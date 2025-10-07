//
//  ViewController.h
//  UniPayDemo
//
//  Created by zhong howard on 13-6-25.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
//#import "UniPay.h"
//#import "UniPay_Delegate.h"
//#import "InputAlert.h"

@interface UniPayViewController : UIViewController <MFMailComposeViewControllerDelegate>
{
    
    //UniPay * reader;
    /*
    UITextView *resultsTextView;
    UILabel *connectedLabel;
    UITextField *txtAPDUData;
    UITextField *txtDirectIO;
    UILabel *LabelVersion;
    
    UITextField *_BDKTextField;
    UITextField *_KSNTextField;
    
    InputAlert *userInputAlert;
    
    UIAlertView *prompt_doConnection;
	UIAlertView *prompt_sendLog;
*/
}

//@property(nonatomic, strong) UniPay * reader;
@property(nonatomic, strong) IBOutlet UITextView *resultsTextView;
/*@property(nonatomic, strong) IBOutlet UILabel *connectedLabel;
@property(nonatomic, strong) IBOutlet UITextField *txtAPDUData;
@property(nonatomic, strong) IBOutlet UITextField *txtDirectIO;
@property(nonatomic, strong) IBOutlet UILabel *LabelVersion;
*/
//only for iPhone view
/*
@property (strong, nonatomic) IBOutlet UIScrollView *sView;
@property (strong, nonatomic) IBOutlet UIView *view1;
@property (strong, nonatomic) IBOutlet UIView *view2;
@property (strong, nonatomic) IBOutlet UIView *view3;
@property (strong, nonatomic) IBOutlet UIView *view4;
@property (strong, nonatomic) IBOutlet UIView *view5;
@property (strong, nonatomic) IBOutlet UIPageControl *pcControlPanes;

@property(nonatomic, strong) IBOutlet UITextField *_BDKTextField;
@property(nonatomic, strong) IBOutlet UITextField *_KSNTextField;
@property(nonatomic, strong) UIAlertView *prompt_doConnection;
@property(nonatomic, strong) UIAlertView *prompt_sendLog;
*/
// for all
/*- (IBAction) DoKeyboardOff:(id)sender;
- (IBAction) DoClearLog:(id)sender;

- (IBAction) f_getFirm:(id)sender;

- (IBAction) f_getSerialNumber:(id)sender;
- (IBAction) f_setSerialNumber:(id)sender;
- (IBAction) f_GetModelNumber:(id)sender;
- (IBAction) f_setAudioVolume:(id)sender;


- (IBAction) f_directIO:(id)sender;

- (IBAction) f_smart_GetICC_Status:(id)sender;

- (IBAction) f_smart_GetEncryptionMode:(id)sender;
- (IBAction) f_smart_SetEncryptionMode:(id)sender;
- (IBAction) f_smart_Get_KeyType_DUKPT:(id)sender;
- (IBAction) f_smart_Set_KeyType_DUKPT:(id)sender;

- (IBAction) f_smart_ICC_PowerOn:(id)sender;
- (IBAction) f_smart_ICC_PowerOff:(id)sender;
- (IBAction) f_smart_ExchangeAPDU:(id)sender;
- (IBAction) f_smart_ExchangeAPDU_Encrypted:(id)sender;
- (IBAction) f_smart_GetKSN:(id)sender;
- (IBAction) f_smart_ExchangeAPDU_DUKPT:(id)sender;

- (IBAction) f_msr_EnableMSR:(id)sender;
- (IBAction) f_msr_CancelMSR:(id)sender;
- (IBAction) f_msr_GetEncryptionMode:(id)sender;
- (IBAction) f_msr_SetEncryptionMode:(id)sender;
- (IBAction) f_msr_GetSecurityLevel:(id)sender;
- (IBAction) f_msr_StartMSR_Task:(id)sender;
- (IBAction) f_msr_CancelMSR_Task:(id)sender;

- (IBAction) f_DoTest:(id)sender;
- (IBAction) f_Mail_Wave:(id)sender;

- (IBAction) f_runSomeAPDUs:(id)sender;
- (IBAction) f_runSomeCMDs:(id)sender;
*/
@end
