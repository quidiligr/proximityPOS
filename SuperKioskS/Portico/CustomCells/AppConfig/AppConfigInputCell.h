//
//  CheckoutInputCell.h

#import <UIKit/UIKit.h>

@interface AppConfigInputCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UITextField *textField;
@property (strong, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (strong, nonatomic) IBOutlet UISegmentedControl *modeField;
@property (strong, nonatomic) IBOutlet UISwitch *switchField;
@property (strong, nonatomic) IBOutlet UIImageView *imageField;

@end
