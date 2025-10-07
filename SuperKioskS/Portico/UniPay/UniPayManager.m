//
//  UniPayClass.m
//  superkiosks
//
//  Created by Katherine Sheehy on 4/5/16.
//  Copyright © 2016 Sharecle. All rights reserved.
//

#import "UniPayManager.h"


@interface UniPayManager(){
    NSString *cardNumber;
    NSString *cardName;
    NSString *cardExpDate;
    
    UIAlertView *prompt_doConnection;
    UIAlertView *prompt_sendLog;
}
@end
@implementation UniPayManager

static bool s_bThreadRuning = NO;

-(void)start{
    //init object
    //LabelVersion.text = [NSString stringWithFormat:@"UniPay %@",[UniPay SDK_version]];
    
    [UniPay enableLogging:YES];
    if (_reader) {
        //[reader release];
        _reader = nil;
    }
    _reader = [[UniPay alloc] init];
    _reader.delegate = self;
    [_reader cmut_setAutoAdjustVolume :YES];

}

#pragma mark Attachment Event Delegate


-(void) UniPay_EventFunctionAttachment
{
    [self appendMessageToResults: @"Device attached."];
    //ROM: we will auto connect
    //[prompt_doConnection show];
    
    [self appendMessageToResults: @"Start connect task..."];
    [_reader cmut_StartConnect_Task];
    
}

-(void) UniPay_EventFunctionDetachment
{
    [self appendMessageToResults: @"Device detached."];
    /*if ([prompt_doConnection isVisible]) {
        [prompt_doConnection dismissWithClickedButtonIndex: 0 animated:YES];
    }
     */
}

#pragma mark Connect Event Delegate

-(void) UniPay_EventFunctionConnect:(Byte) nType
{
    NSLog(@"Connect event: %d", nType);
    //[self appendMessageToResults:[NSString stringWithFormat:@"Connect result:  0x%02X", nType]];
    [self displayUpRet: @"Connect result " returnValue: nType];
    
    if (RDS_CONNECTED == nType)
    {
        NSLog(@"Connected --");
        //connectedLabel.text = @"Connected";
        //connectedLabel.backgroundColor = [UIColor blueColor];
        [self appendMessageToResults:@"(Reader connected)"];
        
        //ROM: added enable msr on connect
        //RDStatus rt = [reader msr_StartMSR_Task];
        [self performSelector:@selector(f_msr_EnableMSR:) withObject:nil afterDelay:3.0];
        //[self f_msr_EnableMSR:nil];
    }
    else if (RDS_DISCONNECTED == nType)
    {
        NSLog(@"DisConnt --");
        //connectedLabel.text = @"Disconnect";
       // connectedLabel.backgroundColor = [UIColor grayColor];
        [self appendMessageToResults:@"(Reader disconnect)"];
    }
    
}

#pragma mark MSG Event Delegate

-(void) UniPay_EventFunctionMessage: (NSString *) someString
{
    NSLog(@"MSG: %@", someString);
    [self appendMessageToResults:[NSString stringWithFormat:@"MSG:  %@", someString]];
}

#pragma mark MSR card Event Delegate

