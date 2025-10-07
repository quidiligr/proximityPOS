//
//  InventoryViewController.m
//
//
//  Created by Romulo Quidilig.
//  Copyright (c) 2015 Sharecle Inc. All rights reserved.
//


#import "AddProductViewController.h"
#import "EditProductViewController.h"
#import "Product.h"
#import "ProductCategory.h"
#import "TextEditViewController.h"
#import "InventoryModel.h"
#import "AppDelegate.h"
#import "InventoryItem.h"
#import "GKImagePicker.h"
#import "ProductOptionsViewController.h"
#import "NSData+Conversion.h"
//#import "BCScannerViewController.h"
#import "Util.h"
#import "defs.h"
//#define PlaceHolderTextFull  @"Full description here"
//#define PlaceHolderTextShort @"Short description here"

@interface AddProductViewController (){
    NSString *documentPath;
    NSString *imagesPath;
    NSMutableArray *categories;
    
    BOOL imageChanged;
    BOOL hasImage;
   
    NSDictionary *inventory;
    
    //InventoryModel* _inventoryModel;
    
    //UIActionSheet *asImage;
    UIActionSheet *photoActionSheet;
    //BOOL isEdit;
    NSNumberFormatter *nf;
    
    NSArray *discountTypes;
    
   NSInteger selectedDiscountType;
    AppDelegate *_appDelegate;
    UIBarButtonItem *_doneButton;
    
}
@property (strong, nonatomic) IBOutlet UITextField *nameTextField;
@property (strong, nonatomic) IBOutlet UITextField *priceTextField;


@property (strong, nonatomic) IBOutlet UIImageView *pictureFile;

@property (strong, nonatomic) IBOutlet UITextView *shortDescTextField;
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

@property (strong, nonatomic) IBOutlet UITextField *barcodeTextField;

@property (nonatomic, strong) UIImagePickerController *pickerPhoto;

//@property (strong, nonatomic) IBOutlet UITextField *computedPriceTextField;

//gkimagepicker
@property (nonatomic, strong) GKImagePicker *imagePicker;
@property (nonatomic, strong) UIPopoverController *popoverController;
@property (nonatomic, strong) UIImagePickerController *ctr;

@property (strong, nonatomic) IBOutlet UISwitch *isPublishedLocal;
@property (strong, nonatomic) IBOutlet UISwitch *isPublishedInternet;
@property (strong, nonatomic) IBOutlet UILabel *optionLabel;

@end

@implementation AddProductViewController

extern int g_NeedToPublish;
- (void)viewDidLoad {
    [super viewDidLoad];
     _appDelegate = ApplicationDelegate;
    hasImage=NO;
    //_inventoryModel=[InventoryModel sharedInstance];
    nf=[[NSNumberFormatter alloc] init];
    documentPath= [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    
    self.title=self.selectedCategory.name;
    
    //asImage=[[UIActionSheet alloc] initWithTitle:@"Edit Image" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:AS_CHOOSE_CAMERA,AS_CHOOSE_PHOTOLIB,AS_CHOOSE_REMOVEIMAGE, nil];
    
    imagesPath=[AppDelegate getImagesPath];
    
    imageChanged=NO;
    
  
    //_saveButton=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(actionSave:)];
    //self.navigationItem.rightBarButtonItem=_saveButton;
    
    _doneButton=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(actionDone:)];
    self.navigationItem.leftBarButtonItem=_doneButton;

    
        self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(actionSave:)];
    
    [[self.descriptionTextField layer] setBorderColor:[[[UIColor grayColor] colorWithAlphaComponent:0.5] CGColor]];
    [[self.descriptionTextField layer] setBorderWidth:1.0];//setBorderWidth:2.3];
    [[self.descriptionTextField layer] setCornerRadius:2];
    
   
    _nameTextField.text=_selectedProduct.name;
    _nameTextField.delegate=self;
    
    _barcodeTextField.text=_selectedProduct.barcode;
    _barcodeTextField.delegate=self;
    
    _priceTextField.text=@"";//_priceTextField.text=[NSString stringWithFormat:@"%.2f",(double)_selectedProduct.price/100];//[Product priceToString:(double)_selectedProduct.price/100 currency:_selectedInventory.currencySymbol];
    _priceTextField.delegate=self;
    
    _discountedPriceLabel.text=[NSString stringWithFormat:@"Discounted: %@",[Util priceToString:(double)_selectedProduct.price/100 currency:_appDelegate.inventoryModel.inventory.currencySymbol]];
    
   // NSString *currency=(_selectedInventory.currencySymbol)?_selectedInventory.currencySymbol:(_selectedInventory.currency)?_selectedInventory.currency:DEF_CURRENCY;
     NSString *currency=(_appDelegate.inventoryModel.inventory.currencySymbol)?_appDelegate.inventoryModel.inventory.currencySymbol:@"";
    _currencyLabel.text=currency;//(_selectedInventory.currencySymbol)?_selectedInventory.currencySymbol:(_selectedInventory.currency)?_selectedInventory.currency:DEF_CURRENCY;
    discountTypes=@[@"% discount",[NSString stringWithFormat:@"%@ discount",currency]];
    
    selectedDiscountType=_selectedProduct.discountType;
    
    _discountTextField.text=[NSString stringWithFormat:@"%.2f",_selectedProduct.discount];
    _discountTextField.delegate=self;
    
    
    
        if(!_selectedProduct.allowOutOfStock){
           
            self.remainingTextField.text=@"";
        }
        else{
            
            self.remainingTextField.text=[NSString stringWithFormat:@"%lu",(unsigned long)_selectedProduct.instock];
        }
    /*
    _selectedProduct.publishedLocal=YES;
    _selectedProduct.publishedInternet=NO;
    [_isPublishedLocal setOn:YES];
    [_isPublishedInternet setOn:NO];
    */
    
    [self updatePricing];
    
    self.remainingTextField.delegate=self;
    
    
    _descriptionTextField.text=_selectedProduct.detail;
    _descriptionTextField.delegate=self;
    
    [[_descriptionTextField layer] setBorderColor:[[[UIColor grayColor] colorWithAlphaComponent:0.5] CGColor]];
    [[_descriptionTextField layer] setBorderWidth:1.0];//setBorderWidth:2.3];
    [[_descriptionTextField layer] setCornerRadius:2];
    
    _shortDescTextField.text=_selectedProduct.shortDesc;
    _shortDescTextField.delegate=self;
    
    [[_shortDescTextField layer] setBorderColor:[[[UIColor grayColor] colorWithAlphaComponent:0.5] CGColor]];
    [[_shortDescTextField layer] setBorderWidth:1.0];//setBorderWidth:2.3];
    [[_shortDescTextField layer] setCornerRadius:2];
    
    
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
    
    [self.tableView reloadData];
    [self configurePickerView];

    [_nameTextField becomeFirstResponder];
    
}


