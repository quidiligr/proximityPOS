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

//#define POS_SERVER 1

//#define LIVE_PAYMENT 0


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

#define MSG_TYPE_DEF @"00"
#define MSG_TYPE_PAID_ORDER @"03"
#define MSG_TYPE_UNPAID_ORDER @"04"
#define MSG_TYPE_CONNECTED @"01"
#define MSG_TYPE_DISCONNECTED @"02"
#define MSG_TYPE_ANNOUNCE @"05"
#define MSG_TYPE_ANNOUNCE_ONE @"06"
#define MSG_TYPE_ALERT @"07"
#define MSG_TYPE_PING @"08"
#define MSG_TYPE_REQUEST @"10"
#define MSG_TYPE_RESPONSE @"11"

#define MSG_TYPE_REQUEST_FILE_DOWNLOAD @"12"
#define MSG_TYPE_BROADCAST @"13"
#define MSG_TYPE_REQUEST_SERVERINFO @"14"
#define MSG_TYPE_REQUEST_UPDATEINFO @"16"
/*
#define MSG_TYPE_PEER_CONNECTED @"15"
#define MSG_TYPE_PEER_NOTCONNECTED @"16"
*/
#define MSG_TYPE_UPDATE_PEERS @"15"

 #define NOTIFY_UPDATE_PEERS @"UpdatePeersNotification"

#define MSG_CELLDISPLAY_DEF 0
#define MSG_CELLDISPLAY_NOTIFICATION 1

/*
#define STRIPE_POST_URL @"https://api.stripe.com/v1/charges"

#define STRIPE_TEST_PUBLIC_KEY @"pk_test_U9L4e6hqciFT1nGyluOmKKTu"
#define STRIPE_PUBLIC_KEY @"pk_test_U9L4e6hqciFT1nGyluOmKKTu"

#define STRIPE_SECRET_KEY @"***REMOVED***"
#define STRIPE_TEST_SECRET_KEY @"***REMOVED***"
*/

#define NOTIFY_RECEIVED_PAID_ORDER @"MCReceivedPaidOrderNotification"
#define NOTIFY_RECEIVED_UNPAID_ORDER @"MCReceivedUnpaidOrderNotification"
//#define NOTIFY_SENT_PAID_ORDER @"MCSendPaidOrderNotification"
//#define NOTIFY_SENT_UNPAID_ORDER @"MCSendUnpaidOrderNotification"
#define NOTIFY_UPDATE_HISTORY @"UpdateHistoryNotification"

#define NOTIFY_RELOAD_CONNECTION_VIEWCONTROLLER @"NotifyReloadConnectionViewController"

#define NOTIFY_LOCAL_CHARGE @"LocalChargeNotification"
#define NOTIFY_LOCAL_ORDER @"LocalOrderNotification"

#define NOTIFY_UPDATE_MESSAGES @"UpdateMessagesNotification"

#define NOTIFY_DIDFINISHDOWNLOAD_UPDATE @"DidFinishDownloadUpdate"

#define NOTIFY_UPDATE_SETTINGS @"UpdateSettingsNotification"
#define NOTIFY_UPDATE_PRODUCTS @"UpdateProductsNotification" 
#define NOTIFY_UPDATE_SERVERINFO @"UpdateServerInfo"
#define NOTIFY_UPDATE_PRODUCT @"UpdateProductNotification"


#define NOTIFY_CHARGE_SUCCESS_CARD @"ChargeSuccessCardNotification"
#define NOTIFY_CHARGE_SUCCESS_CASH @"ChargeSuccessCashNotification"
#define NOTIFY_PRINT_ORDER @"PrintOrderNotification"
#define NOTIFY_PRINTER_SELECTED @"PrinterSelected"
#define NOTIFY_BCPRINTER_SELECTED @"BcPrinterSelected"

