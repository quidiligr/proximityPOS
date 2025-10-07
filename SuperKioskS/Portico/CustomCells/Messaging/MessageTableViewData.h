//
//  Message.h
//  Sharecle
//
//  Created by Romulo on 08/04/14.
//  Copyright (c) 2014 Sharecle Inc. All rights reserved.
//

// Data model object that stores a single message
@interface MessageTableViewData : NSObject

// The sender of the message. If nil, the message was sent by the user.
//@property (nonatomic, copy) NSString* senderName;
@property (nonatomic,copy) NSString *deviceID;
@property (nonatomic,copy) NSString *peer_deviceID;

@property (nonatomic,copy) NSString *deviceToken;
@property (nonatomic,copy) NSString *peer_deviceToken;

@property (nonatomic, retain) NSNumber * bubbleSizeheight;
@property (nonatomic, retain) NSNumber * bubbleSizewidth;
@property (nonatomic, copy) NSString* recipient;
@property (nonatomic, copy) NSNumber* recipientid;
@property (nonatomic, copy) NSString* sender;
@property (nonatomic, copy) NSString* sendernickname;

@property (nonatomic, copy) NSString* sender_imagefileuid;
@property (nonatomic, copy) NSString* sender_imagefiletype;
@property (nonatomic, copy) NSNumber* sender_imagefilesize;

@property (nonatomic, copy) NSString* recipient_imagefileuid;
@property (nonatomic, copy) NSString* recipient_imagefiletype;
@property (nonatomic, copy) NSNumber* recipient_imagefilesize;

@property (nonatomic, copy) NSDate* createdon;

@property (nonatomic, copy) NSString* text;

@property (nonatomic, copy) UIImage* senderPhoto;
@property (nonatomic, copy) UIImage* recipientPhoto;
@property (nonatomic, copy) UIImage* myImage;
@property (nonatomic, copy) UIImage* myMedia;
@property(nonatomic)BOOL isPrivate;
@property (nonatomic, copy) NSNumber* senderid;
@property (nonatomic, copy) NSNumber* userid;
@property (nonatomic, strong) NSMutableArray* attachments;

- (id)initWithDictionary:(NSDictionary *)dictionary;
// Determines whether this message was sent by the user of the app. We will
// display such messages on the right-hand side of the screen.


-(BOOL) isSentByUser;
@end
