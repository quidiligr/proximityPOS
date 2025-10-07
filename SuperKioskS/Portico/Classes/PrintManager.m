//
//  PrintManager.m
//  superkiosks
//
//  Created by Katherine Sheehy on 4/11/16.
//  Copyright © 2016 Sharecle. All rights reserved.
//

#import "PrintManager.h"
#import "OrderHistory.h"
#import <CoreText/CoreText.h>
#import "defs.h"
@implementation PrintManager



+ (PrintManager *)sharedInstance {
    static PrintManager*  _sharedObject;
    
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        _sharedObject = [[PrintManager alloc] init];
        [_sharedObject start];
        
    });
    
    return _sharedObject;
}



-(void)start{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(printOrder:) name:NOTIFY_PRINT_ORDER object:nil];
}

+ (NSData *)PDFData:(NSString *)text//(UITextView *)textView
{
    // Prepare the text using a Core Text Framesetter.
    CFAttributedStringRef currentText = CFAttributedStringCreate(NULL, (CFStringRef)text, NULL);
    
    if (currentText) {
        CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString(currentText);
        if (framesetter) {
            
            /*NSString *pdfFileName = [self getPDFFileName];
            // Create the PDF context using the default page size of 612 x 792.
            UIGraphicsBeginPDFContextToFile(pdfFileName, CGRectZero, nil);
            */
            NSMutableData *pdfData=[[NSMutableData alloc] init];
            UIGraphicsBeginPDFContextToData(pdfData, CGRectZero, nil);
            
            CFRange currentRange = CFRangeMake(0, 0);
            NSInteger currentPage = 0;
            BOOL done = NO;
            
            do {
                // Mark the beginning of a new page.
                UIGraphicsBeginPDFPageWithInfo(CGRectMake(0, 0, 612, 792), nil);
                
                // Draw a page number at the bottom of each page.
                currentPage++;
                [PrintManager drawPageNumber:currentPage];
                
                // Render the current page and update the current range to
                // point to the beginning of the next page.
               // currentRange = [PrintManager renderPageWithTextRange:currentRange andFramesetter:framesetter];
                
                currentRange=[PrintManager renderPage:currentPage withTextRange:currentRange andFramesetter:framesetter];
                // If we're at the end of the text, exit the loop.
                if (currentRange.location == CFAttributedStringGetLength((CFAttributedStringRef)currentText))
                    done = YES;
            } while (!done);
            
            // Close the PDF context and write the contents out.
            UIGraphicsEndPDFContext();
            
            // Release the framewetter.
            CFRelease(framesetter);
            return pdfData;
            
        } else {
            NSLog(@"Could not create the framesetter needed to lay out the atrributed string.");
        }
        // Release the attributed string.
        CFRelease(currentText);
    } else {
        NSLog(@"Could not create the attributed string for the framesetter");
    }
    return nil;
}

// Use Core Text to draw the text in a frame on the page.
+ (CFRange)renderPage:(NSInteger)pageNum withTextRange:(CFRange)currentRange
       andFramesetter:(CTFramesetterRef)framesetter
{
    // Get the graphics context.
    CGContextRef    currentContext = UIGraphicsGetCurrentContext();
    
    // Put the text matrix into a known state. This ensures
    // that no old scaling factors are left in place.
    CGContextSetTextMatrix(currentContext, CGAffineTransformIdentity);
    
    // Create a path object to enclose the text. Use 72 point
    // margins all around the text.
    CGRect    frameRect = CGRectMake(72, 72, 468, 648);
    CGMutablePathRef framePath = CGPathCreateMutable();
    CGPathAddRect(framePath, NULL, frameRect);
    
    // Get the frame that will do the rendering.
    // The currentRange variable specifies only the starting point. The framesetter
    // lays out as much text as will fit into the frame.
    CTFrameRef frameRef = CTFramesetterCreateFrame(framesetter, currentRange, framePath, NULL);
    CGPathRelease(framePath);
    
    // Core Text draws from the bottom-left corner up, so flip
    // the current transform prior to drawing.
    CGContextTranslateCTM(currentContext, 0, 792);
    CGContextScaleCTM(currentContext, 1.0, -1.0);
    
    // Draw the frame.
    CTFrameDraw(frameRef, currentContext);
    
    // Update the current range based on what was drawn.
    currentRange = CTFrameGetVisibleStringRange(frameRef);
    currentRange.location += currentRange.length;
    currentRange.length = 0;
    CFRelease(frameRef);
    
    return currentRange;
}

