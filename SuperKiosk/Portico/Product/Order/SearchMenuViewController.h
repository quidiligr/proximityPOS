//
//  IODViewController.h
//  iOSDiner
//
//  Created by Romulo Quidilig on 3/19/15.
//  Copyright (c) 2015 Sharecle Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
//#import "BCScannerViewController.h"

@protocol SearchMenuViewControllerDelegate;
//@class Order;
//@class CheckoutCart;

@interface SearchMenuViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate> //{
    //int currentItemIndex;
//}

//@property (strong, nonatomic) NSDictionary* inventory;
////@property (strong, nonatomic) Order* order;
@property (nonatomic, assign) id<SearchMenuViewControllerDelegate> delegate;
//@property (strong, nonatomic) CheckoutCart* checkoutCart;

@property (strong, nonatomic) IBOutlet UITextField *searchTextField;


@property (strong, nonatomic) IBOutlet UITableView *menuTableView;
@property (strong, nonatomic) NSString *searchText;



@property (strong, nonatomic) InventoryItem *selectedInventory;
//InventoryItem *_selectedInventory;
//@property (strong, nonatomic) IBOutlet UIImageView *wallImage;

//@property (strong, nonatomic) IBOutlet UITableView *orderTableView;

//@property (strong, nonatomic) NSIndexPath *selectedIndexPath;

@property (nonatomic, strong) AppDelegate *appDelegate;
//@property (nonatomic, strong) UIPopoverController *chatPopover;

/*
- (IBAction)ibaRemoveItem:(id)sender;
- (IBAction)ibaAddItem:(id)sender;
- (IBAction)ibaLoadPreviousItem:(id)sender;
- (IBAction)ibaLoadNextItem:(id)sender;
- (IBAction)ibaCalculateTotal:(id)sender;
*/
//- (void)updateCurrentInventoryItem;
//- (void)updateInventoryButtons;
//- (void)updateOrderBoard;

@end

@protocol SearchMenuViewControllerDelegate <NSObject>

-(void)searchMenuViewControllerItemSelected:(SearchMenuViewController *)controller item:(Product *)item;
/*
-(void)searchMenuViewControllerWasCancelled:(SearchMenuViewController *)controller;
*/
@end

