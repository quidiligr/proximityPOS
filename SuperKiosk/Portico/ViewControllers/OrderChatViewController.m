//
//  FirstViewController.m
//
//
//  Created by Romulo Quidilig.
//  Copyright (c) 2015 Sharecle Inc. All rights reserved.
//

#import "OrderChatViewController.h"
#import "AppDelegate.h"
//#import "MessageNBCell.h"
//#import "MessageTableViewCell.h"
//#import "MessageTableViewData.h"
#import "BroadcastMessageAPI.h"
//#import "AppSettingsViewController.h"
//#import "MessageWithImageTableViewCell.h"
//#import "MessageWithImageAndMediaCell.h"
#import "SpeechBubbleView.h"
#import "NSData+Conversion.h"
#import "Order.h"
#import "OrderItem.h"

#import "InventoryItem.h"
#import "InventoryModel.h"

//#import "DummyViewController.h"
//#import <iAd/iAd.h>
#import "HistoryModel.h"
#import "OrderHistory.h"
//#import "SWRevealViewController.h"
#import "ChatImageOnlyCell.h"
#import "ChatTextOnlyCell.h"
#import "ChatImageOnlyCustCell.h"
#import "ChatTextOnlyCustCell.h"
#import "Util.h"
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>
//#import "PeerListViewController_iPhone.h"
//#import "ArticleListViewController_iPad.h"
//#import "NSData+Conversion.h"

#import "StoreHistory.h"
#import "CheckoutCart.h"

#import "defs.h"



//const CGFloat MinBubbleWidth = 50;   // minimum width of the bubble
//const CGFloat MinBubbleHeight = 40;  // minimum height of the bubble


//const CGFloat WrapWidth = 200;       // maximum width of text in the bubble
//const CGFloat WrapWidthIpad = 400;


@interface OrderChatViewController ()
{
    //UIFont* font;
    //NSArray *paths;
    UIImage *_myPhoto;
    UITabBarItem *tbiChat;
    NSString *selectedDeviceId;
    NSString *selectedDeviceName;
    
    NSDateFormatter* formatter;
    UILabel *messageLabel;
    BOOL bannerIsVisible;
    
    UISwitch *audioSwitch;
    UIBarButtonItem *audioButtonItem;
    
    UIBarButtonItem *_usersButtonItem;
    UIBarButtonItem *_clearAllButtonItem;
    ////UIBarButtonItem *menuButtonItem;
    //UIBarButtonItem *ordersButtonItem;
    
    
    UIButton *audioButton;
    /*UIButton *usersButton;
    UIButton *menuButton;
    UIButton *ordersButton;
    UIButton *settingsButton;
    */
    //compose buttons
    
    UIBarButtonItem *cancelButton;
    UIBarButtonItem *clearButton;
    UIBarButtonItem *sendButton;
    UIToolbar *pickerToolbar;
    UIBarButtonItem *flexibleSpaceLeft;
    
    NSString *displayText;
    NSString *utterText;
    
    
}


@property (nonatomic, strong) AppDelegate *appDelegate;
@property (nonatomic, strong) UIImagePickerController *pickerPhoto;
@property (strong, nonatomic) IBOutlet UIImageView *attachedPhoto;
@property (strong, nonatomic) IBOutlet UILabel *toLabel;
@property (nonatomic)BOOL canDisplayBannerAds;
//-(void)sendMyMessage:(NSString *)text;
//-(void)didReceiveDataWithNotification:(NSNotification *)notification;
//-(void)didReceiveVoiceDataWithNotification:(NSNotification *)notification;
//-(void)didReceiveControlDataWithNotification:(NSNotification *)notification;
@property (strong, nonatomic) IBOutlet UIButton *attachButton;

@property (nonatomic, strong) UIPopoverController *popOver;
@property (nonatomic, strong) GKImagePicker *imagePicker;
//@property (nonatomic, strong) UIPopoverController *popoverController;

@property(nonatomic, strong) AVSpeechSynthesizer *synthesizer;

@property(nonatomic, strong) AVSpeechUtterance *speechutt;

@end

@implementation OrderChatViewController

//@synthesize audioSwitch;//, gainValueLabel, audioProcessor;

static CGFloat const kComposeBarHeight=150;
static CGFloat const kComposeBarHeightIpad=200;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor clearColor];
      _appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
   // UITabBarController *tabBarcontroller=(UITabBarController*)_appDelegate.window.rootViewController;
   // tabBarcontroller.delegate=self;
	// Do any additional setup after loading the view, typically from a nib.
    
#ifdef ENABLE_IAD
    if ([self respondsToSelector:@selector(setCanDisplayBannerAds:)]) {
        
        self.canDisplayBannerAds=YES;
    }
#endif
   /*
    CGRect frame= self.banner1.frame;
    frame.size.height=0;
    self.banner1.frame=frame;
    [self.banner1 setHidden:YES];
    */
    //self.broadcastButton=[[UIBarButtonItem alloc] initWithTitle:@"Post" style:UIBarButtonItemStyleBordered target:self action:@selector(broadcastButtonTapped:)];
   
    _usersButtonItem=[self createBarButtonItem:@"Users" withImageName:nil withAction:@selector(showUsersAction:)];
    
    _clearAllButtonItem=[self createBarButtonItem:@"Clear" withImageName:nil withAction:@selector(clearAllAction:)];
    
    _broadcastButton=[self createBarButtonItem:@"Compose" withImageName:@"Create" withAction:@selector(broadcastButtonTapped:)];
    
    audioSwitch=[[UISwitch alloc] init];
     [audioSwitch addTarget:self action:@selector(audioSwitchAction:) forControlEvents:UIControlEventValueChanged];
    [audioSwitch setOn:NO];
    audioButtonItem=[[UIBarButtonItem alloc] initWithCustomView:audioSwitch];
    
    //if(_appDelegate.mcManager.serverPeerInfo!=nil && _appDelegate.selectedStore.peerInfo.peerID!=nil){
        self.navigationItem.rightBarButtonItem=_usersButtonItem;
   // }
    
    /*
    menuButtonItem=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menu"] style:UIBarButtonItemStyleBordered target:self action:@selector(showMenuAction:)];
    [menuButtonItem setTitle:@"Menu"];
    */
    /*
    menuButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [menuButton setImage:[UIImage imageNamed:@"menu"] forState:UIControlStateNormal];
    [menuButton setTitle:@"Menu" forState:UIControlStateNormal];
    [menuButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [menuButton setTitleColor:[UIColor blueColor] forState:UIControlStateSelected];
    [menuButton addTarget:self action:@selector(showMenuAction:) forControlEvents:UIControlEventTouchUpInside];
    [menuButton sizeToFit];
    menuButtonItem=[[UIBarButtonItem alloc] initWithCustomView:menuButton];
    */
    
    //menuButtonItem=[self createBarButtonItem:@"Menu" withImageName:@"menu" withAction:@selector(showMenuAction:)];
    
   
    //ordersButtonItem=[self createBarButtonItem:@"Orders" withImageName:@"Check" withAction:@selector(showOrdersAction:)];
    
    
   
    /*
    if(_appDelegate.isIpad){
        self.navigationItem.rightBarButtonItems=@[menuButtonItem,ordersButtonItem,settingsButtonItem];
        
    }
    else{
        self.navigationItem.rightBarButtonItems=@[menuButtonItem];
    }
    */
  
    //usersButtonItem=[self createBarButtonItem:@"Users" withImageName:@"User Group" withAction:@selector(showSettngsAction:)];
    
   
    
   
  //self.navigationItem.leftBarButtonItems=@[self.broadcastButton,usersButtonItem];
    
   //_appDelegate.orderChatViewController=self;
    
    formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterShortStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDoesRelativeDateFormatting:YES];
    
    /*
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
    {
        [self.sidebarButton setTarget: self.revealViewController];
        [self.sidebarButton setAction: @selector( revealToggle: )];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
     */
    
    tbiChat=(UITabBarItem *)[self.tabBarController.tabBar.items objectAtIndex:TAB_INDEX_CHAT];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didUpdateMessagesNotification:)
                                                 name:NOTIFY_UPDATE_MESSAGES
                                               object:nil];
    
    /*[[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didReceivePeerBgPhotoNotification:)
                                                 name:NOTIFY_RECEIVED_PEER_BGPHOTO2
                                               object:nil];*/
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(showSendMessageNotification:)
                                                 name:NOTIFY_SHOW_SENDMESSAGE
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(peerDidChangeStateWithNotification:)
                                                 name:NOTIFY_MCDIDCHANGESTATE
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didReceiveAppConfigUpdate:)
                                                 name:NOTIFY_APPCONFIG_UPDATE
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didReceiveUpdatePeers:)
                                                 name:NOTIFY_UPDATE_PEERS
                                               object:nil];
    _attachedPhoto=[UIImageView new];

    //font = [UIFont systemFontOfSize:[UIFont systemFontSize]];
    
    //if(_appDelegate.messages==nil)
      //  _appDelegate.messages=[NSMutableArray new];
    
    
    _txtMessage.delegate = self;
    
   
    //paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *myphoto=[NSString stringWithFormat:@"%@%@.png",PREFIX_MYPHOTO, _appDelegate.appConfig.userInfo.deviceID];

    NSString *filePath=[[AppDelegate getDocumentsPath] stringByAppendingPathComponent:myphoto];
    
    if([[NSFileManager defaultManager] fileExistsAtPath:filePath]){
        
        _myPhoto=[[UIImage alloc] initWithContentsOfFile:filePath];
    }
    else{
        
        _myPhoto=[UIImage imageNamed:@"empty"];
    }
    
    
    
    /*UIImageView *tempImageView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@""]];
    [tempImageView setFrame:self.tableView.frame];
     */
    self.tableView.backgroundColor=[UIColor clearColor];

    //self.staffsView.backgroundColor=[UIColor clearColor];
    
    //self.customersView.backgroundColor=[UIColor clearColor];
    
    
   
    
    
    [self hideCompose:YES];
    
    [self configurePickerView];
    
    [self speech_init];
    
    
}

-(void)speech_init{
    self.synthesizer = [[AVSpeechSynthesizer alloc]init];
    
    
}
/*
func speakText(voiceOutdata: String ) {
    do {
        try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playAndRecord, mode: .default, options: .defaultToSpeaker)
        try AVAudioSession.sharedInstance().setActive(true, options: .notifyOthersOnDeactivation)
    } catch {
        print("audioSession properties weren't set because of an error.")
    }
    
    let utterance = AVSpeechUtterance(string: voiceOutdata)
    utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
    
    let synth = AVSpeechSynthesizer()
    synth.speak(utterance)
    
    defer {
        disableAVSession()
    }
}

private func disableAVSession() {
    do {
        try AVAudioSession.sharedInstance().setActive(false, options: .notifyOthersOnDeactivation)
    } catch {
        print("audioSession properties weren't disable.")
    }
}
 */


-(void)speechSpeakAndDisplayMessage:(NSString *)displayText andUtterText:(NSString *) utterText{
    [self speech_displayMessage:displayText];
    [self speechSpeak:utterText];
}

