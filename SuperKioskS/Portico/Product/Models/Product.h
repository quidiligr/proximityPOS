//
//  IODItem.h
//  iOSDiner
//
//  Created by Romulo Quidilig on 3/19/15.
//  Copyright (c) 2015 Sharecle Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ProductCategory.h"
#import "ProductOption.h"

@interface Product : NSObject <NSCoding>

@property(nonatomic,assign)NSUInteger productID;
@property(nonatomic,copy)NSString *barcode;
@property(nonatomic,copy)NSString *productUID;
@property(nonatomic,assign)NSUInteger sortNumber;
//@property(nonatomic,assign)NSUInteger productNumber;
@property (nonatomic,copy) NSString* name;
@property(nonatomic,copy)NSString* detail;
@property(nonatomic,copy)NSString* shortDesc;
@property (nonatomic) NSInteger price;
@property (nonatomic) NSInteger actualPrice;

//@property (nonatomic) double discountVal;
//@property (nonatomic) double discountPct;
@property (nonatomic) double discount;
@property (nonatomic) NSUInteger discountType;

@property (nonatomic,copy) NSString* pictureFile;


@property(nonatomic,assign)NSUInteger maxQuantity; //per customer
@property(nonatomic,assign)NSUInteger minQuantity;

@property(nonatomic,assign)NSUInteger instock;
@property(nonatomic,assign)BOOL allowOutOfStock;//stock_unlimited;
//@property(nonatomic,assign)BOOL published;
@property (nonatomic) BOOL publishedLocal;
@property (nonatomic) BOOL publishedInternet;


@property(nonatomic,assign)NSUInteger initialStock;
@property(nonatomic,assign)NSUInteger sold;

@property(nonatomic,strong)NSMutableArray *options;
@property (nonatomic,strong) NSMutableArray *images;
@property (nonatomic,assign) BOOL feaured;
//purchase
//@property(nonatomic,assign)int quantity;
//@property(nonatomic,assign)NSDate *purchaseDateTime;
//@property(nonatomic,assign)NSDate *purchaseDate;
//@property(nonatomic,copy)NSString* storeID;


//@property(nonatomic,assign) int limitPer;
//@property(nonatomic,assign)long total;
//@property(nonatomic,assign) int sold;
//@property (nonatomic,assign) float discount_price;
@property(nonatomic,assign) NSUInteger categoryID;
//@property(nonatomic,assign) NSString *categoryName;
//@property(nonatomic,assign) ProductCategory* productCategory;
@property(nonatomic,strong) ProductOption *selectedOption;
//@property(nonatomic,assign) int sort_id;
//@property (nonatomic,assign) float tax;
- (NSMutableDictionary *)toNSDictionary;

- (id)initWithDictionary:(NSDictionary *)dictionary;
-(void)importFromDictionary:(NSDictionary *)dictionary;
-(ProductOptionItem *)getOptionItemWithParentUID:(NSString *)parentUID andUID:(NSString *)UID;
//-(NSString *)actualPriceToString;

//`+(double)compute_discount:(double)pct_discount price:(NSInteger)price quantity:(NSInteger)quantity;
//+(NSInteger)compute_discount_val:(double)pct_discount price:(NSInteger)price;

+(Product *)fromDictionary:(NSDictionary *)dictionary;

-(void)uploadImage;
-(void)downloadImage;
-(void)removeImage;
@end
