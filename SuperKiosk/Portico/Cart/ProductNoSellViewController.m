//
//  ProductViewController.m


#import "ProductNoSellViewController.h"
#import "CheckoutCart.h"
#import "defs.h"
#import "BroadcastMessageAPI.h"
#import "OrderItem.h"
#import "ProductPriceCell.h"
#import "ProductCartCell.h"
#import "ProductImageCell.h"
#import "ProductTitleCell.h"
#import "ProductDescriptionCell.h"

//#import "AFNetworking.h"
//#define MaxNotesLength 300
#define MaxQuantityLength 6
//#define PlaceHolderText  @"Your notes here"
@interface ProductNoSellViewController ()
{
    NSString *imagesPath;
    NSString *documentPath;
    //CheckoutCart* checkoutCart;
    //OrderItem *orderItem;
    BOOL bannerIsVisible;
    UIToolbar *pickerToolbar;
}

@property (strong, nonatomic) IBOutlet UITableView* tableView;

@property (strong, nonatomic) IBOutlet UILabel *productNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *productDescLable;
@property (weak, nonatomic) IBOutlet UILabel *txtDescription;

@property (strong, nonatomic) IBOutlet UIImageView *productImageView;
//@property (strong, nonatomic) IBOutlet UILabel *priceLabel;
//@property (strong, nonatomic) IBOutlet UIButton *addToCartButton;
//@property (strong, nonatomic) IBOutlet UITextField *quantityText;


//@property (strong, nonatomic) IBOutlet UIView *addCartView;
//@property (strong, nonatomic) IBOutlet UILabel *soldoutLabel;
//@property (strong, nonatomic) IBOutlet UITextView *notesText;

//@property (strong, nonatomic) IBOutlet UIImageView *wallImage;


//- (IBAction)addToCartButtonTapped:(id)sender;

@end

@implementation ProductNoSellViewController
/*
+ (Product *)sharedProductInstance {
    static Product*  _sharedProduct;
    
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        _sharedProduct = [[Product alloc] init];
    });
    
    return _sharedProduct;
}
*/
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor=[UIColor clearColor];
    
    _appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    documentPath= [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    
    
    
    
    imagesPath=[AppDelegate getImagesPathForServer:_appDelegate.selectedStore.peerInfo.deviceID];
    
    
    /*[[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didReceivePeerBgPhotoNotification:)
                                                 name:NOTIFY_RECEIVED_PEER_BGPHOTO2
                                               object:nil];*/
    
    /*
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didReceiveMenuWithNotification:)
                                                 name:NOTIFY_RECEIVED_MENU
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didReceiveMenuWithNotification:)
                                                 name:NOTIFY_RECEIVED_MENU_UPDATE
                                               object:nil];
    
    
    checkoutCart=[CheckoutCart sharedInstance];
    
    checkoutCart.currentStoreID=_appDelegate.selectedStore.peerInfo.deviceID;
    */
    if(self.selectedProduct==nil){
        self.selectedProductID=0;
        [self.tableView setHidden:YES];
    }
    else{
        self.selectedProductID=self.selectedProduct.productID;
       // orderItem=[[OrderItem alloc] initWithProduct:self.selectedProduct isLive:_appDelegate.appConfig.isLive withStoreID:_appDelegate.selectedStore.peerInfo.deviceID];
    }
    
    
    //[self.tableView setBackgroundColor:[UIColor clearColor]];
    
    pickerToolbar = [[UIToolbar alloc] init];
    pickerToolbar.barStyle = UIBarStyleDefault;
    [pickerToolbar sizeToFit];
    
    UIBarButtonItem *flexibleSpaceLeft = [[UIBarButtonItem alloc]
                                          initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                          target:nil
                                          action:nil];
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                   style:UIBarButtonItemStyleBordered
                                                                  target:self
                                                                  action:@selector(pickerDoneButtonPressed)];
    
    [pickerToolbar setItems:[NSArray arrayWithObjects:flexibleSpaceLeft, doneButton, nil]];
    
    
    
    
    //self.selectedProduct.detail=@"Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Nam liber te conscient to factor tum poen legum odioque civiuda.";
    // [self loadData];
    
    
    // self.addToCartButton=cell.addToCartButton;
    /*
     self.quantityText.delegate=self;
     self.notesText.delegate=self;
     
     [[self.notesText layer] setBorderColor:[[[UIColor grayColor] colorWithAlphaComponent:0.5] CGColor]];
     [[self.notesText layer] setBorderWidth:1.0];//setBorderWidth:2.3];
     [[self.notesText layer] setCornerRadius:2];
     self.quantityText.text=[NSString stringWithFormat:@"%lu",(unsigned long)self.selectedProduct.minQuantity ];
     
     
     if([checkoutCart containsItem:orderItem]){
     orderItem=[checkoutCart getItem:orderItem.productID];
     self.quantityText.text=[NSString stringWithFormat:@"%ld", (long)orderItem.quantity];
     [self.quantityText setEnabled:NO];
     [self.addToCartButton setTitle:@"Remove from cart" forState:UIControlStateNormal];
     self.addToCartButton.selected=NO;
     self.notesText.text=orderItem.notes;
     if(self.notesText.text.length==0)
     //self.notesText.text=@"Your notes here";
     [self textViewPlaceHolder:self.notesText text:PlaceHolderText];
     }
     else{
     self.quantityText.text=nil;
     [self.quantityText setEnabled:YES];
     self.addToCartButton.selected=YES;
     [self textViewPlaceHolder:self.notesText text:PlaceHolderText];
     }
     
     self.priceLabel.text=[NSString stringWithFormat:@"@%0.02f",(double)self.selectedProduct.price/100];
     
     
     if(self.selectedProduct.stock_unlimited){
     
     self.soldoutLabel.text=@"";
     
     }
     else{
     
     
     
     if(self.selectedProduct.instock>0){
     
     [self.addCartView setHidden:NO];
     
     self.soldoutLabel.text=[NSString stringWithFormat:@"%lu left",(unsigned long)self.selectedProduct.instock];
     
     
     }
     else{
     
     self.soldoutLabel.text=@"SOLD OUT";
     
     }
     }
     */
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppearEcommerce{
    /*
     if(self.selectedProduct.stock_unlimited){
     
     [self.addCartView setHidden:NO];
     self.soldoutLabel.text=@"";
     //  checkoutCart = [CheckoutCart sharedInstance];
     //item=[[OrderItem alloc] initWithProduct:self.selectedProduct];
     
     self.addToCartButton.selected = [checkoutCart containsItem:orderItem] ? YES : NO;
     }
     else{
     
     
     
     if(self.selectedProduct.instock>0){
     
     [self.addCartView setHidden:NO];
     
     self.soldoutLabel.text=[NSString stringWithFormat:@"%lu left",(unsigned long)self.selectedProduct.instock];
     
     //checkoutCart = [CheckoutCart sharedInstance];
     // item=[[OrderItem alloc] initWithProduct:self.selectedProduct];
     
     self.addToCartButton.selected = [checkoutCart containsItem:orderItem] ? YES : NO;
     }
     else{
     
     self.soldoutLabel.text=@"SOLD OUT";
     [self.addCartView setHidden:YES];
     }
     }
     */
    
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    /*if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        self.navigationItem.hidesBackButton=YES;
        
    }
     */
    [self reloadData];
}
//
//- (NSString*)getImagesPath
//{
//    //NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    //NSString* documentsDirectory = paths[0];
//    NSError *error;
//    BOOL isDirectory=YES;
//    NSString *directory=[documentPath stringByAppendingPathComponent:@"images"];
//    if([[NSFileManager defaultManager] fileExistsAtPath:directory]==NO){
//        [[NSFileManager defaultManager] createDirectoryAtPath:directory withIntermediateDirectories:NO attributes:nil error:&error];
//    }
//    if(![[NSFileManager defaultManager] fileExistsAtPath:directory isDirectory:&isDirectory])
//        [[NSFileManager defaultManager] createDirectoryAtPath:directory withIntermediateDirectories:YES attributes:nil error:&error];
//    if (error!=nil) {
//        return nil;
//    }
//    return directory;
//}

