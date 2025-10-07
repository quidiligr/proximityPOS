//
//  ConnectionManager.h
//  superkiosk
//
//  Created by Katherine Sheehy on 6/11/16.
//  Copyright © 2016 Sharecle. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Reachability.h"

@interface ConnectionManager : NSObject

@property (nonatomic, strong) NSMutableDictionary *connections;
@property (nonatomic, strong) NSMutableArray *downloadRequests;
//reachability
@property (nonatomic) Reachability *hostReachability;
@property (nonatomic) Reachability *internetReachability;
@property (nonatomic) NetworkStatus netStatus;
@property (nonatomic) BOOL connectionRequired;
//

+ (ConnectionManager *)sharedInstance;
//-(void)downloadViaBlueTooth:(NSString *)serverPath serverPeer:(PeerInfo *)serverPeer;
-(void)downloadViaBlueTooth:(NSString *)serverPath serverPeer:(PeerInfo *)serverPeer timeOutSec:(NSInteger)timeOutSec;
-(BOOL)downloadImageViaWWAN:(NSString *)pictureFile storeID:(NSString *)storeID deviceID:(NSString *)deviceID;
//- (NSString*)connectionsPath;
//- (void)loadConnections;
//- (void)saveConnections;

@end
