//
//  PaymentViewController.m

#import "AddCCardViewController.h"
//#import "CheckoutCart.h"
//#import "RWEmailManager.h"

#import "CheckoutInputCell.h"
#import "CheckoutDisplayCell.h"
#import "CCardSwitchCell.h"
//#import <AFNetworking/AFNetworking.h>

#import "CardInfo.h"
#import "Stripe.h"
//#import "CardInfo.h"
#import "AppDelegate.h"

#import "defs.h"



@interface AddCCardViewController () <UITableViewDataSource, UITableViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate>
{
    CCardInfo *newCard;
}




@property (strong, nonatomic) IBOutlet UITableView* tableView;
@property (strong, nonatomic) IBOutlet UIView* buttonView;
@property (strong, nonatomic) IBOutlet UIButton* completeButton;
@property (strong, nonatomic) IBOutlet UIButton *cancelButton;

@property (strong, nonatomic) UITextField* nameTextField;
@property (strong, nonatomic) UITextField* emailTextField;
@property (strong, nonatomic) UITextField* tableNumberTextField;

@property (strong, nonatomic) UITextField* expirationDateTextField;
@property (strong, nonatomic) UITextField* cardNumber;
@property (strong, nonatomic) UITextField* CVCNumber;

@property (strong, nonatomic) NSArray* monthArray;
@property (strong, nonatomic) NSNumber* selectedMonth;
@property (strong, nonatomic) NSNumber* selectedYear;
@property (strong, nonatomic) UIPickerView *expirationDatePicker;

//@property (strong, nonatomic) AFJSONRequestOperation* httpOperation;
@property (strong, nonatomic) STPCard* stripeCard;
//@property (strong, nonatomic) CardInfo* stripeCard;
@property (strong, nonatomic) UISwitch* defaultCardSwitch;

@property (nonatomic, strong) AppDelegate *appDelegate;
@end

@implementation AddCCardViewController

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
    //self.tableView.backgroundColor=[UIColor clearColor];
    newCard=[CCardInfo new];
    
    newCard.name=_appDelegate.appConfig.userInfo.fullName;
    //newCard.ccEmail=_appDelegate.appConfig.userInfo.email;
    
    newCard.cvc=@"";
    
    newCard.number=@"";
    newCard.isDefault=NO;
    //if([_appDelegate.appConfig.userInfo.ccards count]==0)
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy"];
    NSInteger currentYear = [[dateFormatter stringFromDate:[NSDate date]] integerValue];
    
    newCard.expMonth=1;
    
    newCard.expYear=currentYear+1;
    /*
    [_appDelegate.appConfig.userInfo.ccards addObject:newCard];
    [self.tableView reloadData];
    selectedCard=newCard;
    [AppConfigModel saveSettings];
    */
    
	// Do any additional setup after loading the view.
    _appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    self.monthArray = @[@"01 - January", @"02 - February", @"03 - March",
    @"04 - April", @"05 - May", @"06 - June", @"07 - July", @"08 - August", @"09 - September",
    @"10 - October", @"11 - November", @"12 - December"];
    
    
    /*[_nameTextField setText:_selectedCard.ccName];
    
    [_emailTextField setText:_selectedCard.ccEmail];
    
    [_cardNumber setText:_selectedCard.ccNumber];
    [_CVCNumber setText:_selectedCard.ccCVV];
    */
    _selectedMonth=@(newCard.expMonth);
    
    _selectedYear=@(newCard.expYear);
    
    // [_expirationDateTextField setText:[NSString stringWithFormat:@"%@/%@",_selectedMonth,_selectedYear]];
    
    [_expirationDatePicker selectRow:[_selectedMonth unsignedIntegerValue] inComponent:0 animated:NO];
    
    
    //NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //[dateFormatter setDateFormat:@"yyyy"];
    //NSInteger currentYear = [[dateFormatter stringFromDate:[NSDate date]] integerValue];
    NSInteger row=[_selectedYear integerValue] -currentYear;
    if (row>=0 & row<=9){
        [_expirationDatePicker selectRow:row inComponent:1 animated:NO];
    }
    else{
        [_expirationDatePicker selectRow:0 inComponent:1 animated:NO];
    }

    
   // self.tableView.frame=[AppDelegate maximumUsableFrame:self];
    
    
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(completeButtonTapped:)];
    
    
    //UIBarButtonItem *backButton=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(backButtonTapped)];
    //self.navigationItem.leftBarButtonItem=backButton;
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(cancelButtonTapped:)];
    

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
    [self configurePickerView];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Stripe

