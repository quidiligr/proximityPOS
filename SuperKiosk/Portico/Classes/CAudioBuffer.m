//
//  CAudioBuffer.m
//  TDAudioStreamer
//
//  Created by Romulo Quidilig on 3/2/15.
//  Copyright (c) 2015 Sharecle Inc. All rights reserved.
//



#include "CAudioBuffer.h"


@implementation CAudioBuffer

-(instancetype)initWithAudioBuffer:(AudioBuffer)audioBuffer{
    self = [super init];
    if (!self) return nil;
    
    self.mData = [[NSData alloc] initWithBytes:audioBuffer.mData length:audioBuffer.mDataByteSize];
    self.mDataByteSize=audioBuffer.mDataByteSize;
    self.mNumberChannels=audioBuffer.mNumberChannels;
    
    
    return self;
    
}

@end
