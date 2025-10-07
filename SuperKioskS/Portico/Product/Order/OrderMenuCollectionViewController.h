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
#import "OrderMenuViewController.h"

@protocol OrderViewControllerDelegate;
@class Order;
@class CheckoutCart;

@interface OrderMenuCollectionViewController : UICollectionViewController<UICollectionViewDelegate, UIAlertViewDelegate,BCScannerViewControllerDelegate,SearchMenuViewControllerDelegate,SelectOneViewControllerDelegate,UIActionSheetDelegate> {
    int currentItemIndex;
}


@property (strong, nonatomic) Order* order;
@property (nonatomic, assign) id<OrderViewControllerDelegate> delegate;
@property (strong, nonatomic) CheckoutCart* checkoutCart;
@property (strong, nonatomic) IBOutlet UITextField *searchTextField;
@property (strong, nonatomic) IBOutlet UIButton *searchButton;
@property (strong, nonatomic) IBOutlet UIButton *barcodeButton;

@property (strong, nonatomic) IBOutlet UIImageView *wallImage;

@property(nonatomic,strong) OrderMenuViewController *refenceToParentViewController;


@property (nonatomic, strong) AppDelegate *appDelegate;
@property (nonatomic, strong) UIPopoverController *popOver;


- (void)updateCurrentInventoryItem;
- (void)updateInventoryButtons;
- (void)updateOrderBoard;

@end

@protocol OrderViewControllerDelegate <NSObject>

-(void)orderViewControllerDidFinish:(OrderMenuCollectionViewController *)orderViewController;

-(void)orderViewControllerWasCancelled:(OrderMenuCollectionViewController *)orderViewController;

@end

