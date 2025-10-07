//
//  CheckoutViewController.m


#import "CheckoutViewController.h"
#import "CheckoutCell.h"
#import "CheckoutNoNotesCell.h"
#import "SubtotalCell.h"
#import "CheckoutCart.h"
#import "OrderItem.h"
#import "OrderOptionItem.h"
#import "InventoryModel.h"
#import "InventoryItem.h"
#import "Util.h"
#import "defs.h"
#import "AppDelegate.h"

@interface CheckoutViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *continueButtonView;
@property (strong, nonatomic) IBOutlet UIButton *continueButton;

@property (strong, nonatomic) CheckoutCart* checkoutCart;

@property (strong, nonatomic) AppDelegate* appDelegate;



@end

@implementation CheckoutViewController{
    UIBarButtonItem *emptyCartButton;
    InventoryModel *_inventoryModel;
    InventoryItem *_selectedInventory;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor clearColor];
	// Do any additional setup after loading the view.
    emptyCartButton=[[UIBarButtonItem alloc] initWithTitle:@"Empty cart" style:UIBarButtonItemStyleBordered target:self action:@selector(emptyCart)];
    
    self.checkoutCart = [CheckoutCart sharedInstance];
    self.appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];//[[UIApplication sharedApplication] delegate];
    _inventoryModel=[InventoryModel sharedInstance];
    _selectedInventory=_inventoryModel.inventory;//[InventoryModel activeInventory];
    CGRect frame=self.tableView.frame;
    self.tableView.frame=CGRectMake(frame.origin.x, frame.origin.y, frame.size.height-self.tabBarController.tabBar.frame.size.height, frame.size.width);
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    /*if(self.checkoutCart.itemsInCart.count==0){
        [self.tableView setHidden:YES];
        self.navigationItem.rightBarButtonItem=nil;
        self.navigationItem.leftBarButtonItem=nil;
    }
    else{
         self.navigationItem.rightBarButtonItem=emptyCartButton;
        [self.tableView setHidden:NO];
        [self.tableView reloadData];
    }
     */
    [self.tableView reloadData];
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

- (UITableViewCell *)cellForRowAtIndexPath:(NSIndexPath *)indexPath withOrderItem:(OrderItem *)item{
    
    
    CheckoutCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"CheckoutItemCell"];
   
    
    if (item.quantity>1) {
       
        cell.productNameLabel.text = [NSString stringWithFormat:@"%lu %@",(long)item.quantity, item.name];
    }
    else{
        
        cell.productNameLabel.text = item.name;
        
    }
    /*
    double  price=item.price;
    cell.priceLabel.text = [NSString stringWithFormat:@"%.2f",price/100*item.quantity];
    */
    cell.priceLabel.text = [NSString stringWithFormat:@"@%@",[Util priceToString:(double)(item.price*item.quantity)/100 currency:_selectedInventory.currencySymbol]];
    
    if(item.discount>0){
        NSInteger discount=(item.actualPrice-item.price)*item.quantity;
        cell.discountLabel.text = [NSString stringWithFormat:@"Saved %.2f",(double)discount/100];
        
    }
    else{
        cell.discountLabel.text=nil;
    }
    
    NSString *notes=@"";
    
    if ([item.options count]>0){
        for(OrderOptionItem *ooi in item.options){
           // NSString *priceString=[Util priceToString:(double)(ooi.price*item.quantity)/100 currency:_selectedInventory.currencySymbol];
            
             NSString *priceString=[Util priceIntToString:ooi.addlCost currency:_selectedInventory.currencySymbol];
            
            notes=[NSString stringWithFormat:@"%@%@    %@\\n", notes,ooi.title,priceString];
            
            
        }
    }
    if(item.notes.length>0){
        notes=[NSString stringWithFormat:@"%@%@",notes,item.notes];
    }
    //if (orderItem.notes!=nil)
    cell.notesLabel.text=notes;//orderItem.notes;
    //else
    //  cell.notesLabel.text=nil;
    
    
    return cell;
}

