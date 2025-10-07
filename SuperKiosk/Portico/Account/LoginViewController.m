//
//  LoginViewController.m
//  Sharecle
//
//  Created by Romulo on 08/04/14.
//  Copyright (c) 2014 Sharecle Inc. All rights reserved.
//

#import "LoginViewController.h"
//#import "DataModel.h"
//#import "Message.h"
//#import "UserInfo.h"
//#import "BroadcastChannelAPI.h"
//#import "MyBroadcastChannel.h"
//#import "RegisterViewController.h"
#import "PasswordRecoveryViewController.h"
#import "AFNetworking.h"
#import "NSData+MD5.h"
//#import "AppDelegate.h"
#import "MBProgressHUD.h"
#import "RNEncryptor.h"
#import "RNDecryptor.h"
#import "WebViewController.h"
#import "Util.h"

#import "defs.h"

@interface LoginViewController(){
    //DataModel* _dataModel;
    //AFHTTPClient *_client;
    BOOL _clearPasswordField;
    
    int _attempts;
    
}
@property (nonatomic, strong) AppDelegate *appDelegate;
@property (nonatomic,strong) AFHTTPClient *client;
@property (nonatomic, retain) IBOutlet UITextField* nicknameTextField;
@property (nonatomic, retain) IBOutlet UITextField* secretCodeTextField;
@property (weak, nonatomic) IBOutlet UILabel *lblMessage;
@property (weak, nonatomic) IBOutlet UITableViewCell *cellMessage;
@property (strong, nonatomic) IBOutlet UIButton *skipLoginButton;

@end


@implementation LoginViewController{
    //PasswordRecoveryViewController* passwordRecoveryController;
    
}

- (void)viewDidLoad
{
	[super viewDidLoad];
    
    _appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
     _appDelegate.loginController=self;
    
    
    _client = [Util clientSharedInstance];//[AFHTTPClient clientWithBaseURL:[NSURL URLWithString:ServerApiURL]];
    
    _attempts=0;
    //core location
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
        [self.locationManager requestWhenInUseAuthorization];
    
    [self.locationManager startUpdatingLocation];

    
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(postLoginRequest) name:@"Login" object:nil];
}

//- (void)viewWillAppear:(BOOL)animated
//{
//	/*[super viewWillAppear:animated];
//     
//     if (self.nicknameTextField.text.length == 0)
//     [self.nicknameTextField becomeFirstResponder];
//     else
//     [self.secretCodeTextField becomeFirstResponder];
//     */
//}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    //ROM: change this on prod
    //self.nicknameTextField.text =@"rquidilig";//_appDelegate.appConfig.userInfo.username;//sername;
    //self.secretCodeTextField.text =@"t@ught11";//_appDelegate.appConfig.userInfo.password;
    
    self.nicknameTextField.text =_appDelegate.appConfig.userInfo.username;
    self.secretCodeTextField.text =_appDelegate.appConfig.userInfo.password;
    
    _clearPasswordField=NO;
    
    if (self.nicknameTextField.text.length == 0)
        [self.nicknameTextField becomeFirstResponder];
    else
        [self.secretCodeTextField becomeFirstResponder];
    //if(_attempts==0)
    //    [self loginAction];
}


-(void)reset{
    /*_dataModel.selectedBroadcast=nil;
    [_dataModel.broadcastChannels removeAllObjects];
    
    
    _dataModel.selectedContact=nil;
   
    if(_dataModel.broadcastChannels==nil)
        _dataModel.broadcastChannels=[NSMutableArray new];
    else
        [_dataModel.broadcastChannels removeAllObjects];
    
    if(_dataModel.contacts==nil)
        _dataModel.contacts=[NSMutableArray new];
    
    else
        [_dataModel.contacts removeAllObjects];
    
    if(_dataModel.mycontacts==nil)
        _dataModel.mycontacts=[NSMutableArray new];
    
    else
        [_dataModel.mycontacts removeAllObjects];
    
    if(_dataModel.broadcastMessages==nil)
        _dataModel.broadcastMessages=[NSMutableArray new];
    
    else
        [_dataModel.broadcastMessages removeAllObjects];
    
    if(_dataModel.contactMessages==nil)
        _dataModel.contactMessages=[NSMutableArray new];
    
    else
        [_dataModel.contactMessages removeAllObjects];
    
    
    if(_dataModel.unplayedBroadcastMessages==nil)
        _dataModel.unplayedBroadcastMessages=[NSMutableArray new];
    
    else
        [_dataModel.unplayedBroadcastMessages removeAllObjects];
    
    if(_dataModel.unplayedContactMessages==nil)
        _dataModel.unplayedContactMessages=[NSMutableArray new];
    
    [_dataModel.unplayedContactMessages removeAllObjects];
    
    if(_dataModel.myBlockedList==nil)
        _dataModel.myBlockedList=[NSMutableArray new];
    
    else
        [_dataModel.myBlockedList removeAllObjects];
    
    if(_dataModel.searchResults==nil)
        _dataModel.searchResults=[NSMutableArray new];
    
    else
        [_dataModel.searchResults removeAllObjects];
    
    if(_dataModel.myFiles==nil)
        _dataModel.myFiles=[NSMutableArray new];
    
    else
        [_dataModel.myFiles removeAllObjects];
    
    _dataModel.needsUpdateViewBroadcastController=YES;
    _dataModel.needsUpdateViewBChatController=YES;
    _dataModel.needsUpdateViewMessageController=YES;
    _dataModel.needsUpdateViewMessageController=YES;
    
    _dataModel.needsUpdateViewMyDrive=YES;
    _dataModel.needsUpdateViewSearch=YES;
    
    _dataModel.userInfo.fileData=nil;
    */

}
/*
 - (NSManagedObjectContext *)managedObjectContext {
 NSManagedObjectContext *context = nil;
 id delegate = [[UIApplication sharedApplication] delegate];
 if ([delegate performSelector:@selector(managedObjectContext)]) {
 context = [delegate managedObjectContext];
 }
 return context;
 }
 */
