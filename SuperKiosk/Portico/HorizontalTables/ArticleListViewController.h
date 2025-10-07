//
//  ArticleListViewController.h
//  HorizontalTables
//
//  Created by Romulo Quidilig on 7/2/2015.
//  Copyright 2015 Romulo Quidilig. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ArticleListViewController : UITableViewController
/*{
    NSDictionary *_articleDictionary;
    NSMutableArray *_reusableCells;
}
*/
//@property (nonatomic, strong) NSDictionary *articleDictionarySource;
@property (nonatomic, strong) NSDictionary *articleDictionary;
@property (nonatomic, strong) NSMutableArray *reusableCells;

//-(void)loadControllerFromSegue;


@end
