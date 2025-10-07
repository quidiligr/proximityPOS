//
//  RecipeViewCell.h
//  CollectionViewDemo
//
//  Created by Simon on 9/1/13.
//  Copyright (c) 2013 Sharecle. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "iCarousel.h"

@interface MenuCategoryCollectionCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *categoryImage;
@property (strong,nonatomic) NSMutableArray *titles;
@property (strong,nonatomic) NSMutableArray *images;
@property (nonatomic) BOOL NOWRAP;
//@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
//@property (weak, nonatomic) IBOutlet UILabel *quantityLabel;
//@property (weak, nonatomic) IBOutlet UILabel *actualPriceLabel;
//@property (strong, nonatomic) IBOutlet UILabel *fullDescLabel;
//@property (strong, nonatomic) IBOutlet UILabel *shortDescLabel;
//@property (strong, nonatomic) IBOutlet UILabel *loadingLabel;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *loadingIndicator;

@end
