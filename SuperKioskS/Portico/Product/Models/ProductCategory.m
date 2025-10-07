//
//  IODItem.m
//  iOSDiner
//
//  Created by Romulo Quidilig on 3/19/15.
//  Copyright (c) 2015 Sharecle Inc. All rights reserved.
//

#import "ProductCategory.h"
#import "Product.h"
#import "defs.h"
#import "defs_order_product.h"
//#define kInventoryAddress @"http://kiosk.sharecle.com/inventory/"



@implementation ProductCategory

- (id)initWithCoder:(NSCoder*)decoder
{
    if ((self = [super init]))
    {
        self.name = [decoder decodeObjectForKey:NAME_KEY];
       self.categoryID=[decoder decodeIntForKey:CATEGORYID_KEY];
        self.pictureFile = [decoder decodeObjectForKey:pictureFileKey];
        self.sortNumber=[decoder decodeIntegerForKey:SORTNUMBER_KEY];
        self.detail = [decoder decodeObjectForKey:DETAIL_KEY];
        self.publishedLocal=[decoder decodeBoolForKey:PublishedLocalKey];
        self.publishedInternet=[decoder decodeBoolForKey:PublishedInternetKey];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder*)encoder
{
    [encoder encodeObject:self.name forKey:NAME_KEY];
    [encoder encodeInt:self.categoryID forKey:CATEGORYID_KEY];
    [encoder encodeObject:self.categoryUID forKey:CATEGORYUID_KEY];
    [encoder encodeObject:self.pictureFile forKey:pictureFileKey];
   [encoder encodeObject:self.detail forKey:DETAIL_KEY];
     [encoder encodeInteger:self.sortNumber forKey:SORTNUMBER_KEY];
    [encoder encodeBool:self.publishedLocal forKey:PublishedLocalKey];
    [encoder encodeBool:self.publishedInternet forKey:PublishedInternetKey];
}

+(ProductCategory *)fromDictionary:(NSDictionary *)dictionary{
    ProductCategory *result=[ProductCategory new];
    result.name=DICT_GET(dictionary, NAME_KEY);// [dictionary valueForKey:NAME_KEY];
    result.categoryUID=DICT_GET(dictionary, CATEGORYUID_KEY);//[dictionary valueForKey:CATEGORYUID_KEY];
    result.categoryID=DICT_GET_INT(dictionary, CATEGORYID_KEY);//[[dictionary valueForKey:CATEGORYID_KEY] intValue];
    result.pictureFile=DICT_GET(dictionary, pictureFileKey);//[dictionary valueForKey:pictureFileKey];
    result.detail=DICT_GET(dictionary, DetailKey);//[dictionary valueForKey:DetailKey];
    result.sortNumber=DICT_GET_INT(dictionary, SORTNUMBER_KEY);//[[dictionary valueForKey:SORTNUMBER_KEY] integerValue];
    result.publishedLocal=DICT_GET_INT(dictionary, PublishedLocalKey);//[[dictionary valueForKey:PublishedLocalKey] boolValue];
    result.publishedInternet=DICT_GET_INT(dictionary, PublishedInternetKey);//[[dictionary valueForKey:PublishedInternetKey] boolValue];
    result.sortedProducts=[NSMutableArray new];
    result.products=[NSMutableArray new];
    result.searchedProducts=[NSMutableArray new];
    
    return result;
}


-(NSDictionary *)toNSDictionary{
    
    NSMutableDictionary *dictionary=[[NSMutableDictionary alloc]init];
    [dictionary setValue:self.name forKey:NAME_KEY];
   
     [dictionary setValue:self.categoryUID forKey:CATEGORYUID_KEY];
    [dictionary setValue:(self.detail == nil)?@"":self.detail forKey:DETAIL_KEY];
    
    [dictionary setValue:(self.pictureFile==nil)?@"":self.pictureFile forKey:pictureFileKey];
    
    [dictionary setValue:[NSNumber numberWithUnsignedInteger:self.sortNumber] forKey:SORTNUMBER_KEY];
    
    [dictionary setValue:[NSNumber numberWithUnsignedInteger:self.categoryID] forKey:CATEGORYID_KEY];
    
    [dictionary setValue:[NSNumber numberWithBool:self.publishedLocal] forKey:PublishedLocalKey];
    [dictionary setValue:[NSNumber numberWithBool:self.publishedInternet] forKey:PublishedInternetKey];
    
    return dictionary;

}

-(NSArray *)sort{
    //NSPredicate* predicate=[NSPredicate predicateWithFormat:@"categoryID=%i",categoryID];
    //NSArray *resultArray=[self.products filteredArrayUsingPredicate:predicate];
    //if(sorted){
        NSSortDescriptor *descriptor=[[NSSortDescriptor alloc] initWithKey:@"sortNumber" ascending:YES];
        return [self.products sortedArrayUsingDescriptors:[NSArray arrayWithObject:descriptor]];
    //}
    //else{
    //    return resultArray;
   // }
    
}

@end
