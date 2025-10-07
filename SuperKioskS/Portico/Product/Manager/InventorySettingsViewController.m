//
//  PaymentViewController.m

#import "InventorySettingsViewController.h"

#import "InvConfigInputCell.h"
#import "InvConfigTitleCell.h"
#import "InvConfigRefundCell.h"
#import "InvConfigInputNumCell.h"
#import "InvConfigDisplayCell.h"
#import "InvConfigCurrencyCell.h"
#import "InvConfigAcceptCardCell.h"
#import "InvConfigAcceptCashCell.h"
#import "InvConfigAcceptSKCell.h"
#import "InvConfigEcommerceCell.h"
#import "InvConfigIsLiveCell.h"
#import "InvConfigSwitchSectionCell.h"
#import "InvConfigSectionCell.h"
#import "InvConfigMenuIDCell.h"
#import "AppDelegate.h"
//#import "InventroySettings.h"
#import "InventoryModel.h"
#import "InventoryItem.h"
#import "Product.h"
#import "Util.h"

//#import "InventorySelectionDelegate.h"

#import "defs.h"


#define MENU_INV_MANAGE  @"Manage Items"
#define MENU_INV_SETTINGS @"Settings"
#define MENU_INV_BACKUP @"Backup"
#define MENU_INV_RESTORE @"Restore"
#define MENU_INV_BACKUP_MYDRIVE @"Backup to MyDrive"
#define MENU_INV_RESTORE_MYDRIVE @"Restore from MyDrive"

#define MENU_INV_SAVE @"Save continue edit"
#define MENU_INV_SAVEEXIT @"Save"
//_saveButton=[[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStyleBordered target:self action:@selector(saveButtonTapped:)];

//_saveDoneButton=[[UIBarButtonItem alloc] initWithTitle:@"Save/Done" style:UIBarButtonItemStyleBordered target:self action:@selector(saveDoneButtonTapped:)];

#define TAG_NEWNAME 1
#define TAG_RENAME 2
#define TAG_BACKUP_LOCAL 3
#define TAG_RESTORE_LOCAL 4
#define TAG_BACKUP_MYDRIVE 5
#define TAG_RESTORE_MYDRIVE 6

#define SAVE_TO_LOCAL 1
#define SAVE_TO_MYDRIVE 2

#define RESTORE_FROM_LOCAL 1
#define RESTORE_FROM_MYDRIVE 2

/*
#define PAY_BOTH 0
#define PAY_CARD 1
#define PAY_CASH 2
*/
//#define INVENTORY_BACKUP 3



@interface InventorySettingsViewController (){
    
    BOOL isEcommerce;
    BOOL isLive;
    //BOOL hasChanged;
    
    
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
    BOOL acceptSK;
    double salesTax;
    NSInteger maxUnpaidOrdersPerCustomer;
    NSInteger minChargeAmount;
    NSInteger maxChargeAmount;
    
    NSNumberFormatter *nf;
    
    UIAlertView *registerAlert;
    BOOL registerLater;
    //UIBarButtonItem *itemsButtonItem;
    //UIBarButtonItem *exportButtonItem;
    NSString *selected_restore_filename;
    
    
    UIActionSheet *_menuActionSheet;
    UIBarButtonItem *_menuButtonItem;
}
@property (strong, nonatomic) IBOutlet UITableView* tableView;
@property (strong, nonatomic) IBOutlet UIView* buttonView;

@property (strong, nonatomic) IBOutlet UIBarButtonItem* saveButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem* saveDoneButton;

@property (strong, nonatomic) UITextField* nameTextField;
@property (strong, nonatomic) UISwitch* isActiveSwitch;
@property (strong, nonatomic) UISwitch* isEcommerceSwitch;
@property (strong, nonatomic) UISwitch* isLiveSwitch;


@property (strong, nonatomic) UITextField* salesTaxTextField;
@property (strong, nonatomic) UITextField* currencyTextField;
@property (strong, nonatomic) UITextField* symbolTextField;
@property (strong, nonatomic) UITextField* menuIDTextField;


@property(strong,nonatomic) UISwitch *acceptCCardSwitch;
@property(strong,nonatomic) UISwitch *acceptCashSwitch;
@property(strong,nonatomic) UISwitch *acceptSKSwitch;



@property (strong, nonatomic) UITextField* refundLevelTextField;


@property (strong, nonatomic) UITextField* maxUnpaidTextField;
@property (strong, nonatomic) UITextField* maxChargeTextField;
@property (strong, nonatomic) UITextField* minChargeTextField;




@property (strong, nonatomic) UIPickerView *refundLevelPicker;
@property (strong, nonatomic) UIPickerView *currencyPicker;

@property (nonatomic, strong) AppDelegate *appDelegate;

//@property (nonatomic, strong) InventoryModel *inventoryModel;

@property (strong, nonatomic) IBOutlet UILabel *categoriesLabel;


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
    self.view.backgroundColor=[UIColor clearColor];
    
	// Do any additional setup after loading the view.
    _appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadData) name:NOTIFY_UPDATE_INVENTORY object:nil];
   
    nf=[[NSNumberFormatter alloc] init];
    
     _menuButtonItem=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Menu Filled"] style:UIBarButtonItemStyleBordered target:self action:@selector(showMenuActionSheet)];
    
    //_saveButton=[[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStyleBordered target:self action:@selector(saveButtonTapped:)];
    
    //_saveDoneButton=[[UIBarButtonItem alloc] initWithTitle:@"Save/Done" style:UIBarButtonItemStyleBordered target:self action:@selector(saveDoneButtonTapped:)];
    
    self.navigationItem.rightBarButtonItems=@[_menuButtonItem];
    
    //hasChanged=NO;
    
    refundLevelArray=@[REFUND_NOREFUND,REFUND_ORDER_RECEIVED,REFUND_ORDER_READY];
    
    currenciesArray=[_appDelegate.appConfig.currencies allKeys];
    
    
    
    
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
    
    _currencyPicker = [[UIPickerView alloc] init];
    _currencyPicker.delegate = self;
    _currencyPicker.dataSource = self;
    _currencyPicker.showsSelectionIndicator = YES;
    
    
    
    
    
    
}


-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    if(_appDelegate.inventoryModel.inventory){
        [self displayInventory];
    }
    [self.tableView reloadData];
     //[self configurePickerView];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -

-(IBAction)saveButtonTapped:(id)sender{
    [self save:NO];
}
-(IBAction)saveDoneButtonTapped:(id)sender{
    [self save:YES];
}

