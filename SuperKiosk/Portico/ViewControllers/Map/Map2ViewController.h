//
//  Map2ViewController.h
//  superkiosk
//
//  Created by Katherine Sheehy on 7/1/16.
//  Copyright © 2016 Appcoda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "MapSearchViewController.h"
#import "LoginViewController.h"
@protocol Map2ViewControllerDelegate;
@interface Map2ViewController : UIViewController<MKMapViewDelegate,LoginDelegate,MapSearchViewControllerDelegate>
@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property(nonatomic,assign)id<Map2ViewControllerDelegate> delegate;

@property (nonatomic, strong) UIPopoverController *popOver;

@end

@protocol Map2ViewControllerDelegate <NSObject>

//-(void)map2didSelectStore:(Map2ViewController *)viewController store:(StoreHistory *)store;
-(void)map2didSelectStore:(Map2ViewController *)viewController withStore:(StoreHistory *)store;

@end