#define NOTIFY_CHARGE_FAIL_CARD @"CharegeFailCardNotification"
#define NOTIFY_CHARGE_FAIL_CASH @"CharegeFailCashNotification"
#define NOTIFY_CARD_SWIPED @"NotifyCardSwiped"
#define NOTIFY_CARD_READY_TOSWIPE @"NotifyReadytoSwipe"

#define NOTIFY_CATEGORY_ADDED @"CategoryAdded"
#define NOTIFY_CATEGORY_SAVED @"CategorySaveed"
#define NOTIFY_PRODUCT_ADDED @"ProductAdded"
#define NOTIFY_SHOW_PRODUCTS @"ShowProducts"
#define NOTIFY_SHOW_START_PRODUCT @"ShowStartProduct"
#define NOTIFY_SHOW_EDIT_PRODUCT @"ShowEditProduct"
#define NOTIFY_SHOW_INVENTORY_SETTINGS @"ShowInventorySettings"
#define NOTIFY_SHOW_ADD_PRODUCT @"ShowAddProduct"
#define NOTIFY_SHOW_PRODUCT @"ShowProduct"

#define NOTIFY_ADD_CATEGORY @"AddCategory"
#define NOTIFY_EDIT_CATEGORY @"EditCategory"

#define NOTIFY_VISIBILTY_MODE_CHANGED @"VisibilityModeChanged"

#define KEY_SELECTED_INVENTORY @"selectedInventory"
#define KEY_SELECTED_CATEGORY @"selectedCategory"
#define KEY_SELECTED_PRODUCT @"selectedProduct"

#define NOTIFY_HAS_DATA_TO_SEND @"HasDataToSendNotification"

#define NOTIFY_RECEIVE_TEXT_DATA @"MCDidReceiveTextDataNotification"

#define NOTIFY_RECEIVED_MENU @"DidReceivedMenuNotification"

#define NOTIFY_DEVICE @"DeviceNotification"


//#define NOTIFY_SENT_PAID_ORDER_FROM_SERVER @"SendPaidOrderFromServerNotification"
//#define NOTIFY_SENT_UNPAID_ORDER_FROM_SERVER @"SendUnpaidOrderFromServerNotification"

#define NOTIFY_RECEIVED_PEER_PHOTO @"DidReceivedPeerPhoto"
#define NOTIFY_MCDIDCHANGESTATE @"MCDidChangeState"

#define NOTIFY_MCDIDCHANGESTATE_UPDATE @"MCDidChangeStateUpdate"

#define NOTIFY_APPCONFIG_UPDATE @"AppConfigUpdate"
#define NOTIFY_UPDATE_INVENTORY @"NotifyUpdateInventory" //products and settings
#define NOTIFY_UPDATE_INVENTORY_SETTINGS @"NotifyUpdateInventorySettings" 
//#define NOTIFY_UPDATE_INVENTORY_SETTINGS @"NotifyUpdateInventorySettings" //settings only
//#define NOTIFY_UPDATE_INVENTORY_PRODUCTS @"NotifyUpdateInventoryProducts" //products only
//#define NOTIFY_BROADCAST_UPDATE_INVENTORY @"NotifyBroadcastUpdateInventoryProducts"
//#define NOTIFY_UPDATE_INVENTORY_ACTIVE @"NotifyUpdateInventoryActive"

#define REFUND_NOREFUND @"No Refund"
#define REFUND_ORDER_RECEIVED @"Order Received"
#define REFUND_ORDER_READY @"Order Ready"

#define REFUND_NOREFUND_VAL 0
#define REFUND_ORDER_RECEIVED_VAL 2
#define REFUND_ORDER_READY_VAL 3


#define ORDER_SOURCE_REMOTE 1
#define ORDER_SOURCE_LOCAL 2

#define ORDER_SET_CAPTURED 20

