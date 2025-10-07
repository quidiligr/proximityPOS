//
//  PaymentManager.h
//  superkiosks
//
//  Created by Katherine Sheehy on 4/8/16.
//  Copyright © 2016 Sharecle. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"

@interface PaymentManager : NSObject
//+ (PaymentManager *)sharedInstance;

+(BOOL)performPostCharge:(OrderHistory *)order cardInfo:(STPCard *)card isCaptured:(BOOL)captured;
+(void)returnOrder:(OrderHistory *)order;
+(NSString *)performPostRefund:(OrderHistory *)order;
+(NSString *)performPostCapture:(OrderHistory *)order;
@end
