//
//  IODViewController.m
//  iOSDiner
//
//  Created by Romulo Quidilig on 3/19/15.
//  Copyright (c) 2015 Sharecle Inc. All rights reserved.
//

#import "OrderIpadViewController.h"

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
#import "MenuNoSellCell.h"
#import "MenuSectionCell.h"
#import "MenuSectionNoImageCell.h"
#import "ProductIpadViewController.h"
#import "defs.h"



@implementation OrderIpadViewController
{
    NSArray *categorySectionTitles;
     UIImage *_myPhoto;
    
    Product *selectedProduct;
    //InventoryItem *_selectedInventory;
    ProductCategory *_selectedCategory;
    
    AppDelegate *_appDelegate;
    BOOL bannerIsVisible;
    NSTimer *timerWaitBeforReload;
    NSMutableArray *_inventory;// _sortedCategories;
    ProductIpadViewController *detailProduct;
    
    UINavigationController *navProduct;

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
    _appDelegate = ApplicationDelegate;//(AppDelegate *)[[UIApplication sharedApplication] delegate];
/*
    UISplitViewController *svc= (UISplitViewController *)[self.navigationController parentViewController];
    
    navProduct=(UINavigationController *)[svc.viewControllers objectAtIndex:1];
    
    detailProduct=(ProductIpadViewController *)navProduct.topViewController;//(ProductIpadViewController *)[svc.viewControllers objectAtIndex:1];//[self.storyboard instantiateViewControllerWithIdentifier:@"ProductIpadViewController"];
    //navProduct=[[UINavigationController alloc] initWithRootViewController:detailProduct];
    
    self.delegateProduct=detailProduct;
    svc.delegate=detailProduct;
    */
   /* SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
    {
        [self.sidebarButton setTarget: self.revealViewController];
        [self.sidebarButton setAction: @selector( revealToggle: )];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
    */
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didReceiveMenuWithNotification:)
                                                 name:NOTIFY_RECEIVED_MENU
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didReceiveMenuWithNotification:)
                                                 name:NOTIFY_RECEIVED_MENU_UPDATE
                                               object:nil];


    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didReceivePeerBgPhotoNotification:)
                                                 name:NOTIFY_RECEIVED_PEER_BGPHOTO
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didFinishDownload:)
                                                 name:NOTIFY_DOWNLOAD_DONE
                                               object:nil];
    
    
    
    self.tableView.backgroundColor=[UIColor clearColor];
    
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.parentViewController.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"common_bg"]];
    self.tableView.backgroundColor = [UIColor clearColor];
    UIEdgeInsets inset = UIEdgeInsetsMake(5, 0, 0, 0);
    self.tableView.contentInset = inset;

    [self reloadMenu];
    
    
    [self loadBgPhoto];
    self.title=@"Menu";//_appDelegate.mcManager.serverPeerInfo.peerID.displayName;
    
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