/*-(void)displayData{
 self.nicknameTextField.text=[NSString stringWithFormat:@"%@",@"rquidilig@sharecle.com"];
 self.secretCodeTextField.text=@"t@ught11";//_dataModel.userInfo.password;
 
 if([_dataModel.userInfo.loggedIn boolValue]==YES){
 [self dismissViewControllerAnimated:YES completion:nil];
 
 [self.delegate didLoginSuccess];
 }
 
 
 }
 */
#pragma mark -
#pragma mark Actions
/*
 - (void)userDidJoin
 {
 // Close the Login screen
 [self.dataModel setJoinedChat:YES];
 [self dismissViewControllerAnimated:YES completion:nil];
 }
 */

/*
- (void)userDidLogin:(BOOL)needReset
{
    
    
    [_appDelegate showTabBarController];
    
  
 
}
*/

/*
 - (void)postJoinRequest
 {
 MBProgressHUD* hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
 hud.labelText = NSLocalizedString(@"Connecting", nil);
 
 NSDictionary *params = @{@"cmd":@"join",
 @"usertoke":[_dataModel userToken],
 @"token":[_dataModel deviceToken],
 @"name":[_dataModel username],
 @"code":[_dataModel password]};
 
 [_client postPath:@"/api.php"
 parameters:params
 success:^(AFHTTPRequestOperation *operation, id responseObject) {
 
 if ([self isViewLoaded]) {
 [MBProgressHUD hideHUDForView:self.view animated:YES];
 if([operation.response statusCode] != 200) {
 ShowErrorAlert(NSLocalizedString(@"There was an error communicating with the server", nil));
 } else {
 [self userDidJoin];
 }
 }
 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
 if ([self isViewLoaded]) {
 [MBProgressHUD hideHUDForView:self.view animated:YES];
 ShowErrorAlert([error localizedDescription]);
 }
 }];
 }
 */

