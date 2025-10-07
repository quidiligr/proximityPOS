//
//  IODViewController.m
//  iOSDiner
//
//  Created by Romulo Quidilig on 3/19/15.
//  Copyright (c) 2015 Sharecle Inc. All rights reserved.
//

#import "OrderMenuTableViewController.h"

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
#import "MenuCell.h"
//#import "MenuNoImageCell.h"
//#import "MenuNoImageNoQuantityCell.h"
//#import "MenuNoQuantityCell.h"
#import "MenuNoSellCell.h"
//#import "MenuNoSellNoImageCell.h"

#import "MenuSectionCell.h"
#import "MenuSectionNoImageCell.h"
#import "ProductViewController.h"

#import "AppSettingsViewController.h"

#import "defs.h"



@implementation OrderMenuTableViewController
{
    NSArray *categorySectionTitles;
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
    
    //UINavigationController *navProduct;
    /*
    UIBarButtonItem *settingsButtonItem;
    UIBarButtonItem *_searchButtonItem;
    UIBarButtonItem *_barcodeButtonItem;
    */
    
    
    UIActionSheet *_menuActionSheet;
    //UIBarButtonItem *_menuButtonItem;
    bool isIpad;

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
    _appDelegate = ApplicationDelegate;//(AppDelegate *)[[UIApplication sharedApplication] delegate];
    

    //settingsButtonItem=[self createBarButtonItem:@"Settings" withImageName:@"settings" withAction:@selector(showSettngsAction:)];
    /*
    settingsButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"Settings" style:UIBarButtonItemStyleBordered target:self action:@selector(showSettngsAction:)];
    
    _searchButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"Search" style:UIBarButtonItemStyleBordered target:self action:@selector(searchAction:)];
    
    _barcodeButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"Barcode" style:UIBarButtonItemStyleBordered target:self action:@selector(barcodeAction:)];
    
    
    self.navigationItem.rightBarButtonItems=@[settingsButtonItem];
    self.navigationItem.leftBarButtonItems=@[_searchButtonItem,_barcodeButtonItem];
    
     */
    //_menuButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"Menu" style:UIBarButtonItemStyleBordered target:self action:@selector(showMenuActionSheet)];
    
    _searchButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"Search" style:UIBarButtonItemStyleBordered target:self action:@selector(searchAction:)];
    self.navigationItem.leftBarButtonItems=@[_searchButtonItem,_barcodeButtonItem];
    
    _menuButtonItem=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Menu"] style:UIBarButtonItemStyleBordered target:self action:@selector(showMenuActionSheet)];
    self.navigationItem.rightBarButtonItem=_menuButtonItem;
    
    //_menuActionSheet=[[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:TITLE_SEARCH,TITLE_BARCODE,TITLE_SETTINGS,TITLE_THUMBVIEW,TITLE_LOCK, nil];
    _menuActionSheet=[[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:TITLE_SEARCH,TITLE_BARCODE,TITLE_THUMBVIEW,TITLE_LOCK, nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didReceiveMenuWithNotification:)
                                                 name:NOTIFY_RECEIVED_MENU
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didReceiveMenuWithNotification:)
                                                 name:NOTIFY_RECEIVED_MENU_UPDATE
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didReceiveUpdateProductImageNotification:)
                                                 name:NOTIFY_UPDATE_PRODUCT_IMAGE
                                               object:nil];
    
    
    /* [[NSNotificationCenter defaultCenter] addObserver:self
     selector:@selector(didReceivePeerBgPhotoNotification:)
     name:NOTIFY_RECEIVED_PEER_BGPHOTO
     object:nil];*/
    
   /* [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didFinishDownload:)
                                                 name:NOTIFY_DOWNLOAD_DONE
                                               object:nil];
    
    */
    
    
    
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    //self.parentViewController.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"common_bg"]];
    //self.tableView.backgroundColor = [UIColor clearColor];
    UIEdgeInsets inset = UIEdgeInsetsMake(5, 0, 0, 0);
    self.tableView.contentInset = inset;
    
    
    
    
    //[self loadBgPhoto];
    //self.title=@"Menu";//_appDelegate.selectedStore.peerInfo.peerID.displayName;
    self.title=_appDelegate.selectedStore.storeName;
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
    [self reloadMenu];
}



/*- (void)viewWillAppear:(BOOL)animated
 {
 [super viewWillAppear:animated];
 }
 */
-(void)reloadMenu{
    //NSArray *inventory_array=[_appDelegate.selectedStore.inventory_dict valueForKey:inventoryKey];
    
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
    NSArray *pcs=_appDelegate.selectedStore.inventory.categories;
    
    
    
    for(ProductCategory *pc in pcs){
        
        pc.products=[_appDelegate.selectedStore.inventory allProductsWithCategoryID:pc.categoryID sorted:YES];
        if([_menu count]==1 || [_appDelegate.selectedStore.inventory.products count]<50){
            pc.expanded=YES;
        }
        [_menu addObject:pc];
    }
    
    
    //categorySectionTitles=[_inventory valueForKey:NAME_KEY]; //[menu valueForKey:NAME_KEY];
    //dispatch_async(dispatch_get_main_queue(), ^{
    [self.tableView reloadData];
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
    if(!_appDelegate.selectedStore.isConnected){
        _lblStatus.text=@"Connecting. Please wait...";
    }
    
    if([_menu count]==0){
        
        BroadcastMessageAPI *m=[[BroadcastMessageAPI alloc] init];
        //message.text=serverPath;
        m.message_type=MSG_TYPE_REQUEST_SERVERINFO;
        m.toPeerInfo=_appDelegate.selectedStore.peerInfo;//_appDelegate.mcManager.serverPeerInfo;
        m.isBroadcast=NO;
        
        m.localCopy=NO;
        
        
        NSDictionary *dict = @{KEY_SEND_MESSAGE: m
                               };
        
        
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_HAS_DATA_TO_SEND
                                                            object:nil
                                                          userInfo:dict];
        //[AppDelegate toast:@"Loading" duration:3];
    }
    
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
    NSDictionary *cat=[[_appDelegate.selectedStore.inventory_dict valueForKey:@"products"] objectAtIndex:indexPath.section];
    
    NSArray *sectionProducts = [cat objectForKey:PRODUCTS_KEY];
    
    // NSString *product = [sectionProducts objectAtIndex:indexPath.row];
    OrderItem *currentItem=[sectionProducts objectAtIndex:indexPath.row];
    [order removeItemFromOrder:currentItem];
    [self updateOrderBoard];
    [self updateCurrentInventoryItem];
    [self updateInventoryButtons];
    
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
    NSDictionary *cat=[[_appDelegate.selectedStore.inventory_dict valueForKey:@"products"] objectAtIndex:indexPath.section];//[_appDelegate.selectedStore.inventory_dict objectAtIndex:indexPath.section];
    
    NSArray *sectionProducts = [cat objectForKey:PRODUCTS_KEY];
    // NSString *product = [sectionProducts objectAtIndex:indexPath.row];
    OrderItem *currentItem=[sectionProducts objectAtIndex:indexPath.row];
    
    
    
    [order addItemToOrder:currentItem];
    [self updateOrderBoard];
    //[self updateCurrentInventoryItem];
    //[self updateInventoryButtons];
    
    //UILabel* addItemDisplay = [[UILabel alloc] initWithFrame:[ibCurrentItemImageView frame]];
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
}


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

