//
//  NSDate.m
//
//  Created by Romulo Quidilig on 3/19/15.
//  Copyright (c) 2015 Sharecle Inc. All rights reserved.
//

//#import <Foundation/Foundation.h>
#import "NSString+JSONDate.h"
@implementation NSString (JSONDate)
-(NSDate*) JSONDate
{
    
    if(self==(id)[NSNull null] || self==nil || self.length<9)
        return nil;
    // NSLog(@"jsonDateString=%@", jsonDateString);
    /*/Date(6716160000)/
      /Date(1368128341000)/
     */
    NSInteger offset = [[NSTimeZone defaultTimeZone] secondsFromGMT]; //get number of seconds to add or subtract according to the client default time zone
    
    NSInteger startPosition = [self rangeOfString:@"("].location + 1; //start of the date value
    NSInteger endPosition = [self rangeOfString:@")"].location; //start of the date value
    NSInteger length=endPosition-startPosition;
    NSString *datePart=[self substringWithRange:NSMakeRange(startPosition, length)];
    //NSTimeInterval unixTime = [[jsonDateString substringWithRange:NSMakeRange(startPosition, 13)] doubleValue] / 1000; //WCF will send 13 digit-long value for the time interval since 1970 (millisecond precision) whereas iOS works with 10 digit-long values (second precision), hence the divide by 1000
    NSTimeInterval unixTime = [datePart doubleValue]/1000; //WCF will send 13 digit-long value for the time interval since 1970 (millisecond precision) whereas iOS works with 10 digit-long values (second precision), hence the divide by 1000
    
    NSDate* date=[[NSDate dateWithTimeIntervalSince1970:unixTime] dateByAddingTimeInterval:offset];
    
    return date;
}
@end