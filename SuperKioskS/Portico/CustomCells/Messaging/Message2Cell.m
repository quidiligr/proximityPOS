//
//  MessageTableViewCell.m
//  Sharecle
//
//  Created by Romulo on 08/04/14.
//  Copyright (c) 2014 Sharecle Inc. All rights reserved.
//

#import "Message2Cell.h"
//#import "Message.h"
#import "SpeechBubbleView.h"
//#import "ContactMessage.h"
//#import "BroadcastMessageAPI.h"
#import "MessageTableViewData.h"


static UIColor* color = nil;
static CGFloat marginLeft=10.0;
//static CGFloat marginTop=10.0;
@interface Message2Cell() {
    SpeechBubbleView *_bubbleView;
	UILabel *_label;
    UIImageView *_image;
     UIImageView *_image2;
    //UIImageView *_imageAttach;
}
@end

@implementation Message2Cell

+ (void)initialize
{
	if (self == [Message2Cell class])
	{
		color =[UIColor clearColor]; //[UIColor colorWithRed:219/255.0 green:226/255.0 blue:237/255.0 alpha:1.0];
	}
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)reuseIdentifier
{
	if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]))
	{
		self.selectionStyle = UITableViewCellSelectionStyleNone;

		// Create the speech bubble view
		_bubbleView = [[SpeechBubbleView alloc] initWithFrame:CGRectZero];
		_bubbleView.backgroundColor = color;
		_bubbleView.opaque = YES;
		_bubbleView.clearsContextBeforeDrawing = NO;
		_bubbleView.contentMode = UIViewContentModeRedraw;
		//_bubbleView.autoresizingMask = 0;
        _bubbleView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		[self.contentView addSubview:_bubbleView];

		// Create the label
		_label = [[UILabel alloc] initWithFrame:CGRectZero];
		_label.backgroundColor = color;
		_label.opaque = YES;
		_label.clearsContextBeforeDrawing = NO;
		_label.contentMode = UIViewContentModeRedraw;
		_label.autoresizingMask = 0;
		_label.font = [UIFont systemFontOfSize:13];
		_label.textColor = [UIColor colorWithRed:64/255.0 green:64/255.0 blue:64/255.0 alpha:1.0];
		[self.contentView addSubview:_label];
        
        _image=[[UIImageView alloc] initWithFrame:CGRectMake(0,0,60,60)];
        _image.autoresizingMask=UIViewAutoresizingFlexibleLeftMargin;
        [self.contentView addSubview:_image];
        
        _image2=[[UIImageView alloc] initWithFrame:CGRectMake(0,0,60,60)];
        _image2.autoresizingMask=UIViewAutoresizingFlexibleLeftMargin;
        [self.contentView addSubview:_image2];

        
        //_imageAttach=[[UIImageView alloc] initWithFrame:CGRectMake(0,0,120,120)];
        //[self.contentView addSubview:_imageAttach];
	}
	return self;
}

