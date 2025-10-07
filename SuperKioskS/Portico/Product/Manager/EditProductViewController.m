//
//  InventoryViewController.m
//
//
//  Created by Romulo Quidilig.
//  Copyright (c) 2015 Sharecle Inc. All rights reserved.
//


#import "EditProductViewController.h"
#import "Product.h"
#import "ProductCategory.h"
#import "InventoryModel.h"
#import "InventoryItem.h"
#import "Util.h"
#import "AppDelegate.h"
#import "NSData+Conversion.h"

#import "GKImagePicker.h"
#import "BCScannerViewController.h"
#import "ProductOptionsViewController.h"
#import "defs.h"

//#define PlaceHolderTextFull  @"Full description here"
//#define PlaceHolderTextShort  @"Short description here"
//#define MaxNotesLength 300

@interface EditProductViewController ()<UIImagePickerControllerDelegate,GKImagePickerDelegate,UINavigationControllerDelegate,UIPickerViewDelegate,UIPickerViewDataSource,UIActionSheetDelegate,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UITextViewDelegate,BCScannerViewControllerDelegate>{
    NSString *documentPath;
    NSString *imagesPath;
    NSMutableArray *categories;
   UIActionSheet *photoActionSheet;
    BOOL imageChanged;
   
    BOOL hasImage;
    NSDictionary *inventory;
    
    
    //InventoryModel* _inventoryModel;
    
    //UIActionSheet *asImage;
    
    //BOOL isEdit;
    NSNumberFormatter *nf;
    
    NSArray *discountTypes;
    NSInteger selectedDiscountType;
    
    
     UIBarButtonItem *_saveButton;
    UIBarButtonItem *_doneButton;

    AppDelegate *_appDelegate;
    
}






@property(nonatomic,weak)IBOutlet UINavigationItem *navBarItem;
@property(nonatomic,strong)UIPopoverController *popover;

@property (strong, nonatomic) IBOutlet UITextField *nameTextField;
@property (strong, nonatomic) IBOutlet UITextField *priceTextField;
@property (strong, nonatomic) IBOutlet UITextField *displayOrderTextField;

@property (strong, nonatomic) IBOutlet UIImageView *pictureFile;

@property (strong, nonatomic) IBOutlet UITextView *descriptionTextField;

@property (strong, nonatomic) IBOutlet UITextView *shortDescTextField;

@property (strong, nonatomic) IBOutlet UIPickerView *pickerCategory;
@property (strong, nonatomic) IBOutlet UIPickerView *pickerDiscount;

@property (strong, nonatomic) IBOutlet UITextField *categoryTextField;
@property (strong, nonatomic) IBOutlet UISwitch *allowOutOfStockSwitchField;


@property (strong, nonatomic) NSNumber* selectedCategoryID;

@property (strong, nonatomic) IBOutlet UITextField *remainingTextField;

@property (strong, nonatomic) IBOutlet UITextField *discountTypeTextField;
@property (strong, nonatomic) IBOutlet UITextField *discountTextField;
@property (strong, nonatomic) IBOutlet UILabel *discountedPriceLabel;
@property (strong, nonatomic) IBOutlet UILabel *currencyLabel;

@property (nonatomic, strong) UIImagePickerController *pickerPhoto;
//gkimagepicker
@property (nonatomic, strong) GKImagePicker *imagePicker;
@property (nonatomic, strong) UIPopoverController *popoverController;
@property (nonatomic, strong) UIImagePickerController *ctr;
@property (strong, nonatomic) IBOutlet UITextField *barcodeTextField;

@property (strong, nonatomic) IBOutlet UISwitch *isPublishedLocal;
@property (strong, nonatomic) IBOutlet UISwitch *isPublishedInternet;

//@property (strong, nonatomic) IBOutlet UIView *composeBar;
@property (strong, nonatomic) IBOutlet UILabel *optionLabel;

@end

