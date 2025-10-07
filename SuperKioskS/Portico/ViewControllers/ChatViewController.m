//
//  FirstViewController.m
//
//
//  Created by Romulo Quidilig.
//  Copyright (c) 2015 Sharecle Inc. All rights reserved.
//

#import "ChatViewController.h"
#import "AppDelegate.h"
#import "MessageNBCell.h"
#import "MessageTableViewCell.h"
#import "MessageTableViewData.h"
#import "BroadcastMessageAPI.h"

#import "MessageWithImageTableViewCell.h"
#import "MessageWithImageAndMediaCell.h"
#import "SpeechBubbleView.h"
#import "NSData+Conversion.h"
#import "Order.h"
#import "OrderItem.h"

#import "HistoryModel.h"
#import "OrderHistory.h"
//#import "SWRevealViewController.h"
#import "ChatImageOnlyCell.h"
#import "ChatTextOnlyCell.h"
#import "ChatImageOnlyCustCell.h"
#import "ChatTextOnlyCustCell.h"
//#import <AudioToolbox/AudioToolbox.h>
//#import "PeerListViewController_iPhone.h"
//#import "ArticleListViewController_iPad.h"
#import "NSData+Conversion.h"
#import "Util.h"
#import "SoundController.h"
#import "defs.h"



//const CGFloat MinBubbleWidth = 50;   // minimum width of the bubble
//const CGFloat MinBubbleHeight = 40;  // minimum height of the bubble


//const CGFloat WrapWidth = 200;       // maximum width of text in the bubble
//const CGFloat WrapWidthIpad = 400;


@interface ChatViewController ()
{
    //UIFont* font;
    //NSArray *paths;
    UIImage *_myPhoto;
    UITabBarItem *tbiChat;
    
     NSDateFormatter* formatter;
   // UIBarButtonItem *attachFileButton;
   // BOOL isEditing;
    UISwitch *audioSwitch;
    UIBarButtonItem *audioButtonItem;
    
    NSString *selectedDeviceId;
    NSString *selectedDeviceName;
    
    //UIBarButtonItem *usersButtonItem;
    //UIBarButtonItem *menuButtonItem;
    //UIBarButtonItem *ordersButtonItem;
     UIBarButtonItem *clearAllButtonItem;
    //UIBarButtonItem *settingsButtonItem;
    
    UIBarButtonItem *cancelButton;
    UIBarButtonItem *clearButton;
    UIBarButtonItem *sendButton;
    
    UIBarButtonItem *_settingsButton;
    
    //UIBarButtonItem *_usersButtonItem;
    NSMutableArray *_selectedUsers;

    UIToolbar *pickerToolbar;
    UIBarButtonItem *flexibleSpaceLeft;
    
    SoundController *_soundController;
}


//-(void)sendMyMessage:(NSString *)text;
//-(void)didReceiveDataWithNotification:(NSNotification *)notification;
//-(void)didReceiveVoiceDataWithNotification:(NSNotification *)notification;
//-(void)didReceiveControlDataWithNotification:(NSNotification *)notification;

@end

@implementation ChatViewController

//@synthesize audioSwitch;//, gainValueLabel, audioProcessor;

//static CGFloat const kNavigationBarPortraitHeight = 44;
//static CGFloat const kNavigationBarLandscapeHeight = 34;
//static CGFloat const kToolBarHeight = 49;
static CGFloat const kComposeBarHeight=150;
static CGFloat const kComposeBarHeightIpad=200;
//- (CGSize)sizeForText:(NSString*)text
//{
//    /*CGSize textSize = [text sizeWithFont:font
//     constrainedToSize:CGSizeMake(WrapWidth, 9999)
//     lineBreakMode:NSLineBreakByWordWrapping]; */
//    
//    /*CGSize textSize = [text sizeWithFont:font
//     constrainedToSize:CGSizeMake((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)?WrapWidthIpad:WrapWidth, 9999)
//     lineBreakMode:NSLineBreakByWordWrapping];
//     */
//    CGRect textRect = [text boundingRectWithSize:CGSizeMake((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)?400:200, 9999)
//                                         options:NSStringDrawingUsesLineFragmentOrigin
//                                      attributes:@{NSFontAttributeName:font}
//                                         context:nil];
//    CGSize textSize =textRect.size;
//    
//    
//    
//    
//    
//    CGSize bubbleSize;
//    bubbleSize.width = textSize.width;// + TextLeftMargin + TextRightMargin;
//    bubbleSize.height = textSize.height;// + TextTopMargin + TextBottomMargin;
//    
//    if (bubbleSize.width < 50)
//        bubbleSize.width = 50;
//    
//    if (bubbleSize.height < 40)
//        bubbleSize.height = 40;
//    
//    // bubbleSize.width += HorzPadding*2;
//    // bubbleSize.height += VertPadding*2;
//    
//    return bubbleSize;
//}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self. view.backgroundColor=[UIColor clearColor];
    [self loadBgPhoto];
    _appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    _soundController=[SoundController sharedInstance];
    //menuButtonItem=[self createBarButtonItem:@"Menu" withImageName:@"Menu Filled" withAction:@selector(showMenuAction:)];
    
    _selectedUsers=[NSMutableArray new];
    
    //_usersButtonItem=[self createBarButtonItem:@"Users" withImageName:nil withAction:@selector(usersButtonTapped:)];
    
    _settingsButton=[self createBarButtonItem:@"Settings" withImageName:nil withAction:@selector(settingsButtonTapped:)];
    
    clearAllButtonItem=[self createBarButtonItem:@"Clear" withImageName:nil withAction:@selector(clearAllAction:)];
    
    self.broadcastButton=[self createBarButtonItem:@"Compose" withImageName:@"Create" withAction:@selector(broadcastButtonTapped:)];

    
    if(_appDelegate.isIpad){
    
    //ordersButtonItem=[self createBarButtonItem:@"Orders" withImageName:@"Check" withAction:@selector(showOrdersAction:)];
   
        //ordersButtonItem=[self createBarButtonItem:@"Orders" withImageName:@"Check" withAction:@selector(showOrdersAction:)];
       // ordersButtonItem=[[UIBarButtonItem alloc] initWithTitle:[NSString stringWithFormat:@"Orders%@",(_appDelegate.badgeOrderNumber>0)?[NSString stringWithFormat:@"(%@)",@(_appDelegate.badgeOrderNumber)]:@""] style:UIBarButtonItemStyleBordered target:self action:@selector(showOrdersAction:)];
        
    
    
        //self.navigationItem.rightBarButtonItems=@[menuButtonItem,ordersButtonItem];
        
    }
    else{
        //self.navigationItem.rightBarButtonItems=@[menuButtonItem];
    }

    //usersButtonItem=[self createBarButtonItem:@"Users" withImageName:@"User Group" withAction:@selector(showSettngsAction:)];
    
    //usersButtonItem=[self createBarButtonItem:@"Users" withImageName:nil withAction:@selector(showUsersAction:)];
    
    clearAllButtonItem=[self createBarButtonItem:@"Clear" withImageName:nil withAction:@selector(clearAllAction:)];
    
    self.broadcastButton=[self createBarButtonItem:@"Compose" withImageName:@"Create" withAction:@selector(broadcastButtonTapped:)];

    //exclude users for now.
   // self.navigationItem.leftBarButtonItems=@[self.broadcastButton];

    formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterShortStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDoesRelativeDateFormatting:YES];

    
    /*SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
    {
        [self.sidebarButton setTarget: self.revealViewController];
        [self.sidebarButton setAction: @selector( revealToggle: )];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
    */
    audioSwitch=[[UISwitch alloc] init];
    [audioSwitch addTarget:self action:@selector(audioSwitchAction:) forControlEvents:UIControlEventValueChanged];
    [audioSwitch setOn:NO];
    audioButtonItem=[[UIBarButtonItem alloc] initWithCustomView:audioSwitch];
   // self.broadcastButton=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Create"] style:UIBarButtonItemStyleBordered target:self action:@selector(broadcastButtonTapped:)];
    

     //self.navigationItem.rightBarButtonItems=@[self.broadcastButton];
    
    [self textViewPlaceHolder:_txtMessage text:YOUR_MESSAGE_HERE];
    
    _attachedPhoto=[UIImageView new];
    
    tbiChat=(UITabBarItem *)[self.tabBarController.tabBar.items objectAtIndex:TAB_INDEX_CHAT];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didUpdateMessagesNotification:)
                                                 name:NOTIFY_UPDATE_MESSAGES
                                               object:nil];
    
  /*  [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didReceivePeerBgPhotoNotification:)
                                                 name:NOTIFY_RECEIVED_PEER_BGPHOTO2
                                               object:nil];*/
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(showSendMessageNotification:)
                                                 name:NOTIFY_SHOW_SENDMESSAGE
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(showSendMessageNotification:)
                                                 name:NOTIFY_SHOW_SENDMESSAGE
                                               object:nil];
    
    
    if(_appDelegate.isIpad){
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(badgeUpdateForOrders)
                                                     name:NOTIFY_UPDATEBADGE_ORDERS
                                                   object:nil];
        
    }
    
    //font = [UIFont systemFontOfSize:[UIFont systemFontSize]];
    
    if(_appDelegate.messages==nil)
        _appDelegate.messages=[NSMutableArray new];
    
    
    _txtMessage.delegate = self;
    
    
    //paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *filePath=[[AppDelegate getDocumentsPath] stringByAppendingPathComponent:@"myphoto.png"];
    
    if([[NSFileManager defaultManager] fileExistsAtPath:filePath]){
        
        _myPhoto=[[UIImage alloc] initWithContentsOfFile:filePath];
    }
    else{
        
        _myPhoto=[UIImage imageNamed:@"person.png"];
    }
    
    
    
    /*UIImageView *tempImageView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@""]];
     [tempImageView setFrame:self.tableView.frame];
     */
    self.tableView.backgroundColor=[UIColor clearColor];
    
   
  //  [self.tableView setFrame:[self maximumUsableFrame]];
    
    [self hideCompose:YES];
    
    
    
    
}