-(void) UniPay_EventFunctionMSR: (Byte) nType : (NSData *) cardData
{
    if (RDS_TIMEDOUT == nType)
    {
        NSLog(@"MSR event: time out.");
        [self appendMessageToResults:[NSString stringWithFormat:@"MSR event: time out. data: %@", cardData.description]];
    }
    else if (RDS_SUCCESS == nType)
    {
        
        NSLog(@"MSR event: card data, %@", cardData.description);
        [self appendMessageToResults:[NSString stringWithFormat:@"MSR event: card data, %@", cardData.description]];
        
        //ROM: strip off '\0' at the beginning
        NSData *data= [cardData subdataWithRange:NSMakeRange(1,cardData.length-1)];
        
        NSString *strData=[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        
        [self appendMessageToResults:[NSString stringWithFormat:@"MSR event: card data to ASCII, %@", strData]];
        [self parseMSRCardData:strData];
        
        
        
    }
    else if (RDS_CANCELED == nType)
    {
        NSLog(@"MSR event: canceled.");
        [self appendMessageToResults:@"MSR event: canceled."];
    }
    else if (RDS_FAILED == nType)
    {
        NSLog(@"MSR event: error data.");
        [self appendMessageToResults:@"MSR event: error data."];
    }
}


#pragma mark ICC attach/detach Event
-(void) UniPay_EventFunctionICC: (Byte) nICC_Attached
{
    switch (nICC_Attached) {
        case 0x01:
        case 0x11:
        {
            NSLog(@"ICC event: ICC attached.");
            [self appendMessageToResults:@"ICC event: ICC attached."];
        }
            break;
            
        case 0x00:
        case 0x10:
        {
            NSLog(@"ICC event: ICC detached.");
            [self appendMessageToResults:@"ICC event: ICC detached."];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark MSR api

- (IBAction) f_msr_EnableMSR:(id)sender{
    RD_class * rt = [_reader msr_EnableMSR];
    if (RDS_FAILED == rt.status)
    {
    }
    else{
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_CARD_READY_TOSWIPE object:nil];
    }
    [self displayUpRet2: @"Enable MSR " returnValue: rt];
    
}

- (IBAction) f_msr_CancelMSR:(id)sender{
    RD_class * rt = [_reader msr_CancelMSR];
    [self displayUpRet2: @"Cacel MSR " returnValue: rt];
    
}

- (IBAction) f_msr_StartMSR_Task:(id)sender{
    RDStatus rt = [_reader msr_StartMSR_Task];
    [self displayUpRet: @"StartMSR_Task " returnValue: rt];
    
}

- (IBAction) f_msr_CancelMSR_Task:(id)sender{
    [_reader msr_CancelMSR_Task];
    [self appendMessageToResults:@"CancelMSR_Task."];
}

- (IBAction) f_msr_GetEncryptionMode:(id)sender{
    RD_class * rt = [_reader msr_GetEncryptionMode];
    [self displayUpRet2: @"Get MSR encryption mode " returnValue: rt];
}

- (IBAction) f_msr_SetEncryptionMode:(id)sender{
    /*
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Select mode"
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:
                                  @"TDes",
                                  @"AES",
                                  nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
    actionSheet.tag = (int)ACTION_SHEET_MSR_Encrypt_Mode;
    [actionSheet showInView:self.view];
    //[actionSheet release];
    actionSheet = nil;
    return;
    */
}

- (IBAction) f_msr_GetSecurityLevel:(id)sender{
    RD_class * rt = [_reader msr_GetSecurityLevel];
    [self displayUpRet2: @"Get MSR security level " returnValue: rt];
}


- (void) doEmailLog
{
    /*
    if ([MFMailComposeViewController canSendMail])
    {
        MFMailComposeViewController *mailVc = [[MFMailComposeViewController alloc] init];
        mailVc.mailComposeDelegate = self;
        [mailVc setSubject:@"iOS UniPay demo log"];
        
        NSData *att_wave = [reader debug_GetReceivedWave];
        if (att_wave)
            [mailVc addAttachmentData: att_wave mimeType:@"audio/x-caf" fileName:@"UiP_audio.wav"];
        
        NSData *att_log = [NSData dataWithContentsOfFile: [NSHomeDirectory() stringByAppendingPathComponent: @"/Documents/UiP_demo.log"]];
        if (att_log)
            [mailVc addAttachmentData: att_log mimeType:@"text/plain" fileName:@"UiP_demo.log"];
        
        [self presentModalViewController:mailVc animated:YES];
        //[mailVc release];
        mailVc = nil;
    }
    else
    {
        [self showAlertView: @"Cannot send email. Email not setup on this device"];
    }
     */
}
/*
- (void)mailComposeController:(MFMailComposeViewController*)controller
          didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    [self becomeFirstResponder];
    [self dismissModalViewControllerAnimated:YES];
}
*/
- (IBAction) f_Mail_Wave:(id)sender
{
  //  [prompt_sendLog show];
    
}

-(void)AddMessageLog:(NSString*)msg
{
    [self appendMessageToResults: msg];
}

-(void)MsgThrd:(NSString*)msg
{
    [self performSelectorOnMainThread:@selector(AddMessageLog:) withObject:msg waitUntilDone:YES];
}


-(void) displayUpRet_3:(NSString*) operation returnValue: (RD_class *)rt
{
    if (RDS_FAILED == rt.status)
    {
        NSString * strErr = [_reader comn_GetErrorString:rt.data];
        NSString * str = [NSString stringWithFormat:
                          @"%@ : \"%@\", data: %@, err: %@",
                          operation, RDStatus_lookup(rt.status), rt.data.description, strErr];
        [self MsgThrd:str];
    }
    else
    {
        int len = (int)rt.data.length;
        Byte *byD = (Byte *) rt.data.bytes;
        if (len>100) {
            NSString * str = @"";
            for (int i=0; i<15; i++) {
                if (i == 10)
                {
                    str = [NSString stringWithFormat:@"%@...",str];
                    continue;
                }
                if (i<10)
                {
                    str = [NSString stringWithFormat:@"%@%02X",str,byD[i]];
                    continue;
                }
                if (i>10)
                {
                    str = [NSString stringWithFormat:@"%@%02X",str,byD[len-1-(14-i)]];
                    continue;
                }
            }
            str =[NSString stringWithFormat:
                  @"%@ : \"%@\", len: %d, data: %@",
                  operation, RDStatus_lookup(rt.status), len, str];
            [self MsgThrd:str];
        }
        else
        {
            NSString * str = [NSString stringWithFormat:
                              @"%@ : \"%@\", len: %d, data: %@",
                              operation, RDStatus_lookup(rt.status), len, rt.data.description];
            [self MsgThrd:str];
        }
    }
    
}


-(void) Do_a_APDU : (NSString *) strCMD
{
    NSData *dataBuffer = nil;
    RD_class * rt;
    CFAbsoluteTime start;
    CFAbsoluteTime end;
    
    // 1
    NSString *Cmd1 = strCMD;
    dataBuffer = [self hexStringToBytes:Cmd1];
    start = CFAbsoluteTimeGetCurrent();
    //CFAbsoluteTime BegainAll = start;
    rt = [_reader smart_ExchangeAPDU: dataBuffer];
    end = CFAbsoluteTimeGetCurrent();
    [self displayUpRet_3: @"ExchangeData " returnValue: rt];
    [self MsgThrd: [NSString stringWithFormat:@"took %2.3f seconds.", end-start]];
    
    return;
}


-(void) Call_do_APDUs
{
    CFAbsoluteTime BegainAll = CFAbsoluteTimeGetCurrent();
    
    // 1
    [self Do_a_APDU: @"00a404000E315041592e5359532e444446303100"];
    // 2
    [self Do_a_APDU: @"00A4040007A000000003101000"];
    // 3
    [self Do_a_APDU: @"80A8000002830000"];
    // 4
    [self Do_a_APDU: @"00B2010C00"];
    // 5
    [self Do_a_APDU: @"00B2011400"];
    // 6
    [self Do_a_APDU: @"00B2021400"];
    // 7
    [self Do_a_APDU: @"00B2031400"];
    // 8
    [self Do_a_APDU: @"00B2011C00"];
    
    // 9
    [self Do_a_APDU: @"00B2021C00"];
    // 10
    [self Do_a_APDU: @"80AE80001D00000000100000000000000000564020009000097870010100FF230B8300"];
    // 11
    [self Do_a_APDU: @"80AE40001F30300000000010"];
    
    CFAbsoluteTime endAll = CFAbsoluteTimeGetCurrent();
    
    [self MsgThrd: [NSString stringWithFormat:@"all took %2.3f seconds.", endAll-BegainAll]];
    
}

-(void) procThread_APDUs
{
    //NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
    @autoreleasepool{
        [self Call_do_APDUs];
    }
    
    //[pool release];
    
    s_bThreadRuning = NO;
}


- (IBAction) f_runSomeAPDUs:(id)sender
{
    ///////////////////////////////////////
    
    s_bThreadRuning = YES;
    [NSThread detachNewThreadSelector:@selector(procThread_APDUs) toTarget:self withObject:NULL];
    NSLog(@"->");
    
}

-(void) Call_do_CMDs
{
    CFAbsoluteTime BegainAll = CFAbsoluteTimeGetCurrent();
    
    NSString * sCMD=nil;
    sCMD = @"";
    for (int i=0; i<700; i++) {
        sCMD = [NSString stringWithFormat:@"%@%02X",sCMD, i&0xff];
    }
    //NSLog(sCMD);
    NSData* dataBuffer = [self hexStringToBytes:sCMD];
    //NSLog(@"%@", dataBuffer.description);
    
    [_reader cmut_setCmdTimeoutDuration: 8];
    RD_class * rt = [_reader comn_directIO: dataBuffer];
    [_reader cmut_setCmdTimeoutDuration: 3];
    [self displayUpRet_3: @"DirectIO " returnValue: rt];
    
    //APDU
    //201
    [self Do_a_APDU: @"063df7acec76cce7b22eabf37c853a3fbd1a4a0e2c812d5b931fa5de3bfe993cc420331ae354daaeab583c5936c830fe04b38bb8062a7c84d388bf5192374541669301a59d52ed0fb5a41e212f7f2319effe028a1e6b8a98ec3f62775a5a1d0decde189bc8eac6fd7c4af3a95feccc690f98e88fad607a6f80308b2a520cc480eb29cb2b9376d44542f894fdb3a019077a683e139441488f535dc20a40e82f2169829d33c22dc1c5a874b131975163ac067432c4401b033ac36720ca9fce14e2c96e21cb7eb21639df"];
    //225
    [self Do_a_APDU: @"064165a65d35715f4fea625e29435c957e14ede2b688f9429813b09b596a0430e66903c263fa67e70309117d2f97843096ee9bd000caa884302d7bed54c76e40f2cea411f79481cfa3e8d512ead195992889501c60eb3361d6427d8ba07b2b7de3262d5f4deb7dabf52277b96e9d0d5d7d30aab86211ed7392e1f429ed071e3bc4317647fc4dbc40f239d8292e9e654e10b1a989dc849896b874d0c4e586162124ccce56da564793a5dd2cfaaba6c5daed0a86943a84e932937dce7e43893d5e89dfa97d3b6e4a9556f30d0c0650f0941e1e692ce94ecf110b5a5b8383ba58f6c6"];
    //209
    [self Do_a_APDU: @"068d9075f88360628348ab15fcfeb88cc3e875c3841c571d6ef42974a69fb8146fcb6902e46ce77c4c9890a5a3d253bc4de509470959b9c9c47e3e7fe806628f7d485d1eece73700148e9e59217dc8a3b839485306b3099407be3f9d8e839d4366303eaf156614d38befebc44986672e214a72798152a8c3cb9bdb5a3a3be999705a3d8db93fa2b1d1a91e922b78e2884e99b258b9ccfdb075ac9d95921b1461de4244560ba820a9bd14b5985c9e8e828751ac323ef7760839978a77e73e68bcbc6caba6c40c34d07c006c040bb394f1a9"];
    //fail
    [self Do_a_APDU: @"067d0528469ae59f1819e141d6206267575fcaf9ac9e12a7026bd7933ecd90211127d9dd10d258404a496c8fa1ff4d3611a2a81731c6d1f4ae6858f0b168fae4bb2d3fc191120f484cb9dca51f0ad21facf0026f998a08886b4fded1d4eadb393f048a8f1773ee9a5c0004a741f197f9b07d0406c5aa725c7b9da455681c7b46b29598fecce2841b5ea965eda1b898df17fd967395885cc29ebeee21917da3ce7d1c5f2d5849d84ba893067426d413049561c33a870ceca7c5269d9dadd6ded26f19a3fc6221a91c0494d4ee67de2455182adcddd626ab"];
    //193
    [self Do_a_APDU: @"064fe56add28895c67f621bc50fae51a07e8745fc190eedce79262a2c9e1513902173fcff577e7bc9eb04e387802f83658a31b34224aff76e21b4292772cb6f78830a50fcd486bea89a88a6bf354172f2ba0fe4b0bffb392c705f5642d16a636b260b48129d0bea4db01bf7cca44bac45ace45633359c23f36e98d5bbc1eeadc936cfc0e87aa74ee1ee674f67ca6b7fbfd83cb7b907f9aadfcda827dc6749a113b8422520f198c167bd7b148381a38e0a6e88e755684b0906f27df56520ca88afd"];
    
    [self Do_a_APDU: @"02a1000637651042b73cf5828df44cf408c2ecb0b158e58c99fd2fc11c8e97cb9a8625b6aa1136cc7b463f174fdb10242ade48c41d4daa9f6b04d95a541797c6e7ec52e4803fa25472037041e4b39218d69f26d16fc3e89c07894e25f756a03bec1c194c460e9915133d5a80f863f78edb76572730c1e8068171ad72cc0fb60903d012530b6e4a567a6e4bf591b445552997d1e09698a367af17f1ac2f510280f433b7831cfa03"];
    
    [self Do_a_APDU: @"724663865A2907B1B7B57B94124F9DAFF78427492E56BB24BD38567C0300AFABC455AB19494438A2078F2C1A744AE0BE880B02"];
    
    CFAbsoluteTime endAll = CFAbsoluteTimeGetCurrent();
    
    [self MsgThrd: [NSString stringWithFormat:@"all took %2.3f seconds.", endAll-BegainAll]];
}

-(void) procThread_CMDs
{
    //NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
    
    @autoreleasepool{
        [self Call_do_CMDs];
    }
    
    //[pool release];
    
    s_bThreadRuning = NO;
}

- (IBAction) f_runSomeCMDs:(id)sender
{
    s_bThreadRuning = YES;
    [NSThread detachNewThreadSelector:@selector(procThread_CMDs) toTarget:self withObject:NULL];
    NSLog(@"->");
    
}

-(void)Do_loop
{
    RD_class * rt;
    
    /*
     [NSThread sleepForTimeInterval:0.5];
     rt = [reader smart_ICC_PowerOn ];
     [self displayUpRet_3: @"PowerOn " returnValue: rt];
     
     [NSThread sleepForTimeInterval:0.5];
     rt = [reader smart_GetKSN ];
     [self displayUpRet_3: @"GetKSN " returnValue: rt];
     
     [NSThread sleepForTimeInterval:0.5];
     NSData* dataBuffer = [self hexStringToBytes:@"E4D34DC859B446CDCA15419A5ECC5FBBA8189A2D4688EBE8"];
     rt = [reader smart_ExchangeAPDU_DUKPT_Fully: dataBuffer];
     [self displayUpRet_3: @"ExchangeAPDU " returnValue: rt];
     
     [NSThread sleepForTimeInterval:0.5];
     rt = [reader smart_ICC_PowerOff ];
     [self displayUpRet_3: @"PowerOff " returnValue: rt];
     */
    
    [NSThread sleepForTimeInterval:0.5];
    rt = [_reader msr_EnableMSR];
    //NSLog(@"EnableMSR %d", rs);
    
    [NSThread sleepForTimeInterval:0.5];
    rt = [_reader smart_GetICC_Status];
    [self displayUpRet_3: @"GetICC_Status " returnValue: rt];
    
    
    //[NSThread sleepForTimeInterval:0.5];
    //[reader msr_CancelMSR_Task];
    //NSLog(@"CancelMSR.");
    
    
}

-(void) procThread_loop
{
    //NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
    
    @autoreleasepool{
        [self Do_loop];
    }
    
    //[pool release];
    
    s_bThreadRuning = NO;
}

- (IBAction) f_runTest2:(id)sender;
{
    if (!s_bThreadRuning) {
        s_bThreadRuning = YES;
        [NSThread detachNewThreadSelector:@selector(procThread_loop) toTarget:self withObject:NULL];
        NSLog(@"->");
    }
    
}

-(void) appendMessageToResults:(NSString*) message{
    //return;
    /*[self.resultsTextView setText:[NSString stringWithFormat:@"%@\n%@", self.resultsTextView.text, message]];
    [self.resultsTextView scrollRangeToVisible:NSMakeRange([self.resultsTextView.text length], 0)];
     */
#ifdef DEBUG
    NSLog(@"%@",message);
#endif
}

-(void) displayUpRet:(NSString*) operation returnValue: (RDStatus)ret
{
    /*
     NSString * str = [NSString stringWithFormat:
     @"%@ %@\nReturn code: \"%@\"",
     operation, (RDS_SUCCESS==ret?@"succeeded":@"failed"), RDStatus_lookup(ret)];
     */
    NSString * str = [NSString stringWithFormat:
                      @"%@ : \"%@\"",
                      operation, RDStatus_lookup(ret)];
    [self appendMessageToResults:str];
}


-(void) displayUpRet2:(NSString*) operation returnValue: (RD_class *)rt
{
    if (RDS_FAILED == rt.status)
    {
        NSString * strErr = [_reader comn_GetErrorString:rt.data];
        NSString * str = [NSString stringWithFormat:
                          @"%@ : \"%@\", data: %@, err: %@",
                          operation, RDStatus_lookup(rt.status), rt.data.description, strErr];
        [self appendMessageToResults:str];
    }
    else
    {
        NSString * str = [NSString stringWithFormat:
                          @"%@ : \"%@\", data: %@",
                          operation, RDStatus_lookup(rt.status), rt.data.description];
        [self appendMessageToResults:str];
    }
    
}


#pragma mark ActionSheet
typedef enum {
    ACTION_SHEET_MSR_Encrypt_Mode=501,
    ACTION_SHEET_ICC_Encrypt_Mode,
    ACTION_SHEET_ICC_KeyType_DUKPT,
} ActionSheetList;

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == actionSheet.cancelButtonIndex) {
        return;
    }
    
    //NSString *result = nil;
    //NSData *rawResult = nil;
    long normalizedButtonIdx = buttonIndex - actionSheet.firstOtherButtonIndex;
    
    [actionSheet dismissWithClickedButtonIndex:actionSheet.cancelButtonIndex animated:YES];
    
    switch (actionSheet.tag) {
        case ACTION_SHEET_MSR_Encrypt_Mode:
        {
            
            RD_class * rt;
            Byte bP = 0x31; //TDes
            switch (normalizedButtonIdx) {
                case 0: //TDES
                    bP = 0x31; //TDes
                    rt = [_reader msr_SetEncryptionMode: bP];
                    [self displayUpRet2: @"Set MSR encryption mode to TDes " returnValue: rt];
                    break;
                case 1: //AES
                    bP = 0x32; //TDes
                    rt = [_reader msr_SetEncryptionMode: bP];
                    [self displayUpRet2: @"Set MSR encryption mode to AES " returnValue: rt];
                    break;
            }
            
        }
            break;
        case ACTION_SHEET_ICC_Encrypt_Mode:
        {
            
            RD_class * rt;
            Byte bP = 0x00; //TDes
            switch (normalizedButtonIdx) {
                case 0: //TDES
                    bP = 0x00; //TDes
                    rt = [_reader smart_SetEncryptionMode: bP];
                    [self displayUpRet2: @"Set ICC encryption mode to TDes " returnValue: rt];
                    break;
                case 1: //AES
                    bP = 0x01; //AES
                    rt = [_reader smart_SetEncryptionMode: bP];
                    [self displayUpRet2: @"Set ICC encryption mode to AES " returnValue: rt];
                    break;
            }
            
        }
            break;
        case ACTION_SHEET_ICC_KeyType_DUKPT:
        {
            
            RD_class * rt;
            Byte bP = 0x00; //data key
            switch (normalizedButtonIdx) {
                case 0: //data key
                    bP = 0x00; //data key
                    rt = [_reader smart_Set_KeyType_DUKPT: bP];
                    [self displayUpRet2: @"Set ICC KeyType as data key " returnValue: rt];
                    break;
                case 1: //PIN key
                    bP = 0x01; //PIN key
                    rt = [_reader smart_Set_KeyType_DUKPT: bP];
                    [self displayUpRet2: @"Set ICC KeyType as PIN key " returnValue: rt];
                    break;
            }
            
        }
            break;
    }
}

#pragma mark inputAlert
typedef enum {
    SET_SERAIL_NUMBER = 900,
    SET_ENCRYPTION_MODE_ICC,
    SET_KEY_TYPE_DUKPT_ICC,
    SET_ENCRYPTION_MODE_MSR,
    SET_AUDIO_VOLUME
} ActionSheetTags;

/*
 if (userInputAlert) {
 [userInputAlert release];
 userInputAlert = nil;
 }
 
 userInputAlert = [[InputAlert alloc] init];
 userInputAlert.tag = SET_ENCRYPTION_MODE_ICC;
 userInputAlert.delegate = self;
 [userInputAlert showWithTitle:@"Enter Select File Location"];
 */

-(void)inputAlert:(InputAlert *)inputAlert valueEntered:(NSString *)valueEntered{
    if (!valueEntered) {
        return;
    }
    NSData *dataBuffer = nil;
    
    if(inputAlert.tag == SET_SERAIL_NUMBER)
    {
        if (valueEntered.length < 9) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:@"Select file value must be at least 2 bytes"
                                                           delegate:nil
                                                  cancelButtonTitle:@"Dismiss"
                                                  otherButtonTitles:nil];
            [alert show];
            //[alert release];
            alert = nil;
            return;
        }
        dataBuffer = [self hexStringToBytes:valueEntered];
        if (dataBuffer.length<2) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid"
                                                            message:@"Select file value is invalid"
                                                           delegate:nil
                                                  cancelButtonTitle:@"Dismiss"
                                                  otherButtonTitles:nil];
            [alert show];
            //[alert release];
            alert = nil;
            return;
        }
        
        //NSData *resultData = [iSmartDevice Quick_SelectFile:dataBuffer];
        //[self appendMessageToResults:[NSString stringWithFormat:@"Quick_Select Result: %@", resultData.description]];
        
    }
    else if(inputAlert.tag == SET_ENCRYPTION_MODE_ICC)
    {
        
        if (valueEntered.length != 1)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid"
                                                            message:@"Input data length must be 1 or 0."
                                                           delegate:nil
                                                  cancelButtonTitle:@"Dismiss"
                                                  otherButtonTitles:nil];
            [alert show];
            //[alert release];
            alert = nil;
            return;
        }
        else
        {
            Byte bP = 0x00;
            if ([valueEntered compare: @"0"] == NSOrderedSame) //TDES
            {
                bP = 0x00;
            }
            else if ([valueEntered compare: @"1"] == NSOrderedSame) //AES
            {
                bP = 0x01;
            }
            RD_class * rt = [_reader smart_SetEncryptionMode: bP];
            [self displayUpRet2: @"Set ICC encryption mode " returnValue: rt];
            
        }
        
    }
    else if(inputAlert.tag == SET_KEY_TYPE_DUKPT_ICC)
    {
        if (valueEntered.length != 1)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid"
                                                            message:@"Input data length must be 1 or 0."
                                                           delegate:nil
                                                  cancelButtonTitle:@"Dismiss"
                                                  otherButtonTitles:nil];
            [alert show];
            //[alert release];
            alert = nil;
            return;
        }
        else
        {
            Byte bP = 0x00;
            if ([valueEntered compare: @"0"] == NSOrderedSame) //data key
            {
                bP = 0x00;
            }
            else if ([valueEntered compare: @"1"] == NSOrderedSame) //PIN key
            {
                bP = 0x01;
            }
            RD_class * rt = [_reader smart_Set_KeyType_DUKPT: bP];
            [self displayUpRet2: @"Set ICC KeyType of DUKPT " returnValue: rt];
            
        }
    }
    else if(inputAlert.tag == SET_ENCRYPTION_MODE_MSR)
    {
        if (valueEntered.length != 1)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid"
                                                            message:@"Input data length must be 1 or 0."
                                                           delegate:nil
                                                  cancelButtonTitle:@"Dismiss"
                                                  otherButtonTitles:nil];
            [alert show];
            //[alert release];
            alert = nil;
            return;
        }
        else
        {
            Byte bP = 0x00;
            if ([valueEntered compare: @"0"] == NSOrderedSame) //TDES
            {
                bP = 0x31;
            }
            else if ([valueEntered compare: @"1"] == NSOrderedSame) //AES
            {
                bP = 0x32;
            }
            RD_class * rt = [_reader msr_SetEncryptionMode: bP];
            [self displayUpRet2: @"Set MSR encryption mode " returnValue: rt];
            
        }
    }
    else if(inputAlert.tag == SET_AUDIO_VOLUME)
    {
        if (valueEntered.length != 3)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid"
                                                            message:@"Input volum data is invalid, should 0.1 ~ 1.0"
                                                           delegate:nil
                                                  cancelButtonTitle:@"Dismiss"
                                                  otherButtonTitles:nil];
            [alert show];
            //[alert release];
            alert = nil;
            return;
        }
        if ([valueEntered compare: @"1.0"] == NSOrderedSame) {
            RD_class * rt = [_reader cmut_setVolume: 1.0];
            [self displayUpRet: @"Set audio volums " returnValue: rt.status];
            
            return;
        }
        
        //NSString *string1 = [valueEntered substringWithRange:NSMakeRange(0, 2)];
        if ([valueEntered compare: @"1.0"] == NSOrderedDescending)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid"
                                                            message:@"Input volum value is invalid, should be 0.1 ~ 1.0"
                                                           delegate:nil
                                                  cancelButtonTitle:@"Dismiss"
                                                  otherButtonTitles:nil];
            [alert show];
            //[alert release];
            alert = nil;
            return;
        }
        
        float fV = 2.0;
        if ([valueEntered compare: @"0.9"] == NSOrderedSame)
            fV = 0.9;
        else if ([valueEntered compare: @"0.8"] == NSOrderedSame)
            fV = 0.8;
        else if ([valueEntered compare: @"0.7"] == NSOrderedSame)
            fV = 0.7;
        else if ([valueEntered compare: @"0.6"] == NSOrderedSame)
            fV = 0.6;
        else if ([valueEntered compare: @"0.5"] == NSOrderedSame)
            fV = 0.5;
        else if ([valueEntered compare: @"0.4"] == NSOrderedSame)
            fV = 0.4;
        else if ([valueEntered compare: @"0.3"] == NSOrderedSame)
            fV = 0.3;
        else if ([valueEntered compare: @"0.2"] == NSOrderedSame)
            fV = 0.2;
        else if ([valueEntered compare: @"0.1"] == NSOrderedSame)
            fV = 0.1;
        
        if (fV > 1.0)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid"
                                                            message:@"Input volum value is invalid, should be 0.1 ~ 1.0"
                                                           delegate:nil
                                                  cancelButtonTitle:@"Dismiss"
                                                  otherButtonTitles:nil];
            [alert show];
            //[alert release];
            alert = nil;
            return;
        }
        
        [_reader cmut_setAutoAdjustVolume: NO];
        RD_class * rt = [_reader cmut_setVolume: fV];
        [self displayUpRet: @"Set audio volums " returnValue: rt.status];
    }
    
}


