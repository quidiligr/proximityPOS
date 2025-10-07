//
//  Map2ViewController.m
//  superkiosk
//
//  Created by Katherine Sheehy on 7/1/16.
//  Copyright © 2016 Appcoda. All rights reserved.
//

#import "Map2ViewController.h"
#import "StoreAnnotation.h"
#import "StorePointAnnotation.h"
#import "defs.h"
#import "Util.h"
#import <LocalAuthentication/LocalAuthentication.h>

#define StoreNameKey @"StoreName"
#define LatitudeKey @"Latitude"
#define LongitudeKey @"Longitude"
#define StoreAddressKey @"StoreAddress"


static CLLocationDistance regionRadius=5000;


@interface Map2ViewController ()<CLLocationManagerDelegate>
{
    AppDelegate *_appDelegate;
    NSMutableArray *_stores;
    //NSDictionary *dictDevice;
    NSDictionary *selected_store_dict;
    NSInteger selectedAuthType;
    
    UIBarButtonItem *_backButtonItem;
    UIBarButtonItem *_myLocationButtonItem;
    UIBarButtonItem *_searchButtonItem;
    BOOL firstTime;
}

@property (strong, nonatomic) CLLocationManager *locationManager;
@end

@implementation Map2ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _appDelegate=ApplicationDelegate;
    
    firstTime=YES;
    // ** Don't forget to add NSLocationWhenInUseUsageDescription in MyApp-Info.plist and give it a string
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    // Check for iOS 8. Without this guard the code will crash with "unknown selector" on iOS 7.
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
    }
    
    [self.locationManager startUpdatingLocation];
    
    _mapView.showsUserLocation=YES;
    _mapView.delegate=self;
    
    
    _backButtonItem=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Back"] style:UIBarButtonItemStyleBordered target:self action:@selector(backButtonTapped:)];

     self.navigationItem.leftBarButtonItem=_backButtonItem;
    
    _searchButtonItem=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Search"] style:UIBarButtonItemStyleBordered target:self action:@selector(searchAction:)];
    
    
    _myLocationButtonItem=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"NearMe"] style:UIBarButtonItemStyleBordered target:self action:@selector(myLocationButtonTapped)];
    self.navigationItem.rightBarButtonItems=@[_myLocationButtonItem,_searchButtonItem];

    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(OnNotifySearchResult:) name:NOTIFY_SEARCH_RESULT object:nil];
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if(firstTime)
        [self reloadFromWeb];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{
    //_mapView.centerCoordinate=userLocation.location.coordinate;
    /*
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 800, 800);
    [self.mapView setRegion:[self.mapView regionThatFits:region] animated:YES];
    
    // Add an annotation
    MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
    point.coordinate = userLocation.coordinate;
    point.title = @"Where am I?";
    point.subtitle = @"I'm here!!!";

    
    [self.mapView addAnnotation:point];
    */
     [_locationManager stopUpdatingLocation];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(void) centerMapLocation:(CLLocation *) location{
    
    MKCoordinateRegion coordinateRegion= MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius * 2.0, regionRadius * 2.0);
    
    [_mapView setRegion:coordinateRegion];
    
}

-(void)reloadFromWeb//:(CLLocationCoordinate2D)withMyCoordinate
{
    [Util postSearchStores:@""];
}

