//
//  ConnectionsViewController.m

//

#import "ConnectionsViewController.h"

#import "AppSettingsViewController.h"
#import "AppConfigModel.h"
#import "PeerInfo.h"
//#import "FirstViewController.h"
#import "OrderHistory.h"
//#import "RWEmailManager.h"
#import "RNEncryptor.h"
#import "RNDecryptor.h"

#import "BroadcastMessageAPI.h"
//#import "InventoryModel.h"
//#import "InventoryItem.h"
//#import "SoundController.h"
//#import "AFNetworking.h"

#import "LoginViewController.h"

#import "WebViewController.h"
//#import "RNEncryptor.h"
//#import "RNDecryptor.h"
//#import "NSData+Conversion.h"
#import "defs.h"
#import "defs_order_product.h"

//#import "BrowserViewController.h"
//#import "RWStripeViewController.h"
#import "UsersViewController.h"

#import "CheckoutCart.h"



@interface ConnectionsViewController (){
    // MyBrowserViewController *browser;
    NSMutableArray *connectedDevices;
    NSMutableArray *timers;
   // UIBarButtonItem *settingsButton;
   // UIBarButtonItem *registerButton;
    //UIBarButtonItem *lockButton;
    BOOL registerLater;
    UIBarButtonItem *_usersButtonItem;
    //UIAlertView *registerAlert;
    //InventoryItem *_selectedInventory;
    
}

@property (nonatomic, strong) AppDelegate *appDelegate;
//@property (nonatomic, strong) NSString *documentsDirectory;

//@property (strong, nonatomic) SoundController *soundController;
@property (nonatomic, strong) PeerInfo *selectedPeer;

#pragma mark -HTTP client
//@property (nonatomic,strong) AFHTTPClient *client;

//-(void)peerDidChangeStateWithNotification:(NSNotification *)notification;

@end

@implementation ConnectionsViewController
//@synthesize audioSwitch, gainValueLabel, audioProcessor;
/*
 + (ConnectionsViewController *)sharedInstance {
 static ConnectionsViewController*  _sharedConnectionController;
 
 static dispatch_once_t once;
 dispatch_once(&once, ^{
 _sharedConnectionController = [[ConnectionsViewController alloc] init];
 
 
 });
 
 return _sharedConnectionController;
 }
 */
- (instancetype)init
{
    self = [super init];
    if (self) {
        /*
         [self configureAudioSession];
         [self configureAudioPlayer];
         [self configureSystemSound];
         */
        //SoundController *snd=[SoundController sharedInstance];
    }
    return self;
}
/*
 - (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
 {
 self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
 if (self) {
 // Custom initialization
 }
 return self;
 }
 */



- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor clearColor];
    // Do any additional setup after loading the view.
    _appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
   // _selectedInventory=[InventoryModel activeInventory];
    
  //  settingsButton=[[UIBarButtonItem alloc] initWithTitle:@"Settings" style:UIBarButtonItemStyleBordered target:self action:@selector(settingsButtonTapped:)];
    
   // registerButton=[[UIBarButtonItem alloc] initWithTitle:@"Register" style:UIBarButtonItemStyleBordered target:self action:@selector(registerButtonTapped:)];
    
    //lockButton=[[UIBarButtonItem alloc] initWithTitle:@"Lock" style:UIBarButtonItemStyleBordered target:self action:@selector(lockButtonTapped:)];
    
    //self.navigationItem.leftBarButtonItem=lockButton;
    //[self enableNotifications];
    //text
    
    _usersButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"Users" style:UIBarButtonItemStyleBordered target:self action:@selector(usersButtonTapped:)];
    
    self.navigationItem.rightBarButtonItem=_usersButtonItem;

    
    self.title=@"Connections";
    
    
    //NSSortDescriptor *sort=[NSSortDescriptor sortDescriptorWithKey:@"" ascending:<#(BOOL)#>]
   
    
    
    [_tblConnectedDevices setDataSource:self];
    
    // self.soundController =[SoundController sharedInstance]; //[[SoudnController alloc] init];
    //[self.soundController tryPlayMusic];
    
    
    
    
    if(!_appDelegate.appConfig.device_name){
        [self showSettings];
    }
    /*else
        [self.tabBarController setSelectedIndex:TAB_INDEX_MENU];
    */
   /* [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didFinishDownloadUpdate:)
                                                 name:NOTIFY_DIDFINISHDOWNLOAD_UPDATE
                                               object:nil];
    */
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didReceivedReloadViewController)
                                                 name:NOTIFY_RELOAD_CONNECTION_VIEWCONTROLLER
                                               object:nil];
