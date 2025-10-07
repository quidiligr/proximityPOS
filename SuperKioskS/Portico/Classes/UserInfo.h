//
//  UserInfo.h
//  Sharecle
//
//  Created by Romulo Quidilig on 4/19/14.
//  Copyright (c) 2014 Sharecle Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
/*#import <CoreData/CoreData.h>


@interface UserInfo : NSManagedObject
*/
@interface UserInfo : NSObject<NSCoding>

@property (nonatomic, strong) NSString * deviceToken;
@property (nonatomic, strong) NSString * password;
@property (nonatomic, strong) NSNumber * userid;
@property (nonatomic, strong) NSString * username;
@property (nonatomic, strong) NSString * userToken;
@property (nonatomic, strong) NSString * displayName;
@property (nonatomic, strong) NSString * homeUrl;

@property (nonatomic, strong) NSString * userTableNumber;


@property (nonatomic,strong) UIImage *photo;

@end
