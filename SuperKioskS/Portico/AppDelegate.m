//
//  AppDelegate.m
//
//
//  Created by Romulo Quidilig.
//  Copyright (c) 2015 Sharecle Inc. All rights reserved.
//


#import "AppDelegate.h"
#import "GCDWebUploader.h"
#import "GCDWebHome.h"
#import "GCDWebServer.h"
#import "GCDWebServerDataResponse.h"
#import "GCDWebServerURLEncodedFormRequest.h"

//#import "ConnectionsViewController.h"
//#import "ChatViewController.h"
//#import "MenuViewController.h"
//#import "CheckoutViewController.h"
//#import "InventoryListViewController.h"
#import "BroadcastMessageAPI.h"
#import "MBProgressHUD.h"
#import "CheckoutCart.h"
#import "UserGroup.h"
#import "User.h"


#import <SystemConfiguration/CaptiveNetwork.h>


#import "defs.h"
int g_IOS_Type = 1;
int g_NeedToPublish=0;
/*void ShowErrorAlert(NSString* text)
{
    
    UIAlertView* alertView = [[UIAlertView alloc]
                              initWithTitle:text
                              message:nil
                              delegate:nil
                              cancelButtonTitle:NSLocalizedString(@"OK", nil)
                              otherButtonTitles:nil];
    
    [alertView show];
}
*/
@interface AppDelegate () <GCDWebUploaderDelegate,GCDWebHomeDelegate> {
    UIAlertView *registerAlert;
    BOOL registerLater;
//@interface AppDelegate () {
      // CTCallCenter* callCenter;
@private
    
 //   GCDWebServer *_webServer;
    GCDWebUploader* _webServerUploader;
     GCDWebHome* _webServerHome;
}
@end

@implementation AppDelegate


#pragma mark -System generated AppDelegate functions
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        
        _storyBoard=[UIStoryboard storyboardWithName:@"Main_iPad" bundle:nil];
        //_storyBoard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
        
        [[UILabel appearance] setFont:[UIFont systemFontOfSize:FONTSIZE_IPAD]];
        [[UITextField appearance] setFont:[UIFont systemFontOfSize:FONTSIZE_IPAD]];
        
      //  [[UIButton appearance] setFont:[UIFont systemFontOfSize:20]];
        
        
        //self.window.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"common_bg@2x.png"]];
        self.isIpad=YES;
    }
    else {
        
        _storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        //self.window.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"common_bg.png"]];
        self.isIpad=NO;
        
    }
    
   
    
    
    //local notification
    /*doesnt work//ios8
    if([application respondsToSelector:@selector(registerUserNotificationSettings:)]){
        UIUserNotificationSettings *settings=[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge|UIUserNotificationTypeAlert|UIUserNotificationTypeSound categories:nil];
        [application registerUserNotificationSettings:settings];
        
    }
    //ios 7 or earlier
    else {
        UIRemoteNotificationType myTypes=UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeSound;
        [application registerForRemoteNotificationTypes:myTypes];
    }
     */
    
    
    /*if (![self.appConfig objectForKey:KEY_APP_NIKCNAME]) {
        [self.appConfig setValue:[[UIDevice currentDevice] name] forKey:KEY_APP_NIKCNAME];
    }
    
    
    if (![self.appConfig objectForKey:KEY_APP_VISIBLE]) {
        [self.appConfig setValue:@1 forKey:KEY_APP_VISIBLE];
        
    }
*/
    //start reachability
    _reachabilityManager=[ReachabilityManager sharedInstance];
    [self loadSettings];
    
    

    
     [self setBackgroundImage];
    #pragma mark Magtek
    //self.mtSCRALib = [[MTSCRA alloc] init];
    
    /*
     *
     *  NOTE: TRANS_STATUS_START should be used with caution. CPU intensive tasks done after this events and before
     *        TRANS_STATUS_OK may interfere with reader communication.
     *
     */
    
   // [self.mtSCRALib listenForEvents:(TRANS_EVENT_START|TRANS_EVENT_OK|TRANS_EVENT_ERROR)];
    
    /*
     *
     *  NOTE: When calling the View Controller's openDevice method automatically when the application is coming back from a
     *        Background State it is recommended that a 5 second delay be issued to ensure that the device has enough time
     *        to power on.
     *
     */
    
    // Uncomment these lines to add a 5 second delay before the automatic openDevice call
    //    [mtSCRALib setDeviceType:(MAGTEKIDYNAMO)];
    //    [NSTimer scheduledTimerWithTimeInterval:5.0
    //                                     target:self
    //                                   selector:@selector(openDeviceConnection)
    //                                   userInfo:nil
    //                                    repeats:NO];
/*
    callCenter = [[CTCallCenter alloc] init];
    [callCenter setCallEventHandler:^(CTCall *call)
     {
         NSLog(@"Event handler called");
         if ([call.callState isEqualToString: CTCallStateConnected])
         {
             NSLog(@"Connected");
         }
         else if ([call.callState isEqualToString: CTCallStateDialing])
         {
             NSLog(@"Dialing");
         }
         else if ([call.callState isEqualToString: CTCallStateDisconnected])
         {
             NSLog(@"Disconnected");
             dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                 [[self viewController] openDevice];
             });
             
         } else if ([call.callState isEqualToString: CTCallStateIncoming])
         {
             NSLog(@"Incomming");
         }
     }];
*/
#pragma mark Remote notification
    if([application respondsToSelector:@selector(isRegisteredForRemoteNotifications)]){
        //iOS 8 Notifications
        [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert|UIUserNotificationTypeBadge) categories:nil]];
    }
    else{
        //iOS < 8 Notifications
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
         (UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert| UIRemoteNotificationTypeBadge)];
    }

    if (launchOptions != nil)
    {
        NSDictionary* dictionary = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
        if (dictionary != nil)
        {
#ifdef DEBUG
            NSLog(@"Launched from push notification: %@", dictionary);
#endif
            [self addMessageFromRemoteNotification:dictionary updateUI:NO];
        }
    }

  
    return YES;
}

