//
//  PaymentManager.m
//  superkiosks
//
//  Created by Katherine Sheehy on 4/8/16.
//  Copyright © 2016 Sharecle. All rights reserved.
//

#import "PaymentManager.h"
#import "OrderHistory.h"
#import "InventoryModel.h"
#import "Product.h"
#import "OrderItem.h"
/*
@interface PaymentManager(){
    AppDelegate *_appDelegate;
    
}
@end
*/
@implementation PaymentManager
/*
- (id)init {
    self = [super init];
    if (self) {
        _appDelegate=ApplicationDelegate;
        
    }
    return self;
}
*/
+ (PaymentManager *)sharedInstance {
    static PaymentManager*  _sharedObject;
    
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        _sharedObject = [[PaymentManager alloc] init];
        
        
    });
    
    return _sharedObject;
}


//-(BOOL)performPostCharge:(OrderHistory *)order cardInfo:(STPCard *)card isPreauth:(BOOL)isPreauth fromPeer:(PeerInfo *)peerInfo{
  +(BOOL)performPostCharge:(OrderHistory *)order cardInfo:(STPCard *)card isCaptured:(BOOL)captured{
    //order.chargeToken=token.tokenId;
      AppDelegate *_appDelegate= ApplicationDelegate;
    BOOL success=NO;
    order.orderIsPaid=NO;
      order.orderIsCaptured=captured;
    NSDictionary *result=nil;
    
    //if([order.chargePayType isEqualToString:ORDER_PAY_TYPE_CCARD]){
    
    //TODO: implement cashback
    if(order.chargeAmount>order.orderAmountDue)
        order.chargeAmount=order.orderAmountDue;
    
    //this is just a predicted order number
    NSInteger tmp_orderNumber=[order.orderNumber integerValue];
    if(tmp_orderNumber==0){
        tmp_orderNumber=_appDelegate.historyModel.lastOrderNumber+1;
    }
    
      order.chargeDescription=[NSString stringWithFormat:@"%@",[order toChargeDescription]];/*[NSString stringWithFormat:@"tmp_order_number: %li oder_id: %@ store_num: %@ store_id: %@ store_name: %@"
                             ,(long)tmp_orderNumber
                             ,order.orderID
                             ,@(_appDelegate.appConfig.device_num)
                             ,(_appDelegate.appConfig.device_id.length>8)?[_appDelegate.appConfig.device_id substringToIndex:8]:@""
                             ,_appDelegate.appConfig.device_name];
                             */
      
      NSMutableArray *metaData=[NSMutableArray arrayWithCapacity:4];
      metaData[0]=[NSString stringWithFormat:@"metadata[tmp_order_number]=%li",(long)tmp_orderNumber];
      metaData[1]=[NSString stringWithFormat:@"metadata[oder_id]=%@",order.orderID];
      metaData[2]=[NSString stringWithFormat:@"metadata[store_num]=%@",@(_appDelegate.appConfig.device_num)];
      metaData[3]=[NSString stringWithFormat:@"metadata[store_id]=%@",(_appDelegate.appConfig.device_id.length>8)?[_appDelegate.appConfig.device_id substringToIndex:8]:@""];
      //rom: we need to replace any occurce of "&"  to "%26" or we get failed response
      
      NSString *device_name=[_appDelegate.appConfig.device_name stringByReplacingOccurrencesOfString:@"&" withString:@"%26"];
      
      
      metaData[4]=[NSString stringWithFormat:@"metadata[store_name]=%@",device_name];
      
                   NSString *chargeMetaData=[NSString stringWithFormat:@"%@&%@&%@&%@&%@",metaData[0],metaData[1],metaData[2],metaData[3],metaData[4]];
                   
    NSString *postRequestString;
    if(captured){
        postRequestString=[NSString stringWithFormat:@"amount=%li&currency=%@&source=%@&description=%@&%@",(long)order.chargeAmount,order.chargeCurrency,order.chargeToken,order.chargeDescription,chargeMetaData];
    }
    else{
        postRequestString=[NSString stringWithFormat:@"amount=%li&currency=%@&capture=false;&source=%@&description=%@&%@",(long)order.chargeAmount,order.chargeCurrency,order.chargeToken,order.chargeDescription,chargeMetaData];
    }
    if(order.chargeAmount>0){
        result=[self charge:postRequestString];
        success=[[result valueForKey:@"Success"] boolValue];
    }
    else{
        result=@{@"Result":@"Success. No charge was made."};
        success=YES;
    }
    
      
    if(success){
        
        order.orderIsPaid=YES;
        
        id obj_response_result=[result valueForKey:@"Result"];
        if (![obj_response_result isKindOfClass:[NSDictionary class]]) {
#ifdef DEBUG
            
                NSLog(@"Although the charge is successful we did not detect charge id. Therefore we cannot refund.");
            
#endif

            return success;
        }
        NSDictionary *response_result=(NSDictionary *)obj_response_result;
        if(response_result==nil)
            return success;
        //@try{
        //NSArray *allKeys= [response_result allKeys];
        //if([allKeys containsObject:@"id"]){
            NSString *chargeId=DICT_GET(response_result, @"id");
            if(![chargeId isEqual:[NSNull null]] &&  chargeId!=nil){
            
                order.chargeId=[response_result valueForKey:@"id"];
            }
       //}
        /*}
        @catch(NSException ex){
            //return ;
            //[AppDelegate toast:@"chargeId not provided" duration:<#(int)#>
            
        }
        */
#ifdef DEBUG
        if (result!=nil) {
            NSLog(@"Result(Success): %@",[result valueForKey:@"Result"]);
        }
#endif
        
        //[self performChargeSuccess:order cardInfo:card fromPeer:peerInfo];
        return YES;
        
    }
    else{
        order.orderIsPaid=NO;
        order.errorMessage=[result valueForKey:@"Error"];
#ifdef DEBUG
        
        NSLog(@"Chareg Error: %@",[result valueForKey:@"Error"]);
        
        NSLog(@"Result(Error): %@",[result valueForKey:@"Result"]);
        
#endif
        
        
        //[self performChargeFail:order fromPeer:peerInfo];
        return NO;
    }
    
}

