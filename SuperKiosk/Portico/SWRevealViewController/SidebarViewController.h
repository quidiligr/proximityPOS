//
//  SidebarViewController.h
//  SidebarDemo
//
//  Created by Simon on 29/6/13.
//  Copyright (c) 2013 Appcoda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

//
//  IODViewController.h
//  iOSDiner
//
//  Created by Romulo Quidilig on 3/19/15.
//  Copyright (c) 2015 Sharecle Inc. All rights reserved.
//



@protocol SidebarViewControllerDelegate;
@class Order;
@class CheckoutCart;
@class ProductViewController;

@interface SidebarViewController : UITableViewController<UITableViewDelegate,UITableViewDataSource> {
    int currentItemIndex;
}

//@property (strong, nonatomic) NSDictionary* inventory;
@property (strong, nonatomic) Order* order;
@property (nonatomic, assign) id<SidebarViewControllerDelegate> delegate;
@property (strong, nonatomic) CheckoutCart* checkoutCart;


@property (strong, nonatomic) NSIndexPath *selectedIndexPath;

@property (nonatomic, strong) AppDelegate *appDelegate;

@property(nonatomic,strong)ProductViewController *menuViewController;


//- (void)updateCurrentInventoryItem;
//- (void)updateInventoryButtons;
//- (void)updateOrderBoard;

@end

@protocol OrderViewControllerDelegate <NSObject>

-(void)orderViewControllerDidFinish:(SidebarViewController *)orderViewController;

-(void)orderViewControllerWasCancelled:(SidebarViewController *)orderViewController;

@end


