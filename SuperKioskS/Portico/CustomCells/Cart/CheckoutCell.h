//
//  RWCheckoutCell.h
//
//
//  Created by Romulo Quidilig.
//  Copyright (c) 2015 Sharecle Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CheckoutCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *productNameLabel;
//@property (strong, nonatomic) IBOutlet UILabel *productDescLabel;
@property (strong, nonatomic) IBOutlet UILabel *priceLabel;
//@property (strong, nonatomic) IBOutlet UILabel *quantityLabel;
@property (strong, nonatomic) IBOutlet UILabel *notesLabel;
@property (strong, nonatomic) IBOutlet UILabel *discountLabel;

@end
