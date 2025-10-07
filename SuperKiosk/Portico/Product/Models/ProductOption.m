//
//  ProductOption.m
//  superkiosks
//
//  Created by Katherine Sheehy on 8/22/16.
//  Copyright © 2016 Sharecle. All rights reserved.
//

#import "ProductOption.h"
#import "defs_order_product.h"

@implementation ProductOption
- (id)initWithCoder:(NSCoder*)decoder
{
    
    if ((self = [super init]))
    {
        
        self.name = [decoder decodeObjectForKey:NameKey];
        self.selections= [decoder decodeObjectForKey:selectionsKey];
        self.UID = [decoder decodeObjectForKey:UIDKey];
        self.parentUID = [decoder decodeObjectForKey:parentUIDKey];
        self.ID = [decoder decodeIntegerForKey:IDKey];
        self.maxSelected = [decoder decodeIntegerForKey:maxSelectedKey];
        self.sortNum= [decoder decodeIntegerForKey:sortNumKey];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder*)encoder
{
    
    [encoder encodeObject:self.name forKey:NameKey];
    [encoder encodeObject:self.selections forKey:selectionsKey];
    [encoder encodeObject:self.UID forKey:UIDKey];
    [encoder encodeObject:self.parentUID forKey:parentUIDKey];
    [encoder encodeInteger:self.ID forKey:IDKey];
    [encoder encodeInteger:self.maxSelected forKey:maxSelectedKey];
    [encoder encodeInteger:self.sortNum forKey:sortNumKey];
}

- (NSMutableDictionary *)toNSDictionary{
    NSMutableDictionary *dictionary=[NSMutableDictionary new];
    
    [dictionary setValue:self.name forKey:nameKey];
    
    [dictionary setValue:self.UID forKey:UIDKey];
    [dictionary setValue:(self.parentUID == nil)?@"":self.parentUID forKey:parentUIDKey];
    
    [dictionary setValue:@(self.ID) forKey:IDKey];
    [dictionary setValue:@(self.maxSelected) forKey:maxSelectedKey];
    [dictionary setValue:@(self.sortNum) forKey:sortNumKey];
    
    
    NSMutableArray *items=[NSMutableArray new];
    for (ProductOptionItem *item in self.selections) {
        
        [items addObject:[item toNSDictionary]];
    }
    [dictionary setValue:items forKey:selectionsKey];

    
    return dictionary;
}

- (id)initWithDictionary:(NSDictionary *)dictionary{
    if ((self = [super init]))
    {
        self.name=[dictionary valueForKey:nameKey];
        self.UID=[dictionary valueForKey:UIDKey];
        self.parentUID=[dictionary valueForKey:parentUIDKey];
        self.ID=[[dictionary valueForKey:IDKey] integerValue];
        self.sortNum=[[dictionary valueForKey:sortNumKey] integerValue];
         self.maxSelected=[[dictionary valueForKey:maxSelectedKey] integerValue];
        self.minSelected=[[dictionary valueForKey:minSelectedKey] integerValue];
        
        self.selections=[NSMutableArray new];
        NSArray *items=[dictionary valueForKey:selectionsKey];
        if([items count]>0){
            for(NSDictionary *item in items){
                ProductOptionItem *poi=[[ProductOptionItem alloc] initWithDictionary:item];
                
                if([poi.parentUID isEqual:[NSNull null]])
                    poi.parentUID=@"";
                
                if([self.UID isEqual:[NSNull null]]){
                    self.UID=@"";
                    continue;
                }
                
                if(![poi.parentUID isEqualToString:self.UID]){
                    poi.parentUID=self.UID;
                }
                
                [self.selections addObject:poi];
            }
        }
        
    }
    return self;
}

@end
