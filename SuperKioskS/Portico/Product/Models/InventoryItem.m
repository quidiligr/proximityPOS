//
//  IODOrder.m
//  iOSDiner
//
//  Created by Romulo Quidilig on 3/19/15.
//  Copyright (c) 2015 Sharecle Inc. All rights reserved.
//

#import "InventoryItem.h"
#import "Product.h"
#import "ProductCategory.h"
#import "NSData+Conversion.h"
#import "AppConfigModel.h"
#import "Util.h"
#import "defs.h"

@implementation InventoryItem
//@synthesize products;


- (id)init {
    self = [super init];
    if (self) {
        //Custom initialization
        //self.productsArray = [[NSMutableArray alloc] init];
         //_inventoryModel = [[InventoryModel alloc] init];
      //  self.products=[NSMutableArray new];
       // self.categories=[NSMutableArray new];
    }
    return self;
}

- (id)initWithCoder:(NSCoder*)decoder
{
    if ((self = [super init]))
    {
        self.authType= [decoder decodeIntegerForKey:authTypeKey];
        self.inventoryId = [decoder decodeObjectForKey:INVENTORYID_KEY];
        self.name = [decoder decodeObjectForKey:NAME_KEY];
        self.isEcommerce = [decoder decodeBoolForKey:isEcommerceKey];
        self.acceptCCard = [decoder decodeBoolForKey:acceptCCardKey];
        self.acceptCash = [decoder decodeBoolForKey:acceptCashKey];
        
        self.salesTax = [decoder decodeDoubleForKey:salesTaxKey];
        self.salesTip = [decoder decodeDoubleForKey:salesTipKey];
        
        self.currency= [decoder decodeObjectForKey:currencyKey];
        self.currencySymbol= [decoder decodeObjectForKey:currencySymbolKey];
        if(!self.currency){
            self.currency=DEF_CURRENCY;
            self.currencySymbol=DEF_CURRENCY_SYMBOL;
        }
        
        self.minChargeAmount= [decoder decodeIntegerForKey:minChargeAmountKey];
        self.maxChargeAmount= [decoder decodeIntegerForKey:maxChargeAmountKey];
        
        self.maxUnpaidOrdersPerCustomer=[decoder decodeIntegerForKey:maxUnpaidOrdersPerCustomerKey];
        
        
        
        self.refundLevel=[decoder decodeIntegerForKey:refundLevelKey];
        if(self.refundLevel>ORDER_STATUS_READY)
            self.refundLevel=ORDER_STATUS_READY;
        
        //self.cardReader=[decoder decodeIntegerForKey:cardReaderKey];
        self.allowedDaysToSynch=[decoder decodeIntegerForKey:allowedDaysToSynchKey];
      
        //self.isActive= [decoder decodeBoolForKey:isActiveKey];
        self.categories=[decoder decodeObjectForKey:categoriesKey];
        if(self.categories==nil)
            _categories=[NSMutableArray new];
        self.products= [decoder decodeObjectForKey:productsKey];
            if(_products==nil)
                _products=[NSMutableArray new];
            
        
    }
    return self;
}


- (void)encodeWithCoder:(NSCoder*)encoder
{
    [encoder encodeInteger:self.authType forKey:authTypeKey];
    
    [encoder encodeObject:self.inventoryId forKey:INVENTORYID_KEY];
    [encoder encodeObject:self.name forKey:NAME_KEY];
    
    [encoder encodeBool:self.isEcommerce forKey:isEcommerceKey];
    [encoder encodeBool:self.acceptCash forKey:acceptCashKey];
    [encoder encodeBool:self.acceptCCard forKey:acceptCCardKey];
    
    [encoder encodeFloat:self.salesTax forKey:salesTaxKey];
    [encoder encodeFloat:self.salesTip forKey:salesTipKey];
    
    [encoder encodeObject:self.currency forKey:currencyKey];
    [encoder encodeObject:self.currencySymbol forKey:currencySymbolKey];
    if(!self.currency){
        self.currency=DEF_CURRENCY;
        self.currencySymbol=DEF_CURRENCY_SYMBOL;
    }
    
   
    [encoder encodeInteger:self.minChargeAmount forKey:minChargeAmountKey];
    [encoder encodeInteger:self.maxChargeAmount forKey:maxChargeAmountKey];
    [encoder encodeInteger:self.maxUnpaidOrdersPerCustomer forKey:maxUnpaidOrdersPerCustomerKey];
    
    if(self.refundLevel>ORDER_STATUS_READY)
        self.refundLevel=ORDER_STATUS_READY;
    [encoder encodeInteger:self.refundLevel forKey:refundLevelKey];
    
   //[encoder encodeInteger:self.cardReader forKey:cardReaderKey];
    [encoder encodeInteger:self.allowedDaysToSynch forKey:allowedDaysToSynchKey];
    
   // [encoder encodeBool:self.isActive forKey:isActiveKey];
    [encoder encodeObject:self.categories forKey:categoriesKey];
    [encoder encodeObject:self.products forKey:productsKey];
}


/*
-(void)loadDefaultCategory{
   
}
 */



- (ProductCategory *)addCategory:(NSString*)categoryName imageName:(NSString *)imageFile detail:(NSString *)detail{
    
   // NSDictionary *inventory =[self.inventories valueForKey:inventoryName];
    
    //NSMutableArray *categories=[inventory valueForKey:CATEGORIES_KEY];
    
   // NSPredicate *predicate=[NSPredicate predicateWithFormat:@"name=%@",categoryName];
    
    
    categoryName=[categoryName stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" "]];
    
    if(categoryName.length==0)
        return nil;
    if(self.categories==nil)
        self.categories=[NSMutableArray new];
    
    NSArray *names=[self.categories valueForKey:NAME_KEY];
    
    
    //NSPredicate *predicate=[NSPredicate predicateWithFormat:@"name=%@",categoryName];
    //NSArray *search=[self.categories filteredArrayUsingPredicate:predicate];
    if([names containsObject:categoryName]) //duped
        return nil;
    
    InventoryModel *model=[InventoryModel sharedInstance];
    NSSortDescriptor *valueDescriptors=[[NSSortDescriptor alloc] initWithKey:@"sortNumber" ascending:YES];
    //NSArray *descriptors=[NSArray arrayWithObject:valueDescriptors];
    
    
    NSArray *sortedArray=[self.categories sortedArrayUsingDescriptors:[NSArray arrayWithObject:valueDescriptors]];
    
   // NSUInteger newSortNumber=[sortedArray count];
    
    if([sortedArray count]>0)
    {
        ProductCategory *last=[sortedArray lastObject];
        if(last.sortNumber!=[sortedArray count]-1){
            //re-number
            for (NSUInteger i=0; i<[sortedArray count]; i++) {
                ((ProductCategory *)sortedArray[i]).sortNumber=i;
            }
            
           // [model saveInventory];
            
           // sortedArray=[self.categories sortedArrayUsingDescriptors:descriptors];
            
        }
        
        
        
    }
    
    ProductCategory *newCategory=[ProductCategory new];
    
    newCategory.name=categoryName;
    newCategory.pictureFile=imageFile;
    newCategory.sortNumber=self.categories.count;
    newCategory.detail=detail;
    
    ProductCategory *last_cat=[self.categories lastObject];
        //ProductCategory *new_cat=[ProductCategory new];
        //new_cat.name=name;
    if(last_cat==nil)
        newCategory.categoryID=1;
    else
        newCategory.categoryID=last_cat.categoryID+1;
    [self.categories addObject:newCategory];
  //  return newCategory;
    [model saveInventory];
    return newCategory;
    
}

