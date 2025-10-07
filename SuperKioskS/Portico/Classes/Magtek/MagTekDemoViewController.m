//
//  MagTekDemoViewController.m
//  MagTekDemo
//
//  Created by MagTek on 11/27/11.
//  Copyright 2011 MagTek. All rights reserved.
//

#import <CoreBluetooth/CoreBluetooth.h>
#import <ExternalAccessory/ExternalAccessory.h>


#import "MTSCRA.h"
#import "MediaPlayer/MediaPlayer.h"
#import "MagTekDemoViewController.h"
#import "MediaPlayer/MPMusicPlayerController.h"

#import "DUKPT.h"

@interface MagTekDemoViewController () <UITextFieldDelegate,
UIScrollViewDelegate,
UITableViewDelegate,
UITableViewDataSource,
UIActionSheetDelegate,
UIApplicationDelegate,
UIAlertViewDelegate,
UITextFieldDelegate
/*,MTSCRAEventDelegate*/>
{
    UILabel* infoLabel;
    UISwitch* devSwitch;
    UIToolbar *toolbar;
    UITextField *commandTextField;
    UIButton* commandButton;
    UITextView* dataResponds;
    UIButton* clearButton;
    NSInteger selectedRow;
}

@property (nonatomic) BOOL isSendingCommand;
@property (nonatomic) int prevSelection;



#pragma mark -
#pragma mark NSMutableArray Properties
#pragma mark -

@property (nonatomic, strong) NSMutableArray *peripheralArray;

#pragma mark -
#pragma mark UILabel Properties
#pragma mark -

@property (nonatomic, strong) IBOutlet UILabel *versionLabel;
@property (nonatomic, strong) IBOutlet UILabel *transactionStatusLabel;
@property (nonatomic, strong) IBOutlet UILabel *deviceConnectionStatusLabel;

#pragma mark -
#pragma mark UIButton Property
#pragma mark -

@property (strong, nonatomic) IBOutlet UIButton *scanButton;

#pragma mark -
#pragma mark UISwitch Properties
#pragma mark -

@property (nonatomic, strong) IBOutlet UISwitch *audioSwitch;
@property (nonatomic, strong) IBOutlet UISwitch *iDynamoSwitch;
@property (strong, nonatomic) IBOutlet UISwitch *dynaMaxSwitch;

#pragma mark -
#pragma mark UISlider Property
#pragma mark -

@property (nonatomic, strong) UISlider *volumeSlider;

#pragma mark -
#pragma mark UITextField Property
#pragma mark -

@property (nonatomic, strong) IBOutlet UITextField *sendCommandTextField;

#pragma mark -
#pragma mark UITextView Properties
#pragma mark -

@property (nonatomic, strong) IBOutlet UITextView *responseDataTextView;
@property (nonatomic, strong) IBOutlet UITextView *rawResponseDataTextView;

#pragma mark -
#pragma mark UIScrollView Property
#pragma mark -

@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;

#pragma mark -
#pragma mark UITableView Property
#pragma mark -

@property (strong, nonatomic) UITableView *tableView;

#pragma mark -
#pragma mark UIActionSheet Property
#pragma mark -

@property (nonatomic, retain) UIActionSheet *actionSheet;

#pragma mark -
#pragma mark MPVolumeView Property
#pragma mark -

@property (nonatomic, strong) MPVolumeView *volumeView;
@property (nonatomic) float curVolume;

#pragma mark -
#pragma mark MTSCRA Property
#pragma mark -

@property (nonatomic, strong) MTSCRA *mtSCRALib;

#pragma mark -
#pragma mark Remember Dynamax Property
#pragma mark -

@property (nonatomic, strong) CBPeripheral *curPeripheral;

#pragma mark -
#pragma mark Picker Property
#pragma mark -


@property (nonatomic, strong) UIPickerView   *pickerVC;
@property (nonatomic, strong) UIView   *pickerView;
//@property (nonatomic, strong) MTPickerViewController *pickerVC;
@property (nonatomic) bool noPicker;



#pragma mark -
#pragma mark IBAction Methods
#pragma mark -

- (IBAction)onScanButtonPressed:(id)sender;
- (IBAction)onClearButtonPressed:(id)sender;
- (IBAction)onAudioSwitchChanged:(id)sender;
- (IBAction)onIDynamoSwitchChanged:(id)sender;
- (IBAction)onDynaMaxSwitchChanged:(id)sender;
- (IBAction)onSendCommandButtonPressed:(id)sender;

#pragma mark -
#pragma mark Helper Methods
#pragma mark -

- (void)clearLabels;
- (void)displayData;
- (void)devConnStatusChange;

@end

@implementation MagTekDemoViewController


#define PROTOCOLSTRING @"com.magtek.idynamo"

//#define _DGBPRNT


#pragma mark -
#pragma mark Memory Management Method
#pragma mark -

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark -
#pragma mark View Lifecycle
#pragma mark -

- (void)viewDidLoad
{
    MagTekDemoAppDelegate *delegate = (MagTekDemoAppDelegate *)([[UIApplication sharedApplication] delegate]);
    self.mtSCRALib                  = (MTSCRA *)([delegate getSCRALib]);
    
    
    //self.mtSCRALib.delegate = self;
    /*******************WARNING********************/
    // will be deprecated on next release
    /**********************************************/
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(trackDataReady:)
                                                 name:@"trackDataReadyNotification"
                                               object:nil];
    
    
    /*******************WARNING********************/
    // will be deprecated on next release
    /**********************************************/
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(devConnStatusChange)
                                                 name:@"devConnectionNotification"
                                               object:nil];
    /*******************WARNING********************/
    // will be deprecated on next release
    /**********************************************/
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reloadTableData)
                                                 name:@"reloadTableDataNotification"
                                               object:nil];
    
    /*******************WARNING********************/
    // will be deprecated on next release
    /**********************************************/
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(bleStateUpdated:)
                                                 name:@"bleStateUpdated"
                                               object:nil];
    
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(bleReaderConnectedNotification:)
                                                 name:@"bleReaderConected"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidEnterBackground:) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
    
    
    
    [[self scrollView] setDelegate:self];
    [[self scrollView] setScrollEnabled:YES];
    [[self scrollView] setContentSize:CGSizeMake(320, self.rawResponseDataTextView.frame.origin.y + self.rawResponseDataTextView.frame.size.height + 500)];
    
    [self updateConnStatus];
    
    [self clearLabels];
    
    NSString *appVersionString = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
    NSString *revDisplay       = [NSString stringWithFormat:@"App.Ver=%@,"
                                  "SDK.Ver=%@",
                                  appVersionString,
                                  [self.mtSCRALib getSDKVersion]];
    
    
    
    [[self versionLabel] setText:revDisplay];
    
    [[self sendCommandTextField] setDelegate:self];
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:!self.navigationController.navigationBarHidden animated:NO];
    
    /*                       ANSI TEST KEY: 0123456789ABCEDFFEDCDA9876543210
     DUKPT* d = [[DUKPT alloc]initWithBDK:@"0123456789ABCDEFFEDCBA9876543210" KSN:[mtSCRALib getKSN]];
     NSLog([d decrypt:[mtSCRALib getTrack1]]);
     */
    
    
     //tested working:
    //DUKPT* d = [[DUKPT alloc]initWithBDK:@"0123456789ABCDEFFEDCBA9876543210" KSN:@"FFFF9876543210E00000"];
    /*
    
    DUKPT* d = [[DUKPT alloc]initWithBDK:@"0123456789ABCDEFFEDCBA9876543210" KSN:@"FFFF9876543210E00008"];
    
    
    
    
    NSLog([d decrypt:@"C25C1D1197D31CAA87285D59A892047426D9182EC11353C051ADD6D0F072A6CB3436560B3071FC1FD11D9F7E74886742D9BEE0CFD1EA1064C213BB55278B2F12"]);
    //B5452300551227189^HOGAN/PAUL      ^08043210000000725000000?
    */
    DUKPT* d = [[DUKPT alloc]initWithBDK:@"0123456789ABCDEFFEDCBA9876543210" KSN:@"000000020049D9000005"];
    NSLog([d decrypt:@" E47BB2A46E783A760FF6F043EB31266932D7D691987F4965F68EB0E90590BF8D84DBFB9C6F95FCF383A963D047F1D30A46E6C46E18043B0981CC8E88B26C7093EE6DC7AF17B3965D"]);
    
}


//delegate for device connection change;
-(void)onDeviceConnectionDidChange:(MTSCRADeviceType)deviceType connected:(BOOL)connected instance:(id)instance
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self updateConnStatus];
        
    });
}


