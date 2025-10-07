//
//  Message.m
//  Sharecle
//
//  Created by Romulo on 08/04/14.
//  Copyright (c) 2014 Sharecle Inc. All rights reserved.
//

#import "Message.h"
//#import "DataModel.h"
#import "NSString+JSONDate.h"
#import "UserInfo.h"
//#import "FileStore.h"
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
@implementation Message
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
- (id)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        //NSLog(@"%@",dictionary);
        //self.createdon = [DataModel deserializeJsonDateString:[dictionary objectForKey:@"createdon"]] ;
        NSString *jsonDate=[dictionary objectForKey:@"createdon"];
        self.createdon =[jsonDate JSONDate]; //deserializeJsonDateString([dictionary objectForKey:@"createdon"]);

        self.text = DICT_GET(dictionary, @"text");
        
        
        self.messageid = DICT_GET(dictionary, @"messageid");
        self.messageuid= DICT_GET(dictionary, @"messageuid");
        
        self.fileuid = DICT_GET(dictionary, @"fileuid");
        self.filelen = DICT_GET(dictionary, @"filelen");
        self.filecontenttype = DICT_GET(dictionary, @"filecontenttype");
        self.filetitle = DICT_GET(dictionary, @"filetitle");
        self.filedescription = DICT_GET(dictionary, @"filedescription");
        
        self.imagefileuid= DICT_GET(dictionary, @"imagefileuid");
        self.imagefilelen= DICT_GET(dictionary, @"imagefilelen");
        self.imagefilecontenttype= DICT_GET(dictionary, @"imagefilecontenttype");
        
        /*
         self.thumbnailfileuid= DICT_GET(dictionary, @"thumbnailfileuid");
        self.thumbnailfilelen= DICT_GET(dictionary, @"thumbnailfilelen");
        self.thumbnailfilecontenttype= DICT_GET(dictionary, @"thumbnailfilecontenttype");
        */
        self.sender_imagefileuid= DICT_GET(dictionary, @"sender_imagefileuid");
        self.sender_imagefiletype= DICT_GET(dictionary, @"sender_imagefiletype");
        self.sender_imagefilesize= DICT_GET(dictionary, @"sender_imagefilesize");
        
        self.recipient_imagefileuid= DICT_GET(dictionary, @"recipient_imagefileuid");
        self.recipient_imagefilesize= DICT_GET(dictionary, @"recipient_imagefilesize");
        self.recipient_imagefiletype= DICT_GET(dictionary, @"recipient_imagefiletype");
        
        
        self.senderid = DICT_GET(dictionary, @"senderid");
        self.sender = DICT_GET(dictionary, @"sender");
        self.sendernickname = DICT_GET(dictionary, @"sendernickname");
        self.senderblockedid= DICT_GET(dictionary, @"senderblockedid");
        
        self.recipientid =DICT_GET(dictionary, @"recipientid");
        self.recipient = DICT_GET(dictionary, @"recipient");
        self.recipientnickname = DICT_GET(dictionary, @"recipientnickname");
        self.recipientblockedid= DICT_GET(dictionary, @"recipientblockedid");
        
        self.userid = DICT_GET(dictionary, @"userid");
        self.isread=DICT_GET(dictionary, @"isread");
        self.isplayed=DICT_GET(dictionary, @"isplayed");
        self.status=@1;
        
        self.attachments=[dictionary objectForKey:@"attachments"];
       // if(self.attachments!=(id)[NSNull null] && self.attachments && [self.attachments count]>0)
         //   NSLog(@"attachments %@",self.attachments);
        //NSArray *jsonArray=[json objectForKey:@"attachments"];
        
    }
    
    return self;
}

- (BOOL)isEqual:(id)object {
    if (![object isKindOfClass:[Message class]]) {
        return NO;
    }
    
    Message *other = (Message *)object;
    return [other.messageuid isEqualToString:self.messageuid];
}

