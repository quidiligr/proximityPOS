//
//  Message.h
//  Sharecle
//
//  Created by Romulo on 08/04/14.
//  Copyright (c) 2014 Sharecle Inc. All rights reserved.
//

// Data model object that stores a single message
#import "PeerInfo.h"

@interface BroadcastMessageAPI : NSObject

@property(nonatomic,strong) PeerInfo *peerInfo;//sender
@property(nonatomic,strong) PeerInfo *toPeerInfo;//recipient
@property(nonatomic,strong) NSString *toDeviceID;
@property(nonatomic,strong) NSString *deviceID;
@property(nonatomic,strong) NSString *deviceToken;
@property(nonatomic,strong) NSString *message_type;
@property (nonatomic, assign) BOOL isBroadcast;

@property (nonatomic, assign) BOOL isForward;

@property (nonatomic, assign) BOOL localCopy;
@property(nonatomic,assign) NSUInteger message_celldisplay;

@property (nonatomic, copy) NSString* channel;
@property (nonatomic, copy) NSString* broadcast_title;
@property (nonatomic, copy) NSString* broadcast_description;
@property (nonatomic, copy) NSString* broadcast_imagefilename;

@property (nonatomic, copy) NSString* channel_ownerphoto;//channel owner
@property (nonatomic, copy) NSString* channel_ownerphotocontenttype;//channel owner
@property (nonatomic, copy) NSString* channel_ownernickname;
@property (nonatomic, copy) NSString* channel_ownerid;


@property (nonatomic, copy) NSString* sender;
//@property (nonatomic, copy) NSString* sender_origin;
@property (nonatomic, copy) NSString* fromDeviceID;

@property (nonatomic, copy) NSString* recipient; //this is just to sync with message class just in case we need to merge the two in the future, for now we'll use just for the todictionary for messagetableviewdata


@property (nonatomic, copy) NSDate* createdon;


@property (nonatomic, copy) NSString* text;

@property (nonatomic, assign) CGSize bubbleSize;
@property (nonatomic, copy) NSNumber * bubbleSizeheight;
@property (nonatomic, copy) NSNumber * bubbleSizewidth;


@property (nonatomic, copy) NSNumber *messageid;
@property (nonatomic, copy) NSString *messageuid;

@property (nonatomic, copy) NSString* sendernickname;
//@property (nonatomic, copy) NSString* senderusername;


@property (nonatomic, copy) NSNumber* senderid;
@property (nonatomic, copy) NSString* senderToken;

@property (nonatomic, copy) NSNumber* userid;
@property (nonatomic, copy) NSNumber* isread;
@property (nonatomic, copy) NSNumber* isplayed;


@property (nonatomic, copy) NSString* sender_imagefileuid;
@property (nonatomic, copy) NSString* sender_imagefiletype;
@property (nonatomic, copy) NSNumber* sender_imagefilesize;
 
//@property (nonatomic, copy) NSNumber* thumbnailfilename;

@property (nonatomic, copy) NSString* imagefileuid;
//@property (nonatomic, copy) NSString* imagefilename;
//@property (nonatomic, copy) NSString* imagefilepath;
@property (nonatomic, copy) NSString* imagefilecontenttype;
@property (nonatomic, copy) NSNumber* imagefilecontentlength;

@property (nonatomic, copy) NSString* fileuid;
//@property (nonatomic, copy) NSString* filepath;
//@property (nonatomic, copy) NSString* filename;
@property(nonatomic, copy) NSString* filecontenttype;
@property(nonatomic, copy) NSNumber* filecontentlength;
@property (nonatomic, copy) NSString* filetitle;
@property (nonatomic, copy) NSString* filedescription;

@property(nonatomic, copy) NSNumber* isplaying;


//@property (nonatomic, copy) NSNumber* shareid;
//@property (nonatomic, copy) NSNumber* quantity;
@property (nonatomic, copy) NSNumber* channelid;

@property(nonatomic,copy)NSNumber* status;

//@property(nonatomic,copy)NSArray *attachments;
@property(nonatomic,copy)NSArray *attachments;
- (id)initWithDictionary:(NSDictionary *)dictionary;

- (NSMutableDictionary *)toNSDictionary;
- (NSMutableDictionary *)toJSONDictionary;
- (NSMutableDictionary *)toAttachmentDictionary;

-(BOOL) isSentByUser;
    

//+ (NSDate *)deserializeJsonDateString: (NSString *)jsonDateString;
@end