-(void)textFieldDidBeginEditing:(UITextField *)textField {
    
    [UIView animateWithDuration:0.5
                          delay:0
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         commandTextField.center = CGPointMake(commandTextField.center.x, commandTextField.center.y - 216);
                         commandButton.center = CGPointMake(commandButton.center.x, commandButton.center.y - 216);
                         clearButton.center = CGPointMake(clearButton.center.x, clearButton.center.y - 216);
                         dataResponds.frame = CGRectMake(10, 60, self.view.frame.size.width - 20, 390 - 216 - 50);
                     }
                     completion:^(BOOL finished){}];
    
    
}

-(void)textFieldDidEndEditing:(UITextField *)textField {
    
    commandTextField.center = CGPointMake(commandTextField.center.x, commandTextField.center.y + 216);
    commandButton.center = CGPointMake(commandButton.center.x, commandButton.center.y + 216);
    dataResponds.frame = CGRectMake(10, 60, self.view.frame.size.width - 20, 330);
    clearButton.center = CGPointMake(clearButton.center.x, clearButton.center.y + 216);
}



-(void)uiOnMain
{
    
    commandTextField.hidden = NO;
    commandButton.hidden = NO;
}



-(void)changeTintColor:(UIColor*) tintColor
{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.1)
    {
        //[[UINavigationBar appearance] setBarTintColor:tintColor];
        
        
        
        self.navigationController.navigationBar.barTintColor = tintColor;
        self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
        
        
        self.navigationController.navigationBar.translucent = NO;
        
        [self.navigationController.navigationBar setTitleTextAttributes:
         [NSDictionary dictionaryWithObjectsAndKeys:
          [UIFont fontWithName:@"STHeitiSC-Medium" size:15],
          NSFontAttributeName, [UIColor whiteColor], NSForegroundColorAttributeName, nil]];
        
        
        [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
        
    }
}

- (void) appDidEnterBackground:(NSNotification *)notification {
    
    
    [self closeDevice];
    
    
}
-(void)appDidBecomeActive:(NSNotification *)notification
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self openDevice];
    });
}


- (void)viewDidUnload
{
#ifdef _DGBPRNT
    NSLog(@"viewDidUnload");
#endif
    
    [self setMtSCRALib:nil];
    [self setScrollView:nil];
    [self setAudioSwitch:nil];
    [self setVersionLabel:nil];
    [self setIDynamoSwitch:nil];
    [self setResponseDataTextView:nil];
    [self setSendCommandTextField:nil];
    [self setTransactionStatusLabel:nil];
    [self setRawResponseDataTextView:nil];
    [self setDeviceConnectionStatusLabel:nil];
    
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return ((interfaceOrientation == UIInterfaceOrientationPortrait)||
            (interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown));
}


#pragma mark -
#pragma mark BLE Detection Callback
#pragma mark -

-(void)bleReaderConnectedNotification:(NSNotification*)notification
{
    CBPeripheral *peripheral = [[notification userInfo]objectForKey:@"peripheral"] ;
    
    //[self savePeripheral];
    _curPeripheral = peripheral;
}

-(void) bleReaderConnected:(CBPeripheral *)peripheral
{
    
    //CBPeripheral *per = [[notification userInfo]objectForKey:@"peripheral"] ;
    
    //[self savePeripheral];
    _curPeripheral = peripheral;
    
}
-(void)bleReaderStateUpdated:(MTSCRABLEState)state
{
    switch (state) {
        case OK:
        {
            [self showActionSheet];
            break;
        }
        case UNSUPPORTED:
        {
            [_dynaMaxSwitch setOn:NO animated:YES];
            UIAlertView * alert =[[UIAlertView alloc ] initWithTitle:@"BLE Error"
                                                             message:@"BLE is unsupported in this device."
                                                            delegate:nil
                                                   cancelButtonTitle:@"Okay"
                                                   otherButtonTitles: nil];
            
            [alert show];
            
            break;
        }
        default:
            break;
    }
}
//
-(void) bleStateUpdated:(NSNotification *)notification
{
    
    
    NSString *status = [[notification userInfo]objectForKey:@"status"] ;
    if([status isEqualToString:@"OK"])
    {
        [self showActionSheet];
        
    }
    else if([status isEqualToString:@"Unsupported"])
    {
        [_dynaMaxSwitch setOn:NO animated:YES];
        UIAlertView * alert =[[UIAlertView alloc ] initWithTitle:@"BLE Error"
                                                         message:@"BLE is unsupported in this device."
                                                        delegate:self
                                               cancelButtonTitle:@"Okay"
                                               otherButtonTitles: nil];
        
        [alert show];
    }
}
#pragma mark -
#pragma mark IBAction Methods
#pragma mark -

- (IBAction)onScanButtonPressed:(id)sender
{
    
    [[self mtSCRALib] startScanningForPeripherals];
    
    
}

- (IBAction)onClearButtonPressed:(id)sender
{
    [self clearLabels];
    
    [[self mtSCRALib] clearBuffers];
}

- (IBAction)onAudioSwitchChanged:(id)sender
{
    [self cancel_clicked:nil];
    if([self.mtSCRALib isDeviceOpened])
        [self.mtSCRALib closeDevice];
    
    if([(UISwitch*)sender isOn])
    {
#ifdef _DGBPRNT
        NSLog(@"setAudioSwitch:ON");
#endif
        
        [_iDynamoSwitch setOn:NO animated:YES];
        [_dynaMaxSwitch setOn:NO animated:YES];
        
        [_dynaMaxSwitch setHidden:YES];
        [_iDynamoSwitch setHidden:YES];
        
        [[self mtSCRALib] setDeviceType:MAGTEKAUDIOREADER];
        [self openDevice];
        if(_mtSCRALib.isDeviceConnected)
        {
            MPMusicPlayerController* musicPlayer = [MPMusicPlayerController applicationMusicPlayer];
            
            _curVolume = musicPlayer.volume;
            
            [musicPlayer setVolume:1];
            
            
            
            
        }
        else
        {
            [_mtSCRALib closeDevice];
            //[(UISwitch*)sender setOn: NO animated:YES];
        }
    }
    else
    {
#ifdef _DGBPRNT
        NSLog(@"setAudioSwitch:OFF");
#endif
        
        
        
        MPMusicPlayerController* musicPlayer = [MPMusicPlayerController applicationMusicPlayer];
        
        //_curVolume = musicPlayer.volume;
        
        [musicPlayer setVolume:_curVolume];
        
        [self closeDevice];
        
        
        // self.volumeView = nil;
        [_dynaMaxSwitch setHidden:NO];
        [_iDynamoSwitch setHidden:NO];
        [_audioSwitch setHidden:NO];
        
    }
    
}

- (IBAction)onIDynamoSwitchChanged:(id)sender
{
    [self cancel_clicked:nil];
    if([self.mtSCRALib isDeviceOpened])
        [self.mtSCRALib closeDevice];
    
    if([(UISwitch*)sender isOn])
    {
#ifdef _DGBPRNT
        NSLog(@"onIDynamoSwitchChanged:ON");
#endif
        [_audioSwitch setOn:NO animated:YES];
        [_dynaMaxSwitch setOn:NO animated:YES];
        
        [_audioSwitch setHidden:YES];
        [_dynaMaxSwitch setHidden:YES];
        [[self mtSCRALib] setDeviceType:MAGTEKIDYNAMO];
        
        [self openDevice];
        
        if(!_mtSCRALib.isDeviceConnected)
        {
            //[(UISwitch*)sender setOn:NO animated:YES];
            //[self closeDevice];
            return;
            
        }
        
        
        
        
    }
    else
    {
#ifdef _DGBPRNT
        NSLog(@"onIDynamoSwitchChanged:OFF");
#endif
        [_audioSwitch setHidden:NO];
        [_dynaMaxSwitch setHidden:NO];
        [self closeDevice];
    }
}