#define ORDER_STATUS_UNKNOWN 0
#define ORDER_STATUS_START 1
#define ORDER_STATUS_RECEIVED 2
#define ORDER_STATUS_READY 3
#define ORDER_STATUS_CLOSED 4
#define ORDER_STATUS_CANC 5
#define ORDER_STATUS_FAILED 6
#define ORDER_STATUS_REFUND 7
//#define ORDER_STATUS_DELETED 10
//#define ORDER_STATUS_DELIVERED 8 //or pickedup delivered

#define ORDER_STATUS_UNKNOWN_LABEL @"UNKNOWN"
#define ORDER_STATUS_START_LABEL @"PENDING"
#define ORDER_STATUS_RECEIVED_LABEL @"ORDER RECEIVED"
#define ORDER_STATUS_READY_LABEL @"READY"
//#define ORDER_STATUS_PAID_LABEL @""
//#define ORDER_STATUS_UNPAID_LABEL @""
#define ORDER_STATUS_CLOSED_LABEL @"CLOSED"
#define ORDER_STATUS_CANC_LABEL @"CANCELLED"
#define ORDER_STATUS_FAILED_LABEL @"FAILED"
#define ORDER_STATUS_REFUND_LABEL @"REFUNDED"
#define ORDER_STATUS_DELETED_LABEL @"DELETED"

#define SEARCH_TYPE_ORDER_NUM @"Order#"
#define SEARCH_TYPE_ORDER_BY @"Order by"
#define SEARCH_TYPE_ORDER_STATUS @"Order status"
#define SEARCH_TYPE_ORDER_DATE @"Order date (yyyy-mm-dd)"
#define SEARCH_TYPE_ORDER_PROD @"Product"

#define SEARCH_TYPE_NONE -1
#define SEARCH_TYPE_ALL 0
#define SEARCH_TYPE_ORDER_NUM_VAL 1
#define SEARCH_TYPE_ORDER_BY_VAL 2
#define SEARCH_TYPE_ORDER_STATUS_VAL 3
#define SEARCH_TYPE_ORDER_DATE_VAL 4
#define SEARCH_TYPE_ORDER_PROD_VAL 5



#define ORDER_ISPAID_LABEL @"PAID"
#define ORDER_ISNOTPAID_LABEL @"NOT PAID"


#define ORDER_PAY_TYPE_CCARD @"CARD"
#define ORDER_PAY_TYPE_CASH @"CASH"

#define KEY_PAYMENT_TYPE @"type"
#define KEY_AMOUNT @"amount"
#define KEY_CURRENCY @"currency"
#define KEY_CARD4 @"card4"
#define KEY_CHARGE_TOKEN @"token"

#define ORDER_PAY_STATUS_PENDING 1
#define ORDER_PAY_STATUS_PAID 2
#define ORDER_PAY_STATUS_FAILED 3




#define MENU_ORDER_SET_PAID @"Paid"
#define MENU_ORDER_SET_UNPAID @"Not Paid"
#define MENU_ORDER_SET_READY @"Ready for Pick-up"
#define MENU_ORDER_SET_CLOSED @"Closed"
#define MENU_ORDER_SET_CANC @"Cancelled"
#define MENU_ORDER_SET_PAYNOW @"Pay Now"
#define MENU_ORDER_SET_REFUND @"Refund"
#define MENU_ORDER_SET_CAPTURE @"Capture"
#define MENU_ORDER_PRINT @"Print"
#define MENU_ORDER_SET_DELETED @"Delete"
#define MENU_ORDER_SET_UNDELETE @"Un-delete"

#define MENU_ORDER_VIEW_PAID @"Paid"
#define MENU_ORDER_VIEW_UNPAID @"Not Paid"
#define MENU_ORDER_VIEW_READY @"Ready for Pick-up"
#define MENU_ORDER_VIEW_CLOSED @"Closed"
#define MENU_ORDER_VIEW_REFUND @"Refunds"
#define MENU_ORDER_VIEW_DELETED @"Deleted"
#define MENU_ORDER_VIEW_CANC @"Cancelled"
#define MENU_ORDER_VIEW_ALL @"All"


