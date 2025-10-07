//
//  AddProductOptionItemViewController.h
//  superkiosks
//
//  Created by Katherine Sheehy on 8/22/16.
//  Copyright © 2016 Sharecle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Product.h"
#import "ProductOption.h"
#import "ProductOptionItem.h"

@protocol ProductOptionItemDelegate;

@interface EditProductOptionItemViewController : UITableViewController
@property(nonatomic,strong)Product *selectedProduct;
//@property(nonatomic,strong)ProductOption *selectedOption;

@property (strong, nonatomic) IBOutlet UITextField *nameTextField;
@property (strong, nonatomic) IBOutlet UITextField *addedCostTextField;
@property (strong, nonatomic) IBOutlet UITextField *sortNumTextField;
@property (nonatomic, assign) id<ProductOptionItemDelegate> delegate;
@end

@protocol ProductOptionItemDelegate <NSObject>

//-(void)productOptionItemUpdated:(EditProductOptionItemViewController *)controller;
-(void)productOptionItemUpdated;

@end


