//
//  AppDelegate.m
//
//
//  Created by Romulo Quidilig.
//  Copyright (c) 2015 Sharecle Inc. All rights reserved.
//


#import "AppDelegate.h"
//#import "GCDWebUploader.h"
//#import "GCDWebHome.h"
//#import "GCDWebServer.h"
//#import "GCDWebServerDataResponse.h"
//#import "GCDWebServerURLEncodedFormRequest.h"
#import "CheckoutCart.h"
#import "OrderMenuViewController.h"
#import "ProductOptionItem.h"
#import "ProductOption.h"
#import "OrderOptionItem.h"
#import "ReachabilityManager.h"
#import <AudioToolbox/AudioToolbox.h>

#import "BroadcastMessageAPI.h"
#import <SystemConfiguration/CaptiveNetwork.h>


#import "defs.h"

//#define TAB_INDEX_CART 3
//#define TAB_INDEX_HISTORY 3
//static NSUInteger TAB_INDEX_INVENTORY=4
//static NSUInteger TAB_INDEX_FILESHARE=5

/*
 int TAB_INDEX_CONNECT;
 int TAB_INDEX_CHAT=1;
 int TAB_INDEX_MENU=2;
 int  TAB_INDEX_CART=3;
 int TAB_INDEX_INVENTORY=4;
 int TAB_INDEX_FILESHARE=5;
 */


@interface AppDelegate ()<UITabBarControllerDelegate>{
    //@interface AppDelegate () {
@private
    
    //   GCDWebServer *_webServer;
    //GCDWebUploader* _webServerUploader;
    // GCDWebHome* _webServerHome;
}
@end

@implementation AppDelegate

+ (NSString*)getImagesPath__
{
    //NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    //NSString* documentsDirectory = paths[0];
    NSError *error;
    BOOL isDirectory=YES;
    
    NSString *directory=[[AppDelegate getDocumentsPath] stringByAppendingPathComponent:@"images"];
    
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

+ (void)clearTmpExceptForServer:(NSString *)deviceID
{
    //bypass for now until we put a config to allow caching
    //return;
    if(deviceID==nil)
        return;
    //NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    //NSString* documentsDirectory = paths[0];
    NSError *error;
    //BOOL isDirectory=YES;
    NSArray *exclude=@[deviceID,@".DS_Store"];
    NSPredicate *p=[NSPredicate predicateWithFormat:@"NOT self IN %@ ",exclude];
    NSFileManager *fm=[NSFileManager defaultManager];
    
    NSString *tmp_directory=[[AppDelegate getDocumentsPath] stringByAppendingPathComponent:@"/tmp"];
    
    //if([fm fileExistsAtPath:tmp_directory isDirectory:YES]
    //if(directory.length>0){
    
    
    NSArray *paths=[[NSFileManager defaultManager] contentsOfDirectoryAtPath:tmp_directory error:&error];
    NSArray *remove_paths=[paths filteredArrayUsingPredicate:p];
    if([remove_paths count]>0){
        NSString *remove_path;
        for (int i=0; i<[remove_paths count]; i++) {
            remove_path=[tmp_directory stringByAppendingPathComponent:remove_paths[i]];
            
            [fm removeItemAtPath:remove_path error:&error];
        }
    }
    
}

+ (void)clearTmpForServer:(NSString *)deviceID
{
    //bypass for now until we put a config to allow caching
    //return;
    if(deviceID==nil)
        return;
    //NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    //NSString* documentsDirectory = paths[0];
    NSError *error;
    //BOOL isDirectory=YES;
    //NSArray *includeClude=@[deviceID,@".DS_Store"];
    NSPredicate *p=[NSPredicate predicateWithFormat:@"self IN %@ ",deviceID];
    NSFileManager *fm=[NSFileManager defaultManager];
    
    NSString *tmp_directory=[[AppDelegate getDocumentsPath] stringByAppendingPathComponent:@"/tmp"];
    
    //if([fm fileExistsAtPath:tmp_directory isDirectory:YES]
    //if(directory.length>0){
    
    
    NSArray *paths=[[NSFileManager defaultManager] contentsOfDirectoryAtPath:tmp_directory error:&error];
    NSArray *remove_paths=[paths filteredArrayUsingPredicate:p];
    if([remove_paths count]>0){
        NSString *remove_path;
        for (int i=0; i<[remove_paths count]; i++) {
            remove_path=[tmp_directory stringByAppendingPathComponent:remove_paths[i]];
            
            [fm removeItemAtPath:remove_path error:&error];
        }
    }
    
}

+ (void)clearTmp
{
    //bypass for now until we put a config to allow caching
    //return;
    //if(deviceID==nil)
    //    return;
    //NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    //NSString* documentsDirectory = paths[0];
    NSError *error;
    //BOOL isDirectory=YES;
    
    //NSArray *exclude=@[deviceID,@".DS_Store"];
    //NSPredicate *p=[NSPredicate predicateWithFormat:@"NOT self IN %@ ",exclude];
    NSFileManager *fm=[NSFileManager defaultManager];
    
    NSString *tmp_directory=[[AppDelegate getDocumentsPath] stringByAppendingPathComponent:@"/tmp"];
    
    //if([fm fileExistsAtPath:tmp_directory isDirectory:YES]
    //if(directory.length>0){
    
    
    NSArray *paths=[[NSFileManager defaultManager] contentsOfDirectoryAtPath:tmp_directory error:&error];
    //NSArray *remove_paths=[paths filteredArrayUsingPredicate:p];
    if([paths count]>0){
        NSString *remove_path;
        for (int i=0; i<[paths count]; i++) {
            remove_path=[tmp_directory stringByAppendingPathComponent:paths[i]];
            
            [fm removeItemAtPath:remove_path error:&error];
        }
    }
    
}


+(NSString *)sizeOfTmpFolder//:(NSString *)folderPath
{
    NSString *tmp_directory=[[AppDelegate getDocumentsPath] stringByAppendingPathComponent:@"/tmp"];
    return [AppDelegate sizeOfFolder:tmp_directory];
}

+(NSString *)sizeOfFolder:(NSString *)folderPath
{
    NSArray *contents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:folderPath error:nil];
    NSEnumerator *contentsEnumurator = [contents objectEnumerator];
    
    NSString *file;
    unsigned long long int folderSize = 0;
    
    while (file = [contentsEnumurator nextObject]) {
        NSDictionary *fileAttributes = [[NSFileManager defaultManager] attributesOfItemAtPath:[folderPath stringByAppendingPathComponent:file] error:nil];
        folderSize += [[fileAttributes objectForKey:NSFileSize] intValue];
    }
    
    //This line will give you formatted size from bytes ....
    NSString *folderSizeStr = [NSByteCountFormatter stringFromByteCount:folderSize countStyle:NSByteCountFormatterCountStyleFile];
    return folderSizeStr;
}

