//
//  IODOrder.m
//  iOSDiner
//
//  Created by Romulo Quidilig on 3/19/15.
//  Copyright (c) 2015 Sharecle Inc. All rights reserved.
//

#import "OrderHistory.h"
#import "OrderItem.h"
#import "OrderOptionItem.h"
#import "ProductOption.h"
#import "ProductOptionItem.h"

#import "DiscountItem.h"
#import "InventoryModel.h"
#import "AppDelegate.h"
#import "PaymentManager.h"
#import "NSData+Conversion.h"
#import "defs.h"
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
static NSString* const OrderIsLiveKey = @"OrderIsLive";
static NSString* const OrderDeleteUnpaidPendingKey = @"OrderDeleteUnpaidPending";

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
@interface OrderHistory(){
    PaymentManager *_paymentManager;
}

@end
@implementation OrderHistory


- (id)initWithCoder:(NSCoder*)decoder
{
   
    if ((self = [super init]))
    {
        self.orderItems= [decoder decodeObjectForKey:OrderItemsKey];
        self.orderPayments= [decoder decodeObjectForKey:OrderPaymentsKey];
        self.orderDiscounts= [decoder decodeObjectForKey:OrderDiscountsKey];
        
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
       // self.cancelStatus=[decoder decodeObjectForKey:CanceltatusKey];
        self.orderIsLive=[decoder decodeBoolForKey:OrderIsLiveKey];
        self.orderBy=[decoder decodeObjectForKey:OrderByKey];
        self.orderUserName=[decoder decodeObjectForKey:OrderUserNameKey];
        self.orderUserID =  [decoder decodeObjectForKey:OrderUserIDKey];
        self.orderID=[decoder decodeObjectForKey:OrderIDKey];
        self.orderReply=[decoder decodeObjectForKey:OrderReplyKey];
        self.orderSource=[decoder decodeObjectForKey:OrderSourceKey];
        self.orderDeviceID=[decoder decodeObjectForKey:OrderDeviceIDKey];
        self.orderDeviceToken=[decoder decodeObjectForKey:OrderDeviceTokenKey];
        
        self.orderAmountDue=[decoder decodeIntegerForKey:OrderAmountDueKey];
        
        self.chargeAmount=[decoder decodeIntegerForKey:OrderChargeAmountKey];
        self.orderCashBack=[decoder decodeIntegerForKey:OrderCashbackKey];
        self.chargeCurrency=[decoder decodeObjectForKey:OrderChargeCurrencyKey];
        self.orderTax=[decoder decodeDoubleForKey:OrderTaxRateKey];
        self.orderTip=[decoder decodeIntegerForKey:OrderTipKey];
        
        self.chargeToken=[decoder decodeObjectForKey:OrderChargeTokenKey];
        self.chargeId=[decoder decodeObjectForKey:OrderChargeIdKey];
        self.chargeDescription=[decoder decodeObjectForKey:OrderChargeDescriptionKey];
        
        
        self.chargePayType=[decoder decodeObjectForKey:OrderPayTypeKey];
       
        self.chargeStatus=[decoder decodeObjectForKey:OrderPayStatusKey];
        self.orderDiscountPercent=[decoder decodeIntegerForKey:OrderDiscountPercentKey];
        self.orderDiscountAmount=[decoder decodeIntegerForKey:OrderDiscountAmountKey];
        self.orderDiscountCode=[decoder decodeObjectForKey:OrderDiscountCodeKey];

        self.deleteStatus=[decoder decodeIntegerForKey:deleteStatusKey];
        //self.orderFailedRetry=[decoder decodeObjectForKey:OrderDiscountCodeKey];
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
            
            
            
            total=subtotal+totaltax+self.orderTip;
            self.orderTotal=total;
            
            
            
            
        }
        
        /*if(self.orderDiscounts!=nil && [self.orderDiscounts count]>0){
            for (DiscountItem *di in self.orderDiscounts) {
                
            }
            
        }
        */
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
        self.orderIsCaptured=[decoder decodeBoolForKey:OrderIsCapturedKey];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder*)encoder
{
   
    [encoder encodeObject:self.orderItems forKey:OrderItemsKey];
    [encoder encodeObject:self.orderPayments forKey:OrderPaymentsKey];
    [encoder encodeObject:self.orderDiscounts forKey:OrderDiscountsKey];
    
   //  [encoder encodeObject:self.orderDetailText forKey:OrderDetailTextKey];
    [encoder encodeObject:self.orderNumber forKey:OrderNumberKey];
    [encoder encodeObject:self.orderDate forKey:OrderDateKey];
    [encoder encodeObject:self.orderDateTime forKey:OrderDateTimeKey];
    [encoder encodeObject:self.orderDay forKey:OrderDayKey];
    [encoder encodeObject:self.orderStoreID forKey:OrderStoreIDKey];
    [encoder encodeInteger:self.orderStoreNum forKey:OrderStoreNumKey];
    [encoder encodeObject:self.orderStoreName forKey:OrderStoreNameKey];
    [encoder encodeObject:self.orderStoreLoc forKey:OrderStoreLocKey];
    [encoder encodeObject:self.orderStatus forKey:OrderStatusKey];\
    //[encoder encodeObject:self.cancelStatus forKey:OrderStatusKey];
    [encoder encodeBool:self.orderIsLive forKey:OrderIsLiveKey];
    [encoder encodeBool:self.orderIsPaid forKey:OrderIsPaidKey];
    [encoder encodeBool:self.orderIsRefunded forKey:OrderIsRefundedKey];
    [encoder encodeBool:self.orderIsCaptured forKey:OrderIsCapturedKey];

    
     [encoder encodeObject:self.orderBy forKey:OrderByKey];
    [encoder encodeObject:self.orderUserName forKey:OrderUserNameKey];
    [encoder encodeObject:self.orderUserID forKey:OrderUserIDKey];
    [encoder encodeObject:self.orderID forKey:OrderIDKey];
    [encoder encodeObject:self.orderReply forKey:OrderReplyKey];
    [encoder encodeObject:self.orderSource forKey:OrderSourceKey];
    [encoder encodeObject:self.orderDeviceID forKey:OrderDeviceIDKey];
    [encoder encodeObject:self.orderDeviceToken forKey:OrderDeviceTokenKey];
    [encoder encodeInteger:self.orderAmountDue forKey:OrderAmountDueKey];
    
    [encoder encodeObject:self.chargeId forKey:OrderChargeIdKey];
    [encoder encodeDouble:self.orderTax forKey:OrderTaxRateKey];
    [encoder encodeInteger:self.orderTip forKey:OrderTipKey];
  //  [encoder encodeObject:self.orderDeviceToken forKey:OrderDeviceTokenKey];
    //[encoder encodeInteger:self.orderSubtotal forKey:OrderTaxRateKey];
   // [encoder encodeInteger:self.orderTotal forKey:OrderTotalKey];
    
    
    [encoder encodeObject:self.chargeCurrency forKey:OrderChargeCurrencyKey];
    [encoder encodeInteger:self.orderCashBack forKey:OrderCashbackKey];
    [encoder encodeObject:self.chargeToken forKey:OrderChargeTokenKey];
    //[encoder encodeObject:self.chargeId forKey:OrderChargeIdKey];
    [encoder encodeObject:self.chargeDescription forKey:OrderChargeDescriptionKey];
    
    [encoder encodeObject:self.chargePayType forKey:OrderPayTypeKey];
    //[encoder encodeObject:self.orderPayCashAmount forKey:OrderPayCashAmountKey];
    //[encoder encodeObject:self.orderPayCashChange forKey:OrderPayCashChangeKey];
    [encoder encodeObject:self.chargeStatus forKey:OrderPayStatusKey];
    [encoder encodeInteger:self.orderDiscountPercent forKey:OrderDiscountPercentKey];
    [encoder encodeInteger:self.orderDiscountAmount forKey:OrderDiscountAmountKey];
    [encoder encodeObject:self.orderDiscountCode forKey:OrderDiscountCodeKey];
    
    [encoder encodeInteger:self.deleteStatus forKey:deleteStatusKey];
    
    
    
}

