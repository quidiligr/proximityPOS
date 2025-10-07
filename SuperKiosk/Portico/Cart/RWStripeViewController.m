//
//  PaymentViewController.m

#import "RWStripeViewController.h"
#import "CheckoutCart.h"
//#import "ConnectionsViewController.h"
//#import "RWEmailManager.h"

#import "CheckoutInputCell.h"
#import "CheckoutDisplayCell.h"
#import "PaymentSelectCell.h"
#import "CCardsViewController.h"
#import <AFNetworking/AFNetworking.h>


#import "Stripe.h"
//#import "CardInfo.h"
#import "AppDelegate.h"
#import "BroadcastMessageAPI.h"
#import "DiscountItem.h"
#import "defs.h"

//#define ALERT_TAG_TIP 20
//#define ALERT_TAG_PROMO 21
#define MAX_TIP_PCT 25.0
#define MIN_TIP_PCT 10.0

//#define STRIPE_TEST_POST_URL @""

@interface RWStripeViewController () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UIAlertViewDelegate>
{
    UIAlertView *processWait;
    NSTimer *processTimer;
    
    UIAlertView *alertConfirmAmount;
    //long confirmedAmount;
    //NSInteger confirmed_totalCents;
    //NSInteger totalCents;
    
    CCardInfo *selectedCard;
    BOOL rememberMe;
    
    
    NSInteger confirmed_totalCents;
    NSInteger totalCents;
    NSInteger totalCentsBeforeTip;
    float totalTip;
    NSNumberFormatter *nf;
    
    NSMutableArray *discounts;
    NSInteger totalDiscount;
    
    double t1;
    
}
@property (strong, nonatomic) IBOutlet UITableView* tableView;
@property (strong, nonatomic) IBOutlet UIView* buttonView;
@property (strong, nonatomic) IBOutlet UIButton* completeButton;

//@property (strong, nonatomic) UITextField* nameTextField;
@property (strong, nonatomic) UITextField* emailTextField;
@property (strong, nonatomic) UITextField* tableNumberTextField;
@property (strong, nonatomic) UITextField* chargeTextField; //read only
@property (strong, nonatomic) UITextField* tipTextField;
@property (strong, nonatomic) UITextField* promoCodeTextField;
@property (strong, nonatomic) IBOutlet UILabel *acceptedCardsLabel;
@property (strong, nonatomic) IBOutlet UIButton *tipButton;
@property (weak, nonatomic) IBOutlet UILabel *ccTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *ccLast4Label;
@property (weak, nonatomic) IBOutlet UISwitch *useCreditCardSwitch;

/*@property (strong, nonatomic) UITextField* expirationDateTextField;
@property (strong, nonatomic) UITextField* cardNumber;
@property (strong, nonatomic) UITextField* CVCNumber;

@property (strong, nonatomic) NSArray* monthArray;
@property (strong, nonatomic) NSNumber* selectedMonth;
@property (strong, nonatomic) NSNumber* selectedYear;
@property (strong, nonatomic) UIPickerView *expirationDatePicker;
*/
@property (strong, nonatomic) AFJSONRequestOperation* httpOperation;
@property (strong, nonatomic) STPCard* stripeCard;
//@property (strong, nonatomic) CardInfo* stripeCard;

@property (nonatomic, strong) AppDelegate *appDelegate;
@end

