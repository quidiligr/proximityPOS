//
//  FileStore.m
//  Sharecle
//
//  Created by Romulo Quidilig on 7/23/14.
//  Copyright (c) 2014 Sharecle Inc. All rights reserved.
//

#import "MyFolder.h"
#import "MyFile.h"
#import "defs.h"
//#import "DataModel.h"

@implementation MyFolder

- (id)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
       
        self.foldername = [dictionary objectForKey:@"foldername"];
        self.folderid=DICT_GET(dictionary, @"folderid");
        self.totalfiles=DICT_GET(dictionary, @"count");
      
       /*
        NSArray *filesArray=[dictionary objectForKey:@"files" ];
        
        if (filesArray!=(id)[NSNull null] && filesArray!=nil && filesArray.count>0){
            //self.messages=[[BroadcastMessageAPI alloc] initWithDictionary:[dictionary objectForKey:@"messages" ]];
            //if(self.messages==nil)
            self.files=[NSMutableArray array];
            for(id item in filesArray){
                [self.files addObject: [[MyFile alloc] initWithDictionary:item] ];
                
            }
        }
        
        else
        */
         //   self.files=[NSMutableArray array];
        
        
        
    }
    
    return self;
}

- (BOOL)isEqual:(id)object {
    if (![object isKindOfClass:[MyFolder class]]) {
        return NO;
    }
    
    MyFolder *other = (MyFolder *)object;
    return [other.folderid isEqualToNumber:self.folderid];
}


@end
