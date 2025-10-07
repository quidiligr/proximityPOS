//
//  AudioProcessor.m
//  MicInput
//
//  Created by Stefan Popp on 21.09.11.
//  Copyright 2011 http://www.stefanpopp.de/2011/capture-iphone-microphone/ . All rights reserved.
//

#import "AudioProcessor.h"
#import "CAudioBuffer.h"
//#import <AudioToolbox/AudioServices.h>
#import <AVFoundation/AVFoundation.h>
#pragma mark Recording callback

static OSStatus recordingCallback(void *inRefCon, 
                                  AudioUnitRenderActionFlags *ioActionFlags, 
                                  const AudioTimeStamp *inTimeStamp, 
                                  UInt32 inBusNumber, 
                                  UInt32 inNumberFrames, 
                                  AudioBufferList *ioData) {
	
	// the data gets rendered here
    AudioBuffer buffer;
    
    // a variable where we check the status
    OSStatus status;
    
    /**
     This is the reference to the object who owns the callback.
     */
   // AudioProcessor *audioProcessor = (AudioProcessor*) inRefCon;
    
    AudioProcessor *audioProcessor = (__bridge AudioProcessor*) inRefCon;
    
    /**
     on this point we define the number of channels, which is mono
     for the iphone. the number of frames is usally 512 or 1024.
     */
    buffer.mDataByteSize = inNumberFrames * 2; // sample size
    buffer.mNumberChannels = 1; // one channel
	buffer.mData = malloc( inNumberFrames * 2 ); // buffer size
	
    // we put our buffer into a bufferlist array for rendering
	AudioBufferList bufferList;
	bufferList.mNumberBuffers = 1;
	bufferList.mBuffers[0] = buffer;
    
    // render input and check for error
    status = AudioUnitRender([audioProcessor audioUnit], ioActionFlags, inTimeStamp, inBusNumber, inNumberFrames, &bufferList);
    [audioProcessor hasError:status file:__FILE__ line:__LINE__];
    
	// process the bufferlist in the audio processor
    [audioProcessor processBuffer:&bufferList];
	
    // clean up the buffer
	free(bufferList.mBuffers[0].mData);
	
    return noErr;
}

#pragma mark Playback callback

static OSStatus playbackCallback(void *inRefCon,
								 AudioUnitRenderActionFlags *ioActionFlags, 
								 const AudioTimeStamp *inTimeStamp, 
								 UInt32 inBusNumber, 
								 UInt32 inNumberFrames, 
								 AudioBufferList *ioData) {    

    /**
     This is the reference to the object who owns the callback.
     */
    //AudioProcessor *audioProcessor = (AudioProcessor*) inRefCon;
    
    AudioProcessor *audioProcessor = (__bridge AudioProcessor*) inRefCon;
    audioProcessor.isReadingInput=YES;
 /*   // iterate over incoming stream an copy to output stream
    for (int i=0; i < ioData->mNumberBuffers; i++) {
        AudioBuffer buffer = ioData->mBuffers[i];
        
        // find minimum size
        UInt32 size = min(buffer.mDataByteSize, [audioProcessor audioBuffer].mDataByteSize);
        
        // copy buffer to audio buffer which gets played after function return
        memcpy(buffer.mData, [audioProcessor audioBuffer].mData, size);
        
        // set data size
        buffer.mDataByteSize = size;
    }
    return noErr;
*/
   //  @synchronized(audioProcessor.inputBuffers ){
    if ([audioProcessor inputBuffers].count>0) {
        CAudioBuffer *audioBufferPlayback=[[audioProcessor inputBuffers] objectAtIndex:0];

        
        for (int i=0; i < ioData->mNumberBuffers; i++) {
            AudioBuffer buffer = ioData->mBuffers[i];
            
            // find minimum size
            UInt32 size = min(buffer.mDataByteSize, audioBufferPlayback.mDataByteSize);
            
            // copy buffer to audio buffer which gets played after function return
            
           // memcpy(buffer.mData, (SInt16 *)[audioBufferPlayback.mData bytes], size);
             memcpy(buffer.mData, [audioBufferPlayback.mData bytes], size);
            
            
            // set data size
            buffer.mDataByteSize = size;
            
            
            
        }
       
            [[audioProcessor inputBuffers] removeObjectAtIndex:0];
        
    }
    else{
        /*
         we set the number of channels to mono and allocate our block size to
         1024 bytes.
         */
        /*audioBuffer.mNumberChannels = 1;
        audioBuffer.mDataByteSize = 512 * 2;
        audioBuffer.mData = malloc( 512 * 2 );
        */
        for (int i=0; i < ioData->mNumberBuffers; i++) {
            AudioBuffer buffer = ioData->mBuffers[i];
            
                        buffer.mData=0;
            buffer.mDataByteSize= 512 * 2;
            buffer.mNumberChannels=1;
        }
        
        /*for (int i=0; i < ioData->mNumberBuffers; i++) {
            AudioBuffer buffer = ioData->mBuffers[i];
            
            // find minimum size
            UInt32 size = min(buffer.mDataByteSize, [audioProcessor audioBuffer].mDataByteSize);
            
            // copy buffer to audio buffer which gets played after function return
            memcpy(buffer.mData, [audioProcessor audioBuffer].mData, size);
            
            // set data size
            buffer.mDataByteSize = size;
        }
         */
    }
   //  }
    //audioProcessor.isReadingInput=NO;
    return noErr;
}




