//
//  InventoryViewController.m
//
//
//  Created by Romulo Quidilig.
//  Copyright (c) 2015 Sharecle Inc. All rights reserved.
//


#import "AddCategoryViewController.h"

#import "InventoryModel.h"
#import "InventoryItem.h"
#import "AppDelegate.h"
#import "Product.h"
#import "ProductCategory.h"
#import "NSData+Conversion.h"
#import "defs.h"

//#define PlaceHolderText  @"Your category detatil here"
#define MaxNotesLength 300

@interface AddCategoryViewController (){
    NSString *documentPath;
    NSString *imagesPath;
  
    BOOL imageChanged;
   
    NSDictionary *inventory;
   
    ProductCategory *_selectedCategory;
    
    //InventoryModel* _inventoryModel;
    
    //UIActionSheet *asImage;
    AppDelegate *_appDelegate;
    UIActionSheet *photoActionSheet;
    
    BOOL hasImage;
    UIBarButtonItem *_doneButton;
    
}
@property (strong, nonatomic) IBOutlet UITextField *nameTextField;
//@property (strong, nonatomic) IBOutlet UITextField *priceTextField;
//@property (weak, nonatomic) IBOutlet UITextField *productCategory;
@property (strong, nonatomic) IBOutlet UIImageView *pictureFile;
//@property (strong, nonatomic) IBOutlet UITextField *productIDTextField;

//@property (strong, nonatomic) IBOutlet UIButton *btnSave;


@property (strong, nonatomic) IBOutlet UITextView *descriptionTextField;

//@property (strong, nonatomic) IBOutlet UIPickerView *pickerCategory;
//@property (strong, nonatomic) IBOutlet UITextField *categoryTextField;

//@property (strong, nonatomic) NSNumber* selectedCategoryID;
//@property (strong, nonatomic) IBOutlet UISwitch *unlimittedToggle;
//@property (strong, nonatomic) IBOutlet UITextField *remainingTextField;
//@property (strong, nonatomic) IBOutlet UITextField *sortNumber;

@property (nonatomic, strong) UIImagePickerController *pickerPhoto;

//gkimagepicker

@property (nonatomic, strong) GKImagePicker *imagePicker;
@property (nonatomic, strong) UIPopoverController *popoverController;
@property (nonatomic, strong) UIImagePickerController *ctr;

@property (strong, nonatomic) IBOutlet UISwitch *isPublishedLocal;
@property (strong, nonatomic) IBOutlet UISwitch *isPublishedInternet;

@end

@implementation AddCategoryViewController
extern int g_NeedToPublish;
/*- (id) initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        _inventoryModel = [[InventoryModel alloc] init];
        [_inventoryModel loadInventory];
        //inventory=[_inventoryModel toInventoryDictionary];
        //categorySectionTitles=[inventory allKeys];
    }
    return self;
}
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    
    //load categories
    //[_inventoryModel.products fil]
    
    //create path
     //fileManager=[NSFileManager defaultManager];
    //_inventoryModel=[InventoryModel sharedInstance];
    _appDelegate=ApplicationDelegate;
    
    hasImage=NO;
    documentPath= [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    
    self.title=@"Add category";
    
    //asImage=[[UIActionSheet alloc] initWithTitle:@"Edit Image" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:AS_CHOOSE_IMAGE,AS_REMOVE_IMAGE, nil];
    
    imagesPath=[AppDelegate getImagesPath];
    
    imageChanged=NO;
    
    _doneButton=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(actionDone:)];
    self.navigationItem.leftBarButtonItem=_doneButton;
    
    //if(self.isUpdateProduct){
        self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(actionSave:)];
    
        [_pictureFile setImage:[UIImage imageNamed:@"empty_picture"]];
        
        
        /*if(_selectedProduct.pictureFile.length>0){
            NSString *filePath=[imagesPath stringByAppendingPathComponent:_selectedProduct.pictureFile];
            
            if([[NSFileManager defaultManager] fileExistsAtPath:filePath])
                _pictureFile.image=[[UIImage alloc] initWithContentsOfFile:filePath];
            else
                _selectedProduct.pictureFile=@"";
            
        }
        */
       // [_btnSave setTitle:@"Save" forState:UIControlStateNormal];
    /*}
    
    else{
        self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(actionSave:)];
        _selectedProduct=[self createNewProduct];
   
        [_pictureFile setImage:[UIImage imageNamed:@"empty_picture"]];
    
    }
    */
    UITapGestureRecognizer *imageTap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTapped)];
    imageTap.numberOfTapsRequired=1;
    [_pictureFile setUserInteractionEnabled:YES];
    [_pictureFile addGestureRecognizer:imageTap];
    
    
    _selectedCategory=[[ProductCategory alloc] init];
    /*newCategory.name=@"";
    newCategory.detail=@"";
    
    
    if([sortedArray count]>0)
        newCategory.sortNumber=[sortedArray count]-1;
    else
        newCategory.sortNumber=0;
     */
    //if(_descriptionTextField.text.length==0)
    //    [self textViewPlaceHolder:_descriptionTextField text:PlaceHolderText];
    
    [[_descriptionTextField layer] setBorderColor:[[[UIColor grayColor] colorWithAlphaComponent:0.5] CGColor]];
    [[_descriptionTextField layer] setBorderWidth:1.0];//setBorderWidth:2.3];
    [[_descriptionTextField layer] setCornerRadius:2];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    /*if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        self.navigationItem.hidesBackButton=YES;
        
    }
     */
    [_isPublishedLocal setOn:_selectedCategory.publishedLocal];
    [_isPublishedInternet setOn:_selectedCategory.publishedInternet];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self configurePickerView];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
