//
//  PaymentViewController.m

#import "RWStripeViewController.h"
#import "CheckoutCart.h"
#import "RWEmailManager.h"
#import "InventoryItem.h"
#import "InventoryModel.h"
#import "DiscountItem.h"
#import "CheckoutInputCell.h"
#import "CheckoutDisplayCell.h"
#import "SoundController.h"
#import <AFNetworking/AFNetworking.h>


#import "Stripe.h"
#import "AppDelegate.h"

#import "defs.h"

//#import "CardInfo.h"
#import "CardIO.h"
#import "UniPayViewController.h"

#ifdef MAGTEK
//#import "MagTekDemoAppDelegate.h"
#import "MediaPlayer/MediaPlayer.h"
#import <MessageUI/MessageUI.h>




@class MTSCRA;
#endif


//#define STRIPE_TEST_POST_URL @""

//@interface RWStripeViewController () <UITableViewDataSource, UITableViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate, UIAlertViewDelegate,CardIOPaymentViewControllerDelegate,MTSCRAEventDelegate>
#ifdef MAGTEK
@interface RWStripeViewController () <UITableViewDataSource, UITableViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate, UIAlertViewDelegate,CardIOPaymentViewControllerDelegate,MTSCRAEventDelegate,UIPrintInteractionControllerDelegate>
#else
@interface RWStripeViewController () <UITableViewDataSource, UITableViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate, UIAlertViewDelegate,CardIOPaymentViewControllerDelegate>
#endif

{
    UIAlertView *processWait;
    UIAlertView *readyToSwipeCard;
    NSTimer *processTimer;
    BOOL isCardScan;
    InventoryItem *_selectedInventory;
    
   SoundController *_sounController;
    
    
    NSInteger confirmed_totalCents;
    NSInteger totalCents;
    NSInteger totalCentsBeforeTip;
    float totalTip;
    
    NSMutableArray *discounts;
    NSInteger totalDiscount;
    

    #ifdef MAGTEK
    //magtek
    UITextView* dataResponds;
    UISwitch* devSwitch;
    #endif
}
@property (strong, nonatomic) IBOutlet UITableView* tableView;
@property (strong, nonatomic) IBOutlet UIView* buttonView;
@property (strong, nonatomic) IBOutlet UIButton* completeButton;

@property (strong, nonatomic) UITextField* nameTextField;
@property (strong, nonatomic) UITextField* emailTextField;
@property (strong, nonatomic) UITextField* tableNumberTextField;

@property (strong, nonatomic) UITextField* chargeTextField; //read only
@property (strong, nonatomic) UITextField* tipTextField;
@property (strong, nonatomic) UITextField* promoCodeTextField;
@property (strong, nonatomic) IBOutlet UILabel *acceptedCardsLabel;
@property (strong, nonatomic) IBOutlet UIButton *tipButton;

@property (strong, nonatomic) UITextField* expirationDateTextField;
@property (strong, nonatomic) UITextField* cardNumber;
@property (strong, nonatomic) UITextField* CVCNumber;

@property (strong, nonatomic) NSArray* monthArray;
@property (strong, nonatomic) NSNumber* selectedMonth;
@property (strong, nonatomic) NSNumber* selectedYear;
@property (strong, nonatomic) UIPickerView *expirationDatePicker;

@property (strong, nonatomic) AFJSONRequestOperation* httpOperation;
@property (strong, nonatomic) STPCard* stripeCard;

@property (nonatomic, strong) AppDelegate *appDelegate;

#pragma mark -
#pragma mark UILabel Properties
#pragma mark -

@property (nonatomic, strong) IBOutlet UILabel *versionLabel;
@property (nonatomic, strong) IBOutlet UILabel *transactionStatusLabel;
@property (nonatomic, strong) IBOutlet UILabel *deviceConnectionStatusLabel;

#pragma mark -
#pragma mark MPVolumeView Property
#pragma mark -

#ifdef MAGTEK

@property (nonatomic, strong) MPVolumeView *volumeView;
@property (nonatomic) float curVolume;

#endif

#pragma mark -
#pragma mark MTSCRA Property
#pragma mark -

#ifdef MAGTEK
@property (nonatomic, strong) MTSCRA *mtSCRALib;
#endif
#pragma mark -
#pragma mark Remember Dynamax Property
#pragma mark -

#ifdef MAGTEK
@property (nonatomic, strong) CBPeripheral *curPeripheral;
#endif
#pragma mark -
#pragma mark Picker Property
#pragma mark -


//@property (nonatomic, strong) UIPickerView   *pickerVC;
//@property (nonatomic, strong) UIView   *pickerView;
//@property (nonatomic, strong) MTPickerViewController *pickerVC;
@property (nonatomic) bool noPicker;


@end

@implementation RWStripeViewController

#define PROTOCOLSTRING @"com.magtek.idynamo"
/*- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
 */
- (id)init {
    self = [super init];
    if (self) {
        //Custom initialization
        //self.productsArray = [[NSMutableArray alloc] init];
        //_inventoryModel = [[InventoryModel alloc] init];
        //self.orders=[NSMutableArray new];
        //self.dates=[NSMutableArray new];
        //self.history=[NSMutableDictionary new];
    }
    return self;
}
/*+ (RWStripeViewController *)sharedInstance {
    static RWStripeViewController*  _sharedWStripeViewController;
    
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        _sharedWStripeViewController = [[RWStripeViewController alloc] init];
        
        
    });
    
    return _sharedWStripeViewController;
}
*/
- (void)viewDidLoad {
    [super viewDidLoad];
	self.view.backgroundColor=[UIColor clearColor];
    
    _appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    _sounController=[SoundController sharedInstance];
    _selectedInventory=_appDelegate.inventoryModel.inventory;//[InventoryModel activeInventory];
    if(self.stripeCard==nil)
        self.stripeCard = [[STPCard alloc] init];
    
    self.monthArray = @[@"01 - January", @"02 - February", @"03 - March",
    @"04 - April", @"05 - May", @"06 - June", @"07 - July", @"08 - August", @"09 - September",
    @"10 - October", @"11 - November", @"12 - December"];
    
   
    isCardScan=NO;
    
   
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(performChargeSuccess:)
                                                 name:NOTIFY_CHARGE_SUCCESS_CARD
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(performChargeFail:)
                                                 name:NOTIFY_CHARGE_FAIL_CARD
                                               object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(performCardSwiped:)
                                                 name:NOTIFY_CARD_SWIPED
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(performReadyToSwipeCard:)
                                                 name:NOTIFY_CARD_READY_TOSWIPE
                                               object:nil];
    
    processWait=[[UIAlertView alloc] initWithTitle:@"Processing your payment"  message:@"Please wait..." delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
    
    readyToSwipeCard=[[UIAlertView alloc] initWithTitle:@"Card Reader"  message:@"NOT READY. Please wait..." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
    
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:[NSDate date]];
   
    NSInteger year = [components year]+1;
    _selectedMonth=@1;
    _selectedYear=@(year);
    self.stripeCard.expMonth = 1;
    self.stripeCard.expYear = year;
    
    if(_appDelegate.appConfig.visibility!=VISIBILITY_LIVE){
        
        
        self.stripeCard.name=@"Rom Doe";
        self.stripeCard.number=@"4242424242424242";
        
        self.stripeCard.cvc=@"123";
        

    }
    else{
        self.stripeCard.name=@"";
        self.stripeCard.number=@"";
        self.stripeCard.cvc=@"";
       
    }
    
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //Make an optional call to speed up the subsequent launch of card.io scanning:
    [CardIOUtilities preload];
}
-(void)viewDidAppear:(BOOL)animated{
    
   // [_expirationDateTextField setText:[NSString stringWithFormat:@"%@/%@",_selectedMonth,_selectedYear]];
    
    
  
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Stripe

- (IBAction)completeButtonTapped:(id)sender {
    //1
    if(self.stripeCard==nil)
        self.stripeCard = [[STPCard alloc] init];
    
    self.stripeCard.name = self.nameTextField.text;
    //self.stripeCard.number = self.cardNumber.text;
    self.stripeCard.cvc = self.CVCNumber.text;
    self.stripeCard.expMonth = [self.selectedMonth integerValue];
    self.stripeCard.expYear = [self.selectedYear integerValue];
    //ROM added:
    self.stripeCard.email=self.emailTextField.text;
    //2
    if ([self validateCustomerInfo]) {
        
        [self performStripeOperation];
    }
    

    
}

- (BOOL)validateCustomerInfo {
    
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Please try again"
                                                     message:@"Please enter all required information"
                                                    delegate:nil
                                           cancelButtonTitle:@"OK"
                                           otherButtonTitles:nil];
    
    //1. Validate name & email
    if (self.nameTextField.text.length == 0
        //|| self.emailTextField.text.length == 0
        ) {
        
        [alert show];
        return NO;
    }
    
    //2. Validate card number, CVC, expMonth, expYear
    NSError* error = nil;
    [self.stripeCard validateCardReturningError:&error];
    
    //3
    if (error) {
        alert.message = [error localizedDescription];
        [alert show];
        return NO;
    }
    
    return YES;
}