- (IBAction)onDynaMaxSwitchChanged:(id)sender
{
    if([self.mtSCRALib isDeviceOpened])
        [self.mtSCRALib closeDevice];
    
    
    if([(UISwitch*)sender isOn])
    {
#ifdef _DGBPRNT
        NSLog(@"onDynaMaxSwitchChanged:ON");
#endif
        
        [_iDynamoSwitch setOn:NO animated:YES];
        [_audioSwitch setOn:NO animated:YES];
        
        // [[self scanButton] setHidden:NO];
        
        [[self mtSCRALib] setDeviceType:MAGTEKDYNAMAX];
        
        if(![[self mtSCRALib] isDeviceOpened])
        {
            // load previously connected Peripheral's UUID (if any)
            NSString *uuidString = [self loadPeripheral];
            
            // If a previous Peripheral's UUID exists we connect to it
            if(![uuidString isEqualToString:@""] && uuidString != nil)
            {
                [[self mtSCRALib] setUUIDString:uuidString];
            }
            else
            {
                [[self mtSCRALib] setUUIDString:@""];
                
            }
        }
        
        [self openDevice];
        if(_curPeripheral)
        {
            _noPicker = YES;
            UIAlertView * alert =[[UIAlertView alloc ] initWithTitle:@"Reconnect"
                                                             message:@"Reconnect to previous device?"
                                                            delegate:self
                                                   cancelButtonTitle:@"No"
                                                   otherButtonTitles: nil];
            [alert addButtonWithTitle:@"Yes"];
            [alert show];
        }
        else [self performSelector:@selector(onScanButtonPressed:) withObject:nil afterDelay:.1];
        
        
    }
    else
    {
        
        [self cancel_clicked:nil];
#ifdef _DGBPRNT
        NSLog(@"onDynaMaxSwitchChanged:OFF");
#endif
        
        [[self scanButton] setHidden:YES];
        //[self savePeripheral];
        [self closeDevice];
    }
}

#pragma mark -
#pragma mark UIAlertView delegate
#pragma mark -
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    _noPicker = NO;
    if([alertView.title isEqualToString:@"BLE Error"])
    {
        return;
    }
    // NSLog(@"Button Index =%ld",buttonIndex);
    if (buttonIndex == 0)
    {
        _curPeripheral = nil;
        [self performSelector:@selector(onScanButtonPressed:) withObject:nil afterDelay:.1];
        [self showActionSheet];
    }
    else if(buttonIndex == 1)
    {
        
        [self connectToBLEReader:_curPeripheral];
    }
    
}

- (IBAction)onSendCommandButtonPressed:(id)sender
{
    
    //
    //_sendCommandTextField.text = @"C10206C20503C30100";
    
    [[self mtSCRALib] sendcommandWithLength:[[self sendCommandTextField] text]];
    [_sendCommandTextField resignFirstResponder];
    
    
}

#pragma mark -
#pragma mark UITableView Data Source
#pragma mark -

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    if([[[self mtSCRALib] getDiscoveredPeripherals] count] > 0)
    {
        
        return [[[self mtSCRALib] getDiscoveredPeripherals] count];
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"DeviceList";
    UITableViewCell	*cell   = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if(!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
                                      reuseIdentifier:cellID];
    }
    
    // if there are discovered Peripherals we will display them
    if([self.peripheralArray count] > 0)
    {
        if([self.peripheralArray count] > [indexPath row])
        {
            CBPeripheral *peripheral = (CBPeripheral *)[self.peripheralArray objectAtIndex:[indexPath row]];
            
            if([[peripheral name] length])
            {
                [[cell textLabel] setText:[peripheral name]];
                //NSLog([peripheral name]);
            }
            else
            {
                [[cell textLabel] setText:@"Peripheral"];
            }
            
            [[cell detailTextLabel] setText:[peripheral state] == CBPeripheralStateConnected ? @"Connected" : @"Not connected"];
        }
    }
    // else there are no discovered Peripherals
    else
    {
        [[cell textLabel]       setText:@""];
        [[cell detailTextLabel] setText:@""];
    }
    
    return cell;
}

#pragma mark -
#pragma mark UITableView Delegate
#pragma mark -

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Ensure that the Peripheral Array contains elements before populating the Table View
    if([self.peripheralArray count] > 0)
    {
        CBPeripheral *peripheral = (CBPeripheral *)[self.peripheralArray objectAtIndex:[indexPath row]];
        
        // If the iOS device is running a version of iOS 6.1 or earlier
//        if(floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1)
//        {
//            // if the Peripheral is not connected we set the Device UUID with the selected Peripheral's UUID
//            if(![peripheral isConnected])
//            {
//                // if the Peripheral's UUID is available
//                if([peripheral UUID])
//                {
//                    NSString *uuidString = [NSString stringWithFormat:@"%@", CFUUIDCreateString(NULL, [peripheral UUID])];
//                    
//                    [[self mtSCRALib] setUUIDString:uuidString];
//                }
//                // else the Peripheral has never been connected so we set the Peripheral Device UUID to nil
//                else
//                {
//                    [[self mtSCRALib] setUUIDString:nil];
//                }
//                
//                [self openDevice];
//            }
//            // else the device is connected so we close it's connection
//            else
//            {
//                [self closeDevice];
//            }
//        }
        // Else the iOS device is running a version of iOS 7.0 or later
       // else
        {
            // if the Peripheral is not connected we set the Device UUID with the selected Peripheral's UUID
            if([peripheral state] == CBPeripheralStateDisconnected)
            {
                // If there is another Peripheral that is connected then we disconnect it
                if([[[self mtSCRALib] getConnectedPeripheral] state] == CBPeripheralStateConnected)
                {
                    [self closeDevice];
                    
                    [self removePeripheral];
                }
                
                // if the Peripheral's UUID is available
                if([peripheral identifier])
                {
                    NSString *uuidString =peripheral.identifier.UUIDString; //[NSString stringWithFormat:@"%@", CFBridgingRelease(CFUUIDCreateString(kCFAllocatorDefault, peripheral.UUID))];
                    
                    [[self mtSCRALib] setUUIDString:uuidString];
                }
                // else the Peripheral has never been connected so we set the Peripheral Device UUID to an empty string
                else
                {
                    [[self mtSCRALib] setUUIDString:@""];
                }
                
                [self openDevice];
            }
            // else the device is connected so we close it's connection
            else
            {
                [self closeDevice];
                
                [self removePeripheral];
            }
        }
    }
    
    // If you prefer to not close the UIActionSheet imeediately upon user selection then comment out the lines below
    [self.actionSheet dismissWithClickedButtonIndex:0 animated:YES];
}

- (void) bleReaderDidDiscoverPeripheral
{
    self.peripheralArray = [[self mtSCRALib] getDiscoveredPeripherals];
    //[_pickerVC reloadPicker];
    [_pickerVC reloadAllComponents];
    
    [[self tableView] reloadData];
    
    NSIndexSet * sections = [NSIndexSet indexSetWithIndex:0];
    [self.tableView reloadSections:sections withRowAnimation:UITableViewRowAnimationNone];
}


- (NSURL *)applicationDocumentsDirectory {
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory
                                                   inDomains:NSUserDomainMask] lastObject];
}




#pragma mark -
#pragma mark UITableView Helper Methods
#pragma mark -

- (void)reloadTableData
{
    self.peripheralArray = [[self mtSCRALib] getDiscoveredPeripherals];
    [_pickerVC reloadAllComponents];
    
    [[self tableView] reloadData];
    
    NSIndexSet * sections = [NSIndexSet indexSetWithIndex:0];
    [self.tableView reloadSections:sections withRowAnimation:UITableViewRowAnimationNone];
    
}

#pragma mark -
#pragma mark UITextField Delegate Method
#pragma mark -

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

#pragma mark -
#pragma mark Helper Methods
#pragma mark -

- (void)openDevice
{
    switch([[self mtSCRALib] getDeviceType])
    {
        case MAGTEKAUDIOREADER:
            
            if(![[self mtSCRALib] isDeviceOpened])
            {
                [[self mtSCRALib] openDevice];
            }
            
            [self updateConnStatus];
            
            break;
            
        case MAGTEKIDYNAMO:
            
            [[self mtSCRALib] setDeviceProtocolString:(PROTOCOLSTRING)];
            
            if(![[self mtSCRALib] isDeviceOpened])
            {
                [[self mtSCRALib] openDevice];
            }
            
            break;
            
        case MAGTEKDYNAMAX:
            
            if(![[self mtSCRALib] isDeviceOpened])
            {
                [[self mtSCRALib] openDevice];
            }
            
            break;
    }
}



- (void)closeDevice
{
    if([[self mtSCRALib] isDeviceOpened])
    {
        [[self mtSCRALib] closeDevice];
    }
    
    [[self mtSCRALib] clearBuffers];
    
    [self updateConnStatus];
}

- (void)clearLabels
{
    [[self sendCommandTextField]    setText:@""];
    [[self responseDataTextView]    setText:@""];
    [[self responseDataTextView]    setText:@""];
    [[self transactionStatusLabel]  setText:@""];
    [[self rawResponseDataTextView] setText:@""];
    
    [dataResponds setText:@""];
    
}