-(void) dismissAllAlertViews {
    [prompt_doConnection dismissWithClickedButtonIndex:-1 animated:FALSE];
    [prompt_sendLog dismissWithClickedButtonIndex:-1 animated:FALSE];
}

-(void) showAlertView:(NSString*)msg {
    [self dismissAllAlertViews];
    
    UIAlertView *alertView = [[UIAlertView alloc]
                              initWithTitle:@"uniPay"
                              message:msg
                              delegate:nil
                              cancelButtonTitle:@"Ok"
                              otherButtonTitles:nil];
    [alertView show];
    //[alertView release];
    alertView = nil;
}


- (void)alertView:(const UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    if (alertView == prompt_doConnection)
    {
        //selected option to start the connection task at the reader attachment prompt
        if (1 == buttonIndex) {
            [self appendMessageToResults: @"Start connect task..."];
            [_reader cmut_StartConnect_Task];
            
        }
    }
    if (alertView == prompt_sendLog) {
        //selected ok at the send log prompt
        if (1 == buttonIndex)
            [self doEmailLog];
    }
}


//ROM parser
-(void)parseMSRCardData:(NSString *)cardData{
    
    //%B5409970243628336^QUIDILIG/ROMULO           ^18081011279700889000000?;5409970243628336=18081011279710000889?
    
#ifdef DEBUG
    NSLog(@"cardData=%@",cardData);
#endif
    if(cardData==nil || [cardData isEqual:[NSNull null]]){
        [self performSelector:@selector(f_msr_EnableMSR:) withObject:nil afterDelay:3.0];
        return;
    }
    
    NSString *track1;
    NSString *track2;
    NSString *track3;
    
    NSArray *tracks=[cardData componentsSeparatedByString:@"?"];
    
    if([tracks count]>=1){
        track1=[tracks objectAtIndex:0];
        
    }
    if([tracks count]>=2){
        track2=[tracks objectAtIndex:1];
        
    }
    if([tracks count]>=3){
        track3=[tracks objectAtIndex:2];
        
    }
#ifdef DEBUG
    NSLog(@"track1=%@ track2=%@ track3=%@",track1,track2,track3);
#endif
    if(track1.length>0){
        //%B5409970243628336^QUIDILIG/ROMULO           ^18081011279700889000000?
        //NSString *pat=@"^%B\\d{0,19}\\^[\\w\\s\\/]{2,26}\\^\\d{7}\\w*$";
        NSString *pat=@"^%B(\\d{0,19})\\^([\\w\\s\\/]{2,26})\\^(\\d{7}\\w*)$";
        
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pat options:0 error:NULL];
        
        NSTextCheckingResult *match = [regex firstMatchInString:track1 options:0 range:NSMakeRange(0, [track1 length])];
        if(match!=nil){
            
            //NSArray *fields=[track1 componentsSeparatedByString:@"^"];
            
            
            //track 1
            //NSString *m_tarck1=[cardData substringWithRange:[match rangeAtIndex:1]];
            
            cardNumber=[track1 substringWithRange:[match rangeAtIndex:1]];
            //for some reason there is * at the end, i dont know where it's coming from
            //so we just remove it it it's there
            //cardNumber=[cardNumber stringByReplacingOccurrencesOfString:@"*" withString:@""];
            cardNumber=[cardNumber stringByReplacingOccurrencesOfString:@" " withString:@""];
            
            cardName=[track1 substringWithRange:[match rangeAtIndex:2]];
            //cardName=[cardName stringByReplacingOccurrencesOfString:@"*" withString:@""];
            cardName=[cardName stringByReplacingOccurrencesOfString:@" " withString:@""];
            //change last/first to first last
            NSArray *n=[cardName componentsSeparatedByString:@"/"];
            cardName=[NSString stringWithFormat:@"%@ %@",[n objectAtIndex:1],[n objectAtIndex:0]];
            
            cardExpDate=[track1 substringWithRange:[match rangeAtIndex:3]];
            //cardExpDate=[NSString stringWithFormat:@"%@/%@",[cardExpDate substringWithRange:NSMakeRange(0, 2)],[cardExpDate substringWithRange:NSMakeRange(2, 2)]];
            NSString *cardExpYear=[cardExpDate substringWithRange:NSMakeRange(0, 2)];
            NSString *cardExpMonth=[cardExpDate substringWithRange:NSMakeRange(2, 2)];
            
            
#ifdef DEBUG
            NSLog(@"cardNumber=%@ cardName=%@ cardExpDate=%@/%@",cardNumber,cardName,cardExpMonth,cardExpYear);
#endif
            /*
             unsigned intInterval;
             NSScanner *scanner = [NSScanner scannerWithString:hexInterval];
             [scanner scanHexInt:&intInterval];
             */
            
            //[self dismissViewControllerAnimated:YES completion:^{
                [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_CARD_SWIPED object:nil userInfo:@{@"cardNumber":cardNumber,@"cardName":cardName,@"cardExpYear":cardExpYear,@"cardExpMonth":cardExpMonth}];
            //}];
        }
        else{
#ifdef DEBUG
            NSLog(@"Track 1 no match.");
#endif
        }
    }
    
    if(track2.length>0){
        NSString *pat=@";\\d{0,19}=\\d{7}\\w*\\?";
        
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pat options:0 error:NULL];
        
        NSTextCheckingResult *match = [regex firstMatchInString:track2 options:0 range:NSMakeRange(0, [track2 length])];
        if(match!=nil){
            
            
        }
        else{
#ifdef DEBUG
            NSLog(@"Track 2 no match.");
#endif
        }
    }
}