/*
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receivedAppConfigUpdate:)
                                                 name:NOTIFY_APPCONFIG_UPDATE
                                               object:nil];
    */
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadConnectedDevices) name:NOTIFY_VISIBILTY_MODE_CHANGED object:nil];
    
}

- (IBAction)usersButtonTapped:(id)sender{
    
    UsersViewController *vc=[_appDelegate.storyBoard instantiateViewControllerWithIdentifier:@"UsersViewController"];
    //vc.delegate=self;
    
    
    UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:vc];
    
    if(_appDelegate.isIpad){
        //if(_popOver==nil){
        
        
        _popOver=[[UIPopoverController alloc] initWithContentViewController:nav];
        //_chatPopover.popoverContentSize=CGSizeMake(self.view.frame.size.width/2, self.view.frame.size.height);
        _popOver.popoverContentSize=CGSizeMake(200.0, self.view.frame.size.height);
        [_popOver presentPopoverFromBarButtonItem:_usersButtonItem permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        //[_popOver presentPopoverFromRect:CGRectMake(_searchTextField.frame.origin.x, _searchTextField.frame.origin.y, _searchTextField.frame.size.width, _searchTextField.frame.size.height) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        /*}
         else{
         [_popOver dismissPopoverAnimated:YES];
         _popOver=nil;
         }
         */
    }
    else{
        //[self performSegueWithIdentifier:@"toMenuSearchViewController" sender:self];
        [self presentViewController:nav animated:YES completion:nil];
    }
}

-(IBAction)settingsButtonTapped:(id)sender{
    [self showSettings];
}

-(void)showSettings{
   AppSettingsViewController* settingsController = (AppSettingsViewController*) [ApplicationDelegate.storyBoard instantiateViewControllerWithIdentifier:@"AppSettingsViewController"];
    UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:settingsController];
    
   
    
    [self presentViewController:nav animated:YES completion:nil];
    
   // [self performSegueWithIdentifier:NOTIFY_SHOW_SETTINGS sender:self];
}

/*
-(IBAction)registerButtonTapped:(id)sender{
    [self showRegisterDevice];
}
*/
//-(IBAction)lockButtonTapped:(id)sender{
//    /*UIAlertView *alert;
//     if(_appDelegate.appConfig.user_pin.length==0){
//     alert=[[UIAlertView alloc] initWithTitle:@"PIN is not set" message:@"Enter new PIN" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Set PIN", nil];
//     alert.alertViewStyle = UIAlertViewStylePlainTextInput;
//     }
//     else{
//     alert=[[UIAlertView alloc] initWithTitle:@"Device Locked" message:@"Enter PIN" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Unlock", nil];
//     alert.alertViewStyle = UIAlertViewStylePlainTextInput;
//     }
//     _appDelegate.appConfig.user_usepin=YES;
//     [AppConfigModel saveSettings];
//     [alert show];
//     */
//    [_appDelegate lockDevice];
//}

