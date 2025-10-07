//
//  PaymentViewController.m

#import "PayCashViewController.h"
#import "CheckoutCart.h"
#import "RWEmailManager.h"
#import "InventoryModel.h"
#import "InventoryItem.h"
#import "CheckoutInputCell.h"
#import "CheckoutDisplayCell.h"

#import "HistoryModel.h"

#import "OrderHistory.h"

#import <AFNetworking/AFNetworking.h>


//#import "Stripe.h"
#import "AppDelegate.h"
#import "defs.h"
//#define STRIPE_TEST_PUBLIC_KEY @"pk_test_U9L4e6hqciFT1nGyluOmKKTu"

//#define STRIPE_TEST_POST_URL @""

@interface PayCashViewController () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UIAlertViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView* tableView;
@property (strong, nonatomic) IBOutlet UIView* buttonView;
@property (strong, nonatomic) IBOutlet UIButton* completeButton;

@property (strong, nonatomic) UITextField* nameTextField;
@property (strong, nonatomic) UITextField* emailTextField;
@property (strong, nonatomic) UITextField* enterAmountTextField;
@property (strong, nonatomic) UITextField* tableNumberTextField;
@property (strong, nonatomic) CheckoutCart* checkoutCart;
@property (strong, nonatomic) AFJSONRequestOperation* httpOperation;
//@property (strong, nonatomic) STPCard* stripeCard;

@property (nonatomic, strong) AppDelegate *appDelegate;
@end

@implementation PayCashViewController{
    InventoryItem *_selectedInventory;
}

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
    _selectedInventory=_appDelegate.inventoryModel.inventory;//[InventoryModel activeInventory];
    _checkoutCart = [CheckoutCart sharedInstance];
    
   // [_nameTextField setText:_appDelegate.userInfo.displayName];
 //   self.monthArray = @[@"01 - January", @"02 - February", @"03 - March",
//    @"04 - April", @"05 - May", @"06 - June", @"07 - July", @"08 - August", @"09 - September",
 //   @"10 - October", @"11 - November", @"12 - December"];
    
    
    /* [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(performChargeSuccess:)
                                                 name:NOTIFY_CHARGE_SUCCESS_CASH
                                               object:nil];
    */
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(performChargeFail:)
                                                 name:NOTIFY_CHARGE_FAIL_CASH
                                               object:nil];

    
}

-(void)viewDidAppear:(BOOL)animated{
    
    //test only
    
    [self configurePickerView];
    //[_emailTextField setText:@"rquidilig@gmail.com"];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Stripe

- (IBAction)completeButtonTapped:(id)sender {

    /*//1
    self.stripeCard = [[STPCard alloc] init];
    self.stripeCard.name = self.nameTextField.text;
    self.stripeCard.number = self.cardNumber.text;
    self.stripeCard.cvc = self.CVCNumber.text;
    self.stripeCard.expMonth = [self.selectedMonth integerValue];
    self.stripeCard.expYear = [self.selectedYear integerValue];
    */
    //2
    //3 rom update ccinfo locally

    if ([self validateCustomerInfo]) {
        [self performPayCashOperation];
    }
    
}

- (BOOL)validateCustomerInfo {
    
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Please try again"
                                                     message:@"Please enter all required information"
                                                    delegate:nil
                                           cancelButtonTitle:@"OK"
                                           otherButtonTitles:nil];
    return YES;
    //1. Validate name & email
    if (self.nameTextField.text.length == 0 ||
        self.emailTextField.text.length == 0) {
        
        [alert show];
        return NO;
    }
    
    //2. Validate card number, CVC, expMonth, expYear
    /*NSError* error = nil;
    [self.stripeCard validateCardReturningError:&error];
    
    //3
    if (error) {
        alert.message = [error localizedDescription];
        [alert show];
        return NO;
    }
    */
    return YES;
}