-(void)loadSettings{
    // Create server
    // _webServer = [[GCDWebServer alloc] init];
    
    // Add a handler to respond to GET requests on any URL
    /* [_webServer addDefaultHandlerForMethod:@"GET"
     requestClass:[GCDWebServerRequest class]
     processBlock:^GCDWebServerResponse *(GCDWebServerRequest* request) {
     
     return [GCDWebServerDataResponse responseWithHTML:@"<html><body><h2><p>Hello World</p><h2><img src='myphoto.png'/></body></html>"];
     
     }];
     */
    /*  [_webServer addHandlerForMethod:@"GET"
     path:@"/"
     requestClass:[GCDWebServerRequest class]
     processBlock:^GCDWebServerResponse *(GCDWebServerRequest* request) {
     
     return [GCDWebServerResponse responseWithRedirect:[NSURL URLWithString:@"helloworld.html" relativeToURL:request.URL]
     permanent:NO];
     
     }];
     
     // Start server on port 8080
     [_webServer startWithPort:8080 bonjourName:nil];
     NSLog(@"Visit %@ in your web browser", _webServer.serverURL);
     */
    //GCDWebServer* webServer = [[GCDWebServer alloc] init];
    /*[_webServer addGETHandlerForBasePath:@"/" directoryPath:NSHomeDirectory() indexFilename:nil cacheAge:3600 allowRangeRequests:YES];
     [_webServer startWithPort:8080 bonjourName:nil ];
     */
   
    
    self.appConfig=[AppConfigModel sharedInstance];

    
     [AppConfigModel loadSettings];
    
    _inventoryModel=[InventoryModel sharedInstance];
    /*
    self.currentInventory=[InventoryModel activeInventory];
    if(self.currentInventory==nil){
        self.currentInventory=[InventoryItem new];
    }
    */
    self.messages=[NSMutableArray new];
    NSString* documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    
    //self.appConfig.device_ssid=[AppDelegate currentWifiSSID];
    /*working
     [_webServer addGETHandlerForBasePath:@"/" directoryPath:documentsPath indexFilename:nil cacheAge:3600 allowRangeRequests:YES];
     */
    
    
    /*[_webServer addHandlerForMethod:@"GET"
     path:@"/"
     requestClass:[GCDWebServerRequest class]
     processBlock:^GCDWebServerResponse *(GCDWebServerRequest* request) {
     
     return [GCDWebServerResponse responseWithRedirect:[NSURL URLWithString:@"index.html" relativeToURL:request.URL]
     permanent:NO];
     
     }];*/
    
    /*[_webServer addHandlerForMethod:@"GET"
     path:@"/menu"
     requestClass:[GCDWebServerRequest class]
     processBlock:^GCDWebServerResponse *(GCDWebServerRequest* request) {
     
     NSString* html = @" \
     <html><body> \
     <form name=\"input\" action=\"/menu\" method=\"post\" enctype=\"application/x-www-form-urlencoded\"> \
     Value: <input type=\"text\" name=\"value\"> \
     <input type=\"submit\" value=\"Submit\"> \
     </form> \
     </body></html> \
     ";
     return [GCDWebServerDataResponse responseWithHTML:html];
     
     }];
     
     [_webServer addHandlerForMethod:@"POST"
     path:@"/menu"
     requestClass:[GCDWebServerURLEncodedFormRequest class]
     processBlock:^GCDWebServerResponse *(GCDWebServerRequest* request) {
     
     NSString* value = [[(GCDWebServerURLEncodedFormRequest*)request arguments] objectForKey:@"value"];
     NSString* html = [NSString stringWithFormat:@"<html><body><p>%@</p></body></html>", value];
     return [GCDWebServerDataResponse responseWithHTML:html];
     
     }];
     */
    // [_webServer startWithPort:8080 bonjourName:nil ];
    //uploader
    if(_appConfig.enableHttp){
        _webServerUploader = [[GCDWebUploader alloc] initWithUploadDirectory:documentsPath];
        _webServerUploader.delegate = self;
        _webServerUploader.allowHiddenItems = YES;
        [_webServerUploader startWithPort:8081 bonjourName:nil];
       
        
        
        _webServerHome = [[GCDWebHome alloc] initWithUploadDirectory:documentsPath];
        _webServerHome.delegate = self;
        _webServerHome.allowHiddenItems = YES;
        [_webServerHome startWithPort:8080 bonjourName:nil];
    }
    
    
    //_userInfo=[[UserInfo alloc] init];
    
    /*
     _appConfig.device_uuid=[[[[UIDevice currentDevice] identifierForVendor]  UUIDString] lowercaseString];
    
    _appConfig.device_id=_appConfig.device_uuid;
*/
    
    NSString *deviceID=[[[[UIDevice currentDevice] identifierForVendor]  UUIDString] lowercaseString];
    
    //deviceID=[deviceID stringByReplacingOccurrencesOfString:@"-" withString:@""];
    
    //deviceID=[deviceID substringToIndex:15];
    
    _appConfig.device_uuid=deviceID;
    _appConfig.device_id=deviceID;
    
    
    
/*    if(!_appConfig.device_id){
        _appConfig.device_id=[[[[UIDevice currentDevice] identifierForVendor]  UUIDString] lowercaseString];
        
        if (!_appConfig.device_id) {
            _appConfig.device_id=[[[NSUUID UUID] UUIDString] lowercaseString];
            
            
        }
        
        
    }
 
    
    //_userInfo.deviceID=[[[[UIDevice currentDevice] identifierForVendor]  UUIDString] lowercaseString];
    
    if(!_appConfig.device_uuid){
        _appConfig.device_uuid=[[[[UIDevice currentDevice] identifierForVendor]  UUIDString] lowercaseString];
        
        if (!_appConfig.device_uuid) {
            _appConfig.device_uuid=[[[NSUUID UUID] UUIDString] lowercaseString];
            
            
        }
        
        
    }
  */
    
    
    
    
    //_userInfo.deviceID=_appConfig.device_id;
    if(!self.appConfig.user_displayName)
        self.appConfig.user_displayName=_appConfig.device_name;// [[UIDevice currentDevice] name];
#ifdef DEBUG
    NSLog(@"deviceID=%@",_appConfig.device_id);
     NSLog(@"deviceUUID=%@",_appConfig.device_uuid);
    //[UIImage imageNamed:@"person.png"]
#endif
    self.appConfig.user_deviceToken=@"";
    
    self.appConfig.user_photo=[UIImage imageNamed:@"myphoto.png"];
    if(!self.appConfig.user_photo)
        self.appConfig.user_photo=[UIImage imageNamed:@"person.png"];
    
    self.appConfig.user_homeUrl=[NSString stringWithFormat:@"%@",_webServerHome.serverURL];
    
    
    
    _printManager=[PrintManager sharedInstance];
    /*self.tabBarController=[[UITabBarController alloc] init];
     self.loginController=[[LoginViewController alloc] init];
     */
    //[self showLoginController];
}

-(void)loggedInSuccessWithInfo:(NSDictionary *)info{
    
    [self saveOrUpdateLogonInfoFromWeb:info];
    
    [self showTabBarController];
    
    _mcManager = [[MCManager alloc] init];
    
    [_mcManager start];
    
    _cnnManager=[[ConnectionManager alloc] init];
    
    //set client or server
    
    _historyModel=[HistoryModel sharedInstance];
    
    //this is a bug, this is not the right place to load bec no file name is specified
    //[_historyModel loadHistory];
    
    self.historyModel.isServer=YES;
    self.historyModel.filename=_appConfig.device_id;
    
    [_historyModel loadHistory];
    
    
    //self.badgeOrderNumber=0;
    //get/set the last ordernumber
    //self.lastOrderNumber=_historyModel.lastOrderNumber;
    
    //dispaly badge
    // we dont need this bec loadhistory calls it
    //NSDictionary *history_dict=[_historyModel getFilteredHistory:self.appConfig.isLive showClosed:self.appConfig.showClosed showCancelled:self.appConfig.showCancelled showRefunds:self.appConfig.showRefunds showFailed:self.appConfig.showFailed showPaid:self.appConfig.showPaid showUnpaid:self.appConfig.showUnpaid];
    //NSDictionary *history_dict=_historyModel.filteredHistory;
    
    if(_historyModel.filteredHistory!=nil){
        NSUInteger count= [[_historyModel.filteredHistory  valueForKey:@"total"] integerValue];
        //if(count>0){
        UITabBarController *tabBarcontroller=(UITabBarController*)self.window.rootViewController;
        UITabBarItem *tbi=(UITabBarItem *)[tabBarcontroller.tabBar.items objectAtIndex:TAB_INDEX_ORDERS];
        
        if(count==0){
            tbi.badgeValue=nil;
        }
        else{
            tbi.badgeValue=[NSString stringWithFormat:@"%ld",(long)count];
            
            
        }
        [UIApplication sharedApplication].applicationIconBadgeNumber=count;
        
        //self.badgeOrderNumber=count;
    }
    

    
    /*
     [self.activeInventory=[InventoryModel publishedInstance];
     [self.activeInventory loadInventory];
     */
    
    InventoryModel *inventoryModel=[InventoryModel sharedInstance];
    [inventoryModel loadInventory];

}


-(void)enableHttp:(BOOL)enabled{
    //NSString *retUrl=nil;
    if(enabled){
        if(_webServerUploader){
            if([_webServerUploader isRunning])
                return;
        }
        
        else{
            _webServerUploader = [[GCDWebUploader alloc] initWithUploadDirectory:[AppDelegate getDocumentsPath]];
            _webServerUploader.delegate = self;
            _webServerUploader.allowHiddenItems = YES;
        }
        
        [_webServerUploader startWithPort:8081 bonjourName:nil];
        //retUrl=[_webServerUploader.serverURL absoluteString];
        /*
        if(_webServerHome)
            [_webServerHome stop];
        else{
            _webServerHome = [[GCDWebHome alloc] initWithUploadDirectory:[AppDelegate getDocumentsPath]];
            
            _webServerHome.delegate = self;
            _webServerHome.allowHiddenItems = YES;
        }
        
        [_webServerHome startWithPort:8080 bonjourName:nil];
        retUrl=[_webServerHome.serverURL absoluteString]
         */
    }
    else{
        if([_webServerUploader isRunning])
            [_webServerUploader stop];
        
        /*if(_webServerHome)
            [_webServerHome stop];
        */
        //retUrl=[_webServerUploader.serverURL absoluteString];
    }
    //return retUrl;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [AppConfigModel saveSettings];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [AppConfigModel saveSettings];
}