-(void)speechSpeak:(NSString *) text{
    
    
    self.speechutt = [AVSpeechUtterance speechUtteranceWithString:text];
    //self.speechutt.volume=90.0f;
    //self.speechutt.rate=0.50f;
    //self.speechutt.pitchMultiplier=0.80f;
    //[self.speechutt setRate:0.3f];
    self.speechutt.voice = [AVSpeechSynthesisVoice voiceWithLanguage:@"en-us"];
    
    [self.synthesizer speakUtterance:self.speechutt];
    
    //[session setActive:NO withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation error:nil];
    
    
    
}

-(UIBarButtonItem *)createBarButtonItem:(NSString *)title withImageName:(NSString *)imageName withAction:(SEL)action{
    UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    if(_appDelegate.isIpad){
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blueColor] forState:UIControlStateSelected];
    }
    [button addTarget:self  action:action forControlEvents:UIControlEventTouchUpInside];
    [button sizeToFit];
   return [[UIBarButtonItem alloc] initWithCustomView:button];

}
-(void)didReceiveAppConfigUpdate:(NSNotification *)notification{
    NSString *myphoto=[NSString stringWithFormat:@"%@%@.png",PREFIX_MYPHOTO, _appDelegate.appConfig.userInfo.deviceID];
    
    NSString *filePath=[[AppDelegate getDocumentsPath] stringByAppendingPathComponent:myphoto];
    
    if([[NSFileManager defaultManager] fileExistsAtPath:filePath]){
        
        _myPhoto=[[UIImage alloc] initWithContentsOfFile:filePath];
    }
    else{
        
        _myPhoto=[UIImage imageNamed:@"empty"];
    }
    
    [self.tableView reloadData];
}

/*
- (CGRect) maximumUsableFrame {
    
    static CGFloat const kNavigationBarPortraitHeight = 44;
    static CGFloat const kNavigationBarLandscapeHeight = 34;
    static CGFloat const kToolBarHeight = 49;
    static CGFloat const kInputTextHeight = 100; //rom added
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
    
    maxFrame.size.height -= kInputTextHeight;
    
    return maxFrame;
}
*/

- (void)viewDidUnload
{
    //[self setAudioSwitch:nil];
   // [self setGainValueLabel:nil];
    //[self setTopLabel:nil];
    [super viewDidUnload];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if(_appDelegate==nil)
        _appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
     [self loadBgPhoto];
    //[self.tableView reloadData];
    /*
    if(_appDelegate.mcManager.serverPeerInfo!=nil && _appDelegate.selectedStore.peerInfo.peerID!=nil && _appDelegate.selectedStore.peerInfo.sessionState==MCSessionStateConnected)
    {
        //righ now we disable voice
        
            self.navigationItem.leftBarButtonItems=@[self.broadcastButton,usersButtonItem];
      
    }
    else{
        
            self.navigationItem.leftBarButtonItems=nil;
        
        
    }
    */
    //[self configurePickerView];
    //self.tableView.frame=[self maximumUsableFrame];
    
    //uncomment to suppert audio
    //check if in thesame net as the server
    /*if(_appDelegate.selectedStore.peerInfo.device_ssid.length>0 && [_appDelegate.selectedStore.peerInfo.device_ssid isEqualToString:[AppDelegate currentWifiSSID]]){
        
            self.navigationItem.rightBarButtonItems=@[self.broadcastButton,audioButtonItem];
        }
        else{
            self.navigationItem.rightBarButtonItems=@[self.broadcastButton];
        }
    */
    //if(_appDelegate.mcManager.serverPeerInfo!=nil)
     //   self.title=_appDelegate.selectedStore.peerInfo.peerID.displayName;
    int badgeValue=[tbiChat.badgeValue intValue];
    if(badgeValue>0){
        badgeValue--;
        
    }
    
    if(badgeValue>0){
        tbiChat.badgeValue=[NSString stringWithFormat:@"%d",badgeValue];
        
        
    }
    else
        tbiChat.badgeValue=nil;
    [UIApplication sharedApplication].applicationIconBadgeNumber=badgeValue;
    
    [self.tableView reloadData];
    [self loadBgPhoto];
    
    
}
/*
+ (NSString *)currentWifiSSID {
    // Does not work on the simulator.
    NSString *ssid = nil;
    NSArray *ifs = (__bridge_transfer id)CNCopySupportedInterfaces();
    for (NSString *ifnam in ifs) {
        NSDictionary *info = (__bridge_transfer id)CNCopyCurrentNetworkInfo((__bridge CFStringRef)ifnam);
        if (info[@"SSID"]) {
            ssid = info[@"SSID"];
        }
    }
    return ssid;
}
 */
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*#pragma mark - UITextField Delegate method implementation

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    BroadcastMessageAPI *message=[[BroadcastMessageAPI alloc] init];
    message.text=_txtMessage.text;
    message.isBroadcast=YES;
    message.message_type=MSG_TYPE_DEF;
    message.localCopy=YES;

    NSDictionary *dict = @{KEY_SEND_MESSAGE: message
                           
                           };
   
    
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_HAS_DATA_TO_SEND
                                                        object:nil
                                                      userInfo:dict];
    
    return YES;
}


#pragma mark - IBAction method implementation

- (IBAction)sendMessage:(id)sender {
    if(_txtMessage.text.length==0)
        return;
    
    BroadcastMessageAPI *message=[[BroadcastMessageAPI alloc] init];
    message.text=_txtMessage.text;
    message.isBroadcast=YES;
    message.toPeerInfo=_appDelegate.mcManager.serverPeerInfo;
    message.message_type=MSG_TYPE_DEF;
    message.localCopy=NO;
    
    NSDictionary *dict = @{KEY_SEND_MESSAGE: message
                           };

    
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_HAS_DATA_TO_SEND
                                                        object:nil
                                                      userInfo:dict];

    
    [_txtMessage setText:nil];
     [_txtMessage resignFirstResponder];
}

- (IBAction)cancelMessage:(id)sender {
    [_txtMessage resignFirstResponder];
}

*/
#pragma mark - Private method implementation



-(void)didUpdateMessagesNotification:(NSNotification *)notification{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        //remove previous message per user
        
        //
        [_tableView reloadData];
        
        //if(_appDelegate.messages.count>0){
        if(_appDelegate.selectedStore.messages>0){
            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:_appDelegate.selectedStore.messages.count-1] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        }
        //NSIndexSet *indeces=[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, _appDelegate.messages.count)];
        //[_tableView insertSections:indeces withRowAnimation:UITableViewRowAnimationBottom];
    });
    
}

/*-(void) didReceiveInputStreamNotification: (NSNotification *) notification{
    
    
    CAudioBuffer *sourceBuffer=[notification object];
    
    
    [self.audioProcessor.inputBuffers addObject:sourceBuffer];
    
    //NSLog(@"input queue %lu",(unsigned long)self.audioProcessor.inputBuffers.count);
}
*/

#pragma mark table view

- (void)scrollToNewestMessage
{
    // The newest message is at the bottom of the table
   /* NSIndexPath* indexPath = [NSIndexPath indexPathForRow:(_messages.count - 1) inSection:0];
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];*/
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    /*if(_appDelegate.messages.count>0)
    {
        self.navigationItem.rightBarButtonItems=@[self.broadcastButton,self.editButtonItem];
    }
    else{
        self.navigationItem.rightBarButtonItems=@[self.broadcastButton];
    }
     */
    /*
     NSInteger count=_appDelegate.messages.count;
     if(count>0){
     self.navigationItem.leftBarButtonItems=@[ usersButtonItem,self.broadcastButton,self.editButtonItem];
     }
     else{
     self.navigationItem.leftBarButtonItems=@[self.broadcastButton,usersButtonItem];
     }
     return count;
     */
    NSInteger count=_appDelegate.selectedStore.messages.count;
    if(count==0){
        self.navigationItem.leftBarButtonItems=@[self.broadcastButton];
        //UITabBarItem *tbi=(UITabBarItem *)[self.tabBarController.tabBar.items objectAtIndex:TAB_INDEX_CHAT];
        if(tbiChat.badgeValue!=nil)
            tbiChat.badgeValue=nil;
        
    }
    else{
        self.navigationItem.leftBarButtonItems=@[self.broadcastButton,self.editButtonItem];
        
    }
    return count;
}
- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    
    /*if (_currentPage == 0) {
        return 1;
    }
    
    if (_currentPage < _totalPages) {
        if (_currentPage>2 && _dataModel.selectedBroadcast.messages.count<MAX_ROWS) {
            return _dataModel.selectedBroadcast.messages.count + 2;
        }
        else
            return _dataModel.selectedBroadcast.messages.count + 1;
    }
    */
    
    return 1;//_messages.count;
    
}

//- (UIImage *)cellBackgroundForRowAtIndexPath:(NSIndexPath *)indexPath{
//    //NSInteger rowCount = [self tableView:[self tableView] numberOfRowsInSection:0];
//    //NSInteger rowIndex = indexPath.row;
//    /*UIImage *background = nil;
//    
//    if (rowIndex == 0) {
//        background = [UIImage imageNamed:@"cell_top.png"];
//    } else if (rowIndex == rowCount - 1) {
//        background = [UIImage imageNamed:@"cell_bottom.png"];
//    } else {
//        background = [UIImage imageNamed:@"cell_middle.png"];
//    }
//     */
//    UIImage *background =[UIImage imageNamed:@"cell_middle.png"];
//    
//    
//    return background;
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
                    //return [self messageCellForRowAtIndexPath:indexPath];
    BroadcastMessageAPI* message = (_appDelegate.selectedStore.messages)[indexPath.section];//_messages[indexPath.row];
    
    
   
    
    if(![message.isread isEqualToNumber:@1])
    {
        message.isread=@1;
    /*    int badgeValue=[tbiChat.badgeValue intValue];
        if(badgeValue>0){
            badgeValue--;
            
        }
        
        if(badgeValue>0){
            tbiChat.badgeValue=[NSString stringWithFormat:@"%d",badgeValue];
            
            
        }
        else
            tbiChat.badgeValue=nil;
        [UIApplication sharedApplication].applicationIconBadgeNumber=badgeValue;
     */
    }
    
    BOOL isCustomer=YES;
    /* this always retrun 0 so we will use for loop instead
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"(DeviceId==%@) AND (PeerGroup==%@)",message.fromDeviceID,PEER_GROUP_CUSTOMERS];
    
    NSArray *result=[_appDelegate.selectedStore.peerInfo.peers filteredArrayUsingPredicate:predicate];
    if ([result count]>0)
        isCustomer=YES;
   */
    //override
    if(message.isRemoteNotification){
        if(message.isServer)
            isCustomer=NO;
        
    }
    else{
        if([_appDelegate.mcManager.myPeerInfo.deviceID isEqualToString:message.fromDeviceID]){
            if ([_appDelegate.mcManager.myPeerInfo.group isEqualToString:PEER_GROUP_STAFFS])
                 isCustomer=NO;
            
           
        }
        else if([_appDelegate.selectedStore.peerInfo.deviceID isEqualToString:message.fromDeviceID]){
            isCustomer=NO;
        }
        else{
         
            for(NSDictionary *p in _appDelegate.selectedStore.peerInfo.peers){
                if([[p valueForKey:DeviceIdKey] isEqualToString:message.fromDeviceID] && [[p valueForKey:@"PeerGroup"] isEqualToString:PEER_GROUP_STAFFS] ){
                    isCustomer=NO;
                    break;
                }
                
            }
        }
    }
    
    UITableViewCell *cell=nil;
    if(message.imagefileuid==nil || message.imagefileuid.length==0){
        if (isCustomer)
            cell= [self messageTextOnlyCustCellForRowAtIndexPath:message];
        else
            cell= [self messageTextOnlyCellForRowAtIndexPath:message];
    }
    else{
         if (isCustomer)
             cell= [self messageImageOnlyCustCellForRowAtIndexPath:message];
        else
             cell= [self messageImageOnlyCellForRowAtIndexPath:message];
    }
    if(cell){
    //set borders,colors
    [[cell layer] setCornerRadius:8.0f];
    [[cell layer] setBorderWidth:5.0f];
        
        if(message.colorCode==nil){
           [[cell layer] setBorderWidth:0.0f];
            [[cell layer] setBorderColor:[UIColor grayColor].CGColor];
        }
        else{
            
            //[[cell layer] setBorderColor:[UIColor colorWithCGColor:message.colorCode];//[UIColor greenColor].CGColor];
            
            if([message.colorCode isEqualToNumber:@ColorCodeGreen]){
                    [[cell layer] setBorderColor:[UIColor greenColor].CGColor];
            }
            else if([message.colorCode isEqualToNumber:@ColorCodeRed]){
                [[cell layer] setBorderColor:[UIColor redColor].CGColor];
            }
            else if([message.colorCode isEqualToNumber:@ColorCodeYellow]){
                [[cell layer] setBorderColor:[UIColor yellowColor].CGColor];
            }
            else if([message.colorCode isEqualToNumber:@ColorCodeBlue]){
                [[cell layer] setBorderColor:[UIColor blueColor].CGColor];
            }
            else if([message.colorCode isEqualToNumber:@ColorCodeGray]){
                [[cell layer] setBorderColor:[UIColor grayColor].CGColor];
            }
            else if([message.colorCode isEqualToNumber:@ColorCodeDarkGray]){
                [[cell layer] setBorderColor:[UIColor darkGrayColor].CGColor];
            }
        }
    
    
    }
    return cell;
}

