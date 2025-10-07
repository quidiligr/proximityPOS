//
//  ConnectionManager.m
//  superkiosks
//
//  Created by Katherine Sheehy on 3/19/16.
//  Copyright © 2016 Sharecle. All rights reserved.
//

#import "ConnectionManager.h"
#import "AppDelegate.h"
#import "BroadcastMessageAPI.h"
#import "PeerInfo.h"
#import "RNEncryptor.h"
#import "RNDecryptor.h"
#import "AFNetworking.h"
#import "NSData+Conversion.h"
#import "InventoryModel.h"
#import "InventoryItem.h"
#import "AudioProcessor.h"
#import "CAudioBuffer.h"

#import "RWEmailManager.h"

 #import "Order.h"
 #import "OrderItem.h"
 #import "DiscountItem.h"
#import "PaymentManager.h"
//#import "MBProgressHUD.h"
#import "SoundController.h"
#import "Util.h"
//#import "Reachability.h"
#import "defs_order_product.h"
#import "defs.h"


@interface ConnectionManager(){
    AppDelegate *_appDelegate;
    AFHTTPClient *_client;
    InventoryItem *_selectedInventory;
    NSString *_documentsDirectory;
    AudioProcessor *_audioProcessor;
    SoundController *_soundController;
    //PaymentManager *_paymentManager;
}
@end

@implementation ConnectionManager

-(instancetype)init{
    self = [super init];
    if (self) {
        _appDelegate=ApplicationDelegate;
        _selectedInventory=_appDelegate.inventoryModel.inventory;//[InventoryModel activeInventory];
        _soundController=[SoundController sharedInstance];
        //_paymentManager=[PaymentManager sharedInstance];
        [self enableNotifications];
        
       
        //get the number of unclose orders
        NSPredicate *predicate=[NSPredicate predicateWithFormat:@"orderIsPaid=YES AND (orderStatus=%d OR orderStatus=%d)",ORDER_STATUS_READY,ORDER_STATUS_RECEIVED];
        //[_appDelegate.historyModel.history]
       //_appDelegate.badgeOrderNumber=0;
        NSArray *historyDates=[[_appDelegate.historyModel.history allKeys] sortedArrayUsingSelector:@selector(compare:)];
        
        
        
        if ([historyDates count]>0) {
            
            NSArray *orders;
            for(NSString *day in historyDates){
                orders=[_appDelegate.historyModel.history valueForKey:day];
                NSArray *results=[orders filteredArrayUsingPredicate:predicate];
                if([results count]>0){
                    //_appDelegate.badgeOrderNumber=_appDelegate.badgeOrderNumber+[results count];
                }
                
                
            }
            
            //get last ordernumber
            if(orders!=nil && [orders count]>0){
                OrderHistory *item=[orders lastObject];
                _appDelegate.historyModel.lastOrderNumber=[item.orderNumber unsignedIntegerValue];
            }
            
        }
        
        
        if(_appDelegate.historyModel.lastOrderNumber==0)
            _appDelegate.historyModel.lastOrderNumber=1;
        
        //[_appDelegate displayBadgeOrders];
        
    }
    return self;
}

-(void)enableNotifications{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didReceiveDataWithNotification:)
                                                 name:NOTIFY_RECEIVE_TEXT_DATA
                                               object:nil];
    
    /* [[NSNotificationCenter defaultCenter] addObserver:self
     selector:@selector(didPaidOrderWithNotification:)
     name:NOTIFY_SENT_PAID_ORDER
     object:nil];
     
     [[NSNotificationCenter defaultCenter] addObserver:self
     selector:@selector(didUnpaidOrderWithNotification:)
     name:NOTIFY_SENT_UNPAID_ORDER
     object:nil];
     
     */
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(performDeviceNotification:)
                                                 name:NOTIFY_DEVICE
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didReceiveLocalChargeNotification:)
                                                 name:NOTIFY_LOCAL_CHARGE
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didReceiveLocalOrderNotification:)
                                                 name:NOTIFY_LOCAL_ORDER
                                               object:nil];
    
    
    /*[[NSNotificationCenter defaultCenter] addObserver:self
     selector:@selector(didPaidOrderWithNotification:)
     name:NOTIFY_SENT_PAID_ORDER_FROM_SERVER
     object:nil];
     
     [[NSNotificationCenter defaultCenter] addObserver:self
     selector:@selector(didUnpaidOrderWithNotification:)
     name:NOTIFY_SENT_UNPAID_ORDER_FROM_SERVER
     object:nil];
     
     */
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(hasDataToSendWithNotification:)
                                                 name:NOTIFY_HAS_DATA_TO_SEND
                                               object:nil];
    
    
    //voice
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didReceiveVoiceDataWithNotification:)
                                                 name:@"MCDidReceiveVoiceDataNotification"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveMicInputNotification:) name:@"DidReceiveMicInputNotification" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveAudioSwitchNotification:) name:@"DidReceiveAudioSwitchNotification" object:nil];
    
    
    //file download/upload
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didStartReceivingResourceWithNotification:)
                                                 name:@"MCDidStartReceivingResourceNotification"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateReceivingProgressWithNotification:)
                                                 name:@"MCReceivingProgressNotification"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didFinishReceivingResourceWithNotification:)
                                                 name:@"didFinishReceivingResourceNotification"
                                               object:nil];
    
    //end file download/upload
    
   
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(peerDidChangeState:) name:@"MCDidChangeStateNotification" object:nil];
    
   /* [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(peerDidChangeStateUpdate:)                                                 name:NOTIFY_MCDIDCHANGESTATE_UPDATE
                                               object:nil];
    */
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didFinishReceivingResourceWithNotification:)
                                                 name:@"didFinishReceivingResourceNotificationForPeerPhoto"
                                               object:nil];
    
    /*[[NSNotificationCenter defaultCenter] addObserver:self
     selector:@selector(performDeviceNotification:)
     name:NOTIFY_DEVICE
     object:nil];
     */
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(performUpdateSettingsNotification:)
                                                 name:NOTIFY_UPDATE_SETTINGS
                                               object:nil];
    
    /*    [[NSNotificationCenter defaultCenter] addObserver:self
     selector:@selector(performProductsUpdate:)
     name:NOTIFY_UPDATE_PRODUCTS
     object:nil];*/
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(performProductsUpdate:)
                                                 name:NOTIFY_UPDATE_INVENTORY
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(performServerInfoUpdate:)
                                                 name:NOTIFY_UPDATE_SERVERINFO
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(broadcastInventorySettings:)
                                                 name:NOTIFY_UPDATE_INVENTORY_SETTINGS
                                               object:nil];
    
    /*[[NSNotificationCenter defaultCenter] addObserver:self
     selector:@selector(performProductsUpdate:)
     name:NOTIFY_BROADCAST_UPDATE_INVENTORY
     object:nil]; */
    //products and settings
    
    
    
    
}

-(void)performMessageReceived:(BroadcastMessageAPI *)message{
#ifdef DEBUG
    NSLog(@"message.message_type=%@",message.message_type);
#endif
#pragma mark - MSG_TYPE_REQUEST_FILE_DOWNLOAD
    if([message.message_type isEqualToString:MSG_TYPE_REQUEST_FILE_DOWNLOAD]){
        NSString *pathComponents=message.text;
        pathComponents=[pathComponents stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" "]];
        if(pathComponents.length==0)
            return;
        NSArray *paths=[pathComponents componentsSeparatedByString:@","];
        
        for (NSString *pathComponent in paths) {
            //NSString *pathcComponent=message.text;
            // NSLog(@"pathcComponent=%@",pathcComponent);
            if(pathComponent){
                [self performFileUpload:pathComponent fromPeer:message.peerInfo.peerID];
            }
        }
        
    }
#pragma mark - MSG_TYPE_REQUEST_SERVERINFO
    else if([message.message_type isEqualToString:MSG_TYPE_REQUEST_SERVERINFO]){
#ifdef DEBUG
        NSLog(@"Received %@",MSG_TYPE_REQUEST_SERVERINFO);
#endif
        
        [self sendServerInfo:NO message:message];
        
    }
#pragma mark - MSG_TYPE_REQUEST_UPDATEINFO
    else if([message.message_type isEqualToString:MSG_TYPE_REQUEST_UPDATEINFO]){
        
        
        [self processUpdateInfo:message];
        
    }
