//
//  RegisterViewController.m
//  Sharecle
//
//  Created by Romulo Quidilig on 4/27/14.
//  Copyright (c) 2014 Sharecle Inc. All rights reserved.
//

#import "RegisterViewController.h"
//#import "DataModel.h"
//#import "CompleteRegistrationViewController.h"
#import "RegistrationForm.h"
#import "MBProgressHUD.h"
#import "AFNetworking.h"
#import "defs.h"

@interface RegisterViewController(){
   // DataModel* _dataModel;
    AFHTTPClient *_client;
    //CompleteRegistrationViewController* activateController;
}
@property (weak, nonatomic) IBOutlet UILabel *lblMessage;
@property (nonatomic, strong) AppDelegate *appDelegate;

@end

@implementation RegisterViewController
//@synthesize username;
//@synthesize password;
//@synthesize firstName;
//@synthesize lastName;
//@synthesize emailAddress;
//@synthesize gender;
//@synthesize dobMM;
//@synthesize dobDD;
//@synthesize dobYYYY;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	// Do any additional setup after loading the view.
    //_dataModel=[DataModel getInstance];
     _appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    _client = [AFHTTPClient clientWithBaseURL:[NSURL URLWithString:ServerApiURL]];
    //self.userName.text = self.email;//_dataModel.registerInfo.username;
    //self.firstName.text =_dataModel.registerInfo.firstname;
    //self.lastName.text =_dataModel.registerInfo.lastname;
    
    //self.gender.text =_dataModel.registerInfo.gender;
    //self.dobMM.text =_dataModel.registerInfo.dobmm;
    //self.dobDD.text =_dataModel.registerInfo.dobdd;
    //self.dobYYYY.text =_dataModel.registerInfo.dobyyyy;
    
    self.userName.delegate =self;
    self.emailAddress.delegate=self;
    self.firstName.delegate =self;
    self.lastName.delegate =self;
    /*self.gender.delegate =self;
    self.dobMM.delegate =self;
    self.dobDD.delegate =self;
    self.dobYYYY.delegate =self;*/
    self.password.delegate=self;
    self.confirmPassword.delegate=self;


    /*if (self.firstName.text.length == 0)
		[self.firstName becomeFirstResponder];
    else if(self.lastName.text.length == 0)
        [self.lastName becomeFirstResponder];
    else if(self.userName.text.length == 0)
        [self.userName becomeFirstResponder];
    
    else if(self.password.text.length == 0)
        [self.password becomeFirstResponder];
    */
#ifdef DEBUG
    self.firstName.text=@"Test";
    self.lastName.text=@"Me";
    self.emailAddress.text=@"testme1000@sharecle.com";
    self.userName.text=@"testme1000";
    self.password.text=@"t@ught11";
    self.confirmPassword.text=@"t@ught11";
    
    
#endif
    self.lblTermsOfUse.text=@"By clicking Submit you agree to our Terms of Use and Policy. Please visit our website at www.superkioskapp.com for more details.";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
    //[super touchesBegan:<#touches#> withEvent:<#event#>];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    //[self.view endEditing:YES];
    return YES;
}

- (NSManagedObjectContext *)managedObjectContext {
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}

