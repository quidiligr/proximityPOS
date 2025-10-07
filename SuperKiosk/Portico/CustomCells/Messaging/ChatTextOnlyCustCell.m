//
//  CheckoutCell.m
//  

#import "ChatTextOnlyCustCell.h"
#import "SpeechBubbleView.h"

@implementation ChatTextOnlyCustCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
       // _messageLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        //_messageLabel.backgroundColor = color;
                //_messageLabel.font = [UIFont systemFontOfSize:15];
        //_messageLabel.textColor = [UIColor colorWithRed:64/255.0 green:64/255.0 blue:64/255.0 alpha:1.0];
    }
    return self;
}
- (void)layoutSubviews
{
    // This is a little trick to set the background color of a table view cell.
    [super layoutSubviews];
    //self.backgroundColor = [UIColor clearColor];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setMessage:(NSString *)message{
   /* CGSize bubbleSize = [SpeechBubbleView sizeForText:message];
    CGRect rect=_messageLabel.frame;
    
    rect.size.height=bubbleSize.height;
    rect.size.width=bubbleSize.width;
    
    _messageLabel.numberOfLines=0;
    _messageLabel.lineBreakMode=NSLineBreakByWordWrapping;
    _messageLabel.frame=rect;
    
    _messageLabel.text=message;
    */
    _messageLabel.numberOfLines=0;
    _messageLabel.lineBreakMode=NSLineBreakByWordWrapping;

    CGRect frame=_messageLabel.frame;
    _messageLabel.text=message;
    [_messageLabel sizeToFit];
    frame.size.height = _messageLabel.frame.size.height;
    _messageLabel.frame = frame;
    
}
@end
