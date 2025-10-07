//
//  MCManager.m
//
//
//  Created by Romulo Quidilig.
//  Copyright (c) 2015 Sharecle Inc. All rights reserved.
//

#import "MCManager.h"
#import "UserInfo.h"
#import "PeerInfo.h"
#import "NSData+Conversion.h"
#import "BroadcastMessageAPI.h"
#import "RNEncryptor.h"
#import "RNDecryptor.h"
#import "defs.h"
#import "AppConfigModel.h"
#import "AppDelegate.h"

//KEY_MC_ADVERTISE_KIOSK
//#define KEY_MC_ADVERTISE_KIOSK @"sharecle-kiosk"
#define KEY_MC_ADVERTISE_LIVE @"sharecle-live"
#define KEY_MC_ADVERTISE_TEST @"sharecle-test"


@interface MCManager(){
    //UserInfo *_userInfo;
    //AppConfigModel *_appConfig;
    NSArray *ArrayInvitationHandler;
    NSString *_documentsDirectory;
    AppDelegate *_appDelegate;
    
}

@end
@implementation MCManager
/*
 -(id)init{
 self = [super init];
 
 if (self) {
 _peerID = nil;
 _session = nil;
 _browser = nil;
 _advertiser = nil;
 _arrConnectedDevices=[[NSMutableArray alloc] init];
 }
 
 return self;
 }
 */

-(id)init{
    self = [super init];
    
    
    if (self) {
        
    }
    
    return self;
}

-(NSDictionary *)getDiscoveryInfo{
    
    NSDictionary *info_dict=@{
                              
                              deviceIDKey:_appDelegate.appConfig.device_id
                              //,deviceNumKey:@(_appDelegate.appConfig.device_num)
                              ,authTypeKey:@(_appDelegate.appConfig.authType)
                              //,locationKey:[NSString stringWithFormat:@"%f,%f",_appDelegate.appConfig.device_lat,_appDelegate.appConfig.device_lng]
                              // ,@"deviceToken":_userInfo.deviceToken
                              // ,@"homeUrl":_userInfo.homeUrl
                              //,@"paymentPublishableKey":_appConfig.paymentPublishableKey
                              //,@"paymentPublishableKeyTest":_appConfig.paymentPublishableKeyTest
                              // ,@"device_lat":[NSNumber numberWithFloat:_appConfig.device_lat]
                              // ,@"device_lng":[NSNumber numberWithFloat:_appConfig.device_lng]
                              //,@"device_address":_appConfig.device_address
                              //,@"device_status":[NSNumber numberWithInt:_appConfig.device_status]
                              //,deviceNameKey:_appDelegate.appConfig.device_name
                              ,isLiveKey:@([_appDelegate.appConfig isLive])
                              //,INVENTORYID_KEY:@"1.0"//_appDelegate.currentInventory.inventoryId
                              };
    
    NSError *error;
    
    NSData *jsonData=[NSJSONSerialization dataWithJSONObject:info_dict options:NSJSONWritingPrettyPrinted error:&error];
    
    if(error!=nil){
        //return NO;
        [AppDelegate toast:@"Initialization error. Please RESTART. 91" duration:3.0];
        return nil;
    }
    NSDictionary *discoveryInfo;//=@{@"info":info};
    
    NSData *encryptedData = [RNEncryptor encryptData:jsonData
                                        withSettings:kRNCryptorAES256Settings
                                            password:A_SECRET_PASSWORD
                                               error:&error];
    
    if(error!=nil){
        [AppDelegate toast:@"Initialization error. Please RESTART. 124" duration:3.0];
#ifdef DEBUG
        NSLog(@"encryptData error=%@",[error localizedDescription]);
#endif
        return nil;
    }
    NSString *base64Encoded=[encryptedData base64EncodedStringWithOptions:0];//[NSString stringWithUTF8String:[encryptedData bytes]];
    
    discoveryInfo=@{@"info":base64Encoded};
    
    return discoveryInfo;
}



#pragma mark - Public method implementation