//TODO:
- (void)postGenerateKeyRequest
{
    /*
    if(_appDelegate.appConfig.device_token==nil)
        _appDelegate.appConfig.device_token=_appDelegate.appConfig.device_uuid;
    if(_appDelegate.appConfig.device_last_location!=nil){
        if (_appDelegate.appConfig.device_lat==0 && _appDelegate.appConfig.device_lng==0 ){
            _appDelegate.appConfig.device_lat=_appDelegate.appConfig.device_last_location.coordinate.latitude;
            _appDelegate.appConfig.device_lat=_appDelegate.appConfig.device_last_location.coordinate.longitude;
        }
        
    }
    */
    NSError *error;
    
    
     NSString *info=[NSString stringWithFormat:@"%@deviceuuid=%@&deviceid=%@&devicetoken=%@"
     ,_appDelegate.appConfig.userInfo.user_key
     ,_appDelegate.appConfig.userInfo.device_uuid
     ,_appDelegate.appConfig.userInfo.deviceID
     ,(_appDelegate.appConfig.userInfo.deviceToken==nil)?@"":_appDelegate.appConfig.userInfo.deviceToken];
     
    
    NSData *data = [info dataUsingEncoding:NSUTF8StringEncoding];
    NSData *encryptedData = [RNEncryptor encryptData:data
                                        withSettings:kRNCryptorAES256Settings
                                            password:A_SECRET_PASSWORD
                                               error:&error];
    NSString *base64Encoded=[encryptedData base64EncodedStringWithOptions:0];//[NSString
    
    
    if(error!=nil){
#ifdef DEBUG
        NSLog(@"encryptData error=%@",[error localizedDescription]);
#endif
        return;
    }
    MBProgressHUD* hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = NSLocalizedString(@"Loading", nil);
    
    
    
    /*NSDictionary *params = @{@"cmd":@"100",
     //@"user_id":[_dataModel userId],
     @"deviceid": _appDelegate.userInfo.deviceID,
     @"username":_nicknameTextField.text,
     @"password":_secretCodeTextField.text//_dataModel.userInfo.password
     };
     */
    NSDictionary *params = @{@"cmd":@"99",
                             //@"user_id":[_dataModel userId],
                             @"p": base64Encoded//_dataModel.userInfo.password
                             };
    
    [_client postPath:ServerApiPath//@"/portico/api"
           parameters:params
              success:^(AFHTTPRequestOperation *operation, id responseObject) {
                  
                  
                  
                  if ([self isViewLoaded]) {
                      [MBProgressHUD hideHUDForView:self.view animated:YES];
                      if([operation.response statusCode] != 200) {
                          [AppDelegate ShowErrorAlert:NSLocalizedString(@"There was an error communicating with the server", nil)];
                      } else {
                          
                          //NSLog(operation.responseString);
                          
                          NSError* error;
                          NSDictionary* json=[NSJSONSerialization JSONObjectWithData:operation.responseData options:kNilOptions error:&error];
                          //NSDictionary* VLDirectory=[json objectForKey:@"VLDirectory"];
                          NSNumber* success=[json objectForKey:@"success"];
                          if([success intValue]==1){
                              //clean-up
                              //[self reset];
                              //NSDictionary *result=[json objectForKey:@"result"];
                              
                              
                              NSString *base64String=[json objectForKey:@"result"];
                              
#ifdef DEBUG
                              NSLog(@"base64String=%@",base64String);
#endif
                              NSData *base64Data=[[NSData alloc] initWithBase64EncodedString:base64String options:0];
                              
                              //NSError *error;
                              NSData *decryptedData = [RNDecryptor decryptData:base64Data
                                                                  withPassword:A_SECRET_PASSWORD
                                                                         error:&error];
                              
                              if(error!=nil){
#ifdef DEBUG
                                  NSLog(@"encryptData error=%@",[error localizedDescription]);
#endif
                                  return;
                              }
                              
                             
                              
                              NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:decryptedData options:NSJSONReadingMutableContainers error:&error];
                              
                              
#ifdef DEBUG
                              NSLog(@"postGenerateKeyRequest: %@",dict);
#endif
                              
                              
                              /*
                              [_appDelegate saveOrUpdateLogonInfoFromWeb:dict];
                              [_appDelegate.mcManager start];
                              [self userDidLogin:YES];
                              */
                          }
                          else{
                              /*NSString* error=DICT_GET(json,@"error");
                              int error_code=DICT_GET_INT(json,@"error_code");
                              
                              if(error_code==301){
                                  
                                  _appDelegate.appConfig.device_id=[[[NSUUID UUID] UUIDString] lowercaseString];
                                  [[NSNotificationCenter defaultCenter] postNotificationName:@"Login" object:nil];
                                  
                              }
                              
                              if(error){
                                  if([error containsString:@"Forgot your password"]){
                                      _lblMessage.text=@"Login failed.";
                                  }
                                  else{
                                      _lblMessage.text=error;
                                  }
                              }
                              else{
                                  _lblMessage.text=@"Login failed.";
                              }
                              
                              [self.tableView reloadData];
                              */
                          }
                          
                          
                          
                          
                      }
                  }
              } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                  if ([self isViewLoaded]) {
                      [MBProgressHUD hideHUDForView:self.view animated:YES];
                      [AppDelegate ShowErrorAlert:[error localizedDescription]];
                  }
              }];
}
- (void)postLoginRequest
{
    //if(_appDelegate.appConfig.device_token==nil)
    //    _appDelegate.appConfig.device_token=@"";//_appDelegate.appConfig.device_uuid;
    
    if(_appDelegate.appConfig.userInfo.device_last_location!=nil){
        if (_appDelegate.appConfig.userInfo.device_lat==0 && _appDelegate.appConfig.userInfo.device_lng==0 ){
            _appDelegate.appConfig.userInfo.device_lat=_appDelegate.appConfig.userInfo.device_last_location.coordinate.latitude;
            _appDelegate.appConfig.userInfo.device_lat=_appDelegate.appConfig.userInfo.device_last_location.coordinate.longitude;
        }
        
    }
    
    
    NSError *error;
    NSString *info=[NSString stringWithFormat:@"username=%@&password=%@&deviceuuid=%@&deviceid=%@&devicetoken=%@&devicename=%@&lat=%@&lng=%@"
                    ,[_nicknameTextField.text stringByReplacingOccurrencesOfString:@"&" withString:@"%26"]
                    ,[_secretCodeTextField.text stringByReplacingOccurrencesOfString:@"&" withString:@"%26"]
                    ,_appDelegate.appConfig.userInfo.device_uuid
                    ,_appDelegate.appConfig.userInfo.deviceID
                    ,(_appDelegate.appConfig.userInfo.deviceToken==nil)?@"":_appDelegate.appConfig.userInfo.deviceToken
                    ,[_appDelegate.appConfig.userInfo.username stringByReplacingOccurrencesOfString:@"&" withString:@"%26"]
                    
                    ,[NSString stringWithFormat:@"%f",_appDelegate.appConfig.userInfo.device_lat]
                    ,[NSString stringWithFormat:@"%f",_appDelegate.appConfig.userInfo.device_lng]];
    

    NSData *data = [info dataUsingEncoding:NSUTF8StringEncoding];
    NSData *encryptedData = [RNEncryptor encryptData:data
                                        withSettings:kRNCryptorAES256Settings
                                            password:A_SECRET_PASSWORD
                                               error:&error];
    NSString *base64Encoded=[encryptedData base64EncodedStringWithOptions:0];//[NSString

    
    if(error!=nil){
#ifdef DEBUG
        NSLog(@"encryptData error=%@",[error localizedDescription]);
#endif
        [AppDelegate toast:[error localizedDescription] duration:2.0];
        return;
    }
	MBProgressHUD* hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
	hud.labelText = NSLocalizedString(@"Loading", nil);
    
   
    
   /*NSDictionary *params = @{@"cmd":@"100",
                             //@"user_id":[_dataModel userId],
                             @"deviceid": _appDelegate.userInfo.deviceID,
                             @"username":_nicknameTextField.text,
                             @"password":_secretCodeTextField.text//_dataModel.userInfo.password
                             };
    */
    NSDictionary *params = @{@"cmd":@"100",
                           //@"user_id":[_dataModel userId],
                           @"p": base64Encoded//_dataModel.userInfo.password
                           };
    
    [_client postPath:ServerApiPath//@"/portico/api"
                     parameters:params
                        success:^(AFHTTPRequestOperation *operation, id responseObject) {
                            
                          
                            
                            if ([self isViewLoaded]) {
                                [MBProgressHUD hideHUDForView:self.view animated:YES];
                                if([operation.response statusCode] != 200) {
                                    [AppDelegate ShowErrorAlert:NSLocalizedString(@"There was an error communicating with the server", nil)];
                                } else {
                                    
                                    //NSLog(operation.responseString);
                                    
                                    NSError* error;
                                    NSDictionary* json=[NSJSONSerialization JSONObjectWithData:operation.responseData options:kNilOptions error:&error];
                                    //NSDictionary* VLDirectory=[json objectForKey:@"VLDirectory"];
                                    NSNumber* success=[json objectForKey:@"success"];
                                    if([success intValue]==1){
                                        _attempts=0;
                                        //clean-up
                                        //[self reset];
                                        //NSDictionary *result=[json objectForKey:@"result"];
                                        
                                       
                                            NSString *base64String=[json objectForKey:@"result"];
                                            
#ifdef DEBUG
                                            NSLog(@"base64String=%@",base64String);
#endif
                                            NSData *base64Data=[[NSData alloc] initWithBase64EncodedString:base64String options:0];
                                            
                                            //NSError *error;
                                            NSData *decryptedData = [RNDecryptor decryptData:base64Data
                                                                                withPassword:A_SECRET_PASSWORD
                                                                                       error:&error];
                                            
                                            if(error!=nil){
#ifdef DEBUG
                                                NSLog(@"encryptData error=%@",[error localizedDescription]);
#endif
                                                return;
                                            }
                                            
                                       //     NSString *stringInfo=[[NSString alloc] initWithData:decryptedData encoding:NSUTF8StringEncoding];
                                        
                                        //NSData *data=[stringInfo dataUsingEncoding:NSUTF8StringEncoding];
                                       // NSError *error;
                                        
                                        NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:decryptedData options:NSJSONReadingMutableContainers error:&error];
                                        
                                      
#ifdef DEBUG
                                            NSLog(@"postLoginRequest: %@",dict);
#endif
                                        
                                        
                                        
                                        
                                        [_appDelegate loggedInSuccessWithInfo:dict];
                                        /*if(!_initiatedByServer){
                                            [_appDelegate showTabBarController];
                                        }
                                        else{
                                            
                                        }
                                        */
                                        //[self.delegate didLoginSuccess:self];
                                        [self.delegate didLoginSuccess:self];
                                        
                                    }
                                    else{
                                        //NSLog(@"Login failed. %@",[json objectForKey:@"error"]);
                                        // rom: cant use bec of html tags: _lblMessage.text=[NSString stringWithFormat:@"Login failed. %@",[json objectForKey:@"error"]];
                                        _attempts++;
                                        NSString* error=DICT_GET(json,@"error");
                                          int error_code=DICT_GET_INT(json,@"error_code");
                                        
                                        if(error_code==301){
                                           
                                              _appDelegate.appConfig.userInfo.deviceID=[[[NSUUID UUID] UUIDString] lowercaseString];
                                            [[NSNotificationCenter defaultCenter] postNotificationName:@"Login" object:nil];
                                            
                                        }
                                            
                                        if(error){
                                            if([error containsString:@"Forgot your password"]){
                                                _lblMessage.text=@"Login failed.";
                                            }
                                            else{
                                                _lblMessage.text=error;
                                            }
                                        }
                                        else{
                                            _lblMessage.text=@"Login failed.";
                                        }
                                        
                                        [self.tableView reloadData];
                                        
                                    }
                                    
                                    
                                    
                                    /* NSString* latestUrl=[VLDirectory objectForKey:@"URL"];
                                     NSLog(@"fetchedDirectory VLDirectory: %@",VLDirectory);
                                     if(latestUrl!=nil)
                                     {
                                     NSString *url=[[NSString alloc] initWithString:latestUrl];
                                     
                                     NSURL *myURL = [NSURL URLWithString:url];
                                     
                                     NSURLRequest *myRequest = [NSURLRequest requestWithURL:myURL];
                                     
                                     
                                     self.bar.topItem.title=latestUrl;
                                     [webView loadRequest:myRequest];
                                     }
                                     //NSArray* latestCallwords=[json objectForKey:@"VLCallwords"];
                                     self.tableData= [json objectForKey:@"VLCallwords"];
                                     if(self.tableData!=nil)
                                     {
                                     self.tableDataLast=[json objectForKey:@"VLCallwords"];
                                     NSLog(@"callwords last: %@",self.tableDataLast);
                                     
                                     }
                                     */
                                    
                                    //[self userDidJoin];
                                }
                            }
                        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                            if ([self isViewLoaded]) {
                                [MBProgressHUD hideHUDForView:self.view animated:YES];
                                [AppDelegate ShowErrorAlert:[error localizedDescription]];
                            }
                        }];
}

