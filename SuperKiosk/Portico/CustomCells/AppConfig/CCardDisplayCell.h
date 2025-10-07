//
//  CheckoutInputCell.h

#import <UIKit/UIKit.h>

@interface CCardDisplayCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *providerLabel;
@property (strong, nonatomic) IBOutlet UILabel *numberLabel;
@property (strong, nonatomic) IBOutlet UILabel *expLabel;
@property (strong, nonatomic) IBOutlet UILabel *cvvLabel;
@property (strong, nonatomic) IBOutlet UIImageView *cardImage;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;

@end
