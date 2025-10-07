//
//  IODItem.m
//  iOSDiner
//
//  Created by Romulo Quidilig on 3/19/15.
//  Copyright (c) 2015 Sharecle Inc. All rights reserved.
//

#import "Product.h"
#import "Util.h"
#import "NSData+MD5.h"
#import "defs_order_product.h"
//#define kInventoryAddress @"http://kiosk.sharecle.com/inventory/"
/*static NSString* const NameKey = @"Name";
static NSString* const PriceKey = @"Price";
static NSString* const ImageKey = @"Image";
static NSString* const CategoryIDKey = @"CategoryID";
static NSString* const CategoryNameKey = @"CategoryName";
static NSString* const ProductIDKey = @"ProductID";
static NSString* const ProductNumberKey = @"ProductNumber";
static NSString* const DetailKey = @"Detail";
static NSString* const InStockKey = @"InStock";
static NSString* const SoldKey = @"Sold";
static NSString* const MaxQuantityKey = @"MaxQuantity";
static NSString* const MinQuantityKey = @"MinQuantity";
*/
//static NSString* const MaxCountKey = @"MaxCount";
//static NSString* const RemainingKey = @"Remaining";

@implementation Product

- (id)initWithCoder:(NSCoder*)decoder
{
    if ((self = [super init]))
    {
        self.name = [decoder decodeObjectForKey:NameKey];
        self.barcode = [decoder decodeObjectForKey:BarcodeKey];
        self.shortDesc = [decoder decodeObjectForKey:shortDescKey];
        self.detail = [decoder decodeObjectForKey:DetailKey];
        self.price =  [decoder decodeIntegerForKey:PriceKey];
        self.actualPrice =  [decoder decodeIntegerForKey:ActualPriceKey];
        if (self.price>self.actualPrice) {
            self.price=self.actualPrice;
        }
        
        self.discount =  [decoder decodeDoubleForKey:DiscountKey];
        self.discountType =  [decoder decodeIntegerForKey:DiscountTypeKey];
        
        self.pictureFile = [decoder decodeObjectForKey:pictureFileKey];
        self.categoryID=[decoder decodeIntegerForKey:CategoryIDKey];
      //  self.categoryName=[decoder decodeObjectForKey:CategoryNameKey];
        //self.productNumber=[decoder decodeIntForKey:ProductNumberKey];
        self.sortNumber=[decoder decodeIntegerForKey:SortNumberKey];
        
        self.productID=[decoder decodeIntegerForKey:ProductIDKey];
        self.productUID=[decoder decodeObjectForKey:ProductUIDKey];
        
        self.instock=[decoder decodeIntegerForKey:InStockKey];
        self.sold=[decoder decodeIntegerForKey:SoldKey];
        self.maxQuantity=[decoder decodeIntForKey:MaxQuantityKey];
        self.minQuantity=[decoder decodeIntegerForKey:MinQuantityKey];
        
        self.allowOutOfStock=[decoder decodeBoolForKey:allowOutOfStockKey];
        
        self.publishedLocal=[decoder decodeBoolForKey:PublishedLocalKey];
        self.publishedInternet=[decoder decodeBoolForKey:PublishedInternetKey];
        self.options=[decoder decodeObjectForKey:optionsKey];

    }
    return self;
}


