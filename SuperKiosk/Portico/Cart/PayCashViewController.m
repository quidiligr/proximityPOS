//
//  PaymentViewController.m

#import "PayCashViewController.h"
#import "CheckoutCart.h"
#import "RWEmailManager.h"

#import "CheckoutInputCell.h"
#import "CheckoutDisplayCell.h"

#import "HistoryModel.h"

#import "OrderHistory.h"

#import "BroadcastMessageAPI.h"

#import <AFNetworking/AFNetworking.h>


//#import "Stripe.h"
#import "AppDelegate.h"
#import "defs.h"
//#define STRIPE_TEST_PUBLIC_KEY @"pk_test_U9L4e6hqciFT1nGyluOmKKTu"

//#define STRIPE_TEST_POST_URL @""

@interface PayCashViewController () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UIAlertViewDelegate>{
    CCardInfo *selectedCard;
}

@property (strong, nonatomic) IBOutlet UITableView* tableView;
@property (strong, nonatomic) IBOutlet UIView* buttonView;
@property (strong, nonatomic) IBOutlet UIButton* completeButton;

@property (strong, nonatomic) UITextField* nameTextField;
@property (strong, nonatomic) UITextField* emailTextField;
@property (strong, nonatomic) UITextField* tableNumberTextField;
@property (strong, nonatomic) UITextField* promoCodeTextField;

@property (strong, nonatomic) AFJSONRequestOperation* httpOperation;
//@property (strong, nonatomic) STPCard* stripeCard;

@property (nonatomic, strong) AppDelegate *appDelegate;
@end

@implementation PayCashViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor=[UIColor clearColor];
	// Do any additional setup after loading the view.
    _appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
 //   self.monthArray = @[@"01 - January", @"02 - February", @"03 - March",
//    @"04 - April", @"05 - May", @"06 - June", @"07 - July", @"08 - August", @"09 - September",
 //   @"10 - October", @"11 - November", @"12 - December"];
    
    
     [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(performChargeSuccess:)
                                                 name:NOTIFY_CHARGE_SUCCESS_CASH
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(performChargeFail:)
                                                 name:NOTIFY_CHARGE_FAIL_CASH
                                               object:nil];
    self.tableView.frame=[AppDelegate maximumUsableFrame:self];
    selectedCard=[CCardInfo new];
    selectedCard.name=_appDelegate.appConfig.userInfo.displayName;
    //selectedCard.name=_appDelegate.appConfig.userInfo.email;
    
    
}


-(void)viewDidAppear:(BOOL)animated{
    //test only
    [_nameTextField setText:_appDelegate.appConfig.userInfo.displayName];
    //[_emailTextField setText:@"rquidilig@gmail.com"];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Stripe

- (IBAction)completeButtonTapped:(id)sender {
    //CheckoutCart* checkoutCart = [CheckoutCart sharedInstance];
    /*
    if(![_appDelegate isConnectedToStore:checkoutCart.currentStoreID]){
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Please connect to continue." message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }
*/
   /*
    selectedCard.name= self.nameTextField.text;
    
 
    [self performPayCashOperation];
*/
    NSArray *existing=[_appDelegate.historyModel searchUnpaidOrdersWithStore:_appDelegate.selectedStore isLive:_appDelegate.appConfig.isLive];
    if(_appDelegate.selectedStore.inventory.maxUnpaidOrdersPerCustomer>0 && _appDelegate.selectedStore.inventory.maxUnpaidOrdersPerCustomer<=[existing count]){
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"Maximum %lu Unpaid orders exceeded",(unsigned long)[existing count] ] message:@"Please pay or cancel one or more Unpaid orders then try again." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        //[AppDelegate toast:[NSString stringWithFormat:@"You have %i UNPAID. Please pay or cancel pending order and try again.",[existing count]] duration:5];
        [alert show];
        return;
    }
   OrderHistory *order= [self createOrderFromCart];
    
    
    UITabBarItem *tbi=(UITabBarItem *)[self.tabBarController.tabBar.items objectAtIndex:TAB_INDEX_CART];
    
    tbi.badgeValue=nil;
    
    
    /*tbi=(UITabBarItem *)[self.tabBarController.tabBar.items objectAtIndex:TAB_INDEX_INVENTORY];
    
    if(tbi.badgeValue==nil)
        tbi.badgeValue=@"1";
    else
        tbi.badgeValue=[NSString stringWithFormat:@"%d",[tbi.badgeValue integerValue]+1];
     */
    
    //HistoryModel *historyModel=[HistoryModel sharedInstance];
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_NEW_ORDER object:nil userInfo:@{@"order":order}];
    
    [self.navigationController popToRootViewControllerAnimated:YES];
    
    [self.tabBarController setSelectedIndex:TAB_INDEX_CHAT];
   // [_appDelegate.orderChatViewController.navigationController popToRootViewControllerAnimated:NO];
    
}