-(UIBarButtonItem *)createBarButtonItem:(NSString *)title withImageName:(NSString *)imageName withAction:(SEL)action{
    
    if(imageName){
        
        if(_appDelegate.isIpad){
            
            UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
            [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
            [button setTitle:title forState:UIControlStateNormal];
            [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor blueColor] forState:UIControlStateSelected];
            [button addTarget:self  action:action forControlEvents:UIControlEventTouchUpInside];
            [button sizeToFit];
            return [[UIBarButtonItem alloc] initWithCustomView:button];
        }
        else{
            UIBarButtonItem *bi= [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStyleBordered target:self action:action];
            return bi;
        }
        
    }
    else{
        UIBarButtonItem *bi= [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStyleBordered target:self action:action];
        return bi;
    }
    
    
}

//-(CGRect) maximumUsableFrame {
//    /*
//    static CGFloat const kNavigationBarPortraitHeight = 44;
//    static CGFloat const kNavigationBarLandscapeHeight = 34;
//    static CGFloat const kToolBarHeight = 49;
//     */
//    //static CGFloat const kInputTextHeight = 100; //rom added
//    // Start with the screen size minus the status bar if present
//    CGRect maxFrame = [UIScreen mainScreen].applicationFrame;
//    
//    // If the orientation is landscape left or landscape right then swap the width and height
//    if (UIInterfaceOrientationIsLandscape(self.interfaceOrientation)) {
//        CGFloat temp = maxFrame.size.height;
//        maxFrame.size.height = maxFrame.size.width;
//        maxFrame.size.width = temp;
//    }
//    
//    // Take into account if there is a navigation bar present and visible (note that if the NavigationBar may
//    // not be visible at this stage in the view controller's lifecycle.  If the NavigationBar is shown/hidden
//    // in the loadView then this provides an accurate result.  If the NavigationBar is shown/hidden using the
//    // navigationController:willShowViewController: delegate method then this will not be accurate until the
//    // viewDidAppear method is called.
//    if (self.navigationController) {
//        if (self.navigationController.navigationBarHidden == NO) {
//            
//            // Depending upon the orientation reduce the height accordingly
//            if (UIInterfaceOrientationIsLandscape(self.interfaceOrientation)) {
//                maxFrame.size.height -= kNavigationBarLandscapeHeight;
//                //rom added to adjust y pos
//                maxFrame.origin.y+=kNavigationBarLandscapeHeight;//+4;
//            }
//            else {
//                maxFrame.size.height -= kNavigationBarPortraitHeight;
//                //rom added to adjust y pos
//                maxFrame.origin.y+=kNavigationBarPortraitHeight;//+4;
//            }
//        }
//    }
//    
//    // Take into account if there is a toolbar present and visible
//    if (self.tabBarController) {
//        if (!self.tabBarController.view.hidden) maxFrame.size.height -= kToolBarHeight;
//    }
//    
//    //maxFrame.size.height -= kInputTextHeight;
//    
//    return maxFrame;
//}


- (void)viewDidUnload
{
  //  [self setAudioSwitch:nil];
    // [self setGainValueLabel:nil];
    //[self setTopLabel:nil];
    [super viewDidUnload];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    //if(_appDelegate==nil)
      //  _appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
   // [self badgeUpdateForOrders];
    /*if(_appDelegate.mcManager.serverPeerInfo!=nil && _appDelegate.mcManager.serverPeerInfo.peerID!=nil && _appDelegate.mcManager.serverPeerInfo.sessionState==MCSessionStateConnected)
    {
     */
        //righ now we disable voice
        
       // self.navigationItem.leftBarButtonItems=@[self.broadcastButton,usersButtonItem];
        
    /*}
    else{
        
        self.navigationItem.leftBarButtonItems=nil;
        
        
    }
     */
    //[self.tableView reloadData];
    int badgeValue=[tbiChat.badgeValue intValue];
    if(badgeValue>0){
        //badgeValue--;
        //tbi.badgeValue=[NSString stringWithFormat:@"%d",badgeValue];
        [self.tableView reloadData];
    }
    [self configurePickerView];
    //if([_appDelegate.appConfig.device_ssid isEqualToString:[AppDelegate currentWifiSSID]]){
    /*uncomment to suppert audio
    _appDelegate.appConfig.device_ssid=[AppDelegate currentWifiSSID];
    if(_appDelegate.appConfig.device_ssid.length>0){
        
            self.navigationItem.rightBarButtonItems=@[self.broadcastButton,audioButtonItem];
        }
        else{
            self.navigationItem.rightBarButtonItems=@[self.broadcastButton];
        }
    */
    //self.tableView.frame=[self maximumUsableFrame];
    if(_appDelegate.appConfig.user_usepin)
        [_appDelegate lockDevice];

}
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
        [_tableView reloadData];
        if(_appDelegate.messages.count>0){
            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:_appDelegate.messages.count-1] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
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
    //if(isEditing)
     //   return 0;
    NSInteger count=_appDelegate.messages.count;
    if(count>0){
        //self.navigationItem.leftBarButtonItems=@[ usersButtonItem,self.broadcastButton,self.editButtonItem];
        self.navigationItem.leftBarButtonItems=@[ self.broadcastButton,self.editButtonItem];
    }
    else{
        //self.navigationItem.leftBarButtonItems=@[self.broadcastButton,usersButtonItem];
        self.navigationItem.leftBarButtonItems=@[self.broadcastButton];
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
  //  if (isEditing)
   //     return 0;
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
    
   
    BroadcastMessageAPI* message = (_appDelegate.messages)[indexPath.section];    
    
    
    
    if(![message.isread isEqualToNumber:@1])
    {
        message.isread=@1;
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
            }
    
    BOOL isCustomer=YES;
    /* this always retrun 0 so we will use for loop instead
     NSPredicate *predicate=[NSPredicate predicateWithFormat:@"(DeviceId==%@) AND (PeerGroup==%@)",message.fromDeviceID,PEER_GROUP_CUSTOMERS];
     
     NSArray *result=[_appDelegate.mcManager.serverPeerInfo.peers filteredArrayUsingPredicate:predicate];
     if ([result count]>0)
     isCustomer=YES;
     */
    if([_appDelegate.mcManager.myPeerInfo.deviceID isEqualToString:message.fromDeviceID]){
        //if ([_appDelegate.mcManager.myPeerInfo.group isEqualToString:PEER_GROUP_STAFFS])
            isCustomer=NO;
        
        
    }
    /*else if([_appDelegate.mcManager.myPeerInfo.deviceID isEqualToString:message.fromDeviceID]){
        isCustomer=NO;
    }
     */
    else{
        
        for(NSDictionary *p in _appDelegate.mcManager.myPeerInfo.peers){
            if([[p valueForKey:DeviceIdKey] isEqualToString:message.fromDeviceID] && [[p valueForKey:@"PeerGroup"] isEqualToString:PEER_GROUP_STAFFS] ){
                isCustomer=NO;
                break;
            }
            
        }
    }
    
    if(message.imagefileuid==nil || message.imagefileuid.length==0){
        if (isCustomer)
            return [self messageTextOnlyCustCellForRowAtIndexPath:message];
        else
            return [self messageTextOnlyCellForRowAtIndexPath:message];
    }
    else{
        if (isCustomer)
            return [self messageImageOnlyCustCellForRowAtIndexPath:message];
        else
            return [self messageImageOnlyCellForRowAtIndexPath:message];
    }

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

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    BroadcastMessageAPI* message = (_appDelegate.messages)[indexPath.section];//_messages[indexPath.row];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    selectedDeviceId=message.fromDeviceID;
    selectedDeviceName=message.sender;
    
    if([selectedDeviceId isEqualToString:_appDelegate.appConfig.device_id] && message.isBroadcast){
        [self broadcastButtonTapped:nil];
    }
    else{
        
        [self showSendPrivate:self];
    }
    
}


- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    
    BroadcastMessageAPI* message = (_appDelegate.messages)[indexPath.section];
    
    CGSize bubbleSize = [AppDelegate sizeForText:message.text];//[SpeechBubbleView sizeForText:message.text];
    CGFloat height;
    CGFloat sender_height=CHAT_SENDERNAME_HEIGHT;
    CGFloat sender_photo_height=CHAT_PHOTO_HEIGHT;
    CGFloat attached_image_height=CHAT_ATTACHEDIMAGE_HEIGHT;
    
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