- (void)encodeWithCoder:(NSCoder*)encoder
{
    [encoder encodeInteger:self.productID forKey:ProductIDKey];
    [encoder encodeObject:self.productUID forKey:ProductUIDKey];
    //[encoder encodeInteger:self.productNumber forKey:ProductNumberKey];
    [encoder encodeInteger:self.sortNumber forKey:SortNumberKey];
    [encoder encodeObject:self.name forKey:NameKey];
    [encoder encodeObject:self.barcode forKey:BarcodeKey];
    [encoder encodeObject:self.detail forKey:DetailKey];
    [encoder encodeObject:self.shortDesc forKey:shortDescKey];
    
    if (self.price>self.actualPrice) {
        self.price=self.actualPrice;
    }
    [encoder encodeInteger:self.price forKey:PriceKey];
    [encoder encodeInteger:self.actualPrice forKey:ActualPriceKey];
    
    [encoder encodeDouble:self.discount forKey:DiscountKey];
    [encoder encodeInteger:self.discountType forKey:DiscountTypeKey];
    
    [encoder encodeObject:self.pictureFile forKey:pictureFileKey];
    [encoder encodeInteger:self.categoryID forKey:CategoryIDKey];
   // [encoder encodeObject:self.categoryName forKey:CategoryNameKey];
    [encoder encodeInteger:self.maxQuantity forKey:MaxQuantityKey];
    [encoder encodeInteger:self.minQuantity forKey:MinQuantityKey];
     [encoder encodeInteger:self.instock forKey:InStockKey];
      [encoder encodeBool:self.allowOutOfStock forKey:allowOutOfStockKey];
    
     [encoder encodeBool:self.publishedLocal forKey:PublishedLocalKey];
    [encoder encodeBool:self.publishedInternet forKey:PublishedInternetKey];
   /*if(self.options!=nil)
   {
       NSInteger intProductID=self.productID;
   }
    */
    [encoder encodeObject:self.options forKey:optionsKey];
    
    
}

- (id)initWithDictionary:(NSDictionary *)dictionary{
    if ((self = [super init]))
    {
        
        //self.productNumber=[[dictionary valueForKey:ProductNumberKey] integerValue];
        self.sortNumber=[[dictionary valueForKey:SortNumberKey] integerValue];
        //self.storeID=[dictionary valueForKey:storeIDKey];
         self.productID=[[dictionary valueForKey:ProductIDKey] integerValue];
         self.productUID=[dictionary valueForKey:ProductUIDKey];
        self.name = [dictionary valueForKey:NameKey];
        self.barcode = [dictionary valueForKey:BarcodeKey];
        self.detail = [dictionary valueForKey:DetailKey];
        self.shortDesc = [dictionary valueForKey:shortDescKey];
        self.price =  [[dictionary  valueForKey:PriceKey] integerValue];
        self.actualPrice =  [[dictionary  valueForKey:ActualPriceKey] integerValue];
        self.discount =  [[dictionary  valueForKey:DiscountKey] doubleValue];
        self.discountType =  [[dictionary  valueForKey:DiscountTypeKey] integerValue];
        
        self.pictureFile = [dictionary valueForKey:pictureFileKey];
        self.categoryID=[[dictionary valueForKey:CategoryIDKey] integerValue];
       // self.categoryName=[dictionary valueForKey:CategoryNameKey] ;
        
        self.maxQuantity=[[dictionary valueForKey:MaxQuantityKey] integerValue];
        self.minQuantity=[[dictionary valueForKey:MinQuantityKey] integerValue];
        self.instock=[[dictionary valueForKey:InStockKey] integerValue];
        self.allowOutOfStock=[[dictionary valueForKey:allowOutOfStockKey] boolValue];
        //self.discount=[[dictionary valueForKey:DiscountKey] doubleValue];
        
        
       self.publishedLocal=[[dictionary valueForKey:PublishedLocalKey] boolValue];
        self.publishedInternet=[[dictionary valueForKey:PublishedInternetKey] boolValue];
    }
    return self;
    
    
}


