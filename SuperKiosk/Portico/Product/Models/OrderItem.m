//
//  IODItem.m
//  iOSDiner
//
//  Created by Romulo Quidilig on 3/19/15.
//  Copyright (c) 2015 Sharecle Inc. All rights reserved.
//

#import "OrderItem.h"
#import "defs_order_product.h"
#import "OrderOptionItem.h"
//#define kInventoryAddress @"http://kiosk.sharecle.com/inventory/"
/*static NSString* const NameKey = @"Name";
static NSString* const PriceKey = @"Price";
//static NSString* const ImageKey = @"Image";
//static NSString* const CategoryIDKey = @"CategoryID";
static NSString* const ProductIDKey = @"ProductID";
//static NSString* const ProductKey = @"ProductKey";
static NSString* const QuantityKey = @"Quantity";
//static NSString* const DetailKey = @"Detail";
*/
@implementation OrderItem

//@synthesize name;
//@synthesize price;
//@synthesize pictureFile;
//@synthesize detail;
//@synthesize productID;
//@synthesize categoryID;
//@synthesize quantity;
- (id)initWithCoder:(NSCoder*)decoder
{
    if ((self = [super init]))
    {
        self.productID=[decoder decodeIntegerForKey:ProductIDKey];
        self.quantity = [decoder decodeIntegerForKey:QuantityKey];
        self.name = [decoder decodeObjectForKey:NameKey];
        self.notes = [decoder decodeObjectForKey:NotesKey];
        self.price = [decoder decodeIntegerForKey:PriceKey];
        self.actualPrice = [decoder decodeIntegerForKey:ActualPriceKey];
        self.discount=[decoder decodeDoubleForKey:DiscountKey];
        self.options=[decoder decodeObjectForKey:optionsKey];
       // self.storeID = [decoder decodeObjectForKey:StoreIDKey];
        
    }
    return self;
}


- (void)encodeWithCoder:(NSCoder*)encoder
{
    [encoder encodeInteger:self.productID forKey:ProductIDKey];
    [encoder encodeInteger:self.quantity forKey:QuantityKey];
     [encoder encodeInteger:self.price forKey:PriceKey];
    [encoder encodeInteger:self.actualPrice forKey:ActualPriceKey];
    [encoder encodeDouble:self.discount forKey:DiscountKey];
     [encoder encodeObject:self.name forKey:NameKey];
    [encoder encodeObject:self.notes forKey:NotesKey];
    [encoder encodeObject:self.options forKey:optionsKey];
    

    //[encoder encodeObject:self.storeID forKey:StoreIDKey];
    
    
}
- (id)initWithName:(NSString*)inName andPrice:(NSInteger)inPrice andActualPrice:(NSInteger)inActualPrice andPictureFile:(NSString*)inPictureFile andProductID:(int)inProductID andCategoryID:(int)inCategroyID andDetail:(NSString *)inDetail{
    self=[super init];
    //if (self = [self init]) {
    if(self){
        [self setName:inName];
        [self setPrice:inPrice];
        [self setActualPrice:inActualPrice];
        [self setDiscount:0.0];
        
        //[self setPictureFile:inPictureFile];
        [self setProductID:inProductID];
        [self setQuantity:1];
        //[self setCategoryID:inCategroyID];
        //[self setDetail:inDetail];
    }
    
    return self;
}