- (void)reloadData {
    
    if(self.selectedProduct==nil){
        [self.tableView setHidden:YES];
        return;
    }
    if(self.selectedProduct.pictureFile.length>0){
        NSString *filePath=[[AppDelegate getImagesPathForServer:_appDelegate.selectedStore.peerInfo.deviceID] stringByAppendingPathComponent:self.selectedProduct.pictureFile];
        //check if cached
        if([[NSFileManager defaultManager] fileExistsAtPath:filePath])
            self.productImageView.image=[[UIImage alloc] initWithContentsOfFile:filePath];
        else{
            /*this is for http only, we need BT
             dispatch_async(dispatch_get_main_queue(), ^{
             NSURL *url=[[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@images/%@",_appDelegate.selectedStore.peerInfo.homeUrl,self.selectedProduct.pictureFile]];
             NSData *imageData=[[NSData alloc] initWithContentsOfURL:url];
             if (imageData!=nil) {
             // UIImage *image=[[UIImage alloc] initWithData:imageData];
             self.productImageView.image=[[UIImage alloc] initWithData:imageData];
             
             // cell.imageView.layer.cornerRadius=cell.imageView.frame.size.width / 2;
             //cell.imageView.clipsToBounds = YES;
             
             }
             
             
             });
             */
            NSString *request=[NSString stringWithFormat:@"images/%@",self.selectedProduct.pictureFile];
            
            BroadcastMessageAPI *message=[[BroadcastMessageAPI alloc] init];
            message.text=request;
            message.isBroadcast=NO;
            message.toPeerInfo=_appDelegate.selectedStore.peerInfo;
            message.message_type=MSG_TYPE_REQUEST_FILE_DOWNLOAD;
            message.localCopy=NO;
            
            NSDictionary *dict = @{KEY_SEND_MESSAGE: message
                                   };
            
            
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_HAS_DATA_TO_SEND
                                                                object:nil
                                                              userInfo:dict];
        }
        
        
    }
    [self.tableView reloadData];
    //[self configurePickerView];
    [self loadBgPhoto];

    
    
}