-(OrderHistory *)createOrderFromCart{

    
    //1
    self.completeButton.enabled = NO;
    
   
    //CheckoutCart* checkoutCart = [CheckoutCart sharedInstance];
    
    double tax=_appDelegate.selectedStore.inventory.salesTax;
    
    NSInteger totalCents = [_appDelegate.selectedStore.cart grand_total:tax];//_appDelegate.selectedStore.peerInfo.salesTax] ;
  
    NSInteger chargeAmount = totalCents;
    
    
    NSString *chargeCurrency = (_appDelegate.selectedStore.inventory.currency.length==0)?@"usd":_appDelegate.selectedStore.inventory.currency;
   
    //NSString *chargeDescription = [checkoutCart textLabel];//@"Purchase from Portico iOS app!";
    
    
      
        NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        
        NSString *today=[dateFormatter stringFromDate:[NSDate date]];
                OrderHistory *order=[[OrderHistory alloc] init];
        order.chargePayType=ORDER_PAY_TYPE_CASH;
        order.orderBy=self.nameTextField.text;
        order.orderTableNumber=self.tableNumberTextField.text;
    order.orderDiscountCode=self.promoCodeTextField.text;
    
        order.orderID=[[[NSUUID UUID] UUIDString] lowercaseString];
        order.orderNumber=@0;
    
    order.orderStoreID=_appDelegate.selectedStore.deviceID;
    order.orderStoreNum=_appDelegate.selectedStore.storeNum;
    order.orderStoreName=_appDelegate.selectedStore.storeName;

        order.orderIsLive=_appDelegate.appConfig.isLive;
    
    
        order.orderTax=tax;
        order.orderAmountDue=chargeAmount;
        order.chargeAmount=chargeAmount;
        order.chargeCurrency=chargeCurrency;
    
        order.orderItems=[NSArray arrayWithArray:_appDelegate.selectedStore.cart.itemsArray];

        order.orderDateTime=[NSDate date];
        order.orderDay=today;
        order.orderDate=[dateFormatter dateFromString:today];
        order.orderStatus=@ORDER_STATUS_START; //pending
    
   
    order.orderBy=(_appDelegate.appConfig.userInfo.displayName==nil || _appDelegate.appConfig.userInfo.displayName.length==0)?@"Unknown":_appDelegate.appConfig.userInfo.displayName;
    
        //HistoryModel *historyModel=[HistoryModel sharedInstance];
        
        //[historyModel addOrUpdateOrderHistory:order];
    [_appDelegate.historyModel addOrUpdateOrderHistory:order];
    //[checkoutCart clearCart];
    [_appDelegate clearCart];
    return order;
}