/*
-(void)updateDisplay{
    self.lblName.text=_appDelegate.appConfig.device_name;    if(_appDelegate.appConfig.isLive){
        
        
        if(_appDelegate.appConfig.isVisible)
            [self.lblStatus setText:LABEL_LIVE];
        else
            [self.lblStatus setText:[NSString stringWithFormat:@"%@. %@",LABEL_LIVE,LABEL_NOTVISIBLE]];
    }
    else
    {
        //self.lblStatus.text=LABEL_NOTREGISTERED;
        if(_appDelegate.appConfig.isVisible)
            [self.lblStatus setText:LABEL_TEST];
        else
            [self.lblStatus setText:[NSString stringWithFormat:@"%@. %@",LABEL_TEST,LABEL_NOTVISIBLE]];
    }
    
    //NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *filePath=[[AppDelegate getDocumentsPath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@%@.png",PREFIX_MYPHOTO, _appDelegate.appConfig.device_id]];
    if([[NSFileManager defaultManager] fileExistsAtPath:filePath])
        [_myPhoto setImage:[[UIImage alloc] initWithContentsOfFile:filePath]];
    //image=[[UIImage alloc] initWithContentsOfFile:filePath];
    
    //_myPhoto.image=[UIImage imageNamed:@"myphoto.png" ];
    //if(_myPhoto.image==nil)
    else
        _myPhoto.image=[UIImage imageNamed:@"person"];
    
    //rounded image
    _myPhoto.layer.cornerRadius=_myPhoto.frame.size.width / 2;
    _myPhoto.clipsToBounds = YES;
    
    
}
*/
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    /*
    if(_appDelegate.appConfig.isLive)
        [_swLive setOn:YES];
    else
        [_swLive setOn:NO];
    
    
    [self updateDisplay];
    */
    //load map from web
    /*
     UIActivityIndicatorView *activityView=[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
     
     
     CGRect screenRect=[[UIScreen mainScreen] bounds];
     
     activityView.center=CGPointMake(screenRect.size.width/2.0, screenRect.size
     .height/2.0);
     [activityView startAnimating];
     activityView.tag=100;
     
     [self.view addSubview:activityView];
     
     NSURL *urll=[NSURL URLWithString:self.url];
     NSURLRequest *req=[NSURLRequest requestWithURL:urll];
     self.webView.delegate=self;
     [self.webView loadRequest:req];
     */
    //if(_appDelegate.appConfig.user_usepin){
    //    [self lockButtonTapped:self];
    //}
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

/*
 - (void)postRegisterDeviceRequest
 {
 
 if(!_appDelegate.userInfo.userToken || !_appDelegate.userInfo.deviceID)
 return;
 
 NSString *devicename=[self.nickNameTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" "]];
 
 if(!devicename)
 return;
 
 NSString *address=[self.addressTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" "]];
 
 if(!address)
 return;
 
 
 MBProgressHUD* hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
 hud.labelText = NSLocalizedString(@"Loading", nil);
 
 NSString *info=[NSString stringWithFormat:@"usertoken=%@&deviceid=%@&devicename=%@&address=%@",_appDelegate.userInfo.userToken,_appDelegate.userInfo.deviceID,devicename,address];
 
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
 }
 */

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSString *title=[alertView buttonTitleAtIndex:buttonIndex];
    
    if([title isEqualToString:@"Register"]){
        registerLater=NO;
        [self showRegisterDevice];
    }
    /*else if([title isEqualToString:@"Unlock"]){
     UITextField * alertTextField = [alertView textFieldAtIndex:0];
     if(alertTextField.text.length>0){
     if ([alertTextField.text isEqualToString:_appDelegate.appConfig.user_pin] || [alertTextField.text isEqualToString:_appDelegate.appConfig.user_password]) {
     
     if([alertTextField.text isEqualToString:_appDelegate.appConfig.user_password]){
     _appDelegate.appConfig.user_pin=nil;
     }
     
     _appDelegate.appConfig.user_usepin=NO;
     [AppConfigModel saveSettings];
     return;
     }
     
     }
     [self lockButtonTapped:self];
     
     }
     else if([title isEqualToString:@"Set PIN"]){
     UITextField * alertTextField = [alertView textFieldAtIndex:0];
     if(alertTextField.text.length>0){
     _appDelegate.appConfig.user_pin=[alertTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" "]];
     _appDelegate.appConfig.user_usepin=YES;
     [AppConfigModel saveSettings];
     [self lockButtonTapped:self];
     
     }
     }*/
    else{
        registerLater=YES;
        
    }
}

/*
 -(void)didFinishReceivingResourceWithNotification:(NSNotification *)notification{
 [_tblConnectedDevices performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
 }
 */
/*
-(void)imageTapped{
    UIImagePickerController *picker=[[UIImagePickerController alloc] init];
    picker.modalPresentationStyle=UIModalPresentationCurrentContext;
    picker.delegate=self;
    picker.allowsEditing=YES;
    picker.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:picker animated:YES
                     completion:NULL];
}
 */
