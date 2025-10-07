//
//  IODOrder.m
//  iOSDiner
//
//  Created by Romulo Quidilig on 3/19/15.
//  Copyright (c) 2015 Sharecle Inc. All rights reserved.
//

#import "AppConfigModel.h"
#import "defs.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "RNDecryptor.h"
#import "RNEncryptor.h"

#define KEY_APPCONFIG_FILENAME_SECURED @"appconfig.secureData"
#define KEY_APPCONFIG_FILENAME @"appconfig.plist"


@implementation AppConfigModel



- (id)init {
    self = [super init];
    if (self) {
        
       
    }
    return self;
}




+ (AppConfigModel *)sharedInstance
{
   //static NSMutableDictionary *_sharedSettings;
    static AppConfigModel *model;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        
        model=[[AppConfigModel alloc] init];
        
        
        
    });
    
    return model;
    
}



+(NSString *)settingsPath{
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDirectory = paths[0];
    //NSString *filename=KEY_SETTINGS_INV_FILENAME;
    //BOOL secured=SECURED;
    NSString* path = [documentsDirectory stringByAppendingPathComponent:(SECURED)?KEY_APPCONFIG_FILENAME_SECURED:KEY_APPCONFIG_FILENAME];
    return path;
}
/*
+(void)loadSettings{
    NSDictionary *_settings=[AppConfigModel sharedInstance];
    
    
    NSString* path =[AppConfigModel settingsPath];
    
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:path])
    {
        
        
        NSData* data = [[NSData alloc] initWithContentsOfFile:path];
        NSKeyedUnarchiver* unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
        _settings= [unarchiver decodeObjectForKey:@"settings"];
        
        [unarchiver finishDecoding];
    }
    
}
*/
+(void)loadSettings{
    
    AppDelegate *_appDelgate=ApplicationDelegate;
    [_appDelgate showMBProgress:@"Loading..."];
    
    AppConfigModel *model=_appDelgate.appConfig;//[AppConfigModel sharedInstance];
    
    NSString* path =[AppConfigModel settingsPath];
    
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:path])
    {
        
        NSData* data= [[NSData alloc] initWithContentsOfFile:path];

        NSKeyedUnarchiver* unarchiver;
        if(SECURED){
            
            NSData *decryptedData = [RNDecryptor decryptData:data withSettings:kRNCryptorAES256Settings password:A_SECRET_PASSWORD error:nil];
            unarchiver= [[NSKeyedUnarchiver alloc] initForReadingWithData:decryptedData];

        }
        else{
             unarchiver= [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
        }
        
        
        NSDictionary *settings= [unarchiver decodeObjectForKey:@"settings"];
        
        
        model.user_deviceToken=[settings valueForKey:deviceTokenKey];
        model.user_userToken= [settings valueForKey:userTokenKey];
        model.user_username= [settings valueForKey:usernameKey];
        model.user_password= [settings valueForKey:passwordKey];
        model.user_pin= [settings valueForKey:pinKey];
        model.user_usepin= [[settings valueForKey:usePinKey] boolValue];
        model.user_displayName= [settings valueForKey:displayNameKey];
        model.user_homeUrl= [settings valueForKey:homeUrlKey];
        model.welcomeMessage= [settings valueForKey:welcomeMessageKey];
        
        
        //deviceinfo
        model.device_name=[settings valueForKey:KEY_APP_DISPLAYNAME];
        model.device_id=[settings valueForKey:KEY_APP_DEVICEID];
        model.storeID=[settings valueForKey:storeIDKey];
        model.device_num=[[settings valueForKey:KEY_APP_DEVICENUM] integerValue];
        
        model.device_pictureFile=[settings valueForKey:device_pictureFileKey];
        model.device_bgPictureFile=[settings valueForKey:device_bgPictureFileKey];
        
        model.visibility=[[settings valueForKey:visibilityKey] integerValue];
        
        model.enableChat=[[settings valueForKey:enableChatKey] boolValue];
         model.enableChatSound=[[settings valueForKey:enableChatSoundKey] boolValue];
         model.enableOrderSound=[[settings valueForKey:enableOrderSoundKey] boolValue];
        
        model.enablePhotoSharing=[[settings valueForKey:enablePhotoSharingKey] boolValue];
        
        model.enableHttp=[[settings valueForKey:enableHttpKey] boolValue];
        
         model.barcodeAutoAddToCart=[[settings valueForKey:barcodeAutoAddToCartKey] boolValue];
         model.barcodeAutoClose=[[settings valueForKey:barcodeAutoCloseKey] boolValue];
        
        model.maxMessagesPerUser=[[settings valueForKey:maxMessagesPerUserKey] integerValue];
        
        model.expireMessageInSec=[[settings valueForKey:expireMessageInSecKey] integerValue];
        
        model.maxUploadSizeKB=[[settings valueForKey:maxUploadSizeKBKey] integerValue];
        
        model.allowedDaysToSynch=[[settings valueForKey:allowedDaysToSynchKey] integerValue];
        model.currencies=[settings valueForKey:currenciesKey];
        if(model.currencies==nil){
            model.currencies=@{@"usd":@"$"};
        }
       
        model.cardReader=[[settings valueForKey:cardReaderKey] integerValue];
         model.authType=[[settings valueForKey:authTypeKey] integerValue];
        
        if(model.device_name==nil || model.device_name.length==0)
            model.device_name=[[UIDevice currentDevice] name];
        
        if(model.acceptedCards==nil || model.acceptedCards.length==0)
            model.acceptedCards=@"We accept Visa,Mastercard,Amex and Discovery."; //cents
        
        model.visibility=[[settings valueForKey:visibilityKey] integerValue];
        
        //model.showAll=YES;
        model.showClosed=NO;
        model.showCancelled=NO;
        model.showPaid=YES;
        model.showUnpaid=YES;
        model.showReady=YES;
        
        
        model.enableChatSound=[[settings valueForKey:enableChatSoundKey] boolValue];
        model.enableOrderSound=[[settings valueForKey:enableOrderSoundKey] boolValue];;
        model.md5Checksum=[settings valueForKey:md5ChecksumKey];
        
        if(model.md5Checksum==nil || model.md5Checksum.length>0){
            
        }
        
        model.groups=[settings valueForKey:groupsKey];
        model.users=[settings valueForKey:usersKey];
        
        [unarchiver finishDecoding];
        
        
    }
    else{
        model.device_name=[[UIDevice currentDevice] name];
        //model.minChargeAmount=0.00;
        model.allowedDaysToSynch=1;
        model.user_pin=nil;
        model.user_usepin=NO;
        //model.maxUnpaidOrdersPerCustomer=1;
        //model.refundLevel=ORDER_STATUS_READY; //ready
        model.visibility=VISIBILITY_TEST;
        
        //model.acceptPayments=YES;
        //model.acceptCCard=YES;
        //model.acceptCash=NO;
        
        model.enableHttp=NO;
        model.enableChat=YES;
        model.enablePhotoSharing=YES;
        model.enableMultiPay=YES;
        
        model.barcodeAutoClose=YES;
        model.barcodeAutoAddToCart=YES;
        
        model.currencies=@{@"usd":@"$"};
        
        model.cardReader=0; //cardio
        //model.currency=@"usd";
        //model.currencySymbol=@"$";
        model.showAll=YES;
        model.showClosed=NO;
        model.showCancelled=NO;
        model.showPaid=YES;
        model.showUnpaid=YES;
        model.showReady=YES;
        
        model.maxUploadSizeKB=DEF_MAX_UPLOAD_SIZEKB;
        model.maxMessagesPerUser=DEF_MESSAGES_PERUSER;
        model.expireMessageInSec=DEF_MESSAGE_EXPIRESEC;
        model.users=[NSMutableArray new];
        model.groups=[NSMutableArray new];
        //[AppConfigModel saveSettings];
    }
    [_appDelgate hideMBProgress];
}

