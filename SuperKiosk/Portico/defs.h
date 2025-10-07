//
//  defs.h
//  MCDemo
//
//  Created by Romulo Quidilig on 3/17/15.
//  Copyright (c) 2015 Sharecle Inc. All rights reserved.
//

#ifndef MCDemo_defs_h
#define MCDemo_defs_h


#endif

//#define POS_SERVER 0
#define APPLE_MERCHANTID  @"merchant.com.sharecle"

#define CHAT_PHOTO_HEIGHT 44.0
#define CHAT_ATTACHEDIMAGE_HEIGHT 200.0
#define CHAT_SENDERNAME_HEIGHT 21.0


#define CELL_PHOTO_HEIGHT 50
#define CELL_PHOTO_WIDTH 50
#define CELL_IMAGE_HEIGHT 80
#define CELL_IMAGE_WIDTH 80

#define CELL_VERTICAL_SPACE 12

#define CELL_MEDIA_HEIGHT 44
#define CELL_MEDIA_WIDTH 44


#define HEIGHT_OFFSET 16
#define TABLE_CELL_WIDTH 320
#define TABLE_CELL_WIDTH_IPAD 618

//handle null value from json
#define NULL_NIL(_O) _O != [NSNull null] ? _O : nil
#define DICT_GET(_DICT, _KEY) NULL_NIL([_DICT objectForKey:_KEY])
#define DICT_GET_INT(_DICT, _KEY) [DICT_GET(_DICT, _KEY) intValue]
#define DICT_GET_FLOAT(_DICT, _KEY) [DICT_GET(_DICT, _KEY) floatValue]
#define DICT_GET_BOOL(_DICT, _KEY) [DICT_GET(_DICT, _KEY) boolValue]

#define MSG_TYPE_DEF @"00"
#define MSG_TYPE_PAID_ORDER @"03"
#define MSG_TYPE_UNPAID_ORDER @"04"
#define MSG_TYPE_CONNECTED @"01"
#define MSG_TYPE_DISCONNECTED @"02"
#define MSG_TYPE_ANNOUNCE @"05"
#define MSG_TYPE_ANNOUNCE_ONE @"06"

#define MSG_TYPE_REQUEST @"10"
#define MSG_TYPE_RESPONSE @"11"

#define MSG_TYPE_REQUEST_FILE_DOWNLOAD @"12"
#define MSG_TYPE_BROADCAST @"13"
#define MSG_TYPE_REQUEST_SERVERINFO @"14"
#define MSG_TYPE_UPDATE_PEERS @"15"
#define MSG_TYPE_REQUEST_UPDATEINFO @"16"
//#define MSG_TYPE_UPDATE_SINGLE_PEER @"16"
//#define MSG_TYPE_PEER_CONNECTED @"15"
//#define MSG_TYPE_PEER_NOTCONNECTED @"16"


#define MSG_CELLDISPLAY_DEF 0
#define MSG_CELLDISPLAY_NOTIFICATION 1

/*#define STRIPE_TEST_PUBLIC_KEY @"pk_test_U9L4e6hqciFT1nGyluOmKKTu"
#define STRIPE_POST_URL @"https://api.stripe.com/v1/charges"
#define STRIPE_API_KEY @"***REMOVED***"
*/
#define LABEL_NOTREGISTERED @"NOT REGISTERED"
#define LABEL_REGISTERED @"REGISTERED"
#define LABEL_CANCELLED @"CANCELLED"
#define LABEL_DELETED @"DELETED"
#define LABEL_UNKNOWN @"UNKNOWN"
#define LABEL_WAITINGAPPROVAL @"WAITING APPROVAL"
#define LABEL_APPROVED @"APPROVED"
#define LABEL_LIVE @"LIVE"
#define LABEL_TEST @"TEST"
#define LABEL_NOTVISIBLE @"NOT VISIBLE"

#define DEVICE_STATUS_DELETED -2
#define DEVICE_STATUS_CANCELLED -1
#define DEVICE_STATUS_NOTREGISTERED 0
#define DEVICE_STATUS_REGISTERED 1
#define DEVICE_STATUS_WAITINGAPPROVAL 2
#define DEVICE_STATUS_LIVE 3