- (void)performPayCashOperation {
    
   
    
    
    //1
    self.completeButton.enabled = NO;
    
    //double cartTotal=[_checkoutCart total]
    NSInteger totalCents = [_checkoutCart total] ;
   // NSString* textLabel=[checkoutCart textLabel];
    
    NSString *chargeAmount;// = [NSString stringWithFormat:@"%ld", (long)totalCents];
    //check previous payments
    
    
    
    
    NSString *chargeCurrency = _selectedInventory.currency;//@"usd";
    //NSString *stripeToken = token;
   // NSString *chargeDescription = [_checkoutCart textLabel];//@"Purchase from Portico iOS app!";
    
    NSString* chargeDescription=[_checkoutCart textLabel:_appDelegate.mcManager.myPeerInfo.peerID.displayName storeID:_appDelegate.mcManager.myPeerInfo.deviceID];
    if(chargeDescription!=nil){
#ifdef DEBUG
        //if (result!=nil) {
        NSLog(@"Error: %@",chargeDescription);
        //}
#endif
    }
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        
        NSString *today=[dateFormatter stringFromDate:[NSDate date]];
    
    if(_checkoutCart.order==nil){
        _checkoutCart.order=[[OrderHistory alloc] init];
        _checkoutCart.order.orderID=[[[NSUUID UUID] UUIDString] lowercaseString];
        _checkoutCart.order.orderNumber=@0;
    }
    
    
    _checkoutCart.order.orderBy=self.nameTextField.text;
    _checkoutCart.order.orderTableNumber=self.tableNumberTextField.text;
    
    _checkoutCart.order.chargePayType=ORDER_PAY_TYPE_CASH;
    
    
    
    //check partial payments
    NSInteger totalPartialCents=0;
    
    if(_checkoutCart.order.orderPayments!=nil){
        if ([_checkoutCart.order.orderPayments count]>0){
            for(NSDictionary *itemPay in _checkoutCart.order.orderPayments){
                NSInteger amtCents=[[itemPay valueForKey:@"amount"] integerValue];
                if(amtCents>0){
                    totalPartialCents=totalPartialCents+amtCents;
                }
            }
            totalCents=totalCents-totalPartialCents;
        }
        
    }
    else{
        _checkoutCart.order.orderPayments=[NSMutableArray new];
    }
    
    chargeAmount = [NSString stringWithFormat:@"%ld", (long)totalCents];
    
   // _checkoutCart.order.orderAmountDue=[NSNumber numberWithDouble:totalCents/100]; //[NSNumber numberWithFloat:[chargeAmount doubleValue]];
    
    NSInteger cashTendered=0;
    
    NSNumberFormatter *nf=[[NSNumberFormatter alloc] init];
    if([nf numberFromString:_enterAmountTextField.text]){
        cashTendered=[_enterAmountTextField.text doubleValue]*100;//@([_enterAmountTextField.text floatValue]);
    }
    else{
        //_selectedProduct.price=1.0;
        cashTendered=0;
    }
    
    if(cashTendered==0 && totalCents>0)
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Error" message:@"Please enter a valid amount." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    if(cashTendered>0 && totalCents==0)
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Can't accept payment" message:@"The Amount due is 0" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }

    
    _checkoutCart.order.orderAmountDue=totalCents;//[NSNumber numberWithDouble:totalCents/100];
    
    _checkoutCart.order.chargeAmount= cashTendered;//[NSNumber numberWithFloat:[chargeAmount floatValue]];
        _checkoutCart.order.chargeCurrency=chargeCurrency;
    
       // _checkoutCart.order.orderDetailText=chargeDescription;
        _checkoutCart.order.orderDateTime=[NSDate date];
        _checkoutCart.order.orderDay=today;
        _checkoutCart.order.orderDate=[dateFormatter dateFromString:today];
        _checkoutCart.order.orderStatus=@ORDER_STATUS_RECEIVED;
    _checkoutCart.order.orderIsPaid=YES;
        _checkoutCart.order.orderStoreID=_appDelegate.appConfig.device_id;
    
    
    
    if(_checkoutCart.order.orderPayments==nil)
        _checkoutCart.order.orderPayments=[NSMutableArray new];
    
    NSDictionary *payment=@{KEY_AMOUNT:@(cashTendered),KEY_PAYMENT_TYPE:ORDER_PAY_TYPE_CASH};
    [_checkoutCart.order.orderPayments addObject:payment];
    
    _checkoutCart.order.orderAmountDue=_checkoutCart.order.orderAmountDue-cashTendered;
    
    if(_checkoutCart.order.orderAmountDue<=0){
        _checkoutCart.order.orderCashBack= -1*_checkoutCart.order.orderAmountDue;
        _checkoutCart.order.orderAmountDue=0;
        _checkoutCart.order.orderIsPaid=YES;
        _checkoutCart.order.orderStatus=@ORDER_STATUS_RECEIVED;
        _checkoutCart.order.orderIsPaid=YES;
        [_appDelegate.historyModel addOrUpdateHistory:_checkoutCart.order];
       // [_appDelegate.historyModel addOrUpdateHistory:order.orderDay withOrder:order];
        /*if (_checkoutCart.order.orderAmountDue<0){
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Cash back" message:[NSString stringWithFormat:@"$%d",_checkoutCart.order.orderCashBack/100] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            alert.tag=100;
            [alert show];
        }
        */
        [_checkoutCart clearCart];
        UITabBarItem *tbi=(UITabBarItem *)[self.tabBarController.tabBar.items objectAtIndex:TAB_INDEX_CART];
       
        tbi.badgeValue=nil;
       
        
    }
    
    [_appDelegate.historyModel saveHistory];
    
    [self.navigationController popToRootViewControllerAnimated:YES];
    
    if(!_appDelegate.isIpad)
        [self.tabBarController setSelectedIndex:TAB_INDEX_ORDERS];
    
    

}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
  /*  if(alertView.tag==100){
        if (_checkoutCart.order.orderAmountDue==0){
            [_checkoutCart clearCart];
            
            //[_appDelegate.historyModel saveHistory];
            
            [self.navigationController popToRootViewControllerAnimated:YES];
            
            [self.tabBarController setSelectedIndex:TAB_INDEX_CHAT];
        }
    }
   */
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
//    item.orderStoreID=_appDelegate.mcManager.serverPeerInfo.deviceID;
//    
//    //[todaysHistory addObject:item];
//    
//    //[historyModel saveHistory];
//    [historyModel addHistory:item];
//}
/*
- (void)postStripeToken:(NSString* )token {
    NSString *STRIPE_TEST_POST_URL=[NSString stringWithFormat:@"%@stripe", _appDelegate.mcManager.serverPeerInfo.homeUrl];
    
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
- (void)postStripeToken__:(NSString* )token {
    
    //1
    NSString *STRIPE_TEST_POST_URL=_appDelegate.mcManager.myPeerInfo.homeUrl;
    
    NSURL *postURL = [NSURL URLWithString:STRIPE_TEST_POST_URL];
    
    AFHTTPClient* httpClient = [AFHTTPClient clientWithBaseURL:postURL];
    
    httpClient.parameterEncoding = AFJSONParameterEncoding;
    [httpClient registerHTTPOperationClass:[AFJSONRequestOperation class]];
    [httpClient setDefaultHeader:@"Accept" value:@"text/json"];
    
    //2
    CheckoutCart* checkoutCart = [CheckoutCart sharedInstance];
    NSInteger totalCents = [checkoutCart total] ;
    
    //3
    NSMutableDictionary* postRequestDictionary = [[NSMutableDictionary alloc] init];
    postRequestDictionary[@"stripeAmount"] = [NSString stringWithFormat:@"%ld", (long)totalCents];
    postRequestDictionary[@"stripeCurrency"] = @"usd";
    postRequestDictionary[@"stripeToken"] = token;
    postRequestDictionary[@"stripeDescription"] = @"Purchase from Kiosk iOS app!";
    
    //4
    NSMutableURLRequest* request = [httpClient requestWithMethod:@"POST" path:@"/stripe" parameters:postRequestDictionary];
    
    self.httpOperation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        [self chargeDidSucceed];
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        [self chargeDidNotSuceed];
    }];
    
    [self.httpOperation start];
    
    self.completeButton.enabled = YES;
}

- (void)handleStripeError:(NSError *) error {
    
    //1
    if ([error.domain isEqualToString:@"StripeDomain"]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:[error localizedDescription]
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    
    //2
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"Please try again"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    
    self.completeButton.enabled = YES;
}

- (void)chargeDidSucceed {

    /*
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success"
                                                    message:@"We received your order and payment. Thank You."
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
    */
    [AppDelegate toast:@"Success. We received your order. Thank You." duration:1.0];
   
    CheckoutCart* checkoutCart = [CheckoutCart sharedInstance];
    [checkoutCart clearCart];
    
    UITabBarItem *tbi=(UITabBarItem *)[self.tabBarController.tabBar.items objectAtIndex:TAB_INDEX_CART];
    
    tbi.badgeValue=nil;
    
    
     [self.navigationController popToRootViewControllerAnimated:YES];
     
     [self.tabBarController setSelectedIndex:TAB_INDEX_ORDERS];
    
    
    
    
    
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
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    if (section == 0 && row == 0) {
        CheckoutInputCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"CheckoutInputCell"];
        cell.nameLabel.text = @"Name";

        cell.textField.placeholder = @"Required";

        cell.textField.keyboardType = UIKeyboardTypeAlphabet;
        if(_checkoutCart.order!=nil){
            if(_checkoutCart.order.orderBy!=nil && _checkoutCart.order.orderBy.length>0)
                cell.textField.text=_checkoutCart.order.orderBy;
            //else
             //   self.nameTextField.text=[NSString stringWithFormat:@"Customer #%@",_checkoutCart.order.orderNumber];
        }
        
        self.nameTextField = cell.textField;
        return cell;
    }
    //rom added for table/seat#
    else if (section == 0 && row == 1) {
        CheckoutInputCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"CheckoutInputCell"];
        cell.nameLabel.text = @"Table#";
        cell.textField.placeholder = @"";
        if(_checkoutCart.order!=nil){
            if(_checkoutCart.order.orderTableNumber!=nil)
                cell.textField.text=_checkoutCart.order.orderTableNumber;
            //else
            //   self.nameTextField.text=[NSString stringWithFormat:@"Customer #%@",_checkoutCart.order.orderNumber];
        }
        self.tableNumberTextField = cell.textField;
        cell.textField.keyboardType = UIKeyboardTypeNumberPad;
        return cell;
    }
    
    else if (section == 0 && row == 2) {
        /*CheckoutInputCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"CheckoutInputCell"];
        cell.nameLabel.text = @"E-mail";
         cell.textField.placeholder = (_appDelegate.userInfo.ccEmail!=nil && _appDelegate.userInfo.ccEmail.length>0)?_appDelegate.userInfo.ccEmail:@"";
        self.emailTextField = cell.textField;
        cell.textField.keyboardType = UIKeyboardTypeAlphabet;
         */
        CheckoutInputCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"CheckoutInputCell"];
        cell.nameLabel.text = @"Enter Amount";
        cell.textField.placeholder=@"Required";
        cell.textField.text =(_checkoutCart.order!=nil)?[NSString stringWithFormat:@"%.02f", (double)_checkoutCart.order.orderAmountDue/100]:@""; //(_appDelegate.userInfo.ccEmail!=nil && _appDelegate.userInfo.ccEmail.length>0)?_appDelegate.userInfo.ccEmail:@"";
        self.enterAmountTextField = cell.textField;
        cell.textField.keyboardType = UIKeyboardTypeNumberPad;

        return cell;
    }
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
    pickerToolbar.barStyle = UIBarStyleBlackTranslucent;
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
/*-(void)performChargeSuccess:(NSNotification *)notification{
    
    [self chargeDidSucceed];
    
}
*/

#pragma mark - UIPicker configuration
- (void)configurePickerView {
    
    
    //Create and configure toolabr that holds "Done button"
    UIToolbar *pickerToolbar = [[UIToolbar alloc] init];
    pickerToolbar.barStyle = UIBarStyleBlackTranslucent;
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
    
    
    
    
    
    self.tableNumberTextField.inputAccessoryView = pickerToolbar;
    
    self.nameTextField.inputAccessoryView = pickerToolbar;
    self.enterAmountTextField.inputAccessoryView=pickerToolbar;
    
    
}

- (void)pickerDoneButtonPressed {
    [self.view endEditing:YES];
}


@end