+(NSString *)sizeOfFile:(NSString *)filePath
{
    NSDictionary *fileAttributes = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil];
    NSInteger fileSize = [[fileAttributes objectForKey:NSFileSize] integerValue];
    NSString *fileSizeStr = [NSByteCountFormatter stringFromByteCount:fileSize countStyle:NSByteCountFormatterCountStyleFile];
    return fileSizeStr;
}

+ (NSString*)getImagesPathForServer:(NSString *)deviceID
{
    if(deviceID==nil)
        return nil;
    //NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    //NSString* documentsDirectory = paths[0];
    NSError *error=nil;
    //BOOL isDirectory=YES;
    
    NSString *directory=[[AppDelegate getDocumentsPath] stringByAppendingPathComponent:[@"/tmp/" stringByAppendingString:deviceID]];
    
    ///Users/ksheehy965/Library/Developer/CoreSimulator/Devices/D6B54954-315C-4513-BF0E-32135193D95B/data/Containers/Data/Application/3ED5C2A6-EFF1-4D70-A59E-A23803D95031/Documents/temp/05e36e88-ad38-4981-b8ad-b058f7387412
#ifdef DEBUG
    NSLog(@"directory=%@",directory);
#endif
    /*
    if([[NSFileManager defaultManager] fileExistsAtPath:directory]==NO){
        [[NSFileManager defaultManager] createDirectoryAtPath:directory withIntermediateDirectories:NO attributes:nil error:&error];
    }
    
    if(![[NSFileManager defaultManager] fileExistsAtPath:directory isDirectory:&isDirectory])
        [[NSFileManager defaultManager] createDirectoryAtPath:directory withIntermediateDirectories:YES attributes:nil error:&error];
    */
    if([[NSFileManager defaultManager] fileExistsAtPath:directory]==NO){
        [[NSFileManager defaultManager] createDirectoryAtPath:directory withIntermediateDirectories:YES attributes:nil error:&error];
    }
    
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
    
    NSString *directory=[[AppDelegate getDocumentsPath] stringByAppendingPathComponent:@"shared"];
    
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
/*
 -(void)CreateOrderFromServer:(NSString *)withOrderDetail orderBy:(NSString *)orderBy orderStatus:(NSNumber *) orderStatus {
 NSDateFormatter *dateFormatter=[[NSDateFormatter alloc ]init];
 [dateFormatter setDateFormat:@"yyyy-MM-dd"];
 NSString *today=[dateFormatter stringFromDate:[NSDate date]];
 
 OrderHistory *newOrder=[[OrderHistory alloc] init];
 //newOrder.orderDetailText=withOrderDetail;
 newOrder.orderBy=orderBy;
 newOrder.orderDateTime=[NSDate date];
 newOrder.orderDate=[dateFormatter dateFromString:today];
 
 newOrder.orderStatus=@ORDER_STATUS_RECEIVED;
 
 NSMutableArray *orders=[_historyModel.history valueForKey:today];
 if(orders==nil)
 orders=[NSMutableArray new];
 
 _lastOrderNumber++;
 
 newOrder.orderNumber=[NSNumber numberWithUnsignedInteger:_lastOrderNumber];//[NSNumber numberWithUnsignedInteger:[orders count]+1];
 
 //[orders addObject:newOrder];
 
 [_historyModel addOrUpdateOrderHistory:newOrder];
 
 _badgeOrderNumber++;
 
 UITabBarController *tabBarController=(UITabBarController*)self.window.rootViewController;
 UITabBarItem *tbi=(UITabBarItem *)[tabBarController.tabBar.items objectAtIndex:TAB_INDEX_MENU];
 
 
 tbi.badgeValue =[NSString stringWithFormat:@"%lu",(unsigned long)_badgeOrderNumber];
 }
 */
//+(NSDictionary *)charge:(NSString *)stripeAmount stripeCurrency:(NSString *)stripeCurrency stripeToken:(NSString *)stripeToken stripeDescription:(NSString *)stripeDescription{*/

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //#ifdef DEBUG
    //    NSLog(@"application didFinishLaunchingWithOptions");
    //#endif
    //if (StripePublishableKey) {
    //[Stripe setDefaultPublishableKey:STRIPE_TEST_PUBLIC_KEY];
    
    //}
    // Override point for customization after application
    /*self.TAB_INDEX_CONNECT=0; //this will not be use on iphone
    self.TAB_INDEX_CHAT=1;
     */
    
    /*
     You can set a NSLocale on the NSNumberFormatter, the formatter will automatically behave according to that locale. The default locale for a number formatter is always the currency for the users selected region format.
     
     NSDecimalNumber *someAmount = [NSDecimalNumber decimalNumberWithString:@"5.00"];
     
     NSNumberFormatter *currencyFormatter = [[NSNumberFormatter alloc] init];
     [currencyFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
     
     NSLog(@"%@", [currencyFormatter stringFromNumber:someAmount]);
     This will log the amount '5.00' according to the users default region format. If you want to alter the currency you can set:
     
     NSLocale *aLocale = [[NSLocale alloc] initWithLocaleIdentifier: "nl-NL"]
     [currencyFormatter setLocale:aLocale];
     Which will choose the default currency for that locale.
     
     Often though you're not charging in your user's local currency, but in your own. To force NSNumberFormatter to format in your currency, while keeping the number formatting in the user's preference, use:
     
     currencyFormatter.currencyCode = @"USD"
     currencyFormatter.internationalCurrencySymbol = @"$"
     currencyFormatter.currencySymbol = @"$"
     In en-US this will format as $5.00 in nl-NL it's $ 5,00.
     */
    //NSLocale *locale=[[NSLocale alloc] initWithLocaleIdentifier:@"ja_JP"];
    
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        self.isIpad=YES;
        _storyBoard=[UIStoryboard storyboardWithName:@"Main_iPad" bundle:nil];
        /*
        self.TAB_INDEX_MENU=2; //this will not be use on iphone
        self.TAB_INDEX_CART=3;
        
        self.TAB_INDEX_INVENTORY=4;
        self.TAB_INDEX_FILESHARE=5;
        */
        /*self.window.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"common_bg.png"]];
        [[UILabel appearance] setFont:[UIFont systemFontOfSize:20]];
        [[UITextField appearance] setFont:[UIFont systemFontOfSize:20]];
         */
        [[UILabel appearance] setFont:[UIFont systemFontOfSize:FONTSIZE_IPAD]];
        [[UITextField appearance] setFont:[UIFont systemFontOfSize:FONTSIZE_IPAD]];
    }
    else {
        self.isIpad=NO;
        _storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        
        
        /*
        self.TAB_INDEX_MENU=2; //this will not be use on iphone
        self.TAB_INDEX_CART=2;
        
        self.TAB_INDEX_INVENTORY=3;
        self.TAB_INDEX_FILESHARE=4;
        */
        
        //self.window.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"common_bg@2x.png"]];
        [[UILabel appearance] setFont:[UIFont systemFontOfSize:FONTSIZE_IPHONE]];
        [[UITextField appearance] setFont:[UIFont systemFontOfSize:FONTSIZE_IPHONE]];
    }
    
    self.window.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"background"]];
    
    _reachabilityManager=[ReachabilityManager sharedInstance];
    _connectionManager=[ConnectionManager sharedInstance];
    
    [self loadSettings];
    
    //messaging
    /*self.messagesModel=[MessagesModel sharedInstance];
    [_messagesModel loadMessages];
    _messages=_messagesModel.messages;
    */
    //dispaly badge
    /*
    NSInteger count=[self.historyModel countReadyOrders];
    
    
    UITabBarController *tabBarcontroller=(UITabBarController*)self.window.rootViewController;
    UITabBarItem *tbi=(UITabBarItem *)[tabBarcontroller.tabBar.items objectAtIndex:TAB_INDEX_CHAT];
    
    if(count==0)
        tbi.badgeValue=nil;
    else
        tbi.badgeValue=[NSString stringWithFormat:@"%ld",(long)count];
    
    
    [UIApplication sharedApplication].applicationIconBadgeNumber=count;
    */
    
    
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
    
    [AppConfigModel loadSettings];
    
    self.appConfig=[AppConfigModel sharedInstance];
    
    if(_appConfig.userInfo==nil){
        _appConfig.userInfo=[[UserInfo alloc] init];
        //_userInfo.userToken=[[[NSUUID UUID] UUIDString] lowercaseString];
        // _appConfig.userInfo.deviceID=[[[[UIDevice currentDevice] identifierForVendor]  UUIDString] lowercaseString];
        
        _appConfig.userInfo.deviceToken=@"";
        
        _appConfig.userInfo.fullName=[[UIDevice currentDevice] name];
        
        if(!_appConfig.userInfo.fullName || _appConfig.userInfo.fullName.length==0)
            _appConfig.userInfo.fullName=@"Unknown";
        
        NSError *error;
        NSRegularExpression *regex=[[NSRegularExpression alloc] initWithPattern:@" +" options:NSRegularExpressionCaseInsensitive error:&error];
        NSString *trimmedString=[regex stringByReplacingMatchesInString:_appConfig.userInfo.fullName options:0 range:NSMakeRange(0, [_appConfig.userInfo.fullName length]) withTemplate:@" "];
        _appConfig.userInfo.fullName=trimmedString;
        
        _appConfig.userInfo.displayName=[UserInfo getDisplayName:_appConfig.userInfo.fullName];//[[UIDevice currentDevice] name];
        NSString *lower=[_appConfig.userInfo.displayName lowercaseString];
        
        if([lower isEqualToString:@"manager"] || [lower isEqualToString:@"owner"] || [lower isEqualToString:@"staff"] || [lower isEqualToString:@"cashier"] || [lower isEqualToString:@"register"] || [lower isEqualToString:@"waiter"] || [lower isEqualToString:@"waitress"] || [lower isEqualToString:@"bartender"] || [lower isEqualToString:@"police"] || [lower isEqualToString:@"ceo"] || [lower isEqualToString:@"president"]){
            _appConfig.userInfo.displayName=@"Unknown";
        }
        
        _appConfig.userInfo.ccards=[NSMutableArray new];
    }
    
    //05e36e88-ad38-4981-b8ad-b058f7387412
    //for security reason we can only set deviceid on this spot
    _appConfig.userInfo.deviceID=[[[[UIDevice currentDevice] identifierForVendor]  UUIDString] lowercaseString];
    
    
    
