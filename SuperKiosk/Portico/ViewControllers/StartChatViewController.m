//
//  EmptyViewController.m
//  superkiosks
//
//  Created by Katherine Sheehy on 12/10/15.
//  Copyright © 2015 Appcoda. All rights reserved.
//

#import "StartChatViewController.h"
#import "ConnectionsViewController.h"
#import "AppSettingsViewController.h"
#import "AppDelegate.h"
//#import "AddCategoryViewController.h"
//#import "EditCategoryViewController.h"

//#import "ProductViewController.h"
//#import "BadgeBarButtonItem.h"
//#import "Product.h"
//#import "ProductCategory.h"
//#import "InventoryItem.h"
#import "defs.h"




//#import "AddProductViewController.h"

@interface StartChatViewController (){
    //UISplitViewController *svc;
    
    
}

@end

@implementation StartChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor clearColor];
   
    /*
    svc= (UISplitViewController *)[self.navigationController parentViewController];
    svc.delegate=self;
   */
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showOrderHistory:) name:NOTIFY_SHOW_ORDERHISTORY object:nil];
    
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showCheckout:) name:NOTIFY_SHOW_CHECKOUT object:nil];
    
    
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showSettings:) name:NOTIFY_SHOW_SETTINGS object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showUsers:) name:NOTIFY_SHOW_USERS object:nil];
    
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showMenu:) name:NOTIFY_SHOW_MENU object:nil];
    
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showConn:) name:NOTIFY_SHOW_CONN object:nil];
    /*
    UIButton *customButton = [[UIButton alloc] init];
    //...
    
    // Create and add our custom BBBadgeBarButtonItem
    BBBadgeBarButtonItem *barButton = [[BBBadgeBarButtonItem alloc] initWithCustomUIButton:customButton];
    // Set a value for the badge
    barButton.badgeValue = @"1";
    
    // Add it as the leftBarButtonItem of the navigation bar
    self.navigationItem.leftBarButtonItem = barButton;
    */
    // If you want your BarButtonItem to handle touch event and click, use a UIButton as customView
//    UIButton *checkoutButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
//    // Add your action to your button
//    [checkoutButton addTarget:self action:@selector(showCheckout:) forControlEvents:UIControlEventTouchUpInside];
//    // Customize your button as you want, with an image if you have a pictogram to display for example
//    [checkoutButton setImage:[UIImage imageNamed:@"Checkout-32"] forState:UIControlStateNormal];
    
    // Then create and add our custom BBBadgeBarButtonItem
//    checkoutBadgeButton = [[BadgeBarButtonItem alloc] initWithCustomUIButton:checkoutButton];
//    // Set a value for the badge
//    checkoutBadgeButton.badgeValue = @"1";
//    
//    checkoutBadgeButton.badgeOriginX = 13;
//    checkoutBadgeButton.badgeOriginY = -9;
//    
//    
//    
//    //menuButton=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"list"] style:UIBarButtonItemStyleBordered target:self action:@selector(showMenu:)];
//    
//    // Add it as the leftBarButtonItem of the navigation bar
//    self.navigationItem.rightBarButtonItems = @[ordersButton,settingsButton,usersButton];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
     [[self navigationController] setNavigationBarHidden:YES animated:YES];
    /*if(_popover!=nil){
        [_popover dismissPopoverAnimated:YES];
    }
*/
    //if(isIpad){
  /*  if(svc.delegate==nil || svc.delegate!=self){
        svc.delegate=self;
    }
    if(_initialView){
        [self showInitialView];
        _initialView=nil;
    }
   */
    //}
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
     [[self navigationController] setNavigationBarHidden:NO animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)showOrderHistory:(id)sender {

    [self show:NOTIFY_SHOW_ORDERHISTORY];
    
}
- (IBAction)showCheckout:(id)sender {

    [self show:NOTIFY_SHOW_CHECKOUT];

}

- (IBAction)showSettings:(id)sender {

  
    
    //[self show:NOTIFY_SHOW_SETTINGS];
    AppSettingsViewController* settingsController = (AppSettingsViewController*) [ApplicationDelegate.storyBoard instantiateViewControllerWithIdentifier:@"AppSettingsViewController"];
    UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:settingsController];
    
    
    
    [self presentViewController:nav animated:YES completion:nil];
    //[self performSegueWithIdentifier:NOTIFY_SHOW_SETTINGS sender:self];
}

- (IBAction)showMenu:(id)sender {
   
    [self show:NOTIFY_SHOW_MENU];
    
}
- (IBAction)showUsers:(id)sender {

    [self show:NOTIFY_SHOW_USERS];
    
}

- (IBAction)showConn:(id)sender {
    
    if([self.navigationController.topViewController isKindOfClass:[ConnectionsViewController class]]){
        return;
        
    }
    else
    {
        [self.navigationController popToRootViewControllerAnimated:YES];
        
    }
    
    
    
    
    
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
   
    
}

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
-(void)show:(NSString *)name{
    NSInteger count=[self.navigationController.viewControllers count];
    /*
#if DEBUG
    NSLog(@"VCs count=%lu",count);
#endif
*/
     if(count>1){
        count=count-1;
        for(int i=1;i<=count;i++){
            [self.navigationController popViewControllerAnimated:YES];
            
            
        }
    }
    [self performSegueWithIdentifier:name sender:self];
}

-(void)showInitialView{
    if(_initialView){
        [self performSegueWithIdentifier:_initialView sender:self];
    }
     
}

@end
