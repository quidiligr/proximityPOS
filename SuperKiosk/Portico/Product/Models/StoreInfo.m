//
//  IODItem.m
//  iOSDiner
//
//  Created by Romulo Quidilig on 3/19/15.
//  Copyright (c) 2015 Sharecle Inc. All rights reserved.
//

#import "StoreInfo.h"
#import "defs_order_product.h"
//#define kInventoryAddress @"http://kiosk.sharecle.com/inventory/"
/*static NSString* const NameKey = @"Name";
static NSString* const ImageKey = @"Image";
static NSString* const StoreIDKey = @"StoreID";
*/
@implementation StoreInfo

- (id)initWithCoder:(NSCoder*)decoder
{
    if ((self = [super init]))
    {
        self.name = [decoder decodeObjectForKey:NameKey];
       self.storeID=[decoder decodeObjectForKey:StoreIDKey];
        self.pictureFile = [decoder decodeObjectForKey:ImageKey];
        
       
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder*)encoder
{
    [encoder encodeObject:self.name forKey:NameKey];
    [encoder encodeObject:self.storeID forKey:StoreIDKey];
    [encoder encodeObject:self.pictureFile forKey:ImageKey];
   
}

@end
