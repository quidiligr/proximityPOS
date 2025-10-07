//
//  MyAudioWindow.m
//  MicInput
//
//  Created by Stefan Popp on 21.10.11.
//  Copyright (c) 2011 http://www.stefanpopp.de/2011/capture-iphone-microphone/ . All rights reserved.
//

#import "MyAudioViewController.h"
#import "AudioProcessor.h"
/*#import "TDAudioStreamer.h"
#import "TDAudioInputStreamer.h"
#import "TDAudioOutputStreamer.h"
*/
 #import "CAudioBuffer.h"

//#import <CFNetwork/CFNetwork.h>
//#import <netinet/in.h>
#import "AppDelegate.h"

@interface MyAudioViewController ()

@property (nonatomic, strong) AppDelegate *appDelegate;

//-(void)sendMyMessage;
-(void)didReceiveVoiceDataWithNotification:(NSNotification *)notification;
-(void)didReceiveControlDataWithNotification:(NSNotification *)notification;

@end

@implementation MyAudioViewController

@synthesize topLabel;
@synthesize audioSwitch, gainValueLabel, audioProcessor;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor=[UIColor clearColor];
    
  /*  self.session = [[TDSession alloc] initWithPeerDisplayName:[UIDevice currentDevice].name];
    
    [self.session startAdvertisingForServiceType:@"dance-party" discoveryInfo:nil];
    self.session.delegate = self;
    
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(peerDidChangeStateWithNotification:) name:NOTIFY_MCDIDCHANGESTATE object:nil];
    
  */
    
    _appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    //_txtMessage.delegate = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didReceiveVoiceDataWithNotification:)
                                                 name:@"MCDidReceiveVoiceDataNotification"
                                               object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveMicInputNotification:) name:@"DidReceiveMicInputNotification" object:nil];
    
  //  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveInputStreamNotification:) name:@"DidReceiveInputStreamNotification" object:nil];

   
}