//- (IBAction)addToCartButtonTapped:(id)sender {
//    
//    
//    if (!self.addToCartButton.selected) {
//        
//        [self.view endEditing:YES];
//        
//        
//        
//        NSNumberFormatter *nf=[[NSNumberFormatter alloc] init];
//        
//        /*NSString *deviceID=[_appDelegate.selectedStore.inventory_dict valueForKey:deviceIDKey];
//        
//        
//        orderItem.storeID=(deviceID==nil)?@"":deviceID;
//        */
//        self.notesText.text=[self.notesText.text stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" "]];
//        
//        self.notesText.text=[self.notesText.text stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"\n"]];
//        
//        orderItem.notes=([self.notesText.text isEqualToString:YOUR_NOTES_HERE])?@"":self.notesText.text;
//        
//        //item
//        //if(self.selectedProduct.minQuantity<1)
//        //    self.selectedProduct.minQuantity=1;
//        
//        
//        if(![nf numberFromString:self.quantityText.text]){
//            _quantityText.text=[NSString stringWithFormat:@"%@", @(self.selectedProduct.minQuantity)];
//           
//            
//        }
//       
//            NSInteger quantity=[self.quantityText.text integerValue];
//            if(quantity>0)
//                orderItem.quantity=quantity;//[self.quantityText.text integerValue];
//            else{
//                //orderItem.quantity=1;
//                _quantityText.text=[NSString stringWithFormat:@"%@", @(self.selectedProduct.minQuantity)];
//                //return;
//                orderItem.quantity=self.selectedProduct.minQuantity;
//            }
//        
//        [_appDelegate addToCart:orderItem product:self.selectedProduct];
//        self.addToCartButton.selected = YES;
//        
//        /*
//         UILabel* addItemDisplay = [[UILabel alloc] initWithFrame:[_addToCartButton frame]];
//         [addItemDisplay setText:@"+1"];
//         [addItemDisplay setTextColor:[UIColor whiteColor]];
//         [addItemDisplay setBackgroundColor:[UIColor clearColor]];
//         [addItemDisplay setTextAlignment:UITextAlignmentCenter];
//         [addItemDisplay setFont:[UIFont boldSystemFontOfSize:32.0]];
//         [[self view] addSubview:addItemDisplay];
//         
//         [UIView animateWithDuration:1.0
//         animations:^{
//         [addItemDisplay setCenter:[self.tabBarController.tabBar center]];
//         [addItemDisplay setAlpha:0.0];
//         } completion:^(BOOL finished) {
//         [addItemDisplay removeFromSuperview];
//         }];
//         */
//        //end animation
//        
//        
//        
//    }
//    else {
//        OrderItem *item=[[OrderItem alloc] initWithProduct:self.selectedProduct isLive:_appDelegate.appConfig.isLive withStoreID:_appDelegate.selectedStore.peerInfo.deviceID];
//        [checkoutCart removeItem:item] ;//] withQuantity:[self.quantityText.text integerValue]];
//        self.addToCartButton.selected = NO;
//        [self.quantityText setEnabled:YES];
//        
//        
//    }
//    /*
//     
//     UITabBarItem *tbi=(UITabBarItem *)[self.tabBarController.tabBar.items objectAtIndex:TAB_INDEX_CART];
//     if([checkoutCart.itemsInCart count]==0)
//     tbi.badgeValue=nil;
//     else
//     tbi.badgeValue=[NSString stringWithFormat:@"%lu",(unsigned long)[checkoutCart.itemsInCart count]];
//     
//     //[self.navigationController popViewControllerAnimated:YES];
//     [self.tableView reloadData];
//     */
//    
//    [self updateCartBadge];
//    
//    /*if (_appDelegate.isIpad){
//        [self.tableView reloadData];
//        
//    }
//    else{*/
//        
//        [self.navigationController popViewControllerAnimated:YES];
//    
//    //}
//    
//}
//
/*
-(void)updateCartBadge{
    UITabBarItem *tbi=(UITabBarItem *)[self.tabBarController.tabBar.items objectAtIndex:TAB_INDEX_CART];
    if([checkoutCart.itemsInCart count]==0)
        tbi.badgeValue=nil;
    else
        tbi.badgeValue=[NSString stringWithFormat:@"%lu",(unsigned long)[checkoutCart.itemsInCart count]];
}
 */

-(void)loadBgPhoto{
/*
    
    NSString *peer_bgphoto=[NSString stringWithFormat:@"%@%@.png",PREFIX_MYBGPHOTO, _appDelegate.selectedStore.peerInfo.deviceID];
    
    
    
    NSString *filePath=[[AppDelegate getImagesPathForServer:_appDelegate.selectedStore.peerInfo.deviceID] stringByAppendingPathComponent:peer_bgphoto];
    
    
    
    //check if cached
    if([[NSFileManager defaultManager] fileExistsAtPath:filePath]){
        
        self.wallImage.image=[[UIImage alloc] initWithContentsOfFile:filePath];
    }
 */
}

-(void)didFinishDownload:(NSNotification *)notification{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}
-(void)didReceivePeerBgPhotoNotification:(NSNotification *)notification{
    [self loadBgPhoto];
}



#pragma mark - UITableViewDataSource methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if(self.selectedProduct)
        return 1; // (1) user details, (2) credit card details
    else
        return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"";//(section == 0) ? @"Customer Info" : @"Credit Card Details";
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(self.selectedProduct)
        return 3;//(section == 0) ? 1 : 1;
    else
        return 0;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(_appDelegate.isIpad){
        switch(indexPath.row){
            case 0:
                return 70;
            case 1:
                if (self.selectedProduct.detail.length>0)
                    return [AppDelegate sizeForText:self.selectedProduct.detail].height;
                else
                    return 0;
            case 2:
                return 320;
                // default:
                //     return 0;
                
        }
    }
    else{
        switch(indexPath.row){
            case 0:
                return 44;
            
            case 1:
                if (self.selectedProduct.detail.length>0)
                    return [AppDelegate sizeForText:self.selectedProduct.detail].height;
                else
                    return 0;
            case 2:
                return 220;
                //default:
                //    return 0;
                
        }
    }
    
    return 0;

    
}
/*
 UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"
 forIndexPath:indexPath];
 id item = self.store.allItems[indexPath.row];
 NSArray *descriptions = [self.store descriptionsForItem:item];
 cell.textLabel.text = descriptions[0];
 cell.detailTextLabel.text = descriptions[1];
 cell.accessoryType = ([item isEqual:self.store.selectedItem]) ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
 return cell;
 */
