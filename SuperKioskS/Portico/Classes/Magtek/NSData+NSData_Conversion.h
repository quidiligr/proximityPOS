//
//  NSData+NSData_Conversion.h
//  MagTekDemo
//
//  Created by Katherine Sheehy on 10/28/15.
//
//

#import <Foundation/Foundation.h>

@interface NSData (NSData_Conversion)
#pragma mark - String Conversion
/*
 NSData *someData = ...;
 NSString *someDataHexadecimalString = [someData hexadecimalString];
 */
- (NSString *)hexadecimalString;
@end