//- (Product *)addProduct:(NSString*)name  categoryId:(NSUInteger)categoryId price:(float)price imageName:(NSString *)imageFile detail:(NSString *)detail remaining:(NSInteger)remaining unlimited:(BOOL)unlimited{
//- (Product *)addProduct:(NSString*)name  categoryId:(NSUInteger)categoryId price:(NSInteger)price discount:(double)discount imageName:(NSString *)imageFile detail:(NSString *)detail remaining:(NSInteger)remaining unlimited:(BOOL)unlimited{


/*
- (Product *)addProduct:(NSString*)name  categoryId:(NSUInteger)categoryId price:(NSInteger)price actualPrice:(NSInteger)actualPrice discount:(double)discount discountType:(NSUInteger)discountType imageName:(NSString *)imageFile detail:(NSString *)detail remaining:(NSInteger)remaining unlimited:(BOOL)unlimited{

    
   
    if(self.products==nil)
        self.products=[NSMutableArray new];
    
   
    
    InventoryModel *model=[InventoryModel sharedInstance];
    NSSortDescriptor *valueDescriptors=[[NSSortDescriptor alloc] initWithKey:@"sortNumber" ascending:YES];
    //NSArray *descriptors=[NSArray arrayWithObject:valueDescriptors];
    
    NSPredicate* predicate=[NSPredicate predicateWithFormat:@"categoryID=%i",categoryId];
    
    NSArray *sortedArray=[[self.products filteredArrayUsingPredicate:predicate] sortedArrayUsingDescriptors:[NSArray arrayWithObject:valueDescriptors]];
    
    // NSUInteger newSortNumber=[sortedArray count];
    
    Product *lastProd;
    NSUInteger lastSortNum=0;
    if([sortedArray count]>0)
    {
        lastProd=[sortedArray lastObject];
        lastSortNum=lastProd.sortNumber;
        
        
        
    }
    
    lastSortNum++;
    
    
    
    Product *newProduct=[Product new];
    
    newProduct.name=name;
    //newProduct.barcode=
    newProduct.pictureFile=imageFile;
    newProduct.sortNumber=lastSortNum;//self.categories.count;
    newProduct.detail=detail;
    newProduct.categoryID=categoryId;
    
    newProduct.price=price;
    newProduct.actualPrice=actualPrice;
    newProduct.discount=discount;
    newProduct.stock_unlimited=unlimited;
    //if(unlimited)
    //    newProduct.instock=0;
    //else
        newProduct.instock=remaining;
    
    lastProd=[self.products lastObject];
    
    newProduct.productID=lastProd.productID+1;
    //newProduct.product
    [self.products addObject:newProduct];
    
    [model saveInventory];
    return newProduct;
    
}
 */

//if  saved id==0 or nextid already exist then we do this:
-(void)getLastProductID{
    NSSortDescriptor *valueDescriptors=[[NSSortDescriptor alloc] initWithKey:@"productID" ascending:YES];
    //NSArray *descriptors=[NSArray arrayWithObject:valueDescriptors];
    
   // NSPredicate* predicate=[NSPredicate predicateWithFormat:@"categoryID=%i",categoryID];
    
    NSArray *sortedArray=[self.products sortedArrayUsingDescriptors:[NSArray arrayWithObject:valueDescriptors]];
    if([sortedArray count]==0)
        self.lastProductID= 0;
    
    Product *last=[sortedArray lastObject];
    
    self.lastProductID= last.productID;
    
    
}

-(NSString *)getNewProductUID{
    NSString *result=nil;
    for(int i=0;i<100;i++){ //try 100
        NSString *tmp=[[[NSUUID UUID] UUIDString] lowercaseString];
        NSPredicate* predicate=[NSPredicate predicateWithFormat:@"productUID=%i",tmp];
        NSArray *arr=[self.products filteredArrayUsingPredicate:predicate];
        if([arr count]==0){
            result=tmp;
            break;
        }
    }
    return result;
    
}

