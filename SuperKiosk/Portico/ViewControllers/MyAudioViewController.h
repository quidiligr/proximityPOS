//
//  MyAudioWindow.h
//  MicInput
//
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>
//#import <CFNetwork/CFNetwork.h>

//#import "TDSession.h"

@import MediaPlayer;
@import MultipeerConnectivity;
@import AVFoundation;
@class AudioProcessor;
//@class TDAudioOutputStreamer;
//@class TDAudioInputStreamer;
@class AppDelegate;


@interface MyAudioViewController : UIViewController <NSStreamDelegate>

@property (retain, nonatomic) IBOutlet UISwitch *audioSwitch;
@property (retain, nonatomic) IBOutlet UILabel *gainValueLabel;
@property (retain, nonatomic) AudioProcessor *audioProcessor;
@property (retain, nonatomic) IBOutlet UILabel *topLabel;

//multipeer
/*@property (strong, nonatomic) TDAudioOutputStreamer *outputStreamer;
@property (strong, nonatomic) TDAudioInputStreamer *inputStream;
@property (strong, nonatomic) TDSession *session;
*/
 @property (strong, nonatomic) AVPlayer *player;




/*
@property (nonatomic, strong) NSInputStream *inputStreamm;
@property (nonatomic, strong) NSOutputStream *outputStreamm;
*/
@property(strong,nonatomic) NSMutableArray *outputQueue;
@property (nonatomic, strong) NSMutableString *communicationLog;
// actions
- (IBAction)riseGain:(id)sender;
- (IBAction)lowerGain:(id)sender;
- (IBAction)audioSwitch:(id)sender;

// ui element manipulation
- (void)setGainLabelValue:(float)gainValue;
- (void)showLabelWithText:(NSString*)labelText;

@end
