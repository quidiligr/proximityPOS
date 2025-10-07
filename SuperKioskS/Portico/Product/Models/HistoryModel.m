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
#import "StoreInfo.h"
#import "Util.h"
#import "AppDelegate.h"
//#import "AppConfigModel.h"
#import "defs.h"
#import "defs_order_product.h"
//#import "ProductCategory.h"
//#import "NSData+Conversion.h"
//static NSInteger trashBadgeNumber;

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
        //Custom initialization
        //self.productsArray = [[NSMutableArray alloc] init];
         //_inventoryModel = [[InventoryModel alloc] init];
        //self.orders=[NSMutableArray new];
        //self.dates=[NSMutableArray new];
        self.history=[NSMutableDictionary new];
    }
    return self;
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
        if(_sharedHistory.history==nil){
            _sharedHistory.history=[NSMutableDictionary new];
        }
        
      
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
    
    NSString *filename;//=[self.filename stringByAppendingString:@".history.plist"];
    
    if (self.isServer) {
        filename= [self.filename stringByAppendingString:@".server-history.plist"];
    }
    else{
        filename= [self.filename stringByAppendingString:@".history.plist"];
    }
   
    return [documentsDirectory stringByAppendingPathComponent:filename];
}


//-(void)loadDefaultCategory{
//    BOOL hasDefault=YES;
//    if(self.categories==nil){
//        self.categories=[NSMutableArray new];
//        hasDefault=NO;
//    }
//    else{
//        NSPredicate *predicate=[NSPredicate predicateWithFormat:@"categoryID=0"];
//        NSArray *def_cat_result=[self.categories filteredArrayUsingPredicate:predicate];
//        if([def_cat_result count]>0){
//            hasDefault=YES;
//        }
//            
//    }
//    if(hasDefault==NO){
//        ProductCategory *def_cat=[ProductCategory new];
//        def_cat.name=@"";
//        def_cat.categoryID=0;
//        def_cat.pictureFile=@"";
//        [self.categories addObject:def_cat];
//        [self saveInventory];
//    }
//}

- (void)loadHistory
{
    if(self.history==nil)
        self.history=[NSMutableDictionary new];
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
        if(data){
            NSKeyedUnarchiver* unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
            self.history =[unarchiver decodeObjectForKey:@"History"];
            
            if(_history==nil){
                _history=[NSMutableDictionary new];
            }
            
            [unarchiver finishDecoding];
        }
    }
    else
    {
        //self.orders = [NSMutableArray arrayWithCapacity:20];
        // self.categories = [NSMutableArray new];
        //[self loadDefaultCategory];
        //[self saveInventory];
    }
    
    AppDelegate *appDelegate= ApplicationDelegate;
    //AppConfigModel *appConfig=appDelegate.appConfig;
    
    [self synchFilteredHistory:(appDelegate.appConfig.visibility==VISIBILITY_LIVE)?YES:NO showClosed:appDelegate.appConfig.showClosed showCancelled:appDelegate.appConfig.showCancelled showRefunds:appDelegate.appConfig.showRefunds showFailed:appDelegate.appConfig.showFailed showPaid:appDelegate.appConfig.showPaid showUnpaid:appDelegate.appConfig.showUnpaid];
    
    [self synchLastOrderNumber];
    
}

- (void)saveHistory
{
    AppDelegate *appDelegate= ApplicationDelegate;
    //AppConfigModel *appConfig=appDelegate.appConfig;
    
    [self synchFilteredHistory:(appDelegate.appConfig.visibility==VISIBILITY_LIVE)?YES:NO showClosed:appDelegate.appConfig.showClosed showCancelled:appDelegate.appConfig.showCancelled showRefunds:appDelegate.appConfig.showRefunds showFailed:appDelegate.appConfig.showFailed showPaid:appDelegate.appConfig.showPaid showUnpaid:appDelegate.appConfig.showUnpaid];
    
    NSMutableData* data = [[NSMutableData alloc] init];
    NSKeyedArchiver* archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:self.history forKey:@"History"];
    
    [archiver finishEncoding];
    [data writeToFile:[self historyPath] atomically:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_UPDATE_HISTORY object:nil];
}