/*
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    BroadcastMessageAPI* message = _messages[indexPath.row];
    
    
 
    
    CGSize labelSize=[self sizeForText: message.text];
    return labelSize.height+tableView.rowHeight;
    
    //CGSize constraintSize=CGSizeMake(280.0f, MAXFLOAT);
    //CGSize labelSize=[message.text sizeWithFont:font constrainedToSize:constraintSize lineBreakMode:UILineBreakModeWordWrap];
    //return labelSize.height+20;
}
*/
/*
- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    
    
    
       BroadcastMessageAPI* message = (_appDelegate.messages)[indexPath.section];

    
    UILabel *messageLabell=[[UILabel alloc] initWithFrame:CGRectMake(8, 29, 229, 21)];
    messageLabell.numberOfLines=0;
    messageLabell.lineBreakMode=NSLineBreakByWordWrapping;
    

    
    messageLabell.text=[message.text stringByAppendingString:@"\n"];
    CGRect frame = messageLabell.frame;//label.frame;
    [messageLabell sizeToFit];
    frame.size.height = messageLabell.frame.size.height;
    if(frame.size.height<MIN_MESSAGE_HEIGHT)
        frame.size.height=MIN_MESSAGE_HEIGHT;
    

    messageLabell.frame = frame;
    
    CGSize bubbleSize =frame.size;
            CGFloat height;
    
    CGFloat attached_image_height=CHAT_ATTACHEDIMAGE_HEIGHT;
    
    if(message.imagefileuid!=nil && message.imagefileuid.length>0){
        
        
        height=bubbleSize.height+35;
         if(height<72.0)
         height=72.0;
        
        height=height+attached_image_height+21;
    }
    else{
       
        height=bubbleSize.height+35;
        if(height<72.0)
            height=72.0;
    }
    
    
    return height;
}
*/

- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    
    
    
    BroadcastMessageAPI* message = (_appDelegate.selectedStore.messages)[indexPath.section];
    
    CGSize bubbleSize = [AppDelegate sizeForText:message.text];//[SpeechBubbleView sizeForText:message.text];
    CGFloat height;
    CGFloat sender_height=CHAT_SENDERNAME_HEIGHT;
    CGFloat sender_photo_height=CHAT_PHOTO_HEIGHT;
    CGFloat attached_image_height=CHAT_ATTACHEDIMAGE_HEIGHT;
    
    /*
    UILabel *messageLabell=[[UILabel alloc] initWithFrame:CGRectMake(8, 29, 229, 21)];
    messageLabell.numberOfLines=0;
    messageLabell.lineBreakMode=NSLineBreakByWordWrapping;
    
    
    
    messageLabell.text=[message.text stringByAppendingString:@"\n"];
    CGRect frame = messageLabell.frame;//label.frame;
    [messageLabell sizeToFit];
    frame.size.height = messageLabell.frame.size.height;
    if(frame.size.height<MIN_MESSAGE_HEIGHT)
        frame.size.height=MIN_MESSAGE_HEIGHT;
    
    
    messageLabell.frame = frame;
    
    CGSize bubbleSize =frame.size;
    CGFloat height;
    
    CGFloat attached_image_height=CHAT_ATTACHEDIMAGE_HEIGHT;
    
    if(message.imagefileuid!=nil && message.imagefileuid.length>0){
        
        
        height=bubbleSize.height+35;
        if(height<72.0)
            height=72.0;
        
        height=height+attached_image_height+21;
    }
    else{
        
        height=bubbleSize.height+35;
        if(height<72.0)
            height=72.0;
    }
    */
    if(message.imagefileuid!=nil && message.imagefileuid.length>0){
        
        if(bubbleSize.height>sender_photo_height){
            height=sender_height+bubbleSize.height+attached_image_height;
            
        }
        else{
            height=sender_height+sender_photo_height+attached_image_height;
        }
        height=height+20;
    }
    else{
        if(bubbleSize.height>sender_photo_height){
            height=sender_height+bubbleSize.height;
        }
        else{
            height=sender_height+sender_photo_height;
        }
        height=height+7;
    }
    
    
    return height;
    
    
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    /*
     NSMutableArray *orders=[self.history valueForKey:day];
     if(orders==nil){
     orders=[NSMutableArray new];
     [orders addObject:order];
     [self.history setValue:orders forKey:day];
     }
     else{
     [orders addObject:order];
     }
     */
    //NSMutableArray *orders=[_appDelegate.historyModel.history valueForKey:historyDates[indexPath.section]] ;
    
    //OrderHistory *delete_item=[orders objectAtIndex:indexPath.row];
    
    
    
    
    if(editingStyle==UITableViewCellEditingStyleDelete){
       
        [_appDelegate.selectedStore.messages removeObjectAtIndex:indexPath.section];
        
        [self.tableView reloadData];
    }
}
-(void)setEditing:(BOOL)editing animated:(BOOL)animated{
    [super setEditing:editing animated:animated];
    [self.tableView setEditing:editing animated:animated];
    /*if (editing)
    {
        //self.editButtonItem.title = NSLocalizedString(@"Cancel", @"Cancel");
    }
    else
    {
        self.editButtonItem.title = NSLocalizedString(@"Block/UnBlock", @"Block/UnBlock");
    }
     */
    if(editing){
        if(![self.navigationItem.rightBarButtonItems containsObject:_clearAllButtonItem]){
            self.navigationItem.leftBarButtonItems=@[self.broadcastButton,self.editButtonItem,_clearAllButtonItem];
        }
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    BroadcastMessageAPI* message = (_appDelegate.selectedStore.messages)[indexPath.section];//_messages[indexPath.row];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    selectedDeviceId=message.fromDeviceID;
    selectedDeviceName=message.sender;
    
    if([selectedDeviceId isEqualToString:_appDelegate.appConfig.userInfo.deviceID ] && message.isBroadcast){
        [self broadcastButtonTapped:nil];
    }
    else{
    
    [self showSendPrivate:self];
    }
   
}

- (UITableViewCell*)messageTextOnlyCellForRowAtIndexPath:(BroadcastMessageAPI*) message{//(NSIndexPath*)indexPath{
   
    
    ChatTextOnlyCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"ChatTextOnlyCell"];
    
   
          if([_appDelegate.appConfig.userInfo.deviceID isEqualToString:message.fromDeviceID]){
        
        //cell.senderLabel.text=@"You";
        if(message.isBroadcast)
            cell.senderLabel.text=@"You @everyone";
        else
            cell.senderLabel.text=[NSString stringWithFormat:@"You @%@", message.recipient];
        
        cell.senderPhoto.image=_myPhoto;
        
    }
    else{
        
        
        if(message.isBroadcast)
            cell.senderLabel.text=[NSString stringWithFormat:@"%@ @everyone", message.sender];
        else
            cell.senderLabel.text=[NSString stringWithFormat:@"%@",message.sender];
                [self imageForSender:cell.senderPhoto deviceID:message.fromDeviceID];
       
        
        
    }
    
    
    cell.senderPhoto.layer.cornerRadius=cell.senderPhoto.frame.size.width / 2;
    cell.senderPhoto.clipsToBounds = YES;

    cell.dateLabel.text=[formatter stringFromDate:message.createdon];
    
    
    
    [cell setMessage:message.text];
    
    //[[cell layer] setCornerRadius:8.0f];
    return cell;
    
}

- (UITableViewCell*)messageTextOnlyCustCellForRowAtIndexPath:(BroadcastMessageAPI*) message{//(NSIndexPath*)indexPath{
  
    
    ChatTextOnlyCustCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"ChatTextOnlyCustCell"];
    
    
    if([_appDelegate.appConfig.userInfo.deviceID isEqualToString:message.fromDeviceID]){
        
        if(message.isBroadcast)
            cell.senderLabel.text=@"You @everyone";
        else
            cell.senderLabel.text=[NSString stringWithFormat:@"You @%@", message.recipient];
        cell.senderPhoto.image=_myPhoto;
        
    }
    else{
        
        if(message.isBroadcast)
            cell.senderLabel.text=[NSString stringWithFormat:@"%@ @everyone", message.sender];
        else
            cell.senderLabel.text=[NSString stringWithFormat:@"%@",message.sender];
        
        [self imageForSender:cell.senderPhoto deviceID:message.fromDeviceID];
     
    }
   
    cell.senderPhoto.layer.cornerRadius=cell.senderPhoto.frame.size.width / 2;
    cell.senderPhoto.clipsToBounds = YES;
   
    
    cell.dateLabel.text=[formatter stringFromDate:message.createdon];
    
    
    /*
    cell.messageLabel.numberOfLines=0;
    cell.messageLabel.lineBreakMode=NSLineBreakByWordWrapping;
    cell.messageLabel.text=message.text;//[message.text stringByAppendingString:@"\n"];
    CGRect frame = cell.messageLabel.frame;//label.frame;
    [cell.messageLabel sizeToFit];
    frame.size.height = cell.messageLabel.frame.size.height;//+35;
    cell.messageLabel.frame = frame;
    */
     [cell setMessage:message.text];
    
    //[[cell layer] setCornerRadius:8.0f];
    return cell;
    
}


