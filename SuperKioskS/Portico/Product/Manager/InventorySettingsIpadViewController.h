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

@interface InventorySettingsIpadViewController : UIViewController<UITextFieldDelegate>
//+(RWStripeViewController *)sharedInstance;
//-(void)performChargeSuccess;
//-(void)performChargeFailed;
@property(nonatomic,strong)InventoryItem *selectedInventory;
@end
