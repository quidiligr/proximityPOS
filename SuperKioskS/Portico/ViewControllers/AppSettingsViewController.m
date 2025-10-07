//
//  AppSettingsViewController.m

#import "AppSettingsViewController.h"

#import "AppConfigInputCell.h"
//#import "AppConfigImageCell.h"
//#import "AppConfigSwitchCell.h"
//#import "AppConfigDisplayCell.h"
//#import "IsVisibleCell.h"
//#import "EnableChatCell.h"
//#import "EnableChatSoundCell.h"
//#import "EnablePhotoSharingCell.h"
//#import "AppConfigPhotoCell.h"
//#import "EnableHttpCell.h"
//#import "AppConfigDeviceNameCell.h"
#import "AppDelegate.h"

#import "AppConfigModel.h"

#import "MBProgressHUD.h"
#import "AFNetworking.h"



#import "UIImage+Resize.h"
#import "GKImagePicker.h"
#import "PrintManager.h"
#import "WebViewController.h"
//#import <ImageIO/ImageIO.h>
#import "NSData+Conversion.h" //this will be use if settings has changed
#import "defs.h"

#define PHOTO_PICKER_LOGO 0
#define PHOTO_PICKER_BACKG 1
#define PHOTO_PICKER_BACKG2 2
#define PHOTO_PICKER_WELCOME 3


@interface AppSettingsViewController () <UITableViewDataSource, UITableViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate,GKImagePickerDelegate,UITextInputDelegate,UITextFieldDelegate>{
    
    NSInteger cardReader;
    NSArray* cardReadersArray;
    
    NSArray* authTypeArray;
    NSInteger authType;
    //BOOL hasChanged;
    NSArray *refundLevels;

    UIToolbar *pickerToolbar;
   // UIBarButtonItem *backButtonItem;
    
    int _selectedPhotoPicker;
    
    PrintManager *PM;
    UIActionSheet *asPrinter;
    
    //UIBarButtonItem *registerButton;
    UIBarButtonItem *inventoryButtonItem;
    //UIBarButtonItem *saveButton;
    
    BOOL registerLater;
    BOOL hasChanged;
    
    //BOOL isSaved;
    
}
//@property (strong, nonatomic) IBOutlet UITableView* tableView;
//@property (strong, nonatomic) IBOutlet UIView* buttonView;
@property (strong, nonatomic) IBOutlet UIButton* completeButton;

//@property (strong, nonatomic) UITextField* nickNameTextField;
//@property (strong, nonatomic) UITextField* addressTextField;

@property (strong, nonatomic) UITextField* welcomTextField;
@property (strong, nonatomic) UIImageView* welcomImageField;

//@property(strong,nonatomic) UISwitch *acceptCCardSwitchField;
//@property(strong,nonatomic) UISwitch *acceptCashSwitchField;
//@property(strong,nonatomic) UISwitch *visibleSwitchField;
@property(nonatomic,strong)UISegmentedControl* visibilityModeField;
@property(strong,nonatomic) UISwitch *enableChatSwitchField;
@property(strong,nonatomic) UISwitch *enableChatSoundSwitchField;
@property(strong,nonatomic) UISwitch *enableOrderSoundSwitchField;

@property(strong,nonatomic) UISwitch *barcodeCloseOnSuccessSwitchField;
@property(strong,nonatomic) UISwitch *barcodeAutoAddToCartSwitchField;

@property(strong,nonatomic) UISwitch *enablePhotoSharingSwitchField;
@property(strong,nonatomic) UISwitch *enableHttpSwitchField;

//@property(strong,nonatomic) UISwitch *acceptApplepaySwitchField;

@property (strong, nonatomic) UITextField* refundLevelTextField;
@property (strong, nonatomic) UITextField* paymentProviderTextField;

@property (strong, nonatomic) UITextField* maxUnpaidTextField;
@property (strong, nonatomic) UITextField* maxChargeTextField;
@property (strong, nonatomic) UITextField* minChargeTextField;

@property (strong, nonatomic) UITextField* allowedDaysToSyncTextField;

@property (strong, nonatomic) UITextField* maxDisplayMessagePerUserTextField;

@property (strong, nonatomic) UITextField* paymentPublishableKeyTextField;
@property (strong, nonatomic) UITextField* paymentSecretKeyTextField;


//@property (strong, nonatomic) UITextField* currencyTextField;
//@property (strong, nonatomic) UITextField* salesTaxTextField;
//@property (strong, nonatomic) UITextField* acceptCardsTextField;
//@property (strong, nonatomic) UITextField* acceptCashTextField;
@property (strong, nonatomic) UIImageView* photoImageField;
@property (strong, nonatomic) UIImageView* photobgImageField;
@property (strong, nonatomic) UIImageView* photobg2ImageField;

@property (nonatomic,strong) AFHTTPClient *client;

@property (nonatomic, strong) AppDelegate *appDelegate;

//@property (nonatomic, strong) NSDictionary *config;

@property (nonatomic, strong) UIImagePickerController *pickerPhoto;
@property (nonatomic, strong) UIImagePickerController *pickerBgPhoto;
@property (nonatomic, strong) UIImagePickerController *pickerBg2Photo;
@property (nonatomic, strong) UIImagePickerController *pickerWelcomePhoto;

//@property (weak, nonatomic) IBOutlet UISwitch *swVisible;

@property (strong, nonatomic) UIPickerView *cardReaderPicker;
@property (strong, nonatomic) UITextField* cardReaderTextField;

@property (strong, nonatomic) UIPickerView *authTypePicker;
@property (strong, nonatomic) UITextField *authTypeTextField;

//gkimagepicker
@property (nonatomic, strong) GKImagePicker *imagePicker;
@property (nonatomic, strong) UIPopoverController *popoverController;
@property (nonatomic, strong) UIImagePickerController *ctr;

@end

@implementation AppSettingsViewController
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
	//self.view.backgroundColor=[UIColor clearColor];
    _appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    _client = [AFHTTPClient clientWithBaseURL:[NSURL URLWithString:ServerApiURL]];
    
    //backButtonItem=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(backButtonAction:)];
    
    // registerButton=[[UIBarButtonItem alloc] initWithTitle:@"Register" style:UIBarButtonItemStyleBordered target:self action:@selector(registerButtonTapped:)];
    
    inventoryButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"Inventory" style:UIBarButtonItemStyleBordered target:self action:@selector(showInventory)];
    
    //saveButton=[[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStyleBordered target:self action:@selector(completeButtonTapped:)];
    
    self.navigationItem.rightBarButtonItem=inventoryButtonItem;
    
    //self.nickNameTextField.text =_appDelegate.appConfig.device_name;
    
    
   
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
    UIBarButtonItem *clearButton = [[UIBarButtonItem alloc] initWithTitle:@"Clear"
                                                                    style:UIBarButtonItemStyleBordered
                                                                   target:self
                                                                   action:@selector(pickerClearButtonPressed)];
    
    [pickerToolbar setItems:[NSArray arrayWithObjects:flexibleSpaceLeft,clearButton, doneButton, nil]];
    
    
    
    cardReadersArray=@[@"Camera",@"Swipe"];
    authTypeArray=@[@"None",@"Basic",@"Finger Print"];
    
    
     _cardReaderPicker = [[UIPickerView alloc] init];
     _cardReaderPicker.delegate = self;
     _cardReaderPicker.dataSource = self;
     _cardReaderPicker.showsSelectionIndicator = YES;
    
    
    
    _authTypePicker = [[UIPickerView alloc] init];
    _authTypePicker.delegate = self;
    _authTypePicker.dataSource = self;
    _authTypePicker.showsSelectionIndicator = YES;
    
    /*
     Select user authentication. Basic auth use username and password. Double auth use Basic auth plus finger print or 4 digit PIN.
     */

    
    PM=[PrintManager sharedInstance];
    
    //hasChanged=NO;
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadDataa) name:NOTIFY_PRINTER_SELECTED object:nil];
    
}


-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    hasChanged=NO;
    
    self.welcomTextField.text = _appDelegate.appConfig.welcomeMessage;
    
    [self.enableChatSwitchField setOn:_appDelegate.appConfig.enableChat];
    [self.enablePhotoSharingSwitchField  setOn:_appDelegate.appConfig.enablePhotoSharing];
    cardReader=_appDelegate.appConfig.cardReader;
    [_cardReaderPicker selectRow:cardReader inComponent:0 animated:NO];
    authType=_appDelegate.appConfig.authType;
    [_authTypePicker selectRow:authType inComponent:0 animated:NO];
    
    [self updateNavigationItems];
    [self.tableView reloadData];
   // [self configurePickerView];
    
    
}

-(void)viewDidDisappear:(BOOL)animated{
    if(hasChanged){
        [self actionSave];
    }
}

-(void)reloadDataa{
    [self.tableView reloadData];
}
//
//-(void)viewDidDisappear:(BOOL)animated{
//    [super viewDidDisappear:animated];
//    }
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -


- (IBAction)completeButtonTapped:(id)sender {
   
    
    [self actionSave];
   // [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    
    /*[self.navigationController popViewControllerAnimated:YES];
*/
    
}


-(void)actionSave{
    
    _appDelegate.appConfig.welcomeMessage=self.welcomTextField.text;
    
    //_appDelegate.appConfig.device_name=self.nickNameTextField.text;
    //_appDelegate.appConfig.device_address=self.addressTextField.text;
     _appDelegate.appConfig.allowedDaysToSynch=[self.allowedDaysToSyncTextField.text integerValue];
    _appDelegate.appConfig.cardReader=cardReader;

    _appDelegate.appConfig.authType=authType;

    _appDelegate.appConfig.enableChat=[self.enableChatSwitchField isOn];
     _appDelegate.appConfig.enablePhotoSharing=[self.enablePhotoSharingSwitchField isOn];
    
    _appDelegate.appConfig.enableHttp=[self.enableHttpSwitchField isOn];
    /*
    if(_visibilityModeField.selectedSegmentIndex==MODE_OFF){
        _appDelegate.appConfig.visibility=VISIBILITY_NONE;
    }
    else{
        _appDelegate.appConfig.isVisible=YES;
    }
    */
    [AppConfigModel saveSettings];
    
    [self applyVisibility];
    
    [self updateNavigationItems];
    
    [AppDelegate toast:@"Changes has been saved and published." duration:2.0];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_UPDATE_SERVERINFO object:nil];

}

