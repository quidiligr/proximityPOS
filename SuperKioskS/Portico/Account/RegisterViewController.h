//
//  RegisterViewController.h
//  Sharecle
//
//  Created by Romulo Quidilig on 4/27/14.
//  Copyright (c) 2014 Sharecle Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CompleteRegistrationViewController.h"

@protocol RegistrationDelegate <NSObject>

-(void)didRegisterSuccess;

@end

@interface RegisterViewController : UITableViewController<UITextFieldDelegate>
//@property (weak, nonatomic) IBOutlet UITextField *userName;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UITextField *confirmPassword;

@property (weak, nonatomic) IBOutlet UITextField *userName;
//@property (weak, nonatomic) IBOutlet UITextField *dobMM;
//@property (weak, nonatomic) IBOutlet UITextField *dobDD;
//@property (weak, nonatomic) IBOutlet UITextField *mobileNumber;
//@property (weak, nonatomic) IBOutlet UITextField *dobYYYY;
//@property (weak, nonatomic) IBOutlet UITextField *gender;
//@property (weak, nonatomic) IBOutlet UITextField *address;
//@property (weak, nonatomic) IBOutlet UITextField *city;

@property (weak, nonatomic) IBOutlet UITextField *lastName;
@property (weak, nonatomic) IBOutlet UITextField *firstName;

@property (weak, nonatomic) IBOutlet UITextField *emailAddress;

@property (strong, nonatomic) IBOutlet UITextField *companyName;

@property (strong, nonatomic) IBOutlet UITextField *companyAddress;

@property (strong, nonatomic) IBOutlet UITextField *companyPhone;

@property (strong, nonatomic) IBOutlet UITextField *businessCategory;
@property (strong, nonatomic) IBOutlet UILabel *lblTermsOfUse;

/*
@property (strong, nonatomic) IBOutlet UITextField *kioskName;
@property (strong, nonatomic) IBOutlet UITextField *kioskCategory;

@property (strong, nonatomic) IBOutlet UITextField *bankAcctNum;
@property (strong, nonatomic) IBOutlet UITextField *bankRouting;
@property (strong, nonatomic) IBOutlet UITextField *bankAcctName;
*/
- (IBAction)startRegistration:(id)sender;

@property(assign,atomic)id<RegistrationDelegate> delegate;
@property(strong,nonatomic) NSString *email;

@end