#ifdef DEBUG
    NSLog(@"deviceID=%@",_appConfig.userInfo.deviceID);
    
#endif
    
    _appConfig.isLive=YES;
    
    
    //self.messages=[NSMutableArray new];
    // self.bmessages=[NSMutableArray new];
    
    // NSString* documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    
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
    /*
     _webServerUploader = [[GCDWebUploader alloc] initWithUploadDirectory:[AppDelegate getDocumentsPath]];
     _webServerUploader.delegate = self;
     _webServerUploader.allowHiddenItems = YES;
     [_webServerUploader startWithPort:8081 bonjourName:nil];
     
     _webServerHome = [[GCDWebHome alloc] initWithUploadDirectory:[AppDelegate getDocumentsPath]];
     _webServerHome.delegate = self;
     _webServerHome.allowHiddenItems = YES;
     [_webServerHome startWithPort:8080 bonjourName:nil];
     */
    
    //test only
    
    //load credit card
    /*
     if(_appConfig.userInfo.ccard==nil){
     _appConfig.userInfo.ccard=[CCardInfo new];
     if([_appConfig.userInfo.ccards count]>0){
     
     NSDictionary *ccard_default=[_appConfig.userInfo.ccards firstObject];
     
     
     _appConfig.userInfo.ccard.ccExpMonth=[ccard_default valueForKey:KEY_CCEXPMONTH];
     _appConfig.userInfo.ccard.ccExpYear=[ccard_default valueForKey:KEY_CCEXPYEAR];
     _appConfig.userInfo.ccard.ccName=[ccard_default valueForKey:KEY_CCNAME];
     _appConfig.userInfo.ccard.ccEmail= [ccard_default valueForKey:KEY_CCEMAIL];
     _appConfig.userInfo.ccard.ccNumber= [ccard_default valueForKey:KEY_CCNUMBER];
     _appConfig.userInfo.ccard.ccCVV= [ccard_default valueForKey:KEY_CCCVV];
     }
     
     }
     
     if(!_appConfig.userInfo.ccard.ccExpMonth)
     _appConfig.userInfo.ccard.ccExpMonth=@1;
     
     if(!_appConfig.userInfo.ccard.ccExpYear){
     NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
     [dateFormatter setDateFormat:@"yyyy"];
     NSInteger currentYear = [[dateFormatter stringFromDate:[NSDate date]] integerValue];
     _appConfig.userInfo.ccard.ccExpYear=[NSNumber numberWithInteger:currentYear+1];
     
     }
     
     #ifdef DEBUG
     if(_appConfig.userInfo.ccard.ccName.length==0)
     _appConfig.userInfo.ccard.ccName=@"Rom TheGreat";
     if(_appConfig.userInfo.ccard.ccEmail.length==0)
     _appConfig.userInfo.ccard.ccEmail=@"rquidilig@gmail.com";
     if(_appConfig.userInfo.ccard.ccNumber.length==0)
     _appConfig.userInfo.ccard.ccNumber=@"4242424242424242";
     if(_appConfig.userInfo.ccard.ccCVV.length==0)
     _appConfig.userInfo.ccard.ccCVV=@"123";
     
     //_appDelegate.userInfo.ccExpMonth=@1;
     
     #endif
     */
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
    
    _appConfig.userInfo.photo=[UIImage imageNamed:@"myphoto.png"];
    if(!_appConfig.userInfo.photo)
        _appConfig.userInfo.photo=[UIImage imageNamed:@"empty"];
    
    //_appConfig.userInfo.homeUrl=[NSString stringWithFormat:@"%@",_webServerHome.serverURL];
    
    self.historyModel=[HistoryModel sharedInstance];
    
    _mcManager = [[MCManager alloc] init];
    
    
    //set client or server
    
    
    
    
    _mcManager.isAutoConnect=NO;
    //self.historyModel.isServer=NO;
    
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
    if([application applicationIconBadgeNumber]>0){
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    }
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
    self.appConfig.userInfo.deviceToken=newToken;
    /*
     dataModel.userInfo.devicetoken=newToken;
     dataModel.deviceToken=newToken;
     [_dataModel.context save:nil];
     
     if (dataModel.userInfo.loggedIn)
     {
     [dataModel postRegisterDevice:NO];
     }*/
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
#ifdef DEBUG
    NSLog(@"Failed to get token, error: %@.", error);