- (void)performStripeOperation {
    
    //1
    self.completeButton.enabled = NO;
    
    //2
    /*
    CheckoutCart* checkoutCart = [CheckoutCart sharedInstance];
    NSInteger totalCents = [checkoutCart total];
    
    NSString* textLabel=[checkoutCart textLabel:_appDelegate.mcManager.myPeerInfo.peerID.displayName storeID:_appDelegate.mcManager.myPeerInfo.deviceID];

    NSString *stripeCurrency = _selectedInventory.currency;//@"usd";
    NSString *stripeToken = @"";//token;
    NSString *stripeDescription = textLabel;
    
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSString *today=[dateFormatter stringFromDate:[NSDate date]];
    
    
    OrderHistory *order=[[OrderHistory alloc] init];
    //order.orderSource=@ORDER_SOURCE_LOCAL; //already set at notification
    order.orderBy=self.nameTextField.text;
    order.orderTableNumber=self.tableNumberTextField.text;
    order.orderID=[[[NSUUID UUID] UUIDString] lowercaseString];
    order.orderNumber=@0;
    order.chargePayType=ORDER_PAY_TYPE_CCARD;
   
    order.orderItems=[NSMutableArray arrayWithArray:[checkoutCart itemsInCart]];
    // order.orderDetailText=textLabel;
    
    
    order.orderDateTime=[NSDate date];
    order.orderDate=[dateFormatter dateFromString:today];
    order.orderDay=today;
    order.orderStatus=@ORDER_STATUS_START;
    
    order.orderStoreID=_appDelegate.appConfig.device_id;
    order.orderDeviceID=_appDelegate.appConfig.device_id;
    order.orderDeviceToken=_appDelegate.appConfig.user_deviceToken;
    
    order.chargeAmount=totalCents;
    order.chargeCurrency=stripeCurrency;
    order.chargeToken=stripeToken;
    order.chargeDescription=stripeDescription;
    */
    
    OrderHistory *order=[self createOrderFromCart];
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_LOCAL_CHARGE
                                                        object:nil
                                                      userInfo:@{@"cardinfo":self.stripeCard, @"order":order}];
    
    
    
}

-(OrderHistory *)createOrderFromCart{
    //2
    CheckoutCart* checkoutCart = [CheckoutCart sharedInstance];
    
    [self computeTotals];
    
    
    
    confirmed_totalCents=totalCents;
    
    /*
     NSString* textLabel=[checkoutCart textLabel:[_appDelegate.inventory valueForKey:deviceNameKey] storeID:[_appDelegate.inventory valueForKey:deviceIDKey]];
    
    
    
    NSString *stripeCurrency = (_appDelegate.selectedInventory.currency.length==0)?@"usd":_appDelegate.selectedInventory.currency;
    */
    NSString* textLabel=[checkoutCart textLabel:_appDelegate.mcManager.myPeerInfo.peerID.displayName storeID:_appDelegate.mcManager.myPeerInfo.deviceID];
    
    NSString *stripeCurrency = _selectedInventory.currency;
    
    
    NSString *stripeDescription = textLabel;//@"Purchase from Portico iOS app!";
    
    
    
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSString *today=[dateFormatter stringFromDate:[NSDate date]];
    
    
    
    OrderHistory *order=[[OrderHistory alloc] init];
    
    //order.orderBy=selectedCard.name;
    order.orderBy=self.nameTextField.text;
    order.orderTableNumber=self.tableNumberTextField.text;
    order.orderDiscountCode=self.promoCodeTextField.text;
    
    
    if(totalTip<0)
        totalTip=0;
    
    order.orderTip=totalTip*100;
    
    order.orderID=[[[NSUUID UUID] UUIDString] lowercaseString];
    order.orderNumber=@0;
    order.chargePayType=ORDER_PAY_TYPE_CCARD;
    
    //get order items
    order.orderItems=[NSMutableArray arrayWithArray:[checkoutCart itemsInCart]];
    
    if([discounts count]>0){
        order.orderDiscounts=[NSMutableArray arrayWithArray:discounts];
    }
    
    
    if(order.orderPayments==nil)
        order.orderPayments=[NSMutableArray new];
    
    
    order.orderDateTime=[NSDate date];
    order.orderDate=[dateFormatter dateFromString:today];
    order.orderDay=today;
    order.orderStatus=@ORDER_STATUS_START;
    
    order.orderStoreID=_appDelegate.appConfig.device_id;
    order.orderDeviceID=_appDelegate.appConfig.device_id;
    order.orderStoreNum=_appDelegate.appConfig.device_num;
    order.orderStoreName=_appDelegate.appConfig.device_name;
    order.orderIsLive=_appDelegate.appConfig.isLive;
    
    order.orderDeviceToken=_appDelegate.appConfig.user_deviceToken;
    
    
    double tax=_selectedInventory.salesTax;
    order.orderTax=tax;
    order.orderAmountDue=totalCents;
    order.chargeAmount=confirmed_totalCents; //stripeAmount;
    order.chargeCurrency=stripeCurrency;
    
    order.chargeDescription=stripeDescription;
    [_appDelegate.historyModel addOrUpdateHistory:order];
    
    [_appDelegate clearCart];
    return order;
    
    
}
/*
- (void)postCashPayment{
    CheckoutCart* checkoutCart = [CheckoutCart sharedInstance];
    NSInteger totalCents = [[checkoutCart total] doubleValue] * 100;
    NSString* textLabel=[checkoutCart textLabel];
    
    NSDictionary *dict = @{ @"data": textLabel
                            //,@"peerID": peerID
                            };
    [[NSNotificationCenter defaultCenter] postNotificationName:
                                                        object:nil
                                                      userInfo:dict];
    
    [self chargeDidSucceed];
    
}
*/

-(void)computeTotals{
    
    
    CheckoutCart* checkoutCart = [CheckoutCart sharedInstance];
    
    
    totalCents=[checkoutCart total];
    
    //totalCents = totalCents+[checkoutCart total_tax:totalCents tax:[[_appDelegate.inventory valueForKey:taxKey] floatValue]];
    
    //minus discounts
    totalDiscount=0;
    if([discounts count]>0){
        for(DiscountItem *d in discounts){
            if(d.price>0){
                totalDiscount=totalDiscount+d.price;
            }
        }
    }
    if(totalDiscount>0){
        totalCents=totalCents-totalDiscount;
    }
    //add tax
    totalCents = totalCents+[checkoutCart total_tax:totalCents tax:_selectedInventory.salesTax];
    
    totalCentsBeforeTip=totalCents;
    
    if(totalTip<0)
        totalTip=0;
    
    if(totalTip>0){
        totalCents=totalCents+(totalTip*100);
        //[_tipButton setTitle:@"Change Tip" forState:UIControlStateNormal];
    }
    else{
        //[_tipButton setTitle:@"Add Tip" forState:UIControlStateNormal];
    }
    
}

- (void)postStripeTokenHTTP:(NSString* )token {
   /* NSString *STRIPE_TEST_POST_URL=[NSString stringWithFormat:@"%@stripe", _appDelegate.mcManager.serverPeerInfo.homeUrl];
    
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
    NSString *stripeDescription = textLabel;//@"Purchase from Portico iOS app!";

    
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
    if(err==nil)
        [self performChargeSuccess:<#(OrderHistory *)#>:textLabel];
    else
        [self performChargeFailed];
    
    
    */
}

-(void)performChargeFail:(NSNotification *)notification{
    [self chargeDidNotSuceed];
}
-(void)performChargeSuccess:(NSNotification *)notification{
    
  [self chargeDidSucceed];
  
}



/*
- (void)postStripeToken__:(NSString* )token {
    
    //1
    NSString *STRIPE_TEST_POST_URL=_appDelegate.mcManager.serverPeerInfo.homeUrl;
    
    NSURL *postURL = [NSURL URLWithString:STRIPE_TEST_POST_URL];
    
    AFHTTPClient* httpClient = [AFHTTPClient clientWithBaseURL:postURL];
    
    httpClient.parameterEncoding = AFJSONParameterEncoding;
    [httpClient registerHTTPOperationClass:[AFJSONRequestOperation class]];
    [httpClient setDefaultHeader:@"Accept" value:@"text/json"];
    
    //2
    CheckoutCart* checkoutCart = [CheckoutCart sharedInstance];
    NSInteger totalCents = [[checkoutCart total] doubleValue] * 100;
    
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
*/
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
    if(processTimer)
        [processTimer invalidate];
    [processWait dismissWithClickedButtonIndex:0 animated:YES];
    
    /*
    //Send confirmation email
    if(self.emailTextField.text.length>0){
    RWEmailManager* emailManager = [[RWEmailManager alloc] initWithRecipient:self.nameTextField.text
                                                              recipientEmail:self.emailTextField.text];
    
    [emailManager sendConfirmationEmail];
    }
     */
    /*
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success"
                                                    message:@"We received your order. Thank You."
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
    */
    //[AppDelegate toast:@"Success. We received your order. Thank You." duration:1.0];
    
    
    CheckoutCart* checkoutCart = [CheckoutCart sharedInstance];
    [checkoutCart clearCart];
    
    UITabBarItem *tbi=(UITabBarItem *)[self.tabBarController.tabBar.items objectAtIndex:TAB_INDEX_CART];
    
    tbi.badgeValue=nil;
    //}
    [self.navigationController popToRootViewControllerAnimated:YES];
    
    [self.tabBarController setSelectedIndex:TAB_INDEX_ORDERS];
    
}
- (void)chargeTimedOut {
    
    [processWait dismissWithClickedButtonIndex:0 animated:YES];
    
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Request timedout" message:@"Timed out waiting for response. Please try again or speak to an attendant." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    self.completeButton.enabled = YES;

}

- (void)chargeDidNotSuceed {
    if(processTimer)
        [processTimer invalidate];
    [processWait dismissWithClickedButtonIndex:0 animated:YES];
    //2
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Payment not successful"
                                                    message:@"Please try again later."
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}


/* The methods below implement the user interface. You don't need to change anything. */