@implementation EditProductViewController
extern int g_NeedToPublish;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    _appDelegate=ApplicationDelegate;
    //_inventoryModel=[InventoryModel sharedInstance];
    
    nf=[[NSNumberFormatter alloc] init];
    
    documentPath= [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    
    _saveButton=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(actionSave:)];
    self.navigationItem.rightBarButtonItem=_saveButton;
    
    _doneButton=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(actionDone:)];
     self.navigationItem.leftBarButtonItem=_doneButton;
    
    self.title=self.selectedCategory.name;
    /*
    asImage=[[UIActionSheet alloc] initWithTitle:@"Edit Image" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:AS_CHOOSE_IMAGE,AS_REMOVE_IMAGE, nil];
    
    */
     imagesPath=[AppDelegate getImagesPath];
    
    imageChanged=NO;
   
    _discountTextField.delegate=self;

    self.remainingTextField.delegate=self;
    
    _descriptionTextField.delegate=self;
    _shortDescTextField.delegate=self;
    
    [[_descriptionTextField layer] setBorderColor:[[[UIColor grayColor] colorWithAlphaComponent:0.5] CGColor]];
    [[_descriptionTextField layer] setBorderWidth:1.0];//setBorderWidth:2.3];
    [[_descriptionTextField layer] setCornerRadius:2];
    
    [[_shortDescTextField layer] setBorderColor:[[[UIColor grayColor] colorWithAlphaComponent:0.5] CGColor]];
    [[_shortDescTextField layer] setBorderWidth:1.0];//setBorderWidth:2.3];
    [[_shortDescTextField layer] setCornerRadius:2];

    
        
    
   
    UITapGestureRecognizer *imageTap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTapped)];
    imageTap.numberOfTapsRequired=1;
    [_pictureFile setUserInteractionEnabled:YES];
    [_pictureFile addGestureRecognizer:imageTap];
    
    [self displayProduct];
    
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
   /* if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        self.navigationItem.hidesBackButton=YES;
        
    }
    */
    //[self.tableView reloadData];
    //[_isPublishedLocal setOn:_selectedProduct.publishedLocal];
   // [_isPublishedInternet setOn:_selectedProduct.publishedInternet];
     [self configurePickerView];
    if([_selectedProduct.options count]>0){
        _optionLabel.text=[NSString stringWithFormat:@"Options: %lu",(unsigned long)[_selectedProduct.options count]];
    }
    else{
        _optionLabel.text=@"Tap to set options for this new product.";
    }
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)actionSave:(id)sender {
    
    
    
   if(_nameTextField.text==nil || _nameTextField.text.length==0)
       return;
    
    _nameTextField.text=[_nameTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" "]];
    
    if(_nameTextField.text.length==0){
        [AppDelegate toast:@"name field is required." duration:2.0];
        return;
    }
    
    _displayOrderTextField.text=[_displayOrderTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" "]];
    
    if(_displayOrderTextField.text.length==0){
        //[AppDelegate toast:@"name field is required." duration:2.0];
        //return;
        _displayOrderTextField.text=@"0";
    }
    else{
        if(![Util isNumeric:_displayOrderTextField.text]){
            _displayOrderTextField.text=@"0";
        }
    }
    _selectedProduct.sortNumber=[_displayOrderTextField.text integerValue];
    
    _selectedProduct.barcode=[_barcodeTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" "]];
    
    _descriptionTextField.text=[_descriptionTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" "]];
    _descriptionTextField.text=[_descriptionTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"\n"]];
    _selectedProduct.detail=_descriptionTextField.text;
    
    //_descriptionTextField.text=([_descriptionTextField.text isEqualToString:PlaceHolderTextFull])?@"":_descriptionTextField.text;

    _shortDescTextField.text=[_shortDescTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" "]];
    
    _shortDescTextField.text=[_shortDescTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"\n"]];
    
    //_shortDescTextField.text=([_shortDescTextField.text isEqualToString:PlaceHolderTextShort])?@"":_shortDescTextField.text;
    _selectedProduct.shortDesc=_shortDescTextField.text;
    
    if([_allowOutOfStockSwitchField isOn]){
        _selectedProduct.allowOutOfStock=YES;
        if([nf numberFromString:_remainingTextField.text]){
            //_selectedProduct.stock_unlimited=YES;
        //else{
          //  _selectedProduct.stock_unlimited=NO;
            _selectedProduct.instock=[_remainingTextField.text integerValue];
            
        }
    }
    else{
        _selectedProduct.allowOutOfStock=NO;
    }
    
    
    
        _selectedProduct.name=_nameTextField.text;
        
    
    
    
    _selectedProduct.discountType=selectedDiscountType;
    
    [self updatePricing];
    
        _selectedProduct.categoryID=_selectedCategory.categoryID;//cat.categoryID;//
        if(imageChanged){
          /*
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
           */
        }
    
        [_appDelegate.inventoryModel saveInventory];
    if(imageChanged && _selectedProduct.publishedInternet && _selectedProduct.pictureFile!=nil && _selectedProduct.pictureFile.length>0){
            [_selectedProduct uploadImage];
    }
    
    
    
    //[[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_UPDATE_PRODUCTS object:nil userInfo:@{PRODUCTS_KEY:@[_selectedProduct]}];
    
     [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_UPDATE_INVENTORY object:nil userInfo:@{KEY_SELECTED_INVENTORY:_appDelegate.inventoryModel.inventory, KEY_SELECTED_PRODUCT:_selectedProduct}];
    