- (IBAction)completeButtonTapped:(id)sender {
    //1
    if(newCard==nil)
        newCard=[CCardInfo new];
     self.stripeCard = [[STPCard alloc] init];
    newCard.name= self.stripeCard.name = self.nameTextField.text;
    newCard.number= self.stripeCard.number = self.cardNumber.text;
    newCard.cvc = self.stripeCard.cvc = self.CVCNumber.text;
    
    self.stripeCard.expMonth = [self.selectedMonth integerValue];
    newCard.expMonth=[self.selectedMonth integerValue];
    
    self.stripeCard.expYear = [self.selectedYear integerValue];
    newCard.expYear=[self.selectedYear integerValue];
    
    newCard.isDefault=[self.defaultCardSwitch isOn];
    //ROM added:
    //_selectedCard.ccEmail = self.stripeCard.email=self.emailTextField.text;
    
    //2
    if ([self validateCustomerInfo]) {
        
        /*_appDelegate.appConfig.userInfo.ccard.ccName=self.stripeCard.name;
        _appDelegate.appConfig.userInfo.ccard.ccNumber=self.stripeCard.number;
        _appDelegate.appConfig.userInfo.ccard.ccExpMonth=[NSNumber numberWithInteger:self.stripeCard.expMonth];
        _appDelegate.appConfig.userInfo.ccard.ccExpYear=[NSNumber numberWithInteger:self.stripeCard.expYear];
        
        _appDelegate.appConfig.userInfo.ccard.ccCVV=self.stripeCard.cvc;
        _appDelegate.appConfig.userInfo.ccard.ccEmail=self.stripeCard.email;*/
        
        // make sure only one default card
        
        
        if(newCard.isDefault){
            NSPredicate *predicate=[NSPredicate predicateWithFormat:@"isDefault==YES"];
            
            NSArray *results;
            
            
            results=[_appDelegate.appConfig.userInfo.ccards filteredArrayUsingPredicate:predicate];
            if([results count]>0){
                for(CCardInfo *cc in results){
                    cc.isDefault=NO;
                }
                
            }
            //newCard.isDefault=YES;
            
             [_appDelegate.appConfig.userInfo.ccards addObject:newCard];
             //[self.tableView reloadData];
             //selectedCard=newCard;
             //[AppConfigModel saveSettings];
            //[self dismissViewControllerAnimated:YES completion:nil];

        }
        
         
        
        
        [AppConfigModel saveSettings];
        //[[NSNotificationCenter defaultCenter] postNotificationName:@"DidReceiveUpdateCardsNotification" object:nil];
        [self dismissViewControllerAnimated:YES completion:nil];
        
        
    }
    else{
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Error" message:@"Invalid card." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
    }
    
    
    
}