//web server download
/*
- (void)webUploader:(GCDWebUploader*)uploader didUploadFileAtPath:(NSString*)path {
    NSLog(@"[UPLOAD] %@", path);
}

- (void)webUploader:(GCDWebUploader*)uploader didMoveItemFromPath:(NSString*)fromPath toPath:(NSString*)toPath {
    NSLog(@"[MOVE] %@ -> %@", fromPath, toPath);
}

- (void)webUploader:(GCDWebUploader*)uploader didDeleteItemAtPath:(NSString*)path {
    NSLog(@"[DELETE] %@", path);
}

- (void)webUploader:(GCDWebUploader*)uploader didCreateDirectoryAtPath:(NSString*)path {
    NSLog(@"[CREATE] %@", path);
}
*/

-(void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings{
    [application registerForRemoteNotifications];
}

- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
    
    //DataModel *dataModel = [DataModel getInstance];
    
    NSString* newToken = [deviceToken description];
    newToken = [newToken stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    newToken = [newToken stringByReplacingOccurrencesOfString:@" " withString:@""];
#ifdef DEBUG
    NSLog(@"My token is: %@", newToken);
#endif
    //_appConfig.device_token=newToken;
    //[self initWithAPNSToken:newToken];
    if(_appConfig)
        _appConfig.device_token=newToken;

   
}

- (void)application:(UIApplication*)application didReceiveRemoteNotification:(NSDictionary*)userInfo
{
    
#ifdef DEBUG
    NSLog(@"Received notification: %@", userInfo);
#endif
    [self addMessageFromRemoteNotification:userInfo updateUI:YES];
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
    NSLog(@"Failed to get token, error: %@.", error);
    /*DataModel *dataModel = [DataModel getInstance]; //chatViewController.dataModel;
     NSString* oldToken = dataModel.userInfo.devicetoken;
     dataModel.userInfo.devicetoken=nil;
     dataModel.deviceToken=nil;
     
     //dataModel.userInfo.devicetoken=[[[NSUUID UUID] UUIDString] lowercaseString];
     NSLog(@"Created token : %@",  dataModel.userInfo.devicetoken);
     
     
     if (dataModel.userInfo.loggedIn && ![dataModel.userInfo.devicetoken isEqualToString:oldToken])
     {
     [dataModel postUpdateRequest];
     }
     */
    //NSString *token=[[[[UIDevice currentDevice] identifierForVendor]  UUIDString] lowercaseString];//[[[NSUUID UUID] UUIDString] lowercaseString];
   // [self initWithAPNSToken:@""];
    if(_appConfig){
        _appConfig.device_token=_appConfig.device_uuid;
    }
    
}

- (void)addMessageFromRemoteNotification:(NSDictionary*)userInfo updateUI:(BOOL)updateUI
{
   /* UITabBarController *tabBarcontroller=(UITabBarController*)self.window.rootViewController;
    
    
    //UINavigationController *navigationController;
    
    UITabBarItem *tbi=(UITabBarItem *)[tabBarcontroller.tabBar.items objectAtIndex:TAB_INDEX_CHAT];
    int badgeValue=[tbi.badgeValue intValue];
    
    badgeValue++;
    
    tbi.badgeValue=[NSString stringWithFormat:@"%lu",(unsigned long)badgeValue];
    
    [UIApplication sharedApplication].applicationIconBadgeNumber=badgeValue;
    */
    //rom: i dont need this for now:
#ifdef DEBUG
    NSLog(@"remote notification: userInfo = %@",userInfo
          );
#endif
    NSString* alertValue = [[userInfo valueForKey:@"aps"] valueForKey:@"alert"];
    
    
    
    //[[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_UPDATE_SETTINGS object:nil userInfo:@{@"alert":alertValue}];
    
       if([alertValue isEqualToString:@"reset"]){
        self.appConfig.user_password=nil;
           [AppConfigModel saveSettings];
        [self showLoginController];
    }
    else if([alertValue isEqualToString:@"restart"]){
        [self showLoginController];
    }
    
    
    
    
    }

#pragma mark -Global directory utility functions
+ (NSString*)getImagesPath
{
    //NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    //NSString* documentsDirectory = paths[0];
    NSError *error;
    BOOL isDirectory=YES;
    NSString *directory=[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"images"];
    if([[NSFileManager defaultManager] fileExistsAtPath:directory]==NO){
        [[NSFileManager defaultManager] createDirectoryAtPath:directory withIntermediateDirectories:NO attributes:nil error:&error];
    }
    if(![[NSFileManager defaultManager] fileExistsAtPath:directory isDirectory:&isDirectory])
        [[NSFileManager defaultManager] createDirectoryAtPath:directory withIntermediateDirectories:YES attributes:nil error:&error];
    if (error!=nil) {
        return nil;
    }
    return directory;
}

+ (NSString*)getBackupPath
{
    //NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    //NSString* documentsDirectory = paths[0];
    NSError *error;
    BOOL isDirectory=YES;
    NSString *directory=[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"backup"];
    if([[NSFileManager defaultManager] fileExistsAtPath:directory]==NO){
        [[NSFileManager defaultManager] createDirectoryAtPath:directory withIntermediateDirectories:NO attributes:nil error:&error];
    }
    if(![[NSFileManager defaultManager] fileExistsAtPath:directory isDirectory:&isDirectory])
        [[NSFileManager defaultManager] createDirectoryAtPath:directory withIntermediateDirectories:YES attributes:nil error:&error];
    if (error!=nil) {
        return nil;
    }
    return directory;
}
+ (NSString*)getSharedPath__
{
    //NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    //NSString* documentsDirectory = paths[0];
    NSError *error;
    BOOL isDirectory=YES;
    NSString *directory=[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"shared"];
    if([[NSFileManager defaultManager] fileExistsAtPath:directory]==NO){
        [[NSFileManager defaultManager] createDirectoryAtPath:directory withIntermediateDirectories:NO attributes:nil error:&error];
    }
    if(![[NSFileManager defaultManager] fileExistsAtPath:directory isDirectory:&isDirectory])
        [[NSFileManager defaultManager] createDirectoryAtPath:directory withIntermediateDirectories:YES attributes:nil error:&error];
    if (error!=nil) {
        return nil;
    }
    return directory;
}

+ (NSString*)getDocumentsPath
{
    //NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    //NSString* documentsDirectory = paths[0];
    //NSError *error;
    //BOOL isDirectory=YES;
    NSString *directory=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] ;
    return directory;
}



#pragma mark -Global date utility functions

+(NSString*)today{
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    return [dateFormatter stringFromDate:[NSDate date]];
}

#pragma mark -Global Order utility functions

-(OrderHistory *)searchOrderWithID:(NSString *)orderID withOrderDay:(NSString *)orderDay withStoreID:(NSString *)storeID withDeviceID:(NSString *)deviceID{
    
    NSMutableArray *orders=[self.historyModel.history valueForKey:orderDay];
    if(orders!=nil && [orders count]>0){
        //search first
        NSPredicate *predicate=[NSPredicate predicateWithFormat:@"orderID=%@ AND orderDay=%@ AND orderStoreID=%@ AND orderDeviceID=%@",orderID,orderDay,storeID,deviceID];
        NSArray *searchResult=[orders filteredArrayUsingPredicate:predicate];
        
        if([searchResult count]>0)
            return [searchResult firstObject];
    }
    return nil;
    
}

