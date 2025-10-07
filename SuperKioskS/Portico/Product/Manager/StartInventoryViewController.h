//
//  EmptyViewController.h
//  superkiosks
//
//  Created by Katherine Sheehy on 12/10/15.
//  Copyright © 2015 Appcoda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InventorySettingsViewController.h"

@class InventoryItem;
@class ProductCategory;
@class Product;

@interface StartInventoryViewController : UIViewController<UISplitViewControllerDelegate>
@property (nonatomic,strong) InventorySettingsViewController *settingsViewContorller;
@property(nonatomic,strong) InventoryItem *selectedInventory;
@property(nonatomic,strong) ProductCategory *selectedCategory;
@property(nonatomic,strong) Product *selectedProduct;
@property (strong, nonatomic) IBOutlet UILabel *lblMessage;
//@property (nonatomic, strong) UIPopoverController *popover;
@end
