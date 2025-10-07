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
#import "ProductSelectionDelegate.h"
#import <iAd/iAd.h>
@interface ProductIpadViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate,UITextFieldDelegate,ADBannerViewDelegate
//,ProductSelectionDelegate
,UISplitViewControllerDelegate>

//@property (strong, nonatomic) Product* product;
@property (strong, nonatomic) Product* selectedProduct;
@property (strong, nonatomic) InventoryItem* selectedInventory;
@property (strong, nonatomic) ProductCategory* selectedCategory;
@property (strong, nonatomic) IBOutlet UIView *messageView;
@property (strong, nonatomic) IBOutlet UILabel *messageLabel;

@property (nonatomic, strong) AppDelegate *appDelegate;

@property(nonatomic,weak)IBOutlet UINavigationItem *navBarItem;
@property(nonatomic,strong)UIPopoverController *popover;
@end
