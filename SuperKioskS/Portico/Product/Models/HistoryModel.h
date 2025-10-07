//
//  IODOrder.h
//  iOSDiner
//
//  Created by Romulo Quidilig on 3/19/15.
//  Copyright (c) 2015 Sharecle Inc. All rights reserved.
//

#import <Foundation/Foundation.h>


@class OrderHistory;
//@class AppConfigModel;

@interface HistoryModel : NSObject
+ (HistoryModel *)sharedInstance;
@property (nonatomic,strong) NSMutableDictionary* history;

//@property (nonatomic,strong) NSMutableDictionary* filteredHistory;

@property (nonatomic,copy)NSString* filename; //deviceid
//@property (nonatomic)BOOL isActive;

//@property (nonatomic,strong) NSMutableArray *days;
//@property (nonatomic,strong) NSMutableArray *sortedDays;


@property(nonatomic,assign) BOOL isServer;

- (void)loadHistory;


- (void)saveHistory;

-(NSUInteger)trashCount;
-(NSArray *)trashArray;

- (void)addHistory:(OrderHistory*)order;

- (void)addOrUpdateHistory:(OrderHistory *)order;

-(NSArray *)search:(NSString *)searchText withSearchType:(NSString *)searchType withStatus:(NSString *)status withStartDate:(NSString*)startDate withEndDate:(NSString*)endDate isLive:(BOOL)isLive;
-(NSArray *)searchWithUserID:(NSUInteger )userID isLive:(BOOL)isLive;
-(NSArray *)searchWithUserName:(NSString *)userName isLive:(BOOL)isLive;
-(NSArray *)searchWithDeviceID:(NSString *)deviceID isLive:(BOOL)isLive;
-(NSDictionary *)synchFilteredHistory:(BOOL)isLive showClosed:(BOOL)showClosed showCancelled:(BOOL)showCancelled showRefunds:(BOOL)showRefunds showFailed:(BOOL)showFailed showPaid:(BOOL)showPaid showUnpaid:(BOOL)showUnpaid;

-(NSInteger)synchLastOrderNumber;

-(void)emtpyTrash:(BOOL)forced;
//-(void)deleteFromTrash:(OrderHistory *)item;
//this will the global storage from getFilteredHistory result;
@property(nonatomic,strong) NSDictionary *filteredHistory;
@property(nonatomic) NSInteger lastOrderNumber;


@end