- (UITableViewCell*)messageImageOnlyCellForRowAtIndexPath:(BroadcastMessageAPI*) message{//(NSIndexPath*)indexPath{
    ChatImageOnlyCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"ChatImageOnlyCell"];
    
   
     if([_appDelegate.appConfig.userInfo.deviceID isEqualToString:message.fromDeviceID]){
        if(message.isBroadcast)
            cell.senderLabel.text=@"You @everyone";
        else
            cell.senderLabel.text=[NSString stringWithFormat:@"You @%@", message.recipient];
        cell.senderPhoto.image=_myPhoto;
        
    }
    else{
        
        if(message.isBroadcast)
            cell.senderLabel.text=[NSString stringWithFormat:@"%@ @everyone", message.sender];
        else
            cell.senderLabel.text=[NSString stringWithFormat:@"%@",message.sender];
        
        [self imageForSender:cell.senderPhoto deviceID:message.fromDeviceID];
        
    }
    
    
    cell.senderPhoto.layer.cornerRadius=cell.senderPhoto.frame.size.width / 2;
    cell.senderPhoto.clipsToBounds = YES;
    
    cell.dateLabel.text=[formatter stringFromDate:message.createdon];
    
    /*CGSize bubbleSize = [SpeechBubbleView sizeForText:message.text];
    CGRect rect=cell.messageLabel.frame;
   
    
    rect.size.width=bubbleSize.width;
    if(bubbleSize.height>CHAT_PHOTO_HEIGHT)
        rect.size.height=bubbleSize.height;
    else
        rect.size.height=CHAT_PHOTO_HEIGHT;
    
  
    cell.messageLabel.numberOfLines=0;
    cell.messageLabel.lineBreakMode=NSLineBreakByWordWrapping;
    cell.messageLabel.frame=rect;
    cell.messageLabel.text=message.text;
    */
    [cell setMessage:message.text];
    cell.senderLabel.text=message.sender;
    [cell.attachImage setImage:[UIImage imageNamed:@"loading_attachment"]];
    [self imageForAttachment:cell.attachImage message:message];
    
    [[cell.attachImage layer] setCornerRadius:8.0f];
    cell.attachImage.clipsToBounds = YES;
    
    //[[cell layer] setCornerRadius:8.0f];
    
    return cell;
    
}

- (UITableViewCell*)messageImageOnlyCustCellForRowAtIndexPath:(BroadcastMessageAPI*) message{//(NSIndexPath*)indexPath{
    ChatImageOnlyCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"ChatImageOnlyCustCell"];
    
   // if([_appDelegate.mcManager.myPeerInfo.deviceID isEqualToString:message.fromDeviceID]){
      if([_appDelegate.appConfig.userInfo.deviceID isEqualToString:message.fromDeviceID]){
        if(message.isBroadcast)
            cell.senderLabel.text=@"You @everyone";
        else
            cell.senderLabel.text=[NSString stringWithFormat:@"You @%@", message.recipient];
        cell.senderPhoto.image=_myPhoto;
        
    }
    else{
        
        if(message.isBroadcast)
            cell.senderLabel.text=[NSString stringWithFormat:@"%@ @everyone", message.sender];
        else
            cell.senderLabel.text=[NSString stringWithFormat:@"%@",message.sender];
        
        [self imageForSender:cell.senderPhoto deviceID:message.fromDeviceID];
       
    }
    
    cell.senderPhoto.layer.cornerRadius=cell.senderPhoto.frame.size.width / 2;
    cell.senderPhoto.clipsToBounds = YES;
    
    cell.dateLabel.text=[formatter stringFromDate:message.createdon];
    
    /*CGSize bubbleSize = [SpeechBubbleView sizeForText:message.text];
    CGRect rect=cell.messageLabel.frame;
    
    
    rect.size.width=bubbleSize.width;
    if(bubbleSize.height>CHAT_PHOTO_HEIGHT)
        rect.size.height=bubbleSize.height;
    else
        rect.size.height=CHAT_PHOTO_HEIGHT;
    
    rect.size.height=rect.size.height+20;
    
    cell.messageLabel.numberOfLines=0;
    cell.messageLabel.lineBreakMode=NSLineBreakByWordWrapping;
    cell.messageLabel.frame=rect;
    cell.messageLabel.text=message.text;
*/
    [cell setMessage:message.text];
    
    cell.senderLabel.text=message.sender;
    
    [cell.attachImage setImage:[UIImage imageNamed:@"loading_attachment"]];
    [self imageForAttachment:cell.attachImage message:message];
    
     [[cell.attachImage layer] setCornerRadius:8.0f];
    cell.attachImage.clipsToBounds = YES;

  //  [[cell layer] setCornerRadius:8.0f];
    return cell;
    
}

-(void)imageForAttachment:(UIImageView *)imageView message:(BroadcastMessageAPI *)message{//fileuid:(NSString *)fileuid{
    NSString *attached_photo=[NSString stringWithFormat:@"%@%@.png",PREFIX_ATTACHMENT, message.imagefileuid];
    
    
    NSString *filePath=[[AppDelegate getImagesPathForServer:_appDelegate.selectedStore.peerInfo.deviceID] stringByAppendingPathComponent:attached_photo];
    
    
    
    //check if cached
    if([[NSFileManager defaultManager] fileExistsAtPath:filePath]){
        
        //cell.attachImage.image=[[UIImage alloc] initWithContentsOfFile:filePath];
        dispatch_queue_t imageQueue = dispatch_queue_create("Image Attachment Queue",NULL);
        dispatch_async(imageQueue, ^{
            
            
            NSData *imageData=[NSData dataWithContentsOfFile:filePath];
            
            
            if(!imageData) return;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if(imageView){
                    [imageView setImage:[UIImage imageWithData:imageData]];
                   // imageView.layer.cornerRadius=imageView.frame.size.width / 8;//cell.senderPhoto.frame.size.width / 2;
                   // imageView.clipsToBounds = YES;
                }
            });
        });
    }
    else{ //download
        //if(_appDelegate.mcManager.serverPeerInfo && _appDelegate.selectedStore.peerInfo.peerID){
            
        NSString *remotePath=[NSString stringWithFormat:@"/images/%@",attached_photo];
        
        
        BroadcastMessageAPI *send_message=[[BroadcastMessageAPI alloc] init];
        send_message.text=remotePath;
        send_message.message_type=MSG_TYPE_REQUEST_FILE_DOWNLOAD;
        send_message.isBroadcast=NO;
        send_message.toPeerInfo=_appDelegate.selectedStore.peerInfo;//_appDelegate.mcManager.serverPeerInfo;//message.peerInfo;
        send_message.localCopy=NO;
        //[self sendMyMessage:send_message];
        NSDictionary *dict = @{KEY_SEND_MESSAGE: send_message
                               };
        
        
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_HAS_DATA_TO_SEND
                                                            object:nil
                                                          userInfo:dict];
    //}
    }
    

}

-(void)imageForSender:(UIImageView *)imageView deviceID:(NSString *) deviceID{
    [imageView setImage:[UIImage imageNamed:@"empty"]];
    
    NSString *peer_photo=[NSString stringWithFormat:@"%@%@.png",PREFIX_MYPHOTO, deviceID];
    
    
    NSString *filePath=[[AppDelegate getImagesPathForServer:_appDelegate.selectedStore.peerInfo.deviceID] stringByAppendingPathComponent:peer_photo];
    if([[NSFileManager defaultManager] fileExistsAtPath:filePath]){
        dispatch_queue_t imageQueue = dispatch_queue_create("Image Queue",NULL);
        dispatch_async(imageQueue, ^{
            
            
            NSData *imageData=imageData =[NSData dataWithContentsOfFile:filePath];
            
            
            if(!imageData) return;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if(imageView){
                    [imageView setImage:[UIImage imageWithData:imageData]];
                    //imageView.layer.cornerRadius=imageView.frame.size.width / 2;
                    //imageView.clipsToBounds = YES;
                }
            });
        });
    }
    else{
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didFinishDownload:) name:peer_photo object:nil];
        NSString *serverPath=[NSString stringWithFormat:@"/images/%@",peer_photo];
        
        BroadcastMessageAPI *message=[[BroadcastMessageAPI alloc] init];
        message.text=serverPath;
        message.isBroadcast=NO;
        message.toPeerInfo=_appDelegate.selectedStore.peerInfo;//_appDelegate.mcManager.serverPeerInfo;;
        message.message_type=MSG_TYPE_REQUEST_FILE_DOWNLOAD;
        message.localCopy=NO;
        
        // [self sendMyMessage:message]
        NSDictionary *dict = @{KEY_SEND_MESSAGE: message
                               };
        
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_HAS_DATA_TO_SEND object:nil userInfo:dict];
    }
    
    }



- (IBAction)audioSwitchAction:(id)sender {
    _appDelegate.isAudioON=audioSwitch.on;
   // [[NSNotificationCenter defaultCenter] postNotificationName:@"DidReceiveAudioSwitchNotification" object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"DidReceiveAudioSwitchNotification" object:nil userInfo:@{@"on":@(audioSwitch.on)}];
}
- (IBAction)showUsersAction:(id)sender {
   /*
    
   
        
        UsersViewController *vc=[_appDelegate.storyBoard instantiateViewControllerWithIdentifier:@"UsersViewController"];
    
    
    
        UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:vc];
        
        if(_appDelegate.isIpad){
           
            
            
            _popOver=[[UIPopoverController alloc] initWithContentViewController:nav];
            
            _popOver.popoverContentSize=CGSizeMake(200.0, self.view.frame.size.height);
            [_popOver presentPopoverFromBarButtonItem:_usersButtonItem permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
            
        }
        else{
           
            [self presentViewController:nav animated:YES completion:nil];
        }
    
*/
}

/*
- (IBAction)showMenuAction:(id)sender {
    if(![_appDelegate isConnected]){
        [AppDelegate toast:@"Not connected. Please connect to get an updated menu." duration:2.0];
        //return;
    }
    
    [self show:NOTIFY_SHOW_MENU];
    
}

- (IBAction)showOrdersAction:(id)sender {
    
    [self show:NOTIFY_SHOW_ORDERHISTORY];
}
*/



-(void)show:(NSString *)name{
    
    if(_appDelegate.isIpad){
        
        [[NSNotificationCenter defaultCenter] postNotificationName:name object:nil];
    }
    else{
        [self performSegueWithIdentifier:name sender:self];
    }
}

 -(void)didReceivePeerBgPhotoNotification:(NSNotification *)notification{
    //[self loadBgPhoto];
}


/*-(void)didReceiveRemoteNotification:(NSNotification *)notification{
    dispatch_async(dispatch_get_main_queue(), ^{
        [_tableView reloadData];
    });
}
*/


