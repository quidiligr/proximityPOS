//
//  ConnectionsViewController.m


#import "ConnectionsViewController.h"
#import "AppDelegate.h"
#import "PeerInfo.h"
//#import "FirstViewController.h"
#import "OrderHistory.h"
#import "AppSettingsViewController.h"
//#import "Map2ViewController.h"
#import "AudioProcessor.h"
#import "CAudioBuffer.h"
#import "BroadcastMessageAPI.h"
#import "InventoryModel.h"
//#import "SoundController.h"
#import "RNDecryptor.h"
#import "RNEncryptor.h"
//#import "SpeechBubbleView.h"
#import "defs.h"
#import "defs_order_product.h"
//#import "BrowserViewController.h"
//#import "RWStripeViewController.h"
#import <AudioToolbox/AudioToolbox.h>
#import "CheckoutCart.h"
#import "MapViewController.h"
#import "MBProgressHUD.h"
#import "ConnectionManager.h"
#import <LocalAuthentication/LocalAuthentication.h>
#import "Util.h"


@interface ConnectionsViewController (){
   // MyBrowserViewController *browser;
    //NSMutableArray *connectedDevices;
    MCNearbyServiceBrowser *browser;
    BOOL bannerIsVisible;
   // UISwitch *toggleLive;
   // UIBarButtonItem *toggleLiveButtonItem;
    NSTimer *browseTimer;
    BOOL browseStarted;
    // UIBarButtonItem *settingsButton;
    //UIBarButtonItem *locationsButton;
    
    //ConnectionManager *_connectionManager;
    //HistoryModel *_historyModel;
    NSMutableArray *_stores; //from history
    //NSMutableArray *connectedItems;
    NSMutableArray *nearItems;
    NSMutableArray *farItems;
    
    NSTimer *scanTimer;
    //PeerInfo *connectToPeerInfo;
    
   // UIBarButtonItem *loginButtonItem;
    NSInteger selectedAuthType;
    StoreHistory *store_selected;
    
    UIBarButtonItem *_menuButtonItem;
    
    UIActionSheet *_menuActionSheet;
    
}

@property (nonatomic, strong) AppDelegate *appDelegate;
@property (nonatomic, strong) NSString *documentsDirectory;

//@property (strong, nonatomic) SoundController *soundController;

//@property (nonatomic, strong) PeerInfo *selectedPeer;
@property (strong, nonatomic) IBOutlet UILabel *chooseLabel;

//@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (strong, nonatomic) IBOutlet UISwitch *toggleLive;

//@property (strong, nonatomic) IBOutlet UIWebView *mapWebView;
//@property (strong, nonatomic) IBOutlet UIView *mapView;
//@property (strong, nonatomic) IBOutlet ADBannerView *banner1;

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
    
    _appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    nearItems=[NSMutableArray new];
    farItems=[NSMutableArray new];
    
    _locationsButtonItem=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"NearMe"] style:UIBarButtonItemStyleBordered target:self action:@selector(locationsButtonTapped:)];
    /*
    _settingsButtonItem=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"settings"] style:UIBarButtonItemStyleBordered target:self action:@selector(settingsButtonTapped:)];
    
    _loginButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"Login" style:UIBarButtonItemStylePlain target:self action:@selector(loginButtonTapped:)];
    */

    _menuButtonItem=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Menu"] style:UIBarButtonItemStyleBordered target:self action:@selector(showMenuActionSheet)];
    
    self.navigationItem.rightBarButtonItem=_menuButtonItem;

    
    
    //self.navigationItem.rightBarButtonItems=@[_locationsButtonItem,_settingsButtonItem];
    self.navigationItem.leftBarButtonItem=_locationsButtonItem;//_loginButtonItem;
    
    [self.nearbyIndicator setHidesWhenStopped:YES];

    #ifdef ENABLE_IAD
    if ([self respondsToSelector:@selector(setCanDisplayBannerAds:)]) {

        self.canDisplayBannerAds=YES;
    }
#endif
    
    if(_appDelegate.mcManager.browser==nil){
        [[_appDelegate mcManager] setupMCBrowser];
        _appDelegate.mcManager.browser.delegate=self;
    }
    
    /*
    [_appDelegate.mcManager.browser startBrowsingForPeers];
    [self.nearbyIndicator startAnimating];
*/
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didReceiveDataWithNotification:)
                                                 name:NOTIFY_RECEIVE_TEXT_DATA
                                               object:nil];
    
 
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(hasDataToSendWithNotification:)
                                                 name:NOTIFY_HAS_DATA_TO_SEND
                                               object:nil];

    //voice
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didReceiveVoiceDataWithNotification:)
                                                 name:@"MCDidReceiveVoiceDataNotification"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveMicInputNotification:) name:@"DidReceiveMicInputNotification" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveAudioSwitchNotification:) name:@"DidReceiveAudioSwitchNotification" object:nil];
    
        //[self reloadConnectedDevices];

    //file download/upload
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didStartReceivingResourceWithNotification:)
                                                 name:@"MCDidStartReceivingResourceNotification"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateReceivingProgressWithNotification:)
                                                 name:@"MCReceivingProgressNotification"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didFinishReceivingResourceWithNotification:)
                                                 name:didFinishReceivingResourceNotificationKey
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didReceivedNewOrderNotification:)
                                                 name:NOTIFY_NEW_ORDER
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(peerDidChangeStateWithNotification:)
                                                 name:NOTIFY_MCDIDCHANGESTATE
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didLostPeerNotification:)
                                                 name:NOTIFY_BROWSERLOSTPEER
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didFinishReceivingResourceWithNotification:)
                                                 name:@"didFinishReceivingResourceNotificationForPeerPhoto"
                                               object:nil];
    
    
    //_arrConnectedDevices = [[NSMutableArray alloc] init];
    
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    
   // self.soundController =[SoundController sharedInstance]; //[[SoudnController alloc] init];
    //[self.soundController tryPlayMusic];
    
    
    //map
    /*
    UIActivityIndicatorView *activityView=[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    
    CGRect screenRect=[self.mapView bounds];//[[UIScreen mainScreen] bounds];
    
    activityView.center=CGPointMake(screenRect.size.width/2.0, screenRect.size
                                    .height/2.0);
    [activityView startAnimating];
    activityView.tag=100;
    
    [self.mapView addSubview:activityView];
    NSString *mapUrl;
    if(_appDelegate.appConfig.isLive)
        mapUrl=MAP_LIVE_URL;
    else
        mapUrl=MAP_TEST_URL;
    NSURL *urll=[NSURL URLWithString:mapUrl];
    NSURLRequest *req=[NSURLRequest requestWithURL:urll];
    self.mapWebView.delegate=self;
    [self.mapWebView loadRequest:req];
*/
   // [self initBrowsing];


}



-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    
    /*
   if(browseTimer==nil)
   {
       browseStarted=YES;
       
       [self.nearbyIndicator startAnimating];
       [_appDelegate.mcManager.browser startBrowsingForPeers];
       
      browseTimer=[NSTimer scheduledTimerWithTimeInterval:10.0 target:self selector:@selector(onStartStopBrowser:) userInfo:nil repeats:YES];
   }
     */
    
   // [_appDelegate.mcManager.browser startBrowsingForPeers];
    
   // [self.nearbyIndicator startAnimating];
    
    if(_appDelegate.isIpad)
        self.title=@"Super Kiosk";
    else
        self.title=@"SK";
    
    
    if(_appDelegate.appConfig.isLive){
        [_toggleLive setOn:YES];
        _chooseLabel.text=@"Choose a LIVE Kiosk...";
    }
    else{
        _chooseLabel.text=@"Choose a TEST Kiosk...";
        [_toggleLive setOn:NO];
    }
    
    [self reloadData];
    
    [self startTimer];

}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self stopTimer];
    /*
    [browseTimer invalidate];
    browseTimer=nil;
    browseStarted=NO;
    
    [self.nearbyIndicator stopAnimating];
    */
     [_appDelegate.mcManager.browser stopBrowsingForPeers];
}
-(void)initBrowsing__{
    [_appDelegate.mcManager.browser startBrowsingForPeers];
    /*
    if(browseTimer ==nil){
        browseTimer=[NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(startBrowsing) userInfo:nil repeats:YES];
    }
    else{
        if(![browseTimer isValid]){
            browseTimer=[NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(startBrowsing) userInfo:nil repeats:YES];
            
        }
    }
     */
}
//-(void)startBrowsing__{
////    if(_appDelegate.mcManager.browser stopBrowsingForPeers
//  //  [_appDelegate.mcManager.browser startBrowsingForPeers];
//    if (!browseStarted) {
//        browseStarted=YES;
//         //[_appDelegate.mcManager.browser startBrowsingForPeers];
//        [self.nearbyIndicator startAnimating];
//    }
//    else{
//        browseStarted=NO;
//        // [_appDelegate.mcManager.browser stopBrowsingForPeers];
//        [self.nearbyIndicator stopAnimating];
//        
//    }
//}
//
//-(void)stopBrowsing__{
//    [browseTimer invalidate];
//    [self.nearbyIndicator stopAnimating];
//    //[_appDelegate.mcManager.browser stopBrowsingForPeers];
//
//}

-(void)imageTapped{
    UIImagePickerController *picker=[[UIImagePickerController alloc] init];
    picker.delegate=self;
    picker.allowsEditing=YES;
    picker.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:picker animated:YES
                     completion:NULL];
}
/*
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    
    if (_appDelegate.appConfig.userInfo.deviceID==nil || _appDelegate.appConfig.userInfo.deviceID.length<36) {
        return;
    }
    NSString *myphoto=[NSString stringWithFormat:@"myphoto-%@.png",_appDelegate.appConfig.userInfo.deviceID];
    
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
/*
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [_txtName resignFirstResponder];
 
    return YES;
}
*/

#pragma mark - Public method implementation

- (IBAction)browseForDevices:(id)sender {
    /*[[_appDelegate mcManager] setupMCBrowser];
    
    MyBrowserViewController* browser = (MyBrowserViewController*) [ApplicationDelegate.storyBoard instantiateViewControllerWithIdentifier:@"MyBrowserViewController"];
    browser.delegate = self;
   
    [self presentViewController:browser animated:YES completion:nil];
     */
}


- (IBAction)toggleVisibility:(id)sender {
    //[_appDelegate.mcManager advertiseSelf:_swVisible.isOn];
}


- (IBAction)disconnect:(id)sender {
#ifdef DEBUG
    NSLog(@"disconnect called");
#endif
    [_appDelegate.mcManager.session disconnect];
    
   // _txtName.enabled = YES;
   // _appDelegate.mcManager.serverPeerInfo=nil;
    //[_appDelegate.mcManager.peerDevices removeAllObjects];
    //[_tblConnectedDevices reloadData];
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
*/

-(void)browserViewControllerDidFinish:(MyBrowserViewController *)browserViewController{
    [browserViewController dismissViewControllerAnimated:YES completion:nil];
}


-(void)browserViewControllerWasCancelled:(MyBrowserViewController *)browserViewController{
    [browserViewController dismissViewControllerAnimated:YES completion:nil];
}

//-(void)browserViewControllerDidFinishConnected:(MyBrowserViewController *)browserViewController{
//-(void)browserConnected{
//    
//    
//    if(_selectedPeer==nil)
//        return;
//    
//   
//        HistoryModel *historyModel=[HistoryModel sharedInstance];
//        historyModel.filename=_appDelegate.selectedStore.peerInfo.deviceID;
//        
//        [historyModel loadHistory];
//        
//
// 
//    
//        
//        [self.tabBarController setSelectedIndex:TAB_INDEX_CHAT];
//       
//  
//    
//}
//


#pragma mark - UITableView Delegate and Datasource method implementation

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    //if(
    return 2;
    
    
}


/*
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    CGRect frame=tableView.frame;
  
    
    
    
    NSString *text=@"Searching nearby...   ";
    
    
    CGRect textRect = [text boundingRectWithSize:CGSizeMake(frame.size.width, 9999)
                                         options:NSStringDrawingUsesLineFragmentOrigin
                                      attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]}
                                         context:nil];
    CGSize textSize =textRect.size;
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, textSize.height)];
    
   
     UILabel *searchingLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, textSize.width, textSize.height)];
   
    searchingLabel.text=text;
   
    [headerView addSubview:searchingLabel];
    
    UIActivityIndicatorView *activityIndicator =
    [[UIActivityIndicatorView alloc]
     initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    CGRect activityFrame=activityIndicator.frame;
    activityFrame.origin.x=searchingLabel.frame.origin.x+searchingLabel.frame.size.width;
    activityFrame.origin.y=searchingLabel.frame.origin.y;
    activityIndicator.frame=activityFrame;
    
    [activityIndicator startAnimating];
    [headerView addSubview:activityIndicator];
    
     
    return headerView;
}
*/



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSUInteger count=0;
    
    if(section==0){
        count=[nearItems count];//[_appDelegate.mcManager.peerDevices count];
    }
    
    else if(section==1){
        count=[farItems count];
    }
    
    
    return count;
    
}


-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if(section==0){
        return @"Near me";
        
    }
    else if(section==1){
        return @"History";
    }
    //else if(section==2){
    //    return @" ";
   // }
    
    return @" ";
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CnnCellIdentifier"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CnnCellIdentifier"];
    }
    StoreHistory *store;
   
    if(indexPath.section==0)
        store= [nearItems objectAtIndex:indexPath.row];
    else
        store= [farItems objectAtIndex:indexPath.row];
    
    
    //cell.textLabel.text =[NSString stringWithFormat:@"%@ %@", store.storeName, @(store.storeNum)] ;
    cell.textLabel.text =[NSString stringWithFormat:@"%@", store.storeName] ;
    if(store.device_address!=nil && store.device_address.length>0){
        cell.detailTextLabel.text=store.device_address;
    }
    //else{
    //    cell.detailTextLabel.text=@"Near me";
    //}
    if(indexPath.section==0){
        
        if(store.peerInfo.sessionState==MCSessionStateConnected){ //NOTE: we shouldnt get this
            cell.detailTextLabel.text=@"Connected";//peerInfo.deviceToken;
            cell.accessoryType=UITableViewCellAccessoryCheckmark;
        }
        else if(store.peerInfo.sessionState==MCSessionStateConnecting){
            cell.detailTextLabel.text=@"Connecting...";
            cell.accessoryType=UITableViewCellAccessoryNone;
        }
        else{
            cell.detailTextLabel.text=store.device_address;//@"Not Connected. Tap to connect.";
            //cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
            cell.accessoryType=UITableViewCellAccessoryNone;
            
        }
    }
    else{
        cell.detailTextLabel.text=store.device_address;///@"Out of range. Tap to see cached content.";
        //cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        cell.accessoryType=UITableViewCellAccessoryNone;

    }
    
    /*this ok for http connection
     dispatch_async(dispatch_get_main_queue(), ^{
     NSURL *url=[[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@myphoto.png",peerInfo.homeUrl]];
     NSData *imageData=[[NSData alloc] initWithContentsOfURL:url];
     if (imageData!=nil) {
     // UIImage *image=[[UIImage alloc] initWithData:imageData];
     cell.imageView.image=[[UIImage alloc] initWithData:imageData];
     cell.imageView.layer.cornerRadius=cell.imageView.frame.size.width / 2;
     cell.imageView.clipsToBounds = YES;
     
     }
     
     
     });
     */
    /*BT connection. NOTE: In this case this wont work bec theyre not connected yet
     
     //TODO: implement compression
     dispatch_async(dispatch_get_main_queue(), ^{
     NSString *peer_photo=[NSString stringWithFormat:@"myphoto-%@.png",peerInfo.deviceID];
     NSString *serverPath=[NSString stringWithFormat:@"/%@",peer_photo];
     
     //NSLog(@"serverpath=%@",peerInfo.homeUrl);
     NSLog(@"serverpath=%@",serverPath);
     
     NSDictionary *dict = @{KEY_SEND_MESSAGE: serverPath,
     KEY_SEND_MESSAGE_TYPE : MSG_TYPE_REQUEST_FILE_DOWNLOAD
     };
     
     [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_HAS_DATA_TO_SEND
     object:nil
     userInfo:dict];
     
     
     
     });
     */
    
    
    
    
    
    /*
     NSString *filePath=[[AppDelegate getSharedPath] stringByAppendingPathComponent:attached_photo];
     
     
     
     //check if cached
     if([[NSFileManager defaultManager] fileExistsAtPath:filePath]){
     
     //cell.attachImage.image=[[UIImage alloc] initWithContentsOfFile:filePath];
     dispatch_queue_t imageQueue = dispatch_queue_create("Image Attachment Queue",NULL);
     dispatch_async(imageQueue, ^{
     
     
     NSData *imageData=[NSData dataWithContentsOfFile:filePath];
     
     
     if(!imageData) return;
     
     dispatch_async(dispatch_get_main_queue(), ^{
     
     if(imageData){
     [cell.attachImage setImage:[UIImage imageWithData:imageData]];
     cell.attachImage.layer.cornerRadius=cell.attachImage.layer.cornerRadius=cell.senderPhoto.frame.size.width / 4;//cell.senderPhoto.frame.size.width / 2;
     cell.attachImage.clipsToBounds = YES;
     }
     });
     });
     }
     
     */
    
    //check if cached
    [cell.imageView setImage:[UIImage imageNamed:@"empty"]];
    
    
    NSString *peer_photo=[NSString stringWithFormat:@"myphoto-%@.png",store.deviceID];
    //NSString *filePath=[[AppDelegate getImagesPathForServer:store.peerInfo.deviceID] stringByAppendingPathComponent:peer_photo];
    NSString *filePath=[[AppDelegate getImagesPathForServer:store.deviceID] stringByAppendingPathComponent:peer_photo];
    
    
    if([[NSFileManager defaultManager] fileExistsAtPath:filePath]){
        
        NSData *imageData=[NSData dataWithContentsOfFile:filePath];
        //if(cell.imageView && imageData!=nil)
        //{
            [cell.imageView setImage:[UIImage imageWithData:imageData]];
            cell.imageView.layer.cornerRadius=cell.imageView.frame.size.width / 4;//cell.senderPhoto.frame.size.width / 2;
            cell.imageView.clipsToBounds = YES;
        //}
        
    }
    else{
    
        /*
        NSData *imageData=nil;
        NSString *peer_photo=[NSString stringWithFormat:@"myphoto-%@.png",store.deviceID];
        
        NSString *filePath=[[AppDelegate getImagesPathForServer:store.peerInfo.deviceID] stringByAppendingPathComponent:peer_photo];
        
        
            if([[NSFileManager defaultManager] fileExistsAtPath:filePath]){
                
                imageData=[NSData dataWithContentsOfFile:filePath];
                
                
            }
        
            else{
         */
                //if(indexPath.section==0){
                    if(store.peerInfo.sessionState==MCSessionStateConnected){
                        
                        //dispatch_async(dispatch_get_main_queue(), ^{
                        /*this is for http connectivity
                         NSURL *url=[[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@myphoto.png",peerInfo.homeUrl]];
                         NSData *imageData=[[NSData alloc] initWithContentsOfURL:url];
                         if (imageData!=nil) {
                         // UIImage *image=[[UIImage alloc] initWithData:imageData];
                         cell.imageView.image=[[UIImage alloc] initWithData:imageData];
                         cell.imageView.layer.cornerRadius=cell.imageView.frame.size.width / 2;
                         cell.imageView.clipsToBounds = YES;
                         }
                         */
                        
                        //MC connectivity
                        
                         [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didFinishDownload:) name:peer_photo object:nil];
                         NSString *serverPath=[NSString stringWithFormat:@"/%@",peer_photo];
                         
                         BroadcastMessageAPI *message=[[BroadcastMessageAPI alloc] init];
                         message.text=serverPath;
                         message.isBroadcast=NO;
                        message.toPeerInfo=store.peerInfo;//peerInfo;
                         message.message_type=MSG_TYPE_REQUEST_FILE_DOWNLOAD;
                         message.localCopy=NO;
                         
                         [self sendMyMessage:message];
                         
                        
                        //});
                    }
                    else{ //pull from the internet
                        //NOTE!!! this may cause disconnect specially when image is not available
                         
                         //dispatch_queue_t imageQueue = dispatch_queue_create("Image Queue",NULL);
                         //dispatch_async(imageQueue, ^{
                         /*
                          NSURL *url=[[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@myphoto.png",peerInfo.homeUrl]];
                          NSData *imageData=[[NSData alloc] initWithContentsOfURL:url];
                          if (imageData!=nil) {
                          // UIImage *image=[[UIImage alloc] initWithData:imageData];
                          cell.imageView.image=[[UIImage alloc] initWithData:imageData];
                          cell.imageView.layer.cornerRadius=cell.imageView.frame.size.width / 2;
                          cell.imageView.clipsToBounds = YES;
                          }
                          */
                         
                         NSString *urlPath=[NSString stringWithFormat:@"%@%@?deviceID=%@",ServerURL,ServerLogoPath,store.deviceID];
                         
                         //NSURL *url=[[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@myphoto.png",peerInfo.homeUrl]];
                         NSURL *url=[[NSURL alloc] initWithString:urlPath];
                        
                        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                            NSData *imageData = [NSData dataWithContentsOfURL:url];
                            
                            dispatch_async(dispatch_get_main_queue(), ^{
                                // Update the UI
                                //self.imageView.image = [UIImage imageWithData:imageData];
                                if(imageData!=nil){
                                    [imageData writeToFile:filePath atomically:YES];
                                //[[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_UPDATE_INVENTORY object:nil];
                                
                                //[[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_UPDATE_INVENTORY_SETTINGS object:nil userInfo:@{KEY_SELECTED_INVENTORY:_appDelegate.inventoryModel.inventory}];
                                //if(cell.imageView && imageData!=nil)
                                //{
                                    [cell.imageView setImage:[UIImage imageWithData:imageData]];
                                    cell.imageView.layer.cornerRadius=cell.imageView.frame.size.width / 4;//cell.senderPhoto.frame.size.width / 2;
                                    cell.imageView.clipsToBounds = YES;
                                }
                                //}
                            });
                        });
                        
