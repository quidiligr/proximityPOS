
//
//  Util.m
//  superkiosks
//
//  Created by Katherine Sheehy on 4/25/16.
//  Copyright © 2016 Sharecle. All rights reserved.
//

#import "Util.h"
#import "NSData+MD5.h"
#import "RNEncryptor.h"
#import "RNDecryptor.h"
#import "StoreHistory.h"
#import "Product.h"
#import "defs.h"
@implementation Util

+ (AFHTTPClient *)clientSharedInstance {
    //static HistoryModel*  _sharedHistory;
    static AFHTTPClient *_sharedClient;
    
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        
        _sharedClient = [AFHTTPClient clientWithBaseURL:[NSURL URLWithString:ServerURL]];
        
        
    });
    
    return _sharedClient;
}


#pragma mark number display
+(NSString *)decimalDisplay:(double)decimal{
    NSNumberFormatter *fmt=[[NSNumberFormatter alloc] init];
    [fmt setPositiveFormat:@"0.##"];
    return [fmt stringFromNumber:[NSNumber numberWithDouble:decimal]]; //[NSString stringWithFormat:@"%.02f",discount];
    
    //s=[s stringByReplacingOccurrencesOfString:@".00" withString:@""];
    
    
    //return s;
}
+(NSString *)discountToString:(double)discount{
    NSNumberFormatter *fmt=[[NSNumberFormatter alloc] init];
    [fmt setPositiveFormat:@"0.##"];
    return [fmt stringFromNumber:[NSNumber numberWithDouble:discount]]; //[NSString stringWithFormat:@"%.02f",discount];
    
    //s=[s stringByReplacingOccurrencesOfString:@".00" withString:@""];
    
    
    //return s;
}
+(NSString *)priceIntToString:(NSInteger)price currency:(NSString *)currency{
    /*
     NSNumberFormatter *fmt=[[NSNumberFormatter alloc] init];
     [fmt setPositiveFormat:@"0.##"];
     return [NSString stringWithFormat:@"%@%@",currency,[fmt stringFromNumber:[NSNumber numberWithDouble:price]]]; //[NSString stringWithFormat:@"%.02f",discount];
     */
    double dbl_price=(double)price/100;
    
    if(currency==nil || currency.length==0)
        return [NSString stringWithFormat:@"%.2f",dbl_price];
    else
        return [NSString stringWithFormat:@"%@%.2f",currency,dbl_price];
    
    
    
}

+(NSString *)priceToString:(double)price currency:(NSString *)currency{
    NSNumberFormatter *fmt=[[NSNumberFormatter alloc] init];
    [fmt setPositiveFormat:@"0.##"];
    return [NSString stringWithFormat:@"%@%@",currency,[fmt stringFromNumber:[NSNumber numberWithDouble:price]]]; //[NSString stringWithFormat:@"%.02f",discount];
    
    //s=[s stringByReplacingOccurrencesOfString:@".00" withString:@""];
    
    
    //return s;
}

+ (CGSize)sizeForText:(NSString*)text{
    
    bool isIpad=UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad;
    
    UIFont *font;
    
    if(isIpad)
        font=[UIFont systemFontOfSize:FONTSIZE_IPAD];
    else
        font=[UIFont systemFontOfSize:[UIFont systemFontSize]];
    
    
    CGRect textRect = [text boundingRectWithSize:CGSizeMake((isIpad)?482:200, 9999)
                                         options:NSStringDrawingUsesLineFragmentOrigin
                                      attributes:@{NSFontAttributeName:font}
                                         context:nil];
    CGSize textSize =textRect.size;
    
    
    
    
    
    CGSize bubbleSize;
    bubbleSize.width = textSize.width;// + TextLeftMargin + TextRightMargin;
    //if(isIpad)
    bubbleSize.height = textSize.height+30;// + TextTopMargin + TextBottomMargin;
    //else
    //   bubbleSize.height = textSize.height+18;
    
    if(isIpad){
        if (bubbleSize.width < 50)
            bubbleSize.width = 50;
        
        if (bubbleSize.height < 90)
            bubbleSize.height = 90;
    }
    else{
        if (bubbleSize.width < 50)
            bubbleSize.width = 50;
        
        if (bubbleSize.height < 40)
            bubbleSize.height = 40;
        
    }
    // bubbleSize.width += HorzPadding*2;
    // bubbleSize.height += VertPadding*2;
    
    return bubbleSize;
}