- (void)viewDidUnload
{
    /*
    [self setIbRemoveItemButton:nil];
    [self setIbAddItemButton:nil];
    [self setIbPreviousItemButton:nil];
    [self setIbNextItemButton:nil];
    [self setIbTotalOrderButton:nil];
    [self setIbChalkboardLabel:nil];
    [self setIbCurrentItemImageView:nil];
    [self setIbCurrentItemLabel:nil];
     */
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

/*- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
*/
-(void)reloadMenu{
    NSArray *inventory_array=[_appDelegate.inventory valueForKey:inventoryKey];
    
    if(_inventory==nil)
        _inventory = [NSMutableArray new];
    //this is already sorted at the server side
    [_inventory removeAllObjects];
    //for (ProductCategory *pc in allSortedCategories) {
    //for (ProductCategory *pc in allSortedCategories) {
    for (NSDictionary *dict in inventory_array ) {
        ProductCategory *pc=[[ProductCategory alloc] initWithDictionary:dict];
        //pc.sortedProducts=[_selectedInventory allProductsWithCategoryID:pc.categoryID sorted:YES];
        //if(pc.sortedProducts!=nil && [pc.sortedProducts count]>0){
       //     [_sortedCategories addObject:pc];
       // }
        [_inventory addObject:pc];
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
    if([_inventory count]==0){
        
         BroadcastMessageAPI *m=[[BroadcastMessageAPI alloc] init];
         //message.text=serverPath;
         m.message_type=MSG_TYPE_REQUEST_SERVERINFO;
         m.toPeerInfo=_appDelegate.mcManager.serverPeerInfo;
         m.isBroadcast=NO;
         //[self sendMyMessage:message];
        [_appDelegate addNewMessage:m];
        
        
        NSDictionary *dict = @{KEY_SEND_MESSAGE: m
                               };
        
        
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_HAS_DATA_TO_SEND
                                                            object:nil
                                                          userInfo:dict];
        [AppDelegate toast:@"Loading" duration:5];
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
    NSArray *sectionProducts = [_appDelegate.inventory objectForKey:sectionTitle];
     */
    //NSDictionary *cat=[_appDelegate.inventory objectAtIndex:indexPath.section];
    NSDictionary *cat=[[_appDelegate.inventory valueForKey:@"products"] objectAtIndex:indexPath.section];
    
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
    NSArray *sectionProducts = [_appDelegate.inventory objectForKey:sectionTitle];
     */
    NSDictionary *cat=[[_appDelegate.inventory valueForKey:@"products"] objectAtIndex:indexPath.section];//[_appDelegate.inventory objectAtIndex:indexPath.section];
    
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
            NSString *url=[NSString stringWithFormat:@"%@images/%@",_appDelegate.mcManager.serverPeerInfo.homeUrl,[currentItem pictureFile]];
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
    return [_inventory count];//[categorySectionTitles count];
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
    
    ProductCategory *cat=[_inventory objectAtIndex:section];
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

-(UITableViewCell *)menuCell:(NSIndexPath *)indexPath{
    MenuCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"menu_cell" forIndexPath:indexPath];
    if(cell==nil){
        cell=[[MenuCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"menu_cell"];
    }
    // Configure the cell...
   /*
    NSDictionary *cat=[[_appDelegate.inventory valueForKey:inventoryKey] objectAtIndex:indexPath.section];//[_appDelegate.inventory objectAtIndex:indexPath.section];
    
    NSArray *sectionProducts = [cat objectForKey:PRODUCTS_KEY];
    
    
    Product *product=[[Product alloc] initWithDictionary:[sectionProducts objectAtIndex:indexPath.row]];
    */
    ProductCategory *cat=[_inventory objectAtIndex:indexPath.section];
    Product *product=[[Product alloc] initWithDictionary:[cat.products objectAtIndex:indexPath.row]];
   
    cell.nameLabel.text=product.name;
    //cell.prodDetailLabel.text=product.detail;
    
    if (product.discount>0) {
        NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:[Product priceToString:(double)product.actualPrice/100]];
        [attributeString addAttribute:NSStrikethroughStyleAttributeName
                                value:@2
                                range:NSMakeRange(0, [attributeString length])];
        cell.actualPriceLabel.attributedText=attributeString;//[Product priceToString:(double)product.actualPrice/100]; //[NSString stringWithFormat:@"%.2f",(double)product.price/100];
        
        //cell.priceLabel.text=[Product priceToString:(double)product.price/100];//[NSString stringWithFormat:@"%.2f %@%% off",(double)product.price/100,product.discountToString];
    }
    else{
        cell.actualPriceLabel.text=nil;
    }
   
    if(product.price==0){
    cell.priceLabel.text=@"FREE";
    }
    else{
        cell.priceLabel.text=[Product priceToString:(double)product.price/100];//cell.priceLabel.text=[NSString stringWithFormat:@"%.2f",(double)product.price/100];

    }
    
    
    
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
        
          NSString *filePath=[[AppDelegate getImagesPathForServer:_appDelegate.mcManager.serverPeerInfo.deviceID] stringByAppendingPathComponent:product.pictureFile];
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
    // Configure the cell...
    /*
    NSDictionary *cat=[[_appDelegate.inventory valueForKey:inventoryKey] objectAtIndex:indexPath.section];//[_appDelegate.inventory objectAtIndex:indexPath.section];
    
    NSArray *sectionProducts = [cat objectForKey:PRODUCTS_KEY];
    
    
    Product *product=[[Product alloc] initWithDictionary:[sectionProducts objectAtIndex:indexPath.row]];
    */
    ProductCategory *cat=[_inventory objectAtIndex:indexPath.section];
    Product *product=[[Product alloc] initWithDictionary:[cat.products objectAtIndex:indexPath.row]];
    cell.nameLabel.text=product.name;
    cell.prodDetailLabel.text=product.detail;
    
    
    
   
    
    cell.productImage.image=nil;
    if(product.pictureFile.length>0){
        
        NSString *filePath=[[AppDelegate getImagesPathForServer:_appDelegate.mcManager.serverPeerInfo.deviceID] stringByAppendingPathComponent:product.pictureFile];
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





- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(_appDelegate.selectedInventory.isEcommerce)
        return [self menuCell:indexPath];
    else
        return [self menuNoSellCell:indexPath];
    
    
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   // if([tableView isEqual:self.tableView]){
   
    /*NSString *sectionTitle = [categorySectionTitles objectAtIndex:_selectedIndexPath.section];
     NSArray *sectionProducts = [_appDelegate.inventory objectForKey:sectionTitle];
     */
    
    /*
    NSDictionary *cat=[[_appDelegate.inventory valueForKey:inventoryKey] objectAtIndex:indexPath.section];//[_appDelegate.inventory objectAtIndex:indexPath.section];
    
    NSArray *sectionProducts = [cat objectForKey:PRODUCTS_KEY];
    selectedProduct= [[Product alloc] initWithDictionary:[sectionProducts objectAtIndex:indexPath.row]];
    */
    
    
    //[self performSegueWithIdentifier:@"toProductViewController" sender:self];
    /*
    if(_delegateProduct){
        [_delegateProduct selectedProduct:selectedProduct];
    }
      */
    //_selectedInventory=[_appDelegate activ];
    _selectedCategory=[_inventory objectAtIndex:indexPath.section];//[_sortedCategories objectAtIndex:indexPath.section];
    
    //selectedProduct=selectedProduct=[_selectedCategory objectAtIndex:indexPath.row];//[_selectedCategory.sortedProducts objectAtIndex:indexPath.row];
    
    
    selectedProduct=[[Product alloc] initWithDictionary:[_selectedCategory.products objectAtIndex:indexPath.row]];
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_SHOW_PRODUCT object:nil userInfo:@{KEY_SELECTED_INVENTORY:_appDelegate.selectedInventory,KEY_SELECTED_CATEGORY:_selectedCategory,KEY_SELECTED_PRODUCT:selectedProduct}];
    }
    else{
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
        [self performSegueWithIdentifier:@"toProductViewController" sender:nil];
    }
    
        
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
    ProductCategory *pc=[_inventory objectAtIndex:section];
    
    
    
    bool hasImage=NO;
    NSString *filePath=nil;
    if(pc.pictureFile){
        filePath=[[AppDelegate getImagesPathForServer:_appDelegate.mcManager.serverPeerInfo.deviceID] stringByAppendingPathComponent:pc.pictureFile];
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
            
            
            [cell.expandButton setImage:[UIImage imageNamed:@"expand_arrow"] forState:UIControlStateNormal];
            
            
        }
        else{
            [cell.expandButton setImage:[UIImage imageNamed:@"collapse_arrow"] forState:UIControlStateNormal];
            
        }
        [cell.expandButton addTarget:self action:@selector(expandAction:) forControlEvents:UIControlEventTouchUpInside];
        cell.expandButton.tag=section;
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
        if(!pc.expanded){
            //cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
            [cell.expandButton setImage:[UIImage imageNamed:@"expand_arrow"] forState:UIControlStateNormal];
            
            
        }
        else{
            [cell.expandButton setImage:[UIImage imageNamed:@"collapse_arrow"] forState:UIControlStateNormal];
            
        }
        [cell.expandButton addTarget:self action:@selector(expandAction:) forControlEvents:UIControlEventTouchUpInside];
        cell.expandButton.tag=section;
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
    return 100;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 60.0;
}

#pragma mark - UIStoryboard methods

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    /*
    if([segue.identifier isEqualToString:@"toProductViewController"]){
                ProductViewController* viewController = (ProductViewController*) segue.destinationViewController;
        viewController.product= selectedProduct;
        
    }
   */
}