#define MAINMENU_ORDERHISTORY_SETTINGS @"Settings"
#define MAINMENU_ORDERHISTORY_REPORTS @"Reports"
#define MAINMENU_ORDERHISTORY_SEARCH @"Search"
#define MAINMENU_ORDERHISTORY_EMPTYTRASH @"Empty Trash"


//#define AS_CHOOSE_IMAGE @"Choose Image"
//#define AS_REMOVE_IMAGE @"Remove Image"
#define AS_CHOOSE_PHOTOLIB @"Choose Photo Library"
#define AS_CHOOSE_CAMERA @"Choose Camera"
#define AS_CHOOSE_REMOVEIMAGE @"Remove Image"

#define AS_ADD_OPTIONITEM @"Add new selection"
#define AS_REMOVE_OPTION @"Remove this option"

/*
#define TAB_INDEX_CONNECT 0
#define TAB_INDEX_CHAT 1
#define TAB_INDEX_MENU 2
#define TAB_INDEX_CART 3

#define TAB_INDEX_ORDERS 4

//#define TAB_INDEX_HISTORY 3
#define TAB_INDEX_INVENTORY 5
#define TAB_INDEX_FILESHARE 6
*/
//#define iPad UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad
//#define TAB_INDEX_CONNECT 2
//#define TAB_INDEX_CHAT 0
/*#define TAB_INDEX_MENU (iPad?1:1)
#define TAB_INDEX_CART (iPad?2:2)
 */
#define TAB_INDEX_MENU 0
#define TAB_INDEX_CART 1

#define TAB_INDEX_ORDERS 2//(iPad?2:3)
#define TAB_INDEX_CHAT 3
//#define TAB_INDEX_INVENTORY 4
#define TAB_INDEX_CONNECT 4
//#define TAB_INDEX_SETTINGS 6
//#define TAB_INDEX_TRASH 5

//#define TAB_INDEX_INVENTORY (iPad?2:2)
/*
 #define TAB_INDEX_MENU (iPad?2:1)
 #define TAB_INDEX_CART (iPad?3:2)
 //#define TAB_INDEX_HISTORY 3
 #define TAB_INDEX_INVENTORY (iPad?4:3)
 #define TAB_INDEX_FILESHARE (iPad?5:4)
 */
#define BADGEUPDATETYPE_SET 0
#define BADGEUPDATETYPE_INCREMENT 1
#define BADGEUPDATETYPE_DECREMENT 2






#define KEY_SEND_MESSAGE @"message"
#define KEY_SEND_MESSAGE_TYPE @"type"
#define KEY_SEND_MESSAGE_TOPEER @"topeer"

#define REPLY_PAYMENT_FAILED @"Sorry your payment did no go through. You may also choose to Pay Cash at the register to complete this transaction."
#define REPLY_STORE_INVALID @"The item(s) in your cart is no longer valid. Please clear your cart and order again. Thanks."


#define KEY_ACTION @"action"

#define KEY_ACTION_CHARGE @"charge" //charge is combo order and pay
#define KEY_ACTION_CANCEL_ORDER @"cancel_order"
#define KEY_ACTION_CONFIRMED @"confirmed"
//#define KEY_ACTION_CASH @"cash"
#define KEY_ACTION_ORDER @"order"

#define KEY_ACTION_INVENTORY @"inventory"


#define KEY_ACTION_SYNCH_REQUEST @"synch_request"
#define KEY_ACTION_SYNCH_RESPONSE @"synch_response"
#define KEY_ACTION_INVENTORY_UPDATE @"inventory_update"
#define KEY_ACTION_INVENTORY_SETTINGS @"inventory_settings"
#define KEY_ACTION_ALERT @"alert"

