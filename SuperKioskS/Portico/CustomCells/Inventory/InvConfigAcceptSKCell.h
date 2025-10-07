//
//  InvConfigSwitchCell.h

#import <UIKit/UIKit.h>

@interface InvConfigAcceptSKCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *nameLabel;

@property (strong, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (strong, nonatomic) IBOutlet UISwitch *switchField;
@end
