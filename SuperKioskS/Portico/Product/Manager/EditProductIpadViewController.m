//
//  InventoryViewController.m
//
//
//  Created by Romulo Quidilig.
//  Copyright (c) 2015 Sharecle Inc. All rights reserved.
//


#import "EditProductIpadViewController.h"
#import "Product.h"
#import "ProductCategory.h"
#import "NSData+Conversion.h"
#import "defs.h"

#define PlaceHolderText  @"Your description here"
//#define MaxNotesLength 300

@interface EditProductIpadViewController (){
    NSString *documentPath;
    NSString *imagesPath;
    NSMutableArray *categories;
   
    BOOL imageChanged;
   
    NSDictionary *inventory;
    
    
    InventoryModel* _inventoryModel;
    
    UIActionSheet *asImage;
    
    //BOOL isEdit;
    NSNumberFormatter *nf;
    
    NSArray *discountTypes;
    NSInteger selectedDiscountType;
    
    

    
}
@property (strong, nonatomic) IBOutlet UITextField *nameTextField;
@property (strong, nonatomic) IBOutlet UITextField *priceTextField;

@property (strong, nonatomic) IBOutlet UIImageView *pictureFile;

@property (strong, nonatomic) IBOutlet UITextView *descriptionTextField;


@property (strong, nonatomic) IBOutlet UIPickerView *pickerCategory;
@property (strong, nonatomic) IBOutlet UIPickerView *pickerDiscount;

@property (strong, nonatomic) IBOutlet UITextField *categoryTextField;


@property (strong, nonatomic) NSNumber* selectedCategoryID;

@property (strong, nonatomic) IBOutlet UITextField *remainingTextField;

@property (strong, nonatomic) IBOutlet UITextField *discountTypeTextField;
@property (strong, nonatomic) IBOutlet UITextField *discountTextField;
@property (strong, nonatomic) IBOutlet UILabel *discountedPriceLabel;
@property (strong, nonatomic) IBOutlet UILabel *currencyLabel;

//@property (strong, nonatomic) IBOutlet UIView *composeBar;

@end

