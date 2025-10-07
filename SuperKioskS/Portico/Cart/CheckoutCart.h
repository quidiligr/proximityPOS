//
//  RWCheckoutCart.h
//  
//
//  Created by Romulo Quidilig.
//  Copyright (c) 2015 Sharecle Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "Product.h"
#import "OrderItem.h"

@interface CheckoutCart : NSObject

+ (CheckoutCart *)sharedInstance;

- (NSArray*)itemsInCart;

- (BOOL)containsItem:(OrderItem*)item;
- (OrderItem*)getItem:(NSInteger)productID;
- (void)addItem:(OrderItem*)item;
//- (void)addProduct:(Product*)product withQuantity:(NSUInteger)quantity;

- (void)removeItem:(OrderItem*)item;
//- (void)removeProduct:(Product*)product withQuantity:(NSUInteger)quantity;


- (void)clearCart;

- (NSInteger)total;

//- (NSInteger)total_tax:(float) tax;
- (NSInteger)total_tax:(NSInteger)totalCents tax:(double)tax;

- (NSInteger)grand_total:(double) tax;

//- (NSString*)textLabel;
- (NSString*)textLabel:(NSString *) storeName storeID:(NSString *)storeID;
@property (nonatomic,strong)OrderHistory *order;

@end