-(void)loadBgPhoto{


    NSString *peer_bgphoto=[NSString stringWithFormat:@"%@%@.png",PREFIX_MYBGPHOTO, _appDelegate.selectedStore.peerInfo.deviceID];



    NSString *filePath=[[AppDelegate getImagesPathForServer:_appDelegate.selectedStore.peerInfo.deviceID] stringByAppendingPathComponent:peer_bgphoto];



    //check if cached
    /*if([[NSFileManager defaultManager] fileExistsAtPath:filePath]){
        
        self.wallImage.image=[[UIImage alloc] initWithContentsOfFile:filePath];
    }
    */
   
    if([[NSFileManager defaultManager] fileExistsAtPath:filePath]){
        dispatch_queue_t imageQueue = dispatch_queue_create("Image Queue",NULL);
        dispatch_async(imageQueue, ^{
            
            
            NSData *imageData=imageData =[NSData dataWithContentsOfFile:filePath];
            
            
            if(!imageData) return;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                //if(self.wallImage){
                    [self.wallImage setImage:[UIImage imageWithData:imageData]];
                    //imageView.layer.cornerRadius=imageView.frame.size.width / 2;
                    //imageView.clipsToBounds = YES;
                //}
            });
        });
    }
}

#pragma mark - UITextField Delegate method implementation
/*
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    
      //  [self sendMessage];
   
    return YES;
}
*/
-(void)showSendMessageNotification:(NSNotification *)notification{
    dispatch_async(dispatch_get_main_queue(), ^{
        selectedDeviceId=[notification.userInfo valueForKey:DeviceIdKey];
        selectedDeviceName=[notification.userInfo valueForKey:@"Title"];
        [self showSendPrivate:self];
    });
    
   
}
#pragma mark - IBAction method implementation

- (IBAction)attachButtonTapped:(id)sender {
    [self.view endEditing:YES];
    
    if([self hasImageAttachment]){
        [AppDelegate toast:@"Only 1 attachment per message is allowed." duration:2.0 ];
        return;
    }
    
    UIActionSheet *photoActionSheet=[[UIActionSheet alloc]
                                     initWithTitle: [NSString stringWithFormat:@"Attach file upto %@",@(_appDelegate.selectedStore.maxUploadSizeKB)]
                        delegate:self
                        cancelButtonTitle:@"Cancel"
                        destructiveButtonTitle: nil
                        otherButtonTitles:@"Take Photo",@"Select Photo", NULL];
    [photoActionSheet showInView:self.parentViewController.view ];
}




-(void)hideCompose:(BOOL)hide{
    CGRect frame;
   
    self.tableView.contentOffset=CGPointMake(0,0-self.tableView.contentInset.top);
    frame=  self.composeBar.frame;
    
    if(hide)
        frame.size.height=0.0;
    else{
        
        if(_appDelegate.isIpad)
            frame.size.height=kComposeBarHeightIpad;
        else
            frame.size.height=kComposeBarHeight;
    }
    //frame.origin.y=frame.origin.y+8;
    
    self.composeBar.frame=frame;
    
    [self.composeBar setHidden:hide];
    
    if(!hide){
        [self.navigationController setNavigationBarHidden:YES animated:YES];
        [self.txtMessage becomeFirstResponder];
    }
    else{
        [self.navigationController setNavigationBarHidden:NO animated:YES];
        [self.txtMessage endEditing:YES];
    }
    
    
    if(_appDelegate.selectedStore.maxUploadSizeKB==0)
        [self.attachButton setHidden:YES];
    else
        [self.attachButton setHidden:NO];
    
}

-(BOOL)hasImageAttachment{
    __block BOOL result=NO;
    [_txtMessage.attributedText enumerateAttribute:NSAttachmentAttributeName
                                           inRange:NSMakeRange(0, [_txtMessage.attributedText length])
                                           options:0
                                        usingBlock:^(id value, NSRange range, BOOL *stop)
     {
         if ([value isKindOfClass:[NSTextAttachment class]])
         {
             NSTextAttachment *attachment = (NSTextAttachment *)value;
             UIImage *image = nil;
             if ([attachment image])
                 image = [attachment image];
             else
                 image = [attachment imageForBounds:[attachment bounds]
                                      textContainer:nil
                                     characterIndex:range.location];
             
             if (image){
                 //[imagesArray addObject:image];
                 /*
                  _attachedPhoto.image=image;
                  */
                 result=YES;
             }
         }
     }];
    return result;
}

- (void)sendMessage{
   // if(_txtMessage.text.length==0 && _attachedPhoto.image==nil)
    if(_txtMessage.text.length==0 && ![self hasImageAttachment ])
        
        return;
    
    if(_appDelegate.selectedStore.peerInfo==nil){
        
        [AppDelegate ShowErrorAlert:@"Please CONNECT to send."];
        return;
    }
    
    //check if beginning is order, that means speech recognition is use
    NSString * finalText =_txtMessage.text;//[_txtMessage.attributedText string];
    
    finalText = [finalText lowercaseString];
    if([finalText hasPrefix:@"order"]){
        finalText = [finalText stringByReplacingOccurrencesOfString:@"order" withString:@""];
        //[self speechAddToCartMessage:finalText];
        
        [_txtMessage setText:nil];
        [_txtMessage resignFirstResponder];
        _attachedPhoto.image=nil;
        [_attachButton setEnabled:YES];
        [self hideCompose:YES];
        [self.navigationController setNavigationBarHidden:NO animated:YES];
        
        [self speechAddToCartMessage:finalText];
        
        return;
        
    }
    else if([finalText hasPrefix:@"checkout"] || [finalText hasPrefix:@"check out"]){
        //[self.tabBarController setSelectedIndex:TAB_INDEX_CART];
        [self speech_completePayment];
        
    }
    /*
    else if([finalText hasPrefix:@"quick checkout"] || [finalText hasPrefix:@"quick check out"]){
        [self.tabBarController setSelectedIndex:TAB_INDEX_CART];
        
    }
     */
    
    
     NSString *imagefileuid=nil;
    _attachedPhoto.image=nil;
    
    //NSMutableArray *imagesArray = [[NSMutableArray alloc] init];
    [_txtMessage.attributedText enumerateAttribute:NSAttachmentAttributeName
                                 inRange:NSMakeRange(0, [_txtMessage.attributedText length])
                                 options:0
                              usingBlock:^(id value, NSRange range, BOOL *stop)
     {
         if ([value isKindOfClass:[NSTextAttachment class]])
         {
             NSTextAttachment *attachment = (NSTextAttachment *)value;
             UIImage *image = nil;
             if ([attachment image])
                 image = [attachment image];
             else
                 image = [attachment imageForBounds:[attachment bounds]
                                      textContainer:nil
                                     characterIndex:range.location];
             
             if (image){
                 //[imagesArray addObject:image];
                 _attachedPhoto.image=image;
                 
             }
         }
     }];
    
    
    if(_attachedPhoto.image!=nil){
        
      
        
        
         NSData  *imageFileData= UIImagePNGRepresentation(_attachedPhoto.image);
        
#ifdef DEBUG
        NSLog(@"imageFileData.length=%lu",(unsigned long)imageFileData.length);
#endif
        if(imageFileData.length>0){
         if (imageFileData.length<=_appDelegate.selectedStore.maxUploadSizeKB*1024)//TODO: Limit size ex: 200000 //approx 200x250
         {
             imagefileuid=[[ imageFileData MD5] uppercaseString];
             NSString *filename=[NSString stringWithFormat:@"%@%@.png",PREFIX_ATTACHMENT, imagefileuid];
             
             //create path
            
             NSString *filePath=[[AppDelegate getImagesPathForServer:_appDelegate.selectedStore.peerInfo.deviceID] stringByAppendingPathComponent:filename];
             //save image if does not exist
             
             //check if cached
             if(![[NSFileManager defaultManager] fileExistsAtPath:filePath]){
                 //clean up first to save space
                 NSFileManager* fm = [[NSFileManager alloc] init] ;
                 NSDirectoryEnumerator* en = [fm enumeratorAtPath:[AppDelegate getImagesPathForServer:_appDelegate.selectedStore.peerInfo.deviceID] ];
                 NSError* err = nil;
                 BOOL res;
                 
                 NSString* file;
                 NSPredicate *p=[NSPredicate predicateWithFormat:@"imagefileuid!=nil AND imagefileuid!=''"];
                 NSArray *r=[_appDelegate.selectedStore.messages filteredArrayUsingPredicate:p];
                 if ([r count]==0) {
                     //empty directory
                    
                     while (file = [en nextObject]) {
                         res = [fm removeItemAtPath:[[AppDelegate getImagesPathForServer:_appDelegate.selectedStore.peerInfo.deviceID]  stringByAppendingPathComponent:file] error:&err];
                         if (!res && err) {
                             //NSLog(@"oops: %@", err);
                         }
                     }
                 }
                 else{
                     while (file = [en nextObject]) {
                         if (![r containsObject:file]) {
                             
                         res = [fm removeItemAtPath:[[AppDelegate getImagesPathForServer:_appDelegate.selectedStore.peerInfo.deviceID]  stringByAppendingPathComponent:file] error:&err];
                         if (!res && err) {
                             //NSLog(@"oops: %@", err);
                         }
                         }
                     }
                 }
                 
                 [imageFileData writeToFile:filePath atomically:YES];
             }

         
        }
         else{
             [AppDelegate toast:@"Unable to attach file. The maximum filesize is 1MB." duration:3];
             return;
         }
        }
        
    }
    
    BroadcastMessageAPI *message=[[BroadcastMessageAPI alloc] init];
    //NSLog(@"_txtMessage.attributedText=%@",_txtMessage.attributedText);
    message.text=_txtMessage.text;//[_txtMessage.attributedText string];
    //NSLog(@"message.text=%@",message.text);
    message.imagefileuid=imagefileuid;
    message.fromDeviceID=_appDelegate.mcManager.myPeerInfo.deviceID;
    message.message_type=MSG_TYPE_DEF;
    message.localCopy=NO;
    //message.fromDeviceID=_appDelegate.mcManager.myPeerInfo.deviceID;
    
    if(selectedDeviceId){
        
        message.toDeviceID=selectedDeviceId;
        message.recipient=selectedDeviceName;
        message.isBroadcast=NO;
        
    }
    else{
        message.isBroadcast=YES;
        message.recipient=@"everyone";
    }
    
    
    
    [_appDelegate.selectedStore addNewMessage:message];
    //AudioServicesPlaySystemSound(1004); //smssent
   [_tableView reloadData];
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:_appDelegate.selectedStore.messages.count-1] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
//self.tableView.contentOffset=CGPointMake(0,0-self.tableView.contentInset.bottom);
    
    NSDictionary *dict = @{KEY_SEND_MESSAGE: message
                           };
    
    
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_HAS_DATA_TO_SEND
                                                        object:nil
                                                      userInfo:dict];
    
    
    [_txtMessage setText:nil];
    [_txtMessage resignFirstResponder];
    _attachedPhoto.image=nil;
    [_attachButton setEnabled:YES];
    [self hideCompose:YES];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    //if(self.containerStaffsList.isHidden){
       // CGRect frame=self.tableView.frame;
       // frame.origin.y=self.sendMessageView.frame.origin.y;
        
        
      //  [self.sendMessageView setHidden:YES];
    
  //  [self.broadcastButton setEnabled:YES];
        
      //  self.tableView.frame=frame;
   // }
   // [self.showSendButton setTitle:@"Send message"];
}