-(void)testParser{
    NSString *cardData=@"%B4242424242424242^QUIDILIG/ROMULO           ^18081011279700889000000?;4242424242424242=18081011279710000889?";
    [self parseMSRCardData:cardData];
}



- (IBAction) DoClearLog:(id)sender
{
    /*
    [self.resultsTextView setText: @""];
    [self.resultsTextView scrollRangeToVisible:NSMakeRange([self.resultsTextView.text length], 0)];
     */
}

- (IBAction) DoKeyboardOff:(id)sender{
    [sender resignFirstResponder];
}

#pragma mark comn api

- (IBAction) f_getFirm:(id)sender{
    
    //[self appendMessageToResults: @"f_getFirm."];
    RD_class *rt = [_reader comn_GetFirmVersion];
    [self displayUpRet2: @"Get FirmVersion " returnValue: rt];
    if (RDS_SUCCESS == rt.status)
    {
        NSString* aStr = [[NSString alloc] initWithData: rt.data encoding:NSASCIIStringEncoding];
        [self appendMessageToResults:[NSString stringWithFormat:@"\"%@\"", aStr]];
    }
}

- (IBAction) f_DoTest:(id)sender
{
    NSString * sCMD=nil;
    sCMD = @"";
    for (int i=0; i<800; i++) {
        sCMD = [NSString stringWithFormat:@"%@%02X",sCMD, i&0xff];
    }
    //NSLog(sCMD);
    NSData* dataBuffer = [self hexStringToBytes:sCMD];
    //NSLog(@"%@", dataBuffer.description);
    
    [_reader cmut_setCmdTimeoutDuration: 8];
    RD_class * rt = [_reader comn_directIO: dataBuffer];
    [_reader cmut_setCmdTimeoutDuration: 3];
    [self displayUpRet2: @"DirectIO " returnValue: rt];
    
    /*
     RD_class * rt = [reader smart_GetAllSetting];
     [self displayUpRet2: @"ICC GetAll: " returnValue: rt];
     if (RDS_SUCCESS == rt.status)
     {
     [self appendMessageToResults:[NSString stringWithFormat:@"data: %@", rt.data.description]];
     }
     */
    /*
     Byte by[] = {0x15, 0x6A, 0x00};
     NSData *dt = [NSData dataWithBytes: by length:3];
     NSString *str = [reader comn_GetErrorString: dt];
     NSLog(str);
     [self appendMessageToResults:str];
     */
}


