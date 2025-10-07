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
#import "ProductSelectionDelegate.h"
//#import "CategoryViewController.h"


@interface CategoryProductsIpadViewController : UITableViewController<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
//@property (nonatomic, strong,readonly) InventoryModel* inventoryModel;

//@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property(strong,nonatomic)ProductCategory *selectedCategory;
@property(strong,nonatomic)Product *selectedProduct;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *editProductButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *upButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *downButton;
@property (strong, nonatomic) IBOutlet UIToolbar *toolBar;
@property(nonatomic)BOOL autoContinueToAdd;
@property (strong, nonatomic) IBOutlet UILabel *messageLabel;

@property (nonatomic, strong)InventoryItem *selectedInventory;

@property (nonatomic, assign) id<ProductSelectionDelegate> delegateProduct;
//@property (nonatomic) BOOL needsUpdate;

@end
