//
//  OrderHistoryViewCell.h
//  superkiosks
//
//  Created by Katherine Sheehy on 10/22/15.
//  Copyright (c) 2015 Sharecle. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderHistoryViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *orderByImageView;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *numberLabel;
@property (strong, nonatomic) IBOutlet UILabel *itemsLabel;

@end