#endif
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
    
}

- (void)addMessageFromRemoteNotification:(NSDictionary*)userInfo updateUI:(BOOL)updateUI
{
    
    /*
     UITabBarController *tabBarcontroller=(UITabBarController*)self.window.rootViewController;
     
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
    
    /*
     NSDictionary *dict_order = [userInfo valueForKey:@"order"];
    if(dict_order==nil)
        return;
    */
    NSArray *order_info= [userInfo valueForKey:@"orderinfo"];
    
    if(order_info==nil || [order_info count]!=4)
        return;
    
    NSString *m_orderStoreNum=[order_info objectAtIndex:0];//DICT_GET(dict_order, @"storenum");
    //if (m_orderStoreNum==nil)
     //   return;
    if(self.historyModel==nil)
        self.historyModel=[HistoryModel sharedInstance];
    if(self.historyModel==nil)
        return;
    
    StoreHistory *store=[self.historyModel storeWithStoreNum:[m_orderStoreNum integerValue]];
    if(store==nil)
        return;
    
    NSString *m_orderId=[order_info objectAtIndex:1];
    
    //NSString *m_orderNumber=[order_info objectAtIndex:1];//DICT_GET(dict_order, @"ordernum");
    //if (m_orderNumber==nil)
     //   return;
    
    NSString *m_orderStatus=[order_info objectAtIndex:2];//DICT_GET(dict_order, @"orderstatus");    if (m_orderStatus==nil)
       // return;
    
    NSString *orderDt=[order_info objectAtIndex:3];//DICT_GET(dict_order, @"orderdt");
   // if (orderDt==nil)
     //   return;
    
    
    unsigned intInterval=[orderDt intValue];
    
    
    /*
    
    NSString *pat=[NSString stringWithFormat:@"Your Order# ([\\d]+) is (%@|%@|%@). Ref# ([\\d]+)-(.+)",ORDER_STATUS_READY_LABEL,ORDER_STATUS_CANC_LABEL,ORDER_STATUS_CLOSED_LABEL];
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pat options:0 error:NULL];
    
    NSTextCheckingResult *match = [regex firstMatchInString:alertValue options:0 range:NSMakeRange(0, [alertValue length])];
    if(match!=nil){
    
        NSString *m_orderNumber=[alertValue substringWithRange:[match rangeAtIndex:1]];
        NSString *m_orderStatus=[alertValue substringWithRange:[match rangeAtIndex:2]];
        
    
        NSString *m_orderStoreNum=[alertValue substringWithRange:[match rangeAtIndex:3]];
        NSString *hexInterval=[alertValue substringWithRange:[match rangeAtIndex:4]];
        
    
        unsigned intInterval;
        NSScanner *scanner = [NSScanner scannerWithString:hexInterval];
        [scanner scanHexInt:&intInterval];
        */
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:intInterval];
        
