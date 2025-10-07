//
//  CAudio.h
//  TDAudioStreamer
//
//  Created by Romulo Quidilig on 3/2/15.
//  Copyright (c) 2015 Sharecle Inc. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>


@interface CAudioBuffer:NSObject

@property(nonatomic,strong) NSData *mData;
@property(nonatomic) UInt32 mDataByteSize;
@property(nonatomic) UInt32 mNumberChannels;


-(instancetype)initWithAudioBuffer:(AudioBuffer) audioBuffer;

@end