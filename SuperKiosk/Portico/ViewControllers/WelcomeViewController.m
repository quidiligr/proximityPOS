//
//  StartScreenViewController.m
//  superkiosk
//
//  Created by Romulo Quidilig on 3/1/17.
//  Copyright © 2017 All rights reserved.
//

#import "WelcomeViewController.h"
#import "ConnectionsViewController.h"

@interface WelcomeViewController ()
{
    NSMutableArray *_menu;
    NSMutableArray *_featured;
    
    ProductCategory *_selectedCategory;
    Product *_selectedProduct;
    
    AppDelegate *_appDelegate;
    
    ConnectionManager *_connManager;
    
    ReachabilityManager *rm;
    NSTimer *timer;
    
    
}



@end



@implementation WelcomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _featured = [NSMutableArray arrayWithArray:@[@"welcome-1.jpg",@"welcome-2.jpg",@"welcome-3.jpg",@"welcome-4.jpg"]];
    [self refreshView];
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id <UIViewControllerTransitionCoordinator>)coordinator
{
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    
    // Code here will execute before the rotation begins.
    // Equivalent to placing it in the deprecated method -[willRotateToInterfaceOrientation:duration:]
    
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        
        // Place code here to perform animations during the rotation.
        // You can pass nil or leave this block empty if not necessary.
        
    } completion:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        
        // Code here will execute after the rotation has finished.
        // Equivalent to placing it in the deprecated method -[didRotateFromInterfaceOrientation:]
        [self refreshView];
        
    }];
}

 - (void)viewWillAppear:(BOOL)animated {
 [self.navigationController setNavigationBarHidden:YES animated:animated];
 [super viewWillAppear:animated];
 }

 - (void)viewWillDisappear:(BOOL)animated {
 [self.navigationController setNavigationBarHidden:NO animated:animated];
 [super viewWillDisappear:animated];
 }
 

-(void)viewDidAppear:(BOOL)animated{
    if(timer==nil || timer.isValid==NO ){
        timer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(moveToNextPage) userInfo:nil repeats:YES];
    }
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [timer invalidate];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    if(timer){
        [timer invalidate];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    if(timer==nil ){
        timer = [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(moveToNextPage) userInfo:nil repeats:NO];
    }
    else {
        
    if(timer.isValid==YES){
        [timer invalidate];
        
    }
        timer = [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(moveToNextPage) userInfo:nil repeats:NO];
        
    }
    //else{
        
    //}
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)refreshView{
    CGRect rect = [UIScreen mainScreen].bounds;
    //self.featuredScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, rect.size.width, rect.size.height)];
    self.featuredScrollView.pagingEnabled=YES;
    self.featuredScrollView.autoresizingMask=UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    //self.featuredScrollView.backgroundColor = [UIColor whiteColor];
    self.featuredScrollView.delegate=self;
    
    
    //for(Product *fp in _featured){
    //fp.pictureFile
    //}
    /*
     for(int i=0; i<_featured.count;i++){
     [featuredScrollView addSubview:[[UIImageView alloc] initWithFrame:CGRectMake(300*i, 0, rect.size.width, 300)]];
     }
     */
    //self.featuredScrollView.contentSize=CGSizeMake(rect.size.width*_featured.count, rect.size.height);
    //[self.view addSubview:self.featuredScrollView];
    
    //CGRect re = self.featuredScrollView.frame;
    
    self.featuredScrollView.contentSize=CGSizeMake(rect.size.width*_featured.count, rect.size.height);
    //self.feaView = [[UIView alloc] initWithFrame:CGRectMake((re.size.width/2)-150, re.size.height-100, 300, 100)];
    //self.feaView = [[UIView alloc] initWithFrame:CGRectMake(0, re.size.height-100, re.size.width, 100)];
    /*self.feaTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, re.size.width, 60)];
    
    [self.feaTitle setTextColor:[UIColor whiteColor]];
    [self.feaTitle setNumberOfLines:0];
    [self.feaTitle setTextAlignment:NSTextAlignmentCenter];
    [self.feaTitle setFont:[UIFont fontWithName:@"TrebuchetMS-Bold" size:25]];
    */
    
    //self.pageControl=[[UIPageControl alloc] initWithFrame:CGRectMake( (re.size.width/2)-150, re.size.height-40, 300, 40)];
    self.pageControl.numberOfPages=[_featured count];
    
    //[self.feaView addSubview:self.feaTitle];
    //[self.feaView addSubview:self.pageControl];
    //[self.feaView setBackgroundColor:[UIColor whiteColor]];
    //[self.feaView setAlpha:55];
    //[cell addSubview:self.pageControl];
    //[self.view addSubview:self.feaView];
    
    
    //for(Product *prod in _featured){
    for(int i=0; i<_featured.count;i++){
        //Product *prod=[_featured objectAtIndex:i];
        //if( prod.pictureFile.length>0){
            UIImageView *uiv=[[UIImageView alloc] initWithFrame:CGRectMake(rect.size.width*i, 0, rect.size.width, rect.size.height)];
            [uiv setContentMode:UIViewContentModeScaleAspectFill];
            //[uiv setTag:i];
            [uiv setImage: [UIImage imageNamed:[_featured objectAtIndex:i]]];
            [self.featuredScrollView addSubview:uiv];
        

        /*
            NSString *filePath=[[AppDelegate getImagesPathForServer:_appDelegate.selectedStore.peerInfo.deviceID] stringByAppendingPathComponent:prod.pictureFile];
        
            if([[NSFileManager defaultManager] fileExistsAtPath:filePath])
            {
                dispatch_queue_t imageQueue = dispatch_queue_create("Image Queue",NULL);
                dispatch_async(imageQueue, ^{
                    
                    
                    //NSData *imageData=[NSData dataWithContentsOfFile:filePath];
                    
                    UIImage *image=[UIImage imageWithContentsOfFile:filePath];
                    
                    //if(!imageData) return;
                    if(image){
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
         
                            [uiv setImage:image];
                            
         
                        });
                    }
                    
                });
            }
            else
            {
                
                
                
                // this is for BT connection but it may be very slow
                //TODO: implement compression
                //dispatch_async(dispatch_get_main_queue(), ^{
                NSString *serverPath=[NSString stringWithFormat:@"images/%@",prod.pictureFile];
                
                BroadcastMessageAPI *message=[[BroadcastMessageAPI alloc] init];
                message.text=serverPath;
                message.isBroadcast=NO;
                message.toPeerInfo=_appDelegate.selectedStore.peerInfo;
                message.message_type=MSG_TYPE_REQUEST_FILE_DOWNLOAD;
                message.localCopy=NO;
                
                // [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didFinishDownload:) name:pc.pictureFile object:nil];
                
                NSDictionary *dict = @{KEY_SEND_MESSAGE: message
                                       };
                
                [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_HAS_DATA_TO_SEND
                 
                 
                 
                                                                    object:nil
                                                                  userInfo:dict];
                
                
                
                //});
                
            }
             */
            
            
        }
        
    //}
    
}

