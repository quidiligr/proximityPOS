//
//  BrowserViewController.h
//
//
//  Created by Romulo Quidilig.
//  Copyright (c) 2015 Sharecle Inc. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <MultipeerConnectivity/MultipeerConnectivity.h>

@class PeerInfo;

@protocol MyBrowserViewControllerDelegate;

@interface MyBrowserViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,MCNearbyServiceBrowserDelegate,UIAlertViewDelegate>

@property (nonatomic, assign) id<MyBrowserViewControllerDelegate> delegate;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIButton *btnCancel;
@property (weak, nonatomic) IBOutlet UIButton *btnDone;

@property (nonatomic, strong) PeerInfo *selectedPeer;
@end

@protocol MyBrowserViewControllerDelegate <NSObject>

-(void)browserViewControllerDidFinish:(MyBrowserViewController *)browserViewController;

-(void)browserViewControllerWasCancelled:(MyBrowserViewController *)browserViewController;

-(void)browserViewControllerDidFinishConnected:(MyBrowserViewController *)browserViewController;

@end