#ifdef DEBUG
        NSLog(@"%@ %@ %@ %@",m_orderId,m_orderStatus,m_orderStoreNum,date);
#endif
        NSNumber *orderStatus=[NSNumber numberWithInteger:[m_orderStatus integerValue]];//@0;
       /* if([m_orderStatus isEqualToString:ORDER_STATUS_READY_LABEL])
            orderStatus=@ORDER_STATUS_READY;
        else if([m_orderStatus isEqualToString:ORDER_STATUS_CANC_LABEL])
            orderStatus=@ORDER_STATUS_CANC;
        else if([m_orderStatus isEqualToString:ORDER_STATUS_CLOSED_LABEL])
            orderStatus=@ORDER_STATUS_CLOSED;
        */
        
        NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
        //[dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss zzz"];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        
        //OrderHistory *oh=[self.historyModel searchOrderWithOrderNum:[m_orderNumber integerValue] andStoreNum:[m_orderStoreNum integerValue] andOrderDateTime:date];
    OrderHistory *oh=[self.historyModel searchOrderWithOrderId:m_orderId andStoreNum:[NSNumber numberWithInteger:[m_orderStoreNum integerValue]] andOrderDateTime:nil];
    //OrderHistory *oh=[_historyModel searchOrderWithOrderID:searchOrderWithOrderId:m_orderId andStoreId:_appDelegate.selectedStore.peerInfo.deviceID];
    
        if(oh!=nil){
            //UITabBarController *tabBarcontroller=(UITabBarController*)self.window.rootViewController;
            
            
            if([orderStatus integerValue]!=0){
                if([oh.orderStatus integerValue]!=[orderStatus integerValue]){
                    oh.orderStatus=orderStatus;
                    [self.historyModel saveHistory];
                    /*this doesn work here
                    NSInteger count=[self.historyModel countReadyOrders];
                     
                    UITabBarItem *tbiOrders=(UITabBarItem *)[tabBarcontroller.tabBar.items objectAtIndex:TAB_INDEX_INVENTORY];
                    
                    if(count==0)
                        tbiOrders.badgeValue=nil;
                    else
                        tbiOrders.badgeValue=[NSString stringWithFormat:@"%ld",(long)count];
                    */
                    //[UIApplication sharedApplication].applicationIconBadgeNumber=count;
                    
                    
                    /*UITabBarController *tabBarcontroller=(UITabBarController*)self.window.rootViewController;
                     
                     UITabBarItem *tbi=(UITabBarItem *)[tabBarcontroller.tabBar.items objectAtIndex:TAB_INDEX_INVENTORY];
                     
                     int badgeOrderStatus=[tbi.badgeValue intValue];
                     
                     if([orderStatus integerValue]==ORDER_STATUS_READY){
                     
                     
                     //badgeOrderStatus++;
                     [UIApplication sharedApplication].applicationIconBadgeNumber=badgeValue;
                     
                     
                     }
                     else{
                     badgeOrderStatus--;
                     
                     }
                     if (badgeOrderStatus<=0) {
                     tbi.badgeValue=nil;
                     }
                     else{
                     tbi.badgeValue=[NSString stringWithFormat:@"%lu",(unsigned long)badgeOrderStatus];
                     }
                     */
                    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_UPDATE_HISTORY object:nil];
                    
                    
                }
                
            }
            BroadcastMessageAPI *message=[[BroadcastMessageAPI alloc] init];
            
            message.text=alertValue;
            message.fromDeviceID=oh.orderStoreID;
            message.isRemoteNotification=YES;
            message.isServer=YES;
            message.sender=oh.orderStoreName;
            message.createdon=[NSDate date];
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
            
            //[self addNewMessage:message];
            [store addNewMessage:message];
            //we need to save here so that when the app awakes we can show the message;
            
            //[_messagesModel saveMessages];
            [_historyModel saveHistory];
            
            NSInteger count=[store.messages count];

            /*this will not work bec view is not available
            UITabBarItem *tbiMessages=(UITabBarItem *)[tabBarcontroller.tabBar.items objectAtIndex:TAB_INDEX_CHAT];
                        if(count==0)
                tbiMessages.badgeValue=nil;
            else
                tbiMessages.badgeValue=[NSString stringWithFormat:@"%ld",(long)count];
            */
            NSInteger currentBadgeNum=[UIApplication sharedApplication].applicationIconBadgeNumber;
            [UIApplication sharedApplication].applicationIconBadgeNumber=currentBadgeNum+count;
            
            /*if(self.messages==nil)
             self.messages=[NSMutableArray new];
             
             [self.messages addObject:message];
             [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_UPDATE_MESSAGES object:nil];
             */
        }
        
        
        
        
    //}
    
    //[[NSNotificationCenter defaultCenter] postNotificationName:REMOTE_NOTIFY_RECEIVED object:@{@"message":alertValue}];
    //NSNumber* channelValue = [[userInfo valueForKey:@"aps"] valueForKey:@"alert"];
    
    
    
    
    /*
     
     navigationController = [[tabBarcontroller viewControllers] objectAtIndex:0];
     ConnectionsViewController *messageViewController =[[navigationController viewControllers] objectAtIndex:1 ];
     [FirstViewController  updateMessages];
     */
    
    
    
    
}

+(void)ShowErrorAlert:(NSString *)message
{
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Error" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
}

