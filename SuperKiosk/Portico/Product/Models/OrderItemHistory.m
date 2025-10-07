//
//  IODItem.m
//  iOSDiner
//
//  Created by Romulo Quidilig on 3/19/15.
//  Copyright (c) 2015 Sharecle Inc. All rights reserved.
//

#import "OrderItemHistory.h"
//#define kInventoryAddress @"http://kiosk.sharecle.com/inventory/"

@implementation OrderItemHistory

@synthesize name;
@synthesize price;
@synthesize pictureFile;
@synthesize detail;
@synthesize productID;
@synthesize categoryID;
@synthesize quantity;

- (id)initWithName:(NSString*)inName andPrice:(float)inPrice andPictureFile:(NSString*)inPictureFile andProductID:(int)inProductID andCategoryID:(int)inCategroyID andDetail:(NSString *)inDetail{
    self=[super init];
    //if (self = [self init]) {
    if(self){
        [self setName:inName];
        [self setPrice:inPrice];
        [self setPictureFile:inPictureFile];
        [self setProductID:inProductID];
        [self setCategoryID:inCategroyID];
        [self setDetail:inDetail];
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
@end
