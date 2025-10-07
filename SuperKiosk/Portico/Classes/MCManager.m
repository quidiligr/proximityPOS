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
#import "StoreHistory.h"
#import "HistoryModel.h"
#import "RNEncryptor.h"
#import "RNDecryptor.h"
#import "AppDelegate.h"
#import "defs.h"

@interface MCManager(){
    UserInfo *_userInfo;
    HistoryModel *_historyModel;
    NSArray *ArrayInvitationHandler;
    NSString *_documentsDirectory;
    
}

@end
@implementation MCManager


//-(id)initWithUserInfo:(UserInfo *)userInfo{
-(id)init{//WithUserInfo:(UserInfo *)userInfo{
    self = [super init];
   // self = [self init];

    if (self) {
        AppDelegate *appDelegate=ApplicationDelegate;
        _isAutoConnect=YES;
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        _documentsDirectory = [[NSString alloc] initWithString:[paths objectAtIndex:0]];
        
        //self.peerDevices=[[NSMutableArray alloc] init];
        
        _userInfo=appDelegate.appConfig.userInfo;
        _historyModel=appDelegate.historyModel;
      
        _browser = nil;
        _advertiser = nil;
        
        
        [self setupPeerAndSession];
        
       // [self advertiseSelf:NO];
    }
    
    return self;
}




#pragma mark - Public method implementation

//-(void)setupPeerAndSessionWithDisplayName:(NSString *)displayName deviceToke:(NSString *)deviceID{
-(void)setupPeerAndSession{//WithDisplayName:(UserInfo *)userInfo{
    NSString *displayName=_userInfo.deviceID;

   /*
    NSString *displayName=[_userInfo.deviceID stringByReplacingOccurrencesOfString:@"-" withString:@""];
    
    displayName=[displayName substringToIndex:15];
*/
    _peerID = [[MCPeerID alloc] initWithDisplayName:displayName];//_userInfo.deviceID]; //_userInfo.displayName];
    
    
    _myPeerInfo=[[PeerInfo alloc] initWithPeerID:_peerID];
    _myPeerInfo.deviceID=_userInfo.deviceID;
    _myPeerInfo.deviceToken=_userInfo.deviceToken;
    
    _session = [[MCSession alloc] initWithPeer:_peerID];
   
   
    _session.delegate = self;
    
}


-(void)setupMCBrowser{//:(BOOL)isLive{
    if(_browser==nil)
    //if(isLive)
        _browser = [[MCNearbyServiceBrowser alloc] initWithPeer:_peerID serviceType:KEY_MC_ADVERTISE_LIVE];
    //else
        //_browser = [[MCNearbyServiceBrowser alloc] initWithPeer:_peerID serviceType:KEY_MC_ADVERTISE_TEST];
     //   _browser = [[MCNearbyServiceBrowser alloc] initWithPeer:_peerID serviceType:KEY_MC_ADVERTISE_LIVE];
}

/*
-(void)advertiseSelf:(BOOL)shouldAdvertise{
    if (shouldAdvertise) {
        
       
        NSArray *objects=[[NSArray alloc] initWithObjects:_userInfo.deviceID,(_userInfo.deviceToken==nil)?@"":_userInfo.deviceToken,_userInfo.homeUrl, nil];
        
        
        NSArray *keys=[[NSArray alloc] initWithObjects:@"deviceID",@"deviceToken",@"homeurl", nil];
        NSDictionary *discoveryInfo=[[NSDictionary alloc] initWithObjects:objects forKeys:keys];
       
        _advertiser = [[MCNearbyServiceAdvertiser alloc] initWithPeer:_peerID discoveryInfo:discoveryInfo serviceType:KEY_MC_ADVERTISE_KIOSK];
        
        _advertiser.delegate=self;
        [_advertiser startAdvertisingPeer];
        
    }
    else{
        
        [_advertiser stopAdvertisingPeer];
        _advertiser = nil;
    }
}
*/

#pragma mark - MCSession Delegate method implementation


