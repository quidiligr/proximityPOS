//
//  NSData+MD5.m
//  Sharecle
//
//  Created by Romulo Quidilig on 5/4/14.
//  Copyright (c) 2014 Sharecle Inc. All rights reserved.
//

#import "NSData+MD5.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSData (MD5)

-(NSString*)MD5{
    
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