- (void)save:(BOOL)done {
    
   
//InventoryItem *activeInventory=[InventoryModel activeInventory];
    //self.nameTextField.text=[self.nameTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" "]];
    /*
    if(!name)
    {
        [AppDelegate ShowErrorAlert:@"Please specify a unique name."];
        return;
    }
    self.selectedInventory.name=name;//self.nameTextField.text;
    */
  
    
    
    _appDelegate.inventoryModel.inventory.isEcommerce=isEcommerce;
    _appDelegate.inventoryModel.inventory.acceptCash=acceptCash;
    _appDelegate.inventoryModel.inventory.acceptCCard=acceptCard;
    _appDelegate.inventoryModel.inventory.acceptCCard=acceptSK;
    
   
    //_selectedInventory.isLive=isLive;
    _menuIDTextField.text=[_menuIDTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" "]];
    if(_menuIDTextField.text.length>0)
        _appDelegate.appConfig.device_menuid=[_menuIDTextField.text integerValue];
    
    _appDelegate.inventoryModel.inventory.salesTax=salesTax;
    
    _appDelegate.inventoryModel.inventory.currency=selectedCurrency;
    
    _appDelegate.inventoryModel.inventory.currencySymbol=[_appDelegate.appConfig.currencies valueForKey: _appDelegate.inventoryModel.inventory.currency];
    
    
    
        _appDelegate.inventoryModel.inventory.maxUnpaidOrdersPerCustomer=maxUnpaidOrdersPerCustomer;
    

    
        _appDelegate.inventoryModel.inventory.maxChargeAmount=maxChargeAmount;
    
    
    
        _appDelegate.inventoryModel.inventory.minChargeAmount=minChargeAmount;

    
    
    
    _appDelegate.inventoryModel.inventory.acceptCash=[self.acceptCashSwitch isOn];
    _appDelegate.inventoryModel.inventory.acceptCCard=[self.acceptCCardSwitch isOn];
    
    
    //_selectedInventory.selectedScanner=selectedScanner;
    
    _appDelegate.inventoryModel.inventory.refundLevel=selectedRefundLevel;
    
    
    
    /*BOOL wasActive=_appDelegate.currentInventory.isActive;//
    
    _selectedInventory.isActive=isActive;
    
    if([_appDelegate.currentInventory isEqual:_selectedInventory]){
        if(wasActive){
            
        }
      */
   // _selectedInventory.isActive=isActive;
    BOOL needBroadcast=YES;
    /*if(_appDelegate.currentInventory==nil){
        _appDelegate.currentInventory=[InventoryModel activeInventory];
        if(_appDelegate.currentInventory==nil)
            _appDelegate.currentInventory=[InventoryItem new];
    }
    
    
    _selectedInventory.isActive=isActive;
    
    if(![_selectedInventory isEqual:_appDelegate.currentInventory]){
        if(isActive){
     */
            //[InventoryModel setActiveInventory:_selectedInventory];
            ///_appDelegate.currentInventory=_selectedInventory;
            
       // }
       // else{
           // needBroadcast=NO;
       // }
    //}

    /*}
    else{
        
        
    }
*/
    
   // BOOL wasActive=(self.selectedInventory.isActive)?YES:NO;
    
    
    
    [_appDelegate.inventoryModel saveInventory];

    if(done){
        if(needBroadcast){
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_UPDATE_INVENTORY_SETTINGS object:nil userInfo:@{KEY_SELECTED_INVENTORY:_appDelegate.inventoryModel.inventory}];
        }
       
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    ////synch/publish internet/online
    [self publishMenuOnline];
    
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
   //// if(!_selectedInventory)
        //return 0; // (1) user details, (2) credit card details

    return 2;
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
    
   // if(!_selectedInventory)
    //    return 0;
    
    //return (section == 0) ? 1 : 3;
    switch(section)
    {
        case 0:
            return 2;
        
        case 1:
            if(isEcommerce)
                return 9;
            else
                return 0;
        
       
    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section==1)
        return 68;
    else
       return 0;
}
/*
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
}
*/
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

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    /*if(indexPath.section==0 && indexPath.row==0){
        
        //[self performSegueWithIdentifier:@"toStartCategoryViewController" sender:self];
        if (UI_USER_INTERFACE_IDIOM() == UIUserIntefaceIdiomPad) {

        [self.navigationController popViewControllerAnimated:YES];
         [[NSNotificationCenter defaultCenter] postNotificationName:@"NOTIFY_START_CATEGORY" object:nil userInfo:@{@"selectedInventory":_selectedInventory}];
        }
       
    }
     */
    if(indexPath.section==0 && indexPath.row==1){
        [self performSegueWithIdentifier:@"toCategoryListViewController" sender:self];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
//    if(section==0){
//        /*InvConfigDisplayCell *cell=[self.tableView dequeueReusableCellWithIdentifier:@"InvConfigDisplayCell"];
//        cell.nameLabel.text=@"Products";
//        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
//        return cell;
//        */
//        UITableViewCell *cell=[self.tableView dequeueReusableCellWithIdentifier:@"InvConfigShowProductsCell"];
//        //cell.textLabel.text=@"Products";
//        //cell.imageView.image=[UIImage imageNamed:@"259-list.png"];
//        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
//        return cell;
//    }
    
     if(section==0){
            switch(row){
                
//                case 0:
//                {
//                    
//                    
//                        InvConfigTitleCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"InvConfigTitleCell"];
//                        cell.nameLabel.text = @"Title";
//                    cell.descriptionLabel.text=@"A unique name for this menu/content";
//                    cell.textField.text=name;//self.selectedInventory.name;
//                        cell.textField.placeholder = @"Required";
//
//                        cell.textField.keyboardType = UIKeyboardTypeAlphabet;
//                        self.nameTextField = cell.textField;
//                        self.nameTextField.delegate=self;
//                    self.nameTextField.inputAccessoryView = pickerToolbar;
//                        return cell;
//                }
                    //break;
                case 0:
                {
                    InvConfigMenuIDCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"InvConfigMenuIDCell"];
                    
                    cell.nameLabel.text = @"Assign Menu/Content ID";
                    cell.descriptionLabel.text=@"Devices with thesame ID may share menu/content.";
                    cell.textField.text=[NSString stringWithFormat:@"%li", (long)_appDelegate.appConfig.device_menuid];
                    cell.textField.keyboardType = UIKeyboardTypeNumberPad;
                    self.menuIDTextField = cell.textField;
                    self.menuIDTextField.delegate=self;
                    self.menuIDTextField.inputAccessoryView = pickerToolbar;
                    return cell;
                }
                    break;
                case 1:
                {
                    UITableViewCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"ManageItemsCell"];
                    
                    if(cell==nil){
                        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ManageItemsCell"];
                    }
                    return cell;
                }
                    /*
                case 1:
                {
                    
                    InvConfigIsLiveCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"InvConfigIsLiveCell"];
                    cell.nameLabel.text = @"Live";
                    cell.descriptionLabel.text=@"Go LIVE when your account is approved.";
                    [cell.switchField setOn:isLive];
                    [cell.switchField addTarget:self action:@selector(toggleLive:) forControlEvents:UIControlEventValueChanged];
                    _isLiveSwitch=cell.switchField;
                    return cell;
                    
                    
                }
                case 2:
                {
                    
                    InvConfigEcommerceCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"InvConfigEcommerceCell"];
                    cell.nameLabel.text = @"E-commerce";
                    cell.descriptionLabel.text=@"Enable e-commerce.";
                    [cell.switchField setOn:isEcommerce];
                    [cell.switchField addTarget:self action:@selector(toggleEcommerce:) forControlEvents:UIControlEventValueChanged];
                    _isEcommerceSwitch=cell.switchField;
                    return cell;
                    
                    
                }
                */
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
                    cell.descriptionLabel.text=@"Accept credicard payments remotely from IOS devices.";
                    
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
                        cell.descriptionLabel.text=@"Accept cash payments at the register.";
                    //cell.labelOFF.text=nil;
                    //cell.labelON.text=nil;
                    
                    [cell.switchField setOn:acceptCash animated:YES];
                    [cell.switchField addTarget:self action:@selector(toggleAcceptCash:) forControlEvents:UIControlEventValueChanged];
                    self.acceptCashSwitch=cell.switchField;
                    return cell;
                    }
                case 2:
                {
                    
                    InvConfigAcceptSKCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"InvConfigAcceptSKCell"];
                    cell.nameLabel.text = @"SK Credits";
                    cell.descriptionLabel.text=@"Accept SK credits for payments. 1sk = 1¢";
                    //cell.labelOFF.text=nil;
                    //cell.labelON.text=nil;
                    
                    [cell.switchField setOn:acceptSK animated:YES];
                    [cell.switchField addTarget:self action:@selector(toggleAcceptSK:) forControlEvents:UIControlEventValueChanged];
                    self.acceptSKSwitch=cell.switchField;
                    return cell;
                }
                case 3:
                {
                    InvConfigInputNumCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"InvConfigInputNumCell"];
                    cell.nameLabel.text = @"Currency";
                    cell.descriptionLabel.text=@"Currency use for payment transactions.";
                    //[_nameTextField setText:self.inventory.name];
                    if(!_appDelegate.inventoryModel.inventory.currency){
                        _appDelegate.inventoryModel.inventory.currency=DEF_CURRENCY;//_appDelegate.appConfig.currency;
                        _appDelegate.inventoryModel.inventory.currencySymbol=DEF_CURRENCY_SYMBOL;//_appDelegate.appConfig.currencySymbol;
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
                case 4:
                {
                    InvConfigInputNumCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"InvConfigInputNumCell"];
                    cell.nameLabel.text = @"Sales Tax %";
                    cell.descriptionLabel.text=nil;
                   
                    
                    cell.textField.text=[NSString stringWithFormat:@"%@",[Util decimalDisplay:salesTax]];
                    
                    //cell.textField.textColor = [UIColor lightGrayColor];
                    cell.textField.keyboardType = UIKeyboardTypeDecimalPad;
                    self.salesTaxTextField = cell.textField;
                    self.salesTaxTextField.delegate=self;
                    self.salesTaxTextField.inputAccessoryView = pickerToolbar;
                    return cell;
                }
                    break;
                case 5:{
                    InvConfigRefundCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"InvConfigRefundCell"];
                    cell.nameLabel.text = @"Refundable Level";
                    cell.descriptionLabel.text=@"Level at which a refund is allowed";
                    
                    cell.textField.text=[NSString stringWithFormat:@"%@",[refundLevelArray objectAtIndex:selectedRefundLevel]];
                    
                    
                   
                    cell.textField.keyboardType = UIKeyboardTypeNumberPad;
                    cell.textField.placeholder = @"Required";
                    _refundLevelTextField = cell.textField;
                    
                    self.refundLevelTextField.inputView = self.refundLevelPicker;
                    self.refundLevelTextField.inputAccessoryView = pickerToolbar;

                    
                    return cell;
                }
                    break;
                case 6:
                {
                    InvConfigInputNumCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"InvConfigInputNumCell"];
                    cell.nameLabel.text = @"Maximum UNPAID orders";
                    cell.descriptionLabel.text=@"Maximum number of unpaid orders per user. 0 for unlimited";
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
                case 7:
                {
                    InvConfigInputNumCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"InvConfigInputNumCell"];
                    cell.nameLabel.text = @"Minimum Charge";
                    cell.descriptionLabel.text=@"The minimum charge amount per transaction.";
                    //if(minChargeAmount)
                        cell.textField.text=[NSString stringWithFormat:@"%@",[Util decimalDisplay:minChargeAmount/100]];//[NSString stringWithFormat:@"%@",@(minChargeAmount)];
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
                case 8:
                {
                    InvConfigInputNumCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"InvConfigInputNumCell"];
                    cell.nameLabel.text = @"Maximum Charge";
                    cell.descriptionLabel.text=@"The maximum charge amount per transaction.";
                    //if(maxChargeAmount)
                        cell.textField.text=[NSString stringWithFormat:@"%@",[Util decimalDisplay:maxChargeAmount/100]];//[NSString stringWithFormat:@"%@",@(maxChargeAmount)];
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
    //[self setHiddenSaveButton:NO];
    /*if([pickerView isEqual:_scannerPicker]){
        if (component == 0) {
            selectedScanner = row;
            _scannerTextField.text=[NSString stringWithFormat:@"%@",[refundLevelArray objectAtIndex:selectedScanner]];
        }
        
    }
    else*/ if([pickerView isEqual:_refundLevelPicker]){
        if (component == 0) {
            NSString *s=[refundLevelArray objectAtIndex:row];
            if([s isEqualToString:REFUND_ORDER_RECEIVED]) { //2
                selectedRefundLevel=REFUND_ORDER_RECEIVED_VAL;
                
            }
            else if([s isEqualToString:REFUND_ORDER_READY]) { //3
                selectedRefundLevel=REFUND_ORDER_READY_VAL;
                
            }
            else{//if([s isEqualToString:REFUND_NOREFUND]) { //0
                selectedRefundLevel=REFUND_NOREFUND_VAL;
                
            }
            
            
            //selectedRefundLevel = row;
            //_refundLevelTextField.text=[NSString stringWithFormat:@"%@",[refundLevelArray objectAtIndex:selectedRefundLevel]];
            _refundLevelTextField.text=[NSString stringWithFormat:@"%@",s];
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
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    //[self setHiddenSaveButton:NO];
}
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
   
   // [self setHiddenSaveButton:NO];
    [self save:NO];
    
}

