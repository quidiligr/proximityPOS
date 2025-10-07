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
       // _sharedHistory= [NSMutableDictionary new];
        //_sharedHistory.orders=[NSMutableArray new];
       // _sharedHistory.dates=[NSMutableArray new];
        //_sharedInventory.categories=[NSMutableArray new];
    });
    
    return _sharedHistory;
}

// Returns the path to the Messages.plist file in the app's Documents directory
- (NSString*)historyPath//:(NSString *)withTitle
{
    /*
    if(withTitle==nil)
        withTitle=@"Inventory";
    else {
        withTitle=[withTitle stringByReplacingOccurrencesOfString:@" " withString:@"_"];
    }
    */
    //withTitle=[withTitle stringByAppendingString:@".plist"];
    
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDirectory = paths[0];
    NSString *filename=[self.filename stringByAppendingString:@".history.plist"];
    //NSString *filename=@"history.plist";
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
        NSKeyedUnarchiver* unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
        self.history =[unarchiver decodeObjectForKey:@"History"];
        /*NSArray *arr_orders=[unarchiver decodeObjectForKey:@"Orders"];
        NSArray *arr_days=[unarchiver decodeObjectForKey:@"Days"];
        
        if(arr_orders!=nil)
            self.orders = [arr_orders mutableCopy];
        if(arr_days!=nil)
            self.days = [arr_days mutableCopy];
         */
        
        /*if([self.categories count]==0){
         self.categories=[NSMutableArray new];
         ProductCategory *def_cat=[ProductCategory new];
         def_cat.name=@"default";
         def_cat.categoryID=0;
         def_cat.pictureFile=@"";
         [self.categories addObject:def_cat];
         }
         */
        /*if(self.products==nil)
         self.products=[NSMutableArray new];
         
         if(self.categories==nil)
         self.categories=[NSMutableArray new];
         */
        //[self loadDefaultCategory];
        [unarchiver finishDecoding];
    }
    else
    {
        //self.orders = [NSMutableArray arrayWithCapacity:20];
        // self.categories = [NSMutableArray new];
        //[self loadDefaultCategory];
        //[self saveInventory];
    }
}

- (void)saveHistory
{
    NSMutableData* data = [[NSMutableData alloc] init];
    NSKeyedArchiver* archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:self.history forKey:@"History"];
    //[archiver encodeObject:self.days forKey:@"Days"];
    [archiver finishEncoding];
    [data writeToFile:[self historyPath] atomically:YES];
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

- (void)addHistory:(NSString *)day withOrder:(OrderHistory *)order
{
    NSMutableArray *orders=[self.history valueForKey:day];
    if(orders==nil){
        orders=[NSMutableArray new];
        [orders addObject:order];
        [self.history setValue:orders forKey:day];
    }
    else{
        [orders addObject:order];
    }
    
    //see if needed: [self.history setValue:order forKey:day];
   // [self.orders addObject:order];
    [self saveHistory];
   // return self.orders.count - 1;
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


@end
