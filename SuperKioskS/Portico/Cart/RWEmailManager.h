//
//  RWEmailManager.h

//
//  Created by Romulo Quidilig.
//  Copyright (c) 2015 Sharecle Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RWEmailManager : NSObject

- (id)initWithRecipient:(NSString*)name recipientEmail:(NSString *)email;

- (void)sendConfirmationEmail;

- (void)sendConfirmationEmailWithSuccessBlock:(void(^)(void))successBlock
                                 failureBlock:(void(^)(void))failureBlock;

@end