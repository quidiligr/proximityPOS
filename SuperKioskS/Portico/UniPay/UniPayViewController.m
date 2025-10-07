
#import "UniPayViewController.h"
#import "AppDelegate.h"

@interface UniPayViewController (){
    NSString *cardNumber;
    NSString *cardName;
    NSString *cardExpDate;
    AppDelegate *_appDelegate;
    
}

@end

@implementation UniPayViewController
//@synthesize resultsTextView;
/*@synthesize connectedLabel;
@synthesize txtAPDUData;
@synthesize txtDirectIO;
@synthesize LabelVersion;
@synthesize _BDKTextField;
@synthesize _KSNTextField;
//@synthesize reader=_reader;

@synthesize sView;
@synthesize view1;
@synthesize view2;
@synthesize view3;
@synthesize view4;
@synthesize pcControlPanes;
@synthesize prompt_doConnection;
@synthesize prompt_sendLog;
*/
extern int g_IOS_Type;
//static bool s_bThreadRuning = NO;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    _appDelegate=ApplicationDelegate;
    //nav buttons
    UIBarButtonItem *doneButtonItem=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneAction:)];
    self.navigationItem.leftBarButtonItem=doneButtonItem;
/*
#ifdef DEBUG
    
    UIBarButtonItem *testButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"Test" style:UIBarButtonItemStyleBordered target:self action:@selector(testParser)];
    self.navigationItem.rightBarButtonItem=testButtonItem;
 
#endif
 */
    //init alert views
    /*prompt_doConnection = [[UIAlertView alloc]
                           initWithTitle:@"UniPay"
                           message:@"Device detected in headphone jack. Try connecting it?"
                           delegate:self
                           cancelButtonTitle:@"Cancel"
                           otherButtonTitles:@"OK",nil];

    prompt_sendLog = [[UIAlertView alloc]
                      initWithTitle:@"UniPay"
                      message:@"Email diagnostic information about UniPay's last action? "
                      @"Take care not to send valid and unencrypted card data."
                      delegate:self
                      cancelButtonTitle:@"Cancel"
                      otherButtonTitles:@"OK", nil];
     */

    //for iPhone
    /*if (0 == g_IOS_Type) {
        CGRect frame = self.sView.frame;
        frame.size.width = [UIScreen mainScreen].bounds.size.width;
        CGSize contentSize = frame.size;
        contentSize.width *= 4;
        self.sView.contentSize = contentSize;
        
        // add to scroll view
        frame.origin.y = 0;
        frame.origin.x = frame.size.width * 3;
        self.view4.frame = frame;
        [self.sView addSubview: self.view4];
        
        frame.origin.y = 0;
        frame.origin.x = frame.size.width * 2;
        self.view3.frame = frame;
        [self.sView addSubview: self.view3];
        
        frame.origin.y = 0;
        frame.origin.x = frame.size.width * 1;
        self.view2.frame = frame;
        [self.sView addSubview: self.view2];
        
        frame.origin.y = 0;
        frame.origin.x = frame.size.width * 0;
        self.view1.frame = frame;
        [self.sView addSubview: self.view1];
        
        self.pcControlPanes.numberOfPages = 4;
        self.pcControlPanes.currentPage = 0;
    }*/
    
    /*
    //init object
    LabelVersion.text = [NSString stringWithFormat:@"UniPay %@",[UniPay SDK_version]];
    
    [UniPay enableLogging:YES];
    if (reader) {
        //[reader release];
        reader = nil;
    }
    reader = [[UniPay alloc] init];
    reader.delegate = self;
    [reader cmut_setAutoAdjustVolume :YES];
    */
    if(_appDelegate.uniPayManager==nil){
        _appDelegate.uniPayManager=[[UniPayManager alloc] init];
        [_appDelegate.uniPayManager start];
    }
    _resultsTextView.layoutManager.allowsNonContiguousLayout = NO;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    // Release any retained subviews of the main view.

    //[prompt_doConnection release];
   // prompt_doConnection = nil;
    //[prompt_sendLog release];
   // prompt_sendLog = nil;

    //[reader release];
    //reader = nil;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    

}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    //return NO;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)sender {
    /*if (sender != self.sView)
        return;
    
    //for iPhone
    if (0 == g_IOS_Type) {
        //update UIPageControl object
        CGFloat pageWidth = self.sView.frame.size.width;
        int page = floor((self.sView.contentOffset.x + pageWidth / 2) / pageWidth);
        self.pcControlPanes.currentPage = page;
    }
     */
}



#pragma mark Button Actions
-(void)doneAction:(id)source{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
