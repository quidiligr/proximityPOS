//
//  Peer.h
//
//
//  Created by Romulo Quidilig.
//  Copyright (c) 2015 Sharecle Inc. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <MultipeerConnectivity/MCPeerID.h>
#import <MultipeerConnectivity/MCSession.h>

@interface PeerInfo : NSObject
//@property (nonatomic,strong) NSString *displayName;
//@property (nonatomic,strong) NSString *md5;
//@property(nonatomic,strong)NSString *inventoryID;

@property(nonatomic,strong) MCPeerID *peerID;
@property(nonatomic,strong)NSString *group;
@property(nonatomic,strong)NSString *deviceID;
@property(nonatomic,strong)NSString *deviceToken;
//@property(nonatomic)NSInteger device_num;

//@property float device_lat;
//@property float device_lng;
//@property NSInteger device_status;
//@property BOOL isLive;

//@property float salesTax;
/*@property float shippingCost;
@property BOOL acceptCash;
@property BOOL acceptCCard;
@property BOOL useApplePay;
*/


//@property NSInteger refundLevel;

//@property(nonatomic,strong)NSString *acceptedCards;
@property(nonatomic,strong)NSMutableArray *peers;
/*@property NSInteger minChargeAmount;
@property NSInteger maxChargeAmount;
@property NSInteger maxUnpaidOrdersPerCustomer;
*/





@property(nonatomic)MCSessionState sessionState;

@property(nonatomic,strong) NSString* paymentPublishableKey;
@property(nonatomic,strong) NSString* paymentPublishableKeyTest;
//@property(nonatomic,strong) NSString* paymentSecretKey;
@property(nonatomic,strong) NSString* paymentPostUrl;
/*@property(nonatomic,strong) NSString* currency;
@property(nonatomic,strong) NSString* currencySymbol;
*/
//@property(nonatomic)enum MCSessionState state;

-(instancetype)initWithPeerID:(MCPeerID *)peerID;
@end