#pragma mark - MSG_TYPE_REQUEST
    else if([message.message_type isEqualToString:MSG_TYPE_REQUEST]){
        
        
        NSData *data=[message.text dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error;
        
        NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
        
        
        NSString *action=[dict valueForKey:KEY_ACTION];
#pragma mark - INVENTORY
        if([action isEqualToString:KEY_ACTION_INVENTORY]){
            
            NSDictionary *menu_dict=nil;
            
            InventoryItem *inventoryItem=_appDelegate.inventoryModel.inventory;//[InventoryModel activeInventory];
            
            if(inventoryItem!=nil){
                menu_dict=[inventoryItem toMenuDictionary:_appDelegate.appConfig];
#ifdef DEBUG
                NSLog(@"response: %@ dict: %@",KEY_ACTION_INVENTORY,menu_dict);
#endif
            }
            
            if(menu_dict==nil)
                menu_dict=[NSDictionary new];
            
            
            
            NSMutableDictionary *response_dict=[[NSMutableDictionary alloc] init];
            
            [response_dict setValue:KEY_ACTION_INVENTORY forKey:KEY_ACTION];
            
            [response_dict setValue:menu_dict forKey:KEY_ACTION_PARAM];
            [response_dict setValue:KEY_ACTION_TYPE_RESPONSE forKey:KEY_ACTION_TYPE];
            
            NSError *error;
            
            NSData *jsonData=[NSJSONSerialization dataWithJSONObject:response_dict options:NSJSONWritingPrettyPrinted error:&error];
            
            if(error==nil){
                NSString *reply=[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
                //BroadcastMessageAPI *message=[[BroadcastMessageAPI alloc] init];
                message.text=reply;
                message.isBroadcast=NO;
                message.toPeerInfo=message.peerInfo;
                message.message_type=MSG_TYPE_RESPONSE;
                message.localCopy=NO;
                [self sendMyMessage:message];
                return;
            }
        }
#pragma mark - SYNCH REQUEST
        else if([action isEqualToString:KEY_ACTION_SYNCH_REQUEST]){
            
            //TODO:
            _appDelegate.appConfig.allowedDaysToSynch=1;
            if(_appDelegate.appConfig.allowedDaysToSynch==0)
                return;
            
            
            NSSortDescriptor *valueDescriptors=[[NSSortDescriptor alloc] initWithKey:@"self" ascending:NO];
            NSArray *descriptors=[NSArray arrayWithObject:valueDescriptors];
            
            if([[_appDelegate.historyModel.history allKeys] count]==0)
                return;
            
            NSArray *sortedArray=[[_appDelegate.historyModel.history allKeys] sortedArrayUsingDescriptors:descriptors];
            
            
            
            NSPredicate *p=[NSPredicate predicateWithFormat:@"orderDeviceID==%@",message.peerInfo.deviceID];
            NSMutableArray *result=[NSMutableArray new];
            
            int d=1;
            
            for(NSString *day in sortedArray){
                if(d<=_appDelegate.appConfig.allowedDaysToSynch){
                    
                    NSArray *orders=[(NSArray *)[_appDelegate.historyModel.history valueForKey:day] filteredArrayUsingPredicate:p];
                    if([orders count]>0){
                        //[result addObjectsFromArray:orders];
                        
                        for (OrderHistory *oh in orders) {
                            [result addObject:[oh toJSONDictionary]];
                        }
                    }
                    
                }
                else{
                    break;
                }
                d++;
                
            }
            
            NSMutableDictionary *response_dict=[[NSMutableDictionary alloc] init];
            
            [response_dict setValue:KEY_ACTION_SYNCH_RESPONSE forKey:KEY_ACTION];
            [response_dict setValue:@{@"orders":result,@"days":@(_appDelegate.appConfig.allowedDaysToSynch)} forKey:KEY_ACTION_PARAM];
            //[response_dict setValue:result forKey:KEY_ACTION_PARAM];
            [response_dict setValue:KEY_ACTION_TYPE_RESPONSE forKey:KEY_ACTION_TYPE];
            
            NSError *error;
            
            NSData *jsonData=[NSJSONSerialization dataWithJSONObject:response_dict options:NSJSONWritingPrettyPrinted error:&error];
            
            if(error==nil){
                NSString *reply=[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
                //BroadcastMessageAPI *message=[[BroadcastMessageAPI alloc] init];
                message.text=reply;
                message.isBroadcast=NO;
                message.toPeerInfo=message.peerInfo;
                message.message_type=MSG_TYPE_RESPONSE;
                message.localCopy=NO;
                [self sendMyMessage:message];
                return;
            }
            
            
        }
#pragma mark - CHARGE
        else if ([action isEqualToString:KEY_ACTION_CHARGE]){
            NSDictionary *param_dict=[dict valueForKey:KEY_ACTION_PARAM];
            
            NSDictionary *order_dict=[param_dict valueForKey:KEY_CHARGE_ORDER];
            NSDictionary *cardinfo_dict=[param_dict valueForKey:KEY_CHARGE_CARDINFO];
            
            
            NSString *storeID=[order_dict valueForKey:OrderStoreIDKey];
            if(![storeID isEqualToString:_appDelegate.appConfig.device_id]){
                
                //new_order.errorMessage=ORDER_ERR_CODE_103;//REPLY_STORE_INVALID;
                //[self performReplyToOrder:new_order toPeer:message.peerInfo];
                //NSString *reply=[order toChargeResponseString];
                //if(reply!=nil){
                //NSString *reply=[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
                //NSLog(@"reply=%@",reply);
                BroadcastMessageAPI *message=[[BroadcastMessageAPI alloc] init];
                message.text=@"There was an error processing your request. 2780.";//@"Invalid store.";
                message.isBroadcast=NO;
                message.toPeerInfo=message.peerInfo;
                message.message_type=MSG_TYPE_RESPONSE;
                message.localCopy=NO;
                [self sendMyMessage:message];
                // }
#if DEBUG
                NSLog(@"Invalid store.");
#endif
                return;
            }
            
            OrderHistory *order=nil;
            
            OrderHistory *new_order=[[OrderHistory alloc] initWithJSON:order_dict];
            
            new_order.orderSource=@ORDER_SOURCE_REMOTE;
            new_order.orderDateTime=[NSDate date];
            new_order.orderDay=[AppDelegate today];
            new_order.orderStoreNum=_appDelegate.appConfig.device_num;
            new_order.orderStoreName=_appDelegate.appConfig.device_name;
            
            //InventoryItem *inventoryItem=[InventoryModel activeInventory];
            new_order.orderTax=_selectedInventory.salesTax;//_appDelegate.appConfig.salesTax/100;
            
            
            
            /*
             if(new_order.errorCodes){
             
             [self performReplyToOrder:new_order toPeer:message.peerInfo];
             return;
             
             }
             */
            
            
            OrderHistory *existing_order=[_appDelegate searchOrderWithID:new_order.orderID withOrderDay:new_order.orderDay withStoreID:new_order.orderStoreID withDeviceID:new_order.orderDeviceID];
            
            if(existing_order!=nil)
            {
                /* if (!existing_order.orderIsPaid) {
                 existing_order.errorMessage=ORDER_ERR_OUT_OF_STOCK;
                 [self performReplyToOrder:new_order toPeer:message.peerInfo];
                 return;
                 }
                 */
                if (existing_order.orderIsPaid)
                    return;
                
                order=existing_order;
            }
            else{
                order=new_order;
            }
            
            
            if(![order validateOrder]){ //this include updating the inventory specifically instock field
                order.orderStatus=@ORDER_STATUS_FAILED;
                [_appDelegate.historyModel saveHistory];
                [self performReplyToOrder:order toPeer:message.peerInfo];
                return;
                
            }
            
            
            /*order.orderTaxRate=_appDelegate.appConfig.salesTax/100;
             order.orderSubtotal=[self total:order]; //cents
             order.orderTotalTax=order.orderSubtotal *order.orderTaxRate; //cents
             order.orderTotal=order.orderSubtotal+order.orderTotalTax;//@([self grand_total:order]);
             
             order.chargeAmount=order.orderTotal;
             order.orderAmountDue=order.chargeAmount;
             */
            
            STPCard* stripeCard=[[STPCard alloc] init];
            stripeCard.name = [cardinfo_dict valueForKey:@"name"];
            stripeCard.email = [cardinfo_dict valueForKey:@"email"];
            stripeCard.number =[cardinfo_dict valueForKey:@"number"];
            stripeCard.cvc = [cardinfo_dict valueForKey:@"cvc"];
            stripeCard.expMonth = [[cardinfo_dict valueForKey:@"expMonth"] unsignedIntegerValue];
            stripeCard.expYear = [[cardinfo_dict valueForKey:@"expYear"] unsignedIntegerValue];
            
            NSString *last4=stripeCard.last4;
            if (last4==nil) {
                if(stripeCard.number.length >=4){
                    last4=[stripeCard.number substringFromIndex:(stripeCard.number.length-4)];
                }
            }
            
            [_soundController playSystemSound:SOUND_ORDER_RECEIVED soundSource:SOURCE_ORDERS];
            
            //f(existing_order!=nil){
            if(order.chargeToken==nil || order.chargeToken.length==0){
                [self performChargeWithOrder:order cardInfo:stripeCard fromPeer:message.peerInfo];
            }
            else{
                
                //[self performChargeWithOrderWithToken:order cardInfo:stripeCard fromPeer:message.peerInfo];
                [self performChargeWithOrderWithToken:order cardInfo:stripeCard fromPeer:message.peerInfo];
            }
            //}
            //            else{
            //                if(existing_order.chargeToken==nil || existing_order.chargeToken.length==0){
            //                [self performChargeWithOrder:new_order cardInfo:stripeCard fromPeer:message.peerInfo];
            //                    else{
            //
            //                        [self performChargeWithOrderWithToken:new_order cardInfo:stripeCard fromPeer:message.peerInfo];
            //                    }
            //            }
            
        }
#pragma mark - CASH ORDER
        else if ([action isEqualToString:KEY_ACTION_ORDER]){
            
            NSDictionary *param_dict=[dict valueForKey:KEY_ACTION_PARAM];
            
            NSDictionary *order_dict=[param_dict valueForKey:KEY_CHARGE_ORDER];
            
            
            NSString *storeID=[order_dict valueForKey:OrderStoreIDKey];
            if(![storeID isEqualToString:_appDelegate.appConfig.device_id]){
                
                //new_order.errorMessage=ORDER_ERR_CODE_103;//REPLY_STORE_INVALID;
                //[self performReplyToOrder:new_order toPeer:message.peerInfo];
                //NSString *reply=[order toChargeResponseString];
                //if(reply!=nil){
                //NSString *reply=[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
                //NSLog(@"reply=%@",reply);
                BroadcastMessageAPI *message=[[BroadcastMessageAPI alloc] init];
                message.text=@"Please connect to place an order.";
                message.isBroadcast=NO;
                message.toPeerInfo=message.peerInfo;
                message.message_type=MSG_TYPE_RESPONSE;
                message.localCopy=NO;
                [self sendMyMessage:message];
                // }
                return;
            }
            
            OrderHistory *new_order=[[OrderHistory alloc] initWithJSON:order_dict];
            
            new_order.orderSource=@ORDER_SOURCE_REMOTE;
            new_order.orderDateTime=[NSDate date];
            new_order.orderDay=[AppDelegate today];
            new_order.orderStoreNum=_appDelegate.appConfig.device_num;
            //new_order.orderTaxRate=@(_appDelegate.appConfig.salesTax);
            
            if(![new_order.orderStoreID isEqualToString:_appDelegate.appConfig.device_id]){
                
                new_order.errorMessage=ORDER_ERR_INVALID_STORE;//REPLY_STORE_INVALID;
                [self performReplyToOrder:new_order toPeer:message.peerInfo];
                
                return;
            }
            
            
            if(![new_order validateOrder]){ //this include updating the inventory specifically instock field
                
                [self performReplyToOrder:new_order toPeer:message.peerInfo];
                //TODO: send confirmation for changes
                return;
                
            }
            
            
            [self performOrder:new_order fromPeer:message.peerInfo];
            
        }
        
#pragma mark - CANCEL ORDER
        else if ([action isEqualToString:KEY_ACTION_CANCEL_ORDER]){
            NSDictionary *param_dict=[dict valueForKey:KEY_ACTION_PARAM];
            
            NSDictionary *order_dict=[param_dict valueForKey:KEY_ORDER];
            
            OrderHistory *cancel_order=[[OrderHistory alloc] initWithJSON:order_dict];
            
            
            
            OrderHistory *existing_order=[_appDelegate searchOrderWithID:cancel_order.orderID withOrderDay:cancel_order.orderDay withStoreID:cancel_order.orderStoreID withDeviceID:cancel_order.orderDeviceID];
            
            if(existing_order!=nil)
            {
                /*if(existing_order.orderIsPaid){
                 
                 }
                 else{
                 //existing_order.or
                 }
                 */
                //TODO: comment on production
                //_appDelegate.appConfig.refundLevel=ORDER_STATUS_READY;
                NSString *reply;
                int status=[existing_order.orderStatus intValue];
                
                
                //  if(_appDelegate.appConfig.refundLevel>ORDER_STATUS_READY)
                //     _appDelegate.appConfig.refundLevel=ORDER_STATUS_READY;
                BOOL isSuccess=NO;
                if(_selectedInventory.refundLevel>0 && status<=_selectedInventory.refundLevel){
                    
                    if(existing_order.orderIsPaid){
                        
                        NSString *error=[PaymentManager performPostRefund:existing_order];
                        if(error!=nil){
#ifdef DEBUG
                            //if (result!=nil) {
                            NSLog(@"Error: %@",error);
                            //}
#endif
                            
                            //return;
                            
                        }
                        else{
                            isSuccess=YES;
                        }
                        
                    }
                    else{
                        //asSetStatus=[[UIActionSheet alloc] initWithTitle:@"Set Order Status" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:MENU_ORDER_SET_PAYNOW,MENU_ORDER_SET_CANC,nil];
                        existing_order.orderStatus=@ORDER_STATUS_CANC;//@ORDER_STATUS_REFUND;
                        [_appDelegate.historyModel saveHistory];
                        
                        // [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_UPDATE_HISTORY object:nil];
                        
                        //return inventory
                        [PaymentManager returnOrder:existing_order];
                        isSuccess=YES;
                    }
                    reply=[existing_order toCancelOrderResponseString:isSuccess];
                    
                    //if(error==nil){
                    /*
                     //[reply appendString:[order toChargeResponseString]];
                     NSString *msg=@"Menu has changed.";
                     if(order.errorMessage!=nil && order.errorMessage.length>0)
                     msg=order.errorMessage;
                     
                     [reply appendString:msg];//[order toChargeResponseString]];
                     BroadcastMessageAPI *message=[[BroadcastMessageAPI alloc] init];
                     message.text=reply;
                     message.isBroadcast=NO;
                     message.toPeerInfo=peer;
                     message.message_type=MSG_TYPE_RESPONSE;
                     message.localCopy=NO;
                     [self sendMyMessage:message];
                     */
                    if(reply!=nil){
                        //NSString *reply=[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
                        //NSLog(@"reply=%@",reply);
                        BroadcastMessageAPI *reply_message=[[BroadcastMessageAPI alloc] init];
                        
                        reply_message.text=reply;
                        reply_message.isBroadcast=NO;
                        reply_message.toPeerInfo=message.peerInfo;
                        reply_message.message_type=MSG_TYPE_RESPONSE;
                        reply_message.localCopy=NO;
                        [self sendMyMessage:reply_message];
                    }
                    //}
                    //else{
                    
                    //}
                }
                else{
                    BroadcastMessageAPI *reply_message=[[BroadcastMessageAPI alloc] init];
                    
                    reply_message.text=[NSString stringWithFormat:@"Sorry there was an error cancelling your order# %@. Please see customer service. Thank you.",existing_order.orderNumber];
                    reply_message.isBroadcast=NO;
                    reply_message.toPeerInfo=message.peerInfo;
                    reply_message.message_type=MSG_TYPE_DEF;
                    reply_message.localCopy=NO;
                    [self sendMyMessage:reply_message];
                    
                }
                //                else{
                //                    if(existing_order.orderIsPaid){
                //                        asSetStatus=[[UIActionSheet alloc] initWithTitle:@"Set Order Status" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles: MENU_ORDER_SET_REFUND,nil];
                //                    }
                //                }
                
            }
            
        }
        
    }
    
    /*
     else if([message.message_type isEqualToString:MSG_TYPE_PAID_ORDER]||
     [message.message_type isEqualToString:MSG_TYPE_UNPAID_ORDER])
     {
     [self performPaidOrUnpaidOrder:message];
     }
     */
#pragma mark - MSG_TYPE_RESPONSE
    else if([message.message_type isEqualToString:MSG_TYPE_RESPONSE]){
        NSData *data=[message.text dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error;
        NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
        
        NSString *action=[dict valueForKey:KEY_ACTION];
#ifdef DEBUG
        NSLog(@"KEY_ACTION=%@",action);
        
        
#endif
        if([action isEqualToString:KEY_ACTION_ALERT]){
            
            /*
            NSDictionary *info  =[dict valueForKey:KEY_ACTION_PARAM];
#ifdef DEBUG
            NSLog(@"KEY_ACTION_PARAM=%@",info);
            
            
#endif
             */
            //NSString *devicetoken=[info valueForKey:KEY_DEVICETOKEN];
            //NSString *notificationid=[info valueForKey:KEY_ALERT_ID];
            /*
            NSTimer *invalidTimer=nil;
            if(timers){
                for (NSTimer *timer in timers) {
                    if ([[timer.userInfo valueForKey:KEY_ALERT_ID] isEqualToString:[info valueForKey:KEY_ALERT_ID]]) {
                        
                        invalidTimer=timer;
                        break;
                    }
                }
            }
            
            if(invalidTimer){
                [invalidTimer invalidate];
                [timers removeObject:invalidTimer];
            }
           */
           
        }
    }
    
    
#pragma mark - MSG_TYPE_DEFAULT
    
    else{
        if(!_appDelegate.appConfig.enableChat)
            return;
        
        NSError *error;
        NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:[message.text dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:&error];
        if(error)
            return;
        
        [_soundController playSystemSound:SOUND_CHAT_RECEIVED soundSource:SOURCE_CHAT];
        
        NSString *text=[dict valueForKey:@"text"];
        
        message.isBroadcast=[[dict valueForKey:@"isBroadcast"] boolValue];
        
        message.fromDeviceID=[dict valueForKey:@"fromDeviceID"];
        
        message.sender=[dict valueForKey:@"sender"];
        
        message.text=text;
        
        message.toDeviceID=[dict valueForKey:@"toDeviceID"];
        
        message.imagefileuid=[dict valueForKey:@"imagefileuid"];
        
        if(!_appDelegate.appConfig.enablePhotoSharing)
            message.imagefileuid=nil;
        
        //first check if there's attached file
        if(message.imagefileuid!=nil && message.imagefileuid.length>0){
            //see if file already exist on the server
            NSString *attachment_photo=[NSString stringWithFormat:@"%@%@.png",PREFIX_ATTACHMENT,message.imagefileuid];
            
            
            
            NSString *filePath=[[AppDelegate getImagesPath] stringByAppendingPathComponent:attachment_photo];
            
            
            if(![[NSFileManager defaultManager] fileExistsAtPath:filePath]){
                //que message until finish downloading attachment
                if(_appDelegate.messages_que==nil)
                    _appDelegate.messages_que=[NSMutableArray new];
                
                //remove expired queues to avoid leak
                //NSPredicate *p=[NSPredicate predicateWithFormat:@""];
                NSArray *tmp_q=[_appDelegate.messages_que copy];
                for(BroadcastMessageAPI *q in tmp_q){
                    if(q.createdon<=[[NSDate date] dateByAddingTimeInterval:60]){
                        [_appDelegate.messages_que removeObject:q];
                    }
                }
                
                [_appDelegate.messages_que addObject:message];
                //TODO: implement compression
                
                NSString *remotePath=[NSString stringWithFormat:@"/tmp/%@/%@",_appDelegate.appConfig.device_id , attachment_photo];
                
                /*
                 NSDictionary *dict = @{KEY_SEND_MESSAGE: remotePath,
                 KEY_SEND_MESSAGE_TYPE : MSG_TYPE_REQUEST_FILE_DOWNLOAD
                 };
                 
                 [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_HAS_DATA_TO_SEND
                 object:nil
                 userInfo:dict];
                 */
                
                BroadcastMessageAPI *send_message=[[BroadcastMessageAPI alloc] init];
                send_message.text=remotePath;
                send_message.message_type=MSG_TYPE_REQUEST_FILE_DOWNLOAD;
                send_message.isBroadcast=NO;
                send_message.toPeerInfo=message.peerInfo;
                send_message.localCopy=NO;
                [self sendMyMessage:send_message];
                //
                return;
                
            }
            
            
            
        }
        
        [self processMessageQue:message];
        
    }
    
}


#pragma mark -Notification


-(void)performDeviceNotification:(NSNotification *)notification{
    
    /*
    
    NSString *deviceID=[notification.userInfo valueForKey:OrderDeviceIDKey];
    NSString *deviceToken=[notification.userInfo valueForKey:OrderDeviceTokenKey];
    NSNumber *orderStatus=[notification.userInfo valueForKey:OrderStatusKey];
    NSString *orderID=[notification.userInfo valueForKey:OrderIDKey];
    NSString *orderStoreID=[notification.userInfo valueForKey:OrderStoreIDKey];
    */
    /*
     userInfo:@{OrderDeviceIDKey:selectedOrder.orderDeviceID,OrderDeviceTokenKey:selectedOrder.orderDeviceToken,OrderStatusKey:selectedOrder.orderStatus,OrderIDKey:selectedOrder.orderID,OrderStoreIDKey:selectedOrder.orderStoreID, @"message":message, @"push_message":message}];
     */
    OrderHistory *order=[notification.userInfo valueForKey:@"order"];
    
    
    
    
    /* if (deviceID==nil) {
     //TODO: should we broadcast instead?
     
     return;
     }
     */
    //NSString *name=[notification.userInfo valueForKey:@"name"];
   // NSString *push_text=[notification.userInfo valueForKey:@"push_message"];
    //NSString *text=[notification.userInfo valueForKey:@"message"];
    //if(deviceID!=nil && deviceID.length>0){
    //check if user is nearby
    
    bool isPush=YES;
   
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"deviceID=%@",order.orderDeviceID];
    NSArray *singlePeer=[_appDelegate.mcManager.peerDevices filteredArrayUsingPredicate:predicate];

    PeerInfo *peer=nil;
    if (singlePeer!=nil && [singlePeer count]>0)
        peer=[singlePeer firstObject];
    if(peer && peer.sessionState==MCSessionStateConnected)
        isPush=NO;
    
    //comment this on production, its set to yes to testpush notification
    //isPush=YES;
    
    
    
    if(isPush){
        //must have been removed from the array
        //if(order.orderDeviceToken.length>0){
            //[self performRemoteNotificationWithMessage:text withDeviceToken:deviceToken];
            //[self performRemoteNotificationWithMessage:push_text withDeviceToken:order.orderDeviceToken withOrderID:order.orderID withOrderStatus:order.orderStatus];
            [self performRemoteNotificationWithOrder:order];
        
#ifdef DEBUG
        NSLog(@"User is notified remotely.");
#endif
        //}
    }
    else {
#ifdef DEBUG
        NSLog(@"User is notified remotely.");
#endif
        [self performNearbyNotificationWithOrder:order andPeer:peer];
//        if(peer.sessionState==MCSessionStateConnected){
//            
//            NSMutableDictionary *request_dict=[[NSMutableDictionary alloc] init];
//            
//            NSString *alertid=[[[NSUUID UUID] UUIDString] lowercaseString];
//            
//            [request_dict setValue:KEY_ACTION_ALERT forKey:KEY_ACTION];
//            
//            [request_dict setValue:@{KEY_ALERT_ID:alertid,KEY_ALERT_TEXT:text,KEY_ALERT_PUSHTEXT:push_text,OrderIDKey:order.orderID,OrderStoreIDKey:order.orderStoreID,OrderStatusKey:order.orderStatus} forKey:KEY_ACTION_PARAM];
//            
//            [request_dict setValue:KEY_ACTION_TYPE_REQUEST forKey:KEY_ACTION_TYPE];
//            
//            NSError *error;
//            
//            NSData *jsonData=[NSJSONSerialization dataWithJSONObject:request_dict options:NSJSONWritingPrettyPrinted error:&error];
//            
//            if(error!=nil)
//                return;
//            
//            NSString *request=[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
//            
//            BroadcastMessageAPI *message=[[BroadcastMessageAPI alloc] init];
//            message.text=request;
//            message.isBroadcast=NO;
//            message.fromDeviceID=_appDelegate.mcManager.myPeerInfo.deviceID;
//            message.toPeerInfo=peer;
//            message.message_type=MSG_TYPE_REQUEST;
//            message.localCopy=NO;
//            message.messageuid=alertid;
//            
//            
//            
//            
//            
//            
//            //time receipt
//            /* ROM: this might be dangerous
//            if(timers==nil)
//                timers=[NSMutableArray array];
//            
//            
//            if (deviceToken) {
//                
//                
//                
//                [timers addObject:[NSTimer scheduledTimerWithTimeInterval:10.0 target:self selector:@selector(performAlertTimeout:) userInfo:@{KEY_ALERT_ID:message.messageuid ,KEY_ALERT_PUSHTEXT:push_text ,KEY_DEVICETOKEN:deviceToken,OrderIDKey:orderID,OrderStatusKey:orderStatus} repeats:NO]];
//            }
//            */
//            [self sendMyMessage:message];
//            
//            
//#ifdef DEBUG
//            NSLog(@"Attempt to notify user nearby.");
//#endif
//        }
//        else{
//            if(order.orderDeviceToken.length>0){
//                [self performRemoteNotificationWithMessage:push_text withDeviceToken:order.orderDeviceToken withOrderID:order.orderID withOrderStatus:order.orderStatus];
//#ifdef DEBUG
//                NSLog(@"User is notified remotely.");
//#endif
//            }
//        }
    }
    
    
    
    
    //}
}


-(void) performNearbyNotificationWithOrder:(OrderHistory *)order andPeer:(PeerInfo *)peer{
    
    if(peer.sessionState!=MCSessionStateConnected)
        return;
    NSString *status;
    if([order.orderStatus integerValue]==ORDER_STATUS_READY)
        status=ORDER_STATUS_READY_LABEL;
    else if([order.orderStatus integerValue]==ORDER_STATUS_CANC)
        status=ORDER_STATUS_CANC_LABEL;
    
    else if([order.orderStatus integerValue]==ORDER_STATUS_CLOSED)
        status=ORDER_STATUS_CLOSED_LABEL;
    
    if(!status)
        return;
    
     NSString *push_text=[NSString stringWithFormat:@"Your order# %@ is %@.",order.orderNumber,status];
            
    NSMutableDictionary *request_dict=[[NSMutableDictionary alloc] init];
    
    NSString *alertid=[[[NSUUID UUID] UUIDString] lowercaseString];
    
    [request_dict setValue:KEY_ACTION_ALERT forKey:KEY_ACTION];
    
    [request_dict setValue:@{KEY_ALERT_ID:alertid,KEY_ALERT_TEXT:push_text,KEY_ALERT_PUSHTEXT:push_text,OrderIDKey:order.orderID,OrderStoreIDKey:order.orderStoreID,OrderStatusKey:order.orderStatus} forKey:KEY_ACTION_PARAM];
    
    [request_dict setValue:KEY_ACTION_TYPE_REQUEST forKey:KEY_ACTION_TYPE];
    
    NSError *error;
    
    NSData *jsonData=[NSJSONSerialization dataWithJSONObject:request_dict options:NSJSONWritingPrettyPrinted error:&error];
    
    if(error!=nil)
        return;
    
    NSString *request=[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    BroadcastMessageAPI *message=[[BroadcastMessageAPI alloc] init];
    message.text=request;
    message.isBroadcast=NO;
    message.fromDeviceID=_appDelegate.mcManager.myPeerInfo.deviceID;
    message.toPeerInfo=peer;
    message.message_type=MSG_TYPE_REQUEST;
    message.localCopy=NO;
    message.messageuid=alertid;
    
    
    
    
    
    
    //time receipt
    /* ROM: this might be dangerous
     if(timers==nil)
     timers=[NSMutableArray array];
     
     
     if (deviceToken) {
     
     
     
     [timers addObject:[NSTimer scheduledTimerWithTimeInterval:10.0 target:self selector:@selector(performAlertTimeout:) userInfo:@{KEY_ALERT_ID:message.messageuid ,KEY_ALERT_PUSHTEXT:push_text ,KEY_DEVICETOKEN:deviceToken,OrderIDKey:orderID,OrderStatusKey:orderStatus} repeats:NO]];
     }
     */
    [self sendMyMessage:message];
    
            

    
}

//-(void) postSend:(ComposeData*) message{
//-(void) performRemoteNotificationWithMessage:(NSString *)message withDeviceToken:(NSString *)deviceToken withOrderID:(NSString *)orderID withOrderStatus:(NSNumber *)orderStatus{
             
             /*
              /[self performRemoteNotificationWithMessage:text withDeviceToken:deviceToken];
              //[self performRemoteNotificationWithMessage:push_text withDeviceToken:order.orderDeviceToken withOrderID:order.orderID withOrderStatus:order.orderStatus];
              */
-(void) performRemoteNotificationWithOrder:(OrderHistory *)order{
    //TODO: implement anti spam on the server side
    
    if(order.orderDeviceToken==nil || order.orderDeviceToken.length==0){
        
        //ShowErrorAlert(@"Please enter username or #station");
        return;
    }
    
    NSString *status;
    if([order.orderStatus integerValue]==ORDER_STATUS_READY)
        status=ORDER_STATUS_READY_LABEL;
    else if([order.orderStatus integerValue]==ORDER_STATUS_CANC)
        status=ORDER_STATUS_CANC_LABEL;
    
    else if([order.orderStatus integerValue]==ORDER_STATUS_CLOSED)
        status=ORDER_STATUS_CLOSED_LABEL;
    
    if(!status)
        return;
    
    //NSTimeInterval interval = [order.orderDateTime timeIntervalSince1970];
    int interval = (int)[order.orderDateTime timeIntervalSince1970];
    if(interval<=0)
        return;
    
    //NSString *hexInterval = [NSString stringWithFormat:@"%08x", interval];
    NSString *datetime=[NSString stringWithFormat:@"%@",@(interval)];
    NSString *push_text=[NSString stringWithFormat:@"Your order# %@ is %@.",order.orderNumber,status];
    
    /*   NSDictionary *params = @{@"cmd":@"200",
     @"sendertoken":_appDelegate.appConfig.device_id,
     @"sender":_appDelegate.appConfig.user_displayName,
     @"recipient":deviceToken,
     @"text":message
     };
     */
    NSMutableString *device_name=[_appDelegate.appConfig.device_name mutableCopy];
    [device_name stringByReplacingOccurrencesOfString:@"&" withString:@"&&"];
    
    NSString *text=[push_text mutableCopy];
    [text stringByReplacingOccurrencesOfString:@"&" withString:@"&&"];
    
    NSError *error;
    NSString *info=[NSString stringWithFormat:@"sendertoken=%@&sender=%@&recipient=%@&text=%@&storenum=%@&orderid=%@&orderstatus=%@&orderdt=%@"
                    ,_appDelegate.appConfig.device_id
                    ,device_name//_appDelegate.appConfig.device_name
                   
                    ,order.orderDeviceToken
                    
                    ,text
                     ,@(order.orderStoreNum)
                    ,order.orderID
                    ,order.orderStatus
                    ,datetime
                    
                    ];
    
    
    NSData *data = [info dataUsingEncoding:NSUTF8StringEncoding];
    NSData *encryptedData = [RNEncryptor encryptData:data
                                        withSettings:kRNCryptorAES256Settings
                                            password:A_SECRET_PASSWORD
                                               error:&error];
    NSString *base64Encoded=[encryptedData base64EncodedStringWithOptions:0];//[NSString
    
    
    if(error!=nil){
#ifdef DEBUG
        NSLog(@"encryptData error=%@",[error localizedDescription]);
#endif
        return;
    }
    /*
    MBProgressHUD* hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = NSLocalizedString(@"Sending remote notification.", nil);
    */
    [_appDelegate showMBProgress:@"Sending remote notification."];
    
    
    
    NSDictionary *params = @{@"cmd":@"200",
                             //@"user_id":[_dataModel userId],
                             @"p": base64Encoded//_dataModel.userInfo.password
                             };
    
    
    /*TODO
     MBProgressHUD* hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
     hud.labelText = NSLocalizedString(@"Sending...", nil);
     */
    _client = [AFHTTPClient clientWithBaseURL:[NSURL URLWithString:ServerApiURL]];
    
    [_client postPath:ServerApiPath //@"/portico/api"
           parameters:params
              success:^(AFHTTPRequestOperation *operation, id responseObject) {
                  
                 // if ([self isViewLoaded]) {
                      //[MBProgressHUD hideHUDForView: self.view animated:YES];
                  [_appDelegate hideMBProgress];
                      if([operation.response statusCode] != 200) {
                          // ShowErrorAlert(NSLocalizedString(@"There was an error communicating with the server", nil));
                      }
                      else {
                          
                          //NSLog(operation.responseString);
                          
                          NSError* error;
                          NSDictionary* json=[NSJSONSerialization JSONObjectWithData:operation.responseData options:kNilOptions error:&error];
                          
                          NSNumber* success=[json objectForKey:@"success"];
                          if([success intValue]==1){
                              //[_dataModel.unplayedBroadcastMessages addObject:message];
                              // [self.delegate composeController:self didFinishComposeWithInfo:_properties];
                              //[self.navigationController popViewControllerAnimated:YES];
                              //}
                              
                          }
                          
                      }
                  //}
              } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                  //if ([self isViewLoaded]) {
                      //[MBProgressHUD hideHUDForView:self.view animated:YES];
                  [_appDelegate hideMBProgress];
                      //ShowErrorAlert([error localizedDescription]);
                 // }
              }];
}

-(void)sendMyMessage:(BroadcastMessageAPI *)message{
    message.createdon=[NSDate date];
    message.peerInfo= _appDelegate.mcManager.myPeerInfo;
    message.deviceID=_appDelegate.appConfig.device_id;
    message.deviceToken=_appDelegate.appConfig.user_deviceToken;
    
    if(message.imagefileuid==nil)
        message.imagefileuid=@"";
    
    //added to fix cancel order from client
    if(!message.isForward){
        message.sender=_appDelegate.appConfig.device_name;
        message.fromDeviceID=(message.fromDeviceID!=nil)?message.fromDeviceID:_appDelegate.appConfig.device_id;
        
    }
    /*
     dictMessage=@{@"text":(message.text!=nil)?message.text:@"",@"sender":message.sender,@"fromDeviceID":message.fromDeviceID,@"imagefileuid":(message.imagefileuid)?message.imagefileuid:@"", @"isBroadcast":@(message.isBroadcast)};
     */
    
    [_appDelegate.mcManager sendMyMessage:message];
    
    if(message.localCopy){
        [_appDelegate.messages addObject:message];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateMessagesNotification" object:nil];
        
    }
    
    
}

-(void)startQueryDevice{
    
    
    NSDictionary *params = @{@"cmd":@"100",
                             @"deviceID":_appDelegate.appConfig.device_id,
                             
                             @"usertoken":_appDelegate.appConfig.user_userToken
                             //@"email":self.emailAddress.text ,
                             //@"password":self.password.text,
                             //@"firstname":self.firstName.text,
                             //@"lastname":self.lastName.text,
                             // @"gender":self.gender.text,
                             //@"dob":[NSString stringWithFormat:@"%@/%@/%@",self.dobMM.text,self.dobDD.text,self.dobYYYY.text ]
                             
                             };
    
    //AFHTTPClient *client = [AFHTTPClient clientWithBaseURL:[NSURL URLWithString:ServerApiURL]];
    [_client
     postPath:ServerApiPath//@"/portico/api"
     parameters:params
     success:^(AFHTTPRequestOperation *operation, id responseObject) {
        // if ([self isViewLoaded]) {
             
             //TODO:[MBProgressHUD hideHUDForView:self.view animated:YES];
         [_appDelegate showMBProgress:@""];
             if([operation.response statusCode] != 200) {
                 [AppDelegate ShowErrorAlert:NSLocalizedString(@"There was an error communicating with the server",nil)] ;
                 //self.lblMes-sage.text=@"There was an error communicating with the server";
             }
             else {
                 
                 if(operation.responseString==nil)
                     return;
                 //NSLog([NSString stringWithFormat:@"responseString %@",operation.responseString]);
                 
                 NSError* error;
                 NSDictionary* json=[NSJSONSerialization JSONObjectWithData:operation.responseData options:kNilOptions error:&error];
                 
                 NSNumber* success=[json objectForKey:@"success"];
                 
                 if([success intValue]==1){
                     
                     /*CompleteRegistrationViewController* activateController = (CompleteRegistrationViewController*) [ApplicationDelegate.storyBoard instantiateViewControllerWithIdentifier:@"UserActivationViewController"];
                      activateController.userName.text=self.userName.text;
                      
                      activateController.delegate = self;
                      */
                     //[self presentViewController:activateController animated:YES completion:nil];
                     //[self performSegueWithIdentifier:@"showCompleteRegistration" sender:self];
                     NSDictionary *result=[json objectForKey:@"result"];
                     //[result valueForKey:@name];
                     [self successQueryDeviceInfo:result];
                     
                 }
                 else{
                     //NSLog(@"Registration failed. %@",[json objectForKey:@"message"]);
                     NSString* errorMessage= [json objectForKey:@"error"];
                     //if([errorMessage isEqualToString:@"#1569"] ){
                     //self.lblMessage.text=[NSString stringWithFormat:@"Email address %@ is already registered.",self.userName.text] ;
                     //self.lblMessage.text=errorMessage ;
                     [AppDelegate ShowErrorAlert:NSLocalizedString(errorMessage,nil)];
                     //}
                     
                 }
             }
         //}
         
     }
     failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         //if ([self isViewLoaded]) {
             //[MBProgressHUD hideHUDForView:self.view animated:YES];
         [_appDelegate hideMBProgress];
             [AppDelegate ShowErrorAlert:[error localizedDescription]];
             //self.lblMessage.text=[error localizedDescription];
        // }
     }];
    
    
}

-(void)successQueryDeviceInfo:(NSDictionary *)info{
    _appDelegate.appConfig.device_name=[info valueForKey:@"name"];
    _appDelegate.appConfig.device_address=[info valueForKey:@"address"];
    _appDelegate.appConfig.device_lat=[[info valueForKey:@"lat"] floatValue];
    _appDelegate.appConfig.device_lng=[[info valueForKey:@"lng"] floatValue];
}

-(void)peerDidChangeState:(NSNotification *)notification{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        /*NSDictionary *dict = @{@"peerInfo": peerInfo,
         @"state" : [NSNumber numberWithInt:state]
         };
         */
        long state=[[notification.userInfo valueForKey:@"state"] integerValue];
        PeerInfo *peer=[notification.userInfo valueForKey:@"peerInfo"];
        
        if(state==MCSessionStateConnected){
           // [self updatePeersDisplay:peer isConnected:YES];
            /*
             message.text=_txtMessage.text;
             message.message_type=MSG_TYPE_DEF;
             message.localCopy=NO;
             message.fromDeviceID=_appDelegate.mcManager.myPeerInfo.deviceID;
             message.sender=_appDelegate.mcManager.myPeerInfo.peerName;
             */
            
            BroadcastMessageAPI *message=[[BroadcastMessageAPI alloc] init];
            message.text=[NSString stringWithFormat:@"Welcome! %@\n%@",peer.peerName,(_appDelegate.appConfig.welcomeMessage!=nil)?_appDelegate.appConfig.welcomeMessage:@""];//peer.peerID.displayName];
            message.isBroadcast=NO;
            message.toPeerInfo=peer;
            message.fromDeviceID=_appDelegate.mcManager.myPeerInfo.deviceID;
            message.sender=_appDelegate.mcManager.myPeerInfo.peerName;
            message.message_type=MSG_TYPE_DEF;//MSG_TYPE_RESPONSE;
            message.localCopy=YES;
            
            [self sendMyMessage:message];
            
            BroadcastMessageAPI *update_message=[[BroadcastMessageAPI alloc] init];
            update_message.text=[Util toJsonString:@{@"deviceid":peer.deviceID,@"peername":peer.peerName, @"status":@"connected",@"peergroup":peer.peerGroup,@"photomd5":(peer.photoMD5!=nil)?peer.photoMD5:@""}];
            update_message.isBroadcast=YES;
            update_message.toPeerInfo=nil;
            update_message.message_type=MSG_TYPE_UPDATE_PEERS;
            update_message.localCopy=NO;
            
            [self sendMyMessage:update_message];
            
            [self downloadPeerPhoto:peer];
            
             [self updatePeersDisplay:peer isConnected:YES];
            
        }
        else if(state==MCSessionStateNotConnected){
            
            [self updatePeersDisplay:peer isConnected:NO];
            /*
             BroadcastMessageAPI *message=[[BroadcastMessageAPI alloc] init];
             message.text=[NSString stringWithFormat:@"%@ disconnected.",peer.peerName];//peer.peerID.displayName];
             message.isBroadcast=YES;
             //message.toPeerInfo=peer;
             message.sender=peer.peerName;
             message.message_type=MSG_TYPE_RESPONSE;
             message.localCopy=NO;
             
             [_appDelegate.messages addObject:message];
             
             
             [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateMessagesNotification" object:nil];
             */
            BroadcastMessageAPI *update_message=[[BroadcastMessageAPI alloc] init];
            
            update_message.text=[Util toJsonString:@{@"deviceid":peer.deviceID,@"peername":peer.peerName, @"status":@"notconnected",@"peergroup":peer.peerGroup,@"photomd5":(peer.photoMD5!=nil)?peer.photoMD5:@""}];
            update_message.isBroadcast=YES;
            update_message.toPeerInfo=nil;
            update_message.message_type=MSG_TYPE_UPDATE_PEERS;
            update_message.localCopy=NO;
            //if(peer){
            [self sendMyMessage:update_message];
            
            [_appDelegate removeMessagesFromDevice:peer.deviceID];
            
        }
        
#ifdef DEBUG
        NSLog(@"Received: peerDidChangeStateWithNotification");
#endif
        //dispatch_async(dispatch_get_main_queue(), ^{
        /*
        [self reloadConnectedDevices];
        [_tblConnectedDevices reloadData];
        */
        [[NSNotificationCenter defaultCenter]  postNotificationName:NOTIFY_RELOAD_CONNECTION_VIEWCONTROLLER object:nil];
        
        
        //});
        
    });
}

