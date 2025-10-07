//
//  RWCheckoutCell.h
//
//
//  Created by Romulo Quidilig.
//  Copyright (c) 2015 Sharecle Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChatImageOnlyCustCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *senderLabel;
@property (strong, nonatomic) IBOutlet UIImageView *senderPhoto;
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;
@property (strong, nonatomic) IBOutlet UIImageView *attachImage;
@property (strong, nonatomic) IBOutlet UILabel *messageLabel;

-(void)setMessage:(NSString *)message;
@end