- (id)initWithDictionary:(NSDictionary *)dictionary{
    if ((self = [super init]))
    {
        
        
        //self.orderDetailText=[dictionary valueForKey:OrderDetailTextKey];
        self.orderNumber = [dictionary valueForKey:OrderNumberKey];
        
        self.orderDate = [dictionary valueForKey:OrderDateKey];
        
        self.orderDateTime = [dictionary valueForKey:OrderDateTimeKey];
        
        self.orderDay = [dictionary valueForKey:OrderDayKey];
        self.orderStatus =  [dictionary  valueForKey:OrderStatusKey] ;
        
        self.orderIsRefunded =  [[dictionary  valueForKey:OrderIsRefundedKey] boolValue];
        self.orderIsCaptured =  [[dictionary  valueForKey:OrderIsCapturedKey] boolValue];
        
        self.orderIsLive =  [[dictionary  valueForKey:OrderIsLiveKey] boolValue] ;
        self.orderDeleteUnpaidPending= [dictionary  valueForKey:OrderDeleteUnpaidPendingKey] ;
        self.orderStoreID = [dictionary valueForKey:OrderStoreIDKey];
        
        self.orderStoreNum = [[dictionary valueForKey:OrderStoreNumKey] integerValue];
        self.orderStoreName = [dictionary valueForKey:OrderStoreNameKey] ;
        
        self.orderStoreLoc=[dictionary valueForKey:OrderStoreLocKey] ;
        self.orderBy=[dictionary valueForKey:OrderByKey] ;
        self.orderUserName=[dictionary valueForKey:OrderUserNameKey] ;
        self.orderUserID = [dictionary valueForKey:OrderUserIDKey];
         self.orderID=[dictionary valueForKey:OrderIDKey] ;
        self.orderReply=[dictionary valueForKey:OrderReplyKey] ;
        self.orderSource=[dictionary valueForKey:OrderSourceKey];
        self.orderDeviceID=[dictionary valueForKey:OrderDeviceIDKey];
        self.orderDeviceToken=[dictionary valueForKey:OrderDeviceTokenKey];
        self.orderAmountDue=[[dictionary valueForKey:OrderAmountDueKey] integerValue] ;
        self.orderTax=[[dictionary valueForKey:OrderTaxRateKey] doubleValue] ;
        
        self.chargeAmount=[[dictionary valueForKey:OrderChargeAmountKey] integerValue];
        self.chargeId = [dictionary valueForKey:OrderChargeIdKey];
        self.chargeCurrency=[dictionary valueForKey:OrderChargeCurrencyKey] ;
        self.chargeToken=[dictionary valueForKey:OrderChargeTokenKey] ;
        self.chargeDescription=[dictionary valueForKey:OrderChargeDescriptionKey] ;

      
        self.chargePayType=[dictionary valueForKey:OrderPayTypeKey];
        //self.orderPayCashAmount=[dictionary valueForKey:OrderPayCashAmountKey];
        //self.orderPayCashChange=[dictionary valueForKey:OrderPayCashChangeKey];
        self.chargeStatus=[dictionary valueForKey:OrderPayStatusKey];
        self.orderDiscountPercent=[[dictionary valueForKey:OrderDiscountPercentKey] doubleValue];
        self.orderDiscountAmount=[[dictionary valueForKey:OrderDiscountAmountKey] integerValue];
        self.orderDiscountCode=[dictionary valueForKey:OrderDiscountCodeKey];
        
        self.deleteStatus=[[dictionary valueForKey:deleteStatusKey] integerValue];
    }
    return self;
    
    
}