-(void)reloadData//:(CLLocationCoordinate2D)withMyCoordinate
{
    id userLocation=[_mapView userLocation];
    
    if([_stores isEqual:[NSNull null]] || _stores==nil || [_stores count]==0 ){
        if([_mapView.annotations count]>0){
            NSMutableArray *pins=[[NSMutableArray alloc] initWithArray:_mapView.annotations];
            if(userLocation){
                [pins removeObject:userLocation];
            }
            [_mapView removeAnnotations:pins];
        }
       
        
    }
    else{
        CLLocation *initialLocation=nil;
        for(NSDictionary *item in _stores){

            CLLocationCoordinate2D itemCoordinate=CLLocationCoordinate2DMake([[item valueForKey:LatitudeKey] floatValue], [[item valueForKey:LongitudeKey] floatValue]);
            //StoreAnnotation *sa=[[StoreAnnotation alloc] initWithStoreInfo:s];//[[StoreAnnotation alloc] initWithTitle:store.storeName Location:storeCoordinates];
            //MKPointAnnotation *itemAnnotation=[[MKPointAnnotation alloc] init];
            StorePointAnnotation *itemAnnotation=[[StorePointAnnotation alloc] init];
            itemAnnotation.coordinate=itemCoordinate;
            itemAnnotation.title=[item valueForKey:StoreNameKey];
            itemAnnotation.subtitle=[item valueForKey:StoreAddressKey];
            itemAnnotation.deviceID=[item valueForKey:deviceIDKey];
            
            [_mapView addAnnotation:itemAnnotation];
            if(initialLocation==nil){
                initialLocation=[[CLLocation alloc] initWithLatitude:itemAnnotation.coordinate.latitude longitude:itemAnnotation.coordinate.longitude];
            }
        }
        
        if(userLocation!=nil){
            [self centerMapLocation:userLocation];
        }
        else{
        if(initialLocation!=nil){
            [self centerMapLocation:initialLocation];
        }
        }
        
    }
    
    
    



}

-(void)performValidDeviceSelected{
    NSString *deviceID= [selected_store_dict valueForKey:deviceIDKey];
    StoreHistory *selectedStore=[_appDelegate.historyModel storeWithStoreID:deviceID];
    if(selectedStore==nil)
        selectedStore=[_appDelegate.historyModel createStoreHistoryFromWeb:selected_store_dict];
        //if(selectedStore){
          //  _appDelegate.selectedStore=selectedStore;
           // [self.delegate map2didSelectStore:self];
        //}
        //else{
         //   return;
        //}
   // }
    //else{
     //   _appDelegate.selectedStore=selectedStore;
    //}
        //_appDelegate.selectedStore=selectedStore;
        [self.delegate map2didSelectStore:self withStore:selectedStore];
   
}