- (BOOL)addProduct:(Product *)product
                        /*categoryId:(NSUInteger)categoryId price:(NSInteger)price actualPrice:(NSInteger)actualPrice discount:(double)discount discountType:(NSUInteger)discountType imageName:(NSString *)imageFile detail:(NSString *)detail remaining:(NSInteger)remaining unlimited:(BOOL)unlimited
                         */
                         {
    
    
    
    //categoryName=[categoryName stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" "]];
    
    //if(categoryName.length==0)
    //  return nil;
    if(self.products==nil)
        return NO;
        //self.products=[NSMutableArray new];
    
    /*
     NSArray *names=[self.products valueForKey:NAME_KEY];
     
     
     if([names containsObject:name]) //duped
     return nil;
     */
    
    InventoryModel *model=[InventoryModel sharedInstance];
    NSSortDescriptor *valueDescriptors=[[NSSortDescriptor alloc] initWithKey:@"sortNumber" ascending:YES];
    //NSArray *descriptors=[NSArray arrayWithObject:valueDescriptors];
    
    NSPredicate* predicate=[NSPredicate predicateWithFormat:@"categoryID=%i",product.categoryID];
    
    NSArray *sortedArray=[[self.products filteredArrayUsingPredicate:predicate] sortedArrayUsingDescriptors:[NSArray arrayWithObject:valueDescriptors]];
    
    // NSUInteger newSortNumber=[sortedArray count];
    
    Product *lastProd;
    NSUInteger lastSortNum=0;
    //NSUInteger lastProductID=0;
    if([sortedArray count]>0)
    {
        lastProd=[sortedArray lastObject];
        lastSortNum=lastProd.sortNumber;
        //lastProductID=lastProd.productID;
        /*if(lastProd.sortNumber!=[sortedArray count]-1){
         //re-number
         for (NSUInteger i=0; i<[sortedArray count]; i++) {
         ((Product *)sortedArray[i]).sortNumber=i;
         }
         
         // [model saveInventory];
         
         // sortedArray=[self.categories sortedArrayUsingDescriptors:descriptors];
         
         }
         */
        
        
    }
    
    lastSortNum++;
    //lastProductID++;
    
    
    /*Product *newProduct=[Product new];
    
    newProduct.name=product.name;
    newProduct.barcode=product.barcode;
    newProduct.pictureFile=product.pictureFile;
    newProduct.sortNumber=lastSortNum;//self.categories.count;
    newProduct.detail=product.detail;
    newProduct.shortDesc=product.shortDesc;
    newProduct.categoryID=product.categoryID;
    
    newProduct.price=product.price;
    newProduct.actualPrice=product.actualPrice;
    newProduct.discount=product.discount;
    newProduct.stock_unlimited=product.stock_unlimited;
    
    //if(unlimited)
    //    newProduct.instock=0;
    //else
    newProduct.instock=product.instock;
    
    lastProd=[self.products lastObject];
    
    newProduct.productID=lastProd.productID+1;
    */
                             
     product.productUID=[self getNewProductUID];
     if(product.productUID==nil)
         return NO;
                             
     if(self.lastProductID==0)
         [self getLastProductID];
     
     product.productID=self.lastProductID+1;
    self.lastProductID=product.productID;
    
                             
    [self.products addObject:product];
    
    [model saveInventory];
    
                             if(product.publishedInternet && product.pictureFile!=nil && product.pictureFile.length>0){
                                 [product uploadImage];
                             }
    
    //return newProduct;
                             return YES;
}


-(NSArray *)allProductsWithCategoryID:(NSUInteger)categoryID sorted:(BOOL)sorted {
    NSPredicate* predicate=[NSPredicate predicateWithFormat:@"categoryID=%i",categoryID];
    NSArray *resultArray=[self.products filteredArrayUsingPredicate:predicate];
    if(sorted){
        NSSortDescriptor *descriptor=[[NSSortDescriptor alloc] initWithKey:@"sortNumber" ascending:YES];
        return [resultArray sortedArrayUsingDescriptors:[NSArray arrayWithObject:descriptor]];
    }
    else{
        return resultArray;
    }
    
}
/*
- (NSDictionary *)toMenuDictionary__:(AppConfigModel *)appConfig storeId:(NSString *)storeId storeName:(NSString *)storeName{
     NSSortDescriptor *valueDescriptors=[[NSSortDescriptor alloc] initWithKey:@"sortNumber" ascending:YES];
   
 
    
    NSMutableArray *inventory=[NSMutableArray new];
    
   
    
    NSArray *sorted_categories=[self.categories sortedArrayUsingDescriptors:[NSArray arrayWithObject:valueDescriptors]];
    for (ProductCategory *item in sorted_categories) {
        item.sortedProducts=[self allProductsWithCategoryID:item.categoryID sorted:YES];
            if(item.sortedProducts!=nil && [item.sortedProducts count]>0){
                
                NSMutableDictionary *cat_dictionary=[[item toNSDictionary] mutableCopy];
                
                NSMutableArray *category_products_dict=[NSMutableArray new];
                for(Product *prod in item.sortedProducts  ){
                    
                    [category_products_dict addObject:[prod toNSDictionary]];
                }
                
                [cat_dictionary setValue:category_products_dict forKey:PRODUCTS_KEY];
            
                
                [inventory addObject:cat_dictionary ];
            }
        
    }
    
   
    NSDictionary *inventoryCfg=@{
                                 NAME_KEY:self.name,
                                 ISECOMMERCE_KEY:@(self.isEcommerce),
                                 currencyKey:self.currency,
                                 currencySymbolKey:self.currencySymbol,
                                 salesTaxKey:@(self.salesTax),
                                 salesTipKey:@(self.salesTip),
                                 maxChargeAmountKey:@(self.maxChargeAmount),
                                 minChargeAmountKey:@(self.minChargeAmount),
                                 refundLevelKey:@(self.refundLevel),
                                 acceptCashKey:@(self.acceptCash),
                                 acceptCCardKey:@(self.acceptCCard),
                                 deviceIDKey:storeId,
                                 deviceNameKey:storeName
                                 };
   
  
    NSDictionary *menu_dict=@{inventoryKey:inventory,inventoryCfgKey:inventoryCfg};
    return menu_dict;


}
*/

//- (NSDictionary *)toMenuDictionary:(AppConfigModel *)appConfig storeId:(NSString *)storeId storeName:(NSString *)storeName{
- (NSDictionary *)toMenuDictionary:(AppConfigModel *)appConfig{

    
    NSMutableArray *all_products=[NSMutableArray new];
     NSMutableArray *all_cats=[NSMutableArray new];
    
    for (ProductCategory *item in self.categories) {
        if(item.publishedLocal || item.publishedInternet){
        //if(item.publishedLocal){
            item.sortedProducts=[[self allProductsWithCategoryID:item.categoryID sorted:YES] mutableCopy];
            if(item.sortedProducts!=nil && [item.sortedProducts count]>0){
                [all_cats addObject:[item toNSDictionary]];
                for(Product *prod in item.sortedProducts  ){
                    //if(prod.publishedLocal){
                    if(prod.publishedLocal || prod.publishedInternet){
                        [all_products addObject:[prod toNSDictionary]];
                    }
                }
                
            }
        }
        
    }
    /*
    for(Product *prod in self.products  ){
        //if(prod.publishedLocal){
        if(prod.publishedLocal || prod.publishedInternet){
            [all_products addObject:[prod toNSDictionary]];
        }
    }
     */
    
    NSDictionary *inventory_dict=@{categoriesKey:all_cats,productsKey:all_products};
    NSDictionary *inventoryCfg_dict=@{
                                      INVENTORYID_KEY:self.inventoryId,
                                 //NAME_KEY:self.name,
                                 isEcommerceKey:@(self.isEcommerce),
                                 currencyKey:self.currency,
                                 currencySymbolKey:self.currencySymbol,
                                 salesTaxKey:@(self.salesTax),
                                 salesTipKey:@(self.salesTip),
                                 maxChargeAmountKey:@(self.maxChargeAmount),
                                 minChargeAmountKey:@(self.minChargeAmount),
                                 refundLevelKey:@(self.refundLevel),
                                 acceptCashKey:@(self.acceptCash),
                                 acceptCCardKey:@(self.acceptCCard),
                                      //storeIDKey:appConfig.storeID,
                                 deviceIDKey:appConfig.device_id,
                                      
                                 deviceNameKey:appConfig.device_name
                                 };
    
    
    NSDictionary *menu_dict=@{inventoryKey:inventory_dict,inventoryCfgKey:inventoryCfg_dict};
    return menu_dict;
    
    
}