- (NSMutableDictionary *)toNSDictionary{
    NSMutableDictionary *dictionary=[NSMutableDictionary new];
    
    [dictionary setValue:self.name forKey:NameKey];
    //[dictionary setValue:self.storeID forKey:storeIDKey];

    [dictionary setValue:self.barcode forKey:BarcodeKey];
    [dictionary setValue:(self.detail == nil)?@"":self.detail forKey:DetailKey];
    [dictionary setValue:(self.shortDesc == nil)?@"":self.shortDesc forKey:shortDescKey];
    [dictionary setValue:[NSNumber numberWithInteger:self.price] forKey:PriceKey];
    [dictionary setValue:[NSNumber numberWithInteger:self.actualPrice] forKey:ActualPriceKey];
    
    [dictionary setValue:[NSNumber numberWithDouble:self.discount] forKey:DiscountKey];
    [dictionary setValue:[NSNumber numberWithInteger:self.discountType] forKey:DiscountTypeKey];
    
    [dictionary setValue:(self.pictureFile==nil)?@"":self.pictureFile forKey:pictureFileKey];
    [dictionary setValue:[NSNumber numberWithUnsignedInteger:self.productID] forKey:ProductIDKey];
   [dictionary setValue:self.productUID forKey:ProductUIDKey];
    
    [dictionary setValue:[NSNumber numberWithUnsignedInteger:self.sortNumber] forKey:SortNumberKey];
    [dictionary setValue:[NSNumber numberWithUnsignedInteger:self.categoryID] forKey:CategoryIDKey];
     [dictionary setValue:[NSNumber numberWithUnsignedInteger:self.maxQuantity] forKey:MaxQuantityKey];
    if(self.minQuantity<1)
        self.minQuantity=1;
    [dictionary setValue:[NSNumber numberWithUnsignedInteger:self.minQuantity] forKey:MinQuantityKey];
     [dictionary setValue:[NSNumber numberWithUnsignedInteger:self.instock] forKey:InStockKey];
    [dictionary setValue:[NSNumber numberWithBool:self.allowOutOfStock] forKey:allowOutOfStockKey];
    
    
     [dictionary setValue:[NSNumber numberWithBool:self.publishedLocal] forKey:PublishedLocalKey];
    [dictionary setValue:[NSNumber numberWithBool:self.publishedInternet] forKey:PublishedInternetKey];
    
    NSMutableArray *items=[NSMutableArray new];
    if(self.options==nil)
        self.options=[NSMutableArray new];
    for (ProductOption *po in self.options) {
        //for (ProductOptionItem *poi in self.options) {
            
        [items addObject:[po toNSDictionary]];
        //}
    }
    [dictionary setValue:items forKey:optionsKey];
    
    return dictionary;
    
    
}

-(void)importFromDictionary:(NSDictionary *)dictionary{
    //Product *prod=[Product new];
    self.name=[dictionary valueForKey:NameKey];
    //self.storeID=[dictionary valueForKey:storeIDKey];
    self.barcode=[dictionary valueForKey:BarcodeKey];
    self.detail=[dictionary valueForKey:DetailKey];
    self.shortDesc=[dictionary valueForKey:shortDescKey];
    
    self.price=[[dictionary  valueForKey:PriceKey] integerValue];
    self.actualPrice=[[dictionary  valueForKey:ActualPriceKey] integerValue];
    
    self.discount=[[dictionary  valueForKey:DiscountKey] doubleValue];
    self.discountType=[[dictionary valueForKey:DiscountTypeKey] integerValue];
    
    
    self.pictureFile=[dictionary valueForKey:pictureFileKey];
    self.productID=[[dictionary valueForKey:ProductIDKey] integerValue];
    self.productUID=[dictionary valueForKey:ProductUIDKey];
    
    self.sortNumber=[[dictionary valueForKey:SortNumberKey] integerValue];
    self.categoryID=[[dictionary valueForKey:CategoryIDKey] integerValue];
    self.maxQuantity=[[dictionary valueForKey:MaxQuantityKey] integerValue];
    self.minQuantity=[[dictionary valueForKey:MinQuantityKey] integerValue];
    self.instock=[[dictionary valueForKey:InStockKey] integerValue];
    self.allowOutOfStock=[[dictionary valueForKey:allowOutOfStockKey] boolValue];
    
    self.publishedLocal=[[dictionary valueForKey:PublishedLocalKey] boolValue];
    self.publishedInternet=[[dictionary valueForKey:PublishedInternetKey] boolValue];
    
    //return prod;
    
    
}