- (void)postRegisterDeviceRequest
{
    /*
    if(!_appDelegate.appConfig.user_userToken || !_appDelegate.appConfig.device_id)
        return;
    
    NSString *devicename=[self.nickNameTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" "]];
    
    if(!devicename)
        return;
    
    NSString *address=[self.addressTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" "]];
    
    if(!address)
        return;

    
    MBProgressHUD* hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = NSLocalizedString(@"Loading", nil);
    
    NSString *info=[NSString stringWithFormat:@"usertoken=%@&deviceid=%@&devicename=%@&address=%@",_appDelegate.appConfig.user_userToken,_appDelegate.appConfig.device_id,devicename,address];
    
    //if(SECURED){
        NSError *error;
        //NSData *data = [info dataUsingEncoding:NSUTF8StringEncoding];
        NSData *data = [info dataUsingEncoding:NSUTF8StringEncoding];
        NSData *encryptedData = [RNEncryptor encryptData:data
                                            withSettings:kRNCryptorAES256Settings
                                                password:A_SECRET_PASSWORD
                                                   error:&error];
        
        if(error!=nil){
#ifdef DEBUG
            NSLog(@"encryptData error=%@",[error localizedDescription]);
#endif
            return;
        }
        NSString *base64Encoded=[encryptedData base64EncodedStringWithOptions:0];//[NSString stringWithUTF8String:[encryptedData bytes]];
        
        //discoveryInfo=@{@"info":base64Encoded};
        
        //_advertiser = [[MCNearbyServiceAdvertiser alloc] initWithPeer:_myPeerID discoveryInfo:discoveryInfo serviceType:KEY_MC_ADVERTISE_POS];
    //}
    //else{
    //    discoveryInfo=@{@"info":info};
    //    _advertiser = [[MCNearbyServiceAdvertiser alloc] initWithPeer:_myPeerID discoveryInfo:discoveryInfo serviceType:KEY_MC_ADVERTISE_POS];
   // }

    
    NSDictionary *params = @{@"cmd":@"120",
                             @"param":base64Encoded
                             
                             };
    
    [_client postPath:@"/portico/api"
           parameters:params
              success:^(AFHTTPRequestOperation *operation, id responseObject) {
                  
                  if ([self isViewLoaded]) {
                      [MBProgressHUD hideHUDForView:self.view animated:YES];
                      if([operation.response statusCode] != 200) {
                          [AppDelegate ShowErrorAlert:NSLocalizedString(@"There was an error communicating with the server", nil)];
                      } else {
                          
                         
                          
                          NSError* error;
                          NSDictionary* json=[NSJSONSerialization JSONObjectWithData:operation.responseData options:kNilOptions error:&error];
                         
                          NSNumber* success=[json objectForKey:@"success"];
                          if([success intValue]==1){
                              
     
                              NSDictionary *jsondevice=[json objectForKey:@"success"];
                              _appDelegate.appConfig.device_lat=[DICT_GET(jsondevice, @"lat") floatValue];
                              _appDelegate.appConfig.device_lng=[DICT_GET(jsondevice, @"lng") floatValue];
                              _appDelegate.appConfig.device_name=DICT_GET(jsondevice, @"name");
                              _appDelegate.appConfig.device_address=DICT_GET(jsondevice, @"address");
                              _appDelegate.appConfig.device_categoryid=[DICT_GET(jsondevice, @"categoryid") intValue];
                              
                          }
                          else{
                              
                              //_lblMessage.text=@"Login failed.";
                             // [self.tableView reloadData];
                              [AppDelegate ShowErrorAlert:@"Device registration failed."];
                          }
                          
                          
                          
                          
                      }
                  }
              } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                  if ([self isViewLoaded]) {
                      [MBProgressHUD hideHUDForView:self.view animated:YES];
                      [AppDelegate ShowErrorAlert:[error localizedDescription]];
                  }
              }];
    */
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
    return 8; // (1) user details, (2) credit card details
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    //return (section == 0) ? @"Business Info" : @"Payment Settings";
    switch(section){
        case 0:
            return @"Business Info";
            /*
            if(_appDelegate.appConfig.device_status==DEVICE_STATUS_APPROVED)
                status=@"(APPROVED)";
            else if(_appDelegate.appConfig.device_status==DEVICE_STATUS_REGISTERED)
                status=@"(TEST ONLY)";
            else
                return @"Business Info (WAITING APPROVAL)";
            
            return [NSString stringWithFormat:@"Business Info %@",status];
            */
        
            //break;
        
        case 1:
            return @"Presence";
        case 2:
            return @"E-commerce Settings";
        //case 3:
        //    return @"Synch Settings";
        
        case 3:
            return @"Messaging";
        case 4:
            return @"Network";
        case 5:
            return @"Printer";
        case 6:
            return @"Barcode Scanner";
        case 7:
            return @"Enable Sounds";
            //break;
      // case 3:
     //       return @"Merchant Settings";

        default:
            return @"";
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //return (section == 0) ? 3 : 3;
    switch(section){
        case 0: //acount status
            return 5;
        case 1: //visibility
            return 2;
            //break;
        case 2: //
            return 2;
            
        case 3:
            return 2;
        case 4:
            return 1;
        case 5:
            return 1;
        case 6:
            return 2;
        case 7:
            return 2;//2;
            
    }
    return 0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    hasChanged=YES;
    switch(indexPath.section){
        case 0:
            if(indexPath.row==0){
                //if(_appDelegate.appConfig.device_status==DEVICE_STATUS_NOTREGISTERED || _appDelegate.appConfig.device_status==DEVICE_STATUS_REGISTERED){
                    [self registerButtonTapped:nil];
                //}
                
            }
        case 1:
            
            if (indexPath.row==2)
                [self photoTapped];
            
            
            else if (indexPath.row==3)
                 [self bgphotoTapped];
            
            //else if (indexPath.row==5)
             //   [self welcomephotoTapped];

            
           /* else if (indexPath.row==1){
                [self bgphoto2Tapped];
                
            }*/
            break;
        case 5:
            if(indexPath.row==0){
                PrintManager *pm=[PrintManager sharedInstance];
                if(pm.selectedPrinter!=nil){
                    asPrinter=[[UIActionSheet alloc] initWithTitle:@"Printer Setup" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Remove",@"Change", nil];
                }
                else{
                    [pm selectPrinter:self.view];
                }
            }
            break;
        case 6:
            if(indexPath.row==0){
                if(_appDelegate.appConfig.barcodeAutoClose){
                    _appDelegate.appConfig.barcodeAutoClose=NO;
                    
                }
                else{
                    _appDelegate.appConfig.barcodeAutoClose=YES;
                }
                [self.tableView reloadData];
                
            }
            else if(indexPath.row==1){
                if(_appDelegate.appConfig.barcodeAutoAddToCart){
                    _appDelegate.appConfig.barcodeAutoAddToCart=NO;
                    
                }
                else{
                    _appDelegate.appConfig.barcodeAutoAddToCart=YES;
                }
                [self.tableView reloadData];
                
            }
            break;
        case 7:
            if(indexPath.row==0){
                if(_appDelegate.appConfig.enableChatSound){
                    _appDelegate.appConfig.enableChatSound=NO;
                    
                }
                else{
                    _appDelegate.appConfig.enableChatSound=YES;
                }
                [self.tableView reloadData];
                
            }
            else if(indexPath.row==1){
                if(_appDelegate.appConfig.enableOrderSound){
                    _appDelegate.appConfig.enableOrderSound=NO;
                    
                }
                else{
                    _appDelegate.appConfig.enableOrderSound=YES;
                }
                [self.tableView reloadData];
                
            }
            break;
        
    }
}
/*
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    //if(_appDelegate.isIpad){
    
    //}
    
    // else{
    IsVisibleCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"IsVisibleCell"];
    if(cell==nil){
        cell=[[IsVisibleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"IsVisibleCell"];
    }
    return [cell bounds].size.height;
    //}
}
*/

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(!_appDelegate.isIpad){
        /*if(indexPath.section==0){
            if(indexPath.row==1)
                return 100;
        }
         
        if(indexPath.section==1){
            if(indexPath.row==1 || indexPath.row==4)//address,welcome message
                return 100;
        }
        else if(indexPath.section==2){
            //if(indexPath.row==1)//days to sync
                return 100;
        }
        
        else*/ if(indexPath.section==3){
            if(indexPath.row==2)
                return 120;
        }
        else if(indexPath.section==3){
            if(indexPath.row==2)
                return 120;
        }
        else if(indexPath.section==4){
            
                return 120;
        }

        else{
            return 100;
        }
        
    }
    else{
        return 100;
    }
    
    return 100;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
   
    
    
    
    #pragma mark - Account Info Section
    
    if (section == 0) {
        if (row==0) {
            UITableViewCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"AcctStatusCell"];
            
            if(cell==nil){
                cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"AcctStatusCell"];
            }
            
            if(_appDelegate.appConfig.device_status==DEVICE_STATUS_APPROVED){
                //return @"Business Info (APPROVED)";
                //if(_appDelegate.appConfig.device_status==DEVICE_STATUS_APPROVED){
                    if(_appDelegate.inventoryModel.inventory.isEcommerce){
                        if(_appDelegate.appConfig.device_status==BANK_STATUS_APPROVED){
                            //_appDelegate.appConfig.visibility=VISIBILITY_LIVE;
                            cell.textLabel.text=@"Approved (e-commerce)";
                        }
                    }
                    //else{
                        //_appDelegate.appConfig.visibility=VISIBILITY_LIVE;
                      //  cell.textLabel.text=@"Approved";
                    //}
                //}
                cell.textLabel.text=@"Approved (Non e-commerce)";
            }
            else if(_appDelegate.appConfig.device_status==DEVICE_STATUS_WAITINGAPPROVAL)
                cell.textLabel.text=@"Waiting for Approval";
            else if(_appDelegate.appConfig.device_status==DEVICE_STATUS_NOTREGISTERED){
                cell.textLabel.text=@"Not Registered";
                cell.detailTextLabel.text=@"Tap here to register.";
            }
            else if(_appDelegate.appConfig.device_status==DEVICE_STATUS_REGISTERED){
                cell.textLabel.text=@"Test";
                cell.detailTextLabel.text=@"Tap here for approval and go live.";
            }
            else if(_appDelegate.appConfig.device_status==DEVICE_STATUS_CANCELLED)
                cell.textLabel.text=@"Cancelled";
            else if(_appDelegate.appConfig.device_status==DEVICE_STATUS_DELETED)
                cell.textLabel.text=@"Deleted";

            else
                cell.textLabel.text=@"Unknow status.";
            
            
            
            return cell;

        }
        else if (row==1) {
            //AppConfigInputCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"BussNameCell"];
            UITableViewCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"AcctInfoCell"];
            
            if(cell==nil){
                cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"AcctInfoCell"];
            }
            /*
            if(cell==nil){
                cell=[[AppConfigInputCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"BussNameCell"];
            }
            cell.nameLabel.text = @"Business name";
            cell.descriptionLabel.text=@"Your legal business name.";
            if(_appDelegate.appConfig.device_name)
                cell.textField.text=_appDelegate.appConfig.device_name;
            else
                cell.textField.text=[[UIDevice currentDevice] name];
            cell.textField.placeholder = @"Required";
            
            cell.textField.keyboardType = UIKeyboardTypeAlphabet;
            self.nickNameTextField = cell.textField;
            self.nickNameTextField.delegate=self;
            self.nickNameTextField.inputAccessoryView=pickerToolbar;
             */
            NSString *deviceIDMask=@"";
            if(_appDelegate.appConfig.device_id!=nil && _appDelegate.appConfig.device_id.length>0){
                if(_appDelegate.appConfig.device_id.length>8){
                    deviceIDMask=[_appDelegate.appConfig.device_id substringToIndex:8];
                    [deviceIDMask stringByAppendingString:@"..."];
                }
            }
            
            cell.textLabel.text=[NSString stringWithFormat:@"%@ %@", _appDelegate.appConfig.device_name,deviceIDMask];
            cell.detailTextLabel.text=_appDelegate.appConfig.device_address;
            return cell;
        }
        
       /*
        else if (row == 2) {
            AppConfigInputCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"AddressCell"];
            if(cell==nil){
                cell=[[AppConfigInputCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"AddressCell"];
            }

            cell.nameLabel.text = @"Business address";
            cell.descriptionLabel.text=@"Address where this device will be installed.";
            if(_appDelegate.appConfig.device_address)
                cell.textField.text=_appDelegate.appConfig.device_address;
            //else
             //   cell.textField.text=[[UIDevice currentDevice] name];
            
            cell.textField.placeholder = @"Required";
            
            cell.textField.keyboardType = UIKeyboardTypeAlphabet;
            self.addressTextField = cell.textField;
             self.addressTextField.delegate=self;
            self.addressTextField.inputAccessoryView=pickerToolbar;
            return cell;
        }
        */
        else if (row == 2) {
            AppConfigInputCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"LogoCell"];
            if(cell==nil){
                cell=[[AppConfigInputCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LogoCell"];
            }
            cell.nameLabel.text = @"Photo/Logo";
            cell.descriptionLabel.text=@"Your business/store logo.";
            //CGRect frame=cell.imageField.frame;
            //frame.size.width=70.0;
            //frame.size.height=70.0;
            //cell.imageField.frame=frame;
            //[cell.imageField setClipsToBounds:YES];
            cell.contentMode=UIViewContentModeScaleAspectFit;
            cell.imageField.image=[self loadPhoto:[NSString stringWithFormat:@"%@%@.png",PREFIX_MYPHOTO, _appDelegate.appConfig.device_id]];
            
            //cell.imageField.contentMode=UIViewContentModeScaleAspectFit;
            //[cell.imageField setContentMode:UIViewContentModeScaleAspectFit];
            //[cell.imageField setClipsToBounds:YES];
            
            self.photoImageField = cell.imageField;
           // [self.photoImageField setContentMode:UIViewContentModeScaleAspectFit];
          //  [self.photoImageField setClipsToBounds:YES];
            /*UITapGestureRecognizer *photoTap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(photoTapped)];
             photoTap.numberOfTapsRequired=1;
             [self.photoImageField setUserInteractionEnabled:YES];
             [self.photoImageField addGestureRecognizer:photoTap];
             */
            
            return cell;
        }
        else if (row == 3) {
            AppConfigInputCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"BackgroundCell"];
            if(cell==nil){
                cell=[[AppConfigInputCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"BackgroundCell"];
            }
            cell.nameLabel.text = @"Background Image";
            cell.descriptionLabel.text=@"Background image of your business/store.";
            CGRect frame=cell.imageField.frame;
            frame.size.width=48.0;
            frame.size.height=48.0;
            
            cell.imageField.frame=frame;
            
            cell.imageField.image=[self loadBgPhoto:[NSString stringWithFormat:@"%@%@.png",PREFIX_MYBGPHOTO, _appDelegate.appConfig.device_id]];
            
            
            self.photobgImageField = cell.imageField;
            
            /*UITapGestureRecognizer *bgPhotoTap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bgphotoTapped)];
             bgPhotoTap.numberOfTapsRequired=1;
             [self.photobgImageField setUserInteractionEnabled:YES];
             [self.photobgImageField addGestureRecognizer:bgPhotoTap];
             */
            return cell;
            
        }
        
       
        else if (row == 4) {
            AppConfigInputCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"WelcomeMsgCell"];
            if(cell==nil){
                cell=[[AppConfigInputCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"WelcomeMsgCell"];
            }
            
            cell.nameLabel.text = @"Welcome Message";
            cell.descriptionLabel.text=@"Welcome message when a user gets connected.";
            cell.textField.placeholder = @"Your welcome message here.";
            
            if(_appDelegate.appConfig.welcomeMessage)
                cell.textField.text=_appDelegate.appConfig.welcomeMessage;
            else
                cell.textField.text=@"";
            
            cell.textField.keyboardType = UIKeyboardTypeAlphabet;
            self.welcomTextField = cell.textField;
            self.welcomTextField.delegate=self;
            self.welcomTextField.inputAccessoryView=pickerToolbar;
            return cell;
        }
        

        
    }
    
     #pragma mark - Visibility Section
    else if (section == 1) {
        if (row==0) {
            AppConfigInputCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"IsVisibleCell"];
            if(cell==nil){
                cell=[[AppConfigInputCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"IsVisibleCell"];
            }
            
            [cell.modeField setTitle:@"OFF" forSegmentAtIndex:SEG_INDEX_OFF];
            [cell.modeField setTitle:@"Test" forSegmentAtIndex:SEG_INDEX_TEST];
            [cell.modeField setTitle:@"Live" forSegmentAtIndex:SEG_INDEX_LIVE];
            
            //cell.modeField.apportionsSegmentWidthsByContent=YES;
            if(_appDelegate.appConfig.visibility==VISIBILITY_NONE){
                //[cell.switchField setOn:YES];
                cell.modeField.selectedSegmentIndex=SEG_INDEX_OFF;
            }
            else{
                //[cell.switchField setOn:NO];
                if(_appDelegate.appConfig.device_status==DEVICE_STATUS_APPROVED){
                    if(_appDelegate.appConfig.visibility==VISIBILITY_LIVE){
                        cell.modeField.selectedSegmentIndex=SEG_INDEX_LIVE;
                    }
                    else if(_appDelegate.appConfig.visibility==VISIBILITY_TEST){
                        cell.modeField.selectedSegmentIndex=SEG_INDEX_TEST;
                    }
                }
                else{
                    //_appDelegate.appConfig.isLive=NO;
                    _appDelegate.appConfig.visibility=VISIBILITY_TEST;
                    cell.modeField.selectedSegmentIndex=SEG_INDEX_TEST;
                }
            }
            
            [cell.modeField addTarget:self action:@selector(visibilityModeIndexChanged:) forControlEvents:UIControlEventValueChanged];
            
            if(![cell.modeField isEqual: _visibilityModeField]){
                _visibilityModeField=cell.modeField;
            }
            
            //cell.labelON.text = @"Visible";
            cell.nameLabel.text=@"Visibility";
            //cell.labelDescription.text=@"When Live is ON make sure your account is ready to accept credit card tansactions. Otherwise set it OFF for testing purposes. NO charges will be made.";
            //cell.descriptionLabel.text=@"Set Visble to ON to show presence to nearby users.";
            cell.descriptionLabel.text=[NSString stringWithFormat:@"Accnt. Status: %@. Business account must be approved to go Live.",[self labelForDeviceStatus]];
            /*
             self.visibleSwitchField=cell.switchField;
             [self.visibleSwitchField setOn:_appDelegate.appConfig.isVisible];
             [self.visibleSwitchField addTarget:self action:@selector(toggleVisibility:) forControlEvents:UIControlEventValueChanged];
             */
            return cell;
        }
        else if (row==1) {
            AppConfigInputCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"SelectAuthTypeCell"];
            if(cell==nil){
                cell=[[AppConfigInputCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SelectAuthTypeCell"];
            }
            cell.nameLabel.text=@"Select Authentication Type";
            cell.textField.text=[authTypeArray objectAtIndex:authType];
            cell.descriptionLabel.text=@"Select user authentication. Basic auth uses username and password. Double auth uses Basic auth plus finger print or 4 digit PIN.";
            _authTypeTextField=cell.textField;
            _authTypeTextField.delegate=self;
            _authTypeTextField.inputView = _authTypePicker;
            _authTypeTextField.inputAccessoryView = pickerToolbar;
            return cell;
        }
    }
  
    
#pragma mark - Card Reader Section
    else if (section == 2) {
        
        if (row==0) {
            AppConfigInputCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"SelectCardReaderCell"];
            if(cell==nil){
                cell=[[AppConfigInputCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SelectCardReaderCell"];
            }
            cell.nameLabel.text=@"Select Card Reader";
            cell.textField.text=[cardReadersArray objectAtIndex:cardReader];
            cell.descriptionLabel.text=@"Select the supported device to use for card swipe payment.";
            _cardReaderTextField=cell.textField;
            _cardReaderTextField.delegate=self;
            _cardReaderTextField.inputView = _cardReaderPicker;
            _cardReaderTextField.inputAccessoryView = pickerToolbar;
            return cell;
        }
        
#pragma mark - Synch
        
        else if (row==1) {
            AppConfigInputCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"DaysToSyncCell"];
            if(cell==nil){
                cell=[[AppConfigInputCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"DaysToSyncCell"];
            }
            cell.nameLabel.text = @"Days to synch";
            cell.descriptionLabel.text=@"Number of days where users may synch order history with this device.";
            cell.textField.placeholder = @"Required";
            
            cell.textField.text=[NSString stringWithFormat:@"%@",@(_appDelegate.appConfig.allowedDaysToSynch)];
            
            cell.textField.keyboardType = UIKeyboardTypeNumberPad;
            self.allowedDaysToSyncTextField = cell.textField;
            self.allowedDaysToSyncTextField.delegate=self;
             self.allowedDaysToSyncTextField.inputAccessoryView=pickerToolbar;
            return cell;
            
        }
    }

#pragma mark - Messaging Section
    else if (section == 3) {
        if (row==0) {
            AppConfigInputCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"EnableChatCell"];
            if(cell==nil){
                cell=[[AppConfigInputCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"EnableChatCell"];
            }
            //if(_appDelegate.appConfig.enableChat)
                [cell.switchField setOn:_appDelegate.appConfig.enableChat];
           // else
             //   [cell.switchField setOn:NO];
            
            //cell.labelOFF.text=nil;
            //cell.labelON.text=nil;
            
            //cell.labelDescription.text=@"When Live is ON make sure your account is ready to accept credit card tansactions. Otherwise set it OFF for testing purposes. NO charges will be made.";
            cell.nameLabel.text=@"Enable Chat";
            cell.descriptionLabel.text=@"Enable chat communication with your customer.";
            self.enableChatSwitchField=cell.switchField;
            [self.enableChatSwitchField setOn:_appDelegate.appConfig.enableChat];
            [self.enableChatSwitchField addTarget:self action:@selector(toggleChat:) forControlEvents:UIControlEventValueChanged];
            
            return cell;
        }
        else if (row==1) {
            
                AppConfigInputCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"MaxDisplayMsgPerUserCell"];
            if(cell==nil){
                cell=[[AppConfigInputCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MaxDisplayMsgPerUserCell"];
            }
                cell.nameLabel.text = @"Messages per user.";
                cell.descriptionLabel.text=@"Maximum number of messages to display per user. 0 for unlimited";
                
                //if(_appDelegate.appConfig.allowedDaysToSynch)
                cell.textField.text=[NSString stringWithFormat:@"%@",@(_appDelegate.appConfig.allowedDaysToSynch)];
                // else
                //    cell.textField.text=@"";
                cell.textField.placeholder = @"Required";
                
                cell.textField.keyboardType = UIKeyboardTypeNumberPad;
                self.maxDisplayMessagePerUserTextField = cell.textField;
                self.maxDisplayMessagePerUserTextField.delegate=self;
                self.maxDisplayMessagePerUserTextField.inputAccessoryView=pickerToolbar;
                return cell;
                
            
        }
        else if (row==2) {
            AppConfigInputCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"EnablePhotoSharingCell"];
            
            if(cell==nil){
                cell=[[AppConfigInputCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"EnablePhotoSharingCell"];
            }
            //if(_appDelegate.appConfig.enablePhotoAttch)
                [cell.switchField setOn:_appDelegate.appConfig.enablePhotoSharing];
            //else
              //  [cell.switchField setOn:NO];
            
            //cell.labelOFF.text=nil;
            //cell.labelON.text=nil;
            
            //cell.labelDescription.text=@"When Live is ON make sure your account is ready to accept credit card tansactions. Otherwise set it OFF for testing purposes. NO charges will be made.";
            cell.nameLabel.text=@"Enable Photo Sharing";
            cell.descriptionLabel.text=@"Enable photo attachment with chat messaging.";
            self.enablePhotoSharingSwitchField=cell.switchField;
            
            [self.enablePhotoSharingSwitchField addTarget:self action:@selector(togglePhotoSharing:) forControlEvents:UIControlEventValueChanged];
            [self.enablePhotoSharingSwitchField setOn:_appDelegate.appConfig.enablePhotoSharing];
            return cell;
        }
    }
    
    #pragma mark - Network Info
    else if (section == 4) {
        if (row==0) {
            
            AppConfigInputCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"EnableHttpCell"];
            
            if(cell==nil){
                cell=[[AppConfigInputCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"EnableHttpCell"];
            }
            
            //cell.labelOFF.text=nil;
            //cell.labelON.text=nil;
            
            
            cell.nameLabel.text=[NSString stringWithFormat:@"%@", ([_appDelegate serverUrl])?[_appDelegate serverUrl]:@""];
            cell.descriptionLabel.text=@"Backup your device settings to your local computer. Just type the the url above on your computer's web explorer.";
            //if(cell.labelDescription.text.length==0)
            //    cell.labelDescription.text=@"OFF-LINE";
            self.enableHttpSwitchField=cell.switchField;
             [self.enableHttpSwitchField setOn:_appDelegate.appConfig.enableHttp];
            [self.enableHttpSwitchField addTarget:self action:@selector(toggleHttp:) forControlEvents:UIControlEventValueChanged];
            
            return cell;
           
        }
    }
    
#pragma mark - Printer
    else if (section == 5) {
        if (row==0) {
            
            UITableViewCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"ChoosePrinterCell"];
            //AppConfigInputCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"ChoosePrinterCell"];
            
            
            if(cell==nil){
                cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ChoosePrinterCell"];
            }
            
            //cell.labelOFF.text=nil;
            //cell.labelON.text=nil;
            if( PM.selectedPrinter!=nil){
               cell.textLabel.text=PM.selectedPrinter.displayName;
               cell.detailTextLabel.text=PM.selectedPrinter.displayLocation;
                //cell.detailTextLabel.text=[NSString stringWithFormat:@"%@\n\%@",PM.selectedPrinter.displayName,PM.selectedPrinter.displayLocation];
            }
            else{
                cell.textLabel.text=@"No printer selected. Tap to select.";
                //cell.detailTextLabel.text=@"Select printer.";
            }
            
            
            
            return cell;
            
        }
    }

#pragma mark - Barcode
    else if (section == 6) {
        if (row==0) {
            
            AppConfigInputCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"BarcodeCloseOnSuccess"];
            
            if(cell==nil){
                cell=[[AppConfigInputCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"BarcodeCloseOnSuccess"];
            }
            
            /*
            cell.textLabel.text=@"Auto close scanner";
            cell.detailTextLabel.text=@"Close close on scan result.";
             */
            cell.nameLabel.text=@"Close scanner";
            cell.descriptionLabel.text=@"Automatically close barcode scanner on when result is returned.";//@"Close on scan result.";

        /*
            if(_appDelegate.appConfig.barcodeAutoClose==YES){
                cell.accessoryType=UITableViewCellAccessoryCheckmark;
            }
            else{
                cell.accessoryType=UITableViewCellAccessoryNone;
            }
          */
            self.barcodeCloseOnSuccessSwitchField=cell.switchField;
            [self.barcodeCloseOnSuccessSwitchField setOn:_appDelegate.appConfig.barcodeAutoClose];
            [self.barcodeCloseOnSuccessSwitchField addTarget:self action:@selector(toggleBarcodeCloseOnSuccess:) forControlEvents:UIControlEventValueChanged];
            return cell;
            
        }
        else if (row==1) {
            
            //UITableViewCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"BarcodeAutoAddToCart"];
            AppConfigInputCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"BarcodeAutoAddToCart"];
            if(cell==nil){
                cell=[[AppConfigInputCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"BarcodeAutoAddToCart"];
            }
            /*
            cell.textLabel.text=@"Add to cart";
            cell.detailTextLabel.text=@"Add scanned items to cart.";
             */
            cell.nameLabel.text=@"Add items to cart";
            cell.descriptionLabel.text=@"Automatically add scanned items to cart";
            /*
            if(_appDelegate.appConfig.barcodeAutoAddToCart==YES){
                cell.accessoryType=UITableViewCellAccessoryCheckmark;
            }
            else{
                cell.accessoryType=UITableViewCellAccessoryNone;
            }
            */
            self.barcodeAutoAddToCartSwitchField=cell.switchField;
            [self.barcodeAutoAddToCartSwitchField setOn:_appDelegate.appConfig.barcodeAutoAddToCart];
            [self.barcodeAutoAddToCartSwitchField addTarget:self action:@selector(toggleBarcodeAutoAddToCart:) forControlEvents:UIControlEventValueChanged];
            
            return cell;
            
        }
    }

#pragma mark - Sounds
    else if (section == 7) {
        if (row==0) {
            /*
            UITableViewCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"EnableChatSoundCell"];
            
            if(cell==nil){
                cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"EnableChatSoundCell"];
            }
             */
            AppConfigInputCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"EnableChatSoundCell"];
            
            if(cell==nil){
                cell=[[AppConfigInputCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"EnableChatSoundCell"];
            }

            
            //cell.textLabel.text=@"Chat";
            //cell.detailTextLabel.text=@"Enable audio notification when messages sent or received.";
            cell.nameLabel.text=@"Chat";
            cell.descriptionLabel.text=@"Enable/disable audio notification with chat.";
            /*
            if(_appDelegate.appConfig.enableChatSound==YES){
                cell.accessoryType=UITableViewCellAccessoryCheckmark;
            }
            else{
                cell.accessoryType=UITableViewCellAccessoryNone;
            }
            */
            self.enableChatSoundSwitchField=cell.switchField;
            [self.enableChatSoundSwitchField setOn:_appDelegate.appConfig.enableChatSound];
            [self.enableChatSoundSwitchField addTarget:self action:@selector(toggleChatSound:) forControlEvents:UIControlEventValueChanged];
            return cell;
            
        }
        else if (row==1) {
            /*
            UITableViewCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"EnableOrderSoundCell"];
            
            if(cell==nil){
                cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"EnableOrderSoundCell"];
            }
            */
            AppConfigInputCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"EnableOrderSoundCell"];
            
            if(cell==nil){
                cell=[[AppConfigInputCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"EnableChatSoundCell"];
            }
            /*
            cell.textLabel.text=@"Orders";
            cell.detailTextLabel.text=@"Enable audio notification when orders is updated.";
             */
            cell.nameLabel.text=@"Orders";
            cell.descriptionLabel.text=@"Enable/diable audio notification with orders status.";
            /*
            if(_appDelegate.appConfig.enableOrderSound==YES){
                cell.accessoryType=UITableViewCellAccessoryCheckmark;
            }
            else{
                cell.accessoryType=UITableViewCellAccessoryNone;
            }
            */
            self.enableOrderSoundSwitchField=cell.switchField;
            [self.enableOrderSoundSwitchField setOn:_appDelegate.appConfig.enableOrderSound];
            [self.enableOrderSoundSwitchField addTarget:self action:@selector(toggleOrderSound:) forControlEvents:UIControlEventValueChanged];
            return cell;
            
        }
    }

    /*else if (section == 3) {
        if (row==0) {
            AppConfigInputCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"AppConfigInputCell"];
            cell.nameLabel.text = @"Payment Provider";
            
            if(_appDelegate.appConfig.paymentProvider)
                cell.textField.text=_appDelegate.appConfig.paymentProvider;
            else
                cell.textField.text=@"";
            cell.textField.placeholder = @"Required";
            
            cell.textField.keyboardType = UIKeyboardTypeAlphabet;
            self.paymentProviderTextField = cell.textField;
            return cell;
        }
        else if (row==1) {
            AppConfigInputCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"AppConfigInputCell"];
            cell.nameLabel.text = @"Publishable Key";
            
            if(_appDelegate.appConfig.paymentPublishableKey)
                cell.textField.text=_appDelegate.appConfig.paymentPublishableKey;
            else
                cell.textField.text=@"";
            cell.textField.placeholder = @"Required";
            
            cell.textField.keyboardType = UIKeyboardTypeAlphabet;
            self.paymentPublishableKeyTextField = cell.textField;
            return cell;
        }
        else if (row==2) {
            AppConfigInputCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"AppConfigInputCell"];
            cell.nameLabel.text = @"Secret Key";
            
            if(_appDelegate.appConfig.paymentSecretKey)
                cell.textField.text=_appDelegate.appConfig.paymentSecretKey;
            else{

                cell.textField.text=@"";
            }
            cell.textField.placeholder = @"Required";
            
            cell.textField.keyboardType = UIKeyboardTypeAlphabet;
            self.paymentSecretKeyTextField = cell.textField;
            return cell;
        }
    }*/
    return nil;
}

#pragma mark - Table
//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    //if (indexPath.section==0)
//        
//     //       return 54.0;
//        
//    
//
//    //else
//    //    if(indexPath.section==1){
//        
//       // if(indexPath.row==0 || indexPath.row==3)
//       //     return 54.0;
//       // else
//  //          if(indexPath.row==1)
//  //              return 42.0;
//  //  }
////    else if (indexPath.section==2)
////            
////           // if(indexPath.row==0 || indexPath.row==3) {
////                return 54.0;
////    
////    else if (indexPath.section==3){
////        
////        if(indexPath.row==1 || indexPath.row==2 || indexPath.row==3)
////            return 54.0;
////    }
//    //else{
// //   return 68;//42.0;
//    //}
//}

-(UIImage *)loadPhoto:(NSString *)photo{
    
    UIImage *image=nil;
    /*NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDirectory = paths[0];
    */
    NSString *filePath=[[AppDelegate getDocumentsPath] stringByAppendingPathComponent:photo];
    
    //check if cached
    if([[NSFileManager defaultManager] fileExistsAtPath:filePath]){
        image=[[UIImage alloc] initWithContentsOfFile:filePath];
        
    }
    else{
        //TODO: return empty
        image=[UIImage imageNamed:@"person.png"];
    }
    return image;

}
-(UIImage *)loadWelcomePhoto:(NSString *)photo{
    //NSString *my_photo=[NSString stringWithFormat:@"myphoto-%@.png",_appDelegate.userInfo.deviceID];
    // NSString *my_bgphoto=[NSString stringWithFormat:@"bgphoto-%@.png",_appDelegate.userInfo.deviceID];
    UIImage *image=nil;
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDirectory = paths[0];
    
    NSString *filePath=[documentsDirectory stringByAppendingPathComponent:photo];
    
    //check if cached
    if([[NSFileManager defaultManager] fileExistsAtPath:filePath]){
        image=[[UIImage alloc] initWithContentsOfFile:filePath];
        
    }
    else{
        //TODO: return empty
        image=[UIImage imageNamed:@"empty_picture.png"];
    }
    return image;
    
}
-(UIImage *)loadBgPhoto:(NSString *)photo{
  
    UIImage *image=nil;
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDirectory = paths[0];
    
    NSString *filePath=[documentsDirectory stringByAppendingPathComponent:photo];
    
    //check if cached
    if([[NSFileManager defaultManager] fileExistsAtPath:filePath]){
        image=[[UIImage alloc] initWithContentsOfFile:filePath];
        
    }
    else{
        //TODO: return empty
        image=[UIImage imageNamed:@"empty_picture.png"];
    }
    return image;
    
}
/*
-(UIImage *)loadBgPhoto2:(NSString *)photo{
    //NSString *my_photo=[NSString stringWithFormat:@"myphoto-%@.png",_appDelegate.userInfo.deviceID];
    // NSString *my_bgphoto=[NSString stringWithFormat:@"bgphoto-%@.png",_appDelegate.userInfo.deviceID];
    UIImage *image=nil;
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDirectory = paths[0];
    
    NSString *filePath=[documentsDirectory stringByAppendingPathComponent:photo];
    
    //check if cached
    if([[NSFileManager defaultManager] fileExistsAtPath:filePath]){
        image=[[UIImage alloc] initWithContentsOfFile:filePath];
        
    }
    else{
        //TODO: return empty
        image=[UIImage imageNamed:@"empty_picture.png"];
    }
    return image;
    
}
 */
#pragma mark - UITableViewDelegate methods

/*- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

}
*/
#pragma mark - UIPicker data source

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
     if([pickerView isEqual:_cardReaderPicker])
         return [cardReadersArray count];
    else if([pickerView isEqual:_authTypePicker])
        return [authTypeArray count];
    return 0;
}

