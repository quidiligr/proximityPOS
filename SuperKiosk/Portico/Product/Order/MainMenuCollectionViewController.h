//
//  MainMenuCollectionViewController.h
//  superkiosk
//
//  Created by Robert Gold on 2/17/17.
//  Copyright © 2017 Appcoda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iCarousel.h"
//#import "MyUIPageContol.h"

@interface MainMenuCollectionViewController : UIViewController<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout, iCarouselDataSource,iCarouselDelegate,UIScrollViewDelegate>
//@property (strong, nonatomic) IBOutlet iCarousel *carousel;
@property (strong, nonatomic) UIPageControl *pageControl;
@property (strong, nonatomic) IBOutlet iCarousel *carousel;
@property (strong, nonatomic) IBOutlet UILabel *carouselTitle;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong,nonatomic) UILabel *feaTitle;
@property (strong,nonatomic) UIView *feaView;


@end