#pragma mark objective-c class

@implementation AudioProcessor
@synthesize audioUnit,gain,audioBuffer;

-(AudioProcessor*)init
{
    self = [super init];
    if (self) {
        gain = 0;
        self.isPlaybackBufferEmpty=YES;

        _inputBuffers=[[NSMutableArray alloc] init];
        [self initializeAudio];
    }
    return self;
}
/*
-(AudioProcessor*)initWithSession:(TDSession *)tdsession
{
    self = [super init];
    if (self) {
        gain = 0;
        session=tdsession;
        [self initializeAudio];
    }
    return self;
}
*/


-(void)initializeAudio
{
   /* UInt32 audioCategory = kAudioSessionCategory_PlayAndRecord;
    if(AudioSessionSetProperty(kAudioSessionProperty_AudioCategory,
                               sizeof(UInt32), &audioCategory) != noErr) {
        return 1;
    }
    
    UInt32 overrideCategory = 1;
    if(AudioSessionSetProperty(kAudioSessionProperty_OverrideCategoryDefaultToSpeaker,
                               sizeof(UInt32), &overrideCategory) != noErr) {
        // Less serious error, but you may want to handle it and bail here
    }
   */
  //  [self initAudioSession];
    
    OSStatus status;
	
	// We define the audio component
	AudioComponentDescription desc;
	desc.componentType = kAudioUnitType_Output; // we want to ouput
    desc.componentSubType = kAudioUnitSubType_VoiceProcessingIO; //kAudioUnitSubType_RemoteIO; // we want in and ouput
	desc.componentFlags = 0; // must be zero
	desc.componentFlagsMask = 0; // must be zero
	desc.componentManufacturer = kAudioUnitManufacturer_Apple; // select provider
	
	// find the AU component by description
	AudioComponent inputComponent = AudioComponentFindNext(NULL, &desc);
	
	// create audio unit by component
	status = AudioComponentInstanceNew(inputComponent, &audioUnit);
    
	//[self hasError:status:__FILE__:__LINE__];
     [self hasError:status file:__FILE__ line:__LINE__];
	
    // define that we want record io on the input bus
    UInt32 flag = 1;
    
    UInt32 inputFlag = 1;
    UInt32 outputFlag = 1;
   
	status = AudioUnitSetProperty(audioUnit, 
								  kAudioOutputUnitProperty_EnableIO, // use io
								  kAudioUnitScope_Input, // scope to input
								  kInputBus, // select input bus (1)
								  &inputFlag, // set flag
								  sizeof(inputFlag));
	//self hasError:status:__FILE__:__LINE__];
	 [self hasError:status file:__FILE__ line:__LINE__];
    
	// define that we want play on io on the output bus
	status = AudioUnitSetProperty(audioUnit, 
								  kAudioOutputUnitProperty_EnableIO, // use io
								  kAudioUnitScope_Output, // scope to output
								  kOutputBus, // select output bus (0)
								  &outputFlag, // set flag
								  sizeof(outputFlag));
	//[self hasError:status:__FILE__:__LINE__];
	 [self hasError:status file:__FILE__ line:__LINE__];
	/* 
     We need to specifie our format on which we want to work.
     We use Linear PCM cause its uncompressed and we work on raw data.
     for more informations check.
     
     We want 16 bits, 2 bytes per packet/frames at 44khz 
     */
	AudioStreamBasicDescription audioFormat;
	audioFormat.mSampleRate			= SAMPLE_RATE;
    audioFormat.mFormatID			= kAudioFormatLinearPCM;
	audioFormat.mFormatFlags		= kAudioFormatFlagIsPacked | kAudioFormatFlagIsSignedInteger;
	audioFormat.mFramesPerPacket	= 1;
	audioFormat.mChannelsPerFrame	= 1;
	audioFormat.mBitsPerChannel		= 16;
	audioFormat.mBytesPerPacket		= 2;
	audioFormat.mBytesPerFrame		= 2;
    
    
    
	// set the format on the output stream
	status = AudioUnitSetProperty(audioUnit, 
								  kAudioUnitProperty_StreamFormat, 
								  kAudioUnitScope_Output, 
								  kInputBus, 
								  &audioFormat, 
								  sizeof(audioFormat));
    
	//[self hasError:status:__FILE__:__LINE__];
     [self hasError:status file:__FILE__ line:__LINE__];
    
    // set the format on the input stream
	status = AudioUnitSetProperty(audioUnit, 
								  kAudioUnitProperty_StreamFormat, 
								  kAudioUnitScope_Input, 
								  kOutputBus, 
								  &audioFormat, 
								  sizeof(audioFormat));
	//[self hasError:status:__FILE__:__LINE__];
	 [self hasError:status file:__FILE__ line:__LINE__];
	
	
    /**
        We need to define a callback structure which holds
        a pointer to the recordingCallback and a reference to
        the audio processor object
     */
	AURenderCallbackStruct callbackStruct;
    
    // set recording callback
	callbackStruct.inputProc = recordingCallback; // recordingCallback pointer
    //callbackStruct.inputProcRefCon = self;
	callbackStruct.inputProcRefCon = (__bridge void *)(self);

    // set input callback to recording callback on the input bus
	status = AudioUnitSetProperty(audioUnit, 
                                  kAudioOutputUnitProperty_SetInputCallback, 
								  kAudioUnitScope_Global, 
								  kInputBus, 
								  &callbackStruct, 
								  sizeof(callbackStruct));
    
    //[self hasError:status:__FILE__:__LINE__];
	 [self hasError:status file:__FILE__ line:__LINE__];
    /*
     We do the same on the output stream to hear what is coming
     from the input stream
     */
	callbackStruct.inputProc = playbackCallback;
    //callbackStruct.inputProcRefCon = self;
	callbackStruct.inputProcRefCon = (__bridge void *)(self);
    
    // set playbackCallback as callback on our renderer for the output bus
	status = AudioUnitSetProperty(audioUnit, 
								  kAudioUnitProperty_SetRenderCallback, 
								  kAudioUnitScope_Global, 
								  kOutputBus,
								  &callbackStruct, 
								  sizeof(callbackStruct));
	//[self hasError:status:__FILE__:__LINE__];
	 [self hasError:status file:__FILE__ line:__LINE__];
    
    // reset flag to 0
	flag = 0;
    
    /*
     we need to tell the audio unit to allocate the render buffer,
     that we can directly write into it.
     */
	status = AudioUnitSetProperty(audioUnit, 
								  kAudioUnitProperty_ShouldAllocateBuffer,
								  kAudioUnitScope_Output, 
								  kInputBus,
								  &flag, 
								  sizeof(flag));
	

    /*
     we set the number of channels to mono and allocate our block size to
     1024 bytes.
    */
	audioBuffer.mNumberChannels = 1;
	audioBuffer.mDataByteSize = 512 * 2;
	audioBuffer.mData = malloc( 512 * 2 );
    /*
    audioBufferPlayback.mNumberChannels = 1;
    audioBufferPlayback.mDataByteSize = 512 * 2;
    audioBufferPlayback.mData = malloc( 512 * 2 );
*/
	
	// Initialize the Audio Unit and cross fingers =)
	status = AudioUnitInitialize(audioUnit);
	//[self hasError:status:__FILE__:__LINE__];
     [self hasError:status file:__FILE__ line:__LINE__];
    
   //  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveInputStreamNotification:) name:@"DidReceiveInputStreamNotification" object:nil];
    #ifdef DEBUG
    NSLog(@"initializeAudio...done");
#endif
    
}