#pragma mark - UIPicker delegate

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    if([pickerView isEqual:_cardReaderPicker]){
         if (component == 0) {
             return [cardReadersArray objectAtIndex:row]; //
         }
     }
    else if([pickerView isEqual:_authTypePicker]){
        if (component == 0) {
            return [authTypeArray objectAtIndex:row]; //
        }
    }
    
    return nil;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    if([pickerView isEqual:_cardReaderPicker]){
         if (component == 0) {
             cardReader = row;
             _cardReaderTextField.text=[NSString stringWithFormat:@"%@",[cardReadersArray objectAtIndex:cardReader]];
             [self actionSave];
         }
         
         
     }
    else if([pickerView isEqual:_authTypePicker]){
        if (component == 0) {
            authType = row;
            _authTypeTextField.text=[NSString stringWithFormat:@"%@",[authTypeArray objectAtIndex:authType]];
            [self actionSave];
        }
        
        
    }
    
}

#pragma mark - UIPicker configuration

//- (void)configurePickerView {
//    
//    /*
//        self.paymentPicker = [[UIPickerView alloc] init];
//    self.paymentPicker.tag=1;
//    self.paymentPicker.delegate = self;
//    self.paymentPicker.dataSource = self;
//    self.paymentPicker.showsSelectionIndicator = YES;
//    
//    [_paymentPicker selectRow:self.selectedPayment inComponent:0 animated:NO];
//    
//    self.yesNoPicker = [[UIPickerView alloc] init];
//    self.yesNoPicker.tag=2;
//    self.yesNoPicker.delegate = self;
//    self.yesNoPicker.dataSource = self;
//    self.yesNoPicker.showsSelectionIndicator = YES;
//    
//    [_yesNoPicker selectRow:self.selectedYesNo inComponent:0 animated:NO];
//    */
//   // self.activateSwitch=[[UISwitch alloc] init];
//    //[self.activateSwitch addTarget:self action:@selector(stateChanged) forControlEvents:UIControlEventValueChanged];
//   
//    
//    //Create and configure toolabr that holds "Done button"
//    
//    
//    
//    /*self.paymentTextField.inputView = self.paymentPicker;
//    self.paymentTextField.inputAccessoryView = pickerToolbar;
//    
//   
//    
//    self.yesNoTextField.inputView=self.yesNoPicker;
//    self.yesNoTextField.inputAccessoryView=pickerToolbar;
//    */
//    
//    /*
//     _appDelegate.appConfig.welcomeMessage=self.welcomTextField.text;
//     _appDelegate.appConfig.salesTax=[self.salesTaxTextField.text floatValue];
//     _appDelegate.appConfig.currency=self.currencyTextField.text;
//     _appDelegate.appConfig.device_name=self.nickNameTextField.text;
//     _appDelegate.appConfig.device_address=self.addressTextField.text;
//     _appDelegate.appConfig.acceptCash=[self.acceptCashSwitchField isOn];
//     _appDelegate.appConfig.acceptCCard=[self.acceptCCardSwitchField isOn];
//     _appDelegate.appConfig.maxUnpaidOrdersPerCustomer=[self.maxUnpaidTextField.text integerValue];
//     _appDelegate.appConfig.maxChargeAmount=[self.maxChargeTextField.text integerValue];
//     _appDelegate.appConfig.minChargeAmount=[self.minChargeTextField.text integerValue];
//     _appDelegate.appConfig.refundLevel=[self.refundLevelTextField.text integerValue];
//     _appDelegate.appConfig.allowedDaysToSynch=[self.allowedDaysToSyncTextField.text integerValue];
//     
//     
//     */
//    
//    
//    
//   
//    
//    
//}