#define BANK_STATUS_INVALID -3
#define BANK_STATUS_DELETED -2
#define BANK_STATUS_CANCELLED -1
#define BANK_STATUS_NONE 0
#define BANK_STATUS_WAITINGAPPROVAL 1
#define BANK_STATUS_APPROVED 2


#define NOTIFY_SEARCH_RESULT @"SearchResultNotification"
#define NOTIFY_RECEIVED_PAID_ORDER @"MCReceivedPaidOrderNotification"
#define NOTIFY_RECEIVED_UNPAID_ORDER @"MCReceivedUnpaidOrderNotification"
#define NOTIFY_SENT_PAID_ORDER @"MCSendPaidOrderNotification"
#define NOTIFY_SENT_UNPAID_ORDER @"MCSendUnpaidOrderNotification"
#define NOTIFY_UPDATE_HISTORY @"UpdateHistoryNotification"
#define NOTIFY_NEW_ORDER @"NewOrderNotification"

#define NOTIFY_LOCAL_CHARGE @"LocalChargeNotification"
#define NOTIFY_LOCAL_ORDER @"LocalOrderNotification"

#define NOTIFY_UPDATE_MESSAGES_BROADCAST @"UpdateMessagesNotificationBroadcast"
#define NOTIFY_UPDATE_MESSAGES @"UpdateMessagesNotification"
#define NOTIFY_DOWNLOAD_DONE @"DownloadDoneNotification"
#define NOTIFY_UPDATE_PRODUCT_IMAGE @"UpdateProductImageNotification"

#define NOTIFY_CHARGE_SUCCESS_CARD @"ChargeSuccessCardNotification"
#define NOTIFY_CHARGE_SUCCESS_CASH @"ChargeSuccessCashNotification"

#define NOTIFY_CHARGE_FAIL_CARD @"CharegeFailCardNotification"
#define NOTIFY_CHARGE_FAIL_CASH @"CharegeFailCashNotification"

#define NOTIFY_HAS_DATA_TO_SEND @"HasDataToSendNotification"
#define NOTIFY_HAS_DATA_TO_SEND_BROADCAST @"HasDataToSendNotificationBroadcast"

#define NOTIFY_RECEIVE_TEXT_DATA @"MCDidReceiveTextDataNotification"

#define NOTIFY_RECEIVED_MENU @"DidReceivedMenuNotification"
#define NOTIFY_RECEIVED_MENU_UPDATE @"DidReceivedMenuUpdateNotification"
#define NOTIFY_RECEIVED_MENU_SETTINGS @"DidReceivedMenuSettingsNotification"
#define NOTIFY_RECEIVED_SERVERINFO @"DidReceivedServerInfoNotification"

#define NOTIFY_SENT_PAID_ORDER_FROM_SERVER @"SendPaidOrderFromServerNotification"
#define NOTIFY_SENT_UNPAID_ORDER_FROM_SERVER @"SendUnpaidOrderFromServerNotification"

#define NOTIFY_RECEIVED_PEER_PHOTO @"DidReceivedPeerPhoto"
#define NOTIFY_RECEIVED_PEER_BGPHOTO @"DidReceivedPeerBgPhoto"
#define NOTIFY_RECEIVED_PEER_BGPHOTO2 @"DidReceivedPeerBgPhoto2"

#define NOTIFY_SHOW_SENDMESSAGE @"ShowSendeMessage"

#define NOTIFY_CART_CHANGED @"DidCartChanged"

#define NOTIFY_SHOW_PRODUCT @"toProductViewController"
#define NOTIFY_SHOW_PRODUCT_NOSELL @"toProductNoSellViewController"
#define NOTIFY_SHOW_MENU_TABLE @"toOrderMenuTableViewController"
#define NOTIFY_SHOW_MENU_COLLECTION @"toOrderMenuCollectionViewController"
#define NOTIFY_SHOW_MENU_CONNECTIONS @"toConnectionsViewController"

#define NOTIFY_SHOW_MENU_DEFAULT @"default"

#define KEY_SELECTED_INVENTORY @"selectedInventory"
#define KEY_SELECTED_CATEGORY @"selectedCategory"
#define KEY_SELECTED_PRODUCT @"selectedProduct"

