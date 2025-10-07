//
//  CheckoutViewController.m


#import "CheckoutIpadViewController.h"
#import "CheckoutProductCell.h"
#import "SubtotalCell.h"
#import "CheckoutCart.h"
#import "OrderItem.h"
#import "InventoryModel.h"
#import "InventoryItem.h"
#import "defs.h"
#import "AppDelegate.h"

@interface CheckoutIpadViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *continueButtonView;
@property (strong, nonatomic) IBOutlet UIButton *continueButton;

@property (strong, nonatomic) CheckoutCart* checkoutCart;

@property (strong, nonatomic) AppDelegate* appDelegate;



@end

@implementation CheckoutIpadViewController{
    UIBarButtonItem *emptyCartButton;
    InventoryModel *_inventoryModel;
    InventoryItem *_selectedInventory;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    emptyCartButton=[[UIBarButtonItem alloc] initWithTitle:@"Empty cart" style:UIBarButtonItemStyleBordered target:self action:@selector(emptyCart)];
    
    self.checkoutCart = [CheckoutCart sharedInstance];
    self.appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];//[[UIApplication sharedApplication] delegate];
    //_inventoryModel=[InventoryModel sharedInstance];
    _selectedInventory=[InventoryModel activeInventory];
    CGRect frame=self.tableView.frame;
    self.tableView.frame=CGRectMake(frame.origin.x, frame.origin.y, frame.size.height-self.tabBarController.tabBar.frame.size.height, frame.size.width);
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if(self.checkoutCart.itemsInCart.count==0){
        [self.tableView setHidden:YES];
        self.navigationItem.rightBarButtonItem=nil;

    }
    else{
         self.navigationItem.rightBarButtonItem=emptyCartButton;
        [self.tableView setHidden:NO];
        [self.tableView reloadData];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource methods

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return (section == 0) ? @"Products " : @"";
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //return (section == 0) ? self.checkoutCart.itemsInCart.count : 1;
    NSInteger count=0;
    if (section==0) {
        count=self.checkoutCart.itemsInCart.count;
        if(count==0) {
            
            self.navigationItem.rightBarButtonItem=nil;
            self.navigationItem.leftBarButtonItem=nil;
            
            [self.tableView setHidden:YES];
            UITabBarItem *tbi=(UITabBarItem *)[self.tabBarController.tabBar.items objectAtIndex:TAB_INDEX_CART];
            //if([checkoutCart.itemsInCart count]==0)
            tbi.badgeValue=nil;
            //else
            //  tbi.badgeValue=[NSString stringWithFormat:@"%lu",(unsigned long)[checkoutCart.itemsInCart count]];
            
        }
        else{
            self.navigationItem.rightBarButtonItem=emptyCartButton;
            self.navigationItem.leftBarButtonItem=self.editButtonItem;
            
            [self.tableView setHidden:NO];
            UITabBarItem *tbi=(UITabBarItem *)[self.tabBarController.tabBar.items objectAtIndex:TAB_INDEX_CART];
            //if([checkoutCart.itemsInCart count]==0)
            //tbi.badgeValue=nil;
            //else
            tbi.badgeValue=[NSString stringWithFormat:@"%lu",(unsigned long)[self.checkoutCart.itemsInCart count]];
        }
    }
    else if (section==1){
        count= 3;
    }
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        //Product* product = self.checkoutCart.productsInCart[indexPath.row];
        OrderItem* item = self.checkoutCart.itemsInCart[indexPath.row];
        CheckoutProductCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"CheckoutCell"];
        cell.productNameLabel.text =  item.name;
        //cell.productDescLabel.text = item.detail;
        cell.priceLabel.text = [NSString stringWithFormat:@"%@", [AppDelegate decimalDisplay:(double)(item.price*item.quantity)/100]];
        if (item.quantity>1) {
            cell.quantityLabel.text=[NSString stringWithFormat:@"@%lx",(unsigned long)item.quantity];
        }
        else{
            cell.quantityLabel.text=nil;
        }
        return cell;
    }
    /*else {
        SubtotalCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"TotalCell"];
        NSInteger total=[self.checkoutCart total];
        if(_checkoutCart.order!=nil && _checkoutCart.order.orderTax>0){
            total=total+total*(_checkoutCart.order.orderTax/100);
        }
        cell.totalLabel.text = [NSString stringWithFormat:@"$%.02f", (double)total/100];
        return cell;
    }
     */
    else if(indexPath.section==1) {
        if (indexPath.row==0) {
            
            SubtotalCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"TotalCell"];
            cell.nameLabel.text=@"Subtotal";
            cell.totalLabel.text = [NSString stringWithFormat:@"%@", [AppDelegate decimalDisplay:(double)[self.checkoutCart total]/100]];
            return cell;
        }
        else if (indexPath.row==1) { //tax
            
            SubtotalCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"TotalCell"];
            
            
            //float tax=[[_appDelegate.sale valueForKey:@"tax"] floatValue];
            cell.nameLabel.text=[NSString stringWithFormat:@"Tax %@%%",[AppDelegate decimalDisplay:_selectedInventory.salesTax]];
            cell.totalLabel.text = [NSString stringWithFormat:@"%@", [AppDelegate decimalDisplay:(double)[self.checkoutCart total_tax:[_checkoutCart total] tax:_selectedInventory.salesTax]/100] ];
            
            return cell;
        }
        else if (indexPath.row==2) {
            
            SubtotalCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"TotalCell"];
            
            cell.nameLabel.text=[NSString stringWithFormat:@"Total"];
            cell.totalLabel.text = [NSString stringWithFormat:@"%@", [AppDelegate decimalDisplay:(double)[self.checkoutCart grand_total:_selectedInventory.salesTax]/100]];
            return cell;
        }
    }
    
    return nil;
}

#pragma mark - UITableViewDelegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        return YES;
    }
    else{
        return NO;
    }
}
-(void)setEditing:(BOOL)editing animated:(BOOL)animated{
    [super setEditing:editing animated:animated];
    [self.tableView setEditing:editing animated:animated];
    if(editing){
        
    }
    else{
        
    }
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    /*
     NSMutableArray *orders=[self.history valueForKey:day];
     if(orders==nil){
     orders=[NSMutableArray new];
     [orders addObject:order];
     [self.history setValue:orders forKey:day];
     }
     else{
     [orders addObject:order];
     }
     */
    //NSMutableArray *orders=[_appDelegate.historyModel.history valueForKey:historyDates[indexPath.section]] ;
    
    //OrderHistory *delete_item=[orders objectAtIndex:indexPath.row];
    
    
    
    
    if(editingStyle==UITableViewCellEditingStyleDelete){
        //if(delete_item!=nil){
          //  [orders removeObject:delete_item];
            
        //}
        [self.checkoutCart removeItem:[self.checkoutCart.itemsInCart objectAtIndex:indexPath.row]];
        [self.tableView reloadData];
    }
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    /*if([segue.identifier isEqualToString:@"toRWStripeViewController"]){
        _appDelegate.stripeController=segue.destinationViewController;
    }
     */
}

-(void)emptyCart{
    
    [self.checkoutCart clearCart];
    [self.tableView reloadData];
    
}
@end
