//
//
//
//
//  Created by Romulo Quidilig on 3/19/15.
//  Copyright (c) 2015 Sharecle Inc. All rights reserved.
//

#import "CardInfo.h"
//#define kInventoryAddress @"http://kiosk.sharecle.com/inventory/"
static NSString* const NameKey = @"name";
static NSString* const NumberKey = @"number";
static NSString* const EmailKey = @"email";
static NSString* const CVCKey = @"cvc";
static NSString* const ExpYearKey = @"expYear";
static NSString* const ExpMonthKey = @"expMonth";

@implementation CardInfo

- (id)initWithCoder:(NSCoder*)decoder
{
    if ((self = [super init]))
    {
        self.name = [decoder decodeObjectForKey:NameKey];
       self.number=[decoder decodeObjectForKey:NumberKey];
        self.email = [decoder decodeObjectForKey:EmailKey];
        self.cvc = [decoder decodeObjectForKey:CVCKey];
        self.expMonth = [decoder decodeObjectForKey:ExpMonthKey];
        self.expYear = [decoder decodeObjectForKey:ExpYearKey];
        
       
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder*)encoder
{
    [encoder encodeObject:self.name forKey:NameKey];
    [encoder encodeObject:self.number forKey:NumberKey];
    [encoder encodeObject:self.email forKey:EmailKey];
    [encoder encodeObject:self.cvc forKey:CVCKey];
    [encoder encodeObject:self.expMonth forKey:ExpMonthKey];
    [encoder encodeObject:self.expYear forKey:ExpYearKey];
    
   
}

@end
