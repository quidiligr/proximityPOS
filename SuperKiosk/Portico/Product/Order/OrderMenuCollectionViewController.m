//
//  IODViewController.m
//  iOSDiner
//
//  Created by Romulo Quidilig on 3/19/15.
//  Copyright (c) 2015 Sharecle Inc. All rights reserved.
//

#import "OrderMenuCollectionViewController.h"

#import "OrderItem.h"     // <---- #1
#import "Order.h"     // <---- #1
#import "Product.h"
//#import "OrderItem.h"
#import "CheckoutCart.h"
//#import "ProductViewController.h"
#import "BroadcastMessageAPI.h"
//#import "MessageNBCell.h"
//#import "MessageTableViewData.h"
//#import "SWRevealViewController.h"

#import "MenuCollectionCell.h"
#import "ConnectionManager.h"
#import "ReachabilityManager.h"
//#import "MenuNoImageCollectionCell.h"

//#import "MenuNoSellNoImageCollectionCell.h"
//#import "MenuNoSellCollectionCell.h"


//#import "MenuSectionCell.h"
//#import "MenuSectionNoImageCell.h"

#import "ProductViewController.h"
#import "ProductNoSellViewController.h"


#import "MenuHeaderView.h"


#import "AppSettingsViewController.h"

#import "ReachabilityManager.h"

#import "defs.h"



@implementation OrderMenuCollectionViewController
{
    //NSArray *categorySectionTitles;
    UIImage *_myPhoto;
    
    //Product *selectedProduct;
    //InventoryItem *_selectedInventory;
    ProductCategory *_selectedCategory;
    Product *_selectedProduct;
    
    AppDelegate *_appDelegate;
    BOOL bannerIsVisible;
    NSTimer *timerWaitBeforReload;
    NSMutableArray *_menu;// _sortedCategories;
    //ProductIpadViewController *detailProduct;
    /*
    UINavigationController *navProduct;
    
    UIBarButtonItem *settingsButtonItem;
    
    UIBarButtonItem *_searchButtonItem;
    UIBarButtonItem *_barcodeButtonItem;
    */
    UIBarButtonItem *_menuButtonItem;
    UIActionSheet *_menuActionSheet;
    UIBarButtonItem *_searchButtonItem;//_backButtonItem;
    NSInteger isListView;

    NSTimer *timer; //reload timer
    ConnectionManager *_connManager;
    
    ReachabilityManager *rm;
}


@synthesize order;

dispatch_queue_t queue;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

-(void)dealloc {
    //   dispatch_release(queue);
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor=[UIColor clearColor];
    //self.tableView.backgroundColor=[UIColor clearColor];
    _appDelegate = ApplicationDelegate;
    if(_appDelegate.isIpad)
        isListView=NO;
    else
        isListView=YES;
    
    _connManager=[ConnectionManager sharedInstance];
    
    
    rm=[ReachabilityManager sharedInstance];
    
    /*
       settingsButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"Settings" style:UIBarButtonItemStyleBordered target:self action:@selector(showSettngsAction:)];
    
    _searchButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"Search" style:UIBarButtonItemStyleBordered target:self action:@selector(searchAction:)];
    
    _barcodeButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"Barcode" style:UIBarButtonItemStyleBordered target:self action:@selector(barcodeAction:)];
    
    
    self.navigationItem.rightBarButtonItems=@[settingsButtonItem];
    self.navigationItem.leftBarButtonItems=@[_searchButtonItem,_barcodeButtonItem];
    */
    //_menuButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"Menu" style:UIBarButtonItemStyleBordered target:self action:@selector(showMenuActionSheet)];
    
    //_backButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:self action:@selector(backButtonItemTapped)];
   //_backButtonItem=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Back"] style:UIBarButtonItemStyleBordered target:self action:@selector(backButtonItemTapped)];
    
     _searchButtonItem=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Search"] style:UIBarButtonItemStyleBordered target:self action:@selector(showBrowserAction)];
    
    self.navigationItem.leftBarButtonItem=_searchButtonItem;
    
    
    _menuButtonItem=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Menu"] style:UIBarButtonItemStyleBordered target:self action:@selector(showMenuActionSheet)];
    
    self.navigationItem.rightBarButtonItem=_menuButtonItem;
    
    _menuActionSheet=[[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:TITLE_SEARCH,TITLE_BARCODE,TITLE_LISTVIEW, nil];
    
    UICollectionViewFlowLayout *collectionViewLayout = (UICollectionViewFlowLayout*)self.collectionView.collectionViewLayout;
    collectionViewLayout.sectionInset = UIEdgeInsetsMake(20, 0, 20, 0);

    
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
    
#ifdef ENABLE_IAD
    if ([self respondsToSelector:@selector(setCanDisplayBannerAds:)]) {
        
        self.canDisplayBannerAds=YES;
    }
#endif
}



/*- (void)viewWillAppear:(BOOL)animated
 {
 [super viewWillAppear:animated];
 }
 */
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
        [_menu addObject:pc];
    }
    
    
    //categorySectionTitles=[_inventory valueForKey:NAME_KEY]; //[menu valueForKey:NAME_KEY];
    //dispatch_async(dispatch_get_main_queue(), ^{
    [self.collectionView reloadData];
    //});
    
}

