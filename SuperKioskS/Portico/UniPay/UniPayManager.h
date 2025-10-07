//
//  UniPayClass.h
//  superkiosks
//
//  Created by Katherine Sheehy on 4/5/16.
//  Copyright © 2016 Sharecle. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import <MessageUI/MessageUI.h>
#import "UniPay.h"
#import "UniPay_Delegate.h"
#import "InputAlert.h"

@interface UniPayManager : NSObject<UniPay_Delegate, InputAlertDelegate>
@property (nonatomic,strong)UniPay * reader;

-(void)start;
@end
