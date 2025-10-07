//
//  ProductOptionItem.m
//  superkiosks
//
//  Created by Katherine Sheehy on 8/22/16.
//  Copyright © 2016 Sharecle. All rights reserved.
//

#import "ProductOptionItem.h"
#import "defs_order_product.h"

@implementation ProductOptionItem
- (id)initWithCoder:(NSCoder*)decoder
{
    
    if ((self = [super init]))
    {
        self.ID= [decoder decodeIntegerForKey:IDKey];
        
        self.title = [decoder decodeObjectForKey:titleKey];
        self.UID = [decoder decodeObjectForKey:UIDKey];
        self.parentUID = [decoder decodeObjectForKey:parentUIDKey];
        self.addlCost = [decoder decodeIntegerForKey:addlCostKey];
        //self.price = [decoder decodeIntegerForKey:priceKey];
        self.sortNum = [decoder decodeIntegerForKey:sortNumKey];
        
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder*)encoder
{
    [encoder encodeInteger:self.ID forKey:IDKey];
    [encoder encodeObject:self.title forKey:titleKey];
    [encoder encodeObject:self.UID forKey:UIDKey];
    [encoder encodeObject:self.parentUID forKey:parentUIDKey];
    [encoder encodeInteger:self.addlCost forKey:addlCostKey];
    //[encoder encodeInteger:self.price forKey:priceKey];
    [encoder encodeInteger:self.sortNum forKey:sortNumKey];
    
    
}

- (id)initWithDictionary:(NSDictionary *)dictionary{
    
    NSLog(@"dictionary: %@",dictionary);
    if ((self = [super init]))
    {
        self.sortNum=[[dictionary valueForKey:sortNumKey] integerValue];
        self.title=[dictionary valueForKey:titleKey];
        self.UID=[dictionary valueForKey:UIDKey];
        self.parentUID=[dictionary valueForKey:parentUIDKey];
        self.ID=[[dictionary valueForKey:IDKey] integerValue];
        self.isDefault=[[dictionary valueForKey:isDefaultKey] boolValue];
        self.addlCost=[[dictionary valueForKey:addlCostKey] integerValue];
        //self.price=[[dictionary valueForKey:priceKey] integerValue];
        //self.maxSelected=[[dictionary valueForKey:maxSelectedKey] integerValue];

    }
    return self;
}
- (NSMutableDictionary *)toNSDictionary{
    NSMutableDictionary *dictionary=[NSMutableDictionary new];
    
    [dictionary setValue:self.title forKey:titleKey];
    //[dictionary setValue:self.storeID forKey:storeIDKey];
    [dictionary setValue:self.UID forKey:UIDKey];
    
    
    [dictionary setValue:self.parentUID forKey:parentUIDKey];
    
    [dictionary setValue:@(self.ID) forKey:IDKey];
    [dictionary setValue:@(self.sortNum) forKey:sortNumKey];
    [dictionary setValue:@(self.addlCost) forKey:addlCostKey];
    //[dictionary setValue:@(self.price) forKey:priceKey];
    [dictionary setValue:@(self.isDefault) forKey:isDefaultKey];
    
    
    return dictionary;
    
}

@end
