//
//  Message.m
//  Sharecle
//
//  Created by Romulo on 08/04/14.
//  Copyright (c) 2014 Sharecle Inc. All rights reserved.
//

#import "MessageTableViewData.h"
//#import "DataModel.h"
#import "UserInfo.h"
#import "defs.h"
/*
//static NSString* const NameKey = @"Name";
static NSString* const CreatedonKey = @"Createdon";
static NSString* const TextKey = @"Text";
static NSString* const MessageIdKey=@"MessageId";
static NSString* const RecipientIdKey=@"RecipientId";
static NSString* const SenderIdKey=@"SenderId";
//static NSString* const ImageUrlKey=@"ImageUrl";
static NSString* const UserIdKey=@"UserId";
//static NSString* const UnreadKey=@"Unread";
static NSString* const FileUidKey=@"FileUid";
static NSString* const RecipientKey=@"Recipient";
static NSString* const SenderKey=@"Sender";
static NSString* const QuantityKey=@"Quantity";
static NSString* const ShareIdKey=@"ShareId";
*/
@implementation MessageTableViewData{
    //DataModel *_dataModel;
}
/*
- (id)initWithCoder:(NSCoder*)decoder
{
	if ((self = [super init]))
	{
        self.sender = [decoder decodeObjectForKey:SenderKey];
		self.recipient = [decoder decodeObjectForKey:RecipientKey];
        self.createdon = [decoder decodeObjectForKey:CreatedonKey];
		self.text = [decoder decodeObjectForKey:TextKey];
        self.messageid = [decoder decodeObjectForKey:MessageIdKey];
        self.recipientid = [decoder decodeObjectForKey:RecipientIdKey];
        self.senderid = [decoder decodeObjectForKey:SenderIdKey];
        //self.imageurl = [decoder decodeObjectForKey:ImageUrlKey];
        self.userid = [decoder decodeObjectForKey:UserIdKey];
        //self.unread = [decoder decodeObjectForKey:UnreadKey];
        self.fileuid = [decoder decodeObjectForKey:FileUidKey];
        self.shareid = [decoder decodeObjectForKey:SenderIdKey];
        self.quantity = [decoder decodeObjectForKey:QuantityKey];

	}
	return self;
}

- (void)encodeWithCoder:(NSCoder*)encoder
{
	[encoder encodeObject:self.sender forKey:SenderKey];
    [encoder encodeObject:self.recipient forKey:RecipientKey];
	[encoder encodeObject:self.createdon forKey:CreatedonKey];
	[encoder encodeObject:self.text forKey:TextKey];
    [encoder encodeObject:self.messageid forKey:MessageIdKey];
    [encoder encodeObject:self.recipientid forKey:RecipientIdKey];
    [encoder encodeObject:self.senderid forKey:SenderIdKey];
    //[encoder encodeObject:self.imageurl forKey:ImageUrlKey];
    [encoder encodeObject:self.userid forKey:UserIdKey];
   // [encoder encodeObject:self.unread forKey:UnreadKey];
    [encoder encodeObject:self.fileuid forKey:FileUidKey];
     [encoder encodeObject:self.shareid forKey:ShareIdKey];
     [encoder encodeObject:self.quantity forKey:QuantityKey];

}

- (BOOL)isSentByUser
{
	//return self.name == nil;
    return [self.senderid longValue] ==[self.userid longValue];
    
}
 */
 -(id)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
       // _dataModel=[DataModel getInstance];
        self.createdon = [dictionary objectForKey:@"createdon"];//[DataModel deserializeJsonDateString:[dictionary objectForKey:@"createdon"]] ;
         self.deviceID = [dictionary objectForKey:@"deviceID"];
        self.peer_deviceID = [dictionary objectForKey:@"peer_deviceID"];
        
        self.deviceToken = [dictionary objectForKey:@"deviceToken"];
        self.peer_deviceToken = [dictionary objectForKey:@"peer_deviceToken"];
        
        self.text = DICT_GET(dictionary, @"text");
        
        self.bubbleSizeheight = DICT_GET(dictionary, @"bubbleSizeheight");
        self.bubbleSizewidth = DICT_GET(dictionary, @"bubbleSizewidth");
        
        self.recipient = DICT_GET(dictionary, @"recipient");
        self.recipientid = DICT_GET(dictionary, @"recipientid");
        self.userid = DICT_GET(dictionary, @"userid");
        
        self.senderid = DICT_GET(dictionary, @"senderid");
        self.sender = DICT_GET(dictionary, @"sender");
        if(self.sender==(id)[NSNull null])
            
                self.sender=@"";
        
        
        self.sendernickname = DICT_GET(dictionary, @"sendernickname");
        if(self.sendernickname==(id)[NSNull null]){
           if(self.sender!=nil)
               self.sendernickname=self.sender;
            else
                self.sendernickname=@"";
        }
        
        
        
        
        
        self.sender_imagefileuid = DICT_GET(dictionary, @"sender_imagefileuid");
        self.sender_imagefiletype = DICT_GET(dictionary, @"sender_imagefiletype");
        self.sender_imagefilesize = DICT_GET(dictionary, @"sender_imagefilesize");
        
        /* rom: do not use, its slow
        if ([self.senderid isEqualToNumber:_dataModel.userInfo.userid]) {
            if(self.sender_imagefileuid.length>0){
                NSData *fsdata=[_dataModel fileStoreGetSetData:_dataModel.userInfo.filehash contentType:_dataModel.userInfo.filecontenttype contentLength:_dataModel.userInfo.filelen isStream:NO];
                if (fsdata)
                    self.senderPhoto=[UIImage imageWithData:fsdata];
                else
                    self.senderPhoto=[UIImage imageNamed:@"person.png"];

            }
            else
                self.senderPhoto=[UIImage imageNamed:@"person.png"];
            
        }
        else{
            if(self.sender_imagefileuid.length>0){
                NSData *fsdata=[_dataModel fileStoreGetSetData:self.sender_imagefileuid contentType:self.sender_imagefiletype contentLength:self.sender_imagefilesize isStream:NO];
                if (fsdata)
                    self.senderPhoto=[UIImage imageWithData:fsdata];
                else
                    self.senderPhoto=[UIImage imageNamed:@"person.png"];
                
            }
            else
                self.senderPhoto=[UIImage imageNamed:@"person.png"];
            
        }
         */
        
        
        //self.recipientid =DICT_GET(dictionary, @"recipientid");
       
        //self.isread=@0;
        //self.status=@1;
        
        
    }
    
    return self;
}
 /*

- (BOOL)isEqual:(id)object {
    if (![object isKindOfClass:[ComposeData class]]) {
        return NO;
    }
    
    ComposeData *other = (ComposeData *)object;
    return [other.messageuid isEqualToString:self.messageuid];
}
*/

-(BOOL) isSentByUser{
    return [self.deviceID isEqualToString:self.peer_deviceID];
    
    
    
}

@end
