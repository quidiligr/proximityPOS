//
//  MainMenuCollectionViewController.m
//  superkiosk
//
//  Created by Robert Gold on 2/17/17.
//  Copyright © 2017 Appcoda. All rights reserved.
//

#import "MainMenuCollectionViewController.h"
#import "Product.h"
#import "ProductCategory.h"
#import "MenuHeaderCollectionReusableView.h"
#import "MenuCategoryCollectionCell.h"
#import "MenuCategoryProductsViewController.h"
#import "BroadcastMessageAPI.h"
#import "ConnectionManager.h"
#import "ReachabilityManager.h"
#import "AsyncImageView.h"

#import "defs.h"
@interface MainMenuCollectionViewController ()
{
    NSMutableArray *_menu;
    NSMutableArray *_featured;
    
    ProductCategory *_selectedCategory;
    Product *_selectedProduct;
    
    AppDelegate *_appDelegate;
    
    ConnectionManager *_connManager;
    
    ReachabilityManager *rm;
    
    UIBarButtonItem *_backButtonItem;
    
    NSTimer *timer;
    
    
}

@property (nonatomic,strong) UIScrollView *featuredScrollView;

@end

@implementation MainMenuCollectionViewController

dispatch_queue_t queue;
//static NSString * const reuseIdentifier = @"Cell";







