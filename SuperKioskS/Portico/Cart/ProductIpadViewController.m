//
//  ProductViewController.m


#import "ProductIpadViewController.h"
#import "CheckoutCart.h"
#import "defs.h"
#import "BroadcastMessageAPI.h"
#import "OrderItem.h"
//#import "ProductPriceCell.h"
#import "ProductCartCell.h"
#import "ProductImageCell.h"
#import "ProductTitleCell.h"
#import "ProductDescriptionCell.h"

//#import "AFNetworking.h"
#define MaxNotesLength 500
#define MaxQuantityLength 6
#define PlaceHolderText  @"Your notes here"
@interface ProductIpadViewController ()
{
    NSString *imagesPath;
    NSString *documentPath;
    
    CheckoutCart* checkoutCart;
    OrderItem *orderItem;
    
    UIToolbar *pickerToolbar;
    InventoryItem *_selectedInventory;
   // BOOL isIpad;
 
}
@property (strong, nonatomic) IBOutlet UITableView* tableView;
@property (strong, nonatomic) IBOutlet UILabel *productNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *productDescLable;
@property (weak, nonatomic) IBOutlet UITextView *txtDescription;

@property (strong, nonatomic) IBOutlet UIImageView *productImageView;
@property (strong, nonatomic) IBOutlet UILabel *priceLabel;
@property (strong, nonatomic) IBOutlet UIButton *addToCartButton;
@property (weak, nonatomic) IBOutlet UITextField *quantityText;

@property (strong, nonatomic) IBOutlet UIView *addCartView;
@property (strong, nonatomic) IBOutlet UILabel *soldoutLabel;
@property (strong, nonatomic) IBOutlet UITextView *notesText;

@property (strong, nonatomic) IBOutlet UIImageView *wallImage;



- (IBAction)addToCartButtonTapped:(id)sender;

@end