+(NSDictionary *)charge:(NSString *)requestString{
    //if (!_appDelegate.appConfig.paymentSecretKey) {
    //   return nil;
    //}
    /*NSString* stripeAmount = [request.arguments objectForKey:@"stripeAmount"];
     NSString* stripeCurrency = [request.arguments objectForKey:@"stripeCurrency"];
     NSString* stripeToken = [request.arguments objectForKey:@"stripeToken"];
     NSString* stripeDescription = [request.arguments objectForKey:@"stripeDescription"];
     */
    
    
    //NSString *STRIPE_POST_URL=@"https://api.stripe.com/v1/charges";
    //NSString *STRIPE_API_KEY=@"***REMOVED***";
    
    //NSData *nsdata=[STRIPE_API_KEY dataUsingEncoding:NSUTF8StringEncoding];
    
    //NSData *nsdata=[NSData dataWithBytes:[STRIPE_API_KEY UTF8String] length:[STRIPE_API_KEY length]];
     AppDelegate *_appDelegate= ApplicationDelegate;
    NSData *nsdata;
    if((_appDelegate.appConfig.visibility==VISIBILITY_LIVE)?YES:NO){
        if (!_appDelegate.appConfig.paymentSecretKey)
            return nil;
        
        nsdata=[NSData dataWithBytes:[_appDelegate.appConfig.paymentSecretKey UTF8String] length:[_appDelegate.appConfig.paymentSecretKey length]];
    }
    else{
        if (!_appDelegate.appConfig.paymentSecretKeyTest)
            return nil;
        nsdata=[NSData dataWithBytes:[_appDelegate.appConfig.paymentSecretKeyTest UTF8String] length:[_appDelegate.appConfig.paymentSecretKeyTest length]];
        
    }
    
    NSString *base64EncodedAPIKEY=[nsdata base64EncodedStringWithOptions:0];
    
    //NSLog([NSString stringWithFormat:@"base64EncodedAPIKEY: %@",base64EncodedAPIKEY]);
    
    //1
    // NSURL *postURL = [NSURL URLWithString:_appDelegate.appConfig.paymentPostUrl];
    NSURL *postURL = [NSURL URLWithString:_appDelegate.appConfig.paymentPostUrl];//[NSURL URLWithString:(_appDelegate.appConfig.paymentPostUrl)?_appDelegate.appConfig.paymentPostUrl:STRIPE_POST_URL];
    NSError* err = nil;
    
    //NSString *requestString=[NSString stringWithFormat:@"amount=%@&currency=%@&source=%@&description=%@",stripeAmount,stripeCurrency,stripeToken,@"description..."];
    
    //NSLog([NSString stringWithFormat:@"requestString: %@",requestString]);
    
    NSData *requestData=[NSData dataWithBytes:[requestString UTF8String] length:[requestString length]];
    
    NSMutableURLRequest *postRequest=[[NSMutableURLRequest alloc] initWithURL:postURL];
    
    [postRequest setHTTPMethod:@"POST"];
    [postRequest setValue:[NSString stringWithFormat: @"Basic %@",base64EncodedAPIKEY] forHTTPHeaderField:@"Authorization"];
    [postRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"content-type"];
    
    //[postRequest setValue:@"text/json" forHTTPHeaderField:@"Accept"];
    
    
    
    [postRequest setHTTPBody:requestData];
    
    NSURLResponse *response;
    //NSError *err;
    NSData *jsonData=[NSURLConnection sendSynchronousRequest:postRequest returningResponse:&response error:&err];
    
    //we will use json instead: NSString *content=[NSString stringWithUTF8String:[jsonData bytes]];
    NSMutableDictionary *jsonResult=[NSMutableDictionary new];
    
    NSDictionary *JSON = [NSJSONSerialization JSONObjectWithData:jsonData
                                                         options:kNilOptions
                                                           error:&err];
    
    if(err==nil){
        NSDictionary *err_dict=[JSON valueForKey:@"error"];
        if(err_dict!=nil){
            [jsonResult setValue:@0 forKey:@"Success"];
            //[jsonResult setValue:[err_dict valueforKey:@"message"]];
            [jsonResult setValue:[err_dict valueForKey:@"message"] forKey:@"Error"];
        }
        else {
            [jsonResult setValue:@1 forKey:@"Success"];
            //[jsonResult setValue:@"" forKey:@"Error"];
            [jsonResult setValue:JSON forKey:@"Result"];
            
        }
        return jsonResult;//JSON;//[GCDWebServerDataResponse responseWithJSONObject:JSON];
    }
    else{
        [jsonResult setValue:@0 forKey:@"Success"];
        [jsonResult setValue:err.localizedDescription forKey:@"Error"];
        [jsonResult setValue:JSON forKey:@"Result"];
        return jsonResult;
    }
    
    
}

