//
//  IODItem.m
//  iOSDiner
//
//  Created by Romulo Quidilig on 3/19/15.
//  Copyright (c) 2015 Sharecle Inc. All rights reserved.
//

#import "Product.h"
#import "ProductOption.h"
#import "ReachabilityManager.h"
#import "defs_order_product.h"
#import "defs.h"
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
//static NSString* const MaxCountKey = @"MaxCount";
//static NSString* const RemainingKey = @"Remaining";
*/
@implementation Product

- (id)initWithCoder:(NSCoder*)decoder
{
    if ((self = [super init]))
    {
        self.name = [decoder decodeObjectForKey:NameKey];
        self.nameGrammar = [self cleanTextForSpeech:self.name];
        self.barcode = [decoder decodeObjectForKey:BarcodeKey];
        self.detail = [decoder decodeObjectForKey:DetailKey];
        self.shortDesc = [decoder decodeObjectForKey:shortDescKey];
        self.price =  [decoder decodeIntegerForKey:PriceKey];
        self.pictureFile = [decoder decodeObjectForKey:ImageKey];
        self.categoryID=[decoder decodeIntegerForKey:CategoryIDKey];
        self.categoryName=[decoder decodeObjectForKey:CategoryNameKey];
        self.sortNumber=[decoder decodeIntegerForKey:ProductNumberKey];
        self.productID=[decoder decodeIntegerForKey:ProductIDKey];
        self.productUID=[decoder decodeObjectForKey:ProductUIDKey];
        self.instock=[decoder decodeIntegerForKey:InStockKey];
        self.allowOutOfStock=[decoder decodeBoolForKey:allowOutOfStockKey];
        
        self.sold=[decoder decodeIntegerForKey:SoldKey];
        self.maxQuantity=[decoder decodeIntegerForKey:MaxQuantityKey];
        self.minQuantity=[decoder decodeIntegerForKey:MinQuantityKey];
        self.discount=[decoder decodeDoubleForKey:DiscountKey];
        
        self.publishedLocal=[decoder decodeBoolForKey:PublishedLocalKey];
        self.publishedInternet=[decoder decodeBoolForKey:PublishedInternetKey];

    }
    return self;
}


- (void)encodeWithCoder:(NSCoder*)encoder
{
    [encoder encodeInteger:self.productID forKey:ProductIDKey];
    [encoder encodeObject:self.productUID forKey:ProductUIDKey];
    [encoder encodeInteger:self.sortNumber forKey:SortNumberKey];
    [encoder encodeObject:self.barcode forKey:BarcodeKey];
    [encoder encodeObject:self.name forKey:NameKey];
    [encoder encodeObject:self.detail forKey:DetailKey];
    [encoder encodeObject:self.shortDesc forKey:shortDescKey];
    [encoder encodeInteger:self.price forKey:PriceKey];
    [encoder encodeInteger:self.actualPrice forKey:ActualPriceKey];
    [encoder encodeObject:self.pictureFile forKey:ImageKey];
    [encoder encodeInteger:self.categoryID forKey:CategoryIDKey];
    [encoder encodeObject:self.categoryName forKey:CategoryNameKey];
    [encoder encodeInteger:self.maxQuantity forKey:MaxQuantityKey];
   [encoder encodeInteger:self.minQuantity forKey:MinQuantityKey];
    [encoder encodeInteger:self.instock forKey:InStockKey];
    [encoder encodeBool:self.allowOutOfStock forKey:allowOutOfStockKey];
    [encoder encodeDouble:self.discount forKey:DiscountKey];
    
    [encoder encodeBool:self.publishedLocal forKey:PublishedLocalKey];
    [encoder encodeBool:self.publishedInternet forKey:PublishedInternetKey];
}

-(NSString *)cleanTextForSpeech:(NSString *)text{
    NSString *ret=[[NSString stringWithString:text] lowercaseString];
    
    //™
    //ret = [ret stringByReplacingOccurrencesOfString:@"®" withString:@"" options:([NSStringCompareOptions o]) range:<#(NSRange)#>]
    ret = [ret stringByReplacingOccurrencesOfString:@"®" withString:@""];
    ret = [ret stringByReplacingOccurrencesOfString:@"™" withString:@""];
    ret = [ret stringByReplacingOccurrencesOfString:@"oz" withString:@"ounce"];
    ret = [ret stringByReplacingOccurrencesOfString:@"caffé" withString:@"café"];
    
    
    
    return ret;
}

