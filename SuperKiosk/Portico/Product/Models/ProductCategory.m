//
//  IODItem.m
//  iOSDiner
//
//  Created by Romulo Quidilig on 3/19/15.
//  Copyright (c) 2015 Sharecle Inc. All rights reserved.
//

#import "ProductCategory.h"
#import "defs_order_product.h"
//#define kInventoryAddress @"http://kiosk.sharecle.com/inventory/"
/*static NSString* const NameKey = @"Name";
static NSString* const ImageKey = @"Image";
static NSString* const CategoryIDKey = @"CategoryID";
*/
@implementation ProductCategory

- (id)initWithCoder:(NSCoder*)decoder
{
    if ((self = [super init]))
    {
        self.name = [decoder decodeObjectForKey:NameKey];
       self.categoryID=[decoder decodeIntForKey:CategoryIDKey];
        self.pictureFile = [decoder decodeObjectForKey:ImageKey];
        self.products = [decoder decodeObjectForKey:PRODUCTS_KEY];
        self.publishedLocal=[decoder decodeBoolForKey:PublishedLocalKey];
        self.publishedInternet=[decoder decodeBoolForKey:PublishedInternetKey];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder*)encoder
{
    [encoder encodeObject:self.name forKey:NameKey];
    [encoder encodeInteger:self.categoryID forKey:CategoryIDKey];
    [encoder encodeObject:self.pictureFile forKey:ImageKey];
   [encoder encodeObject:self.products forKey:PRODUCTS_KEY];
    [encoder encodeBool:self.publishedLocal forKey:PublishedLocalKey];
    [encoder encodeBool:self.publishedInternet forKey:PublishedInternetKey];
}

-(id)initWithDictionary:(NSDictionary *)dictionary{
    if ((self = [super init]))
    {
    self.categoryID=[[dictionary valueForKey:CategoryIDKey] integerValue];
    self.name=[dictionary valueForKey:NameKey];
    self.detail=[dictionary valueForKey:DETAIL_KEY];
    self.pictureFile=[dictionary valueForKey:IMAGE_KEY];
    self.products=[dictionary valueForKey:PRODUCTS_KEY];
        self.publishedLocal=[[dictionary valueForKey:PublishedLocalKey] boolValue];
        self.publishedInternet=[[dictionary valueForKey:PublishedInternetKey] boolValue];
    }
    return self;
}

@end