- (void)viewDidLoad {
    [super viewDidLoad];
    
   // [self reloadMenu];
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
    //[self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    // Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor clearColor];
    //self.tableView.backgroundColor=[UIColor clearColor];
    _appDelegate = ApplicationDelegate;
    /*
    if(_appDelegate.isIpad)
        isListView=NO;
    else
        isListView=YES;
    */
    _connManager=[ConnectionManager sharedInstance];
    
    
    rm=[ReachabilityManager sharedInstance];
    
    _backButtonItem=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Back"] style:UIBarButtonItemStyleBordered target:self action:@selector(backButtonItemTapped)];
    
    self.navigationItem.leftBarButtonItem=_backButtonItem;

    /*
    _searchButtonItem=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Search"] style:UIBarButtonItemStyleBordered target:self action:@selector(showBrowserAction)];
    
    self.navigationItem.leftBarButtonItem=_searchButtonItem;
    
    
    _menuButtonItem=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Menu"] style:UIBarButtonItemStyleBordered target:self action:@selector(showMenuActionSheet)];
    
    self.navigationItem.rightBarButtonItem=_menuButtonItem;
    
    _menuActionSheet=[[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:TITLE_SEARCH,TITLE_BARCODE,TITLE_LISTVIEW, nil];
    
    UICollectionViewFlowLayout *collectionViewLayout = (UICollectionViewFlowLayout*)self.collectionView.collectionViewLayout;
    collectionViewLayout.sectionInset = UIEdgeInsetsMake(20, 0, 20, 0);
    */
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didReceiveMenuWithNotification:)
                                                 name:NOTIFY_RECEIVED_MENU
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didReceiveMenuWithNotification:)
                                                 name:NOTIFY_RECEIVED_MENU_UPDATE
                                               object:nil];
    
    
    
    
    /* [[NSNotificationCenter defaultCenter] addObserver:self
     selector:@selector(didFinishDownload:)
     name:NOTIFY_DOWNLOAD_DONE
     object:nil];
     
     */
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didReceiveUpdateProductImageNotification:)
                                                 name:NOTIFY_UPDATE_PRODUCT_IMAGE
                                               object:nil];
    
    /*
     [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
     //self.parentViewController.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"common_bg"]];
     //self.tableView.backgroundColor = [UIColor clearColor];
     UIEdgeInsets inset = UIEdgeInsetsMake(5, 0, 0, 0);
     self.tableView.contentInset = inset;
     */
    //_appDelegate.selectedStore.peerInfo.peerID.displayName;
    
    /*
     currentItemIndex = 0;     // <---- #3
     [self setOrder:[Order new]];     // <---- #4
     */
    queue = dispatch_queue_create("com.sharecle.kiosk",nil); // <======
    /*
#ifdef ENABLE_IAD
    if ([self respondsToSelector:@selector(setCanDisplayBannerAds:)]) {
        
        self.canDisplayBannerAds=YES;
    }
#endif
    */
    _collectionView.dataSource=self;
    _collectionView.delegate=self;
    
    /*_carousel.delegate=self;
    _carousel.dataSource=self;
    _carousel.type = iCarouselTypeLinear;
     */
    //_carousel.pagingEnabled = NO;
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if(_appDelegate.selectedStore!=nil){
        [self reloadMenu];
        [self.collectionView reloadData];
        /*CGRect carouselFrame=self.carousel.frame;
        CGSize  collectionViewSize = self.collectionView.collectionViewLayout.collectionViewContentSize;
        
        self.scrollView.contentSize =CGSizeMake(carouselFrame.size.width+collectionViewSize.width,carouselFrame.size.height+collectionViewSize.height);
        */
        CGRect contentRect = CGRectZero;
        for(UIView *view in self.scrollView.subviews){
            contentRect = CGRectUnion(contentRect,view.frame);
        }
        self.scrollView.contentSize=contentRect.size;
        //[self loadBgPhoto];
        self.title=_appDelegate.selectedStore.storeName;//
    }
    else{
        //[self showBrowserAction];
    }
    
    /*if([_menu count]==0){
     
     BroadcastMessageAPI *m=[[BroadcastMessageAPI alloc] init];
     //message.text=serverPath;
     m.message_type=MSG_TYPE_REQUEST_SERVERINFO;
     m.toPeerInfo=_appDelegate.mcManager.serverPeerInfo;
     m.isBroadcast=NO;
     
     m.localCopy=NO;
     
     
     NSDictionary *dict = @{KEY_SEND_MESSAGE: m
     };
     
     
     [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_HAS_DATA_TO_SEND
     object:nil
     userInfo:dict];
     //[AppDelegate toast:@"Loading" duration:3];
     }
     */
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)reloadMenu{
    //NSArray *inventory_array=[_appDelegate.selectedStore.inventory_dict valueForKey:inventoryKey];
    /*
     StoreHistory *store=[_appDelegate.historyModel storeWithStoreID:_appDelegate.selectedStore.peerInfo.deviceID];
     if(store==nil)
     return;
     */
    if(_menu==nil)
        _menu = [NSMutableArray new];
    else
        [_menu removeAllObjects];
    
    if(_featured==nil)
        _featured = [NSMutableArray new];
    else
        [_featured removeAllObjects];
    
    
    /*
     for (NSDictionary *dict in inventory_array ) {
     ProductCategory *pc=[[ProductCategory alloc] initWithDictionary:dict];
     
     [_inventory addObject:pc];
     }
     */
    NSArray *pcs=_appDelegate.selectedStore.inventory.categories;//_appDelegate.selectedStore.inventory.categories;
    
    
    
    for(ProductCategory *pc in pcs){
        
        pc.products=[_appDelegate.selectedStore.inventory allProductsWithCategoryID:pc.categoryID sorted:YES];
        /*for(Product *prod in pc.products){
         prod.imageLoadStatus=STATUS_LOAD_NONE;
         }
         */
        /*if([_menu count]==1 || [_appDelegate.selectedStore.inventory.products count]<50){
         pc.expanded=YES;
         }
         else{
         pc.expanded=NO;
         
         }*/
        //TODO: For now will just ger fetured products for the first 3 product in each category, later on we will use the feature field of product.
        if(pc.products.count>0 && _featured.count<4){
            [_featured addObject:[pc.products objectAtIndex:0]];
        }
        [_menu addObject:pc];
        
    }
    
    
    //categorySectionTitles=[_inventory valueForKey:NAME_KEY]; //[menu valueForKey:NAME_KEY];
    //dispatch_async(dispatch_get_main_queue(), ^{
    //[self.collectionView reloadData];
    //});
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark <UICollectionViewDataSource>
/*
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
#warning Incomplete implementation, return the number of sections
    return 0;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of items
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    // Configure the cell
    
    return cell;
}
*/
#pragma mark <UICollectionViewDelegate>

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/
/*
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    NSInteger count= [_featured count]; //[categorySectionTitles count];
    if(count>0)
        return 1;
    else
        return 0;
    //return count;//[categorySectionTitles count];
}
*/
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    /*
    ProductCategory *cat=[_menu objectAtIndex:section];
    
    
    if (!cat.expanded) {
        return 0;
    }
    else{
        
        return [cat.products count];
    }
     */
    NSInteger count= [_menu count]; //[categorySectionTitles count];
            return count;
    
}