-(void)downloadPeerPhoto:(PeerInfo *)peerInfo{
    NSString *peer_photo=[NSString stringWithFormat:@"%@%@.png",PREFIX_MYPHOTO,peerInfo.deviceID];
    NSString *filePath=[[AppDelegate getImagesPath] stringByAppendingPathComponent:peer_photo];
    NSFileManager *filemanager=[NSFileManager defaultManager] ;
    
    
    if(peerInfo.photoMD5==nil || peerInfo.photoMD5.length==0){
        NSError *error;
        [filemanager removeItemAtPath:filePath error:&error];
        return;
    }
    /*this ok for http connection
     dispatch_async(dispatch_get_main_queue(), ^{
     NSURL *url=[[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@myphoto.png",peerInfo.homeUrl]];
     NSData *imageData=[[NSData alloc] initWithContentsOfURL:url];
     if (imageData!=nil) {
     // UIImage *image=[[UIImage alloc] initWithData:imageData];
     cell.imageView.image=[[UIImage alloc] initWithData:imageData];
     cell.imageView.layer.cornerRadius=cell.imageView.frame.size.width / 2;
     cell.imageView.clipsToBounds = YES;
     
     }
     
     
     });
     */
    /*BT connection. NOTE: In this case this wont work bec theyre not connected yet
     
     //TODO: implement compression
     dispatch_async(dispatch_get_main_queue(), ^{
     NSString *peer_photo=[NSString stringWithFormat:@"myphoto-%@.png",peerInfo.deviceID];
     NSString *serverPath=[NSString stringWithFormat:@"/%@",peer_photo];
     
     //NSLog(@"serverpath=%@",peerInfo.homeUrl);
     NSLog(@"serverpath=%@",serverPath);
     
     NSDictionary *dict = @{KEY_SEND_MESSAGE: serverPath,
     KEY_SEND_MESSAGE_TYPE : MSG_TYPE_REQUEST_FILE_DOWNLOAD
     };
     
     [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_HAS_DATA_TO_SEND
     object:nil
     userInfo:dict];
     
     
     
     });
     */
    /*
     //download users photo if necessary
     //if(message.imagefileuid!=nil && message.imagefileuid.length>0){
     //see if file already exist on the server
     
     NSString *peer_photo=[NSString stringWithFormat:@"%@%@.png",PREFIX_MYPHOTO,peer.deviceID];
     
     
     
     NSString *filePath=[[AppDelegate getImagesPath] stringByAppendingPathComponent:peer_photo];
     NSFileManager *filemanager=[NSFileManager defaultManager] ;
     NSError *error;
     if([filemanager fileExistsAtPath:filePath]){
     NSData *data=[NSData dataWithContentsOfFile:filePath];
     NSString *md5=[[data MD5] uppercaseString];
     if([peer.photoMD5 isEqualToString:md5])
     return;
     else
     [filemanager removeItemAtPath:filePath error:&error];
     
     }
     
     
     
     NSString *remotePath=[NSString stringWithFormat:@"/images/%@",peer_photo];
     
     
     
     BroadcastMessageAPI *send_message=[[BroadcastMessageAPI alloc] init];
     send_message.text=remotePath;
     send_message.message_type=MSG_TYPE_REQUEST_FILE_DOWNLOAD;
     send_message.isBroadcast=NO;
     send_message.toPeerInfo=message.peerInfo;
     send_message.localCopy=NO;
     [self sendMyMessage:send_message];
     */
    
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        /*this is for http connectivity
         NSURL *url=[[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@myphoto.png",peerInfo.homeUrl]];
         NSData *imageData=[[NSData alloc] initWithContentsOfURL:url];
         if (imageData!=nil) {
         // UIImage *image=[[UIImage alloc] initWithData:imageData];
         cell.imageView.image=[[UIImage alloc] initWithData:imageData];
         cell.imageView.layer.cornerRadius=cell.imageView.frame.size.width / 2;
         cell.imageView.clipsToBounds = YES;
         }
         */
        
        //MC connectivity
        // NSString *peer_photo=[NSString stringWithFormat:@"%@%@.png",PREFIX_MYPHOTO,peerInfo.deviceID];
        if([filemanager fileExistsAtPath:filePath]){
            NSData *data=[NSData dataWithContentsOfFile:filePath];
            NSString *md5=[[data MD5] uppercaseString];
            if([peerInfo.photoMD5 isEqualToString:md5])
                return;
            else{
                NSError *error;
                [filemanager removeItemAtPath:filePath error:&error];
            }
        }
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didFinishDownload:) name:peer_photo object:nil];
        
        NSString *clientPath=[NSString stringWithFormat:@"/%@",peer_photo];
        
        
        
        
        BroadcastMessageAPI *message=[[BroadcastMessageAPI alloc] init];
        message.text=clientPath;
        message.message_type=MSG_TYPE_REQUEST_FILE_DOWNLOAD;
        message.isBroadcast=NO;
        message.toPeerInfo=peerInfo;
        message.localCopy=NO;
        [self sendMyMessage:message];
        
    });
    
}