@implementation ProductIpadViewController

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
    self.view.backgroundColor=[UIColor clearColor];
	// Do any additional setup after loading the view.
    //if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
       // isIpad=YES;
    //else
      //  isIpad=NO;

    _appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    documentPath= [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
     _selectedInventory=[InventoryModel activeInventory];
    
    
    
    imagesPath=[AppDelegate getImagesPath]; //[self getImagesPath];
  
    
    checkoutCart=[CheckoutCart sharedInstance];
    
    if(_product){
        orderItem=[[OrderItem alloc] initWithProduct:self.product isLive:_appDelegate.appConfig.isLive];
    }
    
     [self.tableView setBackgroundColor:[UIColor clearColor]];
    
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
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    /*
    if(self.product.stock_unlimited){
        
        [self.addCartView setHidden:NO];
        self.soldoutLabel.text=@"";
        //  checkoutCart = [CheckoutCart sharedInstance];
        //item=[[OrderItem alloc] initWithProduct:self.product];
        
        self.addToCartButton.selected = [checkoutCart containsItem:orderItem] ? YES : NO;
    }
    else{
        
        
        
        if(self.product.instock>0){
            
            [self.addCartView setHidden:NO];
            
            self.soldoutLabel.text=[NSString stringWithFormat:@"%lu left",(unsigned long)self.product.instock];
            
            //checkoutCart = [CheckoutCart sharedInstance];
            // item=[[OrderItem alloc] initWithProduct:self.product];
            
            self.addToCartButton.selected = [checkoutCart containsItem:orderItem] ? YES : NO;
        }
        else{
            
            self.soldoutLabel.text=@"SOLD OUT";
            [self.addCartView setHidden:YES];
        }
    }
    */
    //rom: rearrage view
    //if (self.productImageView.image==nil) {
    /* if(self.product.pictureFile.length==0){
     //if([self.product.pictureFile isEqualToString:@"2fb495c391544dd2e3afbcf9edc5906b.png"]){
     CGRect frameImage=self.productImageView.frame;
     //frameImage.size.height=0;
     //self.productImageView.frame=frameImage;
     [self.productImageView setHidden:YES];
     if (self.txtDescription.text.length>0) {
     CGRect frameText=self.txtDescription.frame;
     frameText.origin.y=frameImage.origin.y;
     self.txtDescription.frame=frameText;
     }
     else{
     [self.txtDescription setHidden:YES];
     }
     
     }
     */
    
//    if(self.product.pictureFile.length>0){
//        NSString *filePath=[[AppDelegate getImagesPathForServer:_appDelegate.mcManager.serverPeerInfo.deviceID] stringByAppendingPathComponent:self.product.pictureFile];
//        //check if cached
//        if([[NSFileManager defaultManager] fileExistsAtPath:filePath])
//            self.productImageView.image=[[UIImage alloc] initWithContentsOfFile:filePath];
//        else{
//            /*this is for http only, we need BT
//             dispatch_async(dispatch_get_main_queue(), ^{
//             NSURL *url=[[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@images/%@",_appDelegate.mcManager.serverPeerInfo.homeUrl,self.product.pictureFile]];
//             NSData *imageData=[[NSData alloc] initWithContentsOfURL:url];
//             if (imageData!=nil) {
//             // UIImage *image=[[UIImage alloc] initWithData:imageData];
//             self.productImageView.image=[[UIImage alloc] initWithData:imageData];
//             
//             // cell.imageView.layer.cornerRadius=cell.imageView.frame.size.width / 2;
//             //cell.imageView.clipsToBounds = YES;
//             
//             }
//             
//             
//             });
//             */
//            NSString *request=[NSString stringWithFormat:@"images/%@",self.product.pictureFile];
//            
//            BroadcastMessageAPI *message=[[BroadcastMessageAPI alloc] init];
//            message.text=request;
//            message.isBroadcast=NO;
//            message.toPeerInfo=_appDelegate.mcManager.serverPeerInfo;
//            message.message_type=MSG_TYPE_REQUEST_FILE_DOWNLOAD;
//            message.localCopy=NO;
//            
//            NSDictionary *dict = @{KEY_SEND_MESSAGE: message
//                                   };
//            
//            
//            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_HAS_DATA_TO_SEND
//                                                                object:nil
//                                                              userInfo:dict];
//        }
//        
//        
//    }
    
    [self.tableView reloadData];
    //[self configurePickerView];
    [self loadBgPhoto];
}

