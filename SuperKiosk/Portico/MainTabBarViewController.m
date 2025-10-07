//
//  MainTabBarViewController.m
//  superkiosk
//
//  Created by Katherine Sheehy on 6/7/16.
//  Copyright © 2016 Sharecle. All rights reserved.
//

#import "MainTabBarViewController.h"

@interface MainTabBarViewController ()

@end

@implementation MainTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    if(self.selectedIndex==0){
        /*if(self.isIpad){
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_SHOW_MENU_COLLECTION object:nil];
        }
        else{
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_SHOW_MENU_TABLE object:nil];
        }
         */
    }
}
@end
