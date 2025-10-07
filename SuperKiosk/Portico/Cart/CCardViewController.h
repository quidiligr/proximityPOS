//
//  RWPaymentViewController.h
//
//
//  Created by Romulo Quidilig.
//  Copyright (c) 2015 Sharecle Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CCardInfo.h"

@interface CCardViewController : UIViewController<UITextInputDelegate>
//+(RWStripeViewController *)sharedInstance;
//-(void)performChargeSuccess;
//-(void)performChargeFailed;
@property (strong, nonatomic) CCardInfo *selectedCard;//NSNumber* selectedIndex;
//@property NSInteger selectedAction;//NSNumber* selectedIndex;
@end