#pragma mark - UITableViewDataSource methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2; // (1) user details, (2) credit card details
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return (section == 0) ? @"Customer Info" : @"Credit Card Details";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return (section == 0) ? 3 : 3;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(isCardScan){
        return [self scanCardCellForRowAtIndexPath:indexPath];
    }
    else{
        return [self defaultCellForRowAtIndexPath:indexPath];
    }
}
- (UITableViewCell*)defaultCellForRowAtIndexPath:(NSIndexPath*)indexPath{
    
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    if (section == 0 && row == 0) {
        CheckoutInputCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"CheckoutInputCell"];
        cell.nameLabel.text = @"Name";

        cell.textField.placeholder = @"Required";

        cell.textField.keyboardType = UIKeyboardTypeAlphabet;
        cell.textField.text=_stripeCard.name;
        self.nameTextField = cell.textField;
        self.nameTextField.delegate=self;
        return cell;
    }
    //rom added for table/seat#
    else if (section == 0 && row == 1) {
        CheckoutInputCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"CheckoutInputCell"];
        cell.nameLabel.text = @"Table/Seat";
        cell.textField.placeholder = nil;
        self.tableNumberTextField = cell.textField;
        self.tableNumberTextField.delegate=self;
        cell.textField.keyboardType = UIKeyboardTypeAlphabet;
        return cell;
    }
    else if (section == 0 && row == 2) {
        CheckoutInputCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"CheckoutInputCell"];
        cell.nameLabel.text = @"E-mail";
        cell.textField.placeholder = nil;
        self.emailTextField = cell.textField;
        self.emailTextField.delegate=self;
        cell.textField.keyboardType = UIKeyboardTypeAlphabet;
        return cell;
    }
    
//credi card info
    else if (section == 1 && row == 0) {
        CheckoutInputCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"CheckoutInputCell"];
        cell.nameLabel.text =@"Card Number";
        
        cell.textField.placeholder = @"Required";
        
        cell.textField.keyboardType = UIKeyboardTypeNumberPad;
        cell.textField.text=[NSString stringWithFormat:@"************%@",_stripeCard.last4];
        self.cardNumber = cell.textField;
        self.cardNumber.delegate=self;
        return cell;
    }
    else if (section == 1 && row == 1) {
        CheckoutInputCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"CheckoutInputCell"];
        cell.nameLabel.text = @"Exp. Date";
        cell.textField.placeholder = @"mm/yy";
        if(self.stripeCard.expMonth!=0 && self.stripeCard.expYear!=0)
            cell.textField.text = [NSString stringWithFormat:@"%lu/%lu",(unsigned long)self.stripeCard.expMonth,(unsigned long)self.stripeCard.expYear ];
        else
            cell.textField.text = nil;
        
        //cell.textField.textColor = [UIColor lightGrayColor];
        
        self.expirationDateTextField = cell.textField;
        self.expirationDateTextField.delegate=self;
        return cell;
    }
    else if (section == 1 && row == 2) {
        CheckoutInputCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"CheckoutInputCell"];
        cell.nameLabel.text = @"CVC Number";
        cell.textField.text = @"Required";
        cell.textField.text=_stripeCard.cvc;
        self.CVCNumber = cell.textField;
        self.CVCNumber.delegate=self;
        cell.textField.keyboardType = UIKeyboardTypeNumberPad;
        [self configurePickerView];
        return cell;
    }
    
    return nil;
}

- (UITableViewCell*)scanCardCellForRowAtIndexPath:(NSIndexPath*)indexPath{
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    if (section == 0 && row == 0) {
        CheckoutInputCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"CheckoutInputCell"];
        cell.nameLabel.
        text = @"Name";
        
        cell.textField.placeholder = @"Required";
        
        cell.textField.keyboardType = UIKeyboardTypeAlphabet;
        cell.textField.text=self.stripeCard.name;
        self.nameTextField = cell.textField;
        self.nameTextField.delegate=self;
        return cell;
    }
    //rom added for table/seat#
    else if (section == 0 && row == 1) {
        CheckoutInputCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"CheckoutInputCell"];
        cell.nameLabel.text = @"Table/Seat";
       cell.textField.placeholder = nil;
        cell.textField.text=self.stripeCard.tableNumber;
        self.tableNumberTextField = cell.textField;
        self.tableNumberTextField.delegate=self;
        cell.textField.keyboardType = UIKeyboardTypeAlphabet;
        return cell;
    }
    else if (section == 0 && row == 2) {
        CheckoutInputCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"CheckoutInputCell"];
        cell.nameLabel.text = @"E-mail";
        cell.textField.placeholder = nil;
        cell.textField.text=self.stripeCard.email;
        self.emailTextField = cell.textField;
        self.emailTextField.delegate=self;
        cell.textField.keyboardType = UIKeyboardTypeAlphabet;
        return cell;
    }
    
    //credit card info
    else if (section == 1 && row == 0) {
        CheckoutInputCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"CheckoutInputCell"];
        cell.nameLabel.text =@"Card Number";
        
        //cell.textField.placeholder = (_appDelegate.userInfo.ccNumber!=nil && _appDelegate.userInfo.ccNumber.length>0)?_appDelegate.userInfo.ccNumber:@"Required";
        cell.textField.placeholder = @"Required";
        cell.textField.text=[self maskCardNumber:self.stripeCard.number];//self.stripeCard.number;
        
        cell.textField.keyboardType = UIKeyboardTypeNumberPad;
        self.cardNumber = cell.textField;
        self.cardNumber.delegate=self;
        return cell;
    }
    else if (section == 1 && row == 1) {
        CheckoutInputCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"CheckoutInputCell"];
        cell.nameLabel.text = @"Exp. Date";
        cell.textField.placeholder = @"mm/yy";
        
       if(self.stripeCard.expMonth!=0 && self.stripeCard.expYear!=0)
            cell.textField.text = [NSString stringWithFormat:@"%lu/%lu",(unsigned long)self.stripeCard.expMonth,(unsigned long)self.stripeCard.expYear ];
        else
            cell.textField.text = nil;
        
        //cell.textField.textColor = [UIColor lightGrayColor];
        
        self.expirationDateTextField = cell.textField;
        self.expirationDateTextField.delegate=self;
        return cell;
    }
    else if (section == 1 && row == 2) {
        CheckoutInputCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"CheckoutInputCell"];
        cell.nameLabel.text = @"CVC Number";
         cell.textField.placeholder = @"Required";
        
        cell.textField.text=self.stripeCard.cvc;
        self.CVCNumber = cell.textField;
        self.CVCNumber.delegate=self;
        cell.textField.keyboardType = UIKeyboardTypeNumberPad;
        [self configurePickerView];
        return cell;
    }
    
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

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    if (component == 0) {
        //Expiration month
        return self.monthArray[row];
    }
    else {
        //Expiration year
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy"];
        NSInteger currentYear = [[dateFormatter stringFromDate:[NSDate date]] integerValue];
        return [NSString stringWithFormat:@"%ld", (long)currentYear + row];
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
    
    /*UIBarButtonItem *flexibleSpaceLeft = [[UIBarButtonItem alloc]
                                          initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                          target:nil
                                          action:nil];
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                   style:UIBarButtonItemStyleBordered
                                                                  target:self
                                                                  action:@selector(pickerDoneButtonPressed)];
    
    [pickerToolbar setItems:[NSArray arrayWithObjects:flexibleSpaceLeft, doneButton, nil]];
    */
    UIBarButtonItem *flexibleSpaceLeft = [[UIBarButtonItem alloc]
                                          initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                          target:nil
                                          action:nil];
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                   style:UIBarButtonItemStyleBordered
                                                                  target:self
                                                                  action:@selector(pickerDoneButtonPressed)];
    
    UIBarButtonItem *clearButton = [[UIBarButtonItem alloc] initWithTitle:@"Clear"
                                                                    style:UIBarButtonItemStyleBordered
                                                                   target:self
                                                                   action:@selector(pickerClearButtonPressed)];
    
    [pickerToolbar setItems:[NSArray arrayWithObjects:flexibleSpaceLeft,clearButton, doneButton, nil]];

    
    self.expirationDateTextField.inputView = self.expirationDatePicker;
    self.expirationDateTextField.inputAccessoryView = pickerToolbar;
    self.nameTextField.inputAccessoryView = pickerToolbar;
    self.emailTextField.inputAccessoryView = pickerToolbar;
    self.cardNumber.inputAccessoryView = pickerToolbar;
    self.CVCNumber.inputAccessoryView = pickerToolbar;
    self.tableNumberTextField.inputAccessoryView=pickerToolbar;
}

- (void)pickerDoneButtonPressed {
    if([self.cardNumber isFirstResponder]){
        self.stripeCard.number =(self.cardNumber.text)?self.cardNumber.text:@""; //[self.cardNumber.text stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" "]];
        self.cardNumber.text=[self maskCardNumber:self.stripeCard.number];
    }
    [self.view endEditing:YES];
}

#pragma mark -CardIO
- (IBAction)scanCard:(id)sender {
    if(_appDelegate.appConfig.cardReader==READER_CAMERA){
    CardIOPaymentViewController *viewController = [[CardIOPaymentViewController alloc] initWithPaymentDelegate:self];
    [self presentViewController:viewController animated:YES completion:nil];
    }
    else if(_appDelegate.appConfig.cardReader==READER_SWIPE){
        if(_appDelegate.uniPayManager==nil){
            _appDelegate.uniPayManager=[[UniPayManager alloc] init];
            [_appDelegate.uniPayManager start];
        }
        
        [readyToSwipeCard setMessage:@"NOT READY. Please wait..."];
        [readyToSwipeCard show];
       /*
        UniPayViewController *vc=[self.storyboard instantiateViewControllerWithIdentifier:@"UniPayViewController"];
        
        UINavigationController *nav=[[UINavigationController alloc] initWithRootViewController:vc];
        [self presentViewController:nav animated:YES completion:nil];
        */
    
    }
}