#define KEY_ACTION_PARAM @"actionParam"
#define KEY_ACTION_TYPE @"actionType"
#define KEY_ACTION_TYPE_REQUEST @"request"
#define KEY_ACTION_TYPE_RESPONSE @"response"
#define KEY_ACTION_SERVERINFO @"serverinfo"

#define ALERT_NEW_MESSAGE_ARRIVED @"New message has arrived."

#define KEY_CHARGE_ORDER @"order"
#define KEY_ORDER @"order"
#define KEY_CHARGE_CARDINFO @"cardinfo"

#define KEY_DEVICETOKEN @"devicetoken"
#define KEY_ALERT_ID @"id"
#define KEY_ALERT_TEXT @"text"
#define KEY_ALERT_PUSHTEXT @"pushtext"

#define KEY_ACTION_BROADCAST @"broadcast"
#define KEY_BROADCAST_TEXT @"text"
#define KEY_BROADCAST_SENDER @"sender"
#define KEY_BROADCAST_SENDERID @"senderid"


//#define KEY_APP_USERINFO @"UserInfo"
#define KEY_APP_DISPLAYNAME @"DisplayName"

#define device_pictureFileKey @"device_pictureFile"
#define device_bgPictureFileKey @"device_bgPictureFile"

#define KEY_APP_DEVICEID @"DeviceId"
#define storeIDKey @"storeID"
#define DeviceIdKey @"DeviceId"
#define TitleKey @"Title"
#define KEY_APP_DEVICENUM @"DeviceNum"

#define KEY_COUNT @"count"
#define KEY_NAME @"name"
#define KEY_TOTAL @"total"
#define KEY_PRODUCTID @"productID"


//#define KEY_APP_DEVICEID @"DeviceLat"
//#define KEY_APP_DEVICEID @"DeviceLng"
//#define KEY_APP_DEVICEID @"DeviceAddress"

//#define KEY_APP_DEVICEID @"DeviceCategory"

#define deviceTokenKey @"deviceToken"
#define userTokenKey @"userToken"
#define passwordKey @"password"
#define pinKey @"pin"
#define usePinKey @"usePin"
#define usernameKey @"usernameKey"
#define displayNameKey @"displayName"
#define homeUrlKey @"homeUrl"

#define currencyKey @"currency"
#define currencySymbolKey @"currencySymbol"
#define welcomeMessageKey @"welcomeMessage"

#define KEY_APP_VISIBLE @"Visible"
#define minChargeAmountKey @"minChargeAmount"
#define maxChargeAmountKey @"maxChargeAmount"
#define maxUnpaidOrdersPerCustomerKey @"maxUnpaidOrdersPerCustomer"
#define cardReaderKey @"cardReader"
#define allowedDaysToSynchKey @"allowedDaysToSynch"
#define currenciesKey @"currencies"
#define currencyKey @"currency"


#define maxMessagesPerUserKey @"maxMessagesPerUser"
#define expireMessageInSecKey @"expireMessageInSec"
#define maxUploadSizeKBKey @"maxUploadSizeKB"

#define refundLevelKey @"refundLevel"

#define acceptPaymentsKey @"acceptPayments"
#define remotePayKey @"remotePay"
#define registerPayKey @"registerPay"

#define salesTipKey @"salesTip"
#define salesTaxKey @"salesTax"
#define shippingCostKey @"shippingCost"
#define isLiveKey @"isLive"
#define deviceIDKey @"deviceID"
#define storeIDKey @"storeID"
//#define device_storeIDKey @"device_storeID"
//#define device_store_idKey @"device_store_id"
#define deviceNumKey @"deviceNum"
#define deviceNameKey @"deviceName"
#define bgPictureFileKey @"bgPictureFile"

#define authTypeKey @"authType"
#define locationKey @"location"

#define bankStatusKey @"bankStatus"
#define bankNameKey @"bankName"
#define bankHolderKey @"bankHolder"
#define bankAcctKey @"bankAcct"
#define bankRoutingKey @"bankRouting"

