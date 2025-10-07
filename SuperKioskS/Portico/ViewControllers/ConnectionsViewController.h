//
//  ConnectionsViewController.h
//
//
//  Created by Romulo Quidilig
//  Copyright (c) 2015 Sharecle Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import <MultipeerConnectivity/MultipeerConnectivity.h>
//#import "MyBrowserViewController.h"
//#import "Stripe.h"
//#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@class AudioProcessor;

@interface ConnectionsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource,UINavigationControllerDelegate,UIAlertViewDelegate>

//@property (weak, nonatomic) IBOutlet UITextField *txtName;
/*
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblStatus;

@property (weak, nonatomic) IBOutlet UISwitch *swLive;
 @property (weak, nonatomic) IBOutlet UIImageView *myPhoto;
*/
 @property (weak, nonatomic) IBOutlet UITableView *tblConnectedDevices;
@property (weak, nonatomic) IBOutlet UIButton *btnDisconnect;
@property (nonatomic, strong) UIPopoverController *popOver;
//@property(strong,nonatomic) CLLocation *currentLocation;
//@property (retain, nonatomic) AudioProcessor *audioProcessor;

//@property (strong, nonatomic) STPCard* stripeCard;

//- (IBAction)browseForDevices:(id)sender;
//- (IBAction)toggleLive:(id)sender;
- (IBAction)disconnect:(id)sender;

//- (void)handleStripeError:(NSError *) error;
//+(NSDictionary *)charge:(NSString *)requestString;
@end