//-(void)setupPeerAndSessionWithDisplayName:(NSString *)displayName deviceToke:(NSString *)deviceID{
-(void)start{
    _appDelegate=ApplicationDelegate;
    _isAutoConnect=YES;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    _documentsDirectory = [[NSString alloc] initWithString:[paths objectAtIndex:0]];
    
    self.peerDevices=[[NSMutableArray alloc] init];
    //_appDelegate.appConfig.isVisible=YES;
    [self setupPeerAndSession];
    
    [self advertiseSelf];
}
-(void)setupPeerAndSession{//WithDisplayName:(UserInfo *)userInfo{
    //    if(_appConfig.device_status>DEVICE_STATUS_NOTREGISTERED){
   
    if(_appDelegate.appConfig==nil)
        _appDelegate.appConfig=ApplicationDelegate.appConfig;
    _myPeerID = [[MCPeerID alloc] initWithDisplayName:_appDelegate.appConfig.device_name];
    
    // _myPeerInfo=[[PeerInfo alloc] initWithPeerID:_myPeerID];
    _myPeerInfo=[[PeerInfo alloc] init];
    _myPeerInfo.peerID=_myPeerID;
    _myPeerInfo.deviceID=_appDelegate.appConfig.device_id;
    _myPeerInfo.peerName=_appDelegate.appConfig.device_name;
    _myPeerInfo.deviceToken=_appDelegate.appConfig.device_token;//_userInfo.deviceToken;
    _myPeerInfo.peerGroup=PEER_GROUP_STAFFS;
   
    
    
    MCSession *new_session = [[MCSession alloc] initWithPeer:_myPeerID];
    new_session.delegate = self;
    
    
   
    if(_sessions==nil)
        _sessions=[NSMutableArray new];
    
    
        [_sessions addObject:new_session];
    
    //[self availableSession];
    
    
         /*
         if(_appDelegate.appConfig.isLive){
             if(_appDelegate.appConfig.device_status!=DEVICE_STATUS_LIVE)
                 _appDelegate.appConfig.isLive=NO;
         
             
         }
          */
    [self advertiseSelf];
    
    
    
}

/*
 -(void)setupMCBrowser{
 
 _browser = [[MCNearbyServiceBrowser alloc] initWithPeer:_myPeerID serviceType:KEY_MC_ADVERTISE_KIOSK];
 }
 }
 */



-(void)advertiseSelf{//:(BOOL)isLive{
    
    //we make sure account is LIVE capable
    /*
    if (isLive) {
        if(_appDelegate.appConfig.device_status!=DEVICE_STATUS_LIVE)
            isLive=NO;
           
        
    }
    */
    //_appConfig.isLive is the current state and input isLive is the new state
    //if LIVE to TEST OR TEST to LIVE then  disconnect all and RESET sessions
    //if (_advertiser==nil || _appDelegate.appConfig.visibility==VISIBILITY_NONE){
        
       
        //if(_advertiser!=nil)
        //     [_advertiser stopAdvertisingPeer];
                
        if([_sessions count]>0){
            for(MCSession *s in _sessions){ //disconnect
                
                [s disconnect];
            }
            
            
            
            
            if([_sessions count]>1){ //we should retain atleast 1 session
                MCSession *first=[_sessions firstObject];
                [_sessions removeAllObjects];
                [_sessions addObject:first];
            }
        }
        
        [_peerDevices removeAllObjects];
        
        //change to new mode
        //_appDelegate.appConfig.isLive=isLive;
        
           
             [self StartAdvertising];
        
        
    //}
    /*else{
        
       
            // this triggered by visibility
            //in here we dont reset the existing connections just force advertising
       
            [self StartAdvertising];
        
       
    }
*/

}