-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    /*if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        self.navigationItem.hidesBackButton=YES;
        
    }
     */
    [_isPublishedLocal setOn:_selectedProduct.publishedLocal];
    [_isPublishedInternet setOn:_selectedProduct.publishedInternet];
    /*if([_selectedProduct.options count]>0){
        _optionLabel.text=[NSString stringWithFormat:@"Options: %lu",(unsigned long)[_selectedProduct.options count]];
    }
    else{*/
        _optionLabel.text=@"You need to save this product to set options.";
    //}
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
-(Product *)createNewProduct{
    Product *newProduct=[Product new];
    //if(_productCategory.text.length==0)
    
    newProduct.categoryID=_selectedCategory.categoryID;
    //newProduct.categoryName=_selectedCategory.name;
    
    newProduct.name=@"";
    
    newProduct.detail=@"";
    newProduct.pictureFile=@"";
    newProduct.stock_unlimited=YES;
    
    return newProduct;
}
 */
-(void) actionSaveFinal:(BOOL)allowDupName{
    if(_nameTextField.text==nil || _nameTextField.text.length==0){
        [AppDelegate toast:@"Item name is required." duration:2];
        [_nameTextField becomeFirstResponder];
        return;
    }
    else{
        _nameTextField.text=[_nameTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" "]];
        
        if(_nameTextField.text.length==0){
            [AppDelegate toast:@"Item name is required." duration:2];
            [_nameTextField becomeFirstResponder];
            return;
        }
    }
   _selectedProduct.barcode=[_barcodeTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" "]];
    
    if(!allowDupName){
        NSArray *names=[_appDelegate.inventoryModel.inventory.products valueForKey:NAME_KEY];
        if(names){
            if([names containsObject:_nameTextField.text]){ //duped
                UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Warning" message:[NSString stringWithFormat:@"%@ already exists.",_nameTextField.text] delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Continue", nil];
                [alert show];
                return;
            }
            
        }
    }
    _descriptionTextField.text=[_descriptionTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" "]];
    
    _descriptionTextField.text=[_descriptionTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"\n"]];
    _selectedProduct.detail=_descriptionTextField.text;
    //_descriptionTextField.text=([_descriptionTextField.text isEqualToString:PlaceHolderTextFull])?@"":_descriptionTextField.text;
    
    _shortDescTextField.text=[_shortDescTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" "]];
    
    _shortDescTextField.text=[_shortDescTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"\n"]];
    
    //_shortDescTextField.text=([_shortDescTextField.text isEqualToString:PlaceHolderTextShort])?@"":_shortDescTextField.text;
    _selectedProduct.shortDesc=_shortDescTextField.text;
    
    if(![nf numberFromString:_remainingTextField.text])
        _selectedProduct.allowOutOfStock=NO;
    else{
        _selectedProduct.allowOutOfStock=YES;
        _selectedProduct.instock=[_remainingTextField.text integerValue];
        
    }
    
    
    _selectedProduct.name=_nameTextField.text;
    
    _selectedProduct.discountType=selectedDiscountType;
    
    if([nf numberFromString:_priceTextField.text]){
        _selectedProduct.price=[_priceTextField.text doubleValue]*100;
    }
    
    [self updatePricing];
    
    NSString *newPictureFile=@"";
    if(hasImage){
        NSData *imageData=[[NSData alloc] initWithData:UIImagePNGRepresentation(_pictureFile.image)];
        if(imageData){
            CGFloat oldWidth = _pictureFile.image.size.width;
            CGFloat oldHeight= _pictureFile.image.size.height;
            CGFloat newWidth=300.0;
            CGFloat newHeight=(oldHeight/oldWidth)*newWidth;
            
            _pictureFile.image = [AppDelegate imageWithImage:_pictureFile.image scaledToSize:CGSizeMake(newWidth, newHeight)];
            
            imageData=[[NSData alloc] initWithData:UIImagePNGRepresentation(_pictureFile.image)];
            
            newPictureFile=[NSString stringWithFormat:@"%@-%@.png",PREFIX_PRODUCT, [imageData MD5] ];
            
            
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
    //}
    _selectedProduct.categoryID=self.selectedCategory.categoryID;
    _selectedProduct.detail=_descriptionTextField.text;
    _selectedProduct.shortDesc=_shortDescTextField.text;
    /*
    [_selectedInventory addProduct:_selectedProduct.name categoryId:self.selectedCategory.categoryID price:_selectedProduct.price actualPrice:_selectedProduct.actualPrice discount:_selectedProduct.discount discountType:_selectedProduct.discountType imageName:_selectedProduct.pictureFile detail:_descriptionTextField.text remaining:_selectedProduct.instock unlimited:_selectedProduct.stock_unlimited];
    */
   BOOL success= [_appDelegate.inventoryModel.inventory addProduct:_selectedProduct];
    
    if(!success){
        [AppDelegate toast:@"There was an error processing your request. Please try again later. Error 839." duration:3];
        return;
    }
    //InventoryModel *model=[InventoryModel sharedInstance];
    //[_appDelegate.inventoryModel saveInventory];
    
    
    
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_UPDATE_INVENTORY object:nil userInfo:@{KEY_SELECTED_INVENTORY:_appDelegate.inventoryModel.inventory, KEY_SELECTED_PRODUCT:_selectedProduct}];
    
    
    //[self dismissViewControllerAnimated:YES completion:nil];
    [self.delegate addProductViewControllerDidAdd:self withProduct:_selectedProduct];
}
- (IBAction)actionSave:(id)sender {
    
    [self actionSaveFinal:NO];
    
    
}