-(void) initAudioSession {
    //audioUnit = (AudioUnit*)malloc(sizeof(AudioUnit));
    /*depracated
    if(AudioSessionInitialize(NULL, NULL, NULL, NULL) != noErr) {
        return 1;
    }
    
    if(AudioSessionSetActive(true) != noErr) {
        return 1;
    }
    
    UInt32 sessionCategory = kAudioSessionCategory_PlayAndRecord;
    if(AudioSessionSetProperty(kAudioSessionProperty_AudioCategory,
                               sizeof(UInt32), &sessionCategory) != noErr) {
        return 1;
    }
    
    Float32 bufferSizeInSec = 0.02f;
    if(AudioSessionSetProperty(kAudioSessionProperty_PreferredHardwareIOBufferDuration,
                               sizeof(Float32), &bufferSizeInSec) != noErr) {
        return 1;
    }
    
    UInt32 overrideCategory = 1;
    if(AudioSessionSetProperty(kAudioSessionProperty_OverrideCategoryDefaultToSpeaker,
                               sizeof(UInt32), &overrideCategory) != noErr) {
        return 1;
    }
    
    // There are many properties you might want to provide callback functions for:
    // kAudioSessionProperty_AudioRouteChange
    // kAudioSessionProperty_OverrideCategoryEnableBluetoothInput
    // etc.
    */
    NSError *error = nil;
    if (![[[AVAudioSession sharedInstance] category] isEqualToString:AVAudioSessionCategoryPlayAndRecord]) {
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord withOptions:(AVAudioSessionCategoryOptionDefaultToSpeaker | AVAudioSessionCategoryOptionAllowBluetooth | AVAudioSessionCategoryOptionMixWithOthers) error:&error];
        #ifdef DEBUG
        NSLog(@"setCategory error = %@", error);
#endif
        //[[AVAudioSession sharedInstance] setActive:YES error:&error];
        //NSLog(@"setActive error = %@", error);
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self
     
                                             selector:@selector(handleRouteChange:)
     
                                                 name:AVAudioSessionRouteChangeNotification
     
                                               object:[AVAudioSession sharedInstance]];

   // return 0;
}