+(NSDictionary *)capture:(OrderHistory *)order{
    
    /*NSString* stripeAmount = [request.arguments objectForKey:@"stripeAmount"];
     NSString* stripeCurrency = [request.arguments objectForKey:@"stripeCurrency"];
     NSString* stripeToken = [request.arguments objectForKey:@"stripeToken"];
     NSString* stripeDescription = [request.arguments objectForKey:@"stripeDescription"];
     */
    
    
    //NSString *STRIPE_POST_URL=@"https://api.stripe.com/v1/charges";
    //refund
    //https://api.stripe.com/v1/charges/{charge_id}/refunds
    
    //NSString *STRIPE_API_KEY=@"***REMOVED***";
    
    //NSData *nsdata=[STRIPE_API_KEY dataUsingEncoding:NSUTF8StringEncoding];
    
    //NSData *nsdata=[NSData dataWithBytes:[STRIPE_API_KEY UTF8String] length:[STRIPE_API_KEY length]];
    AppDelegate *appDelegate=ApplicationDelegate;
    
    NSMutableDictionary *jsonResult=[NSMutableDictionary new];
    
    if(order.chargeId==nil || order.chargeId.length==0)
    {
        /*
         UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Error" message:@"Selected transaction is not refundable. Missing charge identifier." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
         [alert show];
         return nil;
         */
        [jsonResult setValue:@0 forKey:@"Success"];
        [jsonResult setValue:@"Missing charge identifier." forKey:@"Error"];
        [jsonResult setValue:nil forKey:@"Result"];
        return jsonResult;
    }
    NSString *refundUrl=[NSString stringWithFormat:@"https://api.stripe.com/v1/charges/%@/capture",order.chargeId];
    
    NSData *nsdata;
    //if(_appDelegate.appConfig.device_status==DEVICE_STATUS_LIVE){
    if(order.orderIsLive){
        if (!appDelegate.appConfig.paymentSecretKey)
            return nil;
        
        nsdata=[NSData dataWithBytes:[appDelegate.appConfig.paymentSecretKey UTF8String] length:[appDelegate.appConfig.paymentSecretKey length]];
        
    }
    else{
        if (!appDelegate.appConfig.paymentSecretKeyTest)
            return nil;
        
        nsdata=[NSData dataWithBytes:[appDelegate.appConfig.paymentSecretKeyTest UTF8String] length:[appDelegate.appConfig.paymentSecretKeyTest length]];
    }
    
    NSString *base64EncodedAPIKEY=[nsdata base64EncodedStringWithOptions:0];
    
    //NSLog([NSString stringWithFormat:@"base64EncodedAPIKEY: %@",base64EncodedAPIKEY]);
    
    //1
    // NSURL *postURL = [NSURL URLWithString:_appDelegate.appConfig.paymentPostUrl];
    NSURL *postURL = [NSURL URLWithString:refundUrl];//[NSURL URLWithString:_appDelegate.appConfig.refundPostUrl];//[NSURL URLWithString:(_appDelegate.appConfig.paymentPostUrl)?_appDelegate.appConfig.paymentPostUrl:STRIPE_POST_URL];
    NSError* err = nil;
    
    //NSString *requestString=[NSString stringWithFormat:@"amount=%@&currency=%@&source=%@&description=%@",stripeAmount,stripeCurrency,stripeToken,@"description..."];
    
    //NSLog([NSString stringWithFormat:@"requestString: %@",requestString]);
    
    // NSData *requestData=[NSData dataWithBytes:[requestString UTF8String] length:[requestString length]];
    
    NSMutableURLRequest *postRequest=[[NSMutableURLRequest alloc] initWithURL:postURL];
    
    [postRequest setHTTPMethod:@"POST"];
    [postRequest setValue:[NSString stringWithFormat: @"Basic %@",base64EncodedAPIKEY] forHTTPHeaderField:@"Authorization"];
    [postRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"content-type"];
    
    //[postRequest setValue:@"text/json" forHTTPHeaderField:@"Accept"];
    
    
    
    //[postRequest setHTTPBody:requestData];
    
    NSURLResponse *response;
    //NSError *err;
    NSData *jsonData=[NSURLConnection sendSynchronousRequest:postRequest returningResponse:&response error:&err];
    
    //we will use json instead: NSString *content=[NSString stringWithUTF8String:[jsonData bytes]];
    
    
    NSDictionary *JSON = [NSJSONSerialization JSONObjectWithData:jsonData
                                                         options:kNilOptions
                                                           error:&err];
    
    if(err==nil){
        
        [jsonResult setValue:@1 forKey:@"Success"];
        //[jsonResult setValue:@"" forKey:@"Error"];
        [jsonResult setValue:JSON forKey:@"Result"];
        
        return jsonResult;//JSON;//[GCDWebServerDataResponse responseWithJSONObject:JSON];
    }
    else{
        [jsonResult setValue:@0 forKey:@"Success"];
        [jsonResult setValue:err.localizedDescription forKey:@"Error"];
        [jsonResult setValue:JSON forKey:@"Result"];
        return jsonResult;
    }
    
    
}

