//  Created by Romulo Quidilig on 3/19/15.
//  Copyright (c) 2015 Sharecle Inc. All rights reserved.
//

#import "StoreHistory.h"
#import "OrderHistory.h"
#import "HistoryModel.h"
#import "PeerInfo.h"
#import "InventoryItem.h"
#import "CheckoutCart.h"
#import "BroadcastMessageAPI.h"
#import <AudioToolbox/AudioToolbox.h>
//#import "ProductCategory.h"
//#import "NSData+Conversion.h"
#import "defs.h"

@implementation StoreHistory
//@synthesize products;


- (id)init {
    self = [super init];
    if (self) {
        //Custom initialization
        //self.productsArray = [[NSMutableArray alloc] init];
        //_inventoryModel = [[InventoryModel alloc] init];
        //  self.products=[NSMutableArray new];
        // self.categories=[NSMutableArray new];
        self.orders=[NSMutableArray new];
        
    }
    return self;
}

- (id)initWithCoder:(NSCoder*)decoder
{
    if ((self = [super init]))
    {
        self.orders = [decoder decodeObjectForKey:ORDERS_KEY];
        self.inventory=[decoder decodeObjectForKey:inventoryKey];
        self.cart=[decoder decodeObjectForKey:cartKey];
        
        self.storeName=[decoder decodeObjectForKey:STORENAME_KEY];
        self.deviceID= [decoder decodeObjectForKey:deviceIDKey];
        self.storeNum= [decoder decodeIntegerForKey:STORENUM_KEY];

        self.device_lat= [decoder decodeFloatForKey:device_latKey];
        self.device_lng= [decoder decodeFloatForKey:device_lngKey];
        self.device_address= [decoder decodeObjectForKey:device_addressKey];
        self.homeUrl= [decoder decodeObjectForKey:homeurlKey];
        
        
        
        
        if(self.orders==nil)
            self.orders=[NSMutableArray new];
        if(self.inventory==nil)
            self.inventory=[InventoryItem new];
        if(self.cart==nil)
            self.cart=[CheckoutCart new];
        
        self.autoConnect= [decoder decodeBoolForKey:autoConnectKey];

    }
    return self;
}


- (void)encodeWithCoder:(NSCoder*)encoder
{
    
    [encoder encodeObject:self.orders forKey:ORDERS_KEY];
        [encoder encodeObject:self.inventory forKey:inventoryKey];
    
    
    [encoder encodeObject:self.cart forKey:cartKey];
    
    
    [encoder encodeObject:self.storeName forKey:STORENAME_KEY];
    [encoder encodeInteger:self.storeNum forKey:STORENUM_KEY];
    [encoder encodeObject:self.deviceID forKey:deviceIDKey];
    
    [encoder encodeFloat:self.device_lat forKey:device_latKey];
    [encoder encodeFloat:self.device_lng forKey:device_lngKey];
    [encoder encodeObject:self.device_address forKey:device_addressKey];
    [encoder encodeObject:self.homeUrl forKey:homeurlKey];
    
    [encoder encodeBool:self.autoConnect forKey:autoConnectKey];
    
    
}

-(NSArray *)days:(BOOL)ascending{
    NSArray *unsorted=[self.orders valueForKeyPath:@"@distinctUnionOfObjects.orderDay"];
    NSSortDescriptor *valueDescriptors=[[NSSortDescriptor alloc] initWithKey:@"self" ascending:ascending];
    NSArray *descriptors=[NSArray arrayWithObject:valueDescriptors];
    
    
    NSArray *sortedArray=[unsorted sortedArrayUsingDescriptors:descriptors];
    
    // historyDates=[[_appDelegate.historyModel.history allKeys] mutableCopy];
   // historyDates=[sortedArray mutableCopy];
    
    return sortedArray;//[self.orders valueForKeyPath:@"@distinctUnionOfObjects.orderDay"];
}

