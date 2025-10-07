//
//  WebViewController.m
//  Nearby Kiosk S
//
//  Created by Katherine Sheehy on 6/27/15.
//  Copyright (c) 2015 Sharecle. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController ()

@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor clearColor];
    // Do any additional setup after loading the view.
    UIActivityIndicatorView *activityView=[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    
    CGRect screenRect=[[UIScreen mainScreen] bounds];
    
    activityView.center=CGPointMake(screenRect.size.width/2.0, screenRect.size
                                    .height/2.0);
    [activityView startAnimating];
    activityView.tag=100;
    
    [self.view addSubview:activityView];
    
    NSURL *urll=[NSURL URLWithString:self.url];
    NSURLRequest *req=[NSURLRequest requestWithURL:urll];
    self.webView.delegate=self;
    [self.webView loadRequest:req];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)doneButtonTapped:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    [[self.view viewWithTag:100] setHidden:YES];
}
/*
-(void)dismissViewControllerAnimated:(BOOL)flag completion:(void (^)(void))completion{
    if(self.presentedViewController){
        [super dismissViewControllerAnimated:flag completion:completion];
    }
}
 */
@end
