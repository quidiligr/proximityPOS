//
//  BaseControllerViewController.m
//  superkiosk
//
//  Created by Katherine Sheehy on 3/2/16.
//  Copyright © 2016 Appcoda. All rights reserved.
//

#import "BaseViewController.h"
#import "defs.h"
#import "BadgeBarButtonItem.h"
#import "AppDelegate.h"
#import "StartChatViewController.h"

@interface BaseViewController (){
    UISplitViewController *svc;
    NSString *initialView;
}
//@property (nonatomic, strong) AppDelegate *appDelegate;
@end

@implementation BaseViewController

- (void)viewDidLoad {
    self.view.backgroundColor=[UIColor clearColor];
    _appDelegatee = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if(_appDelegatee.isIpad){
        svc= (UISplitViewController *)[self.navigationController parentViewController];
        svc.delegate=self;
        
        //toolbar
        //bottom toolbar
        [self.navigationController setToolbarHidden:NO];
        
        
        
        //custom button
        UIButton *settingsButton;
        UIButton *ordersButton;
        UIButton *usersButton;
        UIButton *connButton;
        UIButton *checkoutButton;
        UIButton *menuButton;
        
        UIBarButtonItem *settingsButtonItem;
        UIBarButtonItem *ordersButtonItem;
        UIBarButtonItem *usersButtonItem;
        UIBarButtonItem *connButtonItem;
        //BadgeBarButtonItem *checkoutButtonItem;
        UIBarButtonItem *checkoutButtonItem;
        UIBarButtonItem *menuButtonItem;
        
        checkoutButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        [checkoutButton addTarget:self action:@selector(showCartAction:) forControlEvents:UIControlEventTouchUpInside];
        [checkoutButton setImage:[UIImage imageNamed:@"Checkout-32"] forState:UIControlStateNormal];
        [checkoutButton setTitle:@"Cart" forState:UIControlStateNormal];
        /*
         cartButtonItem = [[BadgeBarButtonItem alloc] initWithCustomUIButton:checkoutButton];
         cartButtonItem.badgeValue = @"1";
         
         cartButtonItem.badgeOriginX = 13;
         cartButtonItem.badgeOriginY = -9;
         */
        
        [checkoutButton sizeToFit];
        checkoutButtonItem=[[UIBarButtonItem alloc] initWithCustomView:checkoutButton];
        
        /*menuButtonItem=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menu"] style:UIBarButtonItemStyleBordered target:self action:@selector(showMenuAction:)];
        self.navigationItem.leftBarButtonItem=menuButtonItem;
        */
        
        menuButton=[UIButton buttonWithType:UIButtonTypeCustom];
        [menuButton setImage:[UIImage imageNamed:@"menu"] forState:UIControlStateNormal];
        [menuButton setTitle:@"Menu" forState:UIControlStateNormal];
        [menuButton addTarget:self action:@selector(showMenuAction:) forControlEvents:UIControlEventTouchUpInside];
        [menuButton sizeToFit];
        menuButtonItem=[[UIBarButtonItem alloc] initWithCustomView:menuButton];
        
        settingsButton=[UIButton buttonWithType:UIButtonTypeCustom];
        [settingsButton setImage:[UIImage imageNamed:@"settings"] forState:UIControlStateNormal];
        [settingsButton setTitle:@"Settings" forState:UIControlStateNormal];
        [settingsButton addTarget:self action:@selector(showSettingsAction:) forControlEvents:UIControlEventTouchUpInside];
        [settingsButton sizeToFit];
        settingsButtonItem=[[UIBarButtonItem alloc] initWithCustomView:settingsButton];
        
        ordersButton=[UIButton buttonWithType:UIButtonTypeCustom];
        [ordersButton setImage:[UIImage imageNamed:@"Check"] forState:UIControlStateNormal];
        [ordersButton setTitle:@"Orders" forState:UIControlStateNormal];
        [ordersButton addTarget:self action:@selector(showOrderHistoryAction:) forControlEvents:UIControlEventTouchUpInside];
        [ordersButton sizeToFit];
        ordersButtonItem=[[UIBarButtonItem alloc] initWithCustomView:ordersButton];
        
        
        usersButton=[UIButton buttonWithType:UIButtonTypeCustom];
        [usersButton setImage:[UIImage imageNamed:@"User Group"] forState:UIControlStateNormal];
        [usersButton setTitle:@"Users" forState:UIControlStateNormal];
        [usersButton addTarget:self action:@selector(showUsersAction:) forControlEvents:UIControlEventTouchUpInside];
        [usersButton sizeToFit];
        usersButtonItem=[[UIBarButtonItem alloc] initWithCustomView:usersButton];
        
        
        connButton=[UIButton buttonWithType:UIButtonTypeCustom];
        [connButton setImage:[UIImage imageNamed:@"settings"] forState:UIControlStateNormal];
        [connButton setTitle:@"Nearby" forState:UIControlStateNormal];
        [connButton addTarget:self action:@selector(showConnectionAction:) forControlEvents:UIControlEventTouchUpInside];
        [connButton sizeToFit];
        connButtonItem=[[UIBarButtonItem alloc] initWithCustomView:connButton];
        
        
        [self setToolbarItems:@[connButtonItem, menuButtonItem,checkoutButtonItem,ordersButtonItem,settingsButtonItem,usersButtonItem,]];
        
    }
    
    //end toolbar

    
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

-(BOOL)splitViewController:(UISplitViewController *)svc shouldHideViewController:(UIViewController *)vc inOrientation:(UIInterfaceOrientation)orientation{
    return NO;
}

- (IBAction)showMenuAction:(id)sender {
    [self buttonsAction:NOTIFY_SHOW_MENU];
    
    
}

- (IBAction)showUsersAction:(id)sender {
       [self buttonsAction:NOTIFY_SHOW_USERS];
    
    
}


- (IBAction)showSettingsAction:(id)sender {
    
     [self buttonsAction:NOTIFY_SHOW_SETTINGS];
    
}


- (IBAction)showOrderHistoryAction:(id)sender {
    
    [self buttonsAction:NOTIFY_SHOW_ORDERHISTORY];
   
    
}

- (IBAction)showConnectionAction:(id)sender {
    
    [self buttonsAction:NOTIFY_SHOW_CONN];
    
}
- (IBAction)showCartAction:(id)sender {
    
    [self buttonsAction:NOTIFY_SHOW_CHECKOUT];
    
}

-(void)buttonsAction:(NSString *)name{
    if(_appDelegatee.isIpad){
        if([self.navigationController.topViewController isKindOfClass:[ConnectionsViewController class]]){
            initialView=name;
            [self performSegueWithIdentifier:NOTIFY_SHOW_STARTCHAT sender:self];
            //[NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(showStarChat) userInfo:@{name:name} repeats:NO];
            [self performSelector:@selector(showStarChat) withObject:nil afterDelay:1.0];
            
            //[[NSNotificationCenter defaultCenter] postNotificationName:name object:nil];
        }
        else{
            if ([name isEqualToString:NOTIFY_SHOW_MENU]){
                if(_appDelegatee.mcManager.serverPeerInfo!=nil && _appDelegatee.mcManager.serverPeerInfo.sessionState==MCSessionStateConnected){
                    [[NSNotificationCenter defaultCenter] postNotificationName:name object:nil];
                }
                else{
                    [AppDelegate toast:@"Not connected. Tap Nearby to connect." duration:3.0];
                }
            }
            else
            {
                
            [[NSNotificationCenter defaultCenter] postNotificationName:name object:nil];
            }
        }
        
    }

}
-(void)showStarChat{
     [[NSNotificationCenter defaultCenter] postNotificationName:initialView object:nil];
}
/*
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:NOTIFY_SHOW_STARTCHAT]){
        StartChatViewController *sc=segue.destinationViewController;
        sc.initialView=initialView;
        //[sc showInitialView];
    }
    
}
 */
//toolbar

 
@end