@implementation EditProductIpadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _inventoryModel=[InventoryModel sharedInstance];
    
    nf=[[NSNumberFormatter alloc] init];
    
    documentPath= [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    
    self.title=self.selectedCategory.name;
    
    asImage=[[UIActionSheet alloc] initWithTitle:@"Edit Image" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:AS_CHOOSE_IMAGE,AS_REMOVE_IMAGE, nil];
    
    imagesPath=[AppDelegate getImagesPath];
    
    imageChanged=NO;
   
        self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(actionSave:)];
    
    
     [[self.descriptionTextField layer] setBorderColor:[[[UIColor grayColor] colorWithAlphaComponent:0.5] CGColor]];
     [[self.descriptionTextField layer] setBorderWidth:1.0];//setBorderWidth:2.3];
     [[self.descriptionTextField layer] setCornerRadius:2];
     
   

    _nameTextField.text=_selectedProduct.name;
    _nameTextField.delegate=self;
    
    _priceTextField.text=[NSString stringWithFormat:@"%.2f",(double)_selectedProduct.actualPrice/100];
    _priceTextField.delegate=self;
    
    
    _discountedPriceLabel.text=[NSString stringWithFormat:@"%.2f",(double)_selectedProduct.price/100];
    
    NSString *currency=(_selectedInventory.currencySymbol)?_selectedInventory.currencySymbol:@"";
      _currencyLabel.text=currency;//(_selectedInventory.currencySymbol)?_selectedInventory.currencySymbol:(_selectedInventory.currency)?_selectedInventory.currency:DEF_CURRENCY;
    discountTypes=@[@"% discount",[NSString stringWithFormat:@"%@ discount",currency]];
    
    selectedDiscountType=_selectedProduct.discountType;
    
    _discountTextField.text=[NSString stringWithFormat:@"%.2f",_selectedProduct.discount];
    _discountTextField.delegate=self;

    
  
    
        if(_selectedProduct.stock_unlimited){
          
            self.remainingTextField.text=@"";
        }
        else{
            
            self.remainingTextField.text=[NSString stringWithFormat:@"%lu",(unsigned long)_selectedProduct.instock];
        }
    self.remainingTextField.delegate=self;
    
    _descriptionTextField.text=_selectedProduct.detail;
    _descriptionTextField.delegate=self;
    [[_descriptionTextField layer] setBorderColor:[[[UIColor grayColor] colorWithAlphaComponent:0.5] CGColor]];
    [[_descriptionTextField layer] setBorderWidth:1.0];//setBorderWidth:2.3];
    [[_descriptionTextField layer] setCornerRadius:2];
    
    [_pictureFile setImage:[UIImage imageNamed:@"empty_picture"]];
        
        
        if(_selectedProduct.pictureFile.length>0){
            NSString *filePath=[imagesPath stringByAppendingPathComponent:_selectedProduct.pictureFile];
            
            if([[NSFileManager defaultManager] fileExistsAtPath:filePath])
                _pictureFile.image=[[UIImage alloc] initWithContentsOfFile:filePath];
            else
                _selectedProduct.pictureFile=@"";
            
        }
        
    
   
    UITapGestureRecognizer *imageTap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTapped)];
    imageTap.numberOfTapsRequired=1;
    [_pictureFile setUserInteractionEnabled:YES];
    [_pictureFile addGestureRecognizer:imageTap];
    
   
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [self.tableView reloadData];
     [self configurePickerView];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)actionSave:(id)sender {
    
    
    
   if(_nameTextField.text==nil || _nameTextField.text.length==0)
       return;
    
    _nameTextField.text=[_nameTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" "]];
    
    if(_nameTextField.text.length==0)
        return;
    
    _descriptionTextField.text=[_descriptionTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" "]];
    
    _descriptionTextField.text=[_descriptionTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"\n"]];
    
    _descriptionTextField.text=([_descriptionTextField.text isEqualToString:PlaceHolderText])?@"":_descriptionTextField.text;

    
        if(![nf numberFromString:_remainingTextField.text])
            _selectedProduct.stock_unlimited=YES;
        else{
            _selectedProduct.stock_unlimited=NO;
            _selectedProduct.instock=[_remainingTextField.text integerValue];
        
        }
    
    
        _selectedProduct.name=_nameTextField.text;
        
        _selectedProduct.detail=_descriptionTextField.text;
    
    _selectedProduct.discountType=selectedDiscountType;
    
    [self updatePricing];
    
        _selectedProduct.categoryID=_selectedCategory.categoryID;//cat.categoryID;//
        if(imageChanged){
          
            NSData *imageData=[[NSData alloc] initWithData:UIImagePNGRepresentation(_pictureFile.image)];
            if(imageData){
               
                CGFloat oldWidth = _pictureFile.image.size.width;
                CGFloat oldHeight= _pictureFile.image.size.height;
                CGFloat newWidth=300.0;
                CGFloat newHeight=(oldHeight/oldWidth)*newWidth;
                
                _pictureFile.image = [AppDelegate imageWithImage:_pictureFile.image scaledToSize:CGSizeMake(newWidth, newHeight)];
                
                imageData=[[NSData alloc] initWithData:UIImagePNGRepresentation(_pictureFile.image)];
                
                
                 NSString *newPictureFile=[NSString stringWithFormat:@"%@%@.png",PREFIX_PRODUCT, [imageData MD5] ];
                if(imagesPath!=nil){
                    NSString *filePath=[imagesPath stringByAppendingPathComponent:newPictureFile];
                    
                    //save image
                    if(![[NSFileManager defaultManager] fileExistsAtPath:filePath])
                        [imageData writeToFile:filePath atomically:YES];
                    
                    _selectedProduct.pictureFile=newPictureFile;
                }
            }
            else{
                _selectedProduct.pictureFile=@"";
            }
        }
    
        [_inventoryModel saveInventory];
    
    //[[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_UPDATE_PRODUCTS object:nil userInfo:@{PRODUCTS_KEY:@[_selectedProduct]}];
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_UPDATE_INVENTORY object:nil userInfo:nil];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_BROADCAST_UPDATE_INVENTORY object:nil userInfo:nil];
    
    
    [self.navigationController popViewControllerAnimated:YES];
    
    
}

-(void)showInvalidFormat:(NSString *)message{
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Format Error" message:message delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alert show];

}

