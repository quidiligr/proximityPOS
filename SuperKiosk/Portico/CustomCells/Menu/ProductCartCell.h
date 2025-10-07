//
//  RWCheckoutCell.h
//
//
//  Created by Romulo Quidilig.
//  Copyright (c) 2015 Sharecle Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProductCartCell : UITableViewCell


@property (strong, nonatomic) IBOutlet UIButton *addToCartButton;
@property (strong, nonatomic) IBOutlet UITextField *quantityText;
//@property (strong, nonatomic) IBOutlet UITextView *notesText;
@property (strong, nonatomic) IBOutlet UILabel *priceLabel;
@property (strong, nonatomic) IBOutlet UILabel *soldoutLabel;


@end
