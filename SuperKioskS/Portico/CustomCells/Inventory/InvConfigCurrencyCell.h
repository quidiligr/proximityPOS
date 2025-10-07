//
//  InvConfigCurrencyCell.h

#import <UIKit/UIKit.h>

@interface InvConfigCurrencyCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UITextField *currencyTextField;
@property (strong, nonatomic) IBOutlet UITextField *symbolTextField;
@property (strong, nonatomic) IBOutlet UILabel *descriptionLabel;

@end
