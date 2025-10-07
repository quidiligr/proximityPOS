//
//  MenuSectionCell.h
//  superkiosks
//
//  Created by Katherine Sheehy on 10/10/15.
//  Copyright (c) 2015 Sharecle. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MenuSectionCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *sectionImageView;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;

@property (strong, nonatomic) IBOutlet UIButton *expandButton;

@property (strong, nonatomic) IBOutlet UILabel *descriptonLabel;
@property (strong, nonatomic) IBOutlet UIImageView *expandImage;
@end