//image
//image
+(UIImage *)resizeImage:(UIImage*)image newSize:(CGSize)newSize {
    CGRect newRect = CGRectIntegral(CGRectMake(0, 0, newSize.width, newSize.height));
    CGImageRef imageRef = image.CGImage;
    
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // Set the quality level to use when rescaling
    CGContextSetInterpolationQuality(context, kCGInterpolationHigh);
    CGAffineTransform flipVertical = CGAffineTransformMake(1, 0, 0, -1, 0, newSize.height);
    
    CGContextConcatCTM(context, flipVertical);
    // Draw into the context; this scales the image
    CGContextDrawImage(context, newRect, imageRef);
    
    // Get the resized image from the context and a UIImage
    CGImageRef newImageRef = CGBitmapContextCreateImage(context);
    UIImage *newImage = [UIImage imageWithCGImage:newImageRef];
    
    CGImageRelease(newImageRef);
    UIGraphicsEndImageContext();
    
    return newImage;
}

+(void) postUploadBeforeSend:(NSData *)filedata filename:(NSString *)filename contenttype:(NSString *)mimetype{
    AppDelegate *_appDelegate=ApplicationDelegate;
    AFHTTPClient *_client=[Util clientSharedInstance];
    
    
    
    
    NSString *md5=[filedata MD5];
    
    NSError *error;
    NSString *info=[NSString stringWithFormat:@"usertoken=%@&md5=%@&filename=%@&mimetype=%@"
                    ,_appDelegate.appConfig.userInfo.userid==nil?@"":_appDelegate.appConfig.userInfo.userid
                    ,md5
                    ,filename
                    ,mimetype];
    
    NSData *data = [info dataUsingEncoding:NSUTF8StringEncoding];
    NSData *encryptedData = [RNEncryptor encryptData:data
                                        withSettings:kRNCryptorAES256Settings
                                            password:A_SECRET_PASSWORD
                                               error:&error];
    NSString *base64Encoded=[encryptedData base64EncodedStringWithOptions:0];//[NSString
    
    if(error!=nil){
#ifdef DEBUG
        NSLog(@"encryptData error=%@",[error localizedDescription]);
#endif
        [AppDelegate toast:[error localizedDescription] duration:2.0];
        return;
    }
    /*
     NSDictionary *params = @{@"cmd":@"120.1.1",
     @"usertoken": _appDelegate.appConfig.user_userToken, //_dataModel.userInfo.userToken,
     @"md5": md5,
     @"mimetype": mimetype,
     @"filename":filename//message.imagefileuid==nil?@"":message.imagefileuid//,
     // @"autoplay": message.fileuid==nil?@"":message.fileuid
     
     
     };
     */
    NSDictionary *params = @{@"cmd":@"120.1.1",
                             //@"user_id":[_dataModel userId],
                             @"p": base64Encoded//_dataModel.userInfo.password
                             };
    
    MBProgressHUD* hud = [MBProgressHUD showHUDAddedTo:_appDelegate.window.rootViewController.view animated:YES];
    hud.labelText = NSLocalizedString(@"Sending...", nil);
    // [_client postPath:ServerApiPath
    NSMutableURLRequest *request = [_client multipartFormRequestWithMethod:@"POST" path:ServerApiPath parameters:params constructingBodyWithBlock: ^(id <AFMultipartFormData>formData) {
        
        /*if (_needVoiceUpload && message.fileuid.length>0 && [message.filelen longValue]>28
         
         )
         {
         if(filedata){
         [formData  appendPartWithFileData: filedata name:@"autoplay" fileName:message.fileuid mimeType:message.filecontenttype];
         }
         
         }
         
         if (_needPhotoUpload && message.imagefileuid.length>0
         
         )
         {
         */
        
        //we will allow 0 byte for menu.plist
        //if(filedata!=nil){
        
        
        [formData  appendPartWithFileData: filedata name:@"attachment" fileName:filename mimeType:mimetype];
        //}
        
        //}
        
        
    }];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         
         //if ([self isViewLoaded])
         [MBProgressHUD hideHUDForView:_appDelegate.window.rootViewController.view animated:YES];
         
         if([operation.response statusCode] != 200){
             
             
             //ShowErrorAlert(@"There was an error communicating with the server");
             [AppDelegate toast:@"There was an error communicating with the server" duration:2.0];
         }
         else {
             
             if(operation.responseString==nil)
                 return;
             
             
             NSError* error;
             NSDictionary* json=[NSJSONSerialization JSONObjectWithData:operation.responseData options:kNilOptions error:&error];
             
             
             
             NSNumber* success=[json objectForKey:@"success"];
             
             if([success intValue]==1){
                 /*TODO
                  if (isPrivate) {
                  [self postSendPrivate:message];
                  }
                  else{
                  [self postSendPublic:message];
                  }
                  */
             }
             else{
                 //ShowErrorAlert(@"There was an error processing your request. Please try again later.");
                 [AppDelegate toast:@"There was an error processing your request. Please try again later." duration:2.0];
                 
                 
             }
         }
         
         
         
     }
     
                                     failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         
         //if ([self isViewLoaded]) {
         [MBProgressHUD hideHUDForView:_appDelegate.window.rootViewController.view animated:YES];
         
         //ShowErrorAlert(@"There was an error processing your request. Please try again later.");
         [AppDelegate toast:@"There was an error processing your request. Please try again later." duration:2.0];
         //}
     }];
    
    [operation start];
}