-(void)photoTapped{
    /*
    self.pickerPhoto=[[UIImagePickerController alloc] init];
    self.pickerPhoto.modalPresentationStyle=UIModalPresentationCurrentContext;
    self.pickerPhoto.delegate=self;
    self.pickerPhoto.allowsEditing=YES;
    
    self.pickerPhoto.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:self.pickerPhoto animated:YES
                     completion:NULL];
     */
    _selectedPhotoPicker=PHOTO_PICKER_LOGO;
    [self showSelectPhotoSource];
}
-(void)bgphotoTapped{
    /*self.pickerBgPhoto=[[UIImagePickerController alloc] init];
    self.pickerBgPhoto.modalPresentationStyle=UIModalPresentationCurrentContext;
    self.pickerBgPhoto.delegate=self;
    self.pickerBgPhoto.allowsEditing=YES;
    self.pickerBgPhoto.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:self.pickerBgPhoto animated:YES
                     completion:NULL];*/
    _selectedPhotoPicker=PHOTO_PICKER_BACKG;
    [self showSelectPhotoSource];
}

-(void)bgphoto2Tapped{
    /*
    self.pickerBg2Photo=[[UIImagePickerController alloc] init];
    self.pickerBg2Photo.modalPresentationStyle=UIModalPresentationCurrentContext;
    self.pickerBg2Photo.delegate=self;
    self.pickerBg2Photo.allowsEditing=YES;
    self.pickerBg2Photo.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:self.pickerBg2Photo animated:YES
                     completion:NULL];
     */
     _selectedPhotoPicker=PHOTO_PICKER_BACKG2;
    [self showSelectPhotoSource];
}
-(void)welcomephotoTapped{
    /*
    self.pickerWelcomePhoto=[[UIImagePickerController alloc] init];
    self.pickerWelcomePhoto.modalPresentationStyle=UIModalPresentationCurrentContext;
    self.pickerWelcomePhoto.delegate=self;
    self.pickerWelcomePhoto.allowsEditing=YES;
    self.pickerWelcomePhoto.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:self.pickerWelcomePhoto animated:YES
                     completion:NULL];
     */
     _selectedPhotoPicker=PHOTO_PICKER_WELCOME;
    [self showSelectPhotoSource];
}