- (void)layoutSubviews
{
	// This is a little trick to set the background color of a table view cell.
	[super layoutSubviews];
	self.backgroundColor = color;
}
- (void)setMessage:(MessageTableViewData*)message{
    
    //CGFloat marginH=10.0;
    BOOL isPrivate=message.isPrivate;
    
	CGPoint point = CGPointZero;
    //CGPoint pointPhoto = CGPointZero;
    CGRect rectPhoto=_image.frame;
    CGRect rectPhoto2=_image2.frame;
    
    CGSize bubbleSize = [SpeechBubbleView sizeForTextWithWrapWidth:message.text width:self.bounds.size.width];
    
    
	// We display messages that are sent by the user on the right-hand side of
	// the screen. Incoming messages are displayed on the left-hand side.
	NSString* senderName;
	BubbleType bubbleType;
	//if ([message isSentByUser])
    _image.image=message.senderPhoto;
    _image2.image=message.recipientPhoto;
    if ([message.userid longValue]==[message.senderid longValue])
	{
		bubbleType = BubbleTypeRighthand;
		senderName = NSLocalizedString(@"You", nil);
        
        
		//point.x = self.bounds.size.width - ([message.bubbleSizewidth floatValue]+_image.frame.size.width) - marginLeft;
        point.x = self.bounds.size.width - (bubbleSize.width+_image.frame.size.width) - marginLeft;
		
        //position the photo
        //pointPhoto.x=self.bounds.size.width -_image.frame.size.width;
        //rectPhoto=_image.frame;
        rectPhoto.origin.x=self.bounds.size.width -_image.frame.size.width -marginLeft;
        //_image.frame=rectPhoto;
        rectPhoto2.origin=CGPointMake(marginLeft, 0); //CGPointZero;
        
        _label.textAlignment = NSTextAlignmentRight;
       
        
        
       
            }
	else
	{
		bubbleType = BubbleTypeLefthand;
		senderName = message.sendernickname;
        point.x = _image.frame.size.width+marginLeft;
        
        rectPhoto.origin=CGPointMake(marginLeft, 0); //CGPointZero;
        
        rectPhoto2.origin.x=self.bounds.size.width -_image2.frame.size.width -marginLeft;
        
        _label.textAlignment = NSTextAlignmentLeft;

		
        	}

    _image.frame=rectPhoto;
     _image2.frame=rectPhoto2;


    //rounded image
    _image.layer.cornerRadius=_image.frame.size.width / 2;
    _image.clipsToBounds = YES;
    
    _image2.layer.cornerRadius=_image2.frame.size.width / 2;
    _image2.clipsToBounds = YES;
    

	// Resize the bubble view and tell it to display the message text
	CGRect rect;
	rect.origin = point;
    //CGSize message_bubbleSize;
    //message_bubbleSize.height=[message.bubbleSizeheight floatValue];
    //message_bubbleSize.width=[message.bubbleSizewidth floatValue];
    
    
	//rect.size = message_bubbleSize;
    //rect.size = CGSizeMake([message.bubbleSizewidth floatValue], [message.bubbleSizeheight floatValue]);//  message_bubbleSize;
    
    rect.size = CGSizeMake(bubbleSize.width, bubbleSize.height);//  message_bubbleSize;

	_bubbleView.frame = rect;
	[_bubbleView setText:message.text bubbleType:bubbleType];

    
    
    
    
	// Format the message date
	NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
	[formatter setDateStyle:NSDateFormatterShortStyle];
	[formatter setTimeStyle:NSDateFormatterShortStyle];
	[formatter setDoesRelativeDateFormatting:YES];
	NSString* dateString = [formatter stringFromDate:message.createdon];

	// Set the sender's name and date on the label
    if (isPrivate==YES)
        _label.text = [NSString stringWithFormat:@"%@", dateString];
    else
        _label.text = [NSString stringWithFormat:@"%@ @ %@", senderName, dateString];
	[_label sizeToFit];
     //_label.frame = CGRectMake(8, message.bubbleSize.height, self.contentView.bounds.size.width - 16, 16);
    if ([message.userid longValue]==[message.senderid longValue])
        _label.frame = CGRectMake(0, [message.bubbleSizeheight floatValue], self.contentView.bounds.size.width - _image.frame.size.width, 16);
    
    else
       _label.frame = CGRectMake(_image.frame.size.width, [message.bubbleSizeheight floatValue], self.contentView.bounds.size.width - 16, 16);
}
/*
- (void)setBroadcastMessage:(BroadcastMessageAPI*)message myPhoto:(UIImage*)myPhoto otherPhoto:(UIImage*)otherPhoto
{
	CGPoint point = CGPointZero;
    //CGPoint pointPhoto = CGPointZero;
    CGRect rectPhoto=_image.frame;
    
	// We display messages that are sent by the user on the right-hand side of
	// the screen. Incoming messages are displayed on the left-hand side.
	NSString* senderName;
	BubbleType bubbleType;
	//if ([message isSentByUser])
    //BroadcastMessage* message = (_messages)[indexPath.row];
	
    CGSize bubbleSize = [SpeechBubbleView sizeForText:message.text];
    message.bubbleSizeheight=[NSNumber numberWithFloat:bubbleSize.height];
    message.bubbleSizewidth=[NSNumber numberWithFloat:bubbleSize.width];
    
	
  //  return [message.bubbleSizeheight floatValue] + 16;

    
    if ([message.userid longValue]==[message.senderid longValue])
	{
		bubbleType = BubbleTypeRighthand;
		senderName = NSLocalizedString(@"You", nil);
        
        
        point.x = self.bounds.size.width - ([message.bubbleSizewidth floatValue]+_image.frame.size.width);
		
        //position the photo
        //pointPhoto.x=self.bounds.size.width -_image.frame.size.width;
        //rectPhoto=_image.frame;
        rectPhoto.origin.x=self.bounds.size.width -_image.frame.size.width;
        //_image.frame=rectPhoto;
        
        _label.textAlignment = NSTextAlignmentLeft;
        _image.image=myPhoto;
        
        
        
    }
	else
	{
		bubbleType = BubbleTypeLefthand;
		senderName = message.sendernickname;
        point.x = _image.frame.size.width;
        
        rectPhoto.origin=CGPointZero;
        //_image.frame=rectPhoto;
        
		_label.textAlignment = NSTextAlignmentRight;
        _image.image=otherPhoto;
	}
    
    _image.frame=rectPhoto;
    
    
    //rounded image
    _image.layer.cornerRadius=_image.frame.size.width / 2;
    _image.clipsToBounds = YES;
    
    
	// Resize the bubble view and tell it to display the message text
	CGRect rect;
	rect.origin = point;
    //CGSize message_bubbleSize;
    //message_bubbleSize.height=[message.bubbleSizeheight floatValue];
    //message_bubbleSize.width=[message.bubbleSizewidth floatValue];
    
    
	//rect.size = message_bubbleSize;
    rect.size = CGSizeMake([message.bubbleSizewidth floatValue], [message.bubbleSizeheight floatValue]);//  message_bubbleSize;
    
    
	_bubbleView.frame = rect;
	[_bubbleView setText:message.text bubbleType:bubbleType];
    
    
    
    
    
	// Format the message date
	NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
	[formatter setDateStyle:NSDateFormatterShortStyle];
	[formatter setTimeStyle:NSDateFormatterShortStyle];
	[formatter setDoesRelativeDateFormatting:YES];
	NSString* dateString = [formatter stringFromDate:message.createdon];
    
	// Set the sender's name and date on the label
	_label.text = [NSString stringWithFormat:@"%@ @ %@", senderName, dateString];
	[_label sizeToFit];
    //_label.frame = CGRectMake(8, message.bubbleSize.height, self.contentView.bounds.size.width - 16, 16);
    _label.frame = CGRectMake(8, [message.bubbleSizeheight floatValue], self.contentView.bounds.size.width - 16, 16);
}


- (void)setBroadcastMessageWithMedia:(BroadcastMessageAPI*)message myPhoto:(UIImage*)myPhoto otherPhoto:(UIImage*)otherPhoto mediaImage:(UIImage*)mediaImage
{
	CGPoint point = CGPointZero;
    //CGPoint pointPhoto = CGPointZero;
    CGRect rectPhoto=_image.frame;
    
	// We display messages that are sent by the user on the right-hand side of
	// the screen. Incoming messages are displayed on the left-hand side.
	NSString* senderName;
	BubbleType bubbleType;
	//if ([message isSentByUser])
    //BroadcastMessage* message = (_messages)[indexPath.row];
	
    
    
    CGSize bubbleSize = [SpeechBubbleView sizeForMedia:mediaImage];
    message.bubbleSizeheight=[NSNumber numberWithFloat:bubbleSize.height];
    message.bubbleSizewidth=[NSNumber numberWithFloat:bubbleSize.width];
    
	
    //  return [message.bubbleSizeheight floatValue] + 16;
    
    
    if ([message.userid longValue]==[message.senderid longValue])
	{
		bubbleType = BubbleTypeRighthand;
		senderName = NSLocalizedString(@"You", nil);
        
        
		point.x = self.bounds.size.width - ([message.bubbleSizewidth floatValue]+_image.frame.size.width);
		
        //position the photo
        //pointPhoto.x=self.bounds.size.width -_image.frame.size.width;
        //rectPhoto=_image.frame;
        rectPhoto.origin.x=self.bounds.size.width -_image.frame.size.width;
        //_image.frame=rectPhoto;
        
        _label.textAlignment = NSTextAlignmentLeft;
        _image.image=myPhoto;
        
        
        
    }
	else
	{
		bubbleType = BubbleTypeLefthand;
		senderName = message.sendernickname;
        point.x = _image.frame.size.width;
        
        rectPhoto.origin=CGPointZero;
        //_image.frame=rectPhoto;
        
		_label.textAlignment = NSTextAlignmentRight;
        _image.image=otherPhoto;
	}
    
    _image.frame=rectPhoto;
    
    
    //rounded image
    _image.layer.cornerRadius=_image.frame.size.width / 2;
    _image.clipsToBounds = YES;
    
    
	// Resize the bubble view and tell it to display the message text
	CGRect rect;
	rect.origin = point;
    //CGSize message_bubbleSize;
    //message_bubbleSize.height=[message.bubbleSizeheight floatValue];
    //message_bubbleSize.width=[message.bubbleSizewidth floatValue];
    
    
	//rect.size = message_bubbleSize;
    rect.size = CGSizeMake([message.bubbleSizewidth floatValue], [message.bubbleSizeheight floatValue]);//  message_bubbleSize;
    
    
	_bubbleView.frame = rect;
	[_bubbleView setText:message.text bubbleType:bubbleType];
    
    
    
    
    
	// Format the message date
	NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
	[formatter setDateStyle:NSDateFormatterShortStyle];
	[formatter setTimeStyle:NSDateFormatterShortStyle];
	[formatter setDoesRelativeDateFormatting:YES];
	NSString* dateString = [formatter stringFromDate:message.createdon];
    
	// Set the sender's name and date on the label
	_label.text = [NSString stringWithFormat:@"%@ @ %@", senderName, dateString];
	[_label sizeToFit];
    //_label.frame = CGRectMake(8, message.bubbleSize.height, self.contentView.bounds.size.width - 16, 16);
    _label.frame = CGRectMake(8, [message.bubbleSizeheight floatValue], self.contentView.bounds.size.width - 16, 16);
}
*/

@end
