//
//  StartScreenViewController.h
//  superkiosk
//
//  Created by Romulo Quidilig on 3/1/17.
//  Copyright © 2017 Appcoda. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WelcomeViewController : UIViewController<UIScrollViewDelegate>
//@property (strong,nonatomic) UIView *feaView;
//@property (strong, nonatomic) UIPageControl *pageControl;
//@property (nonatomic,strong) UIScrollView *featuredScrollView;
@property (weak, nonatomic) IBOutlet UIScrollView *featuredScrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (weak, nonatomic) IBOutlet UIButton *enterAppButton;

@end
