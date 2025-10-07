//
//  ArticleCell.m
//  HorizontalTables
//
//  Created by Romulo Quidilig on 8/20/11.
//  Copyright 2015 Romulo Quidilig. All rights reserved.
//

#import "ArticleCell.h"

@implementation ArticleCell

@synthesize thumbnail = _thumbnail;
@synthesize titleLabel = _titleLabel;

#pragma mark - View Lifecycle

- (NSString *)reuseIdentifier 
{
    return @"ArticleCell";
}

#pragma mark - Memory Management
/*
- (void)dealloc
{
    self.thumbnail = nil;
    self.titleLabel = nil;
    
    [super dealloc];
}
*/
@end