+(NSString *)performPostRefund:(OrderHistory *)order{// fromPeer:(PeerInfo *)peerInfo{
    
    //order.chargeToken=token.tokenId;
    AppDelegate *appDelegate=ApplicationDelegate;
    BOOL success=NO;
    //order.orderIsPaid=NO;
    NSDictionary *result=nil;
    
    if([order.chargePayType isEqualToString:ORDER_PAY_TYPE_CCARD]){
        
        //TODO: implement cashback
        //if(order.chargeAmount>order.orderAmountDue)
        //  order.chargeAmount=order.orderAmountDue;
        
        
        
        //NSString *postRequestString=[NSString stringWithFormat:@"amount=%i&currency=%@&source=%@&description=%@\n%@",order.chargeAmount,order.chargeCurrency,order.chargeToken,order.orderID,order.orderDetailText];
        
        result=[PaymentManager refund:order];
        
        success=[[result valueForKey:@"Success"] boolValue];
    }
    else{
        success=YES;
    }
    
    if(success){
        
        order.orderStatus=@ORDER_STATUS_CANC;//@ORDER_STATUS_REFUND;
        //order.orderIsPaid=YES;
        order.orderIsRefunded=YES;
        //order.order
#ifdef DEBUG
        if (result!=nil) {
            NSLog(@"Result(Success): %@",[result valueForKey:@"Result"]);
        }
#endif
        
        //[self performChargeSuccess:order cardInfo:card fromPeer:peerInfo];
        [appDelegate.historyModel saveHistory];
        
        //return inventory
        [PaymentManager returnOrder:order];
        return nil;
        
    }
    else{
        /*UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Error" message:[result valueForKey:@"Error"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
         [alert show];
         */
        return ([result valueForKey:@"Error"]==nil)?@"Unknown error":[result valueForKey:@"Error"];
    }
    
}

