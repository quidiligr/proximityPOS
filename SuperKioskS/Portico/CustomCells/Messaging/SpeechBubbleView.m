//
//  SpeechBubbleView.m
//  Sharecle
//
//  Created by Romulo on 08/04/14.
//  Copyright (c) 2014 Sharecle Inc. All rights reserved.
//

#import "SpeechBubbleView.h"

static UIFont* font = nil;
static UIImage* lefthandImage = nil;
static UIImage* righthandImage = nil;

const CGFloat VertPadding = 4;       // additional padding around the edges
const CGFloat HorzPadding = 4;

const CGFloat TextLeftMargin = 17;   // insets for the text
const CGFloat TextRightMargin = 15;
const CGFloat TextTopMargin = 10;
const CGFloat TextBottomMargin = 11;

const CGFloat MinBubbleWidth = 50;   // minimum width of the bubble
const CGFloat MinBubbleHeight = 40;  // minimum height of the bubble

const CGFloat WrapWidth = 200;       // maximum width of text in the bubble
const CGFloat WrapWidthIpad = 400;

@interface SpeechBubbleView() {
    NSString *_text;
    //NSData *_media;
	BubbleType _bubbleType;
}
@end

@implementation SpeechBubbleView

+ (void)initialize
{
	if (self == [SpeechBubbleView class])
	{
		font = [UIFont systemFontOfSize:[UIFont systemFontSize]];

		lefthandImage = [[UIImage imageNamed:@"BubbleLefthand"]
			stretchableImageWithLeftCapWidth:20 topCapHeight:19];

		righthandImage = [[UIImage imageNamed:@"BubbleRighthand"]
			stretchableImageWithLeftCapWidth:20 topCapHeight:19];
	}
}

+ (CGSize)sizeForText:(NSString*)text
{
	/*CGSize textSize = [text sizeWithFont:font
		constrainedToSize:CGSizeMake(WrapWidth, 9999)
		lineBreakMode:NSLineBreakByWordWrapping]; */
    
    /*CGSize textSize = [text sizeWithFont:font
                       constrainedToSize:CGSizeMake((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)?WrapWidthIpad:WrapWidth, 9999)
    lineBreakMode:NSLineBreakByWordWrapping];
     */
    CGRect textRect = [text boundingRectWithSize:CGSizeMake((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)?WrapWidthIpad:WrapWidth, 9999)
                                         options:NSStringDrawingUsesLineFragmentOrigin
                                      attributes:@{NSFontAttributeName:font}
                                         context:nil];
    CGSize textSize =textRect.size;
   
        
    


	CGSize bubbleSize;
	bubbleSize.width = textSize.width + TextLeftMargin + TextRightMargin;
	bubbleSize.height = textSize.height + TextTopMargin + TextBottomMargin;

	if (bubbleSize.width < MinBubbleWidth)
		bubbleSize.width = MinBubbleWidth;

	if (bubbleSize.height < MinBubbleHeight)
		bubbleSize.height = MinBubbleHeight;

	bubbleSize.width += HorzPadding*2;
	bubbleSize.height += VertPadding*2;

	return bubbleSize;
}

+ (CGSize)sizeForTextWithWrapWidth:(NSString*)text width:(CGFloat)width
{
	/*CGSize textSize = [text sizeWithFont:font
     constrainedToSize:CGSizeMake(WrapWidth, 9999)
     lineBreakMode:NSLineBreakByWordWrapping]; */
    
   /* CGSize textSize = [text sizeWithFont:font
                       constrainedToSize:CGSizeMake(width-120, 9999)
                           lineBreakMode:NSLineBreakByWordWrapping];
    */
    /*CGSize textSize = [text sizeWithFont:font
                       constrainedToSize:CGSizeMake((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)?WrapWidthIpad:WrapWidth, 9999)
                           lineBreakMode:NSLineBreakByWordWrapping];
     */
    CGRect textRect = [text boundingRectWithSize:CGSizeMake((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)?WrapWidthIpad:WrapWidth, 9999)
                                         options:NSStringDrawingUsesLineFragmentOrigin
                                      attributes:@{NSFontAttributeName:font}
                                         context:nil];
    CGSize textSize =textRect.size;
    
	CGSize bubbleSize;
	bubbleSize.width = textSize.width + TextLeftMargin + TextRightMargin;
	bubbleSize.height = textSize.height + TextTopMargin + TextBottomMargin;
    
	if (bubbleSize.width < MinBubbleWidth)
		bubbleSize.width = MinBubbleWidth;
    
	if (bubbleSize.height < MinBubbleHeight)
		bubbleSize.height = MinBubbleHeight;
    
	bubbleSize.width += HorzPadding*2;
	bubbleSize.height += VertPadding*2;
    
	return bubbleSize;
}



