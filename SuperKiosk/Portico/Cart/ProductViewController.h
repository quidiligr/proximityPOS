//
//  RWPuppyViewController.h
//  RWPuppies
//
//  Created by Pietro Rea on 12/25/12.
//  Copyright (c) 2012 Pietro Rea. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "Product.h"
#import "OrderItem.h"
#import "AppDelegate.h"
#import "OrderMenuViewController.h"
//#import "ProductSelectionDelegate.h"
#import "ProductOptionsViewController.h"
#import <iAd/iAd.h>
@interface ProductViewController : UITableViewController<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate,UITextFieldDelegate,ADBannerViewDelegate,ProductOptionDelegate
//,ProductSelectionDelegate
>

//@property (strong, nonatomic) Product* product;
@property (strong, nonatomic) Product* selectedProduct;
@property (nonatomic) NSUInteger selectedProductID;

@property (strong, nonatomic) InventoryItem* selectedInventory;
@property (strong, nonatomic) ProductCategory* selectedCategory;
//@property (strong, nonatomic) IBOutlet UIView *messageView;
@property (strong, nonatomic) IBOutlet UILabel *messageLabel;

@property (nonatomic, strong) AppDelegate *appDelegate;
@property(nonatomic,strong) OrderMenuViewController *refenceToParentViewController;
//@property(nonatomic,weak)IBOutlet UINavigationItem *navBarItem;
//@property(nonatomic,strong)UIPopoverController *popover;
@end
