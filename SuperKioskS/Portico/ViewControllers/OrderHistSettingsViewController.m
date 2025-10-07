//
//  AppSettingsViewController.m

#import "OrderHistSettingsViewController.h"
/*
#import "AppConfigInputCell.h"
#import "AppConfigImageCell.h"
*/
#import "OrderHistConfigDisplayCell.h"
 #import "AppDelegate.h"

#import "AppConfigModel.h"
#import "defs.h"



@interface OrderHistSettingsViewController () <UITableViewDataSource, UITableViewDelegate
   // , UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate
>{
    
   // NSArray *hoursArray;
    BOOL hasChanged;

}
@property (strong, nonatomic) IBOutlet UITableView* tableView;

@property (strong, nonatomic) IBOutlet UIBarButtonItem* doneButton;

@property (nonatomic, strong) AppDelegate *appDelegate;


@property (strong, nonatomic) IBOutlet UITextField *hoursTextField;

@property (strong, nonatomic) IBOutlet UIPickerView *pickerHours;

@end

@implementation OrderHistSettingsViewController
- (id)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor clearColor];
	
    _appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    hasChanged=NO;
    //hoursArray=@[HOURS_24,HOURS_48,HOURS_SPECIFY];
    _doneButton=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneButtonTapped:)];
    self.navigationItem.leftBarButtonItem=_doneButton;
    
    
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
     //[self configurePickerView];
    
}

