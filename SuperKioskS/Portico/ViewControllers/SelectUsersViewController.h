//
//  StaffPeersTableViewController.h
//  Order Here
//
//  Created by Katherine Sheehy on 7/3/15.
//  Copyright (c) 2015 Sharecle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"
@protocol SelectUsersViewControllerDelegate;

@interface SelectUsersViewController : UITableViewController
//@property(nonatomic,strong)NSDictionary *selectedPeer;
@property(nonatomic,strong)User *selectedUser;
@property (nonatomic,assign) id<SelectUsersViewControllerDelegate> delegate;

//@property (strong, nonatomic) IBOutlet UISearchBar *searcBar;
@property (strong, nonatomic) IBOutlet UITextField *searchTextField;
@property (strong, nonatomic) NSString *searchText;

@end

@protocol SelectUsersViewControllerDelegate <NSObject>

-(void)selectUsersViewControllerDidSelect:(SelectUsersViewController *) controller withUsers:(NSDictionary *)users;
//-(void)usersViewControllerDidSelectUserToBlock:(UsersViewController *) controller withUserInfo:(NSDictionary *)p;

@end