#pragma mark - UITableViewDataSource methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if(_product)
        return 1; // (1) user details, (2) credit card details
    else
        return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"";//(section == 0) ? @"Customer Info" : @"Credit Card Details";
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(_product)
        return 4;//(section == 0) ? 1 : 1;
    else
        return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row==0) {
        if(!_selectedInventory.isEcommerce){
            return 0.0;
        }
        else{
            //return [super tableView:tableView heightForRowAtIndexPath:indexPath];
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
                return 170.0;
            }
            else{
                return 132.0;
            }
        }
    }
    
    
    
    else  if (indexPath.row==1) {
        return 44.0;
    }
    
    else  if (indexPath.row==2) {
        if(self.product.pictureFile.length>0){
            CGRect frameImage=self.productImageView.frame;
            return frameImage.size.height;
            
        }
        
    }
    if (indexPath.row==3) {
        if (self.product.detail.length>0)
            //return [AppDelegate sizeForText:self.product.detail].height;
            return [AppDelegate sizeForText:self.product.detail].height;
        
        
    }
    
    return 0;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    if (section == 0 && row == 0) {
        ProductCartCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ProductCartCell"
                                                                forIndexPath:indexPath];
        _addToCartButton=cell.addToCartButton;
        [_addToCartButton addTarget:self action:@selector(addToCartButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        
        _quantityText=cell.quantityText;
        if(orderItem.price==0){
            cell.priceLabel.text=@"FREE";
        
        }
        else{
            cell.priceLabel.text=[NSString stringWithFormat:@"@%@%@",_selectedInventory.currencySymbol,[Product priceToString:(double)orderItem.price/100]];
        }
        _soldoutLabel=cell.soldoutLabel;
        _notesText=cell.notesText;
        
        _quantityText.delegate=self;
        _notesText.delegate=self;
        
        _quantityText.inputAccessoryView=pickerToolbar;
        _quantityText.keyboardType=UIKeyboardTypeNumberPad;
        
        _notesText.inputAccessoryView=pickerToolbar;
        
        
        [[_notesText layer] setBorderColor:[[[UIColor grayColor] colorWithAlphaComponent:0.5] CGColor]];
        [[_notesText layer] setBorderWidth:1.0];//setBorderWidth:2.3];
        [[_notesText layer] setCornerRadius:2];
        _quantityText.text=[NSString stringWithFormat:@"%lu",(unsigned long)self.product.minQuantity ];
        
        if([checkoutCart containsItem:orderItem]){
            orderItem=[checkoutCart getItem:orderItem.productID];
            self.quantityText.text=[NSString stringWithFormat:@"%ld", (long)orderItem.quantity];
            [self.quantityText setEnabled:NO];
            [self.addToCartButton setTitle:@"Remove from cart" forState:UIControlStateNormal];
            self.addToCartButton.selected=NO;
            self.notesText.text=orderItem.notes;
            
            if(self.notesText.text.length==0)
                [self textViewPlaceHolder:self.notesText text:PlaceHolderText];
            
            self.addToCartButton.selected = YES;
        }
        else{
            self.quantityText.text=@"1";
            [self.quantityText setEnabled:YES];
            [self.addToCartButton setTitle:@"Add to cart" forState:UIControlStateNormal];
            self.addToCartButton.selected=NO;
            [self textViewPlaceHolder:self.notesText text:PlaceHolderText];
        }
        
        self.priceLabel.text=[NSString stringWithFormat:@"@%0.02f",(double)self.product.price/100];
        
        
        if(self.product.stock_unlimited){
            
            self.soldoutLabel.text=nil;
            [self.addCartView setHidden:NO];
            
            //self.addToCartButton.selected = [checkoutCart containsItem:orderItem] ? YES : NO;
            
        }
        else{
            
            
            
            if(self.product.instock>0){
                
                [self.addCartView setHidden:NO];
                
                self.soldoutLabel.text=[NSString stringWithFormat:@"%lu left",(unsigned long)self.product.instock];
                //self.addToCartButton.selected = [checkoutCart containsItem:orderItem] ? YES : NO;
                
            }
            else{
                
                self.soldoutLabel.text=@"SOLD OUT";
                [self.addCartView setHidden:YES];
            }
            
            
        }
        
        
        
        return cell;
    }

    else if (section == 0 && row == 1) {
        ProductTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"product_title_cell"
                                                                 forIndexPath:indexPath];
        cell.nameLabel.text=self.product.name;
        return cell;
    }
    else if (section == 0 && row == 2) {
        ProductImageCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"product_image_cell"];
        //cell.imageView.image=self.productImageView.image;
        self.productImageView=cell.productImage;//=self.productImageView.image;
        
        if(self.product.pictureFile.length>0){
            NSString *filePath=[[AppDelegate getImagesPath] stringByAppendingPathComponent:self.product.pictureFile];
            //check if cached
            if([[NSFileManager defaultManager] fileExistsAtPath:filePath])
                self.productImageView.image=[[UIImage alloc] initWithContentsOfFile:filePath];

            
            
        }
        
        return cell;
    }
    else if (section == 0 && row == 3) {
        ProductDescriptionCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"product_description_cell"];
        cell.descriptionText.text =self.product.detail;
        
        
        return cell;
    }
    return nil;
}

#pragma mark -
#pragma mark UITextViewDelegate
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    //if([textView isEqual:self.notesText])
    //  return textView.text.length+(text.length-range.length)<=MaxNotesLength;
    
    //else if([textView isEqual:self.quantityText])
    return textField.text.length+(string.length-range.length)<=MaxQuantityLength;
    
    //return YES;
}