-(NSArray *)searchUnpaidOrderWithDeviceID:(NSString *)deviceID withStoreID:(NSString *) orderStoreID isLive:(BOOL) isLive{
    NSMutableArray *results=[NSMutableArray new];
    
    //[self.historyModel loadHistory];
    NSArray *historyDates=[[self.historyModel.history allKeys] mutableCopy];
    if([historyDates count]==0)
        return nil;
    for(NSString *item_day in historyDates){
        NSMutableArray *orders=[self.historyModel.history valueForKey:item_day];
        if([orders count]>0){
            //search first
            //NSPredicate *predicate=[NSPredicate predicateWithFormat:@"orderDeviceID==%@ AND orderDay=%@ AND orderStoreID==%@ AND orderIsPaid==NO AND orderStatus NOT IN %@",deviceID,item_day,orderStoreID,@[@ORDER_STATUS_CANC,@ORDER_STATUS_CLOSED]];
            
            NSPredicate *predicate=[NSPredicate predicateWithFormat:@"orderDeviceID==%@ AND orderDay=%@ AND orderStoreID==%@ AND orderIsPaid==NO AND orderIsLive==%@ AND (orderStatus!=%@ AND orderStatus!=%@)",deviceID,item_day,orderStoreID,isLive,@ORDER_STATUS_CANC,@ORDER_STATUS_CLOSED];
            
            NSArray *searchResult=[orders filteredArrayUsingPredicate:predicate];
            
            if([searchResult count]>0)
            {
                //return [searchResult firstObject];
                [results addObject:searchResult];
            }
        }
    }
    
    return results;
    
}

/*
-(OrderHistory *)deleteUnpaidOrderWithDeviceID:(NSString *)deviceID orderID:(NSString *)orderID withStoreID:(NSString *) orderStoreID{
    
    
    [self.historyModel loadHistory];
    NSArray *historyDates=[[self.historyModel.history allKeys] mutableCopy];
    if([historyDates count]==0)
        return nil;
    for(NSString *item_day in historyDates){
        NSMutableArray *orders=[self.historyModel.history valueForKey:item_day];
        if([orders count]>0){
            //search first
            NSPredicate *predicate=[NSPredicate predicateWithFormat:@"orderID=%@ AND orderDeviceID=%@ AND orderDay=%@ AND orderStoreID=%@ AND orderStatus=%i", deviceID,item_day,orderStoreID,ORDER_STATUS_UNPAID];
            NSArray *searchResult=[orders filteredArrayUsingPredicate:predicate];
            
            if([searchResult count]>0){
                
                //return [searchResult firstObject];
                [orders removeObject:[searchResult firstObject]];
                [self.historyModel saveHistory];
            }
        }
    }
    
    return nil;
    
}
 */
-(void)deleteOrderHistoryItem:(OrderHistory *)item{
    [self.historyModel loadHistory];
    
    NSMutableArray *orders=[self.historyModel.history valueForKey:item.orderDay];
    
    if([orders containsObject:item]){
                [orders removeObject:item];
            [self.historyModel saveHistory];
        
    }
    
    
}

-(void)CreateOrderFromServer:(NSString *)withOrderDetail orderBy:(NSString *)orderBy orderStatus:(NSNumber *) orderStatus {
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc ]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *today=[dateFormatter stringFromDate:[NSDate date]];
    
    OrderHistory *newOrder=[[OrderHistory alloc] init];
   // newOrder.orderDetailText=withOrderDetail;
    newOrder.orderBy=orderBy;
    newOrder.orderDateTime=[NSDate date];
    newOrder.orderDate=[dateFormatter dateFromString:today];
    
    newOrder.orderStatus=@ORDER_STATUS_RECEIVED;
    
    NSMutableArray *orders=[_historyModel.history valueForKey:today];
    if(orders==nil)
        orders=[NSMutableArray new];
    
    //_lastOrderNumber++;
    _historyModel.lastOrderNumber++;
    
    newOrder.orderNumber=[NSNumber numberWithUnsignedInteger:_historyModel.lastOrderNumber];//[NSNumber numberWithUnsignedInteger:[orders count]+1];
    
    //[orders addObject:newOrder];
    
    [_historyModel addOrUpdateHistory:newOrder];
    
    //_badgeOrderNumber++;
    
    [self updateBadgeOrders];
}

//+(NSDictionary *)charge:(NSString *)stripeAmount stripeCurrency:(NSString *)stripeCurrency stripeToken:(NSString *)stripeToken stripeDescription:(NSString *)stripeDescription{*/
#pragma mark -Global show alert utility functions
+(void)ShowErrorAlert:(NSString *)message
{
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Error" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
}




-(void)showTabBarController{
    if(self.tabBarController==nil){
        //self.tabBarController=[[UITabBarController alloc] init];
        self.tabBarController=(UITabBarController*)[ApplicationDelegate.storyBoard instantiateViewControllerWithIdentifier:@"TabBarController"];
        //set tabs base on device settings such as category
        //TODO:
        /*ConnectionsViewController *connectionController=[[ConnectionsViewController alloc] init];
        ChatViewController *chatController=[[ChatViewController alloc] init];
        OrderViewController *orderController=[[OrderViewController alloc] init];
        CheckoutViewController *checkoutController=[[CheckoutViewController alloc] init];
        InventoryViewController *inventoryController=[[InventoryViewController alloc] init];
        
        self.tabBarController.viewControllers=@[connectionController,chatController,orderController,checkoutController,inventoryController];
         */
    }
    
    

    [self.window setRootViewController:self.tabBarController];
    if(_loginController!=nil)
        [self.loginController dismissViewControllerAnimated:YES completion:nil];
}