-(void)updatePeersDisplay:(PeerInfo *)peer isConnected:(BOOL) connected{
    //NSDictionary *dictionary=[AppDelegate fromJsonString:message.text];
    //if(dictionary!=nil)
    //{
    /* NSString *deviceid=[dictionary valueForKey:@"deviceid"];
     if(!deviceid)
     return;
     
     NSString *status=[dictionary valueForKey:@"status"];
     if(!status)
     return;
     */
    if(_appDelegate.mcManager.myPeerInfo.peers==nil)
        _appDelegate.mcManager.myPeerInfo.peers=[NSMutableArray new];
    
    
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"DeviceId=%@",peer.deviceID];
    
    NSArray *results=[_appDelegate.mcManager.myPeerInfo.peers filteredArrayUsingPredicate:predicate];
    
    if ([results count]==0) {
        if(connected){
            NSDictionary *peer_dict=@{@"Title":peer.peerName//peerID.displayName
                                      ,DeviceIdKey:peer.deviceID
                                      ,@"PeerGroup":peer.peerGroup
                                      ,@"PhotoMD5":peer.photoMD5};
            [_appDelegate.mcManager.myPeerInfo.peers addObject:peer_dict];
        }
        
    }
    else{
        NSMutableDictionary *existing_peer=[[results firstObject] mutableCopy];
        if(connected){
            
            
            [existing_peer setValue:peer.peerName forKey:@"Title"];
            [existing_peer setValue:peer.peerGroup forKey:@"PeerGroup"];
            [existing_peer setValue:peer.photoMD5 forKey:@"PhotoMD5"];
        }
        else{
            [_appDelegate.mcManager.myPeerInfo.peers removeObject:existing_peer];
        }
        
    }
    
    
    
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_UPDATE_PEERS object:nil]; //userInfo:@{@"data":message.text}];
    
    //}
}

-(void)didFinishDownload:(NSNotification *)notification{
    if([notification.userInfo objectForKey:@"resourceName"]!=nil){
        [[NSNotificationCenter defaultCenter] removeObserver:self name:[notification.userInfo valueForKey:@"resourceName"] object:nil];
    }
    /*if(timerWaitBeforReload==nil)
     timerWaitBeforReload=[NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(reloadImageOntimer) userInfo:nil repeats:NO];
     else{
     if([timerWaitBeforReload isValid]){
     [timerWaitBeforReload invalidate];
     timerWaitBeforReload=[NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(reloadImageOntimer) userInfo:nil repeats:NO];
     }
     }
     */
    /*
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tblConnectedDevices reloadData];
    });
     */
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_RELOAD_CONNECTION_VIEWCONTROLLER object:nil];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_UPDATE_MESSAGES object:nil];
    
   
    
}


#pragma mark PROCESS MESSAGE QUEUE
-(void)processMessageQue:(BroadcastMessageAPI *)message{
    if (message.isBroadcast) {
        
        
        [self displayReceivedMessage:message];
        
        
        BroadcastMessageAPI *re_message=[[BroadcastMessageAPI alloc] init];
        re_message.text=message.text;//reply;
        re_message.isBroadcast=YES;
        re_message.isForward=YES;
        re_message.sender=message.sender;//message.peerInfo.peerName;//peerID.displayName;
        re_message.fromDeviceID=message.fromDeviceID;//message.peerInfo.deviceID;
        re_message.sender=message.peerInfo.peerName;
        re_message.imagefileuid=message.imagefileuid;
        //re_message.isForward=YES;
        re_message.toPeerInfo=nil;
        re_message.message_type=MSG_TYPE_DEF;
        //re_message.message_type=MSG_TYPE_BROADCAST;
        re_message.localCopy=NO;
        //re_message.sender=message.sender;
        
        [self sendMyMessage:re_message];
    }
    else{
        
        //message.toDeviceID=[dict valueForKey:@"todeviceid"];
        // NSString *todeviceid=[dict valueForKey:@"todeviceid"];
        if([message.toDeviceID isEqualToString:_appDelegate.mcManager.myPeerInfo.deviceID]){
            
            [self displayReceivedMessage:message];
            
        }
        
        else{
            NSPredicate *predicate=[NSPredicate predicateWithFormat:@"deviceID==%@",message.toDeviceID];
            NSArray *result=[_appDelegate.mcManager.peerDevices filteredArrayUsingPredicate:predicate];
            
            if([result count]==0){
                
                return;
            }
            
            PeerInfo *toPeerInfo=[result firstObject];
            //message.toPeerInfo=toPeerInfo;
            //message.localCopy=NO;
            
            
            BroadcastMessageAPI *re_message=[[BroadcastMessageAPI alloc] init];
            re_message.text=message.text;//reply;
            re_message.isBroadcast=NO;
            re_message.sender=message.sender;//message.peerInfo.peerName;//peerID.displayName;
            re_message.fromDeviceID=message.fromDeviceID;//message.peerInfo.deviceID;
            //re_message.isForward=YES;
            //re_message.toDeviceID=toPeerInfo.deviceID;
            re_message.toPeerInfo=toPeerInfo;
            re_message.imagefileuid=message.imagefileuid;
            re_message.message_type=MSG_TYPE_DEF;
            //re_message.message_type=MSG_TYPE_BROADCAST;
            re_message.localCopy=NO;
            //re_message.sender=message.sender;
            
            [self sendMyMessage:re_message];
            //[self sendMyMessage:message];
        }
        
    }
}

-(void)displayReceivedMessage:(BroadcastMessageAPI *)message{
    
    if(_appDelegate.messages==nil)
        _appDelegate.messages=[NSMutableArray array];
    
    [_appDelegate.messages addObject:message];
    
    //AudioServicesPlaySystemSound(1003); //sms received //1004 sent sms
    [_soundController playSystemSound:SOUND_CHAT_RECEIVED soundSource:SOURCE_CHAT];
   // UITabBarItem *tbi=(UITabBarItem *)[self.tabBarController.tabBar.items objectAtIndex:TAB_INDEX_CHAT];
    /*
    UITabBarItem *tbi=(UITabBarItem *)[self.tabBarController.tabBar.items objectAtIndex:TAB_INDEX_CHAT];

    int badgeValue=[tbi.badgeValue intValue];
    
    badgeValue++;
    
    tbi.badgeValue=[NSString stringWithFormat:@"%lu",(unsigned long)badgeValue];
    */
    [_appDelegate setMessagesBadge:NO];
    
    //  [UIApplication sharedApplication].applicationIconBadgeNumber=badgeValue;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_UPDATE_MESSAGES object:nil];
    
    //}

    
    //[self.soundController playSystemSound:SOUND_CHAT_RECEIVED];
}
-(void)performFileUpload:(NSString *)pathComponent fromPeer:(MCPeerID *)peer{
    if(pathComponent)
    {
        if([_appDelegate.mcManager.sessions count]==0)
            return;
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        _documentsDirectory = [[NSString alloc] initWithString:[paths objectAtIndex:0]];
        //NSString * imagesPath=[AppDelegate getImagesPath];
        
        NSString *filePath =[_documentsDirectory stringByAppendingPathComponent:pathComponent];
        
        //NSLog(@"filePath=%@",filePath);
        
        if(![[NSFileManager defaultManager] fileExistsAtPath:filePath]){
#ifdef DEBUG
            NSLog(@"File %@ does not exist.",filePath);
#endif
            return;
        }
        
        NSURL *resourceURL = [NSURL fileURLWithPath:filePath];
        //if([pathComponent isEqualToString:@"\myphoto"]
        
        
        
        MCSession *session=[_appDelegate.mcManager GetSessionWithPeerID:peer];
        
        if(session==nil)
        {
#ifdef DEBUG
            NSLog(@"performFileUpload session is nil.");
#endif
            
            return;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            //NSProgress *progress =
            
            [session sendResourceAtURL:resourceURL
                              withName:[filePath lastPathComponent]
                                toPeer://[[_appDelegate.mcManager.session connectedPeers] objectAtIndex:buttonIndex]
             peer
                 withCompletionHandler:^(NSError *error) {
                     if (error) {
#ifdef DEBUG
                         NSLog(@"Error: %@", [error localizedDescription]);
#endif
                     }
                     
                     else{
                         
#ifdef DEBUG
                         NSLog(@"File %@ was successfully sent.",[filePath lastPathComponent]);
#endif
                         /*UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"MCDemo"
                          message:@"File was successfully sent."
                          delegate:self
                          cancelButtonTitle:nil
                          otherButtonTitles:@"Great!", nil];
                          
                          [alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:NO];
                          
                          [_arrFiles replaceObjectAtIndex:_selectedRow withObject:_selectedFile];
                          [_tblFiles performSelectorOnMainThread:@selector(reloadData)
                          withObject:nil
                          waitUntilDone:NO];*/
                     }
                 }];
            
            //NSLog(@"*** %f", progress.fractionCompleted);
            
            /* [progress addObserver:self
             forKeyPath:@"fractionCompleted"
             options:NSKeyValueObservingOptionNew
             context:nil];*/
        });
    }
}

-(void)didReceiveDataWithNotification:(NSNotification *)notification{
    dispatch_async(dispatch_get_main_queue(), ^{
        MCPeerID *peerID=[[notification userInfo] objectForKey:@"peerID"];
        PeerInfo *searchPeerID=[[PeerInfo alloc] initWithPeerID:peerID];// sessionID:session] ;
        
        MCSession *session=[[notification userInfo] objectForKey:@"session"];
        searchPeerID.sessionID=session;
        
        NSData *subData=[[notification userInfo] objectForKey:@"data"];
        
        if(![_appDelegate.mcManager.peerDevices containsObject:searchPeerID])
            return;
        
        NSInteger indexOfPeer = [_appDelegate.mcManager.peerDevices indexOfObject:searchPeerID];
        PeerInfo *peerInfo=[_appDelegate.mcManager.peerDevices objectAtIndex:indexOfPeer];
        
        
        NSError *error;
        NSData *decryptedData = [RNDecryptor decryptData:subData
                                            withPassword:A_SECRET_PASSWORD
                                                   error:&error];
        if(error!=nil)
            return;
        
        
        
        
        NSString *receivedText = [[NSString alloc] initWithData:decryptedData encoding:NSUTF8StringEncoding];
        
        
        
        
        
        BroadcastMessageAPI *message=[[BroadcastMessageAPI alloc] init];
        message.peerInfo=peerInfo;//[[notification userInfo] objectForKey:@"peerInfo"];
        message.deviceID=message.peerInfo.deviceID; //_appDelegate.userInfo.deviceID;
        message.deviceToken=message.peerInfo.deviceToken;
        message.createdon=[NSDate date];
        
        NSString *senderToken_len=[receivedText substringWithRange:NSMakeRange(0, 3)];
        
        NSRange r=[senderToken_len rangeOfString:@"00"];
        
        if(r.location==NSNotFound){
            
            r=[senderToken_len rangeOfString:@"0"];
            if(r.location==0)
                senderToken_len=[senderToken_len substringFromIndex:1];
            
        }
        else{
            
            if(r.location==0)
                senderToken_len=[senderToken_len substringFromIndex:2];
            
        }
        
        int len=[senderToken_len intValue];
        
        message.senderToken=[receivedText substringWithRange:NSMakeRange(3, len)];
        message.message_type=[receivedText substringWithRange:NSMakeRange(len+3, 2)];
        message.text=[receivedText substringFromIndex:(len+3+2)];//receivedText;
        
        message.sender= message.peerInfo.peerName;//peerID.displayName;
        
#ifdef DEBUG
        NSLog(@"receivedText=%@",receivedText);
        NSLog(@"message.senderToken=%@",message.senderToken);
        NSLog(@"message.text=%@",message.text);
        
#endif
        
        
        [self performMessageReceived:message];
        
    });
    
    
    
    
    
}

-(void)didReceiveAlertNotification:(NSString *)data{//:(NSNotification *)notification{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        BroadcastMessageAPI *message=[[BroadcastMessageAPI alloc] init];
        message.peerInfo=nil;//[[notification userInfo] objectForKey:@"peerInfo"];
        message.deviceID=_appDelegate.appConfig.device_id;
        message.deviceToken=_appDelegate.appConfig.user_deviceToken;
        message.createdon=[NSDate date];
        //message.peerInfo.peerID = [[notification userInfo] objectForKey:@"peerID"];
        // NSString *peerDisplayName = message.peerInfo.peerID.displayName;
        
        
        // NSData *receivedData = [[notification userInfo] objectForKey:@"data"];
        
        
        // NSString *receivedText = [[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding];
        
        message.message_type=[data substringWithRange:NSMakeRange(0, 2)];
        message.senderToken=[data substringWithRange:NSMakeRange(2, 36)];
        
        message.sender= [data substringWithRange:NSMakeRange(38, 24)];
        // [data substringWithRange:nsmake];
        
        message.text=[data substringFromIndex:62];//receivedText;
        
        //message.sender= message.peerInfo.peerID.displayName;
        
        // NSLog([NSString stringWithFormat:@"message_type=%@",message.message_type] );
        
        //[_appDelegate.messages addObject:message];
        
        
        //  [_tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
        /*
         UILocalNotification *local_notification = [[UILocalNotification alloc] init];
         //notification.alertBody = @"New VOIP call";
         //notification.alertAction = @"Answer";
         local_notification.soundName = UILocalNotificationDefaultSoundName;
         //if( [stringArray count]>1)
         //    local_notification.alertBody = stringArray[1];
         //else
         local_notification.alertBody = @"New message has arrived.";
         
         //notification.alertAction = @"Listen";
         
         
         [[UIApplication sharedApplication] presentLocalNotificationNow:local_notification];
         //[self updateMessages];
         */
        
        //    dispatch_async(dispatch_get_main_queue(), ^{
        //        /*crash when using sections
        //         [_tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:[_messages count]-1 inSection:0]] withRowAnimation:UITableViewRowAnimationBottom];
        //         */
        //        [_tableView reloadData];
        //    });
        
        
        
        [self performMessageReceived:message];
        //  [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_messages.count-1  inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        //[_tableView performSelector:@"reloadData" withObject:nil afterDelay:<#(NSTimeInterval)#>]
        
        //server side only
        //send notification
    });
    
    
}


