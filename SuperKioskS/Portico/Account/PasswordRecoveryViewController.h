//
//  PasswordRecoveryViewController.h
//  Sharecle
//
//  Created by Romulo Quidilig on 4/30/14.
//  Copyright (c) 2014 Sharecle Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PasswordRecoveryDelegate <NSObject>

-(void)didPasswordRecovery;

@end

@interface PasswordRecoveryViewController : UITableViewController
@property (strong, nonatomic) IBOutlet UILabel *userName;
@property (strong, nonatomic) NSString* email;
@property(nonatomic,assign) id<PasswordRecoveryDelegate> delegate;
@end