-(void)session:(MCSession *)session peer:(MCPeerID *)peerID didChangeState:(MCSessionState)state{
   /*
    if(self.peerDevices==nil)
        self.peerDevices=[NSMutableArray new];
    
    PeerInfo *peerInfo=nil;
    
    PeerInfo *searchPeerInfo=[[PeerInfo alloc] initWithPeerID:peerID];
    
   
    if([self.peerDevices containsObject:searchPeerInfo]){
        NSInteger indexOfPeer = [self.peerDevices indexOfObject:searchPeerInfo];
        peerInfo=[self.peerDevices objectAtIndex:indexOfPeer];
        
    }
    
    //else{
    //    peerInfo=searchPeerInfo;
    //}
   
    if(peerInfo==nil)
        return;
    */
    StoreHistory *store=[_historyModel storeWithPeerName:peerID.displayName];
    if(store==nil)
        return;
    
    
    
    
    if (state != MCSessionStateConnecting) {
        if (state == MCSessionStateConnected) {
            
          
            store.peerInfo.sessionState=MCSessionStateConnected;
            if(![_session isEqual:session])
                _session=session;
        }
        else if (state == MCSessionStateNotConnected){
                                   store.peerInfo.sessionState=MCSessionStateNotConnected;
                        }
        
        
        
        NSDictionary *dict = @{peerInfoKey: store.peerInfo,
                               stateKey : [NSNumber numberWithInt:state]
                               };
        
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_MCDIDCHANGESTATE
                                                            object:nil
                                                          userInfo:dict];

    }
   
    }

-(void)session:(MCSession *)session didReceiveData:(NSData *)data fromPeer:(MCPeerID *)peerID{
    
    StoreHistory *store=[_historyModel storeWithPeerName:peerID.displayName];
    if(store==nil)
        return;

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
           // if([self.arrConnectedDevices count]>0){
               
            //PeerInfo *searchPeerID=store.peerInfo;//[[PeerInfo alloc] initWithPeerID:peerID] ;
                
                
                /*if([self.peerDevices containsObject:searchPeerID]){
                    NSInteger indexOfPeer = [self.peerDevices indexOfObject:searchPeerID];
                    PeerInfo *peerInfo=[self.peerDevices objectAtIndex:indexOfPeer];
                  */
                    NSDictionary *dict;
                    if (SECURED) {
                        NSError *error;
                        NSData *decryptedData = [RNDecryptor decryptData:subData
                                                            withPassword:A_SECRET_PASSWORD
                                                                   error:&error];
                        if(error!=nil)
                            return;
                        
                        dict = @{ @"data": decryptedData,
                                  @"peerInfo": store.peerInfo
                                  };

                    }
                    else{
                        dict = @{ @"data": subData,
                                            @"peerInfo": store.peerInfo
                                            };
                    }
                    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_RECEIVE_TEXT_DATA
                                                                        object:nil
                                                                      userInfo:dict];
                /*}
                else{
                    
                    return;
                }
*/
                
                    
            //}
            
    
    }
    
}


