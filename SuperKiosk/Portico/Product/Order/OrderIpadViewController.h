//
//  IODViewController.h
//  iOSDiner
//
//  Created by Romulo Quidilig on 3/19/15.
//  Copyright (c) 2015 Sharecle Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import <iAd/iAd.h>
#import "ProductSelectionDelegate.h"

@protocol OrderIpadViewControllerDelegate;
@class Order;
@class CheckoutCart;

@interface OrderIpadViewController : UITableViewController<UITableViewDelegate,UITableViewDataSource,ADBannerViewDelegate> {
    int currentItemIndex;
}

//@property (strong, nonatomic) NSDictionary* inventory;
@property (strong, nonatomic) Order* order;

@property (nonatomic, assign) id<OrderIpadViewControllerDelegate> delegate;
@property (nonatomic, assign) id<ProductSelectionDelegate> delegateProduct;

@property (strong, nonatomic) CheckoutCart* checkoutCart;

//@property (strong, nonatomic) IBOutlet UITableView *menuTableView;

//@property (strong, nonatomic) IBOutlet UITableView *orderTableView;

//@property (strong, nonatomic) NSIndexPath *selectedIndexPath;

//@property (nonatomic, strong) AppDelegate *appDelegate;

@property (strong, nonatomic) IBOutlet UIImageView *wallImage;


@property (strong, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;

@property (strong, nonatomic) IBOutlet UITextField *txtMessage;

//@property (strong, nonatomic) IBOutlet ADBannerView *banner1;

@property (nonatomic) BOOL continueShopping;


- (void)updateCurrentInventoryItem;
- (void)updateInventoryButtons;
- (void)updateOrderBoard;

@end

@protocol OrderIpadViewControllerDelegate <NSObject>

-(void)orderViewControllerDidFinish:(OrderIpadViewController *)orderViewController;

-(void)orderViewControllerWasCancelled:(OrderIpadViewController *)orderViewController;



@end