#define deviceAddressKey @"deviceAddress"
#define devceLatitudeKey @"deviceLatitude"
#define deviceLongitudeKey @"deviceLongitude"



#define phoneKey @"phone"
#define latitudeKey @"latitude"
#define longitudeKey @"longitude"
#define addressKey @"address"
#define currencyKey @"currency"
#define currencySymbolKey @"currencySymbol"
#define versionKey @"version"
#define taxKey @"tax"
#define inventoryKey @"inventory"
//#define inventoryItemKey @"inventory_item"
#define imagesKey @"images"

#define inventoryCfgKey @"inventoryCfg"
#define visibilityKey @"visibility"
#define enableChatKey @"enableChat"

#define enableChatSoundKey @"enableChatSound"
#define enableOrderSoundKey @"enableOrderSound"

#define md5ChecksumKey @"md5Checksum"

#define groupsKey @"groups"
#define usersKey @"users"

#define enableHttpKey @"enableHttp"

#define barcodeAutoAddToCartKey @"barcodeAutoAddToCart"
#define barcodeAutoCloseKey @"barcodeAutoClose"


#define enablePhotoSharingKey @"enablePhotoSharing"
//#define KEY_APP_ONLINE @"Online"

//#define LABEL_ONLINE @"ON-LINE"
//#define LABEL_OFFLINE @"OFF-LINE"
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
#define DEVICE_STATUS_APPROVED 3

#define BANK_STATUS_INVALID -3
#define BANK_STATUS_DELETED -2
#define BANK_STATUS_CANCELLED -1
#define BANK_STATUS_NONE 0
#define BANK_STATUS_WAITINGAPPROVAL 1
#define BANK_STATUS_APPROVED 2

#define SEG_INDEX_OFF 0
#define SEG_INDEX_TEST 1
#define SEG_INDEX_LIVE 2

#define VISIBILITY_NONE 0
#define VISIBILITY_TEST 1
#define VISIBILITY_LIVE 2

#define GROUPID_GUESTS 0
#define GROUPID_REGISTERED 1
#define GROUPID_ADMINISTRATORS 2
#define GROUPID_EMPLOYEES 3
#define GROUPID_FRIENDS 4
#define GROUPID_DOCTORS 11



#define CHAT_PHOTO_HEIGHT 44.0
#define CHAT_ATTACHEDIMAGE_HEIGHT 200.0
#define CHAT_SENDERNAME_HEIGHT 21.0

#define PREFIX_MYPHOTO @"myphoto-"
#define PREFIX_MYBGPHOTO @"mybgphoto-"
#define PREFIX_MYBGPHOTO2 @"mybgphoto2-"
#define PREFIX_ATTACHMENT @"attachment-"
#define PREFIX_PRODUCT @"product-"
#define PREFIX_WELCOMEPHOTO @"welcome-"

//#ifdef DEBUG
    //#define ServerApiURL @"http://192.168.1.112"
#define ServerApiURL @"http://www.superkioskapp.com"
//#else
//    #define ServerApiURL @"http://www.superkioskapp.com"
//#endif

#define ServerApiPath @"/superkiosks/api"
#define ServerUploadProductImagePath @"/superkiosks/fileuploadproductimagefromiosapp"
#define ServerImagePath @"/superkiosks/myimage"
#define LogoPath @"/superkiosks/logo"
#define BackgroundImagePath @"/superkiosks/backgroundimage"

#define DEVICEID_LEN 3

