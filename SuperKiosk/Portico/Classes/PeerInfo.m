//
//  Peer.m
//
//
//  Created by Romulo Quidilig.
//  Copyright (c) 2015 Sharecle Inc. All rights reserved.
//


#import "PeerInfo.h"

@implementation PeerInfo


-(instancetype) initWithPeerID:(MCPeerID *)peerID{
    self=[super init];
    if(self){
        self.peerID=peerID;
        self.sessionState=MCSessionStateNotConnected;
    }
    return self;
}

- (BOOL)isEqual:(id)object {
    if (![object isKindOfClass:[PeerInfo class]]) {
        return NO;
    }
    
    PeerInfo *other = (PeerInfo *)object;
    //return [other.deviceToken isEqualToString:self.deviceToken];
    //bool result=[other.peerID isEqual:self.peerID] || [other.peerID.displayName isEqualToString:self.peerID.displayName];
    
     bool result=[other.peerID.displayName isEqualToString:self.peerID.displayName];
    
    return result;
}
@end
