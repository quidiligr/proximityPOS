//
//  OrderIpadSplitViewController.m
//  superkiosk
//
//  Created by Katherine Sheehy on 12/12/15.
//  Copyright © 2015 Appcoda. All rights reserved.
//

#import "OrderIpadSplitViewController.h"
#import "OrderIpadViewController.h"
#import "ProductIpadViewController.h"

@interface OrderIpadSplitViewController ()

@end

@implementation OrderIpadSplitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    OrderIpadViewController *leftController=[self.storyboard instantiateViewControllerWithIdentifier:@"OrderIpadViewController"];
    UINavigationController *navLeft=[[UINavigationController alloc] initWithRootViewController:leftController];
    
    ProductIpadViewController *rightController=[self.storyboard instantiateViewControllerWithIdentifier:@"ProductIpadViewController"];
    UINavigationController *navRight=[[UINavigationController alloc] initWithRootViewController:rightController];
    
    NSMutableArray *viewControllers=[self.viewControllers mutableCopy];
    [viewControllers setObject:navLeft atIndexedSubscript:0];
    [viewControllers setObject:navRight atIndexedSubscript:1];
    self.viewControllers=viewControllers;
    
    
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

@end