/*
- (void)postQueryMyDeviceRequest
{
    if(_appDelegate.appConfig.userInfo.userToken==nil)
    {
        [self postLoginRequest];
        return;
    }
    
    NSError *error;
    NSString *info=[NSString stringWithFormat:@"usertoken=%@&deviceid=%@"
                    ,_appDelegate.appConfig.user_userToken
                    ,_appDelegate.appConfig.device_id
                    
                    ];
    
    
    NSData *data = [info dataUsingEncoding:NSUTF8StringEncoding];
    NSData *encryptedData = [RNEncryptor encryptData:data
                                        withSettings:kRNCryptorAES256Settings
                                            password:A_SECRET_PASSWORD
                                               error:&error];
    NSString *base64Encoded=[encryptedData base64EncodedStringWithOptions:0];//[NSString
    
    
    if(error!=nil){
#ifdef DEBUG
        NSLog(@"encryptData error=%@",[error localizedDescription]);
#endif
        return;
    }
    MBProgressHUD* hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = NSLocalizedString(@"Loading", nil);
    
    
    
   
    NSDictionary *params = @{@"cmd":@"101",
                             //@"user_id":[_dataModel userId],
                             @"p": base64Encoded//_dataModel.userInfo.password
                             };
    
    [_client postPath:ServerApiPath//@"/portico/api"
           parameters:params
              success:^(AFHTTPRequestOperation *operation, id responseObject) {
                  
                  if ([self isViewLoaded]) {
                      [MBProgressHUD hideHUDForView:self.view animated:YES];
                      if([operation.response statusCode] != 200) {
                          [AppDelegate ShowErrorAlert:NSLocalizedString(@"There was an error communicating with the server", nil)];
                      } else {
                          
                          //NSLog(operation.responseString);
                          
                          NSError* error;
                          NSDictionary* json=[NSJSONSerialization JSONObjectWithData:operation.responseData options:kNilOptions error:&error];
                          //NSDictionary* VLDirectory=[json objectForKey:@"VLDirectory"];
                          NSNumber* success=[json objectForKey:@"success"];
                          if([success intValue]==1){
                              //clean-up
                              //[self reset];
                              //NSDictionary *result=[json objectForKey:@"result"];
                              
                              
                              NSString *base64String=[json objectForKey:@"result"];
                              
#ifdef DEBUG
                              NSLog(@"base64String=%@",base64String);
#endif
                              NSData *base64Data=[[NSData alloc] initWithBase64EncodedString:base64String options:0];
                              
                              //NSError *error;
                              NSData *decryptedData = [RNDecryptor decryptData:base64Data
                                                                  withPassword:A_SECRET_PASSWORD
                                                                         error:&error];
                              
                              if(error!=nil){
#ifdef DEBUG
                                  NSLog(@"encryptData error=%@",[error localizedDescription]);
#endif
                                  return;
                              }
                              
                              //     NSString *stringInfo=[[NSString alloc] initWithData:decryptedData encoding:NSUTF8StringEncoding];
                              
                              //NSData *data=[stringInfo dataUsingEncoding:NSUTF8StringEncoding];
                              // NSError *error;
                              
                              NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:decryptedData options:NSJSONReadingMutableContainers error:&error];
                              
                              
                            
                              //[self saveOrUpdateDeviceInfoFromWeb:dict];
                              [_appDelegate saveOrUpdateDeviceInfoFromWeb:[dict objectForKey:@"device"]];
                              
                          }
                          else{
                              
                              
                          }
                          
                          
                          
                          
                      }
                  }
              } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                  if ([self isViewLoaded]) {
                      [MBProgressHUD hideHUDForView:self.view animated:YES];
                      [AppDelegate ShowErrorAlert:[error localizedDescription]];
                  }
              }];
}

*/