//Write delegate methods to receive the card info or a cancellation:

- (void)userDidCancelPaymentViewController:(CardIOPaymentViewController *)scanViewController {
    NSLog(@"User canceled payment info");
    // Handle user cancellation here...
    [scanViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)userDidProvideCreditCardInfo:(CardIOCreditCardInfo *)info inPaymentViewController:(CardIOPaymentViewController *)scanViewController {
    // The full card number is available as info.cardNumber, but don't log that!
//#ifdef DEBUG
//    NSLog(@"Received card info. Number: %@, expiry: %02lu/%lu, cvv: %@.", info.redactedCardNumber, (unsigned long)info.expiryMonth, (unsigned long)info.expiryYear, info.cvv);
//#endif
    // Use the card info...
    //self.nameTextField.text=?;
    /*self.cardNumber.text=info.cardNumber;
    self.CVCNumber.text=info.cvv;
    
    
     */
    isCardScan=YES;
    if(self.stripeCard==nil)
        self.stripeCard = [[STPCard alloc] init];
    
    //self.stripeCard.name = self.nameTextField.text;
    self.stripeCard.number = info.cardNumber;
    
    self.stripeCard.cvc = info.cvv;
    
    self.selectedMonth=[NSNumber numberWithUnsignedInteger:info.expiryMonth];
    self.selectedYear=[NSNumber numberWithUnsignedInteger:info.expiryYear];
    
    self.stripeCard.expMonth = info.expiryMonth;
    self.stripeCard.expYear = info.expiryYear;
    
    [scanViewController dismissViewControllerAnimated:YES completion:^{
        
        [self.tableView reloadData];
        //isCardScan=NO;
    }];
    
}

-(NSString *)maskCardNumber:(NSString *)number{
    if(number==nil || number.length==0)
        return nil;
    NSString *suffix = [number substringFromIndex:MAX((NSInteger)[number length] - 4, 0)];
    //return @[card.name, [NSString stringWithFormat:@"**** **** **** %@", suffix]];
    //return @[[AppDelegate cardtype:card.brand], [NSString stringWithFormat:@"**** **** **** %@", suffix]];
    return [NSString stringWithFormat:@"**** **** **** %@", suffix];

}


-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    CGPoint origin = textField.frame.origin;
    CGPoint point = [textField.superview convertPoint:origin toView:self.tableView];
    
    NSIndexPath * indexPath = [self.tableView indexPathForRowAtPoint:point];
    
    // [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    
    
    // NSIndexPath *indexPath = [self.tableView indexPathForCell:textFieldRowCell];
    
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    //}
    //self.cardNumber.text=nil;
    return YES;
}

- (void)pickerClearButtonPressed {
       if([self.cardNumber isFirstResponder])
        self.cardNumber.text=nil;
    
    
}

#ifdef MAGTEK
#pragma mark Magtek


#pragma mark -
#pragma mark Post Notification Selector Methods
#pragma mark -



- (void)trackDataReady:(NSNotification *)notification
{
    NSNumber *status = [[notification userInfo] valueForKey:@"status"];
    
    [self performSelectorOnMainThread:@selector(onDataEvent:)
                           withObject:status
                        waitUntilDone:NO];
}

- (void)devConnStatusChange
{
//#ifdef _DGBPRNT
//    NSLog(@"******* devConnStatusChange *******");
//#endif
    
    // Ensure that updateConnStatus is performed on the Main Thread
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self updateConnStatus];
        
    });
}

#pragma mark -
#pragma mark Post Notification Selector Helper Methods
#pragma mark -

-(void) onDataRecieved:(MTCardData *)cardDataObj instance:(id)instance
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        
        
        
        [[self transactionStatusLabel] setText:@"Transfer Complete"];
        
        [self displayData:cardDataObj];
    });
}

-(void) cardSwipeDidStart:(id)instance

{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        
        dataResponds.text =@"Transfer Started";
        
        [[self transactionStatusLabel] setText:@"Transfer Started"];
    });
}

-(void)cardSwipeDidGetTransError
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [[self transactionStatusLabel] setText:@"Transfer Error"];
        
        [self.deviceConnectionStatusLabel setBackgroundColor:[UIColor redColor]];
        
        [self updateConnStatus];
        
    });
}

- (void)onDataEvent:(id)status
{
//#ifdef _DGBPRNT
//    NSLog(@"onDataEvent: %i", [status intValue]);
//#endif
    
    switch ([status intValue])
    {
        case TRANS_STATUS_OK:
        {
            BOOL bTrackError = NO;
            
            [[self transactionStatusLabel] setText:@"Transfer Completed"];
            
            NSString *pstrTrackDecodeStatus = [[self mtSCRALib] getTrackDecodeStatus];
            
            [self displayData];
            
            @try
            {
                if(pstrTrackDecodeStatus)
                {
                    if(pstrTrackDecodeStatus.length >= 6)
                    {
/*
#ifdef _DGBPRNT
                        NSString *pStrTrack1Status = [pstrTrackDecodeStatus substringWithRange:NSMakeRange(0, 2)];
                        NSString *pStrTrack2Status = [pstrTrackDecodeStatus substringWithRange:NSMakeRange(2, 2)];
                        NSString *pStrTrack3Status = [pstrTrackDecodeStatus substringWithRange:NSMakeRange(4, 2)];
                        
                        if(pStrTrack1Status && pStrTrack2Status && pStrTrack3Status)
                        {
                            if([pStrTrack1Status compare:@"01"] == NSOrderedSame)
                            {
                                bTrackError=YES;
                            }
                            
                            if([pStrTrack2Status compare:@"01"] == NSOrderedSame)
                            {
                                bTrackError=YES;
                                
                            }
                            
                            if([pStrTrack3Status compare:@"01"] == NSOrderedSame)
                            {
                                bTrackError=YES;
                                
                            }
                            
                            NSLog(@"Track1.Status=%@",pStrTrack1Status);
                            NSLog(@"Track2.Status=%@",pStrTrack2Status);
                            NSLog(@"Track3.Status=%@",pStrTrack3Status);
                        }
#endif
 */
                    }
                }
                
            }
            @catch(NSException *e)
            {
            }
            
            if(bTrackError == NO)
            {
                //                [self closeDevice];
            }
            
            break;
            
        }
        case TRANS_STATUS_START:
            
            /*
             *
             *  NOTE: TRANS_STATUS_START should be used with caution. CPU intensive tasks done after this events and before
             *        TRANS_STATUS_OK may interfere with reader communication.
             *
             */
            
//#ifdef _DGBPRNT
//            NSLog(@"TRANS_STATUS_START");
//#endif
            dataResponds.text =@"Transfer Started";
            
            [[self transactionStatusLabel] setText:@"Transfer Started"];
            
            break;
            
        case TRANS_STATUS_ERROR:
            
            if(self.mtSCRALib != NULL)
            {
//#ifdef _DGBPRNT
//                NSLog(@"TRANS_STATUS_ERROR");
//#endif
                
                [[self transactionStatusLabel] setText:@"Transfer Error"];
                
                [self.deviceConnectionStatusLabel setBackgroundColor:[UIColor redColor]];
                
                [self updateConnStatus];
            }
            
            break;
            
        default:
            
            break;
    }
}