@implementation RWStripeViewController
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
    //self.view.backgroundColor=[UIColor clearColor];
    //[self.tableView setBackgroundColor:[UIColor clearColor]];
	// Do any additional setup after loading the view.
    _appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    nf=[[NSNumberFormatter alloc] init];
    /*self.monthArray = @[@"01 - January", @"02 - February", @"03 - March",
    @"04 - April", @"05 - May", @"06 - June", @"07 - July", @"08 - August", @"09 - September",
    @"10 - October", @"11 - November", @"12 - December"];
    */
    
    
    /*if(_appDelegate.userInfo.ccExpMonth==nil)
        _appDelegate.userInfo.ccExpMonth=@1;
    
    if(_appDelegate.userInfo.ccExpYear==nil){
        //Expiration year
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy"];
        NSInteger currentYear = [[dateFormatter stringFromDate:[NSDate date]] integerValue];
        _appDelegate.userInfo.ccExpYear=[NSNumber numberWithInteger:currentYear];
    }
    
    _selectedMonth=_appDelegate.userInfo.ccExpMonth;
    
    _selectedYear=_appDelegate.userInfo.ccExpYear;
    */
    
   /* [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(performChargeSuccess:)
                                                 name:NOTIFY_CHARGE_SUCCESS_CARD
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(peformDisConnected:)
                                                 name:NOTIFY_MCDIDCHANGESTATE_DISCONNECTED
                                               object:nil];

    */
    
    processWait=[[UIAlertView alloc] initWithTitle:@"Credicard Processing"  message:@"Please wait..." delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didReceiveMenuSettingsWithNotification:)
                                                 name:NOTIFY_RECEIVED_MENU_SETTINGS
                                               object:nil];
    //CGRect frame=[self maximumUsableFrame];
    //[UIScreen mainScreen]
    //self.tableView.frame=CGRectMake(frame.origin.x, frame.origin.y, frame.size.height-self.tabBarController.tabBar.frame.size.height, frame.size.width);
    
    //self.tableView.frame=[AppDelegate maximumUsableFrame:self];
    
}
-(void)peformDisConnected:(NSNotification *)notification{
    dispatch_async(dispatch_get_main_queue(), ^{
        //UIViewController *vc=[self.navigationController.viewControllers objectAtIndex:0];
        //[self.navigationController popToViewController:vc animated:YES];
        [self.navigationController popToRootViewControllerAnimated:YES];
    });
    
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
-(void)viewDidAppear:(BOOL)animated{
    [self reloadData];
   
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Stripe

- (IBAction)cancelButtonTapped:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)completeButtonTapped:(id)sender {
    if(!_appDelegate.selectedStore.isConnected ){
       if(_appDelegate.selectedStore.allowDelivery || _appDelegate.selectedStore.allowPickUp){
            if(_appDelegate.selectedStore.allowPickUp){
                
                
            }
            else{ //(_appDelegate.selectedStore.allowDelivery){
                
            }
        }
        else{
            [AppDelegate toast:@"Please connect to continue." duration:3.0];
        }
        return;
    }
    
    
    
    [AppDelegate toast:@"Processing...please wait." duration:3];
    //CheckoutCart *cart=[CheckoutCart sharedInstance];
    /*
    if(![_appDelegate isConnectedToStore:cart.currentStoreID]){
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Please connect to continue." message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }
     */
    //[self startCharge];
   // if(selectedCard==nil){
        if(_appDelegate.appConfig.isLive){
            if( selectedCard==nil){
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
                        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:nil message:@"You haven't setup a default credit card to use." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Continue", nil];
                        [alert show];
                        
                    }
                }
                else{
                    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:nil message:@"You haven't setup a default credit card to use." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Continue", nil];
                    [alert show];
                    
                    
                    
                }
            }
            else{
                [self completeOrder];
            }
        }
        else {
        
            [self completeOrder];
        }
  

    
    
}
-(void)completeOrder{
    NSArray *existing=[_appDelegate.historyModel searchPendingOrdersWithStore:_appDelegate.selectedStore isLive:_appDelegate.appConfig.isLive];
    
    if([existing count]>0){
       
        if([existing count]>0){
            
            for (int i=0; i<[existing count]; i++) {
               
                ((OrderHistory *)existing[i]).orderStatus=@ORDER_STATUS_FAILED;
            }
            [_appDelegate.historyModel saveHistory];
        }
        
    }
    
        [self performCreateOrder ];
   
}

-(void)performCreateOrder{
    OrderHistory *order=[self createOrderFromCart];
    
    
   
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_NEW_ORDER object:nil userInfo:@{@"order":order}];
    
   
    
    [self.navigationController popToRootViewControllerAnimated:YES];
    
    if(_appDelegate.isIpad){
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_SHOW_ORDERHISTORY object:nil];
    }
    
    [self.tabBarController setSelectedIndex:TAB_INDEX_CHAT];
    //[_appDelegate.orderChatViewController.navigationController popToRootViewControllerAnimated:NO];
    
    
}

-(void)showConfirmAmount{
    
    
    //NSString *confirmed_stripeAmount = @"Confirm Amount $";
    
    
    alertConfirmAmount=[[UIAlertView alloc] initWithTitle:@"Confirm Amount $" message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:BTN_CONFIRM_AMOUNT_CONTINUE, nil] ;
    
    alertConfirmAmount.alertViewStyle=UIAlertViewStylePlainTextInput;
    
    alertConfirmAmount.tag=TAG_CONFIRM_AMOUNT;
    [alertConfirmAmount textFieldAtIndex:0].text=[NSString stringWithFormat:@"%.02f", (double)confirmed_totalCents/100];
    [alertConfirmAmount textFieldAtIndex:0].placeholder=@"required";
   
    [alertConfirmAmount show];
    
}


/*
- (void)performStripeOperationMulti {
    //1
    self.completeButton.enabled = NO;
    
    //2
    CheckoutCart* checkoutCart = [CheckoutCart sharedInstance];
    // NSInteger totalCents = [[checkoutCart total] doubleValue] * 100;
    NSString* textLabel=[checkoutCart textLabel];
    
    NSString *stripeAmount = [NSString stringWithFormat:@"%ld", (long)confirmed_totalCents];
    NSString *stripeCurrency = @"usd";
    NSString *stripeToken = @"";//token;
    NSString *stripeDescription = textLabel;//@"Purchase from Portico iOS app!";
    
    
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSString *today=[dateFormatter stringFromDate:[NSDate date]];
    
    OrderHistory *order=[[OrderHistory alloc] init];
    order.orderBy=self.nameTextField.text;
    order.orderTableNumber=self.tableNumberTextField.text;
    order.orderID=[[[NSUUID UUID] UUIDString] lowercaseString];
    order.orderNumber=@0;
    order.chargePayType=ORDER_PAY_TYPE_CCARD;
    order.orderDetailText=textLabel;
    order.orderDateTime=[NSDate date];
    order.orderDate=[dateFormatter dateFromString:today];
    order.orderDay=today;
    order.orderStatus=@ORDER_STATUS_START;
    order.orderStoreID=_appDelegate.selectedStore.peerInfo.deviceID;
    
    order.chargeAmount=@0;//[NSNumber numberWithInteger:totalCents]; //stripeAmount;
    order.chargeCurrency=stripeCurrency;
    order.chargeToken=stripeToken;
    order.chargeDescription=stripeDescription;
    
    
    HistoryModel *historyModel=[HistoryModel sharedInstance];
    
    [historyModel addHistory:today withOrder:order];
    
    NSDictionary *order_dict=[order toJSONDictionary];
    
    
    NSDictionary *card_info_dict=@{@"name":self.stripeCard.name,
                                   @"email":self.stripeCard.email,
                                   @"number":self.stripeCard.number,
                                   @"cvc":self.stripeCard.cvc,
                                   @"expMonth":[NSNumber numberWithUnsignedInteger:self.stripeCard.expMonth],
                                   @"expYear":[NSNumber numberWithUnsignedInteger:self.stripeCard.expYear]};
    
    
    
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
        message.toPeerInfo=_appDelegate.mcManager.serverPeerInfo;
        message.message_type=MSG_TYPE_REQUEST;
        message.localCopy=NO;
        
        NSDictionary *dict = @{KEY_SEND_MESSAGE: message
                               };
        
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_HAS_DATA_TO_SEND
                                                            object:nil
                                                          userInfo:dict];
        
        processTimer=[NSTimer scheduledTimerWithTimeInterval:15.0 target:self selector:@selector(chargeTimedOut) userInfo:nil repeats:NO];
        [processWait show];
        
    }
    else{
        //return;
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Error 100" message:@"There was an error processing your request. Please see attendant for help." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        
    }
    
    
    
}
*/