- (void)addOrUpdateHistory:(OrderHistory *)order
{
    [order reHash];
    NSMutableArray *orders=[self.history valueForKey:order.orderDay];
    
    if(orders==nil || [orders count]==0){
        orders=[NSMutableArray new];
        [orders addObject:order];
        [self.history setValue:orders forKey:order.orderDay];
    }
    else{
        //search first
        NSPredicate *predicate=[NSPredicate predicateWithFormat:@"orderID=%@ AND orderDay=%@ AND orderStoreID=%@",order.orderID,order.orderDay,order.orderStoreID];
        NSArray *searchResult=[orders filteredArrayUsingPredicate:predicate];
        if([searchResult count]>0){
            OrderHistory *last_item=[searchResult firstObject];
            last_item.orderStatus=order.orderStatus;
            last_item.orderNumber=order.orderNumber;
            last_item.chargeToken=order.chargeToken;
            last_item.orderAmountDue=order.orderAmountDue;
            last_item.orderItems=order.orderItems;
            last_item.orderPayments=order.orderPayments;
            last_item.orderCashBack=order.orderCashBack;
            last_item.orderStoreNum=order.orderStoreNum;
        
            
        }
        else
            [orders addObject:order];
    }
    
    //see if needed: [self.history setValue:order forKey:day];
    // [self.orders addObject:order];
    [self saveHistory];
    
    
    
    // return self.orders.count - 1;
}


- (void)addHistory:(OrderHistory *)order
{
    NSMutableArray *orders=[self.history valueForKey:order.orderDay];
    if(orders==nil){
        orders=[NSMutableArray new];
        [orders addObject:order];
        [self.history setValue:orders forKey:order.orderDay];
    }
    else{
        [orders addObject:order];
    }
    
    //see if needed: [self.history setValue:order forKey:day];
   // [self.orders addObject:order];
    [self saveHistory];
   // return self.orders.count - 1;
    //TODO: provide notification for connected device for order fullfiment
    /*if([order.orderSource isEqualToNumber:ORDER_SOURCE_LOCAL]){
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_UPDATE_HISTORY_LOCAL
                                                        object:nil
                                                      userInfo:nil];
    }
    else{*/
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_UPDATE_HISTORY
                                                            object:nil
                                                          userInfo:nil];

    //}

}



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
/*
+(NSUInteger)trashBadgeValue{
    return
}
*/
-(NSUInteger)trashCount{
    //NSArray *allOrders=[[self.history allValues] mutableCopy];
    //if([allOrders count]==0)
    //    return;
    
    NSArray *allDays=[self.history allKeys];
    if(allDays==nil || [allDays count]==0)
        return 0;
    
    NSUInteger result=0;
    NSPredicate *pDeleted=[NSPredicate predicateWithFormat:@"deleteStatus==1"];
   
    
    for(NSString *day in allDays){
        NSArray *orders=[self.history valueForKey:day];
        if(orders!=nil && [orders count]>0){
            result= result+ [[orders filteredArrayUsingPredicate:pDeleted] count];
            
        }
    }
    
    return result;
}

-(NSArray *)trashArray{
    //NSArray *allOrders=[[self.history allValues] mutableCopy];
    //if([allOrders count]==0)
    //    return;
    
    NSArray *allDays=[self.history allKeys];
    if(allDays==nil || [allDays count]==0)
        return nil;
    
    NSMutableArray *result=[NSMutableArray new];
    
    NSPredicate *pDeleted=[NSPredicate predicateWithFormat:@"deleteStatus>0"];
    //NSPredicate *pNotDeleted=[NSPredicate predicateWithFormat:@"orderIsDeleted==%@",@NO];
    
    for(NSString *day in allDays){
        NSArray *orders=[self.history valueForKey:day];
        if(orders!=nil && [orders count]>0){
            NSArray *deleted=[orders filteredArrayUsingPredicate:pDeleted];
            if(deleted!=nil && [deleted count]>0){
                [result addObjectsFromArray:deleted];
            }
            
        }
        
    }
    return result;
}