- (IBAction)toggleAcceptCash:(id)sender {
   
    acceptCash=[_acceptCashSwitch isOn];
    
    //[self setHiddenSaveButton:NO];
    [self save:NO];
}

- (IBAction)toggleAcceptSK:(id)sender {
    
    acceptSK=[_acceptSKSwitch isOn];
    
    //[self setHiddenSaveButton:NO];
    [self save:NO];
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
    
    //[self setHiddenSaveButton:NO];
    [self save:NO];
}

- (IBAction)toggleLive:(id)sender {
    /*
     if( [(UISwitch *) sender isOn]){
     isEcommerce=YES;
     }
     else{
     isEcommerce=NO;
     }
     */
    if([_isLiveSwitch isOn]){
        if (_appDelegate.appConfig.device_status==DEVICE_STATUS_APPROVED) {
            _appDelegate.inventoryModel.inventory.isLive=YES;
        }
        else{
            
             [_isLiveSwitch setOn:NO];
             _appDelegate.inventoryModel.inventory.isLive=NO;
            [_appDelegate showRegisteAlert];
        }
    }
    else{
        _appDelegate.inventoryModel.inventory.isLive=NO;
    }
    
    
    //[self setHiddenSaveButton:NO];
    
}

- (IBAction)toggleActivate:(id)sender {
    
    isActive=[_isActiveSwitch isOn];
    //[self setHiddenSaveButton:NO];
    
}