/*
 -(void)reloadMenu{
 _selectedInventory=[InventoryModel activeInventory];
 
 
 if(_sortedCategories==nil)
 _sortedCategories = [NSMutableArray new];
 
 [_sortedCategories removeAllObjects];
 
 NSArray *allSortedCategories=[_selectedInventory.categories sortedArrayUsingDescriptors:descriptors];
 for (ProductCategory *pc in allSortedCategories) {
 pc.sortedProducts=[_selectedInventory allProductsWithCategoryID:pc.categoryID sorted:YES];
 if(pc.sortedProducts!=nil && [pc.sortedProducts count]>0){
 [_sortedCategories addObject:pc];
 }
 }
 
 categorySectionTitles=[_sortedCategories valueForKey:NAME_KEY];
 
 
 if(categorySectionTitles==nil)
 categorySectionTitles=[NSMutableArray new];
 
 
 
 if(categorySectionTitles.count==0){
 [self.tableView setHidden:YES];
 
 }
 else{
 [self.tableView reloadData];
 [self.tableView setHidden:NO];
 }
 }
 */

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if(_appDelegate.selectedStore!=nil){
    [self reloadMenu];
    
    
    //[self loadBgPhoto];
    self.title=_appDelegate.selectedStore.storeName;//
    }
    else{
        [self showBrowserAction];
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
/*
 - (void)viewWillDisappear:(BOOL)animated
 {
	[super viewWillDisappear:animated];
 }
 
 - (void)viewDidDisappear:(BOOL)animated
 {
	[super viewDidDisappear:animated];
 }
 */
-(UIInterfaceOrientationMask)supportedInterfaceOrientations{
    if([[UIDevice currentDevice] userInterfaceIdiom]==UIUserInterfaceIdiomPad){
        //ipad allow all orientaions
        return UIInterfaceOrientationMaskAll;
    }
    else{
        //iphone allow only landscape
        return UIInterfaceOrientationMaskLandscape;
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (IBAction)ibaRemoveItem:(id)sender {
    /* OrderItem* currentItem = [[self inventory] objectAtIndex:currentItemIndex];
     
     [order removeItemFromOrder:currentItem];
     [self updateOrderBoard];
     [self updateCurrentInventoryItem];
     [self updateInventoryButtons];
     
     UILabel* removeItemDisplay = [[UILabel alloc] initWithFrame:[ibCurrentItemImageView frame]];
     [removeItemDisplay setCenter:[ibChalkboardLabel center]];
     [removeItemDisplay setText:@"-1"];
     [removeItemDisplay setTextAlignment:UITextAlignmentCenter];
     [removeItemDisplay setTextColor:[UIColor redColor]];
     [removeItemDisplay setBackgroundColor:[UIColor clearColor]];
     [removeItemDisplay setFont:[UIFont boldSystemFontOfSize:32.0]];
     [[self view] addSubview:removeItemDisplay];
     
     [UIView animateWithDuration:1.0
     animations:^{
     [removeItemDisplay setCenter:[ibCurrentItemImageView center]];
     [removeItemDisplay setAlpha:0.0];
     } completion:^(BOOL finished) {
     [removeItemDisplay removeFromSuperview];
     }];
     */
    
}
- (void)removeItem:(NSIndexPath *)indexPath {
    /*
     NSString *sectionTitle = [categorySectionTitles objectAtIndex:indexPath.section];
     NSArray *sectionProducts = [_appDelegate.selectedStore.inventory_dict objectForKey:sectionTitle];
     */
    //NSDictionary *cat=[_appDelegate.selectedStore.inventory_dict objectAtIndex:indexPath.section];
    /*StoreHistory *store=[_appDelegate.historyModel storeWithStoreID:_appDelegate.selectedStore.peerInfo.deviceID];
    if(store==nil)
        return;
*/
    NSDictionary *cat=[[_appDelegate.selectedStore.inventory valueForKey:@"products"] objectAtIndex:indexPath.section];
    
    NSArray *sectionProducts = [cat objectForKey:PRODUCTS_KEY];
    
    // NSString *product = [sectionProducts objectAtIndex:indexPath.row];
    OrderItem *currentItem=[sectionProducts objectAtIndex:indexPath.row];
    [order removeItemFromOrder:currentItem];
    [self updateOrderBoard];
    
    //[self updateCurrentInventoryItem];
    //[self updateInventoryButtons];
    /*
    UILabel* removeItemDisplay = [[UILabel alloc] initWithFrame:[self.tableView frame]];
    [removeItemDisplay setCenter:[self.tableView center]];
    [removeItemDisplay setText:@"-1"];
    [removeItemDisplay setTextAlignment:NSTextAlignmentCenter];
    [removeItemDisplay setTextColor:[UIColor redColor]];
    [removeItemDisplay setBackgroundColor:[UIColor clearColor]];
    [removeItemDisplay setFont:[UIFont boldSystemFontOfSize:32.0]];
    [[self view] addSubview:removeItemDisplay];
    
    [UIView animateWithDuration:1.0
                     animations:^{
                         [removeItemDisplay setCenter:[self.tableView center]];
                         [removeItemDisplay setAlpha:0.0];
                     } completion:^(BOOL finished) {
                         [removeItemDisplay removeFromSuperview];
                     }];
     */
    
}


- (IBAction)ibaAddItem:(id)sender {
    /*  OrderItem* currentItem = [[self inventory] objectAtIndex:currentItemIndex];
     
     [order addItemToOrder:currentItem];
     [self updateOrderBoard];
     [self updateCurrentInventoryItem];
     [self updateInventoryButtons];
     
     UILabel* addItemDisplay = [[UILabel alloc] initWithFrame:[ibCurrentItemImageView frame]];
     [addItemDisplay setText:@"+1"];
     [addItemDisplay setTextColor:[UIColor whiteColor]];
     [addItemDisplay setBackgroundColor:[UIColor clearColor]];
     [addItemDisplay setTextAlignment:UITextAlignmentCenter];
     [addItemDisplay setFont:[UIFont boldSystemFontOfSize:32.0]];
     [[self view] addSubview:addItemDisplay];
     
     [UIView animateWithDuration:1.0
     animations:^{
     [addItemDisplay setCenter:[ibChalkboardLabel center]];
     [addItemDisplay setAlpha:0.0];
     } completion:^(BOOL finished) {
     [addItemDisplay removeFromSuperview];
     }];
     */
}
//rom

- (void)addItem:(NSIndexPath *)indexPath {
    
    //OrderItem* currentItem = [[self inventory] objectAtIndex:currentItemIndex];
    /*
     NSString *sectionTitle = [categorySectionTitles objectAtIndex:indexPath.section];
     NSArray *sectionProducts = [_appDelegate.selectedStore.inventory_dict objectForKey:sectionTitle];
     */
    /*
    StoreHistory *store=[_appDelegate.historyModel storeWithStoreID:_appDelegate.selectedStore.peerInfo.deviceID];
    if(store==nil)
        return;
*/
    NSDictionary *cat=[[_appDelegate.selectedStore.inventory valueForKey:@"products"] objectAtIndex:indexPath.section];//[_appDelegate.selectedStore.inventory_dict objectAtIndex:indexPath.section];
    
    NSArray *sectionProducts = [cat objectForKey:PRODUCTS_KEY];
    // NSString *product = [sectionProducts objectAtIndex:indexPath.row];
    OrderItem *currentItem=[sectionProducts objectAtIndex:indexPath.row];
    
    
    
    [order addItemToOrder:currentItem];
    [self updateOrderBoard];
    
    /*
    UILabel* addItemDisplay = [[UILabel alloc] initWithFrame:[self.tableView frame]];
    [addItemDisplay setText:@"+1"];
    [addItemDisplay setTextColor:[UIColor whiteColor]];
    [addItemDisplay setBackgroundColor:[UIColor clearColor]];
    [addItemDisplay setTextAlignment:NSTextAlignmentCenter];
    [addItemDisplay setFont:[UIFont boldSystemFontOfSize:32.0]];
    [[self view] addSubview:addItemDisplay];
    
    [UIView animateWithDuration:1.0
                     animations:^{
                         // [addItemDisplay setCenter:[ibChalkboardLabel center]];
                         [addItemDisplay setCenter:[self.tableView center]];
                         [addItemDisplay setAlpha:0.0];
                     } completion:^(BOOL finished) {
                         [addItemDisplay removeFromSuperview];
                     }];
     */
}

/*
- (IBAction)ibaLoadPreviousItem:(id)sender {
    currentItemIndex--;
    [self updateCurrentInventoryItem];
    [self updateInventoryButtons];
}

- (IBAction)ibaLoadNextItem:(id)sender {
    currentItemIndex++;
    [self updateCurrentInventoryItem];
    [self updateInventoryButtons];
}

- (IBAction)ibaCalculateTotal:(id)sender {
    float total = [order totalOrder];
    
    UIAlertView* totalAlert = [[UIAlertView alloc] initWithTitle:@"Total"
                                                         message:[NSString stringWithFormat:@"$%0.2f",total]
                                                        delegate:nil
                                               cancelButtonTitle:@"Close"
                                               otherButtonTitles:nil];
    [totalAlert show];
}
*/
#pragma mark - Helper Methods



- (void)updateOrderBoard {
    /*if ([[order orderItems] count] == 0) {
     [ibChalkboardLabel setText:@"No Items. Please order something!"];
     }
     else {
     [ibChalkboardLabel setText:[order orderDescription]];
     }
     */
    [self.collectionView reloadData];
}


#pragma mark - UICollectionView

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    NSInteger count= [_menu count]; //[categorySectionTitles count];
    return count;//[categorySectionTitles count];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    ProductCategory *cat=[_menu objectAtIndex:section];
    
   // if([_menu count]==1){
   //     cat.expanded=YES;
    //}
    
    if (!cat.expanded) {
        return 0;
    }
    else{
        
        return [cat.products count];
    }
}


- (UICollectionReusableView *)viewForHeaderInSection:(NSIndexPath *)indexPath{
    
    MenuHeaderView *cell = [self.collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView" forIndexPath:indexPath];
   
    ProductCategory *pc=[_menu objectAtIndex:indexPath.section];
    
    
    //bool hasImage=NO;
    
    /*NSString *filePath=nil;
    
    if(pc.pictureFile){
        filePath=[[AppDelegate getImagesPath] stringByAppendingPathComponent:pc.pictureFile];
        if([[NSFileManager defaultManager] fileExistsAtPath:filePath])
            hasImage=YES;
    }
    */
    cell.backgroundImage.image=nil;

    if(pc.pictureFile.length>0){
        
        NSString *filePath=[[AppDelegate getImagesPathForServer:_appDelegate.selectedStore.peerInfo.deviceID] stringByAppendingPathComponent:pc.pictureFile];
        if([[NSFileManager defaultManager] fileExistsAtPath:filePath])
        {
            dispatch_queue_t imageQueue = dispatch_queue_create("Image Queue",NULL);
            dispatch_async(imageQueue, ^{
                
                
                NSData *imageData=[NSData dataWithContentsOfFile:filePath];
                
                
                if(!imageData) return;
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    if(cell.backgroundImage){
                        [cell.backgroundImage setImage:[UIImage imageWithData:imageData]];
                    }
                    
                });
                
            });
        }
        else
        {
            
            
            
            // this is for BT connection but it may be very slow
            //TODO: implement compression
            //dispatch_async(dispatch_get_main_queue(), ^{
            NSString *serverPath=[NSString stringWithFormat:@"images/%@",pc.pictureFile];
            
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
    if(hasImage){
        
        //check if cached
        cell.backgroundImage.image=[[UIImage alloc] initWithContentsOfFile:filePath];
    }
    */
    
    if(pc.detail){
        //cell=[tableView dequeueReusableCellWithIdentifier:@"MenuSectionNoImageCell"];
        cell.descriptonLabel.text=pc.detail;
    }
    else {
        //cell=[tableView dequeueReusableCellWithIdentifier:@"MenuSectionTitleOnlyCell"];
        cell.descriptonLabel.text=nil;
    }
    
    cell.nameLabel.text =pc.name;
    
    
    
    if(!pc.expanded){
        
        
        [cell.expandImage setImage:[UIImage imageNamed:@"expand_arrow"] ];
        
        
    }
    else{
        
        [cell.expandImage setImage:[UIImage imageNamed:@"collapse_arrow"] ];
        
    }
    
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(expandGesture:)];
    
    [cell addGestureRecognizer:tap];
    cell.tag=indexPath.section;
    
       // cell.backgroundColor=[UIColor grayColor];
    return cell;
    
}


- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableview = nil;
    
    if (kind == UICollectionElementKindSectionHeader) {
        return [self viewForHeaderInSection:indexPath];
        /*
         MenuHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView" forIndexPath:indexPath];
         NSString *title = [[NSString alloc]initWithFormat:@"Recipe Group #%i", indexPath.section + 1];
         headerView.title.text = title;
         UIImage *headerImage = [UIImage imageNamed:@"header_banner.png"];
         headerView.backgroundImage.image = headerImage;
         headerView.backgroundColor=[UIColor whiteColor];
         reusableview = headerView;
         */
    }
    
    if (kind == UICollectionElementKindSectionFooter) {
        UICollectionReusableView *footerview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"FooterView" forIndexPath:indexPath];
        
        reusableview = footerview;
    }
    
    return reusableview;
}

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

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    ProductCategory *cat=[_menu objectAtIndex:indexPath.section];
    
    Product *product=[cat.products objectAtIndex:indexPath.row];//[[Product alloc] initWithDictionary:[sectionProducts objectAtIndex:indexPath.row]];

    if(_appDelegate.selectedStore.inventory.isEcommerce){
        
                return [self menuCell:indexPath withProduct:product];
    }
    else
        return [self menuNoSellCell:indexPath withProduct:product];

}