- (IBAction) f_getSerialNumber:(id)sender{
    
    //[self appendMessageToResults: @"f_getSerialNumber."];
    RD_class * rt = [_reader comn_GetSerialNumber];
    [self displayUpRet2: @"Get SerialNumber " returnValue: rt];
    if (RDS_SUCCESS == rt.status) {
        //[self appendMessageToResults:[NSString stringWithFormat:@"data: %@", rt.data.description]];
        NSString* aStr = [[NSString alloc] initWithData: rt.data encoding:NSASCIIStringEncoding];
        [self appendMessageToResults:[NSString stringWithFormat:@"\"%@\"", aStr]];
    }
}

- (IBAction) f_setSerialNumber:(id)sender{
    RD_class * rt = [_reader comn_SetSerialNumber: @"0123456789"];
    [self displayUpRet2: @"Set serial number " returnValue: rt];
}

- (IBAction) f_GetModelNumber:(id)sender{
    RD_class * rt = [_reader comn_GetModelNumber];
    [self displayUpRet2: @"Get model number " returnValue: rt];
}


#pragma mark ICC api

- (IBAction) f_smart_GetICC_Status:(id)sender{
    RD_class * rt = [_reader smart_GetICC_Status];
    [self displayUpRet2: @"Get ICC_Status " returnValue: rt];
    
    if (RDS_SUCCESS == rt.status)
    {
        NSLog(@"return ICC status: %@", rt.data.description);
        Byte *tp = (Byte *) rt.data.bytes;
        if (rt.data.length<2)
        {
            NSLog(@"Return ICC status: no data");
            return;
        }
        Byte sts1 = tp[1];
        NSString * sta = nil;
        if((sts1 & 0x01) == (Byte)0x01)
            sta =@"[ICC powerd]";
        else
            sta = @"[ICC Power not ready]";
        if((sts1 & 0x02)== (Byte)0x02)
            sta =[NSString stringWithFormat:@"%@,[Card seated]", sta];
        else
            sta =[NSString stringWithFormat:@"%@,[Card not seated]", sta];
        
        [self appendMessageToResults:[NSString stringWithFormat:@"%@",sta]];
    }
    
}

