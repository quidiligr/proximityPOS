//
//  IODOrder.m
//  iOSDiner
//
//  Created by Romulo Quidilig on 3/19/15.
//  Copyright (c) 2015 Sharecle Inc. All rights reserved.
//

#import "Order.h"
#import "OrderItem.h"
#import "defs_order_product.h"

@implementation Order

@synthesize orderItems;

- (OrderItem*)findKeyForOrderItem:(OrderItem*)searchItem {
    /*NSIndexSet* indexes = [[[self orderItems] allKeys] indexesOfObjectsPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
        OrderItem* key = obj;
        
        return [[searchItem name] isEqualToString:[key name]] && 
        [searchItem price] == [key price];
    }];
    
    if ([indexes count] >= 1) {
        OrderItem* key = [[[self orderItems] allKeys] objectAtIndex:[indexes firstIndex]];
        return key;
    }
    */
    return nil;
}

- (NSMutableArray *)orderItems{
    if (!orderItems) {
        orderItems = [NSMutableArray new];
    }
    
    return orderItems;
}

- (NSString*)orderDescription {
    NSMutableString* orderDescription = [NSMutableString new];
    /*
    NSArray* keys = [[[self orderItems] allKeys] sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        OrderItem* item1 = (OrderItem*)obj1;
        OrderItem* item2 = (OrderItem*)obj2;
        
        return [[item1 name] compare:[item2 name]];
    }];
    
    [keys enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        OrderItem* item = (OrderItem*)obj;
        NSNumber* quantity = (NSNumber*)[[self orderItems] objectForKey:item];
        
        [orderDescription appendFormat:@"%@ x%@\n",[item name],quantity];
    }];
    */
    return [orderDescription copy];
}

- (void)addItemToOrder:(OrderItem*)inItem {
    /*
    OrderItem* key = [self findKeyForOrderItem:inItem];
    
    if (!key) {
        [[self orderItems] setObject:[NSNumber numberWithInt:1] forKey:inItem];
    }
    else {
        NSNumber* quantity = [[self orderItems] objectForKey:key];
        int intQuantity = [quantity intValue];
        intQuantity++;
        
        [[self orderItems] removeObjectForKey:key];
        [[self orderItems] setObject:[NSNumber numberWithInt:intQuantity] forKey:key];
    }
     */
    if([orderItems containsObject:inItem]){
        OrderItem *existingItem=[orderItems objectAtIndex:[orderItems indexOfObject:inItem]];
        existingItem.quantity++;
    }
    else{
        [orderItems addObject:[inItem copy]];
        
    }
    
    
    
}

- (void)removeItemFromOrder:(OrderItem*)inItem {
    /*OrderItem* key = [self findKeyForOrderItem:inItem];
    
    if (key) {
        NSNumber* quantity = [[self orderItems] objectForKey:key];
        int intQuantity = [quantity intValue];
        intQuantity--;
        
        [[self orderItems] removeObjectForKey:key];
        
        if (intQuantity > 0)
            [[self orderItems] setObject:[NSNumber numberWithInt:intQuantity] forKey:key];
    }
     */
    if([orderItems containsObject:inItem]){
        OrderItem *existingItem=[orderItems objectAtIndex:[orderItems indexOfObject:inItem]];
        existingItem.quantity--;
        if(existingItem.quantity<=0)
            [orderItems removeObject:existingItem];
    }
    
}

- (float)totalOrder {
    /*__block float total = 0.0;
    float (^itemTotal)(float,int) = ^float(float price, int quantity) {
        return price * quantity;
    };
    */
    float total=0.0;
    float itemTotal=0.0;
    for(OrderItem *item in self.orderItems){
        itemTotal=item.price*item.quantity;
        total += itemTotal;//itemTotal(item.price,item.quantity);
    }
    
    
    return total;
}

+ (NSArray*)retrieveInventoryItems:(NSString *)inventoryAddress {
   // NSMutableArray* inventory = [NSMutableArray new];
    NSError* err = nil;
    
    NSArray* jsonInventory = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:inventoryAddress]]
                                                             options:kNilOptions
                                                               error:&err];
    NSLog(@"%@",jsonInventory);
   // if(inventory==nil)
    //    inventory=[NSMutableArray new];
    //[jsonInventory enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
    /*for(NSDictionary* item in jsonInventory){
        //NSDictionary* item = obj;
        [inventory addObject:[[OrderItem alloc] initWithName:[item objectForKey:NameKey]
                                                    andPrice:[[item objectForKey:PriceKey] floatValue]
                                              andPictureFile:[item objectForKey:ImageKey]
                              andProductID:[[item objectForKey:ProductIDKey] intValue] andCategoryID:  [[item objectForKey:CategoryIDKey] intValue]
                                                   andDetail:[item objectForKey:DetailKey]]];
     */
    //}];
   // }
    return [jsonInventory copy];
}




@end