//                         dispatch_async(dispatch_get_main_queue(), ^{
//                         NSData *imageData=[[NSData alloc] initWithContentsOfURL:url];
//                         
//                         /*
//                         if(!imageData) return;
//                         
//                         dispatch_async(dispatch_get_main_queue(), ^{
//                         if(cell.imageView)
//                         {
//                         [cell.imageView setImage:[UIImage imageWithData:imageData]];
//                         cell.imageView.layer.cornerRadius=cell.imageView.frame.size.width / 4;//cell.senderPhoto.frame.size.width / 2;
//                         cell.imageView.clipsToBounds = YES;
//                         }
//                         });
//                          */
//                         //});
//                        });
                        
                        
                    }
                //}
            //}
            
            
        
        //});
    //});
    }
    
    
    
    return cell;
}
//
//-(UITableViewCell *)cellForNearMe:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CnnCellIdentifier"];
//    
//    if (cell == nil) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CnnCellIdentifier"];
//    }
//    
//    
//    
//    PeerInfo *peerInfo= [_appDelegate.mcManager.peerDevices objectAtIndex:indexPath.row];
//    /*if([_appDelegate.mcManager.peerDevices containsObject:peerInfo])
//     cell.textLabel.text =[NSString stringWithFormat:@"%@ Connected",peerInfo.peerID.displayName];
//     else*/
//    cell.textLabel.text =peerInfo.peerID.displayName;
//    if(peerInfo.sessionState==MCSessionStateConnected){
//        cell.detailTextLabel.text=@"Connected";//peerInfo.deviceToken;
//        cell.accessoryType=UITableViewCellAccessoryNone;
//    }
//    else if(peerInfo.sessionState==MCSessionStateConnecting){
//        cell.detailTextLabel.text=@"Connecting...";
//         cell.accessoryType=UITableViewCellAccessoryNone;
//    }
//    else{
//        cell.detailTextLabel.text=@"Not Connected. Tap to connect.";
//        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
//
//    }
//    
//    
//    /*this ok for http connection
//     dispatch_async(dispatch_get_main_queue(), ^{
//     NSURL *url=[[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@myphoto.png",peerInfo.homeUrl]];
//     NSData *imageData=[[NSData alloc] initWithContentsOfURL:url];
//     if (imageData!=nil) {
//     // UIImage *image=[[UIImage alloc] initWithData:imageData];
//     cell.imageView.image=[[UIImage alloc] initWithData:imageData];
//     cell.imageView.layer.cornerRadius=cell.imageView.frame.size.width / 2;
//     cell.imageView.clipsToBounds = YES;
//     
//     }
//     
//     
//     });
//     */
//    /*BT connection. NOTE: In this case this wont work bec theyre not connected yet
//     
//     //TODO: implement compression
//     dispatch_async(dispatch_get_main_queue(), ^{
//     NSString *peer_photo=[NSString stringWithFormat:@"myphoto-%@.png",peerInfo.deviceID];
//     NSString *serverPath=[NSString stringWithFormat:@"/%@",peer_photo];
//     
//     //NSLog(@"serverpath=%@",peerInfo.homeUrl);
//     NSLog(@"serverpath=%@",serverPath);
//     
//     NSDictionary *dict = @{KEY_SEND_MESSAGE: serverPath,
//     KEY_SEND_MESSAGE_TYPE : MSG_TYPE_REQUEST_FILE_DOWNLOAD
//     };
//     
//     [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_HAS_DATA_TO_SEND
//     object:nil
//     userInfo:dict];
//     
//     
//     
//     });
//     */
//    NSString *peer_photo=[NSString stringWithFormat:@"myphoto-%@.png",peerInfo.deviceID];
//    
//    NSString *filePath=[[AppDelegate getImagesPathForServer:_appDelegate.selectedStore.peerInfo.deviceID] stringByAppendingPathComponent:peer_photo];
//    /*
//     NSString *filePath=[[AppDelegate getSharedPath] stringByAppendingPathComponent:attached_photo];
//     
//     
//     
//     //check if cached
//     if([[NSFileManager defaultManager] fileExistsAtPath:filePath]){
//     
//     //cell.attachImage.image=[[UIImage alloc] initWithContentsOfFile:filePath];
//     dispatch_queue_t imageQueue = dispatch_queue_create("Image Attachment Queue",NULL);
//     dispatch_async(imageQueue, ^{
//     
//     
//     NSData *imageData=[NSData dataWithContentsOfFile:filePath];
//     
//     
//     if(!imageData) return;
//     
//     dispatch_async(dispatch_get_main_queue(), ^{
//     
//     if(imageData){
//     [cell.attachImage setImage:[UIImage imageWithData:imageData]];
//     cell.attachImage.layer.cornerRadius=cell.attachImage.layer.cornerRadius=cell.senderPhoto.frame.size.width / 4;//cell.senderPhoto.frame.size.width / 2;
//     cell.attachImage.clipsToBounds = YES;
//     }
//     });
//     });
//     }
//
//     */
//    //check if cached
//    [cell.imageView setImage:[UIImage imageNamed:@"empty"]];
//    if([[NSFileManager defaultManager] fileExistsAtPath:filePath]){
//        //cell.imageView.image=[[UIImage alloc] initWithContentsOfFile:filePath];
//        
//        //check if cached
//        //
//       // if([[NSFileManager defaultManager] fileExistsAtPath:filePath]){
//            //cell.imageView.image=[[UIImage alloc] initWithContentsOfFile:filePath];
//            dispatch_queue_t imageQueue = dispatch_queue_create("Image Queue",NULL);
//            dispatch_async(imageQueue, ^{
//                
//                
//                NSData *imageData=[NSData dataWithContentsOfFile:filePath];
//                
//                
//                if(!imageData) return;
//                
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    if(cell.imageView)
//                    {
//                    [cell.imageView setImage:[UIImage imageWithData:imageData]];
//                    cell.imageView.layer.cornerRadius=cell.imageView.frame.size.width / 4;//cell.senderPhoto.frame.size.width / 2;
//                    cell.imageView.clipsToBounds = YES;
//                    }
//                });
//            });
//        //}
//
//    }
//    else{
//        if(peerInfo.sessionState==MCSessionStateConnected){
//            
//            //dispatch_async(dispatch_get_main_queue(), ^{
//                /*this is for http connectivity
//                 NSURL *url=[[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@myphoto.png",peerInfo.homeUrl]];
//                 NSData *imageData=[[NSData alloc] initWithContentsOfURL:url];
//                 if (imageData!=nil) {
//                 // UIImage *image=[[UIImage alloc] initWithData:imageData];
//                 cell.imageView.image=[[UIImage alloc] initWithData:imageData];
//                 cell.imageView.layer.cornerRadius=cell.imageView.frame.size.width / 2;
//                 cell.imageView.clipsToBounds = YES;
//                 }
//                 */
//                
//                //MC connectivity
//            /*
//                [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didFinishDownload:) name:peer_photo object:nil];
//                NSString *serverPath=[NSString stringWithFormat:@"/%@",peer_photo];
//                
//                BroadcastMessageAPI *message=[[BroadcastMessageAPI alloc] init];
//                message.text=serverPath;
//                message.isBroadcast=NO;
//                message.toPeerInfo=peerInfo;
//                message.message_type=MSG_TYPE_REQUEST_FILE_DOWNLOAD;
//                message.localCopy=NO;
//                
//                [self sendMyMessage:message];
//              */
//                
//            //});
//        }
//        else{ //pull from the internet
//           /*NOTE!!! this cause disconnect specially when image is not available
//            
//            dispatch_queue_t imageQueue = dispatch_queue_create("Image Queue",NULL);
//            dispatch_async(imageQueue, ^{
//                
//                
//                NSString *urlPath=[NSString stringWithFormat:@"%@%@/%@",ServerURL,ServerImagePath,peer_photo];
//                
//                //NSURL *url=[[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@myphoto.png",peerInfo.homeUrl]];
//                NSURL *url=[[NSURL alloc] initWithString:urlPath];
//                
//                NSData *imageData=[[NSData alloc] initWithContentsOfURL:url];
//                
//                
//                if(!imageData) return;
//                
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    if(cell.imageView)
//                    {
//                        [cell.imageView setImage:[UIImage imageWithData:imageData]];
//                        cell.imageView.layer.cornerRadius=cell.imageView.frame.size.width / 4;//cell.senderPhoto.frame.size.width / 2;
//                        cell.imageView.clipsToBounds = YES;
//                    }
//                });
//            });
//*/
//            
//             
//        }
//        
//    }
//    
//
//    return cell;
//}
//
//-(UITableViewCell *)cellForOutOfRange:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CnnCellIdentifier"];
//    
//    if (cell == nil) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CnnCellIdentifier"];
//    }
//    
//    
//    
//    PeerInfo *peerInfo= [_appDelegate.mcManager.peerDevices objectAtIndex:indexPath.row];
//    /*if([_appDelegate.mcManager.peerDevices containsObject:peerInfo])
//     cell.textLabel.text =[NSString stringWithFormat:@"%@ Connected",peerInfo.peerID.displayName];
//     else*/
//    cell.textLabel.text =peerInfo.peerID.displayName;
//    if(peerInfo.sessionState==MCSessionStateConnected){
//        cell.detailTextLabel.text=@"Connected";//peerInfo.deviceToken;
//        cell.accessoryType=UITableViewCellAccessoryNone;
//    }
//    else if(peerInfo.sessionState==MCSessionStateConnecting){
//        cell.detailTextLabel.text=@"Connecting...";
//        cell.accessoryType=UITableViewCellAccessoryNone;
//    }
//    else{
//        cell.detailTextLabel.text=@"Not Connected. Tap to connect.";
//        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
//        
//    }
//    
//    
//    /*this ok for http connection
//     dispatch_async(dispatch_get_main_queue(), ^{
//     NSURL *url=[[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@myphoto.png",peerInfo.homeUrl]];
//     NSData *imageData=[[NSData alloc] initWithContentsOfURL:url];
//     if (imageData!=nil) {
//     // UIImage *image=[[UIImage alloc] initWithData:imageData];
//     cell.imageView.image=[[UIImage alloc] initWithData:imageData];
//     cell.imageView.layer.cornerRadius=cell.imageView.frame.size.width / 2;
//     cell.imageView.clipsToBounds = YES;
//     
//     }
//     
//     
//     });
//     */
//    /*BT connection. NOTE: In this case this wont work bec theyre not connected yet
//     
//     //TODO: implement compression
//     dispatch_async(dispatch_get_main_queue(), ^{
//     NSString *peer_photo=[NSString stringWithFormat:@"myphoto-%@.png",peerInfo.deviceID];
//     NSString *serverPath=[NSString stringWithFormat:@"/%@",peer_photo];
//     
//     //NSLog(@"serverpath=%@",peerInfo.homeUrl);
//     NSLog(@"serverpath=%@",serverPath);
//     
//     NSDictionary *dict = @{KEY_SEND_MESSAGE: serverPath,
//     KEY_SEND_MESSAGE_TYPE : MSG_TYPE_REQUEST_FILE_DOWNLOAD
//     };
//     
//     [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_HAS_DATA_TO_SEND
//     object:nil
//     userInfo:dict];
//     
//     
//     
//     });
//     */
//    NSString *peer_photo=[NSString stringWithFormat:@"myphoto-%@.png",peerInfo.deviceID];
//    
//    NSString *filePath=[[AppDelegate getImagesPathForServer:_appDelegate.selectedStore.peerInfo.deviceID] stringByAppendingPathComponent:peer_photo];
//    /*
//     NSString *filePath=[[AppDelegate getSharedPath] stringByAppendingPathComponent:attached_photo];
//     
//     
//     
//     //check if cached
//     if([[NSFileManager defaultManager] fileExistsAtPath:filePath]){
//     
//     //cell.attachImage.image=[[UIImage alloc] initWithContentsOfFile:filePath];
//     dispatch_queue_t imageQueue = dispatch_queue_create("Image Attachment Queue",NULL);
//     dispatch_async(imageQueue, ^{
//     
//     
//     NSData *imageData=[NSData dataWithContentsOfFile:filePath];
//     
//     
//     if(!imageData) return;
//     
//     dispatch_async(dispatch_get_main_queue(), ^{
//     
//     if(imageData){
//     [cell.attachImage setImage:[UIImage imageWithData:imageData]];
//     cell.attachImage.layer.cornerRadius=cell.attachImage.layer.cornerRadius=cell.senderPhoto.frame.size.width / 4;//cell.senderPhoto.frame.size.width / 2;
//     cell.attachImage.clipsToBounds = YES;
//     }
//     });
//     });
//     }
//     
//     */
//    //check if cached
//    [cell.imageView setImage:[UIImage imageNamed:@"empty"]];
//    if([[NSFileManager defaultManager] fileExistsAtPath:filePath]){
//        //cell.imageView.image=[[UIImage alloc] initWithContentsOfFile:filePath];
//        
//        //check if cached
//        //
//        // if([[NSFileManager defaultManager] fileExistsAtPath:filePath]){
//        //cell.imageView.image=[[UIImage alloc] initWithContentsOfFile:filePath];
//        dispatch_queue_t imageQueue = dispatch_queue_create("Image Queue",NULL);
//        dispatch_async(imageQueue, ^{
//            
//            
//            NSData *imageData=[NSData dataWithContentsOfFile:filePath];
//            
//            
//            if(!imageData) return;
//            
//            dispatch_async(dispatch_get_main_queue(), ^{
//                if(cell.imageView)
//                {
//                    [cell.imageView setImage:[UIImage imageWithData:imageData]];
//                    cell.imageView.layer.cornerRadius=cell.imageView.frame.size.width / 4;//cell.senderPhoto.frame.size.width / 2;
//                    cell.imageView.clipsToBounds = YES;
//                }
//            });
//        });
//        //}
//        
//    }
//    else{
//        if(peerInfo.sessionState==MCSessionStateConnected){
//            
//            //dispatch_async(dispatch_get_main_queue(), ^{
//            /*this is for http connectivity
//             NSURL *url=[[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@myphoto.png",peerInfo.homeUrl]];
//             NSData *imageData=[[NSData alloc] initWithContentsOfURL:url];
//             if (imageData!=nil) {
//             // UIImage *image=[[UIImage alloc] initWithData:imageData];
//             cell.imageView.image=[[UIImage alloc] initWithData:imageData];
//             cell.imageView.layer.cornerRadius=cell.imageView.frame.size.width / 2;
//             cell.imageView.clipsToBounds = YES;
//             }
//             */
//            
//            //MC connectivity
//            /*
//             [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didFinishDownload:) name:peer_photo object:nil];
//             NSString *serverPath=[NSString stringWithFormat:@"/%@",peer_photo];
//             
//             BroadcastMessageAPI *message=[[BroadcastMessageAPI alloc] init];
//             message.text=serverPath;
//             message.isBroadcast=NO;
//             message.toPeerInfo=peerInfo;
//             message.message_type=MSG_TYPE_REQUEST_FILE_DOWNLOAD;
//             message.localCopy=NO;
//             
//             [self sendMyMessage:message];
//             */
//            
//            //});
//        }
//        else{ //pull from the internet
//            /*NOTE!!! this cause disconnect specially when image is not available
//             
//             dispatch_queue_t imageQueue = dispatch_queue_create("Image Queue",NULL);
//             dispatch_async(imageQueue, ^{
//             
//             
//             NSString *urlPath=[NSString stringWithFormat:@"%@%@/%@",ServerURL,ServerImagePath,peer_photo];
//             
//             //NSURL *url=[[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@myphoto.png",peerInfo.homeUrl]];
//             NSURL *url=[[NSURL alloc] initWithString:urlPath];
//             
//             NSData *imageData=[[NSData alloc] initWithContentsOfURL:url];
//             
//             
//             if(!imageData) return;
//             
//             dispatch_async(dispatch_get_main_queue(), ^{
//             if(cell.imageView)
//             {
//             [cell.imageView setImage:[UIImage imageWithData:imageData]];
//             cell.imageView.layer.cornerRadius=cell.imageView.frame.size.width / 4;//cell.senderPhoto.frame.size.width / 2;
//             cell.imageView.clipsToBounds = YES;
//             }
//             });
//             });
//             */
//            
//            
//        }
//        
//    }
//    
//    
//    return cell;
//}