-(void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control{
    
    //id <MKAnnotation> annotation=[view annotation];
    id <MKAnnotation> annotation=[view annotation];
    
    
    if([annotation isKindOfClass:[MKPointAnnotation class]]){
        
        StorePointAnnotation *spa=(StorePointAnnotation *)annotation;
        
        NSPredicate *p=[NSPredicate predicateWithFormat:@"deviceID==%@",spa.deviceID];
        NSArray *results=[_stores filteredArrayUsingPredicate:p];
        if(results==nil ||  [results count]==0)
            return;
        selected_store_dict=[results firstObject];
                selectedAuthType=[[selected_store_dict valueForKey:authTypeKey] integerValue];
        if(selectedAuthType==0){
            [self performValidDeviceSelected];
        }
        else{
           
            
            [self authenticate];
        }
        
    }
   
}
-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
    // If it's the user location, just return nil.
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    
    NSUInteger index=[mapView.annotations indexOfObject:annotation];
    //for some reason mapView.annotations may include userlocation as annotation
    //so all we to manually adust it
    if(index>=[_stores count])
        index=[_stores count]-1;

    
    /*
    if(_stores==nil || [_stores count]==0)
        return nil;
    NSDictionary *store_dict=[_stores objectAtIndex:index];
    
    if(store_dict==nil)
        return nil;
    */
    // Handle any custom annotations.
    if ([annotation isKindOfClass:[MKPointAnnotation class]])
    {
        // Try to dequeue an existing pin view first.
        
        //Rom: this works if we use image instead of pin:
        //MKAnnotationView *pinView = (MKAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:@"CustomPinAnnotationView"];
        MKPinAnnotationView *pinView = (MKPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:@"CustomPinAnnotationView"];
        if (!pinView)
        {
            // If an existing pin view was not available, create one.
            
            //Rom: this works if we use image instead of pin:
            //pinView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"CustomPinAnnotationView"];
            
            pinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"CustomPinAnnotationView"];
            //pinView.animatesDrop = YES;
            pinView.canShowCallout = YES;
            
            //Rom: this works if we use image instead of pin:
            //pinView.image = [UIImage imageNamed:@"bluetooth"];
            
            pinView.pinColor=MKPinAnnotationColorRed;
            
            // Add a detail disclosure button to the callout.
            
            UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
            rightButton.tag=index;
            pinView.rightCalloutAccessoryView = rightButton;
            // Add an image to the left callout.
            UIImageView *iconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"empty"]];
            pinView.leftCalloutAccessoryView = iconView;
            
            
             //if(_stores==nil || [_stores count]==0)
            // return nil;
           
             NSDictionary *store_dict=[_stores objectAtIndex:index];
            
             
             //if(store_dict==nil)
            // return nil;
             
            if(store_dict!=nil){
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    NSString *store_photo=DICT_GET(store_dict,pictureFileKey);
                    if(store_photo!=nil && store_photo.length>0){
                    NSData *imageData=nil;
                    
                    
                    //NSString *store_photo=[NSString stringWithFormat:@"myphoto-%@.png",[store_dict valueForKey:deviceIdKey]];
                    
                    
                    
                    //try local copy first
                    NSString *filePath=[[AppDelegate getImagesPathForServer:[store_dict valueForKey:deviceIDKey]] stringByAppendingPathComponent:store_photo];
                    if([[NSFileManager defaultManager] fileExistsAtPath:filePath]){
                        imageData=[NSData dataWithContentsOfFile:filePath];
                        
                    }
                    else{ //try extrnal copy i.e. web
                        //uncomment this on prod:
                        //NSURL *url=[[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@/myphoto-%@.png",[storeAnnotation.storeInfo valueForKey:homeUrlKey],[storeAnnotation.storeInfo valueForKey:deviceIDKey]]];
                        NSURL *url=[[NSURL alloc] initWithString:[store_dict valueForKey:ImageLogoUrlKey]];
                        imageData=[[NSData alloc] initWithContentsOfURL:url];
                        
                        
                    }
                    
                    if (imageData!=nil) {
                        UIImage *pinImage=[[UIImage alloc] initWithData:imageData];
                        if(pinImage.size.height>50){
                            CGSize size=CGSizeMake(50.0,50.0);
                            UIGraphicsBeginImageContext(size);
                            [pinImage drawInRect:CGRectMake(0,0, size.width, size.height)];
                            UIImage *resizedImage= UIGraphicsGetImageFromCurrentImageContext();
                            UIGraphicsEndImageContext();
                            
                            UIImageView *newIconView = [[UIImageView alloc] initWithImage:resizedImage];
                            
                            pinView.leftCalloutAccessoryView = newIconView;
                            
                        }
                        else{
                            UIImageView *newIconView = [[UIImageView alloc] initWithImage:pinImage];
                            
                            pinView.leftCalloutAccessoryView = newIconView;
                        }
                        
                    }
                    }
                    
                });
            }
            
            
            pinView.calloutOffset = CGPointMake(0, 32);
        } else {
            pinView.annotation = annotation;
        }
        
        
        return pinView;
    }
    return nil;
}

