//
//  MCManager.h
//
//
//  Created by Romulo Quidilig.
//  Copyright (c) 2015 Sharecle Inc. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <MultipeerConnectivity/MultipeerConnectivity.h>
#import "PeerInfo.h"
@class UserInfo;
@class BroadcastMessageAPI;
@class StoreHistory;
@class HistoryModel;

//@interface MCManager : NSObject<MCNearbyServiceAdvertiserDelegate,MCSessionDelegate,UIAlertViewDelegate>
@interface MCManager : NSObject<MCSessionDelegate,UIAlertViewDelegate>

@property (nonatomic, strong) MCPeerID *peerID;
@property(nonatomic,strong)PeerInfo *myPeerInfo;
//@property(nonatomic,strong)PeerInfo *serverPeerInfo;
@property (nonatomic, strong) MCSession *session;
//@property (nonatomic, strong) MCBrowserViewController *browser;

//@property (nonatomic, strong) MCAdvertiserAssistant *advertiser;
@property (nonatomic, strong) MCNearbyServiceAdvertiser *advertiser;
@property (nonatomic, strong) MCNearbyServiceBrowser *browser;

//@property (nonatomic, strong) NSMutableArray *arrConnectedDevices;
//@property (nonatomic, strong) NSMutableArray *peerDevices;

//@property (nonatomic, strong) HISTO *peerDevices;

//@property (nonatomic, strong) NSMutableArray *peerDevices;

//@property(nonatomic,strong)NSString *deviceID;
//@property(nonatomic,strong)NSString *deviceToken;

@property(nonatomic) BOOL isAutoConnect;

//-(void)setupPeerAndSessionWithDisplayName:(NSString *)displayName;
-(void)setupMCBrowser;//:(BOOL)isLive;
//-(void)advertiseSelf:(BOOL)shouldAdvertise isLive:(BOOL)isLive;

-(id)init;//WithUserInfo:(UserInfo *)userInfo;

//-(void)sendMyMessage:(BroadcastMessageAPI *)message;
-(void)sendMyMessage:(BroadcastMessageAPI *)message toStore:(StoreHistory *)store;
@end