-(void)didFinishDownload:(NSNotification *)notification{
    if([notification.userInfo objectForKey:@"resourceName"]!=nil){
        [[NSNotificationCenter defaultCenter] removeObserver:self name:[notification.userInfo valueForKey:@"resourceName"] object:nil];
    }
    /*if(timerWaitBeforReload==nil)
     timerWaitBeforReload=[NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(reloadImageOntimer) userInfo:nil repeats:NO];
     else{
     if([timerWaitBeforReload isValid]){
     [timerWaitBeforReload invalidate];
     timerWaitBeforReload=[NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(reloadImageOntimer) userInfo:nil repeats:NO];
     }
     }
     */
    dispatch_async(dispatch_get_main_queue(), ^{
        [_tableView reloadData];
    });
    
    
}

-(void)connectToPeer:(PeerInfo *)peer{
    [self.nearbyIndicator stopAnimating];
    if(browseTimer!=nil){
        [browseTimer invalidate];
        browseTimer=nil;
        
    }
        
   //// _selectedPeer=peer;
   // if(_selectedPeer==nil)
     //   return;
    
    
    
    
    /*
    if(_selectedPeer.sessionState!=MCSessionStateNotConnected)
        return;
    
    
    if(_appDelegate.selectedStore.peerInfo.sessionState==MCSessionStateConnected){
        //[_appDelegate.mcManager.session disconnect];
        
        [self disconnect:nil];
    }
    
    */
    
    
    peer.sessionState=MCSessionStateConnecting;
    
    /*NSArray *objects=[[NSArray alloc] initWithObjects:_appDelegate.appConfig.userInfo.deviceID,_appDelegate.appConfig.userInfo.deviceToken,_appDelegate.appConfig.userInfo.homeUrl, nil];
     
     NSArray *keys=[[NSArray alloc] initWithObjects:@"deviceID",@"deviceToken",@"homeurl", nil];
     NSDictionary *context=[[NSDictionary alloc] initWithObjects:objects forKeys:keys];
     */
    
    NSDictionary *context;
    
    NSString *info=[NSString stringWithFormat:@"%@;%@;%@;%@;%@",_appDelegate.appConfig.userInfo.deviceID,_appDelegate.appConfig.userInfo.deviceToken,(_appDelegate.appConfig.userInfo.homeUrl!=nil)?_appDelegate.appConfig.userInfo.homeUrl:@"",_appDelegate.appConfig.userInfo.displayName,(_appDelegate.appConfig.userInfo.myPhotoMD5!=nil)?_appDelegate.appConfig.userInfo.myPhotoMD5:@""];
    
    //NSDictionary *dict_info=@{}
    
#ifdef DEBUG
    NSLog(@"info=%@",info);
#endif
    
    if(SECURED){
        NSError *error;
        //NSData *data = [info dataUsingEncoding:NSUTF8StringEncoding];
        NSData *data = [info dataUsingEncoding:NSUTF8StringEncoding];
        NSData *encryptedData = [RNEncryptor encryptData:data
                                            withSettings:kRNCryptorAES256Settings
                                                password:A_SECRET_PASSWORD
                                                   error:&error];
        
        if(error!=nil)
            return;
        
        NSString *base64Encoded=[encryptedData base64EncodedStringWithOptions:0];//[NSString stringWithUTF8String:[encryptedData bytes]];
        
        context=@{@"info":base64Encoded};
        
        //_advertiser = [[MCNearbyServiceAdvertiser alloc] initWithPeer:_peerID discoveryInfo:discoveryInfo serviceType:KEY_MC_ADVERTISE_POS];
    }
    else{
        context=@{@"info":info};
    }
    
    [_appDelegate.mcManager.browser invitePeer:peer.peerID toSession:_appDelegate.mcManager.session withContext:[NSKeyedArchiver archivedDataWithRootObject:context] timeout:15.0 ];
    //_appDelegate.mcManager.serverPeerInfo=peer;
    /* UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:@"Connecting to..." message:peerInfo.peerID.displayName delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil, nil];
     [alertView show];
     */
    [_tableView reloadData];
}

-(void)authenticate:(StoreHistory *)device{//:(int) authType{//:(StoreHistory *)device{
    
    if(_appDelegate.appConfig.userInfo.userToken==nil || _appDelegate.appConfig.userInfo.userToken.length==0){
        
        [self showLogin];
    }
    switch(selectedAuthType){
        case 1:{
            [self performValidSelection:device];
        }
            break;
        case 2:
        {
            //show finger print
            [self authenicatewithPIN];
            
            
        }
            break;
        case 3:
        {
            //show finger print
            [self authenicatewithTouchID];
            
        }
            break;
        default:
        {
            [AppDelegate toast:@"Authentication not set." duration:2];
        }
            
    }
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
  //  [self stopBrowsing];
    
    
    
    //StoreHistory *store;
    
    if(indexPath.section==0)
        store_selected= [nearItems objectAtIndex:indexPath.row];
    else
        store_selected= [farItems objectAtIndex:indexPath.row];
    
    if(store_selected.cart==nil)
        store_selected.cart=[[CheckoutCart alloc] init];
    
    if(store_selected.orders==nil)
        store_selected.orders=[NSMutableArray new];
    
    if(store_selected.inventory==nil)
        store_selected.inventory=[InventoryItem new];
        
    
    //_appDelegate.selectedStore=store;
    
    selectedAuthType=store_selected.authType;
    
    if(selectedAuthType==0){
        [self performValidSelection:store_selected];
    }
    else{
        
        
        [self authenticate:store_selected];
    }
    
    
    
}



-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80.0;
}

//- (UITableViewCell *)loadingCell {
//    //UITableViewCell *cell = [[[UITableViewCell alloc]
//    //  initWithStyle:UITableViewCellStyleDefault
//    //  reuseIdentifier:nil] autorelease];
//    UITableViewCell *cell = [[UITableViewCell alloc]
//                             initWithStyle:UITableViewCellStyleDefault
//                             reuseIdentifier:nil] ;
//    
//    UIActivityIndicatorView *activityIndicator =
//    [[UIActivityIndicatorView alloc]
//     initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
//    activityIndicator.center = cell.center;
//    [cell addSubview:activityIndicator];
//    //[activityIndicator release];
//    
//    [activityIndicator startAnimating];
//    
//    cell.tag = 300;//kLoadingCellTag;
//    
//    return cell;
//}

