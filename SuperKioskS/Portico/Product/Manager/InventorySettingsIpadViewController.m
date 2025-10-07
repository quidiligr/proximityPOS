//
//  PaymentViewController.m

#import "InventorySettingsIpadViewController.h"

#import "InvConfigInputCell.h"
#import "InvConfigTitleCell.h"
#import "InvConfigRefundCell.h"
#import "InvConfigInputNumCell.h"
#import "InvConfigDisplayCell.h"
#import "InvConfigCurrencyCell.h"
#import "InvConfigAcceptCardCell.h"
#import "InvConfigAcceptCashCell.h"
#import "InvConfigEcommerceCell.h"
#import "InvConfigSwitchSectionCell.h"
#import "InvConfigSectionCell.h"
#import "AppDelegate.h"
//#import "InventroySettings.h"
#import "InventoryModel.h"
#import "InventoryItem.h"
#import "defs.h"
/*
#define PAY_BOTH 0
#define PAY_CARD 1
#define PAY_CASH 2
*/



@interface InventorySettingsIpadViewController () <UITableViewDataSource, UITableViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate>{
    
    BOOL isEcommerce;
    BOOL hasChanged;
    
    
    NSArray* refundLevelArray;
    NSArray* currenciesArray;
    
   
    NSInteger selectedRefundLevel;
    NSInteger selectedCurrencyIndex;
    NSString  *selectedCurrency;
    
    UIToolbar *pickerToolbar;
    
    NSString *name;
    BOOL isActive;
    BOOL acceptCard;
    BOOL acceptCash;
    double salesTax;
    NSInteger maxUnpaidOrdersPerCustomer;
    NSInteger minChargeAmount;
    NSInteger maxChargeAmount;
    
    NSNumberFormatter *nf;
    
}
@property (strong, nonatomic) IBOutlet UITableView* tableView;
@property (strong, nonatomic) IBOutlet UIView* buttonView;

@property (strong, nonatomic) IBOutlet UIBarButtonItem* saveButton;

@property (strong, nonatomic) UITextField* nameTextField;
@property (strong, nonatomic) UISwitch* isActiveSwitch;


@property (strong, nonatomic) UITextField* salesTaxTextField;
@property (strong, nonatomic) UITextField* currencyTextField;
@property (strong, nonatomic) UITextField* symbolTextField;
@property (strong, nonatomic) UISwitch* isEcommerceSwitch;


@property(strong,nonatomic) UISwitch *acceptCCardSwitch;
@property(strong,nonatomic) UISwitch *acceptCashSwitch;


@property (strong, nonatomic) UITextField* refundLevelTextField;


@property (strong, nonatomic) UITextField* maxUnpaidTextField;
@property (strong, nonatomic) UITextField* maxChargeTextField;
@property (strong, nonatomic) UITextField* minChargeTextField;




@property (strong, nonatomic) UIPickerView *refundLevelPicker;
@property (strong, nonatomic) UIPickerView *currencyPicker;

@property (nonatomic, strong) AppDelegate *appDelegate;

@property (nonatomic, strong) InventoryModel *inventoryModel;



@end

@implementation InventorySettingsViewController
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

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    _appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    _inventoryModel=[InventoryModel sharedInstance];
    
    nf=[[NSNumberFormatter alloc] init];
    
    self.saveButton=[[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStyleBordered target:self action:@selector(completeButtonTapped:)];
    hasChanged=NO;
    isEcommerce=_selectedInventory.isEcommerce;
    
    self.navigationItem.rightBarButtonItem=self.saveButton;
    
    name=_selectedInventory.name;
   
    refundLevelArray=@[@"No Refund",@"Order Received",@"Order Ready"];
    selectedRefundLevel=_selectedInventory.refundLevel;
    
    currenciesArray=[_appDelegate.appConfig.currencies allKeys];
    
    selectedCurrency=_selectedInventory.currency;
    selectedCurrencyIndex=[currenciesArray indexOfObject:selectedCurrency];
    
    
    //Create and configure toolabr that holds "Done button"
    pickerToolbar = [[UIToolbar alloc] init];
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
   
    _refundLevelPicker = [[UIPickerView alloc] init];
    _refundLevelPicker.delegate = self;
    _refundLevelPicker.dataSource = self;
    _refundLevelPicker.showsSelectionIndicator = YES;
    
    [_refundLevelPicker selectRow:selectedRefundLevel inComponent:0 animated:NO];
    
    _currencyPicker = [[UIPickerView alloc] init];
    _currencyPicker.delegate = self;
    _currencyPicker.dataSource = self;
    _currencyPicker.showsSelectionIndicator = YES;
    
    [_currencyPicker selectRow:selectedCurrencyIndex inComponent:0 animated:NO];
    
    
    isActive=_selectedInventory.isActive;
    acceptCard=_selectedInventory.acceptCCard;
    acceptCash=_selectedInventory.acceptCash;
    salesTax=_selectedInventory.salesTax;
    maxUnpaidOrdersPerCustomer=_selectedInventory.maxUnpaidOrdersPerCustomer;
    minChargeAmount=_selectedInventory.minChargeAmount;
    maxChargeAmount=_selectedInventory.maxChargeAmount;
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.tableView reloadData];
     //[self configurePickerView];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -

- (IBAction)completeButtonTapped:(id)sender {
    
   

    //self.nameTextField.text=[self.nameTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" "]];
    
    if(!name)
    {
        [AppDelegate ShowErrorAlert:@"Please specify a unique name."];
        return;
    }
    self.selectedInventory.name=name;//self.nameTextField.text;
    
  
    
    
    _selectedInventory.isEcommerce=isEcommerce;
   
    _selectedInventory.salesTax=salesTax;
    
    _selectedInventory.currency=selectedCurrency;
    
    _selectedInventory.currencySymbol=[_appDelegate.appConfig.currencies valueForKey: _selectedInventory.currency];
    
    
    
        _selectedInventory.maxUnpaidOrdersPerCustomer=maxUnpaidOrdersPerCustomer;
    

    
        _selectedInventory.maxChargeAmount=maxChargeAmount;
    
    
    
        _selectedInventory.minChargeAmount=minChargeAmount;

    
    
    
    _selectedInventory.acceptCash=[self.acceptCashSwitch isOn];
    _selectedInventory.acceptCCard=[self.acceptCCardSwitch isOn];
    
    
    //_selectedInventory.selectedScanner=selectedScanner;
    
    _selectedInventory.refundLevel=selectedRefundLevel;
    
    
    
    if(isActive){
        InventoryItem *inventoryItem=[InventoryModel activeInventory];
        if(![inventoryItem isEqual:_selectedInventory]){
            inventoryItem.isActive=NO;
        }
    }
    
    self.selectedInventory.isActive=isActive;
    
    
    [self.inventoryModel saveInventory];

    
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_UPDATE_INVENTORY object:nil userInfo:@{NAME_KEY:_selectedInventory.name}];
    
    //if([_selectedInventory isActive]){
     [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_BROADCAST_UPDATE_INVENTORY object:nil userInfo:@{NAME_KEY:_selectedInventory.name}];
    //}
    
    [self.navigationController popViewControllerAnimated:YES];

    
}



