//
//  CheckoutViewController.m

#import <Stripe/Stripe.h>
#import "CheckoutViewController.h"
#import "CheckoutCell.h"
#import "CheckoutNoNotesCell.h"
//#import "CheckoutItemDiscountCell.h"
#import "SubtotalCell.h"
#import "CheckoutCart.h"
#import "AppDelegate.h"
#import "ShippingManager.h"
#import "BroadcastMessageAPI.h"
#import "OrderOptionItem.h"

#import <QuartzCore/QuartzCore.h>
//#import <PassKit/PassKit.h>

//#import "ApplePayStubs.h"

#import "PaymentViewController.h"

#import "defs.h"


// TODO: replace nil with your own value


@interface CheckoutViewController () <UITableViewDataSource,
UITableViewDelegate,
PKPaymentAuthorizationViewControllerDelegate,
PaymentViewControllerDelegate,
STPCheckoutViewControllerDelegate

>{
    float total_beforetax;
    float tax;
    float tax_cost;
    float total_aftertax ;
    float grand_total_beforeshipping;
    float shipping_cost;
    float total_charge;
    
    NSInteger confirmed_totalCents;
    NSInteger totalCents;
    
    NSMutableArray *arrBckendChargeHandler;
    NSTimer *processTimer;
    
    UIBarButtonItem *emptyCartButton;
    
}

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *continueButtonView;
@property (strong, nonatomic) IBOutlet UIButton *continueButton;

//@property (strong, nonatomic) CheckoutCart* checkoutCart;

@property (strong, nonatomic) AppDelegate* appDelegate;


@property (nonatomic) BOOL applePaySucceeded;
@property (nonatomic) NSError *applePayError;
@property (nonatomic) ShippingManager *shippingManager;
@property (weak, nonatomic) IBOutlet UIButton *applePayButton;
@property (weak, nonatomic) IBOutlet UIButton *creditcardPayButton;
@property (strong, nonatomic) IBOutlet UIButton *cashPayButton;

@end

@implementation CheckoutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //self.view.backgroundColor=[UIColor clearColor];
   // self.tableView.backgroundColor=[UIColor clearColor];
	// Do any additional setup after loading the view.
    
    emptyCartButton=[[UIBarButtonItem alloc] initWithTitle:@"Empty cart" style:UIBarButtonItemStyleBordered target:self action:@selector(emptyCart)];
    
   /* [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(performChargeSuccess:)
                                                 name:NOTIFY_CHARGE_SUCCESS_CARD
                                               object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(performConnected:)
                                                 name:NOTIFY_MCDIDCHANGESTATE_CONNECTED
                                               object:nil];
     */
    //rom: disable bec of mutiple connection support
    /*[[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(performDisConnected:)
                                                 name:NOTIFY_MCDIDCHANGESTATE_DISCONNECTED
                                               object:nil];
     */
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(performDisConnected:)
                                                 name:NOTIFY_BROWSERLOSTPEER
                                               object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didReceiveMenuWithNotification:)
                                                 name:NOTIFY_RECEIVED_MENU
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didReceiveMenuWithNotification:)
                                                 name:NOTIFY_RECEIVED_MENU_UPDATE
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didReceiveMenuSettingsWithNotification:)
                                                 name:NOTIFY_RECEIVED_MENU_SETTINGS
                                               object:nil];
    
    self.appDelegate=[[UIApplication sharedApplication] delegate];
    
    [[self.creditcardPayButton layer] setCornerRadius:8.0f];
    [[self.cashPayButton layer] setCornerRadius:8.0f];
    
    [[self.creditcardPayButton layer] setBorderWidth:1.0f];
     [[self.cashPayButton layer] setBorderWidth:1.0f];
    
    [[self.creditcardPayButton layer] setBorderColor:self.creditcardPayButton.titleLabel.textColor.CGColor];
    [[self.cashPayButton layer] setBorderColor:self.cashPayButton.titleLabel.textColor.CGColor];
    
    
}

-(void)updateBadge{
    UITabBarItem *tbi=(UITabBarItem *)[self.tabBarController.tabBar.items objectAtIndex:TAB_INDEX_CART];
    
    if([_appDelegate.selectedStore.cart.itemsArray count]==0)
        tbi.badgeValue=nil;
    else
        tbi.badgeValue=[NSString stringWithFormat:@"%ld",(long)[_appDelegate.selectedStore.cart.itemsArray count]];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if(_appDelegate.selectedStore.peerInfo!=nil && _appDelegate.selectedStore.peerInfo.sessionState==MCSessionStateConnected){
        //[self.checkoutCart cleanCart:_appDelegate.selectedStore.peerInfo.deviceID isLive:_appDelegate.appConfig.isLive];
        [self updateBadge];
        

    }
   
    /*if(![_appDelegate isConnectedToStore]){
        [self.cashPayButton setEnabled:NO];
        [self.creditcardPayButton setEnabled:NO];
    }
    else{
        [self.cashPayButton setEnabled:YES];
        [self.creditcardPayButton setEnabled:YES];

    }
     */
    [self reloadData];
}
/*
- (CGRect) maximumUsableFrame {
    
    static CGFloat const kNavigationBarPortraitHeight = 44;
    static CGFloat const kNavigationBarLandscapeHeight = 34;
    static CGFloat const kToolBarHeight = 49;
    
    // Start with the screen size minus the status bar if present
    CGRect maxFrame = [UIScreen mainScreen].applicationFrame;
    
    // If the orientation is landscape left or landscape right then swap the width and height
    if (UIInterfaceOrientationIsLandscape(self.interfaceOrientation)) {
        CGFloat temp = maxFrame.size.height;
        maxFrame.size.height = maxFrame.size.width;
        maxFrame.size.width = temp;
    }
    
    // Take into account if there is a navigation bar present and visible (note that if the NavigationBar may
    // not be visible at this stage in the view controller's lifecycle.  If the NavigationBar is shown/hidden
    // in the loadView then this provides an accurate result.  If the NavigationBar is shown/hidden using the
    // navigationController:willShowViewController: delegate method then this will not be accurate until the
    // viewDidAppear method is called.
    if (self.navigationController) {
        if (self.navigationController.navigationBarHidden == NO) {
            
            // Depending upon the orientation reduce the height accordingly
            if (UIInterfaceOrientationIsLandscape(self.interfaceOrientation)) {
                maxFrame.size.height -= kNavigationBarLandscapeHeight;
            }
            else {
                maxFrame.size.height -= kNavigationBarPortraitHeight;
            }
        }
    }
    
    // Take into account if there is a toolbar present and visible
    if (self.tabBarController) {
        if (!self.tabBarController.view.hidden) maxFrame.size.height -= kToolBarHeight;
    }
    return maxFrame;
}
*/
- (void)viewWillAppear:(BOOL)animated {
     [super viewWillAppear:animated];
    
    
    
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
    NSInteger count=0;
    if (section==0) {
        count=_appDelegate.selectedStore.cart.itemsArray.count;
        if(count==0) {
            
        self.navigationItem.rightBarButtonItem=nil;
        self.navigationItem.leftBarButtonItem=nil;
        
        [self.tableView setHidden:YES];
            

        }
        else{
            self.navigationItem.rightBarButtonItem=emptyCartButton;
            self.navigationItem.leftBarButtonItem=self.editButtonItem;
            
            [self.tableView setHidden:NO];
            /*
            UITabBarItem *tbi=(UITabBarItem *)[self.tabBarController.tabBar.items objectAtIndex:TAB_INDEX_CART];
            
              tbi.badgeValue=[NSString stringWithFormat:@"%lu",(unsigned long)[self.checkoutCart.itemsInCart count]];
             */
        }
        
        [self updateBadge];
    }
    else if (section==1){
        count= 4;
    }
    return count;
}

