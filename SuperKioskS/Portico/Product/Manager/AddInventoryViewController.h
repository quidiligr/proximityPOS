//
//  RWPaymentViewController.h
//
//
//  Created by Romulo Quidilig.
//  Copyright (c) 2015 Sharecle Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "OrderHistory.h"
#import "InventoryItem.h"
#import "InventorySelectionDelegate.h"

@interface AddInventoryViewController : UIViewController<UITextFieldDelegate,InventorySelectionDelegate,UISplitViewControllerDelegate>
//+(RWStripeViewController *)sharedInstance;
//-(void)performChargeSuccess;
//-(void)performChargeFailed;
@property(nonatomic,strong)InventoryItem *selectedInventory;
@property(nonatomic,weak)IBOutlet UINavigationItem *navBarItem;
@property(nonatomic,strong)UIPopoverController *popover;
@end