-(void)StartAdvertising{
    //if(!_appDelegate.appConfig.isVisible)
      //  return;
    NSDictionary *discoveryInfo=[self getDiscoveryInfo];
    
    BOOL needNewInstance=NO;
    
    if(discoveryInfo==nil){
        [AppDelegate toast:@"discovery info is not available" duration:2.0];
        return;
    }
    if(_advertiser==nil){
        needNewInstance=YES;
            }
    else{
        
        [_advertiser stopAdvertisingPeer];
        
        /*if(_appDelegate.appConfig.isLive){
            
            if(![_advertiser.serviceType isEqualToString:KEY_MC_ADVERTISE_LIVE]){
                needNewInstance=YES;
            }
            
        }
        else{
            if(![_advertiser.serviceType isEqualToString:KEY_MC_ADVERTISE_TEST]){
                needNewInstance=YES;
            }
        }
         */
    }
    
    if(![_advertiser.serviceType isEqualToString:KEY_MC_ADVERTISE_LIVE]){
    
        _advertiser = [[MCNearbyServiceAdvertiser alloc] initWithPeer:_myPeerID discoveryInfo:discoveryInfo serviceType:KEY_MC_ADVERTISE_LIVE];
        
        _advertiser.delegate=self;

    }
    
    [_advertiser startAdvertisingPeer];

    
}
-(void)StopAdvertising{
    if(_advertiser!=nil)
        [_advertiser stopAdvertisingPeer];
    //_advertiser.delegate=self;
    //[_advertiser startAdvertisingPeer];
}
//-(BOOL)advertiseSelf__:(BOOL)shouldAdvertise isLive:(BOOL)isLive{ //the ret will decide if is _swvisible should proceed
//    if (shouldAdvertise) {
//        if (_isAdvertiseStarted)
//            return YES;
//        
//        //if(!_appConfig.device_name){
//        if(!_myPeerID){
//            //[_swVisible setOn:NO];
//            //[AppDelegate ShowErrorAlert:@"Please register device to continue. Tap settings to register"];
//            _isAdvertiseStarted=NO;
//            return NO;
//        }
//        
//        /*NSArray *objects=[[NSArray alloc] initWithObjects:_userInfo.deviceID,(_userInfo.deviceToken==nil)?@"":_userInfo.deviceToken,_userInfo.homeUrl, nil];
//         
//         NSArray *keys=[[NSArray alloc] initWithObjects:@"deviceID",@"deviceToken",@"homeurl", nil];
//         NSDictionary *discoveryInfo=[[NSDictionary alloc] initWithObjects:objects forKeys:keys];
//         */
//        
//        /*NSString *info=[NSString stringWithFormat:@"%@,%@,%@,%@,%@,%f,%f,%@,%i",_userInfo.deviceID,_userInfo.deviceToken,_userInfo.homeUrl,_appConfig.paymentPublishableKey,_appConfig.paymentPublishableKeyTest
//         ,_appConfig.device_lat,_appConfig.device_lng,_appConfig.device_address,_appConfig.device_status];
//         */
//        
//        
//        NSDictionary *info_dict=@{
//                                  @"deviceID":_appConfig.device_id
//                                  // ,@"deviceToken":_userInfo.deviceToken
//                                  // ,@"homeUrl":_userInfo.homeUrl
//                                  //,@"paymentPublishableKey":_appConfig.paymentPublishableKey
//                                  //,@"paymentPublishableKeyTest":_appConfig.paymentPublishableKeyTest
//                                  // ,@"device_lat":[NSNumber numberWithFloat:_appConfig.device_lat]
//                                  // ,@"device_lng":[NSNumber numberWithFloat:_appConfig.device_lng]
//                                  //,@"device_address":_appConfig.device_address
//                                  //,@"device_status":[NSNumber numberWithInt:_appConfig.device_status]
//                                  ,@"isLive":@(_appConfig.isLive)
//                                  };
//        
//        /*NSDictionary *info_dict=@{@"deviceID":_userInfo.deviceID
//         //,@"device_lat":[NSNumber numberWithFloat:_appConfig.device_lat]
//         // ,@"device_lng":[NSNumber numberWithFloat:_appConfig.device_lng]
//         //,@"device_address":_appConfig.device_address
//         // ,@"device_status":[NSNumber numberWithInt:_appConfig.device_status]
//         };
//         */
//        
//        NSError *error;
//        
//        NSData *jsonData=[NSJSONSerialization dataWithJSONObject:info_dict options:NSJSONWritingPrettyPrinted error:&error];
//        
//        if(error!=nil)
//            return NO;
//        
//        /* NSString *info=[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
//         
//         #ifdef DEBUG
//         NSLog(@"info=%@",info);
//         #endif
//         */
//        NSDictionary *discoveryInfo;//=@{@"info":info};
//        //if(SECURED){
//        //  NSError *error;
//        //NSData *data = [info dataUsingEncoding:NSUTF8StringEncoding];
//        //NSData *data = [info dataUsingEncoding:NSUTF8StringEncoding];
//        NSData *encryptedData = [RNEncryptor encryptData:jsonData
//                                            withSettings:kRNCryptorAES256Settings
//                                                password:A_SECRET_PASSWORD
//                                                   error:&error];
//        
//        if(error!=nil){
//#ifdef DEBUG
//            NSLog(@"encryptData error=%@",[error localizedDescription]);
//#endif
//            return NO;
//        }
//        NSString *base64Encoded=[encryptedData base64EncodedStringWithOptions:0];//[NSString stringWithUTF8String:[encryptedData bytes]];
//        
//        discoveryInfo=@{@"info":base64Encoded};
//        
//        if(isLive)
//            _advertiser = [[MCNearbyServiceAdvertiser alloc] initWithPeer:_myPeerID discoveryInfo:discoveryInfo serviceType:KEY_MC_ADVERTISE_LIVE];
//        else
//            _advertiser = [[MCNearbyServiceAdvertiser alloc] initWithPeer:_myPeerID discoveryInfo:discoveryInfo serviceType:KEY_MC_ADVERTISE_TEST];
//        /*}
//         else{
//         discoveryInfo=@{@"info":info};
//         _advertiser = [[MCNearbyServiceAdvertiser alloc] initWithPeer:_myPeerID discoveryInfo:discoveryInfo serviceType:KEY_MC_ADVERTISE_POS];
//         }*/
//        _advertiser.delegate=self;
//        [_advertiser startAdvertisingPeer];
//        _isAdvertiseStarted=YES;
//        
//    }
//    else{
//        //[_advertiser stop];
//        [_advertiser stopAdvertisingPeer];
//        _isAdvertiseStarted=NO;
//        _advertiser = nil;
//    }
//    return YES;
//}