- (UICollectionReusableView *)viewForHeaderInSection:(NSIndexPath *)indexPath{
    /*
     MenuHeaderView *cell = [self.collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView" forIndexPath:indexPath];
     */
    
    UICollectionReusableView *cell = [self.collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView" forIndexPath:indexPath];
    /*cell.carousel=[[iCarousel alloc] initWithFrame:CGRectMake(0, 0, 300,400)];
     cell.carousel.delegate=self;
     cell.carousel.dataSource=self;
     */
    
    //Product *prod=[_featured objectAtIndex:0];//indexPath.section];
    
    if(_featured){
        
        //CGRect frame = self.pageControl.frame;
        //frame.size.height = 100;
        //frame.size.width = 100;
        //self.pageControl.frame=frame;
        
        //[self.pageControl setCurrentPage:0];
        //self.pageControl.pageIndicatorTintColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"inactive_dot.png"]];
        
        //self.pageControl.currentPageIndicatorTintColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"active_dot.png"]];
        
        
        CGRect rect = [UIScreen mainScreen].bounds;
        self.featuredScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, rect.size.width, 300)];
        //self.featuredScrollView.pagingEnabled=YES;
        self.featuredScrollView.autoresizingMask=UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        self.featuredScrollView.backgroundColor = [UIColor whiteColor];
        self.featuredScrollView.delegate=self;
        
        
        //for(Product *fp in _featured){
        //fp.pictureFile
        //}
        /*
        for(int i=0; i<_featured.count;i++){
            [featuredScrollView addSubview:[[UIImageView alloc] initWithFrame:CGRectMake(300*i, 0, rect.size.width, 300)]];
        }
        */
        self.featuredScrollView.contentSize=CGSizeMake(rect.size.width*_featured.count, 300);
        [cell addSubview:self.featuredScrollView];
        
        CGRect re = self.featuredScrollView.frame;
        
        //self.feaView = [[UIView alloc] initWithFrame:CGRectMake((re.size.width/2)-150, re.size.height-100, 300, 100)];
        self.feaView = [[UIView alloc] initWithFrame:CGRectMake(0, re.size.height-100, re.size.width, 100)];
        self.feaTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, re.size.width, 60)];
        
        [self.feaTitle setTextColor:[UIColor whiteColor]];
        [self.feaTitle setNumberOfLines:0];
        [self.feaTitle setTextAlignment:NSTextAlignmentCenter];
        [self.feaTitle setFont:[UIFont fontWithName:@"TrebuchetMS-Bold" size:25]];
        
        
        self.pageControl=[[UIPageControl alloc] initWithFrame:CGRectMake( (self.feaTitle.frame.size.width/2)-150, 60, 300, 40)];
        self.pageControl.numberOfPages=[_featured count];
        
        [self.feaView addSubview:self.feaTitle];
        [self.feaView addSubview:self.pageControl];
        //[self.feaView setBackgroundColor:[UIColor whiteColor]];
        [self.feaView setAlpha:55];
        //[cell addSubview:self.pageControl];
        [cell addSubview:self.feaView];
        
        
        //for(Product *prod in _featured){
        for(int i=0; i<_featured.count;i++){
            Product *prod=[_featured objectAtIndex:i];
        if( prod.pictureFile.length>0){
            UIImageView *uiv=[[UIImageView alloc] initWithFrame:CGRectMake(rect.size.width*i, 0, rect.size.width, 300)];
            [uiv setContentMode:UIViewContentModeScaleAspectFill];
            [uiv setTag:i];
            [self.featuredScrollView addSubview:uiv];
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
                        //if(cell.image){
                            //[cell.image setImage:[UIImage imageWithData:imageData]];
                            /*UIImage *newImage = [self imageWithImage:image scaledToSize:CGSizeMake(rect.size.width, 300)];
                            
                            [uiv setImage:newImage];
                        
                            */
                        [uiv setImage:image];
                        //}
                        
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
            
            
        }
        
    }
        if(timer==nil){
            //timer = [NSTimer scheduledTimerWithTimeInterval:4 target:self selector:@selector(moveToNextPage) userInfo:nil repeats:YES];
        }
    }
    
    //cell.image.image=nil;
    
    
    
    
    
    
    /*
     if(pc.detail){
     //cell=[tableView dequeueReusableCellWithIdentifier:@"MenuSectionNoImageCell"];
     cell.descriptonLabel.text=pc.detail;
     }
     else {
     //cell=[tableView dequeueReusableCellWithIdentifier:@"MenuSectionTitleOnlyCell"];
     cell.descriptonLabel.text=nil;
     }
     */
    
    //cell.title.text =prod.name;
    
    
    /*
     if(!pc.expanded){
     
     
     [cell.expandImage setImage:[UIImage imageNamed:@"expand_arrow"] ];
     
     
     }
     else{
     
     [cell.expandImage setImage:[UIImage imageNamed:@"collapse_arrow"] ];
     
     }
     
     UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(expandGesture:)];
     
     [cell addGestureRecognizer:tap];
     cell.tag=indexPath.section;
     */
    
    // cell.backgroundColor=[UIColor grayColor];
    return cell;
}
- (UICollectionReusableView *)viewForHeaderInSection__:(NSIndexPath *)indexPath{
    /*
    MenuHeaderView *cell = [self.collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView" forIndexPath:indexPath];
    */
    MenuHeaderCollectionReusableView *cell = [self.collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView" forIndexPath:indexPath];
    /*cell.carousel=[[iCarousel alloc] initWithFrame:CGRectMake(0, 0, 300,400)];
    cell.carousel.delegate=self;
    cell.carousel.dataSource=self;
     */
    
    Product *prod=[_featured objectAtIndex:0];//indexPath.section];
    
    
    
    
    //cell.image.image=nil;
    
    
    
    if(prod.pictureFile.length>0){
        
        NSString *filePath=[[AppDelegate getImagesPathForServer:_appDelegate.selectedStore.peerInfo.deviceID] stringByAppendingPathComponent:prod.pictureFile];
        if([[NSFileManager defaultManager] fileExistsAtPath:filePath])
        {
            dispatch_queue_t imageQueue = dispatch_queue_create("Image Queue",NULL);
            dispatch_async(imageQueue, ^{
                
                
                //NSData *imageData=[NSData dataWithContentsOfFile:filePath];
                
                UIImage *image=[UIImage imageWithContentsOfFile:filePath];
                
                //if(!imageData) return;
                if(!image) return;
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    if(cell.image){
                        //[cell.image setImage:[UIImage imageWithData:imageData]];
                        UIImage *newImage = [self imageWithImage:image scaledToSize:CGSizeMake(768, 300)];
                        
                        [cell.image setImage:newImage];
                        
                    }
                    
                });
                
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
        
        
    }
    
    
    
    /*
    if(pc.detail){
        //cell=[tableView dequeueReusableCellWithIdentifier:@"MenuSectionNoImageCell"];
        cell.descriptonLabel.text=pc.detail;
    }
    else {
        //cell=[tableView dequeueReusableCellWithIdentifier:@"MenuSectionTitleOnlyCell"];
        cell.descriptonLabel.text=nil;
    }
     */
    
    cell.title.text =prod.name;
    
    
    /*
    if(!pc.expanded){
        
        
        [cell.expandImage setImage:[UIImage imageNamed:@"expand_arrow"] ];
        
        
    }
    else{
        
        [cell.expandImage setImage:[UIImage imageNamed:@"collapse_arrow"] ];
        
    }
    
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(expandGesture:)];
    
    [cell addGestureRecognizer:tap];
    cell.tag=indexPath.section;
     */
    
    // cell.backgroundColor=[UIColor grayColor];
    return cell;
    
}


- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableview = nil;
    
    if (kind == UICollectionElementKindSectionHeader) {
        return [self viewForHeaderInSection:indexPath];
       
    }
    
    if (kind == UICollectionElementKindSectionFooter) {
        UICollectionReusableView *footerview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"FooterView" forIndexPath:indexPath];
        
        reusableview = footerview;
    }
    
    return reusableview;
}

