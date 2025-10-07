//
//  AppDelegate.h
//  
//
//  Created by Romulo Quidilig.
//  Copyright (c) 2015 Sharecle Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MCManager.h"
#import "UserInfo.h"
#import "HistoryModel.h"
#import "OrderHistory.h"
#import "AppConfigModel.h"
#import "LoginViewController.h"
#import "WebViewController.h"
#import "CategoryListViewController.h"
#import "InventoryModel.h"
#import "InventoryItem.h"
#import "ConnectionManager.h"
#import "RNEncryptor.h"
#import "RNDecryptor.h"
#import "UniPayManager.h"
#import "PrintManager.h"
#import "ReachabilityManager.h"
#import "defs.h"

#ifdef MAGTEK
#import "MTSCRA.h"

//#import "MagTekDemoAppDelegate.h"
//#import "MagTekDemoViewController.h"
#import <CoreTelephony/CTCallCenter.h>
#import <CoreTelephony/CTCall.h>
#endif

#define ApplicationDelegate ((AppDelegate *)[UIApplication sharedApplication].delegate)

@class User;

@interface AppDelegate : UIResponder <UIApplicationDelegate,UIAlertViewDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, readonly) UIStoryboard *storyBoard;

@property (nonatomic, strong) MCManager *mcManager;

@property (nonatomic, strong) ConnectionManager *cnnManager;

@property (nonatomic, strong) ReachabilityManager *reachabilityManager;

@property (nonatomic, strong) UniPayManager *uniPayManager;

@property (nonatomic, strong) PrintManager *printManager;

//@property(nonatomic,strong) UserInfo *userInfo;

@property(nonatomic,strong) AppConfigModel *appConfig;

//@property(nonatomic,assign) BOOL isServer;

@property(nonatomic,strong) HistoryModel *historyModel;
@property(nonatomic,strong) InventoryModel *inventoryModel;

//@property(nonatomic) NSUInteger lastOrderNumber;
//@property(nonatomic) NSUInteger badgeOrderNumber;
@property(nonatomic) NSUInteger badgeMessageNumber;
//@property (strong, nonatomic) NSMutableArray* inventory;
@property(assign)BOOL isAudioON;
@property(assign)BOOL isIpad;
@property(nonatomic,strong) NSMutableArray *messages;
@property(nonatomic,strong) NSMutableArray *messages_que;
@property(nonatomic,strong) NSMutableArray *users;
@property(nonatomic,strong) NSMutableArray *groups;
@property (nonatomic,strong)NSString *bgImage;
@property(nonatomic,strong) UITabBarController *tabBarController;
@property(nonatomic,strong) LoginViewController *loginController;


//@property(nonatomic,strong) InventoryItem *currentInventory;


@property(nonatomic,strong) NSString *selectedOrdersDay;

@property(nonatomic) BOOL needToPublish;

@property(nonatomic,strong) User *admin;


//@property(nonatomic,strong) CategoryViewController *categoryController;
//@property(nonatomic,strong) InventoryItem *tmpSelectedInventory;
//@property(nonatomic,strong) InventoryItem *tmpSelectedCategory;

//@property(nonatomic,strong) GCDWebUploader* webServer;
//+(InventoryItem *)activeInventoryItem;
+(NSString *) getImagesPath;
+ (NSString *) getDocumentsPath;
+ (NSString*)getBackupPath;
+ (NSString*)getSharedPath__;
+(NSString *) today;
+(void)ShowErrorAlert:(NSString *)message;

+(UIImage *)loadPhoto:(NSString *)photo;
//-(OrderHistory *)searchOrderWithID:(NSString *)orderID withOrderDay:(NSString *)orderDay withStoreID:(NSString *) orderStoreID isLive:(BOOL)isLive deviceID:(NSString *)deviceID;

-(OrderHistory *)searchOrderWithID:(NSString *)orderID withOrderDay:(NSString *)orderDay withStoreID:(NSString *)storeID withDeviceID:(NSString *)deviceID;

-(NSArray *)searchUnpaidOrderWithDeviceID:(NSString *)deviceID withStoreID:(NSString *) orderStoreID isLive:(BOOL) isLive;
-(void)deleteOrderHistoryItem:(OrderHistory *)item;
-(void)CreateOrderFromServer:(NSString *)withOrderDetail orderBy:(NSString *)orderBy orderStatus:(NSNumber *) orderStatus;
-(void)loggedInSuccessWithInfo:(NSDictionary *)info;
-(void)clearCart;


+(NSString *)currentWifiSSID;
+(NSDictionary *)fromJsonString:(NSString *) string;
+ (NSDate *)deserializeJsonDateString: (NSString *)jsonDateString;
+ (NSString *)contentTypeForImageData:(NSData *)data;
+ (CGSize)sizeForText:(NSString*)text;
//+ (CGSize)sizeForText:(NSString*)text fontSize:(CGFloat )size;
+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize;
+ (UIImage *)scaleImage:(UIImage *)image toSize:(CGSize)newSize;
+(void)toast:(NSString *)message duration:(int)duration;

-(void)showTabBarController;

-(void)showLoginController;
-(void)showRegisterDevice;
-(void)removeLastMessage:(NSString *)fromDeviceID;
-(void)lockDevice;

-(void)saveOrUpdateDeviceInfoFromWeb:(NSDictionary*) jsondevice;
-(void)saveOrUpdateUserInfoFromWeb:(NSDictionary*) jsonuser;
-(void)saveOrUpdateLogonInfoFromWeb:(NSDictionary*) json;

-(void)enableHttp:(BOOL)enabled;

-(NSString *)serverUrl;

-(void)updateBadgeOrders;
//-(void)updateBadgeMessages:(NSInteger)badge;

-(void)setBackgroundImage;
-(void)setBackgroundImageWithData:(NSData *)data;

-(void)removeMessagesFromDevice:(NSString *)fromDeviceID;
-(void)addNewMessage:(BroadcastMessageAPI *)message;
-(void)setMessagesBadge:(BOOL)isReset;

-(void)hideMBProgress;
-(void)showMBProgress:(NSString *)message;

-(void)showRegisteAlert;
-(void)reloadUserGroups;

#ifdef MAGTEK

#pragma mark -
#pragma mark MTSCRA Property
#pragma mark -


@property (nonatomic, strong) MTSCRA *mtSCRALib;

#pragma mark -
#pragma mark UIWindow Property
#pragma mark -

//@property (nonatomic, strong) IBOutlet UIWindow *window;

#pragma mark -
#pragma mark MagTekDemoViewController Property
#pragma mark -

//@property (nonatomic, strong) IBOutlet MagTekDemoViewController *viewController;

#pragma mark -
#pragma mark MTSCRA Library Method
#pragma mark -

- (MTSCRA *)getSCRALib;

#endif
@end
