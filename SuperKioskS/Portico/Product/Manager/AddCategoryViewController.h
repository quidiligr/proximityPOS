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

@protocol AddCategoryViewControllerDelegate;


@interface AddCategoryViewController : UITableViewController<UIImagePickerControllerDelegate,GKImagePickerDelegate,UINavigationControllerDelegate,UIPickerViewDelegate,UIPickerViewDataSource,UIActionSheetDelegate,UITextFieldDelegate>



@property(nonatomic,assign)id<AddCategoryViewControllerDelegate> delegate;
//@property(strong,nonatomic)InventoryItem *selectedInventory;

@end

@protocol AddCategoryViewControllerDelegate <NSObject>

-(void)addCategoryViewControllerDidAddCategory:(AddCategoryViewController *)viewController withNewCategory:(ProductCategory *)newCategory;

@end
