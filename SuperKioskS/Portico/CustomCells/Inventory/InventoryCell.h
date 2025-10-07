//
//  CheckoutInputCell.h

#import <UIKit/UIKit.h>

@interface InventoryCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *subTitleLabel;

@property (strong, nonatomic) IBOutlet UIButton *upButton;

@property (strong, nonatomic) IBOutlet UIButton *downButton;

@property (strong, nonatomic) IBOutlet UIImageView *productImageView;

@end