+ (CGRect) maximumUsableFrame:(UIViewController *)viewController {
    
    static CGFloat const kNavigationBarPortraitHeight = 44;
    static CGFloat const kNavigationBarLandscapeHeight = 34;
    static CGFloat const kToolBarHeight = 49;
    
    // Start with the screen size minus the status bar if present
    CGRect maxFrame = [UIScreen mainScreen].applicationFrame;
    
    // If the orientation is landscape left or landscape right then swap the width and height
    if (UIInterfaceOrientationIsLandscape(viewController.interfaceOrientation)) {
        CGFloat temp = maxFrame.size.height;
        maxFrame.size.height = maxFrame.size.width;
        maxFrame.size.width = temp;
    }
    
    // Take into account if there is a navigation bar present and visible (note that if the NavigationBar may
    // not be visible at this stage in the view controller's lifecycle.  If the NavigationBar is shown/hidden
    // in the loadView then this provides an accurate result.  If the NavigationBar is shown/hidden using the
    // navigationController:willShowViewController: delegate method then this will not be accurate until the
    // viewDidAppear method is called.
    if (viewController.navigationController) {
        if (viewController.navigationController.navigationBarHidden == NO) {
            
            // Depending upon the orientation reduce the height accordingly
            if (UIInterfaceOrientationIsLandscape(viewController.interfaceOrientation)) {
                maxFrame.size.height -= kNavigationBarLandscapeHeight;
            }
            else {
                maxFrame.size.height -= kNavigationBarPortraitHeight;
            }
        }
    }
    
    // Take into account if there is a toolbar present and visible
    if (viewController.tabBarController) {
        if (!viewController.tabBarController.view.hidden) maxFrame.size.height -= kToolBarHeight;
    }
    return maxFrame;
}

