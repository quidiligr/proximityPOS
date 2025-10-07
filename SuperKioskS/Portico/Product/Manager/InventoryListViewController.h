//
//  InventoryViewController.h
//
//
//  Created by Romulo Quidilig.
//  Copyright (c) 2015 Sharecle Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InventoryModel.h"
#import "InventoryItem.h"
#import "FilePickerController.h"
#import "AppDelegate.h"
#import "InventorySelectionDelegate.h"
//#import "ProductUpdateViewController.h"

@interface InventoryListViewController : UITableViewController<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,UIAlertViewDelegate,FilePickerControllerDelegate>

@property (nonatomic, strong) InventoryItem* selectedInventory;
@property (nonatomic, assign) id<InventorySelectionDelegate> delegateInventory;
@property (nonatomic, strong) AppDelegate *appDelegate;
//@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) IBOutlet UILabel *messageLabel;

@property (strong, nonatomic) IBOutlet UIView *messageView;

@end