#pragma mark AVAudioSession notification handlers

- (void)handleRouteChange:(NSNotification *)notification
{
//    UInt8 reasonValue = [[notification.userInfo valueForKey:AVAudioSessionRouteChangeReasonKey] intValue];
//    //AVAudioSessionRouteDescription *routeDescription = [notification.userInfo valueForKey:AVAudioSessionRouteChangePreviousRouteKey];
//    #ifdef DEBUG
//    NSLog(@"Route change:");
//
//    switch (reasonValue) {
//        case AVAudioSessionRouteChangeReasonNewDeviceAvailable:
//            NSLog(@"     NewDeviceAvailable");
//            break;
//        case AVAudioSessionRouteChangeReasonOldDeviceUnavailable:
//           // [self pausePlaybackForPlayer:_dataModel.publicPlayer];
//           
//            NSLog(@"     OldDeviceUnavailable");
//
//            break;
//        case AVAudioSessionRouteChangeReasonCategoryChange:
//            NSLog(@"     CategoryChange");
//            NSLog(@" New Category: %@", [[AVAudioSession sharedInstance] category]);
//            break;
//        case AVAudioSessionRouteChangeReasonOverride:
//            NSLog(@"     Override");
//            break;
//        case AVAudioSessionRouteChangeReasonWakeFromSleep:
//            NSLog(@"     WakeFromSleep");
//            break;
//        case AVAudioSessionRouteChangeReasonNoSuitableRouteForCategory:
//            NSLog(@"     NoSuitableRouteForCategory");
//            break;
//        default:
//            NSLog(@"     ReasonUnknown");
//    }
//#endif
//   // NSLog(@"Previous route:\n");
//    //NSLog(@"%@", routeDescription);
}