+(NSString *)toJsonString:(NSDictionary *) dictionary{
    NSError *error;
    NSData *jsonData=[NSJSONSerialization dataWithJSONObject:dictionary options:NSJSONWritingPrettyPrinted error:&error];
    
    if(error)
        nil;
    
    NSString *json_text=[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return json_text;
}

+(NSDictionary *)fromJsonString:(NSString *) string{
    NSData *data=[string dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    if(error)
        return nil;
    return dict;
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

+(void)alert:(NSString *)message{
    //NSString *message=[error localizedDescription];
    UIAlertView *alertt=[[UIAlertView alloc] initWithTitle:nil message:message delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
    [alertt show];
    
}


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
 -(void)removeLastMessage:(NSString *)fromDeviceID{
 //return;
 NSPredicate *predicate=[NSPredicate predicateWithFormat:@"fromDeviceID==%@",fromDeviceID];
 NSArray *existing=[self.messages filteredArrayUsingPredicate:predicate];
 if([existing count]>0){
 for(BroadcastMessageAPI *item in existing){
 //if([self.peerDevices containsObject:searchPeerInfo]){
 NSInteger index = [self.messages indexOfObject:item];
 //peerInfo=[self.peerDevices objectAtIndex:indexOfPeer];
 
 //}
 [self.messages removeObjectAtIndex:index];
 }
 }
 }
 */
-(void)removeMessagesFromDeviceID:(NSString *)deviceID{
    //return;
    StoreHistory *store=[_historyModel storeWithStoreID:deviceID];
    if(store==nil)
        return;
    /*
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"fromDeviceID==%@",deviceID];
    NSArray *existing=[self.messages filteredArrayUsingPredicate:predicate];
    if([existing count]>0){
        for(BroadcastMessageAPI *item in existing){
            //if([self.peerDevices containsObject:searchPeerInfo]){
            NSInteger index = [self.messages indexOfObject:item];
            //peerInfo=[self.peerDevices objectAtIndex:indexOfPeer];
            
            //}
            [self.messages removeObjectAtIndex:index];
        }
    }
     */
    [store.messages removeAllObjects];
    
}

+(NSString *)currentWifiSSID{
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
    // NSLog(@"Connected at:%@",myDict);
    //#endif
    if(myDictionary!=nil)
        
        return [NSString stringWithFormat:@"%@ %@ %@",DICT_GET(myDictionary, @"SSID"),DICT_GET(myDictionary,@"BSSID"),DICT_GET(myDictionary, @"SSIDDATA")];
    
    else
        return @"";
    
    /*
     Connected at:{
     BSSID = 0;
     SSID = "Eqra'aOrange";
     SSIDDATA = <45717261 27614f72 616e6765>;
     }
     */
}




//-(void)addNewMessage:(BroadcastMessageAPI *)message{
//    if(self.messages==nil){
//        _messagesModel=[MessagesModel sharedInstance];
//        [_messagesModel loadMessages];
//        // self.messages=[NSMutableArray new];
//    }
//    
//    //if(self.mcManager.serverPeerInfo.maxMessagesPerUser>0){
//    if(self.appConfig.userInfo.messageLimitPerUser>0){
//        
//        //NSPredicate *predicate=[NSPredicate predicateWithFormat:@"deviceID==%@",message.deviceID];
//        
//        NSPredicate *predicate=[NSPredicate predicateWithFormat:@"fromDeviceID==%@",message.fromDeviceID];
//        NSArray *existing=[self.messages filteredArrayUsingPredicate:predicate];
//        
//        if([existing count]>0){//=self.appConfig.userInfo.messageLimitPerUser){
//            /* for now just delete everything
//             NSSortDescriptor *descriptor=[[NSSortDescriptor alloc] initWithKey:@"createdon" ascending:YES];
//             NSArray *sorted=[existing sortedArrayUsingDescriptors:[NSArray arrayWithObject:descriptor]];
//             
//             for(BroadcastMessageAPI *item in sorted){
//             //if([self.peerDevices containsObject:searchPeerInfo]){
//             NSInteger indexOfPeer = [self.messages indexOfObject:item];
//             //peerInfo=[self.peerDevices objectAtIndex:indexOfPeer];
//             
//             //}
//             [self.messages removeObjectAtIndex:indexOfPeer];
//             }
//             */
//            for(BroadcastMessageAPI *item in existing){
//                
//                //NSInteger indexOfPeer = [self.messages indexOfObject:item];
//                
//                [self.messages removeObject:item];
//            }
//            
//        }
//    }
//    
//    [self.messages addObject:message];
//    
//    if(_appConfig.userInfo.isPlaySound){
//        AudioServicesPlaySystemSound(1003);
//    }
//    
//    NSInteger count=[_messages count];
//    /*TODO
//     UITabBarController *tabBarcontroller=(UITabBarController*)self.window.rootViewController;
//     ;
//     UITabBarItem *tbiMessages=(UITabBarItem *)[tabBarcontroller.tabBar.items objectAtIndex:TAB_INDEX_CHAT];
//     if(count==0)
//     tbiMessages.badgeValue=nil;
//     else
//     tbiMessages.badgeValue=[NSString stringWithFormat:@"%ld",(long)count];
//     
//     [UIApplication sharedApplication].applicationIconBadgeNumber=count;
//     */
//    
//    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_UPDATE_MESSAGES object:nil];
//}
//

+ (NSString *)cardtype:(STPCardBrand)brand {
    switch (brand) {
        case STPCardBrandAmex:
            return @"American Express";
        case STPCardBrandDinersClub:
            return @"Diners Club";
        case STPCardBrandDiscover:
            return @"Discover";
        case STPCardBrandJCB:
            return @"JCB";
        case STPCardBrandMasterCard:
            return @"MasterCard";
        case STPCardBrandVisa:
            return @"Visa";
        default:
            return @"Unknown";
    }
}
/*
-(BOOL)isConnectedToStore:(NSString *)storeID{
    if(_mcManager.serverPeerInfo!=nil && [_mcManager.serverPeerInfo.deviceID isEqualToString:storeID] &&  _mcManager.serverPeerInfo.sessionState==MCSessionStateConnected){
        
        return YES;
    }
    else{
        return NO;
    }
}
*/
#pragma mark -Global Cart functions
-(void)clearCart{
    //CheckoutCart *cart =[CheckoutCart sharedInstance];
    [self.selectedStore.cart clearCart];
    /*
    UITabBarController *tabBarcontroller=(UITabBarController*)self.window.rootViewController;
    UITabBarItem *tbi=(UITabBarItem *)[tabBarcontroller.tabBar.items objectAtIndex:TAB_INDEX_CART];
    tbi.badgeValue=nil;
     */
    [self.historyModel saveHistory];
    
}
-(void)addToCart:(OrderItem *) orderItem product:(Product *)product{
    //NSNumberFormatter *nf=[[NSNumberFormatter alloc] init];
    
    //NSString *deviceID=[self.inventory valueForKey:deviceIDKey];
   // NSString *deviceID=self.selectedStore.storeId;//peerInfo.deviceID;
    
    if(_selectedStore.deviceID==nil)
        return;
    
    
    orderItem.storeID=_selectedStore.deviceID; //(deviceID==nil)?@"":deviceID;
    
    /*self.notesText.text=[self.notesText.text stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" "]];
    
    self.notesText.text=[self.notesText.text stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"\n"]];
    
    orderItem.notes=([self.notesText.text isEqualToString:PlaceHolderText])?@"":self.notesText.text;
     
    //item
    if(![nf numberFromString:self.quantityText.text]){
        _quantityText.text=nil;
        return;
        //orderItem.quantity=self.selectedProduct.minQuantity;
    }
    else{
        NSInteger quantity=[self.quantityText.text integerValue];
        if(quantity>0)
            orderItem.quantity=[self.quantityText.text integerValue];
        else
            return;
    }
    */
    
    /*if(orderItem.quantity<1)
    {
        orderItem.quantity=product.minQuantity;
        //[AppDelegate toast:@"Please enter quantity." duration:2.0];
        //return;
    }
    */
    if(product.minQuantity>0 && orderItem.quantity<product.minQuantity){
        orderItem.quantity=product.minQuantity;
        [AppDelegate toast:@"Quantity has changed to minimum allowed." duration:2.0];
    }
    if(product.maxQuantity>0 && orderItem.quantity>product.maxQuantity){
        orderItem.quantity=product.maxQuantity;
        [AppDelegate toast:@"Quantity has changed to maximum allowed." duration:2.0];
    }
    
    if(orderItem.quantity==0)
        orderItem.quantity=1;
    
    if(product.options==nil)
        product.options=[NSMutableArray new];
    
    if(orderItem.options==nil)
        orderItem.options=[NSMutableArray new];
    
    if([product.options count]>0){
        for(ProductOption *po in  product.options){
            for(ProductOptionItem *poi in po.selections){
                if(poi.selected){
                OrderOptionItem *ooi=[[OrderOptionItem alloc] initWithOptionItem:poi];
                [orderItem.options addObject:ooi];
                }
            }
        }
    }
        
    
    
    
    //CheckoutCart *checkoutCart=[CheckoutCart sharedInstance];
    
    //_appDelegate.selectedStore.cart.currentStoreID=self.selectedStore.peerInfo.deviceID;
    [self.selectedStore.cart addItem:orderItem isLive:self.appConfig.isLive];// withQuantity:[self.quantityText.text integerValue]];
    //self.addToCartButton.selected = YES;
    [self.historyModel saveHistory];
    
    
}

-(void)updateCartBadge:(UITabBarController *) tabBarController{
    UITabBarItem *tbi=(UITabBarItem *)[tabBarController.tabBar.items objectAtIndex:TAB_INDEX_CART];
    if([self.selectedStore.cart.itemsArray count]==0)
        tbi.badgeValue=nil;
    else
        tbi.badgeValue=[NSString stringWithFormat:@"%lu",(unsigned long)[self.selectedStore.cart.itemsArray count]];
}


-(void)loadBgPhoto{
    
    
    NSString *peer_bgphoto=[NSString stringWithFormat:@"%@%@.png",PREFIX_MYBGPHOTO, self.selectedStore.peerInfo.deviceID];
    
    
    
    NSString *filePath=[[AppDelegate getImagesPathForServer:self.selectedStore.peerInfo.deviceID] stringByAppendingPathComponent:peer_bgphoto];
    
    
    
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
            
            //dispatch_async(dispatch_get_main_queue(), ^{
                
                //if(self.wallImage){
                //[self.wallImage setImage:[UIImage imageWithData:imageData]];
                //imageView.layer.cornerRadius=imageView.frame.size.width / 2;
                //imageView.clipsToBounds = YES;
                //}
            //});
            self.window.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageWithData:imageData]];
        });
    }
}