- (UICollectionViewCell *)menuNoSellCell:(NSIndexPath *)indexPath  withProduct:(Product *)product{
    
    BOOL hasImage=NO;
    NSString *filePath=nil;
    MenuCollectionCell *cell;
    NSString *identifier;// = @"MenuCollectionCell";
    if(product.pictureFile!=nil && product.pictureFile.length>0){
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

    
    //static NSString *identifier = @"MenuNoSellCollectionCell";
    
    cell = (MenuCollectionCell *)[self.collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    //ProductCategory *cat=[_menu objectAtIndex:indexPath.section];
    
    //Product *product=[cat.products objectAtIndex:indexPath.row];
    cell.nameLabel.text=product.name;
    cell.shortDescLabel.text=product.shortDesc;
    
    //cell.productImage.image=nil;
    [cell.loadingIndicator hidesWhenStopped];
    
    //if(!hasImage){
    if(hasImage){
        //[cell.productImage setImage:nil];
        //}
        
        //else{
        //cell.productImage.image=nil;
        //if(product.pictureFile.length>0){
        
        //if(product.imageLoadStatus==STATUS_LOAD_NONE){
        
        //product.imageLoadStatus=STATUS_LOADING;
        
        //[cell.loadingIndicator startAnimating];
        
        // NSString *filePath=[[AppDelegate getImagesPathForServer:_appDelegate.selectedStore.deviceID] stringByAppendingPathComponent:product.pictureFile];
        //if([[NSFileManager defaultManager] fileExistsAtPath:filePath])
        //{
        
        //dispatch_queue_t imageQueue = dispatch_queue_create("Image Queue",NULL);
        //dispatch_async(imageQueue, ^{
        
        
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSData *imageData=[NSData dataWithContentsOfFile:filePath];
            
           // product.imageLoadStatus=STATUS_LOADED;
            [cell.loadingIndicator stopAnimating];
            
            if(imageData) {
                [cell.productImage setImage:[UIImage imageWithData:imageData]];
                
            }
            else{
                [cell.productImage setImage:nil];
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
    return cell;
}
-(void)restartTimer{
    if(timer!=nil){
        [timer invalidate];
        timer=nil;
    }
    timer=[NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(reloadOnTimer:) userInfo:nil repeats:NO];
}
-(void)reloadOnTimer:(NSTimer *)timer{
    [self.collectionView reloadData];
}

- (UICollectionViewCell *)menuCell:(NSIndexPath *)indexPath withProduct:(Product *)product{
    BOOL hasImage=NO;
    NSString *filePath=nil;
    MenuCollectionCell *cell;
    NSString *identifier;// = @"MenuCollectionCell";
    
    if(product.pictureFile!=nil && product.pictureFile.length>0){
        hasImage=YES;
    }
    
    
    
    if(hasImage){
        if(isListView)
            identifier = @"MenuListCell";
        else
            identifier = @"MenuCollectionCell";
    }
    else{
        if(isListView)
            identifier = @"MenuNoImageListCell";
        else
            identifier = @"MenuNoImageCollectionCell";
            
    }
   
    
    cell = (MenuCollectionCell *)[self.collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
   
    [cell.loadingIndicator stopAnimating];
    
    if(product.pictureFile!=nil && product.pictureFile.length>0){
        filePath=[[AppDelegate getImagesPathForServer:_appDelegate.selectedStore.deviceID] stringByAppendingPathComponent:product.pictureFile];
        
        if([[NSFileManager defaultManager] fileExistsAtPath:filePath])
        {
            //this means that images is already downloaded in the background
            hasImage=YES;
            // product.imageLoadStatus=STATUS_LOADED;
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                NSData *imageData=[NSData dataWithContentsOfFile:filePath];
                
            dispatch_async(dispatch_get_main_queue(), ^{
                
                //imageData=[NSData dataWithContentsOfFile:filePath];
                
                //product.imageLoadStatus=STATUS_LOADED;
                //[cell.loadingIndicator stopAnimating];
                
                if(imageData) {
                    [cell.productImage setImage:[UIImage imageWithData:imageData]];
                    
                }
                else{
                    [cell.productImage setImage:nil];
                }
                
            });
            });

        }
        else{
            /*
             if(_appDelegate.selectedStore.isConnected){
             if(product.imageLoadStatus!=STATUS_LOADED){
             product.imageLoadStatus=STATUS_LOADED;
             NSString *serverPath=[NSString stringWithFormat:@"images/%@",product.pictureFile];
             //[self downloadViaBlueTooth:serverPath];
             [_connManager downloadViaBlueTooth:serverPath serverPeer:_appDelegate.selectedStore.peerInfo];
             }
             }
             
             else{
             */
            //if(product.imageLoadStatus!=STATUS_LOADED){
            // product.imageLoadStatus=STATUS_LOADED;
            //[product downloadImage:_appDelegate.selectedStore];
            
            
            //BOOL success=[_connManager downloadImageViaWWAN:product.pictureFile storeID:_appDelegate.selectedStore.storeID deviceID:_appDelegate.selectedStore.deviceID];
            
            if(rm){
                
                NetworkStatus netStatus = [rm.hostReachability currentReachabilityStatus];
                if(netStatus ==ReachableViaWiFi || netStatus ==ReachableViaWWAN){
                    NSString *url=[NSString stringWithFormat:@"%@%@/%@/%@",ServerURL,SKSImagePathWithStoreID,_appDelegate.selectedStore.storeID,product.pictureFile];
#ifdef DEBUG
                    NSLog(@"url=%@",url);
#endif
                    
                    NSURL *imageURL = [NSURL URLWithString:url];
                    
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                        NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            // Update the UI
                            
                            //self.imageView.image = [UIImage imageWithData:imageData];
                            if(cell){
                                cell.productImage.image=[UIImage imageWithData:imageData];
                                [imageData writeToFile:filePath atomically:YES];
                            }
                            //[[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_UPDATE_PRODUCT_IMAGE object:nil];
                            
                            
                        });
                    });
                    
                }
                else{
                    if(_appDelegate.selectedStore.isConnected){
                        //if(product.imageLoadStatus!=STATUS_LOADED){
                        //  product.imageLoadStatus=STATUS_LOADED;
                        NSString *serverPath=[NSString stringWithFormat:@"images/%@",product.pictureFile];
                        //[self downloadViaBlueTooth:serverPath];
                        [_connManager downloadViaBlueTooth:serverPath serverPeer:_appDelegate.selectedStore.peerInfo timeOutSec:60];
                        //}
                    }
                }
            }
            else{
                if(_appDelegate.selectedStore.isConnected){
                    //if(product.imageLoadStatus!=STATUS_LOADED){
                    //  product.imageLoadStatus=STATUS_LOADED;
                    NSString *serverPath=[NSString stringWithFormat:@"images/%@",product.pictureFile];
                    //[self downloadViaBlueTooth:serverPath];
                    [_connManager downloadViaBlueTooth:serverPath serverPeer:_appDelegate.selectedStore.peerInfo timeOutSec:60];
                    //}
                }
                
            }
            //}
            
            
            //}
        }
        
    }
    else{
        //product.imageLoadStatus=STATUS_LOADED;
    }
    
    cell.nameLabel.text=product.name;
    
    
    
    if (product.discount>0) {
        NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:[Product priceToString:(double)product.actualPrice/100 currency:_appDelegate.selectedStore.inventory.currencySymbol]];
        [attributeString addAttribute:NSStrikethroughStyleAttributeName
                                value:@2
                                range:NSMakeRange(0, [attributeString length])];
        cell.actualPriceLabel.attributedText=attributeString;
    }
    else{
        cell.actualPriceLabel.text=nil;
    }
    
    if(product.price>0){
    cell.priceLabel.text=[Product priceToString:(double)product.price/100 currency:_appDelegate.selectedStore.inventory.currencySymbol];//
    }
    else{
        cell.priceLabel.text=@"";
    }
    
    
    if(!product.allowOutOfStock)
        cell.quantityLabel.text=@"";
    else{
        if (product.instock>0)
            cell.quantityLabel.text=[NSString stringWithFormat:@"%lu Left",(unsigned long)product.instock];
        else
            cell.quantityLabel.text=@"SOLD OUT";
    }
    
    //[cell.loadingIndicator hidesWhenStopped];

    
  