-(void)showLoginController{
    if(self.loginController==nil){
        self.loginController=[[LoginViewController alloc] init];
        
    }
    
    [self.window setRootViewController:self.loginController];
    if(self.tabBarController!=nil)
        [self.tabBarController dismissViewControllerAnimated:YES completion:nil];
}
/*
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
*/
-(void)showRegisteAlert{
    
    
    if(_appConfig.device_status==DEVICE_STATUS_APPROVED)
        return;
    
    
    
    if(_appConfig.device_status==DEVICE_STATUS_REGISTERED ){
        
        registerAlert=[[UIAlertView alloc] initWithTitle:nil message:@"Please complete device registration to go LIVE. Complete registration?" delegate:self cancelButtonTitle:@"Later" otherButtonTitles:@"Yes", nil];
        [registerAlert show];
    }
    else if(_appConfig.device_status==DEVICE_STATUS_WAITINGAPPROVAL ){
        
        registerAlert=[[UIAlertView alloc] initWithTitle:nil message:@"Your request to go LIVE is being process for approval. Please email accountservices@sharecle.com for inquiries." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [registerAlert show];
    }
    else if(_appConfig.device_status==DEVICE_STATUS_CANCELLED ){
        
        
        
        registerAlert=[[UIAlertView alloc] initWithTitle:nil message:@"Account is CANCELLED. Please email accountservices@sharecle.com for assistance." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [registerAlert show];
    }
    else if(_appConfig.device_status==DEVICE_STATUS_NOTREGISTERED ){
        
        
        registerAlert=[[UIAlertView alloc] initWithTitle:nil message:@"Account is NOT REGISTRED. Please email accountservices@sharecle.com for inquiries." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [registerAlert show];
    }
    else{
        registerAlert=[[UIAlertView alloc] initWithTitle:nil message:@"Account is in UNKNOWN STATE. Please email accountservices@sharecle.com for inquiries." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [registerAlert show];
        
    }
    
    //return NO;
    
}

-(void)showRegisterDevice{
    
    if(!self.appConfig.user_userToken){
        [self showLoginController];
        return;
    }
    
    if(!self.appConfig.device_id)
    {
        [AppDelegate ShowErrorAlert:@"Missing device identifier. Please restart or re-install app"];
        return;
    }
    
    NSError *error;
    
    //NSString *address=@""; //TODO
    //NSString *info=[NSString stringWithFormat:@"usertoken=%@&deviceid=%@&devicename=%@&address=%@",_appDelegate.userInfo.userToken,_appDelegate.userInfo.deviceID,_appDelegate.appConfig.device_name,address];
    NSString *info=[NSString stringWithFormat:@"usertoken=%@&deviceid=%@&devicename=%@",self.appConfig.user_userToken,self.appConfig.device_id,self.appConfig.device_name];
    
    
    
    
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
    [self.window.rootViewController presentViewController:webNav animated:YES completion:nil];
    
    //[self presentViewController:webController animated:YES completion:nil];
}


-(void)removeLastMessage:(NSString *)fromDeviceID{
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"fromDeviceID==%@",fromDeviceID];
    NSArray *existing=[self.messages filteredArrayUsingPredicate:predicate];
    if([existing count]>0){
        for(BroadcastMessageAPI *item in existing){
            //if([self.peerDevices containsObject:searchPeerInfo]){
            NSInteger indexOfPeer = [self.messages indexOfObject:item];
            //peerInfo=[self.peerDevices objectAtIndex:indexOfPeer];
            
            //}
            [self.messages removeObjectAtIndex:indexOfPeer];
        }
    }
}

+(NSString *)currentWifiSSID{
    @try{
    CFArrayRef myArray = CNCopySupportedInterfaces();
        if(myArray==nil)
            return @"";
    CFDictionaryRef myDict = CNCopyCurrentNetworkInfo(CFArrayGetValueAtIndex(myArray, 0));
    //NSLog(@"Connected at:%@",myDict);
    NSDictionary *myDictionary = (__bridge_transfer NSDictionary*)myDict;
    //NSString * BSSID = [myDictionary objectForKey:@"BSSID"];
    //NSLog(@"bssid is %@",BSSID);
    //#ifdef DEBUG
    //NSLog(@"SSID=%@",[myDictionary objectForKey:@"SSID"]);
    NSLog(@"Connected at:%@",myDict);
    //#endif
    if(myDictionary!=nil)
        
        //return [NSString stringWithFormat:@"%@ %@ %@",DICT_GET(myDictionary, @"SSID"),DICT_GET(myDictionary,@"BSSID"),DICT_GET(myDictionary, @"SSIDDATA")];
        return [NSString stringWithFormat:@"%@ %@ %@",DICT_GET(myDictionary, @"SSID"),DICT_GET(myDictionary,@"BSSID"),DICT_GET(myDictionary, @"SSIDDATA")];
                                                                                                                               
    else
       return @"";
    }
    @catch(NSException *e){
#ifdef DEBUG
        NSLog(@"%@",e);
#endif
    }
    return @"";
    /*
     Connected at:{
     BSSID = 0;
     SSID = "Eqra'aOrange";
     SSIDDATA = <45717261 27614f72 616e6765>;
     }
     */
}

-(void)lockDevice{
    
    UIAlertView *alert;
    if(_appConfig.user_pin.length==0){
        alert=[[UIAlertView alloc] initWithTitle:@"PIN is not set" message:@"Enter new PIN" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Set PIN", nil];
        alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    }
    else{
        alert=[[UIAlertView alloc] initWithTitle:@"Device Locked" message:@"Enter PIN" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Unlock", nil];
        alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    }
    _appConfig.user_usepin=YES;
    [AppConfigModel saveSettings];
    [alert show];
}

-(void)registerAlert:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSString *title=[alertView buttonTitleAtIndex:buttonIndex];
    if([alertView isEqual:registerAlert]){
        if([title isEqualToString:@"Yes"]){
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
}
-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
//-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if([alertView isEqual:registerAlert]){
        [self registerAlert:alertView clickedButtonAtIndex:buttonIndex];
    }
    else{
        NSString *title=[alertView buttonTitleAtIndex:buttonIndex];
        
        if([title isEqualToString:@"Unlock"]){
            UITextField * alertTextField = [alertView textFieldAtIndex:0];
            if(alertTextField.text.length>0){
                if ([alertTextField.text isEqualToString:self.appConfig.user_pin] || [alertTextField.text isEqualToString:self.appConfig.user_password]) {
                    
                    if([alertTextField.text isEqualToString:self.appConfig.user_password]){
                        self.appConfig.user_pin=nil;
                    }
                    
                    self.appConfig.user_usepin=NO;
                    [AppConfigModel saveSettings];
                    return;
                }
                
            }
            [self lockDevice];
            
        }
        else if([title isEqualToString:@"Set PIN"]){
            UITextField * alertTextField = [alertView textFieldAtIndex:0];
            if(alertTextField.text.length>0){
                self.appConfig.user_pin=[alertTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" "]];
                self.appConfig.user_usepin=YES;
                [AppConfigModel saveSettings];
                [self lockDevice];
                
            }
        }
    }
    
}

+(NSDictionary *)fromJsonString:(NSString *) string{
    NSData *data=[string dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    if(error)
        return nil;
    return dict;
}


-(void)saveOrUpdateDeviceInfoFromWeb:(NSDictionary*) jsondevice{
    //0: error 1:registered 2:approved/can go live 3:cancelled
    _appConfig.device_status=[DICT_GET(jsondevice, @"status") intValue];
    
    if(_appConfig.device_status==0)
        _appConfig.device_status=DEVICE_STATUS_REGISTERED;

    _appConfig.bankstatus=[DICT_GET(jsondevice, bankStatusKey) intValue];
    _appConfig.bankName=DICT_GET(jsondevice, bankNameKey);
    _appConfig.bankHolder=DICT_GET(jsondevice, bankHolderKey);
    _appConfig.bankAcct=DICT_GET(jsondevice, bankAcctKey);
    _appConfig.bankRouting=DICT_GET(jsondevice, bankRoutingKey);
    
   // _appConfig.device_groupid=[DICT_GET(jsondevice, @"groupID") intValue];
    
    _appConfig.device_menuid=[DICT_GET(jsondevice, @"menuID") intValue];
    
    //if(_appConfig.device_status==DEVICE_STATUS_APPROVED)
    //    _appConfig.isLive=YES;
    _appConfig.storeID=DICT_GET(jsondevice, storeIDKey);
   
    
    
    _appConfig.device_lat=[DICT_GET(jsondevice, latitudeKey) floatValue];
    _appConfig.device_lng=[DICT_GET(jsondevice, longitudeKey) floatValue];
    
    
    _appConfig.device_name=DICT_GET(jsondevice, deviceNameKey);
    _appConfig.device_id=DICT_GET(jsondevice, deviceIDKey);
    _appConfig.device_num=DICT_GET_INT(jsondevice, deviceNumKey);
    
    //_appConfig.device_bgPictureFile=DICT_GET(jsondevice, bgPictureFileKey);
    //_appConfig.device_pictureFile=DICT_GET(jsondevice, pictureFileKey);
    
    //override images
    //if(_appConfig.device_bgPictureFile!=nil && _appConfig.device_bgPictureFile.length>0)
        _appConfig.device_bgPictureFile=[NSString stringWithFormat:@"%@%@.png",PREFIX_MYBGPHOTO,_appConfig.device_id];
    //if(_appConfig.device_pictureFile!=nil && _appConfig.device_pictureFile.length>0)
        _appConfig.device_pictureFile=[NSString stringWithFormat:@"%@%@.png",PREFIX_MYPHOTO,_appConfig.device_id];
    
    
    //download images if needed
    
    //_appDelegate.userInfo.deviceID=_appDelegate.appConfig.device_id;
    
    _appConfig.device_address=DICT_GET(jsondevice, deviceAddressKey);
    _appConfig.device_categoryid=[DICT_GET(jsondevice, categoryIDKey) intValue];
    
    _appConfig.useClientToken=DICT_GET_INT(jsondevice, useClientTokenKey);
    _appConfig.paymentProvider=DICT_GET(jsondevice, providerKey);
    _appConfig.paymentPostUrl=DICT_GET(jsondevice, postUrlKey);
    
    _appConfig.paymentPublishableKey=DICT_GET(jsondevice, publishableKeyKey);
    _appConfig.paymentSecretKey=DICT_GET(jsondevice, secretKeyKey);
    
    _appConfig.paymentPublishableKeyTest=DICT_GET(jsondevice, testPublishableKeyKey);
    _appConfig.paymentSecretKeyTest=DICT_GET(jsondevice, testSecretKeyKey);
    
    _appConfig.paymentSecretKeyTest=DICT_GET(jsondevice, testSecretKeyKey);
    
    _appConfig.enableChat=YES;
    _appConfig.enableChatSound=YES;
    _appConfig.enableOrderSound=YES;
    _appConfig.enablePhotoSharing=YES;
    _appConfig.enableMultiPay=YES;
    /*
    _appConfig.acceptedCards=DICT_GET(jsondevice, @"acceptedcards");
    
    _appConfig.salesTax=DICT_GET_FLOAT(jsondevice, @"salestax");
    
    _appConfig.minChargeAmount=DICT_GET_INT(jsondevice, @"mincharge");
    
    _appConfig.maxChargeAmount=DICT_GET_INT(jsondevice, @"maxcharge");
    
    
    _appConfig.useApplePay=[DICT_GET(jsondevice, @"useapplepay") boolValue];
    
    _appConfig.acceptCCard=[DICT_GET(jsondevice, @"acceptccard") boolValue];
    _appConfig.acceptCash=[DICT_GET(jsondevice, @"acceptcash") boolValue];
    */
    
    
    
    
    
    //}
    
    
    
}

-(void)saveOrUpdateLogonInfoFromWeb:(NSDictionary*) json{
  // bool fistTime=(_appConfig.user_userToken==nil|| _appConfig.user_userToken.length==0)?YES:NO;
    
    _appConfig.user_userToken=[json objectForKey:@"uid"];
    
    
    
    
    [self saveOrUpdateUserInfoFromWeb:[json objectForKey:@"user"]];
    
    _admin=[User new];
    _admin.name=[NSString stringWithFormat:@"%@ %@",_appConfig.user_firstname, _appConfig.user_lastname];
    _admin.userName=_appConfig.user_username;
    _admin.userID=[_appConfig.user_userid integerValue];
    _admin.deviceID=_appConfig.device_id;
    _admin.groupID=GROUPID_ADMINISTRATORS;
    //if(_mcManager!=nil)
        _admin.peerInfo=_mcManager.myPeerInfo;
    
    
    [self saveOrUpdateDeviceInfoFromWeb:[json objectForKey:@"device"]];
    
    _appConfig.currencies=[json objectForKey:@"currencies"];
    
    
    
    [AppConfigModel saveSettings];
    
    [self downloadImagesIfNeeded];
    
    //if(fistTime){
        [self.inventoryModel.inventory pullInventory];
    //}
    
    
}

-(void)downloadImage:(NSString *)filePath urlPath:(NSString *)urlPath{
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
                //[cell.imageView setImage:[UIImage imageWithData:imageData]];
                //cell.imageView.layer.cornerRadius=cell.imageView.frame.size.width / 4;//cell.senderPhoto.frame.size.width / 2;
                //cell.imageView.clipsToBounds = YES;
            }
            //}
        });
    });

}