- (MCSession *)availableSession {
    

    //for now we just use one session until we figure out whats going .
    //return self.session;
//    if(_sessions==nil || [_sessions count]==0){
//        //[self setupPeerAndSession];
//        //[AppDelegate toast:@"No session" duration:3.0];
//        
//        //if(_appConfig==nil)
//        //    _appConfig=ApplicationDelegate.appConfig;
//        //_myPeerID = [[MCPeerID alloc] initWithDisplayName:_appConfig.device_name];
//        
//        // _myPeerInfo=[[PeerInfo alloc] initWithPeerID:_myPeerID];
//       // _myPeerInfo=[[PeerInfo alloc] init];
//       // _myPeerInfo.peerID=_myPeerID;
//        //_myPeerInfo.deviceID=_appConfig.device_id;
//        //_myPeerInfo.peerName=_appConfig.device_name;
//       // _myPeerInfo.deviceToken=_userInfo.deviceToken;
//       // _myPeerInfo.peerGroup=PEER_GROUP_STAFFS;
//        //_myPeerInfo.peerID=PEER_GROUPNAME_STAFFS
//        
//        
//       MCSession *new_session = [[MCSession alloc] initWithPeer:_myPeerID];
//        new_session.delegate = self;
//        
//        
//        
//        //if(_sessions==nil)
//        //_sessions=[NSMutableArray new];
//        
//        //if([_sessions count]==0){
//        [_sessions addObject:new_session];
//        return new_session;//[_sessions objectAtIndex:0];
//    }
//    
   // return [_sessions objectAtIndex:0];
    
    //check for dups
    
    if(_sessions==nil){
        _sessions=[[NSMutableArray alloc] init];
    }
    //Try and use an existing session (_sessions is a mutable array)
    if([_sessions count]>0){
#ifdef DEBUG
        NSLog(@"_sessions count=%lu",(unsigned long)[_sessions count]);
#endif
        for (MCSession *session in _sessions){
            if ([session.connectedPeers count]<kMCSessionMaximumNumberOfPeers){
    #ifdef DEBUG
                NSLog(@"Reusing session");
    #endif
                return session;
            }
            
        }
        
#ifdef DEBUG
        
        NSLog(@"Maximum number of peers exceeded. Proceed to creating new session");
#endif
    }
    else{
        
        NSLog(@"No session created. Proceed to creating new session");
    }
    

    //Or create a new session
    MCSession *newSession = [[MCSession alloc] initWithPeer:_myPeerID];
    newSession.delegate = self;
    
    //MCSession *newSession = [self newSession];
    //newSession.delegate = self;
    [_sessions addObject:newSession];
    
    return newSession;
}

- (MCSession *)newSession {
    
    /*_myPeerID = [[MCPeerID alloc] initWithDisplayName:_userInfo.displayName];
     
     //_myPeerInfo=[[PeerInfo alloc] initWithPeerID:_myPeerID];
     _myPeerInfo=[[PeerInfo alloc] init];
     _myPeerInfo.peerID=_myPeerID;
     _myPeerInfo.deviceID=_userInfo.deviceID;
     _myPeerInfo.deviceToken=_userInfo.deviceToken;
     */
    
    //_session = [[MCSession alloc] initWithPeer:_myPeerID];
    
    
    // _session.delegate = self;
    
    
    
    MCSession *session = [[MCSession alloc] initWithPeer:_myPeerID securityIdentity:nil encryptionPreference:MCEncryptionNone];
    session.delegate = self;
    
    return session;
}
/*
 - (void)advertiser:(MCNearbyServiceAdvertiser *)advertiser didReceiveInvitationFromPeer:(MCPeerID *)peerID withContext:(NSData *)context invitationHandler:(void (^)(BOOL, MCSession *))invitationHandler {
 
 MCSession *session = [self availableSession];
 invitationHandler(YES,session);
 }
 */