#define ORDER_ERR_PRICE_CHANGED @"PRICE CHANGED" //no match price
#define ORDER_ERR_OPTION_CHANGED @"OPTION CHANGED" //no match price
#define ORDER_ERR_NAME_CHANGED @"NAME CHANGED" //no match name
#define ORDER_ERR_OUT_OF_STOCK @"OUT OF STOCK"
#define ORDER_ERR_QUANTITY_CHANGED @"QUANTITY CHANGED"
#define ORDER_ERR_NOT_FOUND @"NOT FOUND" //no match product id
#define ORDER_ERR_INVALID_STORE @"INVALID STORE" //no match store id
#define ORDER_ERR_PROCESSING @"ERROR PROCESSING" //error processing
#define ORDER_ERR_LIVE_ONLY @"LIVE ONLY"
#define ORDER_ERR_PENDING_UNPAID @"PENDING UNPAID ORDER"

//apple's
#define SOUND_CHAT_RECEIVED 1003 //sms received
#define SOUND_CHAT_SEND 1004
#define SOUND_CHAT_RECEIVED_ALERT 1012 //sms received alert
//my own
#define SOUND_ORDER_RECEIVED 6000
#define SOUND_ORDER_RECEIVED_ALERT 6011

#define A_SECRET_PASSWORD @"ljoshleonlukelyda"
#define SECURED 1

//handle null value from json
#define NULL_NIL(_O) _O != [NSNull null] ? _O : nil
#define DICT_GET(_DICT, _KEY) NULL_NIL([_DICT objectForKey:_KEY])
#define DICT_GET_INT(_DICT, _KEY) [DICT_GET(_DICT, _KEY) intValue]
#define DICT_GET_FLOAT(_DICT, _KEY) [DICT_GET(_DICT, _KEY) floatValue]
#define DICT_GET_BOOL(_DICT, _KEY) [DICT_GET(_DICT, _KEY) boolValue]

//#define PEER_GROUPID_STAFFS 1
//#define PEER_GROUPID_CUSTOMERS 0

#define PEER_GROUP_STAFFS @"Staffs"
#define PEER_GROUP_CUSTOMERS @"Customers"


#define NOTIFY_SHOW_SENDMESSAGE @"ShowSendeMessage"

#define INVENTORYID_KEY  @"inventoryId"
#define NAME_KEY  @"name"
#define pictureFileKey  @"pictureFile" //logo
#define bgPictureFileKey  @"bgPictureFile"
//#define ISECOMMERCE_KEY @"isEcommerce"
#define isEcommerceKey @"isEcommerce"
#define authTypeKey @"authType"
#define acceptCashKey @"acceptCash"
#define acceptCCardKey @"acceptCCard"
#define acceptedCardsKey @"acceptedCards"
/*
#define CURRENCY_KEY  @"currency"
#define CURRENCY_SYMBOL_KEY  @"currencySymbol"
 */
//#define TAX_KEY  @"tax"
#define DISCOUNT_KEY  @"discount"

#define DETAIL_KEY  @"detail"

//#define IMAGE_KEY  @"image"
#define CATEGORYID_KEY @"categoryID"
#define categoryIDKey @"categoryID"
#define useClientTokenKey @"useClientToken"
#define providerKey @"provider"
#define postUrlKey @"postUrl"
#define publishableKeyKey @"publishableKey"
#define testPublishableKeyKey @"testPublishableKey"

#define secretKeyKey @"secretKey"
#define testSecretKeyKey @"testSecretKey"

#define CATEGORYUID_KEY @"categoryUID"
#define SORTNUMBER_KEY @"sortNumber"

#define productsKey @"products"

#define categoriesKey @"categories"
#define isActiveKey @"isActive"

#define  allOptionsKey @"allOptions"
#define  allOptionItemsKey @"allOptionItems"
#define  optionsKey @"options"
#define  productOptionsKey @"productOptions"

#define DEF_MAX_UPLOAD_SIZEKB 1000 //1mb
#define DEF_MESSAGE_EXPIRESEC 0 //no expire
#define DEF_MESSAGES_PERUSER 0//no limit
/*
#define SERVER_STATUS_TEST 1
#define SERVER_STATUS_LIVE 2
 */

#define MINIMUM_USERNAME_LEN 8