//the main purpose is for convertion to messagetableviewdata, we need only partial fields
//the main purpose is for convertion to messagetableviewdata, we need only partial fields
- (NSMutableDictionary *)toNSDictionary{
   // DataModel *_dataModel=[DataModel getInstance];
    NSMutableDictionary *dictionary=[[NSMutableDictionary alloc]init];
    //[dictionary setValue:self.loggedinuserid forKey:@"loggedinuserid"];
    [dictionary setValue:self.userid forKey:@"userid"];
    [dictionary setValue:self.bubbleSizeheight forKey:@"bubbleSizeheight"];
    [dictionary setValue:self.bubbleSizewidth forKey:@"bubbleSizewidth"];
    [dictionary setValue:self.createdon forKey:@"createdon"];
    [dictionary setValue:self.text forKey:@"text"];
    [dictionary setValue:self.senderid forKey:@"senderid"];
    [dictionary setValue:self.sender forKey:@"sender"];
    if(self.sender==(id)[NSNull null]){
        self.sender=nil;
    }
    [dictionary setValue:self.sendernickname forKey:@"sendernickname"];
    if(self.sendernickname==(id)[NSNull null]){
        if(self.sender!=nil)
            self.sendernickname=self.sender;
        else
            self.sendernickname=nil;
    }

    
    [dictionary setValue:self.sender_imagefileuid forKey:@"sender_imagefileuid"];
    [dictionary setValue:self.sender_imagefiletype forKey:@"sender_imagefiletype"];
    [dictionary setValue:self.sender_imagefilesize forKey:@"sender_imagefilesize"];
    
    [dictionary setValue:self.recipient_imagefileuid forKey:@"recipient_imagefileuid"];
    [dictionary setValue:self.recipient_imagefiletype forKey:@"recipient_imagefiletype"];
    [dictionary setValue:self.recipient_imagefilesize forKey:@"recipient_imagefilesize"];
    
    
    [dictionary setValue:self.recipientid forKey:@"recipientid"];
    [dictionary setValue:self.recipient forKey:@"recipient"];
    
    [dictionary setValue:@YES forKey:@"isPrivate"];
    /*if([self.senderid isEqualToNumber:_dataModel.userInfo.userid])
    {
        if (_dataModel.userInfo.fileData!=nil) {
            [dictionary setValue:_dataModel.userInfo.fileData forKey:@"senderPhoto"];
        }
        else{
            
        }
    }
    else{
        
    }
      */
    //UIImage *photo=nil;
        //[dictionary setValue:nil forKey:@"otherPhoto"];
    [dictionary setValue:nil forKey:@"senderPhoto"];
    [dictionary setValue:nil forKey:@"myImage"];
    [dictionary setValue:nil forKey:@"myMedia"];
    return dictionary;
}

- (NSMutableDictionary *)toAttachmentDictionary{
    // DataModel *_dataModel=[DataModel getInstance];
    NSMutableDictionary *dictionary=[[NSMutableDictionary alloc]init];
    [dictionary setValue:self.attachments forKey:@"Attachments"];
    
    return dictionary;
}

//this is use to extract partial info of contactfrom message, basically use from message controller to chat controller
/*
- (NSMutableDictionary *)toContactNSDictionary{
    DataModel *_dataModel=[DataModel getInstance];
    NSMutableDictionary *dictionary=[[NSMutableDictionary alloc]init];
    
    
    if(self.senderid){
        if([self.senderid isEqualToNumber:_dataModel.userInfo.userid]){
            [dictionary setValue:self.recipientid forKey:@"userid"];
            [dictionary setValue:self.recipient forKey:@"username"];
            [dictionary setValue:self.recipientnickname forKey:@"name"];
            
            if (self.recipientblockedid && [self.recipientblockedid isEqualToNumber:@0]) {
                [dictionary setValue:@0 forKey:@"blocked"];
            }
            else{
                [dictionary setValue:@1 forKey:@"blocked"];
            }
            
            [dictionary setValue:self.recipient_imagefileuid forKey:@"photofileuid"];
            [dictionary setValue:self.recipient_imagefiletype forKey:@"photofiletype"];
            [dictionary setValue:self.recipient_imagefilesize forKey:@"photofilesize"];
            }
        else
        {
        
            [dictionary setValue:self.senderid forKey:@"userid"];
            [dictionary setValue:self.sender forKey:@"username"];
            [dictionary setValue:self.sendernickname forKey:@"name"];
            if (self.senderblockedid && [self.senderblockedid isEqualToNumber:@0]) {
                [dictionary setValue:@0 forKey:@"blocked"];
            }
            else{
                [dictionary setValue:@1 forKey:@"blocked"];
            }
            [dictionary setValue:self.sender_imagefileuid forKey:@"photofileuid"];
            [dictionary setValue:self.sender_imagefiletype forKey:@"photofiletype"];
            [dictionary setValue:self.sender_imagefilesize forKey:@"photofilesize"];

        }
    }
    
    return dictionary;
}
*/



@end