//ROM: this works if we use image instead of pin

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation__:(id<MKAnnotation>)annotation{
    // If it's the user location, just return nil.
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    
    // Handle any custom annotations.
    if ([annotation isKindOfClass:[MKPointAnnotation class]])
    {
        // Try to dequeue an existing pin view first.
        MKAnnotationView *pinView = (MKAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:@"CustomPinAnnotationView"];
        if (!pinView)
        {
            // If an existing pin view was not available, create one.
            pinView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"CustomPinAnnotationView"];
            //pinView.animatesDrop = YES;
            pinView.canShowCallout = YES;
            pinView.image = [UIImage imageNamed:@"bluetooth"];
            
            NSUInteger index=[mapView.annotations indexOfObject:annotation];
            NSDictionary *store_dict=[_stores objectAtIndex:index];
            if(store_dict!=nil){
                  dispatch_async(dispatch_get_main_queue(), ^{
         
                  NSData *imageData=nil;
                      
                      
                  NSString *store_photo=[NSString stringWithFormat:@"myphoto-%@.png",[store_dict valueForKey:DeviceIdKey]];
         
                  //try local copy first
                  NSString *filePath=[[AppDelegate getImagesPathForServer:[store_dict valueForKey:DeviceIdKey]] stringByAppendingPathComponent:store_photo];
                  if([[NSFileManager defaultManager] fileExistsAtPath:filePath]){
                  imageData=[NSData dataWithContentsOfFile:filePath];
         
                  }
                  else{ //try extrnal copy i.e. web
                  //uncomment this on prod:
                  //NSURL *url=[[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@/myphoto-%@.png",[storeAnnotation.storeInfo valueForKey:homeUrlKey],[storeAnnotation.storeInfo valueForKey:deviceIDKey]]];
                  NSURL *url=[[NSURL alloc] initWithString:[store_dict valueForKey:ImageLogoUrlKey]];
                  imageData=[[NSData alloc] initWithContentsOfURL:url];
         
                  
                  }
                  
                  if (imageData!=nil) {
                      UIImage *pinImage=[[UIImage alloc] initWithData:imageData];
                      if(pinImage.size.height>50){
                          CGSize size=CGSizeMake(50.0,50.0);
                          UIGraphicsBeginImageContext(size);
                          [pinImage drawInRect:CGRectMake(0,0, size.width, size.height)];
                          UIImage *resizedImage= UIGraphicsGetImageFromCurrentImageContext();
                          UIGraphicsEndImageContext();
                          pinView.image=resizedImage;
                      }
                      else{
                          pinView.image=pinImage;//[[UIImage alloc] initWithData:imageData];
                      }
                  
                  }
                  
                  });
            }
            pinView.calloutOffset = CGPointMake(0, 32);
        } else {
            pinView.annotation = annotation;
        }
        return pinView;
    }
    return nil;
}
//
//-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
//
//if ([annotation isKindOfClass:[MKUserLocation class]])
//return nil;
//
//// Handle any custom annotations.
//if ([annotation isKindOfClass:[MKPointAnnotation class]])
//{
//    // Try to dequeue an existing pin view first.
//    MKAnnotationView *pinView = (MKAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:@"CustomPinAnnotationView"];
//    if (!pinView)
//    {
//        // If an existing pin view was not available, create one.
//        pinView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"CustomPinAnnotationView"];
//        //pinView.animatesDrop = YES;
//        pinView.canShowCallout = YES;
//        //pinView.image = [UIImage imageNamed:@"pizza_slice_32.png"];
//        /*
//         dispatch_async(dispatch_get_main_queue(), ^{
//         
//         NSData *imageData=nil;
//         NSString *store_photo=[NSString stringWithFormat:@"myphoto-%@.png",[storeAnnotation.storeInfo valueForKey:DeviceIdKey]];
//         
//         //try local copy first
//         NSString *filePath=[[AppDelegate getImagesPathForServer:[storeAnnotation.storeInfo valueForKey:DeviceIdKey]] stringByAppendingPathComponent:store_photo];
//         if([[NSFileManager defaultManager] fileExistsAtPath:filePath]){
//         imageData=[NSData dataWithContentsOfFile:filePath];
//         
//         }
//         else{ //try extrnal copy i.e. web
//         //uncomment this on prod:
//         //NSURL *url=[[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@/myphoto-%@.png",[storeAnnotation.storeInfo valueForKey:homeUrlKey],[storeAnnotation.storeInfo valueForKey:deviceIDKey]]];
//         NSURL *url=[[NSURL alloc] initWithString:[storeAnnotation.storeInfo valueForKey:ImageLogoUrlKey]];
//         imageData=[[NSData alloc] initWithContentsOfURL:url];
//         
//         
//         }
//         
//         if (imageData!=nil) {
//         
//         annotationView.image=[[UIImage alloc] initWithData:imageData];
//         
//         }
//         
//         });
//         */
//        pinView.calloutOffset = CGPointMake(0, 32);
//    } else {
//        pinView.annotation = annotation;
//    }
//    return pinView;
//}
//return nil;
//}
/*
-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
    static NSString *identifier=@"StoreAnnotation";
    if([annotation isKindOfClass:[StoreAnnotation class]]){ //if this is a custom pin class
        StoreAnnotation *storeAnnotation=(StoreAnnotation *)annotation;
        MKPinAnnotationView *annotationView=(MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        if(annotationView==nil){
            
            //annotationView=storeAnnotation.annotationView;
            annotationView=[[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
        }
        else{
            
            annotationView.annotation=annotation;
        }
        
        if(annotation !=mapView.userLocation){
            
        }
        //annotationView.enabled=YES;
        //annotationView.canShowCallout=YES;
        //TODO: annotationView.image=[UIImage imageNamed:@""];
        
        //annotationView.rightCalloutAccessoryView=[UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        
        //annotationView.image=
        //CLLocationCoordinate2D storeCoordinates=CLLocationCoordinate2DMake(store.device_lat, store.device_lat);
        
 
        
        return annotationView;
    }
    else
        return nil;
    
}
 */