- (id)initWithJSON:(NSDictionary *)dictionary{
    if ((self = [super init]))
    {
        
        
     //   self.orderDetailText=[dictionary valueForKey:OrderDetailTextKey];
        self.orderNumber = [dictionary valueForKey:OrderNumberKey];
        
       
        NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss zzz"];
        
        
        self.orderDate =[dateFormatter dateFromString:[dictionary valueForKey:OrderDateKey]];
        
        
        
        self.orderDateTime =[dateFormatter dateFromString:[dictionary valueForKey:OrderDateTimeKey]];
        
        
        self.orderDay = [dictionary valueForKey:OrderDayKey];
        self.orderStatus =  [dictionary  valueForKey:OrderStatusKey] ;
        
        self.orderIsRefunded =  [[dictionary  valueForKey:OrderIsRefundedKey] boolValue] ;
        self.orderIsCaptured =  [[dictionary  valueForKey:OrderIsCapturedKey] boolValue] ;
        
        self.orderIsLive =  [[dictionary  valueForKey:OrderIsLiveKey] boolValue] ;
        self.orderStoreID = [dictionary valueForKey:OrderStoreIDKey];
        
        self.orderStoreNum=[[dictionary valueForKey:OrderStoreNumKey] integerValue];
        self.orderStoreName=[dictionary valueForKey:OrderStoreNameKey] ;
        
        self.orderStoreLoc=[dictionary valueForKey:OrderStoreLocKey] ;
        self.orderBy=[dictionary valueForKey:OrderByKey] ;
        self.orderUserName=[dictionary valueForKey:OrderUserNameKey] ;
        self.orderUserID = [dictionary valueForKey:OrderUserIDKey];
        self.orderID=[dictionary valueForKey:OrderIDKey] ;
        self.orderReply=[dictionary valueForKey:OrderReplyKey] ;
        self.orderSource=[dictionary valueForKey:OrderSourceKey];
        self.orderDeviceID=[dictionary valueForKey:OrderDeviceIDKey];
        
        self.orderDeviceToken=[dictionary valueForKey:OrderDeviceTokenKey];
        self.orderAmountDue=[[dictionary valueForKey:OrderAmountDueKey] integerValue] ;
        
        self.orderTax=[[dictionary valueForKey:OrderTaxRateKey] doubleValue] ;
        
        self.orderTip=[[dictionary valueForKey:OrderTipKey] integerValue];
        
        self.chargeAmount=[[dictionary valueForKey:OrderChargeAmountKey] integerValue] ;
        self.chargeCurrency=[dictionary valueForKey:OrderChargeCurrencyKey] ;
        self.chargeToken=[dictionary valueForKey:OrderChargeTokenKey] ;
        self.chargeDescription=[dictionary valueForKey:OrderChargeDescriptionKey] ;
        
        self.chargeId=[dictionary valueForKey:OrderChargeIdKey];
        self.chargePayType=[dictionary valueForKey:OrderPayTypeKey];
        //self.orderPayCashAmount=[dictionary valueForKey:OrderPayCashAmountKey];
       // self.orderPayCashChange=[dictionary valueForKey:OrderPayCashChangeKey];
        self.chargeStatus=[dictionary valueForKey:OrderPayStatusKey];
        
        self.orderDiscountPercent=[[dictionary valueForKey:OrderDiscountPercentKey] doubleValue];
        self.orderDiscountAmount=[[dictionary valueForKey:OrderDiscountAmountKey] integerValue];
        self.orderDiscountCode=[dictionary valueForKey:OrderDiscountCodeKey];
        
        
        
        //self.errorMessage=[NSString new];
        //self.hasError=NO;
        
        self.orderItems=[NSMutableArray new];
        NSArray *jsonOrderItems=[dictionary valueForKey:OrderItemsKey];
        if(jsonOrderItems){
            
            //first line of defence, remove invalid items add update pricing etc..
                    
            

            
            for (NSDictionary *json in jsonOrderItems) {
                OrderItem *item=[[OrderItem alloc] initWithJSON:json];
                
               
                
                [self.orderItems addObject:item];
            }
        }
        
        self.orderDiscounts=[NSMutableArray new];
        NSArray *jsonDiscountItems=[dictionary valueForKey:DiscountsKey];
        if(jsonDiscountItems){
            
            //first line of defence, remove invalid items add update pricing etc..
            
            
            
            
            for (NSDictionary *json in jsonDiscountItems) {
                DiscountItem *item=[[DiscountItem alloc] initWithJSON:json];
                
                
                
                [self.orderDiscounts addObject:item];
            }
        }

      
        
        
    }
    return self;
    
    
}


