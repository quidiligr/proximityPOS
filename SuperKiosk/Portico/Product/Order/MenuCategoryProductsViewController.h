//
//  IODViewController.h
//  iOSDiner
//
//  Created by Romulo Quidilig on 3/19/15.
//  Copyright (c) 2015 Sharecle Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "SearchMenuViewController.h"
#import "BCScannerViewController.h"
#import "SelectOneViewController.h"
#import "MenuCategoryProductsViewController.h"
#import "ProductOptionsViewController.h"
#import <iAd/iAd.h>
//#import "ProductSelectionDelegate.h"

//@protocol OrderViewControllerDelegate;
@class Order;
@class CheckoutCart;

@interface MenuCategoryProductsViewController : UIViewController<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout, ADBannerViewDelegate,BCScannerViewControllerDelegate,SearchMenuViewControllerDelegate,SelectOneViewControllerDelegate,UIActionSheetDelegate,ProductOptionDelegate> {
    int currentItemIndex;
}

//@property (strong, nonatomic) NSDictionary* inventory;
@property (strong, nonatomic) Order* order;

//@property (nonatomic, assign) id<OrderIpadViewControllerDelegate> delegate;
//@property (nonatomic, assign) id<ProductSelectionDelegate> delegateProduct;

//@property (strong, nonatomic) CheckoutCart* checkoutCart;



@property (strong, nonatomic) IBOutlet UIImageView *wallImage;


@property (strong, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;

@property (strong, nonatomic) IBOutlet UITextField *txtMessage;



@property (nonatomic) BOOL continueShopping;

@property (nonatomic, strong) UIPopoverController *popOver;

@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;

@property (strong, nonatomic) IBOutlet UISegmentedControl *selectViewSegmented;

//@property(nonatomic,strong) OrderMenuViewController *refenceToParentViewController;
@property (strong,nonatomic) ProductCategory *selectedCategory;

@end
/*
 @protocol OrderIpadViewControllerDelegate <NSObject>
 
 -(void)orderViewControllerDidFinish:(OrderIpadViewController *)orderViewController;
 
 -(void)orderViewControllerWasCancelled:(OrderIpadViewController *)orderViewController;
 
 
 
 @end
 
 */