//- (UIImage *)resizeImage:(UIImage *)image {
//    // Create the image source (from path)
//    //CGImageSourceRef src = CGImageSourceCreateWithURL((__bridge CFURLRef) [NSURL fileURLWithPath:imagePath], NULL);
//    /*
//     import ImageIO
//     
//     if let imageSource = CGImageSourceCreateWithURL(self.URL, nil) {
//     let options: [NSString: NSObject] = [
//     kCGImageSourceThumbnailMaxPixelSize: max(size.width, size.height) / 2.0,
//     kCGImageSourceCreateThumbnailFromImageAlways: true
//     ]
//     
//     let scaledImage = CGImageSourceCreateThumbnailAtIndex(imageSource, 0, options).flatMap { UIImage(CGImage: $0) }
//     }
//     */
//    // To create image source from UIImage, use this
//     NSData* pngData =  UIImagePNGRepresentation(image);
//     CGImageSourceRef src = CGImageSourceCreateWithData((CFDataRef)pngData, NULL);
//    
//    // Create thumbnail options
//    CFDictionaryRef options = (__bridge CFDictionaryRef) @{
//                                                           (id) kCGImageSourceCreateThumbnailWithTransform : @YES,
//                                                           (id) kCGImageSourceCreateThumbnailFromImageAlways : @YES,
//                                                           (id) kCGImageSourceThumbnailMaxPixelSize : @(70)
//                                                           };
//    // Generate the thumbnail
//    CGImageRef thumbnail = CGImageSourceCreateThumbnailAtIndex(src, 0, options); 
//    CFRelease(src);
//    // Write the thumbnail at path
//    //CGImageWriteToFile(thumbnail, imagePath);
//    return [UIImage imageWithCGImage:thumbnail];
//}