-(void)downloadImagesIfNeeded{
    //logo
    //NSString *image_logo=[NSString stringWithFormat:@"%@%@.png",PREFIX_MYPHOTO,_appConfig.device_id];
   // if(_appConfig.device_pictureFile!=nil && _appConfig.device_pictureFile.length>0){
     //if(image_logo!=nil && image_logo.length>0){
     BOOL downloadNeeded=NO;
    NSError *error;
    NSFileManager *fm=[NSFileManager defaultManager];
       if(_appConfig.device_pictureFile!=nil && _appConfig.device_pictureFile>0){
        NSString *image_logo=[NSString stringWithFormat:@"%@%@.png",PREFIX_MYPHOTO,_appConfig.device_id];
        NSString *filePath=[[AppDelegate getDocumentsPath] stringByAppendingPathComponent:image_logo];
          
        if(![fm fileExistsAtPath:filePath]){
    
            downloadNeeded=YES;
            
        }
        else{
            
            NSDictionary *fileAttribute=[fm attributesOfItemAtPath:filePath error:&error];
            long filesize= (long)[fileAttribute fileSize];
            if(filesize==0){
                downloadNeeded=YES;
            }
        }
           if(downloadNeeded){
               NSString *urlPath=[NSString stringWithFormat:@"%@%@?deviceID=%@",ServerApiURL,LogoPath,_appConfig.device_id];
               [self downloadImage:filePath urlPath:urlPath];
           }
    }
    //background
    downloadNeeded=NO;
    NSString *image_bground=[NSString stringWithFormat:@"%@%@.png",PREFIX_MYBGPHOTO,_appConfig.device_id];
    if(_appConfig.device_bgPictureFile!=nil && _appConfig.device_bgPictureFile.length>0){
        
        
        NSString *filePath=[[AppDelegate getDocumentsPath] stringByAppendingPathComponent:image_bground];
        if(![[NSFileManager defaultManager] fileExistsAtPath:filePath]){
            
            downloadNeeded=YES;
        }
        else{
            NSDictionary *fileAttribute=[fm attributesOfItemAtPath:filePath error:&error];
            long filesize= (long)[fileAttribute fileSize];
            if(filesize==0){
                downloadNeeded=YES;
            }
        }
        
        if(downloadNeeded){
            NSString *urlPath=[NSString stringWithFormat:@"%@%@?deviceID=%@",ServerApiURL,BackgroundImagePath,_appConfig.device_id];
            [self downloadImage:filePath urlPath:urlPath];
        }
        
    }
}

-(void)saveOrUpdateUserInfoFromWeb:(NSDictionary*) jsonuser{
    //_appConfig.user_userToken
    _appConfig.user_folderid=DICT_GET(jsonuser, @"folderid");
    _appConfig.user_username=DICT_GET(jsonuser, @"username");
    _appConfig.user_userid=DICT_GET(jsonuser, @"userid");
    _appConfig.user_picid=DICT_GET(jsonuser, @"picid");
    
    _appConfig.user_lat=DICT_GET(jsonuser, @"latitude");
    _appConfig.user_lng=DICT_GET(jsonuser, @"longitude");
    
    _appConfig.user_firstname=DICT_GET(jsonuser, @"firstname");
    
    _appConfig.user_lastname=DICT_GET(jsonuser, @"lastname");
    
    _appConfig.user_address=DICT_GET(jsonuser, @"address");
    _appConfig.user_city=DICT_GET(jsonuser, @"city");
    _appConfig.user_state=DICT_GET(jsonuser, @"state");
    _appConfig.user_country=DICT_GET(jsonuser, @"country");
    _appConfig.user_zipcode=DICT_GET(jsonuser, @"zipcode");
    
    _appConfig.user_homenumber=DICT_GET(jsonuser, @"homenumber");
    _appConfig.user_mobilenumber=DICT_GET(jsonuser, @"mobilenumber");
    
    //_appConfig.user_homeUrl =DICT_GET(jsonuser, @"homeurl");
    
    
    // NSError *error;
    
    /*if(![self.nickNameTextField.text isEqualToString:_appDelegate.appConfig.displayName]){
     //[self.config valueForKey:KEY_APP_NIKCNAME];
     //self.nickNameTextField.text=[self.config objectForKey:KEY_APP_NIKCNAME];
     _appDelegate.appConfig.displayName=self.nickNameTextField.text;
     _appDelegate.userInfo.displayName=_appDelegate.appConfig.displayName;
     //_appDelegate.mcManager.myPeerID.displayName=@"";//_appDelegate.appConfig.displayName;
     //[AppConfigModel saveSettings];
     //nicknameChanged=YES;
     
     }
     */
    //self.userInfo.userToken=DICT_GET(jsonuser, @"usertoken");
    /*self.userInfo.userid= DICT_GET(jsonuser, @"userid");//[jsonuser objectForKey:@"userid"];
     self.userInfo.username=DICT_GET(jsonuser, @"username");
     self.userInfo.firstName=DICT_GET(jsonuser, @"firstName");
     self.userInfo.lastName=DICT_GET(jsonuser, @"lastName");
     self.userInfo.nickname=DICT_GET(jsonuser, @"nickname");
     self.userInfo.name=DICT_GET(jsonuser, @"name");
     self.userInfo.lat=DICT_GET(jsonuser, @"lat");
     self.userInfo.lng=DICT_GET(jsonuser, @"lng");
     
     self.userInfo.address=DICT_GET(jsonuser, @"address");
     self.userInfo.city=DICT_GET(jsonuser, @"city");
     self.userInfo.state=DICT_GET(jsonuser, @"state");
     self.userInfo.country=DICT_GET(jsonuser, @"country");
     self.userInfo.zipCode=DICT_GET(jsonuser, @"zipCode");
     
     self.userInfo.homeNumber=DICT_GET(jsonuser, @"homenumber");
     self.userInfo.mobileNumber=DICT_GET(jsonuser, @"mobilenumber");
     
     self.userInfo.dob=[DataModel deserializeJsonDateString:DICT_GET(jsonuser, @"dob")];
     self.userInfo.joined=[DataModel deserializeJsonDateString:DICT_GET(jsonuser, @"joined")];
     self.userInfo.gender=DICT_GET(jsonuser, @"gender");
     self.userInfo.maritalstatus=DICT_GET(jsonuser, @"maritalstatus");
     
     self.userInfo.filehash=DICT_GET(jsonuser, @"filehash");
     
     self.userInfo.fileid=DICT_GET(jsonuser, @"fileid");
     
     self.userInfo.filecontenttype=DICT_GET(jsonuser, @"filecontenttype");
     
     self.userInfo.registerServer=DICT_GET(jsonuser, @"server");
     self.userInfo.registerPort=DICT_GET(jsonuser, @"port");
     self.userInfo.showprvinfo=DICT_GET(jsonuser, @"showprvinfo");;
     
     
     if(self.userInfo.filehash.length>0){
     self.userInfo.fileData=[self fileStoreGetSetDataNonBackGroundOnly:self.userInfo.filehash contentType:self.userInfo.filecontenttype contentLength:self.userInfo.filelen isStream:NO];
     }
     else{
     self.userInfo.fileData=nil;
     }
     
     self.userInfo.loggedIn=@YES;
     
     
     
     
     
     [_context save:&error];
     
     if (error)
     return;
     */
    
}

