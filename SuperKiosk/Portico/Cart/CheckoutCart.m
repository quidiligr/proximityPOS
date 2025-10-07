//
//  RWCheckoutCart.m
//
//
//  Created by Romulo Quidilig.
//
//

#import "CheckoutCart.h"
#import "OrderOptionItem.h"
#import "defs.h"

//#import "defs.h"

//static NSUInteger const MAX_QUANTITY=100;

@interface CheckoutCart()




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

- (void)encodeWithCoder:(NSCoder*)encoder
{
    [encoder encodeObject:self.itemsArray forKey:itemsArrayKey];
    [encoder encodeObject:self.discounts forKey:discountsKey];
}
- (id)initWithCoder:(NSCoder*)decoder
{
    if ((self = [super init]))
    {
        self.itemsArray = [decoder decodeObjectForKey:itemsArrayKey];
        self.discounts=[decoder decodeObjectForKey:discountsKey];
        
    }
    return self;
}

/*
+ (CheckoutCart *)sharedInstance {
    static CheckoutCart*  _sharedCart;
    
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        _sharedCart = [[CheckoutCart alloc] init];
    });
    
    return _sharedCart;
}
*/
/*+ (NSNumber *)sharedTaxInstance {
    static NSNumber  *_tax;
    
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        _tax = [[NSNumber alloc ] initWithFloat:0.0];
    });
    
    return _tax;
}
*/
/*+ (float)sharedTaxInstance {
    static float _tax;
    
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        _tax = 0.0;
    });
    
    return _tax;
}
*/
/*
- (NSArray*)itemsInCart {
    return self.itemsArray;
}
*/
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

- (void)addItem:(OrderItem*)item isLive:(BOOL)isLive{// withQuantity:(NSUInteger)quantity {
    
    /*if (![item.storeID isEqualToString:self.currentStoreID]) {
        self.currentStoreID=item.storeID;
        //[self cleanCart:self.currentStoreID isLive:isLive];
        [self clearCart];
    }
     */
    
    
    
    //if (![self containsItem:item]) {
        [self.itemsArray addObject:item];
        
    //}
    
    
    
}

//remove items does not belong to specific storeid
-(void)cleanCart__:(NSString *)storeID isLive:(BOOL)isLive{
    NSPredicate *predicate= [NSPredicate predicateWithFormat:@"storeID!=%@ AND isLive!=%@",storeID,@(isLive)];
    NSArray *removeitems=[self.itemsArray filteredArrayUsingPredicate:predicate];
    
    if([removeitems count]>0)
    {
#if DEBUG
        NSLog(@"Start detecting mutated while being enumrated error");
#endif
        //for (OrderItem *item in removeitems) {
        for (int i=0;i<removeitems.count;i++) {
           
            [self.itemsArray removeObject:removeitems[i]];
        }
#if DEBUG
        NSLog(@"End detecting mutated while being enumrated error");
#endif
        
    }
}

//remove items does not belong to specific storeid
//and synch changes from the server such as live, price,name, etc..
-(void)cleanCart___:(NSString *)storeID isLive:(BOOL)isLive withInventory:(InventoryItem *)inventory{
    //select islive and storeid
    NSPredicate *predicate= [NSPredicate predicateWithFormat:@"storeID==%@ AND isLive==%@",storeID,@(isLive)];
    //NSArray *removeitems=[self.itemsArray filteredArrayUsingPredicate:predicate];
    //pass 1
    NSArray *cleanedItems=[self.itemsArray filteredArrayUsingPredicate:predicate];
    
    //make sure the price and name is synch
    //pass 2
    [self.itemsArray removeAllObjects];
    for( OrderItem* item in cleanedItems) {
        //predicate= [NSPredicate predicateWithFormat:@"categoryID==%@",item.productID];
        predicate= [NSPredicate predicateWithFormat:@"productID==%@",item.productID];
        
        NSArray *arr_p=[inventory.products filteredArrayUsingPredicate:predicate];
        
        
        if(arr_p){
            Product *p=[[Product alloc] initWithDictionary:[arr_p firstObject]];
            if(item.price!=p.price){
                item.price=p.price;
            }
            if(![item.name isEqualToString:p.name]){
                item.name=p.name;
            }
            [self.itemsArray addObject:item];
        }
    }
    
//    if([removeitems count]>0)
//    {
//#if DEBUG
//        NSLog(@"Start detecting mutated while being enumrated error");
//#endif
//        //for (OrderItem *item in removeitems) {
//        for (int i=0;i<removeitems.count;i++) {
//            
//            [self.itemsArray removeObject:removeitems[i]];
//        }
//#if DEBUG
//        NSLog(@"End detecting mutated while being enumrated error");
//#endif
    
   // }
}

