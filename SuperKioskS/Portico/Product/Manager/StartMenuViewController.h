//
//  EmptyViewController.h
//  superkiosks
//
//  Created by Katherine Sheehy on 12/10/15.
//  Copyright © 2015 Appcoda. All rights reserved.
//

#import <UIKit/UIKit.h>
@class InventoryItem;
@class ProductCategory;
@class Product;
//#import "InventorySettingsViewController.h"
//#import "InventorySelectionDelegate.h"
@interface StartMenuViewController : UIViewController<UISplitViewControllerDelegate>
//@property (nonatomic,strong) InventorySettingsViewController *settingsViewContorller;
@property(nonatomic,strong) InventoryItem *selectedInventory;
@property(nonatomic,strong) ProductCategory *selectedCategory;
@property(nonatomic,strong) Product *selectedProduct;

@end
