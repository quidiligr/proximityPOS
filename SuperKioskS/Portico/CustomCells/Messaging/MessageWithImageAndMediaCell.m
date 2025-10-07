//
//  MessageTableViewCell.m
//  Sharecle
//
//  Created by Romulo on 08/04/14.
//  Copyright (c) 2014 Sharecle Inc. All rights reserved.
//

#import "MessageWithImageAndMediaCell.h"
//#import "Message.h"
#import "SpeechBubbleView.h"
//#import "ContactMessage.h"
//#import "BroadcastMessageAPI.h"
#import "MessageTableViewData.h"
#import "defs.h"


static UIColor* color = nil;
static CGFloat marginLeft=10.0;
static CGFloat marginTop=10.0;

@interface MessageWithImageAndMediaCell() {
    SpeechBubbleView *_bubbleView;
	UILabel *_label;
    //UIImageView *_image;
    UIImageView *_imageAttach;
   // UIButton *_btnPlayer;
}
@end

@implementation MessageWithImageAndMediaCell

+ (void)initialize
{
	if (self == [MessageWithImageAndMediaCell class])
	{
		color =[UIColor clearColor]; // [UIColor colorWithRed:219/255.0 green:226/255.0 blue:237/255.0 alpha:1.0];
	}
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)reuseIdentifier
{
	if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]))
	{
		self.selectionStyle = self.selectionStyle = UITableViewCellSelectionStyleBlue;//UITableViewCellSelectionStyleGray;//UITableViewCellSelectionStyleNone;

		// Create the speech bubble view
		_bubbleView = [[SpeechBubbleView alloc] initWithFrame:CGRectZero];
		_bubbleView.backgroundColor = color;
		_bubbleView.opaque = YES;
		_bubbleView.clearsContextBeforeDrawing = NO;
		_bubbleView.contentMode = UIViewContentModeRedraw;
		_bubbleView.autoresizingMask = 0;
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
        
         _photo=[[UIImageView alloc] initWithFrame:CGRectMake(0,0,CELL_PHOTO_WIDTH,CELL_PHOTO_HEIGHT)];
        
        //_image=[[UIImageView alloc] initWithFrame:CGRectMake(0,0,60,60)];
        [self.contentView addSubview:_photo];
        /*
        _imageAttach=[[UIImageView alloc] initWithFrame:CGRectMake(marginLeft+CELL_MEDIA_WIDTH,marginTop,CELL_IMAGE_WIDTH,CELL_IMAGE_HEIGHT)];
        [self.contentView addSubview:_imageAttach];
        
        //_btnPlayer=[[UIButton alloc] initWithFrame:CGRectMake(0,0,CELL_MEDIA_WIDTH,CELL_MEDIA_HEIGHT)];
        _imgPlayer = [[UIImageView alloc] initWithFrame:CGRectMake(marginLeft,marginTop,CELL_MEDIA_WIDTH,CELL_MEDIA_HEIGHT)];
         */
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
            _imageAttach = [[UIImageView alloc] initWithFrame:CGRectMake((TABLE_CELL_WIDTH_IPAD/2)-(CELL_IMAGE_WIDTH/2),marginTop,CELL_IMAGE_WIDTH,CELL_IMAGE_HEIGHT)];
        else
            _imageAttach = [[UIImageView alloc] initWithFrame:CGRectMake((self.bounds.size.width/2)-(CELL_IMAGE_WIDTH/2),marginTop,CELL_IMAGE_WIDTH,CELL_IMAGE_HEIGHT)];
        
        [self.contentView addSubview:_imageAttach];
        
        // _btnPlayer=[[UIButton alloc] initWithFrame:CGRectMake(0,0,CELL_MEDIA_WIDTH,CELL_MEDIA_HEIGHT)];
        // _imgPlayer = [[UIImageView alloc] initWithFrame:CGRectMake(marginLeft,0,CELL_MEDIA_WIDTH,CELL_MEDIA_HEIGHT)];
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
            _imgPlayer = [[UIImageView alloc] initWithFrame:CGRectMake((TABLE_CELL_WIDTH_IPAD/2)-(CELL_MEDIA_WIDTH/2),marginTop+(CELL_IMAGE_HEIGHT/2)-(CELL_MEDIA_WIDTH/2) ,CELL_MEDIA_WIDTH,CELL_MEDIA_HEIGHT)];
        else
            _imgPlayer = [[UIImageView alloc] initWithFrame:CGRectMake((self.bounds.size.width/2)-(CELL_MEDIA_WIDTH/2),marginTop+(CELL_IMAGE_HEIGHT/2)-(CELL_MEDIA_WIDTH/2),CELL_MEDIA_WIDTH,CELL_MEDIA_HEIGHT)];
        [_imgPlayer setAlpha:0.5];

        [self.contentView addSubview:_imgPlayer];
	}
	return self;
}