/*
 - (NSDate *)deserializeJsonDateString: (NSString *)jsonDateString
 {
 NSInteger offset = [[NSTimeZone defaultTimeZone] secondsFromGMT]; //get number of seconds to add or subtract according to the client default time zone
 
 NSInteger startPosition = [jsonDateString rangeOfString:@"("].location + 1; //start of the date value
 
 NSTimeInterval unixTime = [[jsonDateString substringWithRange:NSMakeRange(startPosition, 13)] doubleValue] / 1000; //WCF will send 13 digit-long value for the time interval since 1970 (millisecond precision) whereas iOS works with 10 digit-long values (second precision), hence the divide by 1000
 
 NSDate* date=[[NSDate dateWithTimeIntervalSince1970:unixTime] dateByAddingTimeInterval:offset];
 
 return date;
 }
 
 -(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
 if ([segue.identifier isEqualToString:@"showRegister"]) {
 //NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
 RegisterViewController *destViewController = segue.destinationViewController;
 
 destViewController.userName.text = self.nicknameTextField.text; //(ContactInfo*)[_dataModel.contacts
 //destViewController.password = self.nicknameTextField.text; //(ContactInfo*)[_dataModel.contacts objectAtIndex:indexPath.row]; //[recipes objectAtIndex:indexPath.row];
 }
 }
 */
/*
 -(void) postSynchRequest{
 //MBProgressHUD* hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
 //hud.labelText = NSLocalizedString(@"Connecting", nil);
 NSNumber* messageId=[NSNumber numberWithLong:0];
 Message *lastMessage=[_dataModel.messages lastObject];
 if(lastMessage!=nil)
 messageId=lastMessage.messageid;
 
 NSDictionary *params = @{@"cmd":@"syncmessaging",
 @"usertoken": _dataModel.userInfo .userToken,
 @"lastmessageid":messageId};
 
 [_dataModel.client postPath:@"/api/index"
 parameters:params
 success:^(AFHTTPRequestOperation *operation, id responseObject) {
 
 if ([self isViewLoaded]) {
 [MBProgressHUD hideHUDForView:self.view animated:YES];
 if([operation.response statusCode] != 200) {
 ShowErrorAlert(NSLocalizedString(@"There was an error communicating with the server", nil));
 } else {
 if(operation.responseString==nil)
 return;
 // NSLog(operation.responseString);
 
 NSError* error;
 NSDictionary* json=[NSJSONSerialization JSONObjectWithData:operation.responseData options:kNilOptions error:&error];
 //NSDictionary* VLDirectory=[json objectForKey:@"VLDirectory"];
 NSNumber* success=[json objectForKey:@"success"];
 if([success intValue]==1){
 //[self userDidLogin];
 //NSLog(@"Login success.");
 NSArray* jsonMessages=[json objectForKey:@"messages"];
 //NSArray* arrayMessages=[json objectForKey:@"messages"];
 NSNumber *lastindex=@0;
 if([jsonMessages count]>0)
 {
 for(id item in jsonMessages){
 //[item objectForKey:<#(id)#>]
 //UINavigationController *navigationController = (UINavigationController*)_window.rootViewController;
 //ChatViewController *chatViewController =
 //(ChatViewController*)[navigationController.viewControllers  objectAtIndex:0];
 
 //DataModel *dataModel = chatViewController.dataModel;
 
 Message* message = [[Message alloc] init];
 
 
 message.createdon = [self deserializeJsonDateString:[item objectForKey:@"createdon"]] ;//[NSDate date];
 
 //NSString* alertValue = [[userInfo valueForKey:@"aps"] valueForKey:@"alert"];
 
 //NSMutableArray* parts = [NSMutableArray arrayWithArray:[alertValue componentsSeparatedByString:@": "]];
 //message.sender = [item objectForKey:@"name"]; //[parts objectAtIndex:0];
 //[parts removeObjectAtIndex:0];
 message.text = [item objectForKey:@"text"]; //[parts componentsJoinedByString:@": "];
 
 //message.createdon = [json objectForKey:@"date"];
 message.messageid = [item objectForKey:@"messageid"];
 lastindex=message.messageid;
 
 message.fileuid = [item objectForKey:@"fileuid"];
 message.senderid = [item objectForKey:@"senderid"];
 message.sender = [item objectForKey:@"sender"];
 message.recipientid = [item objectForKey:@"recipientid"];
 message.recipient = [item objectForKey:@"recipient"];
 
 [_dataModel addMessage:message];
 //int index = _dataModel.messages.count-1;
 
 
 
 
 //if (updateUI)
 //    [chatViewController didSaveMessage:message atIndex:index];
 }
 _dataModel.userInfo.lastmessageid=lastindex;
 //[self lo
 }
 }
 else{
 NSLog(@"Messaging synch failed. %@",[json objectForKey:@"error"]);
 
 }
 
 
 
 
 
 //[self userDidJoin];
 }
 }
 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
 if ([self isViewLoaded]) {
 [MBProgressHUD hideHUDForView:self.view animated:YES];
 ShowErrorAlert([error localizedDescription]);
 }
 }];
 }
 */

