//
//  EmptyViewController.m
//  superkiosks
//
//  Created by Katherine Sheehy on 12/10/15.
//  Copyright © 2015 Appcoda. All rights reserved.
//

#import "StartProductViewController.h"
#import "EditProductViewController.h"
#import "AddProductViewController.h"

@interface StartProductViewController (){

InventoryItem *_selectedInventory;
ProductCategory *_selectedCategory;
Product *_selectedProduct;
}

@end

@implementation StartProductViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showEditProduct:) name:NOTIFY_SHOW_EDIT_PRODUCT object:nil];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showAddProduct:) name:NOTIFY_SHOW_ADD_PRODUCT object:nil];
    
}

-(void)showEditProduct:(NSNotification *)notification{
    _selectedCategory=[notification.userInfo valueForKey:KEY_SELECTED_CATEGORY];
    _selectedInventory=[notification.userInfo valueForKey:KEY_SELECTED_INVENTORY];
    _selectedProduct=[notification.userInfo valueForKey:KEY_SELECTED_PRODUCT];
    [self performSegueWithIdentifier:@"toEditProductViewController" sender:self];
}

-(void)showAddProduct:(NSNotification *)notification{
    _selectedCategory=[notification.userInfo valueForKey:KEY_SELECTED_CATEGORY];
    _selectedInventory=[notification.userInfo valueForKey:KEY_SELECTED_INVENTORY];
    _selectedProduct=[notification.userInfo valueForKey:KEY_SELECTED_PRODUCT];
    
    [self performSegueWithIdentifier:@"toAddProductViewController" sender:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
*/
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"toEditProductViewController"]){
        /*UISplitViewController *svc= (UISplitViewController *)[self.navigationController parentViewController];
        
        UINavigationController *nav=(UINavigationController *)[svc.viewControllers objectAtIndex:0];
        
        CategoryViewController *cat=(CategoryViewController *)nav.topViewController;
        */
        EditProductViewController *vc=segue.destinationViewController;
        
        vc.selectedProduct=_selectedProduct;
        vc.selectedInventory=_selectedInventory;
        vc.selectedCategory=_selectedCategory;
    }
    else if([segue.identifier isEqualToString:@"toAddProductViewController"]){
        AddProductViewController *vc=segue.destinationViewController;
        
       
        vc.selectedInventory=_selectedInventory;
        vc.selectedCategory=_selectedCategory;
        vc.selectedProduct=_selectedProduct;
    }
}




@end