#pragma mark - Helper Methods

- (void)updateCurrentInventoryItem {
    /* if (currentItemIndex >= 0 && currentItemIndex < [[self inventory] count]) {
     OrderItem* currentItem = [[self inventory] objectAtIndex:currentItemIndex];
     [ibCurrentItemLabel setText:[currentItem name]];
     
     // [ibCurrentItemImageView setImage:[UIImage imageNamed:[currentItem pictureFile]]];
     
     dispatch_async(dispatch_get_main_queue(), ^{
     NSString *url=[NSString stringWithFormat:@"%@images/%@",_appDelegate.selectedStore.peerInfo.homeUrl,[currentItem pictureFile]];
     NSURL *pictureUrl=[NSURL URLWithString:url];
     NSData *data=[[NSData alloc] initWithContentsOfURL:pictureUrl];
     [ibCurrentItemImageView setImage:[UIImage imageWithData:data]];
     });
     
     
     
     }
     */
}

- (void)updateInventoryButtons {
    /*  if (![self inventory] || [[self inventory] count] == 0) {
     [ibAddItemButton setEnabled:NO];
     [ibRemoveItemButton setEnabled:NO];
     [ibNextItemButton setEnabled:NO];
     [ibPreviousItemButton setEnabled:NO];
     [ibTotalOrderButton setEnabled:NO];
     }
     else {
     if (currentItemIndex <= 0) {
     [ibPreviousItemButton setEnabled:NO];
     }
     else {
     [ibPreviousItemButton setEnabled:YES];
     }
     
     if (currentItemIndex >= [[self inventory] count]-1) {
     [ibNextItemButton setEnabled:NO];
     }
     else {
     [ibNextItemButton setEnabled:YES];
     }
     
     OrderItem* currentItem = [[self inventory] objectAtIndex:currentItemIndex];
     if (currentItem) {
     [ibAddItemButton setEnabled:YES];
     }
     else {
     [ibAddItemButton setEnabled:NO];
     }
     
     if (![[self order] findKeyForOrderItem:currentItem]) {
     [ibRemoveItemButton setEnabled:NO];
     }
     else {
     [ibRemoveItemButton setEnabled:YES];
     }
     
     if ([[order orderItems] count] == 0) {
     [ibTotalOrderButton setEnabled:NO];
     }
     else {
     [ibTotalOrderButton setEnabled:YES];
     }
     }
     */
}

- (void)updateOrderBoard {
    /*if ([[order orderItems] count] == 0) {
     [ibChalkboardLabel setText:@"No Items. Please order something!"];
     }
     else {
     [ibChalkboardLabel setText:[order orderDescription]];
     }
     */
    [self.tableView reloadData];
}
/*
 - (IBAction)actionSubmitOrder:(id)sender {
 [self.delegate orderViewControllerDidFinish:self];
 }
 - (IBAction)cancelOrder:(id)sender {
 //[self dismissViewControllerAnimated:YES completion:nil];
 [self.delegate orderViewControllerWasCancelled:self];
 }
 */

#pragma mark Table
/*
 - (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
 {
 // Return the number of sections.
 
 // if([tableView isEqual:self.tableView])
 return [categorySectionTitles count];
 //else
 //return 0;
 //  return _appDelegate.messages.count;
 }
 */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    //if([tableView isEqual:self.tableView])
    return [_menu count];//[categorySectionTitles count];
    //else
    //  return 0;
}
/*
 - (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
 {
 
 
 
 ProductCategory *cat=[_inventory objectAtIndex:section];
 
 return [cat.products count];//[sectionProducts count];
 
 }
 */
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
        /*NSArray *sectionItems = [_selectedInventory allProductsWithCategoryID:cat.categoryID sorted:YES];
         return [sectionItems count];
         */
        //[_inventory.pr]
        return [cat.products count];
    }
    
}
/*
 - (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
 {
 if([tableView isEqual:self.tableView])
 return [categorySectionTitles objectAtIndex:section];
 else
 return nil;//@"Order";
 }
 */
/*
 -(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
 UIView *view=[[UIView alloc] init];
 if(
 UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.view.bounds.size.width, 48.0f)];
 UILabel *title=[[UILabel alloc] initWithFrame:CGRectMake(50.0f, 0.0f, self.view.bounds.size.width-48, 20)];
 [title setText:[categorySectionTitles objectAtIndex:section]];
 [view addSubview:title];
 }
 */
/*
 -(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
 return [_inventoryModel.products count];
 }
 */

