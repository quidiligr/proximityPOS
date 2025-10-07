//
//  EmptyViewController.m
//  superkiosks
//
//  Created by Katherine Sheehy on 12/10/15.
//  Copyright © 2015 Appcoda. All rights reserved.
//

#import "StartInventoryViewController.h"

#import "AddCategoryViewController.h"
#import "EditCategoryViewController.h"

#import "EditProductViewController.h"
#import "AddProductViewController.h"

@interface StartInventoryViewController (){
UISplitViewController *svc;
//bool isIpad;
}
@end

@implementation StartInventoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    /*if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        isIpad=YES;
    }
    else{
        isIpad=NO;
    }
     */
    self.view.backgroundColor=[UIColor clearColor];

    
     /*
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(showAddCategory:) name:NOTIFY_ADD_CATEGORY
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(showEditCategory:) name:NOTIFY_EDIT_CATEGORY
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showEditProduct:) name:NOTIFY_SHOW_EDIT_PRODUCT object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showAddProduct:) name:NOTIFY_SHOW_ADD_PRODUCT object:nil];
    */
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showInventorySettings:) name:NOTIFY_SHOW_INVENTORY_SETTINGS object:nil];
    
    //if(isIpad){
        svc= (UISplitViewController *)[self.navigationController parentViewController];
    //}
}

-(void)viewDidAppear:(BOOL)animated{
    //if(isIpad){
        svc.delegate=self;
   // }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)showInventorySettings:(NSNotification *)notification{
    if(![self.navigationController.topViewController isKindOfClass:[StartInventoryViewController class]]){
        [self.navigationController popViewControllerAnimated:YES];
        
    }
    
    if([notification.userInfo objectForKey:KEY_SELECTED_INVENTORY]){
        _selectedInventory=[notification.userInfo valueForKey:KEY_SELECTED_INVENTORY];
        [self performSegueWithIdentifier:@"toInventorySettingsViewController" sender:self];
    }
    else{
        _selectedInventory=nil;
    }
    
   
}
/*
-(void)showAddCategory:(NSNotification *)notification{
    if(![self.navigationController.topViewController isKindOfClass:[StartInventoryViewController class]]){
        [self.navigationController popViewControllerAnimated:YES];
        
    }
    [self performSegueWithIdentifier:@"toAddCategoryViewController" sender:self];
}
 */
/*
-(void)showEditCategory:(NSNotification *)notification{
    if(![self.navigationController.topViewController isKindOfClass:[StartInventoryViewController class]]){
        [self.navigationController popViewControllerAnimated:YES];
        
    }
     _selectedCategory=[notification.userInfo valueForKey:KEY_SELECTED_CATEGORY];
    [self performSegueWithIdentifier:@"toEditCategoryViewController" sender:self];
}
*/
/*
-(void)showEditProduct:(NSNotification *)notification{
    if(![self.navigationController.topViewController isKindOfClass:[StartInventoryViewController class]]){
        [self.navigationController popViewControllerAnimated:YES];
        
    }

    
    if(![notification.userInfo objectForKey:KEY_SELECTED_PRODUCT]){
        return;
    }
    
    
    _selectedCategory=[notification.userInfo valueForKey:KEY_SELECTED_CATEGORY];
    _selectedInventory=[notification.userInfo valueForKey:KEY_SELECTED_INVENTORY];
    _selectedProduct=[notification.userInfo valueForKey:KEY_SELECTED_PRODUCT];
    
    
    [self performSegueWithIdentifier:@"toEditProductViewController" sender:self];
    
}
*/
/*
-(void)showAddProduct:(NSNotification *)notification{
    
    _selectedCategory=[notification.userInfo valueForKey:KEY_SELECTED_CATEGORY];
    _selectedInventory=[notification.userInfo valueForKey:KEY_SELECTED_INVENTORY];
    _selectedProduct=[notification.userInfo valueForKey:KEY_SELECTED_PRODUCT];
    
    if(![self.navigationController.topViewController isKindOfClass:[StartInventoryViewController class]]){
        [self.navigationController popViewControllerAnimated:YES];
        
    }
    [self performSegueWithIdentifier:@"toAddProductViewController" sender:self];
}
*/
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
//-(void)didSelectInventory:(NSNotification *)notification{
    //InventoryItem *inventory=
    
