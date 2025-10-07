//
//  Util.h
//  superkiosks
//
//  Created by Katherine Sheehy on 4/25/16.
//  Copyright © 2016 Sharecle. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Util : NSObject
+(NSString *)discountToString:(double)discount;
//+(NSString *)priceToString:(double)price;
+(NSString *)priceToString:(double)price currency:(NSString *)currency;
+(NSString *)decimalDisplay:(double)decimal;
+ (CGSize)sizeForText:(NSString*)text;


+(UIImage *)resizeImage:(UIImage*)image newSize:(CGSize)newSize;

+ (void)httpGetInventoryWithStore:(StoreHistory *)store;
+ (void)postSearchStores:(NSString *)search;
+ (AFHTTPClient *)clientSharedInstance;
+(NSString *)priceIntToString:(NSInteger)price currency:(NSString *)currency;
@end
