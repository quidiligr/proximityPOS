//
//  IODViewController.m
//  iOSDiner
//
//  Created by Romulo Quidilig on 3/19/15.
//  Copyright (c) 2015 Sharecle Inc. All rights reserved.
//

#import "SearchMenuViewController.h"

//#import "OrderItem.h"     // <---- #1
//#import "Order.h"     // <---- #1
#import "Product.h"
//#import "OrderItem.h"
//#import "CheckoutCart.h"
//#import "ProductViewController.h"
//#import "BroadcastMessageAPI.h"
#import "MenuCell.h"
#import "MenuNoSellCell.h"
#import "MenuSectionCell.h"
#import "MenuSectionNoImageCell.h"
//#import "ChatViewController.h"

#import "InventoryItem.h"
#import "Util.h"



#import "defs.h"


#import "InventoryModel.h"


@implementation SearchMenuViewController
{
    NSMutableArray *categorySectionTitles;

    NSArray *searchedProductCategories;
    NSArray *searchedProducts;
    
    //InventoryModel *_inventoryModel;
    
    ProductCategory *_selectedCategory;
    Product *selectedProduct;
    
    NSMutableArray *_sortedCategories;
    NSSortDescriptor *valueDescriptors;
    NSArray *descriptors;
   
    NSString *_search;
    //bool isIpad;
    UIBarButtonItem *_cancelButonItem;
    BOOL isUserTyping;
    NSTimer *timerBeginSearch;
}


//@synthesize order;

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

   // self.view.backgroundColor=[UIColor clearColor];
   
    
    valueDescriptors=[[NSSortDescriptor alloc] initWithKey:@"sortNumber" ascending:YES];
    descriptors=[NSArray arrayWithObject:valueDescriptors];
    
   
    
    _appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    _searchTextField.delegate=self;
    //self.menuTableView.backgroundColor=[UIColor clearColor];
    
    _cancelButonItem=[[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneSearch)];
    
    self.navigationItem.rightBarButtonItem=_cancelButonItem;
    
    [self.menuTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
   
    UIEdgeInsets inset = UIEdgeInsetsMake(5, 0, 0, 0);
    self.menuTableView.contentInset = inset;

    
    queue = dispatch_queue_create("com.sharecle.kiosk",nil); // <======
  
   /* [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reloadData) name:NOTIFY_UPDATE_INVENTORY
                                               object:nil];
*/
    
    [self reloadData];
    [self configurePickerView];
 
}



- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    /*if(_appDelegate.isIpad){
        [[self navigationController] setNavigationBarHidden:NO animated:YES];
    }*/
 /*   [self reloadMenu];
    
    [self loadBgPhoto];
   */
    //if ([_sortedCategories count]==0) {
    //    [self.menuTableView setHidden:YES];
        //[self showAddCategory ];
        //UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Empty menu" message:@"Add item(s) to your Menu now?" delegate:self cancelButtonTitle:@"Later" otherButtonTitles:@"Yes", nil];
        /*UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Menu is empty" message:@"Tap Inventory to add items" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
         */
        
        //[AppDelegate toast:@"Menu is emtpy. Tap Inventory to add items." duration:3.0];
   // }
    //else{
   
   //      [self.menuTableView setHidden:NO];
   // }
    
    //[self.menuTableView reloadData];
    [_searchTextField becomeFirstResponder];
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    //NSString *btnTitle=[alertView buttonTitleAtIndex:buttonIndex];
//    
//    if([ alertView isEqual:alertBarcodeScan]){
//        if([btnTitle isEqualToString:BTN_SCAN]){
//            [self performSegueWithIdentifier:@"toBCScannerViewController" sender:self];
//        }
//        else if ([btnTitle isEqualToString:BTN_OK]){
//            /*TODO: UITextField *txtField=[alertView textFieldAtIndex:0];
//            
//            
//            [self addDiscountCode:txtField.text];
//            */
//        }
//    }
//    else{
//    
//        if([btnTitle isEqualToString:@"Yes"]){
//            [self performSegueWithIdentifier:@"toInventoryViewController" sender:self];
//        }
//    }
}

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
   /* if (!cat.expanded) {
        return 0;
    }
    else{
        
        NSArray *sectionItems = [_selectedInventory allProductsWithCategoryID:cat.categoryID sorted:YES];
          NSInteger count= [sectionItems count];
        return count;
    }
   */
    return [cat.searchedProducts count];
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

