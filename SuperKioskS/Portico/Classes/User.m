//
//  Peer.m
//
//
//  Created by Romulo Quidilig.
//  Copyright (c) 2015 Sharecle Inc. All rights reserved.
//


#import "User.h"

@implementation User

/*
-(instancetype) initWithPeerID:(MCPeerID *)peerID{// sessionID:(MCSession *)session{
    self=[super init];
    if(self){
        self.peerID=peerID;
        //self.sessionID=session;
        self.peers=[NSMutableArray new];
        self.sessionState=MCSessionStateNotConnected;
    }
    return self;
}
 */

-(instancetype) initWithInfo:(NSString *)deviceID userName:(NSString *)userName name:(NSString *)name group:(NSInteger)groupID{// sessionID:(MCSession *)session{
    self=[super init];
    if(self){
        self.userName=userName;
        //self.sessionID=session;
        self.name=name;
        self.deviceID=deviceID;
        self.groupID=groupID;
    }
    return self;
}


- (BOOL)isEqual:(id)object {
    if (![object isKindOfClass:[User class]]) {
        return NO;
    }
    
    User *other = (User *)object;
    //return [other.deviceToken isEqualToString:self.deviceToken];
    //bool result=[other.peerID isEqual:self.peerID];// || [other.peerID.displayName isEqualToString:self.peerID.displayName];
    
     bool result=[other.userName isEqualToString:self.userName];
    
    //bool result=[other.deviceID isEqualToString:self.deviceID];
    
    return result;
}
@end