- (id)initWithProduct:(Product *)product isLive:(BOOL)isLive withStoreID:(NSString *)storeID{
    self=[super init];
 
    if(self){
        
        self.productID=product.productID;
      
        self.name=product.name;
        self.price=product.price;
        self.actualPrice=product.actualPrice;
        self.discount=product.discount;
        self.discountType=product.discountType;
        self.quantity=product.minQuantity;
        self.isLive=isLive;
        self.storeID=storeID;
        //if(self.options==nil)
          //  self.options=[
        //self.notes=product.notes;
        
    }
    
    return self;
}
//rom
- (BOOL)isEqual:(id)object {
    if (![object isKindOfClass:[OrderItem class]]) {
        return NO;
    }
    
    OrderItem *other = (OrderItem *)object;
    //return [other.deviceToken isEqualToString:self.deviceToken];
    //bool result=[other.peerID isEqual:self.peerID] || [other.peerID.displayName isEqualToString:self.peerID.displayName];
    
    bool result=(other.productID == self.productID);
    
    return result;
}
/*
- (id)initWithDictionary:(NSDictionary *)dictionary{
    if ((self = [super init]))
    {
        
        [dictionary setValue:self.name forKey:NameKey];
        [dictionary setValue:self.detail forKey:DetailKey];
        [dictionary setValue:[NSNumber numberWithFloat:self.price] forKey:PriceKey];
        [dictionary setValue:self.pictureFile forKey:ImageKey];
        [dictionary setValue:[NSNumber numberWithInt:self.productID] forKey:ProductIDKey];
        
        self.name = [dictionary valueForKey:NameKey];
        self.detail = [dictionary valueForKey:DetailKey];
        self.price =  [[dictionary  valueForKey:PriceKey] floatValue];
        self.pictureFile = [dictionary valueForKey:ImageKey];
        self.categoryID=[[dictionary valueForKey:CategoryIDKey] intValue];
        self.productID=[[dictionary valueForKey:ProductIDKey] intValue];
    }
    return self;
    
    
}
*/
/*
-(id)copyWithZone:(NSZone *)zone {
    OrderItem* newItem = [OrderItem new];
    [newItem setName:[self name]];
    [newItem setPrice:[self price]];
    [newItem setPictureFile:[self pictureFile]];
    [newItem setProductID:[self productID]];
    [newItem setCategoryID:[self categoryID]];
    [newItem setDetail:[self detail]];
    [newItem setQuantity:[self quantity]];
    return newItem;
}
*/
/*
+ (NSArray*)retrieveInventoryItems {
    NSMutableArray* inventory = [NSMutableArray new];
    NSError* err = nil;
    
    NSArray* jsonInventory = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:kInventoryAddress]] 
                                                             options:kNilOptions 
                                                               error:&err];
    [jsonInventory enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSDictionary* item = obj;
        [inventory addObject:[[IODItem alloc] initWithName:[item objectForKey:@"Name"] 
                                                  andPrice:[[item objectForKey:@"Price"] floatValue]
                                            andPictureFile:[item objectForKey:@"Image"]]];
    }];
    
    return [inventory copy];
}
*/
/*
+ (NSArray*)retrieveInventoryItems:(NSString *)inventoryAddress {
    NSMutableArray* inventory = [NSMutableArray new];
    NSError* err = nil;
    
    NSArray* jsonInventory = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:inventoryAddress]]
                                                             options:kNilOptions
                                                               error:&err];
    [jsonInventory enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSDictionary* item = obj;
        [inventory addObject:[[OrderItem alloc] initWithName:[item objectForKey:@"Name"]
                                                  andPrice:[[item objectForKey:@"Price"] floatValue]
                                            andPictureFile:[item objectForKey:@"Image"]]];
    }];
    
    return [inventory copy];
}
*/
//+ (NSDictionary*)retrieveInventoryItems:(NSString *)inventoryAddress {
//    //NSMutableArray* inventory = [NSMutableArray new];
//    NSError* err = nil;
//    
//    /*
//     NSArray* jsonInventory = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:inventoryAddress]]
//                                                             options:kNilOptions
//                                                               error:&err];
//    [jsonInventory enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
//        NSDictionary* item = obj;
//        [inventory addObject:[[OrderItem alloc] initWithName:[item objectForKey:@"Name"]
//                                                    andPrice:[[item objectForKey:@"Price"] floatValue]
//                                              andPictureFile:[item objectForKey:@"Image"]]];
//    }];
//     */
//    
//    NSDictionary* jsonInventory = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:inventoryAddress]]
//                                                             options:kNilOptions
//                                                               error:&err];
//    NSLog([NSString stringWithFormat:@"jsonInventory=%@",jsonInventory]);
//    return [jsonInventory copy];
//}
/*
+ (NSArray*)retrieveInventoryItems:(NSString *)inventoryAddress {
    NSMutableArray* inventory = [NSMutableArray new];
    NSError* err = nil;
    
    NSArray* jsonInventory = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:inventoryAddress]]
                                                             options:kNilOptions
                                                               error:&err];
    [jsonInventory enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSDictionary* item = obj;
        [inventory addObject:[[OrderItem alloc] initWithName:[item objectForKey:@"Name"]
                                                    andPrice:[[item objectForKey:@"Price"] floatValue]
                                              andPictureFile:[item objectForKey:@"Image"]]];
    }];
    
    return [inventory copy];
}
 */
