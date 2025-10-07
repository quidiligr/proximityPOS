//
//  Users.m
//  superkiosk
//
//  Created by Katherine Sheehy on 3/4/16.
//  Copyright © 2016 Sharecle. All rights reserved.
//

#import "UserGroup.h"

@implementation UserGroup

-(id)initWithName:(NSString *)name expanded:(BOOL) expanded{
    self = [super init];
    if (self) {
        self.name=name;
        self.expanded=expanded;
    }
    return self;
}
@end