- (void)postStartRegistration
{
    self.userName.text=[self.userName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if(self.userName.text.length<8){
        self.lblMessage.text=@"The minimum userName length is 8.";
        return;
    }
    
    self.emailAddress.text=[self.emailAddress.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    self.password.text=[self.password.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    self.firstName.text=[self.firstName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    self.lastName.text=[self.lastName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
   // self.kioskName.text=[self.kioskName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    //self.kioskCategory.text=[self.kioskCategory.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    self.companyName.text=[self.companyName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    self.companyAddress.text=[self.companyAddress.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    //self.companyPosition.text=[self.companyPosition.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    //self.gender.text=[self.gender.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if(self.password.text.length<8){
        self.lblMessage.text=@"The minimum password length is 8.";
        return;
    }
    NSString *s_password=self.password.text;
    NSString *s_confirmPAssword=self.confirmPassword.text;
    if(![s_password isEqualToString:s_confirmPAssword]){
        self.lblMessage.text=@"Confirm password does not match.";
        return;
    }
    
    
   /* if([self.userName.text rangeOfString:@"@"].location==NSNotFound){
        
        self.lblMessage.text=@"Invalid email address.";
        return;
    }
    */
    if([self.emailAddress.text rangeOfString:@"@"].location==NSNotFound){
        
        self.lblMessage.text=@"Invalid email address.";
        return;
    }

    
    if(self.emailAddress.text.length<5){
        
        self.lblMessage.text=@"Invalid email address.";
        return;
    }
    /*
    if(self.userName.text.length<6){
        
        self.lblMessage.text=@"Minimum username length is 6.";
        return;
    }
    */
    if(self.firstName.text.length==0 && self.lastName.text.length==0){
        self.lblMessage.text=@"Firstname and lastname are required.";
        return;
    }
    
    
    //UINavigationController *navigationController = (UINavigationController*)_window.rootViewController;
    //ChatViewController *chatViewController = (ChatViewController*)[navigationController.viewControllers objectAtIndex:0];
    
    //DataModel *dataModel = [DataModel getInstance]; //chatViewController.dataModel;
    
    //MBProgressHUD* hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    
    MBProgressHUD* hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    hud.labelText = NSLocalizedString(@"Registering", nil);

    //NSManagedObjectContext *context=[self managedObjectContext];
    
    //NSFetchRequest *fetch=[[NSFetchRequest alloc] initWithEntityName:@"RegistrationForm"];
    //[fetch setPredicate:[NSPredicate predicateWithFormat:<#(NSString *), ...#>]]
    /*
     NSFetchRequest *fetch=[[NSFetchRequest alloc] initWithEntityName:@"RegistrationForm"];
    NSArray *results=[_dataModel.context executeFetchRequest:fetch error:nil];
    if(results==nil || results.count==0){
        _dataModel.registerInfo= [NSEntityDescription insertNewObjectForEntityForName:@"RegistrationForm" inManagedObjectContext:_dataModel.context];
        //newItem.username=nil;
        
        [_dataModel.context save:nil];
       // _dataModel.registerInfo=item;
    }
    else{
        _dataModel.registerInfo=[results firstObject];
    }
    
    _dataModel.registerInfo.username=self.userName.text;
    _dataModel.registerInfo.firstname=self.firstName.text;
    _dataModel.registerInfo.lastname=self.lastName.text;
    */
    _appDelegate.appConfig.user_username=self.userName.text;
    _appDelegate.appConfig.user_firstname=self.firstName.text;
    _appDelegate.appConfig.user_lastname=self.lastName.text;
    //NSError *error;
    //[_dataModel.context save:&error];
    
    
    NSDictionary *params = @{@"cmd":@"startregistration",
                             @"username":self.userName.text ,
                             @"email":self.emailAddress.text ,
                             @"password":self.password.text,
                             @"firstname":self.firstName.text,
                             @"lastname":self.lastName.text
                             //@"kioskName":self.kioskName.text,
                             //@"kioskCategory":self.kioskCategory.text,
                             //@"companyName":self.companyName.text,
                             //@"companyAddress":self.companyAddress.text,
                             //@"companyPhone":self.companyPhone.text,
                             //@"bankAcctNum":self.bankAcctNum.text,
                             //@"bankRouting":self.bankRouting,
                             //@"bankAcctName":self.bankAcctName.text
                             
                            // @"gender":self.gender.text,
                             //@"dob":[NSString stringWithFormat:@"%@/%@/%@",self.dobMM.text,self.dobDD.text,self.dobYYYY.text ]
                             
                             };
    
    //AFHTTPClient *client = [AFHTTPClient clientWithBaseURL:[NSURL URLWithString:ServerApiURL]];
  
    [_client
     postPath:ServerApiPath
     parameters:params
     success:^(AFHTTPRequestOperation *operation, id responseObject) {
         if ([self isViewLoaded]) {
             
             [MBProgressHUD hideHUDForView:self.view animated:YES];

         if([operation.response statusCode] != 200) {
             //ShowErrorAlert(NSLocalizedString(@"There was an error communicating with the server", nil));
             self.lblMessage.text=@"There was an error communicating with the server";
         }
         else {
             
                         if(operation.responseString==nil)
                 return;
             //NSLog([NSString stringWithFormat:@"responseString %@",operation.responseString]);
             
             NSError* error;
             NSDictionary* json=[NSJSONSerialization JSONObjectWithData:operation.responseData options:kNilOptions error:&error];
             
             NSNumber* success=[json objectForKey:@"success"];
            
             if([success intValue]==1){
                 
                 /*CompleteRegistrationViewController* activateController = (CompleteRegistrationViewController*) [ApplicationDelegate.storyBoard instantiateViewControllerWithIdentifier:@"UserActivationViewController"];
                 activateController.userName.text=self.userName.text;
                 
                 activateController.delegate = self;
                 */
                 //[self presentViewController:activateController animated:YES completion:nil];
                 [self performSegueWithIdentifier:@"showCompleteRegistration" sender:self];
                 
             }
             else{
                 //NSLog(@"Registration failed. %@",[json objectForKey:@"message"]);
                 NSString* errorMessage= [json objectForKey:@"error"];
                 //if([errorMessage isEqualToString:@"#1569"] ){
                     //self.lblMessage.text=[NSString stringWithFormat:@"Email address %@ is already registered.",self.userName.text] ;
                 self.lblMessage.text=errorMessage ;
                 //}
                 
             }
             }
         }
         
     }
     failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         if ([self isViewLoaded]) {
             [MBProgressHUD hideHUDForView:self.view animated:YES];
             //ShowErrorAlert([error localizedDescription]);
             self.lblMessage.text=[error localizedDescription];
         }
     }];
}
/*
-(void)didCompleteRegistrationSuccess{
    //[activateController dismissViewControllerAnimated:YES completion:^{[self dismissViewControllerAnimated:YES completion:nil];}];
   // [self dismissViewControllerAnimated:YES completion:^{[self.delegate didRegisterSuccess];}];
    
    //[self dismissViewControllerAnimated:YES completion:nil];
    //[self.navigationController popViewControllerAnimated:YES];
}
*/

- (IBAction)startRegistration:(id)sender {
    [self.view endEditing:YES];
    [self postStartRegistration];
}
/*
- (IBAction)cancelAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
*/
#pragma mark - Storyboard
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"showCompleteRegistration"]) {
        
        
        CompleteRegistrationViewController *destViewController = segue.destinationViewController;
        //destViewController.delegate=self;
        destViewController.userName.text=self.userName.text;
        
    }
}

@end