-(void)didReceiveControlDataWithNotification:(NSNotification *)notification{
    //MCPeerID *peerID = [[notification userInfo] objectForKey:@"peerID"];
    //NSString *peerDisplayName = peerID.displayName;
    //NSUInteger msgid = (NSInteger)[[notification userInfo] objectForKey:@"msgid"];
    NSData *receivedData = [[notification userInfo] objectForKey:@"data"];
    
    
    NSString *receivedText = [[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding];
    if([receivedText isEqualToString:@"BYE"]){
        
    }
    //[_tvChat performSelectorOnMainThread:@selector(setText:) withObject:[_tvChat.text stringByAppendingString:[NSString stringWithFormat:@"%@ wrote:\n%@\n\n", peerDisplayName, receivedText]] waitUntilDone:NO];
    
}
/*
 -(void)didPaidOrderWithNotification:(NSNotification *)notification{
 
 NSString *receivedText = [[notification userInfo] objectForKey:@"data"];
 [self sendMyMessage:receivedText withMessageType:MSG_TYPE_PAID_ORDER];
 }
 
 -(void)didUnpaidOrderWithNotification:(NSNotification *)notification{
 
 NSString *receivedText = [[notification userInfo] objectForKey:@"data"];
 //NSLog(@"receivedText=%@",receivedText);
 [self sendMyMessage:receivedText withMessageType:MSG_TYPE_UNPAID_ORDER];
 }
 
 -(void)didConnectWithNotification:(NSNotification *)notification{
 NSString *receivedText = [[notification userInfo] objectForKey:@"data"];
 [self sendMyMessage:receivedText withMessageType:MSG_TYPE_CONNECTED];
 
 
 }
 
 
 
 
 -(void)sendMyMessage__:(NSString *)text withMessageType:(NSString *)messageType{
 if([messageType isEqualToString:MSG_TYPE_PAID_ORDER]||
 [messageType isEqualToString:MSG_TYPE_UNPAID_ORDER] ||
 [messageType isEqualToString:MSG_TYPE_REQUEST])
 {
 [self sendMyMessage:text withMessageType:messageType andLocalCopy:NO];
 }
 else{
 [self sendMyMessage:text withMessageType:messageType andLocalCopy:YES];
 }
 }
 
 */
//bec sending message is cetralized here
//this use to send message from other view controllers
-(void)hasDataToSendWithNotification:(NSNotification *)notification{
    BroadcastMessageAPI *message = [[notification userInfo] objectForKey:KEY_SEND_MESSAGE];
    //NSString *message_type = [[notification userInfo] objectForKey:KEY_SEND_MESSAGE_TYPE];
    [self sendMyMessage:message];
}
/*
 -(void)sendMyMessage:(BroadcastMessageAPI *)message{
 message.createdon=[NSDate date];
 message.peerInfo= _appDelegate.mcManager.myPeerInfo;
 message.deviceID=_appDelegate.appConfig.device_id;
 message.deviceToken=_appDelegate.appConfig.user_deviceToken;
 
 //added to fix cancel order from client
 if(!message.isForward){
 message.sender=_appDelegate.appConfig.device_name;
 message.fromDeviceID=(message.fromDeviceID!=nil)?message.fromDeviceID:_appDelegate.appConfig.device_id;
 message.imagefileuid=@"";
 }
 
 
 [_appDelegate.mcManager sendMyMessage:message];
 
 if(message.localCopy){
 [_appDelegate.messages addObject:message];
 
 [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateMessagesNotification" object:nil];
 
 }
 
 
 }
 */
-(void)forwardMessage:(BroadcastMessageAPI *)message{
    message.createdon=[NSDate date];
    message.peerInfo= _appDelegate.mcManager.myPeerInfo;
    //message.deviceID=_appDelegate.appConfig.device_id;
    message.deviceToken=_appDelegate.appConfig.user_deviceToken;
    
    
    [_appDelegate.mcManager sendMyMessage:message];
    
    if(message.localCopy){
        [_appDelegate.messages addObject:message];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateMessagesNotification" object:nil];
        
    }
    
    
}


//file download/upload
-(void)didStartReceivingResourceWithNotification:(NSNotification *)notification{
    /*[_arrFiles addObject:[notification userInfo]];
     [_tblFiles performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
     */
}


-(void)updateReceivingProgressWithNotification:(NSNotification *)notification{
    // NSProgress *progress = [[notification userInfo] objectForKey:@"progress"];
    /*
     NSDictionary *dict = [_arrFiles objectAtIndex:(_arrFiles.count - 1)];
     NSDictionary *updatedDict = @{@"resourceName"  :   [dict objectForKey:@"resourceName"],
     @"peerID"        :   [dict objectForKey:@"peerID"],
     @"progress"      :   progress
     };
     
     
     
     [_arrFiles replaceObjectAtIndex:_arrFiles.count - 1
     withObject:updatedDict];
     
     [_tblFiles performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
     */
}

#pragma mark FINISH DOWNLOAD

-(void)didFinishReceivingResourceWithNotification:(NSNotification *)notification{
    NSDictionary *dict = [notification userInfo];
    
    NSURL *localURL = [dict objectForKey:@"localURL"];
    NSString *resourceName = [dict objectForKey:@"resourceName"];
    
    //NSLog(@"localURL=%@ resourceName=%@",localURL,resourceName);
    
    //NSString *destinationPath = [_documentsDirectory stringByAppendingPathComponent:resourceName];
    NSString *destinationPath=[[AppDelegate getImagesPath] stringByAppendingPathComponent:resourceName];
    
    /* if([resourceName rangeOfString:PREFIX_ATTACHMENT].location==NSNotFound ){
     destinationPath=[[AppDelegate getImagesPath] stringByAppendingPathComponent:resourceName];
     }
     else{
     destinationPath=[[AppDelegate getImagesPath] stringByAppendingPathComponent:resourceName];
     }
     */
    NSURL *destinationURL = [NSURL fileURLWithPath:destinationPath];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSError *error;
    [fileManager copyItemAtURL:localURL toURL:destinationURL error:&error];
    
    if (error) {
#ifdef DEBUG
        NSLog(@"%@", [error localizedDescription]);
#endif
    }
    else{
        if([resourceName rangeOfString:PREFIX_MYPHOTO].location!=NSNotFound){
            
            //[self.tblConnectedDevices reloadData];
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_RELOAD_CONNECTION_VIEWCONTROLLER object:nil];
        }
        else if([resourceName rangeOfString:PREFIX_ATTACHMENT].location!=NSNotFound){
            if ([_appDelegate.messages_que count]>0) {
                /*
                 NSString *search=[resourceName stringByReplacingOccurrencesOfString:PREFIX_ATTACHMENT withString:@""];
                 search=[search stringByReplacingOccurrencesOfString:@"/" withString:@""];
                 */
                //NSString *search=resourceName;// [resourceName stringByReplacingOccurrencesOfString:PREFIX_ATTACHMENT withString:@""];
                //search=[search stringByReplacingOccurrencesOfString:@"/" withString:@""];
                
                NSString *pathExtension=[NSString stringWithFormat:@".%@",[resourceName pathExtension] ];
                
                NSString *imagefileuid=[resourceName stringByReplacingOccurrencesOfString:PREFIX_ATTACHMENT withString:@""];
                
                imagefileuid=[imagefileuid stringByReplacingOccurrencesOfString:pathExtension withString:@""];
                
                NSPredicate *predicate=[NSPredicate predicateWithFormat:@"imagefileuid==%@",imagefileuid];
                NSArray *result=[_appDelegate.messages_que filteredArrayUsingPredicate:predicate];
                if([result count]>0){
                    NSArray *tmp_q=[_appDelegate.messages_que copy];
                    
                    for(BroadcastMessageAPI *message in tmp_q){
                        [self processMessageQue:message];
                        [_appDelegate.messages_que removeObject:message];
                        
                    }
                }
            }
            
        }
        
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:resourceName object:nil userInfo:@{@"resourceName":resourceName}];
    
    /*
     [_arrFiles removeAllObjects];
     _arrFiles = nil;
     _arrFiles = [[NSMutableArray alloc] initWithArray:[self getAllDocDirFiles]];
     
     [_tblFiles performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
     */
}

-(void)didReceiveLocalChargeNotification:(NSNotification *)notification{
    
    
    
    STPCard *card=[[notification userInfo] objectForKey:KEY_CHARGE_CARDINFO];
    
    OrderHistory *order=[[notification userInfo] objectForKey:KEY_CHARGE_ORDER];
    
    order.orderSource=@ORDER_SOURCE_LOCAL;
    
    [self performChargeWithOrder:order cardInfo:card fromPeer:nil];
    
    
    
}

-(void)didReceiveLocalOrderNotification:(NSNotification *)notification{
    NSDictionary *dict_order=[[notification userInfo] objectForKey:@"order"];
    OrderHistory *order=[[OrderHistory alloc] initWithDictionary:dict_order];
    [self performOrder:order fromPeer:nil];
    
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




#pragma mark -remote notification
-(void)performUpdateSettingsNotification:(NSNotification *)notification{
    NSString *remote_alert=[notification.userInfo valueForKey:@"alert"];
    
    if([remote_alert isEqualToString:@"update"]){
        
    }
    else if([remote_alert isEqualToString:@"logout"]){
        _appDelegate.appConfig.user_userToken=@"";
        //_appDelegate.tabBarController=self.tabBarController;
        [_appDelegate showLoginController];
    }
}

#pragma mark BROADCAST PRODUCT UPDATE
//we need not use this bec it's resource intensive
/*
 -(void)performProductsUpdate:(NSNotification *)notification{
 
 NSArray *items =[notification.userInfo valueForKey:PRODUCTS_KEY];
 // InventoryModel *_inventoryModel =[InventoryModel publishedInstance];
 if([items count]==0)
 return;
 
 NSMutableArray *p_items=[NSMutableArray new];
 
 for (Product *p in items) {
 [p_items addObject:[p toNSDictionary]];
 }
 
 // NSDictionary *prod_dict=[product toNSDictionay];
 
 
 NSMutableDictionary *response_dict=[[NSMutableDictionary alloc] init];
 
 [response_dict setValue:KEY_ACTION_INVENTORY_UPDATE forKey:KEY_ACTION];
 // [response_dict setValue:@{@"menu":menu_dict,@"sale":sale_dict} forKey:KEY_ACTION_PARAM];
 [response_dict setValue:@{PRODUCTS_KEY:p_items} forKey:KEY_ACTION_PARAM];
 [response_dict setValue:KEY_ACTION_TYPE_RESPONSE forKey:KEY_ACTION_TYPE];
 
 NSError *error;
 
 NSData *jsonData=[NSJSONSerialization dataWithJSONObject:response_dict options:NSJSONWritingPrettyPrinted error:&error];
 
 if(error==nil){
 NSString *reply=[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
 BroadcastMessageAPI *message=[[BroadcastMessageAPI alloc] init];
 message.text=reply;
 message.isBroadcast=YES;
 //message.toPeerInfo=message.peerInfo;
 message.message_type=MSG_TYPE_RESPONSE;
 message.localCopy=NO;
 [self sendMyMessage:message];
 return;
 }
 }
 */

-(void)performProductsUpdate:(NSNotification *)notification{
    
    
    
    InventoryItem *param_inventory=[notification.userInfo valueForKey:KEY_SELECTED_INVENTORY];
    if(!param_inventory)
        return;
    
    InventoryItem *inventoryItem=_appDelegate.inventoryModel.inventory;//[InventoryModel activeInventory];
    if(!inventoryItem)
        return;
    
    if(![inventoryItem isEqual:param_inventory])
        return;
    
    NSDictionary *menu_dict=nil;
    
    if(inventoryItem!=nil){
        menu_dict=[inventoryItem toMenuDictionary:_appDelegate.appConfig];
    }
    
    if(menu_dict==nil){
        menu_dict=[NSDictionary new];
    }
    
    
    NSMutableDictionary *response_dict=[[NSMutableDictionary alloc] init];
    
    [response_dict setValue:KEY_ACTION_INVENTORY forKey:KEY_ACTION];
    
    [response_dict setValue:menu_dict forKey:KEY_ACTION_PARAM];
    [response_dict setValue:KEY_ACTION_TYPE_RESPONSE forKey:KEY_ACTION_TYPE];
    
    NSError *error;
    
    NSData *jsonData=[NSJSONSerialization dataWithJSONObject:response_dict options:NSJSONWritingPrettyPrinted error:&error];
    
    if(error==nil){
        /*
         NSString *reply=[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
         
         message.text=reply;
         message.isBroadcast=NO;
         message.toPeerInfo=message.peerInfo;
         message.message_type=MSG_TYPE_RESPONSE;
         message.localCopy=NO;
         [self sendMyMessage:message];
         return;
         */
        NSString *reply=[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        BroadcastMessageAPI *message=[[BroadcastMessageAPI alloc] init];
        message.text=reply;
        message.isBroadcast=YES;
        //message.toPeerInfo=message.peerInfo;
        message.message_type=MSG_TYPE_RESPONSE;
        message.localCopy=NO;
        [self sendMyMessage:message];
    }
    
}



#pragma mark BROADCAST SERVERINFO UPDATE
-(void)performServerInfoUpdate:(NSNotification *)notification{
    
    [self sendServerInfo:YES message:nil];
}

#pragma mark BROADCAST INVENTORY SETTINGS
-(void)broadcastInventorySettings:(NSNotification *)notification{
    /*
     InventoryItem *param_inventory=[notification.userInfo valueForKey:KEY_SELECTED_INVENTORY];
     if(param_inventory!=nil && param_inventory.isActive){
     return;
     */
    /*InventoryItem *inventoryItem=[InventoryModel activeInventory];
     if(!inventoryItem)
     return;
     
     if(![inventoryItem isEqual:param_inventory])
     return;
     */
    
    
    
    [self sendInventorySettings:YES message:nil];
    // }
    
}



//we didnt receive confirmation so we remote notify
/*
-(void)performAlertTimeout:(NSTimer *) timer{
    // NSDictionary *info=[timer userInfo];
#ifdef DEBUG
    NSLog(@"[timer userInfo]=%@",[timer userInfo]);
#endif
    
    // [self performRemoteNotificationWithMessage:[[timer userInfo] valueForKey:KEY_ALERT_TEXT] withDeviceToken:[[timer userInfo] valueForKey:KEY_DEVICETOKEN]];
    
    [self performRemoteNotificationWithMessage:[[timer userInfo] valueForKey:KEY_ALERT_PUSHTEXT] withDeviceToken:[[timer userInfo] valueForKey:KEY_DEVICETOKEN] withOrderID:[[timer userInfo] valueForKey:OrderIDKey] withOrderStatus:[[timer userInfo] valueForKey:OrderStatusKey]];
    if([timers containsObject:timer]){
        
        [timers removeObject:timer];
        
    }
}
*/
/*
 - (IBAction)login:(id)sender {
 if (self.usernameTextField.text.length > 0 && self.passwordTextField.text.length > 0) {
 NSString *password = [SSKeychain passwordForService:@"MyPhotos" account:self.usernameTextField.text];
 
 if (password.length > 0) {
 if ([self.passwordTextField.text isEqualToString:password]) {
 [self performSegueWithIdentifier:@"photosViewController" sender:nil];
 
 } else {
 UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Error Login" message:@"Invalid username/password combination." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
 [alertView show];
 }
 
 } else {
 UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"New Account" message:@"Do you want to create an account?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
 [alertView show];
 }
 
 } else {
 UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error Input" message:@"Username and/or password cannot be empty." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
 [alertView show];
 }
 }
 */

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
}


#pragma mark RECALCULATE TOTALS
- (NSInteger)total:(OrderHistory *)order {
    
    NSInteger total_result = 0;
    for (OrderItem* item in order.orderItems) {
        //total += product.price;
        total_result += item.price*item.quantity;
    }
    return total_result;
}

- (NSInteger)total_tax:(OrderHistory *)order{
    float tax_rate=_selectedInventory.salesTax;
    NSInteger total=[self total:order] ;
    //float total_tax=total*[[CheckoutCart sharedTaxInstance] floatValue];
    float total_tax=total*tax_rate;
    
    return total_tax;//total_tax*100;
}

- (NSInteger)grand_total:(OrderHistory *)order{
    float tax_rate=_selectedInventory.salesTax;
    NSInteger total=[self total:order] ;
    //float total_tax=total*tax_rate;
    
    return total+(total*tax_rate);
}

#pragma mark LOCATION
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    //self.currentLocation=[locations lastObject];
    //NSLog(@"OldLocation %f %f", oldLocation.coordinate.latitude, oldLocation.coordinate.longitude);
    
    
    _appDelegate.appConfig.device_last_location=[locations lastObject];
#if DEBUG
    NSLog(@"NewLocation %f %f", _appDelegate.appConfig.device_last_location.coordinate.latitude, _appDelegate.appConfig.device_last_location.coordinate.longitude);
#endif
    
}