//    if(hasImage){
//        //[cell.productImage setImage:nil];
//    //}
//    
//    //else{
//    //cell.productImage.image=nil;
//            //if(product.pictureFile.length>0){
//        
//        //if(product.imageLoadStatus==STATUS_LOAD_NONE){
//            
//            //product.imageLoadStatus=STATUS_LOADING;
//            
//            //[cell.loadingIndicator startAnimating];
//            
//           // NSString *filePath=[[AppDelegate getImagesPathForServer:_appDelegate.selectedStore.deviceID] stringByAppendingPathComponent:product.pictureFile];
//            //if([[NSFileManager defaultManager] fileExistsAtPath:filePath])
//            //{
//                
//                //dispatch_queue_t imageQueue = dispatch_queue_create("Image Queue",NULL);
//                //dispatch_async(imageQueue, ^{
//                    
//                    
//                
//                    
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        
//                        NSData *imageData=[NSData dataWithContentsOfFile:filePath];
//                        
//                        //product.imageLoadStatus=STATUS_LOADED;
//                        //[cell.loadingIndicator stopAnimating];
//                        
//                        if(imageData) {
//                            [cell.productImage setImage:[UIImage imageWithData:imageData]];
//                            
//                        }
//                        else{
//                            [cell.productImage setImage:nil];
//                        }
//                        
//                    });
//                    
//                //});
//            /*}
//            else
//            {
//                if(_appDelegate.selectedStore.isConnected){
//                   NSString *serverPath=[NSString stringWithFormat:@"images/%@",product.pictureFile];
//                    [self downloadViaBlueTooth:serverPath];
//                }
//                else{
//                    
//                    [cell.loadingIndicator stopAnimating];
//                    [cell.loadingIndicator setHidden:YES];
//                    product.imageLoadStatus=STATUS_LOADED;
//                   // [self restartTimer];
//                    
//                }
//            }*/
//        //}
//        /*else if(product.imageLoadStatus==STATUS_LOADING){//loading
//            [cell.loadingIndicator startAnimating];
//
//        }
//        else if(product.imageLoadStatus==STATUS_LOADED){//loaded
//            //[cell.loadingLabel setHidden:YES];
//            [cell.loadingIndicator stopAnimating];
//            [cell.loadingIndicator setHidden:YES];
//            
//            NSString *filePath=[[AppDelegate getImagesPathForServer:_appDelegate.selectedStore.deviceID] stringByAppendingPathComponent:product.pictureFile];
//            
//            //dispatch_queue_t imageQueue = dispatch_queue_create("Image Queue",NULL);
//           // dispatch_async(imageQueue, ^{
//                
//                
//            
//
//                
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    //if(cell.productImage){
//                    NSData *imageData=[NSData dataWithContentsOfFile:filePath];
//                    
//                    
//                    product.imageLoadStatus=STATUS_LOADED;
//                    [cell.loadingIndicator stopAnimating];
//                    
//                    if(imageData) {
//                        [cell.productImage setImage:[UIImage imageWithData:imageData]];
//                    }
//                    else{
//                        [cell.productImage setImage:nil];
//                    }
//                    //}
//                    //cell.productImage.layer.cornerRadius=cell.productImage.frame.size.width / 4;
//                    // cell.productImage.clipsToBounds = YES;
//                });
//                
//            //});
//            
//        }
//        */
//    //}
//    }
    /*
     cell.productImage.layer.cornerRadius=cell.productImage.frame.size.width / 4;
     cell.productImage.clipsToBounds = YES;
     
     UIImage *background = [self cellBackgroundForRowAtIndexPath:indexPath];
     
     
     UIImageView *cellBackgroundView = [[UIImageView alloc] initWithImage:background];
     cellBackgroundView.image = background;
     cell.backgroundView = cellBackgroundView;
     */
    //cell.backgroundColor=[UIColor whiteColor];
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath

{
    _selectedCategory=[_menu objectAtIndex:indexPath.section];
    
    _selectedProduct=[_selectedCategory.products objectAtIndex:indexPath.row];
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
        [self performSegueWithIdentifier:@"toProductViewController" sender:nil];
    //}
   // [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_SHOW_MENU_PRODUCT object:nil userInfo:@{@"product":_selectedProduct,@"category":_selectedCategory}];
}

- (UIImage *)cellBackgroundForRowAtIndexPath:(NSIndexPath *)indexPath{
    /*
     NSInteger rowCount = [self tableView:[self tableView] numberOfRowsInSection:indexPath.section];
     NSInteger rowIndex = indexPath.row;
     UIImage *background = nil;
     
     if (rowIndex == 0) {
     background = [UIImage imageNamed:@"cell_top.png"];
     } else if (rowIndex == rowCount - 1) {
     background = [UIImage imageNamed:@"cell_bottom.png"];
     } else {
     background = [UIImage imageNamed:@"cell_middle.png"];
     }
     */
    UIImage *background = nil;
    return background;
}


#pragma mark Table

/*
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
 
    return [_menu count];//[categorySectionTitles count];
 
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
 
    ProductCategory *cat=[_menu objectAtIndex:section];
    if([_menu count]==1){
        cat.expanded=YES;
    }
    
    if (!cat.expanded) {
        return 0;
    }
    else{
        
        return [cat.products count];
    }
    
}

-(UITableViewCell *)menuCell:(NSIndexPath *)indexPath{
    MenuCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"menu_cell" forIndexPath:indexPath];
    if(cell==nil){
        cell=[[MenuCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"menu_cell"];
    }
        ProductCategory *cat=[_menu objectAtIndex:indexPath.section];
    
    
    Product *product=[cat.products objectAtIndex:indexPath.row];
    
    cell.nameLabel.text=product.name;
   
    
    if (product.discount>0) {
        NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:[Product priceToString:(double)product.actualPrice/100 currency:_appDelegate.selectedStore.inventory.currencySymbol]];
        [attributeString addAttribute:NSStrikethroughStyleAttributeName
                                value:@2
                                range:NSMakeRange(0, [attributeString length])];
        cell.actualPriceLabel.attributedText=attributeString;
    }
    else{
        cell.actualPriceLabel.text=nil;
    }
    
    
        cell.priceLabel.text=[Product priceToString:(double)product.price/100 currency:_appDelegate.selectedStore.inventory.currencySymbol];//
    
    
    
    if(product.stock_unlimited)
        cell.quantityLabel.text=@"";
    else{
        if (product.instock>0)
            cell.quantityLabel.text=[NSString stringWithFormat:@"%lu Left",(unsigned long)product.instock];
        else
            cell.quantityLabel.text=@"SOLD OUT";
    }
    
    cell.productImage.image=nil;
    if(product.pictureFile.length>0){
        
        NSString *filePath=[[AppDelegate getImagesPathForServer:_appDelegate.selectedStore.peerInfo.deviceID] stringByAppendingPathComponent:product.pictureFile];
        if([[NSFileManager defaultManager] fileExistsAtPath:filePath])
        {
            dispatch_queue_t imageQueue = dispatch_queue_create("Image Queue",NULL);
            dispatch_async(imageQueue, ^{
                
                
                NSData *imageData=[NSData dataWithContentsOfFile:filePath];
                
                
                if(!imageData) return;
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    if(cell.productImage){
                        [cell.productImage setImage:[UIImage imageWithData:imageData]];
                    }
                    
                });
                
            });
        }
        else
        {
            
            
            
            // this is for BT connection but it may be very slow
            //TODO: implement compression
            //dispatch_async(dispatch_get_main_queue(), ^{
            NSString *serverPath=[NSString stringWithFormat:@"images/%@",product.pictureFile];
            
            BroadcastMessageAPI *message=[[BroadcastMessageAPI alloc] init];
            message.text=serverPath;
            message.isBroadcast=NO;
            message.toPeerInfo=_appDelegate.mcManager.serverPeerInfo;
            message.message_type=MSG_TYPE_REQUEST_FILE_DOWNLOAD;
            message.localCopy=NO;
            
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didFinishDownload:) name:product.pictureFile object:nil];
            
            NSDictionary *dict = @{KEY_SEND_MESSAGE: message
                                   };
            
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_HAS_DATA_TO_SEND
             
             
             
                                                                object:nil
                                                              userInfo:dict];
            
            
            
            //});
            
        }
        
        
    }
    
    // [cell.productImage setImage:[UIImage imageWithData:imageData]];
    cell.productImage.layer.cornerRadius=cell.productImage.frame.size.width / 4;
    cell.productImage.clipsToBounds = YES;
    
    UIImage *background = [self cellBackgroundForRowAtIndexPath:indexPath];
    
    UIImageView *cellBackgroundView = [[UIImageView alloc] initWithImage:background];
    cellBackgroundView.image = background;
    cell.backgroundView = cellBackgroundView;
    
    return cell;
}

-(UITableViewCell *)menuNoSellCell:(NSIndexPath *)indexPath{
    MenuNoSellCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"MenuNoSellCell" forIndexPath:indexPath];
    if(cell==nil){
        cell=[[MenuNoSellCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MenuNoSellCell"];
    }
    ProductCategory *cat=[_menu objectAtIndex:indexPath.section];
    Product *product=[cat.products objectAtIndex:indexPath.row];
    cell.nameLabel.text=product.name;
    cell.prodDetailLabel.text=product.detail;
    
    
    
    
    
    cell.productImage.image=nil;
    if(product.pictureFile.length>0){
        
        NSString *filePath=[[AppDelegate getImagesPathForServer:_appDelegate.selectedStore.peerInfo.deviceID] stringByAppendingPathComponent:product.pictureFile];
        if([[NSFileManager defaultManager] fileExistsAtPath:filePath])
        {
            dispatch_queue_t imageQueue = dispatch_queue_create("Image Queue",NULL);
            dispatch_async(imageQueue, ^{
                
                
                NSData *imageData=[NSData dataWithContentsOfFile:filePath];
                
                
                if(!imageData) return;
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    if(cell.productImage){
                        [cell.productImage setImage:[UIImage imageWithData:imageData]];
                    }
                    //cell.productImage.layer.cornerRadius=cell.productImage.frame.size.width / 4;
                    // cell.productImage.clipsToBounds = YES;
                });
                
            });
        }
        else
        {
            
            
            
            // this is for BT connection but it may be very slow
            //TODO: implement compression
            //dispatch_async(dispatch_get_main_queue(), ^{
            NSString *serverPath=[NSString stringWithFormat:@"images/%@",product.pictureFile];
            
            BroadcastMessageAPI *message=[[BroadcastMessageAPI alloc] init];
            message.text=serverPath;
            message.isBroadcast=NO;
            message.toPeerInfo=_appDelegate.mcManager.serverPeerInfo;
            message.message_type=MSG_TYPE_REQUEST_FILE_DOWNLOAD;
            message.localCopy=NO;
            
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didFinishDownload:) name:product.pictureFile object:nil];
            
            NSDictionary *dict = @{KEY_SEND_MESSAGE: message
                                   };
            
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_HAS_DATA_TO_SEND object:nil userInfo:dict];
            
        }
        
        
    }
    
    // [cell.productImage setImage:[UIImage imageWithData:imageData]];
    cell.productImage.layer.cornerRadius=cell.productImage.frame.size.width / 4;
    cell.productImage.clipsToBounds = YES;
    
    UIImage *background = [self cellBackgroundForRowAtIndexPath:indexPath];
    
    UIImageView *cellBackgroundView = [[UIImageView alloc] initWithImage:background];
    cellBackgroundView.image = background;
    cell.backgroundView = cellBackgroundView;
    
    return cell;
}





- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(_appDelegate.selectedStore.inventory.isEcommerce)
        return [self menuCell:indexPath];
    else
        return [self menuNoSellCell:indexPath];
    
    
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    _selectedCategory=[_menu objectAtIndex:indexPath.section];
    
    
    selectedProduct=[_selectedCategory.products objectAtIndex:indexPath.row];
    
   
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
        [self performSegueWithIdentifier:@"toProductViewController" sender:nil];
    
}

 -(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    ProductCategory *pc=[_menu objectAtIndex:section];
    
    
    
    bool hasImage=NO;
    NSString *filePath=nil;
    if(pc.pictureFile){
        filePath=[[AppDelegate getImagesPathForServer:_appDelegate.selectedStore.peerInfo.deviceID] stringByAppendingPathComponent:pc.pictureFile];
        if([[NSFileManager defaultManager] fileExistsAtPath:filePath])
            hasImage=YES;
    }
    
    if(hasImage){
        
        MenuSectionCell *cell=[tableView dequeueReusableCellWithIdentifier:@"MenuSectionCell"];
        
        //check if cached
        cell.sectionImageView.image=[[UIImage alloc] initWithContentsOfFile:filePath];
        cell.nameLabel.text =pc.name;//[categorySectionTitles objectAtIndex:section];
        
        
        if(!pc.expanded){
            //cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
            [cell.expandImage setImage:[UIImage imageNamed:@"expand_arrow"]];
            
            
        }
        else{
            [cell.expandImage setImage:[UIImage imageNamed:@"collapse_arrow"]] ;
            
        }
        
        
        //worked: [cell.expandButton addTarget:self action:@selector(expandAction:) forControlEvents:UIControlEventTouchUpInside];
        //cell.expandButton.tag=section;
        
        UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(expandGesture:)];
        
        [cell addGestureRecognizer:tap];
        cell.tag=section;
        
 
        cell.backgroundColor=[UIColor whiteColor];
        return cell;
        
        
    }
    else{
        MenuSectionNoImageCell *cell=[tableView dequeueReusableCellWithIdentifier:@"MenuSectionNoImageCell"];
        cell.nameLabel.text =pc.name;//[categorySectionTitles objectAtIndex:section];
 
        if(!pc.expanded){
            //cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
            [cell.expandImage setImage:[UIImage imageNamed:@"expand_arrow"]];
            
            
        }
        else{
            [cell.expandImage setImage:[UIImage imageNamed:@"collapse_arrow"]] ;
            
        }
 
        UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(expandGesture:)];
        
        [cell addGestureRecognizer:tap];
        cell.tag=section;
                cell.backgroundColor=[UIColor whiteColor];
        return cell;
        
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 60.0;
}
*/
#pragma mark - UIStoryboard methods

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    //this is only triggered using iphone
    if([segue.identifier isEqualToString:@"toProductViewController"]){
        ProductViewController* viewController = (ProductViewController*) segue.destinationViewController;
        viewController.selectedCategory=_selectedCategory;
        viewController.selectedInventory=_appDelegate.selectedStore.inventory;
        viewController.selectedProduct= _selectedProduct;
        
    }
    else if([segue.identifier isEqualToString:@"toProductOptionsViewController"]){
        ProductOptionsViewController* viewController = (ProductOptionsViewController*) segue.destinationViewController;
        //viewController.selectedCategory=_selectedCategory;
        //viewController.selectedInventory=_appDelegate.selectedStore.inventory;
        viewController.selectedProduct= _selectedProduct;
        viewController.delegate=self;
        
    }
    
    
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
-(void)didReceiveMenuSettingsWithNotification:(NSNotification *)notification{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        /*NSDictionary *menu=[_appDelegate.selectedStore.inventory_dict valueForKey:INVENTORY_KEY];
         categorySectionTitles=[menu valueForKey:NAME_KEY];
         [self.tableView reloadData];
         */
        [self reloadMenu];
        
        //check if items in cart then update
        /*
         CheckoutCart *checkoutCart=[CheckoutCart sharedInstance];
         
         [checkoutCart cleanCart:_appDelegate.selectedStore.peerInfo.deviceID isLive:_appDelegate.selectedStore.peerInfo.isLive withInventory:_appDelegate.selectedStore.inventory];
         */
        
    });
    
}
/*
-(void)loadBgPhoto{
    
    if(_appDelegate.mcManager.serverPeerInfo==nil)
        return;
    NSString *peer_bgphoto=[NSString stringWithFormat:@"%@%@.png",PREFIX_MYBGPHOTO, _appDelegate.selectedStore.peerInfo.deviceID];
    
    
    
    NSString *filePath=[[AppDelegate getImagesPathForServer:_appDelegate.selectedStore.peerInfo.deviceID] stringByAppendingPathComponent:peer_bgphoto];
    
    
    
    //check if cached
    if([[NSFileManager defaultManager] fileExistsAtPath:filePath]){
        
        self.wallImage.image=[[UIImage alloc] initWithContentsOfFile:filePath];
    }
}
 */
