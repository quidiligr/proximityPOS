//
//  ConnectionsViewController.h
//
//
//  Created by Romulo Quidilig
//  Copyright (c) 2015 Sharecle Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MultipeerConnectivity/MultipeerConnectivity.h>
//#import <CoreBluetooth/CoreBluetooth.h>
#import "MyBrowserViewController.h"
#import "Stripe.h"
#import "Map2ViewController.h"
#import "LoginViewController.h"
#import <iAd/iAd.h>
@class AudioProcessor;

@interface ConnectionsViewController : UIViewController <UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate,MCNearbyServiceBrowserDelegate,UIAlertViewDelegate,
//CBCentralManagerDelegate,
ADBannerViewDelegate,Map2ViewControllerDelegate,LoginDelegate,UIActionSheetDelegate>

//@property (weak, nonatomic) IBOutlet UITextField *txtName;
@property (weak, nonatomic) IBOutlet UISwitch *swVisible;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *btnDisconnect;
//@property (weak, nonatomic) IBOutlet UIImageView *myPhoto;
//@property (nonatomic, strong) CBCentralManager* bluetoothManager;

@property (retain, nonatomic) AudioProcessor *audioProcessor;

@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *nearbyIndicator;

@property (strong, nonatomic) IBOutlet UIBarButtonItem *locationsButtonItem;
//@property (strong, nonatomic) IBOutlet UIBarButtonItem *settingsButtonItem;
//@property (strong, nonatomic) IBOutlet UIBarButtonItem *loginButtonItem;

- (IBAction)browseForDevices:(id)sender;
- (IBAction)toggleVisibility:(id)sender;
- (IBAction)disconnect:(id)sender;

- (void)handleStripeError:(NSError *) error;
-(void)connectToPeer:(PeerInfo *)peer;
-(void)performConnected:(NSNotification *)notification;
@end