#define kLoadingCellTag 120
#define kLoadingCellPageUpTag 400
#define MAX_ROWS 100 //rows
#define ROWS_PER_PAGE 25
#define SCROLL_UP 1
#define SCROLL_DOWN 0
#define SCROLL_NONE 2
#define ERROR_MSG_PROCESSING @"There was an error processing your request. Please try again later."

#define DEF_CURRENCY @"usd"
#define DEF_CURRENCY_SYMBOL @"$"
#define DEF_SALES_TAX 9
#define DEF_MAX_CHARGE 5000
#define DEF_MIN_CHARGE 100

//#define DISCOUNT_NONE 0
#define DISCOUNT_PCT 0
#define DISCOUNT_VAL 1

#define READER_CAMERA 0
#define READER_SWIPE 1


#define FONTSIZE_IPAD 24

#define NOTIFY_SHOW_MENU_PRODUCT @"toProductViewController"
//#define NOTIFY_SHOW_PRODUCT_NOSELL @"toShowProductNoSellViewController"
#define NOTIFY_SHOW_MENU_TABLE @"toOrderMenuTableViewController"
#define NOTIFY_SHOW_MENU_COLLECTION @"toOrderMenuCollectionViewController"
#define NOTIFY_SHOW_INVENTORY_LIST @"toInventoryListViewController"


#define NOTIFY_SHOW_ORDERDAYS @"toOrderDaysViewController"
#define NOTIFY_SHOW_ORDERHISTORY @"toOrderHistoryViewController"
#define NOTIFY_SHOW_CHECKOUT @"toCheckoutViewController"
#define NOTIFY_SHOW_SETTINGS @"toAppSettingsViewController"
#define NOTIFY_SHOW_USERS @"toUsersViewController"
#define NOTIFY_SHOW_CONN @"toConnectionsViewController"
#define NOTIFY_SHOW_MENU @"toMenuViewController"

#define NOTIFY_SHOW_MYINFOSETTINGS @"toMyInfoSettingsViewController"


#define NOTIFY_UPDATEBADGE_ORDERS @"UpdateBadgeOrders"

#define ColorCodeKey  @"colorCode"
#define ColorCodeGreen  0x4CD964
#define ColorCodeRed  0xFF1300
#define ColorCodeYellow  0xFFCC00
#define ColorCodeDarkGray 0x8E8E93
#define ColorCodeGray 0xC7C7CC
#define ColorCodeBlue 0x007AFF

#define MODE_OFF 2
#define MODE_TEST 1
#define MODE_LIVE 0

#define MAX_CHARS_CHAT 500
#define MAX_CHARS_PRODUCT_NOTE 200

#define YOUR_MESSAGE_HERE @"Your message here"
#define YOUR_NOTES_HERE @"Your notes here."

#define BTN_OK @"OK"
#define BTN_CANCEL @"Cancel"
#define BTN_SCAN @"Use scanner"

#define MSG_SELECTPRODUCT @"Select an item to modify."
#define MSG_NOPRODUCT @"You haven't created an item for %@. Tap + to create your first item."


#define MSG_SELECTCATEGORY @"Select a category to modify."
#define MSG_NOCATEGORY @"You haven't created any category. Tap + to create your first category."

#define HOURS_24 @"24 hrs"
#define HOURS_48 @"48 hrs"
#define HOURS_96 @"96 hrs"
#define HOURS_SPECIFY @"Specify"

#define TITLE_INVENTORY @"Inventory"
#define TITLE_SETTINGS @"Settings"
#define TITLE_LOCK @"Lock"
#define TITLE_SEARCH @"Search"
#define TITLE_BARCODE @"Barcode"
#define TITLE_LISTVIEW @"List view"
#define TITLE_THUMBVIEW @"Thumb view"

#define SOURCE_CHAT 1
#define SOURCE_ORDERS 2





//#define MAGTEK