- (UITableViewCell *)noNotesCellForRowAtIndexPath:(NSIndexPath *)indexPath withOrderItem:(OrderItem *)item{
    
    //OrderItem* product = _appDelegate.selectedStore.cart.itemsArray[indexPath.row];
    CheckoutNoNotesCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"CheckoutNoNotesCell"];
    cell.productNameLabel.text =  item.name;
    
    if (item.quantity>1) {
        //cell.quantityLabel.text=[NSString stringWithFormat:@"%lix",(long)product.quantity];
        cell.productNameLabel.text = [NSString stringWithFormat:@"%lu %@",(long)item.quantity, item.name];
    }
    else{
        //cell.quantityLabel.text=nil;
        cell.productNameLabel.text = item.name;
        
    }
    /*
    double  price=item.price;
    cell.priceLabel.text = [NSString stringWithFormat:@"%.2f",price/100*item.quantity];
    */
    cell.priceLabel.text = [NSString stringWithFormat:@"@%@",[Util priceToString:(double)(item.price*item.quantity)/100 currency:_selectedInventory.currencySymbol]];
    if(item.discount>0){
        NSInteger discount=(item.actualPrice-item.price)*item.quantity;
        cell.discountLabel.text = [NSString stringWithFormat:@"Saved %.2f",(double)discount/100];
        
    }
    else{
        cell.discountLabel.text=nil;
    }
    /*
     if (orderItem.notes!=nil)
     cell.notesLabel.text=orderItem.notes;
     else
     cell.notesLabel.text=nil;
     */
    
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
       
        /*OrderItem* item = self.checkoutCart.itemsInCart[indexPath.row];
        
        CheckoutCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"CheckoutCell"];
        
        
        
        if (item.quantity>1) {
            
            cell.productNameLabel.text = [NSString stringWithFormat:@"%lu %@",(long)item.quantity, item.name];
        }
        else{
            
            cell.productNameLabel.text = item.name;
        }
        
        cell.priceLabel.text = [NSString stringWithFormat:@"@%@",[Util priceToString:(double)(item.price*item.quantity)/100 currency:_selectedInventory.currencySymbol]];
        
            
        return cell;
         */
        OrderItem* item = self.checkoutCart.itemsInCart[indexPath.row];
        if(item.notes.length>0 || [item.options count]>0){
            return [self cellForRowAtIndexPath:indexPath withOrderItem:item];
        }
        else{
            return [self noNotesCellForRowAtIndexPath:indexPath withOrderItem:item];
        }
    }
    
    else if(indexPath.section==1) {
        if (indexPath.row==0) {
            
            SubtotalCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"TotalCell"];
            cell.nameLabel.text=@"Subtotal";
            cell.totalLabel.text = //[NSString stringWithFormat:@"%@", [AppDelegate decimalDisplay:(double)[self.checkoutCart total]/100]];
            [Util priceToString:(double)[self.checkoutCart total]/100 currency:_selectedInventory.currencySymbol];
            return cell;
        }
        else if (indexPath.row==1) { //tax
            
            SubtotalCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"TotalCell"];
            
            
            //float tax=[[_appDelegate.sale valueForKey:@"tax"] floatValue];
            cell.nameLabel.text=[NSString stringWithFormat:@"Tax %@%%",[Util decimalDisplay:_selectedInventory.salesTax]];
            
            //cell.totalLabel.text = [NSString stringWithFormat:@"%@", [AppDelegate decimalDisplay:(double)[self.checkoutCart total_tax:[_checkoutCart total] tax:_selectedInventory.salesTax]/100] ];
            
            cell.totalLabel.text = [Util priceToString:(double)[self.checkoutCart total_tax:[_checkoutCart total] tax:_selectedInventory.salesTax]/100 currency:_selectedInventory.currencySymbol];
            return cell;
        }
        else if (indexPath.row==2) {
            
            SubtotalCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"TotalCell"];
            
            cell.nameLabel.text=[NSString stringWithFormat:@"Total"];
            //cell.totalLabel.text = [NSString stringWithFormat:@"%@", [AppDelegate decimalDisplay:(double)[self.checkoutCart grand_total:_selectedInventory.salesTax]/100]];
            cell.totalLabel.text = [Util priceToString:(double)[self.checkoutCart grand_total:_selectedInventory.salesTax]/100 currency:_selectedInventory.currencySymbol];
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