/*
- (UITableViewCell *)loadingCell {
    //UITableViewCell *cell = [[[UITableViewCell alloc]
    //  initWithStyle:UITableViewCellStyleDefault
    //  reuseIdentifier:nil] autorelease];
    UITableViewCell *cell = [[UITableViewCell alloc]
                             initWithStyle:UITableViewCellStyleDefault
                             reuseIdentifier:nil] ;
    
    UIActivityIndicatorView *activityIndicator =
    [[UIActivityIndicatorView alloc]
     initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityIndicator.center = cell.center;
    [cell addSubview:activityIndicator];
    //[activityIndicator release];
    
    [activityIndicator startAnimating];
    
    cell.tag = kLoadingCellTag;
    
    return cell;
}
*/
//copy photo if needed
-(void)copyImageFileToDocDirIfNeeded:(NSString *)deviceID peerPhoto:(NSData *)peerPhoto{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    _documentsDirectory = [[NSString alloc] initWithString:[paths objectAtIndex:0]];
    
    NSString *filePath = [_documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png",deviceID]];
    
    //   NSString *file2Path = [_documentsDirectory stringByAppendingPathComponent:@"sample_file2.txt"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    
    if (![fileManager fileExistsAtPath:filePath]) {
        /*[fileManager copyItemAtPath:[[NSBundle mainBundle] pathForResource:deviceID ofType:@"png"]
         toPath:filePath
         error:&error];*/
        [peerPhoto writeToFile:filePath atomically:YES];
        
        if (error) {
            #ifdef DEBUG
            NSLog(@"%@", [error localizedDescription]);
#endif
            return;
        }
        
        /* [fileManager copyItemAtPath:[[NSBundle mainBundle] pathForResource:@"sample_file2" ofType:@"txt"]
         toPath:file2Path
         error:&error];
         
         if (error) {
         NSLog(@"%@", [error localizedDescription]);
         return;
         }*/
    }
}

//NSDictionary *menu_dict=[_inventoryModel toMenuDictionary];
-(void)didReceiveVoiceDataWithNotification:(NSNotification *)notification{
    //  MCPeerID *peerID = [[notification userInfo] objectForKey:@"peerID"];
    //   NSString *peerDisplayName = peerID.displayName;
    
    //  NSData *receivedData = [[notification userInfo] objectForKey:@"data"];
    //   NSString *receivedText = [[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding];
    
    //[_tvChat performSelectorOnMainThread:@selector(setText:) withObject:[_tvChat.text stringByAppendingString:[NSString stringWithFormat:@"%@ wrote:\n%@\n\n", peerDisplayName, receivedText]] waitUntilDone:NO];
    if(_appDelegate.isAudioON){
        CAudioBuffer *sourceBuffer=[[CAudioBuffer alloc] init];// [notification object];
        sourceBuffer.mData=[[notification userInfo] objectForKey:@"data"];
        sourceBuffer.mDataByteSize=(int)sourceBuffer.mData.length;//(UInt32)sourceBuffer.mData.length;
        sourceBuffer.mNumberChannels=1;
        //@synchronized(self.audioProcessor.inputBuffers ){
        [self.audioProcessor.inputBuffers addObject:sourceBuffer];
    }
    //}
    //[self.audioProcessor.inputBuffers performSelectorOnMainThread:@selector(addObject:) withObject:sourceBuffer waitUntilDone:NO];
}
-(void)didReceiveAudioSwitchNotification:(NSNotification *)notification{
    BOOL isOn=[[notification.userInfo valueForKey:@"on"] boolValue];
    //if (!_appDelegate.isAudioON) {
    if (!isOn) {
        //[self showLabelWithText:@"Stopping AudioUnit"];
        if (_audioProcessor)
            [_audioProcessor stop];
        //[self showLabelWithText:@"AudioUnit stopped"];
        
        /* if (self.outputStreamer){
         
         [self.outputStreamer stop];
         
         }*/
        
    } else {
        
        
        /* NSArray *peers = [self.session connectedPeers];
         
         if (peers.count) {
         
         if (!self.outputStreamer){
         
         self.outputStreamer = [[TDAudioOutputStreamer alloc] initWithOutputStream:[self.session outputStreamForPeer:peers[0]]];
         //[self.outputStreamer streamAudioFromURL:[self.song valueForProperty:MPMediaItemPropertyAssetURL]];
         
         }
         
         [self.outputStreamer start];
         */
        if (_audioProcessor == nil) {
            _audioProcessor = [[AudioProcessor alloc] init];
        }
        // [self showLabelWithText:@"Starting up AudioUnit"];
        [_audioProcessor start];
        
        
        //  }
        
        // [self showLabelWithText:@"AudioUnit running"];
        
        
    }
}

-(void) didReceiveMicInputNotification: (NSNotification *) notification{
    /*    NSValue *obj=[notification object];
     AudioBuffer sourceBuffer;
     
     [obj getValue:&sourceBuffer];
     
     if(self.outputStreamer)
     //[self.outputStreamer streamAudioFromMic:&sourceBuffer];
     [self.outputStreamer ]
     */
    
    //this works don't erase
    /*
     AudioBuffer *audioBufferPlayback=[self.audioProcessor getPlaybackBuffer];
     if (audioBufferPlayback->mDataByteSize != sourceBuffer.mDataByteSize) {
     free(audioBufferPlayback->mData);
     audioBufferPlayback->mDataByteSize = sourceBuffer.mDataByteSize;
     audioBufferPlayback->mData = malloc(sourceBuffer.mDataByteSize);
     }
     
     memcpy(audioBufferPlayback->mData, sourceBuffer.mData, sourceBuffer.mDataByteSize);
     */
    //if(self.outputStreamer){
    
    /*
     if(self.outputStreamm){
     CAudioBuffer *sourceBuffer=[notification object];
     
     //[self.outputStreamer addQueue:sourceBuffer];
     [self.outputQueue addObject:sourceBuffer];
     }
     */
    
    //NSData *dataToSend = [_txtMessage.text dataUsingEncoding:NSUTF8StringEncoding];
    
    
    NSArray *allPeers = _appDelegate.mcManager.session.connectedPeers;
    
    //assert([allPeers count]>0);
    
    if(allPeers.count>0){
        
        CAudioBuffer *sourceBuffer=[notification object];
        NSMutableData *tmpData=[NSMutableData dataWithBytes:"\x1" length:1];
        [tmpData appendData:sourceBuffer.mData];
        
        // dispatch_async(dispatch_get_main_queue(), ^{
        NSError *error;
        /* [_appDelegate.mcManager.session  sendData:sourceBuffer.mData
         toPeers:allPeers
         withMode:MCSessionSendDataUnreliable
         error:&error];*/
        [_appDelegate.mcManager.session sendData:tmpData
                                         toPeers:allPeers
                                        withMode:MCSessionSendDataUnreliable
                                           error:&error];
        
        if (error) {
            #ifdef DEBUG
            NSLog(@"%@", [error localizedDescription]);
#endif
        }
        //  });
        
        
        
        
        
        
    }
    
}

//-(void)didSendPaidOrderFromServer:(NSNotification *)notification{
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [self.soundController playSystemSound];
//        BroadcastMessageAPI *message=[[BroadcastMessageAPI alloc] init];
//        message.peerInfo=[[notification userInfo] objectForKey:@"peerInfo"];
//        message.deviceID=_appDelegate.userInfo.deviceID;
//        message.createdon=[NSDate date];
//        //message.peerInfo.peerID = [[notification userInfo] objectForKey:@"peerID"];
//        // NSString *peerDisplayName = message.peerInfo.peerID.displayName;
//        
//        
//        NSData *receivedData = [[notification userInfo] objectForKey:@"data"];
//        
//        
//        NSString *receivedText = [[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding];
//        
//        //NSLog(@"receivedText=%@",receivedText);
//        /*
//         [_tvChat performSelectorOnMainThread:@selector(setText:) withObject:[_tvChat.text stringByAppendingString:[NSString stringWithFormat:@"%@ wrote:\n%@\n\n", peerDisplayName, receivedText]] waitUntilDone:NO];
//         */
//        //NSString *header=[receivedText substringToIndex:38];
//        
//        //message.senderToken=[receivedText substringToIndex:36];
//        message.message_type=[receivedText substringWithRange:NSMakeRange(0, 2)];
//        message.senderToken=[receivedText substringWithRange:NSMakeRange(2, 38)];
//        
//        message.text=[receivedText substringFromIndex:38];//receivedText;
//        
//        message.sender= message.peerInfo.peerID.displayName;
//
//        
//    });
//    
//}
//




/*

-(NSDictionary *)charge:(NSString *)requestString{
    
    
    
    //NSString *STRIPE_POST_URL=@"https://api.stripe.com/v1/charges";
    //NSString *STRIPE_API_KEY=@"***REMOVED***";
    
    //NSData *nsdata=[STRIPE_API_KEY dataUsingEncoding:NSUTF8StringEncoding];
    NSData *nsdata=[NSData dataWithBytes:[STRIPE_API_KEY UTF8String] length:[STRIPE_API_KEY length]];
    
    
    NSString *base64EncodedAPIKEY=[nsdata base64EncodedStringWithOptions:0];
    
    //NSLog([NSString stringWithFormat:@"base64EncodedAPIKEY: %@",base64EncodedAPIKEY]);
    
    //1
    NSURL *postURL = [NSURL URLWithString:STRIPE_POST_URL];
    
    NSError* err = nil;
    
    //NSString *requestString=[NSString stringWithFormat:@"amount=%@&currency=%@&source=%@&description=%@",stripeAmount,stripeCurrency,stripeToken,@"description..."];
    
    //NSLog([NSString stringWithFormat:@"requestString: %@",requestString]);
    
    NSData *requestData=[NSData dataWithBytes:[requestString UTF8String] length:[requestString length]];
    
    NSMutableURLRequest *postRequest=[[NSMutableURLRequest alloc] initWithURL:postURL];
    
    [postRequest setHTTPMethod:@"POST"];
    [postRequest setValue:[NSString stringWithFormat: @"Basic %@",base64EncodedAPIKEY] forHTTPHeaderField:@"Authorization"];
    [postRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"content-type"];
    
    //[postRequest setValue:@"text/json" forHTTPHeaderField:@"Accept"];
    
    
    
    [postRequest setHTTPBody:requestData];
    
    NSURLResponse *response;
    //NSError *err;
    NSData *jsonData=[NSURLConnection sendSynchronousRequest:postRequest returningResponse:&response error:&err];
    
    //we will use json instead: NSString *content=[NSString stringWithUTF8String:[jsonData bytes]];
    NSMutableDictionary *jsonResult=[NSMutableDictionary new];
    
    NSDictionary *JSON = [NSJSONSerialization JSONObjectWithData:jsonData
                                                         options:kNilOptions
                                                           error:&err];
    
    if(err==nil){
        [jsonResult setValue:@1 forKey:@"Success"];
        //[jsonResult setValue:@"" forKey:@"Error"];
        [jsonResult setValue:JSON forKey:@"Result"];
        
        return jsonResult;//JSON;//[GCDWebServerDataResponse responseWithJSONObject:JSON];
    }
    else{
        [jsonResult setValue:@0 forKey:@"Success"];
        [jsonResult setValue:err.localizedDescription forKey:@"Error"];
        [jsonResult setValue:JSON forKey:@"Result"];
        return jsonResult;
    }
    
    
}
*/



#pragma mark Client Functions
//-(void)performMessageReceivedForClient:(BroadcastMessageAPI *)message{
-(void)performMessageReceived:(BroadcastMessageAPI *)message{
#ifdef DEBUG
    NSLog(@"BroadcastMessageAPI.text=%@",message.text);
    NSLog(@"BroadcastMessageAPI.message_type=%@",message.message_type);
#endif
    
    StoreHistory *store=[_appDelegate.historyModel storeWithPeer:message.peerInfo];
    if(store==nil)
        return;

    if([message.message_type isEqualToString:MSG_TYPE_REQUEST_FILE_DOWNLOAD]){
        /*NSString *pathcComponent=message.text;
        
        if(pathcComponent){
            [self performFileUpload:pathcComponent fromPeer:message.peerInfo.peerID];
        }*/
        NSString *pathComponents=message.text;
        pathComponents=[pathComponents stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" "]];
        if(pathComponents.length==0)
            return;
        NSArray *paths=[pathComponents componentsSeparatedByString:@","];
        
        for (NSString *pathcComponent in paths) {
            //NSString *pathcComponent=message.text;
            // NSLog(@"pathcComponent=%@",pathcComponent);
            if(pathcComponent){
                [self performFileUpload:pathcComponent fromPeer:message.peerInfo.peerID];
            }
        }
    }
    
    else if([message.message_type isEqualToString:MSG_TYPE_RESPONSE]){
    NSData *data=[message.text dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    
    NSString *action=[dict valueForKey:KEY_ACTION];
    
#ifdef DEBUG
        NSLog(@"action=%@",action);
        
#endif
#pragma -mark INVENTORY
    if([action isEqualToString:KEY_ACTION_INVENTORY]){
       
        //StoreHistory *store=[_historyModel storeWithPeer:message.peerInfo];
        //if(store==nil)
        //    return;
        
        /*
        _appDelegate.inventory=[dict valueForKey:KEY_ACTION_PARAM];
        
        if(_appDelegate.selectedStore.inventory==nil)
            _appDelegate.selectedStore.inventory=[InventoryItem new];
        
        
        [_appDelegate.selectedStore.inventory initFromDictionary:_appDelegate.inventory];
        */
        
        if(store.inventory==nil)
            store.inventory=[InventoryItem new];
        
       
        
        [store.inventory deserialize:[dict valueForKey:KEY_ACTION_PARAM]];
        
        
        [_appDelegate.historyModel saveHistory];
        
        
        
        /*TODO: shold i remove sharedinstance?
         
        CheckoutCart *cart=[CheckoutCart sharedInstance];
        cart.inventory=store.inventory;//_appDelegate.selectedStore.inventory;
        
        if(![cart.inventoryID isEqualToString:_appDelegate.selectedStore.inventory.inventoryId]){
            cart.inventoryID=_appDelegate.selectedStore.inventory.inventoryId;
            
            if([cart.itemsInCart count] >0){
                //[cart clearCart];
                 //UITabBarItem *tbi=(UITabBarItem *)[self.tabBarController.tabBar.items objectAtIndex:TAB_INDEX_CART];
                 //tbi.badgeValue=nil;
                
                [_appDelegate clearCart];
            }
        }
         */
        
        /*
        NSString *storeID=[inventoryCfg valueForKey:deviceIDKey];
        CheckoutCart *cart =[CheckoutCart sharedInstance];
        [cart cleanCart:storeID isLive:_appDelegate.appConfig.isLive];
        */
        /*if([_appDelegate.selectedStore.inventory.categories count]==0){
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
                [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_RECEIVED_MENU object:nil];
            }
            else{
                [AppDelegate toast:@"Menu is not available at this time. Please try again later." duration:3.0];
                
            }
        }
        else{
        */
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_RECEIVED_MENU object:nil];
        //[AppDelegate toast:@"Menu update!" duration:2.0];
        //}
        
        
    }
    else if([action isEqualToString:KEY_ACTION_INVENTORY_UPDATE]){
            //for now lets just fetch everything
        [self fetchMenu:store];
            }

    else if([action isEqualToString:KEY_ACTION_INVENTORY_SETTINGS]){
        //_appDelegate.inventory=[dict valueForKey:KEY_ACTION_PARAM];
        NSDictionary *param_dict=[dict valueForKey:KEY_ACTION_PARAM];
        
        //StoreHistory *store=[_historyModel storeWithStoreID:_appDelegate.selectedStore.peerInfo.deviceID];
        //if(store==nil)
            return;
        
        [store.inventory updateSettingWithDictionary:param_dict]; //[_appDelegate.selectedStore.inventory updateSettingWithDictionary:param_dict];
        
        
             [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_RECEIVED_MENU_SETTINGS object:nil];
         [AppDelegate toast:@"Menu settings has changed." duration:2.0];
        
    }
    
        #pragma -mark SERVER INFO
    else if([action isEqualToString:KEY_ACTION_SERVERINFO]){
            //_appDelegate.inventory=[dict valueForKey:KEY_ACTION_PARAM];
            NSDictionary *param_dict=[dict valueForKey:KEY_ACTION_PARAM];
            
            /*_appDelegate.inventory=[param_dict valueForKey:@"menu"];
            _appDelegate.sale=[param_dict valueForKey:@"sale"];
        */
        store.inventoryId=DICT_GET(param_dict,INVENTORYID_KEY);
        
        store.isLive=DICT_GET_BOOL(param_dict,isLiveKey);
        store.useClientToken=DICT_GET_BOOL(param_dict,@"useClientToken");
        store.peerInfo.paymentPublishableKey=DICT_GET(param_dict,@"paymentPublishableKey");
        store.peerInfo.paymentPublishableKeyTest=DICT_GET(param_dict,@"paymentPublishableKeyTest");
        
        /*_appDelegate.selectedStore.peerInfo.currency=DICT_GET(param_dict,currencyKey);
        _appDelegate.selectedStore.peerInfo.currencySymbol=DICT_GET(param_dict,currencySymbolKey);
         */
        store.device_lat=[DICT_GET(param_dict,@"device_lat") floatValue];
        store.device_lng=[DICT_GET(param_dict,@"device_lng") floatValue];
        store.device_address=DICT_GET(param_dict,@"device_address");
         //store.device_storeID=DICT_GET(param_dict,storeIDKey);
        store.storeID=DICT_GET(param_dict,storeIDKey);
        //store.device_storeID
        store.storeNum=DICT_GET_INT(param_dict,@"device_num");
       
        
        
        store.device_ssid=DICT_GET(param_dict,@"device_ssid");
        
        
        
        //_appDelegate.selectedStore.peerInfo.salesTax=DICT_GET_FLOAT(param_dict,@"tax");
        /*_appDelegate.selectedStore.peerInfo.acceptCash=DICT_GET_BOOL(param_dict,@"acceptCash");
        _appDelegate.selectedStore.peerInfo.acceptCCard=DICT_GET_BOOL(param_dict,@"acceptCCard");
        _appDelegate.selectedStore.peerInfo.useApplePay=DICT_GET_BOOL(param_dict,@"useApplePay");
        */
        store.enableChat=DICT_GET_BOOL(param_dict,@"enableChat");
        store.enablePhotoSharing=DICT_GET_BOOL(param_dict,@"enablePhotoSharing");
        
        //_appDelegate.selectedStore.peerInfo.acceptedCards=DICT_GET(param_dict,@"acceptedCards");
        
       /* _appDelegate.selectedStore.peerInfo.minChargeAmount=DICT_GET_INT(param_dict,minChargeAmountKey);
        _appDelegate.selectedStore.peerInfo.maxChargeAmount=DICT_GET_INT(param_dict,maxChargeAmountKey);
        _appDelegate.selectedStore.peerInfo.maxUnpaidOrdersPerCustomer=DICT_GET_INT(param_dict,maxUnpaidOrdersPerCustomerKey);
        
        _appDelegate.selectedStore.peerInfo.refundLevel=DICT_GET_INT(param_dict,refundLevelKey);
        */
        store.maxUploadSizeKB=DICT_GET_INT(param_dict,maxUploadSizeKBKey);
        store.expireMessageInSec=DICT_GET_INT(param_dict,expireMessageInSecKey);
        store.maxMessagesPerUser=DICT_GET_INT(param_dict,maxMessagesPerUserKey);


        
        store.peerInfo.peers=DICT_GET(param_dict,@"peers");
        
        _appDelegate.mcManager.myPeerInfo.group=PEER_GROUP_CUSTOMERS;
        
        for(NSDictionary *p in store.peerInfo.peers){
            if([[p valueForKey:DeviceIdKey] isEqualToString:_appDelegate.mcManager.myPeerInfo.deviceID] ){
                
                _appDelegate.mcManager.myPeerInfo.group=[p valueForKey:@"PeerGroup"];
                break;
            }
            
        }


        //[[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_RECEIVED_SERVERINFO object:nil];
        [self didReceiveServerInfo:store];
        
        //[self fetchMenu];
            
        }
#pragma mark SYNCH RESPONSE
    else if([action isEqualToString:KEY_ACTION_SYNCH_RESPONSE]){
        NSDictionary *param=[dict valueForKey:KEY_ACTION_PARAM];
        

        NSArray *orders=[param valueForKey:@"orders"];
        if([orders count]>0){
            for (NSDictionary *order_dict in orders) {
                OrderHistory *order=[[OrderHistory alloc] initWithJSON:order_dict];
                order.orderSynched=YES;
                [_appDelegate.historyModel addOrUpdateOrderHistory:order];
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_UPDATE_HISTORY object:nil];
        }
        [AppDelegate toast:[NSString stringWithFormat:@"Synched completed for %@ day(s). %@ record(s) affected.",[param valueForKey:@"days"],@([orders count])] duration:5];
       
    }
#pragma mark CHARGE
    else if([action isEqualToString:KEY_ACTION_CHARGE]){
        NSDictionary *param=[dict valueForKey:KEY_ACTION_PARAM];
        NSDictionary *order_dict=[param valueForKey:@"order"];
         NSString *text=[param valueForKey:@"message"];
        // NSString *orderHash=[param valueForKey:@"orderHash"];
        
       // NSDictionary *cardinfo_dict=[param_dict valueForKey:KEY_CHARGE_CARDINFO];
        
        
        OrderHistory *order=[[OrderHistory alloc] initWithJSON:order_dict];
        
        if(order==  nil){
            [AppDelegate toast:@"Order history did not return any value. Message 1971." duration:2.0];
            return;
        }
        
        //if(order.orderIsLive && _appDelegate.appConfig.isLive==NO)
            
        
        //HistoryModel *historyModel=[HistoryModel sharedInstance];
        
        [_appDelegate.historyModel addOrUpdateOrderHistory:order];
        
        /*CheckoutCart *cart = [CheckoutCart sharedInstance];
        
        [cart clearCart];
        UITabBarItem *tbi=(UITabBarItem *)[self.tabBarController.tabBar.items objectAtIndex:TAB_INDEX_CART];
        //if([checkoutCart.itemsInCart count]==0)
        tbi.badgeValue=nil;

        */
        [_appDelegate clearCart];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_UPDATE_HISTORY
                                                            object:nil
                                                          userInfo:nil];
        
        BroadcastMessageAPI *m=[[BroadcastMessageAPI alloc] init];
        m.sender=store.peerInfo.peerID.displayName;
        m.peerInfo=store.peerInfo;
        m.fromDeviceID=store.peerInfo.deviceID;
        m.colorCode=@ColorCodeYellow;
        
        if(order.orderReply!=nil && order.orderReply.length>0){
         text=[NSString stringWithFormat:@"%@ %@",text, order.orderReply];
        }
        else{
         text=[NSString stringWithFormat:@"%@",text];
        }
        text=[text stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" "]];
        
                m.text=text;
        [store addNewMessage:m];
       
        self.tabBarController.selectedIndex=TAB_INDEX_CHAT;
        
        
    }
        
#pragma mark CANCEL ORDER
    else if([action isEqualToString:KEY_ACTION_CANCEL_ORDER]){
        
        
        //NSDictionary *order_dict=[dict valueForKey:KEY_ACTION_PARAM];
       
        NSDictionary *param=[dict valueForKey:KEY_ACTION_PARAM];
        NSDictionary *order_dict=[param valueForKey:@"order"];
        NSString *text=[param valueForKey:@"message"];
        
        
        OrderHistory *order=[[OrderHistory alloc] initWithJSON:order_dict];
        
       
        
        [_appDelegate.historyModel updateOrderHistory:order];
        
        
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_UPDATE_HISTORY
                                                            object:nil
                                                          userInfo:nil];
        
        BroadcastMessageAPI *m=[[BroadcastMessageAPI alloc] init];
        m.sender=store.peerInfo.peerID.displayName;
        m.peerInfo=store.peerInfo;
        m.fromDeviceID=store.peerInfo.deviceID;
        m.colorCode=@ColorCodeRed;
        
        
        m.text=text;
        
        //[_appDelegate addNewMessage:m];
        [store addNewMessage:m];
    }

        #pragma mark RESPONSE MESSAGE
    else{
        
        //[_appDelegate addNewMessage:message];
        [store addNewMessage:message];
    }
}
#pragma mark REQUEST
    
    else if([message.message_type isEqualToString:MSG_TYPE_REQUEST]){
        
        
        NSData *data=[message.text dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error;
        
        NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
        
        
        NSString *action=[dict valueForKey:KEY_ACTION];
#ifdef DEBUG
        NSLog(@"action=%@",action);
        
#endif
#pragma mark ALERT
        if([action isEqualToString:KEY_ACTION_ALERT]){
            
            //InventoryModel *_inventoryModel =[InventoryModel publishedInstance];
            //NSDictionary *menu_dict=[_inventoryModel toMenuDictionary];
            
            NSDictionary *param_dict=[dict valueForKey:KEY_ACTION_PARAM];
            
            NSString *alert_id=[param_dict valueForKey:KEY_ALERT_ID];
            NSString *alert_text=[param_dict valueForKey:KEY_ALERT_TEXT];
            
            //OrderHistory *order=[[OrderHistory alloc] initWithJSON:order_dict];
            
            
            
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_UPDATE_MESSAGES object:nil];

            NSMutableDictionary *response_dict=[[NSMutableDictionary alloc] init];
            
            [response_dict setValue:KEY_ACTION_ALERT forKey:KEY_ACTION];
            [response_dict setValue:@{KEY_ALERT_ID:alert_id,KEY_ALERT_TEXT:alert_text} forKey:KEY_ACTION_PARAM];
            [response_dict setValue:KEY_ACTION_TYPE_RESPONSE forKey:KEY_ACTION_TYPE];
            NSError *error;
            
            NSData *jsonData=[NSJSONSerialization dataWithJSONObject:response_dict options:NSJSONWritingPrettyPrinted error:&error];
            
            if(error==nil){
                NSString *reply=[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
                BroadcastMessageAPI *reply_message=[[BroadcastMessageAPI alloc] init];
                reply_message.text=reply;
                reply_message.isBroadcast=NO;
                reply_message.toPeerInfo=message.peerInfo;
                reply_message.message_type=MSG_TYPE_RESPONSE;
                reply_message.localCopy=NO;
                [self sendMyMessage:reply_message];
            }
            
            
            
            //update order status
            NSNumber *orderStatus=[param_dict valueForKey:OrderStatusKey];
            NSString *orderID=[param_dict valueForKey:OrderIDKey];
            OrderHistory *oh=[_appDelegate.historyModel searchOrderWithOrderID:orderID andStoreId:store.deviceID];
            if(oh!=nil){
                if([oh.orderStatus integerValue]!=[orderStatus integerValue]){
                    oh.orderStatus=orderStatus;
                   
                    [_appDelegate.historyModel saveHistory];
                   /*  NSInteger count=[_appDelegate.historyModel countReadyOrders];
                   
                    UITabBarItem *tbiOrders=(UITabBarItem *)[self.tabBarController.tabBar.items objectAtIndex:TAB_INDEX_INVENTORY];
                    
                    if(count==0)
                        tbiOrders.badgeValue=nil;
                    else
                        tbiOrders.badgeValue=[NSString stringWithFormat:@"%ld",(long)count];
                    */
                    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_UPDATE_HISTORY object:nil];
                    
                }
                
                if([oh.orderStatus integerValue]==ORDER_STATUS_READY)
                    message.colorCode=@ColorCodeGreen;
                else if ([oh.orderStatus integerValue]==ORDER_STATUS_CANC){
                    message.colorCode=@ColorCodeRed;
                }
                else if ([oh.orderStatus integerValue]==ORDER_STATUS_CLOSED){
                    message.colorCode=@ColorCodeDarkGray;
                }
                else if ([oh.orderStatus integerValue]==ORDER_STATUS_RECEIVED){
                    message.colorCode=@ColorCodeYellow;
                }
                else if ([oh.orderStatus integerValue]==ORDER_STATUS_REFUND){
                    message.colorCode=@ColorCodeBlue;
                }
                //overwrite text part
                message.text=alert_text;
                message.fromDeviceID=store.peerInfo.deviceID;
                
                //  [_appDelegate addNewMessage:message];
                [store addNewMessage:message];
            }
            
            
            
            
            
        }
    }
/*
#pragma mark UPDATE SINGLE PEER
    else if([message.message_type isEqualToString:MSG_TYPE_UPDATE_SINGLE_PEER]){
    }
  */  