- (IBAction) f_smart_GetEncryptionMode:(id)sender{
    RD_class * rt = [_reader smart_GetEncryptionMode];
    [self displayUpRet2: @"Get ICC encryption mode " returnValue: rt];
}


- (IBAction) f_setAudioVolume:(id)sender{
    
    RD_class * rt = [_reader cmut_setVolume: 1.0];
    //[self SetTextV: 1: @"Set AudioVolume: 1.0\n"];
    [self displayUpRet: @"Set audio volums " returnValue: rt.status];
    
}


- (IBAction) f_directIO:(id)sender{
    /*
    [txtDirectIO resignFirstResponder];
    
    NSData *dataBuffer = nil;
    NSString *valueEntered = txtDirectIO.text;
    int len = (int)valueEntered.length;
    if ((len<2)
        || (0 != len%2))
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid"
                                                        message:@"Input data is invalid."
                                                       delegate:nil
                                              cancelButtonTitle:@"Dismiss"
                                              otherButtonTitles:nil];
        [alert show];
        //[alert release];
        alert = nil;
        return;
    }
    else
    {
        dataBuffer = [self hexStringToBytes:valueEntered];
        if (dataBuffer.length<1) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid"
                                                            message:@"Input value is invalid."
                                                           delegate:nil
                                                  cancelButtonTitle:@"Dismiss"
                                                  otherButtonTitles:nil];
            [alert show];
            //[alert release];
            alert = nil;
            return;
        }
    }
    
    RD_class * rt = [reader comn_directIO: dataBuffer];
    [self displayUpRet2: @"DirectIO " returnValue: rt];
     */
    
}