-(BOOL)renameItem:(NSString *)fromName toName:(NSString *)toName{
    NSString *documentPath= [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSFileManager *fileManager=[NSFileManager defaultManager];
    
    
    NSString *fromFileName=[fromName stringByAppendingString:@".inventory.plist"];
    NSString *fromPath=[documentPath stringByAppendingPathComponent:fromFileName];
    
    NSString *toFileName=[toName stringByAppendingString:@".inventory.plist"];
    NSString *toPath=[documentPath stringByAppendingPathComponent:toFileName];
    
    BOOL success=YES;
    if ([fileManager fileExistsAtPath:fromPath]) {
        NSError *error;
        
        success=[fileManager moveItemAtPath:fromPath toPath:toPath error:&error];
        
    }
    
    return success;
    
}



#pragma mark - UITableViewDataSource methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2; // (1) user details, (2) credit card details
}
/*
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    switch(section)
    {
        case 1:
            return @"Payments";
        default:
            return @"";
    }
   // return (section == 0) ? @"" : @"Payments";
}
*/
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //return (section == 0) ? 1 : 3;
    switch(section)
    {
        case 0:
            return 2;
        case 1:
            if(isEcommerce)
                return 8;
            else
                return 0;
       
    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    //if(section==1)
        return 68;
    //else
      //  return 40.0;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if(section==1){
    //static NSString* headerCellIdentifier=@"InvConfigSwitchSectionCell";
    InvConfigSwitchSectionCell *cell=[tableView dequeueReusableCellWithIdentifier:@"InvConfigSwitchSectionCell"];
    //ProductCategory *pc=[_sortedCategories objectAtIndex:section];
    
    cell.titleLabel.text =@"Ecommerce";
        cell.descriptionLabel.text=@"Enable pricing and accept payments.";
        [cell.inputSwitch setOn:isEcommerce];
        
        _isEcommerceSwitch=cell.inputSwitch;
        [_isEcommerceSwitch addTarget:self action:@selector(toggleEcommerce:) forControlEvents:UIControlEventValueChanged];
   return cell;
    }
    else{
        //static NSString* headerCellIdentifier=@"InvConfigSectionCell";
        InvConfigSectionCell *cell=[tableView dequeueReusableCellWithIdentifier:@"InvConfigSectionCell"];
        //ProductCategory *pc=[_sortedCategories objectAtIndex:section];
        
        cell.titleLabel.text =nil;
        return cell;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    if(section==0){
            switch(row){
                    case 0:
                {
                    
                    
                        InvConfigTitleCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"InvConfigTitleCell"];
                        cell.nameLabel.text = @"Title";
                    cell.descriptionLabel.text=@"A unique name for this menu/content";
                    cell.textField.text=name;//self.selectedInventory.name;
                        cell.textField.placeholder = @"Required";

                        cell.textField.keyboardType = UIKeyboardTypeAlphabet;
                        self.nameTextField = cell.textField;
                        self.nameTextField.delegate=self;
                    self.nameTextField.inputAccessoryView = pickerToolbar;
                        return cell;
                }
                    //break;
                case 1:
                {
                    
                    InvConfigEcommerceCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"InvConfigEcommerceCell"];
                    cell.nameLabel.text = @"Active";
                    cell.descriptionLabel.text=@"When active this menu/content is visible to users.";
                    [cell.switchField setOn:isActive];
                    [cell.switchField addTarget:self action:@selector(toggleActivate:) forControlEvents:UIControlEventValueChanged];
                    _isActiveSwitch=cell.switchField;
                    return cell;
                    
                    
                }
                    //break;
            }
        return nil;
    }
    else if(section==1){ //Payments
            switch(row){
                /*case 0:
                {
                    InvConfigSwitchCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"InvConfigSwitchCell"];
                    cell.nameLabel.text = @"Ecommerce";
                    cell.descriptionLabel.text=@"Displays pricing and payment when enabled.";
                    [cell.switchField setOn:self.selectedInventory];
                    return cell;
                }
                    break;
                 */
                case 0:
                {
                    InvConfigAcceptCardCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"InvConfigAcceptCardCell"];
                   
                    cell.nameLabel.text = @"Remote pay";
                    cell.descriptionLabel.text=@"Allows users to order and pay items remotely using their mobile devices.";
                    
                    [cell.switchField setOn:acceptCard animated:YES];
                    
                    [cell.switchField addTarget:self action:@selector(toggleAcceptCCard:) forControlEvents:UIControlEventValueChanged];
                    self.acceptCCardSwitch=cell.switchField;
                    return cell;
                }
                    break;
                case 1:
                    {
                    
                    InvConfigAcceptCashCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"InvConfigAcceptCashCell"];
                    cell.nameLabel.text = @"Pay at the register";
                        cell.descriptionLabel.text=@"Allow users to order remotely and pay at the register with cash or card swipe.";
                    //cell.labelOFF.text=nil;
                    //cell.labelON.text=nil;
                    
                    [cell.switchField setOn:acceptCash animated:YES];
                    [cell.switchField addTarget:self action:@selector(toggleAcceptCash:) forControlEvents:UIControlEventValueChanged];
                    self.acceptCashSwitch=cell.switchField;
                    return cell;
                    }
                case 2:
                {
                    InvConfigInputNumCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"InvConfigInputNumCell"];
                    cell.nameLabel.text = @"Currency";
                    cell.descriptionLabel.text=@"Currency use for payment transactions.";
                    //[_nameTextField setText:self.inventory.name];
                    if(!self.selectedInventory.currency){
                        self.selectedInventory.currency=DEF_CURRENCY;//_appDelegate.appConfig.currency;
                        self.selectedInventory.currencySymbol=DEF_CURRENCY_SYMBOL;//_appDelegate.appConfig.currencySymbol;
                    }
                    cell.textField.text=[NSString stringWithFormat:@"%@ %@",selectedCurrency,[_appDelegate.appConfig.currencies valueForKey:selectedCurrency ]]; //self.selectedInventory.currency;
                    //cell.symbolTextField.text=self.selectedInventory.currencySymbol;
                    
                    //cell.textField.textColor = [UIColor lightGrayColor];
                    //cell.textField.keyboardType = UIKeyboardTypeDecimalPad;
                    self.currencyTextField = cell.textField;
                    self.currencyTextField.delegate=self;
                    self.currencyTextField.inputAccessoryView = pickerToolbar;
                    
                    self.currencyTextField.inputView = self.currencyPicker;
                    self.currencyTextField.inputAccessoryView = pickerToolbar;
                    
                    return cell;
                }
                    break;
                case 3:
                {
                    InvConfigInputNumCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"InvConfigInputNumCell"];
                    cell.nameLabel.text = @"Sales Tax %";
                    cell.descriptionLabel.text=nil;
                   
                    
                    cell.textField.text=[NSString stringWithFormat:@"%@",[AppDelegate decimalDisplay:salesTax]];
                    
                    //cell.textField.textColor = [UIColor lightGrayColor];
                    cell.textField.keyboardType = UIKeyboardTypeDecimalPad;
                    self.salesTaxTextField = cell.textField;
                    self.salesTaxTextField.delegate=self;
                    self.salesTaxTextField.inputAccessoryView = pickerToolbar;
                    return cell;
                }
                    break;
                case 4:{
                    InvConfigRefundCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"InvConfigRefundCell"];
                    cell.nameLabel.text = @"Refundable Level";
                    cell.descriptionLabel.text=@"Level at which a buyer can refund purchase items.";
                    
                    cell.textField.text=[NSString stringWithFormat:@"%@",[refundLevelArray objectAtIndex:selectedRefundLevel]];
                    
                    
                   
                    cell.textField.keyboardType = UIKeyboardTypeNumberPad;
                    cell.textField.placeholder = @"Required";
                    _refundLevelTextField = cell.textField;
                    
                    self.refundLevelTextField.inputView = self.refundLevelPicker;
                    self.refundLevelTextField.inputAccessoryView = pickerToolbar;

                    
                    return cell;
                }
                    break;
                case 5:
                {
                    InvConfigInputNumCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"InvConfigInputNumCell"];
                    cell.nameLabel.text = @"Maximum UNPAID orders";
                    cell.descriptionLabel.text=@"Maximum number of unpaid orders per user. Set 0 for unlimited but not recommended.";
                    //if(maxUnpaidOrdersPerCustomer)
                        cell.textField.text=[NSString stringWithFormat:@"%@",@(maxUnpaidOrdersPerCustomer)];
                    //else
                    //    cell.textField.text=@"";
                    cell.textField.placeholder = @"Required";
                                        cell.textField.keyboardType = UIKeyboardTypeNumberPad;
                    self.maxUnpaidTextField = cell.textField;
                    self.maxUnpaidTextField.delegate=self;
                    self.maxUnpaidTextField.inputAccessoryView = pickerToolbar;
                    return cell;
                }
                    break;
                case 6:
                {
                    InvConfigInputNumCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"InvConfigInputNumCell"];
                    cell.nameLabel.text = @"Minimum Charge";
                    cell.descriptionLabel.text=@"The minimum charge amount per transaction.";
                    //if(minChargeAmount)
                        cell.textField.text=[NSString stringWithFormat:@"%@",[AppDelegate decimalDisplay:minChargeAmount/100]];//[NSString stringWithFormat:@"%@",@(minChargeAmount)];
                    //else
                     //   cell.textField.text=@"";
                    cell.textField.placeholder = @"Required";
                    
                    cell.textField.keyboardType = UIKeyboardTypeNumberPad;
                    self.minChargeTextField = cell.textField;
                    self.minChargeTextField.delegate=self;
                    self.minChargeTextField.inputAccessoryView = pickerToolbar;
                    return cell;
                }
                    break;
                case 7:
                {
                    InvConfigInputNumCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"InvConfigInputNumCell"];
                    cell.nameLabel.text = @"Maximum Charge";
                    cell.descriptionLabel.text=@"The maximum charge amount per transaction.";
                    //if(maxChargeAmount)
                        cell.textField.text=[NSString stringWithFormat:@"%@",[AppDelegate decimalDisplay:maxChargeAmount/100]];//[NSString stringWithFormat:@"%@",@(maxChargeAmount)];
                    //else
                    //    cell.textField.text=@"";
                    cell.textField.placeholder = @"Required";
                    
                    cell.textField.keyboardType = UIKeyboardTypeNumberPad;
                    self.maxChargeTextField = cell.textField;
                    self.maxChargeTextField.delegate=self;
                    self.maxChargeTextField.inputAccessoryView = pickerToolbar;
                    return cell;
                }
                    break;
                    /*
                #pragma mark - Card Reader Section
                case 8:
                {
                    InvConfigInputCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"InvConfigInputCell"];
                   
                    cell.nameLabel.text=@"Card Reader/Scanner";
                    cell.textField.text=[scannersArray objectAtIndex:_selectedInventory.selectedScanner];
                    cell.descriptionLabel.text=@"Select the hardware to use for card swipe payment.";
                    _scannerTextField=cell.textField;
                    _scannerTextField.delegate=self;
                    self.scannerTextField.inputView = self.scannerPicker;
                    self.scannerTextField.inputAccessoryView = pickerToolbar;
                    
                    return cell;
                }
                    break;
                    #pragma mark - Synch Section
                case 9:
                {
                 
                    InvConfigInputNumCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"InvConfigInputNumCell"];
                    cell.nameLabel.text = @"Synch order history (days)";
                    cell.descriptionLabel.text=@"Days allowed to synch order history wih users device. Set 0 for unlimited but slow.";
                    //if(_appDelegate.appConfig.allowedDaysToSynch)
                    cell.textField.text=[NSString stringWithFormat:@"%@",@(_appDelegate.appConfig.allowedDaysToSynch)];
                    // else
                    //    cell.textField.text=@"";
                    cell.textField.placeholder = @"Required";
                    
                    cell.textField.keyboardType = UIKeyboardTypeNumberPad;
                    self.allowedDaysToSyncTextField = cell.textField;
                    self.allowedDaysToSyncTextField.delegate=self;
                     self.allowedDaysToSyncTextField.inputAccessoryView = pickerToolbar;
                    return cell;
                }
                    
                    break;
                */
            }
    }
    return nil;
}