- (void)updateConnStatus
{
//#ifdef _DGBPRNT
//    NSLog(@"updateConnStatus");
//#endif
    
    BOOL isDeviceOpened    = [[self mtSCRALib] isDeviceOpened];
    BOOL isDeviceConnected = [[self mtSCRALib] isDeviceConnected];
    
    
    if(isDeviceConnected)
    {
        if(isDeviceOpened)
        {
            /*[[self responseDataTextView]    setText:@"Connected"];
            [[self rawResponseDataTextView] setText:@""];
            */
            
            [[self deviceConnectionStatusLabel] setText:@"Device Ready"];
            [[self deviceConnectionStatusLabel] setBackgroundColor:[UIColor greenColor]];
            
            
            
            switch([[self mtSCRALib] getDeviceType])
            {
                case MAGTEKAUDIOREADER:
                    
                   
                    
                    [self setIDynamo:NO];
                    
                    [self setDynaMax:NO];
                    
                     [self setUDynamo:YES];
                    
                    break;
                    
                case MAGTEKIDYNAMO:
                    
                    
                    
                    [self setUDynamo:NO];
                    
                    [self setDynaMax:NO];
                    
                    [self setIDynamo:YES];
                    
                    break;
                    
                case MAGTEKDYNAMAX:
                    
                    
                    
                    [self setUDynamo:NO];
                    
                    
                    [self setIDynamo:NO];
                    
                    [self setDynaMax:YES];
                    
                    
                    
                    
                    break;
                    
                default:
                    
                    break;
            }
        }
        else
        {
            /*[self.deviceConnectionStatusLabel setText:@"Device Not Ready"];
            [self.deviceConnectionStatusLabel setBackgroundColor:[UIColor redColor]];
            
            commandTextField.hidden=YES;
            commandButton.hidden = YES;
            
            [[self audioSwitch] setHidden:NO];
            
            [[self audioSwitch] setOn:NO
                             animated:YES];
            
            [[self iDynamoSwitch] setHidden:NO];
            
            [[self iDynamoSwitch] setOn:NO
                               animated:YES];
            
            [[self dynaMaxSwitch] setHidden:NO];
            
            [[self dynaMaxSwitch] setOn:NO
                               animated:YES];
            
            [[self scanButton] setHidden:YES];
            // [[self mtSCRALib] closeDevice];
             */
            [self setUDynamo:NO];
            
            
            [self setIDynamo:NO];
            
            [self setDynaMax:NO];
            
        }
    }
    else
    {
        //[self.responseDataTextView setText:@"Disconnected"];
        
        [self.deviceConnectionStatusLabel setText:@"Device Not Ready"];
        
        
        [self.deviceConnectionStatusLabel setBackgroundColor:[UIColor redColor]];
        
        //commandTextField.hidden=YES;
        //commandButton.hidden = YES;
        [devSwitch setOn:NO];
        /*[[self audioSwitch] setHidden:NO];
        
        [[self audioSwitch] setOn:NO
                         animated:YES];
        
        [[self iDynamoSwitch] setHidden:NO];
        
        //[[self iDynamoSwitch] setOn:NO
        //                   animated:YES];
        
        [[self dynaMaxSwitch] setHidden:NO];
        
        [[self dynaMaxSwitch] setOn:NO
                           animated:YES];
        
        [[self scanButton] setHidden:YES];
        */
        [self setUDynamo:NO];
        
        
        [self setIDynamo:NO];
        
        [self setDynaMax:NO];
        
        if([self.mtSCRALib getDeviceType] == MAGTEKAUDIOREADER)
        {
            //[[self mtSCRALib] closeDevice];
        }
        //[[self mtSCRALib] closeDevice];
        
        /*[[self volumeSlider] setValue:_curVolume
         animated:YES];*/
        
        if(![self.mtSCRALib isDeviceOpened])
        {
            
            /*
            [[self audioSwitch] setOn:NO animated:YES];
            [[self dynaMaxSwitch] setOn:NO animated:YES];
            [[self iDynamoSwitch]  setOn:NO animated:YES];
             */
            [self setUDynamo:NO];
            
            
            [self setIDynamo:NO];
            
            [self setDynaMax:NO];
        }
    }
}


#pragma mark -
#pragma mark Helper Methods
#pragma mark -

- (void)openDevice
{
    switch([[self mtSCRALib] getDeviceType])
    {
        case MAGTEKAUDIOREADER:
            
            if(![[self mtSCRALib] isDeviceOpened])
            {
                [[self mtSCRALib] openDevice];
            }
            
            [self updateConnStatus];
            
            break;
            
        case MAGTEKIDYNAMO:
            
            [[self mtSCRALib] setDeviceProtocolString:(PROTOCOLSTRING)];
            
            if(![[self mtSCRALib] isDeviceOpened])
            {
                [[self mtSCRALib] openDevice];
            }
            
            break;
            
        case MAGTEKDYNAMAX:
            
            if(![[self mtSCRALib] isDeviceOpened])
            {
                [[self mtSCRALib] openDevice];
            }
            
            break;
    }
}



- (void)closeDevice
{
    if([[self mtSCRALib] isDeviceOpened])
    {
        [[self mtSCRALib] closeDevice];
    }
    
    [[self mtSCRALib] clearBuffers];
    
    [self updateConnStatus];
}

- (void)clearLabels
{
    /*[[self sendCommandTextField]    setText:@""];
    [[self responseDataTextView]    setText:@""];
    [[self responseDataTextView]    setText:@""];*/
    [[self transactionStatusLabel]  setText:@""];
    //[[self rawResponseDataTextView] setText:@""];
    
    [dataResponds setText:@""];
    
}