- (UITableViewCell*)messageCellForRowAtIndexPath__:(NSIndexPath*)indexPath{
    static NSString* CellIdentifier = @"MessageCellIdentifier";
    
    //MessageTableViewCell* cell = (MessageTableViewCell*)[self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    MessageNBCell* cell = (MessageNBCell*)[self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
        cell = [[MessageNBCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    
    BroadcastMessageAPI* message = (_appDelegate.messages)[indexPath.section];//_messages[indexPath.row];
    if(![message.isread isEqualToNumber:@1])
    {
        message.isread=@1;
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
    }
    
    MessageTableViewData* message_data=[[MessageTableViewData alloc] initWithDictionary:[message toNSDictionary]];
    
    /*
     if ([message_data.senderid isEqualToNumber:_dataModel.userInfo.userid]) {
     message_data.senderPhoto=_myPhoto;
     }
     else{
     
     message_data.senderPhoto=[UIImage imageNamed:@"person.png"];
     
     
     }
     */
    if([message.peerInfo.deviceID isEqualToString:message.deviceID]){
        //if([_appDelegate.appConfig.userInfo.deviceID isEqualToString:message.deviceID]){
        
        message_data.sender=@"You";
        cell.imageView.image=_myPhoto;
        
    }
    else{
        
        
        /* dispatch_async(dispatch_get_main_queue(), ^{
         NSURL *url=[[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@myphoto.png",message.peerInfo.homeUrl]];
         NSData *imageData=[[NSData alloc] initWithContentsOfURL:url];
         if (imageData!=nil) {
         
         cell.imageView.image=[[UIImage alloc] initWithData:imageData];
         //imgView.image=[[UIImage alloc] initWithData:imageData];
         
         
         
         
         }
         
         
         });
         */
        // NSString *peer_bgphoto=[NSString stringWithFormat:@"%@%@.png",PREFIX_MYPHOTO, _appDelegate.mcManager.serverPeerInfo.deviceID];
        
        NSString *peer_bgphoto=[NSString stringWithFormat:@"%@%@.png",PREFIX_MYPHOTO, message.peerInfo.deviceID];
        
        
        NSString *filePath=[[AppDelegate getImagesPath] stringByAppendingPathComponent:peer_bgphoto];
        
        
        
        //check if cached
        if([[NSFileManager defaultManager] fileExistsAtPath:filePath]){
            
            cell.imageView.image=[[UIImage alloc] initWithContentsOfFile:filePath];
        }
        else{
            
            cell.imageView.image=[UIImage imageNamed:@"person.png"];
        }
        
    }
    [cell setMessage:message_data];
    /*
     if(![message.peerInfo.deviceID isEqualToString:message.deviceID]){
     dispatch_queue_t imageQueue = dispatch_queue_create("Image Queue",NULL);
     dispatch_async(imageQueue, ^{
     
     NSURL *url=[[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@myphoto.png",message.peerInfo.homeUrl]];
     NSData *imageData=[[NSData alloc] initWithContentsOfURL:url];
     if(!cell.photo) return;
     
     dispatch_async(dispatch_get_main_queue(), ^{
     if(imageData)
     [cell.photo setImage:[UIImage imageWithData:imageData]];
     });
     
     });
     }
     */
    //[cell.layer setCornerRadius:7.0f];
    // [cell.layer setMasksToBounds:YES];
    // [cell.layer setBorderWidth:2.0f];
    
    
    /*  UIImage *background = [self cellBackgroundForRowAtIndexPath:indexPath];
     
     UIImageView *cellBackgroundView = [[UIImageView alloc] initWithImage:background];
     cellBackgroundView.image = background;
     cell.backgroundView = cellBackgroundView;
     */
    return cell;
}


- (UITableViewCell*)messageTextOnlyCellForRowAtIndexPath:(BroadcastMessageAPI*) message{//(NSIndexPath*)indexPath{
    //static NSString* CellIdentifier = @"ChatTextOnlyCell";
    
    ChatTextOnlyCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"ChatTextOnlyCell"];
    
   // if([message.peerInfo.deviceID isEqualToString:message.deviceID]){
    if([_appDelegate.appConfig.device_id isEqualToString:message.fromDeviceID]){
        
        cell.senderLabel.text=@"You";
        cell.senderPhoto.image=_myPhoto;
        
    }
    else{
        
        cell.senderLabel.text=message.sender;
        /*NSString *peer_bgphoto=[NSString stringWithFormat:@"%@%@.png",PREFIX_MYPHOTO, message.peerInfo.deviceID];
        
        
        NSString *filePath=[[AppDelegate getImagesPath] stringByAppendingPathComponent:peer_bgphoto];
        
        
        
        //check if cached
        if([[NSFileManager defaultManager] fileExistsAtPath:filePath]){
            
            cell.senderPhoto.image=[[UIImage alloc] initWithContentsOfFile:filePath];
        }
        else{
            
            cell.senderPhoto.image=[UIImage imageNamed:@"person.png"];
        }
         */
        [self imageForSender:cell.senderPhoto deviceID: message.peerInfo.deviceID];
    }
    
    
    
    
    cell.dateLabel.text=[formatter stringFromDate:message.createdon];
    
    /*
     CGSize bubbleSize = [SpeechBubbleView sizeForText:message.text];
     CGRect rect=cell.messageLabel.frame;
     //rect.size = CGSizeMake(bubbleSize.width, bubbleSize.height);//
     rect.size.height=bubbleSize.height;
     rect.size.width=bubbleSize.width;
     
     cell.messageLabel.numberOfLines=0;
     cell.messageLabel.lineBreakMode=NSLineBreakByWordWrapping;
     cell.messageLabel.frame=rect;
     cell.messageLabel.text=message.text;
     //[cell.messageLabel sizeToFit];
     */
    /*
     messageLabel=cell.messageLabel;
     CGSize bubbleSize = [SpeechBubbleView sizeForText:message.text];
     CGRect rect=messageLabel.frame;
     
     rect.size.height=bubbleSize.height;
     rect.size.width=bubbleSize.width;
     
     messageLabel.numberOfLines=0;
     messageLabel.lineBreakMode=NSLineBreakByWordWrapping;
     
     [messageLabel setFrame:rect];
     
     messageLabel.text=message.text;
     */
    
    [cell setMessage:message.text];
    return cell;
    
}

- (UITableViewCell*)messageTextOnlyCustCellForRowAtIndexPath:(BroadcastMessageAPI*) message{//(NSIndexPath*)indexPath{
    //static NSString* CellIdentifier = @"ChatTextOnlyCell";
    
    ChatTextOnlyCustCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"ChatTextOnlyCustCell"];
    
    //if([_appDelegate.mcManager.myPeerInfo.deviceID isEqualToString:message.fromDeviceID]){
     if([_appDelegate.appConfig.device_id isEqualToString:message.fromDeviceID]){
        //cell.senderLabel.font[nsfont
        cell.senderLabel.text=@"You";
        cell.senderPhoto.image=_myPhoto;
        
    }
    else{
        
        cell.senderLabel.text=message.sender;
        /*NSString *peer_bgphoto=[NSString stringWithFormat:@"%@%@.png",PREFIX_MYPHOTO, message.peerInfo.deviceID];
        
        
        NSString *filePath=[[AppDelegate getImagesPath] stringByAppendingPathComponent:peer_bgphoto];
        
        
        
        //check if cached
        if([[NSFileManager defaultManager] fileExistsAtPath:filePath]){
            
            //cell.senderPhoto.image=[[UIImage alloc] initWithContentsOfFile:filePath];
            
        }
        else{
            
            cell.senderPhoto.image=[UIImage imageNamed:@"person.png"];
        }
         */
        [self imageForSender:cell.senderPhoto deviceID: message.fromDeviceID];
    }
    
    
    
    
    cell.dateLabel.text=[formatter stringFromDate:message.createdon];
    
    /*
    CGSize bubbleSize = [SpeechBubbleView sizeForText:message.text];
    CGRect rect=cell.messageLabel.frame;
    //rect.size = CGSizeMake(bubbleSize.width, bubbleSize.height);//
    rect.size.width=bubbleSize.width;
    rect.size.height=bubbleSize.height;
    
    
    cell.messageLabel.numberOfLines=0;
    cell.messageLabel.lineBreakMode=NSLineBreakByWordWrapping;
    cell.messageLabel.frame=rect;
    cell.messageLabel.text=message.text;
    [cell.messageLabel sizeToFit];
     */
    [cell setMessage:message.text];
    return cell;
    
}


- (UITableViewCell*)messageImageOnlyCellForRowAtIndexPath:(BroadcastMessageAPI*) message{//(NSIndexPath*)indexPath{
    ChatImageOnlyCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"ChatImageOnlyCell"];
    
   // if([message.peerInfo.deviceID isEqualToString:message.deviceID]){
    if([_appDelegate.appConfig.device_id isEqualToString:message.fromDeviceID]){
        
        cell.senderLabel.text=@"You";
        cell.senderPhoto.image=_myPhoto;
        
    }
    else{
        
        cell.senderLabel.text=message.sender;
       /* NSString *peer_bgphoto=[NSString stringWithFormat:@"%@%@.png",PREFIX_MYPHOTO, message.peerInfo.deviceID];
        
        
        NSString *filePath=[[AppDelegate getImagesPath] stringByAppendingPathComponent:peer_bgphoto];
        
        
        
        //check if cached
        if([[NSFileManager defaultManager] fileExistsAtPath:filePath]){
            
            cell.senderPhoto.image=[[UIImage alloc] initWithContentsOfFile:filePath];
        }
        else{
            
            cell.senderPhoto.image=[UIImage imageNamed:@"person.png"];
        }
        */
        [self imageForSender:cell.senderPhoto deviceID: message.peerInfo.deviceID];
    }
    
    
    
    
    cell.dateLabel.text=[formatter stringFromDate:message.createdon];
    
    CGSize bubbleSize = [AppDelegate sizeForText:message.text];
    CGRect rect=cell.messageLabel.frame;
    
    
    //rect.size.width=bubbleSize.width;
    if(bubbleSize.height>CHAT_PHOTO_HEIGHT)
        rect.size.height=bubbleSize.height;
    else
        rect.size.height=CHAT_PHOTO_HEIGHT;
    
    cell.messageLabel.numberOfLines=0;
    cell.messageLabel.lineBreakMode=NSLineBreakByWordWrapping;
    cell.messageLabel.frame=rect;
    cell.messageLabel.text=message.text;
    
    //cell.senderLabel.text=message.sender;
    NSString *attached_photo=[NSString stringWithFormat:@"%@%@.png",PREFIX_ATTACHMENT, message.imagefileuid];
    
    
    NSString *filePath=[[AppDelegate getImagesPath] stringByAppendingPathComponent:attached_photo];
    
    
    
    //check if cached
    if([[NSFileManager defaultManager] fileExistsAtPath:filePath]){
        
        cell.attachImage.image=[[UIImage alloc] initWithContentsOfFile:filePath];
        CGRect frame=cell.attachImage.frame;
        
        
        //CGSize bubbleSize = [SpeechBubbleView sizeForText:message.text];
        //CGFloat height;
        //CGFloat sender_height=CHAT_SENDERNAME_HEIGHT;
        //CGFloat sender_photo_height=CHAT_PHOTO_HEIGHT;
        //CGFloat attached_image_height=CHAT_ATTACHEDIMAGE_HEIGHT;
        CGRect frameMessage=cell.messageLabel.frame;
        
        if(frameMessage.size.height>CHAT_PHOTO_HEIGHT){
            frame.origin.y=cell.messageLabel.frame.origin.y+ cell.messageLabel.frame.size.height;
        }
        else{
            frame.origin.y=cell.senderPhoto.frame.origin.y+cell.senderPhoto.frame.size.height;//CHAT_PHOTO_HEIGHT+4;

        }
        //frame.origin.y=frame.origin.y+17;
        cell.attachImage.frame=frame;
        
        
    }

    
    return cell;
    
}

