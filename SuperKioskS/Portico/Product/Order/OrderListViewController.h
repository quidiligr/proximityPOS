//
//  IODViewController.h
//  iOSDiner
//
//  Created by Romulo Quidilig on 3/19/15.
//  Copyright (c) 2015 Sharecle Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "BCScannerViewController.h"
#import "SearchMenuViewController.h"
#import "SelectOneViewController.h"

@protocol OrderListViewControllerDelegate;
@class Order;
@class CheckoutCart;

@interface OrderListViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate,BCScannerViewControllerDelegate,SearchMenuViewControllerDelegate,SelectOneViewControllerDelegate> {
    int currentItemIndex;
}

//@property (strong, nonatomic) NSDictionary* inventory;
@property (strong, nonatomic) Order* order;
@property (nonatomic, assign) id<OrderListViewControllerDelegate> delegate;
@property (strong, nonatomic) CheckoutCart* checkoutCart;
@property (strong, nonatomic) IBOutlet UITextField *searchTextField;
@property (strong, nonatomic) IBOutlet UIButton *searchButton;
@property (strong, nonatomic) IBOutlet UIButton *barcodeButton;

//@property (strong, nonatomic) UIPopoverController *popOver;

//@property (strong, nonatomic) UIPopoverController *searchPopover;
/*@property (weak, nonatomic) IBOutlet UIButton *ibRemoveItemButton;
@property (weak, nonatomic) IBOutlet UIButton *ibAddItemButton;
@property (weak, nonatomic) IBOutlet UIButton *ibPreviousItemButton;
@property (weak, nonatomic) IBOutlet UIButton *ibNextItemButton;
@property (weak, nonatomic) IBOutlet UIButton *ibTotalOrderButton;
@property (weak, nonatomic) IBOutlet UIButton *ibSubmitButton;

@property (weak, nonatomic) IBOutlet UILabel *ibChalkboardLabel;
@property (weak, nonatomic) IBOutlet UIImageView *ibCurrentItemImageView;
@property (weak, nonatomic) IBOutlet UILabel *ibCurrentItemLabel;
*/
@property (strong, nonatomic) IBOutlet UITableView *menuTableView;

@property (strong, nonatomic) IBOutlet UIImageView *wallImage;

//@property (strong, nonatomic) IBOutlet UITableView *orderTableView;

//@property (strong, nonatomic) NSIndexPath *selectedIndexPath;

@property (nonatomic, strong) AppDelegate *appDelegate;
@property (nonatomic, strong) UIPopoverController *popOver;

/*
- (IBAction)ibaRemoveItem:(id)sender;
- (IBAction)ibaAddItem:(id)sender;
- (IBAction)ibaLoadPreviousItem:(id)sender;
- (IBAction)ibaLoadNextItem:(id)sender;
- (IBAction)ibaCalculateTotal:(id)sender;
*/
- (void)updateCurrentInventoryItem;
- (void)updateInventoryButtons;
- (void)updateOrderBoard;

@end

@protocol OrderListViewControllerDelegate <NSObject>

-(void)orderListViewControllerDidFinish:(OrderListViewController *)orderViewController;

-(void)orderListViewControllerWasCancelled:(OrderListViewController *)orderViewController;

@end

