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
@property (nonatomic) BOOL publishedInternet;
@property (nonatomic) BOOL publishedLocal;
@property (nonatomic,copy) NSString* pictureFile;
@property(nonatomic,assign)int categoryID;
@property(nonatomic,copy)NSString *categoryUID;
@property(nonatomic,assign)NSUInteger sortNumber;
@property(nonatomic,copy)NSMutableArray *searchedProducts;
@property(nonatomic,copy)NSMutableArray *products;
@property(nonatomic,assign)BOOL expanded;
@property(nonatomic,copy)NSMutableArray *sortedProducts;
@property(nonatomic,copy)NSIndexPath *indexPath;

-(NSDictionary *)toNSDictionary;
+(ProductCategory *)fromDictionary:(NSDictionary *)dictionary;
-(NSArray *)sort;
@end
