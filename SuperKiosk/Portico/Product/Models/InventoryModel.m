//
//  IODOrder.m
//  iOSDiner
//
//  Created by Romulo Quidilig on 3/19/15.
//  Copyright (c) 2015 Sharecle Inc. All rights reserved.
//

#import "InventoryModel.h"
#import "InventoryItem.h"
#import "Product.h"
#import "ProductCategory.h"
#import "NSData+Conversion.h"
#import "defs.h"

@implementation InventoryModel
//@synthesize products;


- (id)init {
    self = [super init];
    if (self) {
        //Custom initialization
        //self.productsArray = [[NSMutableArray alloc] init];
         //_inventoryModel = [[InventoryModel alloc] init];
      //  self.products=[NSMutableArray new];
       // self.categories=[NSMutableArray new];
    }
    return self;
}


+ (InventoryModel *)sharedInstance {
    static InventoryModel*  _sharedInventory;
    
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        _sharedInventory = [[InventoryModel alloc] init];
        _sharedInventory.inventories=[NSMutableArray new];
        [_sharedInventory loadInventory];
        
      /*  _sharedInventory.products=[NSMutableArray new];
        _sharedInventory.categories=[NSMutableArray new];
        _sharedInventory.name=nil;
       
        _sharedInventory.isActive=NO;
        */
        
    });
    
    return _sharedInventory;
}

/*+ (InventoryModel *)publishedInstance {
    static InventoryModel*  _publishedInventory;
    
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        
        _publishedInventory = [[InventoryModel alloc] init];
        _publishedInventory.products=[NSMutableArray new];
        _publishedInventory.categories=[NSMutableArray new];
        _publishedInventory.name=nil;
        //_publishedInventory.paymentMethod=0;//BOTH
        _publishedInventory.isActive=YES;
        
        
        NSDictionary *settings=[InventoryModel sharedSettings];
        NSString *pub_name=[settings valueForKey:KEY_SETTINGS_INV_PUBLISHEDNAME];
        //NSNumber *payment_method=[settings valueForKey:KEY_SETTINGS_INV_PAYMENTMETHOD];
       //NSDate *pub_date=[settings valueForKey:KEY_SETTINGS_INV_PUBLISHEDDATE];
        if (pub_name!=nil &&
            [pub_name length]>0) {
            _publishedInventory.name=pub_name;
            [_publishedInventory loadInventory];
            
        }
        
        
        
    });
    
    
    return _publishedInventory;
}
 */


// Returns the path to the Messages.plist file in the app's Documents directory
- (NSString*)inventoryPath//:(NSString *)withTitle
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
    NSString *filename=@"inventory.plist";//[self.name stringByAppendingString:@".inventory.plist"];
    return [documentsDirectory stringByAppendingPathComponent:filename];
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
- (void)loadInventory
{
   // [self.products removeAllObjects];
  //  [self.categories removeAllObjects];
    
    NSString* path = [self inventoryPath];
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
        self.inventories=[unarchiver decodeObjectForKey:@"Inventories"];
        
        /*NSArray *arr_products=[unarchiver decodeObjectForKey:@"Products"];
        NSArray *arr_cats=[unarchiver decodeObjectForKey:@"Categories"];
        
        NSNumber *num_isActive=[unarchiver decodeObjectForKey:@"IsActive"];
        
        if(num_isActive){
            self.isActive=[num_isActive boolValue];
        }
        
        if(arr_products!=nil)
            self.products = [arr_products mutableCopy];
        if(arr_cats!=nil)
            self.categories = [arr_cats mutableCopy];
        
        [self loadDefaultCategory];
         */
        [unarchiver finishDecoding];
    }
    else
    {
        self.inventories=[NSMutableArray new];
       // self.products = [NSMutableArray arrayWithCapacity:20];
       // [self loadDefaultCategory];
    }
}

