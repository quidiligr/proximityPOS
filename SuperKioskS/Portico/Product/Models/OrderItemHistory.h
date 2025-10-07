//
//  IODItem.h
//  iOSDiner
//
//  Created by Romulo Quidilig on 3/19/15.
//  Copyright (c) 2015 Sharecle Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Product.h"

@interface OrderItemHistory : NSObject//Product <NSCopying>

//@property (nonatomic,strong) NSString* name;
//@property (nonatomic,assign) float price;
//@property (nonatomic,strong) NSString* pictureFile;
//@property (nonatomic,assign) int productID;
/*@property (nonatomic,assign) int quantity;
@property(nonatomic,strong) NSDate *purchaseDate;
@property(nonatomic,strong) NSString *purchaseCompanyName;
@property(nonatomic,strong) NSString *purchaseLocation;
@property(nonatomic,strong) NSString *purchaseSalesPerson;
*/
@property (nonatomic,strong) NSString* text;
//@property (nonatomic,assign) int orderID;

//- (id)initWithName:(NSString*)inName andPrice:(float)inPrice andPictureFile:(NSString*)inPictureFile;

- (id)initWithName:(NSString*)inName andPrice:(float)inPrice andPictureFile:(NSString*)inPictureFile andProductID:(int)inProductID andCategoryID:(int)inCategroyID andDetail:(NSString *)inDetail;

//+ (NSArray*)retrieveInventoryItems;


//+ (NSArray*)retrieveInventoryItems:(NSString *)inventoryAddress;
@end