-(void)displayData: (MTCardData*)cardObjc
{
    /*
    NSString *pResponse = @"";
    
    if ([[self.mtSCRALib getTrackDecodeStatus] rangeOfString:@"01"].location == NSNotFound) {
        [self changeTintColor:UIColorFromRGB(0x05B3B2)];
    } else {
        AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        [self changeTintColor:UIColorFromRGB(0xBC3D41)];
    }
    
    switch([[self mtSCRALib] getDeviceType])
    {
            
        case MAGTEKAUDIOREADER:
        {
            
            pResponse = [NSString stringWithFormat:@"Response.Type: %@\n\n"
                         "Track.Status: %@\n\n"
                         "Track1.Status: %@\n\n"
                         "Track2.Status: %@\n\n"
                         "Track3.Status: %@\n\n"
                         "Card.Status: %@\n\n"
                         "Encryption.Status: %@\n\n"
                         "Battery.Level: %ld\n\n"
                         "Swipe.Count: %ld\n\n"
                         "Track.Masked: %@\n\n"
                         "Track1.Masked: %@\n\n"
                         "Track2.Masked: %@\n\n"
                         "Track3.Masked: %@\n\n"
                         "Track1.Encrypted: %@\n\n"
                         "Track2.Encrypted: %@\n\n"
                         "Track3.Encrypted: %@\n\n"
                         "Card.PAN: %@\n\n"
                         "MagnePrint.Encrypted: %@\n\n"
                         "MagnePrint.Length: %i\n\n"
                         "MagnePrint.Status: %@\n\n"
                         "SessionID: %@\n\n"
                         "Card.IIN: %@\n\n"
                         "Card.Name: %@\n\n"
                         "Card.Last4: %@\n\n"
                         "Card.ExpDate: %@\n\n"
                         "Card.ExpDateMonth: %@\n\n"
                         "Card.ExpDateYear: %@\n\n"
                         "Card.SvcCode: %@\n\n"
                         "Card.PANLength: %ld\n\n"
                         "KSN: %@\n\n"
                         "Device.SerialNumber: %@\n\n"
                         "Device.Status: %@\n\n"
                         "TLV.CARDIIN: %@\n\n"
                         "MagTek SN: %@\n\n"
                         "Firmware Part Number: %@\n\n"
                         "TLV Version: %@\n\n"
                         "Device Model Name: %@\n\n",
                         cardObjc.responseType,
                         cardObjc.trackDecodeStatus,
                         cardObjc.track1DecodeStatus,
                         cardObjc.track2DecodeStatus,
                         cardObjc.track3DecodeStatus,
                         cardObjc.cardStatus,
                         cardObjc.encryptionStatus,
                         cardObjc.batteryLevel,
                         cardObjc.swipeCount,
                         cardObjc.maskedTracks,
                         cardObjc.maskedTrack1,
                         cardObjc.maskedTrack2,
                         cardObjc.maskedTrack3,
                         cardObjc.encryptedTrack1,
                         cardObjc.encryptedTrack2,
                         cardObjc.encryptedTrack3,
                         cardObjc.cardPAN,
                         cardObjc.encryptedMagneprint,
                         cardObjc.magnePrintLength,
                         cardObjc.magneprintStatus,
                         cardObjc.encrypedSessionID,
                         cardObjc.cardIIN,
                         cardObjc.cardName,
                         cardObjc.cardLast4,
                         cardObjc.cardExpDate,
                         cardObjc.cardExpDateMonth,
                         cardObjc.cardExpDateYear,
                         cardObjc.cardServiceCode,
                         cardObjc.cardPANLength,
                         cardObjc.deviceKSN,
                         cardObjc.deviceSerialNumber,
                         cardObjc.deviceStatus,
                         cardObjc.tagValue,
                         cardObjc.deviceSerialNumberMagTek,
                         cardObjc.firmware,
                         cardObjc.tlvVersion,
                         cardObjc.deviceName];
            
            break;
            
        }
            
        case MAGTEKIDYNAMO:
        {
            
            pResponse = [NSString stringWithFormat:
                         @"Track.Status: %@\n\n"
                         "Track1.Status: %@\n\n"
                         "Track2.Status: %@\n\n"
                         "Track3.Status: %@\n\n"
                         "Encryption.Status: %@\n\n"
                         "Track.Masked: %@\n\n"
                         "Track1.Masked: %@\n\n"
                         "Track2.Masked: %@\n\n"
                         "Track3.Masked: %@\n\n"
                         "Track1.Encrypted: %@\n\n"
                         "Track2.Encrypted: %@\n\n"
                         "Track3.Encrypted: %@\n\n"
                         "Card.PAN: %@\n\n"
                         "Card.IIN: %@\n\n"
                         "Card.Name: %@\n\n"
                         "Card.Last4: %@\n\n"
                         "Card.ExpDate: %@\n\n"
                         "Card.ExpDateMonth: %@\n\n"
                         "Card.ExpDateYear: %@\n\n"
                         "Card.SvcCode: %@\n\n"
                         "Card.PANLength: %ld\n\n"
                         "KSN: %@\n\n"
                         "Device.SerialNumber: %@\n\n"
                         "Firmware Revision Number: %@\n\n"
                         "MagnePrint: %@\n\n"
                         "MagnePrint.Length: %i\n\n"
                         "MagnePrintStatus: %@\n\n"
                         "SessionID: %@\n\n"
                         "Device Model Name: %@\n\n",
                         cardObjc.trackDecodeStatus,
                         cardObjc.track1DecodeStatus,
                         cardObjc.track2DecodeStatus,
                         cardObjc.track3DecodeStatus,
                         cardObjc.encryptionStatus,
                         cardObjc.maskedTracks,
                         cardObjc.maskedTrack1,
                         cardObjc.maskedTrack2,
                         cardObjc.maskedTrack3,
                         cardObjc.encryptedTrack1,
                         cardObjc.encryptedTrack2,
                         cardObjc.encryptedTrack3,
                         cardObjc.cardPAN,
                         cardObjc.cardIIN,
                         cardObjc.cardName,
                         cardObjc.cardLast4,
                         cardObjc.cardExpDate,
                         cardObjc.cardExpDateMonth,
                         cardObjc.cardExpDateYear,
                         cardObjc.cardServiceCode,
                         cardObjc.cardPANLength,
                         cardObjc.deviceKSN,
                         cardObjc.deviceSerialNumber,
                         cardObjc.deviceFirmware,
                         cardObjc.encryptedMagneprint,
                         cardObjc.magnePrintLength,
                         cardObjc.magneprintStatus,
                         cardObjc.encrypedSessionID,
                         cardObjc.deviceName];
            
            break;
            
        }
            
        case MAGTEKDYNAMAX:
        {
            pResponse = [NSString stringWithFormat:
                         @"Track.Status: %@\n\n"
                         "Track1.Status: %@\n\n"
                         "Track2.Status: %@\n\n"
                         "Track3.Status: %@\n\n"
                         "Encryption.Status: %@\n\n"
                         "Battery.Level: %ld\n\n"
                         "Track.Masked: %@\n\n"
                         "Track1.Masked: %@\n\n"
                         "Track2.Masked: %@\n\n"
                         "Track3.Masked: %@\n\n"
                         "Track1.Encrypted: %@\n\n"
                         "Track2.Encrypted: %@\n\n"
                         "Track3.Encrypted: %@\n\n"
                         "Card.PAN: %@\n\n"
                         "Card.IIN: %@\n\n"
                         "Card.Name: %@\n\n"
                         "Card.Last4: %@\n\n"
                         "Card.ExpDate: %@\n\n"
                         "Card.ExpDateMonth: %@\n\n"
                         "Card.ExpDateYear: %@\n\n"
                         "Card.SvcCode: %@\n\n"
                         "Card.PANLength: %ld\n\n"
                         "KSN: %@\n\n"
                         "Device.SerialNumber: %@\n\n"
                         "Firmware Revision Number: %@\n\n"
                         "MagnePrint: %@\n\n"
                         "MagnePrint Length: %i\n\n"
                         "MagnePrintStatus: %@\n\n"
                         "SessionID: %@\n\n"
                         "Device Model Name: %@\n\n",
                         cardObjc.trackDecodeStatus,
                         cardObjc.track1DecodeStatus,
                         cardObjc.track2DecodeStatus,
                         cardObjc.track3DecodeStatus,
                         cardObjc.encryptionStatus,
                         cardObjc.batteryLevel,
                         cardObjc.maskedTracks,
                         cardObjc.maskedTrack1,
                         cardObjc.maskedTrack2,
                         cardObjc.maskedTrack3,
                         cardObjc.encryptedTrack1,
                         cardObjc.encryptedTrack2,
                         cardObjc.encryptedTrack3,
                         cardObjc.cardPAN,
                         cardObjc.cardIIN,
                         cardObjc.cardName,
                         cardObjc.cardLast4,
                         cardObjc.cardExpDate,
                         cardObjc.cardExpDateMonth,
                         cardObjc.cardExpDateYear,
                         cardObjc.cardServiceCode,
                         cardObjc.cardPANLength,
                         cardObjc.deviceKSN,
                         cardObjc.deviceSerialNumber,
                         cardObjc.deviceFirmware,
                         cardObjc.encryptedMagneprint,
                         cardObjc.magnePrintLength,
                         cardObjc.magneprintStatus,
                         cardObjc.encrypedSessionID,
                         cardObjc.deviceName];
            
            break;
        }
            
        default:
        {
            pResponse = [NSString stringWithFormat:
                         @"Track.Status: %@\n\n"
                         "Encryption.Status: %@\n\n"
                         "Track.Masked: %@\n\n"
                         "Track1.Masked: %@\n\n"
                         "Track2.Masked: %@\n\n"
                         "Track3.Masked: %@\n\n"
                         "Track1.Encrypted: %@\n\n"
                         "Track2.Encrypted: %@\n\n"
                         "Track3.Encrypted: %@\n\n"
                         "Card.IIN: %@\n\n"
                         "Card.Name: %@\n\n"
                         "Card.Last4: %@\n\n"
                         "Card.ExpDate: %@\n\n"
                         "Card.SvcCode: %@\n\n"
                         "Card.PANLength: %ld\n\n"
                         "KSN: %@\n\n"
                         "Device.SerialNumber: %@\n\n"
                         "Firmware Revision Number: %@\n\n"
                         "MagnePrint: %@\n\n"
                         "MagnePrintStatus: %@\n\n"
                         "SessionID: %@\n\n"
                         "Device Model Name: %@\n\n",
                         cardObjc.trackDecodeStatus,
                         cardObjc.encryptionStatus,
                         cardObjc.maskedTracks,
                         cardObjc.maskedTrack1,
                         cardObjc.maskedTrack2,
                         cardObjc.maskedTrack3,
                         cardObjc.encryptedTrack1,
                         cardObjc.encryptedTrack2,
                         cardObjc.encryptedTrack3,
                         cardObjc.cardIIN,
                         cardObjc.cardName,
                         cardObjc.cardLast4,
                         cardObjc.cardExpDate,
                         cardObjc.cardServiceCode,
                         cardObjc.cardPANLength,
                         cardObjc.deviceKSN,
                         cardObjc.deviceSerialNumber,
                         cardObjc.deviceFirmware,
                         cardObjc.encryptedMagneprint,
                         cardObjc.magneprintStatus,
                         cardObjc.encrypedSessionID,
                         cardObjc.deviceName];;
            
            break;
            
        }
    }
    
    
    [[self responseDataTextView] setText:pResponse];
    NSString *tempResponseDataString = [[self mtSCRALib] getResponseData];
    
    if([tempResponseDataString length] != 0 &&
       tempResponseDataString)
    {
        [[self rawResponseDataTextView] setText:tempResponseDataString];
    }
    */
    
    
    [self.mtSCRALib clearBuffers];
    
    
}