/*
 - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
 
 UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"card_cell"
 forIndexPath:indexPath];
 //id item = self.store.allItems[indexPath.row];
 NSArray *descriptions = [self descriptionsForCard:selectedCard];
 cell.textLabel.text = descriptions[0];
 cell.detailTextLabel.text = descriptions[1];
 //cell.accessoryType = ([item isEqual:self.store.selectedItem]) ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
 return cell;
 }
 */
//- (UITableViewCell *)eCommerceCell:(NSIndexPath *)indexPath {
//    
//    NSInteger section = indexPath.section;
//    NSInteger row = indexPath.row;
//    
//    if (section == 0 && row == 0) {
//        ProductCartCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"ProductCartCell"
//                                                                     forIndexPath:indexPath];
//        _addToCartButton=cell.addToCartButton;
//        [_addToCartButton addTarget:self action:@selector(addToCartButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
//        
//        _quantityText=cell.quantityText;
//        cell.priceLabel.text=[NSString stringWithFormat:@"@%@",[Product priceToString:(double)orderItem.price/100 currency:_appDelegate.selectedStore.inventory.currencySymbol]];
//        _soldoutLabel=cell.soldoutLabel;
//        _notesText=cell.notesText;
//        
//        _quantityText.delegate=self;
//        _notesText.delegate=self;
//        
//        _quantityText.inputAccessoryView=pickerToolbar;
//        _quantityText.keyboardType=UIKeyboardTypeNumberPad;
//        
//        _notesText.inputAccessoryView=pickerToolbar;
//        
//        
//        [[_notesText layer] setBorderColor:[[[UIColor grayColor] colorWithAlphaComponent:0.5] CGColor]];
//        [[_notesText layer] setBorderWidth:1.0];//setBorderWidth:2.3];
//        [[_notesText layer] setCornerRadius:2];
//        _quantityText.text=[NSString stringWithFormat:@"%lu",(unsigned long)_selectedProduct.minQuantity ];
//        
//        CGRect frame=_messageView.frame;
//        frame.size.height=60.0;
//        _messageView.frame=frame;
//        [_messageView setHidden:NO];
//        
//        if([checkoutCart containsItem:orderItem]){
//            orderItem=[checkoutCart getItem:orderItem.productID];
//            self.quantityText.text=[NSString stringWithFormat:@"%ld", (long)orderItem.quantity];
//            [self.quantityText setEnabled:NO];
//            [self.addToCartButton setTitle:@"Remove from Cart" forState:UIControlStateNormal];
//            self.addToCartButton.selected=NO;
//            self.notesText.text=orderItem.notes;
//            [self.notesText setEditable:NO];
//            if(self.notesText.text.length==0)
//                [self textViewPlaceHolder:self.notesText text:YOUR_NOTES_HERE];
//            
//            self.addToCartButton.selected = YES;
//            
//            
//            
//            //if([checkoutCart containsItem:orderItem]){
//            _messageLabel.text=@"This item is already in your cart. Tap Remove from Cart to make any changes.";
//            
//            
//            
//        }
//        else{
//            
//            
//            _messageLabel.text=@"Tap Add to Cart to purchase this item.";
//            
//            self.quantityText.text=@"1";
//            [self.quantityText setEnabled:YES];
//            self.addToCartButton.selected=NO;
//            [self.addToCartButton setTitle:@"Add to Cart" forState:UIControlStateNormal];
//            [self.notesText setEditable:YES];
//            [self textViewPlaceHolder:self.notesText text:YOUR_NOTES_HERE];
//            
//            
//        }
//        
//        self.priceLabel.text=[NSString stringWithFormat:@"@%0.02f",(double)_selectedProduct.price/100];
//        
//        
//        if(_selectedProduct.stock_unlimited){
//            
//            self.soldoutLabel.text=nil;
//            [self.addCartView setHidden:NO];
//            
//            //self.addToCartButton.selected = [checkoutCart containsItem:orderItem] ? YES : NO;
//            
//        }
//        else{
//            
//            
//            
//            if(_selectedProduct.instock>0){
//                
//                [self.addCartView setHidden:NO];
//                
//                self.soldoutLabel.text=[NSString stringWithFormat:@"%lu left",(unsigned long)_selectedProduct.instock];
//                //self.addToCartButton.selected = [checkoutCart containsItem:orderItem] ? YES : NO;
//                
//            }
//            else{
//                
//                self.soldoutLabel.text=@"SOLD OUT";
//                [self.addCartView setHidden:YES];
//            }
//            
//            
//        }
//        
//        
//        
//        return cell;
//    }
//    
//    else if (section == 0 && row == 1) {
//        ProductTitleCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"product_title_cell"
//                                                                      forIndexPath:indexPath];
//        cell.nameLabel.text=_selectedProduct.name;
//        return cell;
//    }
//    else if (section == 0 && row == 2) {
//        ProductImageCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"product_image_cell"];
//        //cell.imageView.image=self.productImageView.image;
//        self.productImageView=cell.productImage;//=self.productImageView.image;
//        
//        
//        if(self.selectedProduct.pictureFile.length>0){
//            NSString *filePath=[[AppDelegate getImagesPathForServer:_appDelegate.selectedStore.peerInfo.deviceID] stringByAppendingPathComponent:self.selectedProduct.pictureFile];
//            //check if cached
//            if([[NSFileManager defaultManager] fileExistsAtPath:filePath])
//                self.productImageView.image=[[UIImage alloc] initWithContentsOfFile:filePath];
//            else{
//                /*this is for http only, we need BT
//                 dispatch_async(dispatch_get_main_queue(), ^{
//                 NSURL *url=[[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@images/%@",_appDelegate.selectedStore.peerInfo.homeUrl,self.selectedProduct.pictureFile]];
//                 NSData *imageData=[[NSData alloc] initWithContentsOfURL:url];
//                 if (imageData!=nil) {
//                 // UIImage *image=[[UIImage alloc] initWithData:imageData];
//                 self.productImageView.image=[[UIImage alloc] initWithData:imageData];
//                 
//                 // cell.imageView.layer.cornerRadius=cell.imageView.frame.size.width / 2;
//                 //cell.imageView.clipsToBounds = YES;
//                 
//                 }
//                 
//                 
//                 });
//                 */
//                NSString *request=[NSString stringWithFormat:@"images/%@",self.selectedProduct.pictureFile];
//                
//                BroadcastMessageAPI *message=[[BroadcastMessageAPI alloc] init];
//                message.text=request;
//                message.isBroadcast=NO;
//                message.toPeerInfo=_appDelegate.mcManager.serverPeerInfo;
//                message.message_type=MSG_TYPE_REQUEST_FILE_DOWNLOAD;
//                message.localCopy=NO;
//                
//                NSDictionary *dict = @{KEY_SEND_MESSAGE: message
//                                       };
//                
//                
//                [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_HAS_DATA_TO_SEND
//                                                                    object:nil
//                                                                  userInfo:dict];
//            }
//            
//            
//        }
//        
//        
//        return cell;
//    }
//    else if (section == 0 && row == 3) {
//        ProductDescriptionCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"product_description_cell"];
//        cell.descriptionText.text =_selectedProduct.detail;
//        
//        
//        return cell;
//    }
//    return nil;
//}

