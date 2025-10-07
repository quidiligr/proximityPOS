//
//  PasswordRecoveryViewController.m
//  Sharecle
//
//  Created by Romulo Quidilig on 4/30/14.
//  Copyright (c) 2014 Sharecle Inc. All rights reserved.
//

#import "PasswordRecoveryViewController.h"
//#import "DataModel.h"
#import "AFNetworking.h"
//#import "NSData+MD5.h"
//#import "AppDelegate.h"
#import "MBProgressHUD.h"
#import "UserInfo.h"
#import "defs.h"
@interface PasswordRecoveryViewController (){
    //DataModel* _datamodel;
    AFHTTPClient *_client;
    
}

@property (weak, nonatomic) IBOutlet UITextField *verificationCode;
@property (weak, nonatomic) IBOutlet UILabel *lblMessage;
@property (nonatomic, strong) AppDelegate *appDelegate;

@end

@implementation PasswordRecoveryViewController

//@synthesize userName;

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
  //  _datamodel=[DataModel getInstance];
     _appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    _client = [AFHTTPClient clientWithBaseURL:[NSURL URLWithString:ServerApiURL]];
    //self.email=_datamodel.recoveryEmail;
    self.lblMessage.text=[NSString stringWithFormat:@"%@, a password recovery verification code was sent to your email.",self.email];
    //[self.verificationCode setHidden:YES];

	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*

#pragma mark -
#pragma mark Core Data

- (NSManagedObjectContext *)managedObjectContext {
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}
*/
- (void)postCompletePasswordRecovery
{
    self.email=[self.email stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    
    /*if([self.email rangeOfString:@"@"].location==NSNotFound){
        
        self.lblMessage.text=@"Invalid username.";
        return;
    }
    */
    if(self.email.length<MINIMUM_USERNAME_LEN){
        
        self.lblMessage.text=@"Invalid username.";
        return;
    }
    
    
    
    
    //UINavigationController *navigationController = (UINavigationController*)_window.rootViewController;
    //ChatViewController *chatViewController = (ChatViewController*)[navigationController.viewControllers objectAtIndex:0];
    
    //DataModel *dataModel = [DataModel getInstance]; //chatViewController.dataModel;
    
    //MBProgressHUD* hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    
    MBProgressHUD* hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    hud.labelText = NSLocalizedString(@"Loading", nil);
    
    //NSManagedObjectContext *context=[self managedObjectContext];
    
    //NSFetchRequest *fetch=[[NSFetchRequest alloc] initWithEntityName:@"RegistrationForm"];
    //[fetch setPredicate:[NSPredicate predicateWithFormat:<#(NSString *), ...#>]]
    
    
    //_dataModel.registerInfo.username=self.userName.text;
    //_dataModel.registerInfo.firstname=self.firstName.text;
    //_dataModel.registerInfo.lastname=self.lastName.text;
    //_dataModel.registerInfo.gender=self.gender.text;
    //_dataModel.registerInfo.dobdd=self.dobDD.text;
    //_dataModel.registerInfo.dobmm=self.dobMM.text;
    //_dataModel.registerInfo.dobyyyy=self.dobYYYY.text;
    
    //NSError *error;
    //[context save:&error];
    
//    if (_datamodel.userInfo.devicetoken==nil)
//	{
//		_datamodel.userInfo.devicetoken=[[[NSUUID UUID] UUIDString] lowercaseString];
//        [_datamodel.context save:nil];
//	}
    NSDictionary *params = @{@"cmd":@"111",
                             @"username":self.email ,
                             @"devicetoken": _appDelegate.appConfig.device_token, //_datamodel.userInfo.devicetoken,
                             @"verificationcode":self.verificationCode.text//,
                             //@"firstname":self.firstName.text,
                             //@"lastname":self.lastName.text,
                             // @"gender":self.gender.text,
                             //@"dob":[NSString stringWithFormat:@"%@/%@/%@",self.dobMM.text,self.dobDD.text,self.dobYYYY.text ]
                             
                             };
    
    //AFHTTPClient *client = [AFHTTPClient clientWithBaseURL:[NSURL URLWithString:ServerApiURL]];
    [_client
     postPath:@"/api/index"
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
                     
                     /*activateController = (PasswordRecoveryViewController*) [ApplicationDelegate.storyBoard instantiateViewControllerWithIdentifier:@"UserActivationViewController"];
                     activateController.userName.text=self.userName.text;
                     
                     activateController.delegate = self;
                     
                     [self presentViewController:activateController animated:YES completion:nil];
                     */
                     //[self.verificationCode setHidden:NO];
                     
                     //[self.su setHidden:NO];
                     //NSManagedObjectContext *context=[self managedObjectContext];
                     
                     NSString* message= [json objectForKey:@"pwd"];
                     
                       [_appDelegate saveOrUpdateLogonInfoFromWeb:json];
                     
                     //_datamodel.userInfo.password=message;
                     //_datamodel.userInfo.loggedIn=@YES;
                     _appDelegate.appConfig.user_password_tmp=message; //_datamodel.tmpPassword=message;
                    // [_datamodel.context save:nil];
                    // NSLog(@"new password=%@",message);
                     //[context save:nil];
                     
                     //self.lblMessage.text=message;
                     //[self dismissViewControllerAnimated:YES completion:^{[self.delegate didPasswordRecovery];}];
                    
                     //[self dismissViewControllerAnimated:YES completion:nil];
                     [self.navigationController popViewControllerAnimated:YES];
                     
                     
                 }
                 else{
                     //NSLog(@"Registration failed. %@",[json objectForKey:@"message"]);
                     NSString* errorMessage= [json objectForKey:@"error"];
                     //if([errorMessage isEqualToString:@"#1569"] ){
                         self.lblMessage.text=[NSString stringWithFormat:@"Error: %@",errorMessage] ;
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

- (IBAction)submitAction:(id)sender {
     [self.view endEditing:YES];
    [self postCompletePasswordRecovery];
}
/*
- (IBAction)cancelAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
*/
@end
