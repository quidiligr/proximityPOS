//
//  RWEmailManager.m
//  RWPuppies
//
//  Created by Pietro Rea on 1/2/13.
//  Copyright (c) 2013 Pietro Rea. All rights reserved.
//

#import "CheckoutCart.h"
#import "RWEmailManager.h"

#import "AFNetworking.h"

#define kConfirmationEmailPostURL @"YOUR-EMAIL-POST-URL"

@interface RWEmailManager()
@property (strong, nonatomic) NSString* name;
@property (strong, nonatomic) NSString* email;
@property (strong, nonatomic) AFJSONRequestOperation* httpOperation;
@property (strong, nonatomic) StoreHistory* store;
@end

@implementation RWEmailManager

- (id)initWithRecipient:(NSString*)name recipientEmail:(NSString *)email andStore:(StoreHistory *)store {
    self = [super init];
    if (self) {
        self.name = name;
        self.email = email;
        self.store=store;
        
    }
    return self;
}

- (void)sendConfirmationEmail {
    [self sendConfirmationEmailWithSuccessBlock:nil failureBlock:nil];
}

- (void)sendConfirmationEmailWithSuccessBlock:(void(^)(void))successBlock
                                 failureBlock:(void(^)(void))failureBlock {
    
    NSURL* postURL = [NSURL URLWithString:kConfirmationEmailPostURL];
    AFHTTPClient* httpClient = [AFHTTPClient clientWithBaseURL:postURL];
    httpClient.parameterEncoding = AFJSONParameterEncoding;
    [httpClient registerHTTPOperationClass:[AFJSONRequestOperation class]];
    [httpClient setDefaultHeader:@"Accept" value:@"text/json"];
    
    NSMutableDictionary* postRequestDictionary = [[NSMutableDictionary alloc] init];
    
    //CheckoutCart* checkoutCart = [CheckoutCart sharedInstance];
    NSMutableArray* productArray = [[NSMutableArray alloc] init];
    
    for (Product* product in self.store.cart.itemsArray) {
        NSMutableDictionary* productDict = [[NSMutableDictionary alloc] init];
        productDict[@"productName"] = product.name;
        productDict[@"productPrice"] =[NSNumber numberWithFloat:product.price];
        [productArray addObject:productDict];
    }
    
    postRequestDictionary[@"recipientName"] = self.name;
    postRequestDictionary[@"recipientEmail"] = self.email;
    postRequestDictionary[@"recipientProducts"] = productArray;
    
    NSMutableURLRequest* request = [httpClient requestWithMethod:@"POST" path:nil parameters:postRequestDictionary];
    self.httpOperation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        if (successBlock) successBlock();
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        if (failureBlock) failureBlock();
    }];
    
    [self.httpOperation start];
}

@end
