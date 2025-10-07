//
//  Created by Romulo Quidilig on 3/19/15.
//  Copyright (c) 2015 Sharecle Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Product.h"

@interface OrderItem : NSObject<NSCoding>



@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *barcode;
@property (nonatomic,assign) NSInteger price;
@property (nonatomic,assign) NSInteger actualPrice;
@property (nonatomic,assign) NSUInteger discountType;
@property (nonatomic,assign) double discount;

@property (nonatomic,assign) NSUInteger productID;
@property (nonatomic,assign) NSUInteger quantity;
@property (nonatomic,copy) NSString* storeID;
@property (nonatomic,copy) NSString *notes;
@property (nonatomic) BOOL isLive;
@property (nonatomic,copy) NSString *errorMessage;
@property (nonatomic,strong) NSMutableArray *options;



- (id)initWithName:(NSString*)inName andPrice:(float)inPrice andPictureFile:(NSString*)inPictureFile andProductID:(int)inProductID andCategoryID:(int)inCategroyID andDetail:(NSString *)inDetail;
- (id)initWithJSON:(NSDictionary*)json;
//- (id)initWithProduct:(Product *)product isLive:(BOOL)isLive;
- (id)initWithProduct:(Product *)product isLive:(BOOL)isLive withStoreID:(NSString *)storeID;
@end