- (id)initWithDictionary:(NSDictionary *)dictionary{
    if ((self = [super init]))
    {
          self.sortNumber=[[dictionary valueForKey:SortNumberKey] integerValue];
        //self.productNumber=[[dictionary valueForKey:ProductNumberKey] integerValue];
         self.productID=[[dictionary valueForKey:ProductIDKey] integerValue];
        self.productUID=[dictionary valueForKey:ProductUIDKey];
        self.barcode = [dictionary valueForKey:BarcodeKey];
        self.name = [dictionary valueForKey:NameKey];
        self.nameGrammar = [self cleanTextForSpeech:self.name];
        
        self.detail = [dictionary valueForKey:DetailKey];
        self.shortDesc = [dictionary valueForKey:shortDescKey];
        self.price =  [[dictionary  valueForKey:PriceKey] integerValue];
        self.actualPrice =  [[dictionary  valueForKey:ActualPriceKey] integerValue];
        //self.pictureFile = [dictionary valueForKey:ImageKey];
        self.pictureFile = [dictionary valueForKey:pictureFileKey];
        self.categoryID=[[dictionary valueForKey:CategoryIDKey] integerValue];
        self.categoryName=[dictionary valueForKey:CategoryNameKey] ;
        
        self.maxQuantity=[[dictionary valueForKey:MaxQuantityKey] integerValue];
        self.minQuantity=[[dictionary valueForKey:MinQuantityKey] integerValue];
         self.instock=[[dictionary valueForKey:InStockKey] integerValue];
        self.allowOutOfStock=[[dictionary  valueForKey:allowOutOfStockKey] boolValue];
        self.discount=[[dictionary valueForKey:DiscountKey] doubleValue];
        
        self.publishedLocal=[[dictionary valueForKey:PublishedLocalKey] boolValue];
        self.publishedInternet=[[dictionary valueForKey:PublishedInternetKey] boolValue];
        
        self.options=[NSMutableArray new];
        
        NSArray *items=[dictionary valueForKey:optionsKey];
        if(![items isEqual:[NSNull null]] && items!=nil && [items count]>0){
            for(NSDictionary *item in items){
                ProductOption *po=[[ProductOption alloc] initWithDictionary:item];
                [self.options addObject:po];
            }
        }
        
    }
    return self;
    
    
}


- (NSMutableDictionary *)toNSDictionay{
    NSMutableDictionary *dictionary=[NSMutableDictionary new];
    
    [dictionary setValue:self.name forKey:NameKey];
    
    [dictionary setValue:self.barcode forKey:BarcodeKey];
    [dictionary setValue:(self.detail == nil)?@"":self.detail forKey:DetailKey];
    [dictionary setValue:(self.shortDesc == nil)?@"":self.detail forKey:shortDescKey];
    [dictionary setValue:[NSNumber numberWithFloat:self.price] forKey:PriceKey];
    [dictionary setValue:[NSNumber numberWithFloat:self.actualPrice] forKey:ActualPriceKey];
    [dictionary setValue:(self.pictureFile==nil)?@"":self.pictureFile forKey:ImageKey];
    [dictionary setValue:[NSNumber numberWithUnsignedInteger:self.productID] forKey:ProductIDKey];
     [dictionary setValue:self.productUID forKey:ProductUIDKey];
    [dictionary setValue:[NSNumber numberWithUnsignedInteger:self.sortNumber] forKey:ProductNumberKey];
    [dictionary setValue:[NSNumber numberWithUnsignedInteger:self.categoryID] forKey:CategoryIDKey];
    [dictionary setValue:self.categoryName forKey:CategoryNameKey];
    [dictionary setValue:[NSNumber numberWithUnsignedInteger:self.maxQuantity] forKey:MaxQuantityKey];
    [dictionary setValue:[NSNumber numberWithUnsignedInteger:self.minQuantity] forKey:MinQuantityKey];
     [dictionary setValue:[NSNumber numberWithUnsignedInteger:self.instock] forKey:InStockKey];
    
    [dictionary setValue:[NSNumber numberWithUnsignedInteger:self.allowOutOfStock] forKey:allowOutOfStockKey];
    [dictionary setValue:[NSNumber numberWithDouble:self.discount] forKey:DiscountKey];

    [dictionary setValue:[NSNumber numberWithBool:self.publishedLocal] forKey:PublishedLocalKey];
    [dictionary setValue:[NSNumber numberWithBool:self.publishedInternet] forKey:PublishedInternetKey];
    
    return dictionary;
    
    
}

