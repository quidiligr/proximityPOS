//
//  InventoryViewController.m
//
//
//  Created by Romulo Quidilig.
//  Copyright (c) 2015 Sharecle Inc. All rights reserved.
//


#import "EditCategoryViewController.h"
#import "InventoryModel.h"
#import "InventoryItem.h"
#import "AppDelegate.h"
#import "Product.h"
#import "ProductCategory.h"
#import "NSData+Conversion.h"
#import "defs.h"
#define PlaceHolderText  @"Your category detail here"
#define MaxNotesLength 300

@interface EditCategoryViewController ()<GKImagePickerDelegate>{
    NSString *documentPath;
    NSString *imagesPath;
  
    BOOL imageChanged;
   
    NSDictionary *inventory;
   
    //ProductCategory *newCategory;
    
    //InventoryModel* _inventoryModel;
    
    //UIActionSheet *asImage;
    UIActionSheet *photoActionSheet;
    UIBarButtonItem *_saveButton;
    UIBarButtonItem *_doneButton;
    BOOL hasImage;
    
    AppDelegate *_appDelegate;
    
}
@property (strong, nonatomic) IBOutlet UITextField *nameTextField;

@property (strong, nonatomic) IBOutlet UIImageView *pictureFile;

@property (strong, nonatomic) IBOutlet UITableViewCell *showProductsCell;

@property (strong, nonatomic) IBOutlet UITextView *descriptionTextField;
@property (strong, nonatomic) IBOutlet UILabel *productsLabel;
@property (nonatomic, strong) UIImagePickerController *pickerPhoto;


//gkimagepicker
@property (nonatomic, strong) GKImagePicker *imagePicker;
@property (nonatomic, strong) UIPopoverController *popoverController;
@property (nonatomic, strong) UIImagePickerController *ctr;
@property (strong, nonatomic) IBOutlet UISwitch *isPublishedLocal;
@property (strong, nonatomic) IBOutlet UISwitch *isPublishedInternet;

@end

@implementation EditCategoryViewController

extern int g_NeedToPublish;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    _appDelegate=ApplicationDelegate;
    
   // _inventoryModel=[InventoryModel sharedInstance];
    
    
    
    documentPath= [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    
    
    _doneButton=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(actionDone:)];
    self.navigationItem.leftBarButtonItem=_doneButton;
    
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(actionSave:)];
    
    [[self.descriptionTextField layer] setBorderColor:[[[UIColor grayColor] colorWithAlphaComponent:0.5] CGColor]];
    [[self.descriptionTextField layer] setBorderWidth:1.0];//setBorderWidth:2.3];
    [[self.descriptionTextField layer] setCornerRadius:2];
    

    /*
    asImage=[[UIActionSheet alloc] initWithTitle:@"Edit Image" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:AS_CHOOSE_IMAGE,AS_REMOVE_IMAGE, nil];
    */
    imagesPath=[AppDelegate getImagesPath];
    
    imageChanged=NO;
    
    //if(self.isUpdateProduct){
     //   self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(actionSave:)];
    
    
    
     UITapGestureRecognizer *imageTap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTapped)];
    imageTap.numberOfTapsRequired=1;
    [_pictureFile setUserInteractionEnabled:YES];
    [_pictureFile addGestureRecognizer:imageTap];
    
    [self displayCategory];
    [self configurePickerView];
    /*
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        self.navigationItem.hidesBackButton=YES;
        
    }
    else{
        //self.navigationItem.rightBarButtonItem=saveButton;
    }
    */
}
/*
-(void)showStartProduct:(NSNotification *)notification{
    [self performSegueWithIdentifier:@"toStartProductViewController" sender:self];
}
*/
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [_isPublishedLocal setOn:_selectedCategory.publishedLocal];
    [_isPublishedInternet setOn:_selectedCategory.publishedInternet];
   
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
    
   if(_nameTextField.text==nil || _nameTextField.text.length==0)
       return;
    
    _nameTextField.text=[_nameTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" "]];
    
    if(_nameTextField.text.length==0)
        return;
    
    _descriptionTextField.text=[_descriptionTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" "]];
    
    _descriptionTextField.text=[_descriptionTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"\n"]];
    
    _descriptionTextField.text=([_descriptionTextField.text isEqualToString:PlaceHolderText])?@"":_descriptionTextField.text;

    
    
    NSString *newPictureFile=@"";
    if(hasImage){
            NSData *imageData=[[NSData alloc] initWithData:UIImagePNGRepresentation(_pictureFile.image)];
    
            if(imageData){
                //NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                
                newPictureFile=[NSString stringWithFormat:@"%@.png",[imageData MD5]];
                
                
                if(imagesPath!=nil){
                    NSString *filePath=[imagesPath stringByAppendingPathComponent:newPictureFile];
                    
                    //save image
                    if(![[NSFileManager defaultManager] fileExistsAtPath:filePath])
                        [imageData writeToFile:filePath atomically:YES];
                    
                    //_selectedCategory.pictureFile=newPictureFile;
                }
            }
    }
    
            //else{
             //   _selectedCategory.pictureFile=@"";
            //}
        //}
        //}
    
    //@try {
       // [_inventoryModel addInventory:_selectedProduct];
    self.selectedCategory.pictureFile=newPictureFile;
    self.selectedCategory.name=_nameTextField.text;
    self.selectedCategory.detail=_descriptionTextField.text;
    //self.selectedCategory.pictureFile=newPictureFile;
    
    
    [_appDelegate.inventoryModel saveInventory];
    
  
    //[self dismissViewControllerAnimated:YES completion:nil];
     [self.delegate editCategoryViewControllerDidUpdateCategory:self];
}
/*
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    if (component == 0) {
        _selectedCategory=[_inventoryModel.categories objectAtIndex:row];
        self.categoryTextField.text=_selectedCategory.name;
        self.categoryTextField.textColor = [UIColor blackColor];
    }
    
    
}
*/
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
    
    UIBarButtonItem *clearButton = [[UIBarButtonItem alloc] initWithTitle:@"Clear"
                                                                    style:UIBarButtonItemStyleBordered
                                                                   target:self
                                                                   action:@selector(pickerClearButtonPressed)];
    
    [pickerToolbar setItems:[NSArray arrayWithObjects:flexibleSpaceLeft,clearButton, doneButton, nil]];

    
    
  
    
    
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
-(void)chooseImage{
    UIImagePickerController *picker=[[UIImagePickerController alloc] init];
    picker.modalPresentationStyle=UIModalPresentationCurrentContext;
    picker.delegate=self;
    picker.allowsEditing=YES;
    picker.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:picker animated:YES
                     completion:NULL];
}


