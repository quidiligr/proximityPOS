//
//  MenuSelectionDelegate.h
//  superkiosks
//
//  Created by Katherine Sheehy on 12/6/15.
//  Copyright © 2015 Appcoda. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ProductCategory;
@protocol CategorySelectionDelegate <NSObject>
@required
-(void)selectedCategory:(ProductCategory *)category;

@end