+(NSDictionary *)refund:(OrderHistory *)order{
    
    /*NSString* stripeAmount = [request.arguments objectForKey:@"stripeAmount"];
     NSString* stripeCurrency = [request.arguments objectForKey:@"stripeCurrency"];
     NSString* stripeToken = [request.arguments objectForKey:@"stripeToken"];
     NSString* stripeDescription = [request.arguments objectForKey:@"stripeDescription"];
     */
    
    
    //NSString *STRIPE_POST_URL=@"https://api.stripe.com/v1/charges";
    //refund
    //https://api.stripe.com/v1/charges/{charge_id}/refunds
    
    //NSString *STRIPE_API_KEY=@"***REMOVED***";
    
    //NSData *nsdata=[STRIPE_API_KEY dataUsingEncoding:NSUTF8StringEncoding];
    
    //NSData *nsdata=[NSData dataWithBytes:[STRIPE_API_KEY UTF8String] length:[STRIPE_API_KEY length]];
    AppDelegate *appDelegate=ApplicationDelegate;
    
    NSMutableDictionary *jsonResult=[NSMutableDictionary new];
    
    if(order.chargeId==nil || order.chargeId.length==0)
    {
        /*
         UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Error" message:@"Selected transaction is not refundable. Missing charge identifier." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
         [alert show];
         return nil;
         */
        [jsonResult setValue:@0 forKey:@"Success"];
        [jsonResult setValue:@"Missing charge identifier." forKey:@"Error"];
        [jsonResult setValue:nil forKey:@"Result"];
        return jsonResult;
    }
    NSString *refundUrl=[NSString stringWithFormat:@"https://api.stripe.com/v1/charges/%@/refunds",order.chargeId];
    
    NSData *nsdata;
    //if(_appDelegate.appConfig.device_status==DEVICE_STATUS_LIVE){
    if(order.orderIsLive){
        if (!appDelegate.appConfig.paymentSecretKey)
            return nil;
        
        nsdata=[NSData dataWithBytes:[appDelegate.appConfig.paymentSecretKey UTF8String] length:[appDelegate.appConfig.paymentSecretKey length]];
        
    }
    else{
        if (!appDelegate.appConfig.paymentSecretKeyTest)
            return nil;
        
        nsdata=[NSData dataWithBytes:[appDelegate.appConfig.paymentSecretKeyTest UTF8String] length:[appDelegate.appConfig.paymentSecretKeyTest length]];
    }
    
    NSString *base64EncodedAPIKEY=[nsdata base64EncodedStringWithOptions:0];
    
    //NSLog([NSString stringWithFormat:@"base64EncodedAPIKEY: %@",base64EncodedAPIKEY]);
    
    //1
    // NSURL *postURL = [NSURL URLWithString:_appDelegate.appConfig.paymentPostUrl];
    NSURL *postURL = [NSURL URLWithString:refundUrl];//[NSURL URLWithString:_appDelegate.appConfig.refundPostUrl];//[NSURL URLWithString:(_appDelegate.appConfig.paymentPostUrl)?_appDelegate.appConfig.paymentPostUrl:STRIPE_POST_URL];
    NSError* err = nil;
    
    //NSString *requestString=[NSString stringWithFormat:@"amount=%@&currency=%@&source=%@&description=%@",stripeAmount,stripeCurrency,stripeToken,@"description..."];
    
    //NSLog([NSString stringWithFormat:@"requestString: %@",requestString]);
    
    // NSData *requestData=[NSData dataWithBytes:[requestString UTF8String] length:[requestString length]];
    
    NSMutableURLRequest *postRequest=[[NSMutableURLRequest alloc] initWithURL:postURL];
    
    [postRequest setHTTPMethod:@"POST"];
    [postRequest setValue:[NSString stringWithFormat: @"Basic %@",base64EncodedAPIKEY] forHTTPHeaderField:@"Authorization"];
    [postRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"content-type"];
    
    //[postRequest setValue:@"text/json" forHTTPHeaderField:@"Accept"];
    
    
    
    //[postRequest setHTTPBody:requestData];
    
    NSURLResponse *response;
    //NSError *err;
    NSData *jsonData=[NSURLConnection sendSynchronousRequest:postRequest returningResponse:&response error:&err];
    
    //we will use json instead: NSString *content=[NSString stringWithUTF8String:[jsonData bytes]];
    
    
    NSDictionary *JSON = [NSJSONSerialization JSONObjectWithData:jsonData
                                                         options:kNilOptions
                                                           error:&err];
    
    if(err==nil){
        
        [jsonResult setValue:@1 forKey:@"Success"];
        //[jsonResult setValue:@"" forKey:@"Error"];
        [jsonResult setValue:JSON forKey:@"Result"];
        
        return jsonResult;//JSON;//[GCDWebServerDataResponse responseWithJSONObject:JSON];
    }
    else{
        [jsonResult setValue:@0 forKey:@"Success"];
        [jsonResult setValue:err.localizedDescription forKey:@"Error"];
        [jsonResult setValue:JSON forKey:@"Result"];
        return jsonResult;
    }
    
    
}