- (UITableViewCell*)messageImageOnlyCustCellForRowAtIndexPath:(BroadcastMessageAPI*) message{//(NSIndexPath*)indexPath{
    ChatImageOnlyCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"ChatImageOnlyCustCell"];
    
    if([_appDelegate.appConfig.device_id isEqualToString:message.fromDeviceID]){
        
        
        cell.senderLabel.text=@"You";
        cell.senderPhoto.image=_myPhoto;
        
    }
    else{
        
        cell.senderLabel.text=message.sender;
        /*NSString *peer_bgphoto=[NSString stringWithFormat:@"%@%@.png",PREFIX_MYPHOTO, message.peerInfo.deviceID];
        
        
        NSString *filePath=[[AppDelegate getImagesPath] stringByAppendingPathComponent:peer_bgphoto];
        
        
        
        //check if cached
        if([[NSFileManager defaultManager] fileExistsAtPath:filePath]){
            
            cell.senderPhoto.image=[[UIImage alloc] initWithContentsOfFile:filePath];
        }
        else{
            
            cell.senderPhoto.image=[UIImage imageNamed:@"person.png"];
        }
         */
        [self imageForSender:cell.senderPhoto deviceID: message.fromDeviceID];
    }
    
    
    
    
    cell.dateLabel.text=[formatter stringFromDate:message.createdon];
    
    CGSize bubbleSize = [AppDelegate sizeForText:message.text];
    CGRect rect=cell.messageLabel.frame;
    
    
    //rect.size.width=bubbleSize.width;
    if(bubbleSize.height>CHAT_PHOTO_HEIGHT)
        //rect.size.height=CHAT_PHOTO_HEIGHT;
         rect.size.height=bubbleSize.height;
    else
        rect.size.height=CHAT_PHOTO_HEIGHT;
    
    cell.messageLabel.numberOfLines=0;
    cell.messageLabel.lineBreakMode=NSLineBreakByWordWrapping;
    cell.messageLabel.frame=rect;
    cell.messageLabel.text=message.text;
    
    cell.senderLabel.text=message.sender;
    
    /*NSString *attached_photo=[NSString stringWithFormat:@"%@%@.png",PREFIX_ATTACHMENT, message.imagefileuid];
    
    
    NSString *filePath=[[AppDelegate getImagesPath] stringByAppendingPathComponent:attached_photo];
    
    
    
    //check if cached
    if([[NSFileManager defaultManager] fileExistsAtPath:filePath]){
        
        cell.attachImage.image=[[UIImage alloc] initWithContentsOfFile:filePath];
    }
    else{
     
     //cell.attachImage.image=[UIImage imageNamed:@"person.png"];
     
    }*/
    [self imageForAttachment:cell.attachImage fileuid:message.imagefileuid];
    
    
    return cell;
    
}

-(void)imageForSender:(UIImageView *)imageView deviceID:(NSString *) deviceID{
    [imageView setImage:[UIImage imageNamed:@"person.png"]];
    
    NSString *peer_photo=[NSString stringWithFormat:@"%@%@.png",PREFIX_MYPHOTO, deviceID];
    
    
    NSString *filePath=[[AppDelegate getImagesPath] stringByAppendingPathComponent:peer_photo];
    if([[NSFileManager defaultManager] fileExistsAtPath:filePath]){
        dispatch_queue_t imageQueue = dispatch_queue_create("Image Queue",NULL);
        dispatch_async(imageQueue, ^{
            
            
            NSData *imageData=imageData =[NSData dataWithContentsOfFile:filePath];
            
            
            if(!imageData) return;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if(imageView){
                    [imageView setImage:[UIImage imageWithData:imageData]];
                    //cell.senderPhoto.layer.cornerRadius=cell.senderPhoto.frame.size.width / 2;
                    //cell.senderPhoto.clipsToBounds = YES;
                }
            });
        });
    }
    imageView.layer.cornerRadius=imageView.frame.size.width / 2;
    imageView.clipsToBounds = YES;

}

-(void)imageForAttachment:(UIImageView *)imageView fileuid:(NSString *) fileuid{
    //[imageView setImage:[UIImage imageNamed:@"person.png"]];
    

    NSString *attached_photo=[NSString stringWithFormat:@"%@%@.png",PREFIX_ATTACHMENT, fileuid];
    
    
    NSString *filePath=[[AppDelegate getImagesPath] stringByAppendingPathComponent:attached_photo];

    
    
    if([[NSFileManager defaultManager] fileExistsAtPath:filePath]){
        dispatch_queue_t imageQueue = dispatch_queue_create("Image Queue",NULL);
        dispatch_async(imageQueue, ^{
            
            
            NSData *imageData=imageData =[NSData dataWithContentsOfFile:filePath];
            
            
            if(!imageData) return;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if(imageView){
                    [imageView setImage:[UIImage imageWithData:imageData]];
                    //cell.senderPhoto.layer.cornerRadius=cell.senderPhoto.frame.size.width / 2;
                    //cell.senderPhoto.clipsToBounds = YES;
                }
            });
        });
    }
    imageView.layer.cornerRadius=0.8;
    imageView.clipsToBounds = YES;

}

-(void)setEditing:(BOOL)editing animated:(BOOL)animated{
    [super setEditing:editing animated:animated];
    [self.tableView setEditing:editing animated:animated];
    if(editing){
         //self.navigationItem.leftBarButtonItems=@[ usersButtonItem,self.broadcastButton,self.editButtonItem];
        self.navigationItem.leftBarButtonItems=@[ self.broadcastButton,self.editButtonItem];
    }
    else{
        
    }
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if(editingStyle==UITableViewCellEditingStyleDelete){
        
        //BroadcastMessageAPI* delete_item = (_appDelegate.messages)[indexPath.section];
        [_appDelegate.messages removeObjectAtIndex:indexPath.section];
        
        [self.tableView reloadData];
        
    }
}
/*
 - (UITableViewCell*)messageWithImageCellForRowAtIndexPath:(NSIndexPath*)indexPath{
 static NSString* CellIdentifier = @"MessageWithImageCellIdentifier";
 
 MessageWithImageTableViewCell* cell = (MessageWithImageTableViewCell*)[self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
 if (cell == nil)
 cell = [[MessageWithImageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
 
 BroadcastMessageAPI* message =  _messages[indexPath.row];
 MessageTableViewData* message_data=[[MessageTableViewData alloc] initWithDictionary:[message toNSDictionary]];
 
 if([message.peerInfo.deviceID isEqualToString:_appDelegate.userInfo.deviceID]){
 message_data.senderPhoto=_myPhoto;
 }
 else{
 
 message_data.senderPhoto=[UIImage imageNamed:@"person.png"];
 
 
 }
 
 message_data.myImage=[UIImage imageNamed:@"empty_picture.png"];
 
 [cell setMessage:message_data];
 
 if(![message.peerInfo.deviceID isEqualToString:_appDelegate.userInfo.deviceID]){
 dispatch_queue_t imageQueue = dispatch_queue_create("Image Queue",NULL);
 dispatch_async(imageQueue, ^{
 
 NSURL *url=[[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@myphoto.png",message.peerInfo.homeUrl]];
 NSData *imageData=[[NSData alloc] initWithContentsOfURL:url];
 
 
 if(!cell.photo) return;
 
 dispatch_async(dispatch_get_main_queue(), ^{
 if(imageData)
 [cell.photo setImage:[UIImage imageWithData:imageData]];
 });
 
 });
 }
 
 dispatch_queue_t imageQueueAttachment = dispatch_queue_create("Image Queue Attachment",NULL);
 dispatch_async(imageQueueAttachment, ^{
 
 //NSURL *url = [NSURL URLWithString:urlString];
 NSData *imageData=[_dataModel fileStoreGetSetData:message.imagefileuid contentType:message.imagefilecontenttype contentLength:message.imagefilecontentlength isStream:NO];
 UIImage *image = [UIImage imageWithData:imageData];
 
 //NSUInteger imageIndex = [images indexOfObject:urlString];
 UIImageView *imageVIew =cell.imageAttach; //(UIImageView *)[self.view viewWithTag:imageIndex];
 
 if (!imageVIew) return;
 
 dispatch_async(dispatch_get_main_queue(), ^{
 // Update the UI
 [imageVIew setImage:image];
 });
 
 });
 
 
 UIImage *background = [self cellBackgroundForRowAtIndexPath:indexPath];
 
 UIImageView *cellBackgroundView = [[UIImageView alloc] initWithImage:background];
 cellBackgroundView.image = background;
 cell.backgroundView = cellBackgroundView;
 
 return cell;
 }
 */