#define NOTIFY_BROWSERLOSTPEER @"BROWSERLOSTPEER"
#define NOTIFY_MCDIDCHANGESTATE @"MCDidChangeStateNotification"
#define NOTIFY_MCDIDCHANGESTATE_CONNECTED @"MCDidChangeStateConnected"
#define NOTIFY_MCDIDCHANGESTATE_DISCONNECTED @"MCDidChangeStateDisconnected"

#define REMOTE_NOTIFY_RECEIVED @"RemoteNotification"
#define NOTIFY_APPCONFIG_UPDATE @"AppConfigUpdate"

#define ORDER_SOURCE_REMOTE 1
#define ORDER_SOURCE_LOCAL 2

#define ORDER_STATUS_UNKNOWN 0
#define ORDER_STATUS_START 1
#define ORDER_STATUS_RECEIVED 2
#define ORDER_STATUS_READY 3
#define ORDER_STATUS_CLOSED 4
#define ORDER_STATUS_CANC 5
#define ORDER_STATUS_FAILED 6
#define ORDER_STATUS_REFUND 7
#define ORDER_STATUS_DELETED 10

//#define ORDER_STATUS_PENDING_LABEL @"PENDING"
#define ORDER_STATUS_START_LABEL @"PENDING"
#define ORDER_STATUS_FAILE_LABEL @"FAILED"
#define ORDER_STATUS_RECEIVED_LABEL @"ORDER RECEIVED"
//#define ORDER_STATUS_PAID_LABEL @"PAID"
#define ORDER_STATUS_CLOSED_LABEL @"CLOSED"
#define ORDER_STATUS_READY_LABEL @"READY"
#define ORDER_STATUS_CANC_LABEL @"CANCELLED"
#define ORDER_STATUS_FAILED_LABEL @"FAILED"
#define ORDER_STATUS_UNK_LABEL @""

#define ORDER_STATUS_PAID_LABEL @""
#define ORDER_STATUS_UNPAID_LABEL @""
#define ORDER_STATUS_REFUND_LABEL @"REFUNDED"

#define ORDER_ISPAID_LABEL @"PAID"
#define ORDER_ISNOTPAID_LABEL @"NOT PAID"

//#define ORDER_PAY_TYPE_CCARD @"CARD"
//#define ORDER_PAY_TYPE_CASH @"CASH"

#define ORDER_PAY_STATUS_PENDING 1
#define ORDER_PAY_STATUS_PAID 2
#define ORDER_PAY_STATUS_FAILED 3

#define MENU_ORDER_SET_PAID @"Paid"
#define MENU_ORDER_SET_UNPAID @"Not Paid"
#define MENU_ORDER_SET_READY @"Ready for Pick-up"
#define MENU_ORDER_SET_CLOSED @"Closed"
#define MENU_ORDER_SET_CANC @"Cancel/Refund"
#define MENU_ORDER_SET_DELETED @"Deleted"

#define MENU_ORDER_REFUND @"Refund"
#define MENU_REORDER_TOCART @"Add To Cart"

#define MENU_REORDER_HANDSFREE @"Re-Order (RemotePay Now)"
#define MENU_ORDER_SET_PAYNOW @"Pay Now"
#define MENU_ORDER_SET_REFUND @"Refund"
#define MENU_ORDER_SET_CANCEL @"Cancel"

#define AS_CHOOSE_IMAGE @"Choose"
#define AS_REMOVE_IMAGE @"Remove"

//#define iPad UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad
#define TAB_INDEX_CONNECT 0
#define TAB_INDEX_MENU 0
#define TAB_INDEX_CART 1
#define TAB_INDEX_ORDERS 2
#define TAB_INDEX_CHAT 3


#define FONTSIZE_IPAD 24
#define FONTSIZE_IPHONE 18
/*
#define TAB_INDEX_MENU (iPad?2:1)
#define TAB_INDEX_CART (iPad?3:2)
//#define TAB_INDEX_HISTORY 3
#define TAB_INDEX_INVENTORY (iPad?4:3)
#define TAB_INDEX_FILESHARE (iPad?5:4)
*/