- (void)layoutSubviews
{
	// This is a little trick to set the background color of a table view cell.
	[super layoutSubviews];
	self.backgroundColor = color;
}

//- (void)setBroadcastMessage:(BroadcastMessageAPI*)message myPhoto:(UIImage*)myPhoto otherPhoto:(UIImage*)otherPhoto myImage:(UIImage *)myImage
- (void)setMessage:(MessageTableViewData*)message{
	BOOL isPrivate=message.isPrivate;
    CGPoint point = CGPointZero;
    //CGPoint pointPhoto = CGPointZero;
    
    CGRect rectPhoto=_photo.frame;
    CGRect rectImage=_imageAttach.frame;
    CGRect rectMedia=_imgPlayer.frame;
    
    
    
    
	// We display messages that are sent by the user on the right-hand side of
	// the screen. Incoming messages are displayed on the left-hand side.
	NSString* senderName;
	BubbleType bubbleType;
	//if ([message isSentByUser])
    rectMedia.origin.y=rectImage.size.height;
    _photo.image=message.senderPhoto;
    //if ([message.userid longValue]==[message.senderid longValue])
    if([message.userid isEqualToNumber:message.senderid])
	{
		bubbleType = BubbleTypeRighthand;
		senderName = NSLocalizedString(@"You", nil);
        
        //rectMedia.origin.x=self.bounds.size.width -_image.frame.size.width;
        
        
		point.x = ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)?TABLE_CELL_WIDTH_IPAD :self.bounds.size.width ) - ([message.bubbleSizewidth floatValue]+_photo.frame.size.width)- marginLeft;
		point.y=CELL_IMAGE_HEIGHT+CELL_VERTICAL_SPACE;//rectImage.size.height+rectMedia.size.height;
        //point.y=CELL_IMAGE_HEIGHT;
        //position the photo
        //pointPhoto.x=self.bounds.size.width -_image.frame.size.width;
        //rectPhoto=_image.frame;
        
        rectPhoto.origin.x=((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)?TABLE_CELL_WIDTH_IPAD :self.bounds.size.width ) -_photo.frame.size.width - marginLeft;
        rectPhoto.origin.y=point.y;//CELL_IMAGE_HEIGHT+CELL_VERTICAL_SPACE;//rectImage.size.height+rectMedia.size.height;
        //_image.frame=rectPhoto;
        
        _label.textAlignment = NSTextAlignmentRight;
       
        _imageAttach.image=message.myImage;
        
        
    }
	else
	{
		bubbleType = BubbleTypeLefthand;
		senderName = message.sendernickname;
        
        
        
        point.x = _photo.frame.size.width + marginLeft;
        point.y=CELL_IMAGE_HEIGHT+CELL_VERTICAL_SPACE;//rectImage.size.height+rectMedia.size.height;
        
        rectPhoto.origin=CGPointMake(marginLeft, 0); //CGPointZero;
        rectPhoto.origin.y=point.y;//CELL_IMAGE_HEIGHT+CELL_VERTICAL_SPACE;//rectImage.size.height+rectMedia.size.height;
        //_image.frame=rectPhoto;
        
		_label.textAlignment = NSTextAlignmentLeft;
        _imageAttach.image=message.myImage;
	}
    
    _photo.frame=rectPhoto;
    _imageAttach.frame=rectImage;
    //_btnPlayer.frame=rectMedia;
    
    //rounded image
    _photo.layer.cornerRadius=_photo.frame.size.width / 2;
    _photo.clipsToBounds = YES;
    
    
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
	if (isPrivate==YES)
        _label.text = [NSString stringWithFormat:@"%@", dateString];
    else
        _label.text = [NSString stringWithFormat:@"%@ @ %@", senderName, dateString];
	[_label sizeToFit];
    //_label.frame = CGRectMake(8, message.bubbleSize.height, self.contentView.bounds.size.width - 16, 16);
   // _label.frame = CGRectMake(8, [message.bubbleSizeheight floatValue]+rectImage.size.height+rectMedia.size.height, self.contentView.bounds.size.width - 16, 16);
    if ([message.userid longValue]==[message.senderid longValue])
       // _label.frame = CGRectMake(0, [message.bubbleSizeheight floatValue]+rectImage.size.height+rectMedia.size.height, self.contentView.bounds.size.width - _image.frame.size.width, 16);
         _label.frame = CGRectMake(0, [message.bubbleSizeheight floatValue]+CELL_IMAGE_HEIGHT+CELL_VERTICAL_SPACE, ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)?TABLE_CELL_WIDTH_IPAD :self.bounds.size.width )- _photo.frame.size.width, 16);
    
    else
        _label.frame = CGRectMake(_photo.frame.size.width, [message.bubbleSizeheight floatValue]+CELL_IMAGE_HEIGHT+CELL_VERTICAL_SPACE, ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)?TABLE_CELL_WIDTH_IPAD :self.bounds.size.width ) - 16, 16);
}

@end