/*
-(void)initializeAudioStream
{
}
*/
/*
-(void)audioStream:(TDAudioStream *)audioStream didRaiseEvent:(TDAudioStreamEvent)event{
    switch (event) {
        case TDAudioStreamEventWantsData:
            //[self sendDataChunk];
            _streamHasSpaceAvailable=NO;
            break;
            
        case TDAudioStreamEventError:
            // TODO: shit!
            NSLog(@"Stream Error");
            break;
            
        case TDAudioStreamEventEnd:
            // TODO: shit!
            NSLog(@"Stream Ended");
            break;
            
        default:
            break;
    }

    
}
 */
#pragma mark controll stream

-(void)start;
{
    // start the audio unit. You should hear something, hopefully :)
    OSStatus status = AudioOutputUnitStart(audioUnit);
    //[self hasError:status:__FILE__:__LINE__];
     [self hasError:status file:__FILE__ line:__LINE__];
}
-(void)stop;
{
    // stop the audio unit
    OSStatus status = AudioOutputUnitStop(audioUnit);
    //[self hasError:status:__FILE__:__LINE__];
     [self hasError:status file:__FILE__ line:__LINE__];
}



-(void)setGain:(float)gainValue 
{
    gain = gainValue;
}

-(float)getGain
{
    return gain;
}
/*
-(void)setPlaybackBufferDataSize:(UInt32) mDataSize{
    audioBufferPlayback.mDataByteSize=mDataSize;
}

-(UInt32)getPlaybackBufferDataSize{
    return audioBufferPlayback.mDataByteSize;
}

-(AudioBuffer *)getPlaybackBuffer{
    return &audioBufferPlayback;
}
*/
#pragma mark processing

-(void)processBuffer: (AudioBufferList*) audioBufferList
{
    AudioBuffer sourceBuffer = audioBufferList->mBuffers[0];
    
    // we check here if the input data byte size has changed
	if (audioBuffer.mDataByteSize != sourceBuffer.mDataByteSize) {
        // clear old buffer
		free(audioBuffer.mData);
        // assing new byte size and allocate them on mData
		audioBuffer.mDataByteSize = sourceBuffer.mDataByteSize;
		audioBuffer.mData = malloc(sourceBuffer.mDataByteSize);
	}
    
    /**
     Here we modify the raw data buffer now. 
     In my example this is a simple input volume gain.
     iOS 5 has this on board now, but as example quite good.
     */
    
  //  SInt16 *bytes=(SInt16 *)[tmpCBuffer.mData bytes];
    
//    SInt16 *editBuffer = sourceBuffer.mData;
////    
////    // loop over every packet
//    for (int nb = 0; nb < (sourceBuffer.mDataByteSize / 2); nb++) {
//       // NSLog(@"editBuffer[%d]=%hd",nb,editBuffer[nb]);
//       // NSLog(@"bytes[%d]=%hd",nb,bytes[nb]);
//
//        // we check if the gain has been modified to save resoures
//        if (gain != 0) {
//            // we need more accuracy in our calculation so we calculate with doubles
//        
//            double gainSample = ((double)editBuffer[nb]) / 32767.0;
//
//            /*
//            at this point we multiply with our gain factor
//            we dont make a addition to prevent generation of sound where no sound is.
//             
//             no noise
//             0*10=0
//             
//             noise if zero
//             0+10=10 
//            */
//            gainSample *= gain;
//            
//            /**
//             our signal range cant be higher or lesser -1.0/1.0
//             we prevent that the signal got outside our range
//             */
//            gainSample = (gainSample < -1.0) ? -1.0 : (gainSample > 1.0) ? 1.0 : gainSample;
//            
//            /*
//             This thing here is a little helper to shape our incoming wave.
//             The sound gets pretty warm and better and the noise is reduced a lot.
//             Feel free to outcomment this line and here again.
//             
//             You can see here what happens here http://silentmatt.com/javascript-function-plotter/
//             Copy this to the command line and hit enter: plot y=(1.5*x)-0.5*x*x*x
//             */
//             
//            gainSample = (1.5 * gainSample) - 0.5 * gainSample * gainSample * gainSample;
//            
//            // multiply the new signal back to short 
//            gainSample = gainSample * 32767.0;
//            
//            // write calculate sample back to the buffer
//            editBuffer[nb] = (SInt16)gainSample;
//        }
//    }
    
    // copy incoming audio data to the audio buffer
    memcpy(audioBuffer.mData, audioBufferList->mBuffers[0].mData, audioBufferList->mBuffers[0].mDataByteSize);
    
    
    CAudioBuffer *tmpCBuffer=[[CAudioBuffer alloc] initWithAudioBuffer:audioBuffer];
    
    //CAudioBuffer *tmpCBuffer=[[CAudioBuffer alloc] initWithAudioBuffer:sourceBuffer];
    
    //[_audioBuffers addObject:tmpCBuffer];
    
    
     [[NSNotificationCenter defaultCenter] postNotificationName:@"DidReceiveMicInputNotification" object:tmpCBuffer];
    
}

