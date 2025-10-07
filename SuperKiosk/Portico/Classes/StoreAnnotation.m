//
//  StoreAnnotation.m
//  superkiosk
//
//  Created by Katherine Sheehy on 7/1/16.
//  Copyright © 2016 Appcoda. All rights reserved.
//

#import "StoreAnnotation.h"
#define StoreNameKey @"StoreName"
#define LatitudeKey @"Latitude"
#define LongitudeKey @"Longitude"

@implementation StoreAnnotation
/*
-(id)initWithTitle:(NSString *)newTitle Location:(CLLocationCoordinate2D)location{
    self=[super init];
    if(self){
        _title=newTitle;
        _coordinate=location;
        
    }
    return self;
}
*/

-(id)initWithStoreInfo:(NSDictionary *)storeInfo{
    self=[super init];
    if(self){
        _storeInfo=storeInfo;
        _title=[storeInfo valueForKey:StoreNameKey];//newTitle;
        _coordinate=CLLocationCoordinate2DMake([[storeInfo valueForKey:LatitudeKey] floatValue], [[storeInfo valueForKey:LongitudeKey] floatValue]);//location;
        //_deviceID=store.deviceID;
    }
    return self;
}

-(MKAnnotationView *)annotationView{
    MKAnnotationView *annotationView=[[MKAnnotationView alloc] initWithAnnotation:self reuseIdentifier:@"StoreAnnotation"];
    annotationView.enabled=YES;
    annotationView.canShowCallout=YES;
    //TODO: annotationView.image=[UIImage imageNamed:@""];
    
    annotationView.rightCalloutAccessoryView=[UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    return annotationView;
}
@end