+ (NSDate *)deserializeJsonDateString: (NSString *)jsonDateString
{
    if(jsonDateString==(id)[NSNull null] || jsonDateString==nil || jsonDateString.length<9)
        return nil;
    // NSLog(@"jsonDateString=%@", jsonDateString);
    /*/Date(67161600000)/
     /Date(1368128341000)/
     */
    NSInteger offset = [[NSTimeZone defaultTimeZone] secondsFromGMT]; //get number of seconds to add or subtract according to the client default time zone
    
    NSInteger startPosition = [jsonDateString rangeOfString:@"("].location + 1; //start of the date value
    NSInteger endPosition = [jsonDateString rangeOfString:@")"].location; //start of the date value
    NSInteger length=endPosition-startPosition;
    NSString *datePart=[jsonDateString substringWithRange:NSMakeRange(startPosition, length)];
    //NSTimeInterval unixTime = [[jsonDateString substringWithRange:NSMakeRange(startPosition, 13)] doubleValue] / 1000; //WCF will send 13 digit-long value for the time interval since 1970 (millisecond precision) whereas iOS works with 10 digit-long values (second precision), hence the divide by 1000
    NSTimeInterval unixTime = [datePart doubleValue]/1000; //WCF will send 13 digit-long value for the time interval since 1970 (millisecond precision) whereas iOS works with 10 digit-long values (second precision), hence the divide by 1000
    
    NSDate* date=[[NSDate dateWithTimeIntervalSince1970:unixTime] dateByAddingTimeInterval:offset];
    
    return date;
}

+ (NSString *)contentTypeForImageData:(NSData *)data {
    uint8_t c;
    [data getBytes:&c length:1];
    
    switch (c) {
        case 0xFF:
            return @"image/jpeg";
        case 0x89:
            return @"image/png";
        case 0x47:
            return @"image/gif";
        case 0x49:
        case 0x4D:
            return @"image/tiff";
    }
    return nil;
}

//+ (CGSize)sizeForText:(NSString*)text
//{
//    
//    UIFont *font = [UIFont systemFontOfSize:[UIFont systemFontSize]];
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
+ (CGSize)sizeForText:(NSString*)text{
    
    bool isIpad=UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad;
    
    UIFont *font;
    
    if(isIpad)
        font=[UIFont systemFontOfSize:FONTSIZE_IPAD];
    else
        font=[UIFont systemFontOfSize:[UIFont systemFontSize]];
    
   
    CGRect textRect = [text boundingRectWithSize:CGSizeMake((isIpad)?482:200, 9999)
                                         options:NSStringDrawingUsesLineFragmentOrigin
                                      attributes:@{NSFontAttributeName:font}
                                         context:nil];
    CGSize textSize =textRect.size;
    
    
    
    
    
    CGSize bubbleSize;
    bubbleSize.width = textSize.width;// + TextLeftMargin + TextRightMargin;
    //if(isIpad)
        bubbleSize.height = textSize.height+30;// + TextTopMargin + TextBottomMargin;
    //else
     //   bubbleSize.height = textSize.height+18;
    
    if(isIpad){
        if (bubbleSize.width < 50)
            bubbleSize.width = 50;
        
        if (bubbleSize.height < 90)
            bubbleSize.height = 90;
    }
    else{
        if (bubbleSize.width < 50)
            bubbleSize.width = 50;
        
        if (bubbleSize.height < 40)
            bubbleSize.height = 40;

    }
    // bubbleSize.width += HorzPadding*2;
    // bubbleSize.height += VertPadding*2;
    
    return bubbleSize;
}
/*
 + (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
 //UIGraphicsBeginImageContext(newSize);
 UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
 [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
 UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
 UIGraphicsEndImageContext();
 return newImage;
 }
 */
/*
 + (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)size
 {
 UIGraphicsBeginImageContextWithOptions(size, NO, 0);
 [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
 UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
 UIGraphicsEndImageContext();
 return newImage;
 }
 */
+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    //UIGraphicsBeginImageContext(newSize);
    // In next line, pass 0.0 to use the current device's pixel scaling factor (and thus account for Retina resolution).
    // Pass 1.0 to force exact pixel size.
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 1.0);
    //UIGraphicsBeginImageContextWithOptions(image.size, NO, [[UIScreen mainScreen] scale]);
   // UIGraphicsBeginImageContextWithOptions(image.size, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

+ (UIImage *)scaleImage:(UIImage *)image toSize:(CGSize)newSize {
    
    float width = newSize.width;
    float height = newSize.height;
    
    UIGraphicsBeginImageContext(newSize);
    CGRect rect = CGRectMake(0, 0, width, height);
    
    float widthRatio = image.size.width / width;
    float heightRatio = image.size.height / height;
    float divisor = widthRatio > heightRatio ? widthRatio : heightRatio;
    
    width = image.size.width / divisor;
    height = image.size.height / divisor;
    
    rect.size.width  = width;
    rect.size.height = height;
    
    //indent in case of width or height difference
    float offset = (width - height) / 2;
    if (offset > 0) {
        rect.origin.y = offset;
    }
    else {
        rect.origin.x = -offset;
    }
    
    [image drawInRect: rect];
    
    UIImage *smallImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return smallImage;
    
}



#ifdef MAGTEK
//magtek
#pragma mark -
#pragma mark MTSCRA Library Method
#pragma mark -

- (MTSCRA *)getSCRALib
{
    return [self mtSCRALib];
}

#pragma mark -
#pragma mark Application lifecycle
#pragma mark -
#endif


#pragma mark web server info

-(NSString *)serverUrl{
    if(_webServerUploader)
        return [[_webServerUploader serverURL] absoluteString];
    else
        return @"OFF-LINE";
}


+(void)toast:(NSString *)message duration:(int)duration{
    //NSString *message=[error localizedDescription];
    UIAlertView *toast=[[UIAlertView alloc] initWithTitle:nil message:message delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
    [toast show];
    //int duration=2;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, duration * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [toast dismissWithClickedButtonIndex:0 animated:YES];
    });
}


-(void)updateBadgeOrders{
    
    /*
    if(BADGEUPDATETYPE_SET){
        
    }
    
    _badgeOrderNumber++;
    */
    //if(self.isIpad){
    //    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_UPDATEBADGE_ORDERS object:nil];
    //}
    //else{
    NSInteger count=0;
        UITabBarController *tabBarController=(UITabBarController*)self.window.rootViewController;
        //this cause hard to find error: [UINavigationController tabBar]: unrecognized selector sent to instance
        UITabBarItem *tbi=(UITabBarItem *)[tabBarController.tabBar.items objectAtIndex:TAB_INDEX_ORDERS];
    if(_historyModel!=nil && _historyModel.filteredHistory!=nil && [_historyModel.filteredHistory objectForKey:@"total"]!=nil){
        
        count=[[_historyModel.filteredHistory valueForKey:@"total"] integerValue];
        if(count==0)
            tbi.badgeValue=nil;
        else
            tbi.badgeValue =[NSString stringWithFormat:@"%lu",(unsigned long)count];
    }
    else{
        tbi.badgeValue=nil;
    }
    [UIApplication sharedApplication].applicationIconBadgeNumber=count;
}

