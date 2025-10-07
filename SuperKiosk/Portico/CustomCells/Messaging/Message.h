//
//  Message.h
//  Sharecle
//
//  Created by Romulo on 08/04/14.
//  Copyright (c) 2014 Sharecle Inc. All rights reserved.
//

// Data model object that stores a single message
@interface Message : NSObject

// The sender of the message. If nil, the message was sent by the user.
//@property (nonatomic, copy) NSString* senderName;
@property (nonatomic, retain) NSNumber * bubbleSizeheight;
@property (nonatomic, retain) NSNumber * bubbleSizewidth;



// When the message was sent
//@property (nonatomic, copy) NSDate* date;
@property (nonatomic, copy) NSDate* createdon;

// The text of the message
@property (nonatomic, copy) NSString* text;

// This doesn't really belong in the data model, but we use it to cache the
// size of the speech bubble for this message.
@property (nonatomic, assign) CGSize bubbleSize;


//rom: added
@property (nonatomic, copy) NSNumber* messageid;
@property (nonatomic, copy) NSString* messageuid;

@property (nonatomic, copy) NSString* recipient;
@property (nonatomic, copy) NSNumber* recipientid;
@property (nonatomic, copy) NSString* recipientnickname;
@property (nonatomic, copy) NSNumber* recipientblockedid;


@property (nonatomic, copy) NSString* sender;
@property (nonatomic, copy) NSNumber* senderid;
@property (nonatomic, copy) NSString* sendernickname;
@property (nonatomic, copy) NSNumber* senderblockedid;

@property (nonatomic, copy) NSNumber* userid;
@property (nonatomic, copy) NSNumber* isread;
@property (nonatomic, copy) NSNumber* isplayed;

@property (nonatomic, copy) NSString* fileuid;
@property (nonatomic, copy) NSString* filecontenttype;
@property (nonatomic, copy) NSNumber* filelen;
@property (nonatomic, copy) NSString* filetitle;
@property (nonatomic, copy) NSString* filedescription;


@property (nonatomic, copy) NSString* imagefileuid;
@property (nonatomic, copy) NSString* imagefilecontenttype;
@property (nonatomic, copy) NSNumber* imagefilelen;



@property (nonatomic, copy) NSString* sender_imagefileuid;
@property (nonatomic, copy) NSString* sender_imagefiletype;
@property (nonatomic, copy) NSNumber* sender_imagefilesize;

@property (nonatomic, copy) NSString* recipient_imagefileuid;
@property (nonatomic, copy) NSString* recipient_imagefiletype;
@property (nonatomic, copy) NSNumber* recipient_imagefilesize;
/*
@property (nonatomic, copy) NSString* thumbnailfileuid;
@property (nonatomic, copy) NSString* thumbnailfilecontenttype;
@property (nonatomic, copy) NSNumber* thumbnailfilelen;
*/
@property (nonatomic, copy) NSNumber* shareid;
@property (nonatomic, copy) NSNumber* quantity;
@property(nonatomic,copy)NSNumber* status;

@property(nonatomic,copy)NSArray *attachments;

- (id)initWithDictionary:(NSDictionary *)dictionary;

- (NSMutableDictionary *)toNSDictionary;
//- (NSMutableDictionary *)toContactNSDictionary;

- (NSMutableDictionary *)toAttachmentDictionary;
// Determines whether this message was sent by the user of the app. We will
// display such messages on the right-hand side of the screen.
//- (BOOL)isSentByUser;

@end