//-(void)addHistory:(NSString *)withOrderText andOrderStatus:(NSNumber *)status{
//    //add to order history
//    /*NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
//    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
//    
//    NSString *today=[dateFormatter stringFromDate:[NSDate date]];
//    */
//    HistoryModel *historyModel=[HistoryModel sharedInstance];
//    
//    
//    
//    
//    NSMutableArray *todaysHistory=[historyModel.history valueForKey:today];
//    
//    OrderHistory *item=[[OrderHistory alloc] init];
//    item.orderDetailText=withOrderText;
//    item.orderDateTime=[NSDate date];
//    item.orderDate=[dateFormatter dateFromString:today];
//    item.orderStatus=status; //unpaid
//    item.orderStoreID=_appDelegate.selectedStore.peerInfo.deviceID;
//    
//    //[todaysHistory addObject:item];
//    
//    //[historyModel saveHistory];
//    [historyModel addHistory:item];
//}
/*
- (void)postStripeToken:(NSString* )token {
    NSString *STRIPE_TEST_POST_URL=[NSString stringWithFormat:@"%@stripe", _appDelegate.selectedStore.peerInfo.homeUrl];
    
    NSURL *postURL = [NSURL URLWithString:STRIPE_TEST_POST_URL];
    
    //2
    CheckoutCart* checkoutCart = [CheckoutCart sharedInstance];
    NSInteger totalCents = [[checkoutCart total] doubleValue] * 100;
    NSString* textLabel=[checkoutCart textLabel];
    //3
    
    NSError* err = nil;
    
    NSString *stripeAmount = [NSString stringWithFormat:@"%ld", (long)totalCents];
    NSString *stripeCurrency = @"usd";
    NSString *stripeToken = token;
    NSString *stripeDescription = @"Purchase from Portico iOS app!";

    
    NSString *requestString=[NSString stringWithFormat:@"stripeAmount=%@&stripeCurrency=%@&stripeToken=%@&stripeDescription=%@",stripeAmount,stripeCurrency,stripeToken,stripeDescription];
    
    NSData *requestData=[NSData dataWithBytes:[requestString UTF8String] length:[requestString length]];
    
    NSMutableURLRequest *postRequest=[[NSMutableURLRequest alloc] initWithURL:postURL];
    
    [postRequest setHTTPMethod:@"POST"];
    
    
    //[postRequest setValue:STRIPE_API_KEY forHTTPHeaderField:@"Authorization"];
    [postRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"content-type"];
    
   // [postRequest setValue:@"text/json" forHTTPHeaderField:@"Accept"];
    
    
    
    [postRequest setHTTPBody:requestData];
    
    NSURLResponse *response;
    //NSError *err;
    NSData *jsonData=[NSURLConnection sendSynchronousRequest:postRequest returningResponse:&response error:&err];
    
    //we will use json instead: NSString *content=[NSString stringWithUTF8String:[jsonData bytes]];
    
    NSDictionary *JSON = [NSJSONSerialization JSONObjectWithData:jsonData
                                                         options:kNilOptions
                                                           error:&err];
    
    if(err==nil){
        //chargeDidSucceed
        //  NSDictionary *menu_dict=@{@"stripeAmount":stripeAmount,@"stripeCurrency":stripeCurrency,@"stripeToken":stripeToken,@"stripeDescription":stripeDescription};
        //NSString *data=[NSString stringWithFormat:@"%@"];
        NSDictionary *dict = @{ @"data": textLabel
                                //,@"peerID": peerID
                                };
        [[NSNotificationCenter defaultCenter] postNotificationName:@"MCDidReceiveOrderNotification"
                                                            object:nil
                                                          userInfo:dict];
        
        [self chargeDidSucceed];
    }
    else{
        [self chargeDidNotSuceed];
    }
    
    
}
*/
//- (void)postStripeToken__:(NSString* )token {
//    
//    //1
//    NSString *STRIPE_TEST_POST_URL=_appDelegate.selectedStore.peerInfo.homeUrl;
//    
//    NSURL *postURL = [NSURL URLWithString:STRIPE_TEST_POST_URL];
//    
//    AFHTTPClient* httpClient = [AFHTTPClient clientWithBaseURL:postURL];
//    
//    httpClient.parameterEncoding = AFJSONParameterEncoding;
//    [httpClient registerHTTPOperationClass:[AFJSONRequestOperation class]];
//    [httpClient setDefaultHeader:@"Accept" value:@"text/json"];
//    
//    //2
//    CheckoutCart* checkoutCart = [CheckoutCart sharedInstance];
//    NSInteger totalCents = [[checkoutCart total] doubleValue] * 100;
//    
//    //3
//    NSMutableDictionary* postRequestDictionary = [[NSMutableDictionary alloc] init];
//    postRequestDictionary[@"stripeAmount"] = [NSString stringWithFormat:@"%ld", (long)totalCents];
//    postRequestDictionary[@"stripeCurrency"] = @"usd";
//    postRequestDictionary[@"stripeToken"] = token;
//    postRequestDictionary[@"stripeDescription"] = @"Purchase from Kiosk iOS app!";
//    
//    //4
//    NSMutableURLRequest* request = [httpClient requestWithMethod:@"POST" path:@"/stripe" parameters:postRequestDictionary];
//    
//    self.httpOperation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
//        [self chargeDidSucceed];
//    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
//        [self chargeDidNotSuceed];
//    }];
//    
//    [self.httpOperation start];
//    
//    self.completeButton.enabled = YES;
//}


