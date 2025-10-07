//
//  IODItem.h
//  iOSDiner
//
//  Created by Romulo Quidilig on 3/19/15.
//  Copyright (c) 2015 Sharecle Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Product.h"

@interface OrderItem : NSObject <NSCoding>
@property (nonatomic,strong) NSString* name;
@property (nonatomic,assign) NSInteger price;
@property (nonatomic,assign) NSInteger actualPrice;
@property (nonatomic,assign) NSUInteger discountType;
@property (nonatomic,assign) double discount;

@property (nonatomic,assign) NSUInteger productID;
@property (nonatomic,strong) NSString *barcode;
@property (nonatomic,assign) NSInteger quantity;
@property (nonatomic,strong) NSString* storeID;
@property (nonatomic,strong) NSString* notes;
@property (nonatomic) BOOL isLive;
@property (nonatomic,strong) NSString *errorMessage;
@property (nonatomic,strong) NSMutableArray *options;
//@property (nonatomic,strong) NSString *notesLabel; //combine options labe and notes




- (id)initWithName:(NSString*)inName andPrice:(NSInteger)inPrice andActualPrice:(NSInteger)inActualPrice andPictureFile:(NSString*)inPictureFile andProductID:(int)inProductID andCategoryID:(int)inCategroyID andDetail:(NSString *)inDetail;

- (id)initWithProduct:(Product *)product isLive:(BOOL)isLive withStoreID:(NSString *)storeID;

- (NSMutableDictionary *)toJSONDictionary;

-(NSString *)notesLabel;

@end
