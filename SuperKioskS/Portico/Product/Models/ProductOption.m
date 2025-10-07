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
        self.minSelected = [decoder decodeIntegerForKey:minSelectedKey];
        self.sortNum= [decoder decodeIntegerForKey:sortNumKey];
        
        [self autoCorrectMinMax];
    }
    return self;
}



- (void)encodeWithCoder:(NSCoder*)encoder
{
    [self autoCorrectMinMax];
    [encoder encodeObject:self.name forKey:NameKey];
    [encoder encodeObject:self.selections forKey:selectionsKey];
    [encoder encodeObject:self.UID forKey:UIDKey];
    [encoder encodeObject:self.parentUID forKey:parentUIDKey];
    [encoder encodeInteger:self.ID forKey:IDKey];
    [encoder encodeInteger:self.maxSelected forKey:maxSelectedKey];
    [encoder encodeInteger:self.minSelected forKey:minSelectedKey];
    [encoder encodeInteger:self.sortNum forKey:sortNumKey];
    
}

-(void)autoCorrectMinMax{
    NSInteger count=[self.selections count];
    if(self.maxSelected>count)
        self.maxSelected=count;
    
    if(self.minSelected>count)
        self.minSelected=count;
    
    
    if(self.minSelected>count)
        self.minSelected=count;
}

- (id)initWithDictionary:(NSDictionary *)dictionary{
    NSLog(@"dictionary: %@",dictionary);
    if ((self = [super init]))
    {
        
        //self.productNumber=[[dictionary valueForKey:ProductNumberKey] integerValue];
        self.sortNum=[[dictionary valueForKey:sortNumKey] integerValue];
        
        self.name=[dictionary valueForKey:NameKey];
        self.UID=[dictionary valueForKey:UIDKey];
        self.parentUID=[dictionary valueForKey:parentUIDKey];
        self.ID=[[dictionary valueForKey:IDKey] integerValue];
        self.maxSelected=[[dictionary valueForKey:maxSelectedKey] integerValue];
        self.minSelected=[[dictionary valueForKey:minSelectedKey] integerValue];
        
        self.selections=[NSMutableArray new];
        
        NSArray *arr=[dictionary valueForKey:optionsKey];
        if(![arr isEqual:[NSNull null]] && arr!=nil && [arr count]>0){
            for(NSDictionary *itemDict in arr){
                NSLog(@"dictionary: %@",itemDict);
                ProductOptionItem *poi=[[ProductOptionItem alloc] initWithDictionary:itemDict];
                                
                [self.selections addObject:poi];
            }
        }
        
        [self autoCorrectMinMax];
        
        
    }
    return self;
}
- (NSMutableDictionary *)toNSDictionary{
    NSMutableDictionary *dictionary=[NSMutableDictionary new];
    
    [dictionary setValue:self.name forKey:NameKey];
    //[dictionary setValue:self.storeID forKey:storeIDKey];
    
    [dictionary setValue:self.UID forKey:UIDKey];
    [dictionary setValue:(self.parentUID == nil)?@"":self.parentUID forKey:parentUIDKey];
    
    [dictionary setValue:@(self.ID) forKey:IDKey];
    [dictionary setValue:@(self.maxSelected) forKey:maxSelectedKey];
    [dictionary setValue:@(self.minSelected) forKey:minSelectedKey];
    [dictionary setValue:@(self.sortNum) forKey:sortNumKey];
    
    
    NSMutableArray *items=[NSMutableArray new];
    
    if(self.selections==nil)
        self.selections=[NSMutableArray new];
    
    for (ProductOptionItem *item in self.selections) {
        
        [items addObject:[item toNSDictionary]];
    }
    [dictionary setValue:items forKey:selectionsKey];

    
    return dictionary;
}
@end