- (void)chargeDidSucceed:(OrderHistory *)order{
    // if(processTimer)
    //    [processTimer invalidate];
    //[processWait dismissWithClickedButtonIndex:0 animated:YES];
    /*
    CheckoutCart* checkoutCart = [CheckoutCart sharedInstance];
    [checkoutCart clearCart];
    
    UITabBarItem *tbi=(UITabBarItem *)[self.tabBarController.tabBar.items objectAtIndex:TAB_INDEX_CART];
    
    tbi.badgeValue=nil;
    */
    StoreHistory *store=[_appDelegate.historyModel storeWithStoreID:order.orderStoreID];
    [_appDelegate clearCart];
    BroadcastMessageAPI *m=[[BroadcastMessageAPI alloc] init];
    m.sender=_appDelegate.selectedStore.peerInfo.peerID.displayName;
    m.fromDeviceID=_appDelegate.selectedStore.peerInfo.deviceID;
    m.peerInfo=_appDelegate.selectedStore.peerInfo;
    m.createdon=order.orderDateTime;
    
    if (order.orderAmountDue>0) {
       
        double orderAmountDue =order.orderAmountDue;
        m.text=[NSString stringWithFormat:@"Your order# %@\nAmount Due: %.02f\nPlease pay cashier to complete this order.",order.orderNumber,orderAmountDue/100];
        
    }
    else{
        
        
        
       
        m.text=[NSString stringWithFormat:@"Your order# %@",order.orderNumber];
        
        
    }
   
    [store addNewMessage:m];
    [self.navigationController popToRootViewControllerAnimated:YES];
   
   
    [self.tabBarController setSelectedIndex:TAB_INDEX_CHAT];
     //[_appDelegate.orderChatViewController.navigationController popToRootViewControllerAnimated:NO];
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_UPDATE_MESSAGES object:nil];
    
    
    
       
    
}

- (void)chargeDidNotSuceed {
    //2
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Order not successful"
                                                    message:@"Please try again later."
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}


/* The methods below implement the user interface. You don't need to change anything. */

#pragma mark - UITableViewDataSource methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;//2; // (1) user details, (2) credit card details
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"Customer Info";//(section == 0) ? @"Customer Info" : @"Credit Card Details";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //return (section == 0) ? 3 : 3;
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    /*
    if (section == 0 && row == 0) {
     
        CheckoutDisplayCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"CheckoutDisplayCell"];
        cell.nameLabel.text = @"Name";

        cell.displayLabel.text=_appDelegate.appConfig.userInfo.fullName;

        
        return cell;
    }
     */
    //rom added for table/seat#
    if (section == 0 && row == 0) {
        CheckoutInputCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"CheckoutInputCell"];
        cell.nameLabel.text = @"Table/Seat#";
        cell.textField.placeholder = @"";
        self.tableNumberTextField = cell.textField;
        cell.textField.keyboardType = UIKeyboardTypeDefault;
        return cell;
    }
    else if (section == 0 && row == 1) {
        CheckoutInputCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"CheckoutInputCell"];
        cell.nameLabel.text = @"Promo code";
        cell.textField.placeholder = @"";
        cell.textField.placeholder = _appDelegate.appConfig.userInfo.email;
        self.promoCodeTextField = cell.textField;
        cell.textField.keyboardType = UIKeyboardTypeDefault;
        return cell;
    }
    /*else if (section == 0 && row == 2) {
        CheckoutInputCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"CheckoutInputCell"];
        cell.nameLabel.text = @"E-mail";
         cell.textField.placeholder = _appDelegate.appConfig.userInfo.email;
        self.emailTextField = cell.textField;
        cell.textField.keyboardType = UIKeyboardTypeAlphabet;
        return cell;
    }
    */
    /*
    else if (section == 1 && row == 0) {
        CheckoutInputCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"CheckoutInputCell"];
        cell.nameLabel.text = @"Card Number";
        cell.textField.placeholder = @"Required";
        cell.textField.keyboardType = UIKeyboardTypeNumberPad;
        self.cardNumber = cell.textField;
        return cell;
    }
    else if (section == 1 && row == 1) {
        CheckoutInputCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"CheckoutInputCell"];
        cell.nameLabel.text = @"Exp. Date";
        cell.textField.text = @"Required";
        cell.textField.textColor = [UIColor lightGrayColor];
        self.expirationDateTextField = cell.textField;
        return cell;
    }
    else if (section == 1 && row == 2) {
        CheckoutInputCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"CheckoutInputCell"];
        cell.nameLabel.text = @"CVC Number";
        cell.textField.placeholder = @"Required";
        self.CVCNumber = cell.textField;
        cell.textField.keyboardType = UIKeyboardTypeNumberPad;
        [self configurePickerView];
        return cell;
    }
    */
    return nil;
}

#pragma mark - UITableViewDelegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

}

#pragma mark - UIPicker data source

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return (component == 0) ? 12 : 10;
}

#pragma mark - UIPicker delegate

