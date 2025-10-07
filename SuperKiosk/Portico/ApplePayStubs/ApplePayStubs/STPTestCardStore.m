//
//  STPTestCardStore.m
//  StripeExample
//
//  Created by Jack Flintermann on 9/30/14.
//  Copyright (c) 2014 Stripe. All rights reserved.
//



#import "STPTestCardStore.h"
#import "AppConfigModel.h"
#import "AppDelegate.h"
#import "CCardInfo.h"
#import "Stripe.h"


NSString *const STPSuccessfulChargeCardNumber = @"4242424242424242";
NSString *const STPFailingChargeCardNumber =    @"4000000000000002";

@interface STPTestCardStore ()
@property (nonatomic) NSArray *allItems;
@end

@implementation STPTestCardStore

@synthesize selectedItem;
@synthesize selectedStore;

+ (NSDictionary *)defaultCard {
    NSMutableDictionary *card = [NSMutableDictionary new];
    
    AppDelegate *_appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    CCardInfo *selectedCard=nil;
    
    if([_appDelegate.appConfig.userInfo.ccards count]>0){
        
         selectedCard=[_appDelegate.appConfig.userInfo.ccards objectAtIndex:0];
        for (CCardInfo *c in _appDelegate.appConfig.userInfo.ccards) {
            if(c.isDefault){
                selectedCard=c;
                break;
            }
        }
    }

    if(selectedCard==nil){
        selectedCard=[[CCardInfo alloc] init];
        selectedCard.expYear=2030;
        selectedCard.expMonth=1;
        if(_appDelegate.appConfig.userInfo.ccards==nil)
            _appDelegate.appConfig.userInfo.ccards=[NSMutableArray new];
        
        [_appDelegate.appConfig.userInfo.ccards addObject:selectedCard];

    }
    
            if(!selectedCard.name)
            selectedCard.name=_appDelegate.appConfig.userInfo.fullName;
        
        
        
        if(!selectedCard.number)
            selectedCard.number=@"";
    
        
        if (!selectedCard.expMonth)
            selectedCard.expMonth=1;
        
    
        if (!selectedCard.expYear)
            selectedCard.expYear=2030;
        
    
        if (!selectedCard.cvc)
            selectedCard.cvc=@"";
        
    
        
        selectedCard.isValid=[self validateCustomerInfo:selectedCard showError:NO];
        
    _appDelegate.appConfig.userInfo.selectedCard=selectedCard;

    card[@"number"] = selectedCard.number;
    card[@"name"] = selectedCard.name;
    
    
    card[@"last4"] =(selectedCard.number.length>4)?[selectedCard.number substringFromIndex:selectedCard.number.length-4]:@"";
    card[@"expMonth"] = @(selectedCard.expMonth);
    
    card[@"expYear"] = @(selectedCard.expYear);
    card[@"cvc"] = selectedCard.cvc;
    //CCardInfo *newCard=[[CCardInfo alloc] initWithDictionary:card];
    //[_appDelegate.appConfig.userInfo.ccards addObject:[[CCardInfo alloc] initWithDictionary:card]];

    
    return [card copy];
    
    
}

+ (NSDictionary *)defaultCardTest {
    AppDelegate *_appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSMutableDictionary *card = [NSMutableDictionary new];
    CCardInfo *selectedCard=_appDelegate.appConfig.testCard;
    if(selectedCard.name==nil){
        selectedCard.name=@"";
        if(_appDelegate.appConfig.userInfo.fullName!=nil)
            selectedCard.name=_appDelegate.appConfig.userInfo.fullName;
        else if(_appDelegate.appConfig.userInfo.displayName!=nil)
            selectedCard.name=_appDelegate.appConfig.userInfo.displayName;
            
            
    }
    _appDelegate.appConfig.userInfo.selectedCard=selectedCard;

//rom added to simplify thisng
   // card[@"cardinfo"]=selectedCard;
    //
    card[@"number"] = selectedCard.number;
    card[@"name"] =selectedCard.name;
    
    
    
    card[@"last4"] =selectedCard.last4;
    card[@"expMonth"] = @(selectedCard.expMonth);
    
    card[@"expYear"] = @(selectedCard.expYear);
    card[@"cvc"] = selectedCard.cvc;
    
    
    return [card copy];
    
    
}
 


//ROM added
+ (BOOL)validateCustomerInfo:(STPCard *)stripeCard showError:(BOOL) showError {
    
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Please try again"
                                                     message:@"Please enter all required information"
                                                    delegate:nil
                                           cancelButtonTitle:@"OK"
                                           otherButtonTitles:nil];
    
    //1. Validate name & email
    if (stripeCard.name.length == 0
        //|| self.emailTextField.text.length == 0
        )
    {
        if(showError)
            [alert show];
        return NO;
    }
    
    //2. Validate card number, CVC, expMonth, expYear
    NSError* error = nil;
    [stripeCard validateCardReturningError:&error];
    
    //3
    if (error) {
        alert.message = [error localizedDescription];
        if(showError)
            [alert show];
        return NO;
    }
    
    return YES;
}

+ (NSDictionary *)defaultFailingCard {
    NSMutableDictionary *card = [NSMutableDictionary new];
    card[@"name"] = @"Stripe Test Card";
    card[@"number"] = STPFailingChargeCardNumber;
    card[@"last4"] = [STPFailingChargeCardNumber substringFromIndex:STPSuccessfulChargeCardNumber.length-4];
    card[@"expMonth"] = @12;
    card[@"expYear"] = @2030;
    card[@"cvc"] = @"123";
    return [card copy];
}

- (instancetype)initWithLiveCard {
    self = [super init];
    if (self) {
        self.allItems = @[[self.class defaultCard]];// @[[self.class defaultCard], [self.class defaultFailingCard]];
        self.selectedItem = self.allItems[0];
    }
    return self;
}

- (instancetype)initWithTestCard {
    self = [super init];
    if (self) {
        self.allItems = @[[self.class defaultCardTest]];// @[[self.class defaultCard], [self.class defaultFailingCard]];
        self.selectedItem = self.allItems[0];
    }
    return self;
}


- (NSArray *)descriptionsForItem:(id)item {
    NSDictionary *card = (NSDictionary *)item;
    NSString *number = card[@"number"];
    NSString *suffix = [number substringFromIndex:MAX((NSInteger)[number length] - 4, 0)];
    return @[card[@"name"], [NSString stringWithFormat:@"**** **** **** %@", suffix]];
}

@end