/*
-(void)didReceivePeerBgPhotoNotification:(NSNotification *)notification{
    [self loadBgPhoto];
}
*/

-(void)didReceiveUpdateProductImageNotification:(NSNotification *)notification{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.collectionView reloadData];
    });
}
//-(void)didFinishDownload:(NSNotification *)notification{
//    if([notification.userInfo objectForKey:@"resourceName"]!=nil){
//        [[NSNotificationCenter defaultCenter] removeObserver:self name:[notification.userInfo valueForKey:@"resourceName"] object:nil];
//    }
//    /*if(timerWaitBeforReload==nil)
//     timerWaitBeforReload=[NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(reloadImageOntimer) userInfo:nil repeats:NO];
//     else{
//     if([timerWaitBeforReload isValid]){
//     [timerWaitBeforReload invalidate];
//     timerWaitBeforReload=[NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(reloadImageOntimer) userInfo:nil repeats:NO];
//     }
//     }
//     */
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [self.collectionView reloadData];
//    });
//    
//    
//}
-(void)reloadImageOntimer{
    [self.collectionView reloadData];
}


#pragma mark Banner delegates

- (void)bannerViewDidLoadAd:(ADBannerView *)banner

{
    
    if (!bannerIsVisible)
        
    {
        
        [UIView beginAnimations:@"animateAdBannerOn" context:NULL];
        
        // Assumes the banner view is just off the bottom of the screen.
        
        banner.frame = CGRectOffset(banner.frame, 0, -banner.frame.size.height);
        
        [UIView commitAnimations];
        
        bannerIsVisible = YES;
        
    }
    
}