//+ (CGSize)sizeForMedia:(UIImage*)image
//{
//	/*CGSize textSize = [text sizeWithFont:font
//     constrainedToSize:CGSizeMake(WrapWidth, 9999)
//     lineBreakMode:NSLineBreakByWordWrapping]; */
//    
//    /*CGSize textSize = [text sizeWithFont:font
//                       constrainedToSize:CGSizeMake(WrapWidth, 9999)
//                           lineBreakMode:NSLineBreakByWordWrapping];*/
//    //UIImage *image=[[UIImage alloc] initWithData:media];
//    
//    CGSize mediaSize = [image size];
//    
//	CGSize bubbleSize;
//	bubbleSize.width = mediaSize.width + TextLeftMargin + TextRightMargin;
//	bubbleSize.height = mediaSize.height + TextTopMargin + TextBottomMargin;
//    
//	if (bubbleSize.width < MinBubbleWidth)
//		bubbleSize.width = MinBubbleWidth;
//    
//	if (bubbleSize.height < MinBubbleHeight)
//		bubbleSize.height = MinBubbleHeight;
//    
//	bubbleSize.width += HorzPadding*2;
//	bubbleSize.height += VertPadding*2;
//    
//	return bubbleSize;
//}


- (void)drawRect:(CGRect)rect
{
	[self.backgroundColor setFill];
	UIRectFill(rect);

	CGRect bubbleRect = CGRectInset(self.bounds, VertPadding, HorzPadding);
    
   /* if (_media) {
        CGRect mediaRect;
        mediaRect.origin.y = bubbleRect.origin.y + TextTopMargin;
        mediaRect.size.width = bubbleRect.size.width - TextLeftMargin - TextRightMargin;
        mediaRect.size.height = bubbleRect.size.height - TextTopMargin - TextBottomMargin;
        
        if (_bubbleType == BubbleTypeLefthand)
        {
            [lefthandImage drawInRect:bubbleRect];
            mediaRect.origin.x = bubbleRect.origin.x + TextLeftMargin;
        }
        else
        {
            [righthandImage drawInRect:bubbleRect];
            mediaRect.origin.x = bubbleRect.origin.x + TextRightMargin;
        }
        
        [[UIColor blackColor] set];
        UIImage *_mediaImage=[[UIImage alloc] initWithData:_media];
        [_mediaImage drawInRect:mediaRect];
        
    }
    else
    {*/
        CGRect textRect;
        textRect.origin.y = bubbleRect.origin.y + TextTopMargin;
        textRect.size.width = bubbleRect.size.width - TextLeftMargin - TextRightMargin;
        textRect.size.height = bubbleRect.size.height - TextTopMargin - TextBottomMargin;

        if (_bubbleType == BubbleTypeLefthand)
        {
            [lefthandImage drawInRect:bubbleRect];
            textRect.origin.x = bubbleRect.origin.x + TextLeftMargin;
        }
        else
        {
            [righthandImage drawInRect:bubbleRect];
            textRect.origin.x = bubbleRect.origin.x + TextRightMargin;
        }

        [[UIColor blackColor] set];
       // [_text drawInRect:textRect withFont:font lineBreakMode:NSLineBreakByWordWrapping];
    NSMutableParagraphStyle *textStyle = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
    textStyle.lineBreakMode = NSLineBreakByWordWrapping;
    //textStyle.alignment = NSTextAlignmentCenter;
    //UIFont *textFont = [UIFont systemFontOfSize:16];
    
    //NSString *text = @"Lorem ipsum";
    
    // iOS 7 way
    [_text drawInRect:textRect withAttributes:@{NSFontAttributeName:font, NSParagraphStyleAttributeName:textStyle}];
    
    // pre iOS 7 way
   /* CGFloat margin = 16;
    CGRect bottomFrame = CGRectMake(0, margin, frame.size.width, frame.size.height - margin);
    [text drawInRect:bottomFrame withFont:textFont lineBreakMode:NSLineBreakByWordWrapping alignment:NSTextAlignmentCenter];*/
    //}
}

- (void)setText:(NSString*)newText bubbleType:(BubbleType)newBubbleType
{
	_text = [newText copy];
	_bubbleType = newBubbleType;
	[self setNeedsDisplay];
}
/*
- (void)setMedia:(NSData*)newMedia bubbleType:(BubbleType)newBubbleType
{
	_media = [newMedia copy];
	_bubbleType = newBubbleType;
	[self setNeedsDisplay];
}
 */
@end
