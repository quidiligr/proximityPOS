//
//  EmptyViewController.m
//  superkiosks
//
//  Created by Katherine Sheehy on 12/10/15.
//  Copyright © 2015 Appcoda. All rights reserved.
//

#import "StartCategoryViewController.h"
#import "AddCategoryViewController.h"
#import "EditCategoryViewController.h"
//#import "StartProductViewController.h"
#import "EditProductViewController.h"
#import "AddProductViewController.h"

@interface StartCategoryViewController ()

@end

@implementation StartCategoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(showAddCategory:) name:NOTIFY_ADD_CATEGORY
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(showEditCategory:) name:NOTIFY_EDIT_CATEGORY
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showEditProduct:) name:NOTIFY_SHOW_EDIT_PRODUCT object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showAddProduct:) name:NOTIFY_SHOW_ADD_PRODUCT object:nil];
    
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    /*UISplitViewController *svc= (UISplitViewController *)[self.navigationController parentViewController];
    
    UINavigationController *nav=(UINavigationController *)[svc.viewControllers objectAtIndex:0];
    
    CategoryViewController *cat=(CategoryViewController *)nav.topViewController;
    if(cat.selectedInventory!=nil){
        
    }
     */
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)showAddCategory:(NSNotification *)notification{
    if(![self.navigationController.topViewController isKindOfClass:[StartCategoryViewController class]]){
        [self.navigationController popViewControllerAnimated:YES];
        
    }
    
    [self performSegueWithIdentifier:@"toAddCategoryViewController" sender:self];
}

-(void)showEditCategory:(NSNotification *)notification{
   
    if(![self.navigationController.topViewController isKindOfClass:[StartCategoryViewController class]]){
        [self.navigationController popViewControllerAnimated:YES];
        
    }
     _selectedCategory=[notification.userInfo valueForKey:KEY_SELECTED_CATEGORY];
    [self performSegueWithIdentifier:@"toEditCategoryViewController" sender:self];
}

-(void)showEditProduct:(NSNotification *)notification{
    _selectedCategory=[notification.userInfo valueForKey:KEY_SELECTED_CATEGORY];
    _selectedInventory=[notification.userInfo valueForKey:KEY_SELECTED_INVENTORY];
    _selectedProduct=[notification.userInfo valueForKey:KEY_SELECTED_PRODUCT];

    if(![self.navigationController.topViewController isKindOfClass:[StartCategoryViewController class]]){
        [self.navigationController popViewControllerAnimated:YES];
    
    }
   
    [self performSegueWithIdentifier:@"toEditProductViewController" sender:self];
    
}

-(void)showAddProduct:(NSNotification *)notification{
    
    _selectedCategory=[notification.userInfo valueForKey:KEY_SELECTED_CATEGORY];
    _selectedInventory=[notification.userInfo valueForKey:KEY_SELECTED_INVENTORY];
    _selectedProduct=[notification.userInfo valueForKey:KEY_SELECTED_PRODUCT];
    
    if(![self.navigationController.topViewController isKindOfClass:[StartCategoryViewController class]]){
        [self.navigationController popViewControllerAnimated:YES];
        
    }
    [self performSegueWithIdentifier:@"toAddProductViewController" sender:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    UISplitViewController *svc= (UISplitViewController *)[self.navigationController parentViewController];
    
    UINavigationController *nav=(UINavigationController *)[svc.viewControllers objectAtIndex:0];
    
    CategoryViewController *cat=(CategoryViewController *)nav.topViewController;

    if([segue.identifier isEqualToString:@"toAddCategoryViewController"]){
        AddCategoryViewController *vc=segue.destinationViewController;
        
        _selectedInventory=cat.selectedInventory;
        vc.selectedInventory=_selectedInventory;
        
    }
    else if([segue.identifier isEqualToString:@"toEditCategoryViewController"]){
        EditCategoryViewController *vc=segue.destinationViewController;
        
        _selectedInventory=cat.selectedInventory;
        _selectedCategory=cat.selectedCategory;
        
        vc.selectedInventory=_selectedInventory;
        vc.selectedCategory=_selectedCategory;
        
    }
    /*else if([segue.identifier isEqualToString:@"toStartProductViewController"]){
        StartProductViewController *vc=segue.destinationViewController;
        
        _selectedInventory=cat.selectedInventory;
        _selectedCategory=cat.selectedCategory;
        
        vc.selectedInventory=_selectedInventory;
        vc.selectedCategory=_selectedCategory;
        
    }
    */
    else if([segue.identifier isEqualToString:@"toEditProductViewController"]){
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


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