/**********************FUNCTION WILL BE DEPRECATED*******************/
- (void)displayData
{
    if([self mtSCRALib] != NULL)
    {
        /*
        NSString *pResponse = @"";
        if ([[self.mtSCRALib getTrackDecodeStatus] rangeOfString:@"01"].location == NSNotFound) {
            [self changeTintColor:UIColorFromRGB(0x05B3B2)];
        } else {
            AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
            [self changeTintColor:UIColorFromRGB(0xBC3D41)];
        }
        
        switch([[self mtSCRALib] getDeviceType])
        {
                
            case MAGTEKAUDIOREADER:
            {
                
                pResponse = [NSString stringWithFormat:@"Response.Type: %@\n\n"
                             "Track.Status: %@\n\n"
                             "Card.Status: %@\n\n"
                             "Encryption.Status: %@\n\n"
                             "Battery.Level: %ld\n\n"
                             "Swipe.Count: %ld\n\n"
                             "Track.Masked: %@\n\n"
                             "Track1.Masked: %@\n\n"
                             "Track2.Masked: %@\n\n"
                             "Track3.Masked: %@\n\n"
                             "Track1.Encrypted: %@\n\n"
                             "Track2.Encrypted: %@\n\n"
                             "Track3.Encrypted: %@\n\n"
                             "MagnePrint.Encrypted: %@\n\n"
                             "MagnePrint.Length: %i\n\n"
                             "MagnePrint.Status: %@\n\n"
                             "SessionID: %@\n\n"
                             "Card.IIN: %@\n\n"
                             "Card.Name: %@\n\n"
                             "Card.Last4: %@\n\n"
                             "Card.ExpDate: %@\n\n"
                             "Card.SvcCode: %@\n\n"
                             "Card.PANLength: %d\n\n"
                             "KSN: %@\n\n"
                             "Device.SerialNumber: %@\n\n"
                             "Device.Status %@\n\n"
                             "TLV.CARDIIN: %@\n\n"
                             "MagTek SN: %@\n\n"
                             "Firmware Part Number: %@\n\n"
                             "TLV Version: %@\n\n"
                             "Device Model Name: %@\n\n",
                             [self.mtSCRALib getResponseType],
                             [self.mtSCRALib getTrackDecodeStatus],
                             [self.mtSCRALib getCardStatus],
                             [self.mtSCRALib getEncryptionStatus],
                             [self.mtSCRALib getBatteryLevel],
                             [self.mtSCRALib getSwipeCount],
                             [self.mtSCRALib getMaskedTracks],
                             [self.mtSCRALib getTrack1Masked],
                             [self.mtSCRALib getTrack2Masked],
                             [self.mtSCRALib getTrack3Masked],
                             [self.mtSCRALib getTrack1],
                             [self.mtSCRALib getTrack2],
                             [self.mtSCRALib getTrack3],
                             [self.mtSCRALib getMagnePrint],
                             [self.mtSCRALib getMagnePrintLength],
                             [self.mtSCRALib getMagnePrintStatus],
                             [self.mtSCRALib getSessionID],
                             [self.mtSCRALib getCardIIN],
                             [self.mtSCRALib getCardName],
                             [self.mtSCRALib getCardLast4],
                             [self.mtSCRALib getCardExpDate],
                             [self.mtSCRALib getCardServiceCode],
                             [self.mtSCRALib getCardPANLength],
                             [self.mtSCRALib getKSN],
                             [self.mtSCRALib getDeviceSerial],
                             [self.mtSCRALib getDeviceStatus],
                             [self.mtSCRALib getTagValue:TLV_CARDIIN],
                             [self.mtSCRALib getMagTekDeviceSerial],
                             [self.mtSCRALib getFirmware],
                             [self.mtSCRALib getTLVVersion],
                             [self.mtSCRALib getDeviceName]];
                
                break;
                
            }
                
            case MAGTEKIDYNAMO:
            {
                
                pResponse = [NSString stringWithFormat:@"Track.Status: %@\n\n"
                             "Encryption.Status: %@\n\n"
                             "Track.Masked: %@\n\n"
                             "Track1.Masked: %@\n\n"
                             "Track2.Masked: %@\n\n"
                             "Track3.Masked: %@\n\n"
                             "Track1.Encrypted: %@\n\n"
                             "Track2.Encrypted: %@\n\n"
                             "Track3.Encrypted: %@\n\n"
                             "Card.IIN: %@\n\n"
                             "Card.Name: %@\n\n"
                             "Card.Last4: %@\n\n"
                             "Card.ExpDate: %@\n\n"
                             "Card.SvcCode: %@\n\n"
                             "Card.PANLength: %d\n\n"
                             "KSN: %@\n\n"
                             "Device.SerialNumber: %@\n\n"
                             "MagnePrint: %@\n\n"
                             "MagnePrint.Length: %i\n\n"
                             "MagnePrintStatus: %@\n\n"
                             "SessionID: %@\n\n"
                             "Device Model Name: %@\n\n",
                             [self.mtSCRALib getTrackDecodeStatus],
                             [self.mtSCRALib getEncryptionStatus],
                             [self.mtSCRALib getMaskedTracks],
                             [self.mtSCRALib getTrack1Masked],
                             [self.mtSCRALib getTrack2Masked],
                             [self.mtSCRALib getTrack3Masked],
                             [self.mtSCRALib getTrack1],
                             [self.mtSCRALib getTrack2],
                             [self.mtSCRALib getTrack3],
                             [self.mtSCRALib getCardIIN],
                             [self.mtSCRALib getCardName],
                             [self.mtSCRALib getCardLast4],
                             [self.mtSCRALib getCardExpDate],
                             [self.mtSCRALib getCardServiceCode],
                             [self.mtSCRALib getCardPANLength],
                             [self.mtSCRALib getKSN],
                             [self.mtSCRALib getDeviceSerial],
                             [self.mtSCRALib getMagnePrint],
                             [self.mtSCRALib getMagnePrintLength],
                             [self.mtSCRALib getMagnePrintStatus],
                             [self.mtSCRALib getSessionID],
                             [self.mtSCRALib getDeviceName]];
                
                break;
                
            }
                
            case MAGTEKDYNAMAX:
            {
                pResponse = [NSString stringWithFormat:@"Track.Status: %@\n\n"
                             "Track1.Status: %@\n\n"
                             "Track2.Status: %@\n\n"
                             "Track3.Status: %@\n\n"
                             "Encryption.Status: %@\n\n"
                             "Battery.Level: %ld\n\n"
                             "Track.Masked: %@\n\n"
                             "Track1.Masked: %@\n\n"
                             "Track2.Masked: %@\n\n"
                             "Track3.Masked: %@\n\n"
                             "Track1.Encrypted: %@\n\n"
                             "Track2.Encrypted: %@\n\n"
                             "Track3.Encrypted: %@\n\n"
                             "Card.IIN: %@\n\n"
                             "Card.Name: %@\n\n"
                             "Card.Last4: %@\n\n"
                             "Card.ExpDate: %@\n\n"
                             "Card.SvcCode: %@\n\n"
                             "Card.PANLength: %d\n\n"
                             "KSN: %@\n\n"
                             "Device.SerialNumber: %@\n\n"
                             "Firmware Revision Number: %@\n\n"
                             "MagnePrint: %@\n\n"
                             "MagnePrint.Length: %i\n\n"
                             "MagnePrintStatus: %@\n\n"
                             "SessionID: %@\n\n"
                             "Device Model Name: %@\n\n",
                             [self.mtSCRALib getTrackDecodeStatus],
                             [self.mtSCRALib getTrack1DecodeStatus],
                             [self.mtSCRALib getTrack2DecodeStatus],
                             [self.mtSCRALib getTrack3DecodeStatus],
                             [self.mtSCRALib getEncryptionStatus],
                             [self.mtSCRALib getBatteryLevel],
                             [self.mtSCRALib getMaskedTracks],
                             [self.mtSCRALib getTrack1Masked],
                             [self.mtSCRALib getTrack2Masked],
                             [self.mtSCRALib getTrack3Masked],
                             [self.mtSCRALib getTrack1],
                             [self.mtSCRALib getTrack2],
                             [self.mtSCRALib getTrack3],
                             [self.mtSCRALib getCardIIN],
                             [self.mtSCRALib getCardName],
                             [self.mtSCRALib getCardLast4],
                             [self.mtSCRALib getCardExpDate],
                             [self.mtSCRALib getCardServiceCode],
                             [self.mtSCRALib getCardPANLength],
                             [self.mtSCRALib getKSN],
                             [self.mtSCRALib getDeviceSerial],
                             [self.mtSCRALib getFirmware],
                             [self.mtSCRALib getMagnePrint],
                             [self.mtSCRALib getMagnePrintLength],
                             [self.mtSCRALib getMagnePrintStatus],
                             [self.mtSCRALib getSessionID],
                             [self.mtSCRALib getDeviceName]];
                
                break;
            }
                
            default:
            {
                pResponse = [NSString stringWithFormat:@"Track.Status: %@\n\n"
                             "Encryption.Status: %@\n\n"
                             "Track.Masked: %@\n\n"
                             "Track1.Masked: %@\n\n"
                             "Track2.Masked: %@\n\n"
                             "Track3.Masked: %@\n\n"
                             "Track1.Encrypted: %@\n\n"
                             "Track2.Encrypted: %@\n\n"
                             "Track3.Encrypted: %@\n\n"
                             "Card.IIN: %@\n\n"
                             "Card.Name: %@\n\n"
                             "Card.Last4: %@\n\n"
                             "Card.ExpDate: %@\n\n"
                             "Card.SvcCode: %@\n\n"
                             "Card.PANLength: %d\n\n"
                             "KSN: %@\n\n"
                             "Device.SerialNumber: %@\n\n"
                             "MagnePrint: %@\n\n"
                             "MagnePrintStatus: %@\n\n"
                             "SessionID: %@\n\n"
                             "Device Model Name: %@\n\n",
                             [self.mtSCRALib getTrackDecodeStatus],
                             [self.mtSCRALib getEncryptionStatus],
                             [self.mtSCRALib getMaskedTracks],
                             [self.mtSCRALib getTrack1Masked],
                             [self.mtSCRALib getTrack2Masked],
                             [self.mtSCRALib getTrack3Masked],
                             [self.mtSCRALib getTrack1],
                             [self.mtSCRALib getTrack2],
                             [self.mtSCRALib getTrack3],
                             [self.mtSCRALib getCardIIN],
                             [self.mtSCRALib getCardName],
                             [self.mtSCRALib getCardLast4],
                             [self.mtSCRALib getCardExpDate],
                             [self.mtSCRALib getCardServiceCode],
                             [self.mtSCRALib getCardPANLength],
                             [self.mtSCRALib getKSN],
                             [self.mtSCRALib getDeviceSerial],
                             [self.mtSCRALib getMagnePrint],
                             [self.mtSCRALib getMagnePrintStatus],
                             [self.mtSCRALib getSessionID],
                             [self.mtSCRALib getDeviceName]];
                
                break;
                
            }
        }
        
        [[self responseDataTextView] setText:pResponse];
        
        
        NSString *tempResponseDataString = [[self mtSCRALib] getResponseData];
        
        if([tempResponseDataString length] != 0 &&
           tempResponseDataString)
        {
            [[self rawResponseDataTextView] setText:tempResponseDataString];
        }
        
        */
        
        [self.mtSCRALib clearBuffers];
    }
}