/*
 - (UITableViewCell*)messageWithImageAndMediaCellForRowAtIndexPath:(NSIndexPath*)indexPath
 {
 static NSString* CellIdentifier = @"MessageWithImageAndMediaCellIdentifier";
 
 MessageWithImageAndMediaCell* cell = (MessageWithImageAndMediaCell*)[self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
 if (cell == nil)
 cell = [[MessageWithImageAndMediaCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
 
 BroadcastMessageAPI* message =  _messages[indexPath.row];
 
 MessageTableViewData* message_data=[[MessageTableViewData alloc] initWithDictionary:[message toNSDictionary]];
 
 
 if ([message_data.senderid isEqualToNumber:_dataModel.userInfo.userid]) {
 message_data.senderPhoto=_myPhoto;
 }
 else{
 
 message_data.senderPhoto=[UIImage imageNamed:@"person.png"];
 
 
 }
 
 message_data.myImage=[UIImage imageNamed:@"empty_picture.png"];
 
 
 [cell setMessage:message_data];
 
 if (![message_data.senderid isEqualToNumber:_dataModel.userInfo.userid]) {
 dispatch_queue_t imageQueue = dispatch_queue_create("Image Photo",NULL);
 dispatch_async(imageQueue, ^{
 
 //NSURL *url = [NSURL URLWithString:urlString];
 NSLog(@"message_data=%@",message_data.sender_imagefileuid);
 NSData *imageData = [_dataModel fileStoreGetSetData:message_data.sender_imagefileuid contentType:message_data.sender_imagefiletype contentLength:message_data.sender_imagefilesize isStream:NO];//[NSData dataWithContentsOfURL:url];
 // UIImage *image = [UIImage imageWithData:imageData];
 
 //NSUInteger imageIndex = [images indexOfObject:urlString];
 //UIImageView *imageVIew =cell.photo; //(UIImageView *)[self.view viewWithTag:imageIndex];
 
 //if (!imageVIew) return;
 if(!cell.photo)
 return;
 
 dispatch_async(dispatch_get_main_queue(), ^{
 // Update the UI
 //[imageVIew setImage:image];
 if(imageData)
 [cell.photo setImage:[UIImage imageWithData:imageData]];
 });
 
 });
 }
 
 if(message.imagefileuid.length>0){
 dispatch_queue_t imageQueueAttachment = dispatch_queue_create("Image Attachment",NULL);
 dispatch_async(imageQueueAttachment, ^{
 
 //NSURL *url = [NSURL URLWithString:urlString];
 NSData *imageAttachData=[_dataModel fileStoreGetSetData:message.imagefileuid contentType:message.imagefilecontenttype contentLength:message.imagefilecontentlength isStream:NO];
 //UIImage *image = [UIImage imageWithData:imageData];
 
 //NSUInteger imageIndex = [images indexOfObject:urlString];
 // UIImageView *imageVIew =cell.imageAttach; //(UIImageView *)[self.view viewWithTag:imageIndex];
 
 if (!cell.imageAttach) return;
 
 dispatch_async(dispatch_get_main_queue(), ^{
 // Update the UI
 if(imageAttachData)
 [cell.imageAttach setImage:[UIImage imageWithData:imageAttachData]];
 });
 
 });
 }
 UIImage *background = [self cellBackgroundForRowAtIndexPath:indexPath];
 
 UIImageView *cellBackgroundView = [[UIImageView alloc] initWithImage:background];
 cellBackgroundView.image = background;
 cell.backgroundView = cellBackgroundView;
 
 
 if([message.messageuid isEqualToString:_dataModel.nowPlayingSelectedPublicMessageUid]){
 if(_dataModel.publicPlayer.isPlaying)
 [cell.imgPlayer setImage:[UIImage imageNamed:@"controlsView-stop"] ];
 else{
 [cell.imgPlayer setImage:[UIImage imageNamed:@"controlsView-play"] ];
 }
 }
 else{
 [cell.imgPlayer setImage:[UIImage imageNamed:@"controlsView-play"]];
 }
 
 
 return cell;
 }
 
 
 - (UITableViewCell*)messageWithMediaCellForRowAtIndexPath:(NSIndexPath*)indexPath
 {
 static NSString* CellIdentifier = @"MessageWithMediaCellIdentifier";
 
 MessageWithMediaCell* cell = (MessageWithMediaCell*)[self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
 if (cell == nil)
 cell = [[MessageWithMediaCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
 
 BroadcastMessageAPI* message =  _messages[indexPath.row];
 MessageTableViewData* message_data=[[MessageTableViewData alloc] initWithDictionary:[message toNSDictionary]];
 
 if ([message_data.senderid isEqualToNumber:_dataModel.userInfo.userid]) {
 message_data.senderPhoto=_myPhoto;
 }
 else{
 
 message_data.senderPhoto=[UIImage imageNamed:@"person.png"];
 
 
 }
 
 message_data.myImage=[UIImage imageNamed:@"empty_picture.png"];
 
 [cell setMessage:message_data];
 
 if (![message_data.senderid isEqualToNumber:_dataModel.userInfo.userid]) {
 dispatch_queue_t imageQueue = dispatch_queue_create("Image Queue",NULL);
 dispatch_async(imageQueue, ^{
 
 //NSURL *url = [NSURL URLWithString:urlString];
 NSData *imageData = [_dataModel fileStoreGetSetData:message_data.sender_imagefileuid contentType:message_data.sender_imagefiletype contentLength:message_data.sender_imagefilesize isStream:NO];//[NSData dataWithContentsOfURL:url];
 // UIImage *image = [UIImage imageWithData:imageData];
 
 //NSUInteger imageIndex = [images indexOfObject:urlString];
 //UIImageView *imageVIew =cell.photo; //(UIImageView *)[self.view viewWithTag:imageIndex];
 
 //if (!imageVIew) return;
 if(!cell.photo) return;
 
 dispatch_async(dispatch_get_main_queue(), ^{
 // Update the UI
 //[imageVIew setImage:image];
 if(imageData)
 [cell.photo setImage:[UIImage imageWithData:imageData]];
 });
 
 });
 }
 
 
 
 UIImage *background = [self cellBackgroundForRowAtIndexPath:indexPath];
 
 UIImageView *cellBackgroundView = [[UIImageView alloc] initWithImage:background];
 cellBackgroundView.image = background;
 cell.backgroundView = cellBackgroundView;
 
 if([message.messageuid isEqualToString:_dataModel.nowPlayingSelectedPublicMessageUid]){
 if(_dataModel.publicPlayer.isPlaying)
 [cell.imgPlayer setImage:[UIImage imageNamed:@"controlsView-stop"] ];
 else{
 [cell.imgPlayer setImage:[UIImage imageNamed:@"controlsView-play"] ];
 }
 }
 else{
 [cell.imgPlayer setImage:[UIImage imageNamed:@"controlsView-play"]];
 }
 
 
 return cell;
 }
 
 
 
 - (UITableViewCell*)messageWithImageNoTextCellForRowAtIndexPath:(NSIndexPath*)indexPath{
 static NSString* CellIdentifier = @"MessageWithImageNoTextCellIdentifier";
 
 MessageWithImageNoTextCell* cell = (MessageWithImageNoTextCell*)[self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
 if (cell == nil)
 cell = [[MessageWithImageNoTextCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
 
 BroadcastMessageAPI* message = _messages[indexPath.row];
 MessageTableViewData* message_data=[[MessageTableViewData alloc] initWithDictionary:[message toNSDictionary]];
 
 if ([message_data.senderid isEqualToNumber:_dataModel.userInfo.userid]) {
 message_data.senderPhoto=_myPhoto;
 }
 else{
 
 message_data.senderPhoto=[UIImage imageNamed:@"person.png"];
 
 
 }
 
 message_data.myImage=[UIImage imageNamed:@"empty_picture.png"];
 
 [cell setMessage:message_data];
 
 if ([message_data.senderid isEqualToNumber:_dataModel.userInfo.userid]) {
 dispatch_queue_t imageQueue = dispatch_queue_create("Image Queue",NULL);
 dispatch_async(imageQueue, ^{
 
 //NSURL *url = [NSURL URLWithString:urlString];
 NSData *imageData = [_dataModel fileStoreGetSetData:message_data.sender_imagefileuid contentType:message_data.sender_imagefiletype contentLength:message_data.sender_imagefilesize isStream:NO];//[NSData dataWithContentsOfURL:url];
 UIImage *image = [UIImage imageWithData:imageData];
 
 //NSUInteger imageIndex = [images indexOfObject:urlString];
 UIImageView *imageVIew =cell.photo; //(UIImageView *)[self.view viewWithTag:imageIndex];
 
 if (!imageVIew) return;
 
 dispatch_async(dispatch_get_main_queue(), ^{
 // Update the UI
 [imageVIew setImage:image];
 });
 
 });
 }
 
 dispatch_queue_t imageQueueAttachment = dispatch_queue_create("Image Queue Attachment",NULL);
 dispatch_async(imageQueueAttachment, ^{
 
 //NSURL *url = [NSURL URLWithString:urlString];
 NSData *imageData=[_dataModel fileStoreGetSetData:message.imagefileuid contentType:message.imagefilecontenttype contentLength:message.imagefilecontentlength isStream:NO];
 UIImage *image = [UIImage imageWithData:imageData];
 
 //NSUInteger imageIndex = [images indexOfObject:urlString];
 UIImageView *imageVIew =cell.imageAttach; //(UIImageView *)[self.view viewWithTag:imageIndex];
 
 if (!imageVIew) return;
 
 dispatch_async(dispatch_get_main_queue(), ^{
 // Update the UI
 [imageVIew setImage:image];
 });
 
 });
 
 UIImage *background = [self cellBackgroundForRowAtIndexPath:indexPath];
 
 UIImageView *cellBackgroundView = [[UIImageView alloc] initWithImage:background];
 cellBackgroundView.image = background;
 cell.backgroundView = cellBackgroundView;
 
 //    cell.btnPlayer.tag =indexPath.row;
 //    [cell.btnPlayer  addTarget:self action:@selector(playList:) forControlEvents:UIControlEventTouchUpInside];
 //    [cell.btnPlayer setImage:[UIImage imageNamed:@"controlsView-play@2x.png"] forState:UIControlStateNormal];
 
 
 
 return cell;
 }
 
 - (UITableViewCell*)messageWithMediaNoTextCellForRowAtIndexPath:(NSIndexPath*)indexPath{
 static NSString* CellIdentifier = @"MessageWithMediaNoTextCellIdentifier";
 
 MessageWithMediaNoTextCell* cell = (MessageWithMediaNoTextCell*)[self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
 if (cell == nil)
 cell = [[MessageWithMediaNoTextCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
 
 BroadcastMessageAPI* message =  _messages[indexPath.row];
 //    if(![message.senderid isEqualToNumber:_dataModel.userInfo.userid]){
 //        if(message.sendernickname==(id)[NSNull null])
 //            message.sendernickname=@"Unknown";
 //    }
 
 MessageTableViewData* message_data=[[MessageTableViewData alloc] initWithDictionary:[message toNSDictionary]];
 
 if ([message_data.senderid isEqualToNumber:_dataModel.userInfo.userid]) {
 message_data.senderPhoto=_myPhoto;
 }
 else{
 
 message_data.senderPhoto=[UIImage imageNamed:@"person.png"];
 
 
 }
 
 message_data.myImage=[UIImage imageNamed:@"empty_picture.png"];
 
 
 
 message_data.myMedia=[UIImage imageNamed:@"controlsView-play"];
 
 
 [cell setMessage:message_data];
 
 if (![message_data.senderid isEqualToNumber:_dataModel.userInfo.userid]) {
 dispatch_queue_t imageQueue = dispatch_queue_create("Image Queue",NULL);
 dispatch_async(imageQueue, ^{
 
 //NSURL *url = [NSURL URLWithString:urlString];
 NSData *imageData = [_dataModel fileStoreGetSetData:message_data.sender_imagefileuid contentType:message_data.sender_imagefiletype contentLength:message_data.sender_imagefilesize isStream:NO];//[NSData dataWithContentsOfURL:url];
 // UIImage *image = [UIImage imageWithData:imageData];
 
 //NSUInteger imageIndex = [images indexOfObject:urlString];
 //UIImageView *imageVIew =cell.photo; //(UIImageView *)[self.view viewWithTag:imageIndex];
 
 //if (!imageVIew) return;
 if(!cell.photo) return;
 
 dispatch_async(dispatch_get_main_queue(), ^{
 // Update the UI
 //[imageVIew setImage:image];
 if(imageData)
 [cell.photo setImage:[UIImage imageWithData:imageData]];
 });
 
 });
 }
 
 
 UIImage *background = [self cellBackgroundForRowAtIndexPath:indexPath];
 
 UIImageView *cellBackgroundView = [[UIImageView alloc] initWithImage:background];
 cellBackgroundView.image = background;
 cell.backgroundView = cellBackgroundView;
 
 if([message.messageuid isEqualToString:_dataModel.nowPlayingSelectedPublicMessageUid]){
 if(_dataModel.publicPlayer.isPlaying)
 [cell.imgPlayer setImage:[UIImage imageNamed:@"controlsView-stop"]];
 else{
 [cell.imgPlayer setImage:[UIImage imageNamed:@"controlsView-play"] ];
 }
 }
 else{
 [cell.imgPlayer setImage:[UIImage imageNamed:@"controlsView-play"] ];
 }
 
 return cell;
 }
 
 - (UITableViewCell*)messageWithImageAndMediaNoTextCellForRowAtIndexPath:(NSIndexPath*)indexPath{
 static NSString* CellIdentifier = @"MessageWithImageAndMediaNoTextCellIdentifier";
 
 MessageWithImageAndMediaNoTextCell* cell = (MessageWithImageAndMediaNoTextCell*)[self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
 
 if (cell == nil)
 cell = [[MessageWithImageAndMediaNoTextCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
 
 BroadcastMessageAPI* message = _messages[indexPath.row];
 MessageTableViewData* message_data=[[MessageTableViewData alloc] initWithDictionary:[message toNSDictionary]];
 
 if ([message_data.senderid isEqualToNumber:_dataModel.userInfo.userid]) {
 message_data.senderPhoto=_myPhoto;
 }
 else{
 
 message_data.senderPhoto=[UIImage imageNamed:@"person.png"];
 
 
 }
 
 message_data.myImage=[UIImage imageNamed:@"empty_picture.png"];
 
 [cell setMessage:message_data];
 
 if ([message_data.senderid isEqualToNumber:_dataModel.userInfo.userid]) {
 dispatch_queue_t imageQueue = dispatch_queue_create("Image Queue",NULL);
 dispatch_async(imageQueue, ^{
 
 //NSURL *url = [NSURL URLWithString:urlString];
 NSData *imageData = [_dataModel fileStoreGetSetData:message_data.sender_imagefileuid contentType:message_data.sender_imagefiletype contentLength:message_data.sender_imagefilesize isStream:NO];//[NSData dataWithContentsOfURL:url];
 UIImage *image = [UIImage imageWithData:imageData];
 
 //NSUInteger imageIndex = [images indexOfObject:urlString];
 UIImageView *imageVIew =cell.photo; //(UIImageView *)[self.view viewWithTag:imageIndex];
 
 if (!imageVIew) return;
 
 dispatch_async(dispatch_get_main_queue(), ^{
 // Update the UI
 [imageVIew setImage:image];
 });
 
 });
 }
 
 dispatch_queue_t imageQueueAttachment = dispatch_queue_create("Image Queue Attachment",NULL);
 dispatch_async(imageQueueAttachment, ^{
 
 //NSURL *url = [NSURL URLWithString:urlString];
 NSData *imageData=[_dataModel fileStoreGetSetData:message.imagefileuid contentType:message.imagefilecontenttype contentLength:message.imagefilecontentlength isStream:NO];
 UIImage *image = [UIImage imageWithData:imageData];
 
 //NSUInteger imageIndex = [images indexOfObject:urlString];
 UIImageView *imageVIew =cell.imageAttach; //(UIImageView *)[self.view viewWithTag:imageIndex];
 
 if (!imageVIew) return;
 
 dispatch_async(dispatch_get_main_queue(), ^{
 // Update the UI
 [imageVIew setImage:image];
 });
 
 });
 
 UIImage *background = [self cellBackgroundForRowAtIndexPath:indexPath];
 
 UIImageView *cellBackgroundView = [[UIImageView alloc] initWithImage:background];
 cellBackgroundView.image = background;
 cell.backgroundView = cellBackgroundView;
 
 if([message.messageuid isEqualToString:_dataModel.nowPlayingSelectedPublicMessageUid]){
 if(_dataModel.publicPlayer.isPlaying)
 [cell.imgPlayer setImage:[UIImage imageNamed:@"controlsView-stop"] ];
 else{
 [cell.imgPlayer setImage:[UIImage imageNamed:@"controlsView-play"] ];
 }
 }
 else{
 [cell.imgPlayer setImage:[UIImage imageNamed:@"controlsView-play"]];
 }
 
 
 return cell;
 }
 */