-(void) didReceiveInputStreamNotification: (NSNotification *) notification{
    
    
    /* NSValue *obj =[notification object];
     
     [obj getValue:&sourceBuffer];
     */
    CAudioBuffer *sourceBuffer=[notification object];
    
    
    
    // [obj getValue:&sourceBuffer];
    
    /*AudioBuffer audioBufferPlayback=self.audioProcessor.audioBufferPlayback;
     
     UInt32 size = min(audioBufferPlayback.mDataByteSize, audioBuffer.mDataByteSize);
     
     memcpy(audioBufferPlayback.mData, audioBuffer.mData, size);
     audioBufferPlayback.mDataByteSize=size;//[self.audioProcessor setPlaybackBufferDataSize:size];
     */
    /*
     AudioBuffer *audioBufferPlayback=[self.audioProcessor getPlaybackBuffer];
     if (audioBufferPlayback->mDataByteSize != sourceBuffer.mDataByteSize) {
     free(audioBufferPlayback->mData);
     audioBufferPlayback->mDataByteSize = sourceBuffer.mDataByteSize;
     audioBufferPlayback->mData = malloc(sourceBuffer.mDataByteSize);
     }
     
     memcpy(audioBufferPlayback->mData, sourceBuffer.mData, sourceBuffer.mDataByteSize);
     */
    /* AudioBuffer tmpBuffer;
     tmpBuffer.mData= malloc(sourceBuffer.mDataByteSize);
     tmpBuffer.mDataByteSize=sourceBuffer.mDataByteSize;
     tmpBuffer.mNumberChannels=1;//sourceBuffer.mNumberChannels;
     memcpy(tmpBuffer.mData, sourceBuffer.mData, sourceBuffer.mDataByteSize);
     NSValue *objB=[NSValue value:&tmpBuffer withObjCType:@encode(AudioBuffer)];
     */
    //if([self.audioProcessor isReadingInput]==NO){
//    dispatch_queue_t inputQueue = dispatch_queue_create("inputQueue",NULL);
//    dispatch_async(inputQueue, ^{
//        while (_inputBuffers.count>0) {
//            
//        }
//        
//      //  [_inputBuffers addObject:sourceBuffer];
///*
//        //NSURL *url = [NSURL URLWithString:urlString];
//        NSData *imageData=[_dataModel fileStoreGetSetData:message.imagefileuid contentType:message.imagefilecontenttype contentLength:message.imagefilelen isStream:NO];
//        UIImage *image = [UIImage imageWithData:imageData];
//        
//        //NSUInteger imageIndex = [images indexOfObject:urlString];
//        UIImageView *imageVIew =cell.imageAttach; //(UIImageView *)[self.view viewWithTag:imageIndex];
//        
//        if (!imageVIew) return;
//        */
//        dispatch_async(dispatch_get_main_queue(), ^{
//            // Update the UI
//          //  [imageVIew setImage:image];
//            [_inputBuffers addObject:sourceBuffer];
//             NSLog(@"input queue added%lu",(unsigned long)_inputBuffers.count);
//        });
//        
//    });
       // [_inputBuffers addObject:sourceBuffer];
    //}
    [NSThread sleepForTimeInterval:0.5];
    [_inputBuffers addObject:sourceBuffer];
    // NSLog(@"input queue %lu",(unsigned long)_inputBuffers.count);
   
}