//    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_BROADCAST_UPDATE_INVENTORY object:nil userInfo:nil];
    
    
    
   /* if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        
            self.navigationItem.rightBarButtonItem=nil;
       
    }
    else{*/
        //[self.navigationController popViewControllerAnimated:YES];
    //}
    [self dismissViewControllerAnimated:YES completion:nil];
    //[self.delegate editProductViewControllerDidUpdate:self];
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
    
    //[self setHiddenSaveButton:NO];

    
    if([pickerView isEqual:_pickerCategory]){
    if (component == 0) {
        _selectedCategory=[_appDelegate.inventoryModel.inventory.categories objectAtIndex:row];
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
    g_NeedToPublish=1;
}

#pragma mark - UIPicker configuration
- (void)configurePickerView {
    
    self.categoryTextField.text=_selectedCategory.name;
    self.pickerCategory = [[UIPickerView alloc] init];
    self.pickerCategory.dataSource=self;
    self.pickerCategory.delegate=self;
    self.pickerCategory.showsSelectionIndicator = YES;
    [self.pickerCategory selectRow:[_appDelegate.inventoryModel.inventory.categories indexOfObject:_selectedCategory] inComponent:0 animated:YES];
    
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
    
    self.displayOrderTextField.inputAccessoryView = pickerToolbar;
    self.displayOrderTextField.keyboardType=UIKeyboardTypeNumberPad;
    
    self.nameTextField.inputAccessoryView = pickerToolbar;
    //self.nameTextField.keyboardType=uike
    
    
    
    self.remainingTextField.inputAccessoryView = pickerToolbar;
    self.remainingTextField.keyboardType=UIKeyboardTypeNumberPad;
    
    self.descriptionTextField.inputAccessoryView = pickerToolbar;
   self.shortDescTextField.inputAccessoryView = pickerToolbar;
    
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
//-(void)chooseImage{
    /*
    UIImagePickerController *picker=[[UIImagePickerController alloc] init];
    picker.modalPresentationStyle=UIModalPresentationCurrentContext;
    picker.delegate=self;
    picker.allowsEditing=YES;
    picker.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:picker animated:YES
                     completion:NULL];
     */
//    [self showResizablePicker];
//}


-(void)imageTapped{
    /*
    if(_selectedProduct.pictureFile.length>0){
        [asImage showInView:self.view];
    }
    else{
        [self chooseImage];
    }
     */
    [self showSelectImageSource];
    
}

- (void)showSelectImageSource{
    [self.view endEditing:YES];
    
    
    if(![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera ]){
        photoActionSheet =[[UIActionSheet alloc]
                           initWithTitle: nil
                           delegate:self
                           cancelButtonTitle:@"Cancel"
                           destructiveButtonTitle: nil
                           otherButtonTitles:AS_CHOOSE_PHOTOLIB,AS_CHOOSE_REMOVEIMAGE, NULL];
    }
    else{
        photoActionSheet =[[UIActionSheet alloc]
                           initWithTitle: nil
                           delegate:self
                           cancelButtonTitle:@"Cancel"
                           destructiveButtonTitle: nil
                           otherButtonTitles:AS_CHOOSE_CAMERA,AS_CHOOSE_PHOTOLIB,AS_CHOOSE_REMOVEIMAGE, NULL];
    }
    [photoActionSheet showInView:self.parentViewController.view ];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
   // [self setHiddenSaveButton:NO];

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
        return [_appDelegate.inventoryModel.inventory.categories count];
    }
    else if([pickerView isEqual:_pickerDiscount]){
        return [discountTypes count];
    }
    else
        return 0;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if([pickerView isEqual:_pickerCategory]){
        ProductCategory *cat=_appDelegate.inventoryModel.inventory.categories[row];
        return cat.name;
    }
    else if([pickerView isEqual:_pickerDiscount]){
        return discountTypes[row];
    }
    else
        return nil;
}

-(void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{
    
    //}
    //ROM this code cause popover not to showup bec the actionsheet is considered a presenter and it's not dismiss yet...
//-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if(buttonIndex==[actionSheet cancelButtonIndex])
        return;
    
    NSString *btnTitle=[actionSheet buttonTitleAtIndex:buttonIndex];
    /*
    if ([btnTitle isEqualToString:AS_CHOOSE_IMAGE]) {
        
        [self chooseImage];
        
        
    }
    else if ([btnTitle isEqualToString:AS_REMOVE_IMAGE]) {
        
        [_pictureFile setImage:[UIImage imageNamed:@"empty_picture"]];
        
        
        _selectedProduct.pictureFile=@"";
        
        
    }
     */
    if([actionSheet isEqual:photoActionSheet]){
        
        if([btnTitle isEqualToString:AS_CHOOSE_CAMERA]){
            [self useCameraAction];
        }
        else if([btnTitle isEqualToString:AS_CHOOSE_PHOTOLIB]){
            
            [self usePhotoLibraryAction];
        }
        else if([btnTitle isEqualToString:AS_CHOOSE_REMOVEIMAGE]){
            
            [_pictureFile setImage:[UIImage imageNamed:@"empty_image"]];
            hasImage=NO;
            
        }
    }

}

-(void)usePhotoLibraryAction{
    /*UIImagePickerController *picker=[[UIImagePickerController alloc] init];
     picker.delegate=self;
     picker.allowsEditing=YES;
     picker.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
     picker.modalPresentationStyle=UIModalPresentationCurrentContext;
     [self presentViewController:picker animated:YES
     completion:NULL];
     */
    [self showResizablePicker];
}

-(void)useCameraAction{
    if(![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera ]){
        UIAlertView *myAlertView=[[UIAlertView alloc] initWithTitle:@"Error" message:@"Device has no camera" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [myAlertView show];
    }
    else
    {
        /*
         The problem in iOS7 has to do with transitions. It seems that if a previous transition didn't complete and you launch a new one, iOS7 messes the views, where iOS6 seems to manage it correctly.
         
         You should initialize your Camera in your UIViewController, only after the view has Loaded and with a timeout:
         */
        //show camera...
        // if (!hasLoadedCamera)
        [self performSelector:@selector(showcamera) withObject:nil afterDelay:0.5];
        
        /*UIImagePickerController *picker=[[UIImagePickerController alloc] init];
         picker.delegate=self;
         picker.allowsEditing=YES;
         picker.sourceType=UIImagePickerControllerSourceTypeCamera;
         [self presentViewController:picker animated:YES
         completion:NULL];
         */
    }
}

- (void)showcamera {
    /*pickerCamera = [[UIImagePickerController alloc] init];
     [pickerCamera setDelegate:self];
     [pickerCamera setSourceType:UIImagePickerControllerSourceTypeCamera];
     [pickerCamera setAllowsEditing:YES];
     
     [self presentModalViewController:pickerCamera animated:YES];
     */
    UIImagePickerController *picker=[[UIImagePickerController alloc] init];
    picker.delegate=self;
    self.pickerPhoto.modalPresentationStyle=UIModalPresentationCurrentContext;
    picker.allowsEditing=YES;
    picker.sourceType=UIImagePickerControllerSourceTypeCamera;
    [self presentViewController:picker animated:YES
                     completion:NULL];
}


-(void)textFieldDidBeginEditing:(UITextField *)textField{
   // [self setHiddenSaveButton:NO];
g_NeedToPublish=1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    CGFloat height=22.0;
    if(section==1){
        if(!_appDelegate.inventoryModel.inventory.isEcommerce)
            height=0.0;
    }
    return height;
        
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self showOptions];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height=60.0;
    switch(indexPath.section){
        case 0:
            height=132.0;
            break;
        case 1:
            if(!_appDelegate.inventoryModel.inventory.isEcommerce)
                height=0.0;
            else{
                if(indexPath.row==3)
                    height=100.0;
            }
            break;
        case 2:
            height=120;
        case 3:
            height=320;
        case 4:
            height=120;
        
            
    }
    /*if(!_appDelegate.inventoryModel.inventory.isEcommerce && indexPath.section==1){
        return 0;
    }
    else{
        CGFloat h=[super tableView:tableView heightForRowAtIndexPath:indexPath];
        return h;
    }
     */
    return height;

}

- (BOOL)textView:(UITextView*)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString*)text
{
    /* worked but no need
     NSString *placeHolderString;
    if([textView isEqual:_descriptionTextField]){
        placeHolderString=PlaceHolderTextFull;
    }
    else{
        placeHolderString=PlaceHolderTextShort;
    }
    if ([textView.text isEqualToString:placeHolderString]) {
        textView.text=@"";
        return YES;
        
    }
    else if(text.length==0 && textView.text.length==1){
        [self textViewPlaceHolder:textView text:placeHolderString];
        return NO;
    }
    */
    return YES;// (textView.text.length+(text.length-range.length)<=MaxNotesLength);
    
}
-(void)textViewDidChangeSelection:(UITextView *)textView{
    /* worked but no need
    NSString *placeHolderString;
    if([textView isEqual:_descriptionTextField]){
        placeHolderString=PlaceHolderTextFull;
    }
    else{
        placeHolderString=PlaceHolderTextShort;
    }
    
    if ([textView.text isEqualToString:placeHolderString]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            textView.selectedRange=NSMakeRange(0, 0);
        });
    }
     */
}

-(void)textViewDidBeginEditing:(UITextView *)textView{
    //[self setHiddenSaveButton:NO];
    /*worked but no need
    NSString *placeHolderString;
    if([textView isEqual:_descriptionTextField]){
        placeHolderString=PlaceHolderTextFull;
    }
    else{
        placeHolderString=PlaceHolderTextShort;
    }
    
    
        if ([textView.text isEqualToString:placeHolderString]) {
            //textView.text=nil;
            dispatch_async(dispatch_get_main_queue(), ^{
                textView.selectedRange=NSMakeRange(0, 0);
            });
        }
    g_NeedToPublish=1;
     */
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
/*
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section==0 && indexPath.row==0){
        [[NSNotificationCenter defaultCenter] postNotificationName:@"NOTIFY_SELECTION_CHANGED_FROM_CATEGORY" object:nil userInfo:@{@"selection":@"products",@"selectedCategory":_selectedCategory}];
    }
}
*/
-(void)displayProduct{
    if(_selectedProduct){
        _nameTextField.text=_selectedProduct.name;
        _nameTextField.delegate=self;
        
        _priceTextField.text=[NSString stringWithFormat:@"%.2f",(double)_selectedProduct.actualPrice/100];
        _priceTextField.delegate=self;
        
        
        
        _discountedPriceLabel.text=[NSString stringWithFormat:@"%.2f",(double)_selectedProduct.price/100];
        
        NSString *currency=(_appDelegate.inventoryModel.inventory.currencySymbol)?_appDelegate.inventoryModel.inventory.currencySymbol:@"";
        _currencyLabel.text=currency;//(_selectedInventory.currencySymbol)?_selectedInventory.currencySymbol:(_selectedInventory.currency)?_selectedInventory.currency:DEF_CURRENCY;
        discountTypes=@[@"% discount",[NSString stringWithFormat:@"%@ discount",currency]];
        
        selectedDiscountType=_selectedProduct.discountType;
        
        _discountTextField.text=[NSString stringWithFormat:@"%.2f",_selectedProduct.discount];
        
        if(_selectedProduct.allowOutOfStock){
            
            self.remainingTextField.text=[NSString stringWithFormat:@"%lu",(unsigned long)_selectedProduct.instock];
            [_allowOutOfStockSwitchField setOn:YES];
        }
        else{
            
            self.remainingTextField.text=@"";
            [_allowOutOfStockSwitchField setOn:NO];

        }
        
        _displayOrderTextField.text=[NSString stringWithFormat:@"%lu",(unsigned long)_selectedProduct.sortNumber];
        
        
        
        _descriptionTextField.text=_selectedProduct.detail;
        
        _shortDescTextField.text=_selectedProduct.shortDesc;
        
        [_pictureFile setImage:[UIImage imageNamed:@"empty_picture"]];
        
        
        if(_selectedProduct.pictureFile.length>0){
            NSString *filePath=[imagesPath stringByAppendingPathComponent:_selectedProduct.pictureFile];
            
            if([[NSFileManager defaultManager] fileExistsAtPath:filePath])
                _pictureFile.image=[[UIImage alloc] initWithContentsOfFile:filePath];
            else
                _selectedProduct.pictureFile=@"";
            
        }
        
        
        [_isPublishedLocal setOn:_selectedProduct.publishedLocal];
        [_isPublishedInternet setOn:_selectedProduct.publishedInternet];
        [self.tableView setHidden:NO];
    }
    else{
        [self.tableView setHidden:YES];
    }
}

-(void)selectedProduct:(Product *)prod{
    if(prod){
        [self setSelectedProduct:prod];
        [self displayProduct];
        
        
        
       // [self.tableView reloadData];
        
        //dismiss popover if it's showing
        if(_popover!=nil){
            [_popover dismissPopoverAnimated:YES];
        }
    }
    
}

-(void)splitViewController:(UISplitViewController *)svc willHideViewController:(UIViewController *)aViewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)pc{
    self.popover=pc;
    barButtonItem.title=@"Inventories";
    [_navBarItem setLeftBarButtonItem:barButtonItem animated:YES];
}

-(void)splitViewController:(UISplitViewController *)svc willShowViewController:(UIViewController *)aViewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem{
    [_navBarItem setLeftBarButtonItem:nil animated:YES];
    _popover=nil;
}
/*
-(void)setHiddenSaveButton:(BOOL)hide{
    if(hide){
        if ([self.navigationItem.rightBarButtonItem isEqual:_saveButton]) {
            self.navigationItem.rightBarButtonItem=nil;
        }
    }
    else{
        if (![self.navigationItem.rightBarButtonItem isEqual:_saveButton]) {
            self.navigationItem.rightBarButtonItem=_saveButton;
        }
        
    }
    
}
 */

- (IBAction)actionDone:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

# pragma mark -
# pragma mark GKImagePicker Delegate Methods

- (void)imagePicker:(GKImagePicker *)imagePicker pickedImage:(UIImage *)image{
    /*
     UIImage *chosenImage=info[UIImagePickerControllerEditedImage];
     [_pictureFile setImage:chosenImage];
     imageChanged=YES;
     [picker dismissViewControllerAnimated:YES completion:nil];

     */
    //NSString *photo;
    //if(_selectedPhotoPicker==PHOTO_PICKER_LOGO){
    imageChanged=YES;
        _pictureFile.image = image;
        
        
    /*    photo=[NSString stringWithFormat:@"%@%@.png",PREFIX_MYPHOTO, _appDelegate.appConfig.device_id];
        
    }
    else if(_selectedPhotoPicker==PHOTO_PICKER_BACKG){
        photo=[NSString stringWithFormat:@"%@%@.png",PREFIX_MYBGPHOTO, _appDelegate.appConfig.device_id];
        [self.photobgImageField setImage:image];
        [_appDelegate setBackgroundImage];
    }
     */
    
    [self hideImagePicker];
    
    [self saveImage];
    
    /*NSString *filePath=[[AppDelegate getDocumentsPath] stringByAppendingPathComponent:photo];
    //save image
    [UIImagePNGRepresentation(image) writeToFile:filePath atomically:YES];
     */
    
}

- (void)hideImagePicker{
    if (UIUserInterfaceIdiomPad == UI_USER_INTERFACE_IDIOM()) {
        
        [self.popoverController dismissPopoverAnimated:YES];
        
    } else {
        
        [self.imagePicker.imagePickerController dismissViewControllerAnimated:YES completion:nil];
        
    }
}


-(void)showResizablePicker{
    self.imagePicker = [[GKImagePicker alloc] init];
    self.imagePicker.cropSize = CGSizeMake(296, 300);
    self.imagePicker.delegate = self;
    self.imagePicker.resizeableCropArea = YES;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        
        self.popoverController = [[UIPopoverController alloc] initWithContentViewController:self.imagePicker.imagePickerController];
        //[self.popoverController presentPopoverFromRect:btn.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        CGRect rect=CGRectMake(0, 70, 296, 300);
        //[self.popoverController presentPopoverFromRect:CGRectZero inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        [self.popoverController presentPopoverFromRect:rect inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        
    } else {
        
        //[self presentModalViewController:self.imagePicker.imagePickerController animated:YES];
        
        [self presentViewController:self.imagePicker.imagePickerController  animated:YES completion:nil];
    }
}