#pragma mark - UITableViewDelegate methods

- (UITableViewCell *)cellForRowAtIndexPath:(NSIndexPath *)indexPath withOrderItem:(OrderItem *)orderItem{
    
    //OrderItem* product = _appDelegate.selectedStore.cart.itemsArray[indexPath.row];
    CheckoutCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"CheckoutCell"];
    cell.productNameLabel.text =  orderItem.name;
    
    if (orderItem.quantity>1) {
        //cell.quantityLabel.text=[NSString stringWithFormat:@"%lix",(long)product.quantity];
        cell.productNameLabel.text = [NSString stringWithFormat:@"%lu %@",(long)orderItem.quantity, orderItem.name];
    }
    else{
        //cell.quantityLabel.text=nil;
        cell.productNameLabel.text = orderItem.name;
        
    }
    [cell.productNameLabel sizeToFit];
    NSString *priceLabel=@"";
    double  price=orderItem.price;
    if(price>0)
        priceLabel = [NSString stringWithFormat:@"%.2f",price/100*orderItem.quantity];
    //else
      //  cell.priceLabel.text=@"";
    NSString *discountLabel=@"";
    if(orderItem.discount>0){
        
        NSInteger discount=(orderItem.actualPrice-orderItem.price)*orderItem.quantity;
        //cell.discountLabel.text = [NSString stringWithFormat:@"Saved %.2f",(double)discount/100];
        //discountLabel=[NSString stringWithFormat:@"\nSaved %.2f",(double)discount/100];
        
        float f_discount=(float)discount/100;
        f_discount=(f_discount*100)/100;
        
        discountLabel=[NSString stringWithFormat:@"\nSaved %.2f",f_discount];
    }
    //else{
    //    cell.discountLabel.text=nil;
    //}
    
    cell.priceLabel.text =[priceLabel stringByAppendingString:discountLabel];
    [cell.priceLabel sizeToFit];
    
    //NSString *notes=@"";
    /*
    if ([orderItem.options count]>0){
        for(OrderOptionItem *ooi in orderItem.options){
            NSString *priceString= [NSString stringWithFormat:@"@%@",[Product priceToString:(double)ooi.addlCost/100 currency:nil]];
            //NSString *quantity=(orderItem.quantity>1)?[NSString stringWithFormat:@" @%@x",@(orderItem.quantity)]:@"";
            notes=[NSString stringWithFormat:@"%@%@    %@\n", notes,ooi.title,priceString];
        }
    }
    if(orderItem.notes.length>0){
        notes=[NSString stringWithFormat:@"%@ \"%@\"",notes,orderItem.notes];
    }
     */
    //if (orderItem.notes!=nil)
    cell.notesLabel.text=[orderItem notesLabel];//notes;//orderItem.notes;
    //else
      //  cell.notesLabel.text=nil;
    [cell.notesLabel sizeToFit];
    
    return cell;
}

