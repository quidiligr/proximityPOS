//
//  UserInfo.m
//  Sharecle
//
//  Created by Romulo Quidilig on 4/19/14.
//  Copyright (c) 2014 Sharecle Inc. All rights reserved.
//

#import "UserInfo.h"
#import "defs_userinfo.h"



@implementation UserInfo
/*
@dynamic devicetoken;
@dynamic lastmessagedate;
@dynamic lastmessageid;
@dynamic loggedIn;
@dynamic password;
@dynamic userid;
@dynamic username;
@dynamic userToken;
@dynamic userToken;
*/

- (NSDictionary *)toNSDictionary{
    NSMutableDictionary *dictionary=[NSMutableDictionary new];
    [dictionary setValue:self.username forKey:KEY_USERNAME];
    [dictionary setValue:self.password forKey:KEY_PASSWORD];
    [dictionary setValue:self.fullName forKey:KEY_FULLNAME];
    [dictionary setValue:self.deviceID forKey:KEY_DEVICEID];
    [dictionary setValue:[UserInfo getDisplayName:self.fullName] forKey:KEY_DISPLAYNAME];
    
    NSMutableArray *cards=[NSMutableArray new];
    for(CCardInfo *card in self.ccards){
        if (card.name.length>0 && card.name.length<=MAX_CC_NAME_LEN && card.number.length>=MIN_CC_NUMBER_LEN && card.name.length<= MAX_CC_NUMBER_LEN) {
            
            [cards addObject:[card toNSDictionary]];
        }
        
        //}
    }
    [dictionary setValue:cards forKey:KEY_CCARDS];
   
     [dictionary setValue:self.blockedDevices forKey:KEY_BLOCKEDDEVICES];
    [dictionary setValue:self.myPhotoMD5 forKey:KEY_MYPHOTOMD5];
    [dictionary setValue:self.announceText forKey:KEY_ANNOUNCE];
[dictionary setValue:@(self.isPlaySound) forKey:KEY_PLAYSOUND];
    [dictionary setValue:@(self.messageLimitPerUser) forKey:KEY_MESSAGELIMITPERUSER];
    
    /*[dictionary setValue:self.ccard.ccNumber forKey:KEY_CCNUMBER];
    [dictionary setValue:self.ccard.ccCVV forKey:KEY_CCCVV];
    [dictionary setValue:self.ccard.ccExpYear forKey:KEY_CCEXPYEAR];
    [dictionary setValue:self.ccard.ccExpMonth forKey:KEY_CCEXPMONTH];
    [dictionary setValue:self.ccard.ccEmail forKey:KEY_CCEMAIL];
     */
    return dictionary;
}

- (id)initWithDictionary:(NSDictionary *)dictionary{
    if ((self = [super init]))
    {
        
        self.username=([dictionary objectForKey:KEY_USERNAME]!=nil)? [dictionary valueForKey:KEY_USERNAME]:@"";
        
        self.password=([dictionary objectForKey:KEY_PASSWORD]!=nil)?[dictionary valueForKey:KEY_PASSWORD]:@"";
        
        self.fullName=([dictionary objectForKey:KEY_FULLNAME]!=nil)?[dictionary valueForKey:KEY_FULLNAME]:[[UIDevice currentDevice] name];
        
        self.displayName=[UserInfo getDisplayName:self.fullName];//([dictionary objectForKey:KEY_DISPLAYNAME]!=nil)?[dictionary valueForKey:KEY_DISPLAYNAME]:[[UIDevice currentDevice] name];
        
        self.deviceID=([dictionary objectForKey:KEY_DEVICEID]!=nil)?[dictionary valueForKey:KEY_DEVICEID]:[[[[UIDevice currentDevice] identifierForVendor]  UUIDString] lowercaseString];
        
        self.deviceToken=([dictionary objectForKey:KEY_DEVICETOKEN]!=nil)?[dictionary valueForKey:KEY_DEVICETOKEN]:@"";
        
        self.homeUrl=([dictionary objectForKey:KEY_HOMEURL]!=nil)?[dictionary valueForKey:KEY_HOMEURL]:@"";
        self.myPhotoMD5=([dictionary objectForKey:KEY_MYPHOTOMD5]!=nil)?[dictionary valueForKey:KEY_MYPHOTOMD5]:@"";

        self.blockedDevices=([dictionary objectForKey:KEY_BLOCKEDDEVICES]!=nil)?[dictionary valueForKey:KEY_BLOCKEDDEVICES]:@"";
        
        self.announceText=([dictionary objectForKey:KEY_ANNOUNCE]!=nil)?[dictionary valueForKey:KEY_ANNOUNCE]:@"";
        self.isPlaySound=[[dictionary valueForKey:KEY_PLAYSOUND] boolValue];
        self.messageLimitPerUser=[[dictionary valueForKey:KEY_MESSAGELIMITPERUSER] boolValue];
        
        
        NSArray *cards=[dictionary objectForKey:KEY_CCARDS];
        if(cards){
            self.ccards=[NSMutableArray new];
            for (NSDictionary *item in cards){
                CCardInfo *card=[[CCardInfo alloc] initWithDictionary:item];
                if (card.name.length>0 && card.name.length<=MAX_CC_NAME_LEN && card.number.length>=MIN_CC_NUMBER_LEN && card.name.length<= MAX_CC_NUMBER_LEN) {
                    
                    [self.ccards addObject:card];
                }
                
            }
            //self.ccards=([dictionary objectForKey:KEY_CCARDS]!=nil)?[dictionary valueForKey:KEY_CCARDS]:[[NSMutableArray alloc] initWithCapacity:MAXCARDS];
        }
    }
    return self;
    
}

+(NSString *)getDisplayName:(NSString *)fullName{
    fullName=[fullName stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" "]];
    
    if(fullName.length==0)
        return nil;
    
    NSString *first;
    NSString *last;
    NSRange range=[fullName rangeOfString:@" "];
    if(range.location!=NSNotFound){
        first=[fullName substringToIndex:range.location];
        first = [first stringByReplacingCharactersInRange:NSMakeRange(0,1)
                                               withString:[[first substringToIndex:1] capitalizedString]];
        if(range.location+2<=fullName.length){
            last=[fullName substringWithRange:NSMakeRange(range.location+1, 1)];
            last = [last stringByReplacingCharactersInRange:NSMakeRange(0,1)
                                                   withString:[[last substringToIndex:1] capitalizedString]];
            return [NSString stringWithFormat:@"%@ %@",first,last];
        }
        else{
            //Does the string live in memory and it has atleast one letter?
            //if (first && [first length]>0) {
                //Yes. It is
                
            
            //}
            //else{
                //No
                
            //}
            return first;
        }
        
        
        //return result;
    }
    
    else{
        return fullName;
    }
    
    
}
@end