-(void)cleanCart:(NSString *)storeID isLive:(BOOL)isLive withInventory:(InventoryItem *)inventory{
    //select islive and storeid
    //NSPredicate *predicate= [NSPredicate predicateWithFormat:@"storeID==%@ AND isLive==%@",storeID,@(isLive)];
    NSPredicate *predicate= [NSPredicate predicateWithFormat:@"storeID==%@",storeID];
    //NSArray *removeitems=
    self.itemsArray=[[self.itemsArray filteredArrayUsingPredicate:predicate] mutableCopy];
    //pass 1
    NSMutableArray *cleanedItems=[NSMutableArray new];//[self.itemsArray filteredArrayUsingPredicate:predicate];
    
    //make sure the price and name is synch
    //pass 2
    //[self.itemsArray removeAllObjects];
    for( OrderItem* item in self.itemsArray) {
        //predicate= [NSPredicate predicateWithFormat:@"categoryID==%@",item.productID];
        predicate= [NSPredicate predicateWithFormat:@"productID==%@",@(item.productID)];
        
        NSArray *arr_p=[inventory.products filteredArrayUsingPredicate:predicate];
        
        
        if(arr_p){
            //Product *p=[[Product alloc] initWithDictionary:[arr_p firstObject]];
            Product *p=[arr_p firstObject];
            
            if(item.price!=p.price){
                item.price=p.price;
            }
            if(![item.name isEqualToString:p.name]){
                item.name=p.name;
            }
            item.isLive=isLive;
            [cleanedItems addObject:item];
        }
    }
    self.itemsArray=[[NSMutableArray alloc] initWithArray:cleanedItems];
    
    //    if([removeitems count]>0)
    //    {
    //#if DEBUG
    //        NSLog(@"Start detecting mutated while being enumrated error");
    //#endif
    //        //for (OrderItem *item in removeitems) {
    //        for (int i=0;i<removeitems.count;i++) {
    //
    //            [self.itemsArray removeObject:removeitems[i]];
    //        }
    //#if DEBUG
    //        NSLog(@"End detecting mutated while being enumrated error");
    //#endif
    
    // }
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



- (NSInteger)total_discount {
    
    //NSInteger total = 0;
    double result=0.0;
    for (OrderItem* item in self.itemsArray) {
        if(item.discount>0){
            /*double discount=((item.discount/100)*item.price)*item.quantity;
            discount=discount/100;
            result=result+discount;
             */
            result=(item.actualPrice-item.price)*item.quantity;//[CheckoutCart compute_discount:item.discount price:item.price quantity:item.quantity];
        }
    }
   
    
    return result;
}

- (NSInteger)total {
    
    NSInteger total = 0;
    NSInteger totalOptions=0;
    for (OrderItem* item in self.itemsArray) {
        
        total += item.price*item.quantity;
        if([item.options count]>0){
            for(OrderOptionItem *ooi in item.options ){
                totalOptions=totalOptions+ooi.addlCost;
                
            }
            total=(total+totalOptions)*item.quantity;
        }
        
    }
   
    return total;
}

- (NSInteger)total_tax:(NSInteger)totalCents tax:(float)tax{
    float d_totalCents = (float)totalCents/100;
    d_totalCents=(d_totalCents*100)/100;
     //float total_tax=total*[[CheckoutCart sharedTaxInstance] floatValue];
    
    float f_tax=(float)tax/100;
    f_tax=(f_tax*100)/100;
    
    float total_tax=d_totalCents*(f_tax);//d_totalCents*(tax/100);
    total_tax=(total_tax*100)/100;
    return total_tax*100;
}

- (NSInteger)grand_total:(double)tax{
    double d_total=[self total];
    d_total=d_total/100 ;
    
    /*double d_total_discount=[self total_discount];
    d_total_discount=d_total_discount/100 ;
    
    
    d_total=d_total-d_total_discount;
    */
    double t_total_tax=d_total*(tax/100);//[self total_tax:d_total tax:tax];
    
     //t_total_tax=t_total_tax/100;
    
    return (d_total+t_total_tax)*100;
}


/*-(NSArray*)totalsWithTax:(float)tax{
    float total=[[self total] floatValue];
    float total_tax=total*tax;
    float grand_total=total+total_tax;
    return @[@(total),@(total_tax),@(grand_total)];
}
*/


//rom: this is for sending order to server kiosk
//- (NSString*)textLabel:(NSDictionary *)inventory{
- (NSString*)textLabel:(NSString *) storeName storeID:(NSString *)storeID {
    NSString *text=[NSMutableString new];
    
    for (OrderItem* item in self.itemsArray) {
        text=[text stringByAppendingFormat:@"%ld %@ @%.02f\n",(long)item.quantity,item.name,(double)item.price/100];
        
       
    }
    
    
    // text=[text stringByAppendingFormat:@"Total: %.02f",(double)[self total]/100];
    //if(self.order!=nil){
       //  text=[text stringByAppendingFormat:@"Purchase from %@ %@",self.order.orderStoreID,self.order.orderStoreID];
    text=[text stringByAppendingFormat:@"Purchase from %@ %@",storeName,storeID];
   // }
     return text;//@(total);
    
    
}



@end
