//
//  StaffPeersTableViewController.h
//  Order Here
//
//  Created by Katherine Sheehy on 7/3/15.
//  Copyright (c) 2015 Sharecle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

@protocol SearchUsersViewControllerDelegate;

@interface SearchUsersViewController : UITableViewController<UITextFieldDelegate>
//@property(nonatomic,strong)NSDictionary *selectedPeer;
@property (strong, nonatomic) IBOutlet UITextField *searchTextField;
//@property (strong, nonatomic) NSString *searchText;
@property(nonatomic,strong)User *selectedUser;
@property (nonatomic,assign) id<SearchUsersViewControllerDelegate> delegate;

//@property (strong, nonatomic) IBOutlet UISearchBar *searchBarr;


@end

@protocol SearchUsersViewControllerDelegate <NSObject>

-(void)searchUsersViewControllerDidSelect:(SearchUsersViewController *) controller withUser:(User *)user;
//-(void)usersViewControllerDidSelectUserToBlock:(UsersViewController *) controller withUserInfo:(NSDictionary *)p;

@end
