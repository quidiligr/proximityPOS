//
//  StaffPeersTableViewController.h
//  Order Here
//
//  Created by Katherine Sheehy on 7/3/15.
//  Copyright (c) 2015 Sharecle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchUsersViewController.h"
#import "UserDetailViewController.h"

@protocol UsersViewControllerDelegate;

@interface UsersViewController : UITableViewController<SearchUsersViewControllerDelegate,UserDetailViewControllerDelegate>

@property(nonatomic,strong)NSDictionary *selectedPeer;
@property (strong, nonatomic) User* selectedUser;
@property (nonatomic,assign) id<UsersViewControllerDelegate> delegate;

@property (strong, nonatomic) IBOutlet UITextField *searchTextField;
@property (strong, nonatomic) NSString *searchText;

@end

@protocol UsersViewControllerDelegate <NSObject>

-(void)usersViewControllerDidSelectPeerToSend:(UsersViewController *) controller withPeerInfo:(NSDictionary *)peer;

@end