-(void)didReceiveMenuWithNotification:(NSNotification *)notification{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        /*NSDictionary *menu=[_appDelegate.inventory valueForKey:INVENTORY_KEY];
        categorySectionTitles=[menu valueForKey:NAME_KEY];
            [self.tableView reloadData];
         */
        [self reloadMenu];
    });
    
}

-(void)loadBgPhoto{
    
    if(_appDelegate.mcManager.serverPeerInfo==nil)
        return;
    NSString *peer_bgphoto=[NSString stringWithFormat:@"%@%@.png",PREFIX_MYBGPHOTO, _appDelegate.mcManager.serverPeerInfo.deviceID];
    
    
    
    NSString *filePath=[[AppDelegate getImagesPathForServer:_appDelegate.mcManager.serverPeerInfo.deviceID] stringByAppendingPathComponent:peer_bgphoto];
    
    
    
    //check if cached
    if([[NSFileManager defaultManager] fileExistsAtPath:filePath]){
        
        self.wallImage.image=[[UIImage alloc] initWithContentsOfFile:filePath];
    }
}

-(void)didReceivePeerBgPhotoNotification:(NSNotification *)notification{
    [self loadBgPhoto];
}

-(void)didFinishDownload:(NSNotification *)notification{
    if([notification.userInfo objectForKey:@"resourceName"]!=nil){
        [[NSNotificationCenter defaultCenter] removeObserver:self name:[notification.userInfo valueForKey:@"resourceName"] object:nil];
    }
    /*if(timerWaitBeforReload==nil)
        timerWaitBeforReload=[NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(reloadImageOntimer) userInfo:nil repeats:NO];
    else{
        if([timerWaitBeforReload isValid]){
            [timerWaitBeforReload invalidate];
            timerWaitBeforReload=[NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(reloadImageOntimer) userInfo:nil repeats:NO];
        }
    }
    */
    dispatch_async(dispatch_get_main_queue(), ^{
    [self.tableView reloadData];
    });
    
    
}
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
    ProductCategory *pc=[_inventory objectAtIndex:section];//[_sortedCategories objectAtIndex:section];
    
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




@end
