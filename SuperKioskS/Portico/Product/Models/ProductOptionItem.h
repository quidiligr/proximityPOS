//
//  ProductOptionItem.h
//  superkiosks
//
//  Created by Katherine Sheehy on 8/22/16.
//  Copyright © 2016 Sharecle. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProductOptionItem : NSObject<NSCoding>
@property (nonatomic,strong)NSString *title;
@property (nonatomic)NSInteger ID;
@property (nonatomic)BOOL isDefault;
@property (nonatomic,strong)NSString* UID;
@property (nonatomic,strong)NSString* shortDesc;
@property (nonatomic,strong)NSString* parentUID;
@property (nonatomic,assign)NSInteger addlCost;
//@property (nonatomic,assign)NSInteger price;
@property (nonatomic,assign)NSInteger sortNum;
@property (nonatomic,assign)BOOL selected;
@property (nonatomic,assign)BOOL isNew;

- (NSMutableDictionary *)toNSDictionary;
- (id)initWithDictionary:(NSDictionary *)dictionary;
@end