- (void)postQueryMyDeviceInfo
{
    
    if(!_appDelegate.appConfig.userInfo.userToken || !_appDelegate.appConfig.userInfo.deviceID)
        return;
    
    
    
    MBProgressHUD* hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = NSLocalizedString(@"Loading device info...", nil);
    
    
    
    NSDictionary *params = @{@"cmd":@"110",
                             @"usertoken":_appDelegate.appConfig.userInfo.userToken,
                             @"deviceid": _appDelegate.appConfig.userInfo.deviceID//_appDelegate.userInfo.deviceID//,
                             // @"devicename":devicename,
                             // @"address":address,
                             // @"categoryid":@0
                             
                             };
    
    [_client postPath:ServerApiPath//@"/portico/api"
           parameters:params
              success:^(AFHTTPRequestOperation *operation, id responseObject) {
                  
                  if ([self isViewLoaded]) {
                      [MBProgressHUD hideHUDForView:self.view animated:YES];
                      if([operation.response statusCode] != 200) {
                          [AppDelegate ShowErrorAlert:NSLocalizedString(@"There was an error communicating with the server", nil)];
                      } else {
                          
                          
                          
                          NSError* error;
                          NSDictionary* json=[NSJSONSerialization JSONObjectWithData:operation.responseData options:kNilOptions error:&error];
                          
                          NSNumber* success=[json objectForKey:@"success"];
                          if([success intValue]==1){
                              
                              /*[self reset];
                               
                               [self saveOrUpdateLogonInfoFromWeb:json];
                               
                               
                               [self userDidLogin:YES];
                               */
                              NSDictionary *jsondevice=[json objectForKey:@"success"];
                              _appDelegate.appConfig.userInfo.device_lat=[DICT_GET(jsondevice, @"lat") floatValue];
                              _appDelegate.appConfig.userInfo.device_lng=[DICT_GET(jsondevice, @"lng") floatValue];
                              _appDelegate.appConfig.userInfo.device_name=DICT_GET(jsondevice, @"name");
                              _appDelegate.appConfig.userInfo.address=DICT_GET(jsondevice, @"address");
                              _appDelegate.appConfig.userInfo.phone=DICT_GET(jsondevice, @"phone");
                              //_appDelegate.appConfig.device_categoryid=[DICT_GET(jsondevice, @"categoryid") intValue];
                              //[self updateDisplay];
                          }
                          else{
                              
                              //_lblMessage.text=@"Login failed.";
                              // [self.tableView reloadData];
                              //[AppDelegate ShowErrorAlert:@"Device registration failed."];
                          }
                          
                          
                          
                          
                      }
                  }
              } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                  if ([self isViewLoaded]) {
                      [MBProgressHUD hideHUDForView:self.view animated:YES];
                      [AppDelegate ShowErrorAlert:[error localizedDescription]];
                  }
              }];
}

