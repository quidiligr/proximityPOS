//
//  IODOrder.h
//  iOSDiner
//
//  Created by Romulo Quidilig on 3/19/15.
//  Copyright (c) 2015 Sharecle Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserInfo.h"



@interface AppConfigModel : NSObject
//+(void)loadSettings;
+(NSString *)settingsPath;
+ (void)saveSettings;
+(void)loadSettings;
+ (AppConfigModel *)sharedInstance;
//@property (nonatomic,strong) NSString *displayName;
//@property  double minChargeAmount;
//@property  BOOL enableMultiPay;
@property (nonatomic,strong) UserInfo *userInfo;
@property (nonatomic,strong) CCardInfo *testCard;

@property(assign)BOOL isLive;
@property  BOOL barcodeAutoClose;
@property  BOOL barcodeAutoAddToCart;
//@property  BOOL ccard_default;

//@property NSString *pin;

//history view status
/*@property  BOOL showAll;
@property  BOOL showClosed;
@property  BOOL showPaid;
@property  BOOL showUnpaid;
@property  BOOL showCancelled;
@property  BOOL showReady;
*/

@end
