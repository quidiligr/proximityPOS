//
//  MessageTableViewCell.m
//  Sharecle
//
//  Created by Romulo on 08/04/14.
//  Copyright (c) 2014 Sharecle Inc. All rights reserved.
//

#import "MessageNBCell.h"
//#import "Message.h"
#import "SpeechBubbleView.h"
//#import "ContactMessage.h"
//#import "BroadcastMessageAPI.h"
#import "MessageTableViewData.h"
#import "defs.h"


static UIColor* color = nil;
static CGFloat marginLeft=10.0;
//static CGFloat marginTop=10.0;
@interface MessageNBCell() {
    //SpeechBubbleView *_bubbleView;
	UILabel *_label;
    UILabel  *_label_message;
    UILabel  *_label_date;
    //UIImageView *_image;
    UIActivityIndicatorView *activityIndicator;
    //UIImageView *_imageAttach;
    UIImageView *_image_background;
}
@end

@implementation MessageNBCell

+ (void)initialize
{
	if (self == [MessageNBCell class])
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
/*		_bubbleView = [[SpeechBubbleView alloc] initWithFrame:CGRectZero];
		_bubbleView.backgroundColor = color;
		_bubbleView.opaque = YES;
		_bubbleView.clearsContextBeforeDrawing = NO;
		_bubbleView.contentMode = UIViewContentModeRedraw;
		_bubbleView.autoresizingMask = 0;
       
		[self.contentView addSubview:_bubbleView];
*/
        //crate background
        /*UIImage *background =[UIImage imageNamed:@"cell_middle.png"];
        _image_background=[[UIImageView alloc] initWithImage:background];
         
        _image_background.frame=self.contentView.frame;*/
        _image_background=[[UIImageView alloc] initWithFrame:self.contentView.frame];
        _image_background.backgroundColor=[UIColor whiteColor];
        [self.contentView addSubview:_image_background];
        
        // Create the message label
        _label_message = [[UILabel alloc] initWithFrame:CGRectZero];
        _label_message.backgroundColor = color;
        _label_message.opaque = YES;
        _label_message.clearsContextBeforeDrawing = NO;
        _label_message.contentMode = UIViewContentModeRedraw;
        _label.autoresizingMask = 0;
        _label_message.font = [UIFont systemFontOfSize:15];
        _label_message.textColor = [UIColor colorWithRed:64/255.0 green:64/255.0 blue:64/255.0 alpha:1.0];
        [self.contentView addSubview:_label_message];
        
		// Create the label
		_label = [[UILabel alloc] initWithFrame:CGRectZero];
		_label.backgroundColor = color;
		_label.opaque = YES;
		_label.clearsContextBeforeDrawing = NO;
		_label.contentMode = UIViewContentModeRedraw;
		_label.autoresizingMask = 0;
		_label.font = [UIFont systemFontOfSize:17];
		_label.textColor = [UIColor colorWithRed:64/255.0 green:64/255.0 blue:64/255.0 alpha:1.0];
		[self.contentView addSubview:_label];
        
        // Create the label date
        _label_date = [[UILabel alloc] initWithFrame:CGRectZero];
        _label_date.backgroundColor = color;
        _label_date.opaque = YES;
        _label_date.clearsContextBeforeDrawing = NO;
        _label_date.contentMode = UIViewContentModeRedraw;
        _label_date.autoresizingMask = 0;
        _label_date.font = [UIFont systemFontOfSize:14];
        _label_date.textColor = [UIColor colorWithRed:64/255.0 green:64/255.0 blue:64/255.0 alpha:1.0];
        [self.contentView addSubview:_label_date];

        
        /*activityIndicator =
        [[UIActivityIndicatorView alloc]
         initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
       */
        //[cell addSubview:activityIndicator];
        //[activityIndicator release];
        

        
        
        _photo=[[UIImageView alloc] initWithFrame:CGRectMake(0,0,CELL_PHOTO_WIDTH,CELL_PHOTO_HEIGHT)];
      //  _photo.autoresizingMask=UIViewAutoresizingFlexibleLeftMargin;
       // [_photo setHidden:YES];
        
         //activityIndicator.center = _photo.center;
        //[self.contentView addSubview:activityIndicator];
        //[activityIndicator startAnimating];
        [self.contentView addSubview:_photo];
        
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
    //BOOL isPrivate=message.isPrivate;
    //CGFloat marginH=10.0;
    
	CGPoint point = CGPointZero;
    //CGPoint pointPhoto = CGPointZero;
    CGRect rectPhoto=_photo.frame;
    CGSize bubbleSize = [SpeechBubbleView sizeForText:message.text];
    
    
	// We display messages that are sent by the user on the right-hand side of
	// the screen. Incoming messages are displayed on the left-hand side.
	NSString* senderName;
	//BubbleType bubbleType;
	//if ([message isSentByUser])
    _photo.image=message.senderPhoto;
   // if ([message.userid longValue]==[message.senderid longValue])
    //if([message.userid isEqualToNumber:message.senderid])
//    if([message.deviceID isEqualToString:message.peer_deviceID])
//	{
//		bubbleType = BubbleTypeRighthand;
//		senderName = NSLocalizedString(@"You", nil);
//        
//        
//	//	point.x = self.bounds.size.width - [message.bubbleSizewidth floatValue] - marginLeft;
//        point.x = ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)?TABLE_CELL_WIDTH_IPAD :self.bounds.size.width ) - [message.bubbleSizewidth floatValue] -_photo.frame.size.width- marginLeft;
//        
//        //point.x = self.bounds.size.width - (bubbleSize.width+_photo.frame.size.width) - marginLeft;
//		
//        //position the photo
//        //pointPhoto.x=self.bounds.size.width -_image.frame.size.width;
//        //rectPhoto=_image.frame;
//        //rectPhoto.origin.x=self.bounds.size.width -_photo.frame.size.width -marginLeft;
//        rectPhoto.origin.x=((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)?TABLE_CELL_WIDTH_IPAD :self.bounds.size.width )  -_photo.frame.size.width -marginLeft;
//        //_image.frame=rectPhoto;
//      //  NSLog(@"%f",self.contentView.bounds.size.width);
//
//        _label.textAlignment = NSTextAlignmentRight;
//       
//        
//        
//       
//            }
//	else
//	{
	//	bubbleType = BubbleTypeLefthand;
		senderName = message.sender;
        point.x = _photo.frame.size.width+marginLeft;
        
        rectPhoto.origin=CGPointMake(marginLeft, 0); //CGPointZero;
        //_image.frame=rectPhoto;
        _label.textAlignment = NSTextAlignmentLeft;

		
       // 	}

    _photo.frame=rectPhoto;


    //rounded image
    _photo.layer.cornerRadius=_photo.frame.size.width / 2;
    _photo.clipsToBounds = YES;
    

	// Resize the bubble view and tell it to display the message text
	CGRect rect;
    point.y=_photo.frame.size.height;
    point.x=10;
	rect.origin = point;
    //CGSize message_bubbleSize;
    //message_bubbleSize.height=[message.bubbleSizeheight floatValue];
    //message_bubbleSize.width=[message.bubbleSizewidth floatValue];
    
    
	//rect.size = message_bubbleSize;
    //rect.size = CGSizeMake([message.bubbleSizewidth floatValue], [message.bubbleSizeheight floatValue]);//  message_bubbleSize;
    
    rect.size = CGSizeMake(bubbleSize.width, bubbleSize.height);//  message_bubbleSize;
    
    
	/*_bubbleView.frame = rect;
	[_bubbleView setText:message.text bubbleType:bubbleType];
*/
    _label_message.numberOfLines=0;
    _label_message.lineBreakMode=NSLineBreakByWordWrapping;
    _label_message.frame=rect;
    [_label_message setText:message.text];
    
    
    
    
	// Format the message date
	NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
	[formatter setDateStyle:NSDateFormatterShortStyle];
	[formatter setTimeStyle:NSDateFormatterShortStyle];
	[formatter setDoesRelativeDateFormatting:YES];
	NSString* dateString = [formatter stringFromDate:message.createdon];

	// Set the sender's name and date on the label
    //if (isPrivate==YES)
        _label_date.text = dateString;
    [_label_date sizeToFit];
    
    //else
        _label.text = senderName;
	[_label sizeToFit];
   
  //  _label.frame = CGRectMake(0, [message.bubbleSizeheight floatValue], ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)?TABLE_CELL_WIDTH_IPAD :self.bounds.size.width) - _photo.frame.size.width, 16);
    
     //_label.frame = CGRectMake( _photo.frame.size.width+14, 8, ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)?TABLE_CELL_WIDTH_IPAD :self.bounds.size.width) - _photo.frame.size.width, 16);
    
    CGSize bubbleSizeName = [SpeechBubbleView sizeForText:senderName];
    _label.frame = CGRectMake( _photo.frame.size.width+14, 8, bubbleSizeName.width, 16);
    
    
    // _label_date.frame = CGRectMake( _photo.frame.size.width+14, _label.frame.size.height+8, ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)?TABLE_CELL_WIDTH_IPAD :self.bounds.size.width) - _photo.frame.size.width, 16);
    CGSize bubbleSizeDate = [SpeechBubbleView sizeForText:dateString];

    _label_date.frame = CGRectMake( _photo.frame.size.width+14, _label.frame.size.height+8, bubbleSizeDate.width, 16);

   
   
    //background immage
    float heightoffset=HEIGHT_OFFSET;
    //return [bubbleSize.height floatValue] + heightoffset+25;
    CGRect frame=_image_background.frame;
    
    frame.size.height=bubbleSize.height+heightoffset+25;
    frame.size.width=bubbleSize.width; //margin right
    
    CGFloat max_width1=_label.frame.size.width+_photo.frame.size.width;
    CGFloat max_width2=_label_date.frame.size.width+_photo.frame.size.width;
    
    if(max_width1>frame.size.width){
        //if(bubbleSize.width>max_width1){
            frame.size.width=max_width1;
        //}
        //else{
        //    frame.size.width=max_width1;
        //}
    }
    //else{
        if(max_width2>frame.size.width){
        //    frame.size.width=bubbleSize.width;
       // }
        //else{
            frame.size.width=max_width2;
        }
        
   //}
    //add margin right
    frame.size.width=frame.size.width+8.0;
    
    _image_background.frame=frame;
    
   
    [_image_background.layer setCornerRadius:7.0f];
     [_image_background.layer setMasksToBounds:YES];
     [_image_background.layer setBorderWidth:1.0f];

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