- (IBAction)cancelButtonTapped:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
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
        )
    {
        
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


#pragma mark - UITableViewDataSource methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3; // (1) user details, (2) credit card details
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    //return (section == 0) ? @"Customer Info" : @"Credit Card Details";
    switch (section) {
        case 0:
            return @"Customer Info";
            
        case 1:
            return @"Credit Card Details";
        case 2:
            return @"";
        default:
            break;
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //return (section == 0) ? 2 : 3;
    switch (section) {
        case 0:
            return 1;
        
        case 1:
            return 3;
            
        case 2:
            return 1;
            
        default:
            break;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    if (section == 0) {
        if(row==0){
            CheckoutInputCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"CheckoutInputCell"];
            cell.nameLabel.text = @"Name";
            cell.textField.placeholder=@"Required";
            if(newCard.name)
                cell.textField.text = newCard.name;

            cell.textField.keyboardType = UIKeyboardTypeAlphabet;
            self.nameTextField = cell.textField;
            self.nameTextField.delegate=self;
            return cell;
        }
        /*else if (row == 1) {
            CheckoutInputCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"CheckoutInputCell"];
            cell.nameLabel.text = @"E-mail";
            cell.textField.placeholder=nil;
            if(_appDelegate.appConfig.userInfo.email)
                cell.textField.text = _appDelegate.appConfig.userInfo.email;
            
            self.emailTextField = cell.textField;
            cell.textField.keyboardType = UIKeyboardTypeAlphabet;
            self.emailTextField.delegate=self;
            return cell;
        }*/
    }
    
    
//credi card info
    else if (section == 1) {
        if(row == 0){
            CheckoutInputCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"CheckoutInputCell"];
            cell.nameLabel.text =@"Card Number";
            
            cell.textField.placeholder=@"Required";
            
            if(newCard.number)
                cell.textField.text=newCard.number;
            
            cell.textField.keyboardType = UIKeyboardTypeNumberPad;
            self.cardNumber = cell.textField;
            return cell;
        }
        else if (section == 1 && row == 1) {
            CheckoutInputCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"CheckoutInputCell"];
            cell.nameLabel.text = @"CVC Number";
            cell.textField.placeholder=@"Required";
            if(newCard.cvc)
                cell.textField.text = newCard.cvc;
            self.CVCNumber = cell.textField;
            cell.textField.keyboardType = UIKeyboardTypeNumberPad;
            self.CVCNumber.delegate=self;
            //[self configurePickerView];
            return cell;
        }
        
        else if ( row == 2) {
            CheckoutInputCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"CheckoutInputCell"];
            cell.nameLabel.text = @"Exp. Date";
            cell.textField.placeholder=@"Required";
            //cell.textField.text = (_appDelegate.userInfo.ccExpDate!=nil && _appDelegate.userInfo.ccExpDate.length>0)?_appDelegate.userInfo.ccExpDate:@"Required";
            if(_selectedMonth && _selectedYear)
                cell.textField.text = (_selectedMonth!=nil || _selectedYear==nil)?[NSString stringWithFormat:@"%@/%@",_selectedMonth,_selectedYear ]:@"Required";
            cell.textField.textColor = [UIColor lightGrayColor];
            self.expirationDateTextField = cell.textField;
            self.expirationDateTextField.delegate=self;
            return cell;
        }
        
    }
    
    
    //set default
    else if (section == 2) {
         if(row == 0){
            /*CheckoutDisplayCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"CheckoutDisplayCell"];
            cell.nameLabel.text =@"Set as default creditcard";
            cell.displayLabel.text=@"";
            if(newCard.isDefault)
                cell.accessoryType=UITableViewCellAccessoryCheckmark;
            else
                cell.accessoryType=UITableViewCellAccessoryNone;
            */
             CCardSwitchCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"CCardSwitchCell"];
             cell.nameLabel.text =@"Use this card";
             
             [cell.enableSwitch setOn:newCard.isDefault];
             self.defaultCardSwitch=cell.enableSwitch;
             return cell;
             return cell;
         }
    }
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CGFloat h=52.0;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        h=90.0;
    }
    
    
    return h;
}

#pragma mark - UITableViewDelegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell=[tableView cellForRowAtIndexPath:indexPath];
    
    if(newCard.isDefault){
        newCard.isDefault=NO;
    
        cell.accessoryType=UITableViewCellAccessoryNone;
    }
    else{
        newCard.isDefault=YES;
        cell.accessoryType=UITableViewCellAccessoryCheckmark;
    }
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
        NSUInteger currentYear = [[dateFormatter stringFromDate:[NSDate date]] integerValue];
        return [NSString stringWithFormat:@"%@", @(currentYear + row)];
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
    self.tableNumberTextField.inputAccessoryView=pickerToolbar;
    
}

- (void)pickerDoneButtonPressed {
    [self.view endEditing:YES];
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    CGPoint origin = textField.frame.origin;
    CGPoint point = [textField.superview convertPoint:origin toView:self.tableView];
    
    NSIndexPath * indexPath = [self.tableView indexPathForRowAtPoint:point];
    
    // [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    
    
    // NSIndexPath *indexPath = [self.tableView indexPathForCell:textFieldRowCell];
    
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    //}
    return YES;
}
-(BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    // if([textField isEqual:self.announceTextField]){
    NSIndexPath *ip=[NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView scrollToRowAtIndexPath:ip atScrollPosition:UITableViewScrollPositionTop animated:YES];
    //[self.tableView scrollsToTop];
    //}
    return  YES;
}
-(void)textWillChange:(id<UITextInput>)textInput{
    
}
-(void)textDidChange:(id<UITextInput>)textInput{
    
}
-(void)selectionDidChange:(id<UITextInput>)textInput{
    
}

-(void)selectionWillChange:(id<UITextInput>)textInput{
    
}
@end
