//
//  UserInfo.h
//  Sharecle
//
//  Created by Romulo Quidilig on 4/19/14.
//  Copyright (c) 2014 Sharecle Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Stripe.h"
@interface CCardInfo :STPCard //NSObject

//@property (nonatomic, strong) NSString * ccName;
//@property (nonatomic, strong) NSString * ccNumber;
//@property (nonatomic, strong) NSString * ccProvider;
//@property (nonatomic, strong) NSString * ccType;
//@property (nonatomic, strong) NSString * ccExpDate;
//@property (nonatomic, strong) NSNumber * ccExpMonth;
//@property (nonatomic, strong) NSNumber * ccExpYear;
//@property (nonatomic, strong) NSString * ccCVV;
//@property (nonatomic, strong) NSString * ccEmail;
@property  BOOL isDefault;
@property BOOL isValid;


- (NSDictionary *)toNSDictionary;
- (id)initWithDictionary:(NSDictionary *)dictionary;

@end
