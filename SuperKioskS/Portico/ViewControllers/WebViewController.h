//
//  WebViewController.h
//  Nearby Kiosk S
//
//  Created by Katherine Sheehy on 6/27/15.
//  Copyright (c) 2015 Sharecle. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebViewController : UIViewController<UIWebViewDelegate>
@property (strong, nonatomic) IBOutlet UIWebView *webView;
@property (strong,nonatomic) NSString *url;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *doneButton;
@end
