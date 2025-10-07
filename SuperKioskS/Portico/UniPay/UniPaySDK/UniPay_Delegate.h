//
//  UniPay_Delegate.h
//  UniPay SDK
//
//  Created by Xinhu Li on 10/6/13.
//  Copyright (c) 2013 IDTECH. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UniPay;

@protocol UniPay_Delegate <NSObject>


-(void) UniPay_EventFunctionAttachment;
-(void) UniPay_EventFunctionDetachment;

-(void) UniPay_EventFunctionConnect:(Byte) nType;
-(void) UniPay_EventFunctionMessage:(NSString *) someString;

-(void) UniPay_EventFunctionMSR: (Byte) nType : (NSData *) cardData;
-(void) UniPay_EventFunctionICC: (Byte) nICC_Attached;

@end