//}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    /*
    UISplitViewController *svc= (UISplitViewController *)[self.navigationController parentViewController];
    
    UINavigationController *nav=(UINavigationController *)[svc.viewControllers objectAtIndex:0];
    
    CategoryViewController *cat=(CategoryViewController *)nav.topViewController;
    */
    
    
    if([segue.identifier isEqualToString:@"toInventorySettingsViewController"]){
        InventorySettingsViewController *vc=segue.destinationViewController;
        
        //_selectedInventory=cat.selectedInventory;
        vc.selectedInventory=_selectedInventory;
        
        self.settingsViewContorller=[segue destinationViewController];
        self.settingsViewContorller.selectedInventory=_selectedInventory;
        //if(isIpad){
            svc.delegate=vc;
       // }

        
    }
    else if([segue.identifier isEqualToString:@"toAddCategoryViewController"]){
        AddCategoryViewController *vc=segue.destinationViewController;
        
        //_selectedInventory=cat.selectedInventory;
        vc.selectedInventory=_selectedInventory;
        //svc.delegate=vc;
        //if(isIpad){
            svc.delegate=vc;
        //}
        
    }
//    else if([segue.identifier isEqualToString:@"toEditCategoryViewController"]){
//        EditCategoryViewController *vc=segue.destinationViewController;
//        
//        /*_selectedInventory=cat.selectedInventory;
//        _selectedCategory=cat.selectedCategory;
//        */
//        vc.selectedInventory=_selectedInventory;
//        vc.selectedCategory=_selectedCategory;
//        svc.delegate=vc;
//    }
    
    else if([segue.identifier isEqualToString:@"toEditProductViewController"]){
        /*UISplitViewController *svc= (UISplitViewController *)[self.navigationController parentViewController];
         
         UINavigationController *nav=(UINavigationController *)[svc.viewControllers objectAtIndex:0];
         
         CategoryViewController *cat=(CategoryViewController *)nav.topViewController;
         */
        EditProductViewController *vc=segue.destinationViewController;
        
        vc.selectedProduct=_selectedProduct;
        vc.selectedInventory=_selectedInventory;
        vc.selectedCategory=_selectedCategory;
        
        svc.delegate=vc;
    }
    else if([segue.identifier isEqualToString:@"toAddProductViewController"]){
//        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
//            [self.navigationItem.backBarButtonItem setTitle:@"Cancel"];
//        }
        AddProductViewController *vc=segue.destinationViewController;
        
        
        vc.selectedInventory=_selectedInventory;
        vc.selectedCategory=_selectedCategory;
        vc.selectedProduct=_selectedProduct;
        
        svc.delegate=vc;
        
    }
}

-(void)selectedInventory:(InventoryItem *)inventory{
    _selectedInventory=inventory;
    if(self.settingsViewContorller==nil){
        [self performSegueWithIdentifier:@"toInventorySettingViewController" sender:self];
    }
    else{
        [self.settingsViewContorller setSelectedInventory:inventory];
    }
}

//-(void)splitViewController:(UISplitViewController *)svc willHideViewController:(UIViewController *)aViewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)pc{
//    
//    self.popover=pc;
//     //barButtonItem.title=@"Inventories";
//     //[_navBarItem setLeftBarButtonItem:barButtonItem animated:YES];
//    //UINavigationItem *navItem = [self navigationItem];
//    [[self navigationItem] setLeftBarButtonItem:barButtonItem animated:YES];
//    
//    
//    NSLog(@"Will hide left side 1");
//}
//
//-(void)splitViewController:(UISplitViewController *)svc willShowViewController:(UIViewController *)aViewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem{
//    /*[_navBarItem setLeftBarButtonItem:nil animated:YES];
//    
//     */
//    [[self navigationItem] setLeftBarButtonItem:barButtonItem animated:YES];
//     _popover=nil;
//    NSLog(@"Will show left side 1");
//}
-(BOOL)splitViewController:(UISplitViewController *)svc shouldHideViewController:(UIViewController *)vc inOrientation:(UIInterfaceOrientation)orientation{
    return NO;
}
@end