//(void)advertiser:(MCNearbyServiceAdvertiser *)advertiser didReceiveInvitationFromPeer:(MCPeerID *)peerID withContext:(NSData *)context invitationHandler:(void (^)(BOOL accept, MCSession *session))invitationHandler{
//    
//    //NSDictionary *info=(NSDictionary *)[NSKeyedUnarchiver unarchiveObjectWithData:context];
//    
//    //MCSession *session = [self availableSession];
//    
//    //MCSession *session = [[MCSession alloc] initWithPeer:_peerID securityIdentity:nil encryptionPreference:MCEncryptionNone];
//    //session.delegate = self;
//    invitationHandler(YES,_session);
//    
//    
//}
-(void)advertiser:(MCNearbyServiceAdvertiser *)advertiser didReceiveInvitationFromPeer:(MCPeerID *)peerID withContext:(NSData *)context invitationHandler:(void (^)(BOOL, MCSession *))invitationHandler{
    
    
    NSDictionary *info=(NSDictionary *)[NSKeyedUnarchiver unarchiveObjectWithData:context];
    
    NSString *stringInfo;
    
    if (SECURED) {
        NSString *base64String=[info valueForKey:@"info"];
        
#ifdef DEBUG
        NSLog(@"base64String=%@",base64String);
#endif
        NSData *base64Data=[[NSData alloc] initWithBase64EncodedString:base64String options:0];
        
        NSError *error;
        NSData *decryptedData = [RNDecryptor decryptData:base64Data
                                            withPassword:A_SECRET_PASSWORD
                                                   error:&error];
        
        if(error!=nil){
#ifdef DEBUG
            NSLog(@"encryptData error=%@",[error localizedDescription]);
#endif
            return;
        }
        
        stringInfo=[[NSString alloc] initWithData:decryptedData encoding:NSUTF8StringEncoding];
    }
    else{
        
        stringInfo=[info valueForKey:@"info"];
    }
#ifdef DEBUG
    NSLog(@"stringData=%@",stringInfo);
#endif
    NSArray *infoos=[stringInfo componentsSeparatedByString:@";"];


    
    if([infoos count]!=5){

#ifdef DEBUG
        NSLog(@"[infoos count]=%lu",(unsigned long)[infoos count]);
#endif
        return;
    
    }
    
    
    /*we dont need this anymore bec we are implementing multi session
     NSPredicate *predicate=[NSPredicate predicateWithFormat:@"displayName=%@",peerID.displayName];
     
     NSArray *result=[session.connectedPeers filteredArrayUsingPredicate:predicate];
     
     if([result count]>0){
     invitationHandler(NO,session);
     return;
     }
     */
     MCSession *available_session = [self availableSession];
    
    PeerInfo *fromPeer=[[PeerInfo alloc] initWithPeerID:peerID];// sessionID:session];
    
    fromPeer.deviceID=[infoos objectAtIndex:0];//[info valueForKey:@"deviceID"];
    fromPeer.deviceToken=[infoos objectAtIndex:1];//[info valueForKey:@"deviceToken"];
    fromPeer.homeUrl=[infoos objectAtIndex:2];//[info valueForKey:@"homeurl"];
    fromPeer.peerName=[infoos objectAtIndex:3];
    fromPeer.photoMD5=[infoos objectAtIndex:4];
    fromPeer.peerGroup=PEER_GROUP_CUSTOMERS;
    fromPeer.sessionID=available_session;
    
    
    if(![self isRejected:fromPeer]){
        
        
       // MCSession *sessionn = [self availableSession];
        
       // invitationHandler(YES,session);
        
        fromPeer.sessionID=available_session;
        
        PeerInfo *peerInfo=nil;
        
        if([self.peerDevices containsObject:fromPeer]){
            NSInteger indexOfPeer = [self.peerDevices indexOfObject:fromPeer];
            peerInfo=[self.peerDevices objectAtIndex:indexOfPeer];
            
            /*if(![peerInfo.deviceID isEqualToString:fromPeer.deviceID]){
             #ifdef DEBUG
             NSLog(@"Displayname clashed.Invitation rejected.");
             #endif
             invitationHandler(NO,session);
             return;
             }
             */
            peerInfo.deviceID=fromPeer.deviceID;
            
            peerInfo.peerID=fromPeer.peerID;
            
            //if(![peerInfo.deviceToken isEqualToString:fromPeer.deviceToken])
            peerInfo.deviceToken=fromPeer.deviceToken;
            
            
            
            
            //if(![peerInfo.homeUrl isEqualToString:fromPeer.homeUrl])
            peerInfo.homeUrl=fromPeer.homeUrl;
            
            peerInfo.sessionID=available_session;
            peerInfo.photoMD5=fromPeer.photoMD5;
            
            
        }
        else{
            
            [self.peerDevices addObject:fromPeer];
        }
        if(!_isAutoConnect){
            
            
            UIImageView *imageView=[[UIImageView alloc] initWithFrame:CGRectMake(0,0, 40, 40)];
            UIImage *image=[UIImage imageNamed:@"person.png"];
            [imageView setImage:image];
            
            
            NSString *message=[NSString stringWithFormat:@"%@ wants to connect",peerID.displayName];
            
            
            UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:@"Accept Connection?" message:message delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
            
            //if(floor(NSFoundationVersionNumber)>NSFoundationVersionNumber_iOS_6_1){
            //   [alertView setValue:image forKey:@"accessoryView"];
            //}else{
            [alertView addSubview:imageView];
            //}
            [alertView show];
            
            //copy the invitationHandler block to an array to use it later
            ArrayInvitationHandler=[NSArray arrayWithObjects:[invitationHandler copy], nil];
        }
        else{
#ifdef DEBUG
            NSLog(@"invitation accepted0=%@",stringInfo);
#endif
            invitationHandler(YES,available_session);
        }
    }
    else{
#ifdef DEBUG
        NSLog(@"invitation declined=%@",stringInfo);
#endif
        //if peer is not valid, decline the invitation
        invitationHandler(NO,nil);
    }
    
    
}