- (void)saveInventory{
    
    NSMutableData* data = [[NSMutableData alloc] init];
    NSKeyedArchiver* archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
   [archiver encodeObject:self.inventories forKey:@"Inventories"];
    
    /*[archiver encodeObject:self.products forKey:@"Products"];
    [archiver encodeObject:self.categories forKey:@"Categories"];
   
    [archiver encodeObject:[NSNumber numberWithBool:self.isActive] forKey:@"IsActive"];
     */
    [archiver finishEncoding];
    [data writeToFile:[self inventoryPath] atomically:YES];
    // [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_UPDATE_PRODUCTS object:nil userInfo:nil];
    
}

- (void)saveInventoryWithItems:(NSArray *)items
{
    
    /*
    NSMutableData* data = [[NSMutableData alloc] init];
    NSKeyedArchiver* archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:self.products forKey:@"Products"];
    [archiver encodeObject:self.categories forKey:@"Categories"];
    
    [archiver encodeObject:[NSNumber numberWithBool:self.isActive] forKey:@"IsActive"];
    [archiver finishEncoding];
    [data writeToFile:[self inventoryPath] atomically:YES];
   
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_UPDATE_PRODUCTS object:nil userInfo:nil];
     */
}





+(InventoryItem *)activeInventory{
    InventoryModel *inventoryModel =[InventoryModel sharedInstance];
    NSPredicate *predicate= [NSPredicate predicateWithFormat:@"isActive==1"];
    if([inventoryModel.inventories count]>0){
        NSArray *result=[inventoryModel.inventories filteredArrayUsingPredicate:predicate];
        if([result count]>0)
            return [result firstObject];
    }
    //else
    return  nil;
}

+(void)setActiveInventory:(InventoryItem *)inventory{
    InventoryModel *inventoryModel =[InventoryModel sharedInstance];
    
    if([inventoryModel.inventories count]>0){
       
        for(InventoryItem *item in inventoryModel.inventories){
            if([item isEqual:inventory]){
                item.isActive=YES;
            }
            else{
                item.isActive=NO;
            }
            
        }
        [inventoryModel saveInventory];
    }
    
}

- (BOOL)exists:(NSString *)name
{
    NSArray *names=[ self.inventories valueForKey:NAME_KEY];
    if ([names containsObject:name])
       return YES;
    else
        return NO;
    
 
}

- (InventoryItem *)getInventoryItemWithName:(NSString *)name
{
  
    NSPredicate *predicate= [NSPredicate predicateWithFormat:@"name=%@",name];
    if([self.inventories count]>0){
        NSArray *result=[self.inventories filteredArrayUsingPredicate:predicate];
        if([result count]>0)
            return [result firstObject];
    }
    //else
    return  nil;

    
}


- (InventoryItem *)addInventory:(NSString *)name
{
   // NSArray *names=[ self.inventories valueForKey:NAME_KEY];
   // if ([names containsObject:names])
     //   return nil;
    InventoryItem *newItem=[InventoryItem new];
    NSString *newId=[[[NSUUID UUID] UUIDString] lowercaseString];
    
    NSArray *ids=[ self.inventories valueForKey:INVENTORYID_KEY];
    if ([ids containsObject:newId]){
        newId=[[[NSUUID UUID] UUIDString] lowercaseString];
        if ([ids containsObject:newId]){
            return nil;
        }
    }
    
    newItem.inventoryId=newId;
    newItem.name=name;
    //set defaults
    newItem.isEcommerce=YES;
    newItem.acceptCCard=YES;
    newItem.currency=@"usd";
    newItem.currencySymbol=@"$";
    //newItem.maxChargeAmount=50.0;
    //see if any active inventories set
    InventoryItem *inventoryItem=[InventoryModel activeInventory];
    if(inventoryItem ==nil){
        newItem.isActive=YES;
    }
    
    
    [self.inventories addObject:newItem];
    [self saveInventory];
    return [self.inventories lastObject];
}

