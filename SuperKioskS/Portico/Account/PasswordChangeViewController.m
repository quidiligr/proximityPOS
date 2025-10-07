//
//  PasswordChangeViewController.m
//  Sharecle
//
//  Created by Romulo Quidilig on 4/30/14.
//  Copyright (c) 2014 Sharecle Inc. All rights reserved.
//

#import "PasswordChangeViewController.h"
//#import "DataModel.h"
#import "UserInfo.h"
#import "NSData+MD5.h"
#import "defs.h"
#import "AFNetworking.h"
#import "MBProgressHUD.h"

@interface PasswordChangeViewController (){
//DataModel* _datamodel;
AFHTTPClient *_client;
    NSString *tmpPassword;
   
}
@property (nonatomic, strong) AppDelegate *appDelegate;

@end


@implementation PasswordChangeViewController

//@synthesize oldPassword;
//@synthesize userName;
//@synthesize retypePassword;

//@synthesize newPassword;

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
    //_datamodel=[DataModel getInstance];
    
    _client = [AFHTTPClient clientWithBaseURL:[NSURL URLWithString:ServerApiURL]];
     _appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
	// Do any additional setup after loading the view.
    //self.tempPassword=_datamodel.tmpPassword;
    
    //if(self.tempPassword.length>0){
   /*     self.oldPassword.text=_datamodel.tmpPassword;
    _datamodel.tmpPassword=@"";
   */
    // }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

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


- (void)postPasswordChange
{
    //self.userName.text=[self.userName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    
   /* if([self.userName.text rangeOfString:@"@"].location==NSNotFound){
        
        self.lblMessage.text=@"Invalid email address.";
        return;
    }
    
    if(self.userName.text.length<5){
        
        self.lblMessage.text=@"Invalid email address.";
        return;
    }
    */
    //TODO: not working
    /*
    NSData *hash=[self.oldPassword.text dataUsingEncoding:NSUTF8StringEncoding];
     NSString *pwdHash=[NSString stringWithFormat:@"%@",[[ hash MD5] uppercaseString] ];
	
    
    if(![_datamodel.userInfo.password isEqualToString:pwdHash]){
        self.lblMessage.text=@"Old password is invalid.";
    }
     */
    if(![self.yourPassword.text isEqualToString:self.retypePassword.text]){
        self.lblMessage.text=@"New and confirm password don't match.";
    }
    
    
    //UINavigationController *navigationController = (UINavigationController*)_window.rootViewController;
    //ChatViewController *chatViewController = (ChatViewController*)[navigationController.viewControllers objectAtIndex:0];
    
    //DataModel *dataModel = [DataModel getInstance]; //chatViewController.dataModel;
    
    //MBProgressHUD* hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    
    MBProgressHUD* hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    hud.labelText = NSLocalizedString(@"Connecting.", nil);
    
   /* NSManagedObjectContext *context=[self managedObjectContext];
    
    //NSFetchRequest *fetch=[[NSFetchRequest alloc] initWithEntityName:@"RegistrationForm"];
    //[fetch setPredicate:[NSPredicate predicateWithFormat:<#(NSString *), ...#>]]
    
    
    //_dataModel.registerInfo.username=self.userName.text;
    //_dataModel.registerInfo.firstname=self.firstName.text;
    //_dataModel.registerInfo.lastname=self.lastName.text;
    //_dataModel.registerInfo.gender=self.gender.text;
    //_dataModel.registerInfo.dobdd=self.dobDD.text;
    //_dataModel.registerInfo.dobmm=self.dobMM.text;
    //_dataModel.registerInfo.dobyyyy=self.dobYYYY.text;
    
    NSError *error;
    [context save:&error];
    */
    
    NSDictionary *params = @{@"cmd":@"112",
                             @"username":_appDelegate.appConfig.user_username,//_datamodel.userInfo.username ,
                             @"oldpassword":self.oldPassword.text,
                             @"newpassword":self.yourPassword.text
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
                    // NSManagedObjectContext *context=[self managedObjectContext];
                     
                     //NSString* message= [json objectForKey:@"message"];
                     
                     
                     NSData *hash=[self.yourPassword.text dataUsingEncoding:NSUTF8StringEncoding];
                     NSString *pwdHash=[NSString stringWithFormat:@"%@",[[ hash MD5] uppercaseString] ];
                    
                     //_datamodel.userInfo.password=pwdHash;
                     _appDelegate.appConfig.user_password_hash=pwdHash;
                     //_appDelegate.appConfig.user_username=self.nicknameTextField.text;
                     _appDelegate.appConfig.user_password=self.yourPassword.text;
                     
                     
                     
                     //[context save:nil];
                     
                     //self.lblMessage.text=@"Password changed successfully.";
                     
                     //[self.delegate didPasswordChanged];
                     [self dismissViewControllerAnimated:YES completion:nil];
                     
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

- (IBAction)actionSubmit:(id)sender {
     [self.view endEditing:YES];
    [self postPasswordChange];
    
}
- (IBAction)actionCancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
