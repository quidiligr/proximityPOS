//
//  ReachabilityManager.h
//  superkiosks
//
//  Created by Katherine Sheehy on 8/4/16.
//  Copyright © 2016 Sharecle. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Reachability.h"

@interface ReachabilityManager : NSObject
//reachability

+ (ReachabilityManager *)sharedInstance;

@property (nonatomic) Reachability *hostReachability;
@property (nonatomic) Reachability *internetReachability;
@property (nonatomic) NetworkStatus netStatus;
@property (nonatomic) BOOL connectionRequired;
@end
