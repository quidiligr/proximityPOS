//
//  IODItem.h
//  iOSDiner
//
//  Created by Romulo Quidilig on 3/19/15.
//  Copyright (c) 2015 Sharecle Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ProductCategory.h"

@interface Product : NSObject <NSCoding>

@property(nonatomic,assign)NSUInteger productID;
@property(nonatomic,copy)NSString *productUID;
@property(nonatomic,assign)NSUInteger sortNumber;
//@property(nonatomic,assign)NSUInteger productNumber;
@property (nonatomic,copy) NSString* barcode;
@property (nonatomic,copy) NSString* name;
@property (nonatomic,copy) NSString* nameGrammar;
@property (nonatomic,assign) BOOL allowOutOfStock;
@property(nonatomic,copy)NSString* detail;
@property(nonatomic,copy)NSString* shortDesc;
@property (nonatomic) NSInteger price;
@property (nonatomic) NSInteger actualPrice;
@property (nonatomic,copy) NSString* pictureFile;

//this dynamic prop and soes not need to be saved
//@property (nonatomic,assign) NSUInteger imageLoadStatus;


@property(nonatomic,assign)NSUInteger maxQuantity;
@property(nonatomic,assign)NSUInteger minQuantity;


@property(nonatomic,assign)NSUInteger instock;
@property(nonatomic,assign)NSUInteger sold;

@property (nonatomic,assign) BOOL publishedLocal;
@property (nonatomic,assign) BOOL publishedInternet;
@property (nonatomic,strong) NSMutableArray *options;


//purchase
//@property(nonatomic,assign)int quantity;
//@property(nonatomic,assign)int purchaseDateTime;
//@property(nonatomic,assign)int purchaseDate;
//@property(nonatomic,copy)NSString* storeID;


//@property(nonatomic,assign) int limitPer;
//@property(nonatomic,assign)long total;
//@property(nonatomic,assign) int sold;
@property (nonatomic,assign) double discount;
@property(nonatomic,assign) NSUInteger discountType;
@property(nonatomic,assign) NSUInteger categoryID;
@property(nonatomic,assign) NSString *categoryName;
@property(nonatomic,assign) ProductCategory* productCategory;

//@property(nonatomic,assign) int sort_id;
//@property (nonatomic,assign) float tax;
- (NSMutableDictionary *)toNSDictionay;

- (id)initWithDictionary:(NSDictionary *)dictionary;

+(NSString *)discountToString:(double)discount currency:(NSString *)currency;
+(NSString *)priceToString:(double)price currency:(NSString *)currency;

-(void)downloadImage:(StoreHistory *)store;
//+(double)compute_discount:(double)pct_discount price:(NSInteger)price quantity:(NSInteger)quantity;

-(NSString *)cleanTextForSpeech:(NSString *)text;

@end
