//
//  SecondViewController.h
//
//
//  Created by Romulo Quidilig.
//  Copyright (c) 2015 Sharecle Inc. All rights reserved.
//


#import <UIKit/UIKit.h>
@protocol FilePickerControllerDelegate;

@interface FilePickerController : UIViewController <UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tblFiles;
@property (strong,nonatomic) NSString *folder;
@property(nonatomic,assign) id<FilePickerControllerDelegate>delegate;
@end
@protocol FilePickerControllerDelegate <NSObject>
-(void)filePickerController:(FilePickerController *)picker didFinishPickingFileWithInfo:(NSDictionary *)info;
@end