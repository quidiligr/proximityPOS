//
//  FileStore.m
//  Sharecle
//
//  Created by Romulo Quidilig on 7/23/14.
//  Copyright (c) 2014 Sharecle Inc. All rights reserved.
//

#import "MyFile.h"
#import "defs.h"
//#import "DataModel.h"

@implementation MyFile

- (id)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
       
        self.createdon = [AppDelegate deserializeJsonDateString:[dictionary objectForKey:@"createdon"]] ;
        
        
        self.contenttype = [dictionary objectForKey:@"contenttype"];
        if(self.contenttype==(id)[NSNull null])
            self.contenttype=@"";

        
        //self.fileextension=DICT_GET(dictionary, @"fileextension");
        self.filename=DICT_GET(dictionary, @"filename");
        self.fileuid=DICT_GET(dictionary, @"fileuid");
        if(self.fileuid==(id)[NSNull null])
            self.fileuid=@"";
        

        self.fileimage=DICT_GET(dictionary, @"fileimage");
        if(self.fileimage==(id)[NSNull null])
           self.fileimage=@"";
        
        self.fileid = DICT_GET(dictionary, @"fileid");
       // self.folderid = DICT_GET(dictionary, @"folderid");
       // self.loggedinuserid = DICT_GET(dictionary, @"loggedinuserid");
       // self.mediatype = DICT_GET(dictionary, @"mediatype");
        //  self.path = DICT_GET(dictionary, @"path");
         self.filesize = DICT_GET(dictionary, @"filesize");
        
         self.parent_folderid=DICT_GET(dictionary, @"parent_folderid");
        self.type=[DICT_GET(dictionary, @"type") integerValue];
        
        self.foldername = [dictionary objectForKey:@"foldername"];
        self.folderid=DICT_GET(dictionary, @"folderid");
       
        self.totalfiles=DICT_GET(dictionary, @"totalfiles");
        
    }
    
    return self;
}

- (BOOL)isEqual:(id)object {
    if (![object isKindOfClass:[MyFile class]]) {
        return NO;
    }
    
    MyFile *other = (MyFile *)object;
    return [other.fileuid isEqualToString:self.fileuid];
}


@end
