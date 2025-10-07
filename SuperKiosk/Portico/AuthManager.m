//
//  AuthManager.m
//  superkiosk
//
//  Created by Katherine Sheehy on 9/6/16.
//  Copyright © 2016 Appcoda. All rights reserved.
//

#import "AuthManager.h"
#import "StoreHistory.h"
#import "AppDelegate.h"
#import <LocalAuthentication/LocalAuthentication.h>

@implementation AuthManager

+ (AuthManager *)sharedInstance {
    static AuthManager*  _shared;
    
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        _shared = [[AuthManager alloc] init];
        
        
    });
    
    return _shared;
}
/*
-(void)displayAuthIfNeeded:(StoreHistory *)device returnViewController:(NSString *)controller{
    
if(device.authType==0)
    return;
    
    AppDelegate *_appDelegate=ApplicationDelegate;
    
    switch(device.authType){
        case 1:
        {
            if(_appDelegate.appConfig.userInfo.userToken.length>0){
                
                
            }
            else{
                [self showLogin:controller];
            }
        }
            break;
        case 2:
        {
            if(_appDelegate.appConfig.userInfo.userToken==nil || _appDelegate.appConfig.userInfo.userToken.length==0){
                
                [self showLogin:controller];
            }
            else{
                //show finger print
                [self authenicatewithTouchID];
            }
            
        }
            break;
        default:
        {
            [AppDelegate toast:@"Authentication not set." duration:2];
        }
            
    }
}

-(void)showLogin:(NSString *)returnViewController{
    LoginViewController* vc = (LoginViewController*) [ApplicationDelegate.storyBoard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    vc.delegate=self;
    vc.returnViewController=returnViewController;
    UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:vc];
    
    
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)authenicatewithTouchID{
    LAContext *context = [[LAContext alloc] init];
    
    NSError *error = nil;
    if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error]) {
        [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics
                localizedReason:@"Are you the device owner?"
                          reply:^(BOOL success, NSError *error) {
                              
                              if (error) {
                                  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                                  message:@"There was a problem verifying your identity."
                                                                                 delegate:nil
                                                                        cancelButtonTitle:@"Ok"
                                                                        otherButtonTitles:nil];
                                  [alert show];
                                  return;
                              }
                              
                              if (success) {
                                 
                                  if(_appDelegate.selectedStore!=nil)
                                      
                                      [self dismissViewControllerAnimated:YES completion:nil];
                                  
                                  
                              } else {
                                  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                                  message:@"You are not the device owner."
                                                                                 delegate:nil
                                                                        cancelButtonTitle:@"Ok"
                                                                        otherButtonTitles:nil];
                                  [alert show];
                              }
                              
                          }];
        
    } else {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"Your device cannot authenticate using TouchID."
                                                       delegate:nil
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil];
        [alert show];
        
    }
}
*/

@end