/*
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(nonnull UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(nonnull NSIndexPath *)indexPath{
    
    if(_appDelegate.isIpad){
        if(isListView)
            return CGSizeMake(600, 122);
        else
            return CGSizeMake(200, 200);
    }
    else{
        if(isListView)
            return CGSizeMake(300, 100);
        else
            return CGSizeMake(200, 200);
    }
    
}
*/
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
        ProductCategory *cat=[_menu objectAtIndex:indexPath.row];
    
    //Product *product=[cat.products objectAtIndex:indexPath.row];//[[Product alloc] initWithDictionary:[sectionProducts objectAtIndex:indexPath.row]];
    
    /*if(_appDelegate.selectedStore.inventory.isEcommerce){
        
        return [self menuCell:indexPath withProduct:product];
   }
    else
     
    */
    return [self menuCategoryCell:indexPath withCategory:cat];
    
    
}

- (UICollectionViewCell *)menuCategoryCell:(NSIndexPath *)indexPath  withCategory:(ProductCategory *)cat{
    
    Product *product = nil;
    if(cat.products.count>0)
        product = [cat.products objectAtIndex:0];
    
    /*
     static NSString *identifier = @"Cell";
     
     UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
     
     UIImageView *recipeImageView = (UIImageView *)[cell viewWithTag:100];
     recipeImageView.image = [UIImage imageNamed:[recipeImages objectAtIndex:indexPath.row]];
     cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"photo-frame.png"]];
     
     return cell;
     */

    BOOL hasImage=NO;
    NSString *filePath=nil;
    MenuCategoryCollectionCell *cell;
    //NSString *identifier;// = @"MenuCollectionCell";
    static NSString *identifier = @"MenuCategoryCollectionCell";
    
    if(product!=nil && product.pictureFile!=nil && product.pictureFile.length>0){
        filePath=[[AppDelegate getImagesPathForServer:_appDelegate.selectedStore.deviceID] stringByAppendingPathComponent:product.pictureFile];
        
        if([[NSFileManager defaultManager] fileExistsAtPath:filePath])
        {
            //this means that images is already downloaded in the background
            hasImage=YES;
        }
        else{
            if(_appDelegate.selectedStore.isConnected){
                //if(product.imageLoadStatus!=STATUS_LOADED){
                // product.imageLoadStatus=STATUS_LOADED;
                NSString *serverPath=[NSString stringWithFormat:@"images/%@",product.pictureFile];
                
                [_connManager downloadViaBlueTooth:serverPath serverPeer:_appDelegate.selectedStore.peerInfo timeOutSec:60];
                //}
            }
            /*
             else{
             
             [cell.loadingIndicator stopAnimating];
             [cell.loadingIndicator setHidden:YES];
             product.imageLoadStatus=STATUS_LOADED;
             // [self restartTimer];
             
             }*/
        }
        
    }
    /*
    if(hasImage){
        if(isListView)
            identifier = @"MenuNoSellListCell";
        else
            identifier = @"MenuNoSellCollectionCell";
    }
    else{
        if(isListView)
            identifier = @"MenuNoSellNoImageListCell";
        else
            identifier = @"MenuNoSellNoImageCollectionCell";
    }
    */
    
    
    //static NSString *identifier = @"MenuNoSellCollectionCell";
    /*
     UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
     
     UIImageView *recipeImageView = (UIImageView *)[cell viewWithTag:100];
     recipeImageView.image = [UIImage imageNamed:[recipeImages objectAtIndex:indexPath.row]];
     cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"photo-frame.png"]];
     */
    //cell = (MenuCollectionCell *)[self.collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    //ProductCategory *cat=[_menu objectAtIndex:indexPath.section];
    
    //Product *product=[cat.products objectAtIndex:indexPath.row];
    /*
     cell.nameLabel.text=product.name;
    cell.shortDescLabel.text=product.shortDesc;
     [cell.loadingIndicator hidesWhenStopped];

    */
    /*
    UILabel *nameLabel=(UILabel *)[cell viewWithTag:101];
    nameLabel.text=cat.name;
    
    UIImageView *imageView = (UIImageView *)[cell viewWithTag:100];
    imageView.image=nil;
    */
    
    cell.nameLabel.text=cat.name;
    if(hasImage){
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSData *imageData=[NSData dataWithContentsOfFile:filePath];
            
            
            //[cell.loadingIndicator stopAnimating];
            
            
            if(imageData) {
                

                //imageView.image =[UIImage imageWithData:imageData];
                //cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"photo-frame.png"]];
                [cell.categoryImage setImage:[UIImage imageWithData:imageData]];
                
            }
            
            else{
                [cell.categoryImage setImage:nil];
            }
            
            
        });
        
        //});
        /*}
         else
         {
         if(_appDelegate.selectedStore.isConnected){
         NSString *serverPath=[NSString stringWithFormat:@"images/%@",product.pictureFile];
         [self downloadViaBlueTooth:serverPath];
         }
         else{
         
         [cell.loadingIndicator stopAnimating];
         [cell.loadingIndicator setHidden:YES];
         product.imageLoadStatus=STATUS_LOADED;
         // [self restartTimer];
         
         }
         }*/
        //}
        /*else if(product.imageLoadStatus==STATUS_LOADING){//loading
         [cell.loadingIndicator startAnimating];
         
         }
         else if(product.imageLoadStatus==STATUS_LOADED){//loaded
         //[cell.loadingLabel setHidden:YES];
         [cell.loadingIndicator stopAnimating];
         [cell.loadingIndicator setHidden:YES];
         
         NSString *filePath=[[AppDelegate getImagesPathForServer:_appDelegate.selectedStore.deviceID] stringByAppendingPathComponent:product.pictureFile];
         
         //dispatch_queue_t imageQueue = dispatch_queue_create("Image Queue",NULL);
         // dispatch_async(imageQueue, ^{
         
         
         
         
         
         dispatch_async(dispatch_get_main_queue(), ^{
         //if(cell.productImage){
         NSData *imageData=[NSData dataWithContentsOfFile:filePath];
         
         
         product.imageLoadStatus=STATUS_LOADED;
         [cell.loadingIndicator stopAnimating];
         
         if(imageData) {
         [cell.productImage setImage:[UIImage imageWithData:imageData]];
         }
         else{
         [cell.productImage setImage:nil];
         }
         //}
         //cell.productImage.layer.cornerRadius=cell.productImage.frame.size.width / 4;
         // cell.productImage.clipsToBounds = YES;
         });
         
         //});
         
         }
         */
        //}
    }
    /*
     cell.productImage.layer.cornerRadius=cell.productImage.frame.size.width / 4;
     cell.productImage.clipsToBounds = YES;
     
     UIImage *background = [self cellBackgroundForRowAtIndexPath:indexPath];
     
     UIImageView *cellBackgroundView = [[UIImageView alloc] initWithImage:background];
     cellBackgroundView.image = background;
     cell.backgroundView = cellBackgroundView;
     */
    //cell.backgroundColor=[UIColor whiteColor];
    cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"photo-frame.png"]];

    return cell;
}