+ (void)drawPageNumber:(NSInteger)pageNum
{
    NSString *pageString = [NSString stringWithFormat:@"Page %ld", (long)pageNum];
    UIFont *theFont = [UIFont systemFontOfSize:12];
    CGSize maxSize = CGSizeMake(612, 72);
    /* deprecated
    CGSize pageStringSize = [pageString sizeWithFont:theFont
                                   constrainedToSize:maxSize
                                       lineBreakMode:UILineBreakModeClip];
     CGRect stringRect = CGRectMake(((612.0 - pageStringSize.width) / 2.0),
     720.0 + ((72.0 - pageStringSize.height) / 2.0),
     pageStringSize.width,
     pageStringSize.height);

     [pageString drawInRect:stringRect withFont:theFont];

     */
   CGRect pageStringSize = [pageString boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:theFont} context:nil];
    CGRect stringRect = CGRectMake(((612.0 - pageStringSize.size.width) / 2.0),
                                   720.0 + ((72.0 - pageStringSize.size.height) / 2.0),
                                   pageStringSize.size.width,
                                   pageStringSize.size.height);

    NSMutableParagraphStyle *p=[[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    p.lineBreakMode=NSLineBreakByWordWrapping;
    [pageString drawInRect:stringRect withAttributes:@{NSFontAttributeName:theFont, NSParagraphStyleAttributeName:p}];

    }

/*
+ (void)savePDFFile:(UITextView *)textView
{
    // Prepare the text using a Core Text Framesetter.
    CFAttributedStringRef currentText = CFAttributedStringCreate(NULL, (CFStringRef)textView.text, NULL);
    if (currentText) {
        CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString(currentText);
        if (framesetter) {
            
            NSString *pdfFileName = [self getPDFFileName];
            // Create the PDF context using the default page size of 612 x 792.
            UIGraphicsBeginPDFContextToFile(pdfFileName, CGRectZero, nil);
            
            CFRange currentRange = CFRangeMake(0, 0);
            NSInteger currentPage = 0;
            BOOL done = NO;
            
            do {
                // Mark the beginning of a new page.
                UIGraphicsBeginPDFPageWithInfo(CGRectMake(0, 0, 612, 792), nil);
                
                // Draw a page number at the bottom of each page.
                currentPage++;
                [self drawPageNumber:currentPage];
                
                // Render the current page and update the current range to
                // point to the beginning of the next page.
                currentRange = [self renderPageWithTextRange:currentRange andFramesetter:framesetter];
                
                // If we're at the end of the text, exit the loop.
                if (currentRange.location == CFAttributedStringGetLength((CFAttributedStringRef)currentText))
                    done = YES;
            } while (!done);
            
            // Close the PDF context and write the contents out.
            UIGraphicsEndPDFContext();
            
            // Release the framewetter.
            CFRelease(framesetter);
            
        } else {
            NSLog(@"Could not create the framesetter needed to lay out the atrributed string.");
        }
        // Release the attributed string.
        CFRelease(currentText);
    } else {
        NSLog(@"Could not create the attributed string for the framesetter");
    }
}
 */

-(void)printOrder:(NSNotification *)notification
    {
        OrderHistory *order=[notification.userInfo valueForKey:@"order"];
        if(order==nil)
            return;
        
        //[self setOrderStatus:ORDER_STATUS_CAPTURED];
        /* NSData *pdfData=[PrintManager PDFData:[selectedOrder toStringLabel]];
         
         if ([UIPrintInteractionController canPrintData:pdfData]) {
         UIPrintInfo *printInfo = [UIPrintInfo printInfo];
         //printInfo.jobName = self.imageURL.lastPathComponent;
         printInfo.outputType = UIPrintInfoOutputGeneral;
         
         UIPrintInteractionController *printController = [UIPrintInteractionController sharedPrintController];
         printController.printInfo = printInfo;
         
         printController.printingItem = pdfData;//self.imageURL;
         
         //[printController presentAnimated:true completionHandler: nil];
         if(_appDelegate.isIpad){
         [printController presentFromRect:self.view.frame inView:self.view animated:YES completionHandler:nil];
         }
         
         }
         */
        if(_selectedPrinter==nil)
            return;
        
        if(![UIPrintInteractionController isPrintingAvailable])
            return;
        
        UIPrintInteractionController *pic = [UIPrintInteractionController sharedPrintController];
        pic.delegate = self;
        
        UIPrintInfo *printInfo = [UIPrintInfo printInfo];
        printInfo.outputType = UIPrintInfoOutputGeneral;
        printInfo.jobName = @"Receipt";
        pic.printInfo = printInfo;
        
        NSString *msgBody = [order toStringReceipt];
        
        
        UISimpleTextPrintFormatter *textFormatter = [[UISimpleTextPrintFormatter alloc]
                                                     initWithText:msgBody];
        textFormatter.startPage = 0;
        CGFloat margin=18.0;
        //textFormatter.contentInsets = UIEdgeInsetsMake(72.0, 72.0, 72.0, 72.0); // 1 inch margins
        textFormatter.contentInsets = UIEdgeInsetsMake(margin, margin, margin, margin); // 1/4 inch margins
        textFormatter.maximumContentWidth = 6 * margin;
        pic.printFormatter = textFormatter;
        pic.showsPageRange = NO;
        
        
        void (^completionHandler)(UIPrintInteractionController *, BOOL, NSError *) =
        ^(UIPrintInteractionController *printController, BOOL completed, NSError *error) {
            if (!completed && error) {
                NSLog(@"Printing could not complete because of error: %@", error);
            }
        };
        
        if(_selectedPrinter!=nil){
            [pic printToPrinter:_selectedPrinter completionHandler:completionHandler];
        }
        else{
            if([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
                AppDelegate *_appDelegate=ApplicationDelegate;
               /* [pic presentFromRect: _appDelegate.window.rootViewController.view.frame//self. view.frame
                              inView:_appDelegate.window.rootViewController.view//self.view
                            animated:YES
                   completionHandler:completionHandler];
                */
                
                //CGRect frame=_appDelegate.window.rootViewController.view.frame;
                    [pic presentFromRect: CGRectMake(10, 10, 100, 100)
                              inView:_appDelegate.window.rootViewController.view//self.view
                            animated:YES
                   completionHandler:completionHandler];
                
            }
            else {
                [pic presentAnimated:YES completionHandler:completionHandler];
                
            }
        }
        
    
}

-(void)printBarcode:(UIImage *)image fromView:(UIView *)view
{
   // Product *prod=[notification.userInfo valueForKey:@"product"];
    
    //if(prod==nil)
        //return;
    if(image==nil)
        return;
    if(view==nil)
        return;
    CGSize size=image.size;
    UIImage *scaledImage;
    if (size.height>27) {
        scaledImage=[AppDelegate imageWithImage:image scaledToSize:CGSizeMake(72, 27)];
    }
    else{
        scaledImage=image;
    }
    //[self setOrderStatus:ORDER_STATUS_CAPTURED];
    /* NSData *pdfData=[PrintManager PDFData:[selectedOrder toStringLabel]];
     
     if ([UIPrintInteractionController canPrintData:pdfData]) {
     UIPrintInfo *printInfo = [UIPrintInfo printInfo];
     //printInfo.jobName = self.imageURL.lastPathComponent;
     printInfo.outputType = UIPrintInfoOutputGeneral;
     
     UIPrintInteractionController *printController = [UIPrintInteractionController sharedPrintController];
     printController.printInfo = printInfo;
     
     printController.printingItem = pdfData;//self.imageURL;
     
     //[printController presentAnimated:true completionHandler: nil];
     if(_appDelegate.isIpad){
     [printController presentFromRect:self.view.frame inView:self.view animated:YES completionHandler:nil];
     }
     
     }
     */
    //if(_selectedPrinter==nil)
       // return;
    
    if(![UIPrintInteractionController isPrintingAvailable])
        return;
    
    UIPrintInteractionController *pic = [UIPrintInteractionController sharedPrintController];
    pic.delegate = self;
    
    UIPrintInfo *printInfo = [UIPrintInfo printInfo];
    printInfo.outputType = UIPrintInfoOutputGrayscale;
    printInfo.jobName = @"Barcode";
    //printInfo.printerID
    pic.printInfo = printInfo;
    
    
    /*NSString *msgBody = [order toStringReceipt];
    
    
    UISimpleTextPrintFormatter *textFormatter = [[UISimpleTextPrintFormatter alloc]
                                                 initWithText:msgBody];
    textFormatter.startPage = 0;
     
    CGFloat margin=18.0;
    //textFormatter.contentInsets = UIEdgeInsetsMake(72.0, 72.0, 72.0, 72.0); // 1 inch margins
    textFormatter.contentInsets = UIEdgeInsetsMake(margin, margin, margin, margin); // 1/4 inch margins
    textFormatter.maximumContentWidth = 6 * margin;
    //pic.printFormatter = textFormatter;
    */
    pic.printingItem=scaledImage;
     pic.showsPageRange = NO;
    //return;
    
    
    void (^completionHandler)(UIPrintInteractionController *, BOOL, NSError *) =
    ^(UIPrintInteractionController *printController, BOOL completed, NSError *error) {
        if (!completed && error) {
            NSLog(@"Printing could not complete because of error: %@", error);
        }
    };
    
    if(_selectedBcPrinter!=nil){
        [pic printToPrinter:_selectedBcPrinter completionHandler:completionHandler];
    }
    else{
        /*
        if([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
            AppDelegate *_appDelegate=ApplicationDelegate;
            [pic presentFromRect: CGRectMake(10, 10, 100, 100)
                          inView:_appDelegate.window.rootViewController.view//self.view
                        animated:YES
               completionHandler:completionHandler];
            
        }
        else {
            [pic presentAnimated:YES completionHandler:completionHandler];
            
        }
         */
        [self selectBcPrinter:view];
    
    }
    
    
}


-(void)selectPrinter:(UIView *)fromView{
    UIPrinterPickerController *printPicker = [UIPrinterPickerController printerPickerControllerWithInitiallySelectedPrinter:_selectedPrinter];
    
    void (^completionHandler)(UIPrinterPickerController *, BOOL, NSError *) =
    ^(UIPrinterPickerController *printerPicker, BOOL userDidSelect, NSError *error) {
        
        if (userDidSelect) {
            _selectedPrinter = printerPicker.selectedPrinter;
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_PRINTER_SELECTED object:nil];
        }
    };

    if([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        //AppDelegate *_appDelegate=ApplicationDelegate;
        
        [printPicker presentFromRect: CGRectMake(10, 10, 100, 100)
                      inView:fromView//self.view
                    animated:YES
           completionHandler:completionHandler];
    }
    else {
        [printPicker presentAnimated:YES completionHandler:completionHandler];
        
    }
   /* [printPicker presentAnimated:YES completionHandler:
     ^(UIPrinterPickerController *printerPicker, BOOL userDidSelect, NSError *error) {
         
         if (userDidSelect) {
             _selectedPrinter = printerPicker.selectedPrinter;
         }
     }];
*/
}

-(void)selectBcPrinter:(UIView *)fromView{
    UIPrinterPickerController *printPicker = [UIPrinterPickerController printerPickerControllerWithInitiallySelectedPrinter:_selectedBcPrinter];
    
    void (^completionHandler)(UIPrinterPickerController *, BOOL, NSError *) =
    ^(UIPrinterPickerController *printerPicker, BOOL userDidSelect, NSError *error) {
        
        if (userDidSelect) {
            _selectedBcPrinter = printerPicker.selectedPrinter;
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_BCPRINTER_SELECTED object:nil];
        }
    };
    
    if([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        //AppDelegate *_appDelegate=ApplicationDelegate;
        
        [printPicker presentFromRect: CGRectMake(10, 10, 100, 100)
                              inView:fromView//self.view
                            animated:YES
                   completionHandler:completionHandler];
    }
    else {
        [printPicker presentAnimated:YES completionHandler:completionHandler];
        
    }
    /* [printPicker presentAnimated:YES completionHandler:
     ^(UIPrinterPickerController *printerPicker, BOOL userDidSelect, NSError *error) {
     
     if (userDidSelect) {
     _selectedPrinter = printerPicker.selectedPrinter;
     }
     }];
     */
}

-(UIPrintPaper *)printInteractionController:(UIPrintInteractionController *)printInteractionController choosePaper:(NSArray<UIPrintPaper *> *)paperList{
    
    UIPrintPaper *paper=[UIPrintPaper bestPaperForPageSize:CGSizeMake(216, 216) withPapersFromArray:paperList];
    
    //printInteractionController.printingItem
   // UIPrintPaper *paper;
    /*
    for(UIPrintPaper *p in paperList){
        //we select the smallest paper size
        //NSLog(@"paperSize:%@ %@",@(p.paperSize.width),@(p.paperSize.height));
        if(paper==nil){
            paper=p;
        }
        else{
            if(p.paperSize.width<paper.paperSize.width){
                paper=p;
            }
        }
    }
     */
    
    //UIPrintPaper *paper=[paperList objectAtIndex:0];
    return paper;
    
}

@end
