//
//  IODViewController.m
//  iOSDiner
//
//  Created by Romulo Quidilig on 3/19/15.
//  Copyright (c) 2015 Sharecle Inc. All rights reserved.
//

#import "SidebarViewController.h"

#import "OrderItem.h"     // <---- #1
#import "Order.h"     // <---- #1
#import "Product.h"
//#import "OrderItem.h"
#import "CheckoutCart.h"
#import "ProductViewController.h"
#import "BroadcastMessageAPI.h"
#import "MessageNBCell.h"
#import "MessageTableViewData.h"
#import "SWRevealViewController.h"
#import "OrderViewController.h"
#import "defs.h"



@implementation SidebarViewController
{
    NSArray *categorySectionTitles;
    UIImage *_myPhoto;
    
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
    
    _appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    /*SWRevealViewController *revealViewController = self.revealViewController;
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
                                             selector:@selector(didCartChagedNotification:)
                                                 name:NOTIFY_CART_CHANGED
                                               object:nil];
    
  /*  [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didUpdateMessagesNotification:)
                                                 name:NOTIFY_UPDATE_MESSAGES
                                               object:nil];*/
    /*_orderTableView.dataSource=self;
     _orderTableView.delegate=self;
     _orderTableView.backgroundColor=[UIColor clearColor];
     */
    //self.chatTableView.backgroundColor=[UIColor clearColor];
    //self.menuTableView.backgroundColor=[UIColor clearColor];
    
    currentItemIndex = 0;     // <---- #3
    [self setOrder:[Order new]];     // <---- #4
    
    queue = dispatch_queue_create("com.sharecle.kiosk",nil); // <======
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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    
    if(_appDelegate.mcManager.serverPeerInfo==nil)
        return;
    NSMutableDictionary *request_dict=[[NSMutableDictionary alloc] init];
    
    //[self configurePickerView];
    
    [request_dict setValue:KEY_ACTION_INVENTORY forKey:KEY_ACTION];
    
    [request_dict setValue:KEY_ACTION_TYPE_REQUEST forKey:KEY_ACTION_TYPE];
    
    
    
    NSError *error;
    
    NSData *jsonData=[NSJSONSerialization dataWithJSONObject:request_dict options:NSJSONWritingPrettyPrinted error:&error];
    
    
    NSString *text=[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    /*
     #ifdef DEBUG
     NSLog(@"send=%@",text);
     #endif
     */
    BroadcastMessageAPI *message=[[BroadcastMessageAPI alloc] init];
    message.text=text;
    message.isBroadcast=NO;
    message.toPeerInfo=_appDelegate.mcManager.serverPeerInfo;
    message.message_type=MSG_TYPE_REQUEST;
    message.localCopy=NO;
    
    NSDictionary *dict = @{KEY_SEND_MESSAGE: message
                           };
    
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_HAS_DATA_TO_SEND
                                                        object:nil
                                                      userInfo:dict];
    
    
    
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

-(NSUInteger)supportedInterfaceOrientations{
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
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    
    if([tableView isEqual:self.tableView])
        return [categorySectionTitles count];
    else
        //return 0;
        return _appDelegate.messages.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if([tableView isEqual:self.tableView]){
        NSString *sectionTitle = [categorySectionTitles objectAtIndex:section];
        NSArray *sectionItems = [_appDelegate.inventory objectForKey:sectionTitle];
        return [sectionItems count];
    }
    else{
        return 1;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if([tableView isEqual:self.tableView])
        return [categorySectionTitles objectAtIndex:section];
    else
        return nil;//@"Order";
}
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
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"menu_cell" forIndexPath:indexPath];
    if(cell==nil){
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"menu_cell"];
    }
    // Configure the cell...
    NSString *sectionTitle = [categorySectionTitles objectAtIndex:indexPath.section];
    NSArray *sectionProducts = [_appDelegate.inventory objectForKey:sectionTitle];
    // NSString *product = [sectionProducts objectAtIndex:indexPath.row];
    //Product *product=[sectionProducts objectAtIndex:indexPath.row];
    Product *product=[[Product alloc] initWithDictionary:[sectionProducts objectAtIndex:indexPath.row]];
    cell.textLabel.text=product.name;
    cell.detailTextLabel.text=[NSString stringWithFormat:@"%.02f",product.price];
    
    // NSString *newPictureFile=[imageData MD5];
    
    if(product.pictureFile.length>0){
        //TODO: change to loading image
        [cell.imageView setImage:[UIImage imageNamed:@"empty_picture"]];
        NSString *filePath=[[AppDelegate getImagesPath] stringByAppendingPathComponent:product.pictureFile];
        //check if cached
        if([[NSFileManager defaultManager] fileExistsAtPath:filePath])
            cell.imageView.image=[[UIImage alloc] initWithContentsOfFile:filePath];
        else{
            //TODO
            /* this is only good for http connection, we need BT connection
             dispatch_async(dispatch_get_main_queue(), ^{
             NSURL *url=[[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@images/%@",_appDelegate.mcManager.serverPeerInfo.homeUrl,product.pictureFile]];
             NSData *imageData=[[NSData alloc] initWithContentsOfURL:url];
             if (imageData!=nil) {
             // UIImage *image=[[UIImage alloc] initWithData:imageData];
             cell.imageView.image=[[UIImage alloc] initWithData:imageData];
             // cell.imageView.layer.cornerRadius=cell.imageView.frame.size.width / 2;
             //cell.imageView.clipsToBounds = YES;
             
             }
             
             
             });
             */
            // this is for BT connection but it may be very slow
            //TODO: implement compression
            dispatch_async(dispatch_get_main_queue(), ^{
                NSString *serverPath=[NSString stringWithFormat:@"images/%@",product.pictureFile];
                
                BroadcastMessageAPI *message=[[BroadcastMessageAPI alloc] init];
                message.text=serverPath;
                message.isBroadcast=NO;
                message.toPeerInfo=_appDelegate.mcManager.serverPeerInfo;
                message.message_type=MSG_TYPE_REQUEST_FILE_DOWNLOAD;
                message.localCopy=NO;
                
                NSDictionary *dict = @{KEY_SEND_MESSAGE: message
                                       };
                
                [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_HAS_DATA_TO_SEND
                 
                 
                 
                                                                    object:nil
                                                                  userInfo:dict];
                
                
                
            });
            
        }
    }
    
    return cell;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
   
        return [self menuCell:indexPath];
    
    
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   
        self.selectedIndexPath = indexPath;
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
        
        [self performSegueWithIdentifier:@"toProductViewController" sender:nil];
        
       
    
    
    
}

