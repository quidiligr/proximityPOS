//
//  AppSettingsViewController.m

#import "MyInfoSettingsViewController.h"

#import "AppConfigInputCell.h"
#import "AppConfigImageCell.h"
#import "AppConfigDisplayCell.h"
#import "AppDelegate.h"
#import "GKImagePicker.h"
#import "AppConfigModel.h"
#import "CCardsViewController.h"
#import "NSData+Conversion.h"
#import "BroadcastMessageAPI.h"
#import "defs.h"



@interface MyInfoSettingsViewController () <UITableViewDataSource, UITableViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,GKImagePickerDelegate>{
    //BOOL nicknameChanged;
    //BOOL bgPhotoChanged;
    //BOOL photoChanged;
    BOOL configChanged;
    NSString *oldName;
    
    UIBarButtonItem *saveButton;
    
     NSString *pat;
    NSTimer *t;
    BOOL needsReconnect;
    
}
@property (strong, nonatomic) IBOutlet UITableView* tableView;
//@property (strong, nonatomic) IBOutlet UIView* buttonView;
@property (strong, nonatomic) IBOutlet UIButton* completeButton;

@property (strong, nonatomic) UITextField* nickNameTextField;
@property (strong, nonatomic) UITextField* fullNameTextField;
@property (strong, nonatomic) IBOutlet UITextField *announceTextField;
@property (strong, nonatomic) UILabel* displayNameLabel;
@property (strong, nonatomic) UIImageView* photoImageField;
@property (strong, nonatomic) UIImageView* photobgImageField;

@property (nonatomic, strong) AppDelegate *appDelegate;

//@property (nonatomic, strong) NSDictionary *config;

@property (nonatomic, strong) UIImagePickerController *pickerPhoto;
@property (nonatomic, strong) UIImagePickerController *pickerBgPhoto;

@property (weak, nonatomic) IBOutlet UISwitch *swVisible;


@property (nonatomic, strong) UIPopoverController *popOver;
@property (nonatomic, strong) GKImagePicker *imagePicker;


@end

@implementation MyInfoSettingsViewController
/*- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
 */
- (id)init {
    self = [super init];
    if (self) {
        //Custom initialization
        //self.productsArray = [[NSMutableArray alloc] init];
        //_inventoryModel = [[InventoryModel alloc] init];
        //self.orders=[NSMutableArray new];
        //self.dates=[NSMutableArray new];
        //self.history=[NSMutableDictionary new];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
    self.view.backgroundColor=[UIColor clearColor];
    _appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if(_appDelegate.appConfig.userInfo.fullName.length==0){
        _appDelegate.appConfig.userInfo.fullName=@"Unknown";
        _appDelegate.appConfig.userInfo.displayName=@"Unknown";
    }
    
    self.nickNameTextField.text=_appDelegate.appConfig.userInfo.displayName;
    self.fullNameTextField.text=_appDelegate.appConfig.userInfo.fullName;
    
    oldName=_appDelegate.appConfig.userInfo.fullName;
    
    
    
    saveButton=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(saveButtonTapped)];
    
    self.navigationItem.leftBarButtonItem=saveButton;
    
   [self configurePickerView];
    
    pat=@"[a-zA-Z0-9\\s]+";
    
    needsReconnect=NO;
    
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [self.tableView reloadData];
    [self configurePickerView];
}