+(void)returnOrder:(OrderHistory *)order{
    InventoryModel *inventoryModel =[InventoryModel sharedInstance];
    //TOTDO: was mutade while being enumerated
    NSArray *tmpArray=[NSArray arrayWithArray:order.orderItems];
    NSMutableArray *products=[NSMutableArray new];
    for(OrderItem *item in tmpArray){
        //item.isUpdated=false;
        
        Product *searchProd=[inventoryModel searchAllProduct:item.productID];
        
        if(searchProd){
            if(searchProd.allowOutOfStock//!searchProd.stock_unlimited
               && searchProd.instock>0){
                searchProd.instock=searchProd.instock+item.quantity;
                [products addObject:searchProd];
            }
        }
        
    }
    //[inventoryModel saveInventoryWithItems:products];
    //[inventoryModel saveInventory];
}


+(NSString *)performPostCapture:(OrderHistory *)order{// fromPeer:(PeerInfo *)peerInfo{
    
    //order.chargeToken=token.tokenId;
    AppDelegate *appDelegate=ApplicationDelegate;
    BOOL success=NO;
    //order.orderIsPaid=NO;
    NSDictionary *result=nil;
    
    if([order.chargePayType isEqualToString:ORDER_PAY_TYPE_CCARD]){
        
        //TODO: implement cashback
        //if(order.chargeAmount>order.orderAmountDue)
        //  order.chargeAmount=order.orderAmountDue;
        
        
        
        //NSString *postRequestString=[NSString stringWithFormat:@"amount=%i&currency=%@&source=%@&description=%@\n%@",order.chargeAmount,order.chargeCurrency,order.chargeToken,order.orderID,order.orderDetailText];
        
        result=[PaymentManager capture:order];
        
        success=[[result valueForKey:@"Success"] boolValue];
    }
    else{
        success=YES;
    }
    
    if(success){
        
        order.orderIsCaptured=YES;//@ORDER_STATUS_REFUND;
        //order.orderIsPaid=YES;
        order.orderIsRefunded=YES;
        //order.order
#ifdef DEBUG
        if (result!=nil) {
            NSLog(@"Result(Success): %@",[result valueForKey:@"Result"]);
        }
#endif
        
        //[self performChargeSuccess:order cardInfo:card fromPeer:peerInfo];
        [appDelegate.historyModel saveHistory];
        
        
        return nil;
        
    }
    else{
        order.orderIsCaptured=NO;
        return ([result valueForKey:@"Error"]==nil)?@"Unknown error":[result valueForKey:@"Error"];
    }
    
}


@end
