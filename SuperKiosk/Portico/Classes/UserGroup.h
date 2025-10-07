//
//  Users.h
//  superkiosk
//
//  Created by Katherine Sheehy on 3/4/16.
//  Copyright © 2016 Sharecle. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserGroup : NSObject

@property(nonatomic,strong) NSString *name;
@property(nonatomic) BOOL expanded;
@property(nonatomic,strong)NSArray *peers;
-(instancetype)initWithName:(NSString *)name expanded:(BOOL) expanded;
@end
