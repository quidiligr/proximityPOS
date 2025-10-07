//
//  IODOrder.m
//  iOSDiner
//
//  Created by Romulo Quidilig on 3/19/15.
//  Copyright (c) 2015 Sharecle Inc. All rights reserved.
//

#import "HistoryModel.h"
//#import "Product.h"
#import "OrderHistory.h"
#import "StoreHistory.h"
#import "StoreInfo.h"
#import "PeerInfo.h"
#import "Util.h"
#import "defs.h"
//#import "ProductCategory.h"
//#import "NSData+Conversion.h"

@implementation HistoryModel


//@synthesize products;
//@synthesize filename;
//@synthesize history;



//+ (void)initialize
//{
//    if (self == [InventoryModel class])
//    {
//        // Register default values for our settings
//        /*[[NSUserDefaults standardUserDefaults] registerDefaults:
//         @{NameKey: @"",
//           PriceKey: @0.0,
//           PictureFileKey: @""}];
//         */
//        
//    }
//}

- (id)init {
    self = [super init];
    if (self) {
       
        self.history=[NSMutableDictionary new];
    }
    return self;
}

- (id)initWithCoder:(NSCoder*)decoder
{
    if ((self = [super init]))
    {
        self.history=[decoder decodeObjectForKey:HISTORY_KEY];
     
    }
    return self;
}


- (void)encodeWithCoder:(NSCoder*)encoder
{
    
    [encoder encodeObject:self.history forKey:HISTORY_KEY];
    
}

/*-(void)initWithFilename:(NSString *)filename{
    self.filename=filename;
}
*/

+ (HistoryModel *)sharedInstance {
    static HistoryModel*  _sharedHistory;
    
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        _sharedHistory = [[HistoryModel alloc] init];
        [_sharedHistory loadHistory];
        
      
    });
    
    return _sharedHistory;
}
/*
+ (HistoryModel *)sharedServerInstance {
    static HistoryModel*  _sharedHistory;
    
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        _sharedHistory = [[HistoryModel alloc] init];
        
        _sharedHistory.isServer=YES;
    });
    
    return _sharedHistory;
}
*/
// Returns the path to the Messages.plist file in the app's Documents directory

- (NSString*)historyPath//:(NSString *)withTitle
{
    
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString* documentsDirectory = paths[0];
    
    NSString *filename=@"history.plist";
    
   
    return [documentsDirectory stringByAppendingPathComponent:filename];
}




- (void)loadHistory
{
    //self.history=[NSMutableDictionary new];
    //[self.days removeAllObjects];
    
    NSString* path = [self historyPath];
    if ([[NSFileManager defaultManager] fileExistsAtPath:path])
    {
        // We store the inventory in a plist file inside the app's Documents
        // directory. The Inventory object conforms to the NSCoding protocol,
        // which means that it can "freeze" itself into a data structure that
        // can be saved into a plist file. So can the NSMutableArray that holds
        // these Message objects. When we load the plist back in, the array and
        // its Messages "unfreeze" and are restored to their old state.
        
        NSData* data = [[NSData alloc] initWithContentsOfFile:path];
        NSKeyedUnarchiver* unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
        //self.history =[unarchiver decodeObjectForKey:@"History"];
        //NSArray *arr_history=[unarchiver decodeObjectForKey:@"History"];
        _history=[unarchiver decodeObjectForKey:@"History"];
        //if(_history==nil)
        //    self.history = [NSMutableDictionary new];

        /*
        NSArray *arr_days=[unarchiver decodeObjectForKey:@"Days"];
        
        if(arr_orders!=nil)
            self.orders = [arr_orders mutableCopy];
        if(arr_days!=nil)
            self.days = [arr_days mutableCopy];
        
        
        
        
        if(self.orders==nil){
            self.orders=[NSMutableArray new];
            self.days=[NSMutableArray new];
        }
        if(self.days==nil){
         self.days=[NSMutableArray new];
        }
        */
        /*
         if([self.categories count]==0){
         self.categories=[NSMutableArray new];
         ProductCategory *def_cat=[ProductCategory new];
         def_cat.name=@"default";
         def_cat.categoryID=0;
         def_cat.pictureFile=@"";
         [self.categories addObject:def_cat];
         }
         */
        //[self loadDefaultCategory];
        [unarchiver finishDecoding];
        
        if(_history==nil)
            self.history = [NSMutableDictionary new];

    }
    else
    {
        if(self.history==nil)
            self.history = [NSMutableDictionary new];
       /* self.orders=[NSMutableArray new];
        self.days=[NSMutableArray new];
        [self saveHistory];
        */
        //[self loadDefaultCategory];
        //[self saveInventory];
    }
}