- (void)deleteInventory:(InventoryItem *)item
{
        [self.inventories removeObject:item];
     [self saveInventory];
   
}



- (ProductCategory *)addCategory:(NSString*)categoryName imageName:(NSString *)imageFile detail:(NSString *)detail toInventory:(NSString *)inventoryName{
    
    NSDictionary *inventory =[self.inventories valueForKey:inventoryName];
    
    NSMutableArray *categories=[inventory valueForKey:categoriesKey];
    
   // NSPredicate *predicate=[NSPredicate predicateWithFormat:@"name=%@",categoryName];
    
    
    categoryName=[categoryName stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" "]];
    
    if(categoryName.length==0)
        return nil;
    
    
    
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"name=%@",categoryName];
    NSArray *search=[categories filteredArrayUsingPredicate:predicate];
    if([search count]>0) //duped
        return nil;
    
    NSSortDescriptor *valueDescriptors=[[NSSortDescriptor alloc] initWithKey:@"sortNumber" ascending:YES];
    NSArray *descriptors=[NSArray arrayWithObject:valueDescriptors];
    
    
    NSArray *sortedArray=[categories sortedArrayUsingDescriptors:descriptors];
    
   // NSUInteger newSortNumber=[sortedArray count];
    
    if([sortedArray count]>0)
    {
        ProductCategory *last=[sortedArray lastObject];
        if(last.sortNumber!=[sortedArray count]-1){
            //re-number
            for (NSUInteger i=0; i<[sortedArray count]; i++) {
                ((ProductCategory *)sortedArray[i]).sortNumber=i;
            }
            
            [self saveInventory];
            
           // sortedArray=[self.categories sortedArrayUsingDescriptors:descriptors];
            
        }
        
        
        
    }
    
    ProductCategory *newCategory=[ProductCategory new];
    
    newCategory.name=categoryName;
    newCategory.pictureFile=imageFile;
    newCategory.sortNumber=categories.count;
    newCategory.detail=detail;
    
    ProductCategory *last_cat=[categories lastObject];
        //ProductCategory *new_cat=[ProductCategory new];
        //new_cat.name=name;
        newCategory.categoryID=last_cat.categoryID+1;
        [categories addObject:newCategory];
  //  return newCategory;
    [self saveInventory];
    return newCategory;
    
}





-(Product *)searchAllProduct:(NSUInteger)productID {
     Product *result=nil;
    InventoryModel *model=[InventoryModel sharedInstance];
    //serch active menu first
    NSSortDescriptor *descriptor=[[NSSortDescriptor alloc] initWithKey:isActiveKey ascending:NO];
    
    NSPredicate* predicate;
    NSArray *sortedArray=[model.inventories sortedArrayUsingDescriptors:[NSArray arrayWithObject:descriptor]];
    for(InventoryItem *inv in sortedArray){
        //for (ProductCategory *c in inv.categories) {
            
            predicate = [NSPredicate predicateWithFormat:@"productID=%@",@(productID)];
            
            NSArray* results = [inv.products filteredArrayUsingPredicate:predicate];
            
            if(results !=nil && [results count]>0)//{
                return [results firstObject];
            //}
           // else
           //     return nil;
        //}
        
    }
   
    return result;
    
  
}


/*
  NSPredicate *p=[NSPredicate predicateWithFormat:@"ANY name CONTAINS[c] %@",search];
 */

/*
- (BOOL)isEqual:(id)object {
    if (![object isKindOfClass:[InventoryModel class]]) {
        return NO;
    }
    
    InventoryModel *other = (InventoryModel *)object;
    //return [other.deviceToken isEqualToString:self.deviceToken];
    //bool result=[other.peerID isEqual:self.peerID] || [other.peerID.displayName isEqualToString:self.peerID.displayName];
    
    bool result=(other.name == self.name);
    
    return result;
}

*/
@end
