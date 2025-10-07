//
//  UserActivationViewController.m
//  Sharecle
//
//  Created by Romulo Quidilig on 4/28/14.
//  Copyright (c) 2014 Sharecle Inc. All rights reserved.
//

#import "CompleteRegistrationViewController.h"
//#import "DataModel.h"
#import "UserInfo.h"
//#import "MessageViewController.h"
#import "Util.h"
#import "RegistrationForm.h"
#import "AFNetworking.h"
#import "MBProgressHUD.h"

#import "defs.h"

@interface CompleteRegistrationViewController (){
    AFHTTPClient *_client;
    //DataModel* _dataModel;
    //NSManagedObjectContext *_context;
    
}
@property (weak, nonatomic) IBOutlet UITextField *activationCode;
@property (weak, nonatomic) IBOutlet UILabel *message;
@property (nonatomic, strong) AppDelegate *appDelegate;
@end

@implementation CompleteRegistrationViewController

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
   // _context=[self managedObjectContext];
   // _dataModel=[DataModel getInstance];
    _appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    self.userName.text=_appDelegate.appConfig.userInfo.username; //_dataModel.registerInfo.username;
    
    _client = [Util clientSharedInstance];//[AFHTTPClient clientWithBaseURL:[NSURL URLWithString:ServerApiURL]];
    
    //if (self.activationCode.text.length == 0)
		[self.activationCode becomeFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSManagedObjectContext *)managedObjectContext {
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
    //[super touchesBegan:<#touches#> withEvent:<#event#>];
}


/*
- (void) showMessageViewController {
    MessageViewController* messageController = (MessageViewController*) [ApplicationDelegate.storyBoard instantiateViewControllerWithIdentifier:@"MessageViewController"];
	//loginController.dataModel = _dataModel;
    //loginController.client = _client;
    //rom added
    //messageController.delegate = self;
    
	[self presentViewController:messageController animated:YES completion:nil];
}
*/

- (void)postCompleteRegistration
{
    //UINavigationController *navigationController = (UINavigationController*)_window.rootViewController;
    //ChatViewController *chatViewController = (ChatViewController*)[navigationController.viewControllers objectAtIndex:0];
    
    //DataModel *dataModel = [DataModel getInstance]; //chatViewController.dataModel;
    
    MBProgressHUD* hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = NSLocalizedString(@"Completing registration...", nil);
    
    NSDictionary *params = @{@"cmd":@"completeregistration",
                             @"devicetoken":_appDelegate.appConfig.userInfo.deviceToken,
                             @"email":self.userName.text ,
                             @"activationcode":self.activationCode.text
                             
                             
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
                 [AppDelegate ShowErrorAlert:@"There was an error communicating with the server"];
                 
             }
             else {
                 //[MBProgressHUD hideHUDForView:self.view animated:YES];
                 if(operation.responseString==nil)
                     return;
                 //NSLog([NSString stringWithFormat:@"responseString %@",operation.responseString]);
                 
                 NSError* error;
                 NSDictionary* json=[NSJSONSerialization JSONObjectWithData:operation.responseData options:kNilOptions error:&error];
                 
                 NSNumber* success=[json objectForKey:@"success"];
                 
                 if([success intValue]==1){
                     
                   
                     
                     NSError* error;
                     NSDictionary* json=[NSJSONSerialization JSONObjectWithData:operation.responseData options:kNilOptions error:&error];
                     
                     NSNumber* success=[json objectForKey:@"success"];
                     if([success intValue]==1){
                         
                         /*
                         _dataModel.userInfo.userToken=[json objectForKey:@"uid"];
                         
                         NSDictionary* jsonuser=[json objectForKey:@"user"];
                         NSNumber* userid=[jsonuser objectForKey:@"userid"];
                         NSString* username=[jsonuser objectForKey:@"username"];
                         
                         _dataModel.userInfo.userid=userid;
                         _dataModel.userInfo.username=username;
                        
                         _dataModel.userInfo.loggedIn=@YES;
                         [_context save:nil];
                         */
                         [_appDelegate saveOrUpdateLogonInfoFromWeb:json];
                         
                         [self.navigationController popToRootViewControllerAnimated:YES];
                         
                         
                     }
                     else{
                         //NSLog(@"Login failed. %@",[json objectForKey:@"error"]);
                         self.message.text=[NSString stringWithFormat:@"%@",[json objectForKey:@"error"]];
                         
                     }

                     
                 }
                 else{
                     //NSLog(@"Completing Registration failed. %@",[json objectForKey:@"message"]);
                     self.message.text=[NSString stringWithFormat:@"%@",[json objectForKey:@"error"]];
                     
                 }
             }
         }
         
     }
     failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         if ([self isViewLoaded]) {
             [MBProgressHUD hideHUDForView:self.view animated:YES];
             //ShowErrorAlert([error localizedDescription]);
             self.message.text=[error localizedDescription];
         }
     }];
}

- (IBAction)activateAction:(id)sender {
    [self.view endEditing:YES];
    [self postCompleteRegistration];
}
- (IBAction)cancelAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