- (void)saveHistory
{
    NSMutableData* data = [[NSMutableData alloc] init];
    NSKeyedArchiver* archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    
    [archiver encodeObject:self.history forKey:@"History"];
    //[archiver encodeObject:self.orders forKey:@"Orders"];
    //[archiver encodeObject:self.days forKey:@"Days"];
    [archiver finishEncoding];
    [data writeToFile:[self historyPath] atomically:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_UPDATE_HISTORY object:nil];
}

/*+ (NSMutableDictionary *)sharedSettings
{
    //NSString* path = [self inventoryPath];
    static NSMutableDictionary *_sharedSettings;
    
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        
        
        NSString* path =[InventoryModel settingsPath];
        
        
        if ([[NSFileManager defaultManager] fileExistsAtPath:path])
        {
            
            NSData* data = [[NSData alloc] initWithContentsOfFile:path];
            NSKeyedUnarchiver* unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
            //NSString *filename = [unarchiver decodeObjectForKey:@"Name"];
            //NSString *date = [unarchiver decodeObjectForKey:@"Date"];
            _sharedSettings= [unarchiver decodeObjectForKey:@"settings"];
            
            [unarchiver finishDecoding];
            
           
        }

        if(_sharedSettings==nil){
            _sharedSettings = [[NSMutableDictionary alloc] init];
            [_sharedSettings setValue:nil forKey:KEY_SETTINGS_INV_PUBLISHEDNAME];
            [_sharedSettings setValue:nil forKey:KEY_SETTINGS_INV_PUBLISHEDDATE];
            
        }
    });
    
    return _sharedSettings;
    
}



+(NSString *)settingsPath{
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDirectory = paths[0];
    //NSString *filename=KEY_SETTINGS_INV_FILENAME;
    NSString* path = [documentsDirectory stringByAppendingPathComponent:KEY_SETTINGS_INV_FILENAME];
    return path;
}

+(void)loadSettings{
    NSDictionary *_settings=[InventoryModel sharedSettings];
    
    
    NSString* path =[InventoryModel settingsPath];
    
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:path])
    {
        // We store the inventory in a plist file inside the app's Documents
        // directory. The Inventory object conforms to the NSCoding protocol,
        // which means that it can "freeze" itself into a data structure that
        // can be saved into a plist file. So can the NSMutableArray that holds
        // these Message objects. When we load the plist back in, the array and
        // its Messages "unfreeze" and are restored to their old state.
        
        NSData* data = [[NSData alloc] initWithContentsOfFile:path];
        NSKeyedUnarchiver* unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
        //NSString *filename = [unarchiver decodeObjectForKey:@"Name"];
        //NSString *date = [unarchiver decodeObjectForKey:@"Date"];
        _settings= [unarchiver decodeObjectForKey:@"settings"];
        
        [unarchiver finishDecoding];
    }
    
}

+ (void)saveSettings
{
    NSMutableData* data = [[NSMutableData alloc] init];
    NSKeyedArchiver* archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:[InventoryModel sharedSettings] forKey:@"settings"];
    [archiver finishEncoding];
    [data writeToFile:[self settingsPath] atomically:YES];
}

*/
- (StoreHistory *)createStoreHistoryFromWeb:(NSDictionary *)storeInfo
{
    if(self.history==nil){
        self.history=[NSMutableDictionary new];
        // [self.history addObject:order];
        //[self.history setValue:orders forKey:day];
    }
    NSString *deviceID=[storeInfo valueForKey:deviceIDKey];
    if(deviceID==nil || deviceID.length==0)
        return nil;
    StoreHistory *store=[self storeWithStoreID:deviceID];
    if(store==nil){// || (store.inventory.products==nil || [store.inventory.products count]>0)){
        store=[StoreHistory new];
        NSString *storeName=[storeInfo valueForKey:StoreNameKey];
        store.storeName=(storeName==nil)?@"Unknown":storeName;
        store.authType=[[storeInfo valueForKey:authTypeKey] integerValue];
        store.deviceID=deviceID;
        store.storeID=[storeInfo valueForKey:storeIDKey];
        
        //newStore.days=[NSMutableArray new];
        //[newStore.days addObject:order.orderDay];
        store.orders=[NSMutableArray new];
        if(store.authType==0){
        //[store.orders addObject:order];
            [_history setValue:store forKey:store.deviceID];
    
            [Util httpGetInventoryWithStore:store];
        }
        else{
            //if(authTypeKey)
        }
    }
    else{
        [Util httpGetInventoryWithStore:store];
    }
    // return newStore;
    //}
    return store;
    
}
- (StoreHistory *)createStoreHistoryFromOrder:(OrderHistory *)order
{
    //NSMutableArray *orders=[self.history valueForKey:day];
    if(self.history==nil){
        self.history=[NSMutableDictionary new];
        // [self.history addObject:order];
        //[self.history setValue:orders forKey:day];
    }
   
        //search first
       /* NSPredicate *predicate=[NSPredicate predicateWithFormat:@"orderStoreID=%@",order.orderStoreID];
        NSArray *searchResult=[self.history filteredArrayUsingPredicate:predicate];
        if([searchResult count]>0){
            return [searchResult firstObject];
            
        }
        else{*/
    StoreHistory *store=[self storeWithStoreID:order.orderStoreID];
    if(store==nil){
            store=[StoreHistory new];
            store.storeName=(order.orderStoreName==nil)?@"Unknown":order.orderStoreName;
            store.deviceID=order.orderStoreID;
    
            //newStore.days=[NSMutableArray new];
            //[newStore.days addObject:order.orderDay];
            store.orders=[NSMutableArray new];
            [store.orders addObject:order];
            [_history setValue:store forKey:store.deviceID];
    }
           // return newStore;
        //}
    return store;
    
    
}
- (void)addOrUpdateStoreHistory:(StoreHistory *)store
{
    //NSMutableArray *orders=[self.history valueForKey:day];
    if(self.history==nil){
        self.history=[NSMutableDictionary new];
       // [self.history addObject:order];
        //[self.history setValue:orders forKey:day];
    }
    //else{
        //search first
        //NSPredicate *predicate=[NSPredicate predicateWithFormat:@"storeId=%@",store.storeId];
        //NSArray *searchResult=[self.history filteredArrayUsingPredicate:predicate];
        
        
        
        //if([searchResult count]>0){
        StoreHistory *existing_item=[_history valueForKey:store.deviceID];
        if(existing_item!=nil){
            //existing_item.storeName=store.storeName;
            //existing_item.storeNum=store.storeNum;
            //existing_item.orders=store.orders;
        }
        
        else
            [_history setValue:store forKey:store.deviceID];
    //}
    
    //see if needed: [self.history setValue:order forKey:day];
    // [self.orders addObject:order];
    [self saveHistory];
    // return self.orders.count - 1;
}

