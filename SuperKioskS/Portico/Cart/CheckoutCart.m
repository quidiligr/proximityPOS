//
//  RWCheckoutCart.m
//
//
//  Created by Romulo Quidilig.
//
//

#import "CheckoutCart.h"
//#import "defs.h"
//static NSUInteger const MAX_QUANTITY=100;

@interface CheckoutCart()

@property (strong, nonatomic) NSMutableArray* itemsArray;


@end

@implementation CheckoutCart

- (id)init {
    self = [super init];
    if (self) {
        //Custom initialization
        self.itemsArray = [[NSMutableArray alloc] init];
    }
    return self;
}


+ (CheckoutCart *)sharedInstance {
    static CheckoutCart*  _sharedCart;
    
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        _sharedCart = [[CheckoutCart alloc] init];
    });
    
    return _sharedCart;
}

- (NSArray*)itemsInCart {
    return self.itemsArray;
}

- (BOOL)containsItem:(OrderItem*)item {
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"productID=%@",@(item.productID)];
    NSArray* duplicateProducts = [self.itemsArray filteredArrayUsingPredicate:predicate];
    return (duplicateProducts.count > 0) ? YES : NO;
}

- (OrderItem*)getItem:(NSInteger)productID {
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"productID=%@",@(productID)];
    NSArray* searchProducts = [self.itemsArray filteredArrayUsingPredicate:predicate];
    if(searchProducts.count>0)
        return [searchProducts firstObject];
    else
        return nil;
}

- (void)addItem:(OrderItem*)item{// withQuantity:(NSUInteger)quantity {
    if (![self containsItem:item]) {
        [self.itemsArray addObject:item];
    }
    /*if ([self containsProduct:product]) {
        return;
    }
     */
    /*if(quantity>=MAX_QUANTITY)
        quantity=MAX_QUANTITY;
    */
    //int added=0;
    
    /*for(int i=1;i<=quantity;i++){
        [self.productsArray addObject:product];
    }
     */
    /*if(product.max_quantity>0 && product.quantity>product.max_quantity)
        product.quantity=product.max_quantity;
    
    if(product.quantity==0)
        product.quantity=1;
    */
    /*if([self.productsArray containsObject:product]){
        NSUInteger index= [self.productsArray indexOfObject:product];
        product=[self.productsArray objectAtIndex:index];
        product.quantity=quantity;
    }
    else{*/
    
     //[self.productsArray addObject:product];
    //}
    
    
    
}

- (void)removeItem:(OrderItem*)item{// withQuantity:(NSUInteger)quantity{
   /* NSPredicate *predicate=[NSPredicate predicateWithFormat:@"productID=%lu",product.productID];
    NSArray *removeProducts=[self.productsArray filteredArrayUsingPredicate:predicate];
    
    if(quantity>[removeProducts count])
        quantity=[removeProducts count];
    
    int removed=0;
    for(Product *removeItem in removeProducts){
        [self.productsArray removeObject:removeItem];
        removed++;
        if(removed>=quantity)
            break;
    }
    */
    if ([self containsItem:item]) {
        [self.itemsArray removeObject:item];
    }
}

//- (void)removeProduct:(Product*)product withQuantity:(NSUInteger) quantity{// withQuantity:(NSUInteger)quantity{
//    /* NSPredicate *predicate=[NSPredicate predicateWithFormat:@"productID=%lu",product.productID];
//     NSArray *removeProducts=[self.productsArray filteredArrayUsingPredicate:predicate];
//     
//     if(quantity>[removeProducts count])
//     quantity=[removeProducts count];
//     
//     int removed=0;
//     for(Product *removeItem in removeProducts){
//     [self.productsArray removeObject:removeItem];
//     removed++;
//     if(removed>=quantity)
//     break;
//     }
//     */
//    if ([self containsProduct:product]) {
//        product.quantity=product.quantity-quantity;
//        if(product.quantity<0)
//            product.quantity=0;
//        if(product.quantity==0)
//            [self.productsArray removeObject:product];
//    }
//}

- (void)clearCart {
    if(self.itemsArray)
        [self.itemsArray removeAllObjects];
    else
        self.itemsArray =  [[NSMutableArray alloc] init];
    
   
    
}


-(NSInteger)total {
    
    NSInteger total = 0;
    for (OrderItem* item in self.itemsInCart) {
        //total += product.price;
        total += item.price*item.quantity;
    }
    return total;
}

- (NSInteger)total_tax:(NSInteger)totalCents tax:(double)tax{
    double d_totalCents = totalCents;
    d_totalCents=d_totalCents/100;
    //float total_tax=total*[[CheckoutCart sharedTaxInstance] floatValue];
    double total_tax=d_totalCents*(tax/100);
    
    return total_tax*100;
}

- (NSInteger)grand_total:(double)tax{
    double d_total=[self total];
    d_total=d_total/100 ;
    
    double t_total_tax=d_total*(tax/100);//[self total_tax:d_total tax:tax];
    
    //t_total_tax=t_total_tax/100;
    
    return (d_total+t_total_tax)*100;
}

//rom: this is for sending order to server kiosk
//- (NSString*)textLabel{
//    NSString *text=[NSMutableString new];
//    //NSMutableString *text=[NSMutableString string];
//    
//    /*NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
//    [dateFormatter setDateFormat:@"hh:mm:ss a"];
//    //float total = 0.0;
//    text=[text stringByAppendingString:[NSString stringWithFormat:@"%@\n", [dateFormatter stringFromDate:[NSDate date]]]];
//    */
//    for (OrderItem* item in self.itemsInCart) {
//        //total += product.price;
//        //total += product.price*product.quantity;
//        text=[text stringByAppendingFormat:@"%d %@ @%.02f\n",item.quantity,item.name,(double)item.price/100];
//        
//       // NSLog([NSString stringWithFormat:@"text=%@",text]);
//    }
//    
//    text=[text stringByAppendingFormat:@"Total: %.02f",(double)[self total]/100];
//    //NSLog([NSString stringWithFormat:@"final text=%@",text]);
//    return text;//@(total);
//}

- (NSString*)textLabel:(NSString *) storeName storeID:(NSString *)storeID {
    
    NSString *text=[NSMutableString new];
    
    for (OrderItem* item in self.itemsInCart) {
        text=[text stringByAppendingFormat:@"%lu %@ @%.02f\n",(unsigned long)item.quantity,item.name,(double)item.price/100];
        
        
    }
    
    
    // text=[text stringByAppendingFormat:@"Total: %.02f",(double)[self total]/100];
    //if(self.order!=nil){
    //  text=[text stringByAppendingFormat:@"Purchase from %@ %@",self.order.orderStoreID,self.order.orderStoreID];
    text=[text stringByAppendingFormat:@"Purchase from %@ %@",storeName,storeID];
    // }
    return text;//@(total);
    
    
}



@end