-(MCSession *)GetSessionWithPeerID:(MCPeerID *)peerID{
    MCSession *result=nil;
    //NSUInteger index;
    for (MCSession *s in _sessions ){
        for (MCPeerID *itemPeer in s.connectedPeers ) {
            if([itemPeer isEqual:peerID]){
                result=s;
                break;
            }
        }
        
        
        /*if([s.connectedPeers indexOfObject:peerID]){
         return s;
         }*/
    }
    
    return result;
}
#pragma mark - MCSession Delegate method implementation


-(void)session:(MCSession *)session peer:(MCPeerID *)peerID didChangeState:(MCSessionState)state{
    PeerInfo *peerInfo=nil;//[[PeerInfo alloc] initWithPeerID:peerID];
    /*
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"deviceID==%@",peerID.displayName];
    NSArray *results=[self.peerDevices filteredArrayUsingPredicate:predicate];
    
    if([results count]>0)
        
        peerInfo=[results firstObject];
    
    else
        return;
    */
    if(_peerDevices==0)
        _peerDevices=[NSMutableArray new];
    
    //search if peerID exist
    if([_peerDevices count]>0){
        for(PeerInfo *p in _peerDevices){
            if([p.peerID isEqual:peerID]){
                peerInfo=p;
            }
        }
    }
    else{
        //invalid state
        return;
    }
    if(peerInfo==nil){
        //invalid state
        return;
        //peerInfo=[PeerInfo new];
        //peerInfo.peerID=peerID;
        //[_peerDevices addObject:peerInfo];
    }
    
        
        
    
    /*PeerInfo *searchPeerInfo=[[PeerInfo alloc] initWithPeerID:peerID] ;//] sessionID:session];
     searchPeerInfo.sessionID=session;
     
     if([self.peerDevices containsObject:searchPeerInfo]){
     NSInteger indexOfPeer = [self.peerDevices indexOfObject:searchPeerInfo];
     peerInfo=[self.peerDevices objectAtIndex:indexOfPeer];
     [self.peerDevices removeObjectAtIndex:indexOfPeer];
     //existing.peerID=peerID;
     
     }
     
     if(peerInfo==nil)
     return;
     */
    if (state != MCSessionStateConnecting) {
        if (state == MCSessionStateConnected) {
            
            peerInfo.sessionState=MCSessionStateConnected;
            
            /*
            NSPredicate *p_deviceid=[NSPredicate predicateWithFormat:@"DeviceId == %@",peerID.displayName];
            NSArray *result_peers=[self.myPeerInfo.peers filteredArrayUsingPredicate:p_deviceid];
            if ([result_peers count]==0) {
                [self.myPeerInfo.peers addObject:[result_peers firstObject]];
            }
             */
        }
        else if (state == MCSessionStateNotConnected){
           
            peerInfo.sessionState=MCSessionStateNotConnected;
            /*
             for (PeerInfo *item in results) {
                [self.peerDevices removeObject:item];
            }
             */
            [_peerDevices removeObject:peerInfo];
            /*
            NSPredicate *p_deviceid=[NSPredicate predicateWithFormat:@"DeviceId == %@",peerID.displayName];
            NSArray *result_peers=[self.myPeerInfo.peers filteredArrayUsingPredicate:p_deviceid];
            if ([result_peers count]>0) {
                [self.myPeerInfo.peers removeObject:[result_peers firstObject]];
            }
             */
        }
        
        /*NSDictionary *dict = @{@"peerID": peerID,
         @"state" : [NSNumber numberWithInt:state]
         };
         */
        
        NSDictionary *dict = @{@"peerInfo": peerInfo,
                               @"state" : [NSNumber numberWithInt:state]
                               };
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"MCDidChangeStateNotification"
                                                            object:nil
                                                          userInfo:dict];
        
    }
    /*else{
     PeerInfo *peerInfo=[[PeerInfo alloc] initWithPeerID:peerID];
     
     NSUInteger indexOfPeer =[self.arrConnectedDevices indexOfObject:peerInfo];
     if(indexOfPeer!=NSNotFound){
     //if(![self.arrConnectedDevices containsObject:peerID]){
     PeerInfo *existingPeer=[self.arrConnectedDevices objectAtIndex:indexOfPeer];
     // peerInfo.peerID=peerID;
     //[_arrConnectedDevices addObject:peerInfo];
     //existingPeer.state=state;
     }
     else{
     [_arrConnectedDevices addObject:peerInfo];
     }
     }
     */
}