/*
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"Cell";
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    UIImageView *recipeImageView = (UIImageView *)[cell viewWithTag:100];
    recipeImageView.image = [UIImage imageNamed:[recipeImages objectAtIndex:indexPath.row]];
    cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"photo-frame.png"]];
    
    return cell;
}
*/

-(void)didReceiveUpdateProductImageNotification:(NSNotification *)notification{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.collectionView reloadData];
    });
}

-(void)didReceiveMenuWithNotification:(NSNotification *)notification{
    
    //dispatch_async(dispatch_get_main_queue(), ^{
    
    [self reloadMenu];
    
    //check if items in cart then update
    /*
     CheckoutCart *checkoutCart=[CheckoutCart sharedInstance];
     
     [checkoutCart cleanCart:_appDelegate.selectedStore.peerInfo.deviceID isLive:_appDelegate.selectedStore.peerInfo.isLive withInventory:_appDelegate.selectedStore.inventory];
     */
    
    //});
    
}

-(NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel{
    [self reloadMenu];
    return [_featured count];
}




-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath

{
    _selectedCategory=[_menu objectAtIndex:indexPath.row];
    
    //_selectedProduct=[_selectedCategory.products objectAtIndex:indexPath.row];
    /*
     if(_appDelegate.selectedStore.inventory.isEcommerce)
     [self performSegueWithIdentifier:@"toProductViewController" sender:nil];
     else
     [self performSegueWithIdentifier:@"toProductNoSellViewController" sender:nil];
     */
    /* if([_selectedProduct.options count]>0){
     [self performSegueWithIdentifier:@"toProductOptionsViewController" sender:nil];
     }
     else{
     */
    [self performSegueWithIdentifier:@"toMenuCategoryProducts" sender:nil];
    //}
    // [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_SHOW_MENU_PRODUCT object:nil userInfo:@{@"product":_selectedProduct,@"category":_selectedCategory}];
}
- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view
{
    
    BOOL hasImage=NO;
    NSString *filePath=nil;
    
    Product *product=[_featured objectAtIndex:index];
    if(product!=nil && product.pictureFile!=nil && product.pictureFile.length>0){
        filePath=[[AppDelegate getImagesPathForServer:_appDelegate.selectedStore.deviceID] stringByAppendingPathComponent:product.pictureFile];
        
        if([[NSFileManager defaultManager] fileExistsAtPath:filePath])
        {
            //this means that images is already downloaded in the background
            hasImage=YES;
        }
        else{
            if(_appDelegate.selectedStore.isConnected){
                //if(product.imageLoadStatus!=STATUS_LOADED){
                // product.imageLoadStatus=STATUS_LOADED;
                NSString *serverPath=[NSString stringWithFormat:@"images/%@",product.pictureFile];
                
                [_connManager downloadViaBlueTooth:serverPath serverPeer:_appDelegate.selectedStore.peerInfo timeOutSec:60];
                //}
            }
        }
        
    }
    

    UILabel *label = nil;
    
    
    //create new view if no view is available for recycling
    if (view == nil)
    {
        //don't do anything specific to the index within
        //this `if (view == nil) {...}` statement because the view will be
        //recycled and used with other index values later
        view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 200.0f, 200.0f)];
        
        if(hasImage){
            dispatch_async(dispatch_get_main_queue(), ^{
                
                NSData *imageData=[NSData dataWithContentsOfFile:filePath];
                
                
                //[cell.loadingIndicator stopAnimating];
                
                
                if(imageData) {
                    
                    
                    
                    
                    
                    ((UIImageView *)view).image = [UIImage imageWithData:imageData];
                    view.contentMode = UIViewContentModeCenter;

                    
                }
                
                else{
                   ((UIImageView *)view).image = nil;
                }
                
                
            });
        }

        
        
        label = [[UILabel alloc] initWithFrame:view.bounds];
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [label.font fontWithSize:50];
        label.tag = 1;
        [view addSubview:label];
    }
    else
    {
        //get a reference to the label in the recycled view
        label = (UILabel *)[view viewWithTag:1];
    }
    
    //set item label
    //remember to always set any properties of your carousel item
    //views outside of the `if (view == nil) {...}` check otherwise
    //you'll get weird issues with carousel item content appearing
    //in the wrong place in the carousel
    label.text = product.name;//[_items[index] stringValue];
    
    
    return view;
}