/*
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    
    if (_appDelegate.appConfig.device_id==nil || _appDelegate.appConfig.device_id.length<36) {
        return;
    }
    NSString *myphoto=[NSString stringWithFormat:@"myphoto-%@.png",_appDelegate.appConfig.device_id];
    
    UIImage *chosenImage=info[UIImagePickerControllerEditedImage];
    //create path
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *filePath=[[paths objectAtIndex:0] stringByAppendingPathComponent:myphoto];
    //save image
    [UIImagePNGRepresentation(chosenImage) writeToFile:filePath atomically:YES];
    
    [_myPhoto setImage:chosenImage];
    [picker dismissViewControllerAnimated:YES completion:nil];
}
*/
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UITextField Delegate method implementation

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    /* [_txtName resignFirstResponder];
     
     _appDelegate.mcManager.peerID = nil;
     _appDelegate.mcManager.session = nil;
     _appDelegate.mcManager.browser = nil;
     
     if ([_swVisible isOn]) {
     [_appDelegate.mcManager.advertiser stopAdvertisingPeer];
     }
     _appDelegate.mcManager.advertiser = nil;
     
     
     //[_appDelegate.mcManager setupPeerAndSessionWithDisplayName:_txtName.text];
     _appDelegate.mcManager = [[MCManager alloc] initWithUserInfo:_appDelegate.userInfo];
     
     [_appDelegate.mcManager setupMCBrowser];
     [_appDelegate.mcManager advertiseSelf:_swVisible.isOn];
     */
    return YES;
}


#pragma mark - Public method implementation
/*
 - (IBAction)browseForDevices:(id)sender {
 [[_appDelegate mcManager] setupMCBrowser];
 MyBrowserViewController* browser = (MyBrowserViewController*) [ApplicationDelegate.storyBoard instantiateViewControllerWithIdentifier:@"MyBrowserViewController"];
 browser.delegate = self;
 
 [self presentViewController:browser animated:YES completion:nil];
 }
 */
/*
- (IBAction)toggleLive:(id)sender {
    
    
    
    if(_swLive.isOn){
        //we make sure it doesnt go live when status <> 2
        if(![self isValidAccount]){
            [_swLive setOn:NO];
           return;
        }
    }
    
        
    [self.appDelegate.mcManager advertiseSelf:_swLive.isOn];
    
    [self reloadConnectedDevices];
        [self.tblConnectedDevices reloadData];
        
    
    NSString *modeLabel;
    
    if(_appDelegate.appConfig.isLive){
        modeLabel=LABEL_LIVE;
    }
    else
    {
        modeLabel=LABEL_TEST;
    }
        
    NSString *visibilityLabel=@"";
    if(!_appDelegate.appConfig.isVisible){
        visibilityLabel=LABEL_NOTVISIBLE;
    }
    
    [_lblStatus setText:[NSString stringWithFormat:@"%@. %@",modeLabel,visibilityLabel]];
    
}
*/
/*
-(void)advertiseSelf:(BOOL)islive{
    [self.appDelegate.mcManager advertiseSelf:YES isLive:islive];
    if(_appDelegate.appConfig.isLive){
        if(_appDelegate.appConfig.isVisible)
            [self.lblStatus setText:LABEL_LIVE];
        else
            [self.lblStatus setText:[NSString stringWithFormat:@"%@. %@",LABEL_LIVE,LABEL_NOTVISIBLE]];
    }
    else{
        if(_appDelegate.appConfig.isVisible)
            [self.lblStatus setText:LABEL_TEST];
        else
            [self.lblStatus setText:[NSString stringWithFormat:@"%@. %@",LABEL_TEST,LABEL_NOTVISIBLE]];
    }
}
 */

- (IBAction)disconnect:(id)sender {
    //TODO
    /*[_appDelegate.mcManager.session disconnect];
     
     _txtName.enabled = YES;
     
     [_appDelegate.mcManager.peerDevices removeAllObjects];
     [_tblConnectedDevices reloadData];
     */
   
}


#pragma mark - MCBrowserViewControllerDelegate method implementation
/*
 -(void)browserViewControllerDidFinish:(MCBrowserViewController *)browserViewController{
 [_appDelegate.mcManager.browser dismissViewControllerAnimated:YES completion:nil];
 }
 
 
 -(void)browserViewControllerWasCancelled:(MCBrowserViewController *)browserViewController{
 [_appDelegate.mcManager.browser dismissViewControllerAnimated:YES completion:nil];
 }
 */