- (void)postStartPasswordRecovery:(NSString *)emailAddress//:(NSString *)userName
{
    //if(userName==nil){
    
    /*    self.nicknameTextField.text=[self.nicknameTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        //if(self.nicknameTextField.text.length<MINIMUM_USERNAME_LEN){
        if(self.nicknameTextField.text.length==0){

            self.lblMessage.text=@"Please enter valid Username.";
            return;
        }
        */
       /* if([self.nicknameTextField.text rangeOfString:@"@"].location==NSNotFound){
            
            self.lblMessage.text=@"Invalid email address.";
            return;
        }
        */
//        if(self.nicknameTextField.text.length<6){
//            
//            self.lblMessage.text=@"Invalid Username";
//            return;
//        }
    //}
    //else{
    /*    if(emailAddress.length<MINIMUM_USERNAME_LEN){
            self.lblMessage.text=@"Please enter valid email address.";
            return;
        }
     */
        if([emailAddress rangeOfString:@"@"].location==NSNotFound){
            
            self.lblMessage.text=@"Please enter valid email address.";
            return;
        }
    //}

    
    
    //UINavigationController *navigationController = (UINavigationController*)_window.rootViewController;
    //ChatViewController *chatViewController = (ChatViewController*)[navigationController.viewControllers objectAtIndex:0];
    
    //DataModel *dataModel = [DataModel getInstance]; //chatViewController.dataModel;
    
    //MBProgressHUD* hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    
    MBProgressHUD* hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    hud.labelText = NSLocalizedString(@"Loading", nil);
    
    
    NSError *error;
    //NSString *info=[NSString stringWithFormat:@"emailaddress=%@&deviceuuid=%@&deviceid=%@&devicetoken=%@&devicename=%@&lat=%@&lng=%@"
    NSString *info=[NSString stringWithFormat:@"emailaddress=%@&deviceuuid=%@"
                    ,emailAddress
                    ,_appDelegate.appConfig.userInfo.device_uuid
                    ];
    
    NSData *data = [info dataUsingEncoding:NSUTF8StringEncoding];
    NSData *encryptedData = [RNEncryptor encryptData:data
                                        withSettings:kRNCryptorAES256Settings
                                            password:A_SECRET_PASSWORD
                                               error:&error];
    NSString *base64Encoded=[encryptedData base64EncodedStringWithOptions:0];//[NSString
    
    
    if(error!=nil){
#ifdef DEBUG
        NSLog(@"encryptData error=%@",[error localizedDescription]);
#endif
        return;
    }
    
    
    
    NSDictionary *params = @{@"cmd":@"110",
                             //@"username":(emailAddress==nil)?self.nicknameTextField.text:@""//,
                             @"p":base64Encoded
                             //@"emailaddress":(emailAddress==nil)?@"":emailAddress
                             //@"password":self.password.text,
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
                 [self.tableView reloadData];
             }
             else {
                 
                 if(operation.responseString==nil)
                     return;
                 //NSLog([NSString stringWithFormat:@"responseString %@",operation.responseString]);
                 
                 NSError* error;
                 NSDictionary* json=[NSJSONSerialization JSONObjectWithData:operation.responseData options:kNilOptions error:&error];
                 
                 NSNumber* success=[json objectForKey:@"success"];
                 
                 if([success intValue]==1){
                     /*
                      PasswordRecoveryViewController* passwordRecoveryController = (PasswordRecoveryViewController*) [ApplicationDelegate.storyBoard instantiateViewControllerWithIdentifier:@"PasswordRecoveryViewController"];
                      
                      
                      
                      //NSLog(@"controller.userName.text=%@",self.nicknameTextField.text);
                      
                      passwordRecoveryController.email =self.nicknameTextField.text;
                      //NSLog(@"controller.email=%@",controller.email);
                      passwordRecoveryController.delegate = self;
                      
                      [self presentViewController:passwordRecoveryController animated:YES completion:nil];
                      */
                     [self performSegueWithIdentifier:@"showPasswordRecovery" sender:self];
                     //[self.verificationCode setHidden:NO];
                     
                     //[self.su setHidden:NO];
                 }
                 else{
                     
                     NSString* errorMessage= [json objectForKey:@"error"];
                     if(errorMessage==nil)
                         errorMessage=@"There was an error processing your request. Please try again later. System Admin has been notified.";
                     // NSLog(@"Password recovery failed. %@",errorMessage);
                     //if([errorMessage isEqualToString:@"#1569"] ){
                     //self.lblMessage.text=[NSString stringWithFormat:@"Sorry the email address %@ is not registered. Click register to continue.",self.nicknameTextField.text];//[NSString stringWithFormat:@"Error: %@",errorMessage] ;
                     self.lblMessage.text=[NSString stringWithFormat:@"Error: %@",errorMessage] ;
                     [self.tableView reloadData];
                     
                     //[self performSegueWithIdentifier:@"showUserRegistration" sender:self];
                     
                     
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
             [self.tableView reloadData];
         }
     }];
}


- (IBAction)skipLoginAction:(id)sender {
    if(_appDelegate.appConfig.userInfo==nil)
        _appDelegate.appConfig.userInfo=[UserInfo new];
    
    _appDelegate.appConfig.userInfo.username=@"guest";
    
     [_appDelegate showTabBarController];
}


- (IBAction)loginAction
{
    [self.view endEditing:YES];
    _lblMessage.text=@"";
    
	if (self.nicknameTextField.text.length == 0)
	{
		//ShowErrorAlert(NSLocalizedString(@"Fill in your nickname", nil));
        _lblMessage.text=@"Fill in your username";
        [self.tableView reloadData];
		return;
	}
    
	if (self.secretCodeTextField.text.length == 0)
	{
		//ShowErrorAlert(NSLocalizedString(@"Fill in a secret code", nil));
        _lblMessage.text=@"Fill in your password";
        [self.tableView reloadData];
		return;
	}
    
    
	//_dataModel.userInfo.username=self.nicknameTextField.text;
    
    /*NSData *hash=[self.secretCodeTextField.text dataUsingEncoding:NSUTF8StringEncoding];
    
    NSString *pwdHash=[NSString stringWithFormat:@"%@",[[ hash MD5] uppercaseString] ];
    
	_dataModel.userInfo.password= pwdHash;
    */
	// Hide the keyboard
	[self.nicknameTextField resignFirstResponder];
	[self.secretCodeTextField resignFirstResponder];
    
    _appDelegate.appConfig.userInfo.username=self.nicknameTextField.text;
    _appDelegate.appConfig.userInfo.password=self.secretCodeTextField.text;
    
	//[self postJoinRequest];
    [self postLoginRequest];
}
- (IBAction)passwordRecoveryAction:(id)sender {
   /*
    
    _lblMessage.text=nil;
    
   
    
    [self.tableView reloadData];
    [self postStartPasswordRecovery:nil];
    */
    [self performSegueWithIdentifier:@"showPasswordRecovery" sender:self];
}