- (UITableViewCell *)defaultCell:(NSIndexPath *)indexPath {
    
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    if (section == 0 && row == 0) {
        
        /*
        CGRect frame=_messageView.frame;
        frame.size.height=0.0;
        _messageView.frame=frame;
        [_messageView setHidden:YES];
        _messageLabel.text=@"";
        */
        
        ProductTitleCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"product_title_cell"
                                                                      forIndexPath:indexPath];
        cell.nameLabel.text=_selectedProduct.name;
        return cell;
    }
    else if (section == 0 && row == 1) {
        ProductDescriptionCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"product_description_cell"];
        cell.descriptionText.text =_selectedProduct.detail;
        
        
        return cell;
    }
    
    else if (section == 0 && row == 2) {
        ProductImageCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"product_image_cell"];
        //cell.imageView.image=self.productImageView.image;
        self.productImageView=cell.productImage;//=self.productImageView.image;
        
        /*if(_selectedProduct.pictureFile.length>0){
         NSString *filePath=[[AppDelegate getImagesPath] stringByAppendingPathComponent:_selectedProduct.pictureFile];
         //check if cached
         if([[NSFileManager defaultManager] fileExistsAtPath:filePath])
         self.productImageView.image=[[UIImage alloc] initWithContentsOfFile:filePath];
         
         
         
         }*/
        if(self.selectedProduct.pictureFile.length>0){
            NSString *filePath=[[AppDelegate getImagesPathForServer:_appDelegate.selectedStore.peerInfo.deviceID] stringByAppendingPathComponent:self.selectedProduct.pictureFile];
            //check if cached
            if([[NSFileManager defaultManager] fileExistsAtPath:filePath])
                self.productImageView.image=[[UIImage alloc] initWithContentsOfFile:filePath];
            else{
                /*this is for http only, we need BT
                 dispatch_async(dispatch_get_main_queue(), ^{
                 NSURL *url=[[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@images/%@",_appDelegate.selectedStore.peerInfo.homeUrl,self.selectedProduct.pictureFile]];
                 NSData *imageData=[[NSData alloc] initWithContentsOfURL:url];
                 if (imageData!=nil) {
                 // UIImage *image=[[UIImage alloc] initWithData:imageData];
                 self.productImageView.image=[[UIImage alloc] initWithData:imageData];
                 
                 // cell.imageView.layer.cornerRadius=cell.imageView.frame.size.width / 2;
                 //cell.imageView.clipsToBounds = YES;
                 
                 }
                 
                 
                 });
                 */
                NSString *request=[NSString stringWithFormat:@"images/%@",self.selectedProduct.pictureFile];
                
                BroadcastMessageAPI *message=[[BroadcastMessageAPI alloc] init];
                message.text=request;
                message.isBroadcast=NO;
                message.toPeerInfo=_appDelegate.selectedStore.peerInfo;
                message.message_type=MSG_TYPE_REQUEST_FILE_DOWNLOAD;
                message.localCopy=NO;
                
                NSDictionary *dict = @{KEY_SEND_MESSAGE: message
                                       };
                
                
                [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_HAS_DATA_TO_SEND
                                                                    object:nil
                                                                  userInfo:dict];
            }
            
            
        }
        
        
        return cell;
    }

    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //if(_selectedInventory.isEcommerce){
    //    return [self eCommerceCell:indexPath];
   // }
   // else{
        return [self defaultCell:indexPath];
    //}
}


