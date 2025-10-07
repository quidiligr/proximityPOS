//
//  NSData+hex.h
//  MCDemo
//
//  Created by Romulo Quidilig on 3/22/15.
//  Copyright (c) 2015 Sharecle Inc. All rights reserved.
//


#import <Foundation/Foundation.h>

@interface UIImage (Resize)

+ (UIImage *)imageWithImage:(UIImage *)image
               scaledToSize:(CGSize)size;

+ (UIImage *)imageWithImage:(UIImage *)image
               scaledToSize:(CGSize)size
               cornerRadius:(CGFloat)cornerRadius;

+ (UIImage *)cropImageWithInfo:(NSDictionary *)info;

@end