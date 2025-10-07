//
//  UserInfo.m
//  Sharecle
//
//  Created by Romulo Quidilig on 4/19/14.
//  Copyright (c) 2014 Sharecle Inc. All rights reserved.
//

#import "UserInfo.h"
#import "defs.h"


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

- (id)initWithCoder:(NSCoder*)decoder
{
    
    if ((self = [super init]))
    {
        /*
         @property (nonatomic, strong) NSString * deviceToken;
         @property (nonatomic, strong) NSString * password;
         @property (nonatomic, strong) NSNumber * userid;
         @property (nonatomic, strong) NSString * username;
         @property (nonatomic, strong) NSString * userToken;
         @property (nonatomic, strong) NSString * displayName;
         @property (nonatomic, strong) NSString * homeUrl;
         
         @property (nonatomic, strong) NSString * userTableNumber;
         
         
         @property (nonatomic,strong) UIImage *photo;
         */
        self.deviceToken= [decoder decodeObjectForKey:deviceTokenKey];
        self.userToken= [decoder decodeObjectForKey:userTokenKey];
        self.username= [decoder decodeObjectForKey:usernameKey];
        self.displayName= [decoder decodeObjectForKey:displayNameKey];
        self.homeUrl= [decoder decodeObjectForKey:homeUrlKey];
        
        
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder*)encoder
{
    
    [encoder encodeObject:self.deviceToken forKey:deviceTokenKey];
    [encoder encodeObject:self.userToken forKey:userTokenKey];
     [encoder encodeObject:self.username forKey:usernameKey];
     [encoder encodeObject:self.displayName forKey:displayNameKey];
     [encoder encodeObject:self.homeUrl forKey:homeUrlKey];
}
@end
