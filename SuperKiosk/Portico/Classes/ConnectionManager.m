//
//  ConnectionManager.m
//  superkiosk
//
//  Created by Katherine Sheehy on 6/11/16.
//  Copyright © 2016 Sharecle. All rights reserved.
//

#import "ConnectionManager.h"
#import "ReachabilityManager.h"
#import "BroadcastMessageAPI.h"
#import "defs.h"

@implementation ConnectionManager

+ (ConnectionManager *)sharedInstance {
    static ConnectionManager*  _connectionManager;
    
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        _connectionManager = [[ConnectionManager alloc] init];
        if(_connectionManager.downloadRequests==nil){
            _connectionManager.downloadRequests=[NSMutableArray new];
                    }
        if(_connectionManager.connections==nil){
            _connectionManager.connections=[NSMutableDictionary new];
            
        }
        [_connectionManager startReachability];
        
        
    });
    
    return _connectionManager;
}
/*
- (NSString*)connectionsPath//:(NSString *)withTitle
{
    
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString* documentsDirectory = paths[0];
    
    NSString *filename=@"connections.plist";
    //}
    
    return [documentsDirectory stringByAppendingPathComponent:filename];
}

- (void)loadConnections
{
    if(self.connections==nil)
        self.connections=[NSMutableDictionary new];
    //[self.days removeAllObjects];
    
    NSString* path = [self connectionsPath];
    if ([[NSFileManager defaultManager] fileExistsAtPath:path])
    {
        // We store the inventory in a plist file inside the app's Documents
        // directory. The Inventory object conforms to the NSCoding protocol,
        // which means that it can "freeze" itself into a data structure that
        // can be saved into a plist file. So can the NSMutableArray that holds
        // these Message objects. When we load the plist back in, the array and
        // its Messages "unfreeze" and are restored to their old state.
        
        NSData* data = [[NSData alloc] initWithContentsOfFile:path];
        if(data){
            NSKeyedUnarchiver* unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
            _connections =[unarchiver decodeObjectForKey:@"Connections"];
            
            if(_connections==nil){
                _connections=[NSMutableDictionary new];
            }
            
            [unarchiver finishDecoding];
        }
    }
    else
    {
        //self.orders = [NSMutableArray arrayWithCapacity:20];
        // self.categories = [NSMutableArray new];
        //[self loadDefaultCategory];
        //[self saveInventory];
    }
    
    
}

- (void)saveConnections
{
    NSMutableData* data = [[NSMutableData alloc] init];
    NSKeyedArchiver* archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:_connections forKey:@"Connections"];
    
    [archiver finishEncoding];
    [data writeToFile:[self connectionsPath] atomically:YES];
    //[[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_UPDATE_HISTORY object:nil];
}
*/
-(void)startReachability{
    /*
     Observe the kNetworkReachabilityChangedNotification. When that notification is posted, the method reachabilityChanged will be called.
     */
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    
    //Change the host name here to change the server you want to monitor.
    NSString *remoteHostName = @"www.superkioskapp.com";
    /*NSString *remoteHostLabelFormatString = NSLocalizedString(@"Remote Host: %@", @"Remote host label format string");
    self.remoteHostLabel.text = [NSString stringWithFormat:remoteHostLabelFormatString, remoteHostName];
    */
    self.hostReachability = [Reachability reachabilityWithHostName:remoteHostName];
    [self.hostReachability startNotifier];
    [self updateInterfaceWithReachability:self.hostReachability];
    
    self.internetReachability = [Reachability reachabilityForInternetConnection];
    [self.internetReachability startNotifier];
    [self updateInterfaceWithReachability:self.internetReachability];
}
/*!
* Called by Reachability whenever status changes.
*/
- (void) reachabilityChanged:(NSNotification *)note
{
    Reachability* curReach = [note object];
    NSParameterAssert([curReach isKindOfClass:[Reachability class]]);
    [self updateInterfaceWithReachability:curReach];
}


- (void)updateInterfaceWithReachability:(Reachability *)reachability
{
    if (reachability == self.hostReachability)
    {
        self.netStatus = [reachability currentReachabilityStatus];
        self.connectionRequired = [reachability connectionRequired];
        
        /*[self configureTextField:self.remoteHostStatusField imageView:self.remoteHostImageView reachability:reachability];
        NetworkStatus netStatus = [reachability currentReachabilityStatus];
        BOOL connectionRequired = [reachability connectionRequired];
        
        self.summaryLabel.hidden = (netStatus != ReachableViaWWAN);
        NSString* baseLabelText = @"";
        
        if (connectionRequired)
        {
            baseLabelText = NSLocalizedString(@"Cellular data network is available.\nInternet traffic will be routed through it after a connection is established.", @"Reachability text if a connection is required");
        }
        else
        {
            baseLabelText = NSLocalizedString(@"Cellular data network is active.\nInternet traffic will be routed through it.", @"Reachability text if a connection is not required");
        }
        self.summaryLabel.text = baseLabelText;
         */
    }
    
    if (reachability == self.internetReachability)
    {
        //[self configureTextField:self.internetConnectionStatusField imageView:self.internetConnectionImageView reachability:reachability];
        self.netStatus = [reachability currentReachabilityStatus];
        self.connectionRequired = [reachability connectionRequired];
    }
    
}