-(BOOL)validateOrder{
    
    BOOL result=YES;
    BOOL hasChanged=NO;
    NSMutableArray *changed_items=[NSMutableArray new];
   // InventoryModel *inventoryModel =[InventoryModel sharedInstance];
    InventoryModel *inventoryModel=[InventoryModel sharedInstance];
    
    InventoryItem *activeInventory=inventoryModel.inventory;
    //InventoryItem *activeInventory=[InventoryModel activeInventory];
   // AppDelegate *_appDelegate= (AppDelegate *)[[UIApplication sharedApplication] delegate];
    //TODO: was mutate while being enumerated
    NSArray *tmpArray=[NSArray arrayWithArray:self.orderItems];
    for(OrderItem *item in tmpArray){
        //item.isUpdated=false;
        
        Product *searchProd=[activeInventory searchProduct:item.productID];
        
        if(searchProd){
            //compare price, name
            if(searchProd.price!=item.price){
                item.price=searchProd.price;
                //  item.isUpdated=true;
                //self.errorCodes=[self.errorCodes stringByAppendingString:ORDER_ERR_CODE_100];
                item.errorMessage=ORDER_ERR_PRICE_CHANGED;
                result =NO;
                
            }
            //compare options
            if([item.options count]>0){
                
                for(OrderOptionItem *ooi in item.options){
                    ProductOptionItem *poi=[searchProd getOptionItemWithParentUID:ooi.parentUID andUID:ooi.UID];
                    if(poi==nil){
                        if(![poi.title isEqualToString:ooi.title]){
                            item.errorMessage=ORDER_ERR_OPTION_CHANGED;
                            return NO;
                        }
                    }
                    
                    if(![poi.title isEqualToString:ooi.title]
                       //|| poi.price!=ooi.price
                       || poi.addlCost!=ooi.addlCost
                       ){
                        item.errorMessage=ORDER_ERR_OPTION_CHANGED;
                        return NO;
                    }
                    /*
                    if(poi.price!=ooi.price){
                        item.errorMessage=ORDER_ERR_OPTION_CHANGED;
                        return NO;
                    }
                    if(poi.addlCost!=ooi.addlCost){
                        item.errorMessage=ORDER_ERR_OPTION_CHANGED;
                        return NO;
                    }*/
                    
                        
                    
                }
                
            }
            
            if(![searchProd.name isEqualToString:item.name]){
                item.name=searchProd.name;
                //self.errorCodes=[self.errorCodes stringByAppendingString:ORDER_ERR_CODE_101];
                item.errorMessage=ORDER_ERR_NAME_CHANGED;
                
                return NO;
            }
            
            if(searchProd.allowOutOfStock){//.stock_unlimited){
                if(searchProd.instock==0){
                    item.errorMessage=ORDER_ERR_OUT_OF_STOCK;
            
                return NO;
                }
                else{
                    if(result!=NO)
                    {
                        if(searchProd.instock>=item.quantity){
                            searchProd.instock=searchProd.instock-item.quantity;
                            
                        }
                        else{
                            item.quantity=searchProd.instock;
                            searchProd.instock=0;
                            item.errorMessage=ORDER_ERR_QUANTITY_CHANGED;

                        }
                        [changed_items addObject:searchProd];
                        hasChanged=YES;
                      //  [[NSNotificationCenter defaultCenter] ]
                        
                    }
                }
            }
            
           // [self.orderItems addObject:item];
        }
        else{
            
            item.errorMessage=ORDER_ERR_NOT_FOUND;
            
            return NO;
        }
    }
    /*
    
    //amountdue 0 means already paid
    //so no need to charge
    
    NSInteger amountDue=self.orderAmountDue;
    if(amountDue<0)
    {
#ifdef DEBUG
        NSLog(@"Amount due is <= 0. No charge is made.");
#endif
        self.errorMessage=@"Inconsistent Amount due.";
        return NO;
    }
    
    //for now we will not support muliple charges
    //so we should not process
    NSInteger chargeAmout=self.chargeAmount;
    if(chargeAmout<amountDue)
    {
#ifdef DEBUG
        NSLog(@"Charge Amount due is < Amount Due. No charge is made.");
#endif
        self.errorMessage=@"Invalid charge amount";
        
        return NO;
    }
    
    //for now we will not support cash back
    //so we should not process
    if(chargeAmout>amountDue)
    {
#ifdef DEBUG
        NSLog(@"Charge Amount due is > Amount Due. No charge is made.");
#endif
        self.errorMessage=@"Invalid charge amount";
        return NO;
    }
    */
    
    return result;
}

- (NSNumber*)total {
    
    float total = 0.0;
    //for (OrderItem* product in self.productsInCart) {
    for (OrderItem* item in self.orderItems) {
        //total += product.price;
        total += item.price*item.quantity;
    }
    return @(total);
}

- (double)total_tax:(double)tax{
    double total=[[self total] doubleValue];
    //float total_tax=total*[[CheckoutCart sharedTaxInstance] floatValue];
    double total_tax=total*tax;
    
    return total_tax;
}

