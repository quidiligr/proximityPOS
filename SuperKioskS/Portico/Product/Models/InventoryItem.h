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
//@property (nonatomic,strong) NSMutableArray* options;
//@property (nonatomic,strong) NSMutableArray* optionItems;

@property (nonatomic,copy)NSString* name;

@property (nonatomic)BOOL isEcommerce;
@property (nonatomic)BOOL isLive;

@property BOOL acceptCCard;
@property BOOL acceptCash;
@property BOOL acceptSK;
@property BOOL useApplePay;
@property float shippingCost;
@property (nonatomic)float salesTax;
@property (nonatomic)float salesTip;
@property NSInteger hoursBeforeDeleteUnpaid;
@property NSInteger refundLevel;
@property NSInteger authType;

@property NSInteger allowedDaysToSynch;

//@property (nonatomic)float discount;
//@property (nonatomic)int discountType;

@property (nonatomic,copy)NSString *currency;
@property (nonatomic,copy)NSString *currencySymbol;

@property  NSInteger maxUnpaidOrdersPerCustomer;
@property  NSInteger maxChargeAmount;
@property  NSInteger minChargeAmount;
@property (nonatomic,strong) NSString *acceptedCards;

@property (nonatomic,copy)NSString* inventoryId; //this changes everytime an update occured
//@property (nonatomic)BOOL isActive;

@property (nonatomic)NSUInteger lastProductID;

-(BOOL)isEqual:(id)object;

- (ProductCategory *)addCategory:(NSString*)withName imageName:(NSString *)imageFile detail:(NSString *)detail;

//- (Product *)addProduct:(NSString*)name  categoryId:(NSUInteger)categoryId price:(NSInteger)price actualPrice:(NSInteger)actualPrice discount:(double)discount discountType:(NSUInteger)discountType imageName:(NSString *)imageFile detail:(NSString *)detail remaining:(NSInteger)remaining unlimited:(BOOL)unlimited;

- (BOOL)addProduct:(Product *)product;

//- (NSDictionary *)toMenuDictionary:(AppConfigModel *)appConfig storeId:(NSString *)storeId storeName:(NSString *)storeName;
- (NSDictionary *)toMenuDictionary:(AppConfigModel *)appConfig;
-(NSArray *)allProductsWithCategoryID:(NSUInteger)categoryID sorted:(BOOL)sorted;

-(NSArray *)searchProducts:(NSString *)keywords;

-(Product *)searchProduct:(NSUInteger)productID;

-(NSArray *)searchProductsWithBarcode:(NSString *)barcode;

-(ProductCategory *)searchCategoryWithID:(NSUInteger)categoryID;

//- (NSDictionary *)toDictionaryExport;
- (NSDictionary *)toDictionary;
- (NSDictionary *)toDictionaryExport;
+(InventoryItem *)fromDictionaryExport:(NSDictionary *)dict;

- (NSString *)toJSonString;

-(void)pushInventory:(NSString *)json;
- (void)pullInventory;
-(void)updateFromPullInventory:(NSDictionary *)dict;

@end
