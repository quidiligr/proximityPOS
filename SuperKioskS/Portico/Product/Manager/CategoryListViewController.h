//
//  InventoryViewController.h
//  MCDemo
//
//  Created by Romulo Quidilig on 4/3/15.
//  Copyright (c) 2015 Sharecle Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InventoryModel.h"
#import "InventoryItem.h"
//#import "CategorySelectionDelegate.h"
#import "AddCategoryViewController.h"

#import "EditCategoryViewController.h"
@protocol CategoryListViewControllerDelegate;

@interface CategoryListViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIAlertViewDelegate,AddCategoryViewControllerDelegate,EditCategoryViewControllerDelegate>
//@property (nonatomic, strong) InventoryModel* inventoryModel;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property(nonatomic,assign) id<CategoryListViewControllerDelegate> delegate;
@property (strong, nonatomic) IBOutlet UIView *addCategoryView;
@property (strong, nonatomic) IBOutlet UIButton *doneButton;
/*@property (strong, nonatomic) IBOutlet UIBarButtonItem *productsButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *editCategoryButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *upButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *downButton;
@property (strong, nonatomic) IBOutlet UIToolbar *toolBarr;
*/
//@property (strong,nonatomic)InventoryItem *selectedInventory;
@property (strong,nonatomic)ProductCategory *selectedCategory;
//@property (nonatomic, assign) id<CategorySelectionDelegate> delegateCategory;

@end

@protocol CategoryListViewControllerDelegate <NSObject>

-(void)categoryListViewControllerdidUpdate:(CategoryListViewController*)viewController;

@end
