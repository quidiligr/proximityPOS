//
//  NSData+hex.m
//
//
//  Created by Romulo Quidilig.
//  Copyright (c) 2015 Sharecle Inc. All rights reserved.
//

#import "NSData+Conversion.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSData (NSData_Conversion)

#pragma mark - String Conversion
- (NSString *)hexadecimalString {
    /* Returns hexadecimal string of NSData. Empty string if data is empty.   */
    
    const unsigned char *dataBuffer = (const unsigned char *)[self bytes];
    
    if (!dataBuffer)
        return [NSString string];
    
    NSUInteger          dataLength  = [self length];
    NSMutableString     *hexString  = [NSMutableString stringWithCapacity:(dataLength * 2)];
    
    for (int i = 0; i < dataLength; ++i)
        [hexString appendString:[NSString stringWithFormat:@"%02lx", (unsigned long)dataBuffer[i]]];
    
    return [NSString stringWithString:hexString];
}

-(NSString *)MD5{
    
    //create byte array of unsigned chers
    unsigned char md5Buffer[CC_MD5_DIGEST_LENGTH];
    
    //create 16 yte MD5 hash value, store in buffer
    CC_MD5(self.bytes,(uint32_t)self.length,md5Buffer);
    
    //convert unsigned char buffer to nsstring of hex values
    NSMutableString *output=[NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH];
    for(int i=0;i<CC_MD5_DIGEST_LENGTH;i++)
        [output appendFormat:@"%02x",md5Buffer[i]];
    return output;
}

@end
