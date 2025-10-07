//
//
//
//
//  Created by Romulo Quidilig on 3/19/15.
//  Copyright (c) 2015 Sharecle Inc. All rights reserved.
//

#import "CardInfo.h"
//#define kInventoryAddress @"http://kiosk.sharecle.com/inventory/"
static NSString* const NameKey = @"Name";
static NSString* const CardNumberKey = @"CardNumber";
static NSString* const EmailKey = @"Email";
static NSString* const CVCNumberKey = @"CVCNumber";
static NSString* const ExpYearKey = @"ExpYear";
static NSString* const ExpMonthKey = @"ExpMonth";

@implementation CardInfo

- (id)initWithCoder:(NSCoder*)decoder
{
    if ((self = [super init]))
    {
        self.name = [decoder decodeObjectForKey:NameKey];
       self.cardNumber=[decoder decodeObjectForKey:CardNumberKey];
        self.email = [decoder decodeObjectForKey:EmailKey];
        self.CVCNumber = [decoder decodeObjectForKey:CVCNumberKey];
        self.expMonth = [decoder decodeObjectForKey:ExpMonthKey];
        self.expYear = [decoder decodeObjectForKey:ExpYearKey];
        
       
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder*)encoder
{
    [encoder encodeObject:self.name forKey:NameKey];
    [encoder encodeObject:self.cardNumber forKey:CardNumberKey];
    [encoder encodeObject:self.email forKey:EmailKey];
    [encoder encodeObject:self.CVCNumber forKey:CVCNumberKey];
    [encoder encodeObject:self.expMonth forKey:ExpMonthKey];
    [encoder encodeObject:self.expYear forKey:ExpYearKey];
    
   
}

@end