+(Product *)fromDictionary:(NSDictionary *)dictionary{
    Product *prod=[Product new];
    prod.name=DICT_GET(dictionary, NAME_KEY);//[dictionary valueForKey:NameKey];
    prod.barcode=DICT_GET(dictionary, BarcodeKey);//[dictionary valueForKey:BarcodeKey];
    prod.detail=DICT_GET(dictionary, DetailKey);//[dictionary valueForKey:DetailKey];
    prod.shortDesc=DICT_GET(dictionary, shortDescKey);//[dictionary valueForKey:shortDescKey];
   // prod.storeID=DICT_GET(dictionary, storeIDKey);//[dictionary valueForKey:storeIDKey];
    prod.price=DICT_GET_INT(dictionary, PriceKey);//[[dictionary  valueForKey:PriceKey] integerValue];
    prod.actualPrice=DICT_GET_INT(dictionary, ActualPriceKey);//[[dictionary  valueForKey:ActualPriceKey] integerValue];
    
    prod.discount=DICT_GET_INT(dictionary, DiscountKey);//[[dictionary  valueForKey:DiscountKey] doubleValue];
    prod.discountType=DICT_GET_INT(dictionary, DiscountTypeKey);//[[dictionary valueForKey:DiscountTypeKey] integerValue];
    
    
    prod.pictureFile=DICT_GET(dictionary, pictureFileKey);//[dictionary valueForKey:ImageKey];
    prod.productID=DICT_GET_INT(dictionary, ProductIDKey);//[[dictionary valueForKey:ProductIDKey] integerValue];
    prod.productUID=DICT_GET(dictionary, ProductUIDKey);//[dictionary valueForKey:ProductUIDKey];

    prod.sortNumber=DICT_GET_INT(dictionary, SortNumberKey);//[[dictionary valueForKey:SortNumberKey] integerValue];
    prod.categoryID=DICT_GET_INT(dictionary, CategoryIDKey);//[[dictionary valueForKey:CategoryIDKey] integerValue];
    prod.maxQuantity=DICT_GET_INT(dictionary, MaxQuantityKey);//[[dictionary valueForKey:MaxQuantityKey] integerValue];
    prod.minQuantity=DICT_GET_INT(dictionary, MinQuantityKey);//[[dictionary valueForKey:MinQuantityKey] integerValue];
    prod.instock=DICT_GET_INT(dictionary, InStockKey);//[[dictionary valueForKey:InStockKey] integerValue];
    prod.allowOutOfStock=DICT_GET_INT(dictionary, allowOutOfStockKey);//[[dictionary valueForKey:StockUnLimitedKey] boolValue];
    
    prod.publishedLocal=DICT_GET_INT(dictionary, PublishedLocalKey);//[[dictionary valueForKey:PublishedLocalKey] boolValue];
     prod.publishedInternet=DICT_GET_INT(dictionary, PublishedInternetKey);//[[dictionary valueForKey:PublishedInternetKey] boolValue];
   
    if(prod.options==nil)
        prod.options=[NSMutableArray new];
    
    NSArray *arr=DICT_GET(dictionary, optionsKey);
    if(![arr isEqual:[NSNull null]] && arr!=nil && [arr count]>0){
    for(NSDictionary * option in arr){
        ProductOption *po=[[ProductOption alloc] initWithDictionary:option];
        
        if(po.selections==nil)
            po.selections=[NSMutableArray new];
        if([po.selections count]>0){
            // in here we make normalize values
            for(ProductOptionItem *poi in po.selections){
                if(![poi.parentUID isEqualToString:po.UID]){
                    poi.parentUID=po.UID;
                }
/*
                if(poi.price==0 && poi.addlCost>0){
                    poi.price=prod.price+poi.addlCost;
                }*/
            }
        }
        [prod.options addObject:po];
    }
    }
    
    return prod;
    
    
}