-(void)session:(MCSession *)session didReceiveData:(NSData *)data fromPeer:(MCPeerID *)peerID{
#ifdef DEBUG
    /*NSPredicate *predicate=[NSPredicate predicateWithFormat:@"displayName=%@",message.toPeerInfo.peerID.displayName];
     NSArray *result=[allPeers filteredArrayUsingPredicate:predicate];
     */
    NSLog(@"MCManager -sendMyMessage fromPeer=%@",peerID);
    
    //peerID.idString
    //NSLog(@"MCManager -sendMyMessage message.toPeerInfo.peerID=%@",message.toPeerInfo.peerID);
    //if([_session.connectedPeers indexOfObject:peerID])
    
    /*  if([self GetSessionWithPeerID:peerID])
     
     NSLog(@"MCManager -didReceiveData exist");
     else
     NSLog(@"MCManager -didReceiveData NOT exist");
     
     */
    
#endif
    NSUInteger dataLen=[data length];
    
    if(dataLen<3)
        return;
    
    NSData *subData=[data subdataWithRange:NSMakeRange(1, dataLen-1)];
    uint8_t *bytes=(uint8_t *)[data bytes];
    if(bytes[0]==0){ //control
        //uint8_t bytesData[dataLen-1];
        
        //[data getBytes:bytesData range: NSMakeRange(1, dataLen-1)];
        NSDictionary *dict = @{ @"data": subData,
                                @"peerID": peerID
                                };
        [[NSNotificationCenter defaultCenter] postNotificationName:@"MCDidReceiveControlDataNotification"
                                                            object:nil
                                                          userInfo:dict];
        
    }
    else if (bytes[0]==1){ //voice
        //uint8_t bytesData[dataLen-1];
        //[data getBytes:bytesData range: NSMakeRange(1, dataLen-1)];
        NSData *subData=[data subdataWithRange:NSMakeRange(1, dataLen-1)];
        NSDictionary *dict = @{ @"data": subData,
                                @"peerID": peerID
                                };
        [[NSNotificationCenter defaultCenter] postNotificationName:@"MCDidReceiveVoiceDataNotification"
                                                            object:nil
                                                          userInfo:dict];
    }
    
    else if(bytes[0]==2){ //text
        
        NSData *subData=[data subdataWithRange:NSMakeRange(1, dataLen-1)];
        NSDictionary *dict = @{ @"data": subData,
                                @"peerID": peerID,
                                @"session":session
                                };
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_RECEIVE_TEXT_DATA
                                                            object:nil
                                                          userInfo:dict];
        
        /*PeerInfo *searchPeerID=[[PeerInfo alloc] initWithPeerID:peerID];// sessionID:session] ;
         searchPeerID.sessionID=session;
         
         if([self.peerDevices containsObject:searchPeerID]){
         NSInteger indexOfPeer = [self.peerDevices indexOfObject:searchPeerID];
         PeerInfo *peerInfo=[self.peerDevices objectAtIndex:indexOfPeer];
         
         NSDictionary *dict;
         if (SECURED) {
         NSError *error;
         NSData *decryptedData = [RNDecryptor decryptData:subData
         withPassword:A_SECRET_PASSWORD
         error:&error];
         if(error!=nil)
         return;
         
         dict = @{ @"data": decryptedData,
         @"peerInfo": peerInfo
         };
         
         }
         else{
         dict = @{ @"data": subData,
         @"peerInfo": peerInfo
         };
         }
         [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_RECEIVE_TEXT_DATA
         object:nil
         userInfo:dict];
         }
         else{
         
         return;
         }
         */
        
        
        //}
        
        
    }
    /*
     NSDictionary *dict = @{ @"data": data,
     @"peerID": peerID
     };
     [[NSNotificationCenter defaultCenter] postNotificationName:@"MCDidReceiveVoiceDataNotification"
     object:nil
     userInfo:dict];
     */
}


-(void)session:(MCSession *)session didStartReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID withProgress:(NSProgress *)progress{
    
    if ([resourceName containsString:@"photo_"]) {
        return;
    }
    
    NSDictionary *dict = @{@"resourceName"  :   resourceName,
                           @"peerID"        :   peerID,
                           @"progress"      :   progress
                           };
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"MCDidStartReceivingResourceNotification"
                                                        object:nil
                                                      userInfo:dict];
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [progress addObserver:self
                   forKeyPath:@"fractionCompleted"
                      options:NSKeyValueObservingOptionNew
                      context:nil];
    });
}


-(void)session:(MCSession *)session didFinishReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID atURL:(NSURL *)localURL withError:(NSError *)error{
    
    NSDictionary *dict = @{@"resourceName"  :   resourceName,
                           @"peerID"        :   peerID,
                           @"localURL"      :   (localURL==nil)?@"":localURL
                           };
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"didFinishReceivingResourceNotification"
                                                        object:nil
                                                      userInfo:dict];
    
}

-(void)session:(MCSession *)session didReceiveStream:(NSInputStream *)stream withName:(NSString *)streamName fromPeer:(MCPeerID *)peerID{
    
}


