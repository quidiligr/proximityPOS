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
#import "OrderItem.h"
#import "CheckoutCart.h"
#import "ProductViewController.h"
#import "BroadcastMessageAPI.h"
#import "MenuCell.h"
#import "MenuNoSellCell.h"
#import "MenuSectionCell.h"
#import "MenuNoImageCell.h"
#import "MenuNoSellNoImageCell.h"
#import "MenuSectionNoImageCell.h"
#import "ChatViewController.h"
#import "BBBadgeBarButtonItem.h"
#import "Util.h"


#import "InventoryItem.h"



#import "defs.h"


#import "InventoryModel.h"


@implementation OrderMenuTableViewController
{
    NSMutableArray *categorySectionTitles;
    
    NSArray *searchedProductCategories;
    NSArray *searchedProducts;
    
    InventoryModel *_inventoryModel;
    InventoryItem *_selectedInventory;
    ProductCategory *_selectedCategory;
    Product *_selectedProduct;
    NSMutableArray *_sortedCategories;
    NSSortDescriptor *valueDescriptors;
    NSArray *descriptors;
    /*
    UIBarButtonItem *inventoryButtonItem;
    UIBarButtonItem *settingsButtonItem;
    UIBarButtonItem *lockButton;
    UIBarButtonItem *_searchButtonItem;
    UIBarButtonItem *_barcodeButtonItem;
    */
    UIAlertView * alertBarcodeScan;
    NSString *_search;
    
    UIActionSheet *_menuActionSheet;
    UIBarButtonItem *_menuButtonItem;
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
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        isIpad=YES;
    else
        isIpad=NO;
    
    self.view.backgroundColor=[UIColor clearColor];
    
    /*
    inventoryButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"Inventory" style:UIBarButtonItemStyleBordered target:self action:@selector(showInventoryAction:)];
    
    settingsButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"Settings" style:UIBarButtonItemStyleBordered target:self action:@selector(showSettingsAction:)];
    
    lockButton=[[UIBarButtonItem alloc] initWithTitle:@"Lock" style:UIBarButtonItemStyleBordered target:self action:@selector(lockButtonTapped:)];
    
    
    _searchButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"Search" style:UIBarButtonItemStyleBordered target:self action:@selector(searchAction:)];
    _barcodeButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"Barcode" style:UIBarButtonItemStyleBordered target:self action:@selector(barcodeAction:)];
    
    
    self.navigationItem.rightBarButtonItems=@[inventoryButtonItem,settingsButtonItem,lockButton];
    self.navigationItem.leftBarButtonItems=@[_searchButtonItem,_barcodeButtonItem];
    */
    
    //_menuButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"Menu" style:UIBarButtonItemStyleBordered target:self action:@selector(showMenuActionSheet)];
    
    _menuButtonItem=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Menu Filled"] style:UIBarButtonItemStyleBordered target:self action:@selector(showMenuActionSheet)];
    
    self.navigationItem.rightBarButtonItem=_menuButtonItem;
    
    _menuActionSheet=[[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:TITLE_SEARCH,TITLE_BARCODE,TITLE_INVENTORY,TITLE_SETTINGS,TITLE_LOCK,TITLE_THUMBVIEW, nil];
    
    valueDescriptors=[[NSSortDescriptor alloc] initWithKey:@"sortNumber" ascending:YES];
    descriptors=[NSArray arrayWithObject:valueDescriptors];
    
    
    
    _appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    self.menuTableView.backgroundColor=[UIColor clearColor];
    
    [self.menuTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    UIEdgeInsets inset = UIEdgeInsetsMake(5, 0, 0, 0);
    self.menuTableView.contentInset = inset;
    
    
    queue = dispatch_queue_create("com.sharecle.kiosk",nil); // <======
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reloadMenu) name:NOTIFY_UPDATE_INVENTORY
                                               object:nil];
    
    [self reloadMenu];
    [self loadBgPhoto];
    
}



- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if(_appDelegate.isIpad){
        [[self navigationController] setNavigationBarHidden:NO animated:YES];
    }
    [self reloadMenu];
    
    //[self loadBgPhoto];
    
    
    //    if ([_sortedCategories count]==0) {
    //        [self.menuTableView setHidden:YES];
    //        //[self showAddCategory ];
    //        //UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Empty menu" message:@"Add item(s) to your Menu now?" delegate:self cancelButtonTitle:@"Later" otherButtonTitles:@"Yes", nil];
    //        /*UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Menu is empty" message:@"Tap Inventory to add items" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    //        [alert show];
    //         */
    //
    //        [AppDelegate toast:@"Menu is emtpy. Tap Inventory to add items." duration:3.0];
    //    }
    //    else{
    //
    //         [self.menuTableView setHidden:NO];
    //    }
    //
    //[self.menuTableView reloadData];
    
    if(_appDelegate.appConfig.user_usepin){
        [self lockButtonTapped:self];
    }
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    NSString *btnTitle=[alertView buttonTitleAtIndex:buttonIndex];
    
    if([ alertView isEqual:alertBarcodeScan]){
        if([btnTitle isEqualToString:BTN_SCAN]){
            [self performSegueWithIdentifier:@"toBCScannerViewController" sender:self];
        }
        else if ([btnTitle isEqualToString:BTN_OK]){
            /*TODO: UITextField *txtField=[alertView textFieldAtIndex:0];
             
             
             [self addDiscountCode:txtField.text];
             */
        }
    }
    else{
        /*
         if([btnTitle isEqualToString:@"Yes"]){
         [self performSegueWithIdentifier:@"toInventoryListViewController" sender:self];
         }
         */
    }
}
/*
 -(UIInterfaceOrientationMask)supportedInterfaceOrientations{
 if(![[UIDevice currentDevice] userInterfaceIdiom]==UIUserInterfaceIdiomPad){
 //ipad allow all orientaions
 return UIInterfaceOrientationMaskAll;
 }
 else{
 //ipad allow only landscape
 return UIInterfaceOrientationMaskLandscape;
 }
 }
 
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
 {
 // Return YES for supported orientations
 return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
 }
 */

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
    
    //NSString *sectionTitle = [categorySectionTitles objectAtIndex:indexPath.section];
    NSDictionary *cat=[_selectedInventory.categories objectAtIndex:indexPath.section];
    NSArray *sectionProducts = [cat valueForKey:PRODUCTS_KEY]; //[_appDelegate.inventory objectForKey:sectionTitle];
    // NSString *product = [sectionProducts objectAtIndex:indexPath.row];
    OrderItem *currentItem=[sectionProducts objectAtIndex:indexPath.row];
    [order removeItemFromOrder:currentItem];
    [self updateOrderBoard];
    [self updateCurrentInventoryItem];
    [self updateInventoryButtons];
    
    UILabel* removeItemDisplay = [[UILabel alloc] initWithFrame:[_menuTableView frame]];
    [removeItemDisplay setCenter:[_menuTableView center]];
    [removeItemDisplay setText:@"-1"];
    [removeItemDisplay setTextAlignment:NSTextAlignmentCenter];
    [removeItemDisplay setTextColor:[UIColor redColor]];
    [removeItemDisplay setBackgroundColor:[UIColor clearColor]];
    [removeItemDisplay setFont:[UIFont boldSystemFontOfSize:32.0]];
    [[self view] addSubview:removeItemDisplay];
    
    [UIView animateWithDuration:1.0
                     animations:^{
                         [removeItemDisplay setCenter:[_menuTableView center]];
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
    
    NSDictionary *cat=[_selectedInventory.categories objectAtIndex:indexPath.section];
    NSArray *sectionProducts = [cat valueForKey:PRODUCTS_KEY];
    
    //NSString *sectionTitle = [categorySectionTitles objectAtIndex:indexPath.section];
    //NSArray *sectionProducts = [_appDelegate.inventory objectForKey:sectionTitle];
    // NSString *product = [sectionProducts objectAtIndex:indexPath.row];
    OrderItem *currentItem=[sectionProducts objectAtIndex:indexPath.row];
    
    
    
    [order addItemToOrder:currentItem];
    [self updateOrderBoard];
    //[self updateCurrentInventoryItem];
    //[self updateInventoryButtons];
    
    //UILabel* addItemDisplay = [[UILabel alloc] initWithFrame:[ibCurrentItemImageView frame]];
    UILabel* addItemDisplay = [[UILabel alloc] initWithFrame:[_menuTableView frame]];
    [addItemDisplay setText:@"+1"];
    [addItemDisplay setTextColor:[UIColor whiteColor]];
    [addItemDisplay setBackgroundColor:[UIColor clearColor]];
    [addItemDisplay setTextAlignment:NSTextAlignmentCenter];
    [addItemDisplay setFont:[UIFont boldSystemFontOfSize:32.0]];
    [[self view] addSubview:addItemDisplay];
    
    [UIView animateWithDuration:1.0
                     animations:^{
                         // [addItemDisplay setCenter:[ibChalkboardLabel center]];
                         [addItemDisplay setCenter:[_menuTableView center]];
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
    [_menuTableView reloadData];
}

- (IBAction)actionSubmitOrder:(id)sender {
    [self.delegate orderViewControllerDidFinish:self];
}
- (IBAction)cancelOrder:(id)sender {
    //[self dismissViewControllerAnimated:YES completion:nil];
    [self.delegate orderViewControllerWasCancelled:self];
}


#pragma mark Table
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    // if([tableView isEqual:_menuTableView])
    NSInteger count= [categorySectionTitles count];
    return count;//[categorySectionTitles count];
    //else
    //  return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    ProductCategory *cat=[_sortedCategories objectAtIndex:section];
    
    if (cat.expanded) {
        NSArray *sectionItems = [_selectedInventory allProductsWithCategoryID:cat.categoryID sorted:YES];
        NSInteger count= [sectionItems count];
        return count;
        
    }
    else{
        return 0;
        
    }
    
}
/*
 
 - (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
 {
 
 return ((ProductCategory *)[_sortedCategories objectAtIndex:section]).name;
 
 }
 */

/*
 -(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
 return [_inventoryModel.products count];
 }
 */

-(UITableViewCell *)menuCell:(NSIndexPath *)indexPath withProduct:(Product *)product{
    
    MenuCell *cell = [_menuTableView dequeueReusableCellWithIdentifier:@"MenuCell" forIndexPath:indexPath];
    if(cell==nil){
        cell=[[MenuCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MenuCell"];
    }
    
    //ProductCategory *cat=[_sortedCategories objectAtIndex:indexPath.section];
    
   // Product *product=[cat.sortedProducts objectAtIndex:indexPath.row];//[[Product alloc] initWithDictionary:[sectionProducts objectAtIndex:indexPath.row]];
    cell.nameLabel.text=product.name;
    /*
     cell.priceLabel.text=[Product priceToString:(double)product.price/100 currency:_appDelegate.selectedInventory.currencySymbol];
     */
    
    
    if(product.price==0)
        cell.priceLabel.text=@"FREE";
    else
        
        cell.priceLabel.text=[Util priceToString:(double)product.price/100 currency:_selectedInventory.currencySymbol];
    
    if (product.discount>0) {
        NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:[Util priceToString:(double)product.actualPrice/100 currency:_selectedInventory.currencySymbol]];
        [attributeString addAttribute:NSStrikethroughStyleAttributeName
                                value:@2
                                range:NSMakeRange(0, [attributeString length])];
        cell.actualPriceLabel.attributedText=attributeString;//[Product priceToString:(double)product.actualPrice/100]; //[NSString stringWithFormat:@"%.2f",(double)product.price/100];
        
        //cell.priceLabel.text=[Product priceToString:(double)product.price/100];//[NSString stringWithFormat:@"%.2f %@%% off",(double)product.price/100,product.discountToString];
    }
    else{
        cell.actualPriceLabel.text=nil;
    }
    
    // NSString *newPictureFile=[imageData MD5];
    if(product.stock_unlimited)
        cell.quantityLabel.text=@"";
    else{
        if (product.instock>0)
            cell.quantityLabel.text=[NSString stringWithFormat:@"%lu Left",(unsigned long)product.instock];
        else
            cell.quantityLabel.text=@"SOLD OUT";
    }
    
    if(product.pictureFile.length>0){
        [cell.productImage setImage:[UIImage imageNamed:@"empty_picture"]];
        
        NSString *filePath=[[AppDelegate getImagesPath] stringByAppendingPathComponent:product.pictureFile];
        //check if cached
        if([[NSFileManager defaultManager] fileExistsAtPath:filePath])
            cell.productImage.image=[[UIImage alloc] initWithContentsOfFile:filePath];
        
    }
    else{
        cell.productImage.image=nil;
    }
    
    cell.productImage.layer.cornerRadius=cell.productImage.frame.size.width / 4;
    cell.productImage.clipsToBounds = YES;
    
    UIImage *background = [self cellBackgroundForRowAtIndexPath:indexPath];
    
    
    UIImageView *cellBackgroundView = [[UIImageView alloc] initWithImage:background];
    cellBackgroundView.image = background;
    cell.backgroundView = cellBackgroundView;
    return cell;
}

-(UITableViewCell *)menuNoImageCell:(NSIndexPath *)indexPath withProduct:(Product *)product{
    
    MenuNoImageCell *cell = [_menuTableView dequeueReusableCellWithIdentifier:@"MenuNoImageCell" forIndexPath:indexPath];
    if(cell==nil){
        cell=[[MenuNoImageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MenuNoImageCell"];
    }
    
    //ProductCategory *cat=[_sortedCategories objectAtIndex:indexPath.section];
    
    // Product *product=[cat.sortedProducts objectAtIndex:indexPath.row];//[[Product alloc] initWithDictionary:[sectionProducts objectAtIndex:indexPath.row]];
    cell.nameLabel.text=product.name;
    /*
     cell.priceLabel.text=[Product priceToString:(double)product.price/100 currency:_appDelegate.selectedInventory.currencySymbol];
     */
    
    
    if(product.price==0)
        cell.priceLabel.text=@"FREE";
    else
        
        cell.priceLabel.text=[Util priceToString:(double)product.price/100 currency:_selectedInventory.currencySymbol];
    
    if (product.discount>0) {
        NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:[Util priceToString:(double)product.actualPrice/100 currency:_selectedInventory.currencySymbol]];
        [attributeString addAttribute:NSStrikethroughStyleAttributeName
                                value:@2
                                range:NSMakeRange(0, [attributeString length])];
        cell.actualPriceLabel.attributedText=attributeString;//[Product priceToString:(double)product.actualPrice/100]; //[NSString stringWithFormat:@"%.2f",(double)product.price/100];
        
        //cell.priceLabel.text=[Product priceToString:(double)product.price/100];//[NSString stringWithFormat:@"%.2f %@%% off",(double)product.price/100,product.discountToString];
    }
    else{
        cell.actualPriceLabel.text=nil;
    }
    
    // NSString *newPictureFile=[imageData MD5];
    if(product.stock_unlimited)
        cell.quantityLabel.text=@"";
    else{
        if (product.instock>0)
            cell.quantityLabel.text=[NSString stringWithFormat:@"%lu Left",(unsigned long)product.instock];
        else
            cell.quantityLabel.text=@"SOLD OUT";
    }
    /*
    if(product.pictureFile.length>0){
        [cell.productImage setImage:[UIImage imageNamed:@"empty_picture"]];
        
        NSString *filePath=[[AppDelegate getImagesPath] stringByAppendingPathComponent:product.pictureFile];
        //check if cached
        if([[NSFileManager defaultManager] fileExistsAtPath:filePath])
            cell.productImage.image=[[UIImage alloc] initWithContentsOfFile:filePath];
        
    }
    else{
        cell.productImage.image=nil;
    }
    
    cell.productImage.layer.cornerRadius=cell.productImage.frame.size.width / 4;
    cell.productImage.clipsToBounds = YES;
    */
    UIImage *background = [self cellBackgroundForRowAtIndexPath:indexPath];
    
    
    UIImageView *cellBackgroundView = [[UIImageView alloc] initWithImage:background];
    cellBackgroundView.image = background;
    cell.backgroundView = cellBackgroundView;
    return cell;
}

-(UITableViewCell *)menuNoSellCell:(NSIndexPath *)indexPath withProduct:(Product *)product{
    MenuNoSellCell *cell = [_menuTableView dequeueReusableCellWithIdentifier:@"MenuNoSellCell" forIndexPath:indexPath];
    if(cell==nil){
        cell=[[MenuNoSellCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MenuNoSellCell"];
    }
    
    //ProductCategory *cat=[_sortedCategories objectAtIndex:indexPath.section];
    
    //Product *product=[cat.sortedProducts objectAtIndex:indexPath.row];//[[Product alloc] initWithDictionary:[sectionProducts objectAtIndex:indexPath.row]];
    cell.nameLabel.text=product.name;
    cell.prodDetailLabel.text=product.detail;
    //cell.priceLabel.text=[NSString stringWithFormat:@"$%.02f",(double)product.price/100];
    // NSString *newPictureFile=[imageData MD5];
    
    if(product.pictureFile.length>0){
        [cell.productImage setImage:[UIImage imageNamed:@"empty_picture"]];
        
        NSString *filePath=[[AppDelegate getImagesPath] stringByAppendingPathComponent:product.pictureFile];
        //check if cached
        if([[NSFileManager defaultManager] fileExistsAtPath:filePath])
            cell.productImage.image=[[UIImage alloc] initWithContentsOfFile:filePath];
        
    }
    else{
        cell.productImage.image=nil;
    }
    
    cell.productImage.layer.cornerRadius=cell.productImage.frame.size.width / 4;
    cell.productImage.clipsToBounds = YES;
    
    UIImage *background = [self cellBackgroundForRowAtIndexPath:indexPath];
    
    UIImageView *cellBackgroundView = [[UIImageView alloc] initWithImage:background];
    cellBackgroundView.image = background;
    cell.backgroundView = cellBackgroundView;
    return cell;
}

-(UITableViewCell *)menuNoSellNoImageCell:(NSIndexPath *)indexPath withProduct:(Product *)product{
    MenuNoSellNoImageCell *cell = [_menuTableView dequeueReusableCellWithIdentifier:@"MenuNoSellNoImageCell" forIndexPath:indexPath];
    if(cell==nil){
        cell=[[MenuNoSellNoImageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MenuNoSellNoImageCell"];
    }
    
    //ProductCategory *cat=[_sortedCategories objectAtIndex:indexPath.section];
    
    //Product *product=[cat.sortedProducts objectAtIndex:indexPath.row];//[[Product alloc] initWithDictionary:[sectionProducts objectAtIndex:indexPath.row]];
    cell.nameLabel.text=product.name;
    cell.prodDetailLabel.text=product.detail;
    //cell.priceLabel.text=[NSString stringWithFormat:@"$%.02f",(double)product.price/100];
    // NSString *newPictureFile=[imageData MD5];
    /*
    if(product.pictureFile.length>0){
        [cell.productImage setImage:[UIImage imageNamed:@"empty_picture"]];
        
        NSString *filePath=[[AppDelegate getImagesPath] stringByAppendingPathComponent:product.pictureFile];
        //check if cached
        if([[NSFileManager defaultManager] fileExistsAtPath:filePath])
            cell.productImage.image=[[UIImage alloc] initWithContentsOfFile:filePath];
        
    }
    else{
        cell.productImage.image=nil;
    }
    
    cell.productImage.layer.cornerRadius=cell.productImage.frame.size.width / 4;
    cell.productImage.clipsToBounds = YES;
    */
    UIImage *background = [self cellBackgroundForRowAtIndexPath:indexPath];
    
    UIImageView *cellBackgroundView = [[UIImageView alloc] initWithImage:background];
    cellBackgroundView.image = background;
    cell.backgroundView = cellBackgroundView;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        return 90.0;
    }
    else{
        return 60.0;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    ProductCategory *pc=[_sortedCategories objectAtIndex:section];
    
    
    bool hasImage=NO;
    NSString *filePath=nil;
    if(pc.pictureFile){
        filePath=[[AppDelegate getImagesPath] stringByAppendingPathComponent:pc.pictureFile];
        if([[NSFileManager defaultManager] fileExistsAtPath:filePath])
            hasImage=YES;
    }
    
    if(hasImage){
        
        MenuSectionCell *cell=[tableView dequeueReusableCellWithIdentifier:@"MenuSectionCell"];
        
        //check if cached
        cell.sectionImageView.image=[[UIImage alloc] initWithContentsOfFile:filePath];
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
            //cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
            [cell.expandButton setImage:[UIImage imageNamed:@"expand_arrow"] forState:UIControlStateNormal];
            
            
        }
        else{
            [cell.expandButton setImage:[UIImage imageNamed:@"collapse_arrow"] forState:UIControlStateNormal];
            
        }
        /*
         [cell.expandButton addTarget:self action:@selector(expandAction:) forControlEvents:UIControlEventTouchUpInside];
         cell.expandButton.tag=section;
         */
        UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(expandGesture:)];
        
        [cell addGestureRecognizer:tap];
        cell.tag=section;
        
        cell.backgroundColor=[UIColor whiteColor];
        return cell;
        
        
    }
    else{
        MenuSectionNoImageCell *cell=[tableView dequeueReusableCellWithIdentifier:@"MenuSectionNoImageCell"];
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
            //cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
            [cell.expandButton setImage:[UIImage imageNamed:@"expand_arrow"] forState:UIControlStateNormal];
            
            
        }
        else{
            [cell.expandButton setImage:[UIImage imageNamed:@"collapse_arrow"] forState:UIControlStateNormal];
            
        }
        /*
         [cell.expandButton addTarget:self action:@selector(expandAction:) forControlEvents:UIControlEventTouchUpInside];
         cell.expandButton.tag=section;
         */
        
        UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(expandGesture:)];
        
        [cell addGestureRecognizer:tap];
        cell.tag=section;
        
        
        cell.backgroundColor=[UIColor whiteColor];
        return cell;
        
    }
    
}

- (UIImage *)cellBackgroundForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger rowCount = [self tableView:[self menuTableView] numberOfRowsInSection:0];
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


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ProductCategory *cat=[_sortedCategories objectAtIndex:indexPath.section];
    
    Product *product=[cat.sortedProducts objectAtIndex:indexPath.row];
    
    if(_selectedInventory.isEcommerce){
        if(product.pictureFile!=nil && product.pictureFile.length>0){
            return [self menuCell:indexPath withProduct:product];
        }
        else{
            return [self menuNoImageCell:indexPath withProduct:product];
        }
    }
    else{
        if(product.pictureFile!=nil && product.pictureFile.length>0){
            return [self menuNoSellCell:indexPath withProduct:product];
        }
        else{
            return [self menuNoSellNoImageCell:indexPath withProduct:product];
        }
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //if([tableView isEqual:_menuTableView]){
    //self.selectedIndexPath = indexPath;
    _selectedCategory=[_sortedCategories objectAtIndex:indexPath.section];
    
    _selectedProduct=[_selectedCategory.sortedProducts objectAtIndex:indexPath.row];
    
    // [_menuTableView deselectRowAtIndexPath:indexPath animated:YES];
    
    /*if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
     [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_SHOW_PRODUCT object:nil userInfo:@{KEY_SELECTED_INVENTORY:_selectedInventory,KEY_SELECTED_CATEGORY:_selectedCategory,KEY_SELECTED_PRODUCT:selectedProduct}];
     }
     else{
     */
    //[self performSegueWithIdentifier:@"toProductViewController" sender:nil];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_SHOW_MENU_PRODUCT object:nil userInfo:@{@"product":_selectedProduct,@"category":_selectedCategory}];
    
    //}
    
    /* }
     else{
     
     OrderItem *orderItem=[[order orderItems] objectAtIndex:indexPath.row];
     [order removeItemFromOrder:orderItem];
     
     UILabel* addItemDisplay = [[UILabel alloc] initWithFrame:[_orderTableView frame]];
     [addItemDisplay setText:@"+1"];
     [addItemDisplay setTextColor:[UIColor whiteColor]];
     [addItemDisplay setBackgroundColor:[UIColor clearColor]];
     [addItemDisplay setTextAlignment:NSTextAlignmentCenter];
     [addItemDisplay setFont:[UIFont boldSystemFontOfSize:32.0]];
     [[self view] addSubview:addItemDisplay];
     
     [UIView animateWithDuration:1.0
     animations:^{
     [addItemDisplay setCenter:[_menuTableView center]];
     [addItemDisplay setAlpha:0.0];
     } completion:^(BOOL finished) {
     [addItemDisplay removeFromSuperview];
     }];
     [_orderTableView reloadData];
     }
     */
    
}

#pragma mark - UIStoryboard methods

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"toProductViewController"]){
        ProductViewController* viewController = (ProductViewController*) segue.destinationViewController;
        
        
        
        viewController.selectedProduct= _selectedProduct;
    }
    else{
        
    }
}

-(void)didReceiveUpdateProducts{
    //_inventoryModel =ApplicationDelegate.activeInventory;
    //if(_inventoryModel==nil)
    //  _inventoryModel =ApplicationDelegate.activeInventory;
    //[_inventoryModel loadInventory];
    [self reloadMenu];
}

-(void)reloadMenu{
    _selectedInventory=[InventoryModel activeInventory];
    
    if(_sortedCategories==nil)
        _sortedCategories = [[NSMutableArray alloc] init];
    if([_sortedCategories count]>0)
        [_sortedCategories removeAllObjects];
    
    if(categorySectionTitles==nil)
        categorySectionTitles= [[NSMutableArray alloc] init];
    if([categorySectionTitles count]>0)
        [categorySectionTitles removeAllObjects];
    
    NSArray *allSortedCategories=[_selectedInventory.categories sortedArrayUsingDescriptors:descriptors];
    /*
     if(_searchTextField.text.length>0){
     NSArray *results=[_selectedInventory searchProducts:_searchTextField.text];
     if([results count]>0){
     for(Product *p in results){
     ProductCategory *pc=[_selectedInventory searchCategoryWithID:p.categoryID];
     if(pc!=nil){
     
     if([_sortedCategories containsObject:pc]){
     
     }
     
     }
     }
     
     }
     
     }
     
     else{
     */
    
    for (ProductCategory *pc in allSortedCategories) {
        pc.sortedProducts=[_selectedInventory allProductsWithCategoryID:pc.categoryID sorted:YES];
        if(pc.sortedProducts!=nil && [pc.sortedProducts count]>0){
            [_sortedCategories addObject:pc];
            
            //check if total product<100 then we expand it
            if([_selectedInventory.products count]<100){
                pc.expanded=YES;
            }
        }
        
    }
    
    
    [categorySectionTitles addObjectsFromArray: [_sortedCategories valueForKey:NAME_KEY]];
    
    
    //        if(categorySectionTitles==nil)
    //            categorySectionTitles= [[NSMutableArray alloc] init];
    
    
    /*
     if(categorySectionTitles.count==0){
     [_menuTableView setHidden:YES];
     
     }
     else{
     
     [_menuTableView reloadData];
     [_menuTableView setHidden:NO];
     }
     */
    //}
    [_menuTableView reloadData];
    
    if ([_sortedCategories count]==0) {
        //[self.menuTableView setHidden:YES];
        //[self showAddCategory ];
        //UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Empty menu" message:@"Add item(s) to your Menu now?" delegate:self cancelButtonTitle:@"Later" otherButtonTitles:@"Yes", nil];
        /*UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Menu is empty" message:@"Tap Inventory to add items" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
         [alert show];
         */
        
        [AppDelegate toast:@"Menu is emtpy. Tap Inventory to add items." duration:3.0];
    }
    else{
        
        //[self.menuTableView setHidden:NO];
    }
}
/*
 -(void)expandAction:(id)sender{
 UIButton *button=(UIButton *)sender;
 NSUInteger section=button.tag;
 ProductCategory *pc=[_sortedCategories objectAtIndex:section];
 
 if(pc.expanded){
 pc.expanded=NO;
 }
 else{
 pc.expanded=YES;
 }
 [_menuTableView reloadData];
 }
 */

-(void)expandGesture:(UITapGestureRecognizer *)sender{
    //UIButton *button=(UIButton *)sender;
    
    NSUInteger section=sender.view.tag;//button.tag;
    ProductCategory *pc=[_sortedCategories objectAtIndex:section];//[_sortedCategories objectAtIndex:section];
    
    if(pc.expanded){
        pc.expanded=NO;
    }
    else{
        pc.expanded=YES;
    }
    [_menuTableView reloadData];
}




-(IBAction)showChatAction:(id)sender{
    /*
     if(_appDelegate.isIpad){
     if(_popOver==nil){
     ChatViewController *vc=[_appDelegate.storyBoard instantiateViewControllerWithIdentifier:@"ChatViewController"];
     UINavigationController* chatNav = [[UINavigationController alloc] initWithRootViewController:vc];
     _popOver=[[UIPopoverController alloc] initWithContentViewController:chatNav];
     //_chatPopover.popoverContentSize=CGSizeMake(self.view.frame.size.width/2, self.view.frame.size.height);
     _popOver.popoverContentSize=CGSizeMake(320.0, self.view.frame.size.height);
     [_popOver presentPopoverFromBarButtonItem:chatBadgeBarButton
     //chatButtonItem
     permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
     }
     else{
     [_popOver dismissPopoverAnimated:YES];
     _popOver=nil;
     }
     }
     else{
     [self performSegueWithIdentifier:@"toChatViewController" sender:self];
     }
     */
}


-(void)loadBgPhoto{
    
    
    //NSString *peer_bgphoto=[NSString stringWithFormat:@"%@%@.png",PREFIX_MYBGPHOTO, _appDelegate.mcManager.myPeerInfo.deviceID];
    NSString *peer_bgphoto=[NSString stringWithFormat:@"%@%@.png",PREFIX_MYBGPHOTO, _appDelegate.appConfig.device_id];
    
    
    NSString *filePath=[[AppDelegate getDocumentsPath] stringByAppendingPathComponent:peer_bgphoto];
    
    
    
    //check if cached
    if([[NSFileManager defaultManager] fileExistsAtPath:filePath]){
        
        self.wallImage.image=[[UIImage alloc] initWithContentsOfFile:filePath];
    }
}

#pragma mark -
#pragma mark Search
/*
 -(void)searchProductWithBarcode:(NSString *)barcode{
 
 //[Product ]
 [_selectedInventory searchProduct:<#(NSUInteger)#>]
 
 selectedProduct=[_selectedCategory.sortedProducts objectAtIndex:indexPath.row];
 
 // [_menuTableView deselectRowAtIndexPath:indexPath animated:YES];
 
 
 [self performSegueWithIdentifier:@"toProductViewController" sender:nil];
 
 }
 */


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
    
    NSArray *results=[_selectedInventory searchProductsWithBarcode:barcode];
    NSUInteger count=[results count];
    if(count>0){
        if(count==1){
            _selectedProduct=[results firstObject];
            if(_appDelegate.appConfig.barcodeAutoAddToCart) {
                //create an orderitem from product the add to cart
                OrderItem *orderItem=[[OrderItem alloc] initWithProduct:_selectedProduct isLive:_appDelegate.appConfig.isLive withStoreID:_appDelegate.appConfig.device_id];
                if(_checkoutCart==nil)
                    _checkoutCart=[CheckoutCart sharedInstance];
                [_checkoutCart addItem:orderItem];
                
            }
            else{
                //[self performSegueWithIdentifier:@"toProductViewController" sender:nil];
                 [self showSelectedProduct];
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
       // [self performSegueWithIdentifier:@"toProductViewController" sender:nil];
          [self showSelectedProduct];
    }];
    
}

-(void)searchMenuViewControllerWasCancelled:(SearchMenuViewController *)controller{
    [controller dismissViewControllerAnimated:YES completion:^{[self.view endEditing:YES];}];
}

-(void)selectOneViewControllerItemSelected:(SelectOneViewController *)controller item:(Product *)item{
    _selectedProduct=item;
    [controller dismissViewControllerAnimated:YES completion:^{
        [self.view endEditing:YES];
        [self showSelectedProduct];
        
    }];
     
    
}

-(void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{
    if(buttonIndex<0)
        return;
    NSString *buttonTitle=[actionSheet buttonTitleAtIndex:buttonIndex];
    if([buttonTitle isEqualToString:TITLE_INVENTORY]){
        [self showInventoryAction:nil];
    }
    else if([buttonTitle isEqualToString:TITLE_SETTINGS]){
        [self showSettingsAction:nil];
    }
    else if([buttonTitle isEqualToString:TITLE_LOCK]){
        [self lockButtonTapped:nil];
    }
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

-(void)showSelectedProduct{
    //[self performSegueWithIdentifier:@"toProductViewController" sender:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_SHOW_PRODUCT object:_selectedProduct];
}




-(void)showInventoryAction:(id)sender{
    //[self performSegueWithIdentifier:@"toInventoryListViewController" sender:self];
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_SHOW_INVENTORY_LIST object:nil];
}

-(void)showSettingsAction:(id)sender{
    // [self performSegueWithIdentifier:@"toAppSettingsViewController" sender:self];
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_SHOW_SETTINGS object:nil];
}


-(void)showThumbView{
    // [self performSegueWithIdentifier:@"toAppSettingsViewController" sender:self];
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_SHOW_MENU_COLLECTION object:nil];
}

-(IBAction)lockButtonTapped:(id)sender{
    /*UIAlertView *alert;
     if(_appDelegate.appConfig.user_pin.length==0){
     alert=[[UIAlertView alloc] initWithTitle:@"PIN is not set" message:@"Enter new PIN" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Set PIN", nil];
     alert.alertViewStyle = UIAlertViewStylePlainTextInput;
     }
     else{
     alert=[[UIAlertView alloc] initWithTitle:@"Device Locked" message:@"Enter PIN" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Unlock", nil];
     alert.alertViewStyle = UIAlertViewStylePlainTextInput;
     }
     _appDelegate.appConfig.user_usepin=YES;
     [AppConfigModel saveSettings];
     [alert show];
     */
    [_appDelegate lockDevice];
}


- (IBAction)searchAction:(id)sender{
    
    SearchMenuViewController *vc=[_appDelegate.storyBoard instantiateViewControllerWithIdentifier:@"SearchMenuViewController"];
    vc.delegate=self;
    //vc.searchText=_searchTextField.text;
    vc.selectedInventory=_selectedInventory;
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


@end