/*
- (void)performStripeOperation{ //cents
    //1
    self.completeButton.enabled = NO;
    
    BOOL hasInternet=NO;
    
    if(hasInternet){
    
    //STPAPIClient *client = [[STPAPIClient alloc] initWithPublishableKey:STRIPE_TEST_PUBLIC_KEY];
    STPAPIClient *client;
    if(_appDelegate.appConfig.isLive)
        client = [[STPAPIClient alloc] initWithPublishableKey:_appDelegate.selectedStore.peerInfo.paymentPublishableKey];
    else
         client = [[STPAPIClient alloc] initWithPublishableKey:_appDelegate.selectedStore.peerInfo.paymentPublishableKeyTest];
    [client createTokenWithCard:self.stripeCard completion:
     //get stripe token if stripe is used
 
     ^(STPToken* token,NSError *error){
         if(error)
             [self handleStripeError:error];
         else{
             //order.chargeToken=token.tokenId;
             //[self performPostCharge:order cardInfo:card fromPeer:peerInfo];
             [self performCharge:token.tokenId];
         }
     }];
    }
    else{
        [self performCharge:nil];
    }
    
    
    
}

*/

//-(void)startCharge{
//    //1
//   
//    //check connectivity
//    //check if connected
//    //first see if it's in range then auto connect else notify out of range
//    
//    //1 check if within range
//    /*if([_appDelegate.mcManager.peerDevices count]==0){
//        //[AppDelegate toast:@"Your device currently out of range" duration:<#(int)#>]
//        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Out of range" message:[NSString stringWithFormat:@"This transaction cannot be completed. Please try again later."] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//        [alert show];
//        return;
//    }
//*/
//    
//    //long l=(long)MCSessionStateConnected;
//    //NSPredicate *predicate=[NSPredicate predicateWithFormat:@"sessionState==%ld",l];
//    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"deviceID==%@",[_appDelegate.selectedStore.inventory_dict valueForKey:@"deviceID"]];
//    //NSPredicate *predicate=[NSPredicate predicateWithFormat:@"sessionState==2",l];
//    NSArray *result= [_appDelegate.mcManager.peerDevices filteredArrayUsingPredicate:predicate] ;
//    
//    //if(_appDelegate.mcManager.serverPeerInfo!=nil && _appDelegate.selectedStore.peerInfo.sessionState==MCSessionStateConnected && [_appDelegate.selectedStore.peerInfo.deviceID isEqualToString:<#(NSString *)#>])
//    
//    if ([result count]>0) {
//        PeerInfo *peer=[result firstObject];
//        if(peer.sessionState!=MCSessionStateConnected){
//            //add to queue
//            if(_appDelegate.chargeQueue==nil)
//                _appDelegate.chargeQueue=[NSMutableArray new];
//            
//            NSDictionary *q=@{deviceIDKey:[_appDelegate.selectedStore.inventory_dict valueForKey:deviceIDKey]};
//            
//            if(![_appDelegate.chargeQueue containsObject:q])
//                [_appDelegate.chargeQueue addObject:q];
//            
//            
//            
//        }
//        else{
//            //[self completeCharge];
//        }
//    }
//    else{
//        if(_appDelegate.chargeQueue==nil)
//            _appDelegate.chargeQueue=[NSMutableArray new];
//        NSDictionary *q=@{deviceIDKey:[_appDelegate.selectedStore.inventory_dict valueForKey:deviceIDKey]};
//        
//        if(![_appDelegate.chargeQueue containsObject:q])
//            [_appDelegate.chargeQueue addObject:q];
//
//        //[AppDelegate toast:@"Your device currently out of range" duration:<#(int)#>]
//        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Out of range" message:[NSString stringWithFormat:@"The device needs to be nearby the store to complete this transaction."] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//        [alert show];
//        //return;
//    }
//    
//    //_appDelegate.selectedStore.peerInfo.deviceID
//    
//    /*NSTimer *timer;
//    processTimer=[NSTimer scheduledTimerWithTimeInterval:30.0 target:self selector:@selector(performCharge:) userInfo:nil repeats:NO];
//    [processWait show];
//     */
//    
//}

