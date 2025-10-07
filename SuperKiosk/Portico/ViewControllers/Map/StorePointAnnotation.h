//
//  StorePointAnnotation.h
//  superkiosk
//
//  Created by Katherine Sheehy on 9/1/16.
//  Copyright © 2016 Appcoda. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface StorePointAnnotation : MKPointAnnotation
@property (nonatomic,strong)NSString *deviceID;
@end