-(void)imageTapped{
    /*if(_selectedProduct.pictureFile.length>0){
        [asImage showInView:self.view];
    }
    else{*/
       // [self chooseImage];
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
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    //[self setHiddenSaveButton:NO];
    
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
        
        [self chooseImage];
        
        
    }
    else if ([btnTitle isEqualToString:AS_REMOVE_IMAGE]) {
        
        [_pictureFile setImage:[UIImage imageNamed:@"empty_picture"]];
        
        hasImage=NO;
        //_selectedProduct.pictureFile=@"";
        
        
    }
}
 */
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
            
            [self removeImage];
            
        }
    }
    
    
    
}

-(void)removeImage{
    _selectedCategory.pictureFile=@"";
    hasImage=NO;
    [_pictureFile setImage:[UIImage imageNamed:@"empty_picture"]];
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
    
    [self setHiddenSaveButton:NO];

    
    
    if ([textView.text isEqualToString:PlaceHolderText]) {
        //textView.text=nil;
        dispatch_async(dispatch_get_main_queue(), ^{
            textView.selectedRange=NSMakeRange(0, 0);
        });
    }
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    [self setHiddenSaveButton:NO];

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
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section==0 && indexPath.row==0){
        //[[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_SHOW_PRODUCTS object:nil userInfo:@{@"selection":@"products",@"selectedCategory":_selectedCategory,@"selectedInventory":_appDelegate.inventoryModel.inventory}];
        /*[[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_SHOW_PRODUCTS object:nil userInfo:@{@"selectedCategory":_selectedCategory}];
        [self.navigationController popViewControllerAnimated:YES];
         */
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_SHOW_PRODUCTS object:nil userInfo:@{@"controller":self}];
    }
}

-(void)displayCategory{
    if(_selectedCategory){
    
        //self.showProductsCell.textLabel.text=@"Products";
        //self.showProductsCell.detailTextLabel.text=[NSString stringWithFormat:@"Total: %@",@([_selectedCategory.products count])];
        //self.showProductsCell.imageView.image=[UIImage imageNamed:@"259-list.png"];
        self.title=_selectedCategory.name;//@"Edit category";
        
        self.nameTextField.text=_selectedCategory.name;
        
        self.descriptionTextField.text=_selectedCategory.detail;
        
        if(_selectedCategory.pictureFile==nil || _selectedCategory.pictureFile.length==0){
            [self removeImage];
        }
        else{
            hasImage=YES;
        //}
        
        
            
        //if(_selectedCategory.pictureFile.length>0){
            NSString *filePath=[imagesPath stringByAppendingPathComponent:_selectedCategory.pictureFile];
            
            if([[NSFileManager defaultManager] fileExistsAtPath:filePath])
                _pictureFile.image=[[UIImage alloc] initWithContentsOfFile:filePath];
            else{
                
                 [self removeImage];
            }
            
        //}
        //else{
            
        //}
        [self.tableView setHidden:NO];
        }
    }
    else{
        [self.tableView setHidden:YES];
    }
}
/*
-(void)selectedCategory:(ProductCategory *)category{
    if(category){
        [self setSelectedCategory:category];
        [self displayCategory];
        
        
        
        [self.tableView reloadData];
        
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
*/
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    /*if([segue.identifier isEqualToString:@"toStartProductViewController"]){
        
    }
     */
    
}

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
        [self.popoverController presentPopoverFromRect:CGRectZero inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        
    } else {
        
        //[self presentModalViewController:self.imagePicker.imagePickerController animated:YES];
        [self presentViewController:self.imagePicker.imagePickerController  animated:YES completion:nil];
        
    }
}

-(void)saveImage{
    NSData *imageData=[[NSData alloc] initWithData:UIImagePNGRepresentation(_pictureFile.image)];
    
   
    
     NSString *newPictureFile=[NSString stringWithFormat:@"%@.png",[imageData MD5]];
         
         
         if(imagesPath!=nil){
             NSString *filePath=[imagesPath stringByAppendingPathComponent:newPictureFile];
             
           
             if(![[NSFileManager defaultManager] fileExistsAtPath:filePath]){
                 [imageData writeToFile:filePath atomically:YES];
                 [AppDelegate toast:@"Image saved." duration:2.0];
             }
             
             //_selectedCategory.pictureFile=newPictureFile;
         }
    // }
    /*
    else{
        NSError *error;
        [[NSFileManager defaultManager] removeItemAtPath:newPictureFile error:&error];
        _selectedProduct.pictureFile=@"";
        [AppDelegate toast:@"File removed." duration:2.0];
        
    }
    */
}
- (IBAction)togglePublishedLocal:(id)sender {
    _selectedCategory.publishedLocal=[_isPublishedLocal isOn];
}


- (IBAction)togglePublishedInternet:(id)sender {
    _selectedCategory.publishedInternet=[_isPublishedInternet isOn];
}

@end
