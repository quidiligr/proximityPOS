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
#import "InventoryItem.h"
#import "ProductSelectionDelegate.h"
//#import "TextEditViewController.h"
//@protocol AddProductViewControllerDelegate;


@interface AddProductIpadViewController : UITableViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIPickerViewDelegate,UIPickerViewDataSource,UIActionSheetDelegate,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UITextViewDelegate,ProductSelectionDelegate,UISplitViewControllerDelegate>


//@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic,strong) Product *selectedProduct;
@property(nonatomic,strong) ProductCategory *selectedCategory;
@property(nonatomic,strong) InventoryItem *selectedInventory;

@property(nonatomic,weak)IBOutlet UINavigationItem *navBarItem;
@property(nonatomic,strong)UIPopoverController *popover;


@end
/*
@protocol AddProductViewControllerDelegate <NSObject>

-(void)addProductViewControllerdidAdd:(AddProductViewController *)viewController;
//-(void)productManagerViewControllerdidUpdate:(ProductManagerViewController *)viewController;

@end
*/