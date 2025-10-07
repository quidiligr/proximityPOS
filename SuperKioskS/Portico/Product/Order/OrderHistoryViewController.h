//
//  OrderHistoryViewController.h
//
//
//  Created by Romulo Quidilig.
//  Copyright (c) 2015 Sharecle Inc. All rights reserved.
//


#import <UIKit/UIKit.h>

@interface OrderHistoryViewController : UIViewController<UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIActionSheetDelegate,UIAlertViewDelegate,UIPrintInteractionControllerDelegate,UIPickerViewDelegate,UIPickerViewDataSource>
//@property (strong, nonatomic) NSString *selectedDay;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) IBOutlet UITextField *searchTextField;
@property (strong, nonatomic) IBOutlet UITextField *searchTypeTextField;
@property (strong, nonatomic) IBOutlet UIPickerView *pickerSearchType;

@property (nonatomic, strong) UIPopoverController *popOver;


@end
