//
//  BaseControllerViewController.h
//  superkiosk
//
//  Created by Katherine Sheehy on 3/2/16.
//  Copyright © 2016 Appcoda. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AppDelegate;
@interface BaseViewController : UIViewController<UISplitViewControllerDelegate>
@property (nonatomic, strong) AppDelegate *appDelegatee;
- (IBAction)showMenuAction:(id)sender;
- (IBAction)showConnectionAction:(id)sender;
- (IBAction)showCartAction:(id)sender;
- (IBAction)showUsersAction:(id)sender ;
- (IBAction)showOrderHistoryAction:(id)sender;
- (IBAction)showSettingsAction:(id)sender;

@end
