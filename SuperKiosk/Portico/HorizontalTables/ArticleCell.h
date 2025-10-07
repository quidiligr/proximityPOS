//
//  ArticleCell.h
//  HorizontalTables
//
//  Created by Romulo Quidilig on 8/20/11.
//  Copyright 2015 Romulo Quidilig. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ArticleTitleLabel;

@interface ArticleCell : UITableViewCell 
{
    UIImageView *_thumbnail;
    ArticleTitleLabel *_titleLabel;
}

@property (nonatomic, retain) UIImageView *thumbnail;
@property (nonatomic, retain) ArticleTitleLabel *titleLabel;

@end