- (void)viewDidUnload
{
    [self setAudioSwitch:nil];
    [self setGainValueLabel:nil];
    [self setTopLabel:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark Gain control

// gain factor += 1
- (IBAction)riseGain:(id)sender {
    if (audioProcessor == nil) return;
    [audioProcessor setGain: [audioProcessor getGain]+1.0f];
    [self setGainLabelValue:[audioProcessor getGain]];
}

// gain factor -= 1
- (IBAction)lowerGain:(id)sender {
    if (audioProcessor == nil) return;
    [audioProcessor setGain: [audioProcessor getGain]-1.0f];
    [self setGainLabelValue:[audioProcessor getGain]];
}

#pragma mark AU control

/*
 Switchtes AudioUnit from AudioProcessor on and off.
 Checks if processor exists. If not it will initialized.
 
 Nevermind that indicator and label stuff. I like it a bit fancy ;)
 */
- (IBAction)audioSwitch:(id)sender {
    if (!audioSwitch.on) {
        [self showLabelWithText:@"Stopping AudioUnit"];
        if (audioProcessor)
            [audioProcessor stop];
        [self showLabelWithText:@"AudioUnit stopped"];
        
       /* if (self.outputStreamer){
            
          [self.outputStreamer stop];
            
        }*/
        
    } else {
        
        
       /* NSArray *peers = [self.session connectedPeers];

        if (peers.count) {
            
            if (!self.outputStreamer){
                
                self.outputStreamer = [[TDAudioOutputStreamer alloc] initWithOutputStream:[self.session outputStreamForPeer:peers[0]]];
                //[self.outputStreamer streamAudioFromURL:[self.song valueForProperty:MPMediaItemPropertyAssetURL]];
              
            }
           
            [self.outputStreamer start];
            */
            if (audioProcessor == nil) {
                audioProcessor = [[AudioProcessor alloc] init];
            }
            [self showLabelWithText:@"Starting up AudioUnit"];
            [audioProcessor start];

            
      //  }
        
        [self showLabelWithText:@"AudioUnit running"];
        
        
    }
    [self performSelector:@selector(showLabelWithText:) withObject:@"" afterDelay:3.5];
}
-(void)toggleAudioSwitchOFF{
    
}

#pragma mark Labels

// set gain label text value by given float
- (void)setGainLabelValue:(float)gainValue {
    NSString *gain = [NSString stringWithFormat:@"%d", (int)gainValue];
    [gainValueLabel setText:gain];
}

- (void)showLabelWithText:(NSString*)labelText {
    [topLabel setText:labelText];
}

#pragma mark -delegate implemtation
-(void)session:(MCSession *)session didReceiveStream:(NSInputStream *)stream withName:(NSString *)streamName fromPeer:(MCPeerID *)peerID{
}


#pragma mark - Private method implementation

//-(void)peerDidChangeStateWithNotification:(NSNotification *)notification{
//   /* MCPeerID *peerID = [[notification userInfo] objectForKey:@"peerID"];
//    NSString *peerDisplayName = peerID.displayName;
//    */
//    MCSessionState state = [[[notification userInfo] objectForKey:@"state"] intValue];
//    
//    if (state != MCSessionStateConnecting) {
//        if (state == MCSessionStateConnected) {
//            //[_arrConnectedDevices addObject:peerDisplayName];
//            NSArray *peers = [self.session connectedPeers];
//          //  if (peers.count) {
//            if (!self.outputStreamer){
//                
//                self.outputStreamer = [[TDAudioOutputStreamer alloc] initWithOutputStream:[self.session outputStreamForPeer:peers[0]]];
//                //[self.outputStreamer streamAudioFromURL:[self.song valueForProperty:MPMediaItemPropertyAssetURL]];
//            }
//            
//            [self.outputStreamer start];
//          //  }
//        }
//        else if (state == MCSessionStateNotConnected){
//            /*if ([_arrConnectedDevices count] > 0) {
//                int indexOfPeer = [_arrConnectedDevices indexOfObject:peerDisplayName];
//                [_arrConnectedDevices removeObjectAtIndex:indexOfPeer];
//            }
//             */
//            /* [audioSwitch setOn:NO animated:YES];
//            
//            if(audioProcessor){
//                [self showLabelWithText:@"Stopping AudioUnit"];
//                [audioProcessor stop];
//                [self showLabelWithText:@"AudioUnit stopped"];
//            }
//            */
//            if(self.outputStreamer)
//                [self.outputStreamer stop];
//             
//        }
//       /* [_tblConnectedDevices reloadData];
//        
//        BOOL peersExist = ([[_appDelegate.mcManager.session connectedPeers] count] == 0);
//        [_btnDisconnect setEnabled:!peersExist];
//        [_txtName setEnabled:peersExist];
//        */
//    }
//}

//- (void)session:(TDSession *)session didReceiveData:(NSData *)data
//{
//    /*NSDictionary *info = [NSKeyedUnarchiver unarchiveObjectWithData:data];
//    [self performSelectorOnMainThread:@selector(changeSongInfo:) withObject:info waitUntilDone:NO];
//     */
//}

#pragma mark -notification
-(void) didReceiveMicInputNotification: (NSNotification *) notification{
/*    NSValue *obj=[notification object];
    AudioBuffer sourceBuffer;

    [obj getValue:&sourceBuffer];
    
    if(self.outputStreamer)
        //[self.outputStreamer streamAudioFromMic:&sourceBuffer];
        [self.outputStreamer ]
  */
    
    //this works don't erase
    /*
     AudioBuffer *audioBufferPlayback=[self.audioProcessor getPlaybackBuffer];
    if (audioBufferPlayback->mDataByteSize != sourceBuffer.mDataByteSize) {
        free(audioBufferPlayback->mData);
        audioBufferPlayback->mDataByteSize = sourceBuffer.mDataByteSize;
        audioBufferPlayback->mData = malloc(sourceBuffer.mDataByteSize);
    }
    
    memcpy(audioBufferPlayback->mData, sourceBuffer.mData, sourceBuffer.mDataByteSize);
    */
        //if(self.outputStreamer){
    
    /*
    if(self.outputStreamm){
        CAudioBuffer *sourceBuffer=[notification object];

        //[self.outputStreamer addQueue:sourceBuffer];
        [self.outputQueue addObject:sourceBuffer];
    }
     */
    
    //NSData *dataToSend = [_txtMessage.text dataUsingEncoding:NSUTF8StringEncoding];
    
    
    NSArray *allPeers = _appDelegate.mcManager.session.connectedPeers;
    
    //assert([allPeers count]>0);
    
    if(allPeers.count>0){
       
          CAudioBuffer *sourceBuffer=[notification object];
        NSMutableData *tmpData=[NSMutableData dataWithBytes:"\x1" length:1];
        [tmpData appendData:sourceBuffer.mData];
        
       // dispatch_async(dispatch_get_main_queue(), ^{
             NSError *error;
           /* [_appDelegate.mcManager.session  sendData:sourceBuffer.mData
                                              toPeers:allPeers
                                             withMode:MCSessionSendDataUnreliable
                                                error:&error];*/
        [_appDelegate.mcManager.session sendData:tmpData
                                         toPeers:allPeers
                                        withMode:MCSessionSendDataUnreliable
                                           error:&error];

            if (error) {
                NSLog(@"%@", [error localizedDescription]);
            }
      //  });
        
       
        
        
    
    
    }
    /*
    [_tvChat setText:[_tvChat.text stringByAppendingString:[NSString stringWithFormat:@"I wrote:\n%@\n\n", _txtMessage.text]]];
    [_txtMessage setText:@""];
    [_txtMessage resignFirstResponder];
    */

}

-(void) didReceiveInputStreamNotification: (NSNotification *) notification{
    
 
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
//    if([self.audioProcessor isReadingInput]==NO){
//        
//        [self.audioProcessor.inputBuffers addObject:sourceBuffer];
//    }
  //  [NSThread sleepForTimeInterval:0.5];
    [self.audioProcessor.inputBuffers addObject:sourceBuffer];
  
    //NSLog(@"input queue %lu",(unsigned long)self.audioProcessor.inputBuffers.count);
}
/*

- (void)session:(TDSession *)session didReceiveMusicStream:(NSInputStream *)stream
{
    if (!self.inputStream) {
        self.inputStream = [[TDAudioInputStreamer alloc] initWithInputStream:stream];
        [self.inputStream start];
    }
}

- (void)session:(TDSession *)session didReceiveAudioStream:(NSInputStream *)stream
{
    if (!self.inputStream) {
        self.inputStream = [[TDAudioInputStreamer alloc] initWithInputStream:stream];
        [self.inputStream start];
    }
}
*/
#pragma mark - IBAction method implementation

- (IBAction)sendMessage:(id)sender {
  //  [self sendMyVoice];
}

- (IBAction)cancelMessage:(id)sender {
    //[_txtMessage resignFirstResponder];
}


#pragma mark - Private method implementation

-(void)sendMyVoice{
 /*   NSData *dataToSend = [_txtMessage.text dataUsingEncoding:NSUTF8StringEncoding];
    NSArray *allPeers = _appDelegate.mcManager.session.connectedPeers;
    NSError *error;
    
    [_appDelegate.mcManager.session sendData:dataToSend
                                     toPeers:allPeers
                                    withMode:MCSessionSendDataReliable
                                       error:&error];
    
    if (error) {
        NSLog(@"%@", [error localizedDescription]);
    }
    
    [_tvChat setText:[_tvChat.text stringByAppendingString:[NSString stringWithFormat:@"I wrote:\n%@\n\n", _txtMessage.text]]];
    [_txtMessage setText:@""];
    [_txtMessage resignFirstResponder];
  */
}


-(void)didReceiveVoiceDataWithNotification:(NSNotification *)notification{
  //  MCPeerID *peerID = [[notification userInfo] objectForKey:@"peerID"];
 //   NSString *peerDisplayName = peerID.displayName;
    
  //  NSData *receivedData = [[notification userInfo] objectForKey:@"data"];
 //   NSString *receivedText = [[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding];
    
    //[_tvChat performSelectorOnMainThread:@selector(setText:) withObject:[_tvChat.text stringByAppendingString:[NSString stringWithFormat:@"%@ wrote:\n%@\n\n", peerDisplayName, receivedText]] waitUntilDone:NO];
    if(audioSwitch.on){
    CAudioBuffer *sourceBuffer=[[CAudioBuffer alloc] init];// [notification object];
    sourceBuffer.mData=[[notification userInfo] objectForKey:@"data"];
    sourceBuffer.mDataByteSize=(int)sourceBuffer.mData.length;
    sourceBuffer.mNumberChannels=1;
    //@synchronized(self.audioProcessor.inputBuffers ){
        [self.audioProcessor.inputBuffers addObject:sourceBuffer];
    }
    //}
    //[self.audioProcessor.inputBuffers performSelectorOnMainThread:@selector(addObject:) withObject:sourceBuffer waitUntilDone:NO];
}

-(void)didReceiveControlDataWithNotification:(NSNotification *)notification{
    //MCPeerID *peerID = [[notification userInfo] objectForKey:@"peerID"];
    //NSString *peerDisplayName = peerID.displayName;
    //NSUInteger msgid = (NSInteger)[[notification userInfo] objectForKey:@"msgid"];
    NSData *receivedData = [[notification userInfo] objectForKey:@"data"];
    
    
    NSString *receivedText = [[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding];
    if([receivedText isEqualToString:@"BYE"]){
        
    }
    //[_tvChat performSelectorOnMainThread:@selector(setText:) withObject:[_tvChat.text stringByAppendingString:[NSString stringWithFormat:@"%@ wrote:\n%@\n\n", peerDisplayName, receivedText]] waitUntilDone:NO];

}


#pragma mark - View Actions

- (IBAction)invite:(id)sender
{
    //[self presentViewController:[self.session browserViewControllerForSeriviceType:@"dance-party"] animated:YES completion:nil];
    //[self connect];
}



#pragma mark cleanup

- (void)dealloc {
   /* [audioProcessor release];
    [audioSwitch release];
    [gainValueLabel release];
    [topLabel release];
    [super dealloc];
    */
}

@end