-(UITableViewCell *)menuCell:(NSIndexPath *)indexPath{
    MenuCell *cell = [_menuTableView dequeueReusableCellWithIdentifier:@"MenuCell" forIndexPath:indexPath];
    if(cell==nil){
        cell=[[MenuCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MenuCell"];
    }
  
    ProductCategory *cat=[_sortedCategories objectAtIndex:indexPath.section];
   
    Product *product=[cat.searchedProducts objectAtIndex:indexPath.row];//Product *product=[cat.sortedProducts objectAtIndex:indexPath.row];
    cell.nameLabel.text=product.name;
    /*
     cell.priceLabel.text=[Product priceToString:(double)product.price/100 currency:_appDelegate.selectedStore.inventory.currencySymbol];
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
    if(!product.allowOutOfStock)
        cell.quantityLabel.text=@"";
    else{
        if (product.instock>0)
            cell.quantityLabel.text=[NSString stringWithFormat:@"%lu Left",(unsigned long)product.instock];
        else
            cell.quantityLabel.text=@"SOLD OUT";
    }
        
    if(product.pictureFile.length>0){
        [cell.productImage setImage:[UIImage imageNamed:@"empty_picture"]];

        NSString *filePath=[[AppDelegate getImagesPathForServer:_appDelegate.selectedStore.peerInfo.deviceID] stringByAppendingPathComponent:product.pictureFile];
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

-(UITableViewCell *)menuNoSellCell:(NSIndexPath *)indexPath{
    MenuNoSellCell *cell = [_menuTableView dequeueReusableCellWithIdentifier:@"MenuNoSellCell" forIndexPath:indexPath];
    if(cell==nil){
        cell=[[MenuNoSellCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MenuNoSellCell"];
    }
    
    ProductCategory *cat=[_sortedCategories objectAtIndex:indexPath.section];
    
    Product *product=[cat.searchedProducts objectAtIndex:indexPath.row];//Product *product=[cat.sortedProducts objectAtIndex:indexPath.row];//[[Product alloc] initWithDictionary:[sectionProducts objectAtIndex:indexPath.row]];
    cell.nameLabel.text=product.name;
    cell.prodDetailLabel.text=product.detail;
    //cell.priceLabel.text=[NSString stringWithFormat:@"$%.02f",(double)product.price/100];
    // NSString *newPictureFile=[imageData MD5];
    
    if(product.pictureFile.length>0){
        [cell.productImage setImage:[UIImage imageNamed:@"empty_picture"]];
        
        NSString *filePath=[[AppDelegate getImagesPathForServer:_appDelegate.selectedStore.peerInfo.deviceID] stringByAppendingPathComponent:product.pictureFile];
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
         filePath=[[AppDelegate getImagesPathForServer:_appDelegate.selectedStore.peerInfo.deviceID] stringByAppendingPathComponent:pc.pictureFile];
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
    if(_selectedInventory.isEcommerce)
       return [self menuCell:indexPath];
    else
        return [self menuNoSellCell:indexPath];
    
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //if([tableView isEqual:_menuTableView]){
        //self.selectedIndexPath = indexPath;
    _selectedCategory=[_sortedCategories objectAtIndex:indexPath.section];
    
    selectedProduct=[_selectedCategory.searchedProducts objectAtIndex:indexPath.row];
    
    
        //[self performSegueWithIdentifier:@"toProductViewController" sender:nil];
    [self.delegate searchMenuViewControllerItemSelected:self item:selectedProduct];
    
}

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

#pragma mark - UIStoryboard methods

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 /*   if([segue.identifier isEqualToString:@"toProductViewController"]){
        ProductViewController* viewController = (ProductViewController*) segue.destinationViewController;
        
  
      
        viewController.selectedProduct= selectedProduct;//[[Product alloc] initWithDictionary:[sectionProducts objectAtIndex:_selectedIndexPath.row]];
    }
    else{
        
    }
  */
}



-(void)reloadData{
   //_selectedInventory=[InventoryModel activeInventory];
    
    if(_sortedCategories==nil)
        _sortedCategories = [[NSMutableArray alloc] init];
    if([_sortedCategories count]>0){
        for(ProductCategory *pc in _sortedCategories){
            if(pc.searchedProducts!=nil && [pc.searchedProducts count]>0){
                [pc.searchedProducts removeAllObjects];
            }
        }
        [_sortedCategories removeAllObjects];
    }
    
    if(categorySectionTitles==nil)
        categorySectionTitles= [[NSMutableArray alloc] init];
    if([categorySectionTitles count]>0)
        [categorySectionTitles removeAllObjects];
    //NSArray *allSortedCategories=[_selectedInventory.categories sortedArrayUsingDescriptors:descriptors];
    
    _searchText=[_searchText stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" "]];
    if(_searchText.length>0){
        NSArray *results=[_selectedInventory searchProducts:_searchText];
        if([results count]>0){
            for(Product *p in results){
                ProductCategory *pc=[_selectedInventory searchCategoryWithID:p.categoryID] ;
                if(pc!=nil){
                    if(pc.searchedProducts==nil){
                        pc.searchedProducts=[NSMutableArray new];
                    }
                    [pc.searchedProducts addObject:p];
                    if(![_sortedCategories containsObject:pc]){
                       
                    
                        [_sortedCategories addObject:pc];
                        
                    }
                    
                }
            }
            
            [categorySectionTitles addObjectsFromArray: [_sortedCategories valueForKey:NAME_KEY]];
            
            
            
            
        }
        
    }
    
    
        
    
        
              
                               
        //if(categorySectionTitles.count==0){
           // [_menuTableView setHidden:YES];
       
       // }
       // else{
            
            [_menuTableView reloadData];
             //[_menuTableView setHidden:NO];
       // }
    
}


-(IBAction)cancelAction:(id)sender{
    //[self.delegate searchMenuViewControllerWasCancelled:self];
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
   /*
    dispatch_async(dispatch_get_main_queue(), ^{
    
    if(timerBeginSearch==nil){
        timerBeginSearch=[NSTimer timerWithTimeInterval:2.0 target:self selector:@selector(reloadData) userInfo:nil repeats:NO];
    }
    else{
       // if([timerBeginSearch isValid])
            [timerBeginSearch invalidate];
        timerBeginSearch=nil;
        timerBeginSearch=[NSTimer timerWithTimeInterval:2.0 target:self selector:@selector(reloadData) userInfo:nil repeats:NO];
    }
        });
    */
    
    _searchText=[textField.text stringByReplacingCharactersInRange:range withString:string];
   /*
    NSLog(@"string=%@",string);
    NSLog(@"textField.text=%@",textField.text);
     NSLog(@"_searchText=%@",_searchText);
    */
    //if(![string isEqualToString:@" "])
      [self reloadData];
    //[self.add]
    
    return YES;
}



-(void)doneSearch{
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - UIPicker configuration

- (void)configurePickerView {



   // self.activateSwitch=[[UISwitch alloc] init];
    //[self.activateSwitch addTarget:self action:@selector(stateChanged) forControlEvents:UIControlEventValueChanged];

    
    //Create and configure toolabr that holds "Done button"
    UIToolbar *pickerToolbar = [[UIToolbar alloc] init];
    pickerToolbar.barStyle = UIBarStyleBlackTranslucent;
    [pickerToolbar sizeToFit];

    UIBarButtonItem *flexibleSpaceLeft = [[UIBarButtonItem alloc]
                                          initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                          target:nil
                                          action:nil];

    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                   style:UIBarButtonItemStyleBordered
                                                                  target:self
                                                                  action:@selector(pickerDoneButtonPressed)];
    UIBarButtonItem *clearButton = [[UIBarButtonItem alloc] initWithTitle:@"Clear"
                                                                   style:UIBarButtonItemStyleBordered
                                                                  target:self
                                                                  action:@selector(pickerClearButtonPressed)];
    [pickerToolbar setItems:[NSArray arrayWithObjects:flexibleSpaceLeft, doneButton,clearButton, nil]];
    
    _searchTextField.inputAccessoryView = pickerToolbar;
    
    /*
    self.paymentTextField.inputView = self.paymentPicker;
    self.paymentTextField.inputAccessoryView = pickerToolbar;
    */

   /*

    self.nameTextField.inputAccessoryView = pickerToolbar;
    self.salesTaxTextField.inputAccessoryView = pickerToolbar;
    */
    //self.discountTextField.inputAccessoryView = pickerToolbar;
    /*
     self.currencyTextField.inputAccessoryView = pickerToolbar;
    self.maxUnpaidTextField.inputAccessoryView = pickerToolbar;
    self.minChargeTextField.inputAccessoryView = pickerToolbar;
    self.maxChargeTextField.inputAccessoryView = pickerToolbar;
     */
    //self.refundLevelTextField.inputAccessoryView = pickerToolbar;




}

- (void)pickerDoneButtonPressed {
    [self.view endEditing:YES];
    
}

- (void)pickerClearButtonPressed {
    _searchTextField.text=@"";
    
}

@end
