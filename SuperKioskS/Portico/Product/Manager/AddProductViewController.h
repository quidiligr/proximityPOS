//
//  InventoryViewController.h
//
//
//  Created by Romulo Quidilig.
//  Copyright (c) 2015 Sharecle Inc. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "BCScannerViewController.h"
//#import "TextEditViewController.h"
@protocol AddProductViewControllerDelegate;

@class Product;
@class ProductCategory;
//@class InventoryItem;

@interface AddProductViewController : UITableViewController<UIImagePickerControllerDelegate,GKImagePickerDelegate, UINavigationControllerDelegate,UIPickerViewDelegate,UIPickerViewDataSource,UIActionSheetDelegate,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UITextViewDelegate,UIAlertViewDelegate,BCScannerViewControllerDelegate>

@property(nonatomic,strong) Product *selectedProduct;
@property(nonatomic,strong) ProductCategory *selectedCategory;
//@property(nonatomic,strong) InventoryItem *selectedInventory;
@property (nonatomic, strong) UIPopoverController *popOver;

@property(nonatomic,assign)id<AddProductViewControllerDelegate> delegate;


@end

@protocol AddProductViewControllerDelegate <NSObject>

-(void)addProductViewControllerDidAdd:(AddProductViewController *)viewController withProduct:(Product *)product;


@end
