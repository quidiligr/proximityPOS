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
@class StoreHistory;
@class PeerInfo;

//@class ProductCategory;



@interface HistoryModel: NSObject
+ (HistoryModel *)sharedInstance;

//@property (nonatomic,strong) NSMutableArray* history;
@property (nonatomic,strong) NSMutableDictionary* history;

-(StoreHistory *)storeWithPeerName:(NSString *)peerName;
-(StoreHistory *)storeWithStoreID:(NSString *)storeID;
-(StoreHistory *)storeWithStoreNum:(NSInteger)storeNum;
-(StoreHistory *)storeWithPeer:(PeerInfo *)peer;
// Loads the list of messages from a file.
- (void)loadHistory;

// Saves the list of messages to a file.
- (void)saveHistory;

// Adds a message that the user composed himself or that we received through
// a push notification. Returns the index of the new message in the list of
// messages.
//- (void)addOrUpdateHistory:(NSString *)day withOrder:(OrderHistory*)order;
//- (void)addOrderHistory:(NSString *)day withOrder:(OrderHistory *)order;
//- (void)addStoreHistory:(NSString *)day withOrder:(StoreHistory*)order;
- (void)addOrUpdateStoreHistory:(StoreHistory *)store;
//- (void)addOrUpdateOrderHistory:(OrderHistory *)order;
- (OrderHistory *)addOrUpdateOrderHistory:(OrderHistory *)order;
- (void)updateOrderHistory:(OrderHistory *)order;
- (OrderHistory *)searchPendingOrder:(StoreHistory *)store;
- (OrderHistory *)searchPendingOrderWithStore:(StoreHistory *)store isLive:(BOOL) isLive;
- (NSArray *)searchUnpaidOrdersWithStore:(StoreHistory *)store isLive:(BOOL) isLive;
- (NSArray *)searchPendingOrdersWithStore:(StoreHistory *)store isLive:(BOOL) isLive;
- (NSArray *)searchFailedOrdersWithStore:(StoreHistory *)store isLive:(BOOL) isLive;
-(NSInteger)countAllPending;
- (OrderHistory *)searchOrderWithOrderID:(NSString *)orderID andStoreId:(NSString *)storeId;
- (OrderHistory *)searchOrderWithOrderNum:(NSInteger)orderNum andStoreNum:(NSInteger)storeNum andOrderDateTime:(NSDate *)orderDateTime;

- (OrderHistory *)searchOrderWithOrderId:(NSString *)orderId andStoreNum:(NSNumber *)storeNum andOrderDateTime:(NSDate *)orderDateTime;

- (NSInteger)countReadyOrders;
- (StoreHistory *)createStoreHistoryFromOrder:(OrderHistory *)order;
- (StoreHistory *)createStoreHistoryFromWeb:(NSDictionary *)storeInfo;
-(void)emtpyTrash;
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
