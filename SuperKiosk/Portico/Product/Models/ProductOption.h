//
//  ProductOption.h
//  superkiosks
//
//  Created by Katherine Sheehy on 8/22/16.
//  Copyright © 2016 Sharecle. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ProductOptionItem.h"

@interface ProductOption : NSObject<NSCoding>
@property (nonatomic,copy)NSString *name;
@property (nonatomic,strong)NSMutableArray *selections;
@property (nonatomic)NSInteger maxSelected; //0 allow all
@property (nonatomic)NSInteger minSelected;
@property (nonatomic)NSInteger ID;
@property (nonatomic,copy)NSString *UID;
@property (nonatomic,copy)NSString *parentUID;
@property (nonatomic)NSInteger sortNum;
@property (nonatomic,strong)ProductOptionItem *selectedOptionItem;
@property (nonatomic,assign)BOOL isNew;


- (NSMutableDictionary *)toNSDictionary;
- (id)initWithDictionary:(NSDictionary *)dictionary;
@end