-(void)displayInventory{
    //self.navigationItem.rightBarButtonItem=self.saveButton;
    isEcommerce=_appDelegate.inventoryModel.inventory.isEcommerce;
    
    
    
    name=_appDelegate.inventoryModel.inventory.name;
    
    selectedRefundLevel=_appDelegate.inventoryModel.inventory.refundLevel;
    
    selectedCurrency=_appDelegate.inventoryModel.inventory.currency;
    selectedCurrencyIndex=[currenciesArray indexOfObject:selectedCurrency];
    
    
    
    [_refundLevelPicker selectRow:selectedRefundLevel inComponent:0 animated:NO];
    
    
    [_currencyPicker selectRow:selectedCurrencyIndex inComponent:0 animated:NO];
    
    
    //isActive=_appDelegate.inventoryModel.inventory.isActive;
    acceptCard=_appDelegate.inventoryModel.inventory.acceptCCard;
    acceptCash=_appDelegate.inventoryModel.inventory.acceptCash;
    acceptSK=_appDelegate.inventoryModel.inventory.acceptSK;
    salesTax=_appDelegate.inventoryModel.inventory.salesTax;
    maxUnpaidOrdersPerCustomer=_appDelegate.inventoryModel.inventory.maxUnpaidOrdersPerCustomer;
    minChargeAmount=_appDelegate.inventoryModel.inventory.minChargeAmount;
    maxChargeAmount=_appDelegate.inventoryModel.inventory.maxChargeAmount;
}
/*
-(void)selectedInventory:(InventoryItem *)inventory{
    if(inventory){
        //_appDelegate.tmpSelectedInventory=inventory;
        [self setSelectedInventory:inventory];
        [self displayInventory];
        
        
        
        [self.tableView reloadData];
        
        //dismiss popover if it's showing
        if(_popover!=nil){
            [_popover dismissPopoverAnimated:YES];
        }
    }
    
}
 */
//-(void)splitViewController:(UISplitViewController *)svc willHideViewController:(UIViewController *)aViewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)pc{
//    /*self.popover=pc;
//    barButtonItem.title=@"Inventories";
//    [_navBarItem setLeftBarButtonItem:barButtonItem animated:YES];
//     */
//    NSLog(@"Will hide left side");
//}
//
//-(void)splitViewController:(UISplitViewController *)svc willShowViewController:(UIViewController *)aViewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem{
//    /*[_navBarItem setLeftBarButtonItem:nil animated:YES];
//    _popover=nil;
//     */
//    NSLog(@"Will show left side");
//}

//-(void)splitViewController:(UISplitViewController *)svc willHideViewController:(UIViewController *)aViewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)pc{
//    
//    self.popover=pc;
//    //barButtonItem.title=@"Inventories";
//    //[_navBarItem setLeftBarButtonItem:barButtonItem animated:YES];
//    //UINavigationItem *navItem = [self navigationItem];
//    //[[self navigationItem] setLeftBarButtonItem:barButtonItem animated:YES];
//    /*if(self.navigationItem.backBarButtonItem!=nil){
//        self.navigationItem.leftItemsSupplementBackButton=YES;
//        self.navigationItem.leftBarButtonItems=@[barButtonItem, self.navigationItem.backBarButtonItem];
//    }
//    else{
//        self.navigationItem.leftBarButtonItems=@[barButtonItem];
//    }
//     */
//    
//    UINavigationItem *navItem = [self navigationItem];
//    //[navItem setLeftBarButtonItem:barButtonItem animated:YES];
//    [navItem setRightBarButtonItem:barButtonItem animated:YES];
//    
//    NSLog(@"Will hide left side 2");
//}
//
//-(void)splitViewController:(UISplitViewController *)svc willShowViewController:(UIViewController *)aViewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem{
//    /*[_navBarItem setLeftBarButtonItem:nil animated:YES];
//     
//     */
//    
//    //self.navigationItem.leftItemsSupplementBackButton=YES;
//    /* if(self.navigationItem.backBarButtonItem!=nil){
//    self.navigationItem.leftBarButtonItems=@[self.navigationItem.backBarButtonItem];
//     }
//     else{
//         self.navigationItem.leftBarButtonItems=nil;
//     }
//     */
//    
//    //[[self navigationItem] setLeftBarButtonItem:barButtonItem animated:YES];
//    _popover=nil;
//    NSLog(@"Will show left side 2");
//}

