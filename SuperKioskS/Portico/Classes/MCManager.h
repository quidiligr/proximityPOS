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
@class AppDelegate;

@interface MCManager : NSObject<MCNearbyServiceAdvertiserDelegate,MCSessionDelegate,UIAlertViewDelegate>

@property (nonatomic, strong) MCPeerID *myPeerID;
@property(nonatomic,strong)PeerInfo *myPeerInfo;
//@property(nonatomic,strong)PeerInfo *serverPeerInfo;
//@property (nonatomic, strong) MCSession *session;
//@property (nonatomic, strong) MCBrowserViewController *browser;

//@property (nonatomic, strong) MCAdvertiserAssistant *advertiser;
@property (nonatomic, strong) MCNearbyServiceAdvertiser *advertiser;
//@property (nonatomic, strong) MCNearbyServiceAdvertiser *advertiserTEST;
@property (nonatomic, strong) MCNearbyServiceBrowser *browser;

//@property (nonatomic, strong) NSMutableArray *arrConnectedDevices;
@property (nonatomic, strong) NSMutableArray *peerDevices;

@property(nonatomic,strong)NSString *deviceID;
@property(nonatomic,strong)NSString *deviceToken;

@property(nonatomic) BOOL isAutoConnect;



@property(nonatomic,strong)NSMutableArray* sessions;
//@property(nonatomic,strong)NSMutableDictionary* sessions;

//-(void)setupPeerAndSessionWithDisplayName:(NSString *)displayName;
//-(void)setupMCBrowser;
-(void)setupPeerAndSession;
//-(void)advertiseSelf:(BOOL)shouldAdvertise;
-(void)advertiseSelf;
//-(void)advertiseSelf;

//-(id)initWithUserInfo:(AppConfigModel *)appConfig;

-(void)sendMyMessage:(BroadcastMessageAPI *)message;

-(MCSession *)GetSessionWithPeerID:(MCPeerID *)peerID;

-(void)start;
@end
