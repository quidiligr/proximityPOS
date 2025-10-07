//
//  RWCheckoutCart.h
//  
//
//  Created by Romulo Quidilig.
//  Copyright (c) 2015 Sharecle Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Product.h"
#import "OrderItem.h"
#import "OrderHistory.h"
#import "InventoryModel.h"
#import "InventoryItem.h"

@interface CheckoutCart : NSObject

//+ (CheckoutCart *)sharedInstance;
//+ (NSNumber *)sharedTaxInstance;

//- (NSArray*)itemsInCart;
@property (strong, nonatomic) NSMutableArray* itemsArray;
- (BOOL)containsItem:(OrderItem*)product;
- (OrderItem*)getItem:(NSInteger)productID;
//- (void)addItem:(OrderItem*)item;
- (void)addItem:(OrderItem*)item isLive:(BOOL)isLive;
//- (void)addProduct:(Product*)product withQuantity:(NSUInteger)quantity;

- (void)removeItem:(OrderItem*)item;
//- (void)removeProduct:(Product*)product withQuantity:(NSUInteger)quantity;
//-(void)cleanCart:(NSString *)storeID isLive:(BOOL)isLive;
//-(void)cleanCart:(NSString *)storeID isLive:(BOOL)isLive withInventory:(InventoryItem *)inventory;
-(void)cleanCart:(NSString *)storeID isLive:(BOOL)isLive withInventory:(InventoryItem *)inventory;
- (void)clearCart;

- (NSInteger)total; 


//+(double)compute_discount:(double)pct_discount price:(NSInteger)price quantity:(NSInteger)quantity;
- (NSInteger)total_discount;
//- (NSInteger)total_tax:(float) tax;
//- (NSInteger)total_tax:(NSInteger)totalCents tax:(double)tax;
- (NSInteger)total_tax:(NSInteger)totalCents tax:(float)tax;

- (NSInteger)grand_total:(double) tax;

- (NSString*)textLabel:(NSString *) storeName storeID:(NSString *)storeID;



@property (nonatomic,strong)OrderHistory *order;
@property (nonatomic,strong)NSString *currentStoreID;
@property (nonatomic,strong)NSString *inventoryID;
//@property (nonatomic,strong)InventoryItem *inventory;

@property NSInteger tip;
@property (nonatomic,strong) NSMutableArray *discounts;

/*
@property(nonatomic)float salesTax;
@property(nonatomic)float salesTip;
@property(nonatomic,strong)NSString *salesTipLabel;
*/
@end