-(void)saveImage{
    NSData *imageData=[[NSData alloc] initWithData:UIImagePNGRepresentation(_pictureFile.image)];
    
    NSString *newPictureFile=[NSString stringWithFormat:@"%@%@.png",PREFIX_PRODUCT, [imageData MD5] ];
    
    if(imageData){
        /*
        CGFloat oldWidth = _pictureFile.image.size.width;
        CGFloat oldHeight= _pictureFile.image.size.height;
        CGFloat newWidth=300.0;
        CGFloat newHeight=(oldHeight/oldWidth)*newWidth;
        
        _pictureFile.image = [AppDelegate imageWithImage:_pictureFile.image scaledToSize:CGSizeMake(newWidth, newHeight)];
        */
        imageData=[[NSData alloc] initWithData:UIImagePNGRepresentation(_pictureFile.image)];
        
        
        
        if(imagesPath!=nil){
            NSString *filePath=[imagesPath stringByAppendingPathComponent:newPictureFile];
            
            //save image
            if(![[NSFileManager defaultManager] fileExistsAtPath:filePath])
                [imageData writeToFile:filePath atomically:YES];
            
            _selectedProduct.pictureFile=newPictureFile;
            [AppDelegate toast:@"File saved." duration:2.0];
        }
    }
    else{
        NSError *error;
        [[NSFileManager defaultManager] removeItemAtPath:newPictureFile error:&error];
        _selectedProduct.pictureFile=@"";
         [AppDelegate toast:@"File removed." duration:2.0];
        
    }
    g_NeedToPublish=1;
}