/*
 -(BOOL)browserViewController:(MCBrowserViewController *)browserViewController shouldPresentNearbyPeer:(MCPeerID *)peerID withDiscoveryInfo:(NSDictionary *)info{
 return YES;
 }
 
 
 -(void)browserViewControllerDidFinish:(MyBrowserViewController *)browserViewController{
 [browserViewController dismissViewControllerAnimated:YES completion:nil];
 }
 
 
 -(void)browserViewControllerWasCancelled:(MyBrowserViewController *)browserViewController{
 [browserViewController dismissViewControllerAnimated:YES completion:nil];
 }
 
 -(void)browserViewControllerDidFinishConnected:(MyBrowserViewController *)browserViewController{
 
 PeerInfo *selectedPeer=browserViewController.selectedPeer;
 
 if(selectedPeer==nil)
 return;
 
 [browserViewController dismissViewControllerAnimated:YES completion:^{
 
 [self.tabBarController setSelectedIndex:TAB_INDEX_CHAT];
 }];
 
 }
 */

#pragma mark - Private method implementation

-(void)peerDidChangeStateUpdate:(NSNotification *)notification{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        /*NSDictionary *dict = @{@"peerInfo": peerInfo,
         @"state" : [NSNumber numberWithInt:state]
         };
         */
        //long state=[[notification.userInfo valueForKey:@"state"] integerValue];
       // PeerInfo *peer=[notification.userInfo valueForKey:@"peerInfo"];
        
       /* if(state==MCSessionStateConnected){
            [self updatePeersDisplay:peer isConnected:YES];
            
            [self downloadPeerPhoto:peer];
            
        }
        else if(state==MCSessionStateNotConnected){
            
            [self updatePeersDisplay:peer isConnected:NO];
            
        }
        */
#ifdef DEBUG
        NSLog(@"Received: peerDidChangeStateWithNotification");
#endif
        //dispatch_async(dispatch_get_main_queue(), ^{
        [self reloadConnectedDevices];
        [_tblConnectedDevices reloadData];
        
        
        
        //});
        
    });
}



#pragma mark - UITableView Delegate and Datasource method implementation

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(void)reloadConnectedDevices{
  
    
    UITabBarItem *tbi=(UITabBarItem *)[self.tabBarController.tabBar.items objectAtIndex:TAB_INDEX_CONNECT];
    if([_appDelegate.mcManager.peerDevices count]==0)
        tbi.badgeValue=nil;
    else
        tbi.badgeValue=[NSString stringWithFormat:@"%lu",(unsigned long)[_appDelegate.mcManager.peerDevices count]];
    [self.tblConnectedDevices reloadData];
}

-(NSInteger)tableView__:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [connectedDevices count];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_appDelegate.mcManager.peerDevices count];
    
}



-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CnnCellIdentifier"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CnnCellIdentifier"];
    }
    
    
    PeerInfo *peerInfo= [_appDelegate.mcManager.peerDevices objectAtIndex:indexPath.row];
    /*if([_appDelegate.mcManager.peerDevices containsObject:peerInfo])
     cell.textLabel.text =[NSString stringWithFormat:@"%@ Connected",peerInfo.peerID.displayName];
     else*/
    cell.textLabel.text =peerInfo.peerName;//.peerID.displayName;
    if(peerInfo.sessionState==MCSessionStateConnected){
        cell.detailTextLabel.text=@"Connected";//peerInfo.deviceToken;
        
        NSString *peer_photo=[NSString stringWithFormat:@"myphoto-%@.png",peerInfo.deviceID];
        //NSString *peer_bgphoto=[NSString stringWithFormat:@"bgphoto-%@.png",peerInfo.deviceID];
        
        NSString *filePath=[[AppDelegate getImagesPath] stringByAppendingPathComponent:peer_photo];
        
        //check if cached
        if([[NSFileManager defaultManager] fileExistsAtPath:filePath]){
            cell.imageView.image=[[UIImage alloc] initWithContentsOfFile:filePath];
        }
        else{
            [_appDelegate.cnnManager downloadPeerPhoto:peerInfo];
        }
        
        
    }
    else if(peerInfo.sessionState==MCSessionStateConnecting)
        cell.detailTextLabel.text=@"Connecting...";
    else
        //cell.detailTextLabel.text=@"Not Connected. Tap to connect.";
        cell.detailTextLabel.text=@"Not Connected.";
    
    
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    _selectedPeer = [_appDelegate.mcManager.peerDevices objectAtIndex:indexPath.row];
    
    if(_selectedPeer==nil)
        return;
    
    if(_selectedPeer.sessionState!=MCSessionStateConnected)
        return;
    
    /*_selectedPeer.peerID.
     [_appDelegate.mcManager.session disconnect];
     
     _txtName.enabled = YES;
     
     [_appDelegate.mcManager.peerDevices removeAllObjects];
     [_tblConnectedDevices reloadData];
     
     
     // [_selectedPeer.peerID s]
     //_selectedPeer.sessionState=MCSessionStateConnecting;
     //NSString *photUrl=@"";
     NSArray *objects=[[NSArray alloc] initWithObjects:_appDelegate.userInfo.deviceID,_appDelegate.userInfo.homeUrl, nil];
     
     NSArray *keys=[[NSArray alloc] initWithObjects:@"deviceID",@"homeurl", nil];
     NSDictionary *context=[[NSDictionary alloc] initWithObjects:objects forKeys:keys];
     
     // [context ]
     [_appDelegate.mcManager.browser invitePeer:_selectedPeer.peerID toSession:_appDelegate.mcManager.session withContext:[NSKeyedArchiver archivedDataWithRootObject:context] timeout:60.0 ];
     _appDelegate.mcManager.serverPeerInfo=_selectedPeer;
     
     [tableView reloadData];
     */
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60.0;
}


