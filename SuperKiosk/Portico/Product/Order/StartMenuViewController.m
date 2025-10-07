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
#import "defs.h"

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
    //if(isIpad){
    svc= (UISplitViewController *)[self.navigationController parentViewController];
    svc.delegate=self;
    //}
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showProduct:) name:NOTIFY_SHOW_PRODUCT object:nil];
    
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    /*if(_popover!=nil){
        [_popover dismissPopoverAnimated:YES];
    }
*/
    //if(isIpad){
    if(svc.delegate==nil || svc.delegate!=self){
        svc.delegate=self;
    }
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
/*
-(void)splitViewController:(UISplitViewController *)svc willHideViewController:(UIViewController *)aViewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)pc{
    self.popover=pc;
    [self.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
    
}
-(void)splitViewController:(UISplitViewController *)svc willShowViewController:(UIViewController *)aViewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem{
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
}
 */

@end
