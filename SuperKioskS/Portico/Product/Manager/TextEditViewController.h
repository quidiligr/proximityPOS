//
//  TextEditViewController.h
//  superkiosks
//
//  Created by Katherine Sheehy on 10/24/15.
//  Copyright (c) 2015 Sharecle. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TextEditViewControllerDelegate;

@interface TextEditViewController : UIViewController



@property (strong, nonatomic) NSString *inputText;

@property(nonatomic,assign) id<TextEditViewControllerDelegate> delegate;



@end

@protocol TextEditViewControllerDelegate <NSObject>

-(void)textEditViewControllerDidChange:(TextEditViewController *)viewController;


@end