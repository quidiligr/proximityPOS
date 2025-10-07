//
//  LoginViewController.h
//  Sharecle
//
//  Created by Romulo on 08/04/14.
//  Copyright (c) 2014 Sharecle Inc. All rights reserved.
//

#import "PasswordRecoveryViewController.h"
#import "RegisterViewController.h"

//@class DataModel;
//@class Message;

// The delegate protocol for the Compose screen
@protocol LoginDelegate;

// The Login screen lets the user register a nickname and chat room
@interface LoginViewController : UITableViewController<PasswordRecoveryDelegate,RegistrationDelegate,UIAlertViewDelegate,CLLocationManagerDelegate>

//@property (nonatomic, assign) DataModel* dataModel;
//@property (nonatomic, strong) AFHTTPClient *client;
@property (nonatomic, assign) id<LoginDelegate> delegate;
@property (nonatomic,strong) CLLocationManager *locationManager;

@end

@protocol LoginDelegate
//- (void)didSaveMessageFromLogin:(Message*)message atIndex:(int)index;
//- (void)didFinishSaveMessageFromLogin;
- (void)didLoginSuccess:(LoginViewController *)login;
//- (void)didPasswordRecovery;

@end