-(void)viewDidDisappear:(BOOL)animated{
    /*self.nickNameTextField.text=[self.nickNameTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" "]];
    
        if(self.nickNameTextField.text.length>0){
        
        if(![self.nickNameTextField.text isEqualToString:_appDelegate.appConfig.userInfo.displayName]){
           
            _appDelegate.appConfig.userInfo.displayName=self.nickNameTextField.text;
            
            [AppConfigModel saveSettings];

        }
    }
   */
    //[self saveSettings];
   
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -


-(void)saveSettings{
    _appDelegate.appConfig.userInfo.announceText=self.announceTextField.text;
    [AppConfigModel saveSettings];
    
    self.fullNameTextField.text=[self.fullNameTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" "]];
    
    NSError *error;
    NSRegularExpression *regex=[[NSRegularExpression alloc] initWithPattern:@" +" options:NSRegularExpressionCaseInsensitive error:&error];
    NSString *trimmedString=[regex stringByReplacingMatchesInString:self.fullNameTextField.text options:0 range:NSMakeRange(0, [self.fullNameTextField.text length]) withTemplate:@" "];
    self.fullNameTextField.text=trimmedString;
    
    
    NSString *newName=self.fullNameTextField.text;
    
    if(newName.length==0)
        newName=oldName;
    
    if([[newName lowercaseString] isEqualToString:@"everyone"])
        newName=oldName;
    
    if(![newName isEqualToString:oldName]){
        configChanged=YES;
        _appDelegate.appConfig.userInfo.fullName=newName;
        _appDelegate.appConfig.userInfo.displayName=[UserInfo getDisplayName:_appDelegate.appConfig.userInfo.fullName];
    }
    
    if(configChanged){
        [AppConfigModel saveSettings];
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_APPCONFIG_UPDATE object:nil];
    }
}
-(void)saveButtonTapped{
    [self saveSettings];
    
    //NSString *message=[error localizedDescription];
    if(configChanged){
        if(_appDelegate.selectedStore.peerInfo!=nil && _appDelegate.selectedStore.peerInfo.sessionState==MCSessionStateConnected){
           /*[_appDelegate.mcManager.browser stopBrowsingForPeers];
            UIAlertView *toast=[[UIAlertView alloc] initWithTitle:nil message:@"Restaring connection..." delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
            [toast show];
            //int duration=2;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                    [toast dismissWithClickedButtonIndex:0 animated:YES];
                
                
                        [self.navigationController dismissViewControllerAnimated:YES completion:^{
                        
                             [_appDelegate.mcManager.session disconnect];
                            [_appDelegate.mcManager.browser startBrowsingForPeers];
                        
                    }];
                
            });
            */
            BroadcastMessageAPI *update_message=[[BroadcastMessageAPI alloc] init];
            //update_message.text=[AppDelegate toJsonString:@{@"deviceid":_appDelegate.appConfig.userInfo.deviceID,@"peername":_appDelegate.appConfig.userInfo.displayName,@"photomd5":(_appDelegate.appConfig.userInfo.myPhotoMD5!=nil)?_appDelegate.appConfig.userInfo.myPhotoMD5:@""}];
            update_message.text=[AppDelegate toJsonString:@{@"peername":_appDelegate.appConfig.userInfo.displayName,@"photomd5":(_appDelegate.appConfig.userInfo.myPhotoMD5!=nil)?_appDelegate.appConfig.userInfo.myPhotoMD5:@""}];
            update_message.isBroadcast=NO;
            update_message.toPeerInfo=nil;
            update_message.message_type=MSG_TYPE_REQUEST_UPDATEINFO;
            update_message.localCopy=NO;
            
            //[self sendMyMessage:update_message];
            NSDictionary *dict = @{KEY_SEND_MESSAGE: update_message
                                   };
            
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_HAS_DATA_TO_SEND
             
             
             
                                                                object:nil
                                                              userInfo:dict];


        }
        //else{
        //    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        //}
    }
    //else{
    //    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
   // }
   /* if(_appDelegate.isIpad){
        [self.navigationController popViewControllerAnimated:YES];
    }
    else{
    */
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];//^{
   //  [self.tabBarController setSelectedIndex:TAB_INDEX_CHAT];
   // }];
    //}
    
}

