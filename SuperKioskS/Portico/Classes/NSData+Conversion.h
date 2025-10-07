//
//  NSData+hex.h
//  MCDemo
//
//  Created by Romulo Quidilig on 3/22/15.
//  Copyright (c) 2015 Sharecle Inc. All rights reserved.
//


#import <Foundation/Foundation.h>

@interface NSData (NSData_Conversion)

#pragma mark - String Conversion
- (NSString *)hexadecimalString;

-(NSString*)MD5;

@end