-(void)session:(MCSession *)session didStartReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID withProgress:(NSProgress *)progress{
    
    StoreHistory *store=[_historyModel storeWithPeerName:peerID.displayName];
    if(store==nil)
        return;
    
    //this does not work with older version:if ([resourceName containsString:@"photo_"]) {
    if(resourceName.length>6){
    NSString *s=[resourceName substringToIndex:6];
    if([s isEqualToString:@"photo_"]){
    //if ([resourceName substringToIndex:6]) {
        return;
    }
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
    
    StoreHistory *store=[_historyModel storeWithPeerName:peerID.displayName];
    if(store==nil){
#ifdef DEBUG
        NSLog(@"Store not found.");
#endif
    
        return;
    }
    
    if(localURL==nil){
#ifdef DEBUG
        NSLog(@"localURL is nil.");
#endif
        
        return;
    }
    
    
    NSDictionary *dict = @{resourceNameKey  :   resourceName,
                           peerIDKey        :   peerID,
                           localURLKey      :   (localURL)?localURL:@""
                           };
    
    [[NSNotificationCenter defaultCenter] postNotificationName:didFinishReceivingResourceNotificationKey
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


//-(void)advertiser:(MCNearbyServiceAdvertiser *)advertiser didReceiveInvitationFromPeer:(MCPeerID *)peerID withContext:(NSData *)context invitationHandler:(void (^)(BOOL, MCSession *))invitationHandler{
//    //get the browser's info
//     NSDictionary *info=(NSDictionary *)[NSKeyedUnarchiver unarchiveObjectWithData:context];
//    
//    PeerInfo *fromPeer=[[PeerInfo alloc] initWithPeerID:peerID];
//    //existingPeer.peerID=peerID;
//    fromPeer.deviceID=[info valueForKey:@"deviceID"];
//    fromPeer.deviceToken=[info valueForKey:@"deviceToken"];
//    fromPeer.homeUrl=[info valueForKey:@"homeurl"];
//        if(![self isRejected:fromPeer]){
//        
//       
//        PeerInfo *peerInfo=nil;
//        
//        if([self.peerDevices containsObject:fromPeer]){
//            NSInteger indexOfPeer = [self.peerDevices indexOfObject:fromPeer];
//            peerInfo=[self.peerDevices objectAtIndex:indexOfPeer];
//            
//            if(![peerInfo.deviceID isEqualToString:fromPeer.deviceID])
//                peerInfo.deviceID=fromPeer.deviceID;
//            
//            if(![peerInfo.deviceToken isEqualToString:fromPeer.deviceToken])
//                peerInfo.deviceToken=fromPeer.deviceToken;
//            
//            if(![peerInfo.homeUrl isEqualToString:fromPeer.homeUrl])
//                peerInfo.homeUrl=fromPeer.homeUrl;
//            
//        }
//        else{
//            
//            [self.peerDevices addObject:fromPeer];
//        }
//        if(!_isAutoConnect){
//            
//        
//        UIImageView *imageView=[[UIImageView alloc] initWithFrame:CGRectMake(0,0, 40, 40)];
//        UIImage *image=[UIImage imageNamed:@"empty"];
//        [imageView setImage:image];
//        
//        
//        NSString *message=[NSString stringWithFormat:@"%@ wants to connect",peerID.displayName];
//       
//        
//        UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:@"Accept Connection?" message:message delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
//        
//        //if(floor(NSFoundationVersionNumber)>NSFoundationVersionNumber_iOS_6_1){
//         //   [alertView setValue:image forKey:@"accessoryView"];
//        //}else{
//            [alertView addSubview:imageView];
//        //}
//        [alertView show];
//        
//        //copy the invitationHandler block to an array to use it later
//        ArrayInvitationHandler=[NSArray arrayWithObjects:[invitationHandler copy], nil];
//        }
//        else{
//            invitationHandler(YES,_session);
//        }
//    }
//    else{
//        //if peer is not valid, decline the invitation
//        invitationHandler(NO,_session);
//            }
//    
//    
//}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    BOOL accept=(buttonIndex !=alertView.cancelButtonIndex)?YES:NO;
    
    void(^invitationHandler)(BOOL, MCSession *)=[ArrayInvitationHandler objectAtIndex:0];
    
    invitationHandler(accept,_session);
    // NSArray *allPeers = _session.connectedPeers;
}
/*
-(void)inviteeSaveInfo{
    
}
*/


-(void)sendMyMessage:(BroadcastMessageAPI *)message toStore:(StoreHistory *)store{

if (_userInfo.deviceID.length>512) {
#ifdef DEBUG
    NSLog(@"deviceid is too long.");
#endif
    return;
}

NSString *len_deviceid=[NSString stringWithFormat:@"%lu",(unsigned long)_userInfo.deviceID.length];
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
    
    
#ifdef DEBUG
    NSLog(@"SENDING MESSAGE TYPE: %@",message.message_type);
#endif
    
    if ([message.message_type isEqualToString:MSG_TYPE_DEF]) {
        NSDictionary *dictMessage=@{@"text":message.text,@"sender":_userInfo.displayName,@"fromDeviceID":self.myPeerInfo.deviceID,@"toDeviceID":(message.toDeviceID)?message.toDeviceID:@"",@"imagefileuid":(message.imagefileuid)?message.imagefileuid:@"", @"isBroadcast":@(message.isBroadcast)};
        
               NSData *jsonData=[NSJSONSerialization dataWithJSONObject:dictMessage options:NSJSONWritingPrettyPrinted error:&error];
        
        if(error)
            return;
        
        NSString *json_text=[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        text=json_text;
    }
    
    
    NSString *txtPart=[NSString stringWithFormat:@"%@%@%@%@",len_deviceid,_userInfo.deviceID,message.message_type,(text)?text:@""];
    NSMutableData *dataToSend = [NSMutableData dataWithCapacity:1] ;

    
    
    [dataToSend appendBytes:"\x2" length:(1)];
    
    NSData *data = [txtPart dataUsingEncoding:NSUTF8StringEncoding];
    
  
        NSData *encryptedData = [RNEncryptor encryptData:data
                                            withSettings:kRNCryptorAES256Settings
                                                password:A_SECRET_PASSWORD
                                                   error:&error];
    if(error)
        return;
    
        [dataToSend appendData:encryptedData] ;
    
    if(store.peerInfo && store.peerInfo.peerID){
    [_session sendData:dataToSend
               toPeers:@[store.peerInfo.peerID]
              withMode:MCSessionSendDataReliable
                 error:&error];
    }
    else{
        //ROM: this could be annoying
        /*
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Error" message:@"You are not connected." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        */
    }
    
}

@end
