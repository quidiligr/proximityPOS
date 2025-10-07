//
//  ConnectionManager.h
//  superkiosks
//
//  Created by Katherine Sheehy on 3/19/16.
//  Copyright © 2016 Sharecle. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MultipeerConnectivity/MultipeerConnectivity.h>
#import "Stripe.h"

@class BroadcastMessageAPI;
@class PeerInfo;

@interface ConnectionManager : NSObject
-(void)sendMyMessage:(BroadcastMessageAPI *)message;
-(void)downloadPeerPhoto:(PeerInfo *)peerInfo;
//-(BOOL)isValidAccount;
@end
