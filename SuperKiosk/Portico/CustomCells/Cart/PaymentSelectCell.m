//
//  ChekcoutDisplayCell.m


#import "PaymentSelectCell.h"

@implementation PaymentSelectCell

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
- (IBAction)toggleChanged:(id)sender {
    UISwitch *sw = (UISwitch *)sender;
    if(sw.isOn){
        if ([sw isEqual:self.creditCardSwitch]){
            [self.SKMoneySwitch setOn:NO];
            [self.bitcoinSwitch setOn:NO];
            [self.payPalSwitch setOn:NO];
        }
         else if ([sw isEqual:self.SKMoneySwitch]){
            [self.creditCardSwitch setOn:NO];
            [self.bitcoinSwitch setOn:NO];
            [self.payPalSwitch setOn:NO];
        }
         else if ([sw isEqual:self.bitcoinSwitch]){
            [self.SKMoneySwitch setOn:NO];
            [self.creditCardSwitch setOn:NO];
            [self.payPalSwitch setOn:NO];
        }
        else if ([sw isEqual:self.payPalSwitch]){
            [self.SKMoneySwitch setOn:NO];
            [self.bitcoinSwitch setOn:NO];
            [self.creditCardSwitch setOn:NO];
        }
    }
    /*
    else{
        if ([sw isEqual:self.creditCardSwitch]){
            [self.SKMoneySwitch setOn:NO];
            [self.bitcoinSwitch setOn:NO];
            [self.payPalSwitch setOn:NO];
        }
        else if ([sw isEqual:self.SKMoneySwitch]){
            [self.creditCardSwitch setOn:NO];
            [self.bitcoinSwitch setOn:NO];
            [self.payPalSwitch setOn:NO];
        }
        else if ([sw isEqual:self.bitcoinSwitch]){
            [self.SKMoneySwitch setOn:NO];
            [self.creditCardSwitch setOn:NO];
            [self.payPalSwitch setOn:NO];
        }
        else if ([sw isEqual:self.payPalSwitch]){
            [self.SKMoneySwitch setOn:NO];
            [self.bitcoinSwitch setOn:NO];
            [self.creditCardSwitch setOn:NO];
        }
    }
     */

}

@end