/*
- (IBAction)kioskAction:(id)sender {
    MenuViewController* order = (MenuViewController*) [ApplicationDelegate.storyBoard instantiateViewControllerWithIdentifier:@"MenuViewController"];
    order.delegate = self;
   
    [self presentViewController:order animated:YES completion:nil];
}

-(void)orderViewControllerDidFinish:(MenuViewController *)orderViewController{
    
}

-(void)orderViewControllerWasCancelled:(MenuViewController *)orderViewController{
    [orderViewController dismissViewControllerAnimated:YES completion:nil];
}
*/

- (IBAction)audioSwitchAction:(id)sender {
    _appDelegate.isAudioON=audioSwitch.on;
    //[[NSNotificationCenter defaultCenter] postNotificationName:@"DidReceiveAudioSwitchNotification" object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"DidReceiveAudioSwitchNotification" object:nil userInfo:@{@"on":@(audioSwitch.on)}];
}

-(void)didReceivePeerBgPhotoNotification:(NSNotification *)notification{
    [self loadBgPhoto];
}


/*-(void)didReceiveRemoteNotification:(NSNotification *)notification{
 dispatch_async(dispatch_get_main_queue(), ^{
 [_tableView reloadData];
 });
 }
 */


-(void)loadBgPhoto{
    
    return;
   // NSString *peer_bgphoto=[NSString stringWithFormat:@"%@%@.png",PREFIX_MYBGPHOTO, _appDelegate.mcManager.deviceID];
     NSString *peer_bgphoto=[NSString stringWithFormat:@"%@%@.png",PREFIX_MYBGPHOTO, _appDelegate.appConfig.device_id];
    
    
    
    NSString *filePath=[[AppDelegate getDocumentsPath] stringByAppendingPathComponent:peer_bgphoto];
    
    
    
    //check if cached
    if([[NSFileManager defaultManager] fileExistsAtPath:filePath]){
        
        self.wallImage.image=[[UIImage alloc] initWithContentsOfFile:filePath];
    }
}

#pragma mark - UITextField Delegate method implementation

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    
    //[self sendMessage];
    
    return YES;
}

