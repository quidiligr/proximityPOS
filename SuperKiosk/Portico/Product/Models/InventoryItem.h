//

//  Created by Romulo Quidilig on 3/19/15.
//  Copyright (c) 2015 Sharecle Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Product;
@class ProductCategory;



@interface InventoryItem : NSObject<NSCoding>



@property (nonatomic,strong) NSMutableArray* products;
@property (nonatomic,strong) NSMutableArray* categories;

@property (nonatomic,strong)NSString* name;

@property (nonatomic)BOOL isEcommerce;
@property BOOL acceptCCard;
@property (nonatomic,strong)NSString* acceptedCards;
@property BOOL acceptCash;
@property BOOL useApplePay;

@property (nonatomic)float shippingCost;

@property (nonatomic)float salesTax;
@property (nonatomic)float salesTip;
@property (nonatomic,strong)NSString *salesTipLabel;

@property NSInteger hoursBeforeDeleteUnpaid;
@property NSInteger refundLevel;

@property NSInteger allowedDaysToSynch;

//@property (nonatomic)float discount;
@property (nonatomic)int discountType;

@property (nonatomic,strong)NSString *currency;
@property (nonatomic)NSString *currencySymbol;

@property  NSInteger maxUnpaidOrdersPerCustomer;
@property  NSInteger maxChargeAmount;
@property  NSInteger minChargeAmount;

@property (nonatomic,strong)NSString* inventoryId;

//@property (nonatomic,strong)NSString* featuredProductId;

@property (nonatomic)BOOL isActive;

//-(void)initFromDictionary:(NSDictionary *)dict;
-(void)deserialize:(NSDictionary *)dict;
-(NSArray *)allProductsWithCategoryID:(NSUInteger)categoryID sorted:(BOOL)sorted;

-(void)updateSettingWithDictionary:(NSDictionary *)dict;
-(void)updateProductsWithDictionary:(NSDictionary *)dict;

-(NSArray *)searchProductsWithPictureFile:(NSString *)fileName;
-(BOOL)hasImagesLoading;

-(NSArray *)searchProducts:(NSString *)keywords;
-(ProductCategory *)searchCategoryWithID:(NSUInteger)categoryID;
-(NSArray *)searchProductsWithBarcode:(NSString *)barcode;
-(NSArray *)speechSearchProducts:(NSString *)keywords;

@end
