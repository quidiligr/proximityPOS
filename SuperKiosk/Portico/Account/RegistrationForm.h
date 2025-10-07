//
//  RegistrationForm.h
//  Sharecle
//
//  Created by Romulo Quidilig on 7/19/14.
//  Copyright (c) 2014 Sharecle Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface RegistrationForm : NSManagedObject

@property (nonatomic, retain) NSString * firstname;
@property (nonatomic, retain) NSString * lastname;
@property (nonatomic, retain) NSString * username;

@end
