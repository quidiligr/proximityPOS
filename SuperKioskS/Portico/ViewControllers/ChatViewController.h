//
//  FirstViewController.h
//
//
//  Created by Romulo Quidilig.
//  Copyright (c) 2015 Sharecle Inc. All rights reserved.
//


#import <UIKit/UIKit.h>
//#import "MenuViewController.h"
#import "GKImagePicker.h"
#import "SelectUsersViewController.h"

@interface ChatViewController : UIViewController <UITextViewDelegate,UITableViewDataSource,UITableViewDelegate,NSStreamDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate,GKImagePickerDelegate,UIActionSheetDelegate,SelectUsersViewControllerDelegate>

@property (nonatomic, strong) AppDelegate *appDelegate;
@property (nonatomic, strong) UIImagePickerController *pickerPhoto;
@property (strong, nonatomic) IBOutlet UIImageView *attachedPhoto;

@property (strong, nonatomic) IBOutlet UIView *composeBar;
@property (strong, nonatomic) IBOutlet UILabel *toLabel;

@property (weak, nonatomic) IBOutlet UITextView *txtMessage;

@property (strong, nonatomic) IBOutlet UIButton *attachButton;
//@property (strong, nonatomic) IBOutlet UIButton *sendButton;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
//@property (strong, nonatomic) IBOutlet UIView *staffsView;

//audio
//@property (retain, nonatomic) IBOutlet UISwitch *audioSwitch;
//@property (retain, nonatomic) IBOutlet UILabel *gainValueLabel;
//@property (retain, nonatomic) AudioProcessor *audioProcessor;
//@property (strong, nonatomic) IBOutlet UIView *customersView;

@property (weak, nonatomic) IBOutlet UIImageView *wallImage;
//@property (strong, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
//@property (strong, nonatomic) IBOutlet UIBarButtonItem *showSendButton;
//@property (strong, nonatomic) IBOutlet UIView *sendMessageView;

//- (IBAction)sendMessage:(id)sender;
//- (IBAction)cancelMessage:(id)sender;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *broadcastButton;
@property (strong, nonatomic) IBOutlet UIButton *selectUsersButton;

@property (nonatomic, strong) UIPopoverController *popOver;
@property (nonatomic, strong) GKImagePicker *imagePicker;

@end