/*
- (NSString*)getImagesPath
{
    //NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    //NSString* documentsDirectory = paths[0];
    NSError *error;
    BOOL isDirectory=YES;
    NSString *directory=[documentPath stringByAppendingPathComponent:@"images"];
    if([[NSFileManager defaultManager] fileExistsAtPath:directory]==NO){
        [[NSFileManager defaultManager] createDirectoryAtPath:directory withIntermediateDirectories:NO attributes:nil error:&error];
    }
    if(![[NSFileManager defaultManager] fileExistsAtPath:directory isDirectory:&isDirectory])
        [[NSFileManager defaultManager] createDirectoryAtPath:directory withIntermediateDirectories:YES attributes:nil error:&error];
    if (error!=nil) {
        return nil;
    }
    return directory;
}
 */

- (IBAction)actionSave:(id)sender {
    
    
    
    if(_nameTextField.text==nil || _nameTextField.text.length==0){
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Error" message:@"Category name is required." delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
       return;
    
    }
    _nameTextField.text=[_nameTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" "]];
    
    if(_nameTextField.text.length==0){
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Error" message:@"Category name is required." delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
        
        return;
    }
    
    _descriptionTextField.text=[_descriptionTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" "]];
    
  
    
    _descriptionTextField.text=[_descriptionTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"\n"]];
    
    //_descriptionTextField.text=([_descriptionTextField.text isEqualToString:PlaceHolderText])?@"":_descriptionTextField.text;
    
    

   
    NSString *newPictureFile=@"";
    if(hasImage){
    //if(_pictureFile.image!=nil){
            NSData *imageData=[[NSData alloc] initWithData:UIImagePNGRepresentation(_pictureFile.image)];
    
            if(imageData){
                
                
                newPictureFile=[NSString stringWithFormat:@"cat-%@.png",[imageData MD5]];
                
                
                if(imagesPath!=nil){
                    NSString *filePath=[imagesPath stringByAppendingPathComponent:newPictureFile];
                    
                    //save image
                    if(![[NSFileManager defaultManager] fileExistsAtPath:filePath])
                        [imageData writeToFile:filePath atomically:YES];
                    
                    
                }
            }
    }
    
   ProductCategory *addedCategory= [_appDelegate.inventoryModel.inventory addCategory:_nameTextField.text imageName:newPictureFile detail:_descriptionTextField.text];
   
    
     //[self dismissViewControllerAnimated:YES completion:nil];
    [self.delegate addCategoryViewControllerDidAddCategory:self withNewCategory:addedCategory];
}

#pragma mark - UIPicker configuration
- (void)configurePickerView {
    
    
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
    
    [pickerToolbar setItems:[NSArray arrayWithObjects:flexibleSpaceLeft, doneButton, nil]];
    
    
  
    
    
    self.descriptionTextField.inputAccessoryView = pickerToolbar;
    
    self.nameTextField.inputAccessoryView = pickerToolbar;
    
    
    
}

- (void)pickerDoneButtonPressed {
    [self.view endEditing:YES];
}