- (NSDictionary *)toDictionaryExport{
    
//NSSortDescriptor *valueDescriptors=[[NSSortDescriptor alloc] initWithKey:@"sortNumber" ascending:YES];
    
    //NSDictionary *inventory_dict;//=[NSMutableDictionary new];
    
    NSMutableArray *allProducts=[NSMutableArray new];
    
    //cats
    NSMutableArray *allCategories=[NSMutableArray new];
    
  //  NSArray *sorted_categories=[self.categories sortedArrayUsingDescriptors:[NSArray arrayWithObject:valueDescriptors]];
    for (ProductCategory *item in _categories) {
        /*if(isMenu){
            if(item.publishedInternet || item.publishedLocal){
                [allCategories addObject:[item toNSDictionary]];
                for(Product *prod in item.sortedProducts  ){
                    if(prod.publishedInternet || prod.publishedLocal){
                        [allProducts addObject:[prod toNSDictionary]];
                    }
                }
            }
        }
        else{*/
            [allCategories addObject:[item toNSDictionary]];
            /*for(Product *prod in item.sortedProducts  ){
                
                [allProducts addObject:[prod toNSDictionary]];
           }
             */
        //}
       
    }
    
    for(Product *prod in _products  ){
        
        [allProducts addObject:[prod toNSDictionary]];
    }

    
    AppDelegate *_appDelegate=ApplicationDelegate;
    
    NSDictionary *inventory_dict=@{
                  INVENTORYID_KEY:self.inventoryId,
                  categoriesKey:allCategories,
                  productsKey:allProducts,
                  isEcommerceKey:@(self.isEcommerce),
                  currencyKey:self.currency,
                  currencySymbolKey:self.currencySymbol,
                  salesTaxKey:@(self.salesTax),
                  salesTipKey:@(self.salesTip),
                  maxChargeAmountKey:@(self.maxChargeAmount),
                  minChargeAmountKey:@(self.minChargeAmount),
                  refundLevelKey:@(self.refundLevel),
                  deviceIDKey:_appDelegate.appConfig.device_id,
                  storeIDKey:_appDelegate.appConfig.storeID,
                  deviceNameKey:_appDelegate.appConfig.device_name,
                  deviceNumKey:@(_appDelegate.appConfig.device_num),
                  deviceTokenKey:_appDelegate.appConfig.device_token,
                  phoneKey:(_appDelegate.appConfig.device_phone==nil)?@"":_appDelegate.appConfig.device_phone,
                  latitudeKey:@(_appDelegate.appConfig.device_lat),
                  longitudeKey:@(_appDelegate.appConfig.device_lng),
                  addressKey:(_appDelegate.appConfig.device_address==nil)?@"":_appDelegate.appConfig.device_address
                  
                  };

    
    
    return inventory_dict;//menu_dict;
    
    
}

//- (NSString *)toJSonStringWithUserToken{
    
//}

- (NSString *)toJSonString{
    
    NSDictionary *device_dict= [self toDictionary];
    NSString *json=[Util toJsonString:device_dict];
    
    
    
    return json;//menu_dict;
    
    
}

- (NSDictionary *)toDictionary{
    
    AppDelegate *_appDelegate=ApplicationDelegate;
    
    NSSortDescriptor *valueDescriptors=[[NSSortDescriptor alloc] initWithKey:@"sortNumber" ascending:YES];
    
    NSDictionary *device_dict;//=[NSMutableDictionary new];
    
    NSMutableArray *allProducts=[NSMutableArray new];
    
    //cats
    NSMutableArray *allCategories=[NSMutableArray new];
    
    NSArray *sorted_categories=[self.categories sortedArrayUsingDescriptors:[NSArray arrayWithObject:valueDescriptors]];
    for (ProductCategory *item in sorted_categories) {
        [allCategories addObject:[item toNSDictionary]];
        for(Product *prod in item.sortedProducts  ){
            
            [allProducts addObject:[prod toNSDictionary]];
        }
        
    }
    
    //prods
    
    device_dict=@{
                  INVENTORYID_KEY:self.inventoryId,
                  categoriesKey:allCategories,
                  productsKey:allProducts,
                  isEcommerceKey:@(self.isEcommerce),
                  currencyKey:self.currency,
                  currencySymbolKey:self.currencySymbol,
                  salesTaxKey:@(self.salesTax),
                  salesTipKey:@(self.salesTip),
                  maxChargeAmountKey:@(self.maxChargeAmount),
                  minChargeAmountKey:@(self.minChargeAmount),
                  refundLevelKey:@(self.refundLevel),
                  deviceIDKey:_appDelegate.appConfig.device_id,
                  storeIDKey:_appDelegate.appConfig.storeID,
                  deviceNameKey:_appDelegate.appConfig.device_name,
                  deviceNumKey:@(_appDelegate.appConfig.device_num),
                  deviceTokenKey:_appDelegate.appConfig.device_token,
                  phoneKey:(_appDelegate.appConfig.device_phone==nil)?@"":_appDelegate.appConfig.device_phone,
                  latitudeKey:@(_appDelegate.appConfig.device_lat),
                  longitudeKey:@(_appDelegate.appConfig.device_lng),
                  addressKey:(_appDelegate.appConfig.device_address==nil)?@"":_appDelegate.appConfig.device_address
                  
                  };
    
    //NSString *json=[Util toJsonString:device_dict];
    
    
    
    return device_dict;//menu_dict;
    
    
}