-(void)updatePricing{
    //_selectedProduct.discountType=selecteDiscountType;
    
    if([nf numberFromString:_priceTextField.text]){
        _selectedProduct.actualPrice=[_priceTextField.text doubleValue]*100;
    }
    
    if(_selectedProduct.actualPrice<0)
        _selectedProduct.actualPrice=0;
    
    double discount=_selectedProduct.discount;
    if([nf numberFromString:_discountTextField.text]){
        discount=[_discountTextField.text doubleValue];
        
    }
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
   // _discountedPriceLabel.text=[NSString stringWithFormat:@"Discounted: %.2f",(double)_selectedProduct.price/100];
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
    self.discountTextField.inputAccessoryView = pickerToolbar;
    
    self.priceTextField.inputAccessoryView = pickerToolbar;
    self.priceTextField.keyboardType=UIKeyboardTypeDecimalPad;
    
    self.nameTextField.inputAccessoryView = pickerToolbar;
    
    
    
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
    else if([self.descriptionTextField isFirstResponder])
        self.descriptionTextField.text=nil;
    
}

-(void)chooseImage{
    /*
    UIImagePickerController *picker=[[UIImagePickerController alloc] init];
    picker.modalPresentationStyle=UIModalPresentationCurrentContext;
    picker.delegate=self;
    picker.allowsEditing=YES;
    picker.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:picker animated:YES
                     completion:NULL];
     */
    [self showResizablePicker];
}


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

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    UIImage *chosenImage=info[UIImagePickerControllerEditedImage];
    [_pictureFile setImage:chosenImage];
    imageChanged=YES;
    hasImage=YES;
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
        hasImage=NO;
        
    }
     */
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
    g_NeedToPublish=1;
}


#pragma mark TABLE

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self showAddOption];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(!_appDelegate.inventoryModel.inventory.isEcommerce && indexPath.section==1){
        return 0;
    }
    /*else if(indexPath.section==5)
    {
        return 44;
    }
    */
    else{
        return [super tableView:tableView heightForRowAtIndexPath:indexPath];
    }
}
/*
- (BOOL)textView:(UITextView*)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString*)text
{
    
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
    
    return YES;// (textView.text.length+(text.length-range.length)<=MaxNotesLength);
    
}
*/
/*worked but no need
-(void)textViewDidChangeSelection:(UITextView *)textView{
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
}
 */

-(void)textViewDidBeginEditing:(UITextView *)textView{
    /*
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
     */
    g_NeedToPublish=1;
}


//rom
-(void)textViewPlaceHolder:(UITextView *)textView text:(NSString *)text{
    UIFont *font=textView.font;
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

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"Continue"]){
        //continue on duplicate name
        [self actionSaveFinal:YES];
    }
}

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
        //[self.popoverController presentPopoverFromBarButtonItem:_doneButton permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
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
    g_NeedToPublish=1;
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

-(void)showAddOption{
    
}
@end
