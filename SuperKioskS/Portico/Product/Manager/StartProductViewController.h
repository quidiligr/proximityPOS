//
//  EmptyViewController.h
//  superkiosks
//
//  Created by Katherine Sheehy on 12/10/15.
//  Copyright © 2015 Appcoda. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface StartProductViewController : UIViewController

@property(nonatomic,strong) InventoryItem *selectedInventory;
@property(nonatomic,strong)ProductCategory *selectedCategory;
@property(nonatomic,strong)Product *selectedProduct;


@end