//same as toDictionaryExportInventory but targets user
//we will only include categories/products whose publishinternet is true
- (NSDictionary *)toDictionaryExportMenu{
    
    NSSortDescriptor *valueDescriptors=[[NSSortDescriptor alloc] initWithKey:@"sortNumber" ascending:YES];
    
    NSDictionary *inventory_dict;//=[NSMutableDictionary new];
    
    NSMutableArray *allProducts=[NSMutableArray new];
    
    //cats
    NSMutableArray *allCategories=[NSMutableArray new];
    
    NSArray *sorted_categories=[self.categories sortedArrayUsingDescriptors:[NSArray arrayWithObject:valueDescriptors]];
    for (ProductCategory *item in sorted_categories) {
        [allCategories addObject:[item toNSDictionary]];
        //item.sortedProducts=[self allProductsWithCategoryID:item.categoryID sorted:YES];
        //if(item.sortedProducts!=nil && [item.sortedProducts count]>0){
        
        //NSMutableArray *category_products_dict=[NSMutableArray new];
        for(Product *prod in item.sortedProducts  ){
            
            [allProducts addObject:[prod toNSDictionary]];
        }
        // [allProducts addObject:category_products_dict];
        
        
        //[dictionary setValue:category_products_dict forKey:PRODUCTS_KEY];
        
        
        
        //}
        //}
    }
    
    //prods
    
    inventory_dict=@{
                     NAME_KEY:self.name,
                     categoriesKey:allCategories,
                     productsKey:allProducts,
                     isEcommerceKey:@(self.isEcommerce),
                     currenciesKey:self.currency,
                     currencySymbolKey:self.currencySymbol,
                     salesTaxKey:@(self.salesTax),
                     salesTipKey:@(self.salesTip),
                     maxChargeAmountKey:@(self.maxChargeAmount),
                     minChargeAmountKey:@(self.minChargeAmount),
                     refundLevelKey:@(self.refundLevel)
                     
                     };
    
    
    return inventory_dict;//menu_dict;
    
    
}

+(InventoryItem *)fromDictionaryExport:(NSDictionary *)dict{
    InventoryItem *result=[InventoryItem new];
    
   
    result.name=[dict valueForKey:NAME_KEY];
    result.salesTax=[[dict valueForKey:salesTaxKey] doubleValue];
    
   
    
    result.categories=[NSMutableArray new];
    for (NSDictionary *item in [dict valueForKey:categoriesKey] ) {
        [result.categories addObject:[ProductCategory fromDictionary:item]];
    }
    
    result.products=[NSMutableArray new];
    for (NSDictionary *item in [dict valueForKey:productsKey] ) {
        [result.products addObject:[Product fromDictionary:item]];
    }
    
    return result;
}

-(void)importFromDictionary:(NSDictionary *)dict{
    //InventoryItem *result=[InventoryItem new];
    
    
    //result.name=[dict valueForKey:NAME_KEY];
    //self.salesTax=[[dict valueForKey:salesTaxKey] doubleValue];
    NSPredicate *p;
    NSArray *arr;
    
    if(self.categories==nil)
        self.categories=[NSMutableArray new];
    
    
    for (NSDictionary *item in [dict valueForKey:categoriesKey] ) {
        ProductCategory *catImport=[ProductCategory fromDictionary:item];
        p=[NSPredicate predicateWithFormat:@"categoryUID=%@",catImport.categoryUID];
        arr=[self.categories filteredArrayUsingPredicate:p];
        
        if([_categories count]==0){
            [self.categories addObject:catImport];
            continue;
        }
        
        if([arr count]>0){
            ProductCategory *catExisitng=[arr firstObject];
            catExisitng.name=catImport.name;
            catExisitng.detail=catImport.detail;
            catExisitng.pictureFile=catImport.pictureFile;
            catExisitng.publishedLocal=catImport.publishedLocal;
            catExisitng.publishedInternet=catImport.publishedInternet;
            
            
        }
        else{
            [self.categories addObject:catImport];
        }
    }
    
    if(_products==nil)
        self.products=[NSMutableArray new];
        
    for (NSDictionary *item in [dict valueForKey:productsKey] ) {
        Product *prodImport=[Product fromDictionary:item];
        if([_products count]==0){
           [self.products addObject:prodImport];
            continue;
        }
        
        p=[NSPredicate predicateWithFormat:@"productUID=%@",prodImport.productUID];
        arr=[self.products filteredArrayUsingPredicate:p];
        if([arr count]>0){
            Product *prodExisting=[arr firstObject];
            prodExisting.name=prodImport.name;
            prodExisting.detail=prodImport.detail;
            prodExisting.pictureFile=prodImport.pictureFile;
            prodExisting.publishedLocal=prodImport.publishedLocal;
            prodExisting.publishedInternet=prodImport.publishedInternet;
            
            
            
        }
        else{
            [_products addObject:prodImport];
        }
            
        
        //[self.products addObject:[Product fromDictionary:item]];
    }
    
   
}

