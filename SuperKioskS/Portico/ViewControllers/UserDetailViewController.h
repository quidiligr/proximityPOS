//
//  UserDetailViewController.h
//  superkiosks
//
//  Created by Katherine Sheehy on 8/14/16.
//  Copyright © 2016 Sharecle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

@protocol UserDetailViewControllerDelegate;

@interface UserDetailViewController : UITableViewController
@property (strong, nonatomic) IBOutlet UILabel *userGroupLabel;

@property (strong, nonatomic) IBOutlet UILabel *orderDetailLabel;

@property (strong, nonatomic) IBOutlet UILabel *userDetailLabel;

@property (strong, nonatomic) IBOutlet UIButton *sendMessageButton;

@property (strong, nonatomic) IBOutlet UIButton *blockUnblockButton;

@property (nonatomic,assign) id<UserDetailViewControllerDelegate> delegate;

@property (strong, nonatomic) User* selectedUser;

@end

@protocol UserDetailViewControllerDelegate <NSObject>

-(void)userDetailViewControllerSendTapped:(UserDetailViewController *) controller withUser:(User *)user;
//-(void)usersViewControllerDidSelectUserToBlock:(UsersViewController *) controller withUserInfo:(NSDictionary *)p;

@end