-(void)moveToNextPage{
    //if(self.featuredScrollView){
    CGRect rect = [UIScreen mainScreen].bounds;
    
   
    
    //return;
    
    

    CGFloat pageWidth = rect.size.width;//self.featuredScrollView.frame.size.width;
        CGFloat maxWidth = pageWidth * _featured.count;
        CGFloat contentOffset = self.featuredScrollView.contentOffset.x;
        CGFloat slideToX = contentOffset + pageWidth;
        if(contentOffset + pageWidth == maxWidth){
            slideToX = 0;
        }
        //NOT WORKING: [self.featuredScrollView scrollRectToVisible:CGRectMake(slideToX, 0, pageWidth, self.scrollView.frame.size.height) animated:YES];
        [self.featuredScrollView setContentOffset:CGPointMake(slideToX, 0)];
        NSLog(@"slideToX: %f",slideToX);
        
        //if(self.feaView){
            //CGFloat pageWidth = scrollView.frame.size.width;
            CGFloat currentPage =floorf((self.featuredScrollView.contentOffset.x - pageWidth/2)/pageWidth)+1;
            self.pageControl.currentPage = (int)currentPage;
            NSLog(@"self.pageControl.currentPage: %ld",(long)self.pageControl.currentPage);
            /*
            Product *p = [_featured objectAtIndex:currentPage];
            NSString *priceLabel=@"";
            if(p.price>0){
                priceLabel=[Product priceToString:(double)p.price/100 currency:_appDelegate.selectedStore.inventory.currencySymbol];//
            }
            
            [self.feaTitle setText:[NSString stringWithFormat:@"%@\n%@",p.name,priceLabel]];
             */
        //}
        
        
    //}
    if(timer.timeInterval==10){
        [timer invalidate];
        //if(timer==nil || timer.isValid==NO ){
            timer = [NSTimer scheduledTimerWithTimeInterval:4 target:self selector:@selector(moveToNextPage) userInfo:nil repeats:YES];
        //}
    }
}
- (IBAction)enterAppAction:(id)sender {
    ConnectionsViewController* destViewController = (ConnectionsViewController*) [ApplicationDelegate.storyBoard instantiateViewControllerWithIdentifier:@"ConnectionsViewController"];
    //browser.delegate = self;
    
    UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:destViewController];
    
    [self presentViewController:nav animated:YES completion:nil];
}

-(void)setNeedsStatusBarAppearanceUpdate{
    
}

-(BOOL)prefersStatusBarHidden{
    return YES;
}
/*- (BOOL)prefersStatusBarHidden {
    return YES;
}
 */

@end
