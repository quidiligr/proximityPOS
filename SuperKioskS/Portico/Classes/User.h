//
//  Peer.h
//
//
//  Created by Romulo Quidilig.
//  Copyright (c) 2015 Sharecle Inc. All rights reserved.
//


#import <Foundation/Foundation.h>
//#import <MultipeerConnectivity/MCPeerID.h>
//#import <MultipeerConnectivity/MCSession.h>

@interface User : NSObject
@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *userName;
@property (nonatomic) NSInteger userID;
//@property (nonatomic,strong) NSString *md5;
/*
@property(nonatomic,strong) MCPeerID *peerID;
@property(nonatomic,strong)NSString *peerName;
*/
@property(nonatomic,strong) PeerInfo *peerInfo;
@property(nonatomic,strong)NSString *deviceID;
@property(nonatomic,strong)NSString *deviceToken;
//@property(nonatomic,strong)NSString *homeUrl;
//@property(nonatomic,strong)NSString *photoMD5;

//@property(nonatomic)MCSessionState sessionState;
//@property(nonatomic,strong) MCSession *sessionID;
//@property(nonatomic,strong)NSString *peerGroup;
//@property(nonatomic,strong)NSMutableArray *peers;

//@property(nonatomic)enum MCSessionState state;

@property(nonatomic)NSInteger groupID;

//-(instancetype)initWithPeerID:(MCPeerID *)peerID;
//-(instancetype) initWithInfo:(NSString *)userName name:(NSString *)name group:(NSInteger)groupID;
-(instancetype) initWithInfo:(NSString *)deviceID userName:(NSString *)userName name:(NSString *)name group:(NSInteger)groupID;
- (BOOL)isEqual:(id)object;
@end
