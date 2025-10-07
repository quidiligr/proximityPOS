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
#import "AppDelegate.h"
#import "NSData+Conversion.h"

#define KEY_APPCONFIG_FILENAME @"appconfig.plist"
#define KEY_APPCONFIG_FILENAME_SECURED @"appconfig.secureData"


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
        model.testCard=[CCardInfo new];
        model.testCard.number=TEST_CCARD_NUMBER;
        model.testCard.cvc=TEST_CCARD_CVC;
        model.testCard.name=model.userInfo.fullName;
        model.testCard.expYear=TEST_CCARD_EXP_YEAR;
        model.testCard.expMonth=TEST_CCARD_EXP_MONTH;
        //model.testCard.last4=TEST_CCARD_LAST4;
        
        
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
    AppConfigModel *model=[AppConfigModel sharedInstance];
    NSString* path =[AppConfigModel settingsPath];
    if ([[NSFileManager defaultManager] fileExistsAtPath:path])
    {
        NSData* data = [[NSData alloc] initWithContentsOfFile:path];
        NSKeyedUnarchiver* unarchiver;
        
        if(SECURED){
            NSData *decryptedData = [RNDecryptor decryptData:data withSettings:kRNCryptorAES256Settings password:A_SECRET_PASSWORD error:nil];
            //NSKeyedUnarchiver* unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
            unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:decryptedData];
        
        }
        else{
            unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];

        }
        NSDictionary *settings= [unarchiver decodeObjectForKey:@"settings"];
        //model.userInfo.displayName=[settings valueForKey:KEY_APP_DISPLAYNAME];
        model.userInfo=[[UserInfo alloc] initWithDictionary:[settings valueForKey:KEY_APP_USERINFO]];
        //if(model.userInfo.myPhotoMD5==nil || model.userInfo.myPhotoMD5.length==0){
            
        //}
        //make sure md5 photo is up to date
        
        
        NSString *peer_photo=[NSString stringWithFormat:@"%@%@.png",PREFIX_MYPHOTO,model.userInfo.deviceID];
        NSString *filePath=[[AppDelegate getDocumentsPath] stringByAppendingPathComponent:peer_photo];
        //NSFileManager *filemanager=[NSFileManager defaultManager] ;
        //NSError *error;
        
        if([[NSFileManager defaultManager]  fileExistsAtPath:filePath]){
            NSData *data=[NSData dataWithContentsOfFile:filePath];
            model.userInfo.myPhotoMD5=[[data MD5] uppercaseString];
            
        }
        else{
            model.userInfo.myPhotoMD5=@"";
        }
        
        //make sure name is valid
        NSError *error;
        NSRegularExpression *regex=[[NSRegularExpression alloc] initWithPattern:@"[^a-zA-Z\\s\\d]" options:NSRegularExpressionCaseInsensitive error:&error];
        
        NSString *trimmedString=[regex stringByReplacingMatchesInString:model.userInfo.fullName options:0 range:NSMakeRange(0, [model.userInfo.fullName length]) withTemplate:@""];
        
        model.userInfo.fullName=trimmedString;
        
        regex=[[NSRegularExpression alloc] initWithPattern:@" +" options:NSRegularExpressionCaseInsensitive error:&error];
        
        
        trimmedString=[regex stringByReplacingMatchesInString:model.userInfo.fullName options:0 range:NSMakeRange(0, [model.userInfo.fullName length]) withTemplate:@" "];
        
        model.userInfo.fullName=trimmedString;

        
        //model.minChargeAmount=[[settings valueForKey:KEY_APP_MICHARGEAMOUNT] doubleValue];
        //if(model.userInfo.displayName==nil || model.userInfo.displayName.length==0)
           // model.userInfo.displayName=[[UIDevice currentDevice] name];
        // if(model.minChargeAmount==0)
        //    model.minChargeAmount=1.00; //cents
        
        //model.userInfo.isVisible=[[settings valueForKey:KEY_APP_VISIBLE] boolValue];
        //model.ccards=[settings valueForKey:KEY_APP_CCARDS] ;
        
        [unarchiver finishDecoding];
        
    }
    else{
        model.userInfo=[UserInfo new];
        
        model.userInfo.fullName=[[UIDevice currentDevice] name];
        
        
        if([[model.userInfo.fullName lowercaseString] isEqualToString:@"everyone"])
            model.userInfo.fullName=@"Unknown";
        
        if([[model.userInfo.fullName lowercaseString] isEqualToString:@"guest"])
            model.userInfo.fullName=@"Unknown";
        
        model.userInfo.displayName=[UserInfo getDisplayName:model.userInfo.fullName];//[[UIDevice currentDevice] name];

        model.userInfo.deviceID=[[[[UIDevice currentDevice] identifierForVendor]  UUIDString] lowercaseString];
        
        model.userInfo.deviceToken=@"";
        
        model.userInfo.homeUrl=@"";
        
        model.userInfo.ccards=[NSMutableArray new];
        model.userInfo.blockedDevices=[NSMutableArray new];
        model.userInfo.myPhotoMD5=@"";
        model.userInfo.announceText=@"Hi!";
        model.userInfo.messageLimitPerUser=1;
        model.userInfo.isPlaySound=YES;

        //model.userInfo.isVisible=NO;
        //model.ccards=[NSMutableArray array];
        
        //[AppConfigModel saveSettings];
    }
    
    if(model.userInfo.deviceID==nil || model.userInfo.deviceID.length==0)
        model.userInfo.deviceID=[[[[UIDevice currentDevice] identifierForVendor]  UUIDString] lowercaseString];
}
+ (void)saveSettings
{
    NSMutableData* data = [[NSMutableData alloc] init];
    NSKeyedArchiver* archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    
    NSMutableDictionary *settings= [NSMutableDictionary new];
    
    AppConfigModel *model=[AppConfigModel sharedInstance];
    
    //[settings setValue:model.userInfo.displayName forKey:KEY_APP_DISPLAYNAME];
    //[settings setValue:[NSNumber numberWithBool:model.userInfo.isVisible ] forKey:KEY_APP_VISIBLE];
    //make sure theres only one default card
    
    
    [settings setValue:[model.userInfo toNSDictionary] forKey:KEY_APP_USERINFO];
    
    [archiver encodeObject:settings forKey:@"settings"];
    
    [archiver finishEncoding];
    
    if(SECURED){
    NSData *encryptedData = [RNEncryptor encryptData:data withSettings:kRNCryptorAES256Settings password:A_SECRET_PASSWORD error:nil];
    //[encryptedImage writeToFile:[self.filePath stringByAppendingPathComponent:imageName] atomically:YES];

    [encryptedData writeToFile:[AppConfigModel settingsPath] atomically:YES];
    }
    else{
        [data writeToFile:[AppConfigModel settingsPath] atomically:YES];
    }
    
    //[AppConfigModel loadSettings];
}








@end
