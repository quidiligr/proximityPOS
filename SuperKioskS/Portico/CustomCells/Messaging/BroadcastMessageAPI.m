//
//  Message.m
//  Sharecle
//
//  Created by Romulo on 08/04/14.
//  Copyright (c) 2014 Sharecle Inc. All rights reserved.
//

#import "BroadcastMessageAPI.h"
#import "NSString+JSONDate.h"
//#import "DataModel.h"
#import "defs.h"
//static NSString* const NameKey = @"Name";
/*static NSString* const CreatedonKey = @"Createdon";
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


@implementation BroadcastMessageAPI
//+ (NSDate *)deserializeJsonDateString: (NSString *)jsonDateString
//{
//    if(jsonDateString==(id)[NSNull null] || jsonDateString==nil || jsonDateString.length<9)
//        return nil;
//    // NSLog(@"jsonDateString=%@", jsonDateString);
//    /*/Date(67161600000)/
//     /Date(1368128341000)/
//     */
//    NSInteger offset = [[NSTimeZone defaultTimeZone] secondsFromGMT]; //get number of seconds to add or subtract according to the client default time zone
//    
//    NSInteger startPosition = [jsonDateString rangeOfString:@"("].location + 1; //start of the date value
//    NSInteger endPosition = [jsonDateString rangeOfString:@")"].location; //start of the date value
//    NSInteger length=endPosition-startPosition;
//    NSString *datePart=[jsonDateString substringWithRange:NSMakeRange(startPosition, length)];
//    //NSTimeInterval unixTime = [[jsonDateString substringWithRange:NSMakeRange(startPosition, 13)] doubleValue] / 1000; //WCF will send 13 digit-long value for the time interval since 1970 (millisecond precision) whereas iOS works with 10 digit-long values (second precision), hence the divide by 1000
//    NSTimeInterval unixTime = [datePart doubleValue]/1000; //WCF will send 13 digit-long value for the time interval since 1970 (millisecond precision) whereas iOS works with 10 digit-long values (second precision), hence the divide by 1000
//    
//    NSDate* date=[[NSDate dateWithTimeIntervalSince1970:unixTime] dateByAddingTimeInterval:offset];
//    
//    return date;
//}
/*
- (id)initWithCoder:(NSCoder*)decoder
{
	if ((self = [super init]))
	{
        self.sender = [decoder decodeObjectForKey:SenderKey];
		//self.recipient = [decoder decodeObjectForKey:RecipientKey];
        self.createdon = [decoder decodeObjectForKey:CreatedonKey];
		self.text = [decoder decodeObjectForKey:TextKey];
        self.messageid = [decoder decodeObjectForKey:MessageIdKey];
        //self.recipientid = [decoder decodeObjectForKey:RecipientIdKey];
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
    //[encoder encodeObject:self.recipient forKey:RecipientKey];
	[encoder encodeObject:self.createdon forKey:CreatedonKey];
	[encoder encodeObject:self.text forKey:TextKey];
   // [encoder encodeObject:self.id forKey:IdKey];
    //[encoder encodeObject:self.recipientid forKey:RecipientIdKey];
    [encoder encodeObject:self.senderid forKey:SenderIdKey];
    //[encoder encodeObject:self.imageurl forKey:ImageUrlKey];
    [encoder encodeObject:self.userid forKey:UserIdKey];
   // [encoder encodeObject:self.unread forKey:UnreadKey];
    [encoder encodeObject:self.fileuid forKey:FileUidKey];
     [encoder encodeObject:self.shareid forKey:ShareIdKey];
     [encoder encodeObject:self.quantity forKey:QuantityKey];

}
*/

