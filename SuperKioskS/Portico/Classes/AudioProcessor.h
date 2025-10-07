//
//  AudioProcessor.h
//  MicInput
//
//  Created by Stefan Popp on 21.09.11.
//  Copyright 2011 http://http://www.stefanpopp.de/2011/capture-iphone-microphone//2011/capture-iphone-microphone/ . All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>
@class CAudioBuffer;
// return max value for given values
#define max(a, b) (((a) > (b)) ? (a) : (b))
// return min value for given values
#define min(a, b) (((a) < (b)) ? (a) : (b))

#define kOutputBus 0
#define kInputBus 1

// our default sample rate
#define SAMPLE_RATE 44100.00

@interface AudioProcessor : NSObject
{
    // Audio unit
    AudioComponentInstance audioUnit;
    
    // Audio buffers
	AudioBuffer audioBuffer;
    
    // Audio buffers
    //AudioBuffer audioBufferPlayback;
    
    // gain
    float gain;
    
    //TDAudioStream *audioStream;
   // TDSession *session;
    
}

@property (readonly) AudioBuffer audioBuffer;
@property (readonly) AudioBuffer audioBufferPlayback;
@property (strong,nonatomic) NSMutableArray *inputBuffers;

@property (readonly) AudioComponentInstance audioUnit;
@property (nonatomic) float gain;
@property (nonatomic) BOOL isPlaybackBufferEmpty;
@property (nonatomic) BOOL isReadingInput;


-(AudioProcessor*)init;
//-(AudioProcessor*)initWithSession:(TDSession *)tdsession;

-(void)initializeAudio;
-(void)processBuffer: (AudioBufferList*) audioBufferList;

//-(void)setPlaybackBufferDataSize:(UInt32) mDataSize;
//-(UInt32)getPlaybackBufferDataSize;

//-(AudioBuffer *)getPlaybackBuffer;

// control object
-(void)start;
-(void)stop;

// gain
-(void)setGain:(float)gainValue;
-(float)getGain;

// error managment
//-(void)hasError:(int)statusCode:(char*)file:(int)line;
-(void)hasError:(int)statusCode file:(char*)file line:(int)line;

@end