-(void)expandAction:(id)sender{
    UIButton *button=(UIButton *)sender;
    NSUInteger section=button.tag;
    ProductCategory *pc=[_menu objectAtIndex:section];//[_sortedCategories objectAtIndex:section];
    
    if(pc.expanded){
        pc.expanded=NO;
    }
    else{
        pc.expanded=YES;
    }
    [self.collectionView reloadData];
}

-(void)expandGesture:(UITapGestureRecognizer *)sender{
    //UIButton *button=(UIButton *)sender;
    
    NSUInteger section=sender.view.tag;//button.tag;
    ProductCategory *pc=[_menu objectAtIndex:section];//[_sortedCategories objectAtIndex:section];
    
    if(pc.expanded){
        pc.expanded=NO;
    }
    else{
        pc.expanded=YES;
    }
    [self.collectionView reloadData];
}

-(void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error{
    if (bannerIsVisible)
        
    {
        
        [UIView beginAnimations:@"animateAdBannerOff" context:NULL];
        
        // Assumes the banner view is placed at the bottom of the screen.
        
        banner.frame = CGRectOffset(banner.frame, 0, banner.frame.size.height);
        
        [UIView commitAnimations];
        
        bannerIsVisible = NO;
        
    }
}

-(void)toggleView{
    /*
    _refenceToParentViewController.nextViewName=NOTIFY_SHOW_MENU_TABLE;
    [self.navigationController popViewControllerAnimated:YES];
     */
    if(isListView)
        isListView=NO;
    else
        isListView=YES;
    
    [self.collectionView reloadData];
    
}


- (void)showBrowserAction {
    /*
    ConnectionsViewController* settingsController = (ConnectionsViewController*) [_appDelegate.storyBoard instantiateViewControllerWithIdentifier:@"ConnectionsViewController"];
    UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:settingsController];
    
    [self presentViewController:nav animated:YES completion:nil];
    */
    [self dismissViewControllerAnimated:YES completion:nil];
    //[self performSegueWithIdentifier:NOTIFY_SHOW_SETTINGS sender:self];
}


- (IBAction)showSettngsAction:(id)sender {
    
    
    
    AppSettingsViewController* settingsController = (AppSettingsViewController*) [ApplicationDelegate.storyBoard instantiateViewControllerWithIdentifier:@"AppSettingsViewController"];
    UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:settingsController];
    
    
    
    [self presentViewController:nav animated:YES completion:nil];
    
    //[self performSegueWithIdentifier:NOTIFY_SHOW_SETTINGS sender:self];
}

- (IBAction)searchAction:(id)sender{
    
    SearchMenuViewController *vc=[_appDelegate.storyBoard instantiateViewControllerWithIdentifier:@"SearchMenuViewController"];
    vc.delegate=self;
    //vc.searchText=_searchTextField.text;
    vc.selectedInventory=_appDelegate.selectedStore.inventory;
    UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:vc];
    
    if(_appDelegate.isIpad){
        //if(_popOver==nil){
        
        
        _popOver=[[UIPopoverController alloc] initWithContentViewController:nav];
        //_chatPopover.popoverContentSize=CGSizeMake(self.view.frame.size.width/2, self.view.frame.size.height);
        _popOver.popoverContentSize=CGSizeMake(200.0, self.view.frame.size.height);
        [_popOver presentPopoverFromBarButtonItem:_menuButtonItem permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        //[_popOver presentPopoverFromRect:CGRectMake(_searchTextField.frame.origin.x, _searchTextField.frame.origin.y, _searchTextField.frame.size.width, _searchTextField.frame.size.height) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        /*}
         else{
         [_popOver dismissPopoverAnimated:YES];
         _popOver=nil;
         }
         */
    }
    else{
        //[self performSegueWithIdentifier:@"toMenuSearchViewController" sender:self];
        [self presentViewController:nav animated:YES completion:nil];
    }
}

