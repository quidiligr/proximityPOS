//
//  DiscountItem.h
//  superkiosk
//
//  Created by Katherine Sheehy on 2/24/16.
//  Copyright © 2016 Sharecle. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DiscountItem : NSObject
@property (nonatomic,strong) NSString* name;

@property (nonatomic,copy) NSString* discountID;
@property (nonatomic) NSInteger price;
//@property(nonatomic,copy)NSString *storeID;
- (NSMutableDictionary *)toJSONDictionary;
- (id)initWithJSON:(NSDictionary *)dict;
@end
