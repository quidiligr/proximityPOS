//
//  InventoryViewController.h
//
//
//  Created by Romulo Quidilig.
//  Copyright (c) 2015 Sharecle Inc. All rights reserved.
//


#import <UIKit/UIKit.h>

@protocol EditProductViewControllerDelegate;

@class Product;
@class ProductCategory;
//@class InventoryItem;

@interface EditProductViewController : UITableViewController

@property(nonatomic,strong) Product *selectedProduct;
@property(nonatomic,strong) ProductCategory *selectedCategory;
@property (nonatomic, strong) UIPopoverController *popOver;
//@property(nonatomic,strong) InventoryItem *selectedInventory;
@property(nonatomic,assign)id<EditProductViewControllerDelegate> delegate;
@end

@protocol EditProductViewControllerDelegate <NSObject>

-(void)editProductViewControllerDidUpdate:(EditProductViewController *)viewController;


@end
