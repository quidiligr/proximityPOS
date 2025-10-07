//
//  OrderItemOption.h
//  superkiosk
//
//  Created by Katherine Sheehy on 8/26/16.
//  Copyright © 2016 Appcoda. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ProductOptionItem.h"

@interface OrderOptionItem : NSObject


@property (nonatomic,copy)NSString *title;
@property (nonatomic)NSInteger ID;
@property (nonatomic,copy)NSString* UID;
@property (nonatomic,copy)NSString* parentUID;
@property (nonatomic,assign)NSInteger addlCost;
//@property (nonatomic,assign)NSInteger price;

- (id)initWithOptionItem:(ProductOptionItem *)poi;

- (id)initWithDictionary:(NSDictionary *)dictionary;

- (NSMutableDictionary *)toNSDictionary;
@end