+ (void)httpGetInventoryWithStore:(StoreHistory *)store
{
    /*
    if(_appDelegate.appConfig.user_userToken==nil)
    {
        [self postLoginRequest];
        return;
    }
    */
    AppDelegate *_appDelegate=ApplicationDelegate;
    
    NSError *error;
    /*
    NSString *info=[NSString stringWithFormat:@"usertoken=%@&deviceid=%@&inventoryid=%@"
                    ,_appDelegate.appConfig.userInfo.userToken,store.deviceID
                    ,store.inventoryId
                    
                    ];
    
    */
    //NSString *info=[NSString stringWithFormat:@"usertoken=%@&deviceid=%@"
    //                ,_appDelegate.appConfig.userInfo.userToken,store.deviceID
    //                ];
    if(_appDelegate.appConfig.userInfo.username==nil || _appDelegate.appConfig.userInfo.username.length==0){
        _appDelegate.appConfig.userInfo.username=@"guest";
    }
    NSString *info=[NSString stringWithFormat:@"username=%@&user_deviceid=%@&storeid=%@&deviceid=%@"
                    ,_appDelegate.appConfig.userInfo.username,_appDelegate.appConfig.userInfo.deviceID ,store.storeID,store.deviceID
                    ];
    NSData *data = [info dataUsingEncoding:NSUTF8StringEncoding];
    NSData *encryptedData = [RNEncryptor encryptData:data
                                        withSettings:kRNCryptorAES256Settings
                                            password:A_SECRET_PASSWORD
                                               error:&error];
    NSString *base64Encoded=[encryptedData base64EncodedStringWithOptions:0];//[NSString
    
    
    if(error!=nil){
#ifdef DEBUG
        NSLog(@"encryptData error=%@",[error localizedDescription]);
#endif
        return;
    }
    MBProgressHUD* hud = [MBProgressHUD showHUDAddedTo:_appDelegate.window.rootViewController.view animated:YES];
    hud.labelText = NSLocalizedString(@"Loading", nil);
    
    
    
    /*NSDictionary *params = @{@"cmd":@"100",
     //@"user_id":[_dataModel userId],
     @"deviceid": _appDelegate.userInfo.deviceID,
     @"username":_nicknameTextField.text,
     @"password":_secretCodeTextField.text//_dataModel.userInfo.password
     };
     */
    NSDictionary *params = @{@"cmd":@"300",
                             //@"user_id":[_dataModel userId],
                             @"p": base64Encoded//_dataModel.userInfo.password
                             };
    AFHTTPClient *_client=[Util clientSharedInstance];
    [_client postPath:ServerApiPath//@"/portico/api"
           parameters:params
              success:^(AFHTTPRequestOperation *operation, id responseObject) {
                  
                  //if ([self isViewLoaded]) {
                      [MBProgressHUD hideHUDForView:_appDelegate.window.rootViewController.view animated:YES];
                      if([operation.response statusCode] != 200) {
                          [AppDelegate ShowErrorAlert:NSLocalizedString(@"There was an error communicating with the server", nil)];
                      } else {
                          
                          //NSLog(operation.responseString);
                          
                          NSError* error;
                          NSDictionary* json=[NSJSONSerialization JSONObjectWithData:operation.responseData options:kNilOptions error:&error];
                          //NSDictionary* VLDirectory=[json objectForKey:@"VLDirectory"];
                          NSNumber* success=[json objectForKey:@"success"];
                          if([success intValue]==1){
                              //clean-up
                              //[self reset];
                              //NSDictionary *result=[json objectForKey:@"result"];
                              
                              
                              NSString *base64String=[json objectForKey:@"result"];
                              
#ifdef DEBUG
                              NSLog(@"base64String=%@",base64String);
#endif
                              NSData *base64Data=[[NSData alloc] initWithBase64EncodedString:base64String options:0];
                              
                              //NSError *error;
                              NSData *decryptedData = [RNDecryptor decryptData:base64Data
                                                                  withPassword:A_SECRET_PASSWORD
                                                                         error:&error];
                              
                              if(error!=nil){
#ifdef DEBUG
                                  NSLog(@"encryptData error=%@",[error localizedDescription]);
#endif
                                  return;
                              }
                              
                              //     NSString *stringInfo=[[NSString alloc] initWithData:decryptedData encoding:NSUTF8StringEncoding];
                              
                              //NSData *data=[stringInfo dataUsingEncoding:NSUTF8StringEncoding];
                              // NSError *error;
                              
                              NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:decryptedData options:NSJSONReadingMutableContainers error:&error];
                              
                              //[Util saveOrUpdateStoreInfoFromWeb:[dict objectForKey:@"store"]];
                              if(store.inventory==nil)
                                  store.inventory=[InventoryItem new];
                              
                              //store.inventory_dict=[dict valueForKey:KEY_ACTION_PARAM];
#ifdef DEBUG
                              NSLog(@"dict=%@",dict);
#endif
                              [store.inventory deserialize:dict];
                              
                              [_appDelegate.historyModel saveHistory];
                              
                              
                              
                              
                              [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_RECEIVED_MENU object:nil];
                              
                              //download images if needed
                              //this should be implemented in menuviewcollection lazy image loading
                             /* if([store.inventory.products count]>0){
                                  for(Product *prod in store.inventory.products){
                                      [prod downloadImage:_appDelegate.selectedStore];
                                  }
                              }
                              */
                              
                          }
                          else{
                              
                              
                          }
                          
                          
                          
                          
                      }
                 // }
              } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                  //if ([self isViewLoaded]) {
                      [MBProgressHUD hideHUDForView:_appDelegate.window.rootViewController.view animated:YES];
                      [AppDelegate ShowErrorAlert:[error localizedDescription]];
                  //}
              }];
}