-(BOOL)isConnected{
    if(_selectedStore.peerInfo!=nil && _selectedStore.peerInfo.peerID!=nil && _selectedStore.peerInfo.sessionState==MCSessionStateConnected)
    {
        //righ now we disable voice
        
        return YES;
        
    }
    else{
        return NO;
    }
}

-(void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
    //if([viewController isKindOfClass:OrderMenuViewContro])
    if(tabBarController.selectedIndex==0){
        /*
        if(self.isIpad){
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_SHOW_MENU_COLLECTION object:nil];
        }
        else{
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_SHOW_MENU_TABLE object:nil];
        }
         */
    }
}
-(void)saveOrUpdateDeviceInfoFromWeb:(NSDictionary*) jsondevice{
    //0: error 1:registered 2:approved/can go live 3:cancelled
    /*
    _appConfig.device_status=[DICT_GET(jsondevice, @"status") intValue];
    
    if(_appConfig.device_status==0)
        _appConfig.device_status=DEVICE_STATUS_REGISTERED;
    
    _appConfig.bankstatus=[DICT_GET(jsondevice, bankStatusKey) intValue];
    _appConfig.bankName=DICT_GET(jsondevice, bankNameKey);
    _appConfig.bankHolder=DICT_GET(jsondevice, bankHolderKey);
    _appConfig.bankAcct=DICT_GET(jsondevice, bankAcctKey);
    _appConfig.bankRouting=DICT_GET(jsondevice, bankRoutingKey);
    
    
    
    _appConfig.device_menuid=[DICT_GET(jsondevice, @"menuID") intValue];
    
   
    _appConfig.storeID=DICT_GET(jsondevice, storeIDKey);
    
    
    
    _appConfig.device_lat=[DICT_GET(jsondevice, latitudeKey) floatValue];
    _appConfig.device_lng=[DICT_GET(jsondevice, longitudeKey) floatValue];
    
    
    
    _appConfig.device_name=DICT_GET(jsondevice, deviceNameKey);
    _appConfig.device_id=DICT_GET(jsondevice, deviceIDKey);
    _appConfig.device_num=DICT_GET_INT(jsondevice, deviceNumKey);
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
    
    
   */
    
    
}

-(void)saveOrUpdateUserInfoFromWeb:(NSDictionary*) jsonuser{
    //_appConfig.user_userToken
   
    _appConfig.userInfo.username=DICT_GET(jsonuser, @"username");
    _appConfig.userInfo.userid=DICT_GET(jsonuser, @"userid");
    _appConfig.userInfo.PIN=DICT_GET(jsonuser, @"PIN");
    
    
    _appConfig.userInfo.firstname=DICT_GET(jsonuser, @"firstName");
    _appConfig.userInfo.lastname=DICT_GET(jsonuser, @"lastName");
    
    _appConfig.userInfo.address=DICT_GET(jsonuser, @"address");
    
    _appConfig.userInfo.picid=DICT_GET(jsonuser, @"picid");
     _appConfig.userInfo.folderid=DICT_GET(jsonuser, @"folderid");
    _appConfig.userInfo.latitude=DICT_GET(jsonuser, @"latitude");
    _appConfig.userInfo.longitude=DICT_GET(jsonuser, @"longitude");
    _appConfig.userInfo.city=DICT_GET(jsonuser, @"city");
    _appConfig.userInfo.state=DICT_GET(jsonuser, @"state");
    _appConfig.userInfo.country=DICT_GET(jsonuser, @"country");
    _appConfig.userInfo.zipcode=DICT_GET(jsonuser, @"zipcode");
    
    _appConfig.userInfo.homenumber=DICT_GET(jsonuser, @"homenumber");
    _appConfig.userInfo.mobilenumber=DICT_GET(jsonuser, @"mobilenumber");
    
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

-(void)saveOrUpdateLogonInfoFromWeb:(NSDictionary*) json{
    //bool fistTime=(_appConfig.userInfo.userToken==nil|| _appConfig.userInfo.userToken.length==0)?YES:NO;
    
    _appConfig.userInfo.userToken=[json objectForKey:@"uid"];
    
    
    
    
    [self saveOrUpdateUserInfoFromWeb:[json objectForKey:@"user"]];
    
    
    [self saveOrUpdateDeviceInfoFromWeb:[json objectForKey:@"device"]];
    
    //_appConfig.currencies=[json objectForKey:@"currencies"];
    
    
    
    [AppConfigModel saveSettings];
    /*
    if(fistTime){
        [self.inventoryModel.inventory pullInventory];
    }
    */
    
}



-(void)loggedInSuccessWithInfo:(NSDictionary *)info{
    
    [self saveOrUpdateLogonInfoFromWeb:info];
    
   // [self showTabBarController];
    
    /*_mcManager = [[MCManager alloc] init];
    
    [_mcManager start];
    
    _cnnManager=[[ConnectionManager alloc] init];
    */
    //set client or server
    /*
    _historyModel=[HistoryModel sharedInstance];
    
    //this is a bug, this is not the right place to load bec no file name is specified
    //[_historyModel loadHistory];
    
    self.historyModel.isServer=YES;
    self.historyModel.filename=_appConfig.device_id;
    
    [_historyModel loadHistory];
    
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
    
    
    
    
    
    InventoryModel *inventoryModel=[InventoryModel sharedInstance];
    [inventoryModel loadInventory];
    */
    
}

-(void)showTabBarController{
    if(self.connController==nil){
        //self.tabBarController=[[UITabBarController alloc] init];
        self.connController=(ConnectionsViewController*)[ApplicationDelegate.storyBoard instantiateViewControllerWithIdentifier:@"ConnectionsViewController"];
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
    
    
    
    [self.window setRootViewController:self.connController];
    if(_loginController!=nil)
        [self.loginController dismissViewControllerAnimated:YES completion:nil];
}


-(void)showLoginController{
    if(self.loginController==nil){
        self.loginController=[[LoginViewController alloc] init];
        
    }
    
    [self.window setRootViewController:self.loginController];
    if(self.connController!=nil)
        [self.connController dismissViewControllerAnimated:YES completion:nil];
}

@end