-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"MCReceivingProgressNotification"
                                                        object:nil
                                                      userInfo:@{@"progress": (NSProgress *)object}];
}

-(BOOL)isRejected:(PeerInfo *)peerInfo{
    return NO;
}




-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    BOOL accept=(buttonIndex !=alertView.cancelButtonIndex)?YES:NO;
    
    void(^invitationHandler)(BOOL, MCSession *)=[ArrayInvitationHandler objectAtIndex:0];
    
    //invitationHandler(accept,_session);
    MCSession *session=[self availableSession];
    if(session){
        invitationHandler(accept,session);
    }
}
/*
 -(void)inviteeSaveInfo{
 
 }
 */

-(void)sendMyMessage:(BroadcastMessageAPI *)message{
    
    
    if (_appDelegate.appConfig.device_id.length>512) {
#ifdef DEBUG
        NSLog(@"deviceid is too long.");
#endif
        return;
    }
    
    NSString *len_deviceid=[NSString stringWithFormat:@"%lu",(unsigned long)_appDelegate.appConfig.device_id.length];
    //0's prefix
    //if (len_deviceid.length<DEVICEID_LEN){
    
    long dif=DEVICEID_LEN-len_deviceid.length;
    if (dif!=0) {
        for (int i=1; i<=dif; i++) {
            len_deviceid=[@"0" stringByAppendingString:len_deviceid];
        }
    }
    
    NSError *error;
    NSString *text=message.text;
    //assemble messageapi to json string
    if ([message.message_type isEqualToString:MSG_TYPE_DEF]) {
        NSDictionary *dictMessage;
        if(message.isBroadcast){
            //dictMessage=@{@"text":(message.text!=nil)?message.text:@"",@"fromDeviceID":message.fromDeviceID, @"sender":message.sender,@"isBroadcast":@YES};
            dictMessage=@{@"text":(message.text!=nil)?message.text:@"",@"sender":message.sender,@"fromDeviceID":message.fromDeviceID,@"toDeviceID":(message.toDeviceID)?message.toDeviceID:@"",@"imagefileuid":(message.imagefileuid)?message.imagefileuid:@"", @"isBroadcast":@(message.isBroadcast)};
        }
        else{
            if(message.toPeerInfo==nil)
                return;
#ifdef DEBUG
            NSLog(@"sending private message.");
#endif
            
            // dictMessage=@{@"text":message.text,@"fromDeviceID":message.fromDeviceID,@"sender":message.sender,@"isBroadcast":@NO};
            dictMessage=@{@"text":(message.text!=nil)?message.text:@"",@"sender":message.sender,@"fromDeviceID":message.fromDeviceID,@"imagefileuid":(message.imagefileuid)?message.imagefileuid:@"", @"isBroadcast":@(message.isBroadcast)};
        }
        NSData *jsonData=[NSJSONSerialization dataWithJSONObject:dictMessage options:NSJSONWritingPrettyPrinted error:&error];
        
        if(error)
            return;
        
        NSString *json_text=[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        text=json_text;
    }
    //}
    NSString *txtPart=[NSString stringWithFormat:@"%@%@%@%@",len_deviceid,_appDelegate.appConfig.device_id,message.message_type,text];
    
    NSMutableData *dataToSend = [NSMutableData dataWithCapacity:1] ;
    
    [dataToSend appendBytes:"\x2" length:(1)];
    
    
    
    NSData *data = [txtPart dataUsingEncoding:NSUTF8StringEncoding];
    
    if(SECURED){
        NSError *error;
        NSData *encryptedData = [RNEncryptor encryptData:data
                                            withSettings:kRNCryptorAES256Settings
                                                password:A_SECRET_PASSWORD
                                                   error:&error];
        if(error!=nil)
            return;
        
        [dataToSend appendData:encryptedData] ;
    }
    else{
        
        [dataToSend appendData:data] ;
        
    }
    
    
    
    // NSError *error;
    
    if([_sessions count]>0){
        
        if(message.isBroadcast){
            
            for (MCSession *session in _sessions) {
                if([session.connectedPeers count]>0){
                    [session sendData:dataToSend
                              toPeers:session.connectedPeers
                             withMode:MCSessionSendDataReliable
                                error:&error];
                }
            }
            
        }
        else{
            
            if(message.toPeerInfo!=nil && message.toPeerInfo.sessionID!=nil &&  message.toPeerInfo.peerID!=nil){
                
                [message
                 .toPeerInfo.sessionID sendData:dataToSend
                 toPeers:@[message.toPeerInfo.peerID]//@[[result firstObject]]
                 withMode:MCSessionSendDataReliable
                 error:&error];
                
            }
            
        }
        if (error) {
#ifdef DEBUG
            NSLog(@"%@", [error localizedDescription]);
#endif
        }
        
    }
    
}

@end
