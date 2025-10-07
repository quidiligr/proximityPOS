//
//  MenuMainViewController.h
//  superkiosk
//
//  Created by Katherine Sheehy on 6/5/16.
//  Copyright © 2016 Sharecle. All rights reserved.
//

#import <UIKit/UIKit.h>

//@protocol OrderMenuViewControllerDelegate;
@class Product;
@class ProductCategory;

@interface OrderMenuViewController : UIViewController

@property (nonatomic,strong) Product *selectedProduct;
@property (nonatomic,strong) ProductCategory *selectedCategory;
@property (nonatomic,strong) NSString *nextViewName;

//+(void)setNextViewName:(NSString *)name;
//+ (NSString *)getNextViewName;
@end

//@protocol OrderMenuViewControllerDelegate <NSObject>

//-(void)setNextView:(NSString *)name;



