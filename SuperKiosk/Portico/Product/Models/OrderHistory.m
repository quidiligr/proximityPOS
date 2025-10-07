//
//  IODOrder.m
//  iOSDiner
//
//  Created by Romulo Quidilig on 3/19/15.
//  Copyright (c) 2015 Sharecle Inc. All rights reserved.
//

#import "OrderHistory.h"
#import "OrderItem.h"
#import "DiscountItem.h"
#import "AppDelegate.h"
#import "defs.h"
#import "BroadcastMessageAPI.h"
#import "NSData+Conversion.h"
#import "OrderOptionItem.h"
#import "Util.h"
#import "defs_order_product.h"
/*
static NSString* const OrderItemsKey = @"orderItems";
static NSString* const OrderPaymentsKey = @"orderPayments";
static NSString* const OrderDetailTextKey = @"orderDetailText";
static NSString* const OrderNumberKey = @"OrderNumber";
static NSString* const OrderDateKey = @"OrderDate";
static NSString* const OrderDayKey = @"OrderDay";
static NSString* const OrderDateTimeKey = @"OrderDateTime";
static NSString* const OrderStoreIDKey = @"OrderStoreID";
static NSString* const OrderStoreLocKey = @"OrderStoreLoc";
static NSString* const OrderStatusKey = @"OrderStatus";
static NSString* const OrderByKey = @"OrderBy";
static NSString* const OrderIDKey = @"OrderID";
static NSString* const OrderReplyKey = @"OrderReply";
static NSString* const OrderAmountDueKey = @"OrderAmountDue";


static NSString* const OrderChargeAmountKey = @"OrderChargeAmount";
static NSString* const OrderChargeCurrencyKey = @"OrderChargeCurrency";
static NSString* const OrderChargeTokenKey = @"OrderChargeToken";
static NSString* const OrderChargeDescriptionKey = @"OrderChargeDescription";

static NSString* const OrderPayTypeKey = @"OrderPayType";
static NSString* const OrderPayCashAmountKey = @"OrderPayCashAmount";
static NSString* const OrderPayCashChangeKey = @"OrderPayCashChange";
static NSString* const OrderPayStatusKey = @"OrderPayStatus";

static NSString* const OrderDiscountPercentKey = @"OrderDiscountPercent";
static NSString* const OrderDiscountAmountKey = @"OrderDiscountAmount";
static NSString* const OrderDiscountCodeKey = @"OrderDiscountCode";

static NSString* const OrderSourceKey = @"OrderSource";
static NSString* const OrderDeviceIDKey = @"OrderDeviceID";
static NSString* const OrderDeviceTokenKey = @"OrderDeviceToken";
*/
@implementation OrderHistory