- (NSArray *)searchUnpaidOrdersWithStore:(StoreHistory *)store isLive:(BOOL) isLive
{

            NSPredicate *p=[NSPredicate predicateWithFormat:@"orderIsLive==%@ AND orderStatus==%@",@(isLive),@(ORDER_STATUS_RECEIVED) ];
            NSArray *r=[store.orders filteredArrayUsingPredicate:p];
                return r;
                
    
}

- (NSArray *)searchFailedOrdersWithStore:(StoreHistory *)store isLive:(BOOL) isLive
{
    
    NSPredicate *p=[NSPredicate predicateWithFormat:@"orderIsLive==%@ AND orderStatus==%@",@(isLive),@(ORDER_STATUS_FAILED) ];
    NSArray *r=[store.orders filteredArrayUsingPredicate:p];
    
    return r;
    
   
    
}

- (NSArray *)searchPendingOrdersWithStore:(StoreHistory *)store isLive:(BOOL) isLive
{
    
    NSPredicate *p=[NSPredicate predicateWithFormat:@"orderIsLive==%@ AND orderStatus==%@",@(isLive),@(ORDER_STATUS_START) ];
    NSArray *r=[store.orders filteredArrayUsingPredicate:p];
    
    return r;
    
    
    
}




- (NSInteger)countReadyOrders
{
    //NSPredicate *predicate=[NSPredicate predicateWithFormat:@"storeNum=%@",@(storeNum)];
    //NSArray *searchResult=[self.history filteredArrayUsingPredicate:predicate];
    NSInteger count=0;
    
    NSArray *stores=[_history allValues];
    
    if([stores  count]>0){
        for(StoreHistory *store in stores){
            

            NSPredicate *p=[NSPredicate predicateWithFormat:@"orderStatus==%@",@(ORDER_STATUS_READY) ];
            NSArray *r=[store.orders filteredArrayUsingPredicate:p];
            count=count+[r count];
        }
    
    }
    
    return count;
    
    
    
    
}


