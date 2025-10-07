//
//  FileStore.h
//  Sharecle
//
//  Created by Romulo Quidilig on 7/23/14.
//  Copyright (c) 2014 Sharecle Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import <CoreData/CoreData.h>


@interface MyFolder : NSObject

@property (nonatomic, copy) NSNumber * folderid;
@property (nonatomic, copy) NSString * foldername;
@property (nonatomic, copy) NSNumber * totalfiles;
//@property(nonatomic,strong) NSMutableArray *files;
//@property (nonatomic, retain) NSDate * expires;
- (id)initWithDictionary:(NSDictionary *)dictionary;


@end
