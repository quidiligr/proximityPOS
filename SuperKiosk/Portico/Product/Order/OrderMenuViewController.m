//
//  MenuMainViewController.m
//  superkiosk
//
//  Created by Katherine Sheehy on 6/5/16.
//  Copyright © 2016 Sharecle. All rights reserved.
//

#import "OrderMenuViewController.h"
#import "ProductViewController.h"
#import "ProductNoSellViewController.h"
#import "OrderMenuTableViewController.h"
#import "OrderMenuCollectionViewController.h"

#import "Product.h"
#import "ProductCategory.h"
#import "AppDelegate.h"
#import "CheckoutCart.h"
//#import "StoreHistory.h"
#import "defs.h"

//static NSString  *__nextViewName__;

@interface OrderMenuViewController (){
    
    BOOL isIpad;
    BOOL isTableView;
   // BOOL willShowChildView;
    
    AppDelegate *_appDelegate;
    
    UIBarButtonItem *_searchButtonItem;
    NSString *_nextViewName;
}

@end

@implementation OrderMenuViewController
/*
+ (OrderMenuViewController *)sharedInstance {
    static OrderMenuViewController*  _shared;
    
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        _shared = [[OrderMenuViewController alloc] init];
        
        
    });
    
    return _shared;
}
 */
//+ (NSString *)getNextViewName {
//    //static NSString  *_shared;
//    /*
//    static dispatch_once_t once;
//    dispatch_once(&once, ^{
//        _sharedHistory = [[HistoryModel alloc] init];
//        [_sharedHistory loadHistory];
//        
//        
//    });
//    */
//    return __nextViewName__;
//}
//- (void)setNextViewName:(NSString *)name {
//    //static NSString  *_shared;
//    /*
//     static dispatch_once_t once;
//     dispatch_once(&once, ^{
//     _sharedHistory = [[HistoryModel alloc] init];
//     [_sharedHistory loadHistory];
//     
//     
//     });
//     */
//    __nextViewName__=name;
//}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showMenuTable) name:NOTIFY_SHOW_MENU_TABLE object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showConnections) name:NOTIFY_SHOW_MENU_CONNECTIONS object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showMenuCollection) name:NOTIFY_SHOW_MENU_COLLECTION object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showProduct:) name:NOTIFY_SHOW_PRODUCT object:nil];
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showProductNoSell:) name:NOTIFY_SHOW_PRODUCT_NOSELL object:nil];
    
    _appDelegate=ApplicationDelegate;
    
    
    
    if(_appDelegate.isIpad)
        isIpad=YES;
    else
        isIpad=NO;
    
    if(isIpad)
        isTableView=NO;
    
    else
        isTableView=YES;
    
    // willShowChildView=NO;
    
    //if(isIpad)
        _nextViewName=NOTIFY_SHOW_MENU_COLLECTION;
    //else
     //   _nextViewName=NOTIFY_SHOW_MENU_COLLECTION;//NOTIFY_SHOW_MENU_TABLE;
    
    //_searchButtonItem=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Search"] style:UIBarButtonItemStyleBordered target:self action:@selector(showSearch)];
    
    //self.navigationItem.leftBarButtonItem=_searchButtonItem;
    
    
    //hasView=NO;
    /*
    if(_appDelegate.isIpad){
        isCollectionView=YES;
    }
    else{
        isCollectionView=NO;
    }
    */
    [self updateCartBadge];
}

-(void)updateCartBadge{
    UITabBarItem *tbi=(UITabBarItem *)[self.tabBarController.tabBar.items objectAtIndex:TAB_INDEX_CART];
    if([_appDelegate.selectedStore.cart.itemsArray count]==0)
        tbi.badgeValue=nil;
    else
        tbi.badgeValue=[NSString stringWithFormat:@"%lu",(unsigned long)[_appDelegate.selectedStore.cart.itemsArray count]];
}


