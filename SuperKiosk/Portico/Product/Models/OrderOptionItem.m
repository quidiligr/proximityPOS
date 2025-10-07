//
//  OrderItemOption.m
//  superkiosk
//
//  Created by Katherine Sheehy on 8/26/16.
//  Copyright © 2016 Appcoda. All rights reserved.
//

#import "OrderOptionItem.h"
#import "defs_order_product.h"

//#import "ProductOption.h"
@implementation OrderOptionItem

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
   // [encoder encodeInteger:self.price forKey:priceKey];
    
    
}

- (id)initWithOptionItem:(ProductOptionItem *)poi
{
    
    if ((self = [super init]))
    {
        self.ID= poi.ID;
        
        self.title = poi.title;
        self.UID = poi.UID;
        self.parentUID = poi.parentUID;
        self.addlCost = poi.addlCost;
        //self.price = poi.price;
        
    }
    return self;
}
- (NSMutableDictionary *)toNSDictionary{
    NSMutableDictionary *dictionary=[NSMutableDictionary new];
    
    [dictionary setValue:self.title forKey:titleKey];
    
    [dictionary setValue:self.UID forKey:UIDKey];
    [dictionary setValue:self.parentUID forKey:parentUIDKey];
    [dictionary setValue:@(self.ID) forKey:IDKey];
   // [dictionary setValue:@(self.price) forKey:priceKey];
    [dictionary setValue:@(self.addlCost) forKey:addlCostKey];
    return dictionary;
    
}

                      
- (id)initWithDictionary:(NSDictionary *)dictionary{
    if ((self = [super init]))
    {
        self.title=[dictionary valueForKey:titleKey];
        self.UID=[dictionary valueForKey:UIDKey];
        self.parentUID=[dictionary valueForKey:parentUIDKey];
        self.ID=[[dictionary valueForKey:IDKey] integerValue];
       // self.price=[[dictionary valueForKey:priceKey] integerValue];
        self.addlCost=[[dictionary valueForKey:addlCostKey] integerValue];
        
        
        
    }
    return self;
}

@end