/*
 self.productID=product.productID;
 self.productNumber=product.productNumber;
 self.name=product.name;
 self.price=product.price;
 self.pictureFile=product.pictureFile;
 self.categoryID=product.categoryID;
 self.maxQuantity=product.maxQuantity;
 
 static NSString* const NameKey = @"Name";
 static NSString* const PriceKey = @"Price";
 static NSString* const ImageKey = @"Image";
 //static NSString* const CategoryIDKey = @"CategoryID";
 static NSString* const ProductIDKey = @"ProductID";

 */
- (NSMutableDictionary *)toJSONDictionary{
    NSMutableDictionary *dictionary=[NSMutableDictionary new];
    
    [dictionary setValue:[NSNumber numberWithInteger:self.productID ] forKey:ProductIDKey];
    
    [dictionary setValue:[NSNumber numberWithInteger:self.price] forKey:PriceKey];
    [dictionary setValue:[NSNumber numberWithInteger:self.actualPrice] forKey:ActualPriceKey];
    [dictionary setValue:[NSNumber numberWithFloat:self.discount] forKey:DiscountKey];
    [dictionary setValue:[NSNumber numberWithInteger:self.discountType] forKey:DiscountTypeKey];
    /*[dictionary setValue:self.product.pictureFile forKey:ImageKey];
    [dictionary setValue:self.product.name  forKey:NameKey];
    [dictionary setValue:self.product.pictureFile forKey:ImageKey];
     */
    [dictionary setValue:self.name  forKey:NameKey];
     [dictionary setValue:self.notes  forKey:NotesKey];

    [dictionary setValue:[NSNumber numberWithInteger:self.quantity ] forKey:QuantityKey];
    
    if(self.options==nil)
        self.options=[NSMutableArray new];
    
    if([self.options count]>0){
        NSMutableArray *arr=[NSMutableArray new];
        for(OrderOptionItem *ooi in self.options  ){
            NSDictionary *ooi_dict=[ooi toNSDictionary];
            [arr addObject:ooi_dict];
        }
        [dictionary setValue:arr forKey:optionsKey];
    
    }
    
    
    
    
    
    return dictionary;
    
    
}

-(NSString *)notesLabel{
    NSString *notes=@"";
    if ([self.options count]>0){
        for(OrderOptionItem *ooi in self.options){
            NSString *priceString=@"";
            if(ooi.addlCost!=0)
                priceString= [NSString stringWithFormat:@"@%@",[Product priceToString:(double)ooi.addlCost/100 currency:nil]];
            //NSString *quantity=(orderItem.quantity>1)?[NSString stringWithFormat:@" @%@x",@(orderItem.quantity)]:@"";
            notes=[NSString stringWithFormat:@"%@%@ %@\n", notes,ooi.title,priceString];
        }
    }
    if(self.notes.length>0){
        notes=[NSString stringWithFormat:@"%@\"%@\"",notes,self.notes];
    }
    return notes;
}

@end