-(void)removeImage{
    if(self.pictureFile==nil || self.pictureFile.length==0)
        return;
    
    
    NSString *imagesPath=[AppDelegate getImagesPath];
    
    NSString *filePath=[imagesPath stringByAppendingPathComponent:self.pictureFile];
    
    NSFileManager *fileManager=[NSFileManager defaultManager];
    
    if([fileManager fileExistsAtPath:filePath]){
        NSError *error;
        [fileManager removeItemAtPath:filePath error:&error];
    }
}

-(void)downloadImage{
    
    if(self.pictureFile==nil || self.pictureFile.length==0)
        return;
    
    NSString *imagesPath=[AppDelegate getImagesPath];
    
    NSString *filePath=[imagesPath stringByAppendingPathComponent:self.pictureFile];
    
    if([[NSFileManager defaultManager] fileExistsAtPath:filePath])
        return;
    
    AppDelegate *_appDelegate=ApplicationDelegate;
    
    NSString *url=[NSString stringWithFormat:@"%@/%@/%@/%@",ServerApiURL,ServerImagePath,_appDelegate.appConfig.user_userid,_pictureFile];
    NSURL *imageURL = [NSURL URLWithString:url];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            // Update the UI
            //self.imageView.image = [UIImage imageWithData:imageData];
            [imageData writeToFile:filePath atomically:YES];
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_UPDATE_INVENTORY object:nil];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_UPDATE_INVENTORY_SETTINGS object:nil userInfo:@{KEY_SELECTED_INVENTORY:_appDelegate.inventoryModel.inventory}];
        });
    });
    
}

-(ProductOptionItem *)getOptionItemWithParentUID:(NSString *)parentUID andUID:(NSString *)UID   {
    
    if(self.options==nil || [self.options count]==0)
        return nil;
    
            //for(OrderOptionItem *ooi in item.options){
                
                NSPredicate *p=[NSPredicate predicateWithFormat:@"UID==%@",parentUID];
                
                NSArray *result_options=[self.options filteredArrayUsingPredicate:p];
    
                if([result_options count]==0)
                    return nil;
    
    
                    ProductOption *po=[result_options firstObject];
                    if([po.selections count]==0)
                        return nil;
    
                        p=[NSPredicate predicateWithFormat:@"UID==%@",UID];
    
    result_options=[po.selections filteredArrayUsingPredicate:p];

    if([result_options count]==0)
        return nil;
    
        ProductOptionItem *poi=[result_options firstObject];
    /*if(poi.price==0 && poi.addlCost>0){
        poi.price=self.price+poi.addlCost;
    }*/
        //if(![poi.UID isEqualToString:UID])
          //  return nil;
    
    return poi;
    
    
    
                
            //}
        
    
}

