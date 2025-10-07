//
//  IODItem.m
//  iOSDiner
//
//  Created by Romulo Quidilig on 3/19/15.
//  Copyright (c) 2015 Sharecle Inc. All rights reserved.
//

#import "OrderItem.h"
#import "InventoryModel.h"
#import "OrderOptionItem.h"
#import "defs_order_product.h"
#import "defs.h"


@implementation OrderItem
- (id)initWithCoder:(NSCoder*)decoder
{
    if ((self = [super init]))
    {
        self.productID=[decoder decodeIntegerForKey:ProductIDKey];
        self.barcode=[decoder decodeObjectForKey:BarcodeKey];
        self.quantity = [decoder decodeIntForKey:QuantityKey];
        self.name = [decoder decodeObjectForKey:NameKey];
        self.price = [decoder decodeIntegerForKey:PriceKey];
        self.actualPrice = [decoder decodeIntegerForKey:ActualPriceKey];
        self.discount=[decoder decodeDoubleForKey:DiscountKey];
        self.notes = [decoder decodeObjectForKey:NotesKey];
        self.options=[decoder decodeObjectForKey:optionsKey];
    }
    return self;
}


- (void)encodeWithCoder:(NSCoder*)encoder
{
    
    [encoder encodeInteger:self.productID forKey:ProductIDKey];
    [encoder encodeObject:self.barcode forKey:BarcodeKey];
    [encoder encodeObject:self.name forKey:NameKey];
    [encoder encodeInteger:self.quantity forKey:QuantityKey];
    [encoder encodeInteger:self.price forKey:PriceKey];
    [encoder encodeObject:self.notes forKey:NotesKey];
    
    
    [encoder encodeInteger:self.actualPrice forKey:ActualPriceKey];
    [encoder encodeDouble:self.discount forKey:DiscountKey];
    
    [encoder encodeObject:self.options forKey:optionsKey];
    
}
/*
- (id)initWithProduct:(Product *)product{
    self=[super init];
        if(self){
        
        self.productID=product.productID;
        self.name=product.name;
        self.price=product.price;
        self.quantity=product.minQuantity;
    }
    
    return self;
}
*/
- (id)initWithProduct:(Product *)product isLive:(BOOL)isLive withStoreID:(NSString *)storeID{
    self=[super init];
    
    if(self){
        
        self.productID=product.productID;
        self.barcode=product.barcode;
        self.actualPrice=product.actualPrice;
        self.discount=product.discount;
        self.discountType=product.discountType;
        self.quantity=product.minQuantity;
        self.isLive=isLive;
        //self.notes=product.notes;
        
        //self.productID=product.productID;
        //self.barcode=product.barcode;
        self.name=product.name;
        self.price=product.price;
        //self.actualPrice=product.actualPrice;
        //self.discount=product.discount;
        //self.discountType=product.discountType;
        //self.quantity=product.minQuantity;
        //self.isLive=isLive;
        self.storeID=storeID;
        
    }
    
    return self;
}

- (id)initWithName:(NSString*)inName andPrice:(float)inPrice andPictureFile:(NSString*)inPictureFile andProductID:(int)inProductID andCategoryID:(int)inCategroyID andDetail:(NSString *)inDetail{
    self=[super init];
 
    if(self){
        
    }
    
    return self;
}

- (id)initWithJSON:(NSDictionary*)json{
    self=[super init];
   
    if(self){
        
        self.productID=[[json valueForKey:ProductIDKey] integerValue];
        self.barcode=DICT_GET(json,BarcodeKey);
        [self setQuantity:[[json valueForKey:QuantityKey] integerValue]];
        self.name= DICT_GET(json,NameKey);
        self.price=[[json valueForKey:PriceKey] integerValue];
        self.notes= DICT_GET(json,NotesKey);
        self.options=[NSMutableArray new];
        
        NSArray *arr_options=[json valueForKey:optionsKey];
        
        if(arr_options!=nil && [arr_options count]>0){
            for(NSDictionary *dict in arr_options){
                OrderOptionItem *ooi=[[OrderOptionItem alloc] initWithDictionary:dict];
                
                [self.options addObject:ooi];
            }
        }
    }
    
    return self;
}

//+(void)addToCart:(Product *)product{
//    //if (!self.addToCartButton.selected) {
//    OrderItem *orderItem=[[OrderItem alloc] init];
//    [self.view endEditing:YES];
//    
//    
//    self.notesText.text=[self.notesText.text stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" "]];
//    
//    self.notesText.text=[self.notesText.text stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"\n"]];
//    
//    orderItem.notes=([self.notesText.text isEqualToString:PlaceHolderText])?@"":self.notesText.text;
//    
//    NSNumberFormatter *nf=[[NSNumberFormatter alloc] init];
//    //OrderItem *orderItem=[[OrderItem alloc] initWithProduct:self.product];
//    
//    if(![nf numberFromString:self.quantityText.text]){
//        orderItem.quantity=_selectedProduct.minQuantity;
//    }
//    else{
//        orderItem.quantity=[self.quantityText.text intValue];
//    }
//    
//    
//    if(_selectedProduct.maxQuantity>0 && orderItem.quantity>_selectedProduct.maxQuantity)
//        orderItem.quantity=_selectedProduct.maxQuantity;
//    
//    if(orderItem.quantity==0)
//        orderItem.quantity=_selectedProduct.minQuantity;
//    
//    
//    [checkoutCart addItem:orderItem];// withQuantity:[self.quantityText.text integerValue]];
//    self.addToCartButton.selected = YES;
//    
//    /*
//     UILabel* addItemDisplay = [[UILabel alloc] initWithFrame:[_addToCartButton frame]];
//     [addItemDisplay setText:@"+1"];
//     [addItemDisplay setTextColor:[UIColor whiteColor]];
//     [addItemDisplay setBackgroundColor:[UIColor clearColor]];
//     [addItemDisplay setTextAlignment:NSTextAlignmentCenter];
//     [addItemDisplay setFont:[UIFont boldSystemFontOfSize:32.0]];
//     [[self view] addSubview:addItemDisplay];
//     
//     [UIView animateWithDuration:2.0
//     animations:^{
//     [addItemDisplay setCenter:[self.tabBarController.tabBar center]];
//     [addItemDisplay setAlpha:0.0];
//     } completion:^(BOOL finished) {
//     [addItemDisplay removeFromSuperview];
//     [self updateCartBadge];
//     if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
//     
//     [self.tableView reloadData];
//     
//     }
//     else{
//     [self.navigationController popViewControllerAnimated:YES];
//     }
//     }];
//     */
//    //end animation
//    
//    
//    
//    //}
//    //    else {
//    //        OrderItem *item=[[OrderItem alloc] initWithProduct:_selectedProduct isLive:_appDelegate.appConfig.isLive];
//    //        [checkoutCart removeItem:item] ;//] withQuantity:[self.quantityText.text integerValue]];
//    //        self.addToCartButton.selected = NO;
//    //        [self.quantityText setEnabled:YES];
//    //
//    //
//    //    }
//    [self updateCartBadge];
//    /*if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
//     [self.tableView reloadData];
//     
//     }
//     else{
//     */
//    [self.navigationController popViewControllerAnimated:YES];
//    //}
//    
//}

//rom
- (BOOL)isEqual:(id)object {
    if (![object isKindOfClass:[OrderItem class]]) {
        return NO;
    }
    
    OrderItem *other = (OrderItem *)object;
    
    bool result=(other.productID == self.productID);
    
    return result;
}

@end
