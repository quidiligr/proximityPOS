//
//  MenuSelectionDelegate.h
//  superkiosks
//
//  Created by Katherine Sheehy on 12/6/15.
//  Copyright © 2015 Appcoda. All rights reserved.
//

#import <Foundation/Foundation.h>
@class InventoryItem;
@protocol InventorySelectionDelegate <NSObject>
@required
-(void)selectedInventory:(InventoryItem *)inventory;

@end