-(void)viewDidDisappear:(BOOL)animated{
    if(hasChanged)
        [AppConfigModel saveSettings];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -


- (IBAction)doneButtonTapped:(id)sender {
    
    /*self.nickNameTextField.text=[self.nickNameTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" "]];
    
    if(self.nickNameTextField.text.length==0)
        return;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_APPCONFIG_UPDATE object:nil];
    [self.navigationController popViewControllerAnimated:YES];
*/
    [self dismissViewControllerAnimated:YES completion:nil];
    
}




#pragma mark - UITableViewDataSource methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1; // (1) user details, (2) credit card details
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"Show Order Status";//(section == 0) ? @"Customer Info" : @"Credit Card Details";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 6;//(section == 0) ? 3 : 3;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //status
    if(indexPath.section==0){
        hasChanged=YES;
        if(indexPath.row==0){
            if(_appDelegate.appConfig.showClosed){
                _appDelegate.appConfig.showClosed=NO;
                
            }
            else{
                _appDelegate.appConfig.showClosed=YES;
                
            }
        }
        else if(indexPath.row==1){
            if(_appDelegate.appConfig.showPaid){
                _appDelegate.appConfig.showPaid=NO;
                
            }
            else{
                _appDelegate.appConfig.showPaid=YES;
                
            }
        }
        else if(indexPath.row==2){
            if(_appDelegate.appConfig.showUnpaid){
                _appDelegate.appConfig.showUnpaid=NO;
                
            }
            else{
                _appDelegate.appConfig.showUnpaid=YES;
                
            }
        }
        else if(indexPath.row==3){
            if(_appDelegate.appConfig.showReady){
                _appDelegate.appConfig.showReady=NO;
                
            }
            else{
                _appDelegate.appConfig.showReady=YES;
                
            }
        }
        else if(indexPath.row==4){
            if(_appDelegate.appConfig.showCancelled){
                _appDelegate.appConfig.showCancelled=NO;
                
            }
            else{
                _appDelegate.appConfig.showCancelled=YES;
                
            }
        }
        else if(indexPath.row==5){
            if(_appDelegate.appConfig.showRefunds){
                _appDelegate.appConfig.showRefunds=NO;
                
            }
            else{
                _appDelegate.appConfig.showRefunds=YES;
                
            }
        }
        [self.tableView reloadData];
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath

{
    
    OrderHistConfigDisplayCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"OrderHistConfigDisplayCell" forIndexPath:indexPath];
    if(cell==nil){
        cell=[[OrderHistConfigDisplayCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"OrderHistConfigDisplayCell"];
    }
    
   // OrderHistConfigDisplayCell* cell=(OrderHistConfigDisplayCell*)[tableView cellForRowAtIndexPath:indexPath];
    if (indexPath.section == 0 && indexPath.row == 0) {
        //AppConfigInputCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"HistConfigConfigDisplayCell"];
        //cell.nameLabel.text = MENU_ORDER_VIEW_CLOSED;
        cell.nameLabel.text=MENU_ORDER_VIEW_CLOSED;
        if(_appDelegate.appConfig.showClosed){
            //_appDelegate.appConfig.showClosed=YES;
            cell.accessoryType=UITableViewCellAccessoryCheckmark;
        }
        else{
            //_appDelegate.appConfig.showClosed=NO;
            cell.accessoryType=UITableViewCellAccessoryNone;
        }
        return cell;
    }
    
    else if (indexPath.section == 0 && indexPath.row == 1) {
        
        //AppConfigInputCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"HistConfigConfigDisplayCell"];
        cell.nameLabel.text = MENU_ORDER_VIEW_PAID;
        
        if(_appDelegate.appConfig.showPaid){
            //_appDelegate.appConfig.showPaid=YES;
            cell.accessoryType=UITableViewCellAccessoryCheckmark;
        }
        else{
            //_appDelegate.appConfig.showPaid=NO;
            cell.accessoryType=UITableViewCellAccessoryNone;
        }
        return cell;
        
        
    }
    else if (indexPath.section == 0 && indexPath.row == 2) {
        
        //AppConfigInputCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"HistConfigConfigDisplayCell"];
        cell.nameLabel.text = MENU_ORDER_VIEW_UNPAID;
        
        if(_appDelegate.appConfig.showUnpaid){
            //_appDelegate.appConfig.showUnpaid=YES;
            cell.accessoryType=UITableViewCellAccessoryCheckmark;
        }
        else{
            //_appDelegate.appConfig.showUnpaid=NO;
            cell.accessoryType=UITableViewCellAccessoryNone;
        }
        return cell;
    }
    else if (indexPath.section == 0 && indexPath.row == 3) {
        
        //AppConfigInputCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"HistConfigConfigDisplayCell"];
        cell.nameLabel.text = MENU_ORDER_VIEW_READY;
        
        if(_appDelegate.appConfig.showReady){
           // _appDelegate.appConfig.showReady=YES;
            cell.accessoryType=UITableViewCellAccessoryCheckmark;
        }
        else{
            //_appDelegate.appConfig.showReady=NO;
            cell.accessoryType=UITableViewCellAccessoryNone;
        }
       return cell;
        
        
    }
    else if (indexPath.section == 0 && indexPath.row == 4) {
        
        //AppConfigInputCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"HistConfigConfigDisplayCell"];
        cell.nameLabel.text = MENU_ORDER_VIEW_CANC;
        
        if(_appDelegate.appConfig.showCancelled){
            //_appDelegate.appConfig.showCancelled=YES;
            cell.accessoryType=UITableViewCellAccessoryCheckmark;
        }
        else{
            //_appDelegate.appConfig.showCancelled=NO;
            cell.accessoryType=UITableViewCellAccessoryNone;
        }
        return cell;
        
        
    }
    else if (indexPath.section == 0 && indexPath.row == 5) {
        
        //AppConfigInputCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"HistConfigConfigDisplayCell"];
        cell.nameLabel.text = MENU_ORDER_VIEW_REFUND;
        
        if(_appDelegate.appConfig.showRefunds){
           // _appDelegate.appConfig.showRefunds=YES;
            cell.accessoryType=UITableViewCellAccessoryCheckmark;
        }
        else{
            //_appDelegate.appConfig.showRefunds=NO;
            cell.accessoryType=UITableViewCellAccessoryNone;
        }
        return cell;
        
        
    }
    return nil;
}
/*
#pragma mark - UIPicker data source

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if([pickerView isEqual:_pickerHours])
        return [hoursArray count];
    
    //else if([pickerView isEqual:_pickerSeachStatus])
      //  return [statusTypes count];
    
    return 0;
}

#pragma mark - UIPicker delegate

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    if([pickerView isEqual:_pickerHours])
        return [hoursArray objectAtIndex:row];
    
    //else if([pickerView isEqual:_pickerSeachStatus])
      //  return [statusTypes objectAtIndex:row];
    
    return nil;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    [self.view endEditing:YES];
    
    if([pickerView isEqual:_pickerHours]){
        _hoursTextField.text=
        [NSString stringWithFormat:@"%@",[hoursArray objectAtIndex:row]];
        _appDelegate.appConfig.showHours=row;
        
    }
  
    
}

#pragma mark - UIPicker configuration
- (void)configurePickerView {
    
    _hoursTextField.text=@"24";
    _pickerHours = [[UIPickerView alloc] init];
    _pickerHours.dataSource=self;
    _pickerHours.delegate=self;
    _pickerHours.showsSelectionIndicator = YES;
    [_pickerHours selectRow:0 inComponent:0 animated:YES];
    
    
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
    
    _hoursTextField.inputView = _pickerHours;
    _hoursTextField.inputAccessoryView = pickerToolbar;
    
    
    
}

- (void)pickerDoneButtonPressed {
    [self.view endEditing:YES];
}

- (void)pickerClearButtonPressed {
    if([_hoursTextField isFirstResponder])
        _hoursTextField.text=nil;
    
}
*/

@end
