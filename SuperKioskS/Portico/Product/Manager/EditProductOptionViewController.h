//
//  AddProductOptionItemViewController.h
//  superkiosks
//
//  Created by Katherine Sheehy on 8/22/16.
//  Copyright © 2016 Sharecle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Product.h"
#import "ProductOption.h"
#import "ProductOptionItem.h"
#import "EditProductOptionItemViewController.h"
//@protocol AddProductOptionItemViewControllerDelegate;

@interface EditProductOptionViewController : UITableViewController<UITableViewDelegate,UITableViewDataSource, ProductOptionItemDelegate>
@property(nonatomic,strong)Product *selectedProduct;
//@property(nonatomic)BOOL isAdd;
//@property(nonatomic,strong)ProductOption *po;
@property (nonatomic,strong)UIPopoverController *popOver;
@property (strong, nonatomic) IBOutlet UITextField *nameTextField;
@property (strong, nonatomic) IBOutlet UITextField *maxSelectedTextField;
@property (strong, nonatomic) IBOutlet UITextField *sortNumTextField;
@property (strong, nonatomic) IBOutlet UITextField *minSelectedTextField;


//@property (nonatomic, assign) id<AddProductOptionItemViewControllerDelegate> delegate;
@end
/*
@protocol AddProductOptionItemViewControllerDelegate <NSObject>

-(void)addProductOptionItemViewControllerAdded:(AddProductOptionItemViewController *)controller;

@end
 */