- (IBAction) f_smart_SetEncryptionMode:(id)sender
{
    /*
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Select mode"
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:
                                  @"TDes",
                                  @"AES",
                                  nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
    actionSheet.tag = (int)ACTION_SHEET_ICC_Encrypt_Mode;
    [actionSheet showInView:self.view];
    //[actionSheet release];
    actionSheet = nil;
    return;
     */
    
}

- (IBAction) f_smart_Get_KeyType_DUKPT:(id)sender{
    RD_class * rt = [_reader smart_Get_KeyType_DUKPT];
    [self displayUpRet2: @"Get KeyType_DUKPT " returnValue: rt];
}

- (IBAction) f_smart_Set_KeyType_DUKPT:(id)sender
{
    /*
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Select type"
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:
                                  @"data key",
                                  @"PIN key",
                                  nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
    actionSheet.tag = (int)ACTION_SHEET_ICC_KeyType_DUKPT;
    [actionSheet showInView:self.view];
    //[actionSheet release];
    actionSheet = nil;
    return;
    */
}

-(IBAction)f_smart_ICC_PowerOn:(id)sender{
    RD_class * rt = [_reader smart_ICC_PowerOn];
    [self displayUpRet2: @"ICC_PowerOn " returnValue: rt];
}

- (IBAction) f_smart_ICC_PowerOff:(id)sender{
    RD_class * rt = [_reader smart_ICC_PowerOff];
    [self displayUpRet2: @"ICC_PowerOff " returnValue: rt];
}