#define KEY_SEND_MESSAGE @"message"
#define KEY_SEND_MESSAGE_TYPE @"type"

#define REPLY_PAYMENT_FAILED @"Sorry your payment did no go through. You may also choose Pay Cash on checkout or see the cashier to complete this transaction."
#define REPLY_STORE_INVALID @"The item(s) in your cart is no longer valid. Please clear your cart and order again. Thanks."


#define KEY_ACTION @"action"

#define KEY_ACTION_CHARGE @"charge" //charge is combo order and pay
#define KEY_ACTION_CANCEL_ORDER @"cancel_order"
//#define KEY_ACTION_CASH @"cash"
#define KEY_ACTION_ORDER @"order"

#define KEY_ACTION_INVENTORY @"inventory"
#define KEY_ACTION_INVENTORY_UPDATE @"inventory_update"
#define KEY_ACTION_INVENTORY_SETTINGS @"inventory_settings"

#define KEY_ACTION_SYNCH_REQUEST @"synch_request"
#define KEY_ACTION_SYNCH_RESPONSE @"synch_response"

#define KEY_ACTION_ALERT @"alert"
#define KEY_ALERT_ID @"id"
#define KEY_ALERT_TEXT @"text"


#define KEY_ACTION_BROADCAST @"broadcast"
#define KEY_BROADCAST_TEXT @"text"
#define KEY_BROADCAST_SENDER @"sender"
#define KEY_BROADCAST_SENDERID @"senderid"

#define KEY_ACTION_PARAM @"actionParam"
#define KEY_ACTION_TYPE @"actionType"
#define KEY_ACTION_TYPE_REQUEST @"request"
#define KEY_ACTION_TYPE_RESPONSE @"response"
#define KEY_ACTION_SERVERINFO @"serverinfo"
//#define KEY_ACTION_INVENTORY_ITEM @"inventory_item"
#define ALERT_NEW_MESSAGE_ARRIVED @"New message has arrived."

#define KEY_CHARGE_ORDER @"order"
#define KEY_ORDER @"order"
#define KEY_CHARGE_CARDINFO @"cardinfo"
/*
#define KEY_MC_ADVERTISE_KIOSK @"sharecle-kiosk"
#define KEY_MC_ADVERTISE_POS @"sharecle-pos"
*/
#define KEY_MC_ADVERTISE_LIVE @"sharecle-live"
#define KEY_MC_ADVERTISE_TEST @"sharecle-test"

#define DEVICEID_LEN 3

#define KEY_APP_DISPLAYNAME @"DisplayName" 
#define KEY_APP_VISIBLE @"Visible"
#define KEY_APP_CCARDS @"CCards"
#define KEY_APP_USERINFO @"UserInfo"


#define PREFIX_MYPHOTO @"myphoto-"
#define PREFIX_MYBGPHOTO @"mybgphoto-"
#define PREFIX_MYBGPHOTO2 @"mybgphoto2-"
#define PREFIX_ATTACHMENT @"attachment-"
#define PREFIX_MENU @"menu-"
#define PREFIX_PRODUCT @"product-"

#define KEY_CCNAME @"ccName"
#define KEY_CCNUMBER @"ccNumber"
#define KEY_CCEXPMONTH @"ccExpMonth"
#define KEY_CCEXPYEAR @"ccExpYear"
#define KEY_CCCVV @"ccCVV"
#define KEY_CCEMAIL @"ccEmail"


#define ORDER_PAY_TYPE_CCARD @"CARD"
#define ORDER_PAY_TYPE_CASH @"CASH"

#define KEY_PAYMENT_TYPE @"type"
#define KEY_AMOUNT @"amount"
#define KEY_CURRENCY @"currency"
#define KEY_CARD4 @"card4"
#define KEY_CHARGE_TOKEN @"token"


#define A_SECRET_PASSWORD @"ljoshleonlukelyda"
#define SECURED 1

#define TAG_CHARGE_SUCCESS 200
#define TAG_CONFIRM_AMOUNT 100
#define ALERT_TAG_ADD_TIP 20
#define ALERT_TAG_ADD_DISCOUNT 21