-(void)updateFromPullInventory:(NSDictionary *)dict{
    AppDelegate *_appDelegate=ApplicationDelegate;
    
    NSString *inventoryId=DICT_GET(dict,INVENTORYID_KEY);
    if(inventoryId)
        self.inventoryId=inventoryId;
    
    self.authType=DICT_GET_INT(dict,authTypeKey);
    self.isEcommerce=DICT_GET_BOOL(dict,isEcommerceKey);
    self.currency=DICT_GET(dict,currencyKey);
    self.currency=[self.currency lowercaseString];
    self.currencySymbol=DICT_GET(dict,currencySymbolKey);
    self.salesTax=DICT_GET_FLOAT(dict,salesTaxKey);
    self.salesTip=DICT_GET_FLOAT(dict,salesTipKey);
    
    self.maxChargeAmount=DICT_GET_INT(dict,maxChargeAmountKey);
    self.minChargeAmount=DICT_GET_INT(dict,minChargeAmountKey);
    self.maxUnpaidOrdersPerCustomer=DICT_GET_INT(dict,maxUnpaidOrdersPerCustomerKey);
    
    self.refundLevel=DICT_GET_INT(dict,refundLevelKey);
    
    self.acceptCash=DICT_GET_BOOL(dict,acceptCashKey);
    
    self.acceptCCard=DICT_GET_BOOL(dict,acceptCCardKey);
    self.acceptedCards=DICT_GET(dict,acceptedCardsKey);
    
    
    _appDelegate.appConfig.device_pictureFile=DICT_GET(dict,pictureFileKey);
    if(_appDelegate.appConfig.device_pictureFile){
        [_appDelegate.appConfig downloadLogoImage];
    }
    
    _appDelegate.appConfig.device_bgPictureFile=DICT_GET(dict,bgPictureFileKey);
    if(_appDelegate.appConfig.device_bgPictureFile){
        [_appDelegate.appConfig downloadBackgroundImage];
    }
    
    if(self.categories==nil)
        self.categories=[NSMutableArray new];
    else
        [self.categories removeAllObjects];
    
    if(self.products==nil)
        self.products=[NSMutableArray new];
    else
        [self.products removeAllObjects];
    /*
    if(self.optionItems==nil)
        self.optionItems=[NSMutableArray new];
    [self.optionItems removeAllObjects];
    
    if(self.options==nil)
        self.options=[NSMutableArray new];
    [self.options removeAllObjects];
    */
    for (NSDictionary *item in [dict valueForKey:categoriesKey] ) {
        ProductCategory *catImport=[ProductCategory fromDictionary:item];
        /*p=[NSPredicate predicateWithFormat:@"categoryUID=%@",catImport.categoryUID];
        arr=[self.categories filteredArrayUsingPredicate:p];
        
        if([_categories count]==0){
            [self.categories addObject:catImport];
            continue;
        }
        
        if([arr count]>0){
            ProductCategory *catExisitng=[arr firstObject];
            catExisitng.name=catImport.name;
            catExisitng.detail=catImport.detail;
            catExisitng.pictureFile=catImport.pictureFile;
            catExisitng.publishedLocal=catImport.publishedLocal;
            catExisitng.publishedInternet=catImport.publishedInternet;
            
            
        }
        else{
         */
            [self.categories addObject:catImport];
        //}
    }
    
    /*
    
    for (NSDictionary *item in [dict valueForKey:allOptionItemsKey] ) {
        
        ProductOptionItem *poi=[[ProductOptionItem alloc] initWithDictionary:item];
        
        [self.optionItems addObject:poi];
        
    }

    
    for (NSDictionary *item in [dict valueForKey:allOptionsKey] ) {
        ProductOption *po=[[ProductOption alloc] initWithDictionary:item];
        if(po.selections==nil)
            po.selections=[NSMutableArray new];
        
        NSPredicate *predicate=[NSPredicate predicateWithFormat:@"parentUID==%@",po.UID];
        NSArray *arr= [self.products filteredArrayUsingPredicate:predicate];
        if([arr count]>0){
            //ProductOptionItem *poi=[arr firstObject];
            
            [po.selections addObjectsFromArray:arr];
        }
        
        [self.options addObject:po];
        
    }
*/
    
    
    for (NSDictionary *item in [dict valueForKey:productsKey] ) {
        Product *prod=[Product fromDictionary:item];
        if(prod.options==nil)
            prod.options=[NSMutableArray new];
        /*
        NSPredicate *predicate=[NSPredicate predicateWithFormat:@"productUID==%@",prod.productUID];
        NSArray *arr= [self.products filteredArrayUsingPredicate:predicate];
        if([arr count]>0){
            //ProductOptionItem *poi=[arr firstObject];
            
            [prod.options addObjectsFromArray:arr];
        }
        */
        
        //if([_products count]==0){
            [self.products addObject:prod];
        /*    continue;
        }
        
        p=[NSPredicate predicateWithFormat:@"productUID=%@",prodImport.productUID];
        arr=[self.products filteredArrayUsingPredicate:p];
        if([arr count]>0){
            Product *prodExisting=[arr firstObject];
            */
            /*
            prodExisting.name=prodImport.name;
            prodExisting.detail=prodImport.detail;
            prodExisting.pictureFile=prodImport.pictureFile;
            prodExisting.publishedLocal=prodImport.publishedLocal;
            prodExisting.publishedInternet=prodImport.publishedInternet;
            prodExisting.price=prodImport.price;
            prodExisting.actualPrice=prodImport.actualPrice;
            prodExisting.discount=prodImport.discount;
            prodExisting.discountType=prodImport.discountType;
            
            if((prodExisting.pictureFile.length>0) && ![prodExisting.pictureFile isEqualToString:prodImport.pictureFile])
            {
                [prodExisting removeImage];
             */
                if(prod.pictureFile.length>0)
                    [prod downloadImage];
            //}
            //[_products removeObject:prodExisting];
            //[_products addObject:prodImport];
            
            
        /*}
        else{
            [_products addObject:prodImport];
            if(prodImport.pictureFile.length>0)
                [prodImport downloadImage];
        }
        */
        
        
        //[self.products addObject:[Product fromDictionary:item]];
    }
    
        /*
    for (NSDictionary *item in [dict valueForKey:allOptionItemsKey] ) {
        ProductOptionItem *poi=[[ProductOptionItem alloc] initWithDictionary:item];
        //for (NSDictionary *item in [dict valueForKey:productOptionsKey] ) {
        
        //}
        //if(poi.selections==nil)
          //  poi.selections=[NSMutableArray new];
        
        NSPredicate *predicate=[NSPredicate predicateWithFormat:@"parentUID==%@",poi.parentUID];
        NSArray *arr= [self.products filteredArrayUsingPredicate:predicate];
        if([arr count]>0){
            Product *prod=[arr firstObject];
            
            [prod.options addObject:po];
        }
        
        [self.options addObject:po];
        
    }
*/
    /*
    self.inventoryId=DICT_GET(dict,INVENTORYID_KEY);
    
    AppDelegate *_appDelegate=ApplicationDelegate;
    
    //_appDelegate.appConfig.isLive=DICT_GET_BOOL(dict,isLiveKey);
    _appDelegate.appConfig.useClientToken=DICT_GET_BOOL(dict,@"useClientToken");
    _appDelegate.appConfig.paymentPublishableKey=DICT_GET(dict,@"paymentPublishableKey");
    _appDelegate.appConfig.paymentPublishableKeyTest=DICT_GET(dict,@"paymentPublishableKeyTest");
    
    //_appDelegate.appConfig.currency=DICT_GET(param_dict,currencyKey);
     //_appDelegate.appConfig.currencySymbol=DICT_GET(param_dict,currencySymbolKey);
    
    _appDelegate.appConfig.device_lat=[DICT_GET(dict,@"device_lat") floatValue];
    _appDelegate.appConfig.device_lng=[DICT_GET(dict,@"device_lng") floatValue];
    _appDelegate.appConfig.device_address=DICT_GET(dict,@"device_address");
    _appDelegate.appConfig.device_num=DICT_GET_INT(dict,@"device_num");
    //_appDelegate.appConfig.device_ssid=DICT_GET(dict,@"device_ssid");
    
    
    
    //_appDelegate.appConfig.salesTax=DICT_GET_FLOAT(param_dict,@"tax");
    //_appDelegate.appConfig.acceptCash=DICT_GET_BOOL(param_dict,@"acceptCash");
    // _appDelegate.appConfig.acceptCCard=DICT_GET_BOOL(param_dict,@"acceptCCard");
    // _appDelegate.appConfig.useApplePay=DICT_GET_BOOL(param_dict,@"useApplePay");
    
    _appDelegate.appConfig.enableChat=DICT_GET_BOOL(dict,@"enableChat");
    _appDelegate.appConfig.enablePhotoSharing=DICT_GET_BOOL(dict,@"enablePhotoSharing");
    _appDelegate.appConfig.maxUploadSizeKB=DICT_GET_INT(dict,maxUploadSizeKBKey);
    _appDelegate.appConfig.expireMessageInSec=DICT_GET_INT(dict,expireMessageInSecKey);
    _appDelegate.appConfig.maxMessagesPerUser=DICT_GET_INT(dict,maxMessagesPerUserKey);
*/
    
    
}