- (void)configurePickerView {
   
    UIToolbar *pickerToolbar = [[UIToolbar alloc] init];
    pickerToolbar.barStyle = UIBarStyleDefault;
    [pickerToolbar sizeToFit];
    
    UIBarButtonItem *flexibleSpaceLeft = [[UIBarButtonItem alloc]
                                          initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                          target:nil
                                          action:nil];
    
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                     style:UIBarButtonItemStyleBordered
                                                                    target:self
                                                                    action:@selector(cancelMessage)];
    
    UIBarButtonItem *clearButton = [[UIBarButtonItem alloc] initWithTitle:@"Clear"
                                                                    style:UIBarButtonItemStyleBordered
                                                                   target:self
                                                                   action:@selector(clearMessage)];
    
    [pickerToolbar setItems:[NSArray arrayWithObjects:flexibleSpaceLeft, cancelButton,clearButton,nil]];
    
    
    
    self.fullNameTextField.inputAccessoryView=pickerToolbar;
    self.announceTextField.inputAccessoryView=pickerToolbar;
}
 

- (void)clearMessage{
    self.fullNameTextField.text=@"";
}

- (void)cancelMessage{
   
    //[_fullNameTextField resignFirstResponder];
   // []
    
    [self.view endEditing:YES];
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if([textField isEqual:self.fullNameTextField]){
    if(self.fullNameTextField.text.length>35)
        return false;
    
    if(![string isEqualToString:@""]){
   
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pat options:0 error:NULL];
    NSTextCheckingResult *match = [regex firstMatchInString:string options:0 range:NSMakeRange(0, [string length])];
    if(match==nil)
        return false;
    
    }
    
   
        if([t isValid]){
            [t invalidate];
        }
      t=[NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(updateNickName) userInfo:nil repeats:NO];
    
    return true;
    }
    else if([textField isEqual:self.announceTextField]) {
        if(self.announceTextField.text.length>200)
            return false;
        else
            return true;
    }
    return true;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    CGPoint origin = textField.frame.origin;
    CGPoint point = [textField.superview convertPoint:origin toView:self.tableView];
    
    NSIndexPath * indexPath = [self.tableView indexPathForRowAtPoint:point];
    
   // [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];

    
   // NSIndexPath *indexPath = [self.tableView indexPathForCell:textFieldRowCell];
    
        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    //}
    return YES;
}
-(BOOL)textFieldShouldEndEditing:(UITextField *)textField{
   // if([textField isEqual:self.announceTextField]){
        NSIndexPath *ip=[NSIndexPath indexPathForRow:0 inSection:0];
        [self.tableView scrollToRowAtIndexPath:ip atScrollPosition:UITableViewScrollPositionTop animated:YES];
        //[self.tableView scrollsToTop];
    //}
    return  YES;
}

-(void)updateNickName{
    self.fullNameTextField.text=[self.fullNameTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" "]];
    
    NSError *error;
    NSRegularExpression *regex=[[NSRegularExpression alloc] initWithPattern:@" +" options:NSRegularExpressionCaseInsensitive error:&error];
    NSString *trimmedString=[regex stringByReplacingMatchesInString:self.fullNameTextField.text options:0 range:NSMakeRange(0, [self.fullNameTextField.text length]) withTemplate:@" "];
    self.fullNameTextField.text=trimmedString;
    
    
    //NSString *newName=self.fullNameTextField.text;
    
    //if(newName.length==0)
    //    newName=oldName;
    
    //if(![newName isEqualToString:oldName]){
     //   configChanged=YES;
    //appDelegate.appConfig.userInfo.fullName=newName;
        //self.nic=[UserInfo getDisplayName:_appDelegate.appConfig.userInfo.fullName];
   // }
    self.displayNameLabel.text=[UserInfo getDisplayName:self.fullNameTextField.text];
    

}