- (id)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
      
        //self.createdon = [DataModel deserializeJsonDateString:[dictionary objectForKey:@"createdon"]] ;
        NSString *jsonDate=[dictionary objectForKey:@"createdon"];
        
        if(jsonDate==(id)[NSNull null] || jsonDate==nil )
            self.createdon=[NSDate date];
        
        self.createdon =[jsonDate JSONDate]; //deserializeJsonDateString([dictionary objectForKey:@"createdon"]);

        
        
        self.text = [dictionary objectForKey:@"text"];
        
        
        self.channel_ownerphoto=DICT_GET(dictionary, @"channel_ownerphoto");
        self.channel_ownerphotocontenttype=DICT_GET(dictionary, @"channel_ownerphotocontenttype");
        self.channel_ownernickname=DICT_GET(dictionary, @"channel_ownernickname");
        
        self.sender_imagefileuid = DICT_GET(dictionary, @"sender_imagefileuid");
        self.sender_imagefiletype = DICT_GET(dictionary, @"sender_imagefiletype");
        self.sender_imagefilesize = DICT_GET(dictionary, @"sender_imagefilesize");
        
        self.fileuid = DICT_GET(dictionary, @"fileuid");//[item objectForKey:@"fileuid"];
        self.filecontenttype = DICT_GET(dictionary, @"filecontenttype");//[item objectForKey:@"filecontenttype"];
        self.filecontentlength = DICT_GET(dictionary, @"filecontentlength");//[item objectForKey:@"filecontentlength"];
        self.filetitle = DICT_GET(dictionary, @"filetitle");
        self.filedescription = DICT_GET(dictionary, @"filedescription");
        
        self.imagefileuid = DICT_GET(dictionary, @"imagefileuid");//[item objectForKey:@"imagefileuid"];
        self.imagefilecontenttype = DICT_GET(dictionary, @"imagefilecontenttype");//[item objectForKey:@"imagefilecontenttype"];
        self.imagefilecontentlength = DICT_GET(dictionary, @"imagefilecontentlength");//[item objectForKey:@"imagefilecontentlength"];
        
        
        self.senderid = DICT_GET(dictionary, @"senderid");//[item objectForKey:@"senderid"];
        self.sender = DICT_GET(dictionary, @"sender");//[item objectForKey:@"sender"];
        //self.senderusername = DICT_GET(dictionary, @"senderusername");
        self.sendernickname = DICT_GET(dictionary, @"sendernickname");//[item objectForKey:@"sendernickname"];
        //message.recipientnickname = [item objectForKey:@"recipientnickname"];
        
        
        //message.recipientid = [item objectForKey:@"recipientid"];
        //message.recipient = [item objectForKey:@"recipient"];
        self.userid = DICT_GET(dictionary, @"userid");//[item objectForKey:@"userid"];
        self.messageuid =  DICT_GET(dictionary, @"messageuid");//[item objectForKey:@"messageuid"];
        self.messageid =  DICT_GET(dictionary, @"messageid");//[item objectForKey:@"messageuid"];
        //self.shareid =  DICT_GET(dictionary, @"shareid");//[item objectForKey:@"shareid"];
        //self.quantity =  DICT_GET(dictionary, @"quantity");//[item objectForKey:@"quantity"];
        self.channelid=  DICT_GET(dictionary, @"channelid");
        self.channel=  DICT_GET(dictionary, @"channel");//[item objectForKey:@"channelid"];
        self.broadcast_title=  DICT_GET(dictionary, @"broadcast_title");//[item objectForKey:@"broadcast_title"];
        self.broadcast_description=  DICT_GET(dictionary, @"broadcast_description");//[item objectForKey:@"broadcast_description"];
        
        
        self.status=@1;
        
        self.isread=DICT_GET(dictionary, @"isread");
        self.isplayed=DICT_GET(dictionary, @"isplayed");
         self.attachments=[dictionary objectForKey:@"attachments"];

    }
    
    return self;
}

