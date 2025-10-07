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


@property (nonatomic,copy) NSString* orderHash;

//@property (nonatomic,strong) NSMutableArray* orderItems;
@property (nonatomic,strong) NSMutableArray* orderItems;
@property (nonatomic,strong) NSMutableArray* orderPayments;
@property (nonatomic,strong) NSMutableArray* orderDiscounts;

//@property (nonatomic,strong) NSString* chargeDescription;
@property (nonatomic,copy) NSNumber* orderNumber;
@property (nonatomic,copy) NSString* orderTableNumber;
@property (nonatomic,copy) NSDate* orderDate;
@property (nonatomic,copy) NSString* orderDay;
@property (nonatomic,copy) NSDate* orderDateTime;
@property (nonatomic,copy) NSString* orderStoreID;
@property (nonatomic) NSInteger orderStoreNum;
@property (nonatomic,copy) NSString *orderStoreName;
//@property (nonatomic,strong) NSString* orderStoreNo;
@property (nonatomic,copy) NSString* orderStoreLoc;
@property (nonatomic,copy) NSNumber* orderStatus;
//@property (nonatomic,strong) NSNumber* cancelStatus;


@property (nonatomic) BOOL orderIsPaid;

@property (nonatomic) NSInteger deleteStatus; //0:not deleted 1:trash 2:deleted

@property (nonatomic) BOOL orderIsClosed;
@property (nonatomic) BOOL orderIsCancelled;
@property (nonatomic) BOOL orderIsLive;

@property (nonatomic) BOOL selected; //this use only for cell selection no need to save

@property (nonatomic) BOOL orderIsRefunded;
@property (nonatomic) BOOL orderIsCaptured;
//@property (nonatomic) BOOL orderIsPickedUp;//or delivered

@property (nonatomic,copy) NSString* orderBy;
@property (nonatomic,copy) NSString* orderUserName;
@property (nonatomic,copy) NSNumber* orderUserID;
@property (nonatomic,copy) NSString* orderDeviceID;
@property (nonatomic,copy) NSString* orderDeviceToken;
@property (nonatomic,copy) NSNumber* orderSource;
@property (nonatomic,copy) NSString* orderID;
@property (nonatomic,copy) NSString* orderReply;

//IMPORTANT! this is for unpaid, we need this so there is only one outstanding unpaid order
//if YES DELETE else add to existing
@property (nonatomic,copy) NSString* orderDeleteUnpaidPending;


@property (nonatomic) NSInteger orderSubtotal;
@property (nonatomic) NSInteger orderTotalTax;
@property (nonatomic) NSInteger orderTotal;
@property (nonatomic) NSInteger orderTip;

@property (nonatomic) double orderTax;

@property (nonatomic) double orderDiscountPercent;
@property (nonatomic) NSInteger orderDiscountAmount;
@property (nonatomic) NSString* orderDiscountCode;
@property (nonatomic) NSInteger orderAmountDue;
@property (nonatomic) NSInteger orderCashBack;



//TODO: put this as part of orderpayments
@property (nonatomic) NSInteger chargeAmount;
@property (nonatomic,copy) NSString* chargeCurrency;
@property (nonatomic,copy) NSString* chargeToken;
@property (nonatomic,copy) NSString* chargeId; //response
//@property (nonatomic,strong) NSString* chargeCard4;
//@property (nonatomic,strong) NSString* chargeEmail;

@property (nonatomic,copy) NSString* chargeDescription;
@property (nonatomic,copy) NSString* chargePayType;
//@property (nonatomic,strong) NSString* orderPayCashAmount;
//@property (nonatomic,strong) NSString* chargeChange;
@property (nonatomic,copy) NSNumber* chargeStatus;

@property (nonatomic,copy) NSString* errorMessage;
//@property BOOL hasError;

- (NSMutableDictionary *)toNSDictionary;
- (NSMutableDictionary *)toJSONDictionary;

-(NSString *)toChargeResponseString;
//-(NSString *)toCancelOrderResponseString;
-(NSString *)toCancelOrderResponseString:(BOOL)success;

-(NSString *)toStringLabel;
-(NSString *)toStringLabelItems;
-(NSString *)toChargeDescription;
-(NSString *)toStringReceipt;

-(void)reHash;

- (id)initWithDictionary:(NSDictionary *)dictionary;
- (id)initWithJSON:(NSDictionary *)dictionary;

-(BOOL)validateOrder;
- (NSNumber*)total;
- (double)total_tax:(double)tax;
- (double)grand_total:(double)tax;

//+(void)returnOrder:(OrderHistory *)order;
//+(NSString *)performPostRefund:(OrderHistory *)order;
//+(NSDictionary *)refund:(OrderHistory *)order;
+(NSString *) statusToString:(NSInteger) status;

@end