-(Product *)searchProducts:(NSString *)keywords {
    
    
    keywords  =[keywords stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" "]];
    Product *ret = nil;
    if(keywords.length>0){
        NSArray *results=[_appDelegate.selectedStore.inventory searchProducts:keywords];
        if([results count]>0){
            /*
            for(Product *p in results){
                
                
                ProductCategory *pc=[_selectedInventory searchCategoryWithID:p.categoryID] ;
                if(pc!=nil){
                    if(pc.searchedProducts==nil){
                        pc.searchedProducts=[NSMutableArray new];
                    }
                    [pc.searchedProducts addObject:p];
                    if(![_sortedCategories containsObject:pc]){
                        
                        
                        [_sortedCategories addObject:pc];
                        
                    }
                    
                }
                 
            }
            
            [categorySectionTitles addObjectsFromArray: [_sortedCategories valueForKey:NAME_KEY]];
            */
            ret = results[0];
            
            
            
            
        }
        
       
        
    }
     return ret;
}

-(Product *)speech_searchProducts:(NSString *)keywords {
    
    
    keywords  =[keywords stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" "]];
    Product *ret = nil;
    if(keywords.length>0){
        NSArray *results=[_appDelegate.selectedStore.inventory speechSearchProducts:keywords];
        if([results count]>0){
            /*
             for(Product *p in results){
             
             
             ProductCategory *pc=[_selectedInventory searchCategoryWithID:p.categoryID] ;
             if(pc!=nil){
             if(pc.searchedProducts==nil){
             pc.searchedProducts=[NSMutableArray new];
             }
             [pc.searchedProducts addObject:p];
             if(![_sortedCategories containsObject:pc]){
             
             
             [_sortedCategories addObject:pc];
             
             }
             
             }
             
             }
             
             [categorySectionTitles addObjectsFromArray: [_sortedCategories valueForKey:NAME_KEY]];
             */
            ret = results[0];
            
            
            
            
        }
        
        
        
    }
    return ret;
}

-(NSNumber *)wordToNumber:(NSString *)word{
    
    NSDictionary *dict = @{
                            @"one":@1,@"two":@2,@"three":@3,@"four":@4,@"five":@5,@"six":@6,@"seven":@7,@"eight":@8,@"nine":@9,@"ten":@10
                           ,@"evelen":@11,@"twelve":@12,@"thirteen":@13,@"fourteen":@14,@"fifteen":@15,@"sixteen":@16,@"seventeen":@17
                           ,@"eighteen":@18,@"nineteen":@19,@"twenty":@20,@"thirty":@30,@"forty":@40,@"sixty":@60,@"seventy":@70
                           ,@"eighty":@80,@"ninety":@90,@"hundred":@100,@"thousand":@1000
                           
                           };
    NSNumber *ret = nil;
    if(dict[word]){
        ret = dict[word];
    }
    
    return ret;
}

-(NSDictionary *)getQuantityAndProductText:(NSString *)text{
    
    NSString *finalText = text;
    //NSMutableDictionary *ret = [[NSMutableDictionary alloc] init];
    //NSString *productText = @"";
    
    //remove extra space
    
    NSArray *finalTextArray = [finalText componentsSeparatedByString:@" "];
    
    finalText = @"";
    for(NSString *s in finalTextArray){
        finalText = [finalText stringByAppendingString:s];
        finalText = [finalText stringByAppendingString:@" "];
    }
    
    finalText = [finalText stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    finalTextArray = [finalText componentsSeparatedByString:@" "];
    
    //start extracting quantity from the input
    
    NSUInteger quantity = 0;
    NSString *productText = @"";
    
    //let's check quantity upto 4 words i.e. "one hundred sixty one" 161
    if(![finalTextArray[0] isEqualToString:@"a"]){
        NSUInteger lenarray = [finalTextArray count];
        if(lenarray == 1){
            productText = finalText;
        }
        else if(lenarray>1){
            //check for the first consecutive number words
            NSMutableArray *results =[[NSMutableArray alloc] init];
            NSUInteger index = 0;
            for(id word in finalTextArray){
                
                NSNumber *wordnumber = [self wordToNumber:word];
                if(wordnumber != nil){
                    [results addObject:wordnumber];
                }
                else{
                    break;
                }
                index++;
                if(index >= lenarray) break;
            }
            NSUInteger results_len = [results count];
            if(results_len > 0){
                if(results_len > 4){ //wewill limit to 4 words
                    results_len = 4;
                    productText = @"";
                    
                    index = 0;
                    for(id word in finalTextArray){
                        if(index>=results_len){
                            productText = [productText stringByAppendingString:word];
                        }
                    }
                }
                else{
                    if(results_len == 1){ //one, two...
                        quantity = [[results objectAtIndex:0] intValue];
                    }
                    else if(results_len == 2){ //twenty one, thrity two...
                        quantity = [[results objectAtIndex:1] intValue] + [[results objectAtIndex:0] intValue];
                    }
                    else if(results_len == 3){ //one hundred two, two hundred four...
                        quantity = [[results objectAtIndex:0] intValue] * [[results objectAtIndex:1] intValue] + [[results objectAtIndex:2] intValue];
                    }
                    else if(results_len == 4){ //one hundred thirty two, two hundred twenty four...
                        quantity = ([[results objectAtIndex:0] intValue] * [[results objectAtIndex:1] intValue])
                        + ([[results objectAtIndex:2] intValue] + [[results objectAtIndex:3] intValue]);
                    }
                    else{
                        //we should neverget here!!!
                        
                    }
                    
                    index =0;
                    productText = @"";
                    for(id word in finalTextArray){
                        if(index>=results_len){
                            productText = [productText stringByAppendingString:word];
                            productText = [productText stringByAppendingString:@" "];
                        }
                        index++;
                    }
                    productText = [productText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                    
                    
                }
            }
            
        }
    }
    
    //[ret addEntriesFromDictionary:@{@"produc": productText, @"quantity":quantity}];
    
    return @{@"product": productText, @"quantity": [[NSNumber alloc] initWithUnsignedLong:quantity]};
}

-(void)speech_displayMessage:(NSString *) text{
    
    
    BroadcastMessageAPI *message=[[BroadcastMessageAPI alloc] init];
    //NSLog(@"_txtMessage.attributedText=%@",_txtMessage.attributedText);
    message.text = text;//[_txtMessage.attributedText string];
    message.fromDeviceID=_appDelegate.mcManager.myPeerInfo.deviceID;
    message.message_type=MSG_TYPE_DEF;
    message.localCopy=YES;
    message.isBroadcast=NO;
    
    
    [_appDelegate.selectedStore addNewMessage:message];
}

- (void)speechAddToCartMessage:(NSString *) pText{
    // if(_txtMessage.text.length==0 && _attachedPhoto.image==nil)
    if(pText.length==0)
        return;
    
    //NSString *finalText = pText;
    NSDictionary *result = [self getQuantityAndProductText:pText];
    
    NSString *texttospeech = nil;
    if(result == nil){
        
        //[AppDelegate toast:@"I didn't get that." duration:1.0];
        
        //texttospeech = @"I didn't get that.";
        
        //AVSpeechSynthesizer *synthesizer = [[AVSpeechSynthesizer alloc]init];
        //[self speech_speak:texttospeech];
        displayText = @"I didn't get that.";
        utterText = displayText;
        [self speechSpeakAndDisplayMessage:displayText andUtterText:utterText];
        
        
        return;
    }
    
    NSUInteger quantity = [[result objectForKey:@"quantity"] intValue];
    NSString *productToSearch = [result objectForKey:@"product"];
    
    /*
    NSArray *results = [_selectedInventory searchProductsWithSpeech:productText];
    
    if ([results count] > 0){
        product = [results objectAtIndex:0];
        //NSString *name = [selected_product.name lowercaseString];
        //finalText = [finalText stringByReplacingOccurrencesOfString:name withString:@""];
        
        
    }
     */
    //[AppDelegate alert:productToSearch];
    Product *prod = [self speech_searchProducts:productToSearch];
    if(prod != nil){
        //NSArray *results=[_appDelegate.selectedStore.inventory searchProductsWithBarcode:barcode];
        //NSUInteger count=[results count];
        //if(count>0){
            //if(count==1){
                //_selectedProduct=[results firstObject];
                //if(_appDelegate.appConfig.barcodeAutoAddToCart) {
                    //create an orderitem from product the add to cart
                    //OrderItem *orderItem=[[OrderItem alloc] initWithProduct:_selectedProduct isLive:_appDelegate.appConfig.isLive withStoreID:_appDelegate.appConfig.device_id];
                    
                    OrderItem *orderItem=[[OrderItem alloc] initWithProduct:prod isLive:_appDelegate.selectedStore.isLive withStoreID:_appDelegate.selectedStore.peerInfo.deviceID];
        orderItem.quantity = quantity;
                    /*
                     if(_checkoutCart==nil)
                     _checkoutCart=[CheckoutCart sharedInstance];
                     [_checkoutCart addItem:orderItem];
                     */
                    [_appDelegate addToCart:orderItem product:prod];
        //UITabBarItem *tbi=(UITabBarItem *)[self.tabBarController.tabBar.items objectAtIndex:TAB_INDEX_CART];
        [_appDelegate updateCartBadge:self.tabBarController];
        
        displayText = [NSString stringWithFormat:@"%d %@ %@", (int)quantity, prod.name, @" added to your cart."];
        utterText = [NSString stringWithFormat:@"%d %@ %@", (int)quantity, prod.nameGrammar, @" added to your cart."];
        
        //texttospeech = [texttospeech stringByAppendingString:prod.name];
        [self speechSpeakAndDisplayMessage:displayText andUtterText:utterText];
                //}
                //else{
                //    [self performSegueWithIdentifier:@"toProductViewController" sender:nil];
                //}
            //}
            //else{ //>1
                //TODO: display selection
            //    [AppDelegate toast:@"Barcode is not unique!" duration:1.0];
            //}
        //}
        //else{
        //    [AppDelegate toast:@"Item not found!" duration:1.0];
        //}
        
    }
    else{
        //[AppDelegate toast:@"Item not found!" duration:1.0];
        displayText = @"Item not found!";
        utterText = displayText;
        [self speechSpeakAndDisplayMessage:displayText andUtterText:utterText];
    }
    
    
    
}


- (void)speech_completePayment{
    if(!_appDelegate.selectedStore.isConnected ){
        if(_appDelegate.selectedStore.allowDelivery || _appDelegate.selectedStore.allowPickUp){
            if(_appDelegate.selectedStore.allowPickUp){
                
                
            }
            else{ //(_appDelegate.selectedStore.allowDelivery){
                
            }
        }
        else{
            //[AppDelegate toast:@"Please connect to continue." duration:3.0];
            //[self speech_speak:@"Please connect to continue."];
            displayText = @"Please connect to continue.";
            utterText = displayText;
            [self speechSpeakAndDisplayMessage:displayText andUtterText:utterText];
        }
        return;
    }
    
    
    
    //[AppDelegate toast:@"Processing...please wait." duration:3];
    //[self speech_speak:@"Processing...please wait..."];
    displayText = @"Processing...please wait...";
    utterText = displayText;
    [self speechSpeakAndDisplayMessage:displayText andUtterText:utterText];
    
    CCardInfo *selectedCard;

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
                    /*
                    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:nil message:@"You haven't setup a default credit card to use." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Continue", nil];
                    [alert show];
                     */
                    //[self speech_speak:@"You haven't setup a default credit card to use."];
                    displayText = @"You haven't setup a default credit card to use.";
                    utterText = displayText;
                    [self speechSpeakAndDisplayMessage:displayText andUtterText:utterText];
                    
                }
            }
            else{
                /*
                UIAlertView *alert=[[UIAlertView alloc] initWithTitle:nil message:@"You haven't setup a default credit card to use." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Continue", nil];
                [alert show];
                */
                //[self speech_speak:@"You haven't setup a default credit card to use."];
                displayText = @"You haven't setup a default credit card to use.";
                utterText = displayText;
                [self speechSpeakAndDisplayMessage:displayText andUtterText:utterText];
                
            }
        }
        else{
            [self speech_completeOrder];
        }
    }
    else {
        
        [self speech_completeOrder];
    }
    
    
    
    
}
-(void)speech_completeOrder{
    NSArray *existing=[_appDelegate.historyModel searchPendingOrdersWithStore:_appDelegate.selectedStore isLive:_appDelegate.appConfig.isLive];
    
    if([existing count]>0){
        
        if([existing count]>0){
            
            for (int i=0; i<[existing count]; i++) {
                
                ((OrderHistory *)existing[i]).orderStatus=@ORDER_STATUS_FAILED;
            }
            [_appDelegate.historyModel saveHistory];
        }
        
    }
    
    [self speech_performCreateOrder ];
    
}