-(void)displayData: (MTCardData*)cardObjc
{
    
    NSString *pResponse = @"";
    if ([[self.mtSCRALib getTrackDecodeStatus] rangeOfString:@"01"].location == NSNotFound) {
        //[self changeTintColor:UIColorFromRGB(0x05B3B2)];
    } else {
        
        //AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
        //AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        [_soundController playAlertSound:kSystemSoundID_Vibrate];
        [_soundController playSystemSound:kSystemSoundID_Vibrate];
        //[self changeTintColor:UIColorFromRGB(0xBC3D41)];
    }
    
    switch([[self mtSCRALib] getDeviceType])
    {
            
        case MAGTEKAUDIOREADER:
        {
            
            pResponse = [NSString stringWithFormat:@"Response.Type: %@\n\n"
                         "Track.Status: %@\n\n"
                         "Track1.Status: %@\n\n"
                         "Track2.Status: %@\n\n"
                         "Track3.Status: %@\n\n"
                         "Card.Status: %@\n\n"
                         "Encryption.Status: %@\n\n"
                         "Battery.Level: %ld\n\n"
                         "Swipe.Count: %ld\n\n"
                         "Track.Masked: %@\n\n"
                         "Track1.Masked: %@\n\n"
                         "Track2.Masked: %@\n\n"
                         "Track3.Masked: %@\n\n"
                         "Track1.Encrypted: %@\n\n"
                         "Track2.Encrypted: %@\n\n"
                         "Track3.Encrypted: %@\n\n"
                         "Card.PAN: %@\n\n"
                         "MagnePrint.Encrypted: %@\n\n"
                         "MagnePrint.Length: %i\n\n"
                         "MagnePrint.Status: %@\n\n"
                         "SessionID: %@\n\n"
                         "Card.IIN: %@\n\n"
                         "Card.Name: %@\n\n"
                         "Card.Last4: %@\n\n"
                         "Card.ExpDate: %@\n\n"
                         "Card.ExpDateMonth: %@\n\n"
                         "Card.ExpDateYear: %@\n\n"
                         "Card.SvcCode: %@\n\n"
                         "Card.PANLength: %ld\n\n"
                         "KSN: %@\n\n"
                         "Device.SerialNumber: %@\n\n"
                         "Device.Status: %@\n\n"
                         "TLV.CARDIIN: %@\n\n"
                         "MagTek SN: %@\n\n"
                         "Firmware Part Number: %@\n\n"
                         "TLV Version: %@\n\n"
                         "Device Model Name: %@\n\n",
                         cardObjc.responseType,
                         cardObjc.trackDecodeStatus,
                         cardObjc.track1DecodeStatus,
                         cardObjc.track2DecodeStatus,
                         cardObjc.track3DecodeStatus,
                         cardObjc.cardStatus,
                         cardObjc.encryptionStatus,
                         cardObjc.batteryLevel,
                         cardObjc.swipeCount,
                         cardObjc.maskedTracks,
                         cardObjc.maskedTrack1,
                         cardObjc.maskedTrack2,
                         cardObjc.maskedTrack3,
                         cardObjc.encryptedTrack1,
                         cardObjc.encryptedTrack2,
                         cardObjc.encryptedTrack3,
                         cardObjc.cardPAN,
                         cardObjc.encryptedMagneprint,
                         cardObjc.magnePrintLength,
                         cardObjc.magneprintStatus,
                         cardObjc.encrypedSessionID,
                         cardObjc.cardIIN,
                         cardObjc.cardName,
                         cardObjc.cardLast4,
                         cardObjc.cardExpDate,
                         cardObjc.cardExpDateMonth,
                         cardObjc.cardExpDateYear,
                         cardObjc.cardServiceCode,
                         cardObjc.cardPANLength,
                         cardObjc.deviceKSN,
                         cardObjc.deviceSerialNumber,
                         cardObjc.deviceStatus,
                         cardObjc.tagValue,
                         cardObjc.deviceSerialNumberMagTek,
                         cardObjc.firmware,
                         cardObjc.tlvVersion,
                         cardObjc.deviceName];
            
            break;
            
        }
            
        case MAGTEKIDYNAMO:
        {
            
            pResponse = [NSString stringWithFormat:
                         @"Track.Status: %@\n\n"
                         "Track1.Status: %@\n\n"
                         "Track2.Status: %@\n\n"
                         "Track3.Status: %@\n\n"
                         "Encryption.Status: %@\n\n"
                         "Track.Masked: %@\n\n"
                         "Track1.Masked: %@\n\n"
                         "Track2.Masked: %@\n\n"
                         "Track3.Masked: %@\n\n"
                         "Track1.Encrypted: %@\n\n"
                         "Track2.Encrypted: %@\n\n"
                         "Track3.Encrypted: %@\n\n"
                         "Card.PAN: %@\n\n"
                         "Card.IIN: %@\n\n"
                         "Card.Name: %@\n\n"
                         "Card.Last4: %@\n\n"
                         "Card.ExpDate: %@\n\n"
                         "Card.ExpDateMonth: %@\n\n"
                         "Card.ExpDateYear: %@\n\n"
                         "Card.SvcCode: %@\n\n"
                         "Card.PANLength: %ld\n\n"
                         "KSN: %@\n\n"
                         "Device.SerialNumber: %@\n\n"
                         "Firmware Revision Number: %@\n\n"
                         "MagnePrint: %@\n\n"
                         "MagnePrint.Length: %i\n\n"
                         "MagnePrintStatus: %@\n\n"
                         "SessionID: %@\n\n"
                         "Device Model Name: %@\n\n",
                         cardObjc.trackDecodeStatus,
                         cardObjc.track1DecodeStatus,
                         cardObjc.track2DecodeStatus,
                         cardObjc.track3DecodeStatus,
                         cardObjc.encryptionStatus,
                         cardObjc.maskedTracks,
                         cardObjc.maskedTrack1,
                         cardObjc.maskedTrack2,
                         cardObjc.maskedTrack3,
                         cardObjc.encryptedTrack1,
                         cardObjc.encryptedTrack2,
                         cardObjc.encryptedTrack3,
                         cardObjc.cardPAN,
                         cardObjc.cardIIN,
                         cardObjc.cardName,
                         cardObjc.cardLast4,
                         cardObjc.cardExpDate,
                         cardObjc.cardExpDateMonth,
                         cardObjc.cardExpDateYear,
                         cardObjc.cardServiceCode,
                         cardObjc.cardPANLength,
                         cardObjc.deviceKSN,
                         cardObjc.deviceSerialNumber,
                         cardObjc.deviceFirmware,
                         cardObjc.encryptedMagneprint,
                         cardObjc.magnePrintLength,
                         cardObjc.magneprintStatus,
                         cardObjc.encrypedSessionID,
                         cardObjc.deviceName];
            
            break;
            
        }
            
        case MAGTEKDYNAMAX:
        {
            pResponse = [NSString stringWithFormat:
                         @"Track.Status: %@\n\n"
                         "Track1.Status: %@\n\n"
                         "Track2.Status: %@\n\n"
                         "Track3.Status: %@\n\n"
                         "Encryption.Status: %@\n\n"
                         "Battery.Level: %ld\n\n"
                         "Track.Masked: %@\n\n"
                         "Track1.Masked: %@\n\n"
                         "Track2.Masked: %@\n\n"
                         "Track3.Masked: %@\n\n"
                         "Track1.Encrypted: %@\n\n"
                         "Track2.Encrypted: %@\n\n"
                         "Track3.Encrypted: %@\n\n"
                         "Card.PAN: %@\n\n"
                         "Card.IIN: %@\n\n"
                         "Card.Name: %@\n\n"
                         "Card.Last4: %@\n\n"
                         "Card.ExpDate: %@\n\n"
                         "Card.ExpDateMonth: %@\n\n"
                         "Card.ExpDateYear: %@\n\n"
                         "Card.SvcCode: %@\n\n"
                         "Card.PANLength: %ld\n\n"
                         "KSN: %@\n\n"
                         "Device.SerialNumber: %@\n\n"
                         "Firmware Revision Number: %@\n\n"
                         "MagnePrint: %@\n\n"
                         "MagnePrint Length: %i\n\n"
                         "MagnePrintStatus: %@\n\n"
                         "SessionID: %@\n\n"
                         "Device Model Name: %@\n\n",
                         cardObjc.trackDecodeStatus,
                         cardObjc.track1DecodeStatus,
                         cardObjc.track2DecodeStatus,
                         cardObjc.track3DecodeStatus,
                         cardObjc.encryptionStatus,
                         cardObjc.batteryLevel,
                         cardObjc.maskedTracks,
                         cardObjc.maskedTrack1,
                         cardObjc.maskedTrack2,
                         cardObjc.maskedTrack3,
                         cardObjc.encryptedTrack1,
                         cardObjc.encryptedTrack2,
                         cardObjc.encryptedTrack3,
                         cardObjc.cardPAN,
                         cardObjc.cardIIN,
                         cardObjc.cardName,
                         cardObjc.cardLast4,
                         cardObjc.cardExpDate,
                         cardObjc.cardExpDateMonth,
                         cardObjc.cardExpDateYear,
                         cardObjc.cardServiceCode,
                         cardObjc.cardPANLength,
                         cardObjc.deviceKSN,
                         cardObjc.deviceSerialNumber,
                         cardObjc.deviceFirmware,
                         cardObjc.encryptedMagneprint,
                         cardObjc.magnePrintLength,
                         cardObjc.magneprintStatus,
                         cardObjc.encrypedSessionID,
                         cardObjc.deviceName];
            
            break;
        }
            
        default:
        {
            pResponse = [NSString stringWithFormat:
                         @"Track.Status: %@\n\n"
                         "Encryption.Status: %@\n\n"
                         "Track.Masked: %@\n\n"
                         "Track1.Masked: %@\n\n"
                         "Track2.Masked: %@\n\n"
                         "Track3.Masked: %@\n\n"
                         "Track1.Encrypted: %@\n\n"
                         "Track2.Encrypted: %@\n\n"
                         "Track3.Encrypted: %@\n\n"
                         "Card.IIN: %@\n\n"
                         "Card.Name: %@\n\n"
                         "Card.Last4: %@\n\n"
                         "Card.ExpDate: %@\n\n"
                         "Card.SvcCode: %@\n\n"
                         "Card.PANLength: %ld\n\n"
                         "KSN: %@\n\n"
                         "Device.SerialNumber: %@\n\n"
                         "Firmware Revision Number: %@\n\n"
                         "MagnePrint: %@\n\n"
                         "MagnePrintStatus: %@\n\n"
                         "SessionID: %@\n\n"
                         "Device Model Name: %@\n\n",
                         cardObjc.trackDecodeStatus,
                         cardObjc.encryptionStatus,
                         cardObjc.maskedTracks,
                         cardObjc.maskedTrack1,
                         cardObjc.maskedTrack2,
                         cardObjc.maskedTrack3,
                         cardObjc.encryptedTrack1,
                         cardObjc.encryptedTrack2,
                         cardObjc.encryptedTrack3,
                         cardObjc.cardIIN,
                         cardObjc.cardName,
                         cardObjc.cardLast4,
                         cardObjc.cardExpDate,
                         cardObjc.cardServiceCode,
                         cardObjc.cardPANLength,
                         cardObjc.deviceKSN,
                         cardObjc.deviceSerialNumber,
                         cardObjc.deviceFirmware,
                         cardObjc.encryptedMagneprint,
                         cardObjc.magneprintStatus,
                         cardObjc.encrypedSessionID,
                         cardObjc.deviceName];;
            
            break;
            
        }
    }
    
    
    //[[self responseDataTextView] setText:pResponse];
    NSString *tempResponseDataString = [[self mtSCRALib] getResponseData];
    
    if([tempResponseDataString length] != 0 &&
       tempResponseDataString)
    {
       // [[self rawResponseDataTextView] setText:tempResponseDataString];
    }
    
    
    
    [self.mtSCRALib clearBuffers];
    
    
}