- (OrderHistory *)searchPendingOrder:(StoreHistory *)store
{
   
            //store.storeName=store.storeName;
            //store.orders=store.orders;
            NSPredicate *p=[NSPredicate predicateWithFormat:@"orderStatus==%@",@(ORDER_STATUS_START)];
            NSArray *r=[store.orders filteredArrayUsingPredicate:p];
            if([r count]>0){
                return [r firstObject];
                
            }
   
            //[self.history addObject:store];
    
    return nil;
    
}

- (OrderHistory *)searchOrderWithOrderID:(NSString *)orderID andStoreId:(NSString *)storeId
{
    //NSMutableArray *orders=[self.history valueForKey:day];
    //search first
    //NSPredicate *predicate=[NSPredicate predicateWithFormat:@"storeId=%@",storeId];
    //NSArray *searchResult=[_history filteredArrayUsingPredicate:predicate];
    //if([searchResult count]>0){
    StoreHistory *store=[self storeWithStoreID:storeId];
    
    if(store!=nil && [store.orders count]>0){
        
        NSPredicate *p=[NSPredicate predicateWithFormat:@"orderID==%@",orderID];
        NSArray *r=[store.orders filteredArrayUsingPredicate:p];
        if([r count]>0){
            return [r firstObject];
            
        }
    }
        // existing_item.days=store.days;
    //}
   // else
    //    [self.history addObject:store];
    
    
    return nil;
    
}

- (OrderHistory *)searchOrderWithOrderNum:(NSInteger)orderNum andStoreNum:(NSInteger)storeNum andOrderDateTime:(NSDate *)orderDateTime
{
    //NSMutableArray *orders=[self.history valueForKey:day];
    //search first
    StoreHistory *store=[self storeWithStoreNum:storeNum];
    
    if(store==nil)
        return nil;
   // NSArray *stores=[_history valueForKey:STOREID_KEY];
    //if([stores count]==0)
    //    return nil;
    //for(StoreHistory *store in stores ){
        //if(store.storeNum==storeNum){
            //NSPredicate *predicate=[NSPredicate predicateWithFormat:@"storeNum=%@",@(storeNum)];
            //NSArray *searchResult=[self.history filteredArrayUsingPredicate:predicate];
            //if([searchResult count]>0){
                //StoreHistory *existing_item=[searchResult firstObject];
                
                NSPredicate *p=[NSPredicate predicateWithFormat:@"orderNumber==%@ AND orderDateTime==%@",@(orderNum),orderDateTime];
                //NSPredicate *p=[NSPredicate predicateWithFormat:@"orderNumber==%@",@(orderNum)];
                NSArray *r=[store.orders filteredArrayUsingPredicate:p];
                if([r count]>0){
                    return [r firstObject];
                    
                }
                // existing_item.days=store.days;
            //}
            // else
            //    [self.history addObject:store];
            
            
            
        //}
    //}
    
    return nil;

}