//-(void) didConnectNotification:(NSNotification *)notification{
//    //will finish startCharge
//    //[[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFY_MCDIDCHANGESTATE_CONNECTED object:nil];
//    //[self performCharge:<#(NSString *)#>]
//    if([_appDelegate.chargeQueue count]>0){
//        //if(![_appDelegate.chargeQueue containsObject:q])
//          //  [_appDelegate.chargeQueue addObject:q];
//        NSDictionary *existing_q;
//        for (NSDictionary *item in _appDelegate.chargeQueue) {
//            if([[item valueForKey:@"deviceID"] isEqualToString:[_appDelegate.selectedStore.inventory_dict valueForKey:@"deviceID"]]){
//                existing_q=item;
//                break;
//            }
//        }
//        if(existing_q!=nil){
//            //NSString *token=[existing_q valueForKey:@"token"];
//            //if (token!=nil && [token length]>0) {
//#if DEBUG
//                NSLog(@"completeCharge called.");
//#endif
//                [self completeCharge];
//            //}
//            [_appDelegate.chargeQueue removeObject:existing_q];
//        }
//        
//        
//    }
//    
//}

//-(void)performCharge:(NSString *)token{
-(void)performCharge:(NSString *)token withOrder:(OrderHistory *)order{
    //HistoryModel *historyModel=[HistoryModel sharedInstance];
    
    
    
    NSDictionary *order_dict=[order toJSONDictionary];
    
    
    NSDictionary *card_info_dict=@{@"name":self.stripeCard.name,
                                   @"email":(_appDelegate.appConfig.userInfo.email)?_appDelegate.appConfig.userInfo.email:@"", // self.stripeCard.email,
                                   @"number":self.stripeCard.number,
                                   @"cvc":self.stripeCard.cvc,
                                   @"expMonth":[NSNumber numberWithUnsignedInteger:self.stripeCard.expMonth],
                                   @"expYear":[NSNumber numberWithUnsignedInteger:self.stripeCard.expYear]};
    
    // order.cardInfo=card_info_dict;
    
    [_appDelegate.historyModel addOrUpdateOrderHistory:order];
    
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
        processTimer=[NSTimer scheduledTimerWithTimeInterval:30.0 target:self selector:@selector(chargeTimedOut:) userInfo:nil repeats:NO];
        [processWait show];
        
    }
    else{
        //return;
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Error 100" message:@"There was an error processing your request. Please see attendant for help." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        
    }


}

