//
//  UserInfo.h
//  Sharecle
//
//  Created by Romulo Quidilig on 4/19/14.
//  Copyright (c) 2014 Sharecle Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CCardInfo.h"
#import <CoreLocation/CoreLocation.h>

@interface UserInfo : NSObject
@property (nonatomic, strong) NSString * deviceID;
@property (nonatomic, strong) NSString * deviceToken;

@property(nonatomic,strong) CLLocation *device_last_location;
@property float device_lat;
@property float device_lng;

//APNS remote notication
@property (nonatomic, strong) NSDate * lastmessagedate;
@property (nonatomic, strong) NSNumber * lastmessageid;
@property (nonatomic, strong) NSNumber * loggedIn;
@property (nonatomic, strong) NSString * PIN;
@property (nonatomic) int PINRetry;
@property (nonatomic, strong) NSString * password;
@property (nonatomic, strong) NSString * password_hash;


//added for login
@property (nonatomic, strong) NSString * user_key;
@property (nonatomic, strong) NSString *device_uuid;
@property (nonatomic, strong) NSString *device_name;

//
@property (nonatomic, strong) NSNumber * userid;
@property (nonatomic, strong) NSString * username;
@property (nonatomic, strong) NSString * password_tmp;

@property (nonatomic, strong) NSString * userToken;
@property (nonatomic, strong) NSString * displayName;
@property (nonatomic, strong) NSString * myPhotoMD5;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *phone;

@property (nonatomic)NSUInteger authLevel;

/*
 
 _appConfig.userInfo.picid=DICT_GET(jsonuser, @"picid");
 _appConfig.userInfo.folderid=DICT_GET(jsonuser, @"folderid");
 _appConfig.userInfo.lat=DICT_GET(jsonuser, @"latitude");
 _appConfig.userInfo.lng=DICT_GET(jsonuser, @"longitude");
 _appConfig.userInfo.city=DICT_GET(jsonuser, @"city");
 _appConfig.userInfo.state=DICT_GET(jsonuser, @"state");
 _appConfig.userInfo.country=DICT_GET(jsonuser, @"country");
 _appConfig.userInfo.zipcode=DICT_GET(jsonuser, @"zipcode");
 
 _appConfig.userInfo.homenumber=DICT_GET(jsonuser, @"homenumber");
 _appConfig.userInfo.mobilenumber=DICT_GET(jsonuser, @"mobilenumber");
 */
@property (nonatomic, strong) NSString * picid;
@property (nonatomic, strong) NSString * folderid;
@property (nonatomic, strong) NSString * latitude;
@property (nonatomic, strong) NSString * longitude;
@property (nonatomic, strong) NSString * city;
@property (nonatomic, strong) NSString * state;
@property (nonatomic, strong) NSString * country;
@property (nonatomic, strong) NSString * zipcode;
@property (nonatomic, strong) NSString * homenumber;
@property (nonatomic, strong) NSString * mobilenumber;


@property (nonatomic, strong) NSString * firstname;
@property (nonatomic, strong) NSString * lastname;
@property (nonatomic, strong) NSString * fullName;
@property (nonatomic, strong) NSString * announceText;
//@property (nonatomic, strong) NSString * lastName;
@property (nonatomic, strong) NSString * email;
@property (nonatomic, strong) NSString * homeUrl;
@property  BOOL isVisible;
@property(assign)NSInteger messageLimitPerUser;
@property(assign)BOOL isPlaySound;


/*
@property (nonatomic, strong) NSString * ccName;
@property (nonatomic, strong) NSString * ccNumber;
//@property (nonatomic, strong) NSString * ccExpDate;
@property (nonatomic, strong) NSNumber * ccExpMonth;
@property (nonatomic, strong) NSNumber * ccExpYear;
@property (nonatomic, strong) NSString * ccCVV;
@property (nonatomic, strong) NSString * ccEmail;
*/
@property NSMutableArray *ccards;
@property NSMutableArray *blockedDevices;
@property (nonatomic, strong) CCardInfo *selectedCard;

@property (nonatomic, strong) NSString * userTableNumber;



@property (nonatomic,strong) UIImage *photo;

- (id)initWithDictionary:(NSDictionary *)dictionary;
- (NSDictionary *)toNSDictionary;
+(NSString *)getDisplayName:(NSString *)fullName;
@end