-(void)emtpyTrash:(BOOL)forced{
    //NSArray *allOrders=[[self.history allValues] mutableCopy];
    //if([allOrders count]==0)
    //    return;
    
    NSArray *allDays=[self.history allKeys];
    if(allDays==nil || [allDays count]==0)
        return;
    
    NSPredicate *pDeleted;
    NSPredicate *pNotDeleted;
    if(forced){
    
        pDeleted=[NSPredicate predicateWithFormat:@"deleteStatus==2"];
    
        pNotDeleted=[NSPredicate predicateWithFormat:@"deleteStatus!=2"];
    }
    else{
        pDeleted=[NSPredicate predicateWithFormat:@"deleteStatus>0"];
        
        pNotDeleted=[NSPredicate predicateWithFormat:@"deleteStatus==0"];

    }
    BOOL needSave=NO;
    
    for(NSString *day in allDays){
        NSArray *orders=[self.history valueForKey:day];
        if(orders!=nil && [orders count]>0){
            NSArray *deleted=[orders filteredArrayUsingPredicate:pDeleted];
            if(deleted!=nil && [deleted count]>0){
                NSArray *notdeleted=[orders filteredArrayUsingPredicate:pNotDeleted];
                [self.history setValue:notdeleted forKey:day];
                needSave=YES;
            }
            
        }
        else{
            //TODO: get today
            //[self.history removeObjectForKey:day];
        }
    }
    if(needSave){
        [self saveHistory];

    }
    
}
/*
-(void)deleteFromTrash:(OrderHistory *)item{
    
    NSString *key=item.orderDay;
    
    NSMutableArray *dayOrders=[self.history valueForKey:key];
    
    if([dayOrders count]==0)
        return;
    [dayOrders removeObject:item];
    
    [_history setValue:dayOrders forKey:key];
    
    [self saveHistory];

    
    
}
*/

-(NSArray *)search:(NSString *)searchText withSearchType:(NSString *)searchType withStatus:(NSString *)status withStartDate:(NSString*)startDate withEndDate:(NSString*)endDate isLive:(BOOL)isLive{

    
    NSPredicate* predicate;
    NSMutableArray *orders=[NSMutableArray new];
    
    NSArray *allOrders=[[self.history allValues] mutableCopy];
    if([allOrders count]==0)
        return nil;
    
    for(NSArray *arrDays in allOrders){
        NSArray *tmpArray=nil;
        predicate=[NSPredicate predicateWithFormat:@"orderIsLive == %@",@(isLive)];
        tmpArray=[arrDays filteredArrayUsingPredicate:predicate];
        if([tmpArray count]==0)
            continue;
        
        if(startDate.length>0 || endDate.length>0){ //yyy-mm-dd, yyyy-mm, yyyy
            if(startDate.length==0){
                startDate=endDate;
            }
            if(endDate.length==0){
                endDate=startDate;
            }
            //predicate=[NSPredicate predicateWithFormat:@"oderDay LIKE[c] %@]",orderDate];
            predicate=[NSPredicate predicateWithFormat:@"oderDate <= %@ AND orderDate >= %@]",startDate,endDate];
            
            tmpArray=[tmpArray filteredArrayUsingPredicate:predicate];
            if([tmpArray count]==0)
                continue;
        }
        
        
        
        if(status!=nil){
            predicate=[NSPredicate predicateWithFormat:@"status == %@",status];
            tmpArray=[tmpArray filteredArrayUsingPredicate:predicate];
            if([tmpArray count]==0)
                continue;
        }
        
        predicate=nil;
        
        searchText=[searchText stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"*"]];
        
        
        if(searchText!=nil && searchText.length>0){
            
            if([searchType isEqualToString:SEARCH_TYPE_ORDER_NUM]){
                if([Util isNumeric:searchText]){
                    predicate = [NSPredicate predicateWithFormat:@"orderNumber == %@",@([searchText integerValue])];
                }
            }
            else if([searchType isEqualToString:SEARCH_TYPE_ORDER_BY]){
                
                searchText=[searchText stringByAppendingString:@"*"];
                predicate = [NSPredicate predicateWithFormat:@"orderBy LIKE[c] %@",searchText];
            }
            else if([searchType isEqualToString:SEARCH_TYPE_ORDER_PROD]){
                searchText=[searchText stringByAppendingString:@"*"];
                predicate = [NSPredicate predicateWithFormat:@"orderItems.name LIKE[c] %@",searchText];
                
            }
            
            
            tmpArray = [tmpArray filteredArrayUsingPredicate:predicate] ;
            
            if([tmpArray count]==0)
                continue;
            
        }
        
        [orders addObject:tmpArray];
        
    }
    
    
    
    
    return orders;
    
}

