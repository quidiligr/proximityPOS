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
@protocol CategoryIpadViewControllerDelegate;

@interface CategoryIpadViewController : UITableViewController<UITableViewDataSource,UITableViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIAlertViewDelegate>
//@property (nonatomic, strong) InventoryModel* inventoryModel;

//@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property(nonatomic,assign) id<CategoryIpadViewControllerDelegate> delegate;
@property (strong, nonatomic) IBOutlet UIView *addCategoryView;
@property (strong, nonatomic) IBOutlet UIButton *doneButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *productsButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *editCategoryButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *upButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *downButton;
@property (strong, nonatomic) IBOutlet UIToolbar *toolBar;

@property (strong,nonatomic)InventoryItem *selectedInventory;


@end

@protocol CategoryIpadViewControllerDelegate <NSObject>

-(void)categoryIpadViewControllerdidUpdate:(CategoryIpadViewController*)viewController;

@end