- (IBAction)completeButtonTapped:(id)sender {
    
    /*self.nickNameTextField.text=[self.nickNameTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" "]];
    
    if(self.nickNameTextField.text.length==0)
        return;
    */
    self.fullNameTextField.text=[self.fullNameTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" "]];
    
    if(self.fullNameTextField.text.length==0)
        return;
    
    /*NSError *error;
    NSRegularExpression *regex=[[NSRegularExpression alloc] initWithPattern:@" +" options:NSRegularExpressionCaseInsensitive error:&error];
    NSString *trimmedString=[regex stringByReplacingMatchesInString:_appConfig.userInfo.fullName options:0 range:NSMakeRange(0, [_appConfig.userInfo.fullName length]) withTemplate:@" "];
    _appConfig.userInfo.fullName=trimmedString;
    
    _appConfig.userInfo.displayName=[UserInfo getDisplayName:_appConfig.userInfo.fullName];//[[UIDevice currentDevice] name];
    NSString *lower=[_appConfig.userInfo.displayName lowercaseString];
    
    if([lower isEqualToString:@"manager"] || [lower isEqualToString:@"owner"] || [lower isEqualToString:@"staff"] || [lower isEqualToString:@"cashier"] || [lower isEqualToString:@"register"] || [lower isEqualToString:@"waiter"] || [lower isEqualToString:@"waitress"] || [lower isEqualToString:@"bartender"] || [lower isEqualToString:@"police"] || [lower isEqualToString:@"ceo"] || [lower isEqualToString:@"president"]){
        _appConfig.userInfo.displayName=@"Unknown";
    }
   */
    [self.navigationController popViewControllerAnimated:YES];

    
}



-(BOOL)renameItem:(NSString *)fromName toName:(NSString *)toName{
    NSString *documentPath= [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSFileManager *fileManager=[NSFileManager defaultManager];
    
    
    NSString *fromFileName=[fromName stringByAppendingString:@".inventory.plist"];
    NSString *fromPath=[documentPath stringByAppendingPathComponent:fromFileName];
    
    NSString *toFileName=[toName stringByAppendingString:@".inventory.plist"];
    NSString *toPath=[documentPath stringByAppendingPathComponent:toFileName];
    
    BOOL success=YES;
    if ([fileManager fileExistsAtPath:fromPath]) {
        NSError *error;
        
        success=[fileManager moveItemAtPath:fromPath toPath:toPath error:&error];
        
    }
    
    return success;
    
}



#pragma mark - UITableViewDataSource methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1; // (1) user details, (2) credit card details
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"";//(section == 0) ? @"Customer Info" : @"Credit Card Details";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;//(section == 0) ? 3 : 3;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==2) {
        [self saveSettings];
        //[self photoTapped];
        UIActionSheet *photoActionSheet= [[UIActionSheet alloc]
                             initWithTitle: nil
                             delegate:self
                             cancelButtonTitle:@"Cancel"
                             destructiveButtonTitle: nil
                             otherButtonTitles:@"Take Photo",@"Select Photo", NULL];
        [photoActionSheet showInView:self.parentViewController.view ];
        

    }
    