//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath__:(NSIndexPath *)indexPath {
//    
//    NSInteger section = indexPath.section;
//    NSInteger row = indexPath.row;
//    
//    
//    if (section == 0 && row == 0) {
//        ProductCartCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ProductCartCell"
//                                                                forIndexPath:indexPath];
//        _addToCartButton=cell.addToCartButton;
//        [_addToCartButton addTarget:self action:@selector(addToCartButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
//        
//        _quantityText=cell.quantityText;
//        _soldoutLabel=cell.soldoutLabel;
//        _notesText=cell.notesText;
//        
//        _quantityText.delegate=self;
//        _notesText.delegate=self;
//        
//        _quantityText.inputAccessoryView=pickerToolbar;
//        _quantityText.keyboardType=UIKeyboardTypeNumberPad;
//        
//        _notesText.inputAccessoryView=pickerToolbar;
//        
//        
//        [[_notesText layer] setBorderColor:[[[UIColor grayColor] colorWithAlphaComponent:0.5] CGColor]];
//        [[_notesText layer] setBorderWidth:1.0];//setBorderWidth:2.3];
//        [[_notesText layer] setCornerRadius:2];
//        _quantityText.text=[NSString stringWithFormat:@"%lu",(unsigned long)self.selectedProduct.minQuantity ];
//        
//        if([checkoutCart containsItem:orderItem]){
//            orderItem=[checkoutCart getItem:orderItem.productID];
//            self.quantityText.text=[NSString stringWithFormat:@"%ld", (long)orderItem.quantity];
//            [self.quantityText setEnabled:NO];
//            [self.addToCartButton setTitle:@"Remove from cart" forState:UIControlStateNormal];
//            self.addToCartButton.selected=NO;
//            self.notesText.text=orderItem.notes;
//            
//            if(self.notesText.text.length==0)
//                [self textViewPlaceHolder:self.notesText text:YOUR_NOTES_HERE];
//            
//            self.addToCartButton.selected = YES;
//        }
//        else{
//            self.quantityText.text=@"1";
//            [self.quantityText setEnabled:YES];
//            self.addToCartButton.selected=NO;
//            [self textViewPlaceHolder:self.notesText text:YOUR_NOTES_HERE];
//        }
//        
//        self.priceLabel.text=[NSString stringWithFormat:@"@%0.02f",(double)self.selectedProduct.price/100];
//        
//        
//        if(self.selectedProduct.stock_unlimited){
//            
//            self.soldoutLabel.text=nil;
//            [self.addCartView setHidden:NO];
//            
//            //self.addToCartButton.selected = [checkoutCart containsItem:orderItem] ? YES : NO;
//            
//        }
//        else{
//            
//            
//            
//            if(self.selectedProduct.instock>0){
//                
//                [self.addCartView setHidden:NO];
//                
//                self.soldoutLabel.text=[NSString stringWithFormat:@"%lu left",(unsigned long)self.selectedProduct.instock];
//                //self.addToCartButton.selected = [checkoutCart containsItem:orderItem] ? YES : NO;
//                
//            }
//            else{
//                
//                self.soldoutLabel.text=@"SOLD OUT";
//                [self.addCartView setHidden:YES];
//            }
//            
//            
//        }
//        
//        
//        
//        return cell;
//    }
//    
//    else if (section == 0 && row == 1) {
//        ProductTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"product_title_cell"
//                                                                 forIndexPath:indexPath];
//        cell.nameLabel.text=self.selectedProduct.name;
//        return cell;
//    }
//    else if (section == 0 && row == 2) {
//        ProductImageCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"product_image_cell"];
//        //cell.imageView.image=self.productImageView.image;
//        self.productImageView=cell.productImage;//=self.productImageView.image;
//        
//        if(self.selectedProduct.pictureFile.length>0){
//            NSString *filePath=[[AppDelegate getImagesPathForServer:_appDelegate.selectedStore.peerInfo.deviceID] stringByAppendingPathComponent:self.selectedProduct.pictureFile];
//            //check if cached
//            if([[NSFileManager defaultManager] fileExistsAtPath:filePath])
//                self.productImageView.image=[[UIImage alloc] initWithContentsOfFile:filePath];
//            else{
//                /*this is for http only, we need BT
//                 dispatch_async(dispatch_get_main_queue(), ^{
//                 NSURL *url=[[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@images/%@",_appDelegate.selectedStore.peerInfo.homeUrl,self.selectedProduct.pictureFile]];
//                 NSData *imageData=[[NSData alloc] initWithContentsOfURL:url];
//                 if (imageData!=nil) {
//                 // UIImage *image=[[UIImage alloc] initWithData:imageData];
//                 self.productImageView.image=[[UIImage alloc] initWithData:imageData];
//                 
//                 // cell.imageView.layer.cornerRadius=cell.imageView.frame.size.width / 2;
//                 //cell.imageView.clipsToBounds = YES;
//                 
//                 }
//                 
//                 
//                 });
//                 */
//                NSString *request=[NSString stringWithFormat:@"images/%@",self.selectedProduct.pictureFile];
//                
//                BroadcastMessageAPI *message=[[BroadcastMessageAPI alloc] init];
//                message.text=request;
//                message.isBroadcast=NO;
//                message.toPeerInfo=_appDelegate.mcManager.serverPeerInfo;
//                message.message_type=MSG_TYPE_REQUEST_FILE_DOWNLOAD;
//                message.localCopy=NO;
//                
//                NSDictionary *dict = @{KEY_SEND_MESSAGE: message
//                                       };
//                
//                
//                [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_HAS_DATA_TO_SEND
//                                                                    object:nil
//                                                                  userInfo:dict];
//            }
//            
//            
//        }
//        
//        return cell;
//    }
//    else if (section == 0 && row == 3) {
//        ProductDescriptionCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"product_description_cell"];
//        cell.descriptionText.text =self.selectedProduct.detail;
//        
//        
//        return cell;
//    }
//    return nil;
//}