//-(void)processBufferOutputPeer: (AudioBufferList*) audioBufferList
//{
//    /*AudioBuffer sourceBuffer = audioBufferList->mBuffers[0];
//    
//    // we check here if the input data byte size has changed
//	if (audioBuffer.mDataByteSize != sourceBuffer.mDataByteSize) {
//        // clear old buffer
//		free(audioBuffer.mData);
//        // assing new byte size and allocate them on mData
//		audioBuffer.mDataByteSize = sourceBuffer.mDataByteSize;
//		audioBuffer.mData = malloc(sourceBuffer.mDataByteSize);
//	}
//    */
//    /**
//     Here we modify the raw data buffer now.
//     In my example this is a simple input volume gain.
//     iOS 5 has this on board now, but as example quite good.
//     */
//   // SInt16 *editBuffer = audioBufferList->mBuffers[0].mData;
//   
//   /* [[NSNotificationCenter defaultCenter] postNotificationName:@"AUBufferOutputNotification" object:CFBridgingRelease(audioBufferList)];
//    */
//    /*for (NSUInteger i = 0; i < audioBufferList.mNumberBuffers; i++) {
//        AudioBuffer audioBuffer = audioBufferList.mBuffers[i];
//        [self.audioStream writeData:audioBuffer.mData maxLength:audioBuffer.mDataByteSize];
//        NSLog(@"buffer size: %u", (unsigned int)audioBuffer.mDataByteSize);
//    }*/
//    for (NSUInteger i = 0; i < audioBufferList->mNumberBuffers; i++) {
//        audioBuffer = audioBufferList->mBuffers[i];
//         [self.audioStream writeData:audioBuffer.mData maxLength:audioBuffer.mDataByteSize];
//    }
//    
//   /* for (int nb = 0; nb < (audioBufferList->mBuffers[0].mDataByteSize / 2); nb++) {
//        [self.audioStream writeData:sourceBuffer.mData maxLength:audioBuffer.mDataByteSize];
//        // we check if the gain has been modified to save resoures
//        if (gain != 0) {
//            // we need more accuracy in our calculation so we calculate with doubles
//            double gainSample = ((double)editBuffer[nb]) / 32767.0;
//            
//    
//             at this point we multiply with our gain factor
//             we dont make a addition to prevent generation of sound where no sound is.
//             
//             no noise
//             0*10=0
//             
//             noise if zero
//             0+10=10
//             */
//   //         gainSample *= gain;
//            
//            /**
//             our signal range cant be higher or lesser -1.0/1.0
//             we prevent that the signal got outside our range
//             */
//     //       gainSample = (gainSample < -1.0) ? -1.0 : (gainSample > 1.0) ? 1.0 : gainSample;
//            
//            /*
//             This thing here is a little helper to shape our incoming wave.
//             The sound gets pretty warm and better and the noise is reduced a lot.
//             Feel free to outcomment this line and here again.
//             
//             You can see here what happens here http://silentmatt.com/javascript-function-plotter/
//             Copy this to the command line and hit enter: plot y=(1.5*x)-0.5*x*x*x
//             */
//            
//       //     gainSample = (1.5 * gainSample) - 0.5 * gainSample * gainSample * gainSample;
//            
//            // multiply the new signal back to short
//         //   gainSample = gainSample * 32767.0;
//            
//            // write calculate sample back to the buffer
//           // editBuffer[nb] = (SInt16)gainSample;
//        //}
//   // }
//    
//	// copy incoming audio data to the audio buffer
//	//memcpy(audioBuffer.mData, audioBufferList->mBuffers[0].mData, audioBufferList->mBuffers[0].mDataByteSize);
//}

#pragma mark Error handling

-(void)hasError:(int)statusCode file:(char*)file line:(int)line
{
	if (statusCode) {
		printf("Error Code responded %d in file %s on line %d\n", statusCode, file, line);
        exit(-1);
	}
}


@end