-(BOOL) isValidChar:(Byte)byChar{
    if ( ((byChar>(Byte)0x2F) && (byChar<(Byte)0x3A)) //'0' - '9'
        || ((byChar>(Byte)0x40) && (byChar<(Byte)0x47)) //'A' - 'F'
        || ((byChar>(Byte)0x60) && (byChar<(Byte)0x67)) //'a' - 'f'
        )
    {
        return YES;
    }
    return NO;
}

-(NSData*) hexStringToBytes:(NSString*)hexString{
    if (hexString.length<1) {
        return nil;
    }
    
    char tmpCh[2048] = {0};
    int count = 0;
    for (int k=0; k<hexString.length;k++) {
        char c = [hexString characterAtIndex:k];
        if (c == (char)0x20) {
            continue;
        }
        tmpCh[count] = c;
        count++;
    }
    tmpCh[count] = 0;
    
    if (count % 2) {
        return nil;
    }
    
    NSString *temp = [[NSString alloc] initWithUTF8String:tmpCh];
    int m = temp.length % 2;
    if (m>0) {
        return nil;
    }
    
    NSMutableData *result = [[NSMutableData alloc] init];
    unsigned char byte;
    char hexChars[3] = {0};
    for (int i=0; i < (temp.length/2); i++) {
        hexChars[0] = [temp characterAtIndex:i*2];
        hexChars[1] = [temp characterAtIndex:i*2+1];
        
        if (![self isValidChar:hexChars[0]] || ![self isValidChar:hexChars[1]]) {
            return nil;
        }
        byte = strtol(hexChars, NULL, 16);
        [result appendBytes:&byte length:1];
    }
    //[result autorelease];
    //[temp release];
    temp = nil;
    return [NSData dataWithData:result];
}


- (IBAction) f_smart_ExchangeAPDU:(id)sender{
   /* [txtAPDUData resignFirstResponder];
    
    NSData *dataBuffer = nil;
    NSString *valueEntered = txtAPDUData.text;
    if (valueEntered.length < 6)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid"
                                                        message:@"Input APDU data is invalid."
                                                       delegate:nil
                                              cancelButtonTitle:@"Dismiss"
                                              otherButtonTitles:nil];
        [alert show];
        //[alert release];
        alert = nil;
        return;
    }
    else
    {
        dataBuffer = [self hexStringToBytes:valueEntered];
        if (dataBuffer.length<3) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid"
                                                            message:@"Input value is invalid."
                                                           delegate:nil
                                                  cancelButtonTitle:@"Dismiss"
                                                  otherButtonTitles:nil];
            [alert show];
            //[alert release];
            alert = nil;
            return;
        }
    }
    
    RD_class * rt = [reader smart_ExchangeAPDU: dataBuffer];
    [self displayUpRet2: @"ExchangeAPDU " returnValue: rt];
    */
}

- (IBAction) f_smart_ExchangeAPDU_Encrypted:(id)sender{
  /*  [txtAPDUData resignFirstResponder];
    
    NSData *dataBuffer = nil;
    NSString *valueEntered = txtAPDUData.text;
    if (valueEntered.length < 6)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid"
                                                        message:@"Input APDU data is invalid."
                                                       delegate:nil
                                              cancelButtonTitle:@"Dismiss"
                                              otherButtonTitles:nil];
        [alert show];
        //[alert release];
        alert = nil;
        return;
    }
    else
    {
        dataBuffer = [self hexStringToBytes:valueEntered];
        if (dataBuffer.length<3) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid"
                                                            message:@"Input value is invalid."
                                                           delegate:nil
                                                  cancelButtonTitle:@"Dismiss"
                                                  otherButtonTitles:nil];
            [alert show];
            //[alert release];
            alert = nil;
            return;
        }
    }
    
    RD_class * rt = [reader smart_ExchangeAPDU_Encrypted: dataBuffer];
    [self displayUpRet2: @"ExchangeAPDU_Encrypted " returnValue: rt];
    */
}

- (IBAction) f_smart_GetKSN:(id)sender
{
    RD_class * rt = [_reader smart_GetKSN];
    [self displayUpRet2: @"Get KSN " returnValue: rt];
    
}

- (IBAction) f_smart_ExchangeAPDU_DUKPT:(id)sender
{
    /*
    [txtAPDUData resignFirstResponder];
    
    NSData *dataBuffer = nil;
    NSString *valueEntered = txtAPDUData.text;
    if (valueEntered.length < 6)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid"
                                                        message:@"Input APDU data is invalid."
                                                       delegate:nil
                                              cancelButtonTitle:@"Dismiss"
                                              otherButtonTitles:nil];
        [alert show];
        //[alert release];
        alert = nil;
        return;
    }
    else
    {
        dataBuffer = [self hexStringToBytes:valueEntered];
        if (dataBuffer.length<3) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid"
                                                            message:@"Input value is invalid."
                                                           delegate:nil
                                                  cancelButtonTitle:@"Dismiss"
                                                  otherButtonTitles:nil];
            [alert show];
            //[alert release];
            alert = nil;
            return;
        }
    }
    
    RD_class * rt = [reader smart_ExchangeAPDU_DUKPT_Fully: dataBuffer];
    [self displayUpRet2: @"ExchangeAPDU_DUKPT_Fully " returnValue: rt];
    */
}



@end
