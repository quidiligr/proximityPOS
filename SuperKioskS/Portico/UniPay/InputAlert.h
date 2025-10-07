//
//  PasswordAlert.h
//  iSmartDemo
//
//  Created by Xinhu Li on 11/3/11.
//  Copyright (c) 2011 IDTECH. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface InputAlert : NSObject <UIAlertViewDelegate, UITextFieldDelegate>{
	id delegate;
    int tag;
}

@property(nonatomic, retain) id delegate;
@property(nonatomic, assign) int tag;
    
- (void) showWithTitle:(NSString*)title;
@end

@protocol InputAlertDelegate
-(void) inputAlert:(InputAlert*)inputAlert valueEntered:(NSString*)valueEntered;
@end
