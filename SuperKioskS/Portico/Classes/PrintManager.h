//
//  PrintManager.h
//  superkiosks
//
//  Created by Katherine Sheehy on 4/11/16.
//  Copyright © 2016 Sharecle. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PrintManager : NSObject<UIPrintInteractionControllerDelegate>
+ (NSData *)PDFData:(NSString *)text;
+ (PrintManager *)sharedInstance ;
@property(nonatomic,strong) UIPrinter *selectedPrinter;
@property(nonatomic,strong) UIPrinter *selectedBcPrinter;
-(void)selectPrinter:(UIView *)fromView;
-(void)printBarcode:(UIImage *)image fromView:(UIView *)view;
@end
