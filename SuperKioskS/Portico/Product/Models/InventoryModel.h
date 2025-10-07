//
//  IODOrder.h
//  iOSDiner
//
//  Created by Romulo Quidilig on 3/19/15.
//  Copyright (c) 2015 Sharecle Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

//#define KEY_SETTINGS_INV_PUBLISHEDNAME @"PublishedName"
//#define KEY_SETTINGS_INV_PUBLISHEDDATE @"PublishedDate"

#define KEY_SETTINGS_INV_FILENAME @"inventory_settings.plist"
@class Product;
@class ProductCategory;
@class InventoryItem;



@interface InventoryModel : NSObject
+ (InventoryModel *)sharedInstance;

//@property (nonatomic,strong)NSMutableArray *inventories;

@property (nonatomic,strong)InventoryItem *inventory;

//@property (nonatomic,strong)NSString *md5;

- (void)loadInventory;

- (void)loadInventoryWithData:(NSData *)data;

- (void)saveInventory;
//- (void)saveInventoryWithItems:(NSArray *)items;

//+(InventoryItem *)activeInventory;
//+(void)setActiveInventory:(InventoryItem *)inventory;

//- (InventoryItem *)addInventory:(NSString *)name;
//- (void)deleteInventory:(InventoryItem *)item;

- (Product *)searchAllProduct:(NSUInteger)productID;

//- (InventoryItem *)getInventoryItemWithName:(NSString *)name;
//- (BOOL)exists:(NSString *)name;

@end
