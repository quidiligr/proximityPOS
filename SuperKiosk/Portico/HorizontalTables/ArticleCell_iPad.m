//
//  ArticleCell_iPad.m
//  HorizontalTables
//
//  Created by Romulo Quidilig on 8/21/11.
//  Copyright 2015 Romulo Quidilig. All rights reserved.
//

#import "ArticleCell_iPad.h"
#import "ArticleTitleLabel.h"
#import "ControlVariables.h"

@implementation ArticleCell_iPad

- (id)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    //[super initWithFrame:frame];
    
    self.thumbnail = [[UIImageView alloc] initWithFrame:CGRectMake(kArticleCellHorizontalInnerPadding_iPad, kArticleCellVerticalInnerPadding_iPad, kCellWidth_iPad - kArticleCellHorizontalInnerPadding_iPad * 2, kCellHeight_iPad - kArticleCellVerticalInnerPadding_iPad * 2)] ;
    self.thumbnail.opaque = YES;
    
    [self.contentView addSubview:self.thumbnail];
    
    self.titleLabel = [[ArticleTitleLabel alloc] initWithFrame:CGRectMake(0, self.thumbnail.frame.size.height * 0.632, self.thumbnail.frame.size.width, self.thumbnail.frame.size.height * 0.37)] ;
    self.titleLabel.opaque = YES;
    [self.titleLabel setPersistentBackgroundColor:[UIColor colorWithRed:0 green:0.4745098 blue:0.29019808 alpha:0.9]];
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    self.titleLabel.numberOfLines = 3;
    [self.thumbnail addSubview:self.titleLabel];
    
    self.backgroundColor = [UIColor colorWithRed:0 green:0.40784314 blue:0.21568627 alpha:1.0];
    self.selectedBackgroundView = [[UIView alloc] initWithFrame:self.thumbnail.frame] ;
    self.selectedBackgroundView.backgroundColor = kHorizontalTableSelectedBackgroundColor;
    
    self.transform = CGAffineTransformMakeRotation(M_PI * 0.5);
    
    return self;
}

@end