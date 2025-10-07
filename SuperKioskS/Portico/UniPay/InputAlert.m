//
//  PasswordAlert.m
//  iSmartDemo
//
//  Created by Xinhu Li on 11/3/11.
//  Copyright (c) 2011 IDTECH. All rights reserved.
//

#import "InputAlert.h"
#import <QuartzCore/QuartzCore.h>

@implementation InputAlert
@synthesize delegate;
@synthesize tag;

-(id)init{
  self = [super init];
  if (self) {
    self.tag = 0;
  }
  
  return self;
}

- (void) showWithTitle:(NSString*)title{
	CGAffineTransform transform = CGAffineTransformMakeTranslation(0, 60);
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:@"Place holder" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK",nil];
	UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(12, 45, 260, 25)];
  textField.backgroundColor = [UIColor whiteColor];
  textField.layer.cornerRadius = 5.0f;

	[alert setTransform:transform];
	[alert addSubview:textField];
	[alert show];
	//[alert release];
    alert = nil;
	//[textField release];
    textField = nil;
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
	if(buttonIndex == 1){
		UITextField *txtInput = [[alertView subviews] objectAtIndex:[[alertView subviews] count]-1];
		if ([txtInput isFirstResponder]) {
			[txtInput resignFirstResponder];
		}
		
 		[delegate inputAlert:self valueEntered:[txtInput text]];
	}else {
		[delegate inputAlert:self valueEntered:nil];
	}

}

- (void)alertViewCancel:(UIAlertView *)alertView{
	[delegate inputAlert:self valueEntered:nil];
}

@end