#pragma mark -
#pragma mark Barcode
- (IBAction)barcodeTapped:(id)sender {
    
    BCScannerViewController *vc=[_appDelegate.storyBoard instantiateViewControllerWithIdentifier:@"BCScannerViewController"];
    vc.delegate=self;
    UINavigationController *nav =[[UINavigationController alloc] initWithRootViewController:vc];
    /*if(_appDelegate.isIpad){
     
     _barcodePopover=[[UIPopoverController alloc] initWithContentViewController:vc];
     // [_barcodePopover presentPopoverFromBarButtonItem:(ui)sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
     UIButton *btn=(UIButton *)sender;
     
     [_barcodePopover presentPopoverFromRect:CGRectMake(btn.frame.origin.x, btn.frame.origin.y, 300, 300) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
     
     }
     else{*/
    [self presentViewController:nav animated:YES completion:nil];
    //}
}
/*
-(void)barcodeController:(BCScannerViewController *)controller didFinishScanning:(NSString *)withInfo{
    //_searchTextField.text=withInfo;
    _barcodeTextField.text=withInfo;
    [controller dismissViewControllerAnimated:YES completion:nil];
    
}
 */
-(void)barcodeController:(BCScannerViewController *)controller didScanWithBarcode:(NSString *)barcode{
    _barcodeTextField.text=barcode;
    [controller dismissViewControllerAnimated:YES completion:nil];
}
 