#pragma mark - UITableViewDelegate methods

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//
//}

#pragma mark - UIPicker data source

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    /*if([pickerView isEqual:_scannerPicker])
       
        return [scannersArray count];
    else*/ if([pickerView isEqual:_refundLevelPicker])
        return [refundLevelArray count];
        //return (component == 0) ? 2 : 0;
    else if([pickerView isEqual:_currencyPicker])
        return [currenciesArray count];
    return 0;
}

#pragma mark - UIPicker delegate

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    /*if([pickerView isEqual:_scannerPicker]){
        if (component == 0) {
           return [scannersArray objectAtIndex:row]; //self.paymentArray[row];
        }
    }
    else*/ if([pickerView isEqual:_refundLevelPicker]){
        if (component == 0) {
            return [refundLevelArray objectAtIndex:row]; //self.paymentArray[row];
        }
    }
    else if([pickerView isEqual:_currencyPicker]){
        if (component == 0) {
            return [NSString stringWithFormat:@"%@ %@",[currenciesArray objectAtIndex:row],[_appDelegate.appConfig.currencies valueForKey:[currenciesArray objectAtIndex:row] ]]; //self.paymentArray[row];
        }
    }
    
    return nil;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    /*if([pickerView isEqual:_scannerPicker]){
        if (component == 0) {
            selectedScanner = row;
            _scannerTextField.text=[NSString stringWithFormat:@"%@",[refundLevelArray objectAtIndex:selectedScanner]];
        }
        
    }
    else*/ if([pickerView isEqual:_refundLevelPicker]){
        if (component == 0) {
            selectedRefundLevel = row;
            _refundLevelTextField.text=[NSString stringWithFormat:@"%@",[refundLevelArray objectAtIndex:selectedRefundLevel]];
        }
        
       
    }
    else if([pickerView isEqual:_currencyPicker]){
        if (component == 0) {
            selectedCurrencyIndex = row;
            _currencyTextField.text=[NSString stringWithFormat:@"%@ %@",[currenciesArray objectAtIndex:selectedCurrencyIndex],[_appDelegate.appConfig.currencies valueForKey:[currenciesArray objectAtIndex:row] ]];//[NSString stringWithFormat:@"%@",[currenciesArray objectAtIndex:selectedCurrencyIndex]];
        }
        
        
    }
   // hasChanged=YES;
    //[self.tableView reloadData];
    
    
}