#pragma mark -
#pragma mark UI Helper Methods
#pragma mark -

- (void)showActionSheet
{
    if (_noPicker) {
        return;
        
    }
    
    
    _pickerView = [[UIView alloc]initWithFrame:CGRectMake(0,  UIScreen.mainScreen.bounds.size.height - 240, UIScreen.mainScreen.bounds.size.width, 240.0)];
    _pickerView.backgroundColor = UIColorFromRGB(0xcccccc);
    
    _pickerVC = [[UIPickerView alloc] initWithFrame:CGRectMake(0, _pickerView.frame.size.height - 150, _pickerView.frame.size.width, 150)];
    _pickerVC.delegate = self;
    _pickerVC.dataSource = self;
    _pickerVC.showsSelectionIndicator = YES;
    _pickerVC.backgroundColor = UIColorFromRGB(0xcccccc);
    
    UIToolbar* pickerDateToolbar = [[UIToolbar alloc] initWithFrame: CGRectMake(0, 0, _pickerView.frame.size.width, 44)];
    pickerDateToolbar.barStyle =  UIBarStyleBlack;
    pickerDateToolbar.barTintColor = [UIColor whiteColor];
    pickerDateToolbar.translucent = true;
    
    
    UIBarButtonItem *cancelBtn = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancel_clicked:)];
    
    UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(done_clicked:)];
    
    pickerDateToolbar.items = [[NSArray alloc] initWithObjects:cancelBtn,flexSpace,doneBtn,nil];
    
    
    [_pickerView addSubview:pickerDateToolbar];
    _pickerView.alpha = 0;
    cancelBtn.tintColor = [UIColor blueColor];
    doneBtn.tintColor = [UIColor blueColor];
    
    
    
    [_pickerView addSubview:_pickerVC];
    [self.view addSubview:_pickerView];
    _noPicker = YES;
    [UIView animateWithDuration:0.2 animations:^{
        _pickerView.alpha = 1;
    } completion:^(BOOL finished) {
        
    }];
    
    
    
}

-(void)cancel_clicked:(id)sender{
    _noPicker = NO;
    [_dynaMaxSwitch setOn:NO];
    [UIView animateWithDuration:0.2 animations:^{
        _pickerView.alpha = 0;
    } completion:^(BOOL finished) {
        
        [_pickerView removeFromSuperview];
    }];
}

-(void)done_clicked:(id)sender{
    
    _noPicker = NO;
    // [_dynaMaxSwitch setOn:NO];
    [UIView animateWithDuration:0.2 animations:^{
        _pickerView.alpha = 0;
    } completion:^(BOOL finished) {
        if([self.peripheralArray count] > 0)
        {
            if(selectedRow < self.peripheralArray.count)
            {
                CBPeripheral *peripheral = (CBPeripheral *)[self.peripheralArray objectAtIndex:selectedRow];
                
                
                [self connectToBLEReader:peripheral];
            }
            
        }
        
        [_pickerView removeFromSuperview];
    }];
}

