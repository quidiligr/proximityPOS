//
//  MyFileViewController.h
//  Sharecle
//
//  Created by Romulo Quidilig on 8/11/14.
//  Copyright (c) 2014 Sharecle Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "defs.h"
//@protocol MyDriveControllerDelegate;

//UIKIT_EXTERN NSString *const MyFileControllerSelectedFile;
/*
 typedef NS_ENUM(NSInteger, ScrollDirection) {
 ScrollDirectionUP  = 1,
 ScrollDirectionDOWN = 0
 };
 */
@interface MyDriveViewController : UITableViewController<UIImagePickerControllerDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,UIAlertViewDelegate>
@property(nonatomic,strong) NSNumber *folderid;
@property(nonatomic) NSInteger tag;
@property(nonatomic,strong) NSString *contenTypeFilter;
//@property(nonatomic,assign) id<MyDriveControllerDelegate>delegate;
@end
/*
 @protocol MyDriveControllerDelegate <NSObject>
 -(void)myDriveController:(MyDriveController *)picker didFinishPickingFileWithInfo:(NSDictionary *)info;
 @end
 */