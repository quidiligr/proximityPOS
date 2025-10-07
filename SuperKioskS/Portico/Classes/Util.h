//
//  Util.h
//  superkiosks
//
//  Created by Katherine Sheehy on 4/25/16.
//  Copyright © 2016 Sharecle. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import <AudioToolbox/AudioToolbox.h>
//#import "Reachability.h"

@interface Util : NSObject
+(NSString *)discountToString:(double)discount;
//+(NSString *)priceToString:(double)price;

+(NSString *)priceToString:(double)price currency:(NSString *)currency;

+(NSString *)priceIntToString:(NSInteger)price currency:(NSString *)currency;

+(NSString *)decimalDisplay:(double)decimal;
//+(void)playSystemSound:(SystemSoundID) soundID;
+(BOOL)isNumeric:(NSString *)string;

//+(void) postUploadBeforeSend:(NSData *)filedata filename:(NSString *)filename contenttype:(NSString *)contenttype;

+(void) postUploadBeforeSend:(NSData *)filedata filename:(NSString *)filename contenttype:(NSString *)mimetype serverpath:(NSString *)path info:(NSString *)info;

+ (CGSize)sizeForText:(NSString*)text withWidth:(CGFloat)width withFont:(NSFont *)font;
//+(void)downloadImage:(NSString *)fileName;
//+(UIImage *)resizeImage:(UIImage*)image newSize:(CGSize)newSize;
+ (AFHTTPClient *)clientSharedInstance;

+(NSString *)toJsonString:(NSDictionary *) dict;
+(NSString *)displayTime:(NSDate *)fromDate;
+(NSString*)today;


@end