//where val: -1 0 1
-(void)setMessagesBadge:(BOOL)isReset{
    if(![self.window.rootViewController isKindOfClass:[UITabBarController class]]){
        return;
    }
    
        UITabBarController *tabBarController=(UITabBarController*)self.window.rootViewController;
        UITabBarItem *tbi=(UITabBarItem *)[tabBarController.tabBar.items objectAtIndex:TAB_INDEX_CHAT];
    
    
    int badgeValue=[tbi.badgeValue intValue];
    
    badgeValue++;
    
    tbi.badgeValue=[NSString stringWithFormat:@"%lu",(unsigned long)badgeValue];
    /*
    if(badge==1)
        badgeValue++;
    else if(badge==-1)
         badgeValue--;
    else
        badgeValue=0;
    
        if(badgeValue==0)
            tbi.badgeValue=nil;
        else{
            
                
            tbi.badgeValue =[NSString stringWithFormat:@"%lu",(unsigned long)_badgeOrderNumber];
        }
    */
    
       
    
    
    

}

+(UIImage *)loadPhoto:(NSString *)photo{
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
        //image=[UIImage imageNamed:@"empty_picture.png"];
    }
    return image;
    
}

-(void)setBackgroundImage{
    
   //UIImage *bgImage=[AppDelegate loadPhoto:[NSString stringWithFormat:@"%@%@.png",PREFIX_MYBGPHOTO, _appConfig.device_id]];
    /*works but tiles the backgorund
    UIImage *bgImage=[_appConfig loadBackgroundImage];
    if(bgImage!=nil){
        self.window.backgroundColor=[UIColor colorWithPatternImage:bgImage];
    }
    else{
        self.window.backgroundColor=[UIColor clearColor];
    }
     */
    UIImage *bgImage=[_appConfig loadBackgroundImage];
    
    if(bgImage!=nil){
        UIImageView *bgImageView=[[UIImageView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        bgImageView.image=bgImage;
        //self.window.backgroundColor=[UIColor colorWithPatternImage:bgImage];
        [self.window insertSubview:bgImageView atIndex:0];
    }
    else{
        self.window.backgroundColor=[UIColor clearColor];
    }
}

-(void)setBackgroundImageWithData:(NSData *)data{
    
    //UIImage *bgImage=[AppDelegate loadPhoto:[NSString stringWithFormat:@"%@%@.png",PREFIX_MYBGPHOTO, _appConfig.device_id]];
    UIImage *bgImage=[UIImage imageWithData:data];
    if(bgImage!=nil){
        self.window.backgroundColor=[UIColor colorWithPatternImage:bgImage];
    }
    else{
        self.window.backgroundColor=[UIColor clearColor];
    }
}

-(void)addNewMessage:(BroadcastMessageAPI *)message{
    if(self.messages==nil)
        self.messages=[NSMutableArray new];
    
    //if(self.mcManager.serverPeerInfo.maxMessagesPerUser>0){
    if(self.appConfig.maxMessagesPerUser>0){
        
        //NSPredicate *predicate=[NSPredicate predicateWithFormat:@"deviceID==%@",message.deviceID];
        
        NSPredicate *predicate=[NSPredicate predicateWithFormat:@"fromDeviceID==%@",message.fromDeviceID];
        NSArray *existing=[self.messages filteredArrayUsingPredicate:predicate];
        
        if([existing count]>0){//=self.appConfig.userInfo.messageLimitPerUser){
            /* for now just delete everything
             NSSortDescriptor *descriptor=[[NSSortDescriptor alloc] initWithKey:@"createdon" ascending:YES];
             NSArray *sorted=[existing sortedArrayUsingDescriptors:[NSArray arrayWithObject:descriptor]];
             
             for(BroadcastMessageAPI *item in sorted){
             //if([self.peerDevices containsObject:searchPeerInfo]){
             NSInteger indexOfPeer = [self.messages indexOfObject:item];
             //peerInfo=[self.peerDevices objectAtIndex:indexOfPeer];
             
             //}
             [self.messages removeObjectAtIndex:indexOfPeer];
             }
             */
            //for(BroadcastMessageAPI *item in existing){
                
                //NSInteger indexOfPeer = [self.messages indexOfObject:item];
                
            //    [self.messages removeObject:item];
            //}
            [self.messages removeObjectsInArray:existing];
            
        }
    }
    
    [self.messages addObject:message];
    /*
    if(_appConfig.userInfo.isPlaySound){
        AudioServicesPlaySystemSound(1003);
    }
    */
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_UPDATE_MESSAGES object:nil];
}

-(void)removeMessagesFromDevice:(NSString *)fromDeviceID{
    if(self.messages==nil){
        self.messages=[NSMutableArray new];
        
    }
    if([self.messages count]==0){
        
    
        NSPredicate *predicate=[NSPredicate predicateWithFormat:@"fromDeviceID==%@",fromDeviceID];
        NSArray *existing=[self.messages filteredArrayUsingPredicate:predicate];
        
        if([existing count]>0){
            [self.messages removeObjectsInArray:existing];
            
        }
    
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_UPDATE_MESSAGES object:nil];
}

-(void)clearCart{
    CheckoutCart *cart =[CheckoutCart sharedInstance];
    [cart clearCart];
    UITabBarController *tabBarcontroller=(UITabBarController*)self.window.rootViewController;
    UITabBarItem *tbi=(UITabBarItem *)[tabBarcontroller.tabBar.items objectAtIndex:TAB_INDEX_CART];
    tbi.badgeValue=nil;
    
    
}


-(void)showMBProgress:(NSString *)label{
    MBProgressHUD* hud = [MBProgressHUD showHUDAddedTo:self.window.rootViewController.view animated:YES];
    hud.labelText = NSLocalizedString(label, nil);
}

-(void)hideMBProgress{
   
    [MBProgressHUD hideHUDForView: self.window.rootViewController.view animated:YES];


}

-(void)reloadUserGroups{
    if(_users==nil)
        _users=[NSMutableArray new];
    
    if([_users count]==0){
        //if(_admin!=nil)
        [_users addObject:_admin];
        
    }
    
    if(_groups==nil){
        _groups=[NSMutableArray new];
        
    }
    if([_groups count]==0){
        
        UserGroup *grp=[[UserGroup alloc] init];
        grp.name=@"Guests";
        grp.groupID=0;
        grp.users=[NSMutableArray new];
        [_groups addObject:grp];
        
        grp=[[UserGroup alloc] init];
        grp.name=@"Registered";
        grp.groupID=1;
        grp.users=[NSMutableArray new];
        [_groups addObject:grp];
        
        grp=[[UserGroup alloc] init];
        grp.name=@"Administrators";
        grp.groupID=2;
        grp.users=[NSMutableArray new];
        //[grp.users addObject:_admin];
        [_groups addObject:grp];
        
        grp=[[UserGroup alloc] init];
        grp.name=@"Employees";
        grp.groupID=3;
        grp.users=[NSMutableArray new];
        [_groups addObject:grp];
        
        grp=[[UserGroup alloc] init];
        grp.name=@"Friends";
        grp.groupID=4;
        [_groups addObject:grp];
        
        
    }
    
    else{
        
            //int deleted_count=0;
            NSMutableArray *del_groups=[NSMutableArray new];
            for(UserGroup *grp in _groups ){
                if(grp.groupID>100){
                    
                    [del_groups addObject:grp];
                }
            }
            if(del_groups>0){
                [_groups removeObjectsInArray:del_groups];
                
            }
        
    }
    
    //for(NSString *item in peerGroupNames){
    BOOL def_expanded=YES;
    
    if(_users.count>50)
        def_expanded=NO;
    
    NSPredicate *p;
    
    for(UserGroup* g in _groups){
        p=[NSPredicate predicateWithFormat:@"groupID==%@",@(g.groupID)];
        g.users=[[_users filteredArrayUsingPredicate:p] mutableCopy];
        g.expanded=def_expanded;
    }


}

@end


