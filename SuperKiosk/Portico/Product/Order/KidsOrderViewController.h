//
//  IODViewController.h
//  iOSDiner
//
//  Created by Romulo Quidilig on 3/19/15.
//  Copyright (c) 2015 Sharecle Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@protocol KidsOrderViewControllerDelegate;
@class Order;

@interface KidsOrderViewController : UIViewController {
    int currentItemIndex;
}

@property (strong, nonatomic) NSMutableArray* inventory;
@property (strong, nonatomic) Order* order;
@property (nonatomic, assign) id<KidsOrderViewControllerDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIButton *ibRemoveItemButton;
@property (weak, nonatomic) IBOutlet UIButton *ibAddItemButton;
@property (weak, nonatomic) IBOutlet UIButton *ibPreviousItemButton;
@property (weak, nonatomic) IBOutlet UIButton *ibNextItemButton;
@property (weak, nonatomic) IBOutlet UIButton *ibTotalOrderButton;
@property (weak, nonatomic) IBOutlet UIButton *ibSubmitButton;

@property (weak, nonatomic) IBOutlet UILabel *ibChalkboardLabel;
@property (weak, nonatomic) IBOutlet UIImageView *ibCurrentItemImageView;
@property (weak, nonatomic) IBOutlet UILabel *ibCurrentItemLabel;

@property (nonatomic, strong) AppDelegate *appDelegate;

- (IBAction)ibaRemoveItem:(id)sender;
- (IBAction)ibaAddItem:(id)sender;
- (IBAction)ibaLoadPreviousItem:(id)sender;
- (IBAction)ibaLoadNextItem:(id)sender;
- (IBAction)ibaCalculateTotal:(id)sender;

- (void)updateCurrentInventoryItem;
- (void)updateInventoryButtons;
- (void)updateOrderBoard;

@end

@protocol KidsOrderViewControllerDelegate <NSObject>

-(void)orderViewControllerDidFinish:(KidsOrderViewController *)orderViewController;

-(void)orderViewControllerWasCancelled:(KidsOrderViewController *)orderViewController;

@end

