//
//  SearchMapCell.h
//  superkiosk
//
//  Created by Katherine Sheehy on 9/9/16.
//  Copyright © 2016 Appcoda. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MapSearchCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *resultTitleLabel;
@property (strong, nonatomic) IBOutlet UIImageView *resultImage;
//@property (strong, nonatomic) IBOutlet UILabel *priceLabel;
//@property (strong, nonatomic) IBOutlet UILabel *quantityLabel;
@property (strong, nonatomic) IBOutlet UILabel *resultDetailLabel;
//@property (strong, nonatomic) IBOutlet UILabel *loadingLabel;
//@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *loadingIndicator;
@end