-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    /*if (willShowChildView) {
        
        willShowChildView=NO;
        
        
    }
    else{
        
        if(isTableView)
            [self showMenuTable];
        
        else
            [self showMenuCollection];
         
        
    }
     */
    if(_nextViewName==nil || _nextViewName.length==0){
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else{
        [self showWithNotificationName:_nextViewName];
    }
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
-(void)showWithNotificationName:(NSString *)name{
    /*if([name isEqualToString:NOTIFY_SHOW_MENU_COLLECTION]){
        [self showConnections];
        
    }
    else if([name isEqualToString:NOTIFY_SHOW_MENU_COLLECTION]){
        [self showConnections];
        
    }
    else if([name isEqualToString:NOTIFY_SHOW_MENU_COLLECTION]){
        [self showConnections];
        
    }
     */
    [self performSegueWithIdentifier:name sender:self];
    //_nextViewName=nil;
}
-(void)showConnections{
    //showDefaultView=NO;
    //[self.navigationController popToRootViewControllerAnimated:YES];
    /*if(currentViewController!=nil)
     [currentViewController dismissViewControllerAnimated:YES completion:^{
     [self performSegueWithIdentifier:NOTIFY_SHOW_MENU_TABLE sender:self];
     //hasView=YES;
     }];
     else{*/
    isTableView=YES;
    [self performSegueWithIdentifier:NOTIFY_SHOW_MENU_CONNECTIONS sender:self];
    
    //hasView=YES;
    //}
}
-(void)showMenuTable{
    //showDefaultView=NO;
    //[self.navigationController popToRootViewControllerAnimated:YES];
    /*if(currentViewController!=nil)
     [currentViewController dismissViewControllerAnimated:YES completion:^{
     [self performSegueWithIdentifier:NOTIFY_SHOW_MENU_TABLE sender:self];
     //hasView=YES;
     }];
     else{*/
    isTableView=YES;
    [self performSegueWithIdentifier:NOTIFY_SHOW_MENU_TABLE sender:self];
    
    //hasView=YES;
    //}
}
-(void)showMenuCollection{
    //showDefaultView=NO;
    // [self.navigationController popToRootViewControllerAnimated:YES];
    /*
     if(currentViewController!=nil)
     [currentViewController dismissViewControllerAnimated:YES completion:^{
     [self performSegueWithIdentifier:NOTIFY_SHOW_MENU_COLLECTION sender:self];
     //hasView=YES;
     }];
     else{
     */
    isTableView=NO;
    [self performSegueWithIdentifier:NOTIFY_SHOW_MENU_COLLECTION sender:self];
    
    //hasView=YES;
    //}
    
}

-(void)showProduct:(NSNotification *)notification{
    
    _selectedProduct=(Product *)[notification.userInfo valueForKey:@"product"];
    _selectedCategory=(ProductCategory *)[notification.userInfo valueForKey:@"category"];
    
    //if(_appDelegate.selectedStore.inventory.isEcommerce)
        [self performSegueWithIdentifier:NOTIFY_SHOW_MENU_PRODUCT sender:self];
    //else
    //    [self performSegueWithIdentifier:NOTIFY_SHOW_MENU_PRODUCT_NOSELL sender:self];

    
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
   
    if([segue.identifier isEqualToString:NOTIFY_SHOW_MENU_PRODUCT]){
        
        ProductViewController* viewController = (ProductViewController*) segue.destinationViewController;
        
        
        
        viewController.selectedProduct= _selectedProduct;
        viewController.selectedCategory=_selectedCategory;
        viewController.refenceToParentViewController=self;
       
            _nextViewName=NOTIFY_SHOW_MENU_COLLECTION;
        
    }
   
    else if([segue.identifier isEqualToString:NOTIFY_SHOW_MENU_COLLECTION]){
        
        OrderMenuCollectionViewController* viewController = (OrderMenuCollectionViewController*) segue.destinationViewController;
        viewController.refenceToParentViewController= self;
        _nextViewName=nil;
        
    }
    
    
    
}

-(void)showSearch{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