#pragma mark UPDATE PEERS
    else if([message.message_type isEqualToString:MSG_TYPE_UPDATE_PEERS]){
        
        NSDictionary *dictionary=[AppDelegate fromJsonString:message.text];
        if(dictionary==nil)
            return;
        if(store.peerInfo.peers==nil)
            store.peerInfo.peers=[NSMutableArray new];
        
            NSString *deviceid=[dictionary valueForKey:@"deviceid"];
            if(!deviceid)
                return;
            
            NSString *status=[dictionary valueForKey:@"status"];
            if(!status)
                return;
        
        NSString *text=[dictionary valueForKey:@"text"];
            //NSString *photoMD5=[dictionary valueForKey:@"photomd5"];
            //if(photoMD5==nil||photoMD5.length==0){
                NSError *error;
                 NSString *peer_photo=[NSString stringWithFormat:@"%@%@.png",PREFIX_MYPHOTO,deviceid];
                 NSString *filePath=[[AppDelegate getImagesPathForServer:store.peerInfo.deviceID] stringByAppendingPathComponent:peer_photo];
                
                NSFileManager *fm=[NSFileManager defaultManager];
                if([fm fileExistsAtPath:filePath]){
                    [fm removeItemAtPath:filePath error:&error];
                }
        
            
            BOOL connected=[status isEqualToString:@"connected"];
            
            
            NSPredicate *predicate=[NSPredicate predicateWithFormat:@"%@=%@",DeviceIdKey, deviceid];
            
            NSArray *results=[store.peerInfo.peers filteredArrayUsingPredicate:predicate];
            
            
               
                
                if ([results count]==0) {
                    if (connected) {
                        NSDictionary *peer_dict=@{@"Title":[dictionary valueForKey:@"peername"]//peerID.displayName
                                                  ,DeviceIdKey:deviceid,@"PeerGroup":[dictionary valueForKey:@"peergroup"]
                                                  ,@"PhotoMD5":[dictionary valueForKey:@"photomd5"]};
                        [store.peerInfo.peers addObject:peer_dict];
                    }
                    
                }
                else{
                    NSDictionary *peer=[results firstObject];
                    if (connected) {
                        /*NSString *oldTitle=[peer valueForKey:@"Title"];
                        NSString *newTitle=[dictionary valueForKey:@"Title"];
                        
                        if(![oldTitle isEqualToString:newTitle]){
                            //remove old messages
                            [_appDelegate removeMessagesFromDeviceID:deviceid];
                            
                        }*/
                        [peer setValue:[dictionary valueForKey:@"peername"] forKey:@"Title"];
                        [peer setValue:[dictionary valueForKey:@"peergroup"] forKey:@"PeerGroup"];
                        [peer setValue:[dictionary valueForKey:@"photomd5"] forKey:@"PhotoMD5"];
                    }
                    else{
                        
                        //[_appDelegate removeMessagesFromDeviceID:deviceid];
                        [store.peerInfo.peers removeObject:peer];
                        
                    }
                    
                    
                }
        
        if(text.length>0){
            BroadcastMessageAPI *m=[[BroadcastMessageAPI alloc] init];
            m.sender=store.peerInfo.peerID.displayName;
            m.peerInfo=store.peerInfo;
            m.fromDeviceID=store.peerInfo.deviceID;
            
            
            
            m.text=text;
            
            //[_appDelegate addNewMessage:m];
            [store addNewMessage:m];
        }
        
       
        UITabBarItem *tbi=(UITabBarItem *)[self.tabBarController.tabBar.items objectAtIndex:TAB_INDEX_CONNECT];
        //if([_appDelegate.selectedStore.peerInfo.peers count]==0)
        if(store.peerInfo!=nil && [store.peerInfo.peers count]>0)
            tbi.badgeValue=[NSString stringWithFormat:@"%lu",(unsigned long)[store.peerInfo.peers count]];
        else
            tbi.badgeValue=nil;
            
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_UPDATE_PEERS object:nil userInfo:@{@"data":dictionary}];
            
        

            
        
            
        
    }
#pragma mark BROADCAST/UNICAST
    else if([message.message_type isEqualToString:MSG_TYPE_BROADCAST]){
        {
            NSData *data=[message.text dataUsingEncoding:NSUTF8StringEncoding];
            NSError *error;
            NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
            
            NSString *action=[dict valueForKey:KEY_ACTION];
#ifdef DEBUG
            NSLog(@"KEY_ACTION=%@",action);
            
            
#endif
            if([action isEqualToString:KEY_ACTION_BROADCAST]){
                
                
                NSDictionary *info  =[dict valueForKey:KEY_ACTION_PARAM];
#ifdef DEBUG
                NSLog(@"KEY_ACTION_PARAM=%@",info);
                
                
#endif
                message.sender=[info valueForKey:KEY_BROADCAST_SENDER];
                message.senderid=[info valueForKey:KEY_BROADCAST_SENDERID];
                message.text=[info valueForKey:KEY_BROADCAST_TEXT];
                
                //[_appDelegate addNewMessage:message];
                [store addNewMessage:message];
            }
        }
    }
else{ //it's unicast or broadcast
    
#ifdef DEBUG
    NSLog(@"unicast detected");
#endif
    NSError *error;
    NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:[message.text dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:&error];
    if(error)
        return;
    
    NSString *text=[dict valueForKey:@"text"];
    
    message.isBroadcast=[[dict valueForKey:@"isBroadcast"] boolValue];
    
    message.text=text;//[dict valueForKey:@"text"];
    
    message.fromDeviceID=[dict valueForKey:@"fromDeviceID"];
    
    if ( [_appDelegate.appConfig.userInfo.blockedDevices containsObject:message.fromDeviceID ]) {
        return;
    }
    
    message.sender=[dict valueForKey:@"sender"];
    
    message.imagefileuid=[dict valueForKey:@"imagefileuid"];

    
    
  
        if ([message.fromDeviceID isEqualToString:_appDelegate.mcManager.myPeerInfo.deviceID]) {
            return;
        }
    
    
   
    
    //[_appDelegate addNewMessage:message];
    
    [store addNewMessage:message];
    
    }
}



-(void)fetchMenu:(StoreHistory *)store{
    //query menu
   /* if(store.inventory!=nil && [store.inventory.inventoryId isEqualToString:store.inventoryId]){
        return;
    }
    */
    NSMutableDictionary *request_dict=[[NSMutableDictionary alloc] init];
    
    
    
    [request_dict setValue:KEY_ACTION_INVENTORY forKey:KEY_ACTION];
    
    [request_dict setValue:KEY_ACTION_TYPE_REQUEST forKey:KEY_ACTION_TYPE];
    
    
    
    NSError *error;
    
    NSData *jsonData=[NSJSONSerialization dataWithJSONObject:request_dict options:NSJSONWritingPrettyPrinted error:&error];
    
    
    NSString *text=[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    BroadcastMessageAPI *message=[[BroadcastMessageAPI alloc] init];
    message.text=text;
    message.isBroadcast=NO;
    message.toPeerInfo=store.peerInfo;//_appDelegate.mcManager.serverPeerInfo;
    message.message_type=MSG_TYPE_REQUEST;
    message.localCopy=NO;
    
    NSDictionary *dict = @{KEY_SEND_MESSAGE: message
                           };
    
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_HAS_DATA_TO_SEND
                                                        object:nil
                                                      userInfo:dict];
}



-(void)performFileUpload:(NSString *)pathComponent fromPeer:(MCPeerID *)peer{
    if(pathComponent)
    {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        _documentsDirectory = [[NSString alloc] initWithString:[paths objectAtIndex:0]];
        //NSString * imagesPath=[AppDelegate getImagesPath];
        
        NSString *filePath = [_documentsDirectory stringByAppendingPathComponent:pathComponent];
        
        //NSLog(@"filePath=%@",filePath);
        if(![[NSFileManager defaultManager] fileExistsAtPath:filePath]){
            #ifdef DEBUG
            NSLog(@"File %@ does not exist.",filePath);
#endif
            return;
        }
        
        NSURL *resourceURL = [NSURL fileURLWithPath:filePath];
        //if([pathComponent isEqualToString:@"\myphoto"]
        
        dispatch_async(dispatch_get_main_queue(), ^{
            //NSProgress *progress =
            [_appDelegate.mcManager.session sendResourceAtURL:resourceURL
                                                                            withName:[filePath lastPathComponent]
                                                                              toPeer://[[_appDelegate.mcManager.session connectedPeers] objectAtIndex:buttonIndex]
                                                    peer
                                                               withCompletionHandler:^(NSError *error) {
                                                                   if (error) {
#ifdef DEBUG
                                                                       NSLog(@"Error: %@", [error localizedDescription]);
#endif
                                                                   }
                                                                   
                                                                   else{
                                                                       
#ifdef DEBUG
                                                                       NSLog(@"File %@ was successfully sent.",[filePath lastPathComponent]);
#endif
                                                                       /*UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"MCDemo"
                                                                                                                       message:@"File was successfully sent."
                                                                                                                      delegate:self
                                                                                                             cancelButtonTitle:nil
                                                                                                             otherButtonTitles:@"Great!", nil];
                                                                       
                                                                       [alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:NO];
                                                                       
                                                                       [_arrFiles replaceObjectAtIndex:_selectedRow withObject:_selectedFile];
                                                                       [_tblFiles performSelectorOnMainThread:@selector(reloadData)
                                                                                                   withObject:nil
                                                                                                waitUntilDone:NO];*/
                                                                   }
                                                               }];
            
            //NSLog(@"*** %f", progress.fractionCompleted);
            
           /* [progress addObserver:self
                       forKeyPath:@"fractionCompleted"
                          options:NSKeyValueObservingOptionNew
                          context:nil];*/
        });
    }
}

-(void)didReceiveDataWithNotification:(NSNotification *)notification{
    dispatch_async(dispatch_get_main_queue(), ^{
    
    //[self.soundController playSystemSound];
    BroadcastMessageAPI *message=[[BroadcastMessageAPI alloc] init];
    
        
    message.peerInfo=[[notification userInfo] objectForKey:@"peerInfo"];
    message.deviceID=_appDelegate.appConfig.userInfo.deviceID;
    message.deviceToken=_appDelegate.appConfig.userInfo.deviceToken;
    message.createdon=[NSDate date];
    
    
    NSData *receivedData = [[notification userInfo] objectForKey:@"data"];
    
    
    NSString *receivedText = [[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding];
    
    /*
    message.message_type=[receivedText substringWithRange:NSMakeRange(0, 2)];
    message.senderToken=[receivedText substringWithRange:NSMakeRange(2, 38)];
    message.text=[receivedText substringFromIndex:38];//receivedText;
    */
        NSString *senderToken_len=[receivedText substringWithRange:NSMakeRange(0, 3)];
        
        NSRange r=[senderToken_len rangeOfString:@"00"];
        
        if(r.location==NSNotFound){
            
            r=[senderToken_len rangeOfString:@"0"];
            if(r.location==0)
                senderToken_len=[senderToken_len substringFromIndex:1];
            
        }
        else{
            
            if(r.location==0)
                senderToken_len=[senderToken_len substringFromIndex:2];
            
        }
        
        int len=[senderToken_len intValue];
        
        message.senderToken=[receivedText substringWithRange:NSMakeRange(3, len)];
        message.message_type=[receivedText substringWithRange:NSMakeRange(len+3, 2)];
        message.text=[receivedText substringFromIndex:(len+3+2)];//receivedText;
    
    message.sender= message.peerInfo.peerID.displayName;
       
    
#ifdef DEBUG
        NSLog(@"receivedText=%@",receivedText);
        NSLog(@"message.senderToken=%@",message.senderToken);
        NSLog(@"message.text=%@",message.text);
        
#endif
        
    [self performMessageReceived:message];
   });
    
    
}

-(void)didReceiveAlertNotification:(NSString *)data{//:(NSNotification *)notification{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        BroadcastMessageAPI *message=[[BroadcastMessageAPI alloc] init];
        message.peerInfo=nil;//[[notification userInfo] objectForKey:@"peerInfo"];
        message.deviceID=_appDelegate.appConfig.userInfo.deviceID;
        message.deviceToken=_appDelegate.appConfig.userInfo.deviceToken;
        message.createdon=[NSDate date];
        //message.peerInfo.peerID = [[notification userInfo] objectForKey:@"peerID"];
        // NSString *peerDisplayName = message.peerInfo.peerID.displayName;
        
        
       // NSData *receivedData = [[notification userInfo] objectForKey:@"data"];
        
        
       // NSString *receivedText = [[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding];
        
        message.message_type=[data substringWithRange:NSMakeRange(0, 2)];
        message.senderToken=[data substringWithRange:NSMakeRange(2, 36)];
        
        message.sender= [data substringWithRange:NSMakeRange(38, 24)];
       // [data substringWithRange:nsmake];
        
        message.text=[data substringFromIndex:62];//receivedText;
        
        
        
        [self performMessageReceived:message];
        //  [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_messages.count-1  inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        //[_tableView performSelector:@"reloadData" withObject:nil afterDelay:<#(NSTimeInterval)#>]
        
        //server side only
        //send notification
    });
    
    
}


-(void)didReceiveControlDataWithNotification:(NSNotification *)notification{
    //MCPeerID *peerID = [[notification userInfo] objectForKey:@"peerID"];
    //NSString *peerDisplayName = peerID.displayName;
    //NSUInteger msgid = (NSInteger)[[notification userInfo] objectForKey:@"msgid"];
    NSData *receivedData = [[notification userInfo] objectForKey:@"data"];
    
    
    NSString *receivedText = [[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding];
    if([receivedText isEqualToString:@"BYE"]){
        
    }
    //[_tvChat performSelectorOnMainThread:@selector(setText:) withObject:[_tvChat.text stringByAppendingString:[NSString stringWithFormat:@"%@ wrote:\n%@\n\n", peerDisplayName, receivedText]] waitUntilDone:NO];
    
}
/*

-(void)didConnectWithNotification:(NSNotification *)notification{
    NSString *receivedText = [[notification userInfo] objectForKey:@"data"];
    [self sendMyMessage:receivedText withMessageType:MSG_TYPE_CONNECTED];
    
    
}

-(void)hasDataToSendWithNotification:(NSNotification *)notification{
    NSString *message = [[notification userInfo] objectForKey:KEY_SEND_MESSAGE];
    NSString *message_type = [[notification userInfo] objectForKey:KEY_SEND_MESSAGE_TYPE];
    [self sendMyMessage:message withMessageType:message_type];
}
*/
-(void)hasDataToSendWithNotification:(NSNotification *)notification{
    BroadcastMessageAPI *message = [[notification userInfo] objectForKey:KEY_SEND_MESSAGE];
    //NSString *message_type = [[notification userInfo] objectForKey:KEY_SEND_MESSAGE_TYPE];
    [self sendMyMessage:message];
}
/*
-(void)sendMyMessage:(NSString *)text withMessageType:(NSString *)messageType{
    if([messageType isEqualToString:MSG_TYPE_PAID_ORDER]||
       [messageType isEqualToString:MSG_TYPE_UNPAID_ORDER] ||
        [messageType isEqualToString:MSG_TYPE_REQUEST]||
       [messageType isEqualToString:MSG_TYPE_REQUEST_FILE_DOWNLOAD])
    {
        [self sendMyMessage:text withMessageType:messageType andLocalCopy:NO];
    }
    else{
        [self sendMyMessage:text withMessageType:messageType andLocalCopy:YES];
    }
}
 
-(void)sendMyMessage:(NSString *)text withMessageType:(NSString *)messageType andLocalCopy:(BOOL)localCopy{
    BroadcastMessageAPI *message=[[BroadcastMessageAPI alloc] init];
    message.createdon=[NSDate date];
    message.sender= _appDelegate.userInfo.displayName;
    message.peerInfo= _appDelegate.mcManager.myPeerInfo;
    message.deviceID=_appDelegate.userInfo.deviceID;
    message.message_type=messageType;
    message.text=text;
 */
//-(void)sendMyMessage:(NSString *)text withMessageType:(NSString *)messageType andLocalCopy:(BOOL)localCopy toPeerInfo:(PeerInfo *)toPeerInfo isBroadcast:(BOOL) isBroadcast{
-(void)sendMyMessage:(BroadcastMessageAPI *)message{
    //BroadcastMessageAPI *message=[[BroadcastMessageAPI alloc] init];
    //set missing poperties
    message.createdon=[NSDate date];
    message.sender= _appDelegate.appConfig.userInfo.displayName;
    message.fromDeviceID=_appDelegate.mcManager.myPeerInfo.deviceID;
    message.peerInfo= _appDelegate.mcManager.myPeerInfo;
    //message.toPeerInfo=toPeerInfo;
    message.deviceID=_appDelegate.appConfig.userInfo.deviceID;
    message.deviceToken=_appDelegate.appConfig.userInfo.deviceToken;
    //message.message_type=messageType;
    //message.text=text;
   // message.isBroadcast=isBroadcast;

    
    //[_appDelegate.mcManager sendMyMessage:message ];
    [_appDelegate.mcManager sendMyMessage:message toStore:_appDelegate.selectedStore];
    
        /*if([messageType isEqualToString:MSG_TYPE_PAID_ORDER]
       ||[messageType isEqualToString:MSG_TYPE_UNPAID_ORDER])
        
        message.message_celldisplay=MSG_CELLDISPLAY_NOTIFICATION;
    */
    if(message.localCopy){
       
        //[_appDelegate addNewMessage:message];
      [_appDelegate.selectedStore addNewMessage:message];
       

    }
    
    //[_tableView reloadData];
    
}


//file download/upload
-(void)didStartReceivingResourceWithNotification:(NSNotification *)notification{
    /*[_arrFiles addObject:[notification userInfo]];
    [_tblFiles performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
     */
}


-(void)updateReceivingProgressWithNotification:(NSNotification *)notification{
  //  NSProgress *progress = [[notification userInfo] objectForKey:@"progress"];
    /*
    NSDictionary *dict = [_arrFiles objectAtIndex:(_arrFiles.count - 1)];
    NSDictionary *updatedDict = @{@"resourceName"  :   [dict objectForKey:@"resourceName"],
                                  @"peerID"        :   [dict objectForKey:@"peerID"],
                                  @"progress"      :   progress
                                  };
    
    
    
    [_arrFiles replaceObjectAtIndex:_arrFiles.count - 1
                         withObject:updatedDict];
    
    [_tblFiles performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
     */
}




-(void)didFinishReceivingResourceWithNotification:(NSNotification *)notification{
    NSDictionary *dict = [notification userInfo];
    
    NSURL *localURL = [dict objectForKey:@"localURL"];
    NSString *resourceName = [dict objectForKey:resourceNameKey];
    MCPeerID *peerID=[dict objectForKey:peerIDKey];
    //NSLog(@"localURL=%@ resourceName=%@",localURL,resourceName);
    
    //NSString *destinationPath = [_documentsDirectory stringByAppendingPathComponent:resourceName];
   // NSString *destinationPath=[[AppDelegate getImagesPath] stringByAppendingPathComponent:resourceName];
    StoreHistory *store=[_appDelegate.historyModel storeWithPeerName:peerID.displayName];
    if(store==nil)
        return;
    
    NSString *destinationPath=[[AppDelegate getImagesPathForServer:store.deviceID//store.peerInfo.deviceID
                                ] stringByAppendingPathComponent:resourceName];
    /*
    if([resourceName rangeOfString:PREFIX_ATTACHMENT].location==NSNotFound ){
        destinationPath=[[AppDelegate getImagesPath] stringByAppendingPathComponent:resourceName];
    }
    else{
        destinationPath=[[AppDelegate getSharedPath] stringByAppendingPathComponent:resourceName];
    }
    */
    NSURL *destinationURL = [NSURL fileURLWithPath:destinationPath];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSError *error;
    
    if([fileManager fileExistsAtPath:destinationPath]){
        return;
        //[fileManager removeItemAtPath:destinationPath error:&error];
    }
    
    
    [fileManager copyItemAtURL:localURL toURL:destinationURL error:&error];
    
    
    if (error) {
        #ifdef DEBUG
        NSLog(@"%@", [error localizedDescription]);
#endif
    }
    else{
        //clean resource tmp
        [fileManager removeItemAtPath:localURL.path error:&error];
        /*if([resourceName rangeOfString:@"myphoto-"].location!=NSNotFound){
            //[[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_RECEIVED_PEER_PHOTO object:nil];
            [self.tblConnectedDevices reloadData];
        }
         */
         if([resourceName rangeOfString:PREFIX_MYBGPHOTO].location!=NSNotFound){
            //[[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_RECEIVED_PEER_BGPHOTO object:nil];
             [_appDelegate loadBgPhoto];
        }
        else if([resourceName rangeOfString:PREFIX_PRODUCT].location!=NSNotFound){
            /* we will just send notification to reload instead
            NSArray *prods=[store.inventory searchProductsWithPictureFile:resourceName];
            if(prods){
                for(Product *prod in prods){
                    prod.imageLoadStatus=2;
                }
                
                if(![store.inventory hasImagesLoading]){
                */
                    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_UPDATE_PRODUCT_IMAGE object:nil];
                //}
            //}
             
        }
        else if([resourceName rangeOfString:PREFIX_ATTACHMENT].location!=NSNotFound){
            //[[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_RECEIVED_PEER_BGPHOTO2 object:nil];
            /*if ([_appDelegate.messages_que count]>0) {
             
                               NSString *pathExtension=[NSString stringWithFormat:@".%@",[resourceName pathExtension] ];
                
                NSString *imagefileuid=[resourceName stringByReplacingOccurrencesOfString:PREFIX_ATTACHMENT withString:@""];
                
                imagefileuid=[imagefileuid stringByReplacingOccurrencesOfString:pathExtension withString:@""];
                
                NSPredicate *predicate=[NSPredicate predicateWithFormat:@"imagefileuid==%@",imagefileuid];
                NSArray *result=[_appDelegate.messages_que filteredArrayUsingPredicate:predicate];
                if([result count]>0){
                    NSArray *tmp_q=[_appDelegate.messages_que copy];
                    
                    for(BroadcastMessageAPI *message in tmp_q){
                        [self processMessageQue:message];
                        [_appDelegate.messages_que removeObject:message];
                        
                    }
                }
            }
             */
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_UPDATE_MESSAGES object:nil];

        }
        /*else {//if([resourceName rangeOfString:PREFIX_MENU].location!=NSNotFound){
             [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_DOWNLOAD_DONE object:nil];
        }
         */
        [[NSNotificationCenter defaultCenter] postNotificationName:resourceName object:nil userInfo:@{@"resourceName":resourceName}];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_UPDATE_PRODUCT_IMAGE object:nil];
        
        [self processDownloadQue];
    }
    
    /*
    [_arrFiles removeAllObjects];
    _arrFiles = nil;
    _arrFiles = [[NSMutableArray alloc] initWithArray:[self getAllDocDirFiles]];
    
    [_tblFiles performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
     */
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
    
    //self.completeButton.enabled = YES;
}