#pragma mark -
#pragma mark UITextViewDelegate
/*
 - (void)updateBytesRemaining:(NSString*)text
 {
 // Calculate how many bytes long the text is. We will send the text as
 // UTF-8 characters to the server. Most common UTF-8 characters can be
 // encoded as a single byte, but multiple bytes as possible as well.
 const char* s = [text UTF8String];
 size_t numberOfBytes = strlen(s);
 
 // Calculate how many bytes are left
 remaining = MaxMessageLength - numberOfBytes;
 //_remaining = MaxMessageLength - numberOfBytes;
 
 // Show the number of remaining bytes in the navigation bar's title
 if (remaining >= 0)
 //self.navigationBar.topItem.title = [NSString stringWithFormat:NSLocalizedString(@"%d Remaining", nil), _remaining];
 //self.navigationItem.title=[NSString stringWithFormat:NSLocalizedString(@"%d Remaining", nil), remaining];
 _lblTextHere.text=[NSString stringWithFormat:NSLocalizedString(@"%d Remaining", nil), remaining];
 //[self.tableView headerViewForSection:1].textLabel.text = [self tableView:self.tableView titleForHeaderInSection:1]
 
 else
 //self.navigationBar.topItem.title = NSLocalizedString(@"Text Too Long", nil);
 //self.navigationItem.title= NSLocalizedString(@"Text Too Long", nil);
 _lblTextHere.text = NSLocalizedString(@"Text Too Long", nil);
 
 // Disable the Save button if no text is entered, or if it is too long
 self.saveItem.enabled = ( (remaining >= 0) && (text.length != 0)) || [attachItems count]>0 || _hasAudio;
 
 if(text.length>0)
 [_btnClearText setHidden:NO];
 else
 [_btnClearText setHidden:YES];
 }
 */
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    //if([textView isEqual:self.notesText])
    //  return textView.text.length+(text.length-range.length)<=MaxNotesLength;
    
    //else if([textView isEqual:self.quantityText])
    return textField.text.length+(string.length-range.length)<=MaxQuantityLength;
    
    //return YES;
}

- (BOOL)textView:(UITextView*)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString*)text
{
    if ([textView.text isEqualToString:YOUR_NOTES_HERE]) {
        textView.text=@"";
        return YES;
        
    }
    else if(text.length==0){
        [self textViewPlaceHolder:textView text:YOUR_NOTES_HERE];
        return NO;
    }
    
    
    BOOL isMaxedChars=textView.text.length+(text.length-range.length)>MAX_CHARS_PRODUCT_NOTE;
    if(isMaxedChars){
        [AppDelegate toast:[NSString stringWithFormat:@"%@ characters exceeded.",@(MAX_CHARS_PRODUCT_NOTE)] duration:2.0];
        return NO;
    }
    else
        return YES;
    
}
-(void)textViewDidChangeSelection:(UITextView *)textView{
    if ([textView.text isEqualToString:YOUR_NOTES_HERE]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            textView.selectedRange=NSMakeRange(0, 0);
        });
    }
}

-(void)textViewDidBeginEditing:(UITextView *)textView{
    if ([textView.text isEqualToString:YOUR_NOTES_HERE]) {
        //textView.text=nil;
        dispatch_async(dispatch_get_main_queue(), ^{
            textView.selectedRange=NSMakeRange(0, 0);
        });
    }
}