- (void)pickerClearButtonPressed {
    //[self.view endEditing:YES];
    if([self.nameTextField isFirstResponder])
        self.nameTextField.text=nil;
    else if([_descriptionTextField isFirstResponder])
        _descriptionTextField.text=nil;
    
    
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

-(void)imageTapped{
    /*if(_selectedProduct.pictureFile.length>0){
        [asImage showInView:self.view];
    }
    else{*/
        //[self chooseImage];
    //}
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

-(void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{
    NSString *title= [actionSheet buttonTitleAtIndex:buttonIndex];
    if([actionSheet isEqual:photoActionSheet]){
   
        if([title isEqualToString:AS_CHOOSE_CAMERA]){
            [self useCameraAction];
        }
        else if([title isEqualToString:AS_CHOOSE_PHOTOLIB]){
            
            [self usePhotoLibraryAction];
        }
        else if([title isEqualToString:AS_CHOOSE_REMOVEIMAGE]){
            
            [_pictureFile setImage:[UIImage imageNamed:@"empty_image"]];
            hasImage=NO;
            
        }
    }
    
    
    
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
    return [_appDelegate.inventoryModel.inventory.categories count];
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    ProductCategory *cat=_appDelegate.inventoryModel.inventory.categories[row];
    return cat.name;
}

/*
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if(buttonIndex==[actionSheet cancelButtonIndex])
        return;
    
    NSString *btnTitle=[actionSheet buttonTitleAtIndex:buttonIndex];
    
    if ([btnTitle isEqualToString:AS_CHOOSE_IMAGE]) {
        
        [self showSelectImageSource];
        
        
    }
    else if ([btnTitle isEqualToString:AS_REMOVE_IMAGE]) {
        
        [_pictureFile setImage:[UIImage imageNamed:@"empty_picture"]];
        hasImage=NO;
        
        //_selectedProduct.pictureFile=@"";
        
        
    }
}
*/
//- (IBAction)unlimittedToggleTapped:(id)sender {
//    if (_unlimittedToggle.isOn) {
//        _remainingTextField.text=@"";
//    }
//    else{
//        _remainingTextField.text=[NSString stringWithFormat:@"%lu",(unsigned long)_selectedProduct.instock];
//    }
//}
/*-(void)textFieldDidBeginEditing:(UITextField *)textField{
}
 */

- (BOOL)textView:(UITextView*)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString*)text
{
    /*if ([textView.text isEqualToString:PlaceHolderText]) {
        textView.text=@"";
        return YES;
        
    }
    else if(text.length==0 && textView.text.length==1){
        [self textViewPlaceHolder:textView text:PlaceHolderText];
        return NO;
    }
    */
    return (textView.text.length+(text.length-range.length)<=MaxNotesLength);
    
}
-(void)textViewDidChangeSelection:(UITextView *)textView{
    /*if ([textView.text isEqualToString:PlaceHolderText]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            textView.selectedRange=NSMakeRange(0, 0);
        });
    }
     */
}

-(void)textViewDidBeginEditing:(UITextView *)textView{
    /*if ([textView.text isEqualToString:PlaceHolderText]) {
        //textView.text=nil;
        dispatch_async(dispatch_get_main_queue(), ^{
            textView.selectedRange=NSMakeRange(0, 0);
        });
    }
     */
}


//rom
-(void)textViewPlaceHolder:(UITextView *)textView text:(NSString *)text{
    //UIFont *font=textView.font;
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


-(void)actionDone:(id)sender{
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
    hasImage=YES;
    
    /*    photo=[NSString stringWithFormat:@"%@%@.png",PREFIX_MYPHOTO, _appDelegate.appConfig.device_id];
     
     }
     else if(_selectedPhotoPicker==PHOTO_PICKER_BACKG){
     photo=[NSString stringWithFormat:@"%@%@.png",PREFIX_MYBGPHOTO, _appDelegate.appConfig.device_id];
     [self.photobgImageField setImage:image];
     [_appDelegate setBackgroundImage];
     }
     */
    [self hideImagePicker];
    
    //[self saveImage];
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
        [self.popoverController presentPopoverFromRect:CGRectZero inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        
    } else {
        
       // [self presentModalViewController:self.imagePicker.imagePickerController animated:YES];
        [self presentViewController:self.imagePicker.imagePickerController  animated:YES completion:nil];
        
        
    }
}

- (IBAction)togglePublishedLocal:(id)sender {
    _selectedCategory.publishedLocal=[_isPublishedLocal isOn];
     
}


- (IBAction)togglePublishedInternet:(id)sender {
    _selectedCategory.publishedInternet=[_isPublishedInternet isOn];
}


@end
