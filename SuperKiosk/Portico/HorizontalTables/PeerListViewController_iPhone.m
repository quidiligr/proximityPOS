//
//  ArticleListViewController_iPhone.m
//  HorizontalTables
//
//  Created by Romulo Quidilig on 8/7/11.
//  Copyright 2015 Romulo Quidilig. All rights reserved.
//

#import "PeerListViewController_iPhone.h"
#import "ControlVariables.h"
#import "HorizontalTableCell_iPhone.h"
#import "defs.h"

#define kHeadlineSectionHeight  26
#define kRegularSectionHeight   18


@implementation PeerListViewController_iPhone

#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    /* moved to loadcontrollerfromsegue
     if (!self.reusableCells)
    {       
        NSSortDescriptor* sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:nil ascending:YES selector:@selector(localizedCompare:)];
        NSArray* sortedCategories = [self.articleDictionary.allKeys sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
        
        NSString *categoryName;
        NSArray *currentCategory;
        
        self.reusableCells = [NSMutableArray array];
        
        for (int i = 0; i < [self.articleDictionary.allKeys count]; i++)
        {                        
            HorizontalTableCell_iPhone *cell = [[HorizontalTableCell_iPhone alloc] initWithFrame:CGRectMake(0, 0, 320, 416)];
            
            categoryName = [sortedCategories objectAtIndex:i];
            currentCategory = [self.articleDictionary objectForKey:categoryName];
            cell.articles = [NSArray arrayWithArray:currentCategory];
            
            [self.reusableCells addObject:cell];
            //[cell release];
        }
    }
     */
    [self didUpdatePeersNotification];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didUpdatePeersNotification)
                                                 name:NOTIFY_UPDATE_PEERS
                                               object:nil];
    

}

//ROM: call this from segue


-(void)didUpdatePeersNotification{
    if (!self.reusableCells && self.articleDictionary)
    {
        NSSortDescriptor* sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:nil ascending:YES selector:@selector(localizedCompare:)];
        NSArray* sortedCategories = [self.articleDictionary.allKeys sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
        
        NSString *categoryName;
        NSArray *currentCategory;
        
        self.reusableCells = [NSMutableArray array];
        
        for (int i = 0; i < [self.articleDictionary.allKeys count]; i++)
        {
            HorizontalTableCell_iPhone *cell = [[HorizontalTableCell_iPhone alloc] initWithFrame:CGRectMake(0, 0, 320, 416)];
            
            categoryName = [sortedCategories objectAtIndex:i];
            currentCategory = [self.articleDictionary objectForKey:categoryName];
            cell.articles = [NSArray arrayWithArray:currentCategory];
            
            [self.reusableCells addObject:cell];
            //[cell release];
        }
    }
    
}

#pragma mark - Table View Data Source

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return section == 0 ? kHeadlineSectionHeight : kRegularSectionHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *customSectionHeaderView;
    UILabel *titleLabel;
    UIFont *labelFont;
    
    if (section == 0)
    {
        customSectionHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, kHeadlineSectionHeight)] ;
        
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, tableView.frame.size.width, kHeadlineSectionHeight)];
        labelFont = [UIFont boldSystemFontOfSize:20];
    }
    else
    {
        customSectionHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, kRegularSectionHeight)] ;
        
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, tableView.frame.size.width, kRegularSectionHeight)];
        
        labelFont = [UIFont boldSystemFontOfSize:13];
    }  
    
    customSectionHeaderView.backgroundColor = [UIColor colorWithRed:0 green:0.40784314 blue:0.21568627 alpha:0.95];
    
    titleLabel.textAlignment =NSTextAlignmentLeft; //UITextAlignmentLeft;
    [titleLabel setTextColor:[UIColor whiteColor]];
    [titleLabel setBackgroundColor:[UIColor clearColor]];   
    titleLabel.font = labelFont;
    
    NSSortDescriptor* sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:nil ascending:YES selector:@selector(localizedCompare:)];
    NSArray* sortedCategories = [self.articleDictionary.allKeys sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    
    NSString *categoryName = [sortedCategories objectAtIndex:section];
    
    //titleLabel.text = [categoryName substringFromIndex:1];
    titleLabel.text = categoryName;
    
    [customSectionHeaderView addSubview:titleLabel];
    //[titleLabel release];
    
    return customSectionHeaderView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{        
    HorizontalTableCell *cell = [self.reusableCells objectAtIndex:indexPath.section];
    
    return cell;
}

#pragma mark - Memory Management

- (void)awakeFromNib
{
    [self.tableView setBackgroundColor:kVerticalTableBackgroundColor];
    self.tableView.rowHeight = kCellHeight + (kRowVerticalPadding * 0.5) + ((kRowVerticalPadding * 0.5) * 0.5);
}

@end
