//
//  IODItem.h
//  
//
//  Created by Romulo Quidilig on 3/19/15.
//  Copyright (c) 2015 Sharecle Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CardInfo : NSObject <NSCoding>

@property (nonatomic,copy) NSString* name;

@property (nonatomic,copy) NSString* cardNumber;
@property(nonatomic,copy)NSString *email;
@property(nonatomic,copy)NSString *CVCNumber;
@property(nonatomic,copy)NSString *expYear;
@property(nonatomic,copy)NSString *expMonth;




@end