-(UITableViewCell *)menuCell:(NSIndexPath *)indexPath withProduct:(Product *)product{
    MenuCell *cell;//
    BOOL hasImage=NO;
    NSString *identifier;
    //BOOL haQuantity=NO;
    if( product.pictureFile!=nil && product.pictureFile.length>0)
        hasImage=YES;
    if(hasImage){
        if(product.stock_unlimited){
            identifier=@"MenuNoQuantityCell";
        }
        else{
            identifier=@"MenuCell";
        }
    }
    else{
        if(product.stock_unlimited){
            identifier=@"MenuNoImageNoQuantityCell";
        }
        else{
            identifier=@"MenuNoImageCell";
        }
    }
    
    cell= [self.tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    if(cell==nil)
        cell=[[MenuCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];

    /*
    ProductCategory *cat=[_menu objectAtIndex:indexPath.section];
    Product *product=[cat.products objectAtIndex:indexPath.row];
    */
    
    cell.nameLabel.text=product.name;
    //cell.prodDetailLabel.text=product.detail;
    
    if (product.discount>0) {
        NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:[Product priceToString:(double)product.actualPrice/100 currency:_appDelegate.selectedStore.inventory.currencySymbol]];
        [attributeString addAttribute:NSStrikethroughStyleAttributeName
                                value:@2
                                range:NSMakeRange(0, [attributeString length])];
        cell.actualPriceLabel.attributedText=attributeString;//[Product priceToString:(double)product.actualPrice/100]; //[NSString stringWithFormat:@"%.2f",(double)product.price/100];
        
        //cell.priceLabel.text=[Product priceToString:(double)product.price/100];//[NSString stringWithFormat:@"%.2f %@%% off",(double)product.price/100,product.discountToString];
    }
    else{
        cell.actualPriceLabel.text=nil;
    }
    
    //if(product.price==0){
    //    cell.priceLabel.text=@"FREE";
    //}
    ////else{
    cell.priceLabel.text=[Product priceToString:(double)product.price/100 currency:_appDelegate.selectedStore.inventory.currencySymbol];//cell.priceLabel.text=[NSString stringWithFormat:@"%.2f",(double)product.price/100];
    
    //}
    
    
    
    if(product.stock_unlimited)
        cell.quantityLabel.text=@"";
    else{
        if (product.instock>0)
            cell.quantityLabel.text=[NSString stringWithFormat:@"%lu Left",(unsigned long)product.instock];
        else
            cell.quantityLabel.text=@"SOLD OUT";
    }
    
    cell.productImage.image=nil;
    
    if(hasImage){
        
        if(product.imageLoadStatus==0){
            
            
            
            //product.imageLoadStatus=1;
            
            product.imageLoadStatus=1;
            //[cell.loadingLabel setHidden:NO];
            [cell.loadingIndicator startAnimating];
            NSString *filePath=[[AppDelegate getImagesPathForServer:_appDelegate.selectedStore.storeId] stringByAppendingPathComponent:product.pictureFile];
            
            if([[NSFileManager defaultManager] fileExistsAtPath:filePath])
            {
                //[cell.loadingLabel setHidden:NO];
                
                dispatch_queue_t imageQueue = dispatch_queue_create("Image Queue",NULL);
                dispatch_async(imageQueue, ^{
                    
                    
                    NSData *imageData=[NSData dataWithContentsOfFile:filePath];
                    
                    
                    if(!imageData) return;
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        //if(cell.productImage){
                        
                        product.imageLoadStatus=2; //loaded
                        [cell.productImage setImage:[UIImage imageWithData:imageData]];
                        //[cell.loadingLabel setHidden:YES];
                        [cell.loadingIndicator stopAnimating];

                        //}
                        //cell.productImage.layer.cornerRadius=cell.productImage.frame.size.width / 4;
                        // cell.productImage.clipsToBounds = YES;
                    });
                    
                });
            }
            else
            {
                
                
                //product.imageLoadStatus=1; //loading/fetch
                //[cell.loadingLabel setHidden:NO];
                // this is for BT connection but it may be very slow
                //TODO: implement compression
                //dispatch_async(dispatch_get_main_queue(), ^{
                NSString *serverPath=[NSString stringWithFormat:@"images/%@",product.pictureFile];
                
                BroadcastMessageAPI *message=[[BroadcastMessageAPI alloc] init];
                message.text=serverPath;
                message.isBroadcast=NO;
                message.toPeerInfo=_appDelegate.selectedStore.peerInfo;
                message.message_type=MSG_TYPE_REQUEST_FILE_DOWNLOAD;
                message.localCopy=NO;
                
                //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didFinishDownload:) name:product.pictureFile object:nil];
                
                NSDictionary *dict = @{KEY_SEND_MESSAGE: message
                                       };
                
                [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_HAS_DATA_TO_SEND
                 
                 
                 
                                                                    object:nil
                                                                  userInfo:dict];
                
            }
            
        }
        else if(product.imageLoadStatus==1){//loading
            //[cell.loadingLabel setHidden:NO];
            [cell.loadingIndicator startAnimating];

        }
        else if(product.imageLoadStatus==2){//loaded
            //[cell.loadingLabel setHidden:YES];
            //[cell.loadingLabel setHidden:NO];
            [cell.loadingIndicator stopAnimating];

            NSString *filePath=[[AppDelegate getImagesPathForServer:_appDelegate.selectedStore.peerInfo.deviceID] stringByAppendingPathComponent:product.pictureFile];
            
            dispatch_queue_t imageQueue = dispatch_queue_create("Image Queue",NULL);
            dispatch_async(imageQueue, ^{
                
                
                NSData *imageData=[NSData dataWithContentsOfFile:filePath];
                
                
                if(!imageData) return;
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    //if(cell.productImage){
                    
                    product.imageLoadStatus=2; //loaded
                    [cell.productImage setImage:[UIImage imageWithData:imageData]];
                    [cell.loadingIndicator stopAnimating];
                    //}
                    //cell.productImage.layer.cornerRadius=cell.productImage.frame.size.width / 4;
                    // cell.productImage.clipsToBounds = YES;
                });
                
            });
            
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