/**********************FUNCTION WILL BE DEPRECATED*******************/
- (void)displayData
{
    if([self mtSCRALib] != NULL)
    {
        NSString *pResponse = @"";
        if ([[self.mtSCRALib getTrackDecodeStatus] rangeOfString:@"01"].location == NSNotFound) {
            //[self changeTintColor:UIColorFromRGB(0x05B3B2)];
        } else {
            AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
            //[self changeTintColor:UIColorFromRGB(0xBC3D41)];
        }
        
        switch([[self mtSCRALib] getDeviceType])
        {
                
            case MAGTEKAUDIOREADER:
            {
                
                pResponse = [NSString stringWithFormat:@"Response.Type: %@\n\n"
                             "Track.Status: %@\n\n"
                             "Card.Status: %@\n\n"
                             "Encryption.Status: %@\n\n"
                             "Battery.Level: %ld\n\n"
                             "Swipe.Count: %ld\n\n"
                             "Track.Masked: %@\n\n"
                             "Track1.Masked: %@\n\n"
                             "Track2.Masked: %@\n\n"
                             "Track3.Masked: %@\n\n"
                             "Track1.Encrypted: %@\n\n"
                             "Track2.Encrypted: %@\n\n"
                             "Track3.Encrypted: %@\n\n"
                             "MagnePrint.Encrypted: %@\n\n"
                             "MagnePrint.Length: %i\n\n"
                             "MagnePrint.Status: %@\n\n"
                             "SessionID: %@\n\n"
                             "Card.IIN: %@\n\n"
                             "Card.Name: %@\n\n"
                             "Card.Last4: %@\n\n"
                             "Card.ExpDate: %@\n\n"
                             "Card.SvcCode: %@\n\n"
                             "Card.PANLength: %d\n\n"
                             "KSN: %@\n\n"
                             "Device.SerialNumber: %@\n\n"
                             "Device.Status %@\n\n"
                             "TLV.CARDIIN: %@\n\n"
                             "MagTek SN: %@\n\n"
                             "Firmware Part Number: %@\n\n"
                             "TLV Version: %@\n\n"
                             "Device Model Name: %@\n\n",
                             [self.mtSCRALib getResponseType],
                             [self.mtSCRALib getTrackDecodeStatus],
                             [self.mtSCRALib getCardStatus],
                             [self.mtSCRALib getEncryptionStatus],
                             [self.mtSCRALib getBatteryLevel],
                             [self.mtSCRALib getSwipeCount],
                             [self.mtSCRALib getMaskedTracks],
                             [self.mtSCRALib getTrack1Masked],
                             [self.mtSCRALib getTrack2Masked],
                             [self.mtSCRALib getTrack3Masked],
                             [self.mtSCRALib getTrack1],
                             [self.mtSCRALib getTrack2],
                             [self.mtSCRALib getTrack3],
                             [self.mtSCRALib getMagnePrint],
                             [self.mtSCRALib getMagnePrintLength],
                             [self.mtSCRALib getMagnePrintStatus],
                             [self.mtSCRALib getSessionID],
                             [self.mtSCRALib getCardIIN],
                             [self.mtSCRALib getCardName],
                             [self.mtSCRALib getCardLast4],
                             [self.mtSCRALib getCardExpDate],
                             [self.mtSCRALib getCardServiceCode],
                             [self.mtSCRALib getCardPANLength],
                             [self.mtSCRALib getKSN],
                             [self.mtSCRALib getDeviceSerial],
                             [self.mtSCRALib getDeviceStatus],
                             [self.mtSCRALib getTagValue:TLV_CARDIIN],
                             [self.mtSCRALib getMagTekDeviceSerial],
                             [self.mtSCRALib getFirmware],
                             [self.mtSCRALib getTLVVersion],
                             [self.mtSCRALib getDeviceName]];
                
                break;
                
            }
                
            case MAGTEKIDYNAMO:
            {
                
                pResponse = [NSString stringWithFormat:@"Track.Status: %@\n\n"
                             "Encryption.Status: %@\n\n"
                             "Track.Masked: %@\n\n"
                             "Track1.Masked: %@\n\n"
                             "Track2.Masked: %@\n\n"
                             "Track3.Masked: %@\n\n"
                             "Track1.Encrypted: %@\n\n"
                             "Track2.Encrypted: %@\n\n"
                             "Track3.Encrypted: %@\n\n"
                             "Card.IIN: %@\n\n"
                             "Card.Name: %@\n\n"
                             "Card.Last4: %@\n\n"
                             "Card.ExpDate: %@\n\n"
                             "Card.SvcCode: %@\n\n"
                             "Card.PANLength: %d\n\n"
                             "KSN: %@\n\n"
                             "Device.SerialNumber: %@\n\n"
                             "MagnePrint: %@\n\n"
                             "MagnePrint.Length: %i\n\n"
                             "MagnePrintStatus: %@\n\n"
                             "SessionID: %@\n\n"
                             "Device Model Name: %@\n\n",
                             [self.mtSCRALib getTrackDecodeStatus],
                             [self.mtSCRALib getEncryptionStatus],
                             [self.mtSCRALib getMaskedTracks],
                             [self.mtSCRALib getTrack1Masked],
                             [self.mtSCRALib getTrack2Masked],
                             [self.mtSCRALib getTrack3Masked],
                             [self.mtSCRALib getTrack1],
                             [self.mtSCRALib getTrack2],
                             [self.mtSCRALib getTrack3],
                             [self.mtSCRALib getCardIIN],
                             [self.mtSCRALib getCardName],
                             [self.mtSCRALib getCardLast4],
                             [self.mtSCRALib getCardExpDate],
                             [self.mtSCRALib getCardServiceCode],
                             [self.mtSCRALib getCardPANLength],
                             [self.mtSCRALib getKSN],
                             [self.mtSCRALib getDeviceSerial],
                             [self.mtSCRALib getMagnePrint],
                             [self.mtSCRALib getMagnePrintLength],
                             [self.mtSCRALib getMagnePrintStatus],
                             [self.mtSCRALib getSessionID],
                             [self.mtSCRALib getDeviceName]];
                
                break;
                
            }
                
            case MAGTEKDYNAMAX:
            {
                pResponse = [NSString stringWithFormat:@"Track.Status: %@\n\n"
                             "Track1.Status: %@\n\n"
                             "Track2.Status: %@\n\n"
                             "Track3.Status: %@\n\n"
                             "Encryption.Status: %@\n\n"
                             "Battery.Level: %ld\n\n"
                             "Track.Masked: %@\n\n"
                             "Track1.Masked: %@\n\n"
                             "Track2.Masked: %@\n\n"
                             "Track3.Masked: %@\n\n"
                             "Track1.Encrypted: %@\n\n"
                             "Track2.Encrypted: %@\n\n"
                             "Track3.Encrypted: %@\n\n"
                             "Card.IIN: %@\n\n"
                             "Card.Name: %@\n\n"
                             "Card.Last4: %@\n\n"
                             "Card.ExpDate: %@\n\n"
                             "Card.SvcCode: %@\n\n"
                             "Card.PANLength: %d\n\n"
                             "KSN: %@\n\n"
                             "Device.SerialNumber: %@\n\n"
                             "Firmware Revision Number: %@\n\n"
                             "MagnePrint: %@\n\n"
                             "MagnePrint.Length: %i\n\n"
                             "MagnePrintStatus: %@\n\n"
                             "SessionID: %@\n\n"
                             "Device Model Name: %@\n\n",
                             [self.mtSCRALib getTrackDecodeStatus],
                             [self.mtSCRALib getTrack1DecodeStatus],
                             [self.mtSCRALib getTrack2DecodeStatus],
                             [self.mtSCRALib getTrack3DecodeStatus],
                             [self.mtSCRALib getEncryptionStatus],
                             [self.mtSCRALib getBatteryLevel],
                             [self.mtSCRALib getMaskedTracks],
                             [self.mtSCRALib getTrack1Masked],
                             [self.mtSCRALib getTrack2Masked],
                             [self.mtSCRALib getTrack3Masked],
                             [self.mtSCRALib getTrack1],
                             [self.mtSCRALib getTrack2],
                             [self.mtSCRALib getTrack3],
                             [self.mtSCRALib getCardIIN],
                             [self.mtSCRALib getCardName],
                             [self.mtSCRALib getCardLast4],
                             [self.mtSCRALib getCardExpDate],
                             [self.mtSCRALib getCardServiceCode],
                             [self.mtSCRALib getCardPANLength],
                             [self.mtSCRALib getKSN],
                             [self.mtSCRALib getDeviceSerial],
                             [self.mtSCRALib getFirmware],
                             [self.mtSCRALib getMagnePrint],
                             [self.mtSCRALib getMagnePrintLength],
                             [self.mtSCRALib getMagnePrintStatus],
                             [self.mtSCRALib getSessionID],
                             [self.mtSCRALib getDeviceName]];
                
                break;
            }
                
            default:
            {
                pResponse = [NSString stringWithFormat:@"Track.Status: %@\n\n"
                             "Encryption.Status: %@\n\n"
                             "Track.Masked: %@\n\n"
                             "Track1.Masked: %@\n\n"
                             "Track2.Masked: %@\n\n"
                             "Track3.Masked: %@\n\n"
                             "Track1.Encrypted: %@\n\n"
                             "Track2.Encrypted: %@\n\n"
                             "Track3.Encrypted: %@\n\n"
                             "Card.IIN: %@\n\n"
                             "Card.Name: %@\n\n"
                             "Card.Last4: %@\n\n"
                             "Card.ExpDate: %@\n\n"
                             "Card.SvcCode: %@\n\n"
                             "Card.PANLength: %d\n\n"
                             "KSN: %@\n\n"
                             "Device.SerialNumber: %@\n\n"
                             "MagnePrint: %@\n\n"
                             "MagnePrintStatus: %@\n\n"
                             "SessionID: %@\n\n"
                             "Device Model Name: %@\n\n",
                             [self.mtSCRALib getTrackDecodeStatus],
                             [self.mtSCRALib getEncryptionStatus],
                             [self.mtSCRALib getMaskedTracks],
                             [self.mtSCRALib getTrack1Masked],
                             [self.mtSCRALib getTrack2Masked],
                             [self.mtSCRALib getTrack3Masked],
                             [self.mtSCRALib getTrack1],
                             [self.mtSCRALib getTrack2],
                             [self.mtSCRALib getTrack3],
                             [self.mtSCRALib getCardIIN],
                             [self.mtSCRALib getCardName],
                             [self.mtSCRALib getCardLast4],
                             [self.mtSCRALib getCardExpDate],
                             [self.mtSCRALib getCardServiceCode],
                             [self.mtSCRALib getCardPANLength],
                             [self.mtSCRALib getKSN],
                             [self.mtSCRALib getDeviceSerial],
                             [self.mtSCRALib getMagnePrint],
                             [self.mtSCRALib getMagnePrintStatus],
                             [self.mtSCRALib getSessionID],
                             [self.mtSCRALib getDeviceName]];
                
                break;
                
            }
        }
        
      //  [[self responseDataTextView] setText:pResponse];
        
        
        NSString *tempResponseDataString = [[self mtSCRALib] getResponseData];
        
        if([tempResponseDataString length] != 0 &&
           tempResponseDataString)
        {
           // [[self rawResponseDataTextView] setText:tempResponseDataString];
        }
        
        
        
        [self.mtSCRALib clearBuffers];
    }
}


-(void)setUDynamo:(BOOL)isOn{

   // [self cancel_clicked:nil];
    if([self.mtSCRALib isDeviceOpened])
        [self.mtSCRALib closeDevice];
    
    if(isOn)
    {
//#ifdef _DGBPRNT
//        NSLog(@"setAudioSwitch:ON");
//#endif
        
        [self setIDynamo:NO];
        [self setDynaMax:NO];
        
      //  [_dynaMaxSwitch setHidden:YES];
        //[_iDynamoSwitch setHidden:YES];
        
        [[self mtSCRALib] setDeviceType:MAGTEKAUDIOREADER];
        [self openDevice];
        if(_mtSCRALib.isDeviceConnected)
        {
            MPMusicPlayerController* musicPlayer = [MPMusicPlayerController applicationMusicPlayer];
            
            _curVolume = musicPlayer.volume;
            
            [musicPlayer setVolume:1];
            
            
            
            
        }
        else
        {
            [_mtSCRALib closeDevice];
            //[(UISwitch*)sender setOn: NO animated:YES];
        }
    }
    else
    {
//#ifdef _DGBPRNT
     //   NSLog(@"setAudioSwitch:OFF");
//#endif
        
        
        
        MPMusicPlayerController* musicPlayer = [MPMusicPlayerController applicationMusicPlayer];
        
        //_curVolume = musicPlayer.volume;
        
        [musicPlayer setVolume:_curVolume];
        
        [self closeDevice];
        
        
        // self.volumeView = nil;
       // [_dynaMaxSwitch setHidden:NO];
       // [_iDynamoSwitch setHidden:NO];
        //[_audioSwitch setHidden:NO];
        
    }
    
}