#pragma mark - UIPicker configuration

//- (void)configurePickerView {
//    
//   
//    
//   // self.activateSwitch=[[UISwitch alloc] init];
//    //[self.activateSwitch addTarget:self action:@selector(stateChanged) forControlEvents:UIControlEventValueChanged];
//   
//    /*
//    //Create and configure toolabr that holds "Done button"
//    UIToolbar *pickerToolbar = [[UIToolbar alloc] init];
//    pickerToolbar.barStyle = UIBarStyleBlackTranslucent;
//    [pickerToolbar sizeToFit];
//    
//    UIBarButtonItem *flexibleSpaceLeft = [[UIBarButtonItem alloc]
//                                          initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
//                                          target:nil
//                                          action:nil];
//    
//    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done"
//                                                                   style:UIBarButtonItemStyleBordered
//                                                                  target:self
//                                                                  action:@selector(pickerDoneButtonPressed)];
//    
//    [pickerToolbar setItems:[NSArray arrayWithObjects:flexibleSpaceLeft, doneButton, nil]];
//    */
//    /*
//    self.paymentTextField.inputView = self.paymentPicker;
//    self.paymentTextField.inputAccessoryView = pickerToolbar;
//    */
//    
//   /*
//    
//    self.nameTextField.inputAccessoryView = pickerToolbar;
//    self.salesTaxTextField.inputAccessoryView = pickerToolbar;
//    */
//    //self.discountTextField.inputAccessoryView = pickerToolbar;
//    /*
//     self.currencyTextField.inputAccessoryView = pickerToolbar;
//    self.maxUnpaidTextField.inputAccessoryView = pickerToolbar;
//    self.minChargeTextField.inputAccessoryView = pickerToolbar;
//    self.maxChargeTextField.inputAccessoryView = pickerToolbar;
//     */
//    //self.refundLevelTextField.inputAccessoryView = pickerToolbar;
//    
//   
//    
//    
//}