//-(UITableViewCell *)menuNoQuantityCell:(NSIndexPath *)indexPath withProduct:(Product *)product{
//    MenuNoQuantityCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"MenuNoQuantityCell" forIndexPath:indexPath];
//    if(cell==nil){
//        cell=[[MenuNoQuantityCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MenuNoQuantityCell"];
//    }
//    /*
//     ProductCategory *cat=[_menu objectAtIndex:indexPath.section];
//     Product *product=[cat.products objectAtIndex:indexPath.row];
//     */
//    cell.nameLabel.text=product.name;
//    //cell.prodDetailLabel.text=product.detail;
//    
//    if (product.discount>0) {
//        NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:[Product priceToString:(double)product.actualPrice/100 currency:_appDelegate.selectedStore.inventory.currencySymbol]];
//        [attributeString addAttribute:NSStrikethroughStyleAttributeName
//                                value:@2
//                                range:NSMakeRange(0, [attributeString length])];
//        cell.actualPriceLabel.attributedText=attributeString;//[Product priceToString:(double)product.actualPrice/100]; //[NSString stringWithFormat:@"%.2f",(double)product.price/100];
//        
//        //cell.priceLabel.text=[Product priceToString:(double)product.price/100];//[NSString stringWithFormat:@"%.2f %@%% off",(double)product.price/100,product.discountToString];
//    }
//    else{
//        cell.actualPriceLabel.text=nil;
//    }
//    
//    //if(product.price==0){
//    //    cell.priceLabel.text=@"FREE";
//    //}
//    ////else{
//    cell.priceLabel.text=[Product priceToString:(double)product.price/100 currency:_appDelegate.selectedStore.inventory.currencySymbol];//cell.priceLabel.text=[NSString stringWithFormat:@"%.2f",(double)product.price/100];
//    
//    //}
//    
//    
//    /*
//    if(product.stock_unlimited)
//        cell.quantityLabel.text=@"";
//    else{
//        if (product.instock>0)
//            cell.quantityLabel.text=[NSString stringWithFormat:@"%lu Left",(unsigned long)product.instock];
//        else
//            cell.quantityLabel.text=@"SOLD OUT";
//    }
//    */
//    cell.productImage.image=nil;
//    
//    if(product.pictureFile.length>0){
//        
//        if(product.imageLoadStatus==0){
//        
//
//            
//            //product.imageLoadStatus=1;
//        
//            product.imageLoadStatus=1;
//            [cell.loadingLabel setHidden:NO];
//            NSString *filePath=[[AppDelegate getImagesPathForServer:_appDelegate.selectedStore.peerInfo.deviceID] stringByAppendingPathComponent:product.pictureFile];
//            
//            if([[NSFileManager defaultManager] fileExistsAtPath:filePath])
//            {
//                [cell.loadingLabel setHidden:NO];
//
//                dispatch_queue_t imageQueue = dispatch_queue_create("Image Queue",NULL);
//                dispatch_async(imageQueue, ^{
//                    
//
//                    NSData *imageData=[NSData dataWithContentsOfFile:filePath];
//                    
//                    
//                    if(!imageData) return;
//                    
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        //if(cell.productImage){
//
//                            //product.imageLoadStatus=2; //loaded
//                            [cell.productImage setImage:[UIImage imageWithData:imageData]];
//                            [cell.loadingLabel setHidden:YES];
//                        //}
//                        //cell.productImage.layer.cornerRadius=cell.productImage.frame.size.width / 4;
//                        // cell.productImage.clipsToBounds = YES;
//                    });
//                    
//                });
//            }
//            else
//            {
//                
//                
//                //product.imageLoadStatus=1; //loading/fetch
//                //[cell.loadingLabel setHidden:NO];
//                // this is for BT connection but it may be very slow
//                //TODO: implement compression
//                //dispatch_async(dispatch_get_main_queue(), ^{
//                NSString *serverPath=[NSString stringWithFormat:@"images/%@",product.pictureFile];
//                
//                BroadcastMessageAPI *message=[[BroadcastMessageAPI alloc] init];
//                message.text=serverPath;
//                message.isBroadcast=NO;
//                message.toPeerInfo=_appDelegate.selectedStore.peerInfo;
//                message.message_type=MSG_TYPE_REQUEST_FILE_DOWNLOAD;
//                message.localCopy=NO;
//                
//                [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didFinishDownload:) name:product.pictureFile object:nil];
//                
//                NSDictionary *dict = @{KEY_SEND_MESSAGE: message
//                                       };
//                
//                [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_HAS_DATA_TO_SEND
//                 
//                 
//                 
//                                                                    object:nil
//                                                                  userInfo:dict];
//                
//            }
//            
//        }
//        else if(product.imageLoadStatus==1){//loading
//            [cell.loadingLabel setHidden:NO];
//        }
//        else if(product.imageLoadStatus==2){//loaded
//            //[cell.loadingLabel setHidden:YES];
//            [cell.loadingLabel setHidden:NO];
//
//            NSString *filePath=[[AppDelegate getImagesPathForServer:_appDelegate.selectedStore.peerInfo.deviceID] stringByAppendingPathComponent:product.pictureFile];
//            
//            dispatch_queue_t imageQueue = dispatch_queue_create("Image Queue",NULL);
//            dispatch_async(imageQueue, ^{
//                
//
//                NSData *imageData=[NSData dataWithContentsOfFile:filePath];
//                
//                
//                if(!imageData) return;
//                
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    //if(cell.productImage){
//
//                    //product.imageLoadStatus=2; //loaded
//                    [cell.productImage setImage:[UIImage imageWithData:imageData]];
//                    [cell.loadingLabel setHidden:YES];
//                    //}
//                    //cell.productImage.layer.cornerRadius=cell.productImage.frame.size.width / 4;
//                    // cell.productImage.clipsToBounds = YES;
//                });
//                
//            });
//
//        }
//        
//        
//        
//        
//    }
//    
//    
//    // [cell.productImage setImage:[UIImage imageWithData:imageData]];
//    cell.productImage.layer.cornerRadius=cell.productImage.frame.size.width / 4;
//    cell.productImage.clipsToBounds = YES;
//    
//    UIImage *background = [self cellBackgroundForRowAtIndexPath:indexPath];
//    
//    UIImageView *cellBackgroundView = [[UIImageView alloc] initWithImage:background];
//    cellBackgroundView.image = background;
//    cell.backgroundView = cellBackgroundView;
//    
//    return cell;
//}