- (UITableViewCell *)noNotesCellForRowAtIndexPath:(NSIndexPath *)indexPath withOrderItem:(OrderItem *)orderItem{
    
    //OrderItem* product = _appDelegate.selectedStore.cart.itemsArray[indexPath.row];
    CheckoutNoNotesCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"CheckoutNoNotesCell"];
    cell.productNameLabel.text =  orderItem.name;
    
    if (orderItem.quantity>1) {
        //cell.quantityLabel.text=[NSString stringWithFormat:@"%lix",(long)product.quantity];
        cell.productNameLabel.text = [NSString stringWithFormat:@"%lu %@",(long)orderItem.quantity, orderItem.name];
    }
    else{
        //cell.quantityLabel.text=nil;
        cell.productNameLabel.text = orderItem.name;
        
    }
    double  price=orderItem.price;
    cell.priceLabel.text = [NSString stringWithFormat:@"%.2f",price/100*orderItem.quantity];
    
    if(orderItem.discount>0){
        NSInteger discount=(orderItem.actualPrice-orderItem.price)*orderItem.quantity;
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
        OrderItem* orderItem = _appDelegate.selectedStore.cart.itemsArray[indexPath.row];
        if(orderItem.notes.length>0 || [orderItem.options count]>0){
            return [self cellForRowAtIndexPath:indexPath withOrderItem:orderItem];
        }
        else{
            return [self noNotesCellForRowAtIndexPath:indexPath withOrderItem:orderItem];
        }
    }
    
    else if(indexPath.section==1) {
        if (indexPath.row==0) {
          
        SubtotalCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"TotalCell"];
            cell.nameLabel.text=@"Subtotal";
        cell.totalLabel.text = [NSString stringWithFormat:@"%.2f", total_beforetax];//[NSString stringWithFormat:@"%.2f", (double)[_appDelegate.selectedStore.cart total]/100];
            
        return cell;
        }
        else if (indexPath.row==1) {
            
            SubtotalCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"TotalCell"];
            
            NSInteger total_discount=[_appDelegate.selectedStore.cart total_discount];
            //cell.totalLabel.text = [NSString stringWithFormat:@"%.2f", (double)[self.checkoutCart total_discount]/100];
            if(total_discount>0){
                cell.nameLabel.text=@"Total Saved";
                float f_total_discount=(double)total_discount/100;
                f_total_discount=(f_total_discount *100)/100;
            cell.totalLabel.text = [NSString stringWithFormat:@"%.2f", f_total_discount];//[NSString stringWithFormat:@"%.2f", (double)total_discount/100];
            }
            else{
                cell.nameLabel.text=nil;
                cell.totalLabel.text=nil;
            }
            cell.tag=1; //this will be use for heightforcell
            return cell;
        }
        else if (indexPath.row==2) { //tax
            
            SubtotalCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"TotalCell"];
            
            
            //float tax=[[_appDelegate.sale valueForKey:@"tax"] floatValue];
            cell.nameLabel.text=[NSString stringWithFormat:@"Tax %.2f%%",tax];
            cell.totalLabel.text = [NSString stringWithFormat:@"%.2f", tax_cost];//[NSString stringWithFormat:@"%.2f", (double)[_appDelegate.selectedStore.cart total_tax:[_appDelegate.selectedStore.cart total] tax:tax]/100 ];
            cell.tag=2; //this will be use for heightforcell
            return cell;
        }
        else if (indexPath.row==3) {
            
            SubtotalCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"TotalCell"];
            
            cell.nameLabel.text=[NSString stringWithFormat:@"Total"];
            cell.totalLabel.text = [NSString stringWithFormat:@"%@%.2f",_appDelegate.selectedStore.inventory.currencySymbol, total_aftertax];//[NSString stringWithFormat:@"%@%.2f",_appDelegate.selectedStore.inventory.currencySymbol, (double)[_appDelegate.selectedStore.cart grand_total:tax]/100];
            return cell;
        }
    }
    
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    //iphone
    if(indexPath.section==0){
        
        OrderItem* orderItem = _appDelegate.selectedStore.cart.itemsArray[indexPath.row];
        
        if(orderItem.notes.length>0 || [orderItem.options count]>0){
            //return [self cellForRowAtIndexPath:indexPath withOrderItem:orderItem];
            NSString *notesLabel=[orderItem notesLabel];
            CGSize bubbleSize = [AppDelegate sizeForText:notesLabel];
            if(bubbleSize.height>100){
                return 180+(bubbleSize.height-100);
            }
            else{
                return 180.0;
            }
        }
        else{
            //return [self noNotesCellForRowAtIndexPath:indexPath withOrderItem:orderItem];
            return 70.0;
        }
        
        
        
    }
    
    
    return 52.0;
    
}

/*
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CGFloat h=52.0;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        h=100.0;
    }
    
    
    if(indexPath.section==1 && indexPath.row==1){
        if( [self.checkoutCart total_discount]==0){
            h=0.0;
        }
    }
    return h;
}
*/
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
        [_appDelegate.selectedStore.cart removeItem:[_appDelegate.selectedStore.cart.itemsArray objectAtIndex:indexPath.row]];
        [self.tableView reloadData];
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    /*if([segue.identifier isEqualToString:@"toRWStripeViewController"]){
        _appDelegate.stripeController=segue.destinationViewController;
    }
     */
}

- (void)presentError:(NSError *)error {
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:nil
                                                      message:[error localizedDescription]
                                                     delegate:nil
                                            cancelButtonTitle:NSLocalizedString(@"OK", @"OK")
                                            otherButtonTitles:nil];
    [message show];
}

- (void)paymentSucceeded {
    [[[UIAlertView alloc] initWithTitle:@"Success!"
                                message:@"Payment successfully created!"
                               delegate:nil
                      cancelButtonTitle:nil
                      otherButtonTitles:@"OK", nil] show];
}

#pragma mark - Apple Pay
/*
 // ViewController.m
 
 PKPaymentRequest *request = [Stripe
 paymentRequestWithMerchantIdentifier:YOUR_APPLE_MERCHANT_ID];
 // Configure your request here.
 NSString *label = @"Premium Llama Food";
 NSDecimalNumber *amount = [NSDecimalNumber decimalNumberWithString:@"10.00"];
 request.paymentSummaryItems = @[
 [PKPaymentSummaryItem summaryItemWithLabel:label
 amount:amount]
 ];
 
 if ([Stripe canSubmitPaymentRequest:request]) {
 ...
 } else {
 // Show the user your own credit card form (see options 2 or 3)
 }
 
 */
//- (BOOL)applePayEnabled {
//    if ([PKPaymentRequest class]) {
//        /*
//         PKPaymentRequest *request = [Stripe
//         paymentRequestWithMerchantIdentifier:YOUR_APPLE_MERCHANT_ID];
//         // Configure your request here.
//         NSString *label = @"Premium Llama Food";
//         NSDecimalNumber *amount = [NSDecimalNumber decimalNumberWithString:@"10.00"];
//         request.paymentSummaryItems = @[
//         [PKPaymentSummaryItem summaryItemWithLabel:label
//         amount:amount]
//         ];
//         */
//        
//        PKPaymentRequest *paymentRequest = [Stripe paymentRequestWithMerchantIdentifier:APPLE_MERCHANTID];
//        //return [Stripe canSubmitPaymentRequest:paymentRequest];
//        // Configure your request here.
//        NSString *label = @"Premium Llama Food";
//        NSDecimalNumber *amount = [NSDecimalNumber decimalNumberWithString:@"10.00"];
//        paymentRequest.paymentSummaryItems = @[
//                                        [PKPaymentSummaryItem summaryItemWithLabel:label
//                                                                            amount:amount]
//                                        ];
//        
//        // ViewController.m
//        
//        if ([Stripe canSubmitPaymentRequest:paymentRequest]) {
//            UIViewController *paymentController;
////#if DEBUG
//            paymentController = [[STPTestPaymentAuthorizationViewController alloc]
//                                 initWithPaymentRequest:paymentRequest];
//            paymentController.delegate = self;
////#else
//            paymentController = [[PKPaymentAuthorizationViewController alloc]
//                                 initWithPaymentRequest:paymentRequest];
//            paymentController.delegate = self;
////#end
//            [self presentViewController:paymentController animated:YES completion:nil];
//        } else {
//            // Show the user your own credit card form (see options 2 or 3)
//        }
//        
//
//    }
//    return NO;
//}
- (BOOL)applePayEnabled {
    if ([PKPaymentRequest class]) {
        PKPaymentRequest *paymentRequest = [Stripe paymentRequestWithMerchantIdentifier:APPLE_MERCHANTID];
        return [Stripe canSubmitPaymentRequest:paymentRequest];
    }
    return NO;
}

