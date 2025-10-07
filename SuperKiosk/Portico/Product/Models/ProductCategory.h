//
//  IODItem.h
//  iOSDiner
//
//  Created by Romulo Quidilig on 3/19/15.
//  Copyright (c) 2015 Sharecle Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProductCategory : NSObject <NSCoding>

@property (nonatomic,copy) NSString* name;
@property (nonatomic,copy) NSString* detail;
@property (nonatomic,copy) NSString* pictureFile;
@property(nonatomic,assign)NSInteger categoryID;
@property (nonatomic) BOOL expanded;
@property(nonatomic,strong)NSMutableArray *searchedProducts;
@property(nonatomic,copy)NSArray* products;
@property(nonatomic,assign)NSUInteger sortNumber;

@property (nonatomic,assign) BOOL publishedLocal;
@property (nonatomic,assign) BOOL publishedInternet;

-(id)initWithDictionary:(NSDictionary *)dictionary;


@end