//-(void)setHiddenSaveButton:(BOOL)hide{
//    /*
//    if(hide){
//        if ([self.navigationItem.rightBarButtonItem isEqual:_saveButton]) {
//            self.navigationItem.rightBarButtonItem=nil;
//        }
//    }
//    else{
//        if (![self.navigationItem.rightBarButtonItem isEqual:_saveButton]) {
//            self.navigationItem.rightBarButtonItem=_saveButton;
//        }
//
//    }
//     */
//    if(hide){
//        if([self.navigationItem.rightBarButtonItems containsObject:_saveButton]){
//           // self.navigationItem.rightBarButtonItems=@[itemsButtonItem,exportButtonItem];
//            self.navigationItem.rightBarButtonItem=nil;
//        }
//    }
//    else{
//        //self.navigationItem.rightBarButtonItems=@[_saveButton, itemsButtonItem,exportButtonItem];
//        self.navigationItem.rightBarButtonItem=_saveButton;
//    }
//   
//}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    //currentInventory=[InventoryModel sharedInstance];
    //NSDictionary *inventory_dict=[inventoryModel.inventories valueForKey:selectedName];
    if ([segue.identifier isEqualToString:@"toCategoryListViewController"]) {
        ///if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        
        /*
         UINavigationController *nav=segue.destinationViewController;
         CategoryIpadViewController *dest=(CategoryIpadViewController *)[nav topViewController];
         dest.selectedInventory=self.selectedInventory;
         */
        //}
        //else{
        //CategoryListViewController *dest=segue.destinationViewController;
        //dest.selectedInventory=self.selectedInventory;
        //}
    }
}
/*
-(void)showItems:(id)sender{
    [self performSegueWithIdentifier:@"toCategoryViewController" sender:self];
}

-(void)showBackupDialog:(id)sender{
    UIAlertView * alert =[[UIAlertView alloc ] initWithTitle:@"Backup menu" message:@"Enter backup name" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles: @"OK", nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    //[alert addButtonWithTitle:@"Backup"];
    alert.tag=INVENTORY_BACKUP;
    UITextField *txtName=[alert textFieldAtIndex:0];
    txtName.text=[NSString stringWithFormat:@"%@%@", _selectedInventory.name,@".bak"];
    [alert show];
    
}
*/