#define BTN_CONFIRM_AMOUNT_CONTINUE @"Continue"
#define BTN_CONFIRM_AMOUNT_OTHER @"Other"
#define BTN_CASH @"Pay Cash"
#define BTN_CCARD @"Pay Creditcard"
#define BTN_OK @"OK"
#define BTN_CANCEL @"Cancel"
#define BTN_SCAN @"Use scanner"

#define peerIDKey @"peerID"
#define resourceNameKey @"resourceName"
#define localURLKey @"localURL"
#define peerInfoKey @"peerInfo"
#define stateKey @"state"
#define didFinishReceivingResourceNotificationKey @"didFinishReceivingResourceNotification"


#define PEER_GROUP_STAFFS @"Staffs"
#define PEER_GROUP_CUSTOMERS @"Customers"

#define NOTIFY_UPDATE_PEERS @"UpdatePeersNotification"
#define NOTIFY_UPDATE_SERVERINFO @"UpdateServerInfoNotification"

#define TEST_CCARD_NUMBER @"4242424242424242"
#define TEST_CCARD_EXP_YEAR 2030
#define TEST_CCARD_EXP_MONTH 12
#define TEST_CCARD_LAST4 @"4242"
#define TEST_CCARD_CVC @"123"

#define NAME_KEY  @"name"
#define PRODUCTS_KEY @"products"
#define inventoryKey @"inventory"
#define inventoryCfgKey @"inventoryCfg"
#define taxKey @"tax"
#define cartKey @"cart"

#define HISTORY_KEY @"history"
#define MESSAGES_KEY @"messages"
#define ORDERS_KEY @"orders"
#define DAYS_KEY @"days"
#define STORENAME_KEY @"storeName"
//#define STOREID_KEY @"storeId"


#define STORENUM_KEY @"storeNum"

#define device_latKey @"device_lat"
#define device_lngKey @"device_lng"
#define device_storeIDKey @"device_storeID"
#define device_addressKey @"device_address"
#define homeurlKey @"homeurl"
#define autoConnectKey @"autoConnect"

#define itemsArrayKey @"itemsArray"
#define discountsKey @"discounts"

#define isLiveKey @"isLive"
#define deviceNameKey @"deviceName"
#define deviceIDKey @"deviceID"
#define pathKey @"path"
#define dateKey @"date"
#define DeviceIdKey @"DeviceId"
#define ImageLogoUrlKey @"ImageLogoUrl"
#define StoreNameKey @"StoreName"
#define storeIDKey @"storeID"
#define authTypeKey @"authType"
#define homeUrlKey @"homeUrl"
#define ImageLogoUrlKey @"ImageLogoUrl"
#define pictureFileKey @"pictureFile"

#define minChargeAmountKey @"minChargeAmount"
#define maxChargeAmountKey @"maxChargeAmount"
#define maxUnpaidOrdersPerCustomerKey @"maxUnpaidOrdersPerCustomer"
#define allowedDaysToSynchKey @"allowedDaysToSynch"

#define maxMessagesPerUserKey @"maxMessagesPerUser"
#define expireMessageInSecKey @"expireMessageInSec"
#define maxUploadSizeKBKey @"maxUploadSizeKB"

#define refundLevelKey @"refundLevel"
#define remotePayKey @"remotePay"
#define useApplePayKey @"useApplePay"

#define registerPayKey @"registerPay"
#define salesTipKey @"salesTip"
#define salesTaxKey @"salesTax"
#define shippingCostKey @"shippingCost"
//#define deviceIDkey @"deviceID"
//#define deviceNamekey @"deviceName"


//#define MAP_LIVE_URL @"http://www.sharecle.com/superkiosk/map/live"
//#define MAP_TEST_URL @"http://www.sharecle.com/superkiosk/map/test"
#define MAP_URL @"/superkiosk/map"
#define ServerURL @"http://www.superkioskapp.com"
//#define ServerApiURL @"http://192.168.1.112"
#define ServerHomePath @"/superkiosk/home"
#define ServerMapPath @"/superkiosk/map"
#define ServerImagePath @"/superkiosk/images"
#define ServerLogoPath @"/superkiosks/logo"
#define ServerApiPath @"/superkiosk/api"

