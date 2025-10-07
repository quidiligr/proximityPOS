//
//  PasswordChangeViewController.h
//  Sharecle
//
//  Created by Romulo Quidilig on 4/30/14.
//  Copyright (c) 2014 Sharecle Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
/*
@protocol PasswordChangeDelegate <NSObject>

-(void) didPasswordChanged;

@end
*/

@interface PasswordChangeViewController : UITableViewController
@property (weak, nonatomic) IBOutlet UITextField *oldPassword;
@property (weak, nonatomic) IBOutlet UITextField *retypePassword;
@property (weak, nonatomic) IBOutlet UILabel *userName;

@property (weak, nonatomic) IBOutlet UITextField *yourPassword;

@property (weak, nonatomic) IBOutlet UILabel *lblMessage;

//@property(strong,nonatomic) NSString *tempPassword;

//@property(assign,nonatomic) id<PasswordChangeDelegate> delegate;

@end
