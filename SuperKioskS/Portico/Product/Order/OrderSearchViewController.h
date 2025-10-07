//
//  OrderHistoryViewController.h
//
//
//  Created by Romulo Quidilig.
//  Copyright (c) 2015 Sharecle Inc. All rights reserved.
//


#import <UIKit/UIKit.h>

@interface OrderSearchViewController : UIViewController<UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIActionSheetDelegate,UIAlertViewDelegate,UIPrintInteractionControllerDelegate,UIPickerViewDelegate,UIPickerViewDataSource>
/*
@property (nonatomic,strong) NSString *searchKeywords;
@property (nonatomic,strong) NSString *searchStatus;
@property (nonatomic,strong) NSString *searchDate;
@property (nonatomic,strong) NSString *searchOrderBy;
*/

@property (strong, nonatomic) IBOutlet UITextField *searchTextField;
@property (strong, nonatomic) IBOutlet UITextField *searchTypeTextField;
@property (strong, nonatomic) IBOutlet UITextField *searchByStatusTextField;
@property (strong, nonatomic) IBOutlet UITextField *searchStartDateTextField;
@property (strong, nonatomic) IBOutlet UITextField *searchEndDateTextField;

@property (strong, nonatomic) IBOutlet UIPickerView *pickerSearchType;
@property (strong, nonatomic) IBOutlet UIPickerView *pickerSeachStatus;


@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@end
