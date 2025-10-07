//
//  BCScannerViewController.h
//  superkiosk
//
//  Created by Katherine Sheehy on 2/25/16.
//  Copyright © 2016 Sharecle. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol BCScannerViewControllerDelegate;
@interface BCScannerViewController : UIViewController
@property (nonatomic,assign)id<BCScannerViewControllerDelegate> delegate;
@end
@protocol BCScannerViewControllerDelegate <NSObject>

-(void)barcodeController:(BCScannerViewController *)controller didScanWithBarcode:(NSString *)barcode;
//-(void)productManagerViewControllerdidUpdate:(ProductManagerViewController *)viewController;

@end