-(void)speech_performCreateOrder{
    OrderHistory *order=[self speech_createOrderFromCart];
    
    
    
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_NEW_ORDER object:nil userInfo:@{@"order":order}];
    
    
    
    [self.navigationController popToRootViewControllerAnimated:YES];
    
    if(_appDelegate.isIpad){
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_SHOW_ORDERHISTORY object:nil];
    }
    
    //[self.tabBarController setSelectedIndex:TAB_INDEX_CHAT];
    
    //[self spee]
    
    
    
}

-(NSInteger)speech_computeTotals{
    
    /*
     NSInteger confirmed_totalCents;
     NSInteger totalCents;
     NSInteger totalCentsBeforeTip;
     float totalTip;
     NSNumberFormatter *nf;
     
     NSMutableArray *discounts;
     NSInteger totalDiscount;
     */
    //[_appDelegate.selectedStore addNewMessage:message];
    CheckoutCart *cart = _appDelegate.selectedStore.cart;
    NSInteger totalCents=[cart total];
    
    //minus discounts
    //skippe for now
    /*
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
     */
    
    //add tax
    
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
    
    /*
    NSInteger totalCentsBeforeTip=totalCents;
    
    if(totalTip<0)
        totalTip=0;
    
    if(totalTip>0){
        totalCents=totalCents+(totalTip*100);
        //[_tipButton setTitle:@"Change Tip" forState:UIControlStateNormal];
    }
    else{
        //[_tipButton setTitle:@"Add Tip" forState:UIControlStateNormal];
    }
     */
    return totalCents;
}

-(OrderHistory *)speech_createOrderFromCart{
    //2
    //CheckoutCart* checkoutCart = [CheckoutCart sharedInstance];
    
    NSInteger totalCents = [self speech_computeTotals];
    
    
    
    NSInteger confirmed_totalCents=totalCents;
    
    //NSString* textLabel=[_appDelegate.selectedStore.cart textLabel:[_appDelegate.selectedStore.inventory_dict valueForKey:deviceNameKey] storeID:[_appDelegate.selectedStore.inventory_dict valueForKey:deviceIDKey]];
    NSString* textLabel=[_appDelegate.selectedStore.cart textLabel:_appDelegate.selectedStore.storeName storeID:_appDelegate.selectedStore.deviceID];
    
    
    
    NSString *stripeCurrency = (_appDelegate.selectedStore.inventory.currency.length==0)?@"usd":_appDelegate.selectedStore.inventory.currency;
    
    
    NSString *stripeDescription = textLabel;//@"Purchase from Portico iOS app!";
    
    
    
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSString *today=[dateFormatter stringFromDate:[NSDate date]];
    
    
    
    OrderHistory *order=[[OrderHistory alloc] init];
    
    CCardInfo *selectedCard;

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
    
    order.orderBy=selectedCard.name;//self.nameTextField.text;
    //order.orderTableNumber=self.tableNumberTextField.text;
    //order.orderDiscountCode=self.promoCodeTextField.text;
    
    /* skipped
    if(totalTip<0)
        totalTip=0;
    
    order.orderTip=totalTip*100;
    */
    
    order.orderID=[[[NSUUID UUID] UUIDString] lowercaseString];
    order.orderNumber=@0;
    order.chargePayType=ORDER_PAY_TYPE_CCARD;
    
    //get order items
    order.orderItems=[NSArray arrayWithArray:_appDelegate.selectedStore.cart.itemsArray];
    /* skipped
    if([discounts count]>0){
        order.orderDiscounts=[NSArray arrayWithArray:discounts];
    }
    */
    
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
    //[self updateCartBadge];
     [_appDelegate updateCartBadge:self.tabBarController];
    return order;
    
    
}
-(void)textViewDidChange:(UITextView *)textView{
    
    //self.attachedPhoto.image=nil;
    [_attachButton setEnabled:YES];
    [textView.attributedText enumerateAttribute:NSAttachmentAttributeName
                                        inRange:NSMakeRange(0, [textView.attributedText length])
                                        options:0
                                     usingBlock:^(id value, NSRange range, BOOL *stop)
     {
         if ([value isKindOfClass:[NSTextAttachment class]])
         {
             NSTextAttachment *attachment = (NSTextAttachment *)value;
             //UIImage *image = nil;
             if ([attachment image])
                 //image = [attachment image];
             /*else
              image = [attachment imageForBounds:[attachment bounds]
              textContainer:nil
              characterIndex:range.location];
              
              if (image){
              //[imagesArray addObject:image];
              //_attachedPhoto.image=image;
              [_attachButton setEnabled:NO];
              }
              else{
              [_attachButton setEnabled:YES];
              }
              */
                 [_attachButton setEnabled:NO];
         }
     }];
    
    // if(self.attachedPhoto.image!=nil)
    //     [_attachButton setEnabled:NO];
    // else
    //     [_attachButton setEnabled:YES];
    
}

- (BOOL)textView:(UITextView*)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString*)text
{
    
    if ([textView.text isEqualToString:YOUR_MESSAGE_HERE]) {
        textView.text=@"";
        return YES;
        
    }
    else if(text.length==0 && textView.text.length==1){
        [self textViewPlaceHolder:textView text:YOUR_MESSAGE_HERE];
        return NO;
    }
    
    BOOL isMaxedChars=textView.text.length+(text.length-range.length)>MAX_CHARS_CHAT;
    if(isMaxedChars){
        [AppDelegate toast:[NSString stringWithFormat:@"%@ characters exceeded.",@(MAX_CHARS_CHAT)] duration:2.0];
        return NO;
    }
    else
        return YES;
    
    return YES;
    
}


-(void)textViewDidBeginEditing:(UITextView *)textView{
    /*CGRect frame=[self.tableView frame];
     frame.size.height-=200;
     [self.tableView setFrame:frame];
     */
    if([textView.text isEqualToString:YOUR_MESSAGE_HERE]){
        textView.text=@"";
    }
    if(textView.text.length==0){
        [self textViewPlaceHolder:textView text:YOUR_MESSAGE_HERE];
        
    }
}

-(void)textViewDidEndEditing:(UITextView *)textView{
    //[self.navigationController setNavigationBarHidden:NO animated:YES];
}

-(void)textViewPlaceHolder:(UITextView *)textView text:(NSString *)text{
    //UIFont *font=textView.font;
    NSDictionary *attrsDictionary=[NSDictionary dictionaryWithObject:textView.font forKey:NSFontAttributeName];
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text attributes:attrsDictionary];
    
    /* i can use this for image
     NSTextAttachment *textAttachment = [[NSTextAttachment alloc] init];
     textAttachment.image = chosenImage;//[UIImage imageNamed:@"sample_image.jpg"];
     
     CGFloat oldWidth = textAttachment.image.size.width;
     
     //I'm subtracting 10px to make the image display nicely, accounting
     //for the padding inside the textView
     CGFloat scaleFactor = oldWidth / (_txtMessage.frame.size.width - 10);
     textAttachment.image = [UIImage imageWithCGImage:textAttachment.image.CGImage scale:scaleFactor orientation:UIImageOrientationUp];
     NSAttributedString *attrStringWithImage = [NSAttributedString attributedStringWithAttachment:textAttachment];
     //if(_txtMessage.text.length>0){
     // [attributedString replaceCharactersInRange:NSMakeRange(6, 1) withAttributedString:attrStringWithImage];
     // [attributedString replaceCharactersInRange:NSMakeRange(6, 1) withAttributedString:attrStringWithImage];
     [attributedString appendAttributedString:attrStringWithImage];
     
     // }
     //[_txtMessage.attributedText ]
     */
    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:NSMakeRange(0, text.length)];
    textView.attributedText = attributedString;
    dispatch_async(dispatch_get_main_queue(), ^{
        textView.selectedRange=NSMakeRange(0, 0);
    });
    
}

- (void)sendFile{
    
}
//- (IBAction)cancelMessage:(id)sender {
- (void)cancelMessage{
    //[_txtMessage resignFirstResponder];
    [_txtMessage resignFirstResponder];
    
    //CGRect frame=self.tableView.frame;
    //frame.origin.y=self.sendMessageView.frame.origin.y;
    
    
    //[self.sendMessageView setHidden:YES];
    [self hideCompose:YES];
    
    //[self.broadcastButton setEnabled:YES];
    
    //self.tableView.frame=frame;

}

- (void)clearMessage{
    self.txtMessage.text=@"";
    
        [self textViewPlaceHolder:_txtMessage text:YOUR_MESSAGE_HERE];
   
}

#pragma mark - UIPicker configuration

