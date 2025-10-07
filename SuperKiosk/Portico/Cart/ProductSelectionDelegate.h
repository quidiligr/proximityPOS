//
//  MenuSelectionDelegate.h
//  superkiosks
//
//  Created by Katherine Sheehy on 12/6/15.
//  Copyright © 2015 Sharecle. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Product;
@protocol ProductSelectionDelegate <NSObject>
@required
-(void)selectedProduct:(Product *)product;

@end