-(void)loadDefaultCategory{
    /* BOOL hasDefault=YES;
     if(self.categories==nil){
     self.categories=[NSMutableArray new];
     hasDefault=NO;
     }
     else{
     NSPredicate *predicate=[NSPredicate predicateWithFormat:@"categoryID=0"];
     NSArray *def_cat_result=[self.categories filteredArrayUsingPredicate:predicate];
     if([def_cat_result count]>0){
     hasDefault=YES;
     }
     
     }
     if(hasDefault==NO){
     ProductCategory *def_cat=[ProductCategory new];
     def_cat.name=@"";
     def_cat.categoryID=0;
     def_cat.pictureFile=@"";
     [self.categories addObject:def_cat];
     [self saveInventory];
     }
     */
}



/*- (NSString *)addDay:(NSString*)day {
    
    // NSDictionary *inventory =[self.inventories valueForKey:inventoryName];
    
    //NSMutableArray *categories=[inventory valueForKey:CATEGORIES_KEY];
    
    // NSPredicate *predicate=[NSPredicate predicateWithFormat:@"name=%@",categoryName];
    
    
    day=[day stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" "]];
    
    if(day.length==0)
        return nil;
    if(self.days==nil)
        self.days=[NSMutableArray new];
    
   // NSArray *names=[self.categories valueForKey:NAME_KEY];
    
    
    //NSPredicate *predicate=[NSPredicate predicateWithFormat:@"name=%@",categoryName];
    //NSArray *search=[self.categories filteredArrayUsingPredicate:predicate];
    if([self.days containsObject:day]) //duped
        return nil;
    
    HistoryModel *model=[HistoryModel sharedInstance];
    
    [model saveHistory];
    return day;
    
}
 */

//- (Product *)addProduct:(NSString*)name  categoryId:(NSUInteger)categoryId price:(float)price imageName:(NSString *)imageFile detail:(NSString *)detail remaining:(NSInteger)remaining unlimited:(BOOL)unlimited{


-(NSArray *)allOrdersWithDay:(NSString *)day{
    NSPredicate* predicate=[NSPredicate predicateWithFormat:@"orderDay=%@",day];
    NSArray *resultArray=[self.orders filteredArrayUsingPredicate:predicate];
    
        return resultArray;
    
}


-(OrderHistory *)searchOrder:(NSString *)orderID{
    OrderHistory *result=nil;
    //InventoryModel *model=[InventoryModel sharedInstance];
    //serch active menu first
    
    //NSSortDescriptor *descriptor=[[NSSortDescriptor alloc] initWithKey:ISACTIVE_KEY ascending:NO];
    
    NSPredicate* predicate;
    //NSArray *sortedArray=[model.inventories sortedArrayUsingDescriptors:[NSArray arrayWithObject:descriptor]];
    //for(InventoryItem *inv in sortedArray){
    //for (ProductCategory *c in self.categories) {
    
    predicate = [NSPredicate predicateWithFormat:@"orderID=%@",orderID];
    
    NSArray* results = [self.orders filteredArrayUsingPredicate:predicate];
    
    if(results !=nil && [results count]>0)//{
        return [results firstObject];
    //}
    // else
    //     return nil;
    //}
    
    //}
    
    return result;
    
    
}