//    else if (indexPath.row==3){ //credit cards
//        //[self bgphotoTapped];
//        //[self performSegueWithIdentifier:@"toCCardsViewController" sender:self];
//        CCardsViewController* destViewController = (CCardsViewController*) [ApplicationDelegate.storyBoard instantiateViewControllerWithIdentifier:@"CCardsViewController"];
//        //browser.delegate = self;
//        
//        UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:destViewController];
//        
//        [self presentViewController:nav animated:YES completion:nil];    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    if(section==0){
        if (row == 0) {
            AppConfigInputCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"AppConfigInputCell"];
            cell.nameLabel.text = @"Name";
            
            if(_appDelegate.appConfig.userInfo.fullName && _appDelegate.appConfig.userInfo.fullName.length>0)
                cell.textField.text=_appDelegate.appConfig.userInfo.fullName;
            else
                cell.textField.text=[[UIDevice currentDevice] name];
            
            cell.textField.placeholder = @"Required";
            
            cell.textField.keyboardType = UIKeyboardTypeAlphabet;
            self.fullNameTextField = cell.textField;
            self.fullNameTextField.delegate=self;
            cell.helpLabel.text=@"Your fullname. Not visible to others.";
            return cell;

        }
        
        else if (row == 1) {
            
            AppConfigDisplayCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"AppConfigDisplayCell"];
            cell.nameLabel.text = @"Display name";
            
            if(_appDelegate.appConfig.userInfo.fullName && _appDelegate.appConfig.userInfo.fullName.length>0){
                _appDelegate.appConfig.userInfo.displayName=[UserInfo getDisplayName:_appDelegate.appConfig.userInfo.fullName];
                cell.displayLabel.text=_appDelegate.appConfig.userInfo.displayName;
                
            }
            self.displayNameLabel=cell.displayLabel;
            /*else
                cell.textField.text=[[UIDevice currentDevice] name];
            cell.textField.placeholder = @"Required";
            
            cell.textField.keyboardType = UIKeyboardTypeAlphabet;
            self.nickNameTextField = cell.textField;
            */
            cell.helpLabel.text=@"Visible to others. Shows firstname and first letter of your lastname.";
             return cell;
        }

        else if (row == 2) {
            AppConfigImageCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"AppConfigImageCell"];
            cell.nameLabel.text = @"Photo/Logo";
            
            CGRect frame=cell.imageField.frame;
            frame.size.width=48.0;
            frame.size.height=48.0;
            cell.imageField.frame=frame;
            cell.imageField.image=[self loadPhoto:[NSString stringWithFormat:@"myphoto-%@.png",_appDelegate.appConfig.userInfo.deviceID]];
            
            cell.imageField.layer.cornerRadius=cell.imageField.frame.size.width / 2;//cell.senderPhoto.frame.size.width / 2;
            cell.imageField.clipsToBounds = YES;
        
            self.photoImageField = cell.imageField;
            
            cell.helpLabel.text=@"Your photo will be used when picking-up orders.";
            cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
            return cell;
        }
        else if (row == 3) {
            AppConfigInputCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"AppConfigInputCell"];
            cell.nameLabel.text = @"Announce";
            cell.helpLabel.text=@"Leave blank if you don't want to announce yourself when connected.";
            //if(_appDelegate.appConfig.userInfo.fullName && _appDelegate.appConfig.userInfo.fullName.length>0)
             //   cell.textField.text=_appDelegate.appConfig.userInfo.fullName;
            //else
            cell.textField.text=_appDelegate.appConfig.userInfo.announceText;//[[UIDevice currentDevice] name];
            
            cell.textField.placeholder = @"";
            
            cell.textField.keyboardType = UIKeyboardTypeAlphabet;
            self.announceTextField = cell.textField;
            self.announceTextField.delegate=self;
            return cell;
            
        }
        
//        else if (row == 3) {
//            UITableViewCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"CCardCell"];
//            cell.textLabel.text=@"My Credit Cards";
//            cell.detailTextLabel.text=[NSString stringWithFormat:@"Total: %lu",(unsigned long)[_appDelegate.appConfig.userInfo.ccards count]];
//            cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
//            return cell;
//        }
    }
    /*else if(section==1){
        if (row == 0) {
            AppConfigInputCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"AppConfigInputCell"];
            cell.nameLabel.text = @"Number";
            
            if(_appDelegate.appConfig.userInfo.displayName)
                cell.textField.text=_appDelegate.appConfig.userInfo.displayName;
            else
                cell.textField.text=[[UIDevice currentDevice] name];
            cell.textField.placeholder = @"Required";
            
            cell.textField.keyboardType = UIKeyboardTypeAlphabet;
            self.nickNameTextField = cell.textField;
            return cell;
        }
    }
    */
    /*else if (section == 0 && row == 2) {
        AppConfigImageCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"AppConfigImageCell"];
        cell.nameLabel.text = @"Background Image";
        
        CGRect frame=cell.imageField.frame;
        frame.size.width=48.0;
        frame.size.height=48.0;
        
        cell.imageField.frame=frame;
        
        cell.imageField.image=[self loadBgPhoto:[NSString stringWithFormat:@"mybgphoto-%@.png",_appDelegate.appConfig.userInfo.deviceID]];
        
        
        self.photoImageField = cell.imageField;
        
        UITapGestureRecognizer *bgPhotoTap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bgphotoTapped)];
        bgPhotoTap.numberOfTapsRequired=1;
        [self.photobgImageField setUserInteractionEnabled:YES];
        [self.photobgImageField addGestureRecognizer:bgPhotoTap];
        
        return cell;

    }
    */

    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==2) {
        return 100.0;
    }
    else{
        return 82.0;
    }
}