- (void)configureTextField:(UITextField *)textField imageView:(UIImageView *)imageView reachability:(Reachability *)reachability
{
    /*
    NetworkStatus netStatus = [reachability currentReachabilityStatus];
    BOOL connectionRequired = [reachability connectionRequired];
    NSString* statusString = @"";
    
    switch (netStatus)
    {
        case NotReachable:        {
            statusString = NSLocalizedString(@"Access Not Available", @"Text field text for access is not available");
            imageView.image = [UIImage imageNamed:@"stop-32.png"] ;
            
     //Minor interface detail- connectionRequired may return YES even when the host is unreachable. We cover that up here...
     
            connectionRequired = NO;
            break;
        }
            
        case ReachableViaWWAN:        {
            statusString = NSLocalizedString(@"Reachable WWAN", @"");
            imageView.image = [UIImage imageNamed:@"WWAN5.png"];
            break;
        }
        case ReachableViaWiFi:        {
            statusString= NSLocalizedString(@"Reachable WiFi", @"");
            imageView.image = [UIImage imageNamed:@"Airport.png"];
            break;
        }
    }
    
    
    if (connectionRequired)
    {
        NSString *connectionRequiredFormatString = NSLocalizedString(@"%@, Connection Required", @"Concatenation of status string with connection requirement");
        statusString= [NSString stringWithFormat:connectionRequiredFormatString, statusString];
    }
    textField.text= statusString;
    */
}


-(void)downloadViaBlueTooth:(NSString *)serverPath serverPeer:(PeerInfo *)serverPeer timeOutSec:(NSInteger)timeOutSec{
    // this is for BT connection but it may be very slow
    //TODO: implement compression
    //dispatch_async(dispatch_get_main_queue(), ^{
    
    //int max_queue=1000;
    bool exist=NO;
    //if([_downloadRequests count]>0){
    //remove expired requests;
    NSMutableArray *expired=[NSMutableArray new];
    for(NSDictionary *dict in _downloadRequests){
        NSString *deviceID=[dict valueForKey:deviceIDKey];
        NSString *path=[dict valueForKey:pathKey];
        NSDate *date=[dict valueForKey:dateKey];
        //NSDate *reqDate=[dict valueForKey:@"date"];
        if([deviceID isEqualToString:serverPeer.deviceID] && [serverPath isEqualToString:path]){
            
            NSTimeInterval secs=[date timeIntervalSinceNow];
            if((secs)>=timeOutSec){
                
                [expired addObject:dict];
            }
            else{
                exist=YES;
            }
            
        }
        NSTimeInterval secs=[date timeIntervalSinceNow];
        if((secs)>=timeOutSec){
            //30 mins
            [expired addObject:dict];
        }
        
    }
    if([expired count]>0){
        for(NSDictionary *rem in expired){
            [expired removeObject:rem];
        }
    }
    //if([_downloadRequests count]>max_queue){
        //[AppDelegate toast:@"Too many download requests. Download will resume " duration:2.0];
    //    return;
    //}
        
        if(exist){
            return;
        }
    
    /*if([_downloadRequests count]>0){
        //check if it's already in queue
        NSPredicate *p=[NSPredicate predicateWithFormat:@"deviceID==%@ && path==%@",serverPeer.deviceID,serverPath];
        NSArray *arr=[_downloadRequests filteredArrayUsingPredicate:p];
        if([arr count]>0){
            return;
        }
        
    }
     */
    
    [_downloadRequests addObject:@{deviceIDKey:serverPeer.deviceID,pathKey:serverPath,@"date":[NSDate date]}];
    
    BroadcastMessageAPI *message=[[BroadcastMessageAPI alloc] init];
    message.text=serverPath;
    message.isBroadcast=NO;
    message.toPeerInfo=serverPeer;//_appDelegate.selectedStore.peerInfo;
    message.message_type=MSG_TYPE_REQUEST_FILE_DOWNLOAD;
    message.localCopy=NO;
    
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didFinishDownload:) name:product.pictureFile object:nil];
    
    NSDictionary *dict = @{KEY_SEND_MESSAGE: message
                           };
    
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_HAS_DATA_TO_SEND
     
     
     
                                                        object:nil
                                                      userInfo:dict];
    
    
    
    //});
    
}

-(BOOL)downloadImageViaWWAN:(NSString *)pictureFile storeID:(NSString *)storeID deviceID:(NSString *)deviceID {
    
    if(pictureFile==nil || pictureFile.length==0)
        return YES;
    
    
    /*
     [_connManager downloadViaBlueTooth:serverPath serverPeer:_appDelegate.selectedStore.peerInfo];
     */
    
    NSString *filePath=[[AppDelegate getImagesPathForServer:deviceID] stringByAppendingPathComponent:pictureFile];
    
    if([[NSFileManager defaultManager] fileExistsAtPath:filePath])
        return YES;
    
    ReachabilityManager *rm=[ReachabilityManager sharedInstance];
    
    if(rm==nil)
        return NO;
    NetworkStatus netStatus = [rm.hostReachability currentReachabilityStatus];
    if(netStatus ==ReachableViaWiFi || netStatus ==ReachableViaWWAN){
        NSString *url=[NSString stringWithFormat:@"%@%@/%@/%@",ServerURL,SKSImagePathWithStoreID,storeID,pictureFile];
#ifdef DEBUG
        NSLog(@"url=%@",url);
#endif
        
        NSURL *imageURL = [NSURL URLWithString:url];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                // Update the UI
                //self.imageView.image = [UIImage imageWithData:imageData];
                [imageData writeToFile:filePath atomically:YES];
                [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_UPDATE_PRODUCT_IMAGE object:nil];
                
                
            });
        });
        return true;
    }
    //else{
        return NO;
    //}
}



- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kReachabilityChangedNotification object:nil];
}


@end
