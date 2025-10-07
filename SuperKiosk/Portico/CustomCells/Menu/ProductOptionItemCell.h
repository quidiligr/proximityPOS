//
//  ProductOptionItemCell.h
//  superkiosk
//
//  Created by Katherine Sheehy on 8/23/16.
//  Copyright © 2016 Appcoda. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProductOptionItemCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UISwitch *selectSwitch;
@property (strong, nonatomic) IBOutlet UILabel *selectLabel;
@property (strong, nonatomic) IBOutlet UILabel *priceLabel;
@end