- (CGFloat)carousel:(iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value
{
    if (option == iCarouselOptionSpacing)
    {
        return value * 1.1;
    }
    return value;
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    CGRect screenSize =[UIScreen mainScreen].bounds; //UIScreen.mainScreen().bounds let screenWidth = screenSize.width
    
    //return CGSizeMake(screenSize.size.width/3 , screenSize.size.height/3);//CGSize(width: screenWidth/3, height: screenWidth/3);
    return CGSizeMake(screenSize.size.width/4 , screenSize.size.width/4);
}

-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    CGFloat pageWidth = scrollView.frame.size.width;
    CGFloat currentPage =floorf((scrollView.contentOffset.x - pageWidth/2)/pageWidth)+1;
    self.pageControl.currentPage = (int)currentPage;
    if( (int)currentPage == 0){
        
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"toMenuCategoryProducts"]){
    MenuCategoryProductsViewController *vc=segue.destinationViewController;
    vc.selectedCategory=_selectedCategory;
    }
}

-(UIImage *)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize
{
    
    UIGraphicsBeginImageContextWithOptions(newSize, YES, image.scale);
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
    
}

-(void)moveToNextPage{
    if(self.featuredScrollView){
        CGFloat pageWidth = self.featuredScrollView.frame.size.width;
        CGFloat maxWidth = pageWidth * _featured.count;
        CGFloat contentOffset = self.featuredScrollView.contentOffset.x;
        CGFloat slideToX = contentOffset + pageWidth;
        if(contentOffset + pageWidth == maxWidth){
            slideToX = 0;
        }
        //NOT WORKING: [self.featuredScrollView scrollRectToVisible:CGRectMake(slideToX, 0, pageWidth, self.scrollView.frame.size.height) animated:YES];
        [self.featuredScrollView setContentOffset:CGPointMake(slideToX, 0)];
        NSLog(@"slideToX: %f",slideToX);
        
        if(self.feaView){
        //CGFloat pageWidth = scrollView.frame.size.width;
        CGFloat currentPage =floorf((self.featuredScrollView.contentOffset.x - pageWidth/2)/pageWidth)+1;
        self.pageControl.currentPage = (int)currentPage;
        NSLog(@"self.pageControl.currentPage: %ld",(long)self.pageControl.currentPage);
            
            Product *p = [_featured objectAtIndex:currentPage];
            NSString *priceLabel=@"";
            if(p.price>0){
                priceLabel=[Product priceToString:(double)p.price/100 currency:_appDelegate.selectedStore.inventory.currencySymbol];//
            }
            
            [self.feaTitle setText:[NSString stringWithFormat:@"%@\n%@",p.name,priceLabel]];
        }
        
       
    }
}

-(void)backButtonItemTapped{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

@end