-(Product *)searchProduct:(NSUInteger)productID {
    Product *result=nil;
    //InventoryModel *model=[InventoryModel sharedInstance];
    //serch active menu first
    
    //NSSortDescriptor *descriptor=[[NSSortDescriptor alloc] initWithKey:ISACTIVE_KEY ascending:NO];
    
    NSPredicate* predicate;
    //NSArray *sortedArray=[model.inventories sortedArrayUsingDescriptors:[NSArray arrayWithObject:descriptor]];
    //for(InventoryItem *inv in sortedArray){
        //for (ProductCategory *c in self.categories) {
        
        predicate = [NSPredicate predicateWithFormat:@"productID=%@",@(productID)];
        
        NSArray* results = [self.products filteredArrayUsingPredicate:predicate];
        
        if(results !=nil && [results count]>0)//{
            return [results firstObject];
        //}
        // else
        //     return nil;
        //}
        
    //}
    
    return result;
    
    
}

-(NSArray *)searchProducts:(NSString *)keywords {
    keywords=[keywords stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"*"]];
    keywords=[keywords stringByAppendingString:@"*"];
    
    
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"name LIKE[c] %@",keywords];
    
    NSArray *results=nil;
    
        results = [self.products filteredArrayUsingPredicate:predicate];
        
    
    return results;
    
    
}

-(NSArray *)searchProductsWithBarcode:(NSString *)barcode {
    barcode=[barcode stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" "]];
    
    
    
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"barcode == %@",barcode];
    
    NSArray *results=nil;
    
    results = [self.products filteredArrayUsingPredicate:predicate];
    
    
    return results;
    
    
}


-(ProductCategory *)searchCategoryWithID:(NSUInteger)categoryID {
    ProductCategory *result=nil;
    
    
    NSPredicate* predicate;
    
    
    predicate = [NSPredicate predicateWithFormat:@"categoryID=%@",@(categoryID)];
    
    NSArray* results = [self.categories filteredArrayUsingPredicate:predicate];
    
    if(results !=nil && [results count]>0)//{
        return [results firstObject];
    
    
    return result;
    
    
}

-(void)pushInventory:(NSString *)json
{
    
    
    AppDelegate *_appDelegate=ApplicationDelegate;
    
    MBProgressHUD* hud = [MBProgressHUD showHUDAddedTo:_appDelegate.window.rootViewController.view animated:YES];
    hud.labelText = NSLocalizedString(@"Loading", nil);
    
    NSError *error;
    NSString *p1=[NSString stringWithFormat:@"usertoken=%@&storeid=%@&deviceid=%@&menuid=%@"
                  ,_appDelegate.appConfig.user_userToken
                  ,_appDelegate.appConfig.storeID
                  ,_appDelegate.appConfig.device_id
                  ,@(_appDelegate.appConfig.device_menuid)
                  ];
    
    
    NSData *data1 = [p1 dataUsingEncoding:NSUTF8StringEncoding];
    NSData *encryptedData1 = [RNEncryptor encryptData:data1
                                         withSettings:kRNCryptorAES256Settings
                                             password:A_SECRET_PASSWORD
                                                error:&error];
    NSString *base64Encoded1=[encryptedData1 base64EncodedStringWithOptions:0];//[NSString
    
    
    if(error!=nil){
#ifdef DEBUG
        NSLog(@"encryptData error=%@",[error localizedDescription]);
#endif
        [MBProgressHUD hideHUDForView:_appDelegate.window.rootViewController.view animated:YES];
        [AppDelegate toast:[error localizedDescription] duration:2.0];
        return;
    }
    
    
    //NSError *error;
    
    NSData *data2 = [json dataUsingEncoding:NSUTF8StringEncoding];
    NSData *encryptedData2 = [RNEncryptor encryptData:data2
                                         withSettings:kRNCryptorAES256Settings
                                             password:A_SECRET_PASSWORD
                                                error:&error];
    NSString *base64Encoded2=[encryptedData2 base64EncodedStringWithOptions:0];//[NSString
    
    
    if(error!=nil){
#ifdef DEBUG
        NSLog(@"encryptData error=%@",[error localizedDescription]);
#endif
        [MBProgressHUD hideHUDForView:_appDelegate.window.rootViewController.view animated:YES];
        [AppDelegate toast:[error localizedDescription] duration:2.0];
        return;
    }
    
   
    NSDictionary *params = @{@"cmd":@"301",
                             //@"user_id":[_dataModel userId],
                             @"p1": base64Encoded1,
                             @"p2":base64Encoded2
                             };
    
    AFHTTPClient *_client=[Util clientSharedInstance];
    
    [_client postPath:ServerApiPath//@"/portico/api"
           parameters:params
              success:^(AFHTTPRequestOperation *operation, id responseObject) {
                  
                  
                  
                  //if ([self isViewLoaded]) {
                  [MBProgressHUD hideHUDForView:_appDelegate.window.rootViewController.view animated:YES];
                  if([operation.response statusCode] != 200) {
                      [AppDelegate ShowErrorAlert:NSLocalizedString(@"There was an error communicating with the server", nil)];
                  } else {
                      
                      //NSLog(operation.responseString);
                      
                      NSError* error;
                      NSDictionary* json=[NSJSONSerialization JSONObjectWithData:operation.responseData options:kNilOptions error:&error];
                      //NSDictionary* VLDirectory=[json objectForKey:@"VLDirectory"];
                      NSNumber* success=[json objectForKey:@"success"];
                      if([success intValue]==1){
                          
                          NSDictionary *dict=[json objectForKey:@"result"];
                          
                          
#ifdef DEBUG
                          NSLog(@"postLoginRequest: %@",dict);
#endif
                          
                          
                          //start uploading images if any
                          for(Product *prod in  _products){
                              if(prod.pictureFile.length>0){
                                  [prod uploadImage];
                              }
                          }
                          
                          
                      }
                      else{
                          
                          NSString* error=DICT_GET(json,@"error");
                          //int error_code=DICT_GET_INT(json,@"error_code");
                          
                          
                          if(error){
                              
                              [AppDelegate toast:error duration:2.0];
                              
                          }
                          else{
                              [AppDelegate toast:@"Unknown error." duration:2.0];
                          }
                          
                          
                          
                      }
                      
                  }
                  //}
              } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                  //if ([self isViewLoaded]) {
                  [MBProgressHUD hideHUDForView:_appDelegate.window.rootViewController.view animated:YES];
                  [AppDelegate ShowErrorAlert:[error localizedDescription]];
                  //}
              }];
}