-(void)updatePricing{
     //_selectedProduct.discountType=selecteDiscountType;
    
    if(![nf numberFromString:_priceTextField.text]){
        [self showInvalidFormat:@"Invalid price."];
        return;
    }
    
    _selectedProduct.actualPrice=[_priceTextField.text doubleValue]*100;
    
    if(_selectedProduct.actualPrice<0)
        _selectedProduct.actualPrice=0;
    
    double discount=_selectedProduct.discount;
    if(![nf numberFromString:_discountTextField.text]){
        [self showInvalidFormat:@"Invalid discount."];
        return;
        
        
    }
    discount=[_discountTextField.text doubleValue];
    if(discount<0)
        discount=0;
    
    if(selectedDiscountType==DISCOUNT_PCT){
        if(discount>100)
            discount=100;
        
        _selectedProduct.discount=discount;
        
        _selectedProduct.price=_selectedProduct.actualPrice-(_selectedProduct.actualPrice*(_selectedProduct.discount/100));
    }
    else if(selectedDiscountType==DISCOUNT_VAL){
        if(discount>_selectedProduct.actualPrice/100)
            discount=_selectedProduct.actualPrice/100;
        
        _selectedProduct.discount=discount;
        
       _selectedProduct.price=_selectedProduct.actualPrice-(_selectedProduct.discount*100);
        
    }
   _discountedPriceLabel.text=[NSString stringWithFormat:@"%.2f",(double)_selectedProduct.price/100];
    
}

-(double)validateDiscount:(NSInteger)discountType{
    double discount=_selectedProduct.discount;
    if([nf numberFromString:_discountTextField.text]){
        discount=[_discountTextField.text doubleValue];
        
    }
    
    if(discount<0)
        discount=0;
    
    if(discountType==DISCOUNT_PCT){
        if(discount>100)
            discount=100;
    }
    else if (discountType==DISCOUNT_VAL){
        if(discount>_selectedProduct.actualPrice)
            discount=_selectedProduct.actualPrice;
    }
    return discount;
    
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if([pickerView isEqual:_pickerCategory]){
    if (component == 0) {
        _selectedCategory=[_selectedInventory.categories objectAtIndex:row];
        self.categoryTextField.text=_selectedCategory.name;
       
        
    }
    }
    else if([pickerView isEqual:_pickerDiscount]){
        if (component == 0) {
           
            selectedDiscountType=row;
            
            self.discountTypeTextField.text=[discountTypes objectAtIndex:selectedDiscountType];
            
            [self updatePricing];
           
        }
    }
}

#pragma mark - UIPicker configuration
- (void)configurePickerView {
    
    self.categoryTextField.text=_selectedCategory.name;
    self.pickerCategory = [[UIPickerView alloc] init];
    self.pickerCategory.dataSource=self;
    self.pickerCategory.delegate=self;
    self.pickerCategory.showsSelectionIndicator = YES;
    [self.pickerCategory selectRow:[_selectedInventory.categories indexOfObject:_selectedCategory] inComponent:0 animated:YES];
    
    self.discountTypeTextField.text=[discountTypes objectAtIndex:_selectedProduct.discountType];
    self.pickerDiscount = [[UIPickerView alloc] init];
    self.pickerDiscount.dataSource=self;
    self.pickerDiscount.delegate=self;
    self.pickerDiscount.showsSelectionIndicator = YES;
    [self.pickerDiscount selectRow:_selectedProduct.discountType inComponent:0 animated:YES];
    
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
    [pickerToolbar setItems:[NSArray arrayWithObjects:flexibleSpaceLeft,clearButton, doneButton, nil]];
    
    
    self.categoryTextField.inputView = self.pickerCategory;
    self.categoryTextField.inputAccessoryView = pickerToolbar;
    
    self.discountTypeTextField.inputView = self.pickerDiscount;
    self.discountTypeTextField.inputAccessoryView = pickerToolbar;
    _discountTextField.inputAccessoryView=pickerToolbar;
    
    self.priceTextField.inputAccessoryView = pickerToolbar;
    self.priceTextField.keyboardType=UIKeyboardTypeDecimalPad;
    
    self.nameTextField.inputAccessoryView = pickerToolbar;
    
    
    
    
    self.remainingTextField.inputAccessoryView = pickerToolbar;
    self.remainingTextField.keyboardType=UIKeyboardTypeNumberPad;
    
    self.descriptionTextField.inputAccessoryView = pickerToolbar;
   
    
}