#pragma mark - DynaMAX BLE Section

-(void) connectToBLEReader:(CBPeripheral*) peripheral
{
    //_curPeripheral = peripheral;
    // If the iOS device is running a version of iOS 6.1 or earlier
//    if(floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1)
//    {
//        // if the Peripheral is not connected we set the Device UUID with the selected Peripheral's UUID
//        if(![peripheral isConnected])
//        {
//            // if the Peripheral's UUID is available
//            if([peripheral UUID])
//            {
//                NSString *uuidString = [NSString stringWithFormat:@"%@", CFUUIDCreateString(NULL, [peripheral UUID])];
//                
//                [[self mtSCRALib] setUUIDString:uuidString];
//            }
//            // else the Peripheral has never been connected so we set the Peripheral Device UUID to nil
//            else
//            {
//                [[self mtSCRALib] setUUIDString:nil];
//            }
//            
//            [self openDevice];
//        }
//        // else the device is connected so we close it's connection
//        else
//        {
//            [self closeDevice];
//        }
//    }
    // Else the iOS device is running a version of iOS 7.0 or later
    //else
    {
        // if the Peripheral is not connected we set the Device UUID with the selected Peripheral's UUID
        if([peripheral state] == CBPeripheralStateDisconnected)
        {
            // If there is another Peripheral that is connected then we disconnect it
            if([[[self mtSCRALib] getConnectedPeripheral] state] == CBPeripheralStateConnected)
            {
                [self closeDevice];
                
                [self removePeripheral];
            }
            
            // if the Peripheral's UUID is available
            if([peripheral identifier])
            {
                //NSString *uuidString = [NSString stringWithFormat:@"%@", [peripheral UUID]];
                NSString *uuidString =peripheral.identifier.UUIDString;// CFBridgingRelease(CFUUIDCreateString(kCFAllocatorDefault, peripheral.UUID));
                [[self mtSCRALib] setUUIDString:uuidString];
            }
            // else the Peripheral has never been connected so we set the Peripheral Device UUID to an empty string
            else
            {
                [[self mtSCRALib] setUUIDString:@""];
            }
            
            [self openDevice];
        }
        // else the device is connected so we close it's connection
        else
        {
            [self closeDevice];
            
            //[self removePeripheral];
        }
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow: (NSInteger)row inComponent:(NSInteger)component {
    // Handle the selection
    
    selectedRow = row;
}

// tell the picker how many rows are available for a given component
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    //NSUInteger numRows = 5;
    
    return [[[self mtSCRALib] getDiscoveredPeripherals] count];
}

// tell the picker how many components it will have
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

// tell the picker the title for a given component
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    CBPeripheral *peripheral = (CBPeripheral *)[self.peripheralArray objectAtIndex:row];
    
    
    
    return [peripheral name];
    
    
}

// tell the picker the width of each row for a given component
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    int sectionWidth = 300;
    
    return sectionWidth;
}

//
//#pragma mark - MTPickerViewController Delegates
//- (void)pickerViewController:(MTPickerViewController *)vc didSelectRows:(NSArray *)selectedRows {
//
//
//    if([self.peripheralArray count] > 0)
//    {
//
//        CBPeripheral *peripheral = (CBPeripheral *)[self.peripheralArray objectAtIndex:[[selectedRows objectAtIndex:0] intValue] ];
//
//
//        [self connectToBLEReader:peripheral];
//
//
//    }
//
//
//    _pickerVC = nil;
//}
//
//- (void)pickerViewControllerDidCancel:(MTPickerViewController *)vc {
//    NSLog(@"Selection was canceled");
//
//    [_dynaMaxSwitch setOn:NO animated:YES];
//
//    _pickerVC = nil;
//}
//
//- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
//    return 1;
//}
//
//- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
//    return [[[self mtSCRALib] getDiscoveredPeripherals] count];
//}
//
//- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
//    CBPeripheral *peripheral = (CBPeripheral *)[self.peripheralArray objectAtIndex:row];
//
//
//
//    return [peripheral name];
//}
//


#pragma mark -
#pragma mark Post Notification Selector Methods
#pragma mark -

- (void)trackDataReady:(NSNotification *)notification
{
    NSNumber *status = [[notification userInfo] valueForKey:@"status"];
    
    [self performSelectorOnMainThread:@selector(onDataEvent:)
                           withObject:status
                        waitUntilDone:NO];
}

- (void)devConnStatusChange
{
#ifdef _DGBPRNT
    NSLog(@"******* devConnStatusChange *******");
#endif
    
    // Ensure that updateConnStatus is performed on the Main Thread
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self updateConnStatus];
        
    });
}

#pragma mark -
#pragma mark Post Notification Selector Helper Methods
#pragma mark -

-(void) onDataRecieved:(MTCardData *)cardDataObj instance:(id)instance
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        
        
        
        [[self transactionStatusLabel] setText:@"Transfer Complete"];
        
        [self displayData:cardDataObj];
    });
}

-(void) cardSwipeDidStart:(id)instance

{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        
        dataResponds.text =@"Transfer Started";
        
        [[self transactionStatusLabel] setText:@"Transfer Started"];
    });
}

-(void)cardSwipeDidGetTransError
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [[self transactionStatusLabel] setText:@"Transfer Error"];
        
        [self.deviceConnectionStatusLabel setBackgroundColor:[UIColor redColor]];
        
        [self updateConnStatus];
        
    });
}

- (void)onDataEvent:(id)status
{
#ifdef _DGBPRNT
    NSLog(@"onDataEvent: %i", [status intValue]);
#endif
    
    switch ([status intValue])
    {
        case TRANS_STATUS_OK:
        {
            BOOL bTrackError = NO;
            
            [[self transactionStatusLabel] setText:@"Transfer Completed"];
            
            NSString *pstrTrackDecodeStatus = [[self mtSCRALib] getTrackDecodeStatus];
            
            [self displayData];
            
            @try
            {
                if(pstrTrackDecodeStatus)
                {
                    if(pstrTrackDecodeStatus.length >= 6)
                    {
#ifdef _DGBPRNT
                        NSString *pStrTrack1Status = [pstrTrackDecodeStatus substringWithRange:NSMakeRange(0, 2)];
                        NSString *pStrTrack2Status = [pstrTrackDecodeStatus substringWithRange:NSMakeRange(2, 2)];
                        NSString *pStrTrack3Status = [pstrTrackDecodeStatus substringWithRange:NSMakeRange(4, 2)];
                        
                        if(pStrTrack1Status && pStrTrack2Status && pStrTrack3Status)
                        {
                            if([pStrTrack1Status compare:@"01"] == NSOrderedSame)
                            {
                                bTrackError=YES;
                            }
                            
                            if([pStrTrack2Status compare:@"01"] == NSOrderedSame)
                            {
                                bTrackError=YES;
                                
                            }
                            
                            if([pStrTrack3Status compare:@"01"] == NSOrderedSame)
                            {
                                bTrackError=YES;
                                
                            }
                            
                            NSLog(@"Track1.Status=%@",pStrTrack1Status);
                            NSLog(@"Track2.Status=%@",pStrTrack2Status);
                            NSLog(@"Track3.Status=%@",pStrTrack3Status);
                        }
#endif
                    }
                }
                
            }
            @catch(NSException *e)
            {
            }
            
            if(bTrackError == NO)
            {
                //                [self closeDevice];
            }
            
            break;
            
        }
        case TRANS_STATUS_START:
            
            /*
             *
             *  NOTE: TRANS_STATUS_START should be used with caution. CPU intensive tasks done after this events and before
             *        TRANS_STATUS_OK may interfere with reader communication.
             *
             */
            
#ifdef _DGBPRNT
            NSLog(@"TRANS_STATUS_START");
#endif
            dataResponds.text =@"Transfer Started";
            
            [[self transactionStatusLabel] setText:@"Transfer Started"];
            
            break;
            
        case TRANS_STATUS_ERROR:
            
            if(self.mtSCRALib != NULL)
            {
#ifdef _DGBPRNT
                NSLog(@"TRANS_STATUS_ERROR");
#endif
                
                [[self transactionStatusLabel] setText:@"Transfer Error"];
                
                [self.deviceConnectionStatusLabel setBackgroundColor:[UIColor redColor]];
                
                [self updateConnStatus];
            }
            
            break;
            
        default:
            
            break;
    }
}

