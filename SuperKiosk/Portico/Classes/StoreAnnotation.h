//
//  StoreAnnotation.h
//  superkiosk
//
//  Created by Katherine Sheehy on 7/1/16.
//  Copyright © 2016 Appcoda. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
//#import "StoreHistory.h"

@interface StoreAnnotation : NSObject<MKAnnotation>
@property(nonatomic,readonly)CLLocationCoordinate2D coordinate;
@property(copy,nonatomic)NSString *title;

//@property(copy,nonatomic)NSString *deviceID;

@property(copy,nonatomic)NSDictionary *storeInfo;
//-(id)initWithTitle:(NSString *)newTitle Location:(CLLocationCoordinate2D)location;
-(id)initWithStoreInfo:(NSDictionary *)store;

-(MKAnnotationView *)annotationView;
@end
