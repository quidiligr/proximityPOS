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

@interface ProductIpadViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate,UITextFieldDelegate,ProductSelectionDelegate,UISplitViewControllerDelegate>

@property (strong, nonatomic) Product* product;
@property (nonatomic, strong) AppDelegate *appDelegate;
@property(nonatomic,weak)IBOutlet UINavigationItem *navBarItem;
@property(nonatomic,strong)UIPopoverController *popover;
@end
