//
//  RWPuppyViewController.h
//  RWPuppies
//
//  Created by Pietro Rea on 12/25/12.
//  Copyright (c) 2012 Pietro Rea. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderMenuViewController.h"

@class Product;
@class OrderItem;
@class InventoryItem;
@class ProductCategory;
@class AppDelegate;

@interface ProductViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate,UITextFieldDelegate,UISplitViewControllerDelegate>

@property (strong, nonatomic) Product* selectedProduct;
@property (strong, nonatomic) InventoryItem* selectedInventory;
@property (strong, nonatomic) ProductCategory* selectedCategory;
@property(nonatomic,strong) OrderMenuViewController *refenceToParentViewController;
@property (strong, nonatomic) IBOutlet UILabel *messageLabel;

@property (nonatomic, strong) AppDelegate *appDelegate;

@end
