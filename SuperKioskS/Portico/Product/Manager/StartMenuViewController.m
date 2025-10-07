//
//  EmptyViewController.m
//  superkiosks
//
//  Created by Katherine Sheehy on 12/10/15.
//  Copyright © 2015 Appcoda. All rights reserved.
//

#import "StartMenuViewController.h"

//#import "AddCategoryViewController.h"
//#import "EditCategoryViewController.h"

#import "ProductViewController.h"

#import "Product.h"
#import "ProductCategory.h"
#import "InventoryItem.h"

//#import "AddProductViewController.h"

@interface StartMenuViewController (){
UISplitViewController *svc;
    //bool isIpad;
    
}
@end

@implementation StartMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /*if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        isIpad=YES;
    }
    else{
        isIpad=NO;
    }
    */
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showProduct:) name:NOTIFY_SHOW_PRODUCT object:nil];
    //if(isIpad){
    svc= (UISplitViewController *)[self.navigationController parentViewController];
    //}
    //svc.delegate=self;
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    //if(isIpad){
    svc.delegate=self;
    //}
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)showProduct:(NSNotification *)notification{
    if(![self.navigationController.topViewController isKindOfClass:[StartMenuViewController class]]){
        [self.navigationController popViewControllerAnimated:YES];
        
    }

    
    if(![notification.userInfo objectForKey:KEY_SELECTED_PRODUCT]){
        return;
    }
    
    
    _selectedCategory=[notification.userInfo valueForKey:KEY_SELECTED_CATEGORY];
    _selectedInventory=[notification.userInfo valueForKey:KEY_SELECTED_INVENTORY];
    _selectedProduct=[notification.userInfo valueForKey:KEY_SELECTED_PRODUCT];
    
    
    [self performSegueWithIdentifier:@"toProductViewController" sender:self];
    
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
   
    if([segue.identifier isEqualToString:@"toProductViewController"]){
        /*UISplitViewController *svc= (UISplitViewController *)[self.navigationController parentViewController];
        
         UINavigationController *nav=(UINavigationController *)[svc.viewControllers objectAtIndex:0];
         
         CategoryViewController *cat=(CategoryViewController *)nav.topViewController;
         */
        ProductViewController *vc=segue.destinationViewController;
        
        vc.selectedProduct=_selectedProduct;
        vc.selectedInventory=_selectedInventory;
        vc.selectedCategory=_selectedCategory;
        //if(isIpad){
        svc.delegate=vc;
        //}
        
    }
    
}
/*
-(void)selectedInventory:(InventoryItem *)inventory{
    _selectedInventory=inventory;
    if(self.settingsViewContorller==nil){
        [self performSegueWithIdentifier:@"toInventorySettingViewController" sender:self];
    }
    else{
        [self.settingsViewContorller setSelectedInventory:inventory];
    }
}
*/
-(BOOL)splitViewController:(UISplitViewController *)svc shouldHideViewController:(UIViewController *)vc inOrientation:(UIInterfaceOrientation)orientation{
    return NO;
}
@end
