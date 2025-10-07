//
//  MenuMainViewController.m
//  superkiosk
//
//  Created by Katherine Sheehy on 6/5/16.
//  Copyright © 2016 Sharecle. All rights reserved.
//

#import "OrderMenuViewController.h"
#import "AppDelegate.h"
#import "ProductViewController.h"
#import "OrderMenuCollectionViewController.h"
#import "Product.h"
#import "ProductCategory.h"
#import "defs.h"
@interface OrderMenuViewController (){
    //BOOL hasView;
    BOOL isIpad;
    BOOL isTableView;
    BOOL willShowChildView;
    //UIViewController *currentViewController;
    Product *_selectedProduct;
    ProductCategory *_selectedCategory;
    
    NSString *_nextViewName;
}

@end

@implementation OrderMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showMenuTable) name:NOTIFY_SHOW_MENU_TABLE object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showMenuCollection) name:NOTIFY_SHOW_MENU_COLLECTION object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showProduct:) name:NOTIFY_SHOW_MENU_PRODUCT object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showInventory) name:NOTIFY_SHOW_INVENTORY_LIST object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showSettings) name:NOTIFY_SHOW_SETTINGS object:nil];
    
    AppDelegate *_appDelegate=ApplicationDelegate;
    
    _selectedProduct=nil;
    _selectedCategory=nil;
    
    if(_appDelegate.isIpad)
        isIpad=YES;
    else
        isIpad=NO;
    
    if(isIpad)
        isTableView=NO;
    
    else
        isTableView=YES;
    
    
    //willShowChildView=NO;
    //hasView=NO;
    /*
     if(_appDelegate.isIpad){
     isCollectionView=YES;
     }
     else{
     isCollectionView=NO;
     }
     */
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    /*
    if (willShowChildView) {
        
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
    //showDefaultView=NO;
    //[self.navigationController popToRootViewControllerAnimated:YES];
    
    _selectedProduct=(Product *)[notification.userInfo valueForKey:@"product"];
    _selectedCategory=(ProductCategory *)[notification.userInfo valueForKey:@"category"];
    /*if(product==nil)
        return;
    
    if(currentViewController!=nil)
        [currentViewController dismissViewControllerAnimated:YES completion:^{
            [self performSegueWithIdentifier:NOTIFY_SHOW_MENU_PRODUCT sender:self];
            // hasView=YES;
        }];
    else{
     */
        [self performSegueWithIdentifier:NOTIFY_SHOW_MENU_PRODUCT sender:self];
        
        //hasView=YES;
    //}
    
}

-(void)showInventory{
    //showDefaultView=NO;
    //[self.navigationController popToRootViewControllerAnimated:YES];
    
    //if(currentViewController!=nil)
     //   [self.navigationController popViewControllerAnimated:YES];
        /*[currentViewController dismissViewControllerAnimated:YES completion:^{
            [self performSegueWithIdentifier:NOTIFY_SHOW_INVENTORY sender:self];
            // hasView=YES;
        }];
    else{
         */
        [self performSegueWithIdentifier:NOTIFY_SHOW_INVENTORY_LIST sender:self];
        
        //hasView=YES;
    //}
    
}

-(void)showSettings{
   // showDefaultView=NO;
    //[self.navigationController popToRootViewControllerAnimated:YES];
/*
    if(currentViewController!=nil)
        [currentViewController dismissViewControllerAnimated:YES completion:^{
            [self performSegueWithIdentifier:NOTIFY_SHOW_SETTINGS sender:self];
            // hasView=YES;
        }];
    else{
 */
        [self performSegueWithIdentifier:NOTIFY_SHOW_SETTINGS sender:self];
        
        //hasView=YES;
   // }
    
}

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
/*
-(void)showProductNoSell{
    
    if(currentViewController!=nil)
        [currentViewController dismissViewControllerAnimated:YES completion:^{
            [self performSegueWithIdentifier:@"toProductNoSellViewController" sender:self];
            // hasView=YES;
        }];
    else{
        [self performSegueWithIdentifier:@"toProductNoSellViewController" sender:self];
        
        //hasView=YES;
    }
}
 */
/*
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    //currentViewController=segue.destinationViewController;
    //showDefaultView=NO;
    willShowChildView=YES;
    NSUInteger count=[self.navigationController.viewControllers count];
    if(count>1)
        [self.navigationController popToRootViewControllerAnimated:YES];
    
    if([segue.identifier isEqualToString:NOTIFY_SHOW_MENU_PRODUCT]){
        
        ProductViewController* viewController = (ProductViewController*) segue.destinationViewController;
        
        
        
        viewController.selectedProduct= _selectedProduct;
        viewController.selectedCategory=_selectedCategory;
        
    }
    
}
 */

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

@end