+ (void)saveSettings
{
    AppDelegate *_appDelgate=ApplicationDelegate;
    [_appDelgate showMBProgress:@"Saving..."];
    

    NSMutableData* data = [[NSMutableData alloc] init];
    NSKeyedArchiver* archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    
    NSMutableDictionary *settings= [NSMutableDictionary new];
    
    AppConfigModel *model=_appDelgate.appConfig;//[AppConfigModel sharedInstance];
    
    
    
    [settings setValue:model.device_name forKey:KEY_APP_DISPLAYNAME];
    [settings setValue:model.device_pictureFile forKey:device_pictureFileKey];
    [settings setValue:model.device_bgPictureFile forKey:device_bgPictureFileKey];
    [settings setValue:model.device_id forKey:KEY_APP_DEVICEID];
    [settings setValue:model.storeID forKey:storeIDKey];
    [settings setValue:@(model.device_num) forKey:KEY_APP_DEVICENUM];
    
    [settings setValue:model.user_deviceToken forKey:deviceTokenKey];
    [settings setValue:model.user_userToken forKey:userTokenKey];
    [settings setValue:model.user_username forKey:usernameKey];
    [settings setValue:model.user_password forKey:passwordKey];
    [settings setValue:model.user_pin forKey:pinKey];
    [settings setValue:@(model.user_usepin) forKey:usePinKey];

    [settings setValue:model.user_displayName forKey:displayNameKey];
    [settings setValue:model.user_homeUrl forKey:homeUrlKey];
    [settings setValue:model.welcomeMessage forKey:welcomeMessageKey];
    
   
    
    [settings setValue:@(model.visibility) forKey:visibilityKey];

    [settings setValue:@(model.enableChat) forKey:enableChatKey];
    [settings setValue:@(model.enablePhotoSharing) forKey:enablePhotoSharingKey];
    
    [settings setValue:@(model.enableChatSound) forKey:enableChatSoundKey];
    [settings setValue:@(model.enableOrderSound) forKey:enableOrderSoundKey];
    
    [settings setValue:@(model.enableHttp) forKey:enableHttpKey];
    
    [settings setValue:@(model.barcodeAutoAddToCart) forKey:barcodeAutoAddToCartKey];
    [settings setValue:@(model.barcodeAutoClose) forKey:barcodeAutoCloseKey];
    
     [settings setValue:@(model.maxMessagesPerUser) forKey:maxMessagesPerUserKey];
     [settings setValue:@(model.expireMessageInSec) forKey:expireMessageInSecKey];
     [settings setValue:@(model.maxUploadSizeKB) forKey:maxUploadSizeKBKey];
    
    [settings setValue:model.currencies forKey:currenciesKey];
    
    [settings setValue:@(model.cardReader) forKey:cardReaderKey];
    [settings setValue:@(model.authType) forKey:authTypeKey];
    
    [settings setValue:model.groups forKey:groupsKey];
    [settings setValue:model.users forKey:usersKey];
    
 
    [archiver encodeObject:settings forKey:@"settings"];
    [archiver finishEncoding];
    
    if(SECURED){
    NSData *encryptedData = [RNEncryptor encryptData:data withSettings:kRNCryptorAES256Settings password:A_SECRET_PASSWORD error:nil];
    
    
    [encryptedData writeToFile:[AppConfigModel settingsPath] atomically:YES];
    }
    else{
        [data writeToFile:[AppConfigModel settingsPath] atomically:YES];
    }
    [_appDelgate hideMBProgress];

}