+(void)saveOrUpdateStoreInfoFromWeb:(NSDictionary*) jsondevice{
//    //0: error 1:registered 2:approved/can go live 3:cancelled
//    _appConfig.device_status=[DICT_GET(jsondevice, @"status") intValue];
//    //if(_appConfig.device_status==DEVICE_STATUS_APPROVED)
//    //    _appConfig.isLive=YES;
//    
//    
//    
//    
//    _appConfig.device_lat=[DICT_GET(jsondevice, @"lat") floatValue];
//    _appConfig.device_lng=[DICT_GET(jsondevice, @"lng") floatValue];
//    
//    
//    
//    _appConfig.device_name=DICT_GET(jsondevice, @"name");
//    _appConfig.device_id=DICT_GET(jsondevice, @"deviceid");
//    _appConfig.device_num=DICT_GET_INT(jsondevice, @"devicenum");
//    //_appDelegate.userInfo.deviceID=_appDelegate.appConfig.device_id;
//    
//    _appConfig.device_address=DICT_GET(jsondevice, @"address");
//    _appConfig.device_categoryid=[DICT_GET(jsondevice, @"categoryid") intValue];
//    
//    _appConfig.useClientToken=DICT_GET_INT(jsondevice, @"useclienttoken");
//    _appConfig.paymentProvider=DICT_GET(jsondevice, @"provider");
//    _appConfig.paymentPostUrl=DICT_GET(jsondevice, @"posturl");
//    
//    _appConfig.paymentPublishableKey=DICT_GET(jsondevice, @"publishablekey");
//    _appConfig.paymentSecretKey=DICT_GET(jsondevice, @"secretkey");
//    
//    _appConfig.paymentPublishableKeyTest=DICT_GET(jsondevice, @"testpublishablekey");
//    _appConfig.paymentSecretKeyTest=DICT_GET(jsondevice, @"testsecretkey");
//    
//    
//    /*
//     _appConfig.acceptedCards=DICT_GET(jsondevice, @"acceptedcards");
//     
//     _appConfig.salesTax=DICT_GET_FLOAT(jsondevice, @"salestax");
//     
//     _appConfig.minChargeAmount=DICT_GET_INT(jsondevice, @"mincharge");
//     
//     _appConfig.maxChargeAmount=DICT_GET_INT(jsondevice, @"maxcharge");
//     
//     
//     _appConfig.useApplePay=[DICT_GET(jsondevice, @"useapplepay") boolValue];
//     
//     _appConfig.acceptCCard=[DICT_GET(jsondevice, @"acceptccard") boolValue];
//     _appConfig.acceptCash=[DICT_GET(jsondevice, @"acceptcash") boolValue];
//     */
//    
//    
//    
//    
//    
//    //}
    
    
    
}