#define SKSImagePath @"/superkiosks/myimage"
#define SKSImagePathWithStoreID @"/superkiosks/myimagewithstoreid"
//#define SKSURL @"http://www.superkioskapp.com"

//#define ServerApiURL @"http://www.superkioskapp.com"

#define MIN_MESSAGE_HEIGHT 52.0
//#define ENABLE_IAD 1
/*#define SERVER_STATUS_TEST 1
#define SERVER_STATUS_LIVE 2
*/

#define ISECOMMERCE_KEY @"isEcommerce"
#define acceptCashKey @"acceptCash"
#define acceptCCardKey @"acceptCCard"
#define acceptedCardsKey @"acceptedCards"
#define INVENTORYID_KEY  @"inventoryId"
#define featuredProdID_KEY  @"featuredProdID_KEY"
#define currencyKey @"currency"
#define currencySymbolKey @"currencySymbol"
#define categoriesKey @"categories"
#define isActiveKey @"isActive"
#define DEF_CURRENCY @"usd"
#define DEF_CURRENCY_SYMBOL @"$"

#define NOTIFY_SHOW_MENU_PRODUCT @"toProductViewController"
#define NOTIFY_SHOW_MENU_PRODUCT_NOSELL @"toProductNoSellViewController"
//#define NOTIFY_SHOW_MENU_TABLE @"toOrderMenuTableViewController"
//#define NOTIFY_SHOW_MENU_COLLECTION @"toOrderMenuCollectionViewController"

#define NOTIFY_SHOW_ORDERHISTORY @"toOrderHistoryViewController"
#define NOTIFY_SHOW_CHECKOUT @"toCheckoutViewController"
#define NOTIFY_SHOW_SETTINGS @"toAppSettingsViewController"
#define NOTIFY_SHOW_MAP @"toMapViewController"
#define NOTIFY_SHOW_MAP2 @"toMap2ViewController"
#define NOTIFY_SHOW_USERS @"toUsersViewController"
#define NOTIFY_SHOW_CONN @"toConnectionsViewController"
#define NOTIFY_SHOW_MENU @"toOrderViewController"

#define PINVIEWCONTROLLER @"PINViewController"
#define CONNECTIONSVIEWCONTROLLER @"ConnectionsViewController"
#define ORDERCOLLECTIONSVIEWCONTROLLER @"OrderCollectionsViewController"
#define TOUCHIDVIEWCONTROLLER @"TouchIDViewController"

//#define NOTIFY_SYNCH_REQUEST_DONE @"SynchRequestDoneNotification"

#define NOTIFY_SHOW_MYINFOSETTINGS @"toMyInfoSettingsViewController"

//BroadcastMessageAPI
#define SenderKey  @"sender"
#define CreatedonKey  @"createdon"
#define TextKey  @"text"
#define MessageIdKey  @"messageid"
#define UserIdKey  @"userid"
//#define FileUIDKey  @"fileuid"
#define FromDeviceIDKey  @"fromDeviceID"
#define IsServerKey  @"isServer"

#define ColorCodeKey  @"colorCode"
#define ColorCodeGreen  0x4CD964
#define ColorCodeRed  0xFF1300
#define ColorCodeYellow  0xFFCC00
#define ColorCodeDarkGray 0x8E8E93
#define ColorCodeGray 0xC7C7CC
#define ColorCodeBlue 0x007AFF


//#define YOUR_MESSAGE_HERE @"Your message here"
#define YOUR_MESSAGE_HERE @""
#define YOUR_NOTES_HERE @""

#define MAX_CHARS_CHAT 500
#define MAX_CHARS_PRODUCT_NOTE 200

#define TITLE_SETTINGS @"Settings"
#define TITLE_LOCK @"Lock"
#define TITLE_SEARCH @"Search"
#define TITLE_LOGIN @"Login"

#define TITLE_BARCODE @"Barcode"
#define TITLE_LISTVIEW @"List view"
#define TITLE_THUMBVIEW @"Thumb view"
#define TITLE_DISCONNECT @"Forget This Kiosk"

#define STATUS_LOAD_NONE 0
#define STATUS_LOADING 1
#define STATUS_LOADED 2