/*
-(NSString *)discountToString{
    //1.00
    NSString *s=nil;
    if(self.discount>0){
        s=[NSString stringWithFormat:@"%.2f",self.discount];
        //NSString *subString=[s substringFromIndex:(s.length-3)];
        //if([subString isEqualToString:@".00"])
        //return s;
        s=[s stringByReplacingOccurrencesOfString:@".00" withString:@""];
        //else
        //  return s;//[s substringToIndex:(s.length-3)];
    }
    
    return s;
}
*/
+(NSString *)discountToString:(double)discount currency:(NSString *)currency{
    NSNumberFormatter *fmt=[[NSNumberFormatter alloc] init];
    [fmt setPositiveFormat:@"0.##"];
    return [NSString stringWithFormat:@"%@%@",currency,[fmt stringFromNumber:[NSNumber numberWithDouble:discount]]]; //[NSString stringWithFormat:@"%.02f",discount];
    
    //s=[s stringByReplacingOccurrencesOfString:@".00" withString:@""];
    
    
    //return s;
}
+(NSString *)priceToString:(double)price currency:(NSString *)currency{
    
    NSNumberFormatter *fmt=[[NSNumberFormatter alloc] init];
    [fmt setPositiveFormat:@"0.##"];
    
    if(currency!=nil && currency.length>0){
    
    return [NSString stringWithFormat:@"%@%@",currency,[fmt stringFromNumber:[NSNumber numberWithDouble:price]]];
    }
    else{
        return [NSString stringWithFormat:@"%@",[fmt stringFromNumber:[NSNumber numberWithDouble:price]]];
        
    }
        //[NSString stringWithFormat:@"%.02f",discount];
    
    //s=[s stringByReplacingOccurrencesOfString:@".00" withString:@""];
    
    
    //return s;
}
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

+(double)compute_discount:(double)pct_discount price:(NSInteger)price quantity:(NSInteger)quantity{
    double result=0.0;
    double discount=((pct_discount/100)*price)*quantity;
    discount=discount/100;
    //cell.discountLabel.text = [NSString stringWithFormat:@"-%.02f",discount];
    //total=total+(discount*100); //0+(.1*100
    result=result+discount;
    return round(100*result)/100;
}
 */

//-(void)downloadImage:(NSString *)storeDeviceID storeUserID:(NSInteger)storeUserID {
-(void)downloadImage:(StoreHistory *)store {
    
    if(self.pictureFile==nil || self.pictureFile.length==0)
        return;

    
    /*
      [_connManager downloadViaBlueTooth:serverPath serverPeer:_appDelegate.selectedStore.peerInfo];
     */
    
      NSString *filePath=[[AppDelegate getImagesPathForServer:store.deviceID] stringByAppendingPathComponent:self.pictureFile];
        
        if([[NSFileManager defaultManager] fileExistsAtPath:filePath])
            return;
    
    ReachabilityManager *rm=[ReachabilityManager sharedInstance];
    
    if(rm==nil)
        return;
    NetworkStatus netStatus = [rm.hostReachability currentReachabilityStatus];
    if(netStatus ==ReachableViaWiFi || netStatus ==ReachableViaWWAN){
        NSString *url=[NSString stringWithFormat:@"%@%@/%@/%@",ServerURL,SKSImagePathWithStoreID,store.storeID,_pictureFile];
    #ifdef DEBUG
        NSLog(@"url=%@",url);
    #endif
        
        NSURL *imageURL = [NSURL URLWithString:url];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                // Update the UI
                //self.imageView.image = [UIImage imageWithData:imageData];
                [imageData writeToFile:filePath atomically:YES];
                [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_UPDATE_PRODUCT_IMAGE object:nil];
                
                
            });
        });
    }
}




- (BOOL)isEqual:(id)object {
    if (![object isKindOfClass:[Product class]]) {
        return NO;
    }
    
    Product *other = (Product *)object;
    return (other.productID == self.productID);
}

@end