- (id)initWithCoder:(NSCoder*)decoder
{
    
    if ((self = [super init]))
    {
        
        self.orderItems= [decoder decodeObjectForKey:OrderItemsKey];
        self.orderPayments= [decoder decodeObjectForKey:OrderPaymentsKey];
        
        //self.orderDetailText = [decoder decodeObjectForKey:OrderDetailTextKey];
        self.orderNumber =  [decoder decodeObjectForKey:OrderNumberKey];
        self.orderDate = [decoder decodeObjectForKey:OrderDateKey];
        self.orderDay = [decoder decodeObjectForKey:OrderDayKey];
        self.orderDateTime = [decoder decodeObjectForKey:OrderDateTimeKey];
        self.orderStoreID=[decoder decodeObjectForKey:OrderStoreIDKey];
        self.orderStoreNum=[decoder decodeIntegerForKey:OrderStoreNumKey];
        self.orderStoreName=[decoder decodeObjectForKey:OrderStoreNameKey];
        
        self.orderStoreLoc=[decoder decodeObjectForKey:OrderStoreLocKey];
        self.orderStatus=[decoder decodeObjectForKey:OrderStatusKey];
        self.orderIsLive=[decoder decodeBoolForKey:OrderIsLiveKey];
        self.orderIsPaid=[decoder decodeBoolForKey:OrderIsPaidKey];
        self.orderBy=[decoder decodeObjectForKey:OrderByKey];
        self.orderID=[decoder decodeObjectForKey:OrderIDKey];
        self.orderReply=[decoder decodeObjectForKey:OrderReplyKey];
        self.orderSource=[decoder decodeObjectForKey:OrderSourceKey];
        self.orderDeviceID=[decoder decodeObjectForKey:OrderDeviceIDKey];
        self.orderDeviceToken=[decoder decodeObjectForKey:OrderDeviceTokenKey];
        self.orderAmountDue=[decoder decodeIntegerForKey:OrderAmountDueKey];
        
        self.orderTax=[decoder decodeDoubleForKey:OrderTaxRateKey];
        
        self.chargeAmount=[decoder decodeIntegerForKey:OrderChargeAmountKey];
        self.chargeCurrency=[decoder decodeObjectForKey:OrderChargeCurrencyKey];
        self.chargeToken=[decoder decodeObjectForKey:OrderChargeTokenKey];
        self.chargeDescription=[decoder decodeObjectForKey:OrderChargeDescriptionKey];
        self.chargePayType=[decoder decodeObjectForKey:OrderPayTypeKey];
        //self.cardInfo=[decoder decodeObjectForKey:OrderCardInfoKey];
        //self.chargeAmount=[decoder decodeObjectForKey:OrderPayCashAmountKey];
        //self.orderPayCashChange=[decoder decodeObjectForKey:OrderPayCashChangeKey];
        self.chargeStatus=[decoder decodeObjectForKey:OrderPayStatusKey];
        self.orderDiscountPercent=[decoder decodeIntegerForKey:OrderDiscountPercentKey];
        self.orderDiscountAmount=[decoder decodeIntegerForKey:OrderDiscountAmountKey];
        self.orderDiscountCode=[decoder decodeObjectForKey:OrderDiscountCodeKey];
        self.favorite=[decoder decodeBoolForKey:OrderFavoriteKey];
        self.orderSynched=[decoder decodeBoolForKey:OrderSynchedKey];

        
        //self.orderNotes=[decoder decodeObjectForKey:OrderNotesKey];
        
        //ensure correct values
        NSInteger total=0;
        NSInteger subtotal=0;
        NSInteger totaltax=0;
        
        
        if(self.orderItems!=nil && [self.orderItems count]>0){
            for (OrderItem *oi in self.orderItems) {
                subtotal=subtotal+oi.price;
                
                
                
            }
            
            self.orderSubtotal=subtotal;
            
            totaltax=subtotal*(self.orderTax/100);
            self.orderTotalTax=totaltax;
            
            
            
            total=subtotal+totaltax;
            self.orderTotal=total;
            
            
            
            
        }
        NSInteger amountpaid=0;
        NSInteger amount=0;
        NSInteger amountdue=total;
        NSInteger cashback=0;
        
        NSString *payType;
        if(self.orderPayments!=nil && [self.orderPayments count]>0){
            for (NSDictionary *pitem in self.orderPayments) {
                
                payType=[pitem valueForKey:KEY_PAYMENT_TYPE];
                amount=[[pitem valueForKey:KEY_AMOUNT] integerValue];
                amountpaid=amountpaid+amount;
                
            }
            
            
        }
        
        if(amountpaid>amountdue){
            cashback=amountpaid-amountdue;
            amountdue=0;
            
            
        }
        else{
            amountdue=amountdue-amountpaid;
            
        }
        
        if(amountdue>0){
            //self.orderStatus=@ORDER_STATUS_UNPAID;
            self.orderIsPaid=NO;
        }
        else{
            //self.orderStatus=@ORDER_STATUS_PAID;
            self.orderIsPaid=YES;
        }
        
        self.orderAmountDue=amountdue;
        self.orderCashBack=cashback;
        
        self.orderCashBack=[decoder decodeIntegerForKey:OrderPayCashChangeKey];
        self.orderIsPaid=[decoder decodeBoolForKey:OrderIsPaidKey];
        self.orderIsRefunded=[decoder decodeBoolForKey:OrderIsRefundedKey];

        self.orderHash= [decoder decodeObjectForKey:orderHashKey];
        
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder*)encoder
{
    [encoder encodeObject:self.orderItems forKey:OrderItemsKey];
    [encoder encodeObject:self.orderPayments forKey:OrderPaymentsKey];
    
    //[encoder encodeObject:self.orderDetailText forKey:OrderDetailTextKey];
    [encoder encodeObject:self.orderNumber forKey:OrderNumberKey];
    [encoder encodeObject:self.orderDate forKey:OrderDateKey];
    [encoder encodeObject:self.orderDateTime forKey:OrderDateTimeKey];
    [encoder encodeObject:self.orderDay forKey:OrderDayKey];
    
    [encoder encodeObject:self.orderStoreID forKey:OrderStoreIDKey];
    [encoder encodeInteger:self.orderStoreNum forKey:OrderStoreNumKey];
    [encoder encodeObject:self.orderStoreName forKey:OrderStoreNameKey];
    [encoder encodeObject:self.orderStoreLoc forKey:OrderStoreLocKey];
    
    [encoder encodeObject:self.orderStatus forKey:OrderStatusKey];
    [encoder encodeBool:self.orderIsLive forKey:OrderIsLiveKey];
    [encoder encodeBool:self.orderIsPaid forKey:OrderIsPaidKey];
     [encoder encodeBool:self.orderIsRefunded forKey:OrderIsRefundedKey];
    [encoder encodeObject:self.orderBy forKey:OrderByKey];
    [encoder encodeObject:self.orderID forKey:OrderIDKey];
    [encoder encodeObject:self.orderReply forKey:OrderReplyKey];
    [encoder encodeObject:self.orderSource forKey:OrderSourceKey];
    [encoder encodeObject:self.orderDeviceID forKey:OrderDeviceIDKey];
    [encoder encodeObject:self.orderDeviceToken forKey:OrderDeviceTokenKey];
    [encoder encodeInteger:self.orderAmountDue forKey:OrderAmountDueKey];
    
    [encoder encodeDouble:self.orderTax forKey:OrderTaxRateKey];
    [encoder encodeInteger:self.chargeAmount forKey:OrderChargeAmountKey];
    [encoder encodeObject:self.chargeCurrency forKey:OrderChargeCurrencyKey];
    [encoder encodeObject:self.chargeToken forKey:OrderChargeTokenKey];
    [encoder encodeObject:self.chargeDescription forKey:OrderChargeDescriptionKey];
    
    [encoder encodeObject:self.chargePayType forKey:OrderPayTypeKey];
    // [encoder encodeObject:self.cardInfo forKey:OrderCardInfoKey];
    //[encoder encodeObject:self.orderPayCashAmount forKey:OrderPayCashAmountKey];
    //[encoder encodeObject:self.orderPayCashChange forKey:OrderPayCashChangeKey];
    [encoder encodeObject:self.chargeStatus forKey:OrderPayStatusKey];
    [encoder encodeInteger:self.orderDiscountPercent forKey:OrderDiscountPercentKey];
    [encoder encodeInteger:self.orderDiscountAmount forKey:OrderDiscountAmountKey];
    [encoder encodeObject:self.orderDiscountCode forKey:OrderDiscountCodeKey];
    [encoder encodeBool:self.favorite forKey:OrderFavoriteKey];
    [encoder encodeBool:self.favorite forKey:OrderSynchedKey];
    
    [encoder encodeObject:self.orderHash forKey:orderHashKey];
    
}

- (id)initWithDictionary:(NSDictionary *)dictionary{
    if ((self = [super init]))
    {
        
        
      
        self.orderNumber = [dictionary valueForKey:OrderNumberKey];
        
        self.orderDate = [dictionary valueForKey:OrderDateKey];
        
        self.orderDateTime = [dictionary valueForKey:OrderDateTimeKey];
        
        self.orderDay = [dictionary valueForKey:OrderDayKey];
        self.orderStatus =  [dictionary  valueForKey:OrderStatusKey] ;
        self.orderIsLive =  [[dictionary  valueForKey:OrderIsLiveKey] boolValue] ;
        self.orderIsRefunded =  [[dictionary  valueForKey:OrderIsRefundedKey] boolValue];
        
        self.orderStoreID = [dictionary valueForKey:OrderStoreIDKey];
        self.orderStoreNum = [[dictionary valueForKey:OrderStoreNumKey] integerValue];
        self.orderStoreName = [dictionary valueForKey:OrderStoreNameKey] ;
        self.orderStoreLoc=[dictionary valueForKey:OrderStoreLocKey] ;
        
        self.orderBy=[dictionary valueForKey:OrderByKey] ;
        self.orderID=[dictionary valueForKey:OrderIDKey] ;
        self.orderReply=[dictionary valueForKey:OrderReplyKey] ;
        self.orderSource=[dictionary valueForKey:OrderSourceKey];
        self.orderDeviceID=[dictionary valueForKey:OrderDeviceIDKey];
        self.orderDeviceToken=[dictionary valueForKey:OrderDeviceTokenKey];
        self.orderAmountDue=[[dictionary valueForKey:OrderAmountDueKey] integerValue] ;
        
        self.chargeAmount=[[dictionary valueForKey:OrderChargeAmountKey] integerValue] ;
        self.chargeCurrency=[dictionary valueForKey:OrderChargeCurrencyKey] ;
        self.chargeToken=[dictionary valueForKey:OrderChargeTokenKey] ;
        self.chargeDescription=[dictionary valueForKey:OrderChargeDescriptionKey] ;
        
        
        self.chargePayType=[dictionary valueForKey:OrderPayTypeKey];
        
        self.chargeStatus=[dictionary valueForKey:OrderPayStatusKey];
        self.orderDiscountPercent=[[dictionary valueForKey:OrderDiscountPercentKey] integerValue];
        self.orderDiscountAmount=[[dictionary valueForKey:OrderDiscountAmountKey] integerValue];
        self.orderDiscountCode=[dictionary valueForKey:OrderDiscountCodeKey];
        self.favorite=[[dictionary valueForKey:OrderFavoriteKey] boolValue];
        
        self.orderHash = [dictionary valueForKey:orderHashKey];
    }
    return self;
    
    
}

- (id)initWithJSON:(NSDictionary *)dictionary{
    if ((self = [super init]))
    {
        
        
      //  self.orderDetailText=[dictionary valueForKey:OrderDetailTextKey];
        
        self.orderNumber = [dictionary valueForKey:OrderNumberKey];
        
        
        NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss zzz"];
        
        
        
        
        self.orderDate =[dateFormatter dateFromString:[dictionary valueForKey:OrderDateKey]];
        
        
        
        self.orderDateTime =[dateFormatter dateFromString:[dictionary valueForKey:OrderDateTimeKey]];
        
        
        self.orderDay = [dictionary valueForKey:OrderDayKey];
        self.orderStatus =  [dictionary  valueForKey:OrderStatusKey] ;
        self.orderIsLive =  [[dictionary  valueForKey:OrderIsLiveKey] boolValue] ;
        self.orderIsRefunded =  [[dictionary  valueForKey:OrderIsRefundedKey] boolValue] ;
        self.orderStoreID = [dictionary valueForKey:OrderStoreIDKey];
        self.orderStoreNum = [[dictionary valueForKey:OrderStoreNumKey] integerValue];
        self.orderStoreName = [dictionary valueForKey:OrderStoreNameKey];
        
        self.orderStoreLoc=[dictionary valueForKey:OrderStoreLocKey] ;
        self.orderBy=[dictionary valueForKey:OrderByKey] ;
        self.orderID=[dictionary valueForKey:OrderIDKey] ;
        self.orderReply=[dictionary valueForKey:OrderReplyKey] ;
        self.orderSource=[dictionary valueForKey:OrderSourceKey];
        self.orderDeviceID=[dictionary valueForKey:OrderDeviceIDKey];
        self.orderDeviceToken=[dictionary valueForKey:OrderDeviceTokenKey];
        self.orderAmountDue=[[dictionary valueForKey:OrderAmountDueKey] integerValue] ;
        self.orderTax=[[dictionary valueForKey:OrderTaxKey] floatValue] ;
        
        self.chargeAmount=[[dictionary valueForKey:OrderChargeAmountKey] integerValue] ;
        self.chargeCurrency=[dictionary valueForKey:OrderChargeCurrencyKey] ;
        self.chargeToken=[dictionary valueForKey:OrderChargeTokenKey] ;
        self.chargeDescription=[dictionary valueForKey:OrderChargeDescriptionKey] ;
        //self.cardInfo=[dictionary valueForKey:OrderCardInfoKey] ;
        
        NSMutableArray *items=[NSMutableArray new];
        NSArray *json_items=[dictionary valueForKey:OrderItemsKey];
        
        if([json_items count]>0){
            for(NSDictionary *json_item in json_items){
                OrderItem *item=[[OrderItem alloc] init];
                item.productID=[[json_item valueForKey:ProductIDKey] integerValue];
                item.name=[json_item valueForKey:NameKey] ;
                item.price=[[json_item valueForKey:PriceKey] integerValue];
                item.quantity=[[json_item valueForKey:QuantityKey] integerValue];
                
                NSArray *arr_options=[json_item valueForKey:optionsKey];
                if(arr_options!=nil && [arr_options count]>0){
                    item.options=[NSMutableArray new];
                    for(NSDictionary *dict_option in arr_options ){
                        OrderOptionItem *ooi= [[OrderOptionItem alloc] initWithDictionary:dict_option] ;
                        [item.options addObject:ooi];
                    
                    }
                }
                item.notes=[json_item valueForKey:NotesKey] ;
                [items addObject:item];
            }
            
        }
        self.orderItems=items;
        
        NSMutableArray *payments=[NSMutableArray new];
        NSArray *json_payments=[dictionary valueForKey:OrderPaymentsKey];
        
        if([json_payments count]>0){
            for(NSDictionary *json_item in json_payments){
                //NSDictionary *item=[[OrderItem alloc] init];
                //item.productID=[[json_item valueForKey:ProductIDKey] intValue];
                //item.name=[json_item valueForKey:NameKey] ;
                //item.price=[[json_item valueForKey:ProductIDKey] floatValue];
                //item.quantity=[[json_item valueForKey:ProductIDKey] intValue];
                [payments addObject:json_item];
            }
            
        }
        self.orderPayments=payments;
        
        self.chargePayType=[dictionary valueForKey:OrderPayTypeKey];
        //self.orderPayCashAmount=[dictionary valueForKey:OrderPayCashAmountKey];
        // self.orderPayCashChange=[dictionary valueForKey:OrderPayCashChangeKey];
        self.chargeStatus=[dictionary valueForKey:OrderPayStatusKey];
        self.orderDiscountPercent=[[dictionary valueForKey:OrderDiscountPercentKey] integerValue];
        self.orderDiscountAmount=[[dictionary valueForKey:OrderDiscountAmountKey] integerValue];
        self.orderDiscountCode=[dictionary valueForKey:OrderDiscountCodeKey];
        self.favorite=[[dictionary valueForKey:OrderDiscountCodeKey] boolValue];
        
        self.orderHash =[dictionary valueForKey:orderHashKey];
        
    }
    return self;
    
    
}


/*- (id)initFromJSONDictionary:(NSDictionary *)dictionary{
 if ((self = [super init]))
 {
 
 
 self.orderDetailText=[dictionary valueForKey:OrderDetailTextKey];
 self.orderNumber = [dictionary valueForKey:OrderNumberKey];
 self.orderDate = [dictionary valueForKey:OrderDateKey];
 self.orderDateTime = [dictionary valueForKey:OrderDateTimeKey];
 self.orderDay = [dictionary valueForKey:OrderDayKey];
 self.orderStatus =  [dictionary  valueForKey:OrderStatusKey] ;
 self.orderStoreID = [dictionary valueForKey:OrderStoreIDKey];
 self.orderStoreLoc=[dictionary valueForKey:OrderStoreLocKey] ;
 self.orderBy=[dictionary valueForKey:OrderByKey] ;
 self.orderID=[dictionary valueForKey:OrderIDKey] ;
 self.orderReply=[dictionary valueForKey:OrderReplyKey] ;
 self.orderSource=[dictionary valueForKey:OrderSourceKey];
 self.orderAmountDue=[dictionary valueForKey:OrderAmountDueKey] ;
 
 self.orderChargeAmount=[dictionary valueForKey:OrderChargeAmountKey] ;
 self.orderChargeCurrency=[dictionary valueForKey:OrderChargeCurrencyKey] ;
 self.orderChargeToken=[dictionary valueForKey:OrderChargeTokenKey] ;
 self.orderChargeDescription=[dictionary valueForKey:OrderChargeDescriptionKey] ;
 
 
 self.orderPayType=[dictionary valueForKey:OrderPayTypeKey];
 self.orderPayCashAmount=[dictionary valueForKey:OrderPayCashAmountKey];
 self.orderPayCashChange=[dictionary valueForKey:OrderPayCashChangeKey];
 self.orderPayStatus=[dictionary valueForKey:OrderPayStatusKey];
 self.orderDiscountPercent=[dictionary valueForKey:OrderDiscountPercentKey];
 self.orderDiscountAmount=[dictionary valueForKey:OrderDiscountAmountKey];
 self.orderDiscountCode=[dictionary valueForKey:OrderDiscountCodeKey];
 }
 return self;
 
 
 }
 */


- (NSMutableDictionary *)toNSDictionary{
    NSMutableDictionary *dictionary=[NSMutableDictionary new];
    
    //[dictionary setValue:self.orderDetailText forKey:OrderDetailTextKey];
    [dictionary setValue:self.orderNumber forKey:OrderNumberKey];
    [dictionary setValue:self.orderDate forKey:OrderDateKey];
    [dictionary setValue:self.orderDateTime forKey:OrderDateTimeKey];
    [dictionary setValue:self.orderDay forKey:OrderDayKey];
    
    [dictionary setValue:self.orderStoreID forKey:OrderStoreIDKey];
    [dictionary setValue:@(self.orderStoreNum) forKey:OrderStoreNumKey];
    [dictionary setValue:self.orderStoreName forKey:OrderStoreNameKey];
    [dictionary setValue:self.orderStoreLoc forKey:OrderStoreLocKey];
    
    [dictionary setValue:self.orderStatus forKey:OrderStatusKey];
    [dictionary setValue:@(self.orderIsLive) forKey:OrderIsLiveKey];
    [dictionary setValue:@(self.orderIsPaid) forKey:OrderIsPaidKey];
    [dictionary setValue:@(self.orderIsRefunded) forKey:OrderIsRefundedKey];
    [dictionary setValue:self.orderBy forKey:OrderByKey];
    [dictionary setValue:self.orderID forKey:OrderIDKey];
    [dictionary setValue:self.orderReply forKey:OrderReplyKey];
    [dictionary setValue:self.orderSource forKey:OrderSourceKey];
    [dictionary setValue:self.orderDeviceID forKey:OrderDeviceIDKey];
    [dictionary setValue:self.orderDeviceToken forKey:OrderDeviceTokenKey];
    [dictionary setValue:[NSNumber numberWithInteger:self.orderAmountDue] forKey:OrderAmountDueKey];
    
    [dictionary setValue:[NSNumber numberWithInteger:self.chargeAmount] forKey:OrderChargeAmountKey];
    [dictionary setValue:self.chargeCurrency forKey:OrderChargeCurrencyKey];
    [dictionary setValue:self.chargeToken forKey:OrderChargeTokenKey];
    [dictionary setValue:self.chargeDescription forKey:OrderChargeDescriptionKey];
    
    [dictionary setValue:self.chargePayType forKey:OrderPayTypeKey];
    //[dictionary setValue:self.cardInfo forKey:OrderCardInfoKey];
    //[dictionary setValue:self.orderPayCashAmount forKey:OrderPayCashAmountKey];
    //[dictionary setValue:self.orderPayCashChange forKey:OrderPayCashChangeKey];
    [dictionary setValue:self.chargeStatus forKey:OrderPayStatusKey];
    [dictionary setValue:[NSNumber numberWithInteger:self.orderDiscountPercent] forKey:OrderDiscountPercentKey];
    [dictionary setValue:[NSNumber numberWithInteger:self.orderDiscountAmount] forKey:OrderDiscountAmountKey];
    [dictionary setValue:self.orderDiscountCode forKey:OrderDiscountCodeKey];
    [dictionary setValue:@(self.favorite) forKey:OrderFavoriteKey];
   // [dictionary setValue:self.orderNotes forKey:OrderNotesKey];
    
    [dictionary setValue:self.orderHash forKey:orderHashKey];
    return dictionary;
    
    
}



- (NSMutableDictionary *)toJSONCancelOrderDictionary{
    NSMutableDictionary *dictionary=[NSMutableDictionary new];
   // [dictionary setValue:self.orderNumber forKey:OrderNumberKey];
   // [dictionary setValue:@(self.orderIsLive) forKey:OrderIsLiveKey];
    [dictionary setValue:self.orderID forKey:OrderIDKey];
    [dictionary setValue:self.orderDeviceID forKey:OrderDeviceIDKey];
    [dictionary setValue:self.orderStoreID forKey:OrderStoreIDKey];
    [dictionary setValue:self.orderDay forKey:OrderDayKey];
   
    return dictionary;
}
- (NSMutableDictionary *)toJSONDictionaryWithHash{
    NSMutableDictionary *dictionary=[self toJSONDictionary];
    if(!self.orderHash){
        NSData *data=[NSKeyedArchiver archivedDataWithRootObject:dictionary];
        
        self.orderHash=[data MD5];
    }
    [dictionary setValue:self.orderHash forKey:OrderDateKey];
    return dictionary;
}

- (NSMutableDictionary *)toJSONDictionary{
    NSMutableDictionary *dictionary=[NSMutableDictionary new];
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss zzz"];
    
    //NSString *today=[dateFormatter stringFromDate:[NSDate date]];
    NSString *strDate=[dateFormatter stringFromDate:self.orderDate];
    NSString *strDateTime=[dateFormatter stringFromDate:self.orderDateTime];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
   // [dictionary setValue:self.orderDetailText forKey:OrderDetailTextKey];
    
   
    
    [dictionary setValue:[self orderItemsToJSON] forKey:OrderItemsKey];
    [dictionary setValue:@(self.orderTip) forKey:OrderTipKey];
    
    [dictionary setValue:self.orderPayments forKey:OrderPaymentsKey];
    [dictionary setValue:@(self.orderIsLive) forKey:OrderIsLiveKey];
    [dictionary setValue:@(self.orderIsRefunded) forKey:OrderIsRefundedKey];
    [dictionary setValue:@(self.orderIsPaid) forKey:OrderIsPaidKey];
  
    
    [dictionary setValue:self.orderNumber forKey:OrderNumberKey];
    [dictionary setValue:strDate  forKey:OrderDateKey];
    [dictionary setValue:strDateTime forKey:OrderDateTimeKey];
    [dictionary setValue:self.orderDay forKey:OrderDayKey];
    
    [dictionary setValue:self.orderStoreID forKey:OrderStoreIDKey];
    [dictionary setValue:@(self.orderStoreNum) forKey:OrderStoreNumKey];
    [dictionary setValue:self.orderStoreName forKey:OrderStoreNameKey];
    [dictionary setValue:self.orderStoreLoc forKey:OrderStoreLocKey];
    
    [dictionary setValue:self.orderStatus forKey:OrderStatusKey];
    [dictionary setValue:self.orderBy forKey:OrderByKey];
    [dictionary setValue:self.orderID forKey:OrderIDKey];
    [dictionary setValue:self.orderReply forKey:OrderReplyKey];
    [dictionary setValue:self.orderSource forKey:OrderSourceKey];
    
    if(self.orderDeviceID==nil || self.orderDeviceID.length==0)
        self.orderDeviceID=appDelegate.appConfig.userInfo.deviceID;
    [dictionary setValue:self.orderDeviceID forKey:OrderDeviceIDKey];
    
    if(self.orderDeviceToken==nil || self.orderDeviceToken.length==0)
        self.orderDeviceToken=appDelegate.appConfig.userInfo.deviceToken;
    [dictionary setValue:self.orderDeviceToken forKey:OrderDeviceTokenKey];
    
    [dictionary setValue:[NSNumber numberWithInteger:self.orderAmountDue] forKey:OrderAmountDueKey];
    
    [dictionary setValue:[NSNumber numberWithInteger:self.chargeAmount] forKey:OrderChargeAmountKey];
    [dictionary setValue:self.chargeCurrency forKey:OrderChargeCurrencyKey];
    [dictionary setValue:self.chargeToken forKey:OrderChargeTokenKey];
    [dictionary setValue:self.chargeDescription forKey:OrderChargeDescriptionKey];
    
    [dictionary setValue:self.chargePayType forKey:OrderPayTypeKey];
    //[dictionary setValue:self.cardInfo  forKey:OrderCardInfoKey];
    //[dictionary setValue:self.chargePayCashAmount forKey:OrderPayCashAmountKey];
    //[dictionary setValue:self.orderPayCashChange forKey:OrderPayCashChangeKey];
    [dictionary setValue:self.chargeStatus forKey:OrderPayStatusKey];
    [dictionary setValue:[NSNumber numberWithInteger:self.orderDiscountPercent] forKey:OrderDiscountPercentKey];
    [dictionary setValue:[NSNumber numberWithInteger:self.orderDiscountAmount] forKey:OrderDiscountAmountKey];
    [dictionary setValue:self.orderDiscountCode forKey:OrderDiscountCodeKey];
    [dictionary setValue:@(self.favorite) forKey:OrderFavoriteKey];
    // [dictionary setValue:self.orderNotes forKey:OrderNotesKey];
    
    return dictionary;
    
    
}
-(void)reHash{
    
    NSData *data=[NSKeyedArchiver archivedDataWithRootObject:[self toJSONDictionary]];
    
    self.orderHash=[data MD5];
    //return hashed;
}

/*
-(NSString *)toChargeResponseString{
    NSMutableDictionary *response_dict=[[NSMutableDictionary alloc] init];
    
    NSDictionary *order_dict=[self toJSONDictionary];
    
    [response_dict setValue:@"charge" forKey:KEY_ACTION];
    [response_dict setValue:order_dict forKey:KEY_ACTION_PARAM];
    [response_dict setValue:KEY_ACTION_TYPE_RESPONSE forKey:KEY_ACTION_TYPE];
    
    NSError *error;
    
    NSData *jsonData=[NSJSONSerialization dataWithJSONObject:response_dict options:NSJSONWritingPrettyPrinted error:&error];
    
    if(error==nil){
        NSString *reply=[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        //NSLog(@"reply=%@",reply);
        //[self sendMyMessage:reply withMessageType:MSG_TYPE_RESPONSE andLocalCopy:NO];
        return reply;
    }
    
    return nil;
}
*/
-(NSString *)toStringLabel{
    
    NSString *result=[NSString new];
    
    //if(item.orderNumber!=nil || item.orderNumber!=0){
    
    
    NSString *orderItemsLabel=[NSString new];
    
    NSInteger total=0;
    NSInteger subtotal=0;
    NSInteger totaltax=0;
    NSInteger totaldiscount=0;
    NSInteger totalOptions=0;
    if(self.orderItems!=nil && [self.orderItems count]>0){
        for (OrderItem *oi in self.orderItems) {
            
            if([oi.options count]>0){
                for(OrderOptionItem *ooi in oi.options ){
                    totalOptions=totalOptions+ooi.addlCost;
                }
            }
            
            subtotal=(subtotal+totalOptions)*oi.quantity;
            
            if(oi.price>0){
                double d_price=oi.price;
                orderItemsLabel=[orderItemsLabel stringByAppendingFormat:@"\n%ld %@ @%.02f\n",(long)oi.quantity,oi.name,d_price/100];
            }
            else{
                orderItemsLabel=[orderItemsLabel stringByAppendingFormat:@"\n%ld %@\n",(long)oi.quantity,oi.name];
            }
            
            if ([oi.options count]>0){
                NSString *options=@"";
                for(OrderOptionItem *ooi in oi.options){
                    NSString *priceString=@"";
                    if(ooi.addlCost!=0){
                        priceString= [NSString stringWithFormat:@"@%@",[Util priceIntToString:ooi.addlCost currency:nil]];
                        options=[NSString stringWithFormat:@"%@%@  %@\n", options,ooi.title,priceString];
                    }
                    else{
                        options=[NSString stringWithFormat:@"%@%@ ...%@\n", options,ooi.title,priceString];
                    }
                }
                orderItemsLabel=[orderItemsLabel stringByAppendingFormat:@"%@",options];
            }
            //if(orderItem.notes.length>0){
            //    notes=[NSString stringWithFormat:@"%@ \"%@\"",notes,orderItem.notes];
            //}
            
            if(oi.notes!=nil & oi.notes.length>0)
                orderItemsLabel=[orderItemsLabel stringByAppendingFormat:@"\"%@\"\n",oi.notes];
            
        }
        
        if([self.orderDiscounts count]>0){
            for(DiscountItem *di in self.orderDiscounts){
                totaldiscount=totaldiscount+di.price;
                orderItemsLabel=[orderItemsLabel stringByAppendingFormat:@"%@ %@ -%.02f\n",di.name,di.discountID, (double)totaldiscount/100];
            }
            subtotal=subtotal-totaldiscount;
            orderItemsLabel=[orderItemsLabel stringByAppendingFormat:@"\nDiscounts: %.02f\n",(double)totaldiscount/100];
        }
        
        

        self.orderSubtotal=subtotal;
        /*if (subtotal>0) {
         orderItemsLabel=[orderItemsLabel stringByAppendingFormat:@"Subtotal: %.02f\n",(double)self.orderSubtotal/100];
         }
         */
        totaltax=subtotal* (self.orderTax/100);
        self.orderTotalTax=totaltax;
        
        if(totaltax>0){
            double d_totaltax=self.orderTotalTax;
            orderItemsLabel=[orderItemsLabel stringByAppendingFormat:@"\nTax: %.02f @%.02f%%\n",d_totaltax/100,self.orderTax];
            //orderItemsLabel=[orderItemsLabel stringByAppendingFormat:@"Total: %.02f",(double)[self total]/100];
        }
        
        if(self.orderTip>0){
            orderItemsLabel=[orderItemsLabel stringByAppendingFormat:@"\nTip: %.02f\n",(double)self.orderTip/100];
        }
        
        //tip always after tax
        total=subtotal+totaltax+self.orderTip;
        self.orderTotal=total;
        double d_total=total;
        orderItemsLabel=[orderItemsLabel stringByAppendingFormat:@"\nTotal: %.02f\n",d_total/100];
        
        
        
    }
    NSInteger amountpaid=0;
    NSInteger amount=0;
    NSInteger amountdue=total;
    NSInteger cashback=0;
    NSString *payments=[NSString new];
    NSString *payType;
    if(self.orderPayments!=nil && [self.orderPayments count]>0){
        for (NSDictionary *pitem in self.orderPayments) {
            
            payType=[pitem valueForKey:KEY_PAYMENT_TYPE];
            amount=[[pitem valueForKey:KEY_AMOUNT] integerValue];
            amountpaid=amountpaid+amount;
            double d_amount=amount;
           
            
            if([payType isEqualToString:ORDER_PAY_TYPE_CCARD]){
                payments=[payments stringByAppendingString:[NSString stringWithFormat:@"%@ %.02f\n",
                                                            [pitem valueForKey:KEY_CARD4],
                                                            d_amount/100
                                                            
                                                            ]];
            }
            else if ([payType isEqualToString:ORDER_PAY_TYPE_CASH]){
                payments=[payments stringByAppendingString:[NSString stringWithFormat:@"%@ %.02f\n",
                                                            payType,
                                                            d_amount/100]];
                
            }
        }
        
        
    }
    
    if(amountpaid>amountdue){
        cashback=amountpaid-amountdue;
        amountdue=0;
        
    }
    else{
        amountdue=amountdue-amountpaid;
        
    }
    
    if(amountdue>0){
        //self.orderStatus=@ORDER_STATUS_UNPAID;
        self.orderIsPaid=NO;
    }
    else{
        //self.orderStatus=@ORDER_STATUS_PAID;
        self.orderIsPaid=YES;
    }
    
    self.orderAmountDue=amountdue;
    self.orderCashBack=cashback;
     double d_amountdue=amountdue;
    //double d_cashback=cashback;
    orderItemsLabel=[orderItemsLabel stringByAppendingFormat:@"\nAmount due: %.02f\n",d_amountdue/100];
    
    
    
    
    
    
    
    
    NSString *statusLabel=[NSString new];
    switch ([self.orderStatus intValue]) {
            /* case ORDER_STATUS_PENDING:
             orderDetailTextWithStatus=ORDER_STATUS_PENDING_LABEL;
             break;
             */
        case ORDER_STATUS_START:
            statusLabel=ORDER_STATUS_START_LABEL;
            break;
        case ORDER_STATUS_RECEIVED:
            statusLabel=ORDER_STATUS_RECEIVED_LABEL;
            break;
        /*case ORDER_STATUS_PAID:
            statusLabel=ORDER_STATUS_PAID_LABEL;
            break;
        case ORDER_STATUS_UNPAID:
            statusLabel=ORDER_STATUS_UNPAID_LABEL;
            break;
         */
        case ORDER_STATUS_READY:
            statusLabel=ORDER_STATUS_READY_LABEL;
            break;
        case ORDER_STATUS_FAILED:
            statusLabel=ORDER_STATUS_FAILED_LABEL;
            break;
        case ORDER_STATUS_CLOSED:
            statusLabel=ORDER_STATUS_CLOSED_LABEL;
            break;
        case ORDER_STATUS_CANC:
            statusLabel=ORDER_STATUS_CANC_LABEL;
            break;
        //case ORDER_STATUS_REFUND:
         //   statusLabel=ORDER_STATUS_REFUND_LABEL;
         //   break;
            
            
        default:
            statusLabel=ORDER_STATUS_UNK_LABEL;
            break;
    }
    NSDateFormatter *formatter=[[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm"];
   
    
    if (self.orderCashBack>0) {
         double ordercashback=self.orderCashBack;
        if(self.orderIsRefunded){
            result=[NSString stringWithFormat:@"%@\n%@ #%@\t%@\n%@ %@ %@\n%@\n%@\nChange: %.02f\n", self.orderBy,(self.orderIsLive)?@"ORDER":@"TEST", self.orderNumber,[formatter stringFromDate:self.orderDateTime],(self.orderIsPaid)?ORDER_ISPAID_LABEL:ORDER_ISNOTPAID_LABEL,ORDER_STATUS_REFUND_LABEL, statusLabel, orderItemsLabel,payments,ordercashback/100];
        }
        else{
            result=[NSString stringWithFormat:@"%@\n%@ #%@\t%@\n%@ %@\n%@\n%@\nChange: %.02f\n",self.orderBy,(self.orderIsLive)?@"ORDER":@"TEST", self.orderNumber,[formatter stringFromDate:self.orderDateTime],(self.orderIsPaid)?ORDER_ISPAID_LABEL:ORDER_ISNOTPAID_LABEL,statusLabel, orderItemsLabel,payments,ordercashback/100];
        }
        
    }
    else{
        if(self.orderIsRefunded){
            result=[NSString stringWithFormat:@"%@\n%@ #%@\t%@\n%@ %@ %@\n%@\n%@",self.orderBy,(self.orderIsLive)?@"ORDER":@"TEST", self.orderNumber,[formatter stringFromDate:self.orderDateTime],(self.orderIsPaid)?ORDER_ISPAID_LABEL:ORDER_ISNOTPAID_LABEL,ORDER_STATUS_REFUND_LABEL, statusLabel,orderItemsLabel,payments];
        }
        else{
            result=[NSString stringWithFormat:@"%@\n%@ #%@\t%@\n%@ %@\n%@\n%@",self.orderBy,(self.orderIsLive)?@"ORDER":@"TEST", self.orderNumber,[formatter stringFromDate:self.orderDateTime],(self.orderIsPaid)?ORDER_ISPAID_LABEL:ORDER_ISNOTPAID_LABEL,statusLabel,orderItemsLabel,payments];
        }
    }
    
    return result;
}

- (NSArray *)orderItemsToJSON{
    NSMutableArray *results=[NSMutableArray new];
    for (OrderItem * item in self.orderItems){
        [results addObject:[item toJSONDictionary]];
    }
    return results;
}

- (NSArray *)orderDiscountsToJSON{
    NSMutableArray *results=[NSMutableArray new];
    for (DiscountItem * item in self.orderDiscounts){
        [results addObject:item.toJSONDictionary];
    }
    return results;
}


-(void)completeCharge{
    if([self.chargePayType isEqualToString:ORDER_PAY_TYPE_CASH] ){
        [self performCash];
    }
    else if([self.chargePayType isEqualToString:ORDER_PAY_TYPE_CCARD] ){
        [self performStripeOperation];
    }
}

- (void)performStripeOperation{ //cents
    
    //1
    //self.completeButton.enabled = NO;
    AppDelegate *_appDelegate=ApplicationDelegate;
    
    
    CCardInfo *selectedCard;
    //use default card always
    
    if(self.orderIsLive){ //_appDelegate.appConfig.isLive){
        if([_appDelegate.appConfig.userInfo.ccards count]>0){
            
            selectedCard=[_appDelegate.appConfig.userInfo.ccards objectAtIndex:0];
            for (CCardInfo *c in _appDelegate.appConfig.userInfo.ccards) {
                if(c.isDefault){
                    selectedCard=c;
                    break;
                }
            }
        }
    }
    else{
        selectedCard=_appDelegate.appConfig.testCard;
        if(selectedCard.name==nil){
            selectedCard.name=@"";
            if(_appDelegate.appConfig.userInfo.fullName!=nil)
                selectedCard.name=_appDelegate.appConfig.userInfo.fullName;
            else if(_appDelegate.appConfig.userInfo.displayName!=nil)
                selectedCard.name=_appDelegate.appConfig.userInfo.displayName;
            
            
        }
        
        
    }
    _appDelegate.appConfig.userInfo.selectedCard=selectedCard;
    self.orderBy=selectedCard.name;
    
    //1
    /*if(_appDelegate.mcManager.serverPeerInfo==nil){
     
     }
     */
    
    // BOOL isMultiPay=NO;
    
    STPCard* stripeCard = [[STPCard alloc] init];
    stripeCard.name = selectedCard.name;//self.nameTextField.text;
    stripeCard.number = selectedCard.number;// self.cardNumber.text;
    stripeCard.cvc =selectedCard.cvc;// self.CVCNumber.text;
    stripeCard.expMonth =selectedCard.expMonth;// //[self.selectedMonth integerValue];
    stripeCard.expYear =selectedCard.expYear; //[self.selectedYear integerValue];
    
    //ROM added:
    //self.stripeCard.email=self.emailTextField.text;
    
    //2
    if (![self validateCustomerInfo:stripeCard])
        return;
    
    BOOL hasInternet=NO;
    
    if(hasInternet){
        
        //STPAPIClient *client = [[STPAPIClient alloc] initWithPublishableKey:STRIPE_TEST_PUBLIC_KEY];
        STPAPIClient *client;
        if(_appDelegate.appConfig.isLive)
            client = [[STPAPIClient alloc] initWithPublishableKey:_appDelegate.selectedStore.peerInfo.paymentPublishableKey];
        else
            client = [[STPAPIClient alloc] initWithPublishableKey:_appDelegate.selectedStore.peerInfo.paymentPublishableKeyTest];
        [client createTokenWithCard:stripeCard completion:
         //get stripe token if stripe is used
         /*[Stripe createTokenWithCard:cardInfo publishableKey:STRIPE_TEST_PUBLIC_KEY completion:*/
         ^(STPToken* token,NSError *error){
             if(error){
                 self.orderStatus=@ORDER_STATUS_FAILED;
                 [self handleStripeError:error];
             }
             else{
                 //order.chargeToken=token.tokenId;
                 //[self performPostCharge:order cardInfo:card fromPeer:peerInfo];
                 [self performCharge:token.tokenId withCard:stripeCard];
             }
         }];
    }
    else{
        [self performCharge:nil withCard:stripeCard];
    }
    
    
    
}


-(BOOL)validateCustomerInfo:(STPCard *)stripeCard {
    
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Please try again"
                                                     message:@"Please enter all required information"
                                                    delegate:nil
                                           cancelButtonTitle:@"OK"
                                           otherButtonTitles:nil];
    
    /*
     //1. Validate name & email
     if (self.nameTextField.text.length == 0
     //|| self.emailTextField.text.length == 0
     )
     {
     
     [alert show];
     return NO;
     }
     
     //2. Validate card number, CVC, expMonth, expYear
     NSError* error = nil;
     [self.stripeCard validateCardReturningError:&error];
     
     //3
     if (error) {
     alert.message = [error localizedDescription];
     [alert show];
     return NO;
     }
     */
    /*STPCard* stripeCard = [[STPCard alloc] init];
     stripeCard.name = selectedCard.name;//self.nameTextField.text;
     stripeCard.number = selectedCard.number;// self.cardNumber.text;
     stripeCard.cvc =selectedCard.cvc;// self.CVCNumber.text;
     stripeCard.expMonth =selectedCard.expMonth;// //[self.selectedMonth integerValue];
     stripeCard.expYear =selectedCard.expYear; //[self.selectedYear integerValue];
     */
    if (stripeCard.name.length == 0
        //|| self.emailTextField.text.length == 0
        )
    {
        
        [alert show];
        return NO;
    }
    
    //2. Validate card number, CVC, expMonth, expYear
    NSError* error = nil;
    [stripeCard validateCardReturningError:&error];
    
    //3
    if (error) {
        alert.message = [error localizedDescription];
        [alert show];
        return NO;
    }
    return YES;
}

- (void)handleStripeError:(NSError *) error {
    
    //1
    if ([error.domain isEqualToString:@"StripeDomain"]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:[error localizedDescription]
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    
    //2
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"Please try again"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    
    //self.completeButton.enabled = YES;
}


-(void)performCharge:(NSString *)token withCard:(STPCard*) stripeCard{
    AppDelegate *_appDelegate=ApplicationDelegate;
    self.chargeToken=token;
    
    
    
    NSDictionary *order_dict=[self toJSONDictionary];
    
    
    NSDictionary *card_info_dict=@{@"name":stripeCard.name,
                                   @"email":(_appDelegate.appConfig.userInfo.email)?_appDelegate.appConfig.userInfo.email:@"", // self.stripeCard.email,
                                   @"number":stripeCard.number,
                                   @"cvc":stripeCard.cvc,
                                   @"expMonth":[NSNumber numberWithUnsignedInteger:stripeCard.expMonth],
                                   @"expYear":[NSNumber numberWithUnsignedInteger:stripeCard.expYear]};
    
    // order.cardInfo=card_info_dict;
    
    //[self didUpdateHistoryWithNotification];
    
    NSMutableDictionary *request_dict=[[NSMutableDictionary alloc] init];
    
    [request_dict setValue:KEY_ACTION_CHARGE forKey:KEY_ACTION];
    [request_dict setValue:@{KEY_CHARGE_CARDINFO:card_info_dict,KEY_CHARGE_ORDER:order_dict} forKey:KEY_ACTION_PARAM];
    [request_dict setValue:KEY_ACTION_TYPE_REQUEST forKey:KEY_ACTION_TYPE];
    
    NSError *error;
    
    NSData *jsonData=[NSJSONSerialization dataWithJSONObject:request_dict options:NSJSONWritingPrettyPrinted error:&error];
    
    if(error==nil){
        NSString *request=[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        //NSLog(@"reply=%@",reply);
        //[self sendMyMessage:reply withMessageType:MSG_TYPE_RESPONSE andLocalCopy:NO];
        
        //check if connected and storeid
        //if not just leave in queue/pending then order later when connected
        if(_appDelegate.selectedStore.peerInfo.sessionState==MCSessionStateConnected) //&& [_appDelegate.selectedStore.peerInfo.deviceID isEqualToString:self.orderStoreID])
        {
            BroadcastMessageAPI *message=[[BroadcastMessageAPI alloc] init];
            message.text=request;
            message.isBroadcast=NO;
            message.toPeerInfo=_appDelegate.selectedStore.peerInfo;
            message.message_type=MSG_TYPE_REQUEST;
            message.localCopy=NO;
            
            NSDictionary *dict = @{KEY_SEND_MESSAGE: message
                                   };
            
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_HAS_DATA_TO_SEND
                                                                object:nil
                                                              userInfo:dict];
        }
        //else{
        
        //}
        /*
         processTimer=[NSTimer scheduledTimerWithTimeInterval:30.0 target:self selector:@selector(chargeTimedOut:) userInfo:nil repeats:NO];
         [processWait show];
         */
        
        
    }
    else{
        //return;
        self.orderStatus=@ORDER_STATUS_FAILED;
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Error 100" message:@"There was an error processing your request. Please see attendant for help." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        
    }
}

-(void)performCash{
    AppDelegate *_appDelegate=ApplicationDelegate;
    NSDictionary *order_dict=[self toJSONDictionary];
    
    NSMutableDictionary *request_dict=[[NSMutableDictionary alloc] init];
    
    [request_dict setValue:KEY_ACTION_ORDER forKey:KEY_ACTION];
    //[request_dict setValue:order_dict forKey:KEY_ACTION_PARAM];
    [request_dict setValue:@{KEY_CHARGE_ORDER:order_dict} forKey:KEY_ACTION_PARAM];
    [request_dict setValue:KEY_ACTION_TYPE_REQUEST forKey:KEY_ACTION_TYPE];
    
    NSError *error;
    
    NSData *jsonData=[NSJSONSerialization dataWithJSONObject:request_dict options:NSJSONWritingPrettyPrinted error:&error];
    
    if(error==nil){
        NSString *request=[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        
        BroadcastMessageAPI *message=[[BroadcastMessageAPI alloc] init];
        message.text=request;
        message.isBroadcast=NO;
        message.toPeerInfo=_appDelegate.selectedStore.peerInfo;
        message.message_type=MSG_TYPE_REQUEST;
        message.localCopy=NO;
        
        NSDictionary *dict = @{KEY_SEND_MESSAGE: message
                               };
        
        
        
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_HAS_DATA_TO_SEND
                                                            object:nil
                                                          userInfo:dict];
    }
    else{
        self.orderStatus=@ORDER_STATUS_FAILED;
        //return;
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Error 101" message:@"There was an error processing your request. Please see attendant for help." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];

    }
   

}





@end