- (BOOL)textView:(UITextView*)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString*)text
{
    if ([textView.text isEqualToString:PlaceHolderText]) {
        textView.text=@"";
        return YES;
        
    }
    else if(text.length==0 && textView.text.length==1){
        [self textViewPlaceHolder:textView text:PlaceHolderText];
        return NO;
    }
    
    return (textView.text.length+(text.length-range.length)<=MaxNotesLength);
    
}
-(void)textViewDidChangeSelection:(UITextView *)textView{
    if ([textView.text isEqualToString:PlaceHolderText]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            textView.selectedRange=NSMakeRange(0, 0);
        });
    }
}

-(void)textViewDidBeginEditing:(UITextView *)textView{
    if ([textView.text isEqualToString:PlaceHolderText]) {
        //textView.text=nil;
        dispatch_async(dispatch_get_main_queue(), ^{
            textView.selectedRange=NSMakeRange(0, 0);
        });
    }
}


//rom
-(void)textViewPlaceHolder:(UITextView *)textView text:(NSString *)text{
    UIFont *font=textView.font;//[UIFont systemFontOfSize:24.0];
    NSDictionary *attrsDictionary=[NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
    
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

/*
- (void)viewWillAppear:(BOOL)animated
{
 
    [self loadBgPhoto];
   // CheckoutCart* checkoutCart;
    OrderItem *item;
    if(self.product.stock_unlimited){
 
        [self.addToCartView setHidden:NO];
        self.leftLable.text=@"";
        checkoutCart = [CheckoutCart sharedInstance];
        item=[[OrderItem alloc] initWithProduct:self.product];
        
        self.addToCartButton.selected = [checkoutCart containsItem:item] ? YES : NO;
    }
    else{
        
        
        
        if(self.product.instock>0){
            
            [self.addToCartView setHidden:NO];
            
            self.leftLable.text=[NSString stringWithFormat:@"%lu left",(unsigned long)self.product.instock];
            
            checkoutCart = [CheckoutCart sharedInstance];
            item=[[OrderItem alloc] initWithProduct:self.product];
            
            self.addToCartButton.selected = [checkoutCart containsItem:item] ? YES : NO;
        }
        else{
            
            self.leftLable.text=@"SOLD OUT";
            [self.addToCartView setHidden:YES];
        }
    }
    //rom: rearrage view
    //if (self.productImageView.image==nil) {
    if(self.product.pictureFile.length==0){
    //if([self.product.pictureFile isEqualToString:@"2fb495c391544dd2e3afbcf9edc5906b.png"]){
        CGRect frameImage=self.productImageView.frame;
        //frameImage.size.height=0;
        //self.productImageView.frame=frameImage;
        [self.productImageView setHidden:YES];
        if (self.txtDescription.text.length>0) {
            CGRect frameText=self.txtDescription.frame;
            frameText.origin.y=frameImage.origin.y;
            self.txtDescription.frame=frameText;
        }
        else{
            [self.txtDescription setHidden:YES];
        }
        
    }
}
*/

-(void)loadBgPhoto{
    
    
    //NSString *peer_bgphoto=[NSString stringWithFormat:@"%@%@.png",PREFIX_MYBGPHOTO, _appDelegate.mcManager.myPeerInfo.deviceID];
     NSString *peer_bgphoto=[NSString stringWithFormat:@"%@%@.png",PREFIX_MYBGPHOTO, _appDelegate.appConfig.device_id];
    
    
    NSString *filePath=[[AppDelegate getDocumentsPath] stringByAppendingPathComponent:peer_bgphoto];
    
    
    
    //check if cached
    if([[NSFileManager defaultManager] fileExistsAtPath:filePath]){
        
        self.wallImage.image=[[UIImage alloc] initWithContentsOfFile:filePath];
    }
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

//- (void)loadData {
//    
//    
//    
//    self.productNameLabel.text = self.product.name;
//    /*NSURL* imageURL = [NSURL URLWithString:self.product.photoURL];
//    [self.productImageView setImageWithURL:imageURL placeholderImage:nil];
//     */
//    self.productDescLable.text = [NSString stringWithFormat:@"Description: %@", self.product.detail];
//    
//    self.priceLabel.text = [NSString stringWithFormat:@"Price: $%.02f", (double)self.product.price/100];
//    
//    //if(self.orderItem.quantity==0)
//    //    self.orderItem.quantity=1;
//    
//    self.quantityText.text=[NSString stringWithFormat:@"%lu",(unsigned long)self.product.minQuantity];//self.quantityText.text=self.product.minQuantity;//[NSString stringWithFormat:@"%d",self.orderItem.product.instock];
//    
//    if(self.product.pictureFile.length>0){
//        NSString *filePath=[[AppDelegate getImagesPath] stringByAppendingPathComponent:self.product.pictureFile];
//        //check if cached
//        if([[NSFileManager defaultManager] fileExistsAtPath:filePath])
//            self.productImageView.image=[[UIImage alloc] initWithContentsOfFile:filePath];
//        else{
//            /*this is for http only, we need BT
//            dispatch_async(dispatch_get_main_queue(), ^{
//                NSURL *url=[[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@images/%@",_appDelegate.mcManager.serverPeerInfo.homeUrl,self.product.pictureFile]];
//                NSData *imageData=[[NSData alloc] initWithContentsOfURL:url];
//                if (imageData!=nil) {
//                    // UIImage *image=[[UIImage alloc] initWithData:imageData];
//                    self.productImageView.image=[[UIImage alloc] initWithData:imageData];
//
//                    // cell.imageView.layer.cornerRadius=cell.imageView.frame.size.width / 2;
//                    //cell.imageView.clipsToBounds = YES;
//                    
//                }
//                
//                
//            });
//             */
//            
//            [self.productImageView setImage:[UIImage imageNamed:@"empty_picture"]];
//        }
//
//        
//    }
//
//}

- (void)loadData {
    
    //orderItem=[[OrderItem alloc] initWithProduct:self.product];
    
    self.productNameLabel.text = self.product.name;
    /*NSURL* imageURL = [NSURL URLWithString:self.product.photoURL];
     [self.productImageView setImageWithURL:imageURL placeholderImage:nil];
     */
    self.productDescLable.text = [NSString stringWithFormat:@"Description: %@", self.product.detail];
    
    self.priceLabel.text = [NSString stringWithFormat:@"Price: $%.02f", (double)self.product.price/100];
    
    //if(self.product.quantity==0)
    //     self.product.quantity=1;
    
    self.quantityText.text=[NSString stringWithFormat:@"%lu",(unsigned long)self.product.minQuantity ];//[NSString stringWithFormat:@"%d",1];//self.product.quantity];
    
    
    
    
}
- (IBAction)addToCartButtonTapped:(id)sender {
    
    
    if (!self.addToCartButton.selected) {
        
        [self.view endEditing:YES];
        
        
        self.notesText.text=[self.notesText.text stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" "]];
        
        self.notesText.text=[self.notesText.text stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"\n"]];
        
        orderItem.notes=([self.notesText.text isEqualToString:PlaceHolderText])?@"":self.notesText.text;

        NSNumberFormatter *nf=[[NSNumberFormatter alloc] init];
        //OrderItem *orderItem=[[OrderItem alloc] initWithProduct:self.product];
        
        if(![nf numberFromString:self.quantityText.text]){
            orderItem.quantity=self.product.minQuantity;
        }
        else{
            orderItem.quantity=[self.quantityText.text intValue];
        }
        
        
        if(self.product.maxQuantity>0 && orderItem.quantity>self.product.maxQuantity)
            orderItem.quantity=self.product.maxQuantity;
        
        if(orderItem.quantity==0)
            orderItem.quantity=self.product.minQuantity;
        
        
        [checkoutCart addItem:orderItem];// withQuantity:[self.quantityText.text integerValue]];
        self.addToCartButton.selected = YES;
        
        /*
        UILabel* addItemDisplay = [[UILabel alloc] initWithFrame:[_addToCartButton frame]];
        [addItemDisplay setText:@"+1"];
        [addItemDisplay setTextColor:[UIColor whiteColor]];
        [addItemDisplay setBackgroundColor:[UIColor clearColor]];
        [addItemDisplay setTextAlignment:UITextAlignmentCenter];
        [addItemDisplay setFont:[UIFont boldSystemFontOfSize:32.0]];
        [[self view] addSubview:addItemDisplay];
        
        [UIView animateWithDuration:1.0
                         animations:^{
                             [addItemDisplay setCenter:[self.tabBarController.tabBar center]];
                             [addItemDisplay setAlpha:0.0];
                         } completion:^(BOOL finished) {
                             [addItemDisplay removeFromSuperview];
                         }];
        */
        //end animation
        
       

    }
    else {
         OrderItem *item=[[OrderItem alloc] initWithProduct:self.product isLive:_appDelegate.appConfig.isLive];
        [checkoutCart removeItem:item] ;//] withQuantity:[self.quantityText.text integerValue]];
        self.addToCartButton.selected = NO;
        [self.quantityText setEnabled:YES];
        
        
    }
    UITabBarItem *tbi=(UITabBarItem *)[self.tabBarController.tabBar.items objectAtIndex:TAB_INDEX_CART];
    if([checkoutCart.itemsInCart count]==0)
        tbi.badgeValue=nil;
    else
        tbi.badgeValue=[NSString stringWithFormat:@"%lu",(unsigned long)[checkoutCart.itemsInCart count]];
    
    //[self.navigationController popViewControllerAnimated:YES];
    //self.product=nil;
    [self.tableView reloadData];

}


#pragma mark - UIPicker configuration

//- (void)configurePickerView {
//    /*self.expirationDatePicker = [[UIPickerView alloc] init];
//     self.expirationDatePicker.delegate = self;
//     self.expirationDatePicker.dataSource = self;
//     self.expirationDatePicker.showsSelectionIndicator = YES;
//     */
//    //Create and configure toolabr that holds "Done button"
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
//    
//    //self.expirationDateTextField.inputView = self.expirationDatePicker;
//    //self.expirationDateTextField.inputAccessoryView = pickerToolbar;
//    //self.nameTextField.inputAccessoryView = pickerToolbar;
//    //self.emailTextField.inputAccessoryView = pickerToolbar;
//    //self.cardNumber.inputAccessoryView = pickerToolbar;
//    //self.CVCNumber.inputAccessoryView = pickerToolbar;
//    self.quantityText.inputAccessoryView=pickerToolbar;
//    self.notesText.inputAccessoryView=pickerToolbar;
//    
//}

- (void)pickerDoneButtonPressed {
    [self.view endEditing:YES];
}

-(void)selectedProduct:(Product *)product{
    [self setProduct:product];
    //if(_product){
        orderItem=[[OrderItem alloc] initWithProduct:self.product isLive:_appDelegate.appConfig.isLive];
        
    //}
    [self.tableView reloadData];
    
    //dismiss popover if it's showing
    if(_popover!=nil){
        [_popover dismissPopoverAnimated:YES];
    }
    
}
-(void)splitViewController:(UISplitViewController *)svc willHideViewController:(UIViewController *)aViewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)pc{
    self.popover=pc;
    barButtonItem.title=@"Menu";
    [_navBarItem setLeftBarButtonItem:barButtonItem animated:YES];
}

-(void)splitViewController:(UISplitViewController *)svc willShowViewController:(UIViewController *)aViewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem{
     [_navBarItem setLeftBarButtonItem:nil animated:YES];
    _popover=nil;
}



@end