//-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
-(void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{
    if(buttonIndex==[actionSheet cancelButtonIndex])
        return;
    
    NSString *btnTitle=[actionSheet buttonTitleAtIndex:buttonIndex];
    /*
    if ([btnTitle isEqualToString:MENU_INV_MANAGE]) {
        
        
        
        [self performSegueWithIdentifier:@"toCategoryListViewController" sender:self];
        
    }
    else if ([btnTitle isEqualToString:MENU_INV_VIEW]) {
     
     [self performSegueWithIdentifier:@"toInventoryListViewController" sender:self];
     
     
     }
    
    else if ([btnTitle isEqualToString:MENU_INV_SETTINGS]) {
        
        [self performSegueWithIdentifier:@"toInventorySettingsViewController" sender:self];
        
    }
     */
    if ([btnTitle isEqualToString:MENU_INV_BACKUP]) {
        
        [self showBackupDialog];
        
    }
    else if ([btnTitle isEqualToString:MENU_INV_RESTORE]) {
        [self selectFileToImport];
        
        
    }
    else if ([btnTitle isEqualToString:MENU_INV_BACKUP_MYDRIVE]) {
        
        [self backup:nil saveTo:SAVE_TO_MYDRIVE];
        
        
    }
    else if ([btnTitle isEqualToString:MENU_INV_RESTORE_MYDRIVE]) {
        [_appDelegate.inventoryModel.inventory pullInventory];
        
        
    }
    else if ([btnTitle isEqualToString:MENU_INV_SAVE]) {
        [self saveButtonTapped:nil];
        
        
    }
    else if ([btnTitle isEqualToString:MENU_INV_SAVEEXIT]) {
        [self saveDoneButtonTapped:nil];
        
        
    }
    //selectFile
    /*
     else if ([btnTitle isEqualToString:MENU_INV_ACTIVATE]) {
     self.selectedInventory.isActive=YES;
     [inventoryModel saveInventory];
     [self.tableView reloadData];
     }
     else if ([btnTitle isEqualToString:MENU_INV_DEACTIVATE]) {
     
     self.selectedInventory.isActive=NO;
     [inventoryModel saveInventory];
     [self.tableView reloadData];
     }
     
     else if ([btnTitle isEqualToString:MENU_INV_RENAME]) {
     
     UIAlertView * alert =[[UIAlertView alloc ] initWithTitle:@"Rename Inventory" message:@"Enter new name" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles: nil];
     alert.alertViewStyle = UIAlertViewStylePlainTextInput;
     [alert addButtonWithTitle:@"Save"];
     alert.tag=INVENTORY_RENAME;
     [alert show];
     
     
     }*/
    /*else if ([btnTitle isEqualToString:MENU_INV_PUBLISH]) {
     
     
     [InventoryModel publish:selectedName];
     
     [self.tableView reloadData];
     }
     else if ([btnTitle isEqualToString:MENU_INV_ALLOW_CARDPAYMENT]) {
     
     
     currentInventory.allowedPayment=@CASH_ONLY;
     
     [self.tableView reloadData];
     }*/
}

#pragma mark Backup
-(void)showMenuActionSheet{
    /*
     */
    _menuActionSheet=[[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:MENU_INV_SAVE,MENU_INV_SAVEEXIT,MENU_INV_BACKUP,MENU_INV_RESTORE,MENU_INV_BACKUP_MYDRIVE,MENU_INV_RESTORE_MYDRIVE, nil];
// asMenu=[[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:MENU_INV_SETTINGS,MENU_INV_BACKUP, nil];

    [_menuActionSheet showInView:self.view];
}

-(void)showBackupDialog{//:(id)sender{
    UIAlertView * alert =[[UIAlertView alloc ] initWithTitle:@"Export" message:@"Enter file name" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles: @"OK", nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    //[alert addButtonWithTitle:@"Backup"];
    alert.tag=TAG_BACKUP_LOCAL;
    
   
    
    
    UITextField *txtName=[alert textFieldAtIndex:0];
    txtName.text=[NSString stringWithFormat:@"%@.plist",_appDelegate.appConfig.device_name];
    [alert show];
    
}

-(void)showBackupCloud{//:(id)sender{
    UIAlertView * alert =[[UIAlertView alloc ] initWithTitle:@"Synch to MyDrive" message:@"Synch to MyDrive?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles: @"OK", nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    //[alert addButtonWithTitle:@"Backup"];
    alert.tag=TAG_BACKUP_MYDRIVE;
    
    /*
    
    
    UITextField *txtName=[alert textFieldAtIndex:0];
    txtName.text=[NSString stringWithFormat:@"%@.plist",_appDelegate.appConfig.device_name];
    [alert show];
    */
}
-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
//-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    NSString *btnTitle=[alertView buttonTitleAtIndex:buttonIndex];
    
    //    if (alertView.tag==INVENTORY_NEWNAME) {
    //        if([btnTitle isEqualToString:@"OK"]){
    //            UITextField *txtName=[alertView textFieldAtIndex:0];
    //            if(txtName.text.length>0){
    //
    //                AppDelegate *_appDelegate=ApplicationDelegate;
    //                self.selectedInventory=[_appDelegate.inventoryModel addInventory:txtName.text];
    //                if(self.selectedInventory!=nil){
    //
    //
    //                    if(_selectedInventory.isActive){
    //                        _appDelegate.currentInventory=_selectedInventory;
    //                    }
    //
    //
    //
    //                    [self.tableView reloadData];
    //
    //                    NSIndexPath *selectedIndexPath=[NSIndexPath indexPathForRow:[inventoryModel.inventories count]-1 inSection:0];
    //
    //                    [self.tableView selectRowAtIndexPath:selectedIndexPath animated:YES scrollPosition:UITableViewScrollPositionBottom];
    //
    //                    /*[[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_SHOW_INVENTORY_SETTINGS object:nil userInfo:@{KEY_SELECTED_INVENTORY:_selectedInventory}];
    //                     */
    //                    [self performSegueWithIdentifier:@"toInventorySettingsViewController" sender:self];
    //
    //                }
    //                else{
    //                    UIAlertView *errAlert= [[UIAlertView alloc] initWithTitle:@"Error" message:@"There was an error processing your request. Please try again later." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    //                    [errAlert show];
    //                }
    //
    //
    //
    //
    //            }
    //        }
    //
    //    }
    //
    //    else if (alertView.tag==INVENTORY_RENAME) {
    //
    //
    //        if([btnTitle isEqualToString:@"Save"]){
    //            UITextField *txtName=[alertView textFieldAtIndex:0];
    //
    //            /*if([self renameItem:selectedName toName:txtName.text]){
    //             [self reloadInventoryNames];
    //
    //             [self.tableView reloadData];
    //             }
    //             else{
    //             UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Error" message:@"Rename error." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil]
    //             ;
    //             [alert show];
    //             }*/
    //            if(txtName.text.length>0){
    //
    //                self.selectedInventory.name=txtName.text;
    //                [inventoryModel saveInventory];
    //                [self.tableView reloadData];
    //
    //            }
    //
    //        }
    //    }
    
    
    if (alertView.tag==TAG_RESTORE_LOCAL) {
        
        
        if([btnTitle isEqualToString:@"OK"]){
            if(selected_restore_filename==nil || selected_restore_filename.length==0)
                return;
            
            UITextField *txtName=[alertView textFieldAtIndex:0];
            
            
            [self import:txtName.text];
            
            
            
        }
    }
    else if (alertView.tag==TAG_RESTORE_MYDRIVE) {
        
        
        if([btnTitle isEqualToString:@"OK"]){
            /*if(selected_restore_filename==nil || selected_restore_filename.length==0)
                return;
            
            UITextField *txtName=[alertView textFieldAtIndex:0];
            
            
            [self import:txtName.text];
            */
            dispatch_async(dispatch_get_main_queue(), ^{
                NSURL *url=[[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@/drive/%@/%@/inventory_%@.plist",ServerApiURL,_appDelegate.appConfig.user_userid, _appDelegate.appConfig.user_folderid,_appDelegate.appConfig.device_id]];
                NSData *data=[[NSData alloc] initWithContentsOfURL:url];
                if (data!=nil) {
                    [_appDelegate.inventoryModel loadInventoryWithData:data];
                    //we need to call this to overwrite local copy
                    [_appDelegate.inventoryModel saveInventory];
                }
            });
            
        }
    }
    
    else if (alertView.tag==TAG_BACKUP_LOCAL) {
        
        
        if([btnTitle isEqualToString:@"OK"]){
            UITextField *txtName=[alertView textFieldAtIndex:0];
            
            
            if(txtName.text.length>0){
                /*NSString *fname=[[AppDelegate getDocumentsPath] stringByAppendingPathComponent:txtName.text];
                if([[NSFileManager defaultManager] fileExistsAtPath:fname]){
                    [AppDelegate ShowErrorAlert:@"File already exists."]
                    ;                }
                else{*/
                [self backup:txtName.text saveTo:SAVE_TO_LOCAL];
                
                    
                //}
                
            }
            
        }
    }
    
    
    else if (alertView.tag==TAG_BACKUP_MYDRIVE) {
        
        
        if([btnTitle isEqualToString:@"OK"]){
            UITextField *txtName=[alertView textFieldAtIndex:0];
            
            
            if(txtName.text.length>0){
                /*NSString *fname=[[AppDelegate getDocumentsPath] stringByAppendingPathComponent:txtName.text];
                 if([[NSFileManager defaultManager] fileExistsAtPath:fname]){
                 [AppDelegate ShowErrorAlert:@"File already exists."]
                 ;                }
                 else{*/
                [self backup:txtName.text saveTo:SAVE_TO_MYDRIVE];
                
                
                //}
                
            }
            
        }
    }
    
}

//-(void)export:(NSString *)filename{
//    
//    //InventoryItem * inventoryIte=_selectedInventory;
//    InventoryModel *_inventoryModel =[InventoryModel sharedInstance];
//    //NSDictionary *menu_dict=nil;
//    
//    // InventoryItem *inventoryItem=[InventoryModel activeInventory];
//    
//    // if(_selectedInventory==nil)
//    //     return;
//    
//    
//    //NSDictionary *menu_dict=[_selectedInventory toMenuDictionary:deviceID storeName:storeName];
//    NSDictionary *menu_dict=[_inventoryModel.inventory toDictionaryExport];
//    
//    if(menu_dict==nil)
//        return;
//    
//    // Get a full path to a plist within the Backup folder for the app
//    //NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
//    // NSUserDomainMask,
//    //YES);
//    //NSString *bakPath = [NSString stringWithFormat:@"%@/%@",
//    //[paths objectAtIndex:0],name];
//    NSString *backupPath=[[AppDelegate getBackupPath] stringByAppendingPathComponent:filename];
//    NSString *imagesPath=[AppDelegate getImagesPath];
//    //NSMutableArray *images_array=[NSMutableArray new];
//    NSMutableDictionary *images_dict=[NSMutableDictionary new];
//    for (Product *p in _inventoryModel.inventory.products) {
//        if(p.pictureFile){
//            NSString *filePath=[imagesPath stringByAppendingPathComponent:p.pictureFile];
//            if([[NSFileManager defaultManager] fileExistsAtPath:filePath])
//            {
//                NSData *data=[NSData dataWithContentsOfFile:filePath];
//                //UIImage *image=[[UIImage alloc] initWithContentsOfFile:filePath];
//                if(data!=nil){
//                    [images_dict setObject:data forKey:[NSString stringWithFormat:@"%@",p.pictureFile]];
//                }
//                //[images_dict setObject:[NSData dataWithContentsOfFile:filePath] forKey:[NSString stringWithFormat:@"%@",p.pictureFile]];
//                
//                //[images_array addObject:image];
//            }
//        }
//    }
//    
//    
//    NSDictionary *dictionary=@{inventoryItemKey:menu_dict,@"images":images_dict};
//    @try{
//        [   NSKeyedArchiver archiveRootObject:dictionary toFile:backupPath];
//        
//    }
//    @catch(NSException *error){
//        [AppDelegate ShowErrorAlert:[NSString stringWithFormat:@"There was error saving backup. %@",error]];
//    }
//}

-(void)import:(NSString *)filename{
    
    NSData *fileData = [NSData dataWithContentsOfFile:filename];
    if([fileData length] == 0)
        return;
    
    
    NSDictionary *menuDict = [NSDictionary dictionaryWithDictionary:[NSKeyedUnarchiver unarchiveObjectWithData:fileData]];
    
    InventoryItem *source=[InventoryItem fromDictionaryExport:[menuDict valueForKey:inventoryKey]];
    if(source==nil)
        return;
    
    NSDictionary *images=[menuDict valueForKey:@"images"];
    NSArray *keys=[images allKeys];
    if([keys count]>0){
        //NSFileManager fileManager=[NSFileManager defaultManager];
        NSString *imagesPath=[AppDelegate getImagesPath];
        for (NSString *imageFileName in keys) {
            
            //if(![fileManager fileExistsAtPath:imagePath]){
            NSData *imageData=[images valueForKey:imageFileName];
            
            if(imageData){
                //NSString *filePath=[imagesPath stringByAppendingPathComponent:imagePath];
                
                //save image
                NSString *imagePath=[imagesPath stringByAppendingPathComponent:imageFileName];
                //if(![[NSFileManager defaultManager] fileExistsAtPath:filePath])
                [imageData writeToFile:imagePath atomically:YES];
            }
            
            //}
        }
    }
    
            
    //[inventoryModel.inventories addObject:source];
    [_appDelegate.inventoryModel saveInventory];
    [self.tableView reloadData];
    
    
            
}
            
            
-(void)backup:(NSString *)filename saveTo:(NSUInteger)saveTo{
    
    
    NSDictionary *menu_dict=[_appDelegate.inventoryModel.inventory toDictionaryExport];
    
    if(menu_dict==nil)
        return;
    
    
    
    NSString *imagesPath=[AppDelegate getImagesPath];
    //NSMutableArray *images_array=[NSMutableArray new];
    NSMutableDictionary *images_dict=[NSMutableDictionary new];
    for (Product *p in _appDelegate.inventoryModel.inventory.products) {
        if(p.pictureFile){
            NSString *filePath=[imagesPath stringByAppendingPathComponent:p.pictureFile];
            if([[NSFileManager defaultManager] fileExistsAtPath:filePath])
            {
                NSData *data=[NSData dataWithContentsOfFile:filePath];
                //UIImage *image=[[UIImage alloc] initWithContentsOfFile:filePath];
                if(data!=nil){
                    [images_dict setObject:data forKey:[NSString stringWithFormat:@"%@",p.pictureFile]];
                }
                //[images_dict setObject:[NSData dataWithContentsOfFile:filePath] forKey:[NSString stringWithFormat:@"%@",p.pictureFile]];
                
                //[images_array addObject:image];
            }
        }
    }
    
    NSDictionary *dictionary=@{inventoryKey:menu_dict,imagesKey:images_dict};
    
    if(saveTo==SAVE_TO_LOCAL){ //local
        NSString *backupPath=[[AppDelegate getBackupPath] stringByAppendingPathComponent:filename];

        
        @try{
            [   NSKeyedArchiver archiveRootObject:dictionary toFile:backupPath];
            
        }
        @catch(NSException *error){
            [AppDelegate ShowErrorAlert:[NSString stringWithFormat:@"There was error saving backup. %@",error]];
        }
    }
    else if(saveTo==SAVE_TO_MYDRIVE){
       /* we will post as file:
        NSData *data=[NSKeyedArchiver archivedDataWithRootObject:dictionary];
        
         [Util postUploadBeforeSend:data filename:[NSString stringWithFormat:@"inventory_%@.plist",_appDelegate.appConfig.device_id] contenttype:@"application/x-plist"];
        */
        NSDictionary *device_dict=[_appDelegate.inventoryModel.inventory toDictionaryExport] ;
        //add usertoken
        //[device_dict setValue:_appDelegate.appConfig.user_userToken forKey:userTokenKey];
        NSString *json=[Util toJsonString:device_dict];
        //NSString *json=[_appDelegate.inventoryModel.inventory toJSonString];
        if(json==nil || json.length==0)
            return;
        
        [_appDelegate.inventoryModel.inventory pushInventory:json];
    }
}

-(void)restore:(NSString *)filename from:(NSUInteger)from{
    
    
    NSDictionary *menu_dict=[_appDelegate.inventoryModel.inventory toDictionaryExport];
    
    if(menu_dict==nil)
        return;
    
    
    
    NSString *imagesPath=[AppDelegate getImagesPath];
    //NSMutableArray *images_array=[NSMutableArray new];
    NSMutableDictionary *images_dict=[NSMutableDictionary new];
    for (Product *p in _appDelegate.inventoryModel.inventory.products) {
        if(p.pictureFile){
            NSString *filePath=[imagesPath stringByAppendingPathComponent:p.pictureFile];
            if([[NSFileManager defaultManager] fileExistsAtPath:filePath])
            {
                NSData *data=[NSData dataWithContentsOfFile:filePath];
                //UIImage *image=[[UIImage alloc] initWithContentsOfFile:filePath];
                if(data!=nil){
                    [images_dict setObject:data forKey:[NSString stringWithFormat:@"%@",p.pictureFile]];
                }
                //[images_dict setObject:[NSData dataWithContentsOfFile:filePath] forKey:[NSString stringWithFormat:@"%@",p.pictureFile]];
                
                //[images_array addObject:image];
            }
        }
    }
    
    NSDictionary *dictionary=@{inventoryKey:menu_dict,imagesKey:images_dict};
    
    if(from==RESTORE_FROM_LOCAL){ //local
        NSString *backupPath=[[AppDelegate getBackupPath] stringByAppendingPathComponent:filename];
        
        
        @try{
            [NSKeyedArchiver archiveRootObject:dictionary toFile:backupPath];
            
        }
        @catch(NSException *error){
            [AppDelegate ShowErrorAlert:[NSString stringWithFormat:@"There was error saving backup. %@",error]];
        }
    }
    else if(from==RESTORE_FROM_MYDRIVE){
        
        [_appDelegate.inventoryModel.inventory pullInventory];
    }
}



//-(void)postJSon{
//    
//    
//    //NSDictionary *menu_dict=[_appDelegate.inventoryModel.inventory toDictionaryExport:NO];
//    
//    //if(menu_dict==nil)
//    //    return;
//    NSString *json=[_appDelegate.inventoryModel.inventory toJSonString];
//    if(json==nil || json.length==0)
//        return;
//    
//    [Util postInventory:json];
//    /*
//    
//    NSString *imagesPath=[AppDelegate getImagesPath];
//    //NSMutableArray *images_array=[NSMutableArray new];
//    NSMutableDictionary *images_dict=[NSMutableDictionary new];
//    for (Product *p in _appDelegate.inventoryModel.inventory.products) {
//        if(p.pictureFile){
//            NSString *filePath=[imagesPath stringByAppendingPathComponent:p.pictureFile];
//            if([[NSFileManager defaultManager] fileExistsAtPath:filePath])
//            {
//                NSData *data=[NSData dataWithContentsOfFile:filePath];
//                //UIImage *image=[[UIImage alloc] initWithContentsOfFile:filePath];
//                if(data!=nil){
//                    [images_dict setObject:data forKey:[NSString stringWithFormat:@"%@",p.pictureFile]];
//                }
//                //[images_dict setObject:[NSData dataWithContentsOfFile:filePath] forKey:[NSString stringWithFormat:@"%@",p.pictureFile]];
//                
//                //[images_array addObject:image];
//            }
//        }
//    }
//    
//    NSDictionary *dictionary=@{inventoryKey:menu_dict,imagesKey:images_dict};
//    
//    if(saveTo==SAVE_TO_LOCAL){ //local
//        NSString *backupPath=[[AppDelegate getBackupPath] stringByAppendingPathComponent:filename];
//        
//        
//        @try{
//            [   NSKeyedArchiver archiveRootObject:dictionary toFile:backupPath];
//            
//        }
//        @catch(NSException *error){
//            [AppDelegate ShowErrorAlert:[NSString stringWithFormat:@"There was error saving backup. %@",error]];
//        }
//    }
//    else if(saveTo==SAVE_TO_MYDRIVE){
//     
//        NSData *data=[NSKeyedArchiver archivedDataWithRootObject:dictionary];
//     
//        [Util postUploadBeforeSend:data filename:[NSString stringWithFormat:@"inventory_%@.plist",_appDelegate.appConfig.device_id] contenttype:@"application/x-plist"];
//     */
//    
//}

-(void)publishMenuOnline{
    /*
    
    //NSDictionary *menu_dict=[_appDelegate.inventoryModel.inventory toMenuDictionary:_appDelegate.appConfig];
   
    NSDictionary *menu_dict=[_appDelegate.inventoryModel.inventory toDictionaryExport:YES];
    if(menu_dict==nil){ //we will basically delete file online
        NSData *data=[NSData new];
        [Util postUploadBeforeSend:data filename:[NSString stringWithFormat:@"menu_%@.plist",_appDelegate.appConfig.device_id] contenttype:@"application/x-plist"];
        return;
    }
    
    
    NSString *imagesPath=[AppDelegate getImagesPath];
   
    NSMutableDictionary *images_dict=[NSMutableDictionary new];
    //for (Product *p in _appDelegate.inventoryModel.inventory.products) {
    for (NSDictionary *p in [menu_dict valueForKey:productsKey]) {
        //if(p.pictureFile){
        NSString *pictureFile=[p valueForKey:IMAGE_KEY];
        if(pictureFile!=nil && pictureFile.length>0){
            NSString *filePath=[imagesPath stringByAppendingPathComponent:pictureFile];
            if([[NSFileManager defaultManager] fileExistsAtPath:filePath])
            {
                NSData *data=[NSData dataWithContentsOfFile:filePath];
                //UIImage *image=[[UIImage alloc] initWithContentsOfFile:filePath];
                if(data!=nil){
                    [images_dict setObject:data forKey:[NSString stringWithFormat:@"%@",pictureFile]];
                }
                //[images_dict setObject:[NSData dataWithContentsOfFile:filePath] forKey:[NSString stringWithFormat:@"%@",p.pictureFile]];
                
                //[images_array addObject:image];
            }
        }
    }
    
    NSDictionary *dictionary=@{inventoryKey:menu_dict,imagesKey:images_dict};
    
    
        NSData *data=[NSKeyedArchiver archivedDataWithRootObject:dictionary];
        [Util postUploadBeforeSend:data filename:[NSString stringWithFormat:@"menu_%@.plist",_appDelegate.appConfig.device_id] contenttype:@"application/x-plist"];
    */
}




-(void)selectFileToImport{
    FilePickerController *filePicker=[ApplicationDelegate.storyBoard instantiateViewControllerWithIdentifier:@"FilePickerController"];
    filePicker.delegate=self;
    filePicker.folder=@"backup";
    UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:filePicker];
    [self presentViewController:nav animated:YES completion:nil];
}

-(void)filePickerController:(FilePickerController *)picker didFinishPickingFileWithInfo:(NSDictionary *)info{
    selected_restore_filename=[info valueForKey:@"filename"];
    [picker dismissViewControllerAnimated:YES completion:nil];
    [self import:selected_restore_filename];
}


-(void)reloadData{
    [self.tableView reloadData];
}



@end