-(void)addNewMessage:(BroadcastMessageAPI *)message{
    if(self.messages==nil){
        self.messages=[NSMutableArray new];
        // _messagesModel=[MessagesModel sharedInstance];
        // [_messagesModel loadMessages];
        // self.messages=[NSMutableArray new];
    }
    
    
    //if(self.mcManager.serverPeerInfo.maxMessagesPerUser>0){
    if(self.messageLimitPerUser>0){
        
        //NSPredicate *predicate=[NSPredicate predicateWithFormat:@"deviceID==%@",message.deviceID];
        
        NSPredicate *predicate=[NSPredicate predicateWithFormat:@"fromDeviceID==%@",message.fromDeviceID];
        NSArray *existing=[self.messages filteredArrayUsingPredicate:predicate];
        
        if([existing count]>0){//=self.appConfig.userInfo.messageLimitPerUser){
            /* for now just delete everything
             NSSortDescriptor *descriptor=[[NSSortDescriptor alloc] initWithKey:@"createdon" ascending:YES];
             NSArray *sorted=[existing sortedArrayUsingDescriptors:[NSArray arrayWithObject:descriptor]];
             
             for(BroadcastMessageAPI *item in sorted){
             //if([self.peerDevices containsObject:searchPeerInfo]){
             NSInteger indexOfPeer = [self.messages indexOfObject:item];
             //peerInfo=[self.peerDevices objectAtIndex:indexOfPeer];
             
             //}
             [self.messages removeObjectAtIndex:indexOfPeer];
             }
             */
            for(BroadcastMessageAPI *item in existing){
                
                //NSInteger indexOfPeer = [self.messages indexOfObject:item];
                
                [self.messages removeObject:item];
            }
            
        }
    }
    
    [self.messages addObject:message];
    
    if(self.isPlaySound){
        AudioServicesPlaySystemSound(1003);
    }
    
    
    /*TODO
     NSInteger count=[_messages count];
     UITabBarController *tabBarcontroller=(UITabBarController*)self.window.rootViewController;
     ;
     UITabBarItem *tbiMessages=(UITabBarItem *)[tabBarcontroller.tabBar.items objectAtIndex:TAB_INDEX_CHAT];
     if(count==0)
     tbiMessages.badgeValue=nil;
     else
     tbiMessages.badgeValue=[NSString stringWithFormat:@"%ld",(long)count];
     
     [UIApplication sharedApplication].applicationIconBadgeNumber=count;
     */
    
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_UPDATE_MESSAGES object:nil];
    
}

-(void)addNewMessageFromSpeech:(BroadcastMessageAPI *)message{
    if(self.messages==nil){
        self.messages=[NSMutableArray new];
        // _messagesModel=[MessagesModel sharedInstance];
        // [_messagesModel loadMessages];
        // self.messages=[NSMutableArray new];
    }
    
    
    //if(self.mcManager.serverPeerInfo.maxMessagesPerUser>0){
    if(self.messageLimitPerUser>0){
        
        //NSPredicate *predicate=[NSPredicate predicateWithFormat:@"deviceID==%@",message.deviceID];
        
        NSPredicate *predicate=[NSPredicate predicateWithFormat:@"fromDeviceID==%@",message.fromDeviceID];
        NSArray *existing=[self.messages filteredArrayUsingPredicate:predicate];
        
        if([existing count]>0){//=self.appConfig.userInfo.messageLimitPerUser){
            /* for now just delete everything
             NSSortDescriptor *descriptor=[[NSSortDescriptor alloc] initWithKey:@"createdon" ascending:YES];
             NSArray *sorted=[existing sortedArrayUsingDescriptors:[NSArray arrayWithObject:descriptor]];
             
             for(BroadcastMessageAPI *item in sorted){
             //if([self.peerDevices containsObject:searchPeerInfo]){
             NSInteger indexOfPeer = [self.messages indexOfObject:item];
             //peerInfo=[self.peerDevices objectAtIndex:indexOfPeer];
             
             //}
             [self.messages removeObjectAtIndex:indexOfPeer];
             }
             */
            for(BroadcastMessageAPI *item in existing){
                
                //NSInteger indexOfPeer = [self.messages indexOfObject:item];
                
                [self.messages removeObject:item];
            }
            
        }
    }
    
    [self.messages addObject:message];
    /*
    if(self.isPlaySound){
        AudioServicesPlaySystemSound(1003);
    }
     */
    
    
    /*TODO
     NSInteger count=[_messages count];
     UITabBarController *tabBarcontroller=(UITabBarController*)self.window.rootViewController;
     ;
     UITabBarItem *tbiMessages=(UITabBarItem *)[tabBarcontroller.tabBar.items objectAtIndex:TAB_INDEX_CHAT];
     if(count==0)
     tbiMessages.badgeValue=nil;
     else
     tbiMessages.badgeValue=[NSString stringWithFormat:@"%ld",(long)count];
     
     [UIApplication sharedApplication].applicationIconBadgeNumber=count;
     */
    
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_UPDATE_MESSAGES object:nil];
    
}

@end
