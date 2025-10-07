//
//  MapSearchViewController.h
//  superkiosk
//
//  Created by Katherine Sheehy on 9/9/16.
//  Copyright © 2016 Appcoda. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol MapSearchViewControllerDelegate;

@interface MapSearchViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property (nonatomic, assign) id<MapSearchViewControllerDelegate> delegate;
@property (strong, nonatomic) NSString *searchText;
@property (strong, nonatomic) IBOutlet UITextField *searchTextField;

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@end


@protocol MapSearchViewControllerDelegate <NSObject>

-(void)mapSearchDidSelectItem:(MapSearchViewController *)controller item:(NSDictionary *)item;
@end
