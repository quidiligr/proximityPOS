//
//  Peer.h
//
//
//  Created by Romulo Quidilig.
//  Copyright (c) 2015 Sharecle Inc. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <MultipeerConnectivity/MCPeerID.h>
#import <MultipeerConnectivity/MCSession.h>

@interface PeerInfo : NSObject
//@property (nonatomic,strong) NSString *displayName;
//@property (nonatomic,strong) NSString *md5;

@property(nonatomic,strong) MCPeerID *peerID;
@property(nonatomic,strong)NSString *peerName;
@property(nonatomic,strong)NSString *deviceID;
@property(nonatomic,strong)NSString *deviceToken;
@property(nonatomic,strong)NSString *homeUrl;
@property(nonatomic,strong)NSString *photoMD5;

@property(nonatomic)MCSessionState sessionState;
@property(nonatomic,strong) MCSession *sessionID;
@property(nonatomic,strong)NSString *peerGroup;
@property(nonatomic,strong)NSMutableArray *peers;

//@property(nonatomic)enum MCSessionState state;

//-(instancetype)initWithPeerID:(MCPeerID *)peerID;
-(instancetype) initWithPeerID:(MCPeerID *)peerID;// sessionID:(MCSession *)session;
- (BOOL)isEqual:(id)object;
@end