- (void)pullInventory
{
    AppDelegate *_appDelegate=ApplicationDelegate;
    MBProgressHUD* hud = [MBProgressHUD showHUDAddedTo:_appDelegate.window.rootViewController.view animated:YES];
    hud.labelText = NSLocalizedString(@"Loading", nil);
    
    NSError *error;
    
    NSString *p=[NSString stringWithFormat:@"usertoken=%@&storeid=%@&deviceid=%@&menuid=%@"
                  ,_appDelegate.appConfig.user_userToken
                  ,_appDelegate.appConfig.storeID
                  ,_appDelegate.appConfig.device_id
                  ,@(_appDelegate.appConfig.device_menuid)
                  ];

     
     
     NSData *data = [p dataUsingEncoding:NSUTF8StringEncoding];
     NSData *encryptedData = [RNEncryptor encryptData:data
     withSettings:kRNCryptorAES256Settings
     password:A_SECRET_PASSWORD
     error:&error];
     NSString *base64Encoded=[encryptedData base64EncodedStringWithOptions:0];//[NSString
     
     
     if(error!=nil){
         #ifdef DEBUG
         NSLog(@"encryptData error=%@",[error localizedDescription]);
         #endif
         [MBProgressHUD hideHUDForView:_appDelegate.window.rootViewController.view animated:YES];
         [AppDelegate toast:[error localizedDescription] duration:2.0];
         return;
     }
    
    
    
    
    /*NSDictionary *params = @{@"cmd":@"100",
     //@"user_id":[_dataModel userId],
     @"deviceid": _appDelegate.userInfo.deviceID,
     @"username":_nicknameTextField.text,
     @"password":_secretCodeTextField.text//_dataModel.userInfo.password
     };
     */
    NSDictionary *params = @{@"cmd":@"302",
                             //@"user_id":[_dataModel userId],
                             @"p": base64Encoded
                             };
    
    AFHTTPClient *_client=[Util clientSharedInstance];
    
    [_client postPath:ServerApiPath//@"/portico/api"
           parameters:params
              success:^(AFHTTPRequestOperation *operation, id responseObject) {
                  
                  
                  
                  //if ([self isViewLoaded]) {
                  [MBProgressHUD hideHUDForView:_appDelegate.window.rootViewController.view animated:YES];
                  if([operation.response statusCode] != 200) {
                      [AppDelegate ShowErrorAlert:NSLocalizedString(@"There was an error communicating with the server", nil)];
                  } else {
                      
                      //NSLog(operation.responseString);
                      
                      NSError* error;
                      NSDictionary* json=[NSJSONSerialization JSONObjectWithData:operation.responseData options:kNilOptions error:&error];
                      //NSDictionary* VLDirectory=[json objectForKey:@"VLDirectory"];
                      NSNumber* success=[json objectForKey:@"success"];
                      if([success intValue]==1){
                          //_attempts=0;
                          
                          
                           NSString *base64String=[json objectForKey:@"result"];
                           
                           #ifdef DEBUG
                           NSLog(@"base64String=%@",base64String);
                           #endif
                           NSData *base64Data=[[NSData alloc] initWithBase64EncodedString:base64String options:0];
                           
                           //NSError *error;
                           NSData *decryptedData = [RNDecryptor decryptData:base64Data
                           withPassword:A_SECRET_PASSWORD
                           error:&error];
                           
                           if(error!=nil){
                           #ifdef DEBUG
                           NSLog(@"encryptData error=%@",[error localizedDescription]);
                           #endif
                           return;
                           }
                           
                           
                           
                           NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:decryptedData options:NSJSONReadingMutableContainers error:&error];
                          
                          //NSDictionary *dict=[json objectForKey:@"result"];
                          
                          
#ifdef DEBUG
                          NSLog(@"postLoginRequest: %@",dict);
#endif
                          
                          [_appDelegate.inventoryModel.inventory updateFromPullInventory:dict];
                          [_appDelegate.inventoryModel saveInventory];
                          
                          [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_UPDATE_INVENTORY object:nil];
                          
                          [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_UPDATE_INVENTORY_SETTINGS object:nil userInfo:@{KEY_SELECTED_INVENTORY:_appDelegate.inventoryModel.inventory}];
                          //[_appDelegate loggedInSuccessWithInfo:dict];
                          
                          
                      }
                      else{
                          
                          NSString* error=DICT_GET(json,@"error");
                          //int error_code=DICT_GET_INT(json,@"error_code");
                          
                          
                          if(error){
                              
                              [AppDelegate toast:error duration:2.0];
                              
                          }
                          else{
                              [AppDelegate toast:@"Unknown error." duration:2.0];
                          }
                          
                          
                          
                      }
                      
                  }
                  //}
              } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                  //if ([self isViewLoaded]) {
                  [MBProgressHUD hideHUDForView:_appDelegate.window.rootViewController.view animated:YES];
                  [AppDelegate ShowErrorAlert:[error localizedDescription]];
                  //}
              }];
}


-(BOOL)isEqual:(id)object {
    if (![object isKindOfClass:[InventoryItem class]]) {
        return NO;
    }
    
    InventoryItem *other = (InventoryItem *)object;
    //return [other.deviceToken isEqualToString:self.deviceToken];
    //bool result=[other.peerID isEqual:self.peerID] || [other.peerID.displayName isEqualToString:self.peerID.displayName];
    
    bool result=([other.inventoryId isEqualToString:self.inventoryId]);
    
    return result;
}



@end