- (void)configurePickerView {
    /*self.expirationDatePicker = [[UIPickerView alloc] init];
     self.expirationDatePicker.delegate = self;
     self.expirationDatePicker.dataSource = self;
     self.expirationDatePicker.showsSelectionIndicator = YES;
     */
    //Create and configure toolabr that holds "Done button"
    pickerToolbar = [[UIToolbar alloc] init];
    pickerToolbar.barStyle = UIBarStyleDefault;
    [pickerToolbar sizeToFit];
    
    flexibleSpaceLeft = [[UIBarButtonItem alloc]
                                          initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                          target:nil
                                          action:nil];
    
    /*UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                   style:UIBarButtonItemStyleBordered
                                                                  target:self
                                                                  action:@selector(pickerDoneButtonPressed)];
    */
    cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel"
                                                                   style:UIBarButtonItemStyleBordered
                                                                  target:self
                                                                  action:@selector(cancelMessage)];
    
    clearButton = [[UIBarButtonItem alloc] initWithTitle:@"Clear"
                                                                    style:UIBarButtonItemStyleBordered
                                                                   target:self
                                                                   action:@selector(clearMessage)];
    sendButton = [[UIBarButtonItem alloc] initWithTitle:[NSString stringWithFormat:@"Send to %@",(selectedDeviceName!=nil)?selectedDeviceName:@"everyone"]
                                                                   style:UIBarButtonItemStyleBordered
                                                                  target:self
                                                                  action:@selector(sendMessage)];
    
    /*UIBarButtonItem *sendFile = [[UIBarButtonItem alloc] initWithTitle:@"Send Photo"
                                                                   style:UIBarButtonItemStyleBordered
                                                                  target:self
                                                                  action:@selector(sendMessage)];
    */
    //[pickerToolbar setItems:[NSArray arrayWithObjects:flexibleSpaceLeft, clearButton,sendButton, nil]];
    
     [pickerToolbar setItems:[NSArray arrayWithObjects:sendButton,flexibleSpaceLeft, cancelButton,clearButton,nil]];
    
    
    /*self.expirationDateTextField.inputView = self.expirationDatePicker;
     self.expirationDateTextField.inputAccessoryView = pickerToolbar;
     self.nameTextField.inputAccessoryView = pickerToolbar;
     self.emailTextField.inputAccessoryView = pickerToolbar;
     self.cardNumber.inputAccessoryView = pickerToolbar;
     self.CVCNumber.inputAccessoryView = pickerToolbar;
     self.tableNumberTextField.inputAccessoryView=pickerToolbar;
     */
    
    self.txtMessage.inputAccessoryView=pickerToolbar;
}


- (void)pickerDoneButtonPressed {
    [self.view endEditing:YES];
}
/*
-(void)showSendMessageNotification:(NSNotification *)notification{
    //[self loadBgPhoto];
    NSDictionary *to= [notification.userInfo valueForKey:@"to"];
 
}
*/
- (IBAction)showSendPrivate:(id)sender {
    

    if(selectedDeviceId==nil){
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:nil message:@"Please select a person to continue." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }
    if(!_appDelegate.isIpad)
      [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    //[sendButton setTitle:[NSString stringWithFormat:@"Send to %@",(selectedDeviceName!=nil)?selectedDeviceName:@"everyone"]];
    _toLabel.text=[NSString stringWithFormat:@"To: %@",selectedDeviceName];
    [self hideCompose:NO];
    
    
    //  _txtMessage.placeholder=@"Your message to everyone.";
    //[_txtMessage becomeFirstResponder];
    [_attachButton setEnabled:YES];

}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
   
}
- (IBAction)broadcastButtonTapped:(id)sender {
    if(![_appDelegate isConnected]){
        [AppDelegate toast:@"Not connected. Please connect to send a message." duration:2.0];
        return;
    }
    selectedDeviceId=nil;
    selectedDeviceName=@"everyone";
    _toLabel.text=[NSString stringWithFormat:@"To: everyone"];
    //[self.navigationController setNavigationBarHidden:YES animated:YES];
// [sendButton setTitle:[NSString stringWithFormat:@"Send to %@",selectedDeviceName]];
   [sendButton setTitle:@"Send"];
    

    [self hideCompose:NO];

    
  //  _txtMessage.placeholder=@"Your message to everyone.";
    [_txtMessage becomeFirstResponder];
    [_attachButton setEnabled:YES];
   


}

- (IBAction)sendButtonTapped:(id)sender {
    [self sendMessage];
}


- (IBAction)cancelButtonTapped:(id)sender {
    [self cancelMessage];
   
}
- (IBAction)menuButtonTapped:(id)sender {
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self.txtMessage becomeFirstResponder];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    
    UIImage *chosenImage=info[UIImagePickerControllerEditedImage];
   
   
    
    //[_attachedPhoto setImage:chosenImage];
    
    [picker dismissViewControllerAnimated:YES completion:^{
    
        [self finalAttachmentImage:chosenImage];
    
    }];
}

-(void)finalAttachmentImage:(UIImage *)chosenImage{
    UIFont *fontt=_txtMessage.font;
    
    NSDictionary *attrsDictionary=[NSDictionary dictionaryWithObject:_txtMessage.font forKey:NSFontAttributeName];
    
    //NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:_txtMessage.text];
NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:_txtMessage.text attributes:attrsDictionary];
    NSTextAttachment *textAttachment = [[NSTextAttachment alloc] init];
    textAttachment.image = chosenImage;//[UIImage imageNamed:@"sample_image.jpg"];
    
    CGFloat oldWidth = textAttachment.image.size.width;
    
    //I'm subtracting 10px to make the image display nicely, accounting
    //for the padding inside the textView
    CGFloat scaleFactor = oldWidth / (_txtMessage.frame.size.width - 10);
    textAttachment.image = [UIImage imageWithCGImage:textAttachment.image.CGImage scale:scaleFactor orientation:UIImageOrientationUp];
    NSAttributedString *attrStringWithImage = [NSAttributedString attributedStringWithAttachment:textAttachment];
    //if(_txtMessage.text.length>0){
    // [attributedString replaceCharactersInRange:NSMakeRange(6, 1) withAttributedString:attrStringWithImage];
    // [attributedString replaceCharactersInRange:NSMakeRange(6, 1) withAttributedString:attrStringWithImage];
    [attributedString appendAttributedString:attrStringWithImage];
    
    // }
    //[_txtMessage.attributedText ]
    
    _txtMessage.attributedText = attributedString;
    
    [_txtMessage setFont:fontt];
    
    [_attachButton setEnabled:NO];
    [_txtMessage becomeFirstResponder];
}

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

#pragma mark Actions
-(void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{
    NSString *title= [actionSheet buttonTitleAtIndex:buttonIndex];
    
    
    if([title isEqualToString:@"Take Photo"]){
        [self takePhotoActionn];
    }
    else if([title isEqualToString:@"Select Photo"]){
        
        //[self selectPhotoAction];
        [self showResizablePicker];
    }
    else{
        [self.txtMessage becomeFirstResponder];
    }
    
    
}

- (IBAction)selectPhotoAction {
    self.pickerPhoto=[[UIImagePickerController alloc] init];
    self.pickerPhoto.modalPresentationStyle=UIModalPresentationCurrentContext;
    self.pickerPhoto.delegate=self;
    self.pickerPhoto.allowsEditing=YES;
    
    self.pickerPhoto.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:self.pickerPhoto animated:YES
                     completion:NULL];
    
}

-(void)takePhotoActionn{
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
        [self performSelector:@selector(showCamera) withObject:nil afterDelay:0.3];
        
        /*UIImagePickerController *picker=[[UIImagePickerController alloc] init];
         picker.delegate=self;
         picker.allowsEditing=YES;
         picker.sourceType=UIImagePickerControllerSourceTypeCamera;
         [self presentViewController:picker animated:YES
         completion:NULL];
         */
    }
}

-(void)peerDidChangeStateWithNotification:(NSNotification *)notification{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        
        
        MCSessionState state = [[[notification userInfo] objectForKey:@"state"] intValue];
        
        if (state == MCSessionStateConnected) {
            
            /*
            self.navigationItem.leftBarButtonItems=@[self.broadcastButton,usersButtonItem];
            
            if(_appDelegate.isIpad){
                self.navigationItem.rightBarButtonItems=@[menuButtonItem,ordersButtonItem,settingsButtonItem];
                
            }
            else{
                self.navigationItem.rightBarButtonItems=@[menuButtonItem];
            }
             */

            
        }
        else if(state == MCSessionStateNotConnected) {
            [audioSwitch setOn:NO];
            
            _appDelegate.isAudioON=audioSwitch.on;
            
           /*
            self.navigationItem.leftBarButtonItems=nil;
            self.navigationItem.rightBarButtonItems=nil;
            */
            
        }
    });
    
}

- (void)showCamera {
    /*pickerCamera = [[UIImagePickerController alloc] init];
     [pickerCamera setDelegate:self];
     [pickerCamera setSourceType:UIImagePickerControllerSourceTypeCamera];
     [pickerCamera setAllowsEditing:YES];
     
     [self presentModalViewController:pickerCamera animated:YES];
     */
    UIImagePickerController *picker=[[UIImagePickerController alloc] init];
    picker.delegate=self;
    picker.allowsEditing=YES;
    picker.sourceType=UIImagePickerControllerSourceTypeCamera;
    [self presentViewController:picker animated:YES
                     completion:NULL];
}

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
        [self.tableView reloadData];
    });
    
    
}

-(void)didReceiveUpdatePeers:(NSNotification *)notification{
        dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}
- (IBAction)menuAction:(id)sender {
    
    if(_appDelegate.selectedStore.inventory!=nil && [_appDelegate.selectedStore.inventory.categories count]==0){
        
            [AppDelegate toast:@"Menu is not available at this time. Please try again later." duration:3.0];
        
    }
    else{
        [self performSegueWithIdentifier:@"toOrderViewController" sender:self];
    }
    
}
/*
-(BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{
    if([viewController isKindOfClass:[DummyViewController class]]){
        
        //[[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_SHOW_ORDERHISTORY object:nil];
        return NO;
        
    }
    else{
        return YES;
    }
    
}
 */

- (IBAction)clearAllAction:(id)sender {
    
    //[self show:NOTIFY_SHOW_USERS];
    [_appDelegate.selectedStore.messages removeAllObjects];
    [self setEditing:NO];
    
    [self.tableView reloadData];
    //[self.tableView setEditing:NO];
    
}

# pragma mark -
# pragma mark GKImagePicker Delegate Methods

- (void)imagePicker:(GKImagePicker *)imagePicker pickedImage:(UIImage *)image{
    
    UIImage *chosenImage = image;
    
    
    

    if (UIUserInterfaceIdiomPad == UI_USER_INTERFACE_IDIOM()) {
        
        [self.popOver dismissPopoverAnimated:YES];
        [self finalAttachmentImage:chosenImage];
        
    } else {
        
        [self.imagePicker.imagePickerController dismissViewControllerAnimated:YES completion:^{
            [self finalAttachmentImage:chosenImage];
        }];
        
    }
}


-(void)showResizablePicker{
    self.imagePicker = [[GKImagePicker alloc] init];
    self.imagePicker.cropSize = CGSizeMake(296, 300);
    self.imagePicker.delegate = self;
    self.imagePicker.resizeableCropArea = YES;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        
        self.popOver = [[UIPopoverController alloc] initWithContentViewController:self.imagePicker.imagePickerController];
        //[self.popoverController presentPopoverFromRect:btn.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        //[self.popoverController presentPopoverFromBarButtonItem:_doneButton permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        [self.popOver presentPopoverFromRect:CGRectZero inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        
    } else {
        
        //[self presentModalViewController:self.imagePicker.imagePickerController animated:YES];
        
        [self presentViewController:self.imagePicker.imagePickerController  animated:YES completion:nil];
    }
}

@end
