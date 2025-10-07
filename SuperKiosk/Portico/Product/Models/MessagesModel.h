//
//  IODOrder.h
//  iOSDiner
//
//  Created by Romulo Quidilig on 3/19/15.
//  Copyright (c) 2015 Sharecle Inc. All rights reserved.
//

#import <Foundation/Foundation.h>


@class BroadcastMessageAPI;



@interface MessagesModel: NSObject
+ (MessagesModel *)sharedInstance;

@property (nonatomic,strong) NSMutableArray* messages;


// Loads the list of messages from a file.
- (void)loadMessages;

// Saves the list of messages to a file.
- (void)saveMessages;

- (void)addMessage:(BroadcastMessageAPI *)message;

@end