- (IBAction)backButtonTapped:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)OnNotifySearchResult:(NSNotification *)notification{
    _stores=[notification.userInfo valueForKey:@"results"];
   
    [self reloadData];
    
}

-(void)authenticate{//:(int) authType{//:(StoreHistory *)device{

    if(_appDelegate.appConfig.userInfo.userToken==nil
       || _appDelegate.appConfig.userInfo.userToken.length==0){
        
        [self showLogin:nil];
        return;
    }
    switch(selectedAuthType){
        case 1:{
            [self performValidDeviceSelected];
        }
            break;
        case 2:
        {
               //show finger print
                [self authenicatewithPIN];
            
            
        }
            break;
        case 3:
        {
                //show finger print
                [self authenicatewithTouchID];
            
        }
            break;
        default:
        {
            [AppDelegate toast:@"Authentication not set." duration:2];
        }
            
    }
    
}

- (void)authenicatewithPIN{
    UIAlertView *alert;
    if(_appDelegate.appConfig.userInfo.PIN==nil || _appDelegate.appConfig.userInfo.PIN.length==0){
        alert= [[UIAlertView alloc] initWithTitle:@"New PIN" message:@"Enter your new 4 digit PIN" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
        
    }
    else{
        alert= [[UIAlertView alloc] initWithTitle:@"PIN" message:@"Enter 4 digit PIN" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
        
    }
    
    alert.tag=100;
    alert.alertViewStyle=UIAlertViewStyleSecureTextInput;
    [alert show];
}


- (void)authenicatewithTouchID{
    LAContext *context = [[LAContext alloc] init];
    
    NSError *error = nil;
    if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error]) {
        [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics
                localizedReason:@"Are you the device owner?"
                          reply:^(BOOL success, NSError *error) {
                              
                              if (error) {
                                  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                                  message:@"There was a problem verifying your identity."
                                                                                 delegate:nil
                                                                        cancelButtonTitle:@"Ok"
                                                                        otherButtonTitles:nil];
                                  [alert show];
                                  return;
                              }
                              
                              if (success) {
                                  /*UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success"
                                   message:@"You are the device owner!"
                                   delegate:nil
                                   cancelButtonTitle:@"Ok"
                                   otherButtonTitles:nil];
                                   [alert show];
                                   */
                                  //if(_appDelegate.selectedStore!=nil)
                                      //[self showMainTabbarController];
                                    //  [self dismissViewControllerAnimated:YES completion:nil];
                                  [self performValidDeviceSelected];
                                  
                              } else {
                                  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                                  message:@"You are not the device owner."
                                                                                 delegate:nil
                                                                        cancelButtonTitle:@"Ok"
                                                                        otherButtonTitles:nil];
                                  [alert show];
                              }
                              
                          }];
        
    } else {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"Your device cannot authenticate using TouchID."
                                                       delegate:nil
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil];
        [alert show];
        
    }
}


-(void)showLogin:(NSString *)returnViewController{
    LoginViewController* vc = (LoginViewController*) [ApplicationDelegate.storyBoard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    vc.delegate=self;
    //vc.returnViewController=returnViewController;
    UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:vc];
    
    
    [self presentViewController:nav animated:YES completion:nil];
}