- (double)grand_total:(double)tax{
    double total=[[self total] doubleValue];
    double total_tax=[self total_tax:tax];
    
    return total+total_tax;
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
    
 //   [dictionary setValue:self.orderDetailText forKey:OrderDetailTextKey];
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
    
    [dictionary setValue:[NSNumber numberWithBool:self.orderIsRefunded] forKey:OrderIsRefundedKey];
    [dictionary setValue:[NSNumber numberWithBool:self.orderIsCaptured] forKey:OrderIsCapturedKey];
    
    
    [dictionary setValue:[NSNumber numberWithBool:self.orderIsPaid] forKey:OrderIsPaidKey];
    [dictionary setValue:[NSNumber numberWithBool:self.orderIsLive] forKey:OrderIsLiveKey];
    [dictionary setValue:self.orderBy forKey:OrderByKey];
    [dictionary setValue:self.orderUserName forKey:OrderUserNameKey];
    [dictionary setValue:self.orderUserID forKey:OrderUserIDKey];
    [dictionary setValue:self.orderID forKey:OrderIDKey];
    [dictionary setValue:self.orderReply forKey:OrderReplyKey];
    [dictionary setValue:self.orderSource forKey:OrderSourceKey];
     [dictionary setValue:self.orderDeviceID forKey:OrderDeviceIDKey];
    [dictionary setValue:self.orderDeviceToken forKey:OrderDeviceTokenKey];
    [dictionary setValue:[NSNumber numberWithInteger:self.orderAmountDue] forKey:OrderAmountDueKey];
    
    [dictionary setValue:[NSNumber numberWithInteger:self.chargeAmount] forKey:OrderChargeAmountKey];
     [dictionary setValue:self.chargeCurrency forKey:OrderChargeCurrencyKey];
     [dictionary setValue:self.chargeId forKey:OrderChargeIdKey];
     [dictionary setValue:self.chargeToken forKey:OrderChargeTokenKey];
     [dictionary setValue:self.chargeDescription forKey:OrderChargeDescriptionKey];
    
    [dictionary setValue:self.chargePayType forKey:OrderPayTypeKey];
    //[dictionary setValue:self.orderPayCashAmount forKey:OrderPayCashAmountKey];
   //[dictionary setValue:self.orderPayCashChange forKey:OrderPayCashChangeKey];
    [dictionary setValue:self.chargeStatus forKey:OrderPayStatusKey];
    [dictionary setValue:[NSNumber numberWithInteger:self.orderDiscountPercent] forKey:OrderDiscountPercentKey];
    [dictionary setValue:[NSNumber numberWithInteger:self.orderDiscountAmount] forKey:OrderDiscountAmountKey];
    [dictionary setValue:self.orderDiscountCode forKey:OrderDiscountCodeKey];

    
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
    
   // [dictionary setValue:self.orderDetailText forKey:OrderDetailTextKey];
    
    [dictionary setValue:self.orderNumber forKey:OrderNumberKey];
    
    NSMutableArray *items=[NSMutableArray new];
    for (OrderItem *item in self.orderItems) {
        NSMutableDictionary *dict=[NSMutableDictionary new];
        [dict setValue:@(item.productID) forKey:ProductIDKey];
        [dict setValue:item.name forKey:NameKey];
        [dict setValue:@(item.price) forKey:PriceKey];
        [dict setValue:@(item.quantity) forKey:QuantityKey];
        
        
        NSMutableArray *options=[NSMutableArray new];
        for (OrderOptionItem *ooi in item.options) {
            NSDictionary *dict_ooi=[ooi toNSDictionary];
            [options addObject:dict_ooi];
        }
        [dict setValue:options forKey:optionsKey];
        
        
        [items addObject:dict];
    }
      [dictionary setValue:items forKey:OrderItemsKey];
    
    NSMutableArray *discounts=[NSMutableArray new];
    
    for (DiscountItem *item in self.orderDiscounts) {
        
        /*NSMutableDictionary *dict=[NSMutableDictionary new];
         [dict setValue:@(item.productID) forKey:ProductIDKey];
         [dict setValue:item.name forKey:NameKey];
         [dict setValue:@(item.price) forKey:PriceKey];
         [dict setValue:@(item.quantity) forKey:QuantityKey];
         */
        [discounts addObject:[item toJSONDictionary]];
    }
    [dictionary setValue:discounts forKey:OrderDiscountsKey];
    
    
    NSMutableArray *payments=[NSMutableArray new];
    for (NSDictionary *item in self.orderPayments) {
        /*NSMutableDictionary *dict=[NSMutableDictionary new];
        [dict setValue:@(item.productID) forKey:ProductIDKey];
        [dict setValue:item.name forKey:NameKey];
        [dict setValue:@(item.price) forKey:PriceKey];
        [dict setValue:@(item.quantity) forKey:QuantityKey];
         */
        [payments addObject:item];
    }
      [dictionary setValue:payments forKey:OrderPaymentsKey];
  
    
    
    [dictionary setValue:strDate  forKey:OrderDateKey];
    [dictionary setValue:strDateTime forKey:OrderDateTimeKey];
    [dictionary setValue:self.orderDay forKey:OrderDayKey];
    [dictionary setValue:self.orderStoreID forKey:OrderStoreIDKey];
    [dictionary setValue:@(self.orderStoreNum) forKey:OrderStoreNumKey];
    [dictionary setValue:self.orderStoreName forKey:OrderStoreNameKey];
    
    [dictionary setValue:self.orderStoreLoc forKey:OrderStoreLocKey];
    [dictionary setValue:self.orderStatus forKey:OrderStatusKey];
    
    [dictionary setValue:[NSNumber numberWithBool:self.orderIsRefunded] forKey:OrderIsRefundedKey];
    [dictionary setValue:[NSNumber numberWithBool:self.orderIsCaptured] forKey:OrderIsCapturedKey];
    
    [dictionary setValue:[NSNumber numberWithBool:self.orderIsPaid] forKey:OrderIsPaidKey];
    [dictionary setValue:[NSNumber numberWithBool:self.orderIsLive] forKey:OrderIsLiveKey];
    [dictionary setValue:self.orderBy forKey:OrderByKey];
    [dictionary setValue:self.orderUserName forKey:OrderUserNameKey];
    [dictionary setValue:self.orderUserID forKey:OrderUserIDKey];
    [dictionary setValue:self.orderID forKey:OrderIDKey];
    [dictionary setValue:self.orderReply forKey:OrderReplyKey];
    [dictionary setValue:self.orderSource forKey:OrderSourceKey];
    [dictionary setValue:self.orderDeviceID forKey:OrderDeviceIDKey];
    [dictionary setValue:self.orderDeviceToken forKey:OrderDeviceTokenKey];
    [dictionary setValue:[NSNumber numberWithInteger:self.orderAmountDue] forKey:OrderAmountDueKey];
    
    [dictionary setValue:[NSNumber numberWithInteger:self.chargeAmount] forKey:OrderChargeAmountKey];
    [dictionary setValue:self.chargeCurrency forKey:OrderChargeCurrencyKey];
    //[dictionary setValue:self.chargeId forKey:ChargeIDKey];
    //[dictionary setValue:self.chargeToken forKey:OrderChargeTokenKey];
    [dictionary setValue:self.chargeDescription forKey:OrderChargeDescriptionKey];
    
    [dictionary setValue:self.chargePayType forKey:OrderPayTypeKey];
    //[dictionary setValue:self.chargePayCashAmount forKey:OrderPayCashAmountKey];
    //[dictionary setValue:self.orderPayCashChange forKey:OrderPayCashChangeKey];
    [dictionary setValue:self.chargeStatus forKey:OrderPayStatusKey];
    [dictionary setValue:[NSNumber numberWithInteger:self.orderDiscountPercent] forKey:OrderDiscountPercentKey];
    [dictionary setValue:[NSNumber numberWithInteger:self.orderDiscountAmount] forKey:OrderDiscountAmountKey];
    [dictionary setValue:self.orderDiscountCode forKey:OrderDiscountCodeKey];
    [dictionary setValue:@(self.orderTax) forKey:OrderTaxKey];
    [dictionary setValue:@(self.orderTotalTax) forKey:OrderTotalTaxKey];
    
    return dictionary;
    
    
}