- (OrderHistory *)searchOrderWithOrderId:(NSString *)orderId andStoreNum:(NSNumber *)storeNum andOrderDateTime:(NSDate *)orderDateTime
{
    //NSMutableArray *orders=[self.history valueForKey:day];
    //search first
    StoreHistory *store=[self storeWithStoreNum:[storeNum integerValue]];
    
    if(store==nil)
        return nil;
    
    NSPredicate *p=nil;
    NSArray *r=nil;
    
        if(orderDateTime){
            p=[NSPredicate predicateWithFormat:@"orderId==%@ AND orderDateTime==%@",orderId,orderDateTime];
            //NSPredicate *p=[NSPredicate predicateWithFormat:@"orderNumber==%@",@(orderNum)];
            r=[store.orders filteredArrayUsingPredicate:p];
            if([r count]>0){
                return [r firstObject];
                
            }
        }
        else{
            p=[NSPredicate predicateWithFormat:@"orderID=%@",orderId];
            //NSPredicate *p=[NSPredicate predicateWithFormat:@"orderNumber==%@",@(orderNum)];
            r=[store.orders filteredArrayUsingPredicate:p];
            if([r count]>0){
                return [r firstObject];
                
            }
        }
    
    return nil;
    
}

- (OrderHistory *)searchPendingOrderWithStore:(StoreHistory *)store isLive:(BOOL) isLive
{
    
    NSPredicate *p=[NSPredicate predicateWithFormat:@"orderStatus==%@ AND orderIsLive==%@",@(ORDER_STATUS_START),@(isLive) ];
    NSArray *r=[store.orders filteredArrayUsingPredicate:p];
    if([r count]>0){
        return [r firstObject];
        
    }
    
    return nil;
    
}

-(NSInteger)countAllPending{
    //NSPredicate *predicate=[NSPredicate predicateWithFormat:@"storeId=%@",store.storeId];
    //NSArray *searchResult=[self.history filteredArrayUsingPredicate:predicate];
    NSInteger count=0;
    NSArray *stores = [_history allValues];
    if(stores==nil || [stores count]==0)
        return 0;
    
    for (StoreHistory *s in stores) {
        NSPredicate *p=[NSPredicate predicateWithFormat:@"orderStatus==%@",@(ORDER_STATUS_START) ];
        NSArray *r=[s.orders filteredArrayUsingPredicate:p];
        if([r count]>0){
            count=count+[r count];
        }
    }
    return count;
}


-(StoreHistory *)storeWithStoreID:(NSString *)storeID{
    if(self.history==nil){
        self.history=[NSMutableDictionary new];
        return nil;
    }
    //else{
    StoreHistory *store=[_history valueForKey:storeID];
    if(store.orders==nil){
        store.orders=[NSMutableArray new];
    }
    return store;
}



-(StoreHistory *)storeWithStoreNum:(NSInteger)storeNum{
    if(self.history==nil){
        self.history=[NSMutableDictionary new];
        return nil;
    }
    //else{
    StoreHistory *store=nil;
    NSArray *stores=[_history allValues];
    if([stores count]==0)
        return nil;
    for(StoreHistory *item in stores ){
        if(item.storeNum==storeNum){
            store=item;
            break;
        }
    }
    if(store!=nil && store.orders==nil){
            store.orders=[NSMutableArray new];
        
    }
        
    return store;
}

//StoreName==peer.displayName
-(StoreHistory *)storeWithPeerName:(NSString *)peerName{
    /*if(self.history==nil){
        self.history=[NSMutableDictionary new];
        return nil;
    }
     */
    //else{
    StoreHistory *store=nil;
    NSArray *stores=[_history allValues];
    if([stores count]==0)
        return nil;
    for(StoreHistory *item in stores ){
        if(item.peerInfo!=nil && [peerName isEqualToString:item.peerInfo.peerID.displayName]){
            store=item;
            break;
        }
    }
    if(store!=nil && store.orders==nil){
        store.orders=[NSMutableArray new];
        
    }
    
    return store;
}

-(StoreHistory *)storeWithPeer:(PeerInfo *)peer{
    /*if(self.history==nil){
        self.history=[NSMutableDictionary new];
        return nil;
    }
     */
    //else{
    StoreHistory *store=nil;
    NSArray *stores=[_history allValues];
    if([stores count]==0)
        return nil;
    for(StoreHistory *item in stores ){
        if(item.peerInfo!=nil && [peer isEqual:item.peerInfo]){
            store=item;
            break;
        }
    }
    if(store!=nil && store.orders==nil){
        store.orders=[NSMutableArray new];
        
    }
    
    return store;
}