-(void)didReceivePeerPhotoNotification:(NSNotification *)notification{
    [_tableView reloadData];
}

#pragma mark - Private method implementation
/*
-(void)peerDidChangeStateWithNotification__:(NSNotification *)notification{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self reloadConnectedDevices];
        [_tblConnectedDevices performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
        
        BOOL peersExist = ([[_appDelegate.mcManager.session connectedPeers] count] > 0);
        
        [_btnDisconnect setEnabled:!peersExist];
        
        
        
        [_txtName setEnabled:peersExist];
        
    });
    
    
    
}
 */
-(void)downloadImageFile:(NSString *)fileuid{
    //this is one photo at a time, old upload will be replaced
    NSString *peer_file=[NSString stringWithFormat:@"%@%@.png",PREFIX_ATTACHMENT,fileuid];
    //NSString *peer_bgphoto=[NSString stringWithFormat:@"mybgphoto-%@.png",_selectedPeer.deviceID];
    
    //NSString *peer_bgphoto2=[NSString stringWithFormat:@"mybgphoto2-%@.png",_selectedPeer.deviceID];
    
    NSString *filePath=[[AppDelegate getImagesPathForServer:_appDelegate.selectedStore.peerInfo.deviceID] stringByAppendingPathComponent:peer_file];
    
    //NSString *file2Path=[[AppDelegate getImagesPath] stringByAppendingPathComponent:peer_bgphoto];
    
    // NSString *file3Path=[[AppDelegate getImagesPath] stringByAppendingPathComponent:peer_bgphoto2];
    
    //NSMutableString *files=[NSMutableString string];
    //NSMutableArray *fileUploads=[NSMutableArray new];
    
    //check if cached
    if([[NSFileManager defaultManager] fileExistsAtPath:filePath])
        return;
    
    
    NSString *serverPath=[NSString stringWithFormat:@"/%@",peer_file];
    
    
    //if(serverPath!=nil){
        
        BroadcastMessageAPI *message=[[BroadcastMessageAPI alloc] init];
        message.text=serverPath;
        message.message_type=MSG_TYPE_REQUEST_FILE_DOWNLOAD;
    
        message.toPeerInfo=_appDelegate.selectedStore.peerInfo;
        message.isBroadcast=NO;
        [self sendMyMessage:message];
        
   // }
}

#pragma mark PROCESS RECEIVED SERVER  INFO
-(void)didReceiveServerInfo:(StoreHistory *)store{
    
    //if(_appDelegate.selectedStore.peerInfo.device_status==DEVICE_STATUS_LIVE)
    if(store.isLive)
        [Stripe setDefaultPublishableKey:store.peerInfo.paymentPublishableKey];
    else
        [Stripe setDefaultPublishableKey:store.peerInfo.paymentPublishableKeyTest];
    
    //HistoryModel *historyModel=[HistoryModel sharedInstance];
    //historyModel.filename=_appDelegate.selectedStore.peerInfo.deviceID;
    
    //NSPredicate *predicate=[NSPredicate predicateWithFormat:@"storeId=%@",_appDelegate.selectedStore.peerInfo.deviceID];
    //NSArray *stores=[_appDelegate.historyModel.history filteredArrayUsingPredicate:predicate];
    //if([stores count]>0){
        //_appDelegate.selectedStore=[_appDelegate.historyModel storeWithStoreID:store.peerInfo.deviceID];//[stores firstObject];
    //}
    /*
    if(_appDelegate.selectedStore==nil){
    
        StoreHistory *existing_store=[_historyModel storeWithStoreID:_appDelegate.selectedStore.peerInfo.deviceID];
        if(existing_store==nil)
            return;
        
        //StoreHistory *newStoreHistory=[StoreHistory new];
        //existing_store.storeId=_appDelegate.selectedStore.peerInfo.deviceID;
        existing_store.storeNum=_appDelegate.selectedStore.peerInfo.device_num;
      */
        //existing_store.storeName=_appDelegate.selectedStore.peerInfo.peerID.displayName;
        
        //newHistory.days=[NSMutableArray new];
        //newStoreHistory.orders=[NSMutableArray new];
    [_appDelegate.historyModel addOrUpdateStoreHistory:store];//existing_store];
        //_appDelegate.selectedStore=existing_store;
    //}
    
    //[historyModel loadHistory];
    UITabBarItem *tbi=(UITabBarItem *)[self.tabBarController.tabBar.items objectAtIndex:TAB_INDEX_CONNECT];
    
    
    if(store.peerInfo!=nil && [store.peerInfo.peers count]>0)
        tbi.badgeValue=[NSString stringWithFormat:@"%lu",(unsigned long)[store.peerInfo.peers count]];
    else
        tbi.badgeValue=nil;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_UPDATE_PEERS object:nil];
    
    //[[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_RECEIVED_SERVERINFO object:nil];
    
    
   
    //[self.tabBarController setSelectedIndex:TAB_INDEX_MENU];
    [self failPendingOrders:store];
    
    
    
    
   
    
    
    
    [self loadServerBgPhoto:store];
    [self loadServerPhoto:store];
    
    //if([store.inventoryId isEqualToString:<#(nonnull NSString *)#>])
    //if(store.inventory==nil || ![store.inventory.inventoryId isEqualToString:store.inventoryId]){
        [self fetchMenu:store];
    //}
    
    //[self processDownloadQue ];
}

-(void)loadServerBgPhoto:(StoreHistory *)store{
    NSString *photo=[NSString stringWithFormat:@"%@%@.png",PREFIX_MYBGPHOTO, store.peerInfo.deviceID];
    NSString *localPath=[[AppDelegate getImagesPathForServer:store.peerInfo.deviceID] stringByAppendingPathComponent:photo];
    
    
    if(![[NSFileManager defaultManager] fileExistsAtPath:localPath]){
        [self addDownloadQue:photo];
    }
    else{
        [_appDelegate loadBgPhoto];
    }

}
-(void)loadServerPhoto:(StoreHistory *)store{
    //load server photo and bg
    NSString *photo=[NSString stringWithFormat:@"%@%@.png",PREFIX_MYPHOTO,store.peerInfo.deviceID];
    
    NSString *localPath=[[AppDelegate getImagesPathForServer:store.peerInfo.deviceID] stringByAppendingPathComponent:photo];
    
    
    if(![[NSFileManager defaultManager] fileExistsAtPath:localPath]){
        [self addDownloadQue:photo];
    }
}

-(void)addDownloadQue:(NSString *)filename{
    if(_appDelegate.downloadQue==nil)
        _appDelegate.downloadQue=[NSMutableArray new];
    //NSPredicate *p=[NSPredicate predicateWithFormat:@""]
    //check if cached
    //[fileUploads addObject:[NSString stringWithFormat:@"/%@",peer_bgphoto]];
    
    
    
    if([_appDelegate.downloadQue containsObject:filename])
        return;
    
    NSString *localPath=[[AppDelegate getImagesPathForServer:_appDelegate.selectedStore.peerInfo.deviceID] stringByAppendingPathComponent:filename];
    
    if(![[NSFileManager defaultManager] fileExistsAtPath:localPath]){
        
        //[fileUploads addObject:[NSString stringWithFormat:@"/%@",peer_photo]];
        if([_appDelegate.downloadQue count]>100){ //max que
            
            [_appDelegate.downloadQue removeObjectAtIndex:0];
        }
        
        [_appDelegate.downloadQue addObject:filename];
        
        //if([_appDelegate.downloadQue count]>0){
         //   [_appDelegate.downloadQue addObject:filename];
#if DEBUG
            NSLog(@"Add %@. Remaining: %lu",filename,(unsigned long)[_appDelegate.downloadQue count]);
#endif
        //}
        //else
        if([_appDelegate.downloadQue count]==1)
            [self processDownloadQue];
    }
    
}
-(void)processDownloadQue{
    //download images one at a time
    if([_appDelegate.downloadQue count]==0)
        return;
    

    
    NSString *serverPath=[NSString stringWithFormat:@"/%@",[_appDelegate.downloadQue objectAtIndex:0]];
    
#if DEBUG
    NSLog(@"Start download %@. Remaining %lu",serverPath, (unsigned long)[_appDelegate.downloadQue count]);
#endif
    
    [_appDelegate.downloadQue removeObjectAtIndex:0];
    
    //if(serverPath!=nil){
        
        BroadcastMessageAPI *message=[[BroadcastMessageAPI alloc] init];
        message.text=serverPath;
        message.message_type=MSG_TYPE_REQUEST_FILE_DOWNLOAD;
        message.toPeerInfo=_appDelegate.selectedStore.peerInfo;
        message.isBroadcast=NO;
        [self sendMyMessage:message];
        
    //}

}

-(void)peerDidChangeStateWithNotification:(NSNotification *)notification{
        dispatch_async(dispatch_get_main_queue(), ^{
    
    //[self.tblConnectedDevices performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
            [_tableView reloadData];
    
    MCSessionState state = [[[notification userInfo] objectForKey:stateKey] intValue];
    PeerInfo *peerInfo=[[notification userInfo] objectForKey:peerInfoKey];
            if(peerInfo==nil){
#ifdef DEBUG
                NSLog(@"peerInfo==nil");
#endif
                return;

            }

            
#ifdef DEBUG
            NSLog(@"peerDidChangeStateWithNotification");
            NSLog(@"state=%ld",(long)state);
            
#endif
            StoreHistory *store=[_appDelegate.historyModel storeWithPeerName:peerInfo.peerID.displayName];
    if(store==nil)
        return;
            
    //if(_appDelegate.selectedStore.peerInfo!=nil)
            store.peerInfo.sessionState=state;
    
    if (state == MCSessionStateConnected) {
        //connectToPeerInfo=nil;
        //[_appDelegate.mcManager.browser stopBrowsingForPeers];
        if(![_appDelegate.selectedStore isEqual:store])
            _appDelegate.selectedStore=store;
        
        store.isConnected=YES;
        store.autoConnect=YES;
        [self performConnected:notification];
        
    }
    else if(state==MCSessionStateNotConnected){
        store.isConnected=NO;
        //[_appDelegate.mcManager.browser startBrowsingForPeers];
        if (_audioProcessor)
            [_audioProcessor stop];
        
       // NSString *server=@"Unknown";
        
        
        if(store.peerInfo.peers!=nil){
            
            //if(store.peerInfo.peerID!=nil){
            
            //}
            
            [store.peerInfo.peers removeAllObjects];
        }
        
        NSString *server=store.peerInfo.peerID.displayName;
        [AppDelegate toast:[NSString stringWithFormat:@"You're disconnected from %@",server] duration:1];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_UPDATE_PEERS object:nil];
        /*[self.navigationController popToRootViewControllerAnimated:YES];
        
        long l=(long)MCSessionStateConnected;
        NSPredicate *predicate=[NSPredicate predicateWithFormat:@"sessionState==%ld",l];
        
        connectedDevices= [[_appDelegate.mcManager.peerDevices filteredArrayUsingPredicate:predicate] mutableCopy];
        */
        /*
        UITabBarItem *tbi=(UITabBarItem *)[self.tabBarController.tabBar.items objectAtIndex:TAB_INDEX_CONNECT];
        
        int intBadgeValue=0;
        if(tbi.badgeValue!=nil && tbi.badgeValue.length>0){
            int intBadgeValue=[tbi.badgeValue integerValue];
            intBadgeValue--;
        }
        if(intBadgeValue>0){
            tbi.badgeValue=[NSString stringWithFormat:@"%i",intBadgeValue];
        }
        else{
            tbi.badgeValue=nil;
        }
        */
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_MCDIDCHANGESTATE_DISCONNECTED object:nil];
        
        //[AppDelegate toast:[NSString stringWithFormat:@"You're disconnected from %@",server] duration:1];
       
        
        //connect whe connectToPeer is set
        
        /*[_appDelegate.mcManager.browser startBrowsingForPeers];
#ifdef DEBUG
        NSLog(@"Disconnected. Start browsing for peers re-started.");
#endif
*/
/*
        if(connectToPeerInfo!=nil){
         //MBProgressHUD* hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
         //hud.labelText = NSLocalizedString(@"               ", nil);
         //[self performSelector:@selector(connectAfterDelay:) withObject:connectToPeerInfo afterDelay:3.0];
            [self connectToPeer:connectToPeerInfo];
         }
  */
    }
    else{
        store.isConnected=NO;
#ifdef DEBUG
        NSLog(@"state=%ld",(long)state);
#endif
        
        
    }
    
        });
    
}

-(void)browser:(MCNearbyServiceBrowser *)browser foundPeer:(MCPeerID *)peerID withDiscoveryInfo:(NSDictionary *)info{
    dispatch_async(dispatch_get_main_queue(), ^{
    
       
        
    
//#ifdef DEBUG
//    NSLog(@"[info valueForKey:info]=%@",[info valueForKey:@"info"]);
//#endif
        NSString *base64String=[info valueForKey:@"info"];
        
#ifdef DEBUG
        NSLog(@"base64String=%@",base64String);
#endif
        
        NSData *base64Data=[[NSData alloc] initWithBase64EncodedString:base64String options:0];
        
        NSError *error;
        NSData *decryptedData = [RNDecryptor decryptData:base64Data
                                            withPassword:A_SECRET_PASSWORD
                                                   error:&error];
        
        if(error!=nil)
            return;
        
            NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:decryptedData options:NSJSONReadingMutableContainers error:&error];
    if(error)
        return;
    
        NSString *deviceID=DICT_GET(dict,deviceIDKey);
        NSString *deviceName=peerID.displayName; //DICT_GET(dict,deviceNameKey);
        int deviceNum=DICT_GET_INT(dict,deviceNumKey);
        int authType=DICT_GET_INT(dict,authTypeKey);
        /*float lat;
        float lng;
        NSString *location=DICT_GET(dict,locationKey);
        if(location!=nil && location.length>0){
           NSArray* arr=[location componentsSeparatedByString:@","];
            if([arr count]==2){
                lat=
            }
        }
         */
        NSString *inventoryId=@"";//DICT_GET(dict,INVENTORYID_KEY);
         BOOL isLive=[DICT_GET(dict,isLiveKey) boolValue];
        
         //NSDictionary *dict=@{@"deviceID":peerID.displayName,@"isLive":@NO};
        StoreHistory *store=[_appDelegate.historyModel storeWithStoreID:deviceID];
        
        if(store==nil){
            store=[[StoreHistory alloc] init];
            store.peerInfo=[[PeerInfo alloc] init];
            store.deviceID=deviceID;
            store.storeNum=deviceNum;
            
            
        }
        else{
            
            if(store.peerInfo==nil){
                store.peerInfo=[[PeerInfo alloc] init];
                
            
            }
            
        }
        
        store.authType=authType;
        store.storeName=deviceName;
        store.storeNum=deviceNum;
        store.isLive=isLive;
        store.isNear=YES;
        store.inventoryId=inventoryId;
        store.peerInfo.deviceID=deviceID;
        store.peerInfo.peerID=peerID;
        
        if([_appDelegate.historyModel.history objectForKey:store.deviceID]==nil){
            [_appDelegate.historyModel.history setObject:store forKey:store.deviceID];
        }
        
        //[_appDelegate.historyModel saveHistory];
   
   /*
    if([_appDelegate.mcManager.peerDevices containsObject:store.peerInfo]){
        NSInteger indexOfPeer = [_appDelegate.mcManager.peerDevices indexOfObject:store.peerInfo];
        PeerInfo *existing=[_appDelegate.mcManager.peerDevices objectAtIndex:indexOfPeer];
        existing.peerID=peerID;
        
    }
    else{
        
        [_appDelegate.mcManager.peerDevices addObject:store.peerInfo];
    }
    */
        
    
    /*[_appDelegate.mcManager.session nearbyConnectionDataForPeer:peerID withCompletionHandler:^(NSData *connectionData,
     NSError *error){
     NSDictionary *peer_connectionData=( NSDictionary *)[NSKeyedUnarchiver unarchiveObjectWithData:connectionData];
     //NSString *home_url=[peer_connectionData valueForKey:@"home_url"];
     newPeer.homeUrl=[peer_connectionData valueForKey:@"home_url"];
     
     }];
     */
    
    
    
    //[_tableView reloadData];
        
        if(store.autoConnect && _appDelegate.appConfig.isLive==store.isLive && store.peerInfo.sessionState==MCSessionStateNotConnected){
            _appDelegate.selectedStore=store;
            [self connectToPeer:store.peerInfo];
        }
         
        [self reloadData];
    //[_tblConnectedDevices performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
//    if([_appDelegate.selectedStore.peerInfo isEqual:store.peerInfo]){
//        //if(_appDelegate.inventory!=nil && [[_appDelegate.selectedStore.inventory_dict valueForKey:deviceIDKey] isEqualToString:newPeer.deviceID]){
//        if(_appDelegate.selectedStore.peerInfo.sessionState==MCSessionStateNotConnected){
//            // [self performSelectorOnMainThread:@selector(connectToPeer:) withObject:newPeer waitUntilDone:NO];
//            /*
//            UIAlertView *toast=[[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"Connecting to %@",newPeer.peerID.displayName] delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
//            [toast show];
//            //int duration=2;
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2.0 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
//                [toast dismissWithClickedButtonIndex:0 animated:YES];
//                [self connectToPeer:newPeer];
//            });
//            */
//            [AppDelegate toast:[NSString stringWithFormat:@"Connecting to %@",store.peerInfo.peerID.displayName]  duration:2.0];
//            [self connectToPeer:store.peerInfo];
//        }
//    }

    });
    
}