-(BOOL)isLive{
    if(self.visibility==VISIBILITY_LIVE)
        return YES;
    else
        return NO;
    
}

-(UIImage *)loadLogoImage{
    return [self loadImageFromDocumentsPath:_device_pictureFile];
    
}

-(UIImage *)loadBackgroundImage{
   return  [self loadImageFromDocumentsPath:_device_bgPictureFile];
    
}

-(UIImage *)loadImageFromDocumentsPath:(NSString *)fileName{
    if(fileName==nil || fileName.length==0)
        return nil;
    UIImage *image=nil;
    /*NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
     NSString* documentsDirectory = paths[0];
     
     NSString *filePath=[documentsDirectory stringByAppendingPathComponent:photo];
     */
    NSString *imagesPath=[AppDelegate getDocumentsPath];
    
    NSString *filePath=[imagesPath stringByAppendingPathComponent:fileName];
    
    //check if cached
    NSFileManager *fm= [NSFileManager defaultManager];
    //NSError *error;
    if([fm fileExistsAtPath:filePath]){
        //NSDictionary *fileAttribute=[fm attributesOfItemAtPath:filePath error:&error];
        //NSUInteger filesize= [fileAttribute fileSize];
        //if(filesize>0){
            
        
        image=[[UIImage alloc] initWithContentsOfFile:filePath];
        //}
    }
    else{
        //TODO: return empty
        //image=[UIImage imageNamed:@"empty_picture.png"];
    }
    return image;
    
}

-(UIImage *)loadImage:(NSString *)fileName{
    if(fileName==nil || fileName.length==0)
        return nil;
    UIImage *image=nil;
    /*NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
     NSString* documentsDirectory = paths[0];
     
     NSString *filePath=[documentsDirectory stringByAppendingPathComponent:photo];
     */
    NSString *imagesPath=[AppDelegate getImagesPath];
    
    NSString *filePath=[imagesPath stringByAppendingPathComponent:fileName];
    
    //check if cached
    if([[NSFileManager defaultManager] fileExistsAtPath:filePath]){
        image=[[UIImage alloc] initWithContentsOfFile:filePath];
        
    }
    else{
        //TODO: return empty
        //image=[UIImage imageNamed:@"empty_picture.png"];
    }
    return image;
    
}



-(void)downloadLogoImage{
    [self downloadImage:_device_pictureFile isBgImage:NO];
}

-(void)downloadBackgroundImage{
    [self downloadImage:_device_bgPictureFile isBgImage:YES];
}

-(void)downloadImage:(NSString *)fileName isBgImage:(BOOL)isBgImage{
    if(fileName==nil || fileName.length==0)
        return;
    
    NSString *imagesPath=[AppDelegate getImagesPath];
    
    NSString *filePath=[imagesPath stringByAppendingPathComponent:fileName];
    
    if([[NSFileManager defaultManager] fileExistsAtPath:filePath])
        return;
    
    AppDelegate *_appDelegate=ApplicationDelegate;
    
    NSString *url=[NSString stringWithFormat:@"%@/%@/%@/%@",ServerApiURL,ServerImagePath,_appDelegate.appConfig.user_userid,fileName];
    NSURL *imageURL = [NSURL URLWithString:url];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            // Update the UI
            //self.imageView.image = [UIImage imageWithData:imageData];
            [imageData writeToFile:filePath atomically:YES];
            //[[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_UPDATE_INVENTORY object:nil];
            
            //[[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_UPDATE_INVENTORY_SETTINGS object:nil userInfo:@{KEY_SELECTED_INVENTORY:_appDelegate.inventoryModel.inventory}];
            if(isBgImage){
                [_appDelegate setBackgroundImageWithData:imageData];
            }
        });
    });
    
}






@end