//-(UITableViewCell *)menuNoImageCell:(NSIndexPath *)indexPath withProduct:(Product *)product{
//    MenuNoImageCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"MenuNoImageCell" forIndexPath:indexPath];
//    if(cell==nil){
//        cell=[[MenuNoImageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MenuNoImageCell"];
//    }
//    /*
//     ProductCategory *cat=[_menu objectAtIndex:indexPath.section];
//     Product *product=[cat.products objectAtIndex:indexPath.row];
//     */
//    cell.nameLabel.text=product.name;
//    //cell.prodDetailLabel.text=product.detail;
//    
//    if (product.discount>0) {
//        NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:[Product priceToString:(double)product.actualPrice/100 currency:_appDelegate.selectedStore.inventory.currencySymbol]];
//        [attributeString addAttribute:NSStrikethroughStyleAttributeName
//                                value:@2
//                                range:NSMakeRange(0, [attributeString length])];
//        cell.actualPriceLabel.attributedText=attributeString;//[Product priceToString:(double)product.actualPrice/100]; //[NSString stringWithFormat:@"%.2f",(double)product.price/100];
//        
//        //cell.priceLabel.text=[Product priceToString:(double)product.price/100];//[NSString stringWithFormat:@"%.2f %@%% off",(double)product.price/100,product.discountToString];
//    }
//    else{
//        cell.actualPriceLabel.text=nil;
//    }
//    
//    //if(product.price==0){
//    //    cell.priceLabel.text=@"FREE";
//    //}
//    ////else{
//    cell.priceLabel.text=[Product priceToString:(double)product.price/100 currency:_appDelegate.selectedStore.inventory.currencySymbol];//cell.priceLabel.text=[NSString stringWithFormat:@"%.2f",(double)product.price/100];
//    
//    //}
//    
//    
//    
//    if(product.stock_unlimited)
//        cell.quantityLabel.text=@"";
//    else{
//        if (product.instock>0)
//            cell.quantityLabel.text=[NSString stringWithFormat:@"%lu Left",(unsigned long)product.instock];
//        else
//            cell.quantityLabel.text=@"SOLD OUT";
//    }
//    
//    /*
//    cell.productImage.image=nil;
//    if(product.pictureFile.length>0){
//        
//        NSString *filePath=[[AppDelegate getImagesPathForServer:_appDelegate.selectedStore.peerInfo.deviceID] stringByAppendingPathComponent:product.pictureFile];
//        if([[NSFileManager defaultManager] fileExistsAtPath:filePath])
//        {
//            dispatch_queue_t imageQueue = dispatch_queue_create("Image Queue",NULL);
//            dispatch_async(imageQueue, ^{
//                
//                
//                NSData *imageData=[NSData dataWithContentsOfFile:filePath];
//                
//                
//                if(!imageData) return;
//                
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    if(cell.productImage){
//                        [cell.productImage setImage:[UIImage imageWithData:imageData]];
//                    }
//                    //cell.productImage.layer.cornerRadius=cell.productImage.frame.size.width / 4;
//                    // cell.productImage.clipsToBounds = YES;
//                });
//                
//            });
//        }
//        else
//        {
//            
//            
//            
//            // this is for BT connection but it may be very slow
//            //TODO: implement compression
//            //dispatch_async(dispatch_get_main_queue(), ^{
//            NSString *serverPath=[NSString stringWithFormat:@"images/%@",product.pictureFile];
//            
//            BroadcastMessageAPI *message=[[BroadcastMessageAPI alloc] init];
//            message.text=serverPath;
//            message.isBroadcast=NO;
//            message.toPeerInfo=_appDelegate.mcManager.serverPeerInfo;
//            message.message_type=MSG_TYPE_REQUEST_FILE_DOWNLOAD;
//            message.localCopy=NO;
//            
//            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didFinishDownload:) name:product.pictureFile object:nil];
//            
//            NSDictionary *dict = @{KEY_SEND_MESSAGE: message
//                                   };
//            
//            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_HAS_DATA_TO_SEND
//             
//             
//             
//                                                                object:nil
//                                                              userInfo:dict];
//            
//            
//            
//            //});
//            
//        }
//        
//        
//    }
//    
//    // [cell.productImage setImage:[UIImage imageWithData:imageData]];
//    cell.productImage.layer.cornerRadius=cell.productImage.frame.size.width / 4;
//    cell.productImage.clipsToBounds = YES;
//    */
//    UIImage *background = [self cellBackgroundForRowAtIndexPath:indexPath];
//    
//    UIImageView *cellBackgroundView = [[UIImageView alloc] initWithImage:background];
//    cellBackgroundView.image = background;
//    cell.backgroundView = cellBackgroundView;
//    
//    return cell;
//}
//
//-(UITableViewCell *)menuNoImageNoQuantityCell:(NSIndexPath *)indexPath withProduct:(Product *)product{
//    MenuNoImageNoQuantityCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"MenuNoImageNoQuantityCell" forIndexPath:indexPath];
//    if(cell==nil){
//        cell=[[MenuNoImageNoQuantityCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MenuNoImageNoQuantityCell"];
//    }
//    /*
//     ProductCategory *cat=[_menu objectAtIndex:indexPath.section];
//     Product *product=[cat.products objectAtIndex:indexPath.row];
//     */
//    cell.nameLabel.text=product.name;
//    //cell.prodDetailLabel.text=product.detail;
//    
//    if (product.discount>0) {
//        NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:[Product priceToString:(double)product.actualPrice/100 currency:_appDelegate.selectedStore.inventory.currencySymbol]];
//        [attributeString addAttribute:NSStrikethroughStyleAttributeName
//                                value:@2
//                                range:NSMakeRange(0, [attributeString length])];
//        cell.actualPriceLabel.attributedText=attributeString;//[Product priceToString:(double)product.actualPrice/100]; //[NSString stringWithFormat:@"%.2f",(double)product.price/100];
//        
//        //cell.priceLabel.text=[Product priceToString:(double)product.price/100];//[NSString stringWithFormat:@"%.2f %@%% off",(double)product.price/100,product.discountToString];
//    }
//    else{
//        cell.actualPriceLabel.text=nil;
//    }
//    
//    //if(product.price==0){
//    //    cell.priceLabel.text=@"FREE";
//    //}
//    ////else{
//    cell.priceLabel.text=[Product priceToString:(double)product.price/100 currency:_appDelegate.selectedStore.inventory.currencySymbol];//cell.priceLabel.text=[NSString stringWithFormat:@"%.2f",(double)product.price/100];
//    
//    //}
//    
//    
//    
//    if(product.stock_unlimited)
//        cell.quantityLabel.text=@"";
//    else{
//        if (product.instock>0)
//            cell.quantityLabel.text=[NSString stringWithFormat:@"%lu Left",(unsigned long)product.instock];
//        else
//            cell.quantityLabel.text=@"SOLD OUT";
//    }
//    
//    /*
//     cell.productImage.image=nil;
//     if(product.pictureFile.length>0){
//     
//     NSString *filePath=[[AppDelegate getImagesPathForServer:_appDelegate.selectedStore.peerInfo.deviceID] stringByAppendingPathComponent:product.pictureFile];
//     if([[NSFileManager defaultManager] fileExistsAtPath:filePath])
//     {
//     dispatch_queue_t imageQueue = dispatch_queue_create("Image Queue",NULL);
//     dispatch_async(imageQueue, ^{
//     
//     
//     NSData *imageData=[NSData dataWithContentsOfFile:filePath];
//     
//     
//     if(!imageData) return;
//     
//     dispatch_async(dispatch_get_main_queue(), ^{
//     if(cell.productImage){
//     [cell.productImage setImage:[UIImage imageWithData:imageData]];
//     }
//     //cell.productImage.layer.cornerRadius=cell.productImage.frame.size.width / 4;
//     // cell.productImage.clipsToBounds = YES;
//     });
//     
//     });
//     }
//     else
//     {
//     
//     
//     
//     // this is for BT connection but it may be very slow
//     //TODO: implement compression
//     //dispatch_async(dispatch_get_main_queue(), ^{
//     NSString *serverPath=[NSString stringWithFormat:@"images/%@",product.pictureFile];
//     
//     BroadcastMessageAPI *message=[[BroadcastMessageAPI alloc] init];
//     message.text=serverPath;
//     message.isBroadcast=NO;
//     message.toPeerInfo=_appDelegate.mcManager.serverPeerInfo;
//     message.message_type=MSG_TYPE_REQUEST_FILE_DOWNLOAD;
//     message.localCopy=NO;
//     
//     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didFinishDownload:) name:product.pictureFile object:nil];
//     
//     NSDictionary *dict = @{KEY_SEND_MESSAGE: message
//     };
//     
//     [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_HAS_DATA_TO_SEND
//     
//     
//     
//     object:nil
//     userInfo:dict];
//     
//     
//     
//     //});
//     
//     }
//     
//     
//     }
//     
//     // [cell.productImage setImage:[UIImage imageWithData:imageData]];
//     cell.productImage.layer.cornerRadius=cell.productImage.frame.size.width / 4;
//     cell.productImage.clipsToBounds = YES;
//     */
//    UIImage *background = [self cellBackgroundForRowAtIndexPath:indexPath];
//    
//    UIImageView *cellBackgroundView = [[UIImageView alloc] initWithImage:background];
//    cellBackgroundView.image = background;
//    cell.backgroundView = cellBackgroundView;
//    
//    return cell;
//}

-(UITableViewCell *)menuNoSellCell:(NSIndexPath *)indexPath withProduct:(Product *)product{
    
    MenuNoSellCell *cell;//
    BOOL hasImage=NO;
    NSString *identifier;
    //BOOL haQuantity=NO;
    if( product.pictureFile!=nil && product.pictureFile.length>0)
        hasImage=YES;
    
    if(hasImage){
        identifier=@"MenuNoSellCell";
    }
    else{
        identifier=@"MenuNoSellNoImageCell";
    }
    
    cell = [self.tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    if(cell==nil){
        cell=[[MenuNoSellCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    /*
    ProductCategory *cat=[_menu objectAtIndex:indexPath.section];
    Product *product=[cat.products objectAtIndex:indexPath.row];
     */
    cell.nameLabel.text=product.name;
    cell.prodDetailLabel.text=product.detail;
    
    
    
    
    
    cell.productImage.image=nil;
    if(hasImage){
        
        if(product.imageLoadStatus==0){
            
            
            
            //product.imageLoadStatus=1;
            
            product.imageLoadStatus=1;
            //[cell.loadingLabel setHidden:NO];
           [cell.loadingIndicator startAnimating];
            NSString *filePath=[[AppDelegate getImagesPathForServer:_appDelegate.selectedStore.peerInfo.deviceID] stringByAppendingPathComponent:product.pictureFile];
            
            if([[NSFileManager defaultManager] fileExistsAtPath:filePath])
            {
                //[cell.loadingLabel setHidden:NO];
                
                dispatch_queue_t imageQueue = dispatch_queue_create("Image Queue",NULL);
                dispatch_async(imageQueue, ^{
                    
                    
                    NSData *imageData=[NSData dataWithContentsOfFile:filePath];
                    
                    
                    if(!imageData) return;
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        //if(cell.productImage){
                        
                        product.imageLoadStatus=2; //loaded
                        [cell.productImage setImage:[UIImage imageWithData:imageData]];
                        //[cell.loadingLabel setHidden:YES];
                        [cell.loadingIndicator stopAnimating];
                        //}
                        //cell.productImage.layer.cornerRadius=cell.productImage.frame.size.width / 4;
                        // cell.productImage.clipsToBounds = YES;
                    });
                    
                });
            }
            else
            {
                
                
                //product.imageLoadStatus=1; //loading/fetch
                //[cell.loadingLabel setHidden:NO];
                // this is for BT connection but it may be very slow
                //TODO: implement compression
                //dispatch_async(dispatch_get_main_queue(), ^{
                NSString *serverPath=[NSString stringWithFormat:@"images/%@",product.pictureFile];
                
                BroadcastMessageAPI *message=[[BroadcastMessageAPI alloc] init];
                message.text=serverPath;
                message.isBroadcast=NO;
                message.toPeerInfo=_appDelegate.selectedStore.peerInfo;
                message.message_type=MSG_TYPE_REQUEST_FILE_DOWNLOAD;
                message.localCopy=NO;
                
                //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didFinishDownload:) name:product.pictureFile object:nil];
                
                NSDictionary *dict = @{KEY_SEND_MESSAGE: message
                                       };
                
                [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_HAS_DATA_TO_SEND
                 
                 
                 
                                                                    object:nil
                                                                  userInfo:dict];
                
            }
            
        }
        else if(product.imageLoadStatus==1){//loading
            //[cell.loadingLabel setHidden:NO];
            [cell.loadingIndicator startAnimating];
        }
        else if(product.imageLoadStatus==2){//loaded
            //[cell.loadingLabel setHidden:YES];
            //[cell.loadingLabel setHidden:NO];
            [cell.loadingIndicator stopAnimating];
            NSString *filePath=[[AppDelegate getImagesPathForServer:_appDelegate.selectedStore.peerInfo.deviceID] stringByAppendingPathComponent:product.pictureFile];
            
            dispatch_queue_t imageQueue = dispatch_queue_create("Image Queue",NULL);
            dispatch_async(imageQueue, ^{
                
                
                NSData *imageData=[NSData dataWithContentsOfFile:filePath];
                
                
                if(!imageData) return;
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    //if(cell.productImage){
                    
                    //product.imageLoadStatus=2; //loaded
                    [cell.productImage setImage:[UIImage imageWithData:imageData]];
                    //[cell.loadingLabel setHidden:YES];
                    //}
                    //cell.productImage.layer.cornerRadius=cell.productImage.frame.size.width / 4;
                    // cell.productImage.clipsToBounds = YES;
                });
                
            });
            
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


//-(UITableViewCell *)menuNoSellNoImageCell:(NSIndexPath *)indexPath withProduct:(Product *)product{
//    MenuNoSellNoImageCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"MenuNoSellNoImageCell" forIndexPath:indexPath];
//    if(cell==nil){
//        cell=[[MenuNoSellNoImageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MenuNoSellNoImageCell"];
//    }
//    /*
//     ProductCategory *cat=[_menu objectAtIndex:indexPath.section];
//     Product *product=[cat.products objectAtIndex:indexPath.row];
//     */
//    cell.nameLabel.text=product.name;
//    cell.prodDetailLabel.text=product.detail;
//    
//    
//    
//    
//    /*
//    cell.productImage.image=nil;
//    if(product.pictureFile.length>0){
//        
//        NSString *filePath=[[AppDelegate getImagesPathForServer:_appDelegate.selectedStore.peerInfo.deviceID] stringByAppendingPathComponent:product.pictureFile];
//        if([[NSFileManager defaultManager] fileExistsAtPath:filePath])
//        {
//            dispatch_queue_t imageQueue = dispatch_queue_create("Image Queue",NULL);
//            dispatch_async(imageQueue, ^{
//                
//                
//                NSData *imageData=[NSData dataWithContentsOfFile:filePath];
//                
//                
//                if(!imageData) return;
//                
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    if(cell.productImage){
//                        [cell.productImage setImage:[UIImage imageWithData:imageData]];
//                    }
//                    //cell.productImage.layer.cornerRadius=cell.productImage.frame.size.width / 4;
//                    // cell.productImage.clipsToBounds = YES;
//                });
//                
//            });
//        }
//        else
//        {
//            
//            
//            
//            // this is for BT connection but it may be very slow
//            //TODO: implement compression
//            //dispatch_async(dispatch_get_main_queue(), ^{
//            NSString *serverPath=[NSString stringWithFormat:@"images/%@",product.pictureFile];
//            
//            BroadcastMessageAPI *message=[[BroadcastMessageAPI alloc] init];
//            message.text=serverPath;
//            message.isBroadcast=NO;
//            message.toPeerInfo=_appDelegate.mcManager.serverPeerInfo;
//            message.message_type=MSG_TYPE_REQUEST_FILE_DOWNLOAD;
//            message.localCopy=NO;
//            
//            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didFinishDownload:) name:product.pictureFile object:nil];
//            
//            NSDictionary *dict = @{KEY_SEND_MESSAGE: message
//                                   };
//            
//            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_HAS_DATA_TO_SEND
//             
//             
//             
//                                                                object:nil
//                                                              userInfo:dict];
//            
//            
//            
//            //});
//            
//        }
//        
//        
//    }
//    
//    // [cell.productImage setImage:[UIImage imageWithData:imageData]];
//    cell.productImage.layer.cornerRadius=cell.productImage.frame.size.width / 4;
//    cell.productImage.clipsToBounds = YES;
//    */
//    UIImage *background = [self cellBackgroundForRowAtIndexPath:indexPath];
//    
//    UIImageView *cellBackgroundView = [[UIImageView alloc] initWithImage:background];
//    cellBackgroundView.image = background;
//    cell.backgroundView = cellBackgroundView;
//    
//    return cell;
//}





- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*
    if(_appDelegate.selectedStore.inventory.isEcommerce)
        return [self menuCell:indexPath];
    else
        return [self menuNoSellCell:indexPath];
    */
    
    ProductCategory *cat=[_menu objectAtIndex:indexPath.section];
    Product *product=[cat.products objectAtIndex:indexPath.row];

    
    if(_appDelegate.selectedStore.inventory.isEcommerce){
        return [self menuCell:indexPath withProduct:product];
        /*
        if(product.pictureFile!=nil && product.pictureFile.length>0){
            if(product.stock_unlimited)
                return [self menuNoQuantityCell:indexPath withProduct:product];
            
            else
                return [self menuCell:indexPath withProduct:product];
                
                
        }
        else{
            if(product.stock_unlimited)
                return [self menuNoImageNoQuantityCell:indexPath withProduct:product];
            else
                return [self menuNoImageCell:indexPath withProduct:product];
        }
         */
    }
    else{
        //if(product.pictureFile!=nil && product.pictureFile.length>0){
            return [self menuNoSellCell:indexPath withProduct:product];
        //}
       // else{
      //      return [self menuNoSellNoImageCell:indexPath withProduct:product];
       // }
    }
    
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    _selectedCategory=[_menu objectAtIndex:indexPath.section];
    
    
    _selectedProduct=[_selectedCategory.products objectAtIndex:indexPath.row];
    
    
    //[self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    //[self performSegueWithIdentifier:@"toProductViewController" sender:nil];
    
    //[[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_SHOW_MENU_PRODUCT object:nil userInfo:@{@"product":_selectedProduct,@"category":_selectedCategory}];
    //OrderMenuViewController *vc=(OrderMenuViewController *)[self.parentViewController];
    _refenceToParentViewController.selectedProduct=_selectedProduct;
    _refenceToParentViewController.selectedCategory=_selectedCategory;
    
    _refenceToParentViewController.nextViewName=NOTIFY_SHOW_MENU_PRODUCT;
    [self.navigationController popViewControllerAnimated:YES];
    
    
    /*}
     else{
     
     OrderItem *orderItem=[[order orderItems] objectAtIndex:indexPath.row];
     [order removeItemFromOrder:orderItem];
     
     UILabel* addItemDisplay = [[UILabel alloc] initWithFrame:[self.tableView frame]];
     [addItemDisplay setText:@"+1"];
     [addItemDisplay setTextColor:[UIColor whiteColor]];
     [addItemDisplay setBackgroundColor:[UIColor clearColor]];
     [addItemDisplay setTextAlignment:UITextAlignmentCenter];
     [addItemDisplay setFont:[UIFont boldSystemFontOfSize:32.0]];
     [[self view] addSubview:addItemDisplay];
     
     [UIView animateWithDuration:1.0
     animations:^{
     [addItemDisplay setCenter:[self.tableView center]];
     [addItemDisplay setAlpha:0.0];
     } completion:^(BOOL finished) {
     [addItemDisplay removeFromSuperview];
     }];
     [self.tableView reloadData];
     }
     */
    
}

- (UIImage *)cellBackgroundForRowAtIndexPath:(NSIndexPath *)indexPath{
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
    
    return background;
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
        
        /*if(!pc.expanded){
         //cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
         
         
         [cell.expandButton setImage:[UIImage imageNamed:@"expand_arrow"] forState:UIControlStateNormal];
         
         
         }
         else{
         [cell.expandButton setImage:[UIImage imageNamed:@"collapse_arrow"] forState:UIControlStateNormal];
         
         }
         */
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
        
        /*
         [[cell.expandButton layer] setCornerRadius:8.0f];
         
         [[cell.expandButton layer] setBorderWidth:1.0f];
         
         [[cell.expandButton layer] setBorderColor:cell.expandButton.titleLabel.textColor.CGColor];
         */
        cell.backgroundColor=[UIColor whiteColor];
        return cell;
        
        
    }
    else{
        MenuSectionNoImageCell *cell=[tableView dequeueReusableCellWithIdentifier:@"MenuSectionNoImageCell"];
        cell.nameLabel.text =pc.name;//[categorySectionTitles objectAtIndex:section];
        /*if(!pc.expanded){
         //cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
         [cell.expandButton setImage:[UIImage imageNamed:@"expand_arrow"] forState:UIControlStateNormal];
         
         
         }
         else{
         [cell.expandButton setImage:[UIImage imageNamed:@"collapse_arrow"] forState:UIControlStateNormal];
         
         }
         */
        if(!pc.expanded){
            //cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
            [cell.expandImage setImage:[UIImage imageNamed:@"expand_arrow"]];
            
            
        }
        else{
            [cell.expandImage setImage:[UIImage imageNamed:@"collapse_arrow"]] ;
            
        }
        /*[cell.expandButton addTarget:self action:@selector(expandAction:) forControlEvents:UIControlEventTouchUpInside];
         cell.expandButton.tag=section;
         */
        UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(expandGesture:)];
        
        [cell addGestureRecognizer:tap];
        cell.tag=section;
        /*
         [[cell.expandButton layer] setCornerRadius:8.0f];
         
         [[cell.expandButton layer] setBorderWidth:1.0f];
         
         [[cell.expandButton layer] setBorderColor:cell.expandButton.titleLabel.textColor.CGColor];
         */
        cell.backgroundColor=[UIColor whiteColor];
        return cell;
        
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    /*
    ProductCategory *cat=[_menu objectAtIndex:indexPath.section];
    Product *product=[cat.products objectAtIndex:indexPath.row];
    */
    //if(product.stock_unlimited)
     //   return 100;
    //else
        return 120;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 60.0;
}

#pragma mark - UIStoryboard methods

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    //this is only triggered using iphone
    if([segue.identifier isEqualToString:@"toProductViewController"]){
        ProductViewController* viewController = (ProductViewController*) segue.destinationViewController;
        viewController.selectedCategory=_selectedCategory;
        viewController.selectedInventory=_appDelegate.selectedStore.inventory;
        viewController.selectedProduct= _selectedProduct;
        
    }
    
    
}

-(void)didReceiveMenuWithNotification:(NSNotification *)notification{
    
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

-(void)didReceiveUpdateProductImageNotification:(NSNotification *)notification{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
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
//        [self.tableView reloadData];
//    });
//    
//    
//}
-(void)reloadImageOntimer{
    [self.tableView reloadData];
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
    [self.tableView reloadData];
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
    [self.tableView reloadData];
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

-(void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{
    if(buttonIndex<0)
        return;
    NSString *buttonTitle=[actionSheet buttonTitleAtIndex:buttonIndex];
    
    if([buttonTitle isEqualToString:TITLE_SETTINGS]){
        [self showStoreSettingsAction:nil];
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
    else if([buttonTitle isEqualToString:TITLE_THUMBVIEW]){
        [self showThumbView];
    }
    
    
}
-(void)showMenuActionSheet{
    [_menuActionSheet showFromBarButtonItem:_menuButtonItem animated:YES];
    
}
- (IBAction)menuButtonTapped:(id)sender {
    [_menuActionSheet showFromBarButtonItem:_menuButtonItem animated:YES];
}


-(void)showThumbView{
    // [self performSegueWithIdentifier:@"toAppSettingsViewController" sender:self];
    //[[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_SHOW_MENU_COLLECTION object:nil];
    _refenceToParentViewController.nextViewName=NOTIFY_SHOW_MENU_COLLECTION;
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)showStoreSettingsAction:(id)sender {
    
    
    
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
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_SHOW_MENU_COLLECTION object:nil];
    }



@end
