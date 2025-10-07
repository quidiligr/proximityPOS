//
//  InventoryViewController.h
//
//
//  Created by Romulo Quidilig.
//  Copyright (c) 2015 Sharecle Inc. All rights reserved.
//


#import <UIKit/UIKit.h>

#import "AppDelegate.h"
#import "GKImagePicker.h"

@class ProductCategory;
//@class InventoryItem;


//#import "CategorySelectionDelegate.h"
@protocol EditCategoryViewControllerDelegate;

@interface EditCategoryViewController : UITableViewController<UIImagePickerControllerDelegate,GKImagePickerDelegate,UINavigationControllerDelegate,UIPickerViewDelegate,UIPickerViewDataSource,UIActionSheetDelegate>


@property (strong, nonatomic) ProductCategory *selectedCategory;
//@property(strong,nonatomic) InventoryItem *selectedInventory;

@property(nonatomic,assign)id<EditCategoryViewControllerDelegate> delegate;


@end

@protocol EditCategoryViewControllerDelegate <NSObject>

-(void)editCategoryViewControllerDidUpdateCategory:(EditCategoryViewController *)viewController;

@end