-(void)textViewDidBeginEditing:(UITextView *)textView{
    
    if([textView.text isEqualToString:@"Your message"]){
        textView.text=@"";
    }
    
    //if([_appDelegate.messages count]==0)
    //    return;
    
    /*CGRect frame=[self.tableView frame];
    //if(frame.origin.y>0){
        frame.origin.y=-(frame.size.height-(85+kNavigationBarPortraitHeight+10));
        [self.tableView setFrame:frame];
    //}
     */
   // isEditing=YES;
    //[self.tableView reloadData];
    
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
    else if(text.length==0){
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
    
}
-(void)showSendMessageNotification:(NSNotification *)notification{
    
    selectedDeviceId=[notification.userInfo valueForKey:DeviceIdKey];
    //[self showSendMessage:self];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    
    [self hideCompose:NO];
    
    [_txtMessage becomeFirstResponder];

}


#pragma mark - IBAction method implementation

- (IBAction)usersButtonTapped:(id)sender{
    
    SelectUsersViewController *vc=[_appDelegate.storyBoard instantiateViewControllerWithIdentifier:@"SelectUsersViewController"];
    //vc.delegate=self;
    
    
    UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:vc];
    
    if(_appDelegate.isIpad){
        //if(_popOver==nil){
       // [self.view endEditing];
        [_txtMessage endEditing:YES];
        _popOver=[[UIPopoverController alloc] initWithContentViewController:nav];
        //_chatPopover.popoverContentSize=CGSizeMake(self.view.frame.size.width/2, self.view.frame.size.height);
        _popOver.popoverContentSize=CGSizeMake(_toLabel.frame.size.width, 200.0);//self.view.frame.size.height);
        //[_popOver presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        
        [_popOver presentPopoverFromRect:_toLabel.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
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

- (IBAction)attachButtonTapped:(id)sender {
    /*
    if(self.attachedPhoto.image!=nil){
        self.attachedPhoto.image=nil;
        [_attachButton setTitle:@"Attach" forState:UIControlStateNormal];
        
        //[self.txtMessage becomeFirstResponder];
    }
    else{
    
    self.pickerPhoto=[[UIImagePickerController alloc] init];
    self.pickerPhoto.modalPresentationStyle=UIModalPresentationCurrentContext;
    self.pickerPhoto.delegate=self;
    self.pickerPhoto.allowsEditing=YES;
    
    self.pickerPhoto.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:self.pickerPhoto animated:YES
                     completion:NULL];
    }
     */
    [self.view endEditing:YES];
    
    if([self hasImageAttachment]){
        [AppDelegate toast:@"Only 1 attachment per message is allowed." duration:2.0 ];
        return;
    }
    
    
    UIActionSheet *photoActionSheet=[[UIActionSheet alloc]
                                     initWithTitle: nil
                                     delegate:self
                                     cancelButtonTitle:@"Cancel"
                                     destructiveButtonTitle: nil
                                     otherButtonTitles:@"Take Photo",@"Select Photo", NULL];
    [photoActionSheet showInView:self.parentViewController.view ];
}
//- (IBAction)sendMessage:(id)sender {

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
     //if(_txtMessage.text.length==0 && _attachedPhoto.image==nil)
    if(_txtMessage.text.length==0 && ![self hasImageAttachment ])
        return;
    
    NSString *imagefileuid=nil;
     _attachedPhoto.image=nil;
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
        
        
        
        if (imageFileData.length>0)//TODO: Limit size ex: 200000 //approx 200x250
        {
            imagefileuid=[[ imageFileData MD5] uppercaseString];
            NSString *filename=[NSString stringWithFormat:@"%@%@.png",PREFIX_ATTACHMENT, imagefileuid];
            
            //create path
            
            NSString *filePath=[[AppDelegate getImagesPath] stringByAppendingPathComponent:filename];
            //save image if does not exist
            
            //check if cached
            if(![[NSFileManager defaultManager] fileExistsAtPath:filePath])
                [imageFileData writeToFile:filePath atomically:YES];
            
            
        }
        
        
    }
    
    BroadcastMessageAPI *message=[[BroadcastMessageAPI alloc] init];
    message.text=_txtMessage.text;
    message.imagefileuid=imagefileuid;
    message.message_type=MSG_TYPE_DEF;
    message.localCopy=NO;
    message.fromDeviceID=_appDelegate.mcManager.myPeerInfo.deviceID;
    message.sender=_appDelegate.mcManager.myPeerInfo.peerName;
    
    
    if(selectedDeviceId){
        
        NSPredicate *predicate=[NSPredicate predicateWithFormat:@"%@=%@",deviceIDKey, selectedDeviceId];
        
        NSArray *result=[_appDelegate.mcManager.peerDevices filteredArrayUsingPredicate:predicate];
        
        if([result count]>0){
        
            message.toPeerInfo=[result firstObject];
         
            message.toDeviceID=selectedDeviceId;
            message.isBroadcast=NO;
        }
        
    }
    else{
        //message.toPeerInfo=nil;
        message.isBroadcast=YES;
    }
    
    
     
     [_appDelegate removeLastMessage:message.fromDeviceID];
     [_appDelegate.messages addObject:message];
     [_tableView reloadData];
    
    if(_appDelegate.messages.count>0){
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:_appDelegate.messages.count-1] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        //self.tableView.contentOffset=CGPointMake(0,0-self.tableView.contentInset.bottom);
    }
    [_soundController playSystemSound:SOUND_CHAT_SEND soundSource:SOURCE_CHAT];
    /*[_appDelegate.messages addObject:message];
    [_tableView reloadData];
    */
    
    
    NSDictionary *dict = @{KEY_SEND_MESSAGE: message
                           };
    
    
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_HAS_DATA_TO_SEND
                                                        object:nil
                                                      userInfo:dict];
    
    
    [_txtMessage setText:nil];
    [_txtMessage resignFirstResponder];
     [_attachButton setEnabled:YES];
    _attachedPhoto.image=nil;

    //if(self.containerStaffsList.isHidden){
    // CGRect frame=self.tableView.frame;
    // frame.origin.y=self.sendMessageView.frame.origin.y;
    
    
    //[self.sendMessageView setHidden:YES];
    [self hideCompose:YES];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
  //  [self.broadcastButton setEnabled:YES];
    
    //  self.tableView.frame=frame;
    // }
    // [self.showSendButton setTitle:@"Send message"];
}

- (void)sendPrivateMessage{
    //if(_txtMessage.text.length==0 && _attachedPhoto.image==nil)
    if(_selectedUsers==nil || [_selectedUsers count]==0)
        
        return;
    
    if(_txtMessage.text.length==0 && ![self hasImageAttachment ])
        return;
    
    NSString *imagefileuid=nil;
    _attachedPhoto.image=nil;
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
        
        
        
        if (imageFileData.length>0)//TODO: Limit size ex: 200000 //approx 200x250
        {
            imagefileuid=[[ imageFileData MD5] uppercaseString];
            NSString *filename=[NSString stringWithFormat:@"%@%@.png",PREFIX_ATTACHMENT, imagefileuid];
            
            //create path
            
            NSString *filePath=[[AppDelegate getImagesPath] stringByAppendingPathComponent:filename];
            //save image if does not exist
            
            //check if cached
            if(![[NSFileManager defaultManager] fileExistsAtPath:filePath])
                [imageFileData writeToFile:filePath atomically:YES];
            
            
        }
        
        
    }
    
    BroadcastMessageAPI *message=[[BroadcastMessageAPI alloc] init];
    message.text=_txtMessage.text;
    message.imagefileuid=imagefileuid;
    message.message_type=MSG_TYPE_DEF;
    message.localCopy=NO;
    message.fromDeviceID=_appDelegate.mcManager.myPeerInfo.deviceID;
    message.sender=_appDelegate.mcManager.myPeerInfo.peerName;
    
    
    //if(selectedDeviceId){{
    for(NSDictionary *user in _selectedUsers){
        /*NSPredicate *predicate=[NSPredicate predicateWithFormat:@"%@=%@",deviceIDKey, selectedDeviceId];
        
        NSArray *result=[_appDelegate.mcManager.peerDevices filteredArrayUsingPredicate:predicate];
        
        if([result count]>0){
            
            message.toPeerInfo=[result firstObject];
          */
        message.toDeviceID=[user valueForKey:DeviceIdKey];// selectedDeviceId;
            message.isBroadcast=NO;
        //}
        
   /* }
    else{
        //message.toPeerInfo=nil;
        message.isBroadcast=YES;
    }
    */
    
    
    [_soundController playSystemSound:SOUND_CHAT_SEND soundSource:SOURCE_CHAT];
    /*[_appDelegate.messages addObject:message];
     [_tableView reloadData];
     */
    
    
    NSDictionary *dict = @{KEY_SEND_MESSAGE: message
                           };
    
    
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_HAS_DATA_TO_SEND
                                                        object:nil
                                                      userInfo:dict];
    
    }
    
    [_appDelegate removeLastMessage:message.fromDeviceID];
    [_appDelegate.messages addObject:message];
    [_tableView reloadData];
    
    if(_appDelegate.messages.count>0){
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:_appDelegate.messages.count-1] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        //self.tableView.contentOffset=CGPointMake(0,0-self.tableView.contentInset.bottom);
    }
    
    
    [_txtMessage setText:nil];
    [_txtMessage resignFirstResponder];
    [_attachButton setEnabled:YES];
    _attachedPhoto.image=nil;
    
    //if(self.containerStaffsList.isHidden){
    // CGRect frame=self.tableView.frame;
    // frame.origin.y=self.sendMessageView.frame.origin.y;
    
    
    //[self.sendMessageView setHidden:YES];
    [self hideCompose:YES];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    //  [self.broadcastButton setEnabled:YES];
    
    //  self.tableView.frame=frame;
    // }
    // [self.showSendButton setTitle:@"Send message"];
}
//- (IBAction)cancelMessage:(id)sender {
- (void)cancelMessage{
    //[_txtMessage resignFirstResponder];
    
    [_txtMessage resignFirstResponder];
    
    //CGRect frame=self.tableView.frame;
    //frame.origin.y=self.sendMessageView.frame.origin.y;
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self hideCompose:YES];
    //[self.sendMessageView setHidden:YES];
    
    //[self.broadcastButton setEnabled:YES];
    
    //self.tableView.frame=frame;
    
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
        if(!_appDelegate.isIpad)
            [self.navigationController setNavigationBarHidden:YES animated:YES];
        [self.txtMessage becomeFirstResponder];
    }
    else{
        if(!_appDelegate.isIpad)
            [self.navigationController setNavigationBarHidden:NO animated:YES];
        [self.txtMessage endEditing:YES];
    }
    
    /*
    if(_appDelegate.mcManager.serverPeerInfo.maxUploadSizeKB==0)
        [self.attachButton setHidden:YES];
    else
        [self.attachButton setHidden:NO];
    */
}

- (void)clearMessage{
    self.txtMessage.text=@"";
}

#pragma mark - UIPicker configuration