-(OrderHistory *)createOrderFromCart{
        //2
    //CheckoutCart* checkoutCart = [CheckoutCart sharedInstance];
    
        [self computeTotals];
    
    
    
    confirmed_totalCents=totalCents;
    
    //NSString* textLabel=[_appDelegate.selectedStore.cart textLabel:[_appDelegate.selectedStore.inventory_dict valueForKey:deviceNameKey] storeID:[_appDelegate.selectedStore.inventory_dict valueForKey:deviceIDKey]];
    NSString* textLabel=[_appDelegate.selectedStore.cart textLabel:_appDelegate.selectedStore.storeName storeID:_appDelegate.selectedStore.deviceID];

    
   
    NSString *stripeCurrency = (_appDelegate.selectedStore.inventory.currency.length==0)?@"usd":_appDelegate.selectedStore.inventory.currency;
    
   
    NSString *stripeDescription = textLabel;//@"Purchase from Portico iOS app!";
    

    
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSString *today=[dateFormatter stringFromDate:[NSDate date]];
    
    
    
    OrderHistory *order=[[OrderHistory alloc] init];
   
    order.orderBy=selectedCard.name;//self.nameTextField.text;
    order.orderTableNumber=self.tableNumberTextField.text;
    order.orderDiscountCode=self.promoCodeTextField.text;
    
    
    if(totalTip<0)
        totalTip=0;
    
    order.orderTip=totalTip*100;
    
    order.orderID=[[[NSUUID UUID] UUIDString] lowercaseString];
    order.orderNumber=@0;
    order.chargePayType=ORDER_PAY_TYPE_CCARD;
   
    //get order items
    order.orderItems=[NSArray arrayWithArray:_appDelegate.selectedStore.cart.itemsArray];
    
    if([discounts count]>0){
        order.orderDiscounts=[NSArray arrayWithArray:discounts];
    }
    
    
    if(order.orderPayments==nil)
        order.orderPayments=[NSMutableArray new];
    
    
    order.orderDateTime=[NSDate date];
    order.orderDate=[dateFormatter dateFromString:today];
    order.orderDay=today;
    order.orderStatus=@ORDER_STATUS_START;
    order.orderStoreID=_appDelegate.selectedStore.deviceID;//.peerInfo.deviceID;
    order.orderStoreNum=_appDelegate.selectedStore.storeNum;
    order.orderStoreName=_appDelegate.selectedStore.storeName;//.peerInfo.peerID.displayName;
    order.orderIsLive=_appDelegate.appConfig.isLive;
    order.orderDeviceID=_appDelegate.appConfig.userInfo.deviceID;
    order.orderDeviceToken=_appDelegate.appConfig.userInfo.deviceToken;
    
    
    float tax=_appDelegate.selectedStore.inventory.salesTax;
    order.orderTax=tax;
    order.orderAmountDue=totalCents;
    order.chargeAmount=confirmed_totalCents; //stripeAmount;
    order.chargeCurrency=stripeCurrency;

    order.chargeDescription=stripeDescription;
    [_appDelegate.historyModel addOrUpdateOrderHistory:order];
   
    [_appDelegate clearCart];
    [self updateCartBadge];
        return order;
    
    
}
-(void)updateCartBadge{
    UITabBarItem *tbi=(UITabBarItem *)[self.tabBarController.tabBar.items objectAtIndex:TAB_INDEX_CART];
    if([_appDelegate.selectedStore.cart.itemsArray count]==0)
        tbi.badgeValue=nil;
    else
        tbi.badgeValue=[NSString stringWithFormat:@"%lu",(unsigned long)[_appDelegate.selectedStore.cart.itemsArray count]];
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
- (void)postStripeTokenHTTP:(NSString* )token {
   /* NSString *STRIPE_TEST_POST_URL=[NSString stringWithFormat:@"%@stripe", _appDelegate.selectedStore.peerInfo.homeUrl];
    
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
    //OrderHistory *order=(OrderHistory *)[notification.userInfo valueForKey:@"order"];
    [self chargeDidNotSuceed];
}
-(void)performChargeSuccess:(NSNotification *)notification{
    OrderHistory *order=(OrderHistory *)[notification.userInfo valueForKey:@"order"];
    [self chargeDidSucceed:order];
  
}



/*
- (void)postStripeToken__:(NSString* )token {
    
    //1
    NSString *STRIPE_TEST_POST_URL=_appDelegate.selectedStore.peerInfo.homeUrl;
    
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

- (void)chargeDidSucceed:(OrderHistory *)order{
    if(processTimer)
        [processTimer invalidate];
    [processWait dismissWithClickedButtonIndex:0 animated:YES];
    /*
    CheckoutCart* checkoutCart = [CheckoutCart sharedInstance];
    [checkoutCart clearCart];
    
    UITabBarItem *tbi=(UITabBarItem *)[self.tabBarController.tabBar.items objectAtIndex:TAB_INDEX_CART];
    
    tbi.badgeValue=nil;
    */
    [_appDelegate clearCart];
    
    if (order.orderAmountDue>0) {
        float orderAmountDue=order.orderAmountDue;
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"Your order# %@",order.orderNumber]
                                           message:[NSString stringWithFormat:@"Amount Due: %.2f",orderAmountDue/100]
                                                                     delegate:nil
                                                            cancelButtonTitle:nil
                                                            otherButtonTitles:BTN_CASH,BTN_CCARD, nil];
        alert.tag=TAG_CHARGE_SUCCESS;
        [alert show];
    }
    else{
        
        
        
        /*UIAlertView *alert =  [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"Your order# %@",order.orderNumber]
                                                    message: @"Completed!"
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
        
        
        [alert show];
         */
        [self.navigationController popToRootViewControllerAnimated:YES];
       
        [self.tabBarController setSelectedIndex:TAB_INDEX_CHAT];
         //[_appDelegate.orderChatViewController.navigationController popToRootViewControllerAnimated:NO];
    }
    
    
    
    //Send confirmation email
    /*RWEmailManager* emailManager = [[RWEmailManager alloc] initWithRecipient:self.nameTextField.text
                                                              recipientEmail:self.emailTextField.text];
    
    [emailManager sendConfirmationEmail];
    */
    

    
}
- (void)chargeTimedOut:(NSTimer *)timer {
    
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
   
    //if(section==1)
    //    return @"Discounts/Coupons";
    
    return @"";
}
/*
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section==1 && [discounts count]==0){
        return 0.0;
    }
    else{
        return 44.0;
    }
}
*/
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    /*if(section==1){
        return [discounts count];
    }
    else*/
    if(section==0){
        return 2;
    }
    else if(section==1){
        return 1;
    }
    return 0;
}
/*
 UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"
 forIndexPath:indexPath];
 id item = self.store.allItems[indexPath.row];
 NSArray *descriptions = [self.store descriptionsForItem:item];
 cell.textLabel.text = descriptions[0];
 cell.detailTextLabel.text = descriptions[1];
 cell.accessoryType = ([item isEqual:self.store.selectedItem]) ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
 return cell;
 */
/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"card_cell"
                                                            forIndexPath:indexPath];
    //id item = self.store.allItems[indexPath.row];
    NSArray *descriptions = [self descriptionsForCard:selectedCard];
    cell.textLabel.text = descriptions[0];
    cell.detailTextLabel.text = descriptions[1];
    //cell.accessoryType = ([item isEqual:self.store.selectedItem]) ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    return cell;
}
*/
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    /*if (section == 0 && row == 0) {
        CheckoutInputCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"CheckoutInputCell"];
        cell.nameLabel.text = @"Name";
        cell.textField.placeholder=@"Required";
        if(selectedCard.name)
            cell.textField.text = selectedCard.name;

        cell.textField.keyboardType = UIKeyboardTypeAlphabet;
        self.nameTextField = cell.textField;
        return cell;
    }*/
    //rom added for table/seat#