//- (UIImage *)imageWithImage:(UIImage *)image scaledToFillSize:(CGSize)size
//{
//    CGFloat scale = MAX(size.width/image.size.width, size.height/image.size.height);
//    CGFloat width = image.size.width * scale;
//    CGFloat height = image.size.height * scale;
//    CGRect imageRect = CGRectMake((size.width - width)/2.0f,
//                                  (size.height - height)/2.0f,
//                                  width,
//                                  height);
//    
//    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
//    [image drawInRect:imageRect];
//    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    return newImage;
//}
//
//- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
//    //UIGraphicsBeginImageContext(newSize);
//    // In next line, pass 0.0 to use the current device's pixel scaling factor (and thus account for Retina resolution).
//    // Pass 1.0 to force exact pixel size.
//    //UIGraphicsBeginImageContextWithOptions(newSize, NO, 1.0);
//    UIGraphicsBeginImageContext(newSize);
//    
//    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
//    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    
//    return newImage;
//}


//- (UIImage*)imageByScalingAndCroppingForSizeWithImage:(UIImage *)sourceImage targetSize:(CGSize)targetSize
//{
//    //UIImage *sourceImage = self;
//    UIImage *newImage = nil;
//    CGSize imageSize = sourceImage.size;
//    CGFloat width = imageSize.width;
//    CGFloat height = imageSize.height;
//    CGFloat targetWidth = targetSize.width;
//    CGFloat targetHeight = targetSize.height;
//    CGFloat scaleFactor = 0.0;
//    CGFloat scaledWidth = targetWidth;
//    CGFloat scaledHeight = targetHeight;
//    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
//    
//    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
//    {
//        CGFloat widthFactor = targetWidth / width;
//        CGFloat heightFactor = targetHeight / height;
//        
//        if (widthFactor > heightFactor)
//        {
//            scaleFactor = widthFactor; // scale to fit height
//        }
//        else
//        {
//            scaleFactor = heightFactor; // scale to fit width
//        }
//        
//        scaledWidth  = width * scaleFactor;
//        scaledHeight = height * scaleFactor;
//        
//        // center the image
//        if (widthFactor > heightFactor)
//        {
//            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
//        }
//        else
//        {
//            if (widthFactor < heightFactor)
//            {
//                thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
//            }
//        }
//    }
//    
//    UIGraphicsBeginImageContext(targetSize); // this will crop
//    
//    CGRect thumbnailRect = CGRectZero;
//    thumbnailRect.origin = thumbnailPoint;
//    thumbnailRect.size.width  = scaledWidth;
//    thumbnailRect.size.height = scaledHeight;
//    
//    [sourceImage drawInRect:thumbnailRect];
//    
//    newImage = UIGraphicsGetImageFromCurrentImageContext();
//    
//    if(newImage == nil)
//    {
//        NSLog(@"could not scale image");
//    }
//    
//    //pop the context to get back to the default
//    UIGraphicsEndImageContext();
//    
//    return newImage;
//}

# pragma mark -
# pragma mark GKImagePicker Delegate Methods

- (void)imagePicker:(GKImagePicker *)imagePicker pickedImage:(UIImage *)image{
    hasChanged=YES;
    NSString *photo;
    if(_selectedPhotoPicker==PHOTO_PICKER_LOGO){
        self.photoImageField.image = image;
        
        
       photo=[NSString stringWithFormat:@"%@%@.png",PREFIX_MYPHOTO, _appDelegate.appConfig.device_id];
       
    }
     else if(_selectedPhotoPicker==PHOTO_PICKER_BACKG){
         photo=[NSString stringWithFormat:@"%@%@.png",PREFIX_MYBGPHOTO, _appDelegate.appConfig.device_id];
         [self.photobgImageField setImage:image];
         [_appDelegate setBackgroundImage];
     }
    [self hideImagePicker];
    NSString *filePath=[[AppDelegate getDocumentsPath] stringByAppendingPathComponent:photo];
    //save image
    [UIImagePNGRepresentation(image) writeToFile:filePath atomically:YES];
    
}

- (void)hideImagePicker{
    if (UIUserInterfaceIdiomPad == UI_USER_INTERFACE_IDIOM()) {
        
        [self.popoverController dismissPopoverAnimated:YES];
        
    } else {
        
        [self.imagePicker.imagePickerController dismissViewControllerAnimated:YES completion:nil];
        
    }
}

# pragma mark -
# pragma mark UIImagePickerDelegate Methods
/*
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo{
    self.imgView.image = image;
    
    if (UIUserInterfaceIdiomPad == UI_USER_INTERFACE_IDIOM()) {
        
        [self.popoverController dismissPopoverAnimated:YES];
        
    } else {
        
        [picker dismissViewControllerAnimated:YES completion:nil];
        
    }
}
*/

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    /*
    if (_appDelegate.userInfo.deviceID==nil || _appDelegate.userInfo.deviceID.length<36) {
        return;
    }
    */
    hasChanged=YES;
    _appDelegate.appConfig.needUpdate=YES;
    [self updateNavigationItems];
    UIImage *chosenImage=info[UIImagePickerControllerEditedImage];
    UIImage *scaledImage;
    NSString *photo;
    
    CGFloat oldWidth = chosenImage.size.width;
    CGFloat oldHeight =chosenImage.size.height;
    CGFloat newWidth;
    CGFloat newHeight;
    
    //if([picker isEqual:self.pickerPhoto]){
    if(_selectedPhotoPicker==PHOTO_PICKER_LOGO){
        
        ////CGFloat oldWidth = chosenImage.size.width;
        
        //I'm subtracting 10px to make the image display nicely, accounting
        //for the padding inside the textView
        //CGFloat scaleFactor = oldWidth / 70.0;
      /*  if(oldWidth<1392){
            newWidth=1392;
            newHeight=(oldHeight/oldWidth)*newWidth;
            chosenImage= [self imageWithImage:chosenImage scaledToFillSize:CGSizeMake(newWidth, newHeight)];
            
             oldWidth = chosenImage.size.width;
             oldHeight =chosenImage.size.height;
            
        }
        
         newWidth=70.0;
         newHeight=(oldHeight/oldWidth)*newWidth;
        
        scaledImage= [AppDelegate imageWithImage:chosenImage scaledToSize:CGSizeMake(newWidth, newHeight)];
       
       */
        
        /*
         newWidth=70.0;
        newHeight=(oldHeight/oldWidth)*newWidth;
        */
        //scaledImage=chosenImage;
        newWidth=70.0;
        newHeight=(oldHeight/oldWidth)*newWidth;
        scaledImage= [AppDelegate imageWithImage:chosenImage scaledToSize:CGSizeMake(newWidth, newHeight)];
        //[UIImage cropImageWithInfo:info];
        //scaledImage= [self imageWithImage:chosenImage scaledToSize:CGSizeMake(newWidth, newHeight)];
        
        //scaledImage=[self imageByScalingAndCroppingForSizeWithImage:chosenImage targetSize:CGSizeMake(newWidth, newHeight)];
        /*
        UIGraphicsBeginImageContext(CGSizeMake(480,320));
        
        CGContextRef            context = UIGraphicsGetCurrentContext();
        
        //[image drawInRect: CGRectMake(0, 0, 480, 320)];
        CGRect rect = CGRectMake(0, 0, 320, 480);
        if(chosenImage.size.width/chosenImage.size.height > 320.0/480) {
            rect.size.width = 480/chosenImage.size.heightimage.size.width;
            rect.origin.x = -(rect.size.width-320)/2;
        }
        else if(image.size.width/image.size.height < 320.0/480){
            rect.size.height = 320/chosenImage.size.widthimage.size.height;
            rect.origin.y = -(rect.size.height-480)/2;
        }
        [chosenImage drawInRect: rect];
        
        UIImage        *smallImage = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
        */
        //scaledImage=[UIImage imageWithCGImage:chosenImage.CGImage scale:0.25 orientation:chosenImage.imageOrientation];
        //scaledImage= [AppDelegate scaleImage:chosenImage toSize:CGSizeMake(newWidth, newHeight)];
        //scaledImage=[self resizeImage:chosenImage];
        
        //scaledImage= [self imageWithImage:chosenImage scaledToFillSize:CGSizeMake(newWidth, newHeight)];
        
        //+ (UIImage *)scaleImage:(UIImage *)image toSize:(CGSize)newSize
        //NSData *imageData=[[NSData alloc] initWithData:UIImagePNGRepresentation(chosenImage)];
        
        
        //UIImage *finalImage = [UIImage imageWithCGImage:chosenImage.CGImage scale:scaleFactor orientation:UIImageOrientationUp];
        
        
        photo=[NSString stringWithFormat:@"%@%@.png",PREFIX_MYPHOTO, _appDelegate.appConfig.device_id];
        [self.photoImageField setImage:scaledImage];
    }
    //else if([picker isEqual:self.pickerBgPhoto]){
    else if(_selectedPhotoPicker==PHOTO_PICKER_BACKG){
        //if(_appDelegate.isIpad)
            newWidth=1024.0;
        newHeight=(oldHeight/oldWidth)*newWidth;
        
        scaledImage= [AppDelegate imageWithImage:chosenImage scaledToSize:CGSizeMake(newWidth, newHeight)];
        
        photo=[NSString stringWithFormat:@"%@%@.png",PREFIX_MYBGPHOTO, _appDelegate.appConfig.device_id];
        [self.photobgImageField setImage:scaledImage];
    }
    //else if([picker isEqual:self.pickerBg2Photo]){
       else if(_selectedPhotoPicker==PHOTO_PICKER_BACKG2){
        newWidth=1024.0;
        newHeight=(oldHeight/oldWidth)*newWidth;
        
        scaledImage= [AppDelegate imageWithImage:chosenImage scaledToSize:CGSizeMake(newWidth, newHeight)];
        
        photo=[NSString stringWithFormat:@"%@%@.png",PREFIX_MYBGPHOTO2, _appDelegate.appConfig.device_id];
        [self.photobg2ImageField setImage:scaledImage];
    }
    //else if([picker isEqual:self.pickerWelcomePhoto]){
     else if(_selectedPhotoPicker==PHOTO_PICKER_WELCOME){
        
         newWidth=1024.0;
        newHeight=(oldHeight/oldWidth)*newWidth;
        
        scaledImage= [AppDelegate imageWithImage:chosenImage scaledToSize:CGSizeMake(newWidth, newHeight)];
        
        photo=[NSString stringWithFormat:@"%@%@.png",PREFIX_WELCOMEPHOTO, _appDelegate.appConfig.device_id];
        [self.welcomImageField setImage:scaledImage];
    }
    else{
        return;
    }
    
    //create path
    //NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *filePath=[[AppDelegate getDocumentsPath] stringByAppendingPathComponent:photo];
    //save image
    [UIImagePNGRepresentation(scaledImage) writeToFile:filePath atomically:YES];
    
    //[_myPhoto setImage:chosenImage];
    /*if([picker isEqual:self.pickerPhoto]){
        self.photoImageField.image=[self loadPhoto:[NSString stringWithFormat:@"myphoto-%@.png",_appDelegate.userInfo.deviceID]];
    }
    else{
        self.photobgImageField.image=[self loadPhoto:[NSString stringWithFormat:@"mybgphoto-%@.png",_appDelegate.userInfo.deviceID]];
    }
     */
    
    [picker dismissViewControllerAnimated:YES completion:^{
        [_appDelegate setBackgroundImage];
    }];
}

