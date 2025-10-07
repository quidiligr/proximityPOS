//
//  MagTekDemoAppDelegate.m
//  MagTekDemo
//
//  Created by MagTek on 11/27/11.
//  Copyright 2011 MagTek. All rights reserved.
//

#import "MTSCRA.h"
#import "MagTekDemoAppDelegate.h"
#import "MagTekDemoViewController.h"
#import <CoreTelephony/CTCallCenter.h>
#import <CoreTelephony/CTCall.h>
@interface MagTekDemoAppDelegate () <UIApplicationDelegate>
{
    CTCallCenter* callCenter;
}
#pragma mark -
#pragma mark NSTimer Selector Method
#pragma mark -

- (void)openDeviceConnection;

@end

@implementation MagTekDemoAppDelegate

#pragma mark -
#pragma mark MTSCRA Library Method
#pragma mark -

- (MTSCRA *)getSCRALib
{
    return [self mtSCRALib];
}

#pragma mark -
#pragma mark Application lifecycle
#pragma mark -

- (void)applicationDidFinishLaunching:(UIApplication *)application
{
    self.mtSCRALib = [[MTSCRA alloc] init];
    
    /*
     *
     *  NOTE: TRANS_STATUS_START should be used with caution. CPU intensive tasks done after this events and before
     *        TRANS_STATUS_OK may interfere with reader communication.
     *
     */
    
    [self.mtSCRALib listenForEvents:(TRANS_EVENT_START|TRANS_EVENT_OK|TRANS_EVENT_ERROR)];
    
    /*
     *
     *  NOTE: When calling the View Controller's openDevice method automatically when the application is coming back from a
     *        Background State it is recommended that a 5 second delay be issued to ensure that the device has enough time
     *        to power on.
     *
     */
    
// Uncomment these lines to add a 5 second delay before the automatic openDevice call
//    [mtSCRALib setDeviceType:(MAGTEKIDYNAMO)];
//    [NSTimer scheduledTimerWithTimeInterval:5.0
//                                     target:self
//                                   selector:@selector(openDeviceConnection)
//                                   userInfo:nil
//                                    repeats:NO];
    
    

    UIStoryboard *sb = [UIStoryboard storyboardWithName: @"MainStoryboard_iPhone"
                                                 bundle: [NSBundle mainBundle]];
    UIViewController *vc = [sb instantiateInitialViewController];
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:vc];
    self.window.rootViewController=navController;
    
    
    callCenter = [[CTCallCenter alloc] init];
    [callCenter setCallEventHandler:^(CTCall *call)
     {
         NSLog(@"Event handler called");
         if ([call.callState isEqualToString: CTCallStateConnected])
         {
             NSLog(@"Connected");
         }
         else if ([call.callState isEqualToString: CTCallStateDialing])
         {
             NSLog(@"Dialing");
         }
         else if ([call.callState isEqualToString: CTCallStateDisconnected])
         {
             NSLog(@"Disconnected");
             dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                 [[self viewController] openDevice];
             });
             
         } else if ([call.callState isEqualToString: CTCallStateIncoming])
         {
             NSLog(@"Incomming");
         }
     }];

    

    //[self.window setRootViewController:navController];
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
   // [[self viewController] closeDevice];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[self viewController] openDevice];
        //[[self viewController] updateConnStatus];
        
    });

}

-(void)applicationWillResignActive:(UIApplication *)application
{
    //[[self viewController] closeDevice];
}


- (void)applicationDidBecomeActive:(UIApplication *)application
{
   dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
         [[self viewController] openDevice];
     //[[self viewController] updateConnStatus];
       
   });
    /*
     *
     *  NOTE: When calling the View Controller's openDevice method automatically when the application is coming back from a
     *        Background State it is recommended that a 5 second delay be issued to ensure that the device has enough time
     *        to power on.
     *
     */
    
// Uncomment these lines to add a 5 second delay before the automatic openDevice call
//    switch([mtSCRALib getDeviceType])
//    {
//        // we check and make sure that we are connecting to an iDynamo
//        case MAGTEKIDYNAMO:
//
//            [NSTimer scheduledTimerWithTimeInterval:5.0
//                                             target:self
//                                           selector:@selector(openDeviceConnection)
//                                           userInfo:nil
//                                            repeats:NO];
//
//            break;
//
//        default:
//
//            break;
//    }

}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [[self viewController] closeDevice];
}

#pragma mark -
#pragma mark NSTimer Selector Method
#pragma mark -

- (void)openDeviceConnection
{
    [[self viewController] openDevice];
}

@end