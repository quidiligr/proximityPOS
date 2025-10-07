//
//  IODOrder.h
//  iOSDiner
//
//  Created by Romulo Quidilig on 3/19/15.
//  Copyright (c) 2015 Sharecle Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@class OrderItem;

@interface OrderHistory : NSObject <NSCoding>

//@property (nonatomic,strong) NSMutableDictionary* orderItems;
@property (nonatomic,strong) NSArray* orderItems;
@property (nonatomic,strong) NSArray* orderDiscounts;


@property (nonatomic,strong) NSMutableArray* orderPayments;

@property (nonatomic,strong) NSString* orderHash;
@property (nonatomic,strong) NSNumber* orderNumber;
@property (nonatomic,strong) NSString* orderTableNumber;
@property (nonatomic,strong) NSDate* orderDate;
@property (nonatomic,strong) NSString* orderDay;
@property (nonatomic,strong) NSDate* orderDateTime;
@property (nonatomic,strong) NSString* orderStoreID;
@property (nonatomic,strong) NSString* orderStoreName;
@property (nonatomic) NSInteger orderStoreNum;
@property (nonatomic,strong) NSString* orderStoreLoc;
@property (nonatomic,strong) NSNumber* orderStatus;
@property (nonatomic) BOOL orderIsPaid;
@property (nonatomic) BOOL orderIsRefunded;
@property (nonatomic) BOOL orderIsLive;
@property (nonatomic,strong) NSString* orderBy;
@property (nonatomic,strong) NSString* orderDeviceID;
@property (nonatomic,strong) NSString* orderDeviceToken;
@property (nonatomic,strong) NSNumber* orderSource;
@property (nonatomic,strong) NSString* orderID;
@property (nonatomic,strong) NSString* orderReply;

@property (nonatomic,strong) NSString* deliveryType;
@property (nonatomic,strong) NSString* deliveryCustAddress;
@property (nonatomic,strong) NSString* deliveryCustLat;
@property (nonatomic,strong) NSString* deliveryCustLon;
@property (nonatomic,strong) NSString* deliveryCustPhone;
@property (nonatomic,strong) NSString* deliveryCustName;


//@property (nonatomic,strong) NSString* orderNotes;


@property (nonatomic) NSInteger orderTotalTax;
@property (nonatomic) float orderTax;
@property (nonatomic) NSInteger orderSubtotal;
//@property (nonatomic) NSInteger orderTax;
@property (nonatomic) NSInteger orderTotal;
@property (nonatomic) NSInteger orderTip;

@property (nonatomic) NSInteger orderDiscountPercent;
@property (nonatomic) NSInteger orderDiscountAmount;
@property (nonatomic,strong) NSString* orderDiscountCode;
@property (nonatomic) NSInteger orderAmountDue;
@property (nonatomic) NSInteger orderCashBack;


//TODO: put this as part of orderpayments
@property (nonatomic) NSInteger chargeAmount;
@property (nonatomic,strong) NSString* chargeCurrency;
@property (nonatomic,strong) NSString* chargeToken;
@property (nonatomic,strong) NSString* chargeDescription;
@property (nonatomic,strong) NSString* chargePayType;
//@property (nonatomic,strong) NSString* orderPayCashAmount;
//@property (nonatomic,strong) NSString* chargeChange;
@property (nonatomic,strong) NSNumber* chargeStatus;
@property (nonatomic) BOOL orderSynched;
//cardinfo
//@property (nonatomic,strong) NSDictionary* cardInfo;

@property (nonatomic) BOOL favorite;

- (NSMutableDictionary *)toNSDictionary;
- (NSMutableDictionary *)toJSONDictionary;
- (NSMutableDictionary *)toJSONCancelOrderDictionary;
-(NSString *)toStringLabel;
-(void)reHash;
//-(NSString *)toChargeResponseString;

- (id)initWithDictionary:(NSDictionary *)dictionary;
- (id)initWithJSON:(NSDictionary *)dictionary;

- (NSArray *)orderItemsToJSON;
-(void)completeCharge;
@end