- (void)updateConnStatus
{
#ifdef _DGBPRNT
    NSLog(@"updateConnStatus");
#endif
    
    BOOL isDeviceOpened    = [[self mtSCRALib] isDeviceOpened];
    BOOL isDeviceConnected = [[self mtSCRALib] isDeviceConnected];
    
    
    if(isDeviceConnected)
    {
        if(isDeviceOpened)
        {
            [[self responseDataTextView]    setText:@"Connected"];
            [[self rawResponseDataTextView] setText:@""];
            
            [[self deviceConnectionStatusLabel] setText:@"Device Ready"];
            [[self deviceConnectionStatusLabel] setBackgroundColor:[UIColor greenColor]];
            
            
            
            switch([[self mtSCRALib] getDeviceType])
            {
                case MAGTEKAUDIOREADER:
                    
                    [[self audioSwitch] setOn:YES
                                     animated:YES];
                    
                    //[[self iDynamoSwitch] setHidden:YES];
                    
                    [[self iDynamoSwitch] setOn:NO
                                       animated:YES];
                    
                    [[self dynaMaxSwitch] setHidden:YES];
                    
                    [[self dynaMaxSwitch] setOn:NO
                                       animated:YES];
                    
                    /*
                     * DEPRECATED
                     */
                    
                    //                MPMusicPlayerController *musicPlayer = [MPMusicPlayerController applicationMusicPlayer];
                    //                [musicPlayer setVolume:1];
                    
                    
                    //[self createAndDisplayMPVolumeView];
                    
                    break;
                    
                case MAGTEKIDYNAMO:
                    
                    [[self audioSwitch] setHidden:YES];
                    
                    [[self audioSwitch] setOn:NO
                                     animated:YES];
                    
                    [[self iDynamoSwitch] setOn:YES
                                       animated:YES];
                    
                    [[self dynaMaxSwitch] setHidden:YES];
                    
                    [[self dynaMaxSwitch] setOn:NO
                                       animated:YES];
                    
                    break;
                    
                case MAGTEKDYNAMAX:
                    
                    [[self audioSwitch] setHidden:YES];
                    
                    [[self audioSwitch] setOn:NO
                                     animated:YES];
                    
                    [[self iDynamoSwitch] setHidden:YES];
                    
                    [[self iDynamoSwitch] setOn:NO
                                       animated:YES];
                    
                    [[self dynaMaxSwitch] setOn:YES
                                       animated:YES];
                    
                    
                    
                    
                    break;
                    
                default:
                    
                    break;
            }
        }
        else
        {
            [self.deviceConnectionStatusLabel setText:@"Device Not Ready"];
            [self.deviceConnectionStatusLabel setBackgroundColor:[UIColor redColor]];
            
            commandTextField.hidden=YES;
            commandButton.hidden = YES;
            
            [[self audioSwitch] setHidden:NO];
            
            [[self audioSwitch] setOn:NO
                             animated:YES];
            
            [[self iDynamoSwitch] setHidden:NO];
            
            [[self iDynamoSwitch] setOn:NO
                               animated:YES];
            
            [[self dynaMaxSwitch] setHidden:NO];
            
            [[self dynaMaxSwitch] setOn:NO
                               animated:YES];
            
            [[self scanButton] setHidden:YES];
            // [[self mtSCRALib] closeDevice];
            
        }
    }
    else
    {
        [self.responseDataTextView setText:@"Disconnected"];
        
        [self.deviceConnectionStatusLabel setText:@"Device Not Ready"];
        
        
        [self.deviceConnectionStatusLabel setBackgroundColor:[UIColor redColor]];
        
        commandTextField.hidden=YES;
        commandButton.hidden = YES;
        [devSwitch setOn:NO];
        [[self audioSwitch] setHidden:NO];
        
        [[self audioSwitch] setOn:NO
                         animated:YES];
        
        [[self iDynamoSwitch] setHidden:NO];
        
        //[[self iDynamoSwitch] setOn:NO
        //                   animated:YES];
        
        [[self dynaMaxSwitch] setHidden:NO];
        
        [[self dynaMaxSwitch] setOn:NO
                           animated:YES];
        
        [[self scanButton] setHidden:YES];
        
        if([self.mtSCRALib getDeviceType] == MAGTEKAUDIOREADER)
        {
            //[[self mtSCRALib] closeDevice];
        }
        //[[self mtSCRALib] closeDevice];
        
        /*[[self volumeSlider] setValue:_curVolume
         animated:YES];*/
        
        if(![self.mtSCRALib isDeviceOpened])
        {
            
            
            [[self audioSwitch] setOn:NO animated:YES];
            [[self dynaMaxSwitch] setOn:NO animated:YES];
            [[self iDynamoSwitch]  setOn:NO animated:YES];
        }
    }
}

#pragma mark -
#pragma mark MPVolumeHelper Methods
#pragma mark -

- (void)createAndDisplayMPVolumeView
{
    // Create a simple holding UIView and give it a frame
    UIView *volumeHolder = [[UIView alloc] initWithFrame: CGRectMake(30, 200, 260, 20)];
    
    // set the UIView backgroundColor to clear.
    [volumeHolder setBackgroundColor: [UIColor clearColor]];
    
    // add the holding view as a subView of the main view
    [self.view addSubview: volumeHolder];
    
    // Create an instance of MPVolumeView and give it a frame
    self.volumeView = [[MPVolumeView alloc] initWithFrame:[volumeHolder bounds]];
    
    self.volumeView.showsRouteButton = NO; //no showing
    self.volumeView.showsVolumeSlider = NO;
    
    // Add volumeHolder as a subView of the volumeHolder
    [volumeHolder addSubview:[self volumeView]];
    
    self.volumeSlider = [[UISlider alloc] init];
    
    [[[self volumeView] subviews] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        if([obj isKindOfClass:[UISlider class]])
        {
            self.volumeSlider = obj;
            
            *stop = YES;
        }
        
    }];
    
    [self.volumeSlider addTarget:self
                          action:@selector(handleVolumeChanged:)
                forControlEvents:UIControlEventValueChanged];
}

- (void)handleVolumeChanged:(id)sender
{
    self.volumeSlider.value = 1.0f;
}

#pragma mark -
#pragma mark Data Persistence Helper Methods
#pragma mark -

- (void)savePeripheral
{
    // retrieve the currently connected Peripheral information
    //CBPeripheral *peripheral = [[self mtSCRALib] getConnectedPeripheral];
    
    // store the Peripheral information for automatic connection later
    NSUserDefaults *userDefaults           = [NSUserDefaults standardUserDefaults];
    NSMutableArray *newDevicesMutableArray = [[NSMutableArray alloc] init];
    
    NSString *uuidString = _curPeripheral.identifier.UUIDString;//CFBridgingRelease(CFUUIDCreateString(kCFAllocatorDefault, _curPeripheral.UUID));
    
    if(![uuidString isEqualToString:@""])
    {
        [newDevicesMutableArray addObject:uuidString];
        
        [userDefaults setObject:newDevicesMutableArray
                         forKey:@"storedPeripheral"];
        
        [userDefaults synchronize];
    }
    else
    {
    }
}

- (NSString *)loadPeripheral
{
    // retrieve the stored Peripheral if any
    NSUserDefaults *userDefaults     = [NSUserDefaults standardUserDefaults];
    NSArray        *peripheralArray  = [userDefaults   objectForKey:@"storedPeripheral"];
    
    if([peripheralArray isKindOfClass:[NSArray class]])
    {
        if([peripheralArray count] > 0)
        {
            for(id deviceUUIDString in peripheralArray)
            {
                if(![deviceUUIDString isKindOfClass:[NSString class]])
                {
                    continue;
                }
                
                return deviceUUIDString;
            }
        }
    }
    
    return @"";
}

- (void)removePeripheral
{
    // remove the stored Peripheral connection
    NSUserDefaults *userDefaults           = [NSUserDefaults standardUserDefaults];
    NSArray        *peripheralArray        = [userDefaults objectForKey:@"storedPeripheral"];
    NSMutableArray *newDevicesMutableArray = [[NSMutableArray alloc] init];
    CBPeripheral   *peripheral             = [[self mtSCRALib] getConnectedPeripheral];
    
    if([peripheralArray isKindOfClass:[NSArray class]])
    {
        newDevicesMutableArray = [NSMutableArray arrayWithArray:peripheralArray];
        
        NSString *uuidString = peripheral.identifier.UUIDString;// [NSString stringWithFormat:@"%@", CFBridgingRelease(CFUUIDCreateString(kCFAllocatorDefault, peripheral.UUID))];
        
        if(uuidString)
        {
            [newDevicesMutableArray removeObject:uuidString];
        }
        
        [userDefaults setObject:newDevicesMutableArray
                         forKey:@"storedPeripheral"];
        
        [userDefaults synchronize];
    }
}

@end