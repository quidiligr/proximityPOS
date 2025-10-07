//
//  OrderHistoryViewController.h
//  Portico
//
//
//  Created by Romulo Quidilig.
//  Copyright (c) 2015 Sharecle Inc. All rights reserved.
//

#import <iAd/iAd.h>
#import <UIKit/UIKit.h>

@interface OrderHistoryViewController : UICollectionViewController<UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIActionSheetDelegate,UIAlertViewDelegate,ADBannerViewDelegate>

@property (strong, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *otherStoreButton;

@end