//- (void)configurePickerView {
//    /*self.expirationDatePicker = [[UIPickerView alloc] init];
//     self.expirationDatePicker.delegate = self;
//     self.expirationDatePicker.dataSource = self;
//     self.expirationDatePicker.showsSelectionIndicator = YES;
//     */
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
//   /* UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done"
//                                                                   style:UIBarButtonItemStyleBordered
//                                                                  target:self
//                                                                  action:@selector(pickerDoneButtonPressed)];
//    */
//    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel"
//                                                                     style:UIBarButtonItemStyleBordered
//                                                                    target:self
//                                                                    action:@selector(cancelMessage)];
//    
//     UIBarButtonItem *attachFileButton= [[UIBarButtonItem alloc] initWithTitle:@"Attach"
//                                                                    style:UIBarButtonItemStyleBordered
//                                                                   target:self
//                                                                   action:@selector(attachButtonTapped:)];
//    UIBarButtonItem *sendButton = [[UIBarButtonItem alloc] initWithTitle:@"Send"
//                                                                   style:UIBarButtonItemStyleBordered
//                                                                  target:self
//                                                                  action:@selector(sendMessage)];
//    
//    //[pickerToolbar setItems:[NSArray arrayWithObjects:flexibleSpaceLeft, clearButton,sendButton, nil]];
//    
//    [pickerToolbar setItems:[NSArray arrayWithObjects:attachFileButton,flexibleSpaceLeft, sendButton,cancelButton,nil]];
//    
//    
//    /*self.expirationDateTextField.inputView = self.expirationDatePicker;
//     self.expirationDateTextField.inputAccessoryView = pickerToolbar;
//     self.nameTextField.inputAccessoryView = pickerToolbar;
//     self.emailTextField.inputAccessoryView = pickerToolbar;
//     self.cardNumber.inputAccessoryView = pickerToolbar;
//     self.CVCNumber.inputAccessoryView = pickerToolbar;
//     self.tableNumberTextField.inputAccessoryView=pickerToolbar;
//     */
//    
//    self.txtMessage.inputAccessoryView=pickerToolbar;
//}

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
    //sendButton = [[UIBarButtonItem alloc] initWithTitle:[NSString stringWithFormat:@"Send to %@",(selectedDeviceName!=nil)?selectedDeviceName:@"everyone"]
    sendButton = [[UIBarButtonItem alloc] initWithTitle:@"Send"
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

- (IBAction)showSendMessage:(id)sender {
//    if (self.sendMessageView.isHidden) {
//
//
//        [self.sendMessageView setHidden:NO];
//
//        /*CGRect frame=self.tableView.frame;
//        frame.origin.y=self.sendMessageView.frame.origin.y+self.sendMessageView.frame.size.height;
//        self.tableView.frame=frame;
//        */
//        // [self.showSendButton setTitle:@"Done"];
//     //   [_txtMessage becomeFirstResponder];
//    }
//    else{
//        
//        
//        /*CGRect frame=self.tableView.frame;
//        frame.origin.y=self.sendMessageView.frame.origin.y;
//        
//        
//        [self.sendMessageView setHidden:YES];
//        
//        self.tableView.frame=frame;
//        */
//        //[self.showSendButton setTitle:@"Send message"];
//    }
//    //_txtMessage.placeholder=@"Your private message here";
//    [self.view bringSubviewToFront:self.sendMessageView];
//    [_txtMessage becomeFirstResponder];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    /*
     
     
     if([segue.identifier isEqualToString:@"toStaffList"]){
     if(_appDelegate==nil)
     _appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
     PeerListViewController_iPhone *destViewController=(PeerListViewController_iPhone *)segue.destinationViewController;
     
     NSMutableArray *staffs=[NSMutableArray new];
     if(_appDelegate.mcManager.serverPeerInfo && _appDelegate.mcManager.serverPeerInfo.peers){
     [self.containerStaffsList setHidden:NO];
     NSDictionary *staff;
     NSString *file1Path;
     for (NSDictionary *peer_dict in _appDelegate.mcManager.serverPeerInfo.peers){
     if([[peer_dict valueForKey:@"PeerGroup"] isEqualToString:PEER_GROUP_STAFFS]){
     file1Path=[[AppDelegate getImagesPath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@%@.png",PREFIX_MYPHOTO,[peer_dict valueForKey:DeviceIdKey]]];
     if([[NSFileManager defaultManager] fileExistsAtPath:file1Path]){
     staff=@{
     @"Title":[peer_dict valueForKey:@"Title"],
     DeviceIdKey:[peer_dict valueForKey:DeviceIdKey],
     @"ImageName":[NSString stringWithFormat:@"%@%@.png",PREFIX_MYPHOTO,[peer_dict valueForKey:DeviceIdKey]]
     };
     
     }
     else{
     staff=@{
     @"Title":[peer_dict valueForKey:@"Title"],
     DeviceIdKey:[peer_dict valueForKey:DeviceIdKey],
     @"ImageName":@"person.png"
     };
     }
     [staffs addObject:staff];
     }
     
     }
     
     }
     else{
     //staff=@{@"Title":@"",@"ImageName":@"person.png"};
     [self.containerStaffsList setHidden:YES];
     }
     
     destViewController.articleDictionary=@{@"Staffs":staffs};
     [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_UPDATE_PEERS object:self];*/
    //[destViewController loadControllerFromSegue];
    /*
     if (!destViewController.reusableCells)
     {
     NSSortDescriptor* sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:nil ascending:YES selector:@selector(localizedCompare:)];
     NSArray* sortedCategories = [destViewControlle r.articleDictionary.allKeys sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
     
     NSString *categoryName;
     NSArray *currentCategory;
     
     destViewController.reusableCells = [NSMutableArray array];
     
     for (int i = 0; i < [destViewController.articleDictionary.allKeys count]; i++)
     {
     HorizontalTableCell_iPhone *cell = [[HorizontalTableCell_iPhone alloc] initWithFrame:CGRectMake(0, 0, 320, 416)];
     
     categoryName = [sortedCategories objectAtIndex:i];
     currentCategory = [self.articleDictionary objectForKey:categoryName];
     cell.articles = [NSArray arrayWithArray:currentCategory];
     
     [self.reusableCells addObject:cell];
     //[cell release];
     }
     }
     */
    
    // }

}

- (IBAction)settingsButtonTapped:(id)sender {
    
}

- (IBAction)broadcastButtonTapped:(id)sender {
   if(!_appDelegate.isIpad)
     [self.navigationController setNavigationBarHidden:YES animated:YES];
    _toLabel.text=[NSString stringWithFormat:@"To: everyone"];
    
    selectedDeviceId=nil;
   
    [self hideCompose:NO];
    
        [_txtMessage becomeFirstResponder];
    
    

}

- (IBAction)selectUsersAction:(id)sender {
}

- (IBAction)sendButtonTapped:(id)sender {
    [self sendMessage];
}
- (IBAction)cancelButtonTapped:(id)sender {
    [self cancelMessage];
    
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    UIImage *chosenImage=info[UIImagePickerControllerEditedImage];
    
    
    
    [picker dismissViewControllerAnimated:YES completion:^{
        
        [self finalAttachmentImage:chosenImage];
        
    }];

   
}

-(void)finalAttachmentImage:(UIImage *)chosenImage{
    //UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(0,0,140,140)];
    //NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@"before after"];
    
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
    //_txtMessage.textStorage.addAttributes(_txtMessage.typingAttributes,range:mEditingRange);
    //[_txtMessage.textStorage addAttributes:_txtMessage.typingAttributes range:<#(NSRange)#>]
   
    [_attachButton setEnabled:NO];
    
    [_txtMessage becomeFirstResponder];
}

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
    [_txtMessage becomeFirstResponder];
    [_attachButton setEnabled:YES];
    
}

- (IBAction)clearAllAction:(id)sender {
    
    //[self show:NOTIFY_SHOW_USERS];
    [_appDelegate.messages removeAllObjects];
    [self setEditing:NO];

    [self.tableView reloadData];
    //[self.tableView setEditing:NO];
    
}

- (IBAction)showUsersAction:(id)sender {
    
    //[self show:NOTIFY_SHOW_USERS];
    
    
}
/*
- (IBAction)showMenuAction:(id)sender {
    
    [self show:NOTIFY_SHOW_MENU];
    
}

- (IBAction)showOrdersAction:(id)sender {
    
    //[self show:NOTIFY_SHOW_ORDERHISTORY];
    [self show:NOTIFY_SHOW_ORDERHISTORY];
}

- (IBAction)showSettngsAction:(id)sender {
    [self show:NOTIFY_SHOW_SETTINGS];
    
}
*/
-(void)show:(NSString *)name{
    if(_appDelegate.isIpad){
        
        [[NSNotificationCenter defaultCenter] postNotificationName:name object:nil];
    }
    else{
        //the views here are not attach to tabview controller
        //instead they are segues from chat controllere
        if([name isEqualToString:NOTIFY_SHOW_MENU] || [name isEqualToString:NOTIFY_SHOW_USERS]){
            [self performSegueWithIdentifier:name sender:self];
        }
        
    }
    
}

-(void)badgeUpdateForOrders{
/*    if(_appDelegate.badgeOrderNumber==0)
        [ordersButtonItem setTitle:@"Orders(0)"];
    else
        [ordersButtonItem setTitle:[NSString stringWithFormat:@"Orders(%lu)",(unsigned long)_appDelegate.badgeOrderNumber]];
 */
}

-(void)badgeUpdateForMenu{
    /*if(_appDelegate.isIpad){
        if(_appDelegate.badgeOrderNumber==0)
            [ordersButtonItem setTitle:@"Orders"];
        else
            [ordersButtonItem setTitle:[NSString stringWithFormat:@"Orders(%lu)",(unsigned long)_appDelegate.badgeOrderNumber]];
    }
     */
}

# pragma mark -
# pragma mark ImagePicker
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
    /*
    self.pickerPhoto=[[UIImagePickerController alloc] init];
    self.pickerPhoto.delegate=self;
    self.pickerPhoto.allowsEditing=YES;
    
    self.pickerPhoto.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:self.pickerPhoto animated:YES
                     completion:NULL];
     */
    if(self.attachedPhoto.image!=nil){
        self.attachedPhoto.image=nil;
        [_attachButton setTitle:@"Attach" forState:UIControlStateNormal];
        
        //[self.txtMessage becomeFirstResponder];
    }
    else{
        self.pickerPhoto=[[UIImagePickerController alloc] init];
        self.pickerPhoto.modalPresentationStyle=UIModalPresentationCurrentContext;
        self.pickerPhoto.delegate=self;
        self.pickerPhoto.allowsEditing=YES;
    
        self.pickerPhoto.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:self.pickerPhoto animated:YES
                     completion:NULL];
    }
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
        
        //self.attachedPhoto.image=nil;
        //[_attachButton setTitle:@"Attach" forState:UIControlStateNormal];
        
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

-(void)selectUsersViewControllerDidSelect:(SelectUsersViewController *)controller withUsers:(NSArray *)users{
    //selectedDeviceId=[user valueForKey:@"DeviceId"];//
    //selectedDeviceName=[user objectForKey:@"Title"];//message.sender;
    _selectedUsers=[users mutableCopy];
    [controller dismissViewControllerAnimated:YES completion:^{
        [self updateRecipient];
        [self showSendPrivate:nil];
    }];
    
}

-(void)updateRecipient{
    
    NSString *peerDeviceId;//
    NSString *peerDeviceName;//message.sender;
    
    NSString *toPeers=@"";
    if([_selectedUsers count]>0){
        for(NSDictionary *user in _selectedUsers){
            
            peerDeviceId=[user valueForKey:DeviceIdKey];//
            peerDeviceName=[user objectForKey:TitleKey];//message.sender;
            
            if(peerDeviceId!=nil && peerDeviceName!=nil){
                toPeers=[toPeers stringByAppendingString:[NSString stringWithFormat:@"%@,", peerDeviceName]];
            }
            
        }
    }
    
    _toLabel.text=toPeers;
    
    
    
}

@end
