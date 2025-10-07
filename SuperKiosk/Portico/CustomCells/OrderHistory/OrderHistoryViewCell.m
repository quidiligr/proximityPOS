//
//  OrderHistoryViewCell.m
//  superkiosks
//
//  Created by Katherine Sheehy on 10/22/15.
//  Copyright (c) 2015 Sharecle. All rights reserved.
//

#import "OrderHistoryViewCell.h"

@implementation OrderHistoryViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)layoutSubviews {
    [super layoutSubviews];
    self.imageView.frame = CGRectMake(8,8,48,48);
    
    self.imageView.layer.cornerRadius=self.imageView.frame.size.width / 2;
    self.imageView.clipsToBounds = YES;
}

@end
