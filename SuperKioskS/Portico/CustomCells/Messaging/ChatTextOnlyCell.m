//
//  CheckoutCell.m
//  

#import "ChatTextOnlyCell.h"
#import "SpeechBubbleView.h"
@implementation ChatTextOnlyCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setMessage:(NSString *)message{
    CGSize bubbleSize = [AppDelegate sizeForText:message];//[SpeechBubbleView sizeForText:message];
    CGRect rect=_messageLabel.frame;
   
    rect.size.height=bubbleSize.height;
    rect.size.width=bubbleSize.width;
    
    _messageLabel.numberOfLines=0;
    _messageLabel.lineBreakMode=NSLineBreakByWordWrapping;
    _messageLabel.frame=rect;
    //NSLog(@"frame: %f",_messageLabel.frame.size.height);
    _messageLabel.text=message;

}

@end
