//
//  InventoryViewController.h
//
//
//  Created by Romulo Quidilig.
//  Copyright (c) 2015 Sharecle Inc. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "InventoryModel.h"
#import "AppDelegate.h"
#import "EditProductViewController.h"
#import "AddProductViewController.h"
//#import "CategoryViewController.h"
//#import "ProductSelectionDelegate.h"

@interface CategoryProductsViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,EditProductViewControllerDelegate,AddProductViewControllerDelegate>
//@property (nonatomic, strong,readonly) InventoryModel* inventoryModel;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(strong,nonatomic)ProductCategory *selectedCategory;
@property(strong,nonatomic)Product *selectedProduct;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *editProductButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *upButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *downButton;
//@property (strong, nonatomic) IBOutlet UIToolbar *toolBarr;
//@property (strong, nonatomic) IBOutlet UIView *toolBarrView;

@property(nonatomic)BOOL triggerAddItem;
//@property (strong, nonatomic) IBOutlet UILabel *messageLabel;


//@property (nonatomic, strong)InventoryItem *selectedInventory;
//@property (nonatomic, assign) id<ProductSelectionDelegate> delegateProduct;
//@property (nonatomic) BOOL needsUpdate;

@end
