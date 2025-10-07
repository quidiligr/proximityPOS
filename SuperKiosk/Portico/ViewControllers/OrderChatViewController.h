//
//  FirstViewController.h
//
//
//  Created by Romulo Quidilig.
//  Copyright (c) 2015 Sharecle Inc. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <iAd/iAd.h>
//#import "UsersViewController.h"
#import "GKImagePicker.h"

@interface OrderChatViewController : UIViewController <UITableViewDataSource,UITableViewDelegate,NSStreamDelegate,UIImagePickerControllerDelegate,UITextViewDelegate,UINavigationControllerDelegate,ADBannerViewDelegate,UIActionSheetDelegate,GKImagePickerDelegate,AVSpeechSynthesizerDelegate>
@property (weak, nonatomic) IBOutlet UITextView *txtMessage;


@property (weak, nonatomic) IBOutlet UITableView *tableView;
//@property (strong, nonatomic) IBOutlet UIView *staffsView;

//audio
//@property (retain, nonatomic) IBOutlet UISwitch *audioSwitch;
//@property (retain, nonatomic) IBOutlet UILabel *gainValueLabel;
//@property (retain, nonatomic) AudioProcessor *audioProcessor;
//@property (strong, nonatomic) IBOutlet UIView *customersView;
@property (strong, nonatomic) IBOutlet UIView *composeBar;

@property (weak, nonatomic) IBOutlet UIImageView *wallImage;
//@property (strong, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
//@property (strong, nonatomic) IBOutlet UIBarButtonItem *showSendButton;
//@property (strong, nonatomic) IBOutlet UIView *sendMessageView;

//- (IBAction)sendMessage:(id)sender;
//- (IBAction)cancelMessage:(id)sender;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *broadcastButton;
//@property (strong, nonatomic) IBOutlet UIBarButtonItem *deleteAllButton;
//@property (strong, nonatomic) IBOutlet ADBannerView *banner1;

//@property (strong, nonatomic) IBOutlet UITextField *containerStaffsList;
//@property (strong, nonatomic) InventoryItem *selectedInventory;

@end