- (void)pickerDoneButtonPressed {
    [self.view endEditing:YES];
   
}
/*
-(void)stateChaged:(UISwitch *)switchState{
    if([switchState isOn]){
        _isActiveInventory=YES;
    }
    else{
        _isActiveInventory=NO;
    }
}
*/
-(void)textFieldDidEndEditing:(UITextField *)textField{
    if([textField isEqual:_nameTextField]){
        self.nameTextField.text=[self.nameTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" "]];
        name=_nameTextField.text;
    }
    else if([textField isEqual:_salesTaxTextField]){
         if([nf numberFromString:_salesTaxTextField.text]){
            salesTax=[self.salesTaxTextField.text doubleValue];
             
         }
         else{
             //_salesTaxTextField.text=
         }
    }
    else if([textField isEqual:_maxUnpaidTextField]){
        if([nf numberFromString:_maxUnpaidTextField.text ]){
            maxUnpaidOrdersPerCustomer=[self.maxUnpaidTextField.text integerValue];
        }
    }
   else  if([textField isEqual:_maxChargeTextField]){
       if([nf numberFromString:_maxChargeTextField.text ]){
           maxChargeAmount=[_maxChargeTextField.text doubleValue]*100;
       }
    }
    else if([textField isEqual:_minChargeTextField]){
        if([nf numberFromString:_minChargeTextField.text ]){
            minChargeAmount=[_minChargeTextField.text doubleValue]*100;
            
        }
    }

    
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

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if([string isEqualToString:@""])
        return YES;
    
    if([textField isEqual:_maxChargeTextField] || [textField isEqual:_minChargeTextField] ){
        if(textField.text.length>10){
            return NO;
        }
    }
    else if([textField isEqual:self.salesTaxTextField]){
        if(textField.text.length>5){
            return NO;
        }
    }
    else if([textField isEqual:self.nameTextField]){
        if(textField.text.length>35){
            return NO;
        }
    }
    return YES;
}

- (IBAction)toggleAcceptCCard:(id)sender {
 
    acceptCard=[_acceptCCardSwitch isOn];
    
}

- (IBAction)toggleAcceptCash:(id)sender {
   
    acceptCash=[_acceptCashSwitch isOn];
}
- (IBAction)toggleEcommerce:(id)sender {
    /*
    if( [(UISwitch *) sender isOn]){
        isEcommerce=YES;
    }
    else{
        isEcommerce=NO;
    }
    */
    isEcommerce=[_isEcommerceSwitch isOn];
    [self.tableView reloadData];
    
}

- (IBAction)toggleActivate:(id)sender {
    
    isActive=[_isActiveSwitch isOn];
    
    
}

@end
