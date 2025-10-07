//
//  IODOrder.h
//  iOSDiner
//
//  Created by Romulo Quidilig on 3/19/15.
//  Copyright (c) 2015 Sharecle Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "UserInfo.h"


@interface AppConfigModel : NSObject
//+(void)loadSettings;
+(NSString *)settingsPath;
+ (void)saveSettings;
+(void)loadSettings;
+ (AppConfigModel *)sharedInstance;

-(BOOL)isLive;
//user info

//@property(nonatomic,strong) UserInfo *userInfo;
@property (nonatomic, copy) NSString * user_deviceToken;
@property (nonatomic, copy) NSString * user_password;
@property (nonatomic, copy) NSString * user_password_tmp;
@property (nonatomic, copy) NSString * user_password_hash;
@property (nonatomic, copy) NSString * user_pin;
@property (nonatomic, copy) NSString * user_key;

@property (nonatomic) BOOL user_usepin;
@property (nonatomic, copy) NSNumber * user_userid;
@property (nonatomic, copy) NSString * user_username;
@property (nonatomic, copy) NSNumber * user_picid;

@property (nonatomic, copy) NSString * user_firstname;
@property (nonatomic, copy) NSString * user_lastname;

@property (nonatomic, copy) NSString * user_lat;
@property (nonatomic, copy) NSString * user_lng;

@property (nonatomic, copy) NSString * user_address;
@property (nonatomic, copy) NSString * user_city;
@property (nonatomic, copy) NSString * user_state;
@property (nonatomic, copy) NSString * user_country;
@property (nonatomic, copy) NSString * user_zipcode;
@property (nonatomic, copy) NSString * user_homenumber;
@property (nonatomic, copy) NSString * user_mobilenumber;


@property (nonatomic, copy) NSString * user_userToken;
@property (nonatomic, copy) NSString * user_displayName;
@property (nonatomic, copy) NSString * user_homeUrl;
@property (nonatomic, copy) NSString * user_folderid; //superkioaks folder
@property (nonatomic, copy) NSString * user_tableNumber;
@property (nonatomic,copy) UIImage *user_photo;

@property (nonatomic)BOOL requireLogin;
@property (nonatomic)BOOL requirePin;

//device info
@property (nonatomic,copy) NSString *device_name;
@property (nonatomic,copy) NSString *device_pictureFile; //logo
@property (nonatomic,copy) NSString *device_bgPictureFile;
@property NSInteger device_groupid;
@property NSInteger device_menuid;

@property (nonatomic,copy) NSString *device_id;
//@property (nonatomic,copy) NSString *device_store_id;
@property (nonatomic,copy) NSString *storeAddress;

@property (nonatomic) NSUInteger device_num;
@property (nonatomic,copy) NSString *device_uuid;
@property (nonatomic,copy) NSString *device_ssid;
@property (nonatomic,copy) NSString *device_token;
@property NSUInteger device_categoryid;
@property float device_lat;
@property float device_lng;
@property NSInteger device_status;

@property NSInteger bankstatus;
@property(nonatomic,copy) NSString* bankName;
@property(nonatomic,copy) NSString* bankHolder;
@property(nonatomic,copy) NSString* bankAcct;
@property(nonatomic,copy) NSString* bankRouting;

@property (nonatomic,copy) NSString *storeID;
@property (nonatomic,copy) NSString *device_address;
@property (nonatomic,copy) NSString *device_phone;

@property(nonatomic,copy) CLLocation *device_last_location;
@property(nonatomic,copy)NSMutableArray *blockedDevices;
@property(nonatomic,copy)NSMutableArray *blockedUsers;
@property(nonatomic,copy)NSMutableArray *groups;
@property(nonatomic,copy)NSMutableArray *users;
/*
@property  NSUInteger maxUnpaidOrdersPerCustomer;
@property  NSUInteger maxChargeAmount;
@property  NSUInteger minChargeAmount;
 */
/*
@property NSUInteger hoursBeforeDeleteUnpaid;
@property NSInteger refundLevel;
*/
@property  NSUInteger maxUploadSizeKB;
@property  NSUInteger maxMessagesPerUser;
@property  NSUInteger expireMessageInSec;




@property(nonatomic,copy) NSString* acceptedCards;
@property NSUInteger device_max_unclosed_order; //this use to prevent sspam

@property  BOOL enableMultiPay;
@property  NSUInteger visibility;// isVisible;

//@property BOOL isLive;

/*
@property  BOOL isIdynamo;
@property  BOOL isUdynamo;
@property  BOOL isDynamax;
@property  BOOL isCardIO;
@property  BOOL isManualEntry;
*/
@property NSInteger cardReader;

@property NSInteger authType;

@property  BOOL enableChat;
@property  BOOL enableChatSound;
@property  BOOL enableOrderSound;
@property  BOOL enablePhotoSharing;
@property  BOOL enableHttp;

@property  BOOL barcodeAutoClose;
@property  BOOL barcodeAutoAddToCart;


@property NSInteger allowedDaysToSynch;
@property(nonatomic,copy) NSString* paymentProvider;
@property(nonatomic,copy) NSString* paymentPublishableKey;
@property(nonatomic,copy) NSString* paymentSecretKey;
@property(nonatomic,copy) NSString* paymentPostUrl;
@property(nonatomic,copy) NSString* refundPostUrl;

//@property NSString* paymentProvider;
@property(nonatomic,copy) NSString* paymentPublishableKeyTest;
@property(nonatomic,copy) NSString* paymentSecretKeyTest;
@property(nonatomic,copy) NSString* paymentPostUrlTest;




@property(nonatomic) BOOL useClientToken; //this will pass thru all cardinfo to POS
@property(nonatomic) BOOL useApplePay;

@property(nonatomic,copy) NSDictionary *currencies;
//@property int device_min_charge;
//@property int device_max_charge;


//history view status
@property  BOOL showAll;
@property  BOOL showClosed;
@property  BOOL showPaid;
@property  BOOL showUnpaid;
//@property  BOOL showDeleted;
@property  BOOL showCancelled;
@property  BOOL showFailed;
@property  BOOL showRefunds;
@property  BOOL showReady;

@property  NSUInteger showHours;

@property  BOOL needUpdate;


@property (nonatomic,copy) NSString *welcomeMessage;
@property (nonatomic,copy) UIImage *welcomeImage;

@property (nonatomic,copy) NSString *md5Checksum;


-(void)downloadLogoImage;
-(void)downloadBackgroundImage;
-(UIImage *)loadLogoImage;
-(UIImage *)loadBackgroundImage;

@end