+ (void)postSearchStores:(NSString *)keywords
{
    /*
    if(_appDelegate.appConfig.user_userToken==nil)
    {
        [self postLoginRequest];
        return;
    }
    */
    AppDelegate *_appDelegate=ApplicationDelegate;
    
    NSError *error;
    NSString *userToken=(_appDelegate.appConfig.userInfo.userToken==nil || _appDelegate.appConfig.userInfo.userToken.length==0)?@"":_appDelegate.appConfig.userInfo.userToken;
    //NSString *userName=(_appDelegate.appConfig.userInfo.username==nil || _appDelegate.appConfig.userInfo.username==0)?@"":_appDelegate.appConfig.userInfo.username;
    
    NSString *info=[NSString stringWithFormat:@"usertoken=%@&deviceid=%@&islive=%@&keywords=%@"
                    ,userToken
                    ,_appDelegate.appConfig.userInfo.deviceID
                    ,@(_appDelegate.appConfig.isLive)
                    ,[keywords stringByReplacingOccurrencesOfString:@"&" withString:@"%26"]
                    
                    ];
    
    
    NSData *data = [info dataUsingEncoding:NSUTF8StringEncoding];
    NSData *encryptedData = [RNEncryptor encryptData:data
                                        withSettings:kRNCryptorAES256Settings
                                            password:A_SECRET_PASSWORD
                                               error:&error];
    NSString *base64Encoded=[encryptedData base64EncodedStringWithOptions:0];//[NSString
    
    
    if(error!=nil){
#ifdef DEBUG
        NSLog(@"encryptData error=%@",[error localizedDescription]);
#endif
        return;
    }
    MBProgressHUD* hud = [MBProgressHUD showHUDAddedTo:_appDelegate.window.rootViewController.view animated:YES];
    hud.labelText = NSLocalizedString(@"Loading", nil);
    
    
    
    /*NSDictionary *params = @{@"cmd":@"100",
     //@"user_id":[_dataModel userId],
     @"deviceid": _appDelegate.userInfo.deviceID,
     @"username":_nicknameTextField.text,
     @"password":_secretCodeTextField.text//_dataModel.userInfo.password
     };
     */
    NSDictionary *params = @{@"cmd":@"120",
                             //@"user_id":[_dataModel userId],
                             @"p": base64Encoded//_dataModel.userInfo.password
                             };
    
    AFHTTPClient *_client=[Util clientSharedInstance];
    
    [_client postPath:ServerApiPath//@"/superkiosk/api""
           parameters:params
              success:^(AFHTTPRequestOperation *operation, id responseObject) {
                  
                  //if ([self isViewLoaded]) {
                      [MBProgressHUD hideHUDForView:_appDelegate.window.rootViewController.view animated:YES];
                      if([operation.response statusCode] != 200) {
                          [AppDelegate ShowErrorAlert:NSLocalizedString(@"There was an error communicating with the server", nil)];
                      } else {
                          
                         
                          
                          NSError* error;
                          NSDictionary* json=[NSJSONSerialization JSONObjectWithData:operation.responseData options:kNilOptions error:&error];
                          
                          NSNumber* success=[json objectForKey:@"success"];
                          if([success intValue]==1){
                              
                              /*
                              NSString *base64String=[json objectForKey:@"result"];
                              
#ifdef DEBUG
                              NSLog(@"base64String=%@",base64String);
#endif
                              NSData *base64Data=[[NSData alloc] initWithBase64EncodedString:base64String options:0];
                              
                              //NSError *error;
                              NSData *decryptedData = [RNDecryptor decryptData:base64Data
                                                                  withPassword:A_SECRET_PASSWORD
                                                                         error:&error];
                              
                              if(error!=nil){
#ifdef DEBUG
                                  NSLog(@"encryptData error=%@",[error localizedDescription]);
#endif
                                  return;
                              }
                               
                              
                              
                              NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:decryptedData options:NSJSONReadingMutableContainers error:&error];
                               [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_SEARCH_RESULT object:nil userInfo:dict];
                              */
                              
                              
                              NSArray *dict=[json objectForKey:@"results"];
                              if([dict isEqual:[NSNull null]]){
                                  dict=[NSArray new];
                              }
                              [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_SEARCH_RESULT object:nil userInfo:@{@"results":dict}];
                              
                              
                              /*
                              NSArray *results=[dict objectForKey:@"results"];
                              for(NSDictionary *s in results){
                                  
                              }*/
                              
                          }
                          else{
                              
                              
                          }
                          
                          
                          
                          
                      }
                  //}
              } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                  //if ([self isViewLoaded]) {
                      [MBProgressHUD hideHUDForView:_appDelegate.window.rootViewController.view animated:YES];
                      //[AppDelegate ShowErrorAlert:[error localizedDescription]];
                  [AppDelegate toast:[error localizedDescription] duration:2.0];
                  //}
              }];
}




@end