//    if (section == 0) {
//        //if(row==0){
//            CheckoutInputCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"CheckoutInputCell"];
//            cell.nameLabel.text = @"Table/Seat";
//            cell.textField.placeholder = @"(optional)";
//            self.tableNumberTextField = cell.textField;
//            cell.textField.keyboardType = UIKeyboardTypeDefault;
//            return cell;
//        //}
//        /*else if (row == 1) {
//            CheckoutInputCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"CheckoutInputCell"];
//            cell.nameLabel.text = @"Promo code";
//            cell.textField.placeholder = @"(optional)";
//            self.promoCodeTextField = cell.textField;
//            cell.textField.keyboardType = UIKeyboardTypeDefault;
//            return cell;
//        }*/
//    }
    
   
//    else if (section == 1) {
//        /*if(row==0){
//            CheckoutInputCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"CheckoutInputCell"];
//            cell.nameLabel.text = @"Promo/Discount code";
//            cell.textField.placeholder = @"(optional)";
//            self.promoCodeTextField = cell.textField;
//            cell.textField.keyboardType = UIKeyboardTypeDefault;
//            return cell;
//        }
//         */
//        UITableViewCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"default_cell"];
//        DiscountItem *dc=[discounts objectAtIndex:row];
//        cell.textLabel.text = dc.name;
//        cell.detailTextLabel.text=dc.discountID;
//        
//        return cell;
//    }
    if (section == 0) {
        if(row==0){
            /*CheckoutInputCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"CheckoutInputCell"];
            cell.nameLabel.text =(_appDelegate.selectedStore.inventory.salesTipLabel.length>0)?_appDelegate.selectedStore.inventory.salesTipLabel:@"Tip";
            
            cell.textField.placeholder = @"Tip";
            
            self.tableNumberTextField = cell.textField;
            //cell.textField.keyboardType = UIKeyboardTypeDefault;
             */
            UITableViewCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"default_cell"];
            
            cell.textLabel.text = //[NSString stringWithFormat:@"Tip: %@",@(totalTip)];
            [NSString stringWithFormat:@"Tip: %.2f", totalTip ];
            cell.detailTextLabel.text=@"Thank You!";//[self defaultTipLabel];
            return cell;
        }
        else if(row==1){
            UITableViewCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"default_cell"];
            
            cell.textLabel.text = //[NSString stringWithFormat:@"Charge amount: %@",@((double)(totalCents/100))];
            [NSString stringWithFormat:@"%@%.2f",_appDelegate.selectedStore.inventory.currencySymbol, (double)totalCents/100 ];
            
            cell.detailTextLabel.text=@"Estimated charge amount.";
            return cell;
        }
        
    }
//    else if (section == 3) {
//        //if(row==0){
//            CheckoutInputCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"CheckoutInputCell"];
//            cell.nameLabel.text = @"Charge Amount before Tip and Discounts";
//            cell.textField.placeholder = @"Required";
//            self.tableNumberTextField = cell.textField;
//            //cell.textField.keyboardType = UIKeyboardTypeDefault;
//            return cell;
//        //}
//        
//    }
    //credi card info
    else if (section == 1) {
        if(row==0){
            //PaymentSelectCell *cell = [tableView dequeueReusableCellWithIdentifier:@"card_cell" forIndexPath:indexPath];
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"card_cell" forIndexPath:indexPath];
            //id item = self.store.allItems[indexPath.row];
            if(selectedCard!=nil){
                NSArray *descriptions = [self descriptionsForCard:selectedCard];
                cell.textLabel.text = descriptions[0];
                cell.textLabel.textColor=[UIColor blueColor];
                cell.detailTextLabel.text = descriptions[1];
                /*
                cell.ccTypeLabel.text = descriptions[0];
                                self.ccLast4Label.textColor = [UIColor blueColor];
                cell.ccLast4Label.text = descriptions[1];
                */
                [self.completeButton setEnabled:YES];
            }
            else{
                [self.completeButton setEnabled:NO];
                /*cell.ccTypeLabel.text = @"No credit card selected.";
                cell.ccLast4Label.textColor = [UIColor blueColor];
                cell.ccLast4Label.text = @"Tap here to select";//descriptions[1];
                */
                cell.textLabel.text = @"No credit card selected.";
                cell.textLabel.textColor=[UIColor redColor];
                cell.detailTextLabel.text = @"Tap here to select";//descriptions[1];
                
                
            }
            return cell;
        }
        else if (row == 2){
            PaymentSelectCell *cell = [tableView dequeueReusableCellWithIdentifier:@"card_cell"
                                                                      forIndexPath:indexPath];
            return cell;
        }
        
    }
    
    
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CGFloat h=52.0;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        if (indexPath.section == 1){
            h = 150.0;
        }
        else{
            h=80.0;
        }
    }
    
    
    return h;
}

#pragma mark - UITableViewDelegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section==0){
        if(indexPath.row==0){
            [self showTip];
        }
    }
    else if(indexPath.section==1){
        /*
        if(_appDelegate.selectedStore.isLive){
        CCardsViewController* destViewController = (CCardsViewController*) [ApplicationDelegate.storyBoard instantiateViewControllerWithIdentifier:@"CCardsViewController"];
        //browser.delegate = self;
        
        UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:destViewController];
        
        [self presentViewController:nav animated:YES completion:nil];
        }
         */
    }
    
    
}

