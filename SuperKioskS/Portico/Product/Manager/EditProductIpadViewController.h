//
//  InventoryViewController.h
//
//
//  Created by Romulo Quidilig.
//  Copyright (c) 2015 Sharecle Inc. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "InventoryModel.h"
#import "InventoryItem.h"
//#import "TextEditViewController.h"
#import "AppDelegate.h"
#import "ProductSelectionDelegate.h"


//@protocol EditProductViewControllerDelegate;


@interface EditProductIpadViewController : UITableViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIPickerViewDelegate,UIPickerViewDataSource,UIActionSheetDelegate,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UITextViewDelegate,ProductSelectionDelegate,UISplitViewControllerDelegate>


//@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic,strong) Product *selectedProduct;
@property(nonatomic,strong) ProductCategory *selectedCategory;
@property(nonatomic,strong) InventoryItem *selectedInventory;

@property(nonatomic,weak)IBOutlet UINavigationItem *navBarItem;
@property(nonatomic,strong)UIPopoverController *popover;
//@property (strong, nonatomic) IBOutlet UITableViewCell *ecommerceCell;

//@property(nonatomic,assign) BOOL isUpdateProduct;

//@property(nonatomic,assign)id<EditProductViewControllerDelegate> delegate;
//@property (strong, nonatomic) IBOutlet UITextField *seqNumTextField;


@end
/*
@protocol EditProductViewControllerDelegate <NSObject>

//-(void)editProductViewControllerdidAdd:(EditProductViewController *)viewController;
-(void)editProductViewControllerdidUpdate:(EditProductViewController *)viewController;

@end
*/