//
//-(void)performPaidOrder:(BroadcastMessageAPI *)message{
//
//    //BOOL isPaid=[message.message_type isEqualToString:MSG_TYPE_PAID_ORDER];
//
//    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc ]init];
//    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
//    NSString *today=[dateFormatter stringFromDate:[NSDate date]];
//
//    OrderHistory *newOrder=[[OrderHistory alloc] init];
//    newOrder.orderDetailText=message.text;
//    newOrder.orderBy=message.sender;
//    newOrder.orderDateTime=[NSDate date];
//    newOrder.orderDate=[dateFormatter dateFromString:today];
//
//    newOrder.orderStatus=@ORDER_STATUS_PAID;
//
//
//
//    NSMutableArray *orders=[_appDelegate.historyModel.history valueForKey:today];
//    if(orders==nil)
//        orders=[NSMutableArray new];
//
//    _appDelegate.lastOrderNumber++;
//
//    newOrder.orderNumber=[NSNumber numberWithUnsignedInteger:_appDelegate.lastOrderNumber];//[NSNumber numberWithUnsignedInteger:[orders count]+1];
//
//    //[orders addObject:newOrder];
//
//    [_appDelegate.historyModel addHistory:today withOrder:newOrder];
//
//    _appDelegate.badgeOrderNumber++;
//    //NSDictionary *dict = @{ @"data": newOrder.orderDetailText
//    //,@"peerID": peerID
//    // };
//    UITabBarItem *tbi=(UITabBarItem *)[self.tabBarController.tabBar.items objectAtIndex:TAB_INDEX_MENU];
//
//    // if(_appDelegate.badgeOrderNumber<@0)
//    //   _appDelegate.badgeOrderNumber=0;
//
//    //if(_appDelegate.badgeOrderNumber==0)
//    //    tbi.badgeValue=nil;
//    // else
//    tbi.badgeValue =[NSString stringWithFormat:@"%lu",(unsigned long)_appDelegate.badgeOrderNumber];
//    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_UPDATE_HISTORY object:nil userInfo:nil];
//
//    //message.isUnicast=YES;
//    NSMutableString *reply=[NSMutableString string];
//   // if(isPaid){
//
//        [reply appendFormat:@"Hi %@, Your order and payment for\n%@\nHas been received and is being prepared. Thank You.\nOrder# %@. ",newOrder.orderBy,newOrder.orderDetailText,newOrder.orderNumber];
//        //NSLog([NSString stringWithFormat:@"reply=%@",reply]);
//
////    }
////    else{
////        [reply appendFormat:[NSString stringWithFormat:@"Hi %@, Your order for \n%@\nHas been received. Please pay cashier to complete this transaction. Thank You.\nOrder# %@",newOrder.orderBy,newOrder.orderDetailText,newOrder.orderNumber]];
////    }
//
//    [_appDelegate.messages addObject:message];
//    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_UPDATE_MESSAGES object:nil];
//
//    BroadcastMessageAPI *message=[[BroadcastMessageAPI alloc] init];
//    message.text=reply;
//    message.message_type=MSG_TYPE_DEF;
//    message.isBroadcast=NO;
//    message.toPeerInfo=peerInfo;
//    message.localCopy=NO;
//
//    [self sendMyMessage:message];
//
//    /*
//     UILocalNotification *local_notification = [[UILocalNotification alloc] init];
//     //notification.alertBody = @"New VOIP call";
//     //notification.alertAction = @"Answer";
//     local_notification.soundName = UILocalNotificationDefaultSoundName;
//     //if( [stringArray count]>1)
//     //    local_notification.alertBody = stringArray[1];
//     //else
//     if(isPaid)
//     local_notification.alertBody = @"New PAID order has arrived.";
//     else
//     local_notification.alertBody = @"New UNPAID order has arrived.";
//     //notification.alertAction = @"Listen";
//
//
//     [[UIApplication sharedApplication] presentLocalNotificationNow:local_notification];
//     //[self updateMessages];
//     */
//
//
//}
//
//-(void)performPaidOrUnpaidOrder:(BroadcastMessageAPI *)message{
//
//        BOOL isPaid=[message.message_type isEqualToString:MSG_TYPE_PAID_ORDER];
//
//        NSDateFormatter *dateFormatter=[[NSDateFormatter alloc ]init];
//        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
//        NSString *today=[dateFormatter stringFromDate:[NSDate date]];
//
//        OrderHistory *newOrder=[[OrderHistory alloc] init];
//        newOrder.orderDetailText=message.text;
//        newOrder.orderBy=message.sender;
//        newOrder.orderDateTime=[NSDate date];
//        newOrder.orderDate=[dateFormatter dateFromString:today];
//        newOrder.orderID=[[[UIDevice currentDevice] identifierForVendor]  UUIDString];
//
//        newOrder.orderStatus=(isPaid)?@ORDER_STATUS_PAID:@ORDER_STATUS_RECEIVED;
//
//
//
//        NSMutableArray *orders=[_appDelegate.historyModel.history valueForKey:today];
//        if(orders==nil)
//            orders=[NSMutableArray new];
//
//        _appDelegate.lastOrderNumber++;
//
//        newOrder.orderNumber=[NSNumber numberWithUnsignedInteger:_appDelegate.lastOrderNumber];//[NSNumber numberWithUnsignedInteger:[orders count]+1];
//
//        //[orders addObject:newOrder];
//
//        [_appDelegate.historyModel addHistory:today withOrder:newOrder];
//
//        _appDelegate.badgeOrderNumber++;
//        //NSDictionary *dict = @{ @"data": newOrder.orderDetailText
//        //,@"peerID": peerID
//        // };
//        UITabBarItem *tbi=(UITabBarItem *)[self.tabBarController.tabBar.items objectAtIndex:TAB_INDEX_MENU];
//
//        // if(_appDelegate.badgeOrderNumber<@0)
//        //   _appDelegate.badgeOrderNumber=0;
//
//        //if(_appDelegate.badgeOrderNumber==0)
//        //    tbi.badgeValue=nil;
//        // else
//        tbi.badgeValue =[NSString stringWithFormat:@"%lu",(unsigned long)_appDelegate.badgeOrderNumber];
//        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_UPDATE_HISTORY object:nil userInfo:nil];
//
//        //message.isUnicast=YES;
//        NSMutableString *reply=[NSMutableString string];
//        if(isPaid){
//
//            [reply appendFormat:@"Hi %@, Your order and payment for\n%@\nHas been received and is being prepared. Thank You.\nOrder# %@. ",newOrder.orderBy,newOrder.orderDetailText,newOrder.orderNumber];
//            //NSLog([NSString stringWithFormat:@"reply=%@",reply]);
//
//        }
//        else{
//            [reply appendFormat:@"Hi %@, Your order for \n%@\nHas been received. Please pay cashier to complete this transaction. Thank You.\nOrder# %@",newOrder.orderBy,newOrder.orderDetailText,newOrder.orderNumber];
//        }
//
//        [_appDelegate.messages addObject:message];
//        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_UPDATE_MESSAGES object:nil];
//
//        [self sendMyMessage:reply withMessageType:MSG_TYPE_DEF andLocalCopy:NO toPeerInfo:message.peerInfo isBroadcast:NO];
//
//        /*
//         UILocalNotification *local_notification = [[UILocalNotification alloc] init];
//         //notification.alertBody = @"New VOIP call";
//         //notification.alertAction = @"Answer";
//         local_notification.soundName = UILocalNotificationDefaultSoundName;
//         //if( [stringArray count]>1)
//         //    local_notification.alertBody = stringArray[1];
//         //else
//         if(isPaid)
//         local_notification.alertBody = @"New PAID order has arrived.";
//         else
//         local_notification.alertBody = @"New UNPAID order has arrived.";
//         //notification.alertAction = @"Listen";
//
//
//         [[UIApplication sharedApplication] presentLocalNotificationNow:local_notification];
//         //[self updateMessages];
//         */
//
//
//}
#pragma mark Server Functions

-(void)performChargeWithOrder: (OrderHistory *)order cardInfo:(STPCard *) card  fromPeer:(PeerInfo *) peerInfo{
    
    if(order.orderIsLive!=(_appDelegate.appConfig.visibility==VISIBILITY_LIVE)?YES:NO){
        
        return;
    }
    
    STPAPIClient *client;
    if(order.orderIsLive)
        client = [[STPAPIClient alloc] initWithPublishableKey:_appDelegate.appConfig.paymentPublishableKey];
    else
        client = [[STPAPIClient alloc] initWithPublishableKey:_appDelegate.appConfig.paymentPublishableKeyTest];
    
    [client createTokenWithCard:card completion:
     //get stripe token if stripe is used
     /*[Stripe createTokenWithCard:cardInfo publishableKey:STRIPE_TEST_PUBLIC_KEY completion:*/
     ^(STPToken* token,NSError *error){
         if(error)
             [self handleStripeError:error];
         else{
             order.chargeToken=token.tokenId;
             [_appDelegate.historyModel addOrUpdateHistory:order];
             BOOL charged=[PaymentManager performPostCharge:order cardInfo:card isCaptured:YES];
             
             if(charged){
                 [self performChargeSuccess:order cardInfo:card fromPeer:peerInfo];
             }
             else{
                 [self performChargeFail:order fromPeer:peerInfo];
             }
         }
     }];
    
    
    
    
}

-(void)performChargeWithOrderWithToken: (OrderHistory *)order cardInfo:(STPCard *)card fromPeer:(PeerInfo *)peerInfo {
    
    //NSMutableString *reply=[NSMutableString string];
    //check store
    
    
    /*for(Order *item in order.orderItems){
     //if(item.)
     }
     */
    //amountdue 0 means already paid
    //so no need to charge
    /*if([order.orderAmountDue floatValue]<=0)
     {
     #ifdef DEBUG
     NSLog(@"Amount due is <= 0. No charge is made.");
     #endif
     return;
     }
     
     //for now we will not support muliple charges
     //so we should not process
     if([order.chargeAmount doubleValue]<[order.orderAmountDue doubleValue])
     {
     #ifdef DEBUG
     NSLog(@"Charge Amount due is < Amount Due. No charge is made.");
     #endif
     return;
     }
     */
    //get stripe token if stripe is used
    /*STPAPIClient *client = [[STPAPIClient alloc] initWithPublishableKey:STRIPE_TEST_PUBLIC_KEY];
     
     [client createTokenWithCard:cardInfo completion:
     
     
     ^(STPToken* token,NSError *error){
     if(error)
     [self handleStripeError:error];
     else
     [self performPostCharge:order];
     }];
     */
    
    //[self performPostCharge:order cardInfo:card fromPeer:peerInfo];
    BOOL charged=[PaymentManager performPostCharge:order cardInfo:card isCaptured:YES];
    if(charged){
        [self performChargeSuccess:order cardInfo:card fromPeer:peerInfo];
    }
    else{
        [self performChargeFail:order fromPeer:peerInfo];
    }
    
}


-(void)performOrder: (OrderHistory *)order fromPeer:(PeerInfo *)peerInfo {
    //we assume order is already validated
    
    NSMutableString *reply=[NSMutableString string];
    if([order.orderSource isEqualToNumber:@ORDER_SOURCE_REMOTE]){
        //check store
        if(![order.orderStoreID isEqualToString:_appDelegate.appConfig.device_id]){
            order.orderReply=REPLY_STORE_INVALID;
            
            [ reply appendString:[order toChargeResponseString]];
            if(reply!=nil){
                
                
                BroadcastMessageAPI *message=[[BroadcastMessageAPI alloc] init];
                message.text=reply;
                message.isBroadcast=NO;
                message.toPeerInfo=peerInfo;
                message.message_type=MSG_TYPE_RESPONSE;
                message.localCopy=NO;
                [_appDelegate.cnnManager sendMyMessage:message];
            }
            return;
        }
    }
    
    //NOTE: to make things less comple we comment the ff blocks,
    //lets just do separate transaction for each
    //but we need to setup a rule so that max orders per customer is implemented
    
    //check if unpaid existing order
    /*OrderHistory *existing_unpaidOrder=[_appDelegate searchUnpaidOrderWithDeviceID:order.orderDeviceID withStoreID:order.orderStoreID];
     
     if(existing_unpaidOrder!=nil)
     {
     //in this case we asume the user has one previous unpaid entry in his history with the storeid
     //before the client app pass the order it should set the deleteunpaid to NO
     //the client app should ask the user if it will add or remove
     //order.orderNumber=existing_unpaidOrder.orderNumber;//orderNumber;
     for(OrderItem *new_item in order.orderItems){
     NSPredicate *predicate=[NSPredicate predicateWithFormat:@"productID=%i",new_item.productID];
     NSArray *result=[existing_unpaidOrder.orderItems filteredArrayUsingPredicate:predicate];
     if([result count]>0){
     OrderItem *existing_item=[result firstObject];
     existing_item.quantity=existing_item.quantity+new_item.quantity;
     
     }
     else{
     if(existing_unpaidOrder.orderItems==nil)
     existing_unpaidOrder.orderItems=[NSMutableArray new];
     [existing_unpaidOrder.orderItems addObject:new_item];
     }
     }
     //recalculate totals
     existing_unpaidOrder.orderTaxRate=@(_appDelegate.appConfig.salesTax/100);
     existing_unpaidOrder.orderSubtotal=[self total:order];
     existing_unpaidOrder.orderTotalTax=@([existing_unpaidOrder.orderSubtotal floatValue]*[existing_unpaidOrder.orderTaxRate floatValue]);
     existing_unpaidOrder.orderTotal=@([existing_unpaidOrder.orderSubtotal floatValue]+[existing_unpaidOrder.orderTotalTax floatValue]);//@([self grand_total:order]);
     NSInteger totalCents=[existing_unpaidOrder.orderTotal doubleValue]*100;
     existing_unpaidOrder.chargeAmount=[NSNumber numberWithInteger:totalCents];
     [_appDelegate.historyModel addOrUpdateHistory:order.orderDay withOrder:existing_unpaidOrder];
     
     [self performOrderSuccess:order fromPeer:peerInfo];
     
     }
     else{
     */
    //new_order=order;
    //recalculate totals
    //InventoryItem *inventoryItem=[InventoryModel activeInventory];
    NSArray *unpaidOrders=[_appDelegate searchUnpaidOrderWithDeviceID:order.orderDeviceID withStoreID:order.orderStoreID isLive:(_appDelegate.appConfig.visibility==VISIBILITY_LIVE)?YES:NO];
    if(_selectedInventory.maxUnpaidOrdersPerCustomer>0 && [unpaidOrders count]>=_selectedInventory.maxUnpaidOrdersPerCustomer){
        //send notification
        BroadcastMessageAPI *message=[[BroadcastMessageAPI alloc] init];
        message.text=[NSString stringWithFormat:@"You have %lu Unpaid orders.\nPlease pay or cancel one or more Unpaid orders.",(unsigned long)[unpaidOrders count]];//peer.peerID.displayName];
        message.isBroadcast=NO;
        message.toPeerInfo=peerInfo;
        message.fromDeviceID=_appDelegate.mcManager.myPeerInfo.deviceID;
        message.sender=_appDelegate.mcManager.myPeerInfo.peerName;
        message.message_type=MSG_TYPE_DEF;//MSG_TYPE_RESPONSE;
        message.localCopy=NO;
        
        [_appDelegate.cnnManager sendMyMessage:message];
        return;
    }
    
    order.orderTax=_selectedInventory.salesTax;//_appDelegate.appConfig.salesTax/100;
    order.orderSubtotal=[self total:order]; //cents
    
    //TODO: discounts
    if([order.orderDiscounts count]>0){
        for(DiscountItem *di in order.orderDiscounts){
            order.orderSubtotal=order.orderSubtotal+di.price;
        }
    }
    
    order.orderTotalTax=order.orderSubtotal * (order.orderTax/100); //cents
    
    order.orderTotal=order.orderSubtotal+order.orderTotalTax;//@([self grand_total:order]);
    
    //always add tip after tax
    if(order.orderTip>0){
        order.orderTotal=order.orderTotal+order.orderTip;
    }
    
    order.chargeAmount=order.orderTotal;
    order.orderAmountDue=order.chargeAmount;
    
    
    
    [self performOrderSuccess:order fromPeer:peerInfo];
    
    
}
- (NSString *)card_type_short:(STPCard *)card {
    switch (card.brand) {
        case STPCardBrandAmex:
            return @"AMEX";
        case STPCardBrandDinersClub:
            return @"DINER";
        case STPCardBrandDiscover:
            return @"DISCO";
        case STPCardBrandJCB:
            return @"JCB";
        case STPCardBrandMasterCard:
            return @"MC";
        case STPCardBrandVisa:
            return @"VISA";
        default:
            return @"Unknown";
    }
}