#pragma mark - UIStoryboard methods

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"toProductViewController"]){
        /*
         PaymentViewController *paymentViewController = [[PaymentViewController alloc] initWithNibName:nil bundle:nil];
         paymentViewController.amount = [NSDecimalNumber decimalNumberWithString:@"10.00"];
         //paymentViewController.backendCharger = self;
         paymentViewController.delegate = self;
         UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:paymentViewController];
         [self presentViewController:navController animated:YES completion:nil];
         */
       

        //ProductViewController* viewController = (ProductViewController*) segue.destinationViewController;
        //ProductViewController* productController = [[ProductViewController alloc] initWithNibName:nil bundle:nil];
        
        NSString *sectionTitle = [categorySectionTitles objectAtIndex:_selectedIndexPath.section];
        NSArray *sectionProducts = [_appDelegate.inventory objectForKey:sectionTitle];
        
        Product *product= [[Product alloc] initWithDictionary:[sectionProducts objectAtIndex:_selectedIndexPath.row]];
        
        
        
        UINavigationController *navController = segue.destinationViewController;//
        ProductViewController* productController=[navController.viewControllers firstObject];
        productController.product = [[OrderItem alloc] initWithProduct:product];

        
    }
    else if([segue.identifier isEqualToString:@"toOrderViewContoller"]){
        UINavigationController *navController = segue.destinationViewController;//
        OrderViewController* destController=[navController.viewControllers firstObject];
        destController.continueShopping =YES;
    }
}

-(void)didReceiveMenuWithNotification:(NSNotification *)notification{
    categorySectionTitles=[_appDelegate.inventory allKeys];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
    
}

-(void)didCartChagedNotification:(NSNotification *)notification{
    categorySectionTitles=[_appDelegate.inventory allKeys];
    dispatch_async(dispatch_get_main_queue(), ^{
        //[self.tableView reloadData];
        if(self.menuViewController){
            [self.menuViewController dismissViewControllerAnimated:YES completion:^{
                [self performSegueWithIdentifier:@"toOrderViewContoller" sender:self];
            }];
        }
        else{
            [self performSegueWithIdentifier:@"toOrderViewContoller" sender:self];
        }
    });
    
}



@end
