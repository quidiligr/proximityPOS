//
//  HorizontalTableCell.h
//  HorizontalTables
//
//  Created by Romulo Quidilig on 8/19/11.
//  Copyright 2015 Romulo Quidilig. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HorizontalTableCell : UITableViewCell <UITableViewDelegate, UITableViewDataSource>
{
    UITableView *_horizontalTableView;
    NSArray *_articles;
}

@property (nonatomic, retain) UITableView *horizontalTableView;
@property (nonatomic, retain) NSArray *articles;

@end
