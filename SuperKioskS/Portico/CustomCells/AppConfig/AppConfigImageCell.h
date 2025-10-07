//
//  ConfigInputWithImageCell.h

#import <UIKit/UIKit.h>

@interface AppConfigImageCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
//@property (strong, nonatomic) IBOutlet UITextField *textField;
@property (strong, nonatomic) IBOutlet UIImageView *imageField;
@property (strong, nonatomic) IBOutlet UILabel *descriptionLabel;
@end