#pragma mark - UIPicker data source
/*
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return (component == 0) ? 12 : 10;
}
*/
#pragma mark - UIPicker delegate
/*
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
*/
#pragma mark - UIPicker configuration

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

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    
    
    NSString *btnTitle=[alertView buttonTitleAtIndex:buttonIndex];
    if([btnTitle isEqualToString:@"Replace"]){
        
        NSArray *orders=[_appDelegate.historyModel searchPendingOrdersWithStore:_appDelegate.selectedStore isLive:_appDelegate.appConfig.isLive]; //[_appDelegate.selectedStore.orders filteredArrayUsingPredicate:predicate];
        if([orders count]>0){
            for(OrderHistory *delete_item in orders){
                [_appDelegate.selectedStore.orders removeObject:delete_item];
                
            }
            [_appDelegate.historyModel saveHistory];
        }
        
        [self performCreateOrder];

    }
    else if([btnTitle isEqualToString:@"Continue"]){
        CCardsViewController* destViewController = (CCardsViewController*) [ApplicationDelegate.storyBoard instantiateViewControllerWithIdentifier:@"CCardsViewController"];
        //browser.delegate = self;
        
        UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:destViewController];
        
        [self presentViewController:nav animated:YES completion:nil];
    }
else     if (alertView.tag==TAG_CONFIRM_AMOUNT) {
        if([btnTitle isEqualToString:BTN_CONFIRM_AMOUNT_CONTINUE]){
            @try{
                confirmed_totalCents= [[alertView textFieldAtIndex:0].text doubleValue] * 100;
                if(confirmed_totalCents<=0 || confirmed_totalCents>totalCents){
                    [self showConfirmAmount];
                    return;
                }
                
                //[self performStripeOperation];
            }
            @catch(NSException *e){
#ifdef DEBUG
                NSLog(@"%@",e);
                
#endif
                [self showConfirmAmount];
            }
            
        }
    }
    
    else if (alertView.tag==TAG_CHARGE_SUCCESS){
         if([btnTitle isEqualToString:BTN_CCARD]){
             
             
         }
        else if([btnTitle isEqualToString:BTN_CASH]){
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:nil message:@"Please pay cash at the Register." delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
            [alert show];
        }

    }
    else if (alertView.tag==ALERT_TAG_ADD_TIP){
        
        UITextField *txtField=[alertView textFieldAtIndex:0];
        
        if([nf numberFromString:txtField.text]){
            float newTip=[txtField.text floatValue];
            
            if(newTip<=0){
                newTip=0;
            }
            else if(newTip>(totalCents*(MAX_TIP_PCT/100))){
                newTip=totalCents*(MAX_TIP_PCT/100);
            }
            totalTip=newTip;
        }
        [self computeTotals];
        [self.tableView reloadData];
        
    }
    else if (alertView.tag==ALERT_TAG_ADD_DISCOUNT){
        if([btnTitle isEqualToString:BTN_SCAN]){
            [self performSegueWithIdentifier:@"toBCScannerViewController" sender:self];
        }
        else if ([btnTitle isEqualToString:BTN_OK]){
            UITextField *txtField=[alertView textFieldAtIndex:0];
            
            
            [self addDiscountCode:txtField.text];
         
        }
        
    }
}
-(void)addDiscountCode:(NSString *)discountID{
    if(discountID==nil || discountID.length==0)
        return;
    
    discountID=[discountID stringByReplacingOccurrencesOfString:@" " withString:@""];
    discountID=[discountID stringByReplacingOccurrencesOfString:@"*" withString:@""];
    
    if(discountID==nil || discountID.length==0)
        return;
    
    if(discounts==nil){
        discounts=[NSMutableArray new];
    }
    if([discounts count]>0){
        NSPredicate *p=[NSPredicate predicateWithFormat:@"discountID==%@",discountID];
        
        NSArray *arr=[discounts filteredArrayUsingPredicate:p];
        if([arr count]==0){
            DiscountItem *dc=[DiscountItem new];
            dc.discountID=discountID;
            
            [discounts addObject:dc];
            [self computeTotals];
            [self.tableView reloadData];
        }
    }
    else{
        DiscountItem *dc=[DiscountItem new];
        dc.discountID=discountID;
        
        [discounts addObject:dc];
        [self computeTotals];
        [self.tableView reloadData];
    }
}

//this taken from stpcardstore
- (NSArray *)descriptionsForCard:(CCardInfo *)card {
    //NSDictionary *card = (NSDictionary *)item;
    //NSString *number = card[@"number"];
    
    NSString *suffix = [card.number substringFromIndex:MAX((NSInteger)[card.number length] - 4, 0)];
    //return @[card.name, [NSString stringWithFormat:@"**** **** **** %@", suffix]];
    //return @[[AppDelegate cardtype:card.brand], [NSString stringWithFormat:@"**** **** **** %@", suffix]];
    return @[[AppDelegate cardtype:card.brand], [NSString stringWithFormat:@"-%@", suffix]];
}

