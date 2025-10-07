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
#import "StoreHistory.h"
#import "AppConfigModel.h"
#import "MessagesModel.h"

#import "InventoryItem.h"
#import "ConnectionManager.h"
#import "LoginViewController.h"
#import "ConnectionsViewController.h"


//#import "ConnectionsViewController.h"
//#import "OrderChatViewController.h"
//#import "RWStripeViewController.h"

/*#import "OrderViewController.h"
 #import "CheckoutViewController.h"
 #import "InventoryViewController.h"
 #import "FirstViewController.h"
 #import "SecondViewController.h"
 */
#define ApplicationDelegate ((AppDelegate *)[UIApplication sharedApplication].delegate)
/*
 extern int TAB_INDEX_CONNECT;
 extern int TAB_INDEX_CHAT;
 
 extern int TAB_INDEX_MENU;
 extern int TAB_INDEX_CART;
 
 extern int TAB_INDEX_INVENTORY;
 extern int TAB_INDEX_FILESHARE;
 */
@class ReachabilityManager;
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, readonly) UIStoryboard *storyBoard;

@property(nonatomic,strong) LoginViewController *loginController;
@property(nonatomic,strong) ConnectionsViewController *connController;

@property (nonatomic, strong) MCManager *mcManager;

@property (nonatomic,strong) ConnectionManager *connectionManager;
//@property(nonatomic,strong) UserInfo *userInfo;

//@property(nonatomic,assign) BOOL isServer;

@property(nonatomic,strong) HistoryModel *historyModel;
@property(nonatomic,strong) StoreHistory *selectedStore;
@property (nonatomic, strong) ReachabilityManager *reachabilityManager;

@property(nonatomic) NSUInteger lastOrderNumber;
@property(nonatomic) NSUInteger badgeOrderNumber;
//@property (strong, nonatomic) NSDictionary* inventory;
//@property (strong, nonatomic) InventoryItem* selectedInventory;
/*
@property (assign) int TAB_INDEX_CONNECT;
@property (assign) int TAB_INDEX_CHAT;

@property (assign) int TAB_INDEX_MENU;
@property (assign) int TAB_INDEX_CART;

@property (assign) int TAB_INDEX_INVENTORY;
@property (assign) int TAB_INDEX_FILESHARE;
 */
//@property (strong, nonatomic) NSString* inventory_version;
//@property (strong, nonatomic) NSString* inventory_storeid;

//@property (strong, nonatomic) NSDictionary* sale;

@property(assign)BOOL isAudioON;
@property(assign)BOOL isIpad;
-(BOOL)isConnected;

//@property(nonatomic,strong) NSMutableArray *messages;
//@property(nonatomic,strong) MessagesModel *messagesModel;

@property(nonatomic,strong) NSMutableArray *downloadQue;
//@property(nonatomic,strong) NSMutableArray *bmessages;

@property(nonatomic,strong) AppConfigModel *appConfig;
@property(nonatomic,strong) NSMutableArray *chargeQueue;


//@property(nonatomic,strong) GCDWebUploader* webServer;
+(NSString*)getImagesPath__;
+ (NSString*)getImagesPathForServer:(NSString *)deviceID;
+ (void)clearTmpForServer:(NSString *)deviceID;
+ (void)clearTmpExceptForServer:(NSString *)deviceID;
+ (NSString*)getSharedPath__;
+ (NSString*)getDocumentsPath;
//+(NSDictionary *)charge:(NSString *)stripeAmount stripeCurrency:(NSString *)stripeCurrency stripeToken:(NSString *)stripeToken stripeDescription:(NSString *)stripeDescription;
//+(NSDictionary *)charge:(NSString *)requestString;
//-(void)CreateOrderFromServer:(NSString *)withOrderDetail orderBy:(NSString *)orderBy orderStatus:(NSNumber *) orderStatus;
+(void)ShowErrorAlert:(NSString *)message;
+ (CGRect) maximumUsableFrame:(UIViewController *)viewController;
+(NSString *)toJsonString:(NSDictionary *) dictionary;
+(NSDictionary *)fromJsonString:(NSString *) string;
+(void)toast:(NSString *)message duration:(int)duration;
+(void)alert:(NSString *)message;
+ (CGSize)sizeForText:(NSString*)text;
+(NSString *)currentWifiSSID;
+ (NSString *)cardtype:(STPCardBrand)brand;
//-(void)removeLastMessage:(NSString *)fromDeviceID;
-(void)removeMessagesFromDeviceID:(NSString *)deviceID;



//+ (BOOL)validateCustomerInfo:(STPCard *)stripeCard;
//-(BOOL)isConnectedToStore:(NSString *)storeID;
#pragma mark -Global Cart functions
-(void)clearCart;
-(void)addToCart:(OrderItem *) orderItem product:(Product *)product;
-(void)updateCartBadge:(UITabBarController *) tabBarController;
-(void)loadBgPhoto;

+(NSString *)sizeOfFolder:(NSString *)folderPath;
+(NSString *)sizeOfTmpFolder;//:(NSString *)folderPath;
+(NSString *)sizeOfFile:(NSString *)filePath;
+ (void)clearTmp;
-(void)saveOrUpdateLogonInfoFromWeb:(NSDictionary*) json;
-(void)loggedInSuccessWithInfo:(NSDictionary *)info;
-(void)showTabBarController;


@end
