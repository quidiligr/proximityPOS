//
//  MyUIPageContol.h
//  superkiosk
//
//  Created by Katherine Sheehy on 2/26/17.
//  Copyright © 2017 Appcoda. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyUIPageContol : UIPageControl
{
    UIImage* activeImage;
    UIImage* inactiveImage;
}
@property(nonatomic, retain) UIImage* activeImage;
@property(nonatomic, retain) UIImage* inactiveImage;
@end
