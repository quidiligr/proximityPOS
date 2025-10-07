//
//  ChekcoutDisplayCell.h


#import <UIKit/UIKit.h>

@interface PaymentSelectCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *ccTypeLabel;
@property (strong, nonatomic) IBOutlet UILabel *ccLast4Label;

@property (strong, nonatomic) IBOutlet UISwitch *creditCardSwitch;

@property (strong, nonatomic) IBOutlet UISwitch *SKMoneySwitch;
@property (strong, nonatomic) IBOutlet UISwitch *bitcoinSwitch;
@property (strong, nonatomic) IBOutlet UISwitch *payPalSwitch;

@end