-(void)setIDynamo:(BOOL)isOn{

    //[self cancel_clicked:nil];
    if([self.mtSCRALib isDeviceOpened])
        [self.mtSCRALib closeDevice];
    
    if(isOn)
    {
#ifdef _DGBPRNT
        NSLog(@"setIDynamo:ON");
#endif
        [self setUDynamo:NO];
        [self setDynaMax:NO];
        
        //[_audioSwitch setHidden:YES];
        //[_dynaMaxSwitch setHidden:YES];
        [[self mtSCRALib] setDeviceType:MAGTEKIDYNAMO];
        
        [self openDevice];
        
        if(!_mtSCRALib.isDeviceConnected)
        {
            //[(UISwitch*)sender setOn:NO animated:YES];
            //[self closeDevice];
            return;
            
        }
        
        
        
        
    }
    else
    {
#ifdef _DGBPRNT
        NSLog(@"setIDynamo:OFF");
#endif
        //[_audioSwitch setHidden:NO];
        //[_dynaMaxSwitch setHidden:NO];
        [self closeDevice];
    }
}

-(void)setDynaMax:(BOOL)isOn{

    if([self.mtSCRALib isDeviceOpened])
        [self.mtSCRALib closeDevice];
    
    
    if(isOn)
    {
#ifdef _DGBPRNT
        NSLog(@"setDynaMax:ON");
#endif
        
        [self setIDynamo:NO];
        [self setUDynamo:NO];
        
        // [[self scanButton] setHidden:NO];
        
        [[self mtSCRALib] setDeviceType:MAGTEKDYNAMAX];
        
        if(![[self mtSCRALib] isDeviceOpened])
        {
            // load previously connected Peripheral's UUID (if any)
            NSString *uuidString = [self loadPeripheral];
            
            // If a previous Peripheral's UUID exists we connect to it
            if(![uuidString isEqualToString:@""] && uuidString != nil)
            {
                [[self mtSCRALib] setUUIDString:uuidString];
            }
            else
            {
                [[self mtSCRALib] setUUIDString:@""];
                
            }
        }
        
        [self openDevice];
        if(_curPeripheral)
        {
            _noPicker = YES;
            UIAlertView * alert =[[UIAlertView alloc ] initWithTitle:@"Reconnect"
                                                             message:@"Reconnect to previous device?"
                                                            delegate:self
                                                   cancelButtonTitle:@"No"
                                                   otherButtonTitles: nil];
            [alert addButtonWithTitle:@"Yes"];
            [alert show];
        }
        else [self performSelector:@selector(onScanButtonPressed:) withObject:nil afterDelay:.1];
        
        
    }
    else
    {
        
        //[self cancel_clicked:nil];
#ifdef _DGBPRNT
        NSLog(@"setDynaMax:OFF");
#endif
        
        //[[self scanButton] setHidden:YES];
        
        [self closeDevice];
    }
}



#pragma mark -
#pragma mark Data Persistence Helper Methods
#pragma mark -

- (void)savePeripheral
{
    // retrieve the currently connected Peripheral information
    //CBPeripheral *peripheral = [[self mtSCRALib] getConnectedPeripheral];
    
    // store the Peripheral information for automatic connection later
    NSUserDefaults *userDefaults           = [NSUserDefaults standardUserDefaults];
    NSMutableArray *newDevicesMutableArray = [[NSMutableArray alloc] init];
    
    NSString *uuidString = _curPeripheral.identifier.UUIDString;//CFBridgingRelease(CFUUIDCreateString(kCFAllocatorDefault, _curPeripheral.UUID));
    
    if(![uuidString isEqualToString:@""])
    {
        [newDevicesMutableArray addObject:uuidString];
        
        [userDefaults setObject:newDevicesMutableArray
                         forKey:@"storedPeripheral"];
        
        [userDefaults synchronize];
    }
    else
    {
    }
}

- (NSString *)loadPeripheral
{
    // retrieve the stored Peripheral if any
    NSUserDefaults *userDefaults     = [NSUserDefaults standardUserDefaults];
    NSArray        *peripheralArray  = [userDefaults   objectForKey:@"storedPeripheral"];
    
    if([peripheralArray isKindOfClass:[NSArray class]])
    {
        if([peripheralArray count] > 0)
        {
            for(id deviceUUIDString in peripheralArray)
            {
                if(![deviceUUIDString isKindOfClass:[NSString class]])
                {
                    continue;
                }
                
                return deviceUUIDString;
            }
        }
    }
    
    return @"";
}

- (void)removePeripheral
{
    // remove the stored Peripheral connection
    NSUserDefaults *userDefaults           = [NSUserDefaults standardUserDefaults];
    NSArray        *peripheralArray        = [userDefaults objectForKey:@"storedPeripheral"];
    NSMutableArray *newDevicesMutableArray = [[NSMutableArray alloc] init];
    CBPeripheral   *peripheral             = [[self mtSCRALib] getConnectedPeripheral];
    
    if([peripheralArray isKindOfClass:[NSArray class]])
    {
        newDevicesMutableArray = [NSMutableArray arrayWithArray:peripheralArray];
        
        NSString *uuidString = peripheral.identifier.UUIDString;// [NSString stringWithFormat:@"%@", CFBridgingRelease(CFUUIDCreateString(kCFAllocatorDefault, peripheral.UUID))];
        
        if(uuidString)
        {
            [newDevicesMutableArray removeObject:uuidString];
        }
        
        [userDefaults setObject:newDevicesMutableArray
                         forKey:@"storedPeripheral"];
        
        [userDefaults synchronize];
    }
}

#endif

- (IBAction)discountsAction:(id)sender {
}
- (IBAction)tipAction:(id)sender {
}

-(void)performCardSwiped:(NSNotification *)notification{
     //NSLog(@"cardNumber=%@ cardName=%@ cardExpDate=%@",cardNumber,cardName,cardExpDate);
    /*
    self.stripeCard.name = self.nameTextField.text;
    //self.stripeCard.number = self.cardNumber.text;
    self.stripeCard.cvc = self.CVCNumber.text;
    self.stripeCard.expMonth = [self.selectedMonth integerValue];
    self.stripeCard.expYear = [self.selectedYear integerValue];
    */
   // if([readyToSwipeCard isFocused]){
        [readyToSwipeCard dismissWithClickedButtonIndex:0 animated:YES];
   // }
    self.nameTextField.text=[notification.userInfo valueForKey:@"cardName"];
    self.cardNumber.text=[notification.userInfo valueForKey:@"cardNumber"];;
    //self.CVCNumber.text=[notification.userInfo valueForKey:@"cardCVC"];
    self.selectedMonth =@([[notification.userInfo valueForKey:@"cardExpMonth"] integerValue]);
    self.selectedYear =@([[notification.userInfo valueForKey:@"cardExpYear"] integerValue]);
    [self.tableView reloadData];
    [self completeButtonTapped:self];
    
}

-(void)performReadyToSwipeCard:(NSNotification *)notification{
    if(readyToSwipeCard){
        [readyToSwipeCard setMessage:@"Ready to swipe card..."];
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if([alertView isEqual:readyToSwipeCard]){
        
    }
}

//-(void)printReceipt{
//    {
//        
//        
//        //[self setOrderStatus:ORDER_STATUS_CAPTURED];
//        /* NSData *pdfData=[PrintManager PDFData:[selectedOrder toStringLabel]];
//         
//         if ([UIPrintInteractionController canPrintData:pdfData]) {
//         UIPrintInfo *printInfo = [UIPrintInfo printInfo];
//         //printInfo.jobName = self.imageURL.lastPathComponent;
//         printInfo.outputType = UIPrintInfoOutputGeneral;
//         
//         UIPrintInteractionController *printController = [UIPrintInteractionController sharedPrintController];
//         printController.printInfo = printInfo;
//         
//         printController.printingItem = pdfData;//self.imageURL;
//         
//         //[printController presentAnimated:true completionHandler: nil];
//         if(_appDelegate.isIpad){
//         [printController presentFromRect:self.view.frame inView:self.view animated:YES completionHandler:nil];
//         }
//         
//         }
//         */
//        UIPrintInteractionController *pic = [UIPrintInteractionController sharedPrintController];
//        pic.delegate = self;
//        
//        UIPrintInfo *printInfo = [UIPrintInfo printInfo];
//        printInfo.outputType = UIPrintInfoOutputGeneral;
//        printInfo.jobName = @"My Great Prompt";
//        pic.printInfo = printInfo;
//        
//        NSString *msgBody = [selectedOrder toStringLabel];
//        
//        
//        UISimpleTextPrintFormatter *textFormatter = [[UISimpleTextPrintFormatter alloc]
//                                                     initWithText:msgBody];
//        textFormatter.startPage = 0;
//        textFormatter.contentInsets = UIEdgeInsetsMake(72.0, 72.0, 72.0, 72.0); // 1 inch margins
//        textFormatter.maximumContentWidth = 6 * 72.0;
//        pic.printFormatter = textFormatter;
//        pic.showsPageRange = YES;
//        
//        void (^completionHandler)(UIPrintInteractionController *, BOOL, NSError *) =
//        ^(UIPrintInteractionController *printController, BOOL completed, NSError *error) {
//            if (!completed && error) {
//                NSLog(@"Printing could not complete because of error: %@", error);
//            }
//        };
//        
//        if([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
//            [pic presentFromRect:self.view.frame
//                          inView:self.view
//                        animated:YES
//               completionHandler:completionHandler];
//        }
//        else {
//            [pic presentAnimated:YES completionHandler:completionHandler];
//            
//        }
//        
//    }
//}

@end