//the main purpose is for convertion to messagetableviewdata, we need only partial fields
- (NSMutableDictionary *)toNSDictionary{
    NSMutableDictionary *dictionary=[[NSMutableDictionary alloc]init];
    //[dictionary setValue:self.loggedinuserid forKey:@"loggedinuserid"];
     [dictionary setValue:self.deviceID forKey:@"deviceID"];
    [dictionary setValue:self.peerInfo.deviceID forKey:@"peer_deviceID"];
    
    [dictionary setValue:self.deviceToken forKey:@"deviceToken"];
    [dictionary setValue:self.peerInfo.deviceToken forKey:@"peer_deviceToken"];
    
    [dictionary setValue:self.userid forKey:@"userid"];
    [dictionary setValue:self.bubbleSizeheight forKey:@"bubbleSizeheight"];
    [dictionary setValue:self.bubbleSizewidth forKey:@"bubbleSizewidth"];
    [dictionary setValue:self.createdon forKey:@"createdon"];
    [dictionary setValue:self.text forKey:@"text"];
    [dictionary setValue:self.senderid forKey:@"senderid"];
    [dictionary setValue:self.sender forKey:@"sender"];
    [dictionary setValue:self.sendernickname forKey:@"sendernickname"];
    
    [dictionary setValue:@NO forKey:@"isPrivate"];
    
    [dictionary setValue:self.sender_imagefileuid forKey:@"sender_imagefileuid"];
    [dictionary setValue:self.sender_imagefiletype forKey:@"sender_imagefiletype"];
    [dictionary setValue:self.sender_imagefilesize forKey:@"sender_imagefilesize"];
    
    
    [dictionary setValue:self.recipient forKey:@"recipient"];
    [dictionary setValue:nil forKey:@"senderPhoto"];
    //[dictionary setValue:nil forKey:@"otherPhoto"];
    [dictionary setValue:nil forKey:@"myImage"];
    [dictionary setValue:nil forKey:@"myMedia"];
    return dictionary;
}

- (NSMutableDictionary *)toJSONDictionary{
    NSMutableDictionary *dictionary=[[NSMutableDictionary alloc]init];
    
    /*[dictionary setValue:self.deviceID forKey:@"deviceID"];
     [dictionary setValue:self.deviceToken forKey:@"deviceToken"];
     [dictionary setValue:self.peerInfo.deviceID forKey:@"peer_deviceID"];
     [dictionary setValue:self.peerInfo.deviceToken forKey:@"peer_deviceToken"];
     [dictionary setValue:self.userid forKey:@"userid"];
     [dictionary setValue:self.bubbleSizeheight forKey:@"bubbleSizeheight"];
     [dictionary setValue:self.bubbleSizewidth forKey:@"bubbleSizewidth"];
     */
    [dictionary setValue:self.createdon forKey:@"createdon"];
    [dictionary setValue:self.text forKey:@"text"];
    [dictionary setValue:self.senderid forKey:@"senderid"];
    [dictionary setValue:self.sender forKey:@"sender"];
    [dictionary setValue:self.sendernickname forKey:@"sendernickname"];
    
    [dictionary setValue:[NSNumber numberWithBool:self.isBroadcast ] forKey:@"isBroadcast"];
    //[dictionary setValue:[NSNumber numberWithBool:self.isForward ] forKey:@"isForward"];
    
    /*[dictionary setValue:self.sender_imagefileuid forKey:@"sender_imagefileuid"];
     [dictionary setValue:self.sender_imagefiletype forKey:@"sender_imagefiletype"];
     [dictionary setValue:self.sender_imagefilesize forKey:@"sender_imagefilesize"];
     
     
     [dictionary setValue:self.recipient forKey:@"recipient"];
     [dictionary setValue:nil forKey:@"senderPhoto"];
     [dictionary setValue:nil forKey:@"myImage"];
     [dictionary setValue:nil forKey:@"myMedia"];
     */
    return dictionary;
}

- (NSMutableDictionary *)toAttachmentDictionary{
    // DataModel *_dataModel=[DataModel getInstance];
    NSMutableDictionary *dictionary=[[NSMutableDictionary alloc]init];
    [dictionary setValue:self.attachments forKey:@"Attachments"];
    
    return dictionary;
}


- (BOOL)isEqual:(id)object {
    if (![object isKindOfClass:[BroadcastMessageAPI class]]) {
        return NO;
    }
    
    BroadcastMessageAPI *other = (BroadcastMessageAPI *)object;
    return [other.messageuid isEqualToString:self.messageuid];
}

/*- (BOOL)isSentByUser
{
	//return self.name == nil;
    return [self.senderid longValue] ==[self.userid longValue];
    
}
 */