- (IBAction)passwordRecoveryWithEmailAction:(id)sender {
    [self.view endEditing:YES];
    UIAlertView * alert =[[UIAlertView alloc ] initWithTitle:@"Recover password by emails"
                                                     message:@"Enter email address"
                                                    delegate:self
                                           cancelButtonTitle:@"Cancel"
                                           otherButtonTitles: nil];
    // [alert addButtonWithTitle:@"Block only"];
    
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    
    [alert addButtonWithTitle:@"Submit"];
    [alert show];
    

}

-(void)didPasswordRecovery{
    /*    [self dismissViewControllerAnimated:NO completion:^{
     [self.delegate didPasswordRecovery];
     }];
     */
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    
    _lblMessage.text=nil;

    if (buttonIndex == 1)
    {
        UITextField *txtEmail = [alertView textFieldAtIndex:0];
        //NSLog(@"username: %@", textfield.text);
        if (txtEmail.text.length>0) {
            [self postStartPasswordRecovery:txtEmail.text];
        }
       
    }
    
}

-(void)didRegisterSuccess{
    //if(passwordRecoveryController!=nil){
    //  [passwordRecoveryController dismissViewControllerAnimated:YES completion:^{[self dismissViewControllerAnimated:YES completion:nil];
    //    [self.delegate didPasswordRecovery];
    //}];
    //}
    //else{
    //    [self dismissViewControllerAnimated:YES completion:nil];
    //  [self.delegate didPasswordRecovery];
    //}
    [self dismissViewControllerAnimated:NO completion:nil];
}
#pragma mark - tableView
/*
 -(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
 if(indexPath.section==0){
 if (indexPath.row==0) {
 return 100;
 }
 else if(indexPath.row==1){
 return 88;
 }
 else if(indexPath.row==2){
 [self.cellMessage layoutIfNeeded];
 return [self.cellMessage.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
 }
 }
 return 0;
 }
 */
#pragma mark - Storyboard
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    _lblMessage.text=nil;
    [self.tableView reloadData];
    
    if([segue.identifier isEqualToString:@"showPasswordRecovery"]){
        PasswordRecoveryViewController *destController=segue.destinationViewController;
        destController.email =self.nicknameTextField.text;
        //NSLog(@"controller.email=%@",controller.email);
        destController.delegate = self;
    }
    else if ([segue.identifier isEqualToString:@"showUserRegistration"]){
        RegisterViewController *destController=segue.destinationViewController;
        destController.email=self.nicknameTextField.text;
        
        /*if (_nicknameTextField.text.length>0) {
         destController.userName.text=_nicknameTextField.text;
         }
         */
        destController.delegate = self;
    }
    
}

#pragma mark LOCATION
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    //self.currentLocation=[locations lastObject];
    //NSLog(@"OldLocation %f %f", oldLocation.coordinate.latitude, oldLocation.coordinate.longitude);
    
    
    _appDelegate.appConfig.userInfo.device_last_location=[locations lastObject];
#if DEBUG
    NSLog(@"NewLocation %f %f", _appDelegate.appConfig.userInfo.device_last_location.coordinate.latitude, _appDelegate.appConfig.userInfo.device_last_location.coordinate.longitude);
#endif
    [manager stopUpdatingLocation];
    
}


#pragma mark WEB USER REGISTER
-(void)showRegisterUser{
    /*if(!_appDelegate.appConfig.user_userToken){
        [self showLogin];
        return;
    }
    */
    if(!_appDelegate.appConfig.userInfo.deviceID)
    {
        [AppDelegate ShowErrorAlert:@"Missing device identifier. Please restart or re-install app"];
        return;
    }
    
    NSError *error;
    
    //NSString *address=@""; //TODO
    //NSString *info=[NSString stringWithFormat:@"usertoken=%@&deviceid=%@&devicename=%@&address=%@",_appDelegate.userInfo.userToken,_appDelegate.userInfo.deviceID,_appDelegate.appConfig.device_name,address];
    NSString *info=[NSString stringWithFormat:@"usertoken=%@&deviceid=%@&devicename=%@",_appDelegate.appConfig.userInfo.userToken,_appDelegate.appConfig.userInfo.deviceID,_appDelegate.appConfig.userInfo.device_name];
    
    
    
    
    NSData *data = [info dataUsingEncoding:NSUTF8StringEncoding];
    NSData *encryptedData = [RNEncryptor encryptData:data
                                        withSettings:kRNCryptorAES256Settings
                                            password:A_SECRET_PASSWORD
                                               error:&error];
    
    if(error!=nil){
#ifdef DEBUG
        NSLog(@"encryptData error=%@",[error localizedDescription]);
#endif
        return;
    }
    
    NSString *base64Encoded=[encryptedData base64EncodedStringWithOptions:0];//[NSString
    
    NSString * encodedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(
                                                                                                     NULL,
                                                                                                     (CFStringRef)base64Encoded,
                                                                                                     NULL,
                                                                                                     (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                                                     kCFStringEncodingUTF8 ));
    
    WebViewController* webController = (WebViewController*) [ApplicationDelegate.storyBoard instantiateViewControllerWithIdentifier:@"WebViewController"];
    webController.url=[NSString stringWithFormat:@"%@/superkiosk/createwithdevice/?id=%@",ServerURL,encodedString];
    
    
    UINavigationController* webNav = [[UINavigationController alloc] initWithRootViewController:webController];
    
    
    
    [self presentViewController:webNav animated:YES completion:nil];
    
   
}
- (IBAction)backButtonTapped:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