- (OrderHistory *)addOrUpdateOrderHistory:(OrderHistory *)order
{
    OrderHistory *result=nil;
    StoreHistory *store=[self storeWithStoreID:order.orderStoreID];
    //if(store==nil)
    //    return nil;
    
        //search first
        //NSPredicate *predicate=[NSPredicate predicateWithFormat:@"storeId=%@",order.orderStoreID];
        //NSArray *searchStore=[self.history filteredArrayUsingPredicate:predicate];
    
        if(store!=nil){
            //StoreHistory *existing_store=[searchStore firstObject];
            NSPredicate *predicate=[NSPredicate predicateWithFormat:@"orderID=%@",order.orderID];
            NSArray *searchOrder=[store.orders filteredArrayUsingPredicate:predicate];
            if([searchOrder count]>0){
                OrderHistory *first_order=[searchOrder firstObject];
                first_order.orderHash=order.orderHash;
                first_order.orderStatus=order.orderStatus;
                first_order.orderIsRefunded=order.orderIsRefunded;
                first_order.orderIsPaid=order.orderIsPaid;
                first_order.orderNumber=order.orderNumber;
                first_order.orderItems=order.orderItems;
                 first_order.orderPayments=order.orderPayments;
                
                first_order.chargeToken=order.chargeToken;
                first_order.orderAmountDue=order.orderAmountDue;
                first_order.orderCashBack=order.orderCashBack;
                //first_order.orderSource=order.orderItems;
                first_order.orderDateTime=order.orderDateTime;
                first_order.orderDay=order.orderDay;
                first_order.orderStoreNum=order.orderStoreNum;
                first_order.orderStoreName=order.orderStoreName;
                first_order.orderTax=order.orderTax;
                
                result= first_order;
            }
            else{
                [store.orders addObject:order];
                result= order;
            }
            
        }
        else{
            [self createStoreHistoryFromOrder:order];//[StoreHistory new];
            
            
        }
    [self saveHistory];
    return result;
}

- (void)updateOrderHistory:(OrderHistory *)order
{
    //NSMutableArray *orders=[self.history valueForKey:day];
    if(self.history==nil){
        self.history=[NSMutableDictionary new];
        // [self.history addObject:order];
        //[self.history setValue:orders forKey:day];
    }
    //else{
    
    //search first
    //NSPredicate *predicate=[NSPredicate predicateWithFormat:@"storeId=%@",order.orderStoreID];
    //NSArray *searchStore=[self.history filteredArrayUsingPredicate:predicate];
    StoreHistory *store=[self storeWithStoreID:order.orderStoreID];
    
    if(store!=nil){
        //StoreHistory *existing_store=[searchStore firstObject];
        
        NSPredicate *predicate=[NSPredicate predicateWithFormat:@"orderID=%@",order.orderID];
        NSArray *searchOrder=[store.orders filteredArrayUsingPredicate:predicate];
        if([searchOrder count]>0){
            OrderHistory *first_order=[searchOrder firstObject];
            first_order.orderStatus=order.orderStatus;
            first_order.orderHash=order.orderHash;
            first_order.orderIsRefunded=order.orderIsRefunded;
            first_order.orderIsPaid=order.orderIsPaid;
            first_order.orderNumber=order.orderNumber;
            first_order.orderItems=order.orderItems;
            first_order.orderPayments=order.orderPayments;
            [self saveHistory];
            
        }
        /*else{
            [existing_store.orders addObject:order];
        }
        */
    }
    /*else{
        [self createStoreHistoryFromOrder:order];//[StoreHistory new];
        
    }
     
    [self saveHistory];
     */
    
}