-(NSString *)toChargeResponseString{
    NSMutableDictionary *response_dict=[[NSMutableDictionary alloc] init];
    
    NSDictionary *order_dict=[self toJSONDictionaryWithHash];
    NSString *message=[NSString new];
    if (self.errorMessage!=nil && self.errorMessage.length>0) {
        message=[self.errorMessage stringByAppendingString:@"\n"];
    }
    if(self.orderAmountDue>0){
        float orderAmountDue= self.orderAmountDue;
        if([self.orderNumber integerValue]>0){
        
            message=[message stringByAppendingString:[NSString stringWithFormat:@"Your %@order# %@.\nAmount Due: %.2f\nPlease pay remaining balance to complete this order. \nThank You.",(self.orderIsLive)?@"":@"Test ",self.orderNumber,orderAmountDue/100]];
        }
        else{
             //message=[message stringByAppendingString:[NSString stringWithFormat:@"Your %@order# %@.\nAmount Due: %.2f\nPlease pay remaining balance to complete this order. \nThank You.",(self.orderIsLive)?@"":@"Test ",self.orderNumber,orderAmountDue/100]];
        }
    }
    else{
       
         //message=[message stringByAppendingString:[NSString stringWithFormat:@"Your %@order# %@.\nYou will be notified when READY for pick-up.\nThank You.",(self.orderIsLive)?@"":@"",self.orderNumber]];
        message=[NSString stringWithFormat:@"Your %@order# %@.\nYou will be notified when READY for pick-up.\nThank You.",(self.orderIsLive)?@"":@"TEST ",self.orderNumber];
    }
    
    [response_dict setValue:@"charge" forKey:KEY_ACTION];
    [response_dict setValue:@{@"order":order_dict,@"message":message} forKey:KEY_ACTION_PARAM];
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

-(NSString *)toCancelOrderResponseString:(BOOL)success{
    NSString *message;
    if(success){
        message=[NSString stringWithFormat:@"Your order# %@ is cancelled.",self.orderNumber];

    }
    else{
        message=[NSString stringWithFormat:@"Sorry, there was an error cancelling your order# %@ . Please see customer service.",self.orderNumber];
    }
    NSMutableDictionary *response_dict=[[NSMutableDictionary alloc] init];
    
    NSDictionary *order_dict=[self toJSONDictionary];
    /*
     [response_dict setValue:@"charge" forKey:KEY_ACTION];
     [response_dict setValue:@{@"order":order_dict,@"message":message} forKey:KEY_ACTION_PARAM];
     [response_dict setValue:KEY_ACTION_TYPE_RESPONSE forKey:KEY_ACTION_TYPE];
     */
    [response_dict setValue:KEY_ACTION_CANCEL_ORDER forKey:KEY_ACTION];
    [response_dict setValue:@{@"order":order_dict,@"message":message} forKey:KEY_ACTION_PARAM];
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



-(NSString *)toStringLabel{
    
    NSString *result=[NSString new];
    
    
    NSString *orderItemsLabel=[self toStringLabelItems];
    
    NSString *userName=(_orderUserID==nil||_orderUserID==0)?@"guest":_orderUserName;
    //if(self.orderIsLive){
        if (self.orderCashBack>0) {
            if(self.orderIsRefunded){
                //result=[NSString stringWithFormat:@"%@\n%@ #%@\n%@ %@ %@\n%@\n%@\nChange: %.02f\n",self.orderBy,(self.orderIsLive)?@"ORDER":@"TEST", self.orderNumber,(self.orderIsPaid)?ORDER_ISPAID_LABEL:ORDER_ISNOTPAID_LABEL,ORDER_STATUS_REFUND_LABEL, statusLabel, orderItemsLabel,payments,(double)self.orderCashBack/100];
                result=[NSString stringWithFormat:@"%@(%@)\n%@ #%@\n%@",self.orderBy,userName,(self.orderIsLive)?@"ORDER":@"TEST", self.orderNumber,orderItemsLabel];
            }
            else{
                result=[NSString stringWithFormat:@"%@(%@)\n%@ #%@\n%@",self.orderBy,userName,(self.orderIsLive)?@"ORDER":@"TEST", self.orderNumber,orderItemsLabel];
            }
            
        }
        else{
            if(self.orderIsRefunded){
                result=[NSString stringWithFormat:@"%@(%@)\n%@ #%@\n%@",self.orderBy,userName,(self.orderIsLive)?@"ORDER":@"TEST", self.orderNumber,orderItemsLabel];
            }
            else{
                result=[NSString stringWithFormat:@"%@(%@)\n%@ #%@\n%@",self.orderBy,userName,(self.orderIsLive)?@"ORDER":@"TEST", self.orderNumber,orderItemsLabel];
            }
        }
        
   
    return result;
}

-(NSString *)toStringReceipt{
    AppDelegate *_appDelegate=ApplicationDelegate;
    NSString *header=[NSString stringWithFormat:@"%@\n%@\n%@",_appDelegate.appConfig.device_name,_appDelegate.appConfig.device_address,_appDelegate.appConfig.device_phone];
    NSString *body= [self toStringLabelItems];
    NSString *footer=@"THANK YOU";
    NSString *page=[NSString stringWithFormat:@"%@\n%@\n%@",header,body,footer];
    return page;
}

+(NSString *) statusToString:(NSInteger) status{
    NSString *statusLabel=[NSString new];
    switch (status) {
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
        case ORDER_STATUS_CLOSED:
            statusLabel=ORDER_STATUS_CLOSED_LABEL;
            break;
        case ORDER_STATUS_CANC:
            statusLabel=ORDER_STATUS_CANC_LABEL;
            break;
        case ORDER_STATUS_FAILED:
            statusLabel=ORDER_STATUS_FAILED_LABEL;
            break;
            
            /* case ORDER_STATUS_REFUND:
             statusLabel=ORDER_STATUS_REFUND_LABEL;
             break;
             */
            
        default:
            statusLabel=ORDER_STATUS_UNKNOWN_LABEL;
            break;
    }

    return statusLabel;
}

-(NSString *)toStringLabelItems{
    
    NSString *result=[NSString new];
    
    //if(item.orderNumber!=nil || item.orderNumber!=0){
    
    
    NSString *orderItemsLabel=[NSString new];
    
    NSInteger total=0;
    NSInteger subtotal=0;
    NSInteger totaltax=0;
    NSInteger totaldiscount=0;
    NSInteger totaloptions=0;
    
    if(self.orderItems!=nil && [self.orderItems count]>0){
        for (OrderItem *oi in self.orderItems) {
            
            //start subtotal
            
            
            if ([oi.options count]>0){
                for(OrderOptionItem *ooi in oi.options){
                    totaloptions=totaloptions+ooi.addlCost;
                }
                
            }
            
            //subtotal=subtotal+(oi.price*oi.quantity);
            subtotal=subtotal+((oi.price+totaloptions)*oi.quantity);
            
            
            //display quantity,name,price
            if(oi.price!=0){
                orderItemsLabel=[orderItemsLabel stringByAppendingFormat:@"\n%lu %@ @%@\n",(unsigned long)oi.quantity,oi.name,[Util priceIntToString:oi.price currency:nil]];
            }
            else{
                orderItemsLabel=[orderItemsLabel stringByAppendingFormat:@"%lu %@\n",(unsigned long)oi.quantity,oi.name];
            }
            if ([oi.options count]>0){
                NSString *options=@"";
                for(OrderOptionItem *ooi in oi.options){
                    if(ooi.addlCost>0){
                    NSString *priceString= [Util priceIntToString:ooi.addlCost  currency:nil];//[Util priceToString:(double)ooi.price/100  currency:self.chargeCurrency];
                    //NSString *quantity=(orderItem.quantity>1)?[NSString stringWithFormat:@" @%@x",@(orderItem.quantity)]:@"";
                    options=[NSString stringWithFormat:@"%@%@...@%@\n", options,ooi.title,priceString];
                    }
                    else{
                     options=[NSString stringWithFormat:@"%@%@\n", options,ooi.title];
                    }
                }
                orderItemsLabel=[orderItemsLabel stringByAppendingFormat:@"%@",options];
            }

            
            if(oi.notes!=nil & oi.notes.length>0)
                orderItemsLabel=[orderItemsLabel stringByAppendingFormat:@"\"%@\"\n",oi.notes];
            
            
        }
        
        if([self.orderDiscounts count]>0){
            for(DiscountItem *di in self.orderDiscounts){
                
                
                
                totaldiscount=totaldiscount+di.price;
                
                
                
                orderItemsLabel=[orderItemsLabel stringByAppendingFormat:@"%@ %@ -%.02f\n",di.name,di.discountID, (double)totaldiscount/100];
            }
            subtotal=subtotal-totaldiscount;
            orderItemsLabel=[orderItemsLabel stringByAppendingFormat:@"Discounts: %.02f\n",(double)totaldiscount/100];
        }

        
        
        self.orderSubtotal=subtotal;
        /*if (subtotal>0) {
         orderItemsLabel=[orderItemsLabel stringByAppendingFormat:@"Subtotal: %.02f\n",(double)self.orderSubtotal/100];
         }
         */
        float f_subtotal=(float)subtotal/100;
        f_subtotal=round(f_subtotal*100)/100;
        
        //totaltax=subtotal*(self.orderTax/100);
        float f_tax=(float)self.orderTax/100;
        f_tax=round(f_tax*100)/100;
        
        float f_totaltax=f_subtotal*f_tax;
        f_totaltax=round(f_totaltax*100)/100;
        totaltax=f_totaltax*100;
        self.orderTotalTax=totaltax;
        
        if(totaltax>0){
            orderItemsLabel=[orderItemsLabel stringByAppendingFormat:@"\nTax: %.02f @%.02f%%\n",(double)self.orderTotalTax/100,self.orderTax];
            //orderItemsLabel=[orderItemsLabel stringByAppendingFormat:@"Total: %.02f",(double)[self total]/100];
        }
        
        if(self.orderTip>0){
            orderItemsLabel=[orderItemsLabel stringByAppendingFormat:@"\nTip: %.02f\n",(double)self.orderTip/100];
            
        }

        
        total=subtotal+totaltax+self.orderTip;
        self.orderTotal=total;
        orderItemsLabel=[orderItemsLabel stringByAppendingFormat:@"\nTotal: %.02f\n",(double)self.orderTotal/100];
        
        
        
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
            
            if([payType isEqualToString:ORDER_PAY_TYPE_CCARD]){
                if(self.orderIsCaptured){
                    payType=[NSString stringWithFormat:@"%@ %@",payType,@"AUTH"];
                }
                else{
                    payType=[NSString stringWithFormat:@"%@ %@",payType,@"PAUTH"];
                }
                payments=[payments stringByAppendingString:[NSString stringWithFormat:@"%@-%@ %.02f\n",
                                                            payType,
                                                            [pitem valueForKey:KEY_CARD4],
                                                            (double)amount/100
                                                            ]];
            }
            else if ([payType isEqualToString:ORDER_PAY_TYPE_CASH]){
                payments=[payments stringByAppendingString:[NSString stringWithFormat:@"%@ %.02f\n",
                                                            payType,
                                                            (double)amount/100]];
                
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
    
    orderItemsLabel=[orderItemsLabel stringByAppendingFormat:@"Amount due: %.02f\n",(double)self.orderAmountDue/100];
    
    
    
    
    
    
    
    
    NSString *statusLabel=[OrderHistory statusToString:[self.orderStatus integerValue]]; //[NSString new];
    /*switch ([self.orderStatus intValue]) {
            
        case ORDER_STATUS_START:
            statusLabel=ORDER_STATUS_START_LABEL;
            break;
        case ORDER_STATUS_RECEIVED:
            statusLabel=ORDER_STATUS_RECEIVED_LABEL;
            break;
            
        case ORDER_STATUS_READY:
            statusLabel=ORDER_STATUS_READY_LABEL;
            break;
        case ORDER_STATUS_CLOSED:
            statusLabel=ORDER_STATUS_CLOSED_LABEL;
            break;
        case ORDER_STATUS_CANC:
            statusLabel=ORDER_STATUS_CANC_LABEL;
            break;
        case ORDER_STATUS_FAILED:
            statusLabel=ORDER_STATUS_FAILED_LABEL;
            break;
            
            
        default:
            statusLabel=ORDER_STATUS_UNKNOWN_LABEL;
            break;
    }
    */
    
    //if(self.orderIsLive){
    if (self.orderCashBack>0) {
        if(self.orderIsRefunded){
            result=[NSString stringWithFormat:@"%@ %@ %@\n%@\n%@\nChange: %.02f\n",(self.orderIsPaid)?ORDER_ISPAID_LABEL:ORDER_ISNOTPAID_LABEL,ORDER_STATUS_REFUND_LABEL, statusLabel, orderItemsLabel,payments,(double)self.orderCashBack/100];
        }
        else{
            result=[NSString stringWithFormat:@"%@ %@\n%@\n%@\nChange: %.02f\n",(self.orderIsPaid)?ORDER_ISPAID_LABEL:ORDER_ISNOTPAID_LABEL,statusLabel, orderItemsLabel,payments,(double)self.orderCashBack/100];
        }
        
    }
    else{
        if(self.orderIsRefunded){
            result=[NSString stringWithFormat:@"%@ %@ %@\n%@\n%@",(self.orderIsPaid)?ORDER_ISPAID_LABEL:ORDER_ISNOTPAID_LABEL,ORDER_STATUS_REFUND_LABEL, statusLabel,orderItemsLabel,payments];
        }
        else{
            result=[NSString stringWithFormat:@"%@ %@\n%@\n%@",(self.orderIsPaid)?ORDER_ISPAID_LABEL:ORDER_ISNOTPAID_LABEL,statusLabel,orderItemsLabel,payments];
        }
    }
    
    //}
    /*else{
     
     if (self.orderCashBack>0) {
     if(self.orderIsRefunded){
     result=[NSString stringWithFormat:@"%@\nTEST ORDER #%@\n%@ %@ %@\n%@\n%@\nChange: %.02f\n",self.orderBy, self.orderNumber,(self.orderIsPaid)?ORDER_ISPAID_LABEL:ORDER_ISNOTPAID_LABEL,ORDER_STATUS_REFUND_LABEL, statusLabel, orderItemsLabel,payments,(double)self.orderCashBack/100];
     }
     else{
     result=[NSString stringWithFormat:@"%@\nTEST ORDER #%@\n%@ %@\n%@\n%@\nChange: %.02f\n",self.orderBy, self.orderNumber,(self.orderIsPaid)?ORDER_ISPAID_LABEL:ORDER_ISNOTPAID_LABEL,statusLabel, orderItemsLabel,payments,(double)self.orderCashBack/100];
     }
     }
     else{
     if(self.orderIsRefunded){
     result=[NSString stringWithFormat:@"%@\nTEST ORDER #%@\n%@ %@ %@\n%@\n%@",self.orderBy, self.orderNumber,(self.orderIsPaid)?ORDER_ISPAID_LABEL:ORDER_ISNOTPAID_LABEL,ORDER_STATUS_REFUND_LABEL, statusLabel,orderItemsLabel,payments];
     }
     else{
     result=[NSString stringWithFormat:@"%@\nTEST ORDER #%@\n%@ %@\n%@\n%@",self.orderBy, self.orderNumber,(self.orderIsPaid)?ORDER_ISPAID_LABEL:ORDER_ISNOTPAID_LABEL,statusLabel,orderItemsLabel,payments];
     }
     }
     }
     */
    
    return result;
}

//this one goes to the charge
-(NSString *)toChargeDescription{
    
    NSString *result=[NSString new];
    
    //if(item.orderNumber!=nil || item.orderNumber!=0){
    
    
    NSString *orderItemsLabel=[NSString new];
    
    NSInteger total=0;
    NSInteger subtotal=0;
    NSInteger totaltax=0;
    NSInteger totaldiscount=0;
    
     
    if(self.orderItems!=nil && [self.orderItems count]>0){
        for (OrderItem *oi in self.orderItems) {
            subtotal=subtotal+(oi.price*oi.quantity);
            orderItemsLabel=[orderItemsLabel stringByAppendingFormat:@"%lu %@ @%.02f\n",(unsigned long)oi.quantity,oi.name,(double)oi.price/100];
            if(oi.notes!=nil & oi.notes.length>0)
                orderItemsLabel=[orderItemsLabel stringByAppendingFormat:@"    %@\n",oi.notes];
            
            
        }
        
        if([self.orderDiscounts count]>0){
            for(DiscountItem *di in self.orderDiscounts){
                totaldiscount=totaldiscount+di.price;
                orderItemsLabel=[orderItemsLabel stringByAppendingFormat:@"%@ %@ -%.02f\n",di.name,di.discountID, (double)totaldiscount/100];
            }
            subtotal=subtotal-totaldiscount;
            orderItemsLabel=[orderItemsLabel stringByAppendingFormat:@"Discounts: %.02f\n",(double)totaldiscount/100];
        }
        
        
        
        self.orderSubtotal=subtotal;
        
        totaltax=subtotal*(self.orderTax/100);
        self.orderTotalTax=totaltax;
        
        if(totaltax>0){
            orderItemsLabel=[orderItemsLabel stringByAppendingFormat:@"Tax: %.02f @%.02f%%\n",(double)self.orderTotalTax/100,self.orderTax];
            //orderItemsLabel=[orderItemsLabel stringByAppendingFormat:@"Total: %.02f",(double)[self total]/100];
        }
        
        if(self.orderTip>0){
            orderItemsLabel=[orderItemsLabel stringByAppendingFormat:@"Tip: %.02f\n",(double)self.orderTip/100];
            
        }
        
        
        total=subtotal+totaltax+self.orderTip;
        self.orderTotal=total;
        orderItemsLabel=[orderItemsLabel stringByAppendingFormat:@"Total: %.02f\n",(double)self.orderTotal/100];
        
        
        
    }
    
    return result;
}

-(void)reHash{
    
    NSData *data=[NSKeyedArchiver archivedDataWithRootObject:[self toJSONDictionary]];
    
    self.orderHash=[data MD5];
    //return hashed;
}






@end
