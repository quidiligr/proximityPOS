//

//  Created by Romulo Quidilig on 3/19/15.
//  Copyright (c) 2015 Sharecle Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@class OrderHistory;
@class PeerInfo;
@class InventoryItem;
@class CheckoutCart;
@class BroadcastMessageAPI;

@interface StoreHistory : NSObject<NSCoding>



@property (nonatomic,strong) NSMutableArray* orders;
@property (nonatomic,strong) NSMutableArray* messages;
//@property (nonatomic,strong) NSDictionary* inventory_dict;
@property (nonatomic,strong) InventoryItem* inventory;
@property (nonatomic,strong) CheckoutCart* cart;


//@property (nonatomic,strong) NSMutableArray* days;

@property (nonatomic,strong)NSString* storeName;
@property (nonatomic,strong)NSString* deviceID;
@property (nonatomic,strong)NSString* storeID;
@property (nonatomic)NSInteger userID;
@property (nonatomic)NSInteger storeNum;
@property (nonatomic,strong)NSString* inventoryId;

@property (nonatomic) BOOL isLive;
@property (nonatomic)BOOL isActive;
@property (nonatomic)BOOL isConnected;
@property (nonatomic)BOOL isNear;
@property  (nonatomic)BOOL allowPickUp;
@property  (nonatomic)BOOL allowDelivery;


@property (nonatomic)BOOL autoConnect;
//@property (nonatomic)BOOL requireLogin;
//@property (nonatomic)BOOL requirePin;
@property (nonatomic)NSInteger authType;

@property (nonatomic)NSInteger connectionType;


@property float device_lat;
@property float device_lng;
@property(nonatomic,strong)NSString *device_address;
//@property (nonatomic,strong) NSString *device_storeID;
@property(nonatomic,strong)NSString *homeUrl;

@property(nonatomic,strong)NSString *device_ssid;



@property BOOL enableChat;
@property BOOL enablePhotoSharing;
@property  NSUInteger maxUploadSizeKB;
@property  NSUInteger maxMessagesPerUser;
@property  NSUInteger expireMessageInSec;
@property BOOL useClientToken;



@property (nonatomic,strong) PeerInfo *peerInfo;

//specific store config, this overrides the user config(userinfo class)
@property(nonatomic)NSInteger messageLimitPerUser;
@property(assign)BOOL isPlaySound;

//- (NSString *)addDay:(NSString*)day;
//- (void)addOrderHistory:(NSString *)day withOrder:(OrderHistory *)order;


//- (NSMutableDictionary *)toMenuDictionary;
-(NSArray *)allOrdersWithDay:(NSString *)day;

-(NSArray *)days:(BOOL)ascending;

-(OrderHistory *)searchOrder:(NSString *)orderID;


-(void)addNewMessage:(BroadcastMessageAPI *)message;
-(void)addNewMessageFromSpeech:(BroadcastMessageAPI *)message;
@end