-(void)showTip{
    //if(_appDelegate.selectedStore.inventory.salesTip>0){
        
    //}
    UIAlertView * alert =[[UIAlertView alloc ] initWithTitle:@"Tip" message:[self defaultTipLabel] delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles: nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert addButtonWithTitle:@"OK"];
    alert.tag=ALERT_TAG_ADD_TIP;
    UITextField *txtName=[alert textFieldAtIndex:0];
    
    txtName.text=[NSString stringWithFormat:@"%.2f",(double)totalTip/100];
    [txtName setKeyboardType:UIKeyboardTypeDecimalPad];
    
    [alert show];
}

- (IBAction)addTipButton:(id)sender {
    //NSString *tip=@"0.00";
    [self showTip];
}
- (IBAction)addPromoCodeButton:(id)sender {
    
    if(discounts==nil){
        discounts=[NSMutableArray new];
    }
    
    UIAlertView * alert =[[UIAlertView alloc ] initWithTitle:@"Add Promo Code, Coupon" message:@"Type manually or use Scan." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles: BTN_OK,BTN_SCAN,nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    //[alert addButtonWithTitle:@"OK"];
    alert.tag=ALERT_TAG_ADD_DISCOUNT;
    //UITextField *txtName=[alert textFieldAtIndex:0];
    //txtName.text=@"Tip";
    [alert show];
}

-(void)computeTotals{
    
    
    
    totalCents=[_appDelegate.selectedStore.cart total];
    /*
    float tax=_appDelegate.selectedStore.inventory.salesTax;
    float total_beforetax=(float)totalCents;//[_appDelegate.selectedStore.cart total]/100 ;
    total_beforetax=round(total_beforetax*100)/100;
    float f_tax=(float)tax/100;
    
    f_tax=round(f_tax*100)/100;
    
    float tax_cost=total_beforetax*(f_tax);//tax_cost=total_beforetax*(tax/100); //[self.checkoutCart total_tax:tax_rate] ;
    tax_cost=round(tax_cost*100)/100;
    
    
    float total_aftertax = total_beforetax+tax_cost;//[self.checkoutCart grand_total:tax_rate];
    
    total_aftertax=(total_aftertax*100)/100;
    */
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
    //totalCents = totalCents+[_appDelegate.selectedStore.cart total_tax:totalCents tax:_appDelegate.selectedStore.inventory.salesTax];
    
    
    float total_beforetax=(float)[_appDelegate.selectedStore.cart total]/100 ;
    total_beforetax=round(total_beforetax*100)/100;
    
    float tax=_appDelegate.selectedStore.inventory.salesTax;
    
    float f_tax=(float)tax/100;
    
    f_tax=round(f_tax*100)/100;
    
    float tax_cost=total_beforetax*(f_tax);//tax_cost=total_beforetax*(tax/100); //[self.checkoutCart total_tax:tax_rate] ;
    tax_cost=round(tax_cost*100)/100;
    
    float total_aftertax = total_beforetax+tax_cost;//[self.checkoutCart grand_total:tax_rate];
    
    total_aftertax=round(total_aftertax*100)/100;
    
    totalCents=total_aftertax*100;
    
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

-(NSString *)defaultTipLabel{
    /*
    float salesTip;
    
    if(_appDelegate.selectedStore.inventory.salesTip<=0)
        salesTip=MIN_TIP_PCT;
    else if(_appDelegate.selectedStore.inventory.salesTip>MAX_TIP_PCT)
        salesTip=MAX_TIP_PCT;
    else
        salesTip=_appDelegate.selectedStore.inventory.salesTip;
    */
    t1= (totalCentsBeforeTip*(0.1))/100;
    double t2= (totalCentsBeforeTip*(0.15))/100;
    double t3= (totalCentsBeforeTip*(0.20))/100;
    
    NSString *result=//[NSString stringWithFormat:@"Tip @ %@%%: %@",@(salesTip),@(t)];
    [NSString stringWithFormat:@"Suggested Tip(%@)\n%.2f @10%%\n%.2f @15%%\n%.2f @20%%",_appDelegate.selectedStore.inventory.currencySymbol,t1,t2,t3];
    return result;
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"toBCScannerViewController"]){
        
        }
}

-(void)didReceiveMenuSettingsWithNotification:(NSNotification *)notification{
    //[self.navigationController popViewControllerAnimated:YES];
    [self reloadData];
}

-(void)reloadData{
    if(_appDelegate.appConfig.isLive){
        if([_appDelegate.appConfig.userInfo.ccards count]>0){
            
            selectedCard=[_appDelegate.appConfig.userInfo.ccards objectAtIndex:0];
            for (CCardInfo *c in _appDelegate.appConfig.userInfo.ccards) {
                if(c.isDefault){
                    selectedCard=c;
                    break;
                }
            }
        }
    }
    else{
        selectedCard=_appDelegate.appConfig.testCard;
        if(selectedCard.name==nil){
            selectedCard.name=@"";
            if(_appDelegate.appConfig.userInfo.fullName!=nil)
                selectedCard.name=_appDelegate.appConfig.userInfo.fullName;
            else if(_appDelegate.appConfig.userInfo.displayName!=nil)
                selectedCard.name=_appDelegate.appConfig.userInfo.displayName;
            
            
        }
        _appDelegate.appConfig.userInfo.selectedCard=selectedCard;
        
    }
    
    _acceptedCardsLabel.text=_appDelegate.selectedStore.inventory.acceptedCards;
    [self computeTotals];
    [self.tableView reloadData];
}
@end
