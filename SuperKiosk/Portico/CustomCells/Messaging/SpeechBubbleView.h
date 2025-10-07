//
//  SpeechBubbleView.h
//  Sharecle
//
//  Created by Romulo on 08/04/14.
//  Copyright (c) 2014 Sharecle Inc. All rights reserved.
//

// The bubble type indicates whether it's a left-hand or right-hand bubble
typedef enum
{
	BubbleTypeLefthand = 0,
	BubbleTypeRighthand,
}
BubbleType;

// A UIView that shows a speech bubble
@interface SpeechBubbleView : UIView 

// Calculates how big the speech bubble needs to be to fit the specified text
+ (CGSize)sizeForTextWithWrapWidth:(NSString*)text width:(CGFloat)width;
+ (CGSize)sizeForText:(NSString*)text;
//+ (CGSize)sizeForMedia:(UIImage*)image;

// Configures the speech bubble
- (void)setText:(NSString*)text bubbleType:(BubbleType)bubbleType;
//- (void)setMedia:(NSData*)media bubbleType:(BubbleType)bubbleType;

@end