-(IBAction)barcodeAction:(id)sender{
    
    BCScannerViewController *vc=[_appDelegate.storyBoard instantiateViewControllerWithIdentifier:@"BCScannerViewController"];
    vc.delegate=self;
    
    
    
    
    UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:vc];
    
    if(_appDelegate.isIpad){
        //if(_popOver==nil){
        
        
        _popOver=[[UIPopoverController alloc] initWithContentViewController:nav];
        //_chatPopover.popoverContentSize=CGSizeMake(self.view.frame.size.width/2, self.view.frame.size.height);
        _popOver.popoverContentSize=CGSizeMake(320.0, self.view.frame.size.height);
        [_popOver presentPopoverFromBarButtonItem:_menuButtonItem permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        //[_popOver presentPopoverFromRect:CGRectMake(_barcodeButton.frame.origin.x, _barcodeButton.frame.origin.y, _barcodeButton.frame.size.width, _barcodeButton.frame.size.height) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        /*}
         else{
         [_popOver dismissPopoverAnimated:YES];
         _popOver=nil;
         }
         */
    }
    else{
        [self presentViewController:nav animated:YES completion:nil];
    }
}

-(void)showSelectOne:(NSArray *)items{
    
    SelectOneViewController *vc=[_appDelegate.storyBoard instantiateViewControllerWithIdentifier:@"SelectOneViewController"];
    vc.delegate=self;
    
    
    
    
    UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:vc];
    
    if(_appDelegate.isIpad){
        //if(_popOver==nil){
        
        
        _popOver=[[UIPopoverController alloc] initWithContentViewController:nav];
        //_chatPopover.popoverContentSize=CGSizeMake(self.view.frame.size.width/2, self.view.frame.size.height);
        _popOver.popoverContentSize=CGSizeMake(320.0, self.view.frame.size.height);
        [_popOver presentPopoverFromBarButtonItem:_menuButtonItem permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        //[_popOver presentPopoverFromRect:CGRectMake(_barcodeButton.frame.origin.x, _barcodeButton.frame.origin.y, _barcodeButton.frame.size.width, _barcodeButton.frame.size.height) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        /*}
         else{
         [_popOver dismissPopoverAnimated:YES];
         _popOver=nil;
         }
         */
    }
    else{
        [self presentViewController:nav animated:YES completion:nil];
    }
}

/*
 -(void)searchWithKeywords:(NSString *)keywords{
 //NSPredicate *p=[NSPredicate predicateWithFormat:@"ANY name CONTAINS[c] %@",search];
 NSArray *results=[_selectedInventory searchProducts:keywords];
 //return results;
 
 }
 */

#pragma mark -
#pragma mark Barcode
/*- (IBAction)barcodeAction:(id)sender {
 
 [self showBarcodeScanner];
 
 }
 */
-(void)barcodeController:(BCScannerViewController *)controller didScanWithBarcode:(NSString *)barcode{
    
    if(_appDelegate.appConfig.barcodeAutoClose){
        
        [controller dismissViewControllerAnimated:YES completion:nil];//^{
    }
    
    NSArray *results=[_appDelegate.selectedStore.inventory searchProductsWithBarcode:barcode];
    NSUInteger count=[results count];
    if(count>0){
        if(count==1){
            _selectedProduct=[results firstObject];
            if(_appDelegate.appConfig.barcodeAutoAddToCart) {
                //create an orderitem from product the add to cart
                //OrderItem *orderItem=[[OrderItem alloc] initWithProduct:_selectedProduct isLive:_appDelegate.appConfig.isLive withStoreID:_appDelegate.appConfig.device_id];
                
                OrderItem *orderItem=[[OrderItem alloc] initWithProduct:_selectedProduct isLive:_appDelegate.selectedStore.isLive withStoreID:_appDelegate.selectedStore.peerInfo.deviceID];
                /*
                if(_checkoutCart==nil)
                    _checkoutCart=[CheckoutCart sharedInstance];
                [_checkoutCart addItem:orderItem];
                 */
                [_appDelegate addToCart:orderItem product:_selectedProduct];
            }
            else{
                [self performSegueWithIdentifier:@"toProductViewController" sender:nil];
            }
        }
        else{ //>1
            //TODO: display selection
            [AppDelegate toast:@"Barcode is not unique!" duration:1.0];
        }
    }
    else{
        [AppDelegate toast:@"Item not found!" duration:1.0];
    }
    
    //[self.view endEditing:YES];
    
    //}];
}



-(void)searchMenuViewControllerItemSelected:(SearchMenuViewController *)controller item:(Product *)item{
    _selectedProduct=item;
    
    
    [controller dismissViewControllerAnimated:YES completion:^{
        [self.view endEditing:YES];
        [self performSegueWithIdentifier:@"toProductViewController" sender:nil];
    }];
    
}

-(void)searchMenuViewControllerWasCancelled:(SearchMenuViewController *)controller{
    [controller dismissViewControllerAnimated:YES completion:^{[self.view endEditing:YES];}];
}

-(void)selectOneViewControllerItemSelected:(SelectOneViewController *)controller item:(Product *)item{
    [controller dismissViewControllerAnimated:YES completion:^{
        [self.view endEditing:YES];
        [self performSegueWithIdentifier:@"toProductViewController" sender:nil];
    }];
}

- (IBAction)selectViewAction:(id)sender {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_SHOW_MENU_TABLE object:nil];
}

-(void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{
    if(buttonIndex<0)
        return;
    NSString *buttonTitle=[actionSheet buttonTitleAtIndex:buttonIndex];
    
    if([buttonTitle isEqualToString:TITLE_SETTINGS]){
        [self showSettngsAction:nil];
    }
    //else if([buttonTitle isEqualToString:TITLE_LOCK]){
    //    [self lockButtonTapped:nil];
    //}
    else if([buttonTitle isEqualToString:TITLE_SEARCH]){
        [self searchAction:nil];
    }
    else if([buttonTitle isEqualToString:TITLE_BARCODE]){
        [self barcodeAction:nil];
    }
    else if([buttonTitle isEqualToString:TITLE_LISTVIEW]){
        
        [self toggleView];
        
    }
    else if([buttonTitle isEqualToString:TITLE_THUMBVIEW]){
        [self toggleView];
    }
    else if([buttonTitle isEqualToString:TITLE_DISCONNECT]){
        [self forgetThisKiosk];
    }
    
}

-(void)forgetThisKiosk{
    _appDelegate.selectedStore.autoConnect=NO;
    [_appDelegate.mcManager.session disconnect];
    [self backButtonItemTapped];

}

-(void)showMenuActionSheet{
    NSString *titleString=[_menuActionSheet buttonTitleAtIndex:3];
    if(isListView){
        if(![titleString isEqualToString:TITLE_THUMBVIEW]){
            _menuActionSheet=[[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:TITLE_SEARCH,TITLE_BARCODE,TITLE_THUMBVIEW,TITLE_DISCONNECT, nil];
        }
    }
    else{
        if(![titleString isEqualToString:TITLE_LISTVIEW]){
            _menuActionSheet=[[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:TITLE_SEARCH,TITLE_BARCODE,TITLE_LISTVIEW,TITLE_DISCONNECT, nil];
        }
    }
    
    [_menuActionSheet showFromBarButtonItem:_menuButtonItem animated:YES];
    
}

-(void)backButtonItemTapped{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

-(void)productOptionDone{
     [self performSegueWithIdentifier:@"toProductViewController" sender:nil];
}


@end