- (IBAction)togglePublishedLocal:(id)sender {
    _selectedProduct.publishedLocal=[_isPublishedLocal isOn];
}


- (IBAction)togglePublishedInternet:(id)sender {
    _selectedProduct.publishedInternet=[_isPublishedInternet isOn];
}

-(void)showOptions{
    [self performSegueWithIdentifier:@"toProductOptionsViewController" sender:self];
//    
//    ProductOptionsViewController *vc=[_appDelegate.storyBoard instantiateViewControllerWithIdentifier:@"ProductOptionsViewController"];
//    //vc.delegate=self;
//    vc.selectedProduct=_selectedProduct;
//    
//    
//    
//    UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:vc];
//    
//    if(_appDelegate.isIpad){
//        //if(_popOver==nil){
//        
//        
//        _popOver=[[UIPopoverController alloc] initWithContentViewController:nav];
//        //_chatPopover.popoverContentSize=CGSizeMake(self.view.frame.size.width/2, self.view.frame.size.height);
//        _popOver.popoverContentSize=CGSizeMake(320.0, self.view.frame.size.height);
//        //[_popOver presentPopoverFromBarButtonItem:_menuButtonItem permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
//        //[_popOver presentPopoverFromRect:CGRectMake(_barcodeButton.frame.origin.x, _barcodeButton.frame.origin.y, _barcodeButton.frame.size.width, _barcodeButton.frame.size.height) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
//        [_popOver presentPopoverFromRect:self.view.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
//        /*}
//         else{
//         [_popOver dismissPopoverAnimated:YES];
//         _popOver=nil;
//         }
//         */
//    }
//    else{
//        [self presentViewController:nav animated:YES completion:nil];
//    }
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"toProductOptionsViewController"]){
        ProductOptionsViewController *destViewController=segue.destinationViewController;
        destViewController.selectedProduct=_selectedProduct;
        
    }
}
@end
