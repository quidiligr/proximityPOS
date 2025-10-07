//
//  DiscountItem.m
//  superkiosk
//
//  Created by Katherine Sheehy on 2/24/16.
//  Copyright © 2016 Sharecle. All rights reserved.
//

#import "DiscountItem.h"
#import "defs_order_product.h"
@implementation DiscountItem
- (id)initWithCoder:(NSCoder*)decoder
{
    if ((self = [super init]))
    {
        self.name = [decoder decodeObjectForKey:NameKey];
        self.discountID=[decoder decodeObjectForKey:OrderDiscountIDKey];
        
        
        
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder*)encoder
{
    [encoder encodeObject:self.name forKey:NameKey];
    [encoder encodeObject:self.discountID forKey:OrderDiscountIDKey];
    
    
}

- (NSMutableDictionary *)toJSONDictionary{
    NSMutableDictionary *dictionary=[NSMutableDictionary new];
    
    [dictionary setValue:self.discountID forKey:DiscountIDKey];
    
    [dictionary setValue:[NSNumber numberWithInteger:self.price] forKey:PriceKey];
    
    [dictionary setValue:self.name  forKey:NameKey];
    
    return dictionary;
    
    
}


- (BOOL)isEqual:(id)object {
    if (![object isKindOfClass:[DiscountItem class]]) {
        return NO;
    }
    
    DiscountItem *other = (DiscountItem *)object;
    //return [other.deviceToken isEqualToString:self.deviceToken];
    //bool result=[other.peerID isEqual:self.peerID] || [other.peerID.displayName isEqualToString:self.peerID.displayName];
    
    bool result=[other.discountID isEqualToString:self.discountID];
    
    return result;
}
@end
