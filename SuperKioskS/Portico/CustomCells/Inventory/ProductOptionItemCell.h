//
//  ProductOptionItemCell.h
//  superkiosks
//
//  Created by Katherine Sheehy on 8/24/16.
//  Copyright © 2016 Sharecle. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProductOptionItemCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *shortDescLabel;
@property (strong, nonatomic) IBOutlet UILabel *priceLabel;

@end
