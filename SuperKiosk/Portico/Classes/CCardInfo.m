//
//  UserInfo.m
//  Sharecle
//
//  Created by Romulo Quidilig on 4/19/14.
//  Copyright (c) 2014 Sharecle Inc. All rights reserved.
//

#import "CCardInfo.h"
#import "defs_userinfo.h"

@implementation CCardInfo
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
    
    [dictionary setValue:self.name forKey:KEY_CCNAME];
    [dictionary setValue:self.number forKey:KEY_CCNUMBER];
    [dictionary setValue:self.cvc forKey:KEY_CCCVV];
    [dictionary setValue:[NSNumber numberWithUnsignedInteger:self.expMonth] forKey:KEY_CCEXPMONTH];
    [dictionary setValue:[NSNumber numberWithUnsignedInteger:self.expYear] forKey:KEY_CCEXPYEAR];
   // [dictionary setValue:self.ccEmail forKey:KEY_CCEMAIL];
    [dictionary setValue:[NSNumber numberWithBool:self.isDefault] forKey:KEY_CCDEFAULT];
    
    
    return dictionary;
}

- (id)initWithDictionary:(NSDictionary *)dictionary{
    //NSMutableDictionary *dictionary=[NSMutableDictionary new];
    self = [super init];
    if (self) {
        self.name=([dictionary objectForKey:KEY_CCNAME]==nil)?@"":[dictionary valueForKey:KEY_CCNAME];
        self.number=([dictionary objectForKey:KEY_CCNUMBER]==nil)?@"":[dictionary valueForKey:KEY_CCNUMBER];
        self.cvc=([dictionary objectForKey:KEY_CCCVV]==nil)?@"":[dictionary valueForKey:KEY_CCCVV];
        self.expYear=([dictionary objectForKey:KEY_CCEXPYEAR]==nil)?2030:[[dictionary valueForKey:KEY_CCEXPYEAR] integerValue];
        self.expMonth=([dictionary objectForKey:KEY_CCEXPMONTH]==nil)?1:[[dictionary  valueForKey:KEY_CCEXPMONTH] integerValue];
       // self.ccEmail=([dictionary objectForKey:KEY_CCEMAIL]==nil)?@"":[dictionary valueForKey:KEY_CCEMAIL];
        self.isDefault=([dictionary objectForKey:KEY_CCDEFAULT]==nil)?NO:[[dictionary valueForKey:KEY_CCDEFAULT] boolValue];
        
        

        //[dictionary setValue:[NSNumber numberWithBool:self.ccDefault] forKey:KEY_CCDEFAULT];
        
        
        
    }
    return self;
    
}
@end
