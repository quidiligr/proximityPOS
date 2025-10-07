//
//  MagTekDemoViewController.h
//  MagTekDemo
//
//  Created by MagTek on 11/27/11.
//  Copyright 2011 MagTek. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MagTekDemoAppDelegate.h"
#import "MediaPlayer/MediaPlayer.h"
#import <MessageUI/MessageUI.h>

@class MTSCRA;

@interface MagTekDemoViewController : UIViewController<UIPickerViewDelegate, UIPickerViewDataSource, MTSCRAEventDelegate>


#pragma mark -
#pragma mark Helper Methods
#pragma mark -

- (void)openDevice;
- (void)closeDevice;
- (void)updateConnStatus;
@end