-(void)uploadImage{
    if(self.pictureFile!=nil && self.pictureFile.length>0){
        AppDelegate *_appDelegate=ApplicationDelegate;
        
        NSString *imagesPath=[AppDelegate getImagesPath];
        NSString *filePath=[imagesPath stringByAppendingPathComponent:self.pictureFile];
        if([[NSFileManager defaultManager] fileExistsAtPath:filePath])
        {
            NSData *data=[NSData dataWithContentsOfFile:filePath];
            
            /*rom: TODO, chunk to 64k then spread to multiple servers
             i.e. chunk1 -> server1, chunk2 -> server 2, etc... Each server can handle more than one chunk
             example lets say we have only 2 servers then chunk1->server1 chunk2->sever2 chunk3->server1 chunk4->server2...
             On the dat acenter one server can replicate another server's chunk for backup so when one goes down the other one may serve
             the chunk.
             On the client side get file info with the ipadrees of its chunk servers so we can
             download each chunk simultaneously then assemble them. this way its like having parralel transfer of data.
             
             NSUInteger kb64=64*1024;
             NSUInteger length=[data length];
             if(length==0)
             return;
             
             NSMutableData *mdata;
             int mod=[data length] % kb64;
             if(mod>0){
             mdata=[NSMutableData dataWithData:data];
             [mdata increaseLengthBy:mod];
             }
             //UIImage *image=[[UIImage alloc] initWithContentsOfFile:filePath];
             //if(mdata!=nil){
             NSUInteger total=[mdata length]/kb64;
             for(int i=0;i<total;i++){
             NSData *data64kb=[data subdataWithRange:NSMakeRange(0, kb64)];
             NSString *md5=[data64kb MD5];
             
             }
             */
            
            //[Util postUploadBeforeSend:data filename:[NSString stringWithFormat:@"product_%@.png",@(self.productID)] contenttype:@"image/png"];
            
            
            NSString *md5=[data MD5];
            NSString *mimetype=@"image/png";
            //NSError *error;
            NSString *info=[NSString stringWithFormat:@"usertoken=%@&md5=%@&filename=%@&mimetype=%@&storeid=%@&deviceid=%@&menuid=%@&productid=%@&productuid=%@"
                            ,_appDelegate.appConfig.user_userToken
                            ,md5
                            ,self.pictureFile
                            ,mimetype
                            ,_appDelegate.appConfig.storeID
                            ,_appDelegate.appConfig.device_id
                            ,@(_appDelegate.appConfig.device_menuid)
                            ,@(self.productID)
                            ,self.productUID];
            
            [Util postUploadBeforeSend:data filename:self.pictureFile contenttype:mimetype serverpath:ServerUploadProductImagePath info:info];
            
            //[images_dict setObject:data forKey:[NSString stringWithFormat:@"%@",p.pictureFile]];
            //}
            //[images_dict setObject:[NSData dataWithContentsOfFile:filePath] forKey:[NSString stringWithFormat:@"%@",p.pictureFile]];
            
            //[images_array addObject:image];
        }
    }
}


/*
+(NSString *)priceToString:(double)price{
    NSNumberFormatter *fmt=[[NSNumberFormatter alloc] init];
    [fmt setPositiveFormat:@"0.##"];
    return [fmt stringFromNumber:[NSNumber numberWithDouble:price]]; //[NSString stringWithFormat:@"%.02f",discount];
 
    //s=[s stringByReplacingOccurrencesOfString:@".00" withString:@""];
    
    
    //return s;
}
 */

 /*

-(NSString *)actualPriceToString{
    //1.00
    NSString *s=nil;
    
        if(self.discount>0){
            //self.discountTextField.text=[NSString stringWithFormat:@"%.02f",discount];
            double d_price=(double)self.price/100;
            double actualPrice=d_price-((self.discount/100)*d_price);
            s=[NSString stringWithFormat:@"%.02f",actualPrice];
            s=[s stringByReplacingOccurrencesOfString:@".00" withString:@""];
        }
    
    return s;
}
 */
/*
+(NSInteger)compute_discount_val:(double)pct_discount price:(NSInteger)price{// quantity:(NSInteger)quantity{
    //double result=0.0;
    //(10/100)*100=10
    double result=((pct_discount/100)*(double)price/100);*quantity;
    //discount=discount/100;
    //cell.discountLabel.text = [NSString stringWithFormat:@"-%.02f",discount];
    //total=total+(discount*100); //0+(.1*100
    //result=result+discount;
    return (round(100*result)/100)*100;
}

+(double)compute_discount_pct:(NSInteger)val_discount price:(NSInteger)price{// quantity:(NSInteger)quantity{
    
    double result=(val_discount/price)*100;
    
}
*/

- (BOOL)isEqual:(id)object {
    if (![object isKindOfClass:[Product class]]) {
        return NO;
    }
    
    Product *other = (Product *)object;
    return (other.productID == self.productID);
}



@end