- (void)showSelectPhotoSource{
    [self.view endEditing:YES];
    UIActionSheet *photoActionSheet=[[UIActionSheet alloc]
                                     initWithTitle: nil
                                     delegate:self
                                     cancelButtonTitle:@"Cancel"
                                     destructiveButtonTitle: nil
                                     otherButtonTitles:@"Use Camera",@"Use Photo Library", NULL];
    [photoActionSheet showInView:self.parentViewController.view ];
}

-(void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{
    NSString *title= [actionSheet buttonTitleAtIndex:buttonIndex];
    
    if([actionSheet isEqual:asPrinter]){
        if([title isEqualToString:@"Remove Printer"]){
            PM.selectedPrinter=nil;
        }
        else if([title isEqualToString:@"Change Printer"]){
            [PM selectPrinter:self.view];
        }
    }
    else{
        if([title isEqualToString:@"Use Camera"]){
            [self useCameraAction];
        }
        else if([title isEqualToString:@"Use Photo Library"]){
            
            [self usePhotoLibraryAction];
        }
    }
    
    
}

- (void)usePhotoLibraryAction {
    
    /*
    UIImagePickerController *picker=[[UIImagePickerController alloc] init];
    picker=[[UIImagePickerController alloc] init];
    picker.modalPresentationStyle=UIModalPresentationCurrentContext;
    picker.delegate=self;
    picker.allowsEditing=YES;
    
    picker.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:picker animated:YES
                     completion:NULL];
     */
    
    [self showResizablePicker];
    
}

-(void)useCameraAction{
    if(![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera ]){
        UIAlertView *myAlertView=[[UIAlertView alloc] initWithTitle:@"Error" message:@"Device has no camera" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [myAlertView show];
    }
    else
    {
        /*
         The problem in iOS7 has to do with transitions. It seems that if a previous transition didn't complete and you launch a new one, iOS7 messes the views, where iOS6 seems to manage it correctly.
         
         You should initialize your Camera in your UIViewController, only after the view has Loaded and with a timeout:
         */
        //show camera...
        // if (!hasLoadedCamera)
        [self performSelector:@selector(showcamera) withObject:nil afterDelay:0.5];
        
        /*UIImagePickerController *picker=[[UIImagePickerController alloc] init];
         picker.delegate=self;
         picker.allowsEditing=YES;
         picker.sourceType=UIImagePickerControllerSourceTypeCamera;
         [self presentViewController:picker animated:YES
         completion:NULL];
         */
    }
}

- (void)showcamera {
    /*pickerCamera = [[UIImagePickerController alloc] init];
     [pickerCamera setDelegate:self];
     [pickerCamera setSourceType:UIImagePickerControllerSourceTypeCamera];
     [pickerCamera setAllowsEditing:YES];
     
     [self presentModalViewController:pickerCamera animated:YES];
     */
    UIImagePickerController *picker=[[UIImagePickerController alloc] init];
    picker.delegate=self;
    self.pickerPhoto.modalPresentationStyle=UIModalPresentationCurrentContext;
    picker.allowsEditing=YES;
    picker.sourceType=UIImagePickerControllerSourceTypeCamera;
    [self presentViewController:picker animated:YES
                     completion:NULL];
}

- (void)pickerDoneButtonPressed {
    
    if([self.welcomTextField isFirstResponder])
        _appDelegate.appConfig.welcomeMessage=self.welcomTextField.text;
    /*
    else if([self.nickNameTextField isFirstResponder])
        _appDelegate.appConfig.device_name=self.nickNameTextField.text;
    
    else if([self.addressTextField isFirstResponder])
        _appDelegate.appConfig.device_address=self.addressTextField.text;
    */
    /*
    else if([self.salesTaxTextField isFirstResponder])
        _appDelegate.appConfig.salesTax=[self.salesTaxTextField.text floatValue];
    
    else if([self.currencyTextField isFirstResponder])
        _appDelegate.appConfig.currency=self.currencyTextField.text;
    
    
    else if([self.refundLevelTextField isFirstResponder])
        _appDelegate.appConfig.refundLevel=[self.refundLevelTextField.text integerValue];
    
    else if([self.maxChargeTextField isFirstResponder])
        _appDelegate.appConfig.maxChargeAmount=[self.maxChargeTextField.text integerValue];
    
    else if([self.minChargeTextField isFirstResponder])
        _appDelegate.appConfig.minChargeAmount=[self.minChargeTextField.text integerValue];
    
    else if([self.maxUnpaidTextField isFirstResponder])
        _appDelegate.appConfig.maxUnpaidOrdersPerCustomer=[self.maxUnpaidTextField.text integerValue];
    */
    else if([self.allowedDaysToSyncTextField isFirstResponder])
        _appDelegate.appConfig.allowedDaysToSynch=[self.allowedDaysToSyncTextField.text integerValue];

    [self.view endEditing:YES];
    if([self.completeButton isHidden])
        [self.completeButton setHidden:NO];
}

- (void)pickerClearButtonPressed {
    //[self.view endEditing:YES];
    if([self.welcomTextField isFirstResponder])
        self.welcomTextField.text=nil;
    /*else if([self.nickNameTextField isFirstResponder])
        self.nickNameTextField.text=nil;
    else if([self.addressTextField isFirstResponder])
        self.addressTextField.text=nil;
    */
     else if([self.refundLevelTextField isFirstResponder])
        self.refundLevelTextField.text=nil;
    else if([self.maxChargeTextField isFirstResponder])
        self.maxChargeTextField.text=nil;
    else if([self.minChargeTextField isFirstResponder])
        self.minChargeTextField.text=nil;

    //else if([self.descriptionTextField isFirstResponder])
     //   self.descriptionTextField.text=nil;
    
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

-(void)applyVisibility{
    
    
    if(_appDelegate.appConfig.visibility==VISIBILITY_NONE){
        
        [_appDelegate.mcManager.advertiser stopAdvertisingPeer];
        
        // [_appDelegate.mcManager.advertiserTEST stopAdvertisingPeer];
        
    }
    else{
        
        [_appDelegate.mcManager advertiseSelf];
    }
    //[AppDelegate toast:@"Visibilty updated." duration:1.0];
}
- (IBAction)toggleVisibility:(id)sender {
    /*
    _appDelegate.appConfig.isVisible=self.visibleSwitchField.isOn;
    //hasChanged=YES;
    _appDelegate.appConfig.needUpdate=YES;
    [self updateNavigationItems];
     */
}

- (IBAction)toggleChat:(id)sender {
    _appDelegate.appConfig.enableChat=self.enableChatSwitchField.isOn;
    hasChanged=YES;
    _appDelegate.appConfig.needUpdate=YES;
    [self updateNavigationItems];
}

- (IBAction)togglePhotoSharing:(id)sender {
    hasChanged=YES;
    _appDelegate.appConfig.needUpdate=YES;
    _appDelegate.appConfig.enablePhotoSharing=self.enablePhotoSharingSwitchField.isOn;

}

- (IBAction)toggleHttp:(id)sender {
    hasChanged=YES;
    _appDelegate.appConfig.needUpdate=YES;
    [self updateNavigationItems];
    _appDelegate.appConfig.enableHttp=self.enableHttpSwitchField.isOn;
   
    [_appDelegate enableHttp:_appDelegate.appConfig.enableHttp];
    [self.tableView reloadData];
        
    
}
- (IBAction)toggleOrderSound:(id)sender {
    hasChanged=YES;
    _appDelegate.appConfig.needUpdate=YES;
    [self updateNavigationItems];
    _appDelegate.appConfig.enableOrderSound=self.enableOrderSoundSwitchField.isOn;
    
    
    [self.tableView reloadData];
    
    
}
- (IBAction)toggleChatSound:(id)sender {
    hasChanged=YES;
    _appDelegate.appConfig.needUpdate=YES;
    [self updateNavigationItems];
    _appDelegate.appConfig.enableChatSound=self.enableChatSoundSwitchField.isOn;
    
   
    [self.tableView reloadData];
    
    
}

- (IBAction)toggleBarcodeCloseOnSuccess:(id)sender {
    hasChanged=YES;
     _appDelegate.appConfig.needUpdate=YES;
    [self updateNavigationItems];
    _appDelegate.appConfig.barcodeAutoClose=self.barcodeCloseOnSuccessSwitchField.isOn;
    
    
    [self.tableView reloadData];
    
    
}
- (IBAction)toggleBarcodeAutoAddToCart:(id)sender {
    hasChanged=YES;
     _appDelegate.appConfig.needUpdate=YES;
    [self updateNavigationItems];
    _appDelegate.appConfig.barcodeAutoAddToCart=self.barcodeAutoAddToCartSwitchField.isOn;
    
    
    [self.tableView reloadData];
    
    
}

/*
- (IBAction)toggleAcceptCCard:(id)sender {
   hasChanged=YES;
    _appDelegate.appConfig.acceptCCard=self.acceptCCardSwitchField.isOn;
    
}

- (IBAction)toggleAcceptCash:(id)sender {
    hasChanged=YES;
    _appDelegate.appConfig.acceptCash=self.acceptCashSwitchField.isOn;
}




- (IBAction)toggleAcceptApplepay:(id)sender {
    hasChanged=YES;
    _appDelegate.appConfig.useApplePay=self.acceptApplepaySwitchField.isOn;
}
 */
/*- (IBAction)backButtonTapped:(id)sender {
    if(hasChanged){
        [self actionSave];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}
*/
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    //hasChanged=YES;
    _appDelegate.appConfig.needUpdate=YES;
    [self updateNavigationItems];
    return YES;
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
    /*NSIndexPath *ip=[NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView scrollToRowAtIndexPath:ip atScrollPosition:UITableViewScrollPositionTop animated:YES];
    */
    return  YES;
}
-(void)selectionWillChange:(id<UITextInput>)textInput{
    
}
-(void)selectionDidChange:(id<UITextInput>)textInput{
    
}
-(void)textWillChange:(id<UITextInput>)textInput{
    
}
-(void)textDidChange:(id<UITextInput>)textInput{
    //if ([textInput isEqual:<#(id)#>]) {
    //    <#statements#>
    //}
   // hasChanged=YES;
    _appDelegate.appConfig.needUpdate=YES;
    [self updateNavigationItems];
}

-(void)backButtonAction:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}
//-(void)showResizablePicker:(UIButton*)btn{
-(void)showResizablePicker{
    self.imagePicker = [[GKImagePicker alloc] init];
    self.imagePicker.cropSize = CGSizeMake(296, 300);
    self.imagePicker.delegate = self;
    self.imagePicker.resizeableCropArea = YES;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        
        self.popoverController = [[UIPopoverController alloc] initWithContentViewController:self.imagePicker.imagePickerController];
        //[self.popoverController presentPopoverFromRect:btn.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        [self.popoverController presentPopoverFromRect:CGRectZero inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        
    } else {
     
        //[self presentModalViewController:self.imagePicker.imagePickerController animated:YES];
        [self presentViewController:self.imagePicker.imagePickerController  animated:YES completion:nil];
        
        
    }
}

