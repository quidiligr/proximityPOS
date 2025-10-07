//
//  FileStore.h
//  Sharecle
//
//  Created by Romulo Quidilig on 7/23/14.
//  Copyright (c) 2014 Sharecle Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import <CoreData/CoreData.h>

typedef NS_ENUM(NSInteger, MyFileType) {
    MyFileTypeFile  = 1,
    MyFileTypeFolder = 0
};

@interface MyFile : NSObject

@property (nonatomic, copy) NSNumber * fileid;
@property (nonatomic, copy) NSNumber * folderid;
@property (nonatomic, copy) NSNumber * parent_folderid;
@property (nonatomic, copy) NSString * foldername;
@property (nonatomic, copy) NSNumber * totalfiles;
@property (nonatomic, copy) NSString * contenttype;
@property (nonatomic, copy) NSDate * createdon;
@property (nonatomic, copy) NSData * data;
//@property (nonatomic, retain) NSString * fileextension;
@property (nonatomic, copy) NSString * filename;
//@property (nonatomic, strong) NSString * filecontenttype;
@property (nonatomic, copy) NSString * fileimage;
@property (nonatomic) MyFileType  type;
@property (nonatomic, copy) NSString * fileuid;
//@property (nonatomic, strong) NSString * fileurl;
//@property (nonatomic, retain) NSNumber * loggedinuserid;
//@property (nonatomic, retain) NSString * mediatype;
//@property (nonatomic, retain) NSString * path;
@property (nonatomic, copy) NSNumber * filesize;
//@property (nonatomic, retain) NSDate * expires;
- (id)initWithDictionary:(NSDictionary *)dictionary;


@end
