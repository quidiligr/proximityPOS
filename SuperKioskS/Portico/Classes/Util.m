//
//  Util.m
//  superkiosks
//
//  Created by Katherine Sheehy on 4/25/16.
//  Copyright © 2016 Sharecle. All rights reserved.
//

#import "Util.h"
#import "NSData+MD5.h"
//#import "Reachability.h"

@implementation Util

+ (AFHTTPClient *)clientSharedInstance {
    //static HistoryModel*  _sharedHistory;
    static AFHTTPClient *_sharedClient;
    
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        
        _sharedClient = [AFHTTPClient clientWithBaseURL:[NSURL URLWithString:ServerApiURL]];
        
        
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

+(NSString *)priceToString:(double)price currency:(NSString *)currency{
    /*
    NSNumberFormatter *fmt=[[NSNumberFormatter alloc] init];
    [fmt setPositiveFormat:@"0.##"];
    return [NSString stringWithFormat:@"%@%@",currency,[fmt stringFromNumber:[NSNumber numberWithDouble:price]]]; //[NSString stringWithFormat:@"%.02f",discount];
    */
    if(currency==nil || currency.length==0)
        return [NSString stringWithFormat:@"%.2f",price];
    else
        return [NSString stringWithFormat:@"%@%.2f",currency,price];
    

        
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


/*
+(void)playSystemSound:(SystemSoundID) soundID{
    AudioServicesPlaySystemSound(soundID);
}

+(void)playSystemAlert:(SystemSoundID) soundID{
    AudioServicesPlayAlertSound(soundID);
}
*/
+(BOOL)isNumeric:(NSString *)string{
    NSScanner *ns = [NSScanner scannerWithString:string];
    if([ns scanFloat:NULL])
        return [ns isAtEnd];
    return NO;
}

/*
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
 */

//-(void) postUploadBeforeSend:(ComposeData*) message isPrivate:(BOOL)isPrivate{
+(void) postUploadBeforeSend:(NSData *)filedata filename:(NSString *)filename contenttype:(NSString *)mimetype serverpath:(NSString *)path info:(NSString *)info {
    AppDelegate *_appDelegate=ApplicationDelegate;
    
    //_appDelegate.reachabilityManager.netStatus==
    #ifdef DEBUG
    NSString *statusString;
    switch (_appDelegate.reachabilityManager.netStatus)
    {
        case NotReachable:        {
            statusString = NSLocalizedString(@"Access Not Available", @"Access is not available");
            //imageView.image = [UIImage imageNamed:@"stop-32.png"] ;
            
            //Minor interface detail- connectionRequired may return YES even when the host is unreachable. We cover that up here...
            
            //connectionRequired = NO;

            NSLog(@"Reachability: %@",statusString);

            
            break;
        }
            
        case ReachableViaWWAN:        {
            statusString = NSLocalizedString(@"Reachable WWAN", @"");
            //imageView.image = [UIImage imageNamed:@"WWAN5.png"];
            break;
        }
        case ReachableViaWiFi:        {
            statusString= NSLocalizedString(@"Reachable WiFi", @"");
            //imageView.image = [UIImage imageNamed:@"Airport.png"];
            break;
        }
    }
     NSLog(@"Reachability: %@",statusString);
    #endif
    
    if(_appDelegate.reachabilityManager.netStatus==NotReachable){
        return;
    }

    
    AFHTTPClient *_client=[Util clientSharedInstance];
    
    
    
    
    //NSString *md5=[filedata MD5];
    
    NSError *error;
   /* NSString *info=[NSString stringWithFormat:@"usertoken=%@&md5=%@&filename=%@&mimetype=%@"
                    ,_appDelegate.appConfig.user_userToken
                    ,md5
                    ,filename
                    ,mimetype];
    */
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
    NSDictionary *params = @{//@"cmd":@"120.1.1",
                             //@"user_id":[_dataModel userId],
                             @"p": base64Encoded//_dataModel.userInfo.password
                             };
    
    MBProgressHUD* hud = [MBProgressHUD showHUDAddedTo:_appDelegate.window.rootViewController.view animated:YES];
    hud.labelText = NSLocalizedString(@"Sending...", nil);
   // [_client postPath:ServerApiPath
    NSMutableURLRequest *request = [_client multipartFormRequestWithMethod:@"POST" path:path parameters:params constructingBodyWithBlock: ^(id <AFMultipartFormData>formData) {
        
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
                
                
                [formData  appendPartWithFileData:filedata name:@"attachment" fileName:filename mimeType:mimetype];
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

#pragma mark Time

+(NSString*)today{
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    return [dateFormatter stringFromDate:[NSDate date]];
}

+(NSString*)toTimeString:(NSDate *)withDate{
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"hh:mm:ss a"];
    
    return [dateFormatter stringFromDate:withDate];
}

+(NSString *)displayTime:(NSDate *)fromDate{
    NSDate *toDate=[NSDate date];
    int seconds=[toDate timeIntervalSinceDate:fromDate];
    /*
    NSCalendar *calendar=[NSCalendar currentCalendar];
    
    NSUInteger units=(NSMonthCalendarUnit|NSDayCalendarUnit|NSWeekCalendarUnit|NSYearCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit);
    
    NSDateComponents *dateComponents=[calendar components:units fromDate:fromDate toDate:toDate options:0];
    */
    if(seconds<60){ //less than a minute
        
        return [NSString stringWithFormat:@"%d seconds ago",seconds];
    }
    else if(seconds<3600){ //less then an hour
        int min=seconds/60;
        
        return [NSString stringWithFormat:@"%d minutes ago",min];
    }
    
    else if(seconds<86400){ //less than a day
        int hour=seconds/3600;
        int min=(seconds-(hour*3600))/60;
        return [NSString stringWithFormat:@"%d hour %d minute.",hour,min];
    }
    
    return [NSString stringWithFormat:@"%@",[Util toTimeString:fromDate]];
     
    /*
    if(dateComponents.year){
        return [NSString stringWithFormat:@"%ld year ago.",(long)dateComponents.year];
    }
    else if(dateComponents.month){
        return [NSString stringWithFormat:@"%ld month ago",(long)dateComponents.month];
    }
    else if(dateComponents.weekOfMonth){
        return [NSString stringWithFormat:@"%ld",(long)dateComponents.weekOfMonth];
    }
    else if(dateComponents.day){
        return [NSString stringWithFormat:@"%@ day ago",[Util toTimeString:fromDate]];
    }
    else {
        return [NSString stringWithFormat:@"%@",[Util toTimeString:fromDate]];
    }
    */
}


#pragma mark Json Util
#pragma mark -Global to json string utility functions
+(NSString *)toJsonString:(NSDictionary *) dict{
    NSError *error;
    NSData *jsonData=[NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    
    if(error)
        nil;
    
    NSString *json_text=[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return json_text;
}


+ (CGSize)sizeForText:(NSString*)text withWidth:(CGFloat)width withFont:(NSFont *)font
{
   
   /* CGRect textRect = [text boundingRectWithSize:CGSizeMake((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)?WrapWidthIpad:WrapWidth, 9999)
                                         options:NSStringDrawingUsesLineFragmentOrigin
                                      attributes:@{NSFontAttributeName:font}
                                         context:nil];*/
    CGSize size=CGSizeZero;
    CGRect frame = [text boundingRectWithSize:CGSizeMake(width,CGFLOAT_MAX)
                                         options:NSStringDrawingUsesLineFragmentOrigin
                                      attributes:@{NSFontAttributeName:font}
                                         context:nil];
    size=CGSizeMake(frame.size.width, frame.size.height+1);
    return size;
    
    
    
}


@end