//-(void)browser__:(MCNearbyServiceBrowser *)browser foundPeer:(MCPeerID *)peerID withDiscoveryInfo:(NSDictionary *)info{
//    dispatch_async(dispatch_get_main_queue(), ^{
//        
//        
//        //NSString *stringData;
//        
//        //if (SECURED) {
//#ifdef DEBUG
//        NSLog(@"[info valueForKey:info]=%@",[info valueForKey:@"info"]);
//#endif
//        NSString *base64String=[info valueForKey:@"info"];
//        
//#ifdef DEBUG
//        NSLog(@"base64String=%@",base64String);
//#endif
//        NSData *base64Data=[[NSData alloc] initWithBase64EncodedString:base64String options:0];
//        
//        NSError *error;
//        NSData *decryptedData = [RNDecryptor decryptData:base64Data
//                                            withPassword:A_SECRET_PASSWORD
//                                                   error:&error];
//        
//        if(error!=nil)
//            return;
//        
//        //stringData=[[NSString alloc] initWithData:decryptedData encoding:NSUTF8StringEncoding];
//        /* }
//         else{
//         
//         stringData=[info valueForKey:@"info"];
//         }*/
//        /*#ifdef DEBUG
//         NSLog(@"stringData=%@",stringData);
//         #endif
//         */
//        /*NSArray *infoos=[stringData componentsSeparatedByString:@","];
//         
//         if([infoos count]!=9)
//         return;
//         */
//        //NSData *data=[stringData dataUsingEncoding:NSUTF8StringEncoding];
//        // NSError *error;
//        NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:decryptedData options:NSJSONReadingMutableContainers error:&error];
//        if(error)
//            return;
//        
//        
//        PeerInfo *newPeer=[[PeerInfo alloc] init];
//        newPeer.sessionState=MCSessionStateNotConnected;
//        
//        
//        newPeer.deviceID=DICT_GET(dict,@"deviceID");//[infoos objectAtIndex:0];
//        
//        //newPeer.device_status=[DICT_GET(dict,@"device_status") intValue];//[[infoos objectAtIndex:8] integerValue];
//        
//        newPeer.isLive=[DICT_GET(dict,@"isLive") boolValue];
//        
//        //show if live and peer is live
//        //int deviceStatus=[device_status integerValue];
//        //if (newPeer.device_status==DEVICE_STATUS_NOTREGISTERED || newPeer.device_status==DEVICE_STATUS_CANCELLED)
//        //   return;
//        
//        if(_appDelegate.appConfig.isLive && !newPeer.isLive)//newPeer.device_status!=DEVICE_STATUS_LIVE)
//            return;
//        
//        if(!_appDelegate.appConfig.isLive && newPeer.isLive)//newPeer.device_status==DEVICE_STATUS_LIVE)
//            return;
//        
//        newPeer.peerID=peerID;
//        
//        if([_appDelegate.mcManager.peerDevices containsObject:newPeer]){
//            NSInteger indexOfPeer = [_appDelegate.mcManager.peerDevices indexOfObject:newPeer];
//            PeerInfo *existing=[_appDelegate.mcManager.peerDevices objectAtIndex:indexOfPeer];
//            existing.peerID=peerID;
//            
//        }
//        else{
//            
//            [_appDelegate.mcManager.peerDevices addObject:newPeer];
//        }
//        
//        /*[_appDelegate.mcManager.session nearbyConnectionDataForPeer:peerID withCompletionHandler:^(NSData *connectionData,
//         NSError *error){
//         NSDictionary *peer_connectionData=( NSDictionary *)[NSKeyedUnarchiver unarchiveObjectWithData:connectionData];
//         //NSString *home_url=[peer_connectionData valueForKey:@"home_url"];
//         newPeer.homeUrl=[peer_connectionData valueForKey:@"home_url"];
//         
//         }];
//         */
//        
//        
//        
//        [_tableView reloadData];
//        //[_tblConnectedDevices performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
//        if(newPeer.sessionState==MCSessionStateNotConnected){
//            if(_appDelegate.inventory!=nil && [[_appDelegate.selectedStore.inventory_dict valueForKey:deviceIDKey] isEqualToString:newPeer.deviceID]){
//                // [self performSelectorOnMainThread:@selector(connectToPeer:) withObject:newPeer waitUntilDone:NO];
//                UIAlertView *toast=[[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"Connecting to %@",newPeer.peerID.displayName] delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
//                [toast show];
//                //int duration=2;
//                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2.0 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
//                    [toast dismissWithClickedButtonIndex:0 animated:YES];
//                    [self connectToPeer:newPeer];
//                });
//                
//            }
//        }
//        
//    });
//    
//}


-(void)browser:(MCNearbyServiceBrowser *)browser didNotStartBrowsingForPeers:(NSError *)error{
    /*
    NSString *message=[error localizedDescription];
    UIAlertView *toast=[[UIAlertView alloc] initWithTitle:nil message:message delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
    [toast show];
    int duration=2;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, duration * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [toast dismissWithClickedButtonIndex:0 animated:YES];
    });
     */
    [AppDelegate toast:[error localizedDescription] duration:2.0];
}

-(void)browser:(MCNearbyServiceBrowser *)browser lostPeer:(MCPeerID *)peerID{
    StoreHistory *store=[_appDelegate.historyModel storeWithPeerName:peerID.displayName];
    if(store==nil)
        return;
    store.isNear=NO;
    //PeerInfo *lostPeer=[[PeerInfo alloc] initWithPeerID:peerID];
    
        //if([_appDelegate.mcManager.peerDevices containsObject:lostPeer]){
           /* NSInteger indexOfPeer = [_appDelegate.mcManager.peerDevices indexOfObject:store.peerInfo];
                [_appDelegate.mcManager.peerDevices removeObjectAtIndex:indexOfPeer];
            */
            [_tableView reloadData];
        
            /*if (state != MCSessionStateConnecting) {
                if (state == MCSessionStateConnected) {
                    
                    
                    peerInfo.sessionState=MCSessionStateConnected;
                    if(![_session isEqual:session])
                        _session=session;
                }
                else if (state == MCSessionStateNotConnected){
                    peerInfo.sessionState=MCSessionStateNotConnected;
                }
              */
                
                /*
                NSDictionary *dict = @{@"peerInfo": lostPeer,
                                       @"state" : [NSNumber numberWithInt:MCSessionStateNotConnected]
                                       };
                
                [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_MCDIDCHANGESTATE
                                                                    object:nil
                                                                  userInfo:dict];
                */
            //}

            
            UITabBarItem *tbi=(UITabBarItem *)[self.tabBarController.tabBar.items objectAtIndex:TAB_INDEX_CONNECT];
            
            if(store.peerInfo!=nil && [store.peerInfo.peers count]>0)
                tbi.badgeValue=[NSString stringWithFormat:@"%lu",(unsigned long)[store.peerInfo.peers count]];
            else
                tbi.badgeValue=nil;
        

        //}
    
}

//
//
//
//- (IBAction)actionDone:(id)sender {
//    //[self.delegate browserViewControllerDidFinish:self];
//}
//
//
//- (IBAction)actionCancel:(id)sender {
//    //[self.delegate browserViewControllerWasCancelled:self];
//}

- (void)pickerDoneButtonPressed {
    [self.view endEditing:YES];
    //if([self.completeButton isHidden])
     //   [self.completeButton setHidden:NO];
}

-(void)startTimer{
    
    if(browseTimer!=nil){
        [browseTimer invalidate];
        browseTimer=nil;
    }
    
    browseStarted=YES;
    [self.nearbyIndicator startAnimating];
    [_appDelegate.mcManager.browser startBrowsingForPeers];
    
    browseTimer=[NSTimer scheduledTimerWithTimeInterval:10.0 target:self selector:@selector(onStartStopBrowser:) userInfo:nil repeats:YES];
    
    
}
-(void)stopTimer{
    [self.nearbyIndicator stopAnimating];
    browseStarted=NO;
    if(browseTimer!=nil){
        [browseTimer invalidate];
        browseTimer=nil;
    }
    
    
}

- (IBAction)toggleLiveTapped:(id)sender {
    
   
    
    if(_toggleLive.isOn) {
        
        _appDelegate.appConfig.isLive=YES;
        
        
        
    }
    else{
        _appDelegate.appConfig.isLive=NO;
    }
    
    if(_appDelegate.appConfig.isLive){
        _chooseLabel.text=@"Choose a LIVE Kiosk";
    }
    else{
        _chooseLabel.text=@"Choose a TEST Kiosk";
    }
    
    [self reloadData];
    
    [self startTimer];
    

}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:NOTIFY_SHOW_MAP2]){
        Map2ViewController *map2=segue.destinationViewController;
        map2.delegate=self;
    }
    else if([segue.identifier isEqualToString:NOTIFY_SHOW_MAP]){
        //NSString *mapUrl;
       ///if(_appDelegate.appConfig.isLive)
            //http://www.sharecle.com/superkiosk/map/live
          NSString *mapUrl  =[NSString stringWithFormat:@"%@%@?islive=%@&isphone=%@",ServerURL, MAP_URL,(_appDelegate.appConfig.isLive)?@"1":@"0",(_appDelegate.isIpad)?@"0":@"1"];
        //else
       ///     mapUrl=MAP_TEST_URL;
        //NSURL *urll=[NSURL URLWithString:mapUrl];
       // NSURLRequest *req=[NSURLRequest requestWithURL:urll];
        
        MapViewController *vc=segue.destinationViewController;
        vc.url=mapUrl;
    }
}
//-(void)webViewDidFinishLoad:(UIWebView *)webView{
//    [[self.view viewWithTag:100] setHidden:YES];
//    
//    /*CGRect frame = webView.frame;
//    frame.size.height = 1;
//    webView.frame = frame;
//    CGSize fittingSize = [webView sizeThatFits:CGSizeZero];
//    frame.size = fittingSize;
//    webView.frame = frame;
//    
//    //NSLog(@"size: %f, %f", fittingSize.width, fittingSize.height);
//    
//    //yourScrollView.contentSize = webView.bounds.size;
//    //webView.superview.scr scrollView.contentSize=webView.bounds.size;
//    */
//    NSString *result = [self.mapWebView  stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight;"];
//    
//    NSInteger height = [result integerValue];
//    
//    CGRect frame= self.mapView.frame;
//    frame.size.height=height;
//    self.mapView.frame=frame;
//    
//    [self.mapWebView setHidden:NO];
//    
//    
//}
/*
-(void)reloadMap{
    //if([[self.view viewWithTag:100] isHidden]){
        [[self.view viewWithTag:100] setHidden:NO];
        [self.mapWebView setHidden:YES];
        NSString *mapUrl;
        if(_appDelegate.appConfig.isLive)
            mapUrl=MAP_LIVE_URL;
        else
            mapUrl=MAP_TEST_URL;
        NSURL *urll=[NSURL URLWithString:mapUrl];
        NSURLRequest *req=[NSURLRequest requestWithURL:urll];
        //self.mapWebView.delegate=self;
        [self.mapWebView loadRequest:req];
   // }
}
*/
#pragma mark PENDING ORDER
-(void)didReceivedNewOrderNotification:(NSNotification *)notication{
    dispatch_async(dispatch_get_main_queue(), ^{
        OrderHistory *order=[notication.userInfo valueForKey:@"order"];
        [self processPendingOrder:order];
    });
}
-(void)processPendingOrder:(OrderHistory *)order{
    //dispatch_async(dispatch_get_main_queue(), ^{
    if(_appDelegate.selectedStore.peerInfo.sessionState!=MCSessionStateConnected){
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Not Connected Error" message:@"Please connect and try again." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        order.orderStatus=@ORDER_STATUS_FAILED;
        return;
    }
    if(order==nil)
        order=[_appDelegate.historyModel searchPendingOrderWithStore:_appDelegate.selectedStore isLive:_appDelegate.appConfig.isLive];
    if(order!=nil){
        [order completeCharge];
    };
    //});
    
}
-(void)failPendingOrders:(StoreHistory *)store{
    //if(_appDelegate.selectedStore!=nil){
        /*
        NSArray *failed_orders=[_appDelegate.historyModel searchPendingOrdersWithStore:_appDelegate.selectedStore isLive:order.orderIsLive];
        if([failed_orders count]>0){
            //[AppDelegate toast:[NSString stringWithFormat:@"You still have pending %@orders for %@. Please cancel order and try again.",(order.orderIsLive)?@"":@"TEST ",selectedStoreHistory.storeName] duration:5];
            //return;
            for (int i=0; i<[failed_orders count]; i++) {
                [_appDelegate.selectedStore.orders removeObject:failed_orders[i]];
                
            }
            [_appDelegate.historyModel saveHistory];
        }
         */
        
    NSArray *pending_orders=[_appDelegate.historyModel searchPendingOrdersWithStore:store isLive:_appDelegate.appConfig.isLive];
    if([pending_orders count]>0){
        //[AppDelegate toast:[NSString stringWithFormat:@"You still have pending %@orders for %@. Please cancel order and try again.",(order.orderIsLive)?@"":@"TEST ",selectedStoreHistory.storeName] duration:5];
        //return;
        for (int i=0; i<[pending_orders count]; i++) {
            //[selectedStoreHistory.orders removeObject:pending_orders[i]];
            ((OrderHistory *) pending_orders[i]).orderStatus=@ORDER_STATUS_FAILED;
        }
        [_appDelegate.historyModel saveHistory];
        //[AppDelegate toast:@"You have FAILED order(s). Please see order status for more details." duration:5];
        BroadcastMessageAPI *m=[[BroadcastMessageAPI alloc] init];
        m.sender=store.peerInfo.peerID.displayName;
        m.peerInfo=store.peerInfo;
        m.fromDeviceID=store.peerInfo.deviceID;
        
        
        
        m.text=@"You have FAILED order(s). Please see order status for details.";
        
        //[_appDelegate addNewMessage:m];
        [store addNewMessage:m];
    }
    //}
    
}


-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{

    NSString *title=[alertView buttonTitleAtIndex:buttonIndex];
    if([title isEqualToString:@"Disconnect"]){
        [_appDelegate.mcManager.session disconnect];
        //_appDelegate.inventory=nil;
        /*connectToPeerInfo=nil;
        _appDelegate.mcManager.serverPeerInfo=nil;
         */
      //  [self initBrowsing];
    }
    else if([title isEqualToString:@"Continue"]){
        
        //if(_appDelegate.selectedStore.peerInfo.sessionState==MCSessionStateConnected){
            [_appDelegate.mcManager.session disconnect];
       // }
        //else{
            //_appDelegate.mcManager.serverPeerInfo=connectToPeerInfo;
            [self connectToPeer:_appDelegate.selectedStore.peerInfo];
        //}
        //ROM: the disconnect event will connect to connectToPeerInfo if not nil
        
    }
    else if([title isEqualToString:@"Authenticate"]){
        
        UITextField * alertTextField = [alertView textFieldAtIndex:0];
        //if(alertTextField.text.length>0){
        if ([alertTextField.text isEqualToString:_appDelegate.appConfig.userInfo.PIN]) {
            [self performValidSelection:_appDelegate.selectedStore];
        }
        
        else{
            if(_appDelegate.appConfig.userInfo.PINRetry<=10){
                _appDelegate.appConfig.userInfo.PINRetry++;
            }
            else{
                //_appDelegate.appConfig.userInfo.PIN=nil;
                UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Max of 5 attempts exceeded." message:@"PIN has been disabled." delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
                [alert show];
            }
        }
    }
}