- (void)pickerDoneButtonPressed {
    
    
    if([self.discountTextField isFirstResponder]
       || [self.priceTextField isFirstResponder]
       ){
        [self updatePricing];
        
            _discountedPriceLabel.text=[NSString stringWithFormat:@"%.2f",(double)_selectedProduct.price/100];
       
    }
    
    [self.view endEditing:YES];
}

- (void)pickerClearButtonPressed {
    //[self.view endEditing:YES];
    if([self.nameTextField isFirstResponder])
        self.nameTextField.text=nil;
    else if([self.priceTextField isFirstResponder])
        self.priceTextField.text=nil;
    else if([self.remainingTextField isFirstResponder])
        self.remainingTextField.text=nil;
    else if([self.discountTextField isFirstResponder])
        self.discountTextField.text=nil;
    else if([self.descriptionTextField isFirstResponder])
        self.descriptionTextField.text=nil;
    
}
-(void)chooseImage{
    UIImagePickerController *picker=[[UIImagePickerController alloc] init];
    picker.delegate=self;
    picker.allowsEditing=YES;
    picker.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:picker animated:YES
                     completion:NULL];
}


-(void)imageTapped{
    if(_selectedProduct.pictureFile.length>0){
        [asImage showInView:self.view];
    }
    else{
        [self chooseImage];
    }
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    UIImage *chosenImage=info[UIImagePickerControllerEditedImage];
    [_pictureFile setImage:chosenImage];
    imageChanged=YES;
    [picker dismissViewControllerAnimated:YES completion:nil];
}



-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if([pickerView isEqual:_pickerCategory]){
        return [_selectedInventory.categories count];
    }
    else if([pickerView isEqual:_pickerDiscount]){
        return [discountTypes count];
    }
    else
        return 0;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if([pickerView isEqual:_pickerCategory]){
        ProductCategory *cat=_selectedInventory.categories[row];
        return cat.name;
    }
    else if([pickerView isEqual:_pickerDiscount]){
        return discountTypes[row];
    }
    else
        return nil;
}


-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if(buttonIndex==[actionSheet cancelButtonIndex])
        return;
    
    NSString *btnTitle=[actionSheet buttonTitleAtIndex:buttonIndex];
    
    if ([btnTitle isEqualToString:AS_CHOOSE_IMAGE]) {
        
        [self chooseImage];
        
        
    }
    else if ([btnTitle isEqualToString:AS_REMOVE_IMAGE]) {
        
        [_pictureFile setImage:[UIImage imageNamed:@"empty_picture"]];
        
        
        _selectedProduct.pictureFile=@"";
        
        
    }
}


-(void)textFieldDidBeginEditing:(UITextField *)textField{
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    /*
    if(!_selectedInventory.isEcommerce){
        UITableViewCell *cell=[super tableView:tableView cellForRowAtIndexPath:indexPath];
    
        if([cell isEqual:_ecommerceCell]){
            //[cell.contentView.superview setClipsToBounds:YES];
            
            [cell setHidden:YES];
            return 0;
        }
        
    }
    return [super tableView:tableView heightForRowAtIndexPath:indexPath];
     */
    if(!_selectedInventory.isEcommerce && indexPath.row==1){
        return 0;
    }
    else{
        CGFloat h=[super tableView:tableView heightForRowAtIndexPath:indexPath];
        return h;
    }

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
    
    return YES;// (textView.text.length+(text.length-range.length)<=MaxNotesLength);
    
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
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text];
    
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

-(void)selectedProduct:(Product *)product{
    [self setSelectedProduct:product];
    //if(_product){
    //orderItem=[[OrderItem alloc] initWithProduct:self.product isLive:_appDelegate.appConfig.isLive];
    
    //}
    [self.tableView reloadData];
    
    //dismiss popover if it's showing
    if(_popover!=nil){
        [_popover dismissPopoverAnimated:YES];
    }
    
}
-(void)splitViewController:(UISplitViewController *)svc willHideViewController:(UIViewController *)aViewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)pc{
    self.popover=pc;
    barButtonItem.title=@"Category";
    [_navBarItem setLeftBarButtonItem:barButtonItem animated:YES];
}

-(void)splitViewController:(UISplitViewController *)svc willShowViewController:(UIViewController *)aViewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem{
    [_navBarItem setLeftBarButtonItem:nil animated:YES];
    _popover=nil;
}


@end