-(IBAction)registerButtonTapped:(id)sender{
    //[self performSegueWithIdentifier:@"toInventorySettings" sender:self];
    [self showRegisterDevice];
}

-(void)showLogin
{
    LoginViewController* loginController = (LoginViewController*) [ApplicationDelegate.storyBoard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    UINavigationController* loginNav = [[UINavigationController alloc] initWithRootViewController:loginController];
    
    //LoginViewController* loginController =[[loginNav viewControllers] objectAtIndex:0];
    
    //loginController.dataModel = _dataModel;
    //loginController.client = _client;
    //rom added
    
    //loginController.delegate = self;
    
    [self presentViewController:loginNav animated:YES completion:nil];
}

-(void)showInventory{
    [self performSegueWithIdentifier:@"toInventorySettings" sender:self];
}

-(void)showRegisterDevice{
    if(!_appDelegate.appConfig.user_userToken){
        [self showLogin];
        return;
    }
    
    if(!_appDelegate.appConfig.device_id)
    {
        [AppDelegate ShowErrorAlert:@"Missing device identifier. Please restart or re-install app"];
        return;
    }
    
    NSError *error;
    
    //NSString *address=@""; //TODO
    //NSString *info=[NSString stringWithFormat:@"usertoken=%@&deviceid=%@&devicename=%@&address=%@",_appDelegate.userInfo.userToken,_appDelegate.userInfo.deviceID,_appDelegate.appConfig.device_name,address];
    NSString *info=[NSString stringWithFormat:@"usertoken=%@&deviceid=%@&devicename=%@",_appDelegate.appConfig.user_userToken,_appDelegate.appConfig.device_id,_appDelegate.appConfig.device_name];
    
    
    
    
    NSData *data = [info dataUsingEncoding:NSUTF8StringEncoding];
    NSData *encryptedData = [RNEncryptor encryptData:data
                                        withSettings:kRNCryptorAES256Settings
                                            password:A_SECRET_PASSWORD
                                               error:&error];
    
    if(error!=nil){
#ifdef DEBUG
        NSLog(@"encryptData error=%@",[error localizedDescription]);
#endif
        return;
    }
    
    NSString *base64Encoded=[encryptedData base64EncodedStringWithOptions:0];//[NSString
    
    NSString * encodedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(
                                                                                                     NULL,
                                                                                                     (CFStringRef)base64Encoded,
                                                                                                     NULL,
                                                                                                     (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                                                     kCFStringEncodingUTF8 ));
    
    WebViewController* webController = (WebViewController*) [ApplicationDelegate.storyBoard instantiateViewControllerWithIdentifier:@"WebViewController"];
    // webController.url=[NSString stringWithFormat:@"%@/portico/createwithdevice/?id=%@",ServerApiURL,encodedString];
    webController.url=[NSString stringWithFormat:@"%@/superkiosks/createwithdevice/?id=%@",ServerApiURL,encodedString];
    
    //LoginViewController* loginController = (LoginViewController*) [ApplicationDelegate.storyBoard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    UINavigationController* webNav = [[UINavigationController alloc] initWithRootViewController:webController];
    
    //LoginViewController* loginController =[[loginNav viewControllers] objectAtIndex:0];
    
    //loginController.dataModel = _dataModel;
    //loginController.client = _client;
    //rom added
    
    //loginController.delegate = self;
    
    [self presentViewController:webNav animated:YES completion:nil];
    
    //[self presentViewController:webController animated:YES completion:nil];
}



-(void)updateNavigationItems{
    /*
    if(_appDelegate.appConfig.needUpdate){
    //    if(![self.navigationItem.leftBarButtonItem isEqual:saveButton]){
      //      self.navigationItem.leftBarButtonItem=saveButton;
        //}
    }
    else{
        if(self.navigationItem.leftBarButtonItem!=nil){
            self.navigationItem.leftBarButtonItem=nil;
        }
    }
    
    if(_appDelegate.appConfig.device_status==DEVICE_STATUS_NOTREGISTERED){
        //if(![self.navigationItem.rightBarButtonItem isEqual:saveButton]){
            self.navigationItem.rightBarButtonItem=registerButton;
        //}
    }
    else{
        if(self.navigationItem.rightBarButtonItem!=nil){
            self.navigationItem.rightBarButtonItem=nil;
        }
    }
    */
}
             
-(IBAction)visibilityModeIndexChanged:(UISegmentedControl *)sender{
    hasChanged=YES;
    switch(sender.selectedSegmentIndex){
        case SEG_INDEX_LIVE:
            if(_appDelegate.appConfig.device_status==DEVICE_STATUS_APPROVED){
                if(_appDelegate.inventoryModel.inventory.isEcommerce){
                    if(_appDelegate.appConfig.device_status==BANK_STATUS_APPROVED){
                        _appDelegate.appConfig.visibility=VISIBILITY_LIVE;
                    }
                }
                else{
                    _appDelegate.appConfig.visibility=VISIBILITY_LIVE;
                }
            }
            //else{
               
                //_appDelegate.appConfig.isVisible
                sender.selectedSegmentIndex=SEG_INDEX_TEST;
                [_appDelegate showRegisteAlert];
            //}
            break;
        case SEG_INDEX_TEST:
            _appDelegate.appConfig.visibility=VISIBILITY_TEST;
            break;
        case SEG_INDEX_OFF:
            _appDelegate.appConfig.visibility=VISIBILITY_NONE;
            break;
        
    }

}
/*
- (void)toggleLive:(BOOL)isLive {
    
    
    
    if(isLive){
        //we make sure it doesnt go live when status <> 2
        if(![self showNeededAction]){
            //[_swLive setOn:NO];
            _visibilityModeField.selectedSegmentIndex=MODE_TEST;
            return;
        }
    }
    
    
    [self.appDelegate.mcManager advertiseSelf:isLive];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_VISIBILTY_MODE_CHANGED object:nil];
    
}
*/

-(void)textViewDidBeginEditing:(UITextView *)textView{
    hasChanged=YES;
}

-(NSString *)labelForDeviceStatus{
    switch(_appDelegate.appConfig.device_status){
        case DEVICE_STATUS_APPROVED:
            return LABEL_APPROVED;
        case DEVICE_STATUS_WAITINGAPPROVAL:
            return LABEL_WAITINGAPPROVAL;
        case DEVICE_STATUS_REGISTERED:
            return LABEL_REGISTERED;
        case DEVICE_STATUS_CANCELLED:
            return LABEL_CANCELLED;
        case DEVICE_STATUS_DELETED:
            return LABEL_DELETED;
        default:
            return LABEL_UNKNOWN;
            
    }
}

@end