//NSDictionary *menu_dict=[_inventoryModel toMenuDictionary];

//this is called only when toggle is set to LIVE
/*
-(BOOL)isValidAccount{
    
    
    if(_appDelegate.appConfig.device_status==DEVICE_STATUS_LIVE)
        return YES;
    
    
    
    if(_appDelegate.appConfig.device_status==DEVICE_STATUS_REGISTERED ){
        
        registerAlert=[[UIAlertView alloc] initWithTitle:nil message:@"Please complete device registration to go LIVE. Complete registration now?" delegate:self cancelButtonTitle:@"Later" otherButtonTitles:@"Register", nil];
        [registerAlert show];
    }
    else if(_appDelegate.appConfig.device_status==DEVICE_STATUS_CANCELLED ){
        
        
        
        registerAlert=[[UIAlertView alloc] initWithTitle:nil message:@"Account is CANCELLED. Please email accountservices@sharecle.com" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [registerAlert show];
    }
    else if(_appDelegate.appConfig.device_status==DEVICE_STATUS_NOTREGISTERED ){
        
        
        registerAlert=[[UIAlertView alloc] initWithTitle:nil message:@"Account is NOT REGISTRED. Please email accountservices@sharecle.com" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [registerAlert show];
    }
    else{
        registerAlert=[[UIAlertView alloc] initWithTitle:nil message:@"Account is in UNKNOWN STATE. Please email gotkiosk@sharecle.com about this problem." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [registerAlert show];
        
    }
    
    return NO;
    
}
*/
-(void)didReceivedReloadViewController{
    [self.tblConnectedDevices reloadData];
}
/*
-(void)receivedAppConfigUpdate:(NSNotification *)notification{
    [AppConfigModel saveSettings];
    //[self updateDisplay];
}
*/
#pragma mark -
#pragma mark printing
//- (IBAction)print:(id)sender {
- (void)print:(id)sender {
    //if ([UIPrintInteractionController canPrintURL:self.imageURL]) {
        UIPrintInfo *printInfo = [UIPrintInfo printInfo];
       // printInfo.jobName = self.imageURL.lastPathComponent;
        printInfo.outputType = UIPrintInfoOutputGeneral;
    
    /*
    UIPrintInfo *printInfo = ...
    UISimpleTextPrintFormatter *formatter = ...
    
    NSArray *activityItems = @[printInfo, formatter, self.textView.attributedText];
    UIActivityViewController *activityController = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
    [self presentViewController:activityController animated:YES completion:nil];
    */
    
    
        UIPrintInteractionController *printController = [UIPrintInteractionController sharedPrintController];
        printController.printInfo = printInfo;
        
      //  printController.printingItem = self.imageURL;
        
        [printController presentAnimated:true completionHandler: nil];
   // }
}//

@end