-(BOOL) isSentByUser{
    return [self.deviceID isEqualToString:self.peerInfo.deviceID];
        
        
    
}

//+(void)addNewMessage:(BroadcastMessageAPI *)message{
//    if(self.messages==nil)
//        self.messages=[NSMutableArray new];
//    
//    //if(self.mcManager.serverPeerInfo.maxMessagesPerUser>0){
//    if(self.appConfig.maxMessagesPerUser>0){
//        
//        //NSPredicate *predicate=[NSPredicate predicateWithFormat:@"deviceID==%@",message.deviceID];
//        
//        NSPredicate *predicate=[NSPredicate predicateWithFormat:@"fromDeviceID==%@",message.fromDeviceID];
//        NSArray *existing=[self.messages filteredArrayUsingPredicate:predicate];
//        
//        if([existing count]>0){//=self.appConfig.userInfo.messageLimitPerUser){
//            /* for now just delete everything
//             NSSortDescriptor *descriptor=[[NSSortDescriptor alloc] initWithKey:@"createdon" ascending:YES];
//             NSArray *sorted=[existing sortedArrayUsingDescriptors:[NSArray arrayWithObject:descriptor]];
//             
//             for(BroadcastMessageAPI *item in sorted){
//             //if([self.peerDevices containsObject:searchPeerInfo]){
//             NSInteger indexOfPeer = [self.messages indexOfObject:item];
//             //peerInfo=[self.peerDevices objectAtIndex:indexOfPeer];
//             
//             //}
//             [self.messages removeObjectAtIndex:indexOfPeer];
//             }
//             */
//            for(BroadcastMessageAPI *item in existing){
//                
//                //NSInteger indexOfPeer = [self.messages indexOfObject:item];
//                
//                [self.messages removeObject:item];
//            }
//            
//        }
//    }
//    
//    [self.messages addObject:message];
//    /*
//     if(_appConfig.userInfo.isPlaySound){
//     AudioServicesPlaySystemSound(1003);
//     }
//     */
//    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_UPDATE_MESSAGES object:nil];
//}
//
//+(void)addNewMessage:(BroadcastMessageAPI *)message{
//    if(self.messages==nil)
//        self.messages=[NSMutableArray new];
//    
//    //if(self.mcManager.serverPeerInfo.maxMessagesPerUser>0){
//    if(self.appConfig.maxMessagesPerUser>0){
//        
//        //NSPredicate *predicate=[NSPredicate predicateWithFormat:@"deviceID==%@",message.deviceID];
//        
//        NSPredicate *predicate=[NSPredicate predicateWithFormat:@"fromDeviceID==%@",message.fromDeviceID];
//        NSArray *existing=[self.messages filteredArrayUsingPredicate:predicate];
//        
//        if([existing count]>0){//=self.appConfig.userInfo.messageLimitPerUser){
//            /* for now just delete everything
//             NSSortDescriptor *descriptor=[[NSSortDescriptor alloc] initWithKey:@"createdon" ascending:YES];
//             NSArray *sorted=[existing sortedArrayUsingDescriptors:[NSArray arrayWithObject:descriptor]];
//             
//             for(BroadcastMessageAPI *item in sorted){
//             //if([self.peerDevices containsObject:searchPeerInfo]){
//             NSInteger indexOfPeer = [self.messages indexOfObject:item];
//             //peerInfo=[self.peerDevices objectAtIndex:indexOfPeer];
//             
//             //}
//             [self.messages removeObjectAtIndex:indexOfPeer];
//             }
//             */
//            for(BroadcastMessageAPI *item in existing){
//                
//                //NSInteger indexOfPeer = [self.messages indexOfObject:item];
//                
//                [self.messages removeObject:item];
//            }
//            
//        }
//    }
//    
//    [self.messages addObject:message];
//    /*
//     if(_appConfig.userInfo.isPlaySound){
//     AudioServicesPlaySystemSound(1003);
//     }
//     */
//    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_UPDATE_MESSAGES object:nil];
//}
//

@end