//use in user detail when user is guest or userid=0

-(NSArray *)searchWithDeviceID:(NSString *)deviceID isLive:(BOOL)isLive{
    
    
    NSPredicate* predicate;
    NSMutableArray *orders=[NSMutableArray new];
    
    NSArray *allOrders=[[self.history allValues] mutableCopy];
    if([allOrders count]==0)
        return nil;
    
    for(NSArray *arrDays in allOrders){
        NSArray *tmpArray=nil;
        predicate=[NSPredicate predicateWithFormat:@"orderIsLive == %@",@(isLive)];
        tmpArray=[arrDays filteredArrayUsingPredicate:predicate];
        if([tmpArray count]==0)
            continue;
        
        predicate= [NSPredicate predicateWithFormat:@"orderDeviceID==%@",deviceID];
        
            
            tmpArray = [tmpArray filteredArrayUsingPredicate:predicate] ;
            
            if([tmpArray count]==0)
                continue;
            
        [orders addObject:tmpArray];
        
    
        
    }
    
    
    
    
    return orders;
    
}


-(NSArray *)searchWithUserName:(NSString *)userName isLive:(BOOL)isLive{
    
    
    NSPredicate* predicate;
    NSMutableArray *orders=[NSMutableArray new];
    
    NSArray *allOrders=[[self.history allValues] mutableCopy];
    if([allOrders count]==0)
        return nil;
    
    for(NSArray *arrDays in allOrders){
        NSArray *tmpArray=nil;
        predicate=[NSPredicate predicateWithFormat:@"orderIsLive == %@",@(isLive)];
        tmpArray=[arrDays filteredArrayUsingPredicate:predicate];
        if([tmpArray count]==0)
            continue;
        
        predicate= [NSPredicate predicateWithFormat:@"orderUserName==%@",userName];
        
        
        tmpArray = [tmpArray filteredArrayUsingPredicate:predicate] ;
        
        if([tmpArray count]==0)
            continue;
        
        [orders addObject:tmpArray];
        
        
        
    }
    
    
    
    
    return orders;
    
}

-(NSArray *)searchWithUserID:(NSUInteger )userID isLive:(BOOL)isLive{
    
    
    NSPredicate* predicate;
    NSMutableArray *orders=[NSMutableArray new];
    
    NSArray *allOrders=[[self.history allValues] mutableCopy];
    if([allOrders count]==0)
        return nil;
    
    for(NSArray *arrDays in allOrders){
        NSArray *tmpArray=nil;
        predicate=[NSPredicate predicateWithFormat:@"orderIsLive == %@",@(isLive)];
        tmpArray=[arrDays filteredArrayUsingPredicate:predicate];
        if([tmpArray count]==0)
            continue;
        
        predicate= [NSPredicate predicateWithFormat:@"orderUserID==%@",@(userID)];
        
        
        tmpArray = [tmpArray filteredArrayUsingPredicate:predicate] ;
        
        if([tmpArray count]==0)
            continue;
        
        [orders addObject:tmpArray];
        
        
        
    }
    
    
    
    
    return orders;
    
}


-(NSArray *)getAllDaysSorted{
    
    NSSortDescriptor *valueDescriptors=[[NSSortDescriptor alloc] initWithKey:@"self" ascending:NO];
    NSArray *descriptors=[NSArray arrayWithObject:valueDescriptors];
    
    
    return [[self.history allKeys] sortedArrayUsingDescriptors:descriptors];
    
}

//this will also be use in tab badge and in sycnc with the order hitory result
//-(NSDictionary *)synchFilteredHistory:(BOOL)isLive showClosed:(BOOL)showClosed showCancelled:(BOOL)showCancelled showRefunds:(BOOL)showRefunds showFailed:(BOOL)showFailed showPaid:(BOOL)showPaid showUnpaid:(BOOL)showUnpaid {
-(NSDictionary *)synchFilteredHistory:(BOOL)isLive showClosed:(BOOL)showClosed showCancelled:(BOOL)showCancelled showRefunds:(BOOL)showRefunds showFailed:(BOOL)showFailed showPaid:(BOOL)showPaid showUnpaid:(BOOL)showUnpaid {
    
    NSMutableDictionary *result=[NSMutableDictionary new];
    
    NSArray *sortedArray=[self getAllDaysSorted ];
    NSUInteger total=0;
    
    for(NSString *day in sortedArray){
    
        NSArray *resultsPerDay=[self.history valueForKey:day];
        if(resultsPerDay==nil || [resultsPerDay count]==0)
            continue;
        
        NSArray *filteredResutlsPerDay=[NSMutableArray new];
        
        
        NSMutableArray *filterOrderStatus=[NSMutableArray new];
        
        [filterOrderStatus addObject:@(ORDER_STATUS_RECEIVED)];
        [filterOrderStatus addObject:@(ORDER_STATUS_READY)];
        
        if (showClosed) {
            [filterOrderStatus addObject:@(ORDER_STATUS_CLOSED)];//return 0.0;
        }
        
        if (showCancelled) {
            [filterOrderStatus addObject:@(ORDER_STATUS_CANC)];//return 0.0;
        }
        
        if (showRefunds) {
            [filterOrderStatus addObject:@(ORDER_STATUS_REFUND)];//return 0.0;
        }
        if (showFailed) {
            [filterOrderStatus addObject:@(ORDER_STATUS_FAILED)];//return 0.0;
        }
        
        
        NSString *p=@"orderIsLive==%@ && orderStatus IN %@";
        if(showPaid && showUnpaid)
            p=[p stringByAppendingString:@" && (orderIsPaid==YES || orderIsPaid==NO) "];
        else if(showPaid)// && !_appDelegate.appConfig.showUnpaid)
            p=[p stringByAppendingString:@" && orderIsPaid==YES "];
        else if(showUnpaid)// && !_appDelegate.appConfig.showPaid)
            p=[p stringByAppendingString:@" && orderIsPaid==NO "];
        
        //if (showDeleted) {
            p=[p stringByAppendingString:@" && deleteStatus==0 "];
        //}
        
        
        //not working:  NSPredicate *predicate=[NSPredicate predicateWithFormat:@"(orderIsLive==%@ && orderStatus IN %@) || && orderIsPaid IN %@",@(_appDelegate.appConfig.isLive),filterOrderStatus,filterPaidStatus];
        
        NSPredicate *predicate=[NSPredicate predicateWithFormat:p,@(isLive),filterOrderStatus];
        
        
        filteredResutlsPerDay=[resultsPerDay filteredArrayUsingPredicate:predicate];//[_appDelegate.historyModel.history valueForKey:_selectedDay]];
        NSUInteger totalPerDay=[filteredResutlsPerDay count];
        if(totalPerDay>0){
            total=total+totalPerDay;
            [result setValue:filteredResutlsPerDay forKey:day];
        }
    }
    
    _filteredHistory=@{@"results":result,@"total":@(total)};
    
    return _filteredHistory;//@{@"results":result,@"total":@(total)};
    
}

-(NSInteger)synchLastOrderNumber{
    NSInteger result=1;
    NSArray *sortedArray=[self getAllDaysSorted ];
    if(sortedArray!=nil && [sortedArray count]>0){
        NSArray *arr=[_history valueForKey:[sortedArray firstObject]];
        if(arr!=nil && [arr count]>0){
            OrderHistory *oh=[arr lastObject];
            result=[oh.orderNumber integerValue];
        }
    }
    self.lastOrderNumber=result;
    return self.lastOrderNumber;
}




@end