- (IBAction)beginApplePay:(id)sender {
    self.applePaySucceeded = NO;
    self.applePayError = nil;
    
    NSString *merchantId = APPLE_MERCHANTID;
    
    PKPaymentRequest *paymentRequest = [Stripe paymentRequestWithMerchantIdentifier:merchantId];
    //if ([Stripe canSubmitPaymentRequest:paymentRequest]) {
        /*[paymentRequest setRequiredShippingAddressFields:PKAddressFieldPostalAddress];
        [paymentRequest setRequiredBillingAddressFields:PKAddressFieldPostalAddress];
        paymentRequest.shippingMethods = [self.shippingManager defaultShippingMethods];
    */
        //paymentRequest.paymentSummaryItems = [self summaryItemsForShippingMethod:paymentRequest.shippingMethods.firstObject];
    paymentRequest.paymentSummaryItems = [self summaryItemsForShippingMethod:nil];
/*#if DEBUG
        STPTestPaymentAuthorizationViewController *auth = [[STPTestPaymentAuthorizationViewController alloc] initWithPaymentRequest:paymentRequest];
#else*/
        PKPaymentAuthorizationViewController *auth = [[PKPaymentAuthorizationViewController alloc] initWithPaymentRequest:paymentRequest];
//#endif
        auth.delegate = self;
        [self presentViewController:auth animated:YES completion:nil];
    //}
}
/*
- (void)paymentAuthorizationViewController:(PKPaymentAuthorizationViewController *)controller
                  didSelectShippingAddress:(ABRecordRef)address
                                completion:(void (^)(PKPaymentAuthorizationStatus status, NSArray *shippingMethods, NSArray *summaryItems))completion {
    [self.shippingManager fetchShippingCostsForAddress:address
                                            completion:^(NSArray *shippingMethods, NSError *error) {
                                                if (error) {
                                                    completion(PKPaymentAuthorizationStatusFailure, nil, nil);
                                                    return;
                                                }
                                                completion(PKPaymentAuthorizationStatusSuccess,
                                                           shippingMethods,
                                                           [self summaryItemsForShippingMethod:shippingMethods.firstObject ]);
                                            }];
}
 */
-(void)paymentAuthorizationViewController:(PKPaymentAuthorizationViewController *)controller didSelectShippingAddress:(ABRecordRef)address completion:(void (^)(PKPaymentAuthorizationStatus, NSArray<PKShippingMethod *> * _Nonnull, NSArray<PKPaymentSummaryItem *> * _Nonnull))completion{
    
    [self.shippingManager fetchShippingCostsForAddress:address
                                            completion:^(NSArray *shippingMethods, NSError *error) {
                                                if (error) {
                                                    //completion(PKPaymentAuthorizationStatusFailure, nil, nil);
                                                    completion(PKPaymentAuthorizationStatusFailure,shippingMethods,shippingMethods.firstObject);
                                                    return;
                                                }
                                                completion(PKPaymentAuthorizationStatusSuccess,
                                                           shippingMethods,
                                                           [self summaryItemsForShippingMethod:shippingMethods.firstObject ]);
                                            }];
}

/*
- (void)paymentAuthorizationViewController:(PKPaymentAuthorizationViewController *)controller
                   didSelectShippingMethod:(PKShippingMethod *)shippingMethod
                                completion:(void (^)(PKPaymentAuthorizationStatus, NSArray *summaryItems))completion {
    completion(PKPaymentAuthorizationStatusSuccess, [self summaryItemsForShippingMethod:shippingMethod]);
}
*/

-(void)paymentAuthorizationViewController:(PKPaymentAuthorizationViewController *)controller didSelectShippingMethod:(PKShippingMethod *)shippingMethod completion:(void (^)(PKPaymentAuthorizationStatus, NSArray<PKPaymentSummaryItem *> * _Nonnull))completion{
    completion(PKPaymentAuthorizationStatusSuccess, [self summaryItemsForShippingMethod:shippingMethod]);
}