//- (void)addHistory:(NSString *)day withOrder:(OrderHistory *)order
//{
//    //NSMutableArray *orders=[self.history valueForKey:day];
//    
//    if(self.days==nil){
//        self.days=[NSMutableArray new];
//        
//    }
//    
//    if(![self.days containsObject:day]){
//        [self.days addObject:day];
//    }
//    if(self.orders==nil){
//        self.orders=[NSMutableArray new];
//        [self.orders addObject:order];
//        //[self.history setValue:orders forKey:day];
//    }
//    else{
//        [self.orders addObject:order];
//    }
//    
//    //see if needed: [self.history setValue:order forKey:day];
//   // [self.orders addObject:order];
//    [self saveHistory];
//   // return self.orders.count - 1;
//    //TODO: provide notification for connected device for order fullfiment
//    /*if([order.orderSource isEqualToNumber:ORDER_SOURCE_LOCAL]){
//        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_UPDATE_HISTORY_LOCAL
//                                                        object:nil
//                                                      userInfo:nil];
//    }
//    else{*/
//       // [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_UPDATE_HISTORY
//        //                                                    object:nil
//        //                                                  userInfo:nil];
//
//    //}
//
//}



/*
- (void)addCategory:(NSString*)withName imageName:(NSString *)imageFile{
    
    
    
    
    withName=[withName stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" "]];
    
    if(withName.length==0){
        return ;
    }
    
        NSPredicate *predicate=[NSPredicate predicateWithFormat:@"name=%@",withName];
    NSArray *search=[self.categories filteredArrayUsingPredicate:predicate];
    if([search count]>0) //duped
        return ;
    
    ProductCategory *newCategory=[ProductCategory new];
    
    newCategory.name=withName;
    newCategory.pictureFile=imageFile;
    
    ProductCategory *last_cat=[self.categories lastObject];
        //ProductCategory *new_cat=[ProductCategory new];
        //new_cat.name=name;
        newCategory.categoryID=last_cat.categoryID+1;
        [self.categories addObject:newCategory];
  //  return newCategory;
    [self saveInventory];
    
}

- (NSMutableDictionary *)toMenuDictionary{
    NSMutableDictionary *dictionary=[[NSMutableDictionary alloc]init];
    for(ProductCategory *item in self.categories){
        NSPredicate *predicate=[NSPredicate predicateWithFormat:@"categoryID=%lu",item.categoryID];
        NSArray *category_products=[self.products filteredArrayUsingPredicate:predicate];
        
        NSMutableArray *category_products_dict=[NSMutableArray new];
        for(Product *prod in category_products ){
            
            [category_products_dict addObject:[prod toNSDictionay]];
        }
        [dictionary setValue:category_products_dict forKey:item.name];
    }
    
    return dictionary;


}
*/
/*- (NSMutableDictionary *)toDateOrdersDictionary{
    
    
    
    NSMutableDictionary *dictionary=[[NSMutableDictionary alloc]init];
    
    NSDateComponents *dateComponents=[[NSDateComponents alloc] init];
    dateComponents.day=1;
    
    NSCalendar *calendar=[NSCalendar currentCalendar];
    NSDate *nextDate;
    
    NSDateFormatter *dateFormat=[[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    
    for(NSDate *item in self.orders){
        
        nextDate=[calendar dateByAddingComponents:dateComponents toDate:item options:0];
        
        NSPredicate *predicate=[NSPredicate predicateWithFormat:@"(orderDate>=%@) AND (orderDate<=%@)",item,nextDate];
        
        NSArray *date_orders=[self.orders filteredArrayUsingPredicate:predicate];
        
        [dictionary setValue:date_orders forKey:[dateFormat stringFromDate:item]];
    }
    return dictionary;
    
    
}
*/

-(void)emtpyTrash{
        NSPredicate *pDeleted=[NSPredicate predicateWithFormat:@"orderStatus==%lu",ORDER_STATUS_DELETED];
    //NSPredicate *pNotDeleted=[NSPredicate predicateWithFormat:@"orderStatus!=%lu",ORDER_STATUS_DELETED];
    NSArray *stores=[_history allValues];
    
        if(stores!=nil && [stores count]>0){
            for (StoreHistory *store in stores) {
                NSArray *deleted=[store.orders filteredArrayUsingPredicate:pDeleted];
                if(deleted!=nil && [deleted count]>0){
                    //NSArray *notdeleted=[store.orders filteredArrayUsingPredicate:pNotDeleted];
                    //[self.history setValue:notdeleted forKey:day];
                    //[store removeAllObjects];
                    //[self.history addObjectsFromArray:notdeleted];
                    for(OrderHistory *delete_order in deleted){
                        [store.orders removeObject:delete_order];
                    }
                }
            }
            
            
        
        }
}

@end
