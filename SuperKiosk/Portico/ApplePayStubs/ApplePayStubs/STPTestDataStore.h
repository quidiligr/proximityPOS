//
//  STPTestDataStore.h
//  StripeExample
//
//  Created by Jack Flintermann on 10/1/14.
//  Copyright (c) 2014 Stripe. All rights reserved.
//



#import <Foundation/Foundation.h>

@protocol STPTestDataStore <NSObject>
//rom added
@property(nonatomic) id selectedStore;

@property(nonatomic) id selectedItem;
@property(nonatomic, readonly) NSArray *allItems;
- (NSArray *)descriptionsForItem:(id)item;
- (instancetype)initWithTestCard;
- (instancetype)initWithLiveCard;

@end