//- (NSArray *)summaryItemsForShippingMethod:(PKShippingMethod *)shippingMethod {
- (NSArray *)summaryItemsForShippingMethod:(PKShippingMethod *)shippingMethod {
   
    NSMutableArray *items=[NSMutableArray arrayWithCapacity:[_appDelegate.selectedStore.cart.itemsArray count]];
    /*PKPaymentSummaryItem *productItem;
    for(OrderItem* product in self.checkoutCart.productsInCart){

        productItem=nil;
        if(product.quantity>1)
            productItem = [PKPaymentSummaryItem summaryItemWithLabel:[NSString stringWithFormat:@"%d %@",product.quantity,product.name ] amount:[NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%f",product.price ]]];
        
        else if(product.quantity==1)
            productItem = [PKPaymentSummaryItem summaryItemWithLabel:[NSString stringWithFormat:@"%d %@",product.quantity,product.name ] amount:[NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%f",product.price ]]];
        
       
         if(productItem!=nil)
             [items addObject:productItem];
        

    
    }*/
    
    
    //NSDecimalNumber *total_summary=[NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%@",[self.checkoutCart total]]];
    //NSDecimalNumber *total_summary=[NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%f",total_aftertax]];
    total_charge=total_aftertax;
    
    if(shippingMethod)
        total_charge = total_charge+[shippingMethod.amount floatValue];//[total_summary decimalNumberByAdding:shippingMethod.amount];
    
    PKPaymentSummaryItem *totalItem = [PKPaymentSummaryItem summaryItemWithLabel:_appDelegate.selectedStore.peerInfo.peerID.displayName amount:[NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%f",total_charge]]];
    
    if(shippingMethod)
        [items addObject:shippingMethod];
    
    [items addObject:totalItem];
   return items;
        //return @[shirtItem, shippingMethod, totalItem];
}

- (void)paymentAuthorizationViewController:(PKPaymentAuthorizationViewController *)controller
                       didAuthorizePayment:(PKPayment *)payment
                                completion:(void (^)(PKPaymentAuthorizationStatus))completion {
    [[STPAPIClient sharedClient] createTokenWithPayment:payment
                                             completion:^(STPToken *token, NSError *error) {
#ifdef DEBUG
                                                 NSLog(@"createTokenWithPayment error: %@",error);
#endif
                                               [self createBackendChargeWithToken:token
                                                                         completion:^(STPBackendChargeResult status, NSError *error) {
                                                                             if (status == STPBackendChargeResultSuccess) {
                                                                                 self.applePaySucceeded = YES;
                                                                                 completion(PKPaymentAuthorizationStatusSuccess);
                                                                             } else {
                                                                                 self.applePayError = error;
                                                                                 completion(PKPaymentAuthorizationStatusFailure);
                                                                             }
                                                                         }];
                                             }];
}


- (void)paymentAuthorizationViewControllerDidFinish:(PKPaymentAuthorizationViewController *)controller {
    if (self.applePaySucceeded) {
        [self paymentSucceeded];
    } else if (self.applePayError) {
        [self presentError:self.applePayError];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
    self.applePaySucceeded = NO;
    self.applePayError = nil;
}

#pragma mark - Stripe Checkout

- (IBAction)beginStripeCheckout:(id)sender {
    /* //dont want to use this because it's web base, STPTestPaymentAuthorizationViewController
slow and we dont own the site
     
     STPCheckoutOptions *options = [[STPCheckoutOptions alloc] initWithPublishableKey:[Stripe defaultPublishableKey]];
    options.purchaseDescription = @"Cool Shirt";
    options.purchaseAmount = 1000; // this is in cents
    options.logoColor = [UIColor purpleColor];
    STPCheckoutViewController *checkoutViewController = [[STPCheckoutViewController alloc] initWithOptions:options];
    checkoutViewController.checkoutDelegate = self;
    [self presentViewController:checkoutViewController animated:YES completion:nil];
     */
    self.applePaySucceeded = NO;
    self.applePayError = nil;
    
    NSString *merchantId = APPLE_MERCHANTID;
    
    PKPaymentRequest *paymentRequest = [Stripe paymentRequestWithMerchantIdentifier:merchantId];
    //if ([Stripe canSubmitPaymentRequest:paymentRequest]) {
    /*[paymentRequest setRequiredShippingAddressFields:PKAddressFieldPostalAddress];
     [paymentRequest setRequiredBillingAddressFields:PKAddressFieldPostalAddress];
     paymentRequest.shippingMethods = [self.shippingManager defaultShippingMethods];
     */
    //paymentRequest.paymentSummaryItems = [self summaryItemsForShippingMethod:paymentRequest.shippingMethods.firstObject];
    paymentRequest.paymentSummaryItems = [self summaryItemsForShippingMethod:nil];
//#if DEBUG
   // STPTestPaymentAuthorizationViewController *auth = [[STPTestPaymentAuthorizationViewController alloc] initWithPaymentRequest:paymentRequest];
/*#else
    PKPaymentAuthorizationViewController *auth = [[PKPaymentAuthorizationViewController alloc] initWithPaymentRequest:paymentRequest];
#endif*/
   // auth.delegate = self;
    //[self presentViewController:auth animated:YES completion:nil];
    //}
}

- (void)checkoutController:(STPCheckoutViewController *)controller didCreateToken:(STPToken *)token completion:(STPTokenSubmissionHandler)completion {
    [self createBackendChargeWithToken:token completion:completion];
}

- (void)checkoutController:(STPCheckoutViewController *)controller didFinishWithStatus:(STPPaymentStatus)status error:(NSError *)error {
    switch (status) {
        case STPPaymentStatusSuccess:
            [self paymentSucceeded];
            break;
        case STPPaymentStatusError:
            [self presentError:error];
            break;
        case STPPaymentStatusUserCancelled:
            // do nothing
            break;
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Custom Credit Card Form

- (IBAction)beginCustomPayment:(id)sender {
    PaymentViewController *paymentViewController = [[PaymentViewController alloc] initWithNibName:nil bundle:nil];
    paymentViewController.amount = [NSDecimalNumber decimalNumberWithString:@"10.00"];
    //paymentViewController.backendCharger = self;
    paymentViewController.delegate = self;
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:paymentViewController];
    [self presentViewController:navController animated:YES completion:nil];
}

- (void)paymentViewController:(PaymentViewController *)controller didFinish:(NSError *)error {
    [self dismissViewControllerAnimated:YES completion:nil];
    if (error) {
        [self presentError:error];
    } else {
        [self paymentSucceeded];
    }
}

#pragma mark - STPBackendCharging

- (void)createBackendChargeWithToken:(STPToken *)token completion:(STPTokenSubmissionHandler)completion {
    if(token==nil){
        NSError *error = [NSError
                          errorWithDomain:StripeDomain
                          code:STPInvalidRequestError
                          userInfo:@{
                                     NSLocalizedDescriptionKey:@"Sorry, there was an error processing your request. Please enter a valid credit card."
                                     }];
        completion(STPBackendChargeResultFailure, error);
        
        
        return;
    }
    if(arrBckendChargeHandler==nil)
        arrBckendChargeHandler=[NSMutableArray new];
    
    //NSDictionary *chargeParams = @{ @"stripeToken": token.tokenId, @"amount": @"1000" };
    
    /*if (!BackendChargeURLString) {
        NSError *error = [NSError
                          errorWithDomain:StripeDomain
                          code:STPInvalidRequestError
                          userInfo:@{
                                     NSLocalizedDescriptionKey: [NSString stringWithFormat:@"Good news! Stripe turned your credit card into a token: %@ \nYou can follow the "
                                                                 @"instructions in the README to set up an example backend, or use this "
                                                                 @"token to manually create charges at dashboard.stripe.com .",
                                                                 token.tokenId]
                                     }];
        completion(STPBackendChargeResultFailure, error);
        return;
    }
    
    // This passes the token off to our payment backend, which will then actually complete charging the card using your Stripe account's secret key
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager POST:[BackendChargeURLString stringByAppendingString:@"/charge"]
       parameters:chargeParams
          success:^(AFHTTPRequestOperation *operation, id responseObject) { completion(STPBackendChargeResultSuccess, nil); }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) { completion(STPBackendChargeResultFailure, error); }];
     */
    [arrBckendChargeHandler addObject:[completion copy]];
    [self performCharge:token.tokenId];
    
    
}



-(void)performCharge:(NSString *)token{
    
    //BOOL isMultiPay=NO;
    
    //CheckoutCart* checkoutCart = [CheckoutCart sharedInstance];
    //totalCents = [[checkoutCart total] doubleValue] * 100;
    
    
    
    
    //2
    //CheckoutCart* checkoutCart = _appDelegate.selectedStore.cart;//[CheckoutCart sharedInstance];
   
    //totalCents =total_charge*100; //[[checkoutCart total] doubleValue] * 100;
    //confirmed_totalCents=totalCents;
    /*
    if(isMultiPay)
        [self showConfirmAmount];
    else{
        
        [self performStripeOperation];
    }*/
    
    //NSString* textLabel=[_appDelegate.selectedStore.cart textLabel:[_appDelegate.selectedStore.inventory_dict valueForKey:deviceNameKey] storeID:[_appDelegate.selectedStore.inventory_dict valueForKey:deviceIDKey]];
    
    NSString* textLabel=[_appDelegate.selectedStore.cart textLabel:_appDelegate.selectedStore.storeName storeID:_appDelegate.selectedStore.deviceID];
    
    //NSString *stripeAmount = [NSString stringWithFormat:@"%ld", (long)confirmed_totalCents];
    NSString *stripeCurrency = @"usd";
    //NSString *stripeToken = token;
    NSString *stripeDescription = textLabel;//@"Purchase from Portico iOS app!";
    
    
    
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSString *today=[dateFormatter stringFromDate:[NSDate date]];
    
    
    OrderHistory *order=[[OrderHistory alloc] init];
    order.chargeToken=token;
    order.orderBy=_appDelegate.appConfig.userInfo.fullName;//self.nameTextField.text;
    //TODO: order.orderTableNumber=self.tableNumberTextField.text;
    order.orderID=[[[NSUUID UUID] UUIDString] lowercaseString];
    order.orderNumber=@0;
    order.chargePayType=ORDER_PAY_TYPE_CCARD;
    //order.orderDetailText=textLabel;
    //get order items
    order.orderItems=_appDelegate.selectedStore.cart.itemsArray;
    
    order.orderDateTime=[NSDate date];
    order.orderDate=[dateFormatter dateFromString:today];
    order.orderDay=today;
    order.orderStatus=@ORDER_STATUS_START;
    order.orderStoreID=_appDelegate.selectedStore.peerInfo.deviceID;
    order.orderDeviceID=_appDelegate.appConfig.userInfo.deviceID;
    order.orderDeviceToken=_appDelegate.appConfig.userInfo.deviceToken;
    
    //order.orderTaxRate=_App
    order.orderAmountDue=totalCents;
    order.chargeAmount=confirmed_totalCents; //stripeAmount;
    order.chargeCurrency=stripeCurrency;
    order.chargeToken=token;
    order.chargeDescription=stripeDescription;
    
    
    //HistoryModel *historyModel=[HistoryModel sharedInstance];
    
    //[historyModel addHistory:today withOrder:order];
    [_appDelegate.historyModel addOrUpdateOrderHistory:order];
    NSDictionary *order_dict=[order toJSONDictionary];
    
    
    NSDictionary *card_info_dict=@{@"name":_appDelegate.appConfig.userInfo.selectedCard.name,
                                   @"email":(_appDelegate.appConfig.userInfo.email)?_appDelegate.appConfig.userInfo.email:@"", // self.stripeCard.email,
                                   @"number":_appDelegate.appConfig.userInfo.selectedCard.number,
                                   @"cvc":_appDelegate.appConfig.userInfo.selectedCard.cvc,
                                   @"expMonth":[NSNumber numberWithUnsignedInteger:_appDelegate.appConfig.userInfo.selectedCard.expMonth],
                                   @"expYear":[NSNumber numberWithUnsignedInteger:_appDelegate.appConfig.userInfo.selectedCard.expYear]};
    
    
    
    NSMutableDictionary *request_dict=[[NSMutableDictionary alloc] init];
    
    [request_dict setValue:KEY_ACTION_CHARGE forKey:KEY_ACTION];
    [request_dict setValue:@{KEY_CHARGE_CARDINFO:card_info_dict,KEY_CHARGE_ORDER:order_dict} forKey:KEY_ACTION_PARAM];
    [request_dict setValue:KEY_ACTION_TYPE_REQUEST forKey:KEY_ACTION_TYPE];
    
    NSError *error;
    
    NSData *jsonData=[NSJSONSerialization dataWithJSONObject:request_dict options:NSJSONWritingPrettyPrinted error:&error];
    
    if(error==nil){
        NSString *request=[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        //NSLog(@"reply=%@",reply);
        //[self sendMyMessage:reply withMessageType:MSG_TYPE_RESPONSE andLocalCopy:NO];
        
        BroadcastMessageAPI *message=[[BroadcastMessageAPI alloc] init];
        message.text=request;
        message.isBroadcast=NO;
        message.toPeerInfo=_appDelegate.selectedStore.peerInfo;
        message.message_type=MSG_TYPE_REQUEST;
        message.localCopy=NO;
        
        NSDictionary *dict = @{KEY_SEND_MESSAGE: message
                               };
        
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_HAS_DATA_TO_SEND
                                                            object:nil
                                                          userInfo:dict];
        //NSTimer *timer;
        //processTimer=[NSTimer scheduledTimerWithTimeInterval:30.0 target:self selector:@selector(chargeTimedOut:) userInfo:nil repeats:NO];
        //[processWait show];
        
    }
    else{
        //return;
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Error 100" message:@"There was an error processing your request. Please see attendant for help." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        
    }
    
}


-(void)backendChargeCompletion{
    if(arrBckendChargeHandler){
        STPTokenSubmissionHandler completion=[arrBckendChargeHandler firstObject];
        completion(STPBackendChargeResultSuccess, nil);
    }
}
/*
-(void)performChargeFail:(NSNotification *)notification{
    
    [self chargeDidNotSuceed];
}
 */
/*
-(void)performConnected:(NSNotification *)notification{
     dispatch_async(dispatch_get_main_queue(), ^{
    [self.cashPayButton setEnabled:YES];
    [self.creditcardPayButton setEnabled:YES];
     });
}
 */
-(void)performDisConnected:(NSNotification *)notification{
   //rom: disable bec of multiple connection support
    /*
    dispatch_async(dispatch_get_main_queue(), ^{
       [self.navigationController popToRootViewControllerAnimated:YES];
    });
    
   */
    
}

-(void)performChargeSuccess:(NSNotification *)notification{
    OrderHistory *order=(OrderHistory *)[notification.userInfo valueForKey:@"order"];
    StoreHistory *store=[_appDelegate.historyModel storeWithStoreID:order.orderStoreID];
    if(store==nil)
        return;
    
    if(arrBckendChargeHandler){
        STPTokenSubmissionHandler completion=[arrBckendChargeHandler firstObject];
        completion(STPBackendChargeResultSuccess, nil);
    }
    [self chargeDidSucceed:order withStore:store];
    
}

- (void)chargeDidNotSuceed {
    /*if(processTimer)
        [processTimer invalidate];
    [processWait dismissWithClickedButtonIndex:0 animated:YES];
    //2
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Payment not successful"
                                                    message:@"Please try again later."
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
     */
    if(arrBckendChargeHandler){
        STPTokenSubmissionHandler completion=[arrBckendChargeHandler firstObject];
        completion(STPBackendChargeResultFailure, nil);
    }
    
}
- (void)chargeDidSucceed:(OrderHistory *)order withStore:(StoreHistory *)store{
   // if(processTimer)
    //    [processTimer invalidate];
    //[processWait dismissWithClickedButtonIndex:0 animated:YES];
    /*
    CheckoutCart* checkoutCart = [CheckoutCart sharedInstance];
    [checkoutCart clearCart];
    
    UITabBarItem *tbi=(UITabBarItem *)[self.tabBarController.tabBar.items objectAtIndex:TAB_INDEX_CART];
    
    tbi.badgeValue=nil;
    */
    
    
    [_appDelegate clearCart];
    
    BroadcastMessageAPI *m=[[BroadcastMessageAPI alloc] init];
    m.sender=_appDelegate.selectedStore.peerInfo.peerID.displayName;
    m.peerInfo=_appDelegate.selectedStore.peerInfo;
    m.fromDeviceID=_appDelegate.selectedStore.peerInfo.deviceID;
    
    if (order.orderAmountDue>0) {
        /*UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"Your order# %@",order.orderNumber]
                                                        message:[NSString stringWithFormat:@"Amount Due: %.02f",[order.orderAmountDue doubleValue]/100]
                                                       delegate:nil
                                              cancelButtonTitle:nil
                                              otherButtonTitles:BTN_CASH,BTN_CCARD, nil];
        alert.tag=TAG_CHARGE_SUCCESS;
        [alert show];
         */
        float amountdue=order.orderAmountDue/100;
        m.text=[NSString stringWithFormat:@"Your order# %@. Amount Due: %.02f",order.orderNumber,amountdue];
        
            }
    else{
        
        
        
        /*UIAlertView *alert =  [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"Your order# %@",order.orderNumber]
                                                         message: @"Completed!"
                                                        delegate:nil
                                               cancelButtonTitle:@"OK"
                                               otherButtonTitles:nil];
        
        
        [alert show];
         */
        m.text=[NSString stringWithFormat:@"Your order# %@\nYou will be notified when READY for pick-up.",order.orderNumber];
        
        
    }

    
    //[_appDelegate addNewMessage:m];
    [store addNewMessage:m];
    [self.navigationController popToRootViewControllerAnimated:YES];
    [self.tabBarController setSelectedIndex:TAB_INDEX_CHAT];
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_UPDATE_MESSAGES object:nil];

    
    
    //Send confirmation email
    /*RWEmailManager* emailManager = [[RWEmailManager alloc] initWithRecipient:self.nameTextField.text
     recipientEmail:self.emailTextField.text];
     
     [emailManager sendConfirmationEmail];
     */
    
    
    
}

-(void)emptyCart{
    //self.navigationItem.rightBarButtonItem=nil;
    //[self.checkoutCart clearCart];
    [_appDelegate clearCart];
    
    [self.tableView reloadData];
    //[self.tableView setHidden:YES];
}

//  [[self.creditcardPayButton layer] setBorderColor:self.creditcardPayButton.titleLabel.textColor.CGColor];
//[[self.cashPayButton
- (IBAction)creditcardPayButtonTapped:(id)sender {
    if(!_appDelegate.selectedStore.isConnected){
        [AppDelegate toast:@"Please connect to continue." duration:3.0];
        return;
    }
    /*if(_appDelegate.appConfig.isLive){
        if([_appDelegate.appConfig.userInfo.ccards count]>0){
            
            CCardInfo *defaultCard=nil;//[_appDelegate.appConfig.userInfo.ccards objectAtIndex:0];
            for (CCardInfo *c in _appDelegate.appConfig.userInfo.ccards) {
                if(c.isDefault){
                    defaultCard=c;
                    break;
                }
            }
            if(defaultCard!=nil){
            
                [self performSegueWithIdentifier:@"toRWStripeViewController" sender:self];
            }
            else{
                UIAlertView *alert=[[UIAlertView alloc] initWithTitle:nil message:@"You haven't setup a default card to use." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Continue", nil];
                [alert show];
                
            }
        }
        else{
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:nil message:@"You haven't setup a default card to use." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Continue", nil];
            [alert show];

            
            
        }
    }
    else{*/
    //if([_appDelegate isConnectedToStore:_appDelegate.selectedStore.cart.currentStoreID]){
        //check if cart belongs to connectd store
        //CheckoutCart *cart= [CheckoutCart sharedInstance];
        //if(cart.)
        [self performSegueWithIdentifier:@"toRWStripeViewController" sender:self];
    /*}
    else{
        if(_appDelegate.mcManager.serverPeerInfo!=nil && _appDelegate.selectedStore.peerInfo.sessionState==MCSessionStateConnected){
            
            BroadcastMessageAPI *m=[[BroadcastMessageAPI alloc] init];
            m.sender=_appDelegate.selectedStore.peerInfo.peerID.displayName;
            m.peerInfo=_appDelegate.mcManager.serverPeerInfo;
            m.fromDeviceID=_appDelegate.selectedStore.peerInfo.deviceID;
            
            
            
            //m.text=@"Sorry the items in your cart does not belong to us. You may clear the cart and start shopping.";
            m.text=[NSString stringWithFormat:@"Sorry the items in your cart does not belong to %@. You may clear the cart and start shopping.",_appDelegate.selectedStore.peerInfo.peerID.displayName];
            [_appDelegate addNewMessage:m];
            
            self.tabBarController.selectedIndex=TAB_INDEX_CHAT;
            
        }
        else{
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Please connect to continue." message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
                                }
        
    }
*/
    //}
}
- (IBAction)cashPayButtonTapped:(id)sender {
    //if([_appDelegate isConnectedToStore:self.checkoutCart.currentStoreID]){
        //check if cart belongs to connectd store
        //CheckoutCart *cart= [CheckoutCart sharedInstance];
        //if(cart.)
       [self performSegueWithIdentifier:@"toPayCashViewController" sender:self];
    /*}
    else{
        if(_appDelegate.mcManager.serverPeerInfo!=nil && _appDelegate.selectedStore.peerInfo.sessionState==MCSessionStateConnected){
            
            BroadcastMessageAPI *m=[[BroadcastMessageAPI alloc] init];
            m.sender=_appDelegate.selectedStore.peerInfo.peerID.displayName;
            m.peerInfo=_appDelegate.mcManager.serverPeerInfo;
            m.fromDeviceID=_appDelegate.selectedStore.peerInfo.deviceID;
            
            
            
            m.text=[NSString stringWithFormat:@"Sorry the items in your cart does not belong to %@. You may clear the cart and start shopping.",_appDelegate.selectedStore.peerInfo.peerID.displayName];
            
            [_appDelegate addNewMessage:m];
            self.tabBarController.selectedIndex=TAB_INDEX_CHAT;
        }
        else{
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Please connect to continue." message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
        
    }
    */
    
}

-(void)didReceiveMenuWithNotification:(NSNotification *)notification{
    
     //dispatch_async(dispatch_get_main_queue(), ^{
         /*CheckoutCart *cart=[CheckoutCart sharedInstance];
         [cart cleanCart:_appDelegate.selectedStore.peerInfo.deviceID isLive:_appDelegate.appConfig.isLive withInventory:_appDelegate.selectedStore.inventory];*/
    // [self.tableView reloadData];
     [self reloadData];
     //});
     
    //[self.navigationController popViewControllerAnimated:YES];
}

-(void)didReceiveMenuSettingsWithNotification:(NSNotification *)notification{
    
    //CheckoutCart *cart=[CheckoutCart sharedInstance];
    //[cart cleanCart:_appDelegate.selectedStore.peerInfo.deviceID isLive:_appDelegate.appConfig.isLive withInventory:_appDelegate.selectedStore.inventory];
    [self reloadData];

    
}

-(void)reloadData{
    if(_appDelegate.selectedStore.cart==nil)
        _appDelegate.selectedStore.cart= [CheckoutCart new];
    
   // [_checkoutCart cleanCart:_appDelegate.selectedStore.peerInfo.deviceID isLive:_appDelegate.appConfig.isLive withInventory:_appDelegate.selectedStore.inventory];
    
    if([_appDelegate.selectedStore.cart.itemsArray count]>0){
        self.navigationItem.rightBarButtonItem=emptyCartButton;
    }
    else{
        self.navigationItem.rightBarButtonItem=nil;
    }
    
    tax=0.0;
    
    tax=_appDelegate.selectedStore.inventory.salesTax;
    
    
    shipping_cost=_appDelegate.selectedStore.inventory.shippingCost;
    
    
    
    
    self.shippingManager = [[ShippingManager alloc] init];
    BOOL bool_applePayEnabled =[self applePayEnabled];
    self.applePayButton.enabled =bool_applePayEnabled;
    
    //self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"My Creditcards" style:UIBarButtonItemStyleBordered target:self action:@selector(showMyCreditCards)];
    
    //calculate payment
    /*
     float f_subtotal=(float)subtotal/100;
     f_subtotal=round(f_subtotal*100)/100;
     
     //totaltax=subtotal*(self.orderTax/100);
     float f_tax=(float)self.orderTax/100;
     f_tax=round(f_tax*100)/100;
     
     float f_totaltax=f_subtotal*f_tax;
     f_totaltax=round(f_totaltax*100)/100;
     totaltax=f_totaltax*100;
     self.orderTotalTax=totaltax;

     */
    total_beforetax=(float)[_appDelegate.selectedStore.cart total]/100 ;
    total_beforetax=round(total_beforetax*100)/100;
    float f_tax=(float)tax/100;
    
    f_tax=round(f_tax*100)/100;
    
    tax_cost=total_beforetax*(f_tax);//tax_cost=total_beforetax*(tax/100); //[self.checkoutCart total_tax:tax_rate] ;
    tax_cost=round(tax_cost*100)/100;
    
    
    total_aftertax = total_beforetax+tax_cost;//[self.checkoutCart grand_total:tax_rate];
    
    total_aftertax=(total_aftertax*100)/100;
    
    //self.tableView.frame=[AppDelegate maximumUsableFrame:self];
    
    
    
    if([_appDelegate.selectedStore.cart.itemsArray count ]==0){
        [self.tableView setHidden:YES];
        
    }
    else{
        [self.tableView setHidden:NO];
        [self.tableView reloadData];
    }
    
    
    [self.cashPayButton setHidden:!_appDelegate.selectedStore.inventory.acceptCash];
    
    
    
    [self.creditcardPayButton setHidden:!_appDelegate.selectedStore.inventory.acceptCCard];
    
    [self.tableView reloadData];
}


@end
