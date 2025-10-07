//
//  ProductOptionsViewController.h
//  superkiosk
//
//  Created by Katherine Sheehy on 8/23/16.
//  Copyright © 2016 Appcoda. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Product;
@protocol ProductOptionDelegate <NSObject>

-(void) productOptionDone;

@end
@interface ProductOptionsViewController : UITableViewController

@property (nonatomic,strong)Product *selectedProduct;

@property(nonatomic,assign)id<ProductOptionDelegate> delegate;
@end
