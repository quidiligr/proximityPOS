//
//  IODOrder.h
//  iOSDiner
//
//  Created by Romulo Quidilig on 3/19/15.
//  Copyright (c) 2015 Sharecle Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

//#define KEY_SETTINGS_INV_PUBLISHEDNAME @"PublishedName"
//#define KEY_SETTINGS_INV_PUBLISHEDDATE @"PublishedDate"
//#define KEY_SETTINGS_HIST_FILENAME @"inventory_settings.plist"
@class OrderHistory;
//@class ProductCategory;



@interface HistoryModel : NSObject
+ (HistoryModel *)sharedInstance;
//+ (HistoryModel *)publishedInstance;

/*
+(void)loadSettings;
+(NSString *)settingsPath;
+ (void)saveSettings;
+ (NSDictionary *)sharedSettings;
+(void)publish:(NSString *)withName;
*/
@property (nonatomic,strong) NSMutableDictionary* history;

//@property (nonatomic,strong) NSMutableArray* orders;
//@property (nonatomic,strong) NSMutableArray* days; //dates
//@property (nonatomic,strong) NSMutableArray* purchaseDates
@property (nonatomic,strong)NSString* filename; //company name
//@property (nonatomic)BOOL isActive;

/*
- (InventoryItem*)findKeyForOrderItem:(InventoryItem*)searchItem;
- (NSMutableDictionary *)inventoryItems;
- (NSString*)inventoryDescription;
- (void)addItemToInventory:(InventoryItem*)inItem;
- (void)removeItemFromInventory:(InventoryItem*)inItem;
- (float)totalOrder;

-(void)initWithInventory:(NSDictionary *)inventory;
*/
// Loads the list of messages from a file.
- (void)loadHistory;

// Saves the list of messages to a file.
- (void)saveHistory;

// Adds a message that the user composed himself or that we received through
// a push notification. Returns the index of the new message in the list of
// messages.
- (void)addHistory:(NSString *)day withOrder:(OrderHistory*)order;
//- (void)addCategory:(NSString*)withName imageName:(NSString *)imageFile;
/*
// Get and set the user's nickname.
- (NSString*)nickname;
- (void)setNickname:(NSString*)name;

// Get and set the secret code that the user is registered for.
- (NSString*)secretCode;
- (void)setSecretCode:(NSString*)string;

// Determines whether the user has successfully joined a chat.
- (BOOL)joinedChat;
- (void)setJoinedChat:(BOOL)value;
*/
//- (NSMutableDictionary *)toHistoryDictionary;
//- (NSMutableDictionary *)toDateOrdersDictionary;
//- (NSMutableDictionary *)toMenuDictionary;
@end
