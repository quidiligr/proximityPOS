//  UniPay.h
//  UniPay SDK
/* Copyright 2013 ID TECH. All rights reserved. 2013-10-28
*/

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

//Versioning: ARC STD ver
#define UMSDK_VERSION @"1.5.06"
#define UMSDK_CUSTOMIZATION 1


//async task methods return value
//Description               |Applicable task
//                          |Connect|Swipe|Cmd
typedef enum {              //--------------------------+-------+-----+---+------
    RDS_SUCCESS,            //no error, beginning task  | *     | *   | * |
    RDS_FAILED,             //err response or data      | *     | *   | * |
    RDS_NOT_ATTACHED,       //no reader attached        | *     | *   | * |
    RDS_SDK_BUSY,           //SDK is doing another task | *     | *   | * |
    RDS_MONO_AUDIO,         //mono audio is enabled     | *     |     | * |
    RDS_CONNECTED,          //did connection            | *     |     |   |
    RDS_LOW_VOLUME,         //audio volume is too low   | *     |     | * |
    RDS_DISCONNECTED,       //did not do connection     | *     | *   | * |
    RDS_INVALID_PARAMETER,  //wrong parameter           |       |     | * |
    RDS_CANCELED,           //task or CMD be canceled   | *     | *   |   |
    RDS_TIMEDOUT,           //time out for task or CMD  | *     | *   | * |
} RDStatus;

static inline NSString* RDStatus_lookup(RDStatus c) {
#define URLOOK(a) case a: return @#a;
    switch (c) {
            URLOOK(RDS_SUCCESS          )
            URLOOK(RDS_FAILED        )
            URLOOK(RDS_NOT_ATTACHED        )
            URLOOK(RDS_SDK_BUSY         )
            URLOOK(RDS_MONO_AUDIO       )
            URLOOK(RDS_CONNECTED)
            URLOOK(RDS_LOW_VOLUME       )
            URLOOK(RDS_DISCONNECTED    )
            URLOOK(RDS_INVALID_PARAMETER   )
            URLOOK(RDS_CANCELED       )
            URLOOK(RDS_TIMEDOUT  )
        default: return @"<unknown code>";
    }
#undef URLOOK
}

//InjectKeyType
typedef enum {
    DUKPT_KEY_MSR = 0x00,
    DUKPT_KEY_ICC = 0x01,   
    DUKPT_KEY_Admin = 0x10, 
    DUKPT_KEY_Paireing_PinPad = 0x20,
} InjectDUKPTKeyType;


@interface RD_class : NSObject
@property (nonatomic, assign) RDStatus status;
@property (nonatomic, strong) NSData *data;
@end

@protocol UniPay_Delegate;

@interface UniPay : NSObject{
    id<UniPay_Delegate> delegate;
}

@property(nonatomic, assign) id<UniPay_Delegate> delegate;

//version
+(NSString*) SDK_version;

//connect
-(BOOL) cmut_isReaderConnected;
-(void) cmut_StartConnect_Task;
-(void) cmut_CancelConnect_Task;

//commands
-(RD_class*) comn_GetFirmVersion;
-(RD_class*) comn_GetSerialNumber;
-(RD_class*) comn_SetSerialNumber: (NSString*) strSN;
-(RD_class*) comn_GetModelNumber;
-(RD_class*) comn_ResetReader;
-(RD_class*) comn_directIO: (NSData *) dataCMD;

-(RD_class*) smart_GetICC_Status;
-(RD_class*) smart_ICC_PowerOn;
-(RD_class*) smart_ICC_PowerOff;
-(RD_class*) smart_GetEncryptionMode;
-(RD_class*) smart_SetEncryptionMode: (unsigned char) nMode;
-(RD_class*) smart_Get_KeyType_DUKPT;
-(RD_class*) smart_Set_KeyType_DUKPT: (unsigned char) nType;
-(RD_class*) smart_GetAllSetting;
-(RD_class*) smart_SetAllSetting_Default;
-(RD_class*) smart_GetKSN;
-(RD_class*) smart_ExchangeAPDU: (NSData *) dataAPDU;
-(RD_class*) smart_ExchangeAPDU_Encrypted: (NSData *) dataAPDU;
-(RD_class*) smart_ExchangeAPDU_DUKPT_Fully: (NSData *) dataDUKPT_CAPDU;


-(RD_class*) msr_EnableMSR;
-(RD_class*) msr_CancelMSR;
-(RD_class*) msr_GetEncryptionMode;
-(RD_class*) msr_SetEncryptionMode: (unsigned char) nMode;
-(RD_class*) msr_GetSecurityLevel;
-(RD_class*) msr_GetCommonSetting: (unsigned char) nFunctionID;
-(RD_class*) msr_SetCommonSetting: (unsigned char) nFunctionID : (unsigned char) nValue;
-(RD_class*) msr_GetAllSetting;
-(RD_class*) msr_SetAllSetting_Default;


//audio jack communication
//config
-(BOOL) cmut_setCmdTimeoutDuration:(NSInteger) seconds;
-(void) cmut_setAutoAdjustVolume:(BOOL) b;
-(RD_class*) cmut_setVolume: (float) fVolume;

//debug
-(NSString *) comn_GetErrorString: (NSData *) errorCode;
-(NSData *) debug_GetReceivedWave;
// troubleshooting
+(void) enableLogging:(BOOL) enable;

//old API, just for compatibility (below v1.3).
-(RDStatus) msr_StartMSR_Task;
-(void) msr_CancelMSR_Task;

@end