-(void)didLoginSuccess:(LoginViewController *)viewController {
    [viewController dismissViewControllerAnimated:YES completion:^{
    if(selectedAuthType==1)
        [self performValidDeviceSelected];
    else{
        [self authenticate];
    }
    }
     ];
}
-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    
    //NSString *title=[alertView buttonTitleAtIndex:buttonIndex];
    //if([title isEqualToString:@"Authenticate"]){
    
    if(alertView.tag==100) {//PIN
        UITextField * alertTextField = [alertView textFieldAtIndex:0];
        if(_appDelegate.appConfig.userInfo.PIN==nil || _appDelegate.appConfig.userInfo.PIN.length==0){
            _appDelegate.appConfig.userInfo.PINRetry=0;
            if(alertTextField.text.length==4){
                _appDelegate.appConfig.userInfo.PIN=alertTextField.text;
                [self performValidDeviceSelected];
            }
            else{
                UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"New PIN" message:@"Please enter 4 digit PIN." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
                alert.tag=100;
                alert.alertViewStyle=UIAlertViewStyleSecureTextInput;
                [alert show];
            }
        }
        else{
        
        
        //if(alertTextField.text.length>0){
        if ([alertTextField.text isEqualToString:_appDelegate.appConfig.userInfo.PIN]) {
            _appDelegate.appConfig.userInfo.PINRetry=0;
            [self performValidDeviceSelected];
        }
        
        else{
            if(_appDelegate.appConfig.userInfo.PINRetry<=10){
                _appDelegate.appConfig.userInfo.PINRetry++;
                UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Enter PIN" message:[NSString stringWithFormat:@"Retries %i, %i left",_appDelegate.appConfig.userInfo.PINRetry,10-_appDelegate.appConfig.userInfo.PINRetry]  delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
                alert.tag=100;
                alert.alertViewStyle=UIAlertViewStyleSecureTextInput;
                [alert show];
            }
            else{
                //_appDelegate.appConfig.userInfo.PIN=nil;
                //UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Max of 5 attempts exceeded." message:[NSString stringWithFormat:@"PIN has been disabled. Please check email %@ to Reset PIN.",_appDelegate.appConfig.userInfo.email] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
                UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"PIN Locked" message:@"Max of 10 attempts exceeded. Please check email to Reset PIN." delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
                alert.tag=100;
                alert.alertViewStyle=UIAlertViewStyleSecureTextInput;
                [alert show];
            }
        }
        }
    }

}


-(void)myLocationButtonTapped{
    id userLocation=[_mapView userLocation];
    if(userLocation!=nil)
        [self centerMapLocation:userLocation];
}

- (IBAction)searchAction:(id)sender{
    
    MapSearchViewController *vc=[_appDelegate.storyBoard instantiateViewControllerWithIdentifier:@"MapSearchViewController"];
    vc.delegate=self;
    //vc.searchText=_searchTextField.text;
    //vc.selectedInventory=_appDelegate.selectedStore.inventory;
    UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:vc];
    
    if(_appDelegate.isIpad){
        //if(_popOver==nil){
        
        
        _popOver=[[UIPopoverController alloc] initWithContentViewController:nav];
        //_chatPopover.popoverContentSize=CGSizeMake(self.view.frame.size.width/2, self.view.frame.size.height);
        _popOver.popoverContentSize=CGSizeMake(200.0, self.view.frame.size.height);
        [_popOver presentPopoverFromBarButtonItem:_searchButtonItem permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        //[_popOver presentPopoverFromRect:CGRectMake(_searchTextField.frame.origin.x, _searchTextField.frame.origin.y, _searchTextField.frame.size.width, _searchTextField.frame.size.height) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        /*}
         else{
         [_popOver dismissPopoverAnimated:YES];
         _popOver=nil;
         }
         */
    }
    else{
        //[self performSegueWithIdentifier:@"toMenuSearchViewController" sender:self];
        [self presentViewController:nav animated:YES completion:nil];
    }
}

-(void)mapSearchDidSelectItem:(MapSearchViewController *)controller item:(NSDictionary *)item{
    //[self.mapView.annotations objectAtIndex:<#(NSUInteger)#>]
    firstTime=NO;
    [controller dismissViewControllerAnimated:YES completion:^{
        //[self.view endEditing:YES];
        //[self performSegueWithIdentifier:@"toProductViewController" sender:nil];
        CLLocationCoordinate2D itemCoordinate=CLLocationCoordinate2DMake([[item valueForKey:LatitudeKey] floatValue], [[item valueForKey:LongitudeKey] floatValue]);
        
        CLLocation *loc=[[CLLocation alloc] initWithLatitude:itemCoordinate.latitude longitude:itemCoordinate.longitude];
        [self centerMapLocation:loc];

    }];

}

@end