-(UIImage *)loadPhoto:(NSString *)photo{
    
    UIImage *image=nil;
    /*NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDirectory = paths[0];
    */
    NSString *filePath=[[AppDelegate getDocumentsPath] stringByAppendingPathComponent:photo];
    
    //check if cached
    if([[NSFileManager defaultManager] fileExistsAtPath:filePath]){
        image=[[UIImage alloc] initWithContentsOfFile:filePath];
        
    }
    else{
        //TODO: return empty
        image=[UIImage imageNamed:@"empty"];
    }
    return image;

}

#pragma mark - UITableViewDelegate methods

/*- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

}
*/
#pragma mark - UIPicker data source

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if(pickerView.tag==1)
        return (component == 0) ? 3 : 0;
    else if(pickerView.tag==2)
        return (component == 0) ? 2 : 0;
    else
        return 0;
}

#pragma mark - UIPicker delegate
/*
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if(pickerView.tag==1){
        if (component == 0) {
            return [self.paymentArray objectAtIndex:row]; //self.paymentArray[row];
        }
    }
    else if(pickerView.tag==2){
        if (component == 0) {
            return [self.yesNoArray objectAtIndex:row];
        }
    }
    return nil;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if(pickerView.tag==1){
        if (component == 0) {
            self.selectedPayment = row;
        }
        
        //if (!self.selectedPayment) {
        //    [self.paymentPicker selectRow:0 inComponent:0 animated:YES];
          //  self.selectedPayment = PAY_BOTH; //Default
        //}
        
        self.paymentTextField.text =[_paymentArray objectAtIndex:self.selectedPayment];
        self.paymentTextField.textColor = [UIColor blackColor];
    }
    else if(pickerView.tag==2){
        if (component == 0) {
            self.selectedYesNo = row;
        }
        
 
        self.yesNoTextField.text =[_yesNoArray objectAtIndex:self.selectedYesNo];
        self.yesNoTextField.textColor = [UIColor blackColor];
    }
    
}
 */


-(void)selectPhotoAction{
    self.pickerPhoto=[[UIImagePickerController alloc] init];
    self.pickerPhoto.modalPresentationStyle=UIModalPresentationCurrentContext;
    self.pickerPhoto.delegate=self;
    self.pickerPhoto.allowsEditing=YES;
    
    self.pickerPhoto.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:self.pickerPhoto animated:YES
                     completion:NULL];
}
-(void)bgphotoTapped{
    self.pickerBgPhoto=[[UIImagePickerController alloc] init];
    self.pickerBgPhoto.modalPresentationStyle=UIModalPresentationCurrentContext;
    self.pickerBgPhoto.delegate=self;
    self.pickerBgPhoto.allowsEditing=YES;
    self.pickerBgPhoto.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:self.pickerBgPhoto animated:YES
                     completion:NULL];
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
   
    
    
    UIImage *chosenImage=info[UIImagePickerControllerEditedImage];
    
    
   

    
    [picker dismissViewControllerAnimated:YES completion:^{
        [self finalMyPhoto: chosenImage];
            }];
}

