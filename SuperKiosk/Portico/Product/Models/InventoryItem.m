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
#import "defs.h"

@implementation InventoryItem

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
        self.inventoryId = [decoder decodeObjectForKey:INVENTORYID_KEY];
        self.name = [decoder decodeObjectForKey:NAME_KEY];
        self.isEcommerce = [decoder decodeBoolForKey:ISECOMMERCE_KEY];
        self.acceptCCard = [decoder decodeBoolForKey:acceptCCardKey];
        self.acceptCash = [decoder decodeBoolForKey:acceptCashKey];
        
        self.salesTax = [decoder decodeFloatForKey:salesTaxKey];
        self.salesTip = [decoder decodeFloatForKey:salesTipKey];
        
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
        
        self.isActive= [decoder decodeBoolForKey:isActiveKey];
        self.categories=[decoder decodeObjectForKey:categoriesKey];
        self.products= [decoder decodeObjectForKey:PRODUCTS_KEY];
    }
    return self;
}


- (void)encodeWithCoder:(NSCoder*)encoder
{
    [encoder encodeObject:self.inventoryId forKey:INVENTORYID_KEY];
    [encoder encodeObject:self.name forKey:NAME_KEY];
    
    [encoder encodeBool:self.isEcommerce forKey:ISECOMMERCE_KEY];
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
    
    [encoder encodeBool:self.isActive forKey:isActiveKey];
    [encoder encodeObject:self.categories forKey:categoriesKey];
    [encoder encodeObject:self.products forKey:PRODUCTS_KEY];
}

//-(void)initFromDictionary:(NSDictionary *)dict {
-(void)deserialize:(NSDictionary *)dict {
    
    NSDictionary *cfg=[dict valueForKey:inventoryCfgKey];
#ifdef DEBUG
    NSLog(@"cfg=%@",cfg);
#endif
    [self updateSettingWithDictionary:cfg];
    
    NSDictionary *menu=[dict valueForKey:inventoryKey];
    
    
    [self updateProductsWithDictionary:menu];
    
}

-(void)updateSettingWithDictionary:(NSDictionary *)dict {
    
    // NSDictionary *cfg=[dict valueForKey:inventoryCfgKey];
    // self.featuredProductId = [dict valueForKey:featuredProdID_KEY];
    self.inventoryId = [dict valueForKey:INVENTORYID_KEY];
    //self.name = [dict valueForKey:NAME_KEY];
    
    self.isEcommerce = [[dict valueForKey:ISECOMMERCE_KEY] boolValue];
    self.acceptCCard = [[dict valueForKey:acceptCCardKey] boolValue];
    self.acceptedCards = [dict valueForKey:acceptedCardsKey];
    self.acceptCash = [[dict valueForKey:acceptCashKey] boolValue];
    
    self.salesTax = [[dict valueForKey:salesTaxKey] floatValue];
    self.salesTip = [[dict valueForKey:salesTipKey] floatValue];
    self.shippingCost = [[dict valueForKey:shippingCostKey] floatValue];
    
    self.useApplePay = [[dict valueForKey:useApplePayKey] boolValue];
    
    
    self.currency= [dict valueForKey:currencyKey];
    self.currencySymbol= [dict valueForKey:currencySymbolKey];
    if(!self.currency){
        self.currency=DEF_CURRENCY;
        self.currencySymbol=DEF_CURRENCY_SYMBOL;
    }
    
    self.minChargeAmount= [[dict valueForKey:minChargeAmountKey] integerValue];
    self.maxChargeAmount= [[dict valueForKey:maxChargeAmountKey] integerValue];
    
    self.maxUnpaidOrdersPerCustomer=[[dict valueForKey:maxUnpaidOrdersPerCustomerKey] integerValue];
    
    
    
    self.refundLevel=[[dict valueForKey:refundLevelKey] integerValue];
    if(self.refundLevel>ORDER_STATUS_READY)
        self.refundLevel=ORDER_STATUS_READY;
        
        //self.cardReader=[decoder decodeIntegerForKey:cardReaderKey];
        self.allowedDaysToSynch=[[dict valueForKey:allowedDaysToSynchKey] integerValue];
        
        self.isActive= [[dict valueForKey:isActiveKey] boolValue];
        
        
        if(self.categories==nil)
            self.categories=[NSMutableArray new];
            else
                [self.categories removeAllObjects];
    
    if(self.products==nil)
        self.products=[NSMutableArray new];
        else
            [self.products removeAllObjects];
    
    
    
    
    
    
}


-(void)updateProductsWithDictionary:(NSDictionary *)dict {
    
    
    // NSDictionary *menu=[dict valueForKey:inventoryKey];
    if(_categories==nil)
        _categories=[NSMutableArray new];
    NSArray *arr_categories=[dict valueForKey:categoriesKey];
    if([arr_categories count]>0){
        for(NSDictionary *item in arr_categories){
            [self.categories addObject:[[ProductCategory alloc] initWithDictionary:item]];
        }
    }
    
    if(_products==nil)
        _products=[NSMutableArray new];
    NSArray *arr_products=[dict valueForKey:PRODUCTS_KEY];
    if([arr_products count]>0){
        for(NSDictionary *item in arr_products){
            Product *prod=[[Product alloc] initWithDictionary:item];
            [self.products addObject:prod];
            
        }
    }
    
    
    
    
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

-(NSArray *)searchProducts:(NSString *)keywords {
    keywords=[keywords stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"*"]];
    keywords=[keywords stringByAppendingString:@"*"];
    
    
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"name LIKE[c] %@",keywords];
    
    NSArray *results=nil;
    
    results = [self.products filteredArrayUsingPredicate:predicate];
    
    
    return results;
    
    
}

-(NSArray *)speechSearchProducts:(NSString *)keywords {
    //keywords=[keywords stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"*"]];
    //keywords=[keywords stringByAppendingString:@"*"];
    
    
    //NSPredicate* predicate = [NSPredicate predicateWithFormat:@"name LIKE[c] %@",keywords];
    /*
     
     String comparisons are by default case and diacritic sensitive. You can modify an operator using the key characters c and d within square braces to specify case and diacritic insensitivity respectively, for example firstName BEGINSWITH[cd] $FIRST_NAME.
     [NSPredicate predicateWithFormat:@"keywords.name CONTAINS[cd] %@", self.searchString];
     
     NSPredicate predicateWithFormat:@"ANY keywords.name CONTAINS[c] %@", ...];
     */
    
    
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"nameGrammar CONTAINS[cd] %@",keywords];
    
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

-(NSArray *)searchProductsWithPictureFile:(NSString *)fileName {
    //barcode=[barcode stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" "]];
    if(fileName==nil || fileName.length==0)
        return nil;
    
    
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"pictureFile == %@",fileName];
    
    NSArray *results=nil;
    
    results = [self.products filteredArrayUsingPredicate:predicate];
    if([results count]>0){
        return results;
    }
    else{
        return nil;
    }
    
}

-(BOOL)hasImagesLoading{
    
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"imageLoadStatus == 1"];
    
    NSArray *results=nil;
    
    results = [self.products filteredArrayUsingPredicate:predicate];
    if([results count]>0){
        return YES;
    }
    else{
        return NO;
    }
    
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
@end