-(void)performConnected:(NSNotification *)notification{
//-(void)performConnected:(StoreHistory *)store{
    //dispatch_async(dispatch_get_main_queue(), ^{
    //StoreHistory *store=_appDelegate.selectedStore;
         if (_appDelegate.appConfig.userInfo.announceText.length>0) {
         
         
         
         BroadcastMessageAPI *m=[[BroadcastMessageAPI alloc] init];
         
         m.text=@"Hi!";//[_txtMessage.attributedText string];
         
         //m.imagefileuid=imagefileuid;
         m.fromDeviceID=_appDelegate.mcManager.myPeerInfo.deviceID;
         m.message_type=MSG_TYPE_DEF;
         m.localCopy=YES;
         
         
         
         m.isBroadcast=YES;
         m.recipient=@"everyone";
         
         
         /*[_appDelegate addNewMessage:m];
         
         
         NSDictionary *dict = @{KEY_SEND_MESSAGE: m
         };
         
         
         [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_HAS_DATA_TO_SEND
         object:nil
         userInfo:dict];
         */
             [self sendMyMessage:m];
         //AudioServicesPlaySystemSound(1004); //smssent
             [self.tabBarController setSelectedIndex:TAB_INDEX_MENU];
         }
         
         BroadcastMessageAPI *message=[[BroadcastMessageAPI alloc] init];
         //message.text=serverPath;
    if(_appDelegate.selectedStore.peerInfo!=nil){
        
         message.message_type=MSG_TYPE_REQUEST_SERVERINFO;
        message.toPeerInfo=_appDelegate.selectedStore.peerInfo;//_appDelegate.selectedStore.peerInfo;
         message.isBroadcast=NO;
         [self sendMyMessage:message];
        [self performValidSelection:_appDelegate.selectedStore];
    }
    
         //[AppDelegate clearTmpExceptForServer:_appDelegate.selectedStore.deviceID];
    //_appDelegate.selectedStore.peerInfo.deviceID];
    
         //remove items in cart that doesnt belong to the store
         /*CheckoutCart *cart=[CheckoutCart sharedInstance];
         if([cart.itemsInCart count] >0){
         //for(OrderHistory )
         NSPredicate *p=[NSPredicate predicateWithFormat:@"storeID!=%@ AND orderIsLive!=%@",self.appDelegate.mcManager.serverPeerInfo.deviceID,@(self.appDelegate.appConfig.isLive)];
         NSArray *r=[cart.itemsInCart filteredArrayUsingPredicate:p];
         if(r.count>0)
         {
         [cart clearCart];
         }
         }
          */
         
    //});
    
    //[self showMainTabbarController];
    //[self performValidSelection:store];
}

-(void)showMainTabbarController{
    UITabBarController *vc=[_appDelegate.storyBoard instantiateViewControllerWithIdentifier:@"MainTabbarController"];
    [self presentViewController:vc animated:YES completion:nil];
    
    //[self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark BLUETOOTH
- (void)detectBluetooth
{
//    if(!self.bluetoothManager)
//    {
//        // Put on main queue so we can call UIAlertView from delegate callbacks.
//        self.bluetoothManager = [[CBCentralManager alloc] initWithDelegate:self queue:dispatch_get_main_queue()] ;
//    }
//    [self centralManagerDidUpdateState:self.bluetoothManager]; // Show initial state
//    
}

//- (void)centralManagerDidUpdateState:(CBCentralManager *)central
//{
   /* NSString *stateString = nil;
    switch(self.bluetoothManager.state)
    {
        case CBCentralManagerStateResetting: stateString = @"The connection with the system service was momentarily lost, update imminent."; break;
        case CBCentralManagerStateUnsupported: stateString = @"The platform doesn't support Bluetooth Low Energy."; break;
        case CBCentralManagerStateUnauthorized: stateString = @"The app is not authorized to use Bluetooth Low Energy."; break;
        case CBCentralManagerStatePoweredOff: stateString = @"Bluetooth is currently powered off."; break;
        case CBCentralManagerStatePoweredOn: stateString = @"Bluetooth is currently powered on and available to use."; break;
        default: stateString = @"State unknown, update imminent."; break;
    }
    */
//    if(!CBCentralManagerStatePoweredOn){
//         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Bluetooth state" message:@"Please power on Bluetooth for best user experience." delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
//         [alert show];
//    }
   
   
    
    
   
//}

#pragma mark Banner delegates

- (void)bannerViewDidLoadAd:(ADBannerView *)banner

{
    
    if (!bannerIsVisible)
        
    {
        
        [UIView beginAnimations:@"animateAdBannerOn" context:NULL];
        
        // Assumes the banner view is just off the bottom of the screen.
        
        banner.frame = CGRectOffset(banner.frame, 0, -banner.frame.size.height);
        
        [UIView commitAnimations];
        
        bannerIsVisible = YES;
        
    }
    
}


-(void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error{
    if (bannerIsVisible)
        
    {
        
        [UIView beginAnimations:@"animateAdBannerOff" context:NULL];
        
        // Assumes the banner view is placed at the bottom of the screen.
        
        banner.frame = CGRectOffset(banner.frame, 0, banner.frame.size.height);
        
        [UIView commitAnimations];
        
        bannerIsVisible = NO;
        
    }
}

-(IBAction)loginButtonTapped:(id)sender{
    /*
    LoginViewController* loginController = (LoginViewController*) [ApplicationDelegate.storyBoard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:loginController];
    
    
    
    [self presentViewController:nav animated:YES completion:nil];
    //[self performSegueWithIdentifier:NOTIFY_SHOW_SETTINGS sender:self];
     */
    [self showLogin];
}

-(void)showSettings{
    AppSettingsViewController* settingsController = (AppSettingsViewController*) [ApplicationDelegate.storyBoard instantiateViewControllerWithIdentifier:@"AppSettingsViewController"];
    UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:settingsController];
    
    
    
    [self presentViewController:nav animated:YES completion:nil];
    //[self performSegueWithIdentifier:NOTIFY_SHOW_SETTINGS sender:self];
}

-(IBAction)settingsButtonTapped:(id)sender{
    [self showSettings];
}

-(IBAction)locationsButtonTapped:(id)sender{
    //[self showMap];
    
    Map2ViewController* vc = (Map2ViewController*) [ApplicationDelegate.storyBoard instantiateViewControllerWithIdentifier:@"Map2ViewController"];
    vc.delegate=self;
    UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:vc];
    
    
    
    [self presentViewController:nav animated:YES completion:nil];
     
    //[self performSegueWithIdentifier:NOTIFY_SHOW_MAP2 sender:self];

}

//-(void)showSettings{
//    AppSettingsViewController* settingsController = (AppSettingsViewController*) [ApplicationDelegate.storyBoard instantiateViewControllerWithIdentifier:@"AppSettingsViewController"];
//    UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:settingsController];
//    
//    
//    
//    [self presentViewController:nav animated:YES completion:nil];
//         //[self performSegueWithIdentifier:NOTIFY_SHOW_SETTINGS sender:self];
//}

-(void)showMap{
    
    
     //[self performSegueWithIdentifier:NOTIFY_SHOW_MAP2 sender:self];
    Map2ViewController* vc = (Map2ViewController*) [ApplicationDelegate.storyBoard instantiateViewControllerWithIdentifier:@"Map2ViewController"];
    vc.delegate=self;
    //vc.returnViewController=returnViewController;
    UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:vc];
    
    
    [self presentViewController:nav animated:YES completion:nil];
}

-(void)connectAfterDelay:(PeerInfo *)peer{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [self connectToPeer:peer];
}

-(void)didLostPeerNotification:(NSNotification *)notification{
    //    dispatch_async(dispatch_get_main_queue(), ^{
    //
    //
    //
    //        MCSessionState state = [[[notification userInfo] objectForKey:@"state"] intValue];
    //
    //        if (state == MCSessionStateConnected) {
    //
    //            /*
    //             self.navigationItem.leftBarButtonItems=@[self.broadcastButton,usersButtonItem];
    //
    //             if(_appDelegate.isIpad){
    //             self.navigationItem.rightBarButtonItems=@[menuButtonItem,ordersButtonItem,settingsButtonItem];
    //
    //             }
    //             else{
    //             self.navigationItem.rightBarButtonItems=@[menuButtonItem];
    //             }
    //             */
    //
    //
    //        }
    //        else if(state == MCSessionStateNotConnected) {
    //            [audioSwitch setOn:NO];
    //
    //            _appDelegate.isAudioON=audioSwitch.on;
    //
    //            /*
    //             self.navigationItem.leftBarButtonItems=nil;
    //             self.navigationItem.rightBarButtonItems=nil;
    //             */
    //            
    //        }
    //    });
    
}

-(void)reloadData{
     //[connectedItems removeAllObjects];
    [nearItems removeAllObjects];
    [farItems removeAllObjects];
    int totalConnected=0;
    
    _stores=[[_appDelegate.historyModel.history allValues] mutableCopy];
    
    NSMutableArray *forgotten=[NSMutableArray new];
    for(StoreHistory *store in _stores){
        if(store.isLive==_appDelegate.appConfig.isLive){
            if(store.peerInfo.sessionState==MCSessionStateConnected){
                //[connectedItems addObject:store];
                store.isConnected=YES;
                totalConnected++;
            }
            else{
                store.isConnected=NO;
            }
            if(store.isNear)
                [nearItems addObject:store];
            else{
                //we exclude forget this kiosk entry
                if(store.autoConnect)
                    [farItems addObject:store];
                else
                    [forgotten addObject:store];
            }
        }
    }
    
    if([forgotten count]>0){
        for(StoreHistory *s in forgotten){
            [AppDelegate clearTmpForServer:s.deviceID];
            [_stores removeObject:s];
        }
    }
    
    UITabBarItem *tbi=(UITabBarItem *)[self.tabBarController.tabBar.items objectAtIndex:TAB_INDEX_CONNECT];
    //if(_appDelegate.selectedStore.peerInfo!=nil && [_appDelegate.selectedStore.peerInfo.peers count]>0)
    if(totalConnected>0)
    
    {
        tbi.badgeValue=[NSString stringWithFormat:@"%i",totalConnected];
        
    }
    else{
        tbi.badgeValue=nil;
    }

    [_tableView reloadData];
    
    
    
}
/*
-(void)showLogin:(NSString *)returnViewController{
    LoginViewController* vc = (LoginViewController*) [ApplicationDelegate.storyBoard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    vc.delegate=self;
    vc.returnViewController=returnViewController;
    UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:vc];
    
    
    [self presentViewController:nav animated:YES completion:nil];
}
*/
-(void)showPin:(NSString *)returnViewController{
    /*LoginViewController* vc = (LoginViewController*) [ApplicationDelegate.storyBoard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    vc.delegate=self;
    vc.returnViewController=returnViewController;
    UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:vc];
    
    
    [self presentViewController:nav animated:YES completion:nil];
     */
}
-(void)showTouchID:(NSString *)returnViewController{
    /*LoginViewController* vc = (LoginViewController*) [ApplicationDelegate.storyBoard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    vc.delegate=self;
    vc.returnViewController=returnViewController;
    UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:vc];
    
    
    [self presentViewController:nav animated:YES completion:nil];
     */
}
/*
- (IBAction)loginButtonTapped:(id)sender {
    //[self performSegueWithIdentifier:@"toLoginViewController" sender:self];
    [self showLogin];
}
*/
/*
-(void)reloadConnectedDevices{
 
    UITabBarItem *tbi=(UITabBarItem *)[self.tabBarController.tabBar.items objectAtIndex:TAB_INDEX_CONNECT];
    if(_appDelegate.selectedStore.peerInfo!=nil && [_appDelegate.selectedStore.peerInfo.peers count]>0)
    {
        //tbi.badgeValue=[NSString stringWithFormat:@"%lu",(unsigned long)[connectedDevices count]];
        
    }
    else{
        tbi.badgeValue=nil;
    }
    
    
}
*/

-(void)onStartStopBrowser:(NSTimer *)timer{
    if(browseStarted){
        browseStarted=NO;
        [self.nearbyIndicator stopAnimating];
        [_appDelegate.mcManager.browser stopBrowsingForPeers];
        
    }
    else{
        browseStarted=YES;
        [self.nearbyIndicator startAnimating];
        [_appDelegate.mcManager.browser startBrowsingForPeers];
    }
}

- (void)authenicatewithPIN{
    UIAlertView *alert= [[UIAlertView alloc] initWithTitle:@"PIN" message:@"Enter PIN" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    [alert show];
}


- (void)authenicatewithTouchID{
    LAContext *context = [[LAContext alloc] init];
    
    NSError *error = nil;
    if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error]) {
        [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics
                localizedReason:@"Are you the device owner?"
                          reply:^(BOOL success, NSError *error) {
                              
                              if (error) {
                                  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                                  message:@"There was a problem verifying your identity."
                                                                                 delegate:nil
                                                                        cancelButtonTitle:@"Ok"
                                                                        otherButtonTitles:nil];
                                  [alert show];
                                  return;
                              }
                              
                              if (success) {
                                  /*UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success"
                                   message:@"You are the device owner!"
                                   delegate:nil
                                   cancelButtonTitle:@"Ok"
                                   otherButtonTitles:nil];
                                   [alert show];
                                   */
                                  //if(_appDelegate.selectedStore!=nil)
                                  //[self showMainTabbarController];
                                  //  [self dismissViewControllerAnimated:YES completion:nil];
                                  [self performValidSelection:_appDelegate.selectedStore];
                                  
                              } else {
                                  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                                  message:@"You are not the device owner."
                                                                                 delegate:nil
                                                                        cancelButtonTitle:@"Ok"
                                                                        otherButtonTitles:nil];
                                  [alert show];
                              }
                              
                          }];
        
    } else {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"Your device cannot authenticate using TouchID."
                                                       delegate:nil
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil];
        [alert show];
        
    }
}


-(void)showLogin{
    LoginViewController* vc = (LoginViewController*) [ApplicationDelegate.storyBoard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    vc.delegate=self;
    //vc.returnViewController=returnViewController;
    UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:vc];
    
    
    [self presentViewController:nav animated:YES completion:nil];
}

-(void)didLoginSuccess:(LoginViewController *)viewController{
    StoreHistory *store=viewController.store;
    
    if(selectedAuthType==1)
        [self performValidSelection:store];
    else{
        [self authenticate:store];
    }
}
-(void)map2didSelectStore:(Map2ViewController *)viewController withStore:(StoreHistory *)store{
   // _appDelegate.selectedStore=device;
    [viewController dismissViewControllerAnimated:YES completion:^{
        //[self showMainTabbarController];
        /*if(_appDelegate.selectedStore.authType>0){
            
            if(_appDelegate.appConfig.userInfo.userToken==nil || _appDelegate.appConfig.userInfo.userToken.length==0){
                
                switch (_appDelegate.selectedStore.authType) {
                    case 1: //basic
                        [self showLogin:ORDERCOLLECTIONSVIEWCONTROLLER];
                        
                        break;
                    case 2: //basic pin
                        [self showLogin:PINVIEWCONTROLLER];
                        break;
                    case 3: //basic bio
                        [self showLogin:TOUCHIDVIEWCONTROLLER];
                        break;
                    default:
                        break;
                }
            }
            else{
                switch (_appDelegate.selectedStore.authType) {
                    case 1: //basic
                         //[self dismissViewControllerAnimated:YES completion:nil];
                        [self performValidDeviceSelected];
                        break;
                    case 2: //basic pin
                        //[self showPin:ORDERCOLLECTIONSVIEWCONTROLLER];
                        [self authenicatewithPIN];
                        break;
                    case 3: //basic bio
                        //[self showTouchID:ORDERCOLLECTIONSVIEWCONTROLLER];
                        [self authenicatewithTouchID];
                        break;
                    default:
                        break;
                }
            }
        }
        else if(_appDelegate.selectedStore.authType==0){*/
             //[self dismissViewControllerAnimated:YES completion:nil];
        
        [self performValidSelection:store];
        /*}
        else{
            [AppDelegate toast:@"Cannot determine the authentication type." duration:3.0];
        }
        */
    }];
}


/*
-(void)didPINSuccess:(LoginViewController *)viewController returnViewController:(NSString *)returnViewController{
    
    [viewController dismissViewControllerAnimated:YES completion:^{
        if([returnViewController isEqualToString:ORDERCOLLECTIONSVIEWCONTROLLER]){
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        
    }];
    
}
-(void)didTouchIDSuccess:(LoginViewController *)viewController returnViewController:(NSString *)returnViewController{
    
    [viewController dismissViewControllerAnimated:YES completion:^{
        if([returnViewController isEqualToString:ORDERCOLLECTIONSVIEWCONTROLLER]){
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        
    }];
    
}
*/

-(void)performValidSelection:(StoreHistory *)device{
    
    if(![_appDelegate.selectedStore isEqual:device ])
        _appDelegate.selectedStore=device;
    
    if(device.isNear){// indexPath.section==0){ //near
        
        //connectToPeerInfo= store.peerInfo; //[_appDelegate.mcManager.peerDevices objectAtIndex:indexPath.row];
        
        
        
        if(device.peerInfo.sessionState==MCSessionStateConnected){
            
            [self showMainTabbarController];
            
            
        }
        else if(device.peerInfo.sessionState==MCSessionStateConnecting){
            
            UIAlertView *alert= [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"Disconnect from %@?",device.peerInfo.peerID.displayName] delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Disconnect", nil];
            [alert show];
            
        }
        
        else{
            [self connectToPeer:device.peerInfo];//[_appDelegate.mcManager.peerDevices objectAtIndex:indexPath.row]];
            
        }
        //}
    }
    else{
        //TODO: check if it's connected wireless
        //http connection
        /*dispatch_async(dispatch_get_main_queue(), ^{
         NSURL *url=[[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@/drive/%@/%@/inventory_%@.plist",ServerApiURL,_appDelegate.selectedStore.ownerId,_appDelegate.appConfig.user_folderid,_appDelegate.appConfig.device_id]];
         NSData *data=[[NSData alloc] initWithContentsOfURL:url];
         if (data!=nil) {
         [_appDelegate.inventoryModel loadInventoryWithData:data];
         //we need to call this to overwrite local copy
         [_appDelegate.inventoryModel saveInventory];
         }
         });
         */
        [Util httpGetInventoryWithStore:device];
        [self showMainTabbarController];
    }
    
}


-(void)showMenuActionSheet{
    //NSString *titleString=[_menuActionSheet buttonTitleAtIndex:3];
    // if(isListView){
    //if(![titleString isEqualToString:TITLE_THUMBVIEW]){
        _menuActionSheet=[[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:TITLE_SETTINGS,TITLE_LOGIN, nil];
   // }
    /*}
     else{
     if(![titleString isEqualToString:TITLE_LISTVIEW]){
     _menuActionSheet=[[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:TITLE_SEARCH,TITLE_BARCODE,TITLE_LISTVIEW,TITLE_DISCONNECT, nil];
     }
     }
     */
    [_menuActionSheet showFromBarButtonItem:_menuButtonItem animated:YES];
    
}
-(void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{
    NSString *title=[actionSheet buttonTitleAtIndex:buttonIndex];
    if([title isEqualToString:TITLE_SETTINGS]){
        [self showSettings];
    }
    else if([title isEqualToString:TITLE_LOGIN]){
        [self showLogin];
    }
}


@end