/*- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    if (component == 0) {
        //Expiration month
        return self.monthArray[row];
    }
    else {
        //Expiration year
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy"];
        NSInteger currentYear = [[dateFormatter stringFromDate:[NSDate date]] integerValue];
        return [NSString stringWithFormat:@"%i", currentYear + row];
    }
    
    return nil;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    if (component == 0) {
        self.selectedMonth = @(row + 1);
    }
    else {
        NSString *yearString = [self pickerView:self.expirationDatePicker titleForRow:row forComponent:1];
        self.selectedYear = @([yearString integerValue]);
    }
    
    
    if (!self.selectedMonth) {
        [self.expirationDatePicker selectRow:0 inComponent:0 animated:YES];
        self.selectedMonth = @(1); //Default to January if no selection
    }
    
    if (!self.selectedYear) {
        [self.expirationDatePicker selectRow:0 inComponent:1 animated:YES];
        NSString *yearString = [self pickerView:self.expirationDatePicker titleForRow:0 forComponent:1];
        self.selectedYear = @([yearString integerValue]); //Default to current year if no selection
    }
    
    self.expirationDateTextField.text = [NSString stringWithFormat:@"%@/%@", self.selectedMonth, self.selectedYear];
    self.expirationDateTextField.textColor = [UIColor blackColor];
}

#pragma mark - UIPicker configuration

- (void)configurePickerView {
    self.expirationDatePicker = [[UIPickerView alloc] init];
    self.expirationDatePicker.delegate = self;
    self.expirationDatePicker.dataSource = self;
    self.expirationDatePicker.showsSelectionIndicator = YES;
    
    //Create and configure toolabr that holds "Done button"
    UIToolbar *pickerToolbar = [[UIToolbar alloc] init];
    pickerToolbar.barStyle = UIBarStyleDefault;
    [pickerToolbar sizeToFit];
    
    UIBarButtonItem *flexibleSpaceLeft = [[UIBarButtonItem alloc]
                                          initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                          target:nil
                                          action:nil];
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                   style:UIBarButtonItemStyleBordered
                                                                  target:self
                                                                  action:@selector(pickerDoneButtonPressed)];
    
    [pickerToolbar setItems:[NSArray arrayWithObjects:flexibleSpaceLeft, doneButton, nil]];
    
    
    self.expirationDateTextField.inputView = self.expirationDatePicker;
    self.expirationDateTextField.inputAccessoryView = pickerToolbar;
    self.nameTextField.inputAccessoryView = pickerToolbar;
    self.emailTextField.inputAccessoryView = pickerToolbar;
    self.cardNumber.inputAccessoryView = pickerToolbar;
    self.CVCNumber.inputAccessoryView = pickerToolbar;
}

- (void)pickerDoneButtonPressed {
    [self.view endEditing:YES];
}
 */
-(void)performChargeFail:(NSNotification *)notification{
    [self chargeDidNotSuceed];
}
-(void)performChargeSuccess:(NSNotification *)notification{
    
    //[self chargeDidSucceed];
    OrderHistory *order=(OrderHistory *)[notification.userInfo valueForKey:@"order"];
    [self chargeDidSucceed:order];
}

- (void)configurePickerView {
    /*self.expirationDatePicker = [[UIPickerView alloc] init];
     self.expirationDatePicker.delegate = self;
     self.expirationDatePicker.dataSource = self;
     self.expirationDatePicker.showsSelectionIndicator = YES;
     */
    //Create and configure toolabr that holds "Done button"
    UIToolbar *pickerToolbar = [[UIToolbar alloc] init];
    pickerToolbar.barStyle = UIBarStyleDefault;
    [pickerToolbar sizeToFit];
    
    UIBarButtonItem *flexibleSpaceLeft = [[UIBarButtonItem alloc]
                                          initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                          target:nil
                                          action:nil];
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                   style:UIBarButtonItemStyleBordered
                                                                  target:self
                                                                  action:@selector(pickerDoneButtonPressed)];
    
    [pickerToolbar setItems:[NSArray arrayWithObjects:flexibleSpaceLeft, doneButton, nil]];
    
    
    //self.expirationDateTextField.inputView = self.expirationDatePicker;
    //self.expirationDateTextField.inputAccessoryView = pickerToolbar;
    //self.nameTextField.inputAccessoryView = pickerToolbar;
    //self.emailTextField.inputAccessoryView = pickerToolbar;
    //self.cardNumber.inputAccessoryView = pickerToolbar;
    //self.CVCNumber.inputAccessoryView = pickerToolbar;
    self.tableNumberTextField.inputAccessoryView=pickerToolbar;
    self.promoCodeTextField.inputAccessoryView=pickerToolbar;
    
}

- (void)pickerDoneButtonPressed {
    [self.view endEditing:YES];
}
@end
