//
//  IODOrder.h
//  iOSDiner
//
//  Created by Romulo Quidilig on 3/19/15.
//  Copyright (c) 2015 Sharecle Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@class OrderItem;

@interface Order : NSObject

//@property (nonatomic,strong) NSMutableDictionary* orderItems;
@property (nonatomic,strong) NSMutableArray* orderItems;

- (OrderItem*)findKeyForOrderItem:(OrderItem*)searchItem;
- (NSMutableArray *)orderItems;
- (NSString*)orderDescription;
- (void)addItemToOrder:(OrderItem*)inItem;
- (void)removeItemFromOrder:(OrderItem*)inItem;
- (float)totalOrder;
+ (NSArray*)retrieveInventoryItems:(NSString *)inventoryAddress;
@end