//rom
-(void)textViewPlaceHolder:(UITextView *)textView text:(NSString *)text{
   // UIFont *font=textView.font;
    NSDictionary *attrsDictionary=[NSDictionary dictionaryWithObject:textView.font forKey:NSFontAttributeName];
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text attributes:attrsDictionary];
    
    /* i can use this for image
     NSTextAttachment *textAttachment = [[NSTextAttachment alloc] init];
     textAttachment.image = chosenImage;//[UIImage imageNamed:@"sample_image.jpg"];
     
     CGFloat oldWidth = textAttachment.image.size.width;
     
     //I'm subtracting 10px to make the image display nicely, accounting
     //for the padding inside the textView
     CGFloat scaleFactor = oldWidth / (_txtMessage.frame.size.width - 10);
     textAttachment.image = [UIImage imageWithCGImage:textAttachment.image.CGImage scale:scaleFactor orientation:UIImageOrientationUp];
     NSAttributedString *attrStringWithImage = [NSAttributedString attributedStringWithAttachment:textAttachment];
     //if(_txtMessage.text.length>0){
     // [attributedString replaceCharactersInRange:NSMakeRange(6, 1) withAttributedString:attrStringWithImage];
     // [attributedString replaceCharactersInRange:NSMakeRange(6, 1) withAttributedString:attrStringWithImage];
     [attributedString appendAttributedString:attrStringWithImage];
     
     // }
     //[_txtMessage.attributedText ]
     */
    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:NSMakeRange(0, text.length)];
    textView.attributedText = attributedString;
    dispatch_async(dispatch_get_main_queue(), ^{
        textView.selectedRange=NSMakeRange(0, 0);
    });
    
}
#pragma mark - UITableViewDelegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    /*if (indexPath.section==1 && indexPath.row==3) {
     UITableViewCell *cell=[tableView cellForRowAtIndexPath:indexPath];
     if (cell.accessoryType==UITableViewCellAccessoryCheckmark) {
     cell.accessoryType=UITableViewCellAccessoryNone;
     }
     else{
     cell.accessoryType=UITableViewCellAccessoryCheckmark;
     }
     }
     */
    
}

#pragma mark - UIPicker configuration

//- (void)configurePickerView {
//    /*self.expirationDatePicker = [[UIPickerView alloc] init];
//     self.expirationDatePicker.delegate = self;
//     self.expirationDatePicker.dataSource = self;
//     self.expirationDatePicker.showsSelectionIndicator = YES;
//     */
//    //Create and configure toolabr that holds "Done button"
//    /*
//    UIToolbar *pickerToolbar = [[UIToolbar alloc] init];
//    pickerToolbar.barStyle = UIBarStyleDefault;
//    [pickerToolbar sizeToFit];
//
//    UIBarButtonItem *flexibleSpaceLeft = [[UIBarButtonItem alloc]
//                                          initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
//                                          target:nil
//                                          action:nil];
//
//    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done"
//                                                                   style:UIBarButtonItemStyleBordered
//                                                                  target:self
//                                                                  action:@selector(pickerDoneButtonPressed)];
//
//    [pickerToolbar setItems:[NSArray arrayWithObjects:flexibleSpaceLeft, doneButton, nil]];
//
//    */
//    //self.expirationDateTextField.inputView = self.expirationDatePicker;
//    //self.expirationDateTextField.inputAccessoryView = pickerToolbar;
//    //self.nameTextField.inputAccessoryView = pickerToolbar;
//    //self.emailTextField.inputAccessoryView = pickerToolbar;
//    //self.cardNumber.inputAccessoryView = pickerToolbar;
//    //self.CVCNumber.inputAccessoryView = pickerToolbar;
//
//    /*
//    self.quantityText.inputAccessoryView=pickerToolbar;
//    self.quantityText.keyboardType=UIKeyboardTypeNumberPad;
//
//    self.notesText.inputAccessoryView=pickerToolbar;
//    */
//}

- (void)pickerDoneButtonPressed {
    [self.view endEditing:YES];
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
/*
 -(void)selectedProduct:(Product *)product{
 [self setProduct:product];
 //if(_product==nil){
 //}
 if([self.tableView isHidden]){
 [self.tableView setHidden:NO];
 }
 
 orderItem=[[OrderItem alloc] initWithProduct:self.selectedProduct isLive:_appDelegate.appConfig.isLive];
 
 //}
 [self.tableView reloadData];
 
 //dismiss popover if it's showing
 if(_popover!=nil){
 [_popover dismissPopoverAnimated:YES];
 }
 
 }
 */

//-(void)didReceiveMenuWithNotification:(NSNotification *)notification{
//    // for some reason this doesn work
//    //dispatch_async(dispatch_get_main_queue(), ^{
//        
//         NSPredicate *p=[NSPredicate predicateWithFormat:@"productID==%@",@(self.selectedProductID)];
//         
//         NSArray *arr = [_appDelegate.selectedStore.inventory.products filteredArrayUsingPredicate:p];
//         if([arr count]>0){
//         _selectedProduct=[arr firstObject];
//             
//         }
//         else{
//             _selectedProduct=nil;
//         }
//        
//        if(self.selectedProduct==nil){
//            //self.selectedProductID=0;
//            [self.tableView setHidden:YES];
//        }
//        else{
//            //self.selectedProductID=self.selectedProduct.productID;
//            orderItem=[[OrderItem alloc] initWithProduct:_selectedProduct isLive:_appDelegate.appConfig.isLive withStoreID:_appDelegate.selectedStore.peerInfo.deviceID];
//        }
//
//         
//        [self reloadData];
//        
//   // });
//    
//    
//    //[self.navigationController popViewControllerAnimated:YES];
//}

//-(BOOL)splitViewController:(UISplitViewController *)svc shouldHideViewController:(UIViewController *)vc inOrientation:(UIInterfaceOrientation)orientation{
//    return NO;
//}
/*
-(void)splitViewController:(UISplitViewController *)svc willHideViewController:(UIViewController *)aViewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)pc{
    self.popover=pc;
    [self.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
}
-(void)splitViewController:(UISplitViewController *)svc willShowViewController:(UIViewController *)aViewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem{
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    _popover=nil;
}
*/

@end