-(void)finalMyPhoto:(UIImage *)chosenImage{
    NSString *photo=[NSString stringWithFormat:@"%@%@.png",PREFIX_MYPHOTO, _appDelegate.appConfig.userInfo.deviceID];
    
    NSString *filePath=[[AppDelegate getDocumentsPath] stringByAppendingPathComponent:photo];
    //save image
    NSData *data=UIImagePNGRepresentation(chosenImage);
    [data writeToFile:filePath atomically:YES];
    
    
    _appDelegate.appConfig.userInfo.myPhotoMD5=[[ data MD5] uppercaseString];
    
    configChanged=YES;
    needsReconnect=YES;
}

-(void)takePhotoActionn{
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
            [self performSelector:@selector(showcamera) withObject:nil afterDelay:0.3];
        
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
    picker.allowsEditing=YES;
    picker.sourceType=UIImagePickerControllerSourceTypeCamera;
    [self presentViewController:picker animated:YES
                     completion:NULL];
}

- (void)pickerDoneButtonPressed {
    [self.view endEditing:YES];
    
        //if([self.completeButton isHidden])
     //   [self.completeButton setHidden:NO];
    
    /*self.nickNameTextField.text=[self.nickNameTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" "]];
    
    if(self.nickNameTextField.text.length>0)
        _appDelegate.appConfig.userInfo.displayName=self.nickNameTextField.text;
    */
    /*
    self.fullNameTextField.text=[self.fullNameTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" "]];
    
    f(self.fullNameTextField.text.length>0)
        _appDelegate.appConfig.userInfo.fullName=self.fullNameTextField.text;
    
      [AppConfigModel saveSettings];*/
}
/*
-(void)stateChaged:(UISwitch *)switchState{
    if([switchState isOn]){
        _isActiveInventory=YES;
    }
    else{
        _isActiveInventory=NO;
    }
}
*/

- (IBAction)toggleVisibility:(id)sender {
   // [self.appDelegate.mcManager advertiseSelf:_swVisible.isOn];
}
/*
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
}
 */
#pragma mark Actions
-(void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{
    NSString *title= [actionSheet buttonTitleAtIndex:buttonIndex];
   
    
        if([title isEqualToString:@"Take Photo"]){
            [self takePhotoActionn];
        }
        else if([title isEqualToString:@"Select Photo"]){
            
            //[self selectPhotoAction];
            [self showResizablePicker];
        }

    
}

# pragma mark -
# pragma mark GKImagePicker Delegate Methods

- (void)imagePicker:(GKImagePicker *)imagePicker pickedImage:(UIImage *)image{
    
    UIImage *chosenImage = image;
    
    
    
    
    if (UIUserInterfaceIdiomPad == UI_USER_INTERFACE_IDIOM()) {
        
        [self.popOver dismissPopoverAnimated:YES];
        [self finalMyPhoto:chosenImage];
        
    } else {
        
        [self.imagePicker.imagePickerController dismissViewControllerAnimated:YES completion:^{
            [self finalMyPhoto:chosenImage];
        }];
        
    }
}


-(void)showResizablePicker{
    self.imagePicker = [[GKImagePicker alloc] init];
    self.imagePicker.cropSize = CGSizeMake(296, 300);
    self.imagePicker.delegate = self;
    self.imagePicker.resizeableCropArea = YES;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        
        self.popOver = [[UIPopoverController alloc] initWithContentViewController:self.imagePicker.imagePickerController];
        //[self.popoverController presentPopoverFromRect:btn.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        //[self.popoverController presentPopoverFromBarButtonItem:_doneButton permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        [self.popOver presentPopoverFromRect:CGRectZero inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        
    } else {
        
        //[self presentModalViewController:self.imagePicker.imagePickerController animated:YES];
        
        [self presentViewController:self.imagePicker.imagePickerController  animated:YES completion:nil];
    }
}
@end
