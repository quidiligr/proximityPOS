//
//  ProductOptionsTableViewController.h
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

@interface ProductOptionsViewController : UITableViewController<UIActionSheetDelegate,UIAlertViewDelegate>//,AddProductOptionItemViewControllerDelegate>

@property(nonatomic,strong)Product* selectedProduct;
@property (nonatomic, strong) UIPopoverController *popOver;

@end