-(void)performChargeSuccess:(OrderHistory *)order cardInfo:(STPCard *) cardInfo fromPeer:(PeerInfo *)peerInfo{
    
    //we dont need to record to prevent spam
    
    NSString *last4=cardInfo.last4;
    if (last4==nil) {
        if(cardInfo.number.length >=4){
            last4=[cardInfo.number substringFromIndex:(cardInfo.number.length-4)];
        }
    }
    
    
    
    
    NSDictionary *payment=@{KEY_AMOUNT:@(order.chargeAmount),
                            KEY_CURRENCY:order.chargeCurrency,
                            KEY_CHARGE_TOKEN:order.chargeToken,
                            KEY_CARD4:[NSString stringWithFormat:@"%@-%@",[self card_type_short:cardInfo], last4],
                            KEY_PAYMENT_TYPE:ORDER_PAY_TYPE_CCARD};
    
    if(order.orderPayments==nil)
        order.orderPayments=[NSMutableArray new];
    
    [order.orderPayments addObject:payment];
    
    
    
    NSInteger amountDue=order.orderAmountDue-order.chargeAmount;
    
    order.orderAmountDue=amountDue;
    
    if(amountDue>0){
        order.orderStatus=@ORDER_STATUS_RECEIVED;//@ORDER_STATUS_UNPAID;
        order.orderIsPaid=NO;
    }
    else{
        order.orderStatus=@ORDER_STATUS_RECEIVED;
        order.orderIsPaid=YES;
        // [self.soundController playSystemSound:SOUND_ORDER_RECEIVED];
    }
    //if order is not assigned yet, assign an order number
    if(order.orderNumber==nil || [order.orderNumber isEqualToNumber:@0]){
        _appDelegate.historyModel.lastOrderNumber++;
        order.orderNumber=[NSNumber numberWithUnsignedInteger:_appDelegate.historyModel.lastOrderNumber];
    }
    
    
    //}
    
    
    [_appDelegate.historyModel addOrUpdateHistory:order];
    
    
    //if(amountDue<=0){
        
        //_appDelegate.badgeOrderNumber++;
        [_appDelegate updateBadgeOrders];
        
        
    //}
    
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_UPDATE_HISTORY object:nil userInfo:nil];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_PRINT_ORDER object:nil userInfo:@{@"order":order}];
    
    
    ///Send confirmation email
    if(cardInfo.email.length>0){
        RWEmailManager* emailManager = [[RWEmailManager alloc] initWithRecipient:cardInfo.name
                                                                  recipientEmail:cardInfo.email];
        
        [emailManager sendConfirmationEmail];
    }
    
    //send response
    if([order.orderSource isEqualToNumber:@ORDER_SOURCE_REMOTE]){
        NSString *reply=[order toChargeResponseString];
        if(reply!=nil){
            BroadcastMessageAPI *message=[[BroadcastMessageAPI alloc] init];
            message.text=reply;
            message.isBroadcast=NO;
            message.fromDeviceID=_appDelegate.mcManager.myPeerInfo.deviceID;
            message.toPeerInfo=peerInfo;
            message.message_type=MSG_TYPE_RESPONSE;
            message.localCopy=NO;
            [_appDelegate.cnnManager sendMyMessage:message];
        }
    }
    else{
        if(order.orderIsPaid)
            [[NSNotificationCenter defaultCenter] postNotificationName:([order.chargePayType isEqualToString:ORDER_PAY_TYPE_CCARD])?NOTIFY_CHARGE_SUCCESS_CARD:NOTIFY_CHARGE_SUCCESS_CASH
                                                                object:nil
                                                              userInfo:nil];
        
        else if([order.orderStatus isEqualToNumber:@ORDER_STATUS_FAILED])
            [[NSNotificationCenter defaultCenter] postNotificationName:([order.chargePayType isEqualToString:ORDER_PAY_TYPE_CCARD])?NOTIFY_CHARGE_FAIL_CARD:NOTIFY_CHARGE_FAIL_CASH
                                                                object:nil
                                                              userInfo:nil];
        
    }
}

-(void)performOrderSuccess:(OrderHistory *)order fromPeer:(PeerInfo *)peerInfo{
    
    if(order.orderAmountDue>0){
        order.orderIsPaid=NO;
        order.orderStatus=@ORDER_STATUS_RECEIVED;//@ORDER_STATUS_UNPAID;
    }
    else{
        order.orderIsPaid=YES;
        order.orderStatus=@ORDER_STATUS_RECEIVED;
    }
    //assing an order number
    _appDelegate.historyModel.lastOrderNumber++;
    order.orderNumber=[NSNumber numberWithUnsignedInteger:_appDelegate.historyModel.lastOrderNumber];
    
    
    [_appDelegate.historyModel addOrUpdateHistory:order];
    
    //_appDelegate.badgeOrderNumber++;
    
    [_appDelegate updateBadgeOrders];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_UPDATE_HISTORY object:nil userInfo:nil];
    
    //send response
    if([order.orderSource isEqualToNumber:@ORDER_SOURCE_REMOTE]){
        NSString *reply=[order toChargeResponseString];
        if(reply!=nil){
            //NSString *reply=[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            //NSLog(@"reply=%@",reply);
            BroadcastMessageAPI *message=[[BroadcastMessageAPI alloc] init];
            message.text=reply;
            message.isBroadcast=NO;
            message.toPeerInfo=peerInfo;
            message.message_type=MSG_TYPE_RESPONSE;
            message.localCopy=NO;
            [_appDelegate.cnnManager sendMyMessage:message];
        }
    }
    else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success"
                                                        message:@"We received your order. Thank You."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        
    }
}
/*
 -(void)performCashChargeSuccess:(OrderHistory *)newOrder{
 
 
 _appDelegate.badgeOrderNumber++;
 
 UITabBarItem *tbi=(UITabBarItem *)[self.tabBarController.tabBar.items objectAtIndex:TAB_INDEX_MENU];
 
 
 tbi.badgeValue =[NSString stringWithFormat:@"%lu",(unsigned long)_appDelegate.badgeOrderNumber];
 [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_UPDATE_HISTORY object:nil userInfo:nil];
 
 //send response
 
 NSString *reply=[newOrder toChargeResponseString];
 if(reply!=nil){
 //NSString *reply=[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
 //NSLog(@"reply=%@",reply);
 [self sendMyMessage:reply withMessageType:MSG_TYPE_RESPONSE andLocalCopy:NO];
 }
 }
 */

-(void)performChargeFail:(OrderHistory *)order fromPeer:(PeerInfo *)peerInfo{
    
    order.orderStatus=@ORDER_STATUS_FAILED;
    order.orderReply=REPLY_PAYMENT_FAILED;
    
    //order.orderStatus=@ORDER_STATUS_RECEIVED;
    //assing an order number
    /*if (order.orderNumber==0) {
     
     
     _appDelegate.lastOrderNumber++;
     order.orderNumber=[NSNumber numberWithUnsignedInteger:_appDelegate.lastOrderNumber];
     
     _appDelegate.badgeOrderNumber++;
     
     UITabBarItem *tbi=(UITabBarItem *)[self.tabBarController.tabBar.items objectAtIndex:TAB_INDEX_MENU];
     
     
     tbi.badgeValue =[NSString stringWithFormat:@"%lu",(unsigned long)_appDelegate.badgeOrderNumber];
     }
     [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_UPDATE_HISTORY object:nil userInfo:nil];
     */
    //send response
    if([order.orderSource isEqualToNumber:@ORDER_SOURCE_REMOTE]){
        NSString *reply=[order toChargeResponseString];
        if(reply!=nil){
            BroadcastMessageAPI *message=[[BroadcastMessageAPI alloc] init];
            message.text=reply;
            message.isBroadcast=NO;
            message.toPeerInfo=peerInfo;
            message.message_type=MSG_TYPE_RESPONSE;
            message.localCopy=NO;
            //[self sendMyMessage:message];
            [_appDelegate.cnnManager sendMyMessage:message];
        }
    }
    else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Payment not successful"
                                                        message:@"Please try again."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        
    }
    
}

-(void)performReplyToOrder:(OrderHistory *)order toPeer:(PeerInfo *)peer {
    NSMutableString *reply=[NSMutableString string];
    
    //[reply appendString:[order toChargeResponseString]];
    NSString *msg=@"Menu has changed.";
    if(order.errorMessage!=nil && order.errorMessage.length>0)
        msg=order.errorMessage;
    
    [reply appendString:msg];//[order toChargeResponseString]];
    BroadcastMessageAPI *message=[[BroadcastMessageAPI alloc] init];
    message.text=reply;
    message.isBroadcast=NO;
    message.toPeerInfo=peer;
    message.message_type=MSG_TYPE_RESPONSE;
    message.localCopy=NO;
    [_appDelegate.cnnManager sendMyMessage:message];
}
#pragma mark BROADCAST UPDATEINFO
-(void)processUpdateInfo:(BroadcastMessageAPI *)message{
    NSDictionary *dictionary=[AppDelegate fromJsonString:message.text];
    if(dictionary==nil)
        return;
    /*if(_appDelegate.mcManager.myPeerInfo.peers==nil)
     _appDelegate.mcManager.myPeerInfo.peers=[NSMutableArray new];
     
     NSString *deviceid=[dictionary valueForKey:@"deviceid"];
     if(!deviceid)
     return;
     
     
     
     
     
     NSPredicate *p=[NSPredicate predicateWithFormat:@"deviceID==%@",deviceid];
     NSArray *result=[_appDelegate.mcManager.peerDevices filteredArrayUsingPredicate:p];
     if([result count]==0)
     return;
     */
    
    PeerInfo *peer=message.peerInfo;//[result firstObject];
    
    peer.peerName=[dictionary valueForKey:@"peername"] ;
    peer.photoMD5=[dictionary valueForKey:@"photomd5"];
    
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"DeviceId=%@",peer.deviceID];
    NSArray *results=[_appDelegate.mcManager.myPeerInfo.peers filteredArrayUsingPredicate:predicate];
    NSString *text=@"";
    
    //NSDictionary *peer_dict=nil;
    if ([results count]==0){
        NSDictionary *peer_dict=@{@"Title":peer.peerName//peerID.displayName
                                  ,DeviceIdKey:peer.deviceID
                                  ,@"PeerGroup":peer.peerGroup
                                  ,@"PhotoMD5":peer.photoMD5};
        [_appDelegate.mcManager.myPeerInfo.peers addObject:peer_dict];
    }
    else
    {
        NSMutableDictionary *existing_peer=[[results firstObject] mutableCopy];
        
        
        NSString *oldTitle=[existing_peer valueForKey:@"Title"];
        NSString *newTitle=peer.peerName;
        
        NSString *oldPhoto=[existing_peer valueForKey:@"PhotoMD5"];
        NSString *newPhoto=peer.photoMD5;
        
        
        [existing_peer setValue:peer.peerName forKey:@"Title"];
        
        [existing_peer setValue:peer.photoMD5 forKey:@"PhotoMD5"];
        
        
        if(![oldTitle isEqualToString:newTitle]){
            text=[text stringByAppendingString:[NSString stringWithFormat:@"%@ has changed name to %@.\n",oldTitle,newTitle]];
        }
        
        if(![oldPhoto isEqualToString:newPhoto]){
            text=[text stringByAppendingString:[NSString stringWithFormat:@"%@ has changed photo.",oldTitle]];
        }
        
        
        
    }
    
    [_appDelegate.cnnManager downloadPeerPhoto:peer];
    
    
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_UPDATE_PEERS object:nil userInfo:@{@"data":dictionary}];
    
    BroadcastMessageAPI *update_message=[[BroadcastMessageAPI alloc] init];
    update_message.text=[Util toJsonString:@{@"deviceid":peer.deviceID,@"peername":peer.peerName, @"status":@"connected",@"peergroup":peer.peerGroup,@"photomd5":(peer.photoMD5!=nil)?peer.photoMD5:@"",@"text":text}];
    update_message.isBroadcast=YES;
    update_message.toPeerInfo=nil;
    update_message.message_type=MSG_TYPE_UPDATE_PEERS;
    update_message.localCopy=NO;
    
    [_appDelegate.cnnManager sendMyMessage:update_message];
    
    
}
-(void)sendInventorySettings:(BOOL) isBroadcast message:(BroadcastMessageAPI *)message{
    /* NSMutableArray *array_peers=[NSMutableArray new];
     
     
     for(PeerInfo *peer in _appDelegate.mcManager.peerDevices){
     //for(PeerInfo *peer in _appDelegate.mcManager.myPeerInfo.peers){
     NSDictionary *peer_dict=@{@"Title":peer.peerName//peerID.displayName
     ,DeviceIdKey:peer.deviceID
     ,@"PeerGroup":peer.peerGroup
     ,@"PhotoMD5":peer.photoMD5};
     [array_peers addObject:peer_dict];
     }
     
     
     [array_peers addObject:@{@"Title":_appDelegate.mcManager.myPeerInfo.peerID.displayName
     ,DeviceIdKey:_appDelegate.mcManager.myPeerInfo.deviceID
     ,@"PeerGroup":PEER_GROUP_STAFFS
     ,@"PhotoMD5":(_appDelegate.mcManager.myPeerInfo.photoMD5!=nil)?_appDelegate.mcManager.myPeerInfo.photoMD5:@""}];
     
     _appDelegate.appConfig.device_ssid=[AppDelegate currentWifiSSID];
     */
    /*
    if(_appDelegate.currentInventory==nil){
        _appDelegate.currentInventory=_appDelegate.inventoryModel.inventory;//[InventoryModel activeInventory];
        if(_appDelegate.currentInventory==nil)
            _appDelegate.currentInventory=[InventoryItem new];
    }
    */
    _selectedInventory=_appDelegate.inventoryModel.inventory;//_appDelegate.currentInventory;
    
    
    //if(_selectedInventory==nil)
    // return;
    /*
     if(!_selectedInventory.currency){
     _selectedInventory.currency=@"usd";
     _selectedInventory.currencySymbol=@"$";
     }
     */
    NSDictionary *info_dict=@{
                              
                              /*@"isLive":@(_appDelegate.appConfig.isLive)
                               ,@"useClientToken":@(_appDelegate.appConfig.useClientToken)
                               ,@"paymentPublishableKey":_appDelegate.appConfig.paymentPublishableKey
                               ,@"paymentPublishableKeyTest":_appDelegate.appConfig.paymentPublishableKeyTest
                               ,@"device_lat":[NSNumber numberWithFloat:_appDelegate.appConfig.device_lat]
                               ,@"device_lng":[NSNumber numberWithFloat:_appDelegate.appConfig.device_lng]
                               ,@"device_address":_appDelegate.appConfig.device_address
                               ,@"device_num":@(_appDelegate.appConfig.device_num)
                               ,@"device_ssid":(_appDelegate.appConfig.device_ssid==nil)?@"":_appDelegate.appConfig.device_ssid
                               ,@"enableChat":@(_appDelegate.appConfig.enableChat)
                               ,@"enablePhotoSharing":@(_appDelegate.appConfig.enablePhotoSharing)
                               
                               ,welcomeMessageKey:(_appDelegate.appConfig.welcomeMessage==nil)?@"":_appDelegate.appConfig.welcomeMessage
                               //,@"staffs":staffs_array
                               //,@"customers":customers_array
                               
                               ,maxMessagesPerUserKey:@(_appDelegate.appConfig.maxMessagesPerUser)
                               ,expireMessageInSecKey:@(_appDelegate.appConfig.expireMessageInSec)
                               ,maxUploadSizeKBKey:@1000//@(_appDelegate.appConfig.maxUploadSizeKB)
                               
                               ,@"peers":array_peers
                               */
                              
                              @"currency":_selectedInventory.currency
                              ,@"currencySymbol":_selectedInventory.currencySymbol
                              
                              
                              
                              ,salesTaxKey:@(_selectedInventory.salesTax)//@7.5
                              ,salesTipKey:@(_selectedInventory.salesTip)
                              ,shippingCostKey:@(_selectedInventory.shippingCost)
                              //,@"acceptedCards": (!_appDelegate.appConfig.acceptedCards)?@"":_appDelegate.appConfig.acceptedCards
                              ,@"acceptCCard":@(_selectedInventory.acceptCCard)
                              ,@"acceptCash":@(_selectedInventory.acceptCash)//@YES
                              ,@"useApplePay":@(_selectedInventory.useApplePay)
                              
                              
                              ,minChargeAmountKey:@(_selectedInventory.minChargeAmount)//@1.0
                              ,maxChargeAmountKey:@(_selectedInventory.maxChargeAmount)
                              ,maxUnpaidOrdersPerCustomerKey:@(_selectedInventory.maxUnpaidOrdersPerCustomer)
                              
                              ,refundLevelKey:@(_selectedInventory.refundLevel)//@3//@(_appDelegate.appConfig.refundLevel)
                              
                              
                              };
    
    NSMutableDictionary *response_dict=[[NSMutableDictionary alloc] init];
    
    [response_dict setValue:KEY_ACTION_INVENTORY_SETTINGS forKey:KEY_ACTION];
    [response_dict setValue:info_dict forKey:KEY_ACTION_PARAM];
    [response_dict setValue:KEY_ACTION_TYPE_RESPONSE forKey:KEY_ACTION_TYPE];
    
    NSError *error;
    
    NSData *jsonData=[NSJSONSerialization dataWithJSONObject:response_dict options:NSJSONWritingPrettyPrinted error:&error];
    
    if(error==nil){
        NSString *reply=[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        if(isBroadcast){
            message=[[BroadcastMessageAPI alloc] init];
            message.text=reply;
            message.isBroadcast=YES;
            message.toPeerInfo=nil;//message.peerInfo;
            message.message_type=MSG_TYPE_RESPONSE;
            message.localCopy=NO;
            [_appDelegate.cnnManager sendMyMessage:message];
            
        }
        else{
            message.text=reply;
            message.isBroadcast=NO;
            message.toPeerInfo=message.peerInfo;
            message.message_type=MSG_TYPE_RESPONSE;
            message.localCopy=NO;
            [_appDelegate.cnnManager sendMyMessage:message];
        }
        //return;
    }
    
}
//ignore peerinfo if broadcast
-(void)sendServerInfo:(BOOL) isBroadcast message:(BroadcastMessageAPI *)message{
    NSMutableArray *array_peers=[NSMutableArray new];
    
    // if(_appDelegate.mcManager.peerDevices){
    for(PeerInfo *peer in _appDelegate.mcManager.peerDevices){
        //for(PeerInfo *peer in _appDelegate.mcManager.myPeerInfo.peers){
        NSDictionary *peer_dict=@{@"Title":peer.peerName//peerID.displayName
                                  ,DeviceIdKey:peer.deviceID
                                  ,@"PeerGroup":peer.peerGroup
                                  ,@"PhotoMD5":peer.photoMD5};
        [array_peers addObject:peer_dict];
    }
    // }
    
    [array_peers addObject:@{@"Title":_appDelegate.mcManager.myPeerInfo.peerID.displayName
                             ,DeviceIdKey:_appDelegate.mcManager.myPeerInfo.deviceID
                             ,@"PeerGroup":PEER_GROUP_STAFFS
                             ,@"PhotoMD5":(_appDelegate.mcManager.myPeerInfo.photoMD5!=nil)?_appDelegate.mcManager.myPeerInfo.photoMD5:@""}];
    
    _appDelegate.appConfig.device_ssid=[AppDelegate currentWifiSSID];
    NSDictionary *info_dict=@{
                              //@"deviceID":_appDelegate.userInfo.deviceID
                              //,@"deviceToken":_appDelegate.userInfo.deviceToken
                              //,@"homeUrl":_appDelegate.userInfo.homeUrl
                              INVENTORYID_KEY:_appDelegate.inventoryModel.inventory.inventoryId,
                              @"isLive":@((_appDelegate.appConfig.visibility==VISIBILITY_LIVE)?YES:NO)
                              ,@"useClientToken":@(_appDelegate.appConfig.useClientToken)
                              ,@"paymentPublishableKey":_appDelegate.appConfig.paymentPublishableKey
                              ,@"paymentPublishableKeyTest":_appDelegate.appConfig.paymentPublishableKeyTest
                              ,@"currency":(_selectedInventory.currency==nil)?@"usd":_selectedInventory.currency
                              ,@"device_lat":[NSNumber numberWithFloat:_appDelegate.appConfig.device_lat]
                              ,@"device_lng":[NSNumber numberWithFloat:_appDelegate.appConfig.device_lng]
                              ,storeIDKey:_appDelegate.appConfig.storeID
                              ,@"device_address":_appDelegate.appConfig.device_address
                              ,@"device_num":@(_appDelegate.appConfig.device_num)
                              ,@"device_ssid":(_appDelegate.appConfig.device_ssid==nil)?@"":_appDelegate.appConfig.device_ssid
                              //,@"device_status":[NSNumber numberWithInt:_appDelegate.appConfig.device_status]
                              
                              ,@"tax":@(_selectedInventory.salesTax)//@7.5
                              ,@"acceptedCards":(!_appDelegate.appConfig.acceptedCards)?@"":_appDelegate.appConfig.acceptedCards
                              ,@"acceptCCard":@(_selectedInventory.acceptCCard)
                              ,@"acceptCash":@(_selectedInventory.acceptCash)//@YES
                              ,@"useApplePay":@(_selectedInventory.useApplePay)
                              
                              
                              ,minChargeAmountKey:@(_selectedInventory.minChargeAmount)//@1.0
                              ,maxChargeAmountKey:@(_selectedInventory.maxChargeAmount)
                              ,maxUnpaidOrdersPerCustomerKey:@(_selectedInventory.maxUnpaidOrdersPerCustomer)
                              
                              ,refundLevelKey:@(_selectedInventory.refundLevel)//@3//@(_appDelegate.appConfig.refundLevel)
                              
                              ,@"enableChat":@(_appDelegate.appConfig.enableChat)
                              ,@"enablePhotoSharing":@(_appDelegate.appConfig.enablePhotoSharing)
                              
                              ,welcomeMessageKey:(_appDelegate.appConfig.welcomeMessage==nil)?@"":_appDelegate.appConfig.welcomeMessage
                              //,@"staffs":staffs_array
                              //,@"customers":customers_array
                              
                              ,maxMessagesPerUserKey:@(_appDelegate.appConfig.maxMessagesPerUser)
                              ,expireMessageInSecKey:@(_appDelegate.appConfig.expireMessageInSec)
                              ,maxUploadSizeKBKey:@1000//@(_appDelegate.appConfig.maxUploadSizeKB)
                              
                              ,@"peers":array_peers
                              };
    
    NSMutableDictionary *response_dict=[[NSMutableDictionary alloc] init];
    
    [response_dict setValue:KEY_ACTION_SERVERINFO forKey:KEY_ACTION];
    [response_dict setValue:info_dict forKey:KEY_ACTION_PARAM];
    [response_dict setValue:KEY_ACTION_TYPE_RESPONSE forKey:KEY_ACTION_TYPE];
    
    NSError *error;
    
    NSData *jsonData=[NSJSONSerialization dataWithJSONObject:response_dict options:NSJSONWritingPrettyPrinted error:&error];
    
    if(error==nil){
        NSString *reply=[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        if(isBroadcast){
            message=[[BroadcastMessageAPI alloc] init];
            message.text=reply;
            message.isBroadcast=YES;
            message.toPeerInfo=nil;//message.peerInfo;
            message.message_type=MSG_TYPE_RESPONSE;
            message.localCopy=NO;
#ifdef DEBUG
            NSLog(@"Sending %@",MSG_TYPE_REQUEST_SERVERINFO);
#endif
            [self sendMyMessage:message];
            
        }
        else{
            message.text=reply;
            message.isBroadcast=NO;
            message.toPeerInfo=message.peerInfo;
            message.message_type=MSG_TYPE_RESPONSE;
            message.localCopy=NO;
            [self sendMyMessage:message];
        }
        //return;
    }
    
}

-(void)didReceiveVoiceDataWithNotification:(NSNotification *)notification{
    //  MCPeerID *peerID = [[notification userInfo] objectForKey:@"peerID"];
    //   NSString *peerDisplayName = peerID.displayName;
    
    //  NSData *receivedData = [[notification userInfo] objectForKey:@"data"];
    //   NSString *receivedText = [[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding];
    
    //[_tvChat performSelectorOnMainThread:@selector(setText:) withObject:[_tvChat.text stringByAppendingString:[NSString stringWithFormat:@"%@ wrote:\n%@\n\n", peerDisplayName, receivedText]] waitUntilDone:NO];
    if(_appDelegate.isAudioON){
        CAudioBuffer *sourceBuffer=[[CAudioBuffer alloc] init];// [notification object];
        sourceBuffer.mData=[[notification userInfo] objectForKey:@"data"];
        sourceBuffer.mDataByteSize=(UInt32)sourceBuffer.mData.length;//(UInt32)sourceBuffer.mData.length;
        sourceBuffer.mNumberChannels=1;
        //@synchronized(self.audioProcessor.inputBuffers ){
        [_audioProcessor.inputBuffers addObject:sourceBuffer];
    }
    //}
    //[self.audioProcessor.inputBuffers performSelectorOnMainThread:@selector(addObject:) withObject:sourceBuffer waitUntilDone:NO];
}
-(void)didReceiveAudioSwitchNotification:(NSNotification *)notification{
    BOOL isOn=[[notification.userInfo valueForKey:@"on"] boolValue];
    //if (!_appDelegate.isAudioON) {
    if (!isOn) {
        //[self showLabelWithText:@"Stopping AudioUnit"];
        if (_audioProcessor)
            [_audioProcessor stop];
        //[self showLabelWithText:@"AudioUnit stopped"];
        
        /* if (self.outputStreamer){
         
         [self.outputStreamer stop];
         
         }*/
        
    } else {
        
        
        /* NSArray *peers = [self.session connectedPeers];
         
         if (peers.count) {
         
         if (!self.outputStreamer){
         
         self.outputStreamer = [[TDAudioOutputStreamer alloc] initWithOutputStream:[self.session outputStreamForPeer:peers[0]]];
         //[self.outputStreamer streamAudioFromURL:[self.song valueForProperty:MPMediaItemPropertyAssetURL]];
         
         }
         
         [self.outputStreamer start];
         */
        if (_audioProcessor == nil) {
            _audioProcessor = [[AudioProcessor alloc] init];
        }
        // [self showLabelWithText:@"Starting up AudioUnit"];
        [_audioProcessor start];
        
        
        //  }
        
        // [self showLabelWithText:@"AudioUnit running"];
        
        
    }
}

-(void) didReceiveMicInputNotification: (NSNotification *) notification{
    /*    NSValue *obj=[notification object];
     AudioBuffer sourceBuffer;
     
     [obj getValue:&sourceBuffer];
     
     if(self.outputStreamer)
     //[self.outputStreamer streamAudioFromMic:&sourceBuffer];
     [self.outputStreamer ]
     */
    
    //this works don't erase
    /*
     AudioBuffer *audioBufferPlayback=[self.audioProcessor getPlaybackBuffer];
     if (audioBufferPlayback->mDataByteSize != sourceBuffer.mDataByteSize) {
     free(audioBufferPlayback->mData);
     audioBufferPlayback->mDataByteSize = sourceBuffer.mDataByteSize;
     audioBufferPlayback->mData = malloc(sourceBuffer.mDataByteSize);
     }
     
     memcpy(audioBufferPlayback->mData, sourceBuffer.mData, sourceBuffer.mDataByteSize);
     */
    //if(self.outputStreamer){
    
    /*
     if(self.outputStreamm){
     CAudioBuffer *sourceBuffer=[notification object];
     
     //[self.outputStreamer addQueue:sourceBuffer];
     [self.outputQueue addObject:sourceBuffer];
     }
     */
    
    //NSData *dataToSend = [_txtMessage.text dataUsingEncoding:NSUTF8StringEncoding];
    
    
    // NSMutableArray *allPeers =[NSMutableArray new];//  _appDelegate.mcManager.session.connectedPeers;
    
    //assert([allPeers count]>0);
    
    if([_appDelegate.mcManager.sessions count]>0){
        
        CAudioBuffer *sourceBuffer=[notification object];
        NSMutableData *tmpData=[NSMutableData dataWithBytes:"\x1" length:1];
        [tmpData appendData:sourceBuffer.mData];
        
        // dispatch_async(dispatch_get_main_queue(), ^{
        NSError *error;
        /* [_appDelegate.mcManager.session  sendData:sourceBuffer.mData
         toPeers:allPeers
         withMode:MCSessionSendDataUnreliable
         error:&error];*/
        for(MCSession *session in _appDelegate.mcManager.sessions ){
            if([session.connectedPeers count]>0){
                [session sendData:tmpData
                          toPeers:session.connectedPeers
                         withMode:MCSessionSendDataUnreliable
                            error:&error];
                
                if (error) {
#ifdef DEBUG
                    NSLog(@"%@", [error localizedDescription]);
#endif
                }
            }
        }
        //  });
        
        
        
        
        
        
    }
    
}
/*
 -(void)didSendPaidOrderFromServer:(NSNotification *)notification{
 dispatch_async(dispatch_get_main_queue(), ^{
 [self.soundController playSystemSound];
 BroadcastMessageAPI *message=[[BroadcastMessageAPI alloc] init];
 message.peerInfo=[[notification userInfo] objectForKey:@"peerInfo"];
 message.deviceID=_appDelegate.userInfo.deviceID;
 message.createdon=[NSDate date];
 //message.peerInfo.peerID = [[notification userInfo] objectForKey:@"peerID"];
 // NSString *peerDisplayName = message.peerInfo.peerID.displayName;
 
 
 NSData *receivedData = [[notification userInfo] objectForKey:@"data"];
 
 
 NSString *receivedText = [[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding];
 
 message.message_type=[receivedText substringWithRange:NSMakeRange(0, 2)];
 message.senderToken=[receivedText substringWithRange:NSMakeRange(2, 38)];
 
 message.text=[receivedText substringFromIndex:38];//receivedText;
 
 message.sender= message.peerInfo.peerID.displayName;
 
 
 });
 
 }
 
 
 
 -(void)performCharge: (BroadcastMessageAPI *)message requestString:(NSString *)requestString {
 
 NSMutableString *req_description=[NSMutableString new];
 
 NSMutableDictionary *dict_req=[NSMutableDictionary new];
 
 NSArray *params=[requestString componentsSeparatedByString:@"&"];
 if ([params count]>0) {
 
 NSRange range;
 NSString *key;
 NSString *value;
 for (NSString *item in params) {
 range=[item rangeOfString:@"="];
 if(range.location!=NSNotFound){
 key=[item substringToIndex:range
 .location];
 value=[item substringFromIndex:range.location+1];
 if (key.length>0) {
 [dict_req setValue:value forKey:key];
 }
 }
 }
 
 }
 
 if(![dict_req valueForKey:@"description"])
 return;
 
 NSDateFormatter *dateFormatter=[[NSDateFormatter alloc ]init];
 [dateFormatter setDateFormat:@"yyyy-MM-dd"];
 NSString *today=[dateFormatter stringFromDate:[NSDate date]];
 
 OrderHistory *newOrder=[[OrderHistory alloc] init];
 newOrder.orderDetailText=[dict_req valueForKey:@"description"];//orderDetailText;//req_description;
 newOrder.orderBy=message.sender;
 newOrder.orderDateTime=[NSDate date];
 newOrder.orderDate=[dateFormatter dateFromString:today];
 newOrder.orderDay=today;
 newOrder.orderID=[dict_req valueForKey:@"orderid"];
 newOrder.orderNumber=0;//[NSNumber numberWithUnsignedInteger:orderNumber];
 newOrder.orderStatus=@ORDER_STATUS_PAID;
 newOrder.orderStoreID=_appDelegate.userInfo.deviceID;
 
 [req_description appendFormat:@"%@\n%@",newOrder.orderID,[dict_req valueForKey:@"description"]];
 
 NSString *postRequestString=[NSString stringWithFormat:@"amount=%@&currency=%@&source=%@&description=%@",[dict_req valueForKey:@"amount"],[dict_req valueForKey:@"currency"],[dict_req valueForKey:@"source"],req_description];
 
 NSDictionary *result=[self charge:postRequestString];
 
 
 
 NSMutableString *reply=[NSMutableString string];
 BOOL success=[[result valueForKey:@"Success"] boolValue];
 
 if(success){
 
 #ifdef DEBUG
 //if ([result valueForKey:@"Result"]) {
 NSLog(@"Result(Success): %@",[result valueForKey:@"Result"]);
 //}
 #endif
 
 
 
 
 
 //[reply appendFormat:[NSString stringWithFormat:@"Hi %@, your payment for:\n%@ has been received. Thank You.\nYour order# %@. ",newOrder.orderBy,[dict_req valueForKey:@"description"],newOrder.orderNumber]];
 
 //assing an order number
 _appDelegate.lastOrderNumber++;
 newOrder.orderNumber=[NSNumber numberWithUnsignedInteger:_appDelegate.lastOrderNumber];
 //NSUInteger orderNumber= _appDelegate.lastOrderNumber;
 newOrder.orderDetailText=[NSString stringWithFormat:@"ORDER#%@\n%@",newOrder.orderNumber,[dict_req valueForKey:@"description"]];
 [self performChargeSuccess:newOrder];
 
 
 }
 else{
 //[self chargeDidNotSuceed];
 #ifdef DEBUG
 //if ([result valueForKey:@"Error"]) {
 NSLog(@"Chareg Error: %@",[result valueForKey:@"Error"]);
 //}
 // if ([result valueForKey:@"Result"]) {
 NSLog(@"Result(Error): %@",[result valueForKey:@"Result"]);
 //}
 #endif
 // if((_appDelegate.lastOrderNumber-1)==orderNumber)
 //     _appDelegate.lastOrderNumber--;
 
 [reply appendFormat:@"Hi %@, Sorry your payment for\n%@\nDid no go through. You may also choose Pay Cash on checkout or see the cashier to complete this transaction. Thanks.",message.sender,[dict_req valueForKey:@"description"]];
 [self sendMyMessage:reply withMessageType:MSG_TYPE_DEF andLocalCopy:NO];
 }
 
 //[self sendMyMessage:reply withMessageType:MSG_TYPE_DEF andLocalCopy:NO];
 }
 */

//copy photo if needed
-(void)copyImageFileToDocDirIfNeeded:(NSString *)deviceID peerPhoto:(NSData *)peerPhoto{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    _documentsDirectory = [[NSString alloc] initWithString:[paths objectAtIndex:0]];
    
    NSString *filePath = [_documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png",deviceID]];
    
    //   NSString *file2Path = [_documentsDirectory stringByAppendingPathComponent:@"sample_file2.txt"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    
    if (![fileManager fileExistsAtPath:filePath]) {
        /*[fileManager copyItemAtPath:[[NSBundle mainBundle] pathForResource:deviceID ofType:@"png"]
         toPath:filePath
         error:&error];*/
        [peerPhoto writeToFile:filePath atomically:YES];
        
        if (error) {
#ifdef DEBUG
            NSLog(@"%@", [error localizedDescription]);
#endif
            return;
        }
        
        /* [fileManager copyItemAtPath:[[NSBundle mainBundle] pathForResource:@"sample_file2" ofType:@"txt"]
         toPath:file2Path
         error:&error];
         
         if (error) {
         NSLog(@"%@", [error localizedDescription]);
         return;
         }*/
    }
}





@end
