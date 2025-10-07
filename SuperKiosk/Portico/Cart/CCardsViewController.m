//
//  CCardsViewController.m
//  Order Here
//
//  Created by Romulo Quidilig on 6/4/15.
//  Copyright (c) 2015 Sharecle. All rights reserved.
//

#import "CCardsViewController.h"
#import "CCardViewController.h"
#import "AppDelegate.h"
#import "CCardDisplayCell.h"
#import "defs_userinfo.h"

@interface CCardsViewController (){
    //NSIndexPath * selectedIndexPath;
    CCardInfo *selectedCard;
    //NSInteger selectedAction;
    UIBarButtonItem *addButtonItem;
    
}
@property (nonatomic, strong) AppDelegate *appDelegate;
@end

@implementation CCardsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor clearColor];
   // self.tableView.backgroundColor=[UIColor clearColor];
    _appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    //self.tableView.dataSource=self;
    addButtonItem=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addCCard)];
    
        UIBarButtonItem *backButton=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(backButtonTapped)];
    self.navigationItem.leftBarButtonItem=backButton;
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
-(void)viewDidAppear:(BOOL)animated{
    
    [self.tableView reloadData];
    NSInteger count= [_appDelegate.appConfig.userInfo.ccards count];
    if(count==0){
        [self addCCard];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete method implementation.
    // Return the number of rows in the section.
    NSInteger count= [_appDelegate.appConfig.userInfo.ccards count];
    if (count<MAX_CARDS) {
        if(count>0)
            self.navigationItem.rightBarButtonItems=@[self.editButtonItem, addButtonItem];
        else
            self.navigationItem.rightBarButtonItems=@[addButtonItem];
    }
    else{
        self.navigationItem.rightBarButtonItems=@[self.editButtonItem];
    }
    
    return count;
}
/*
- (NSString *)cardtype:(STPCardBrand)brand {
    switch (brand) {
        case STPCardBrandAmex:
            return @"American Express";
        case STPCardBrandDinersClub:
            return @"Diners Club";
        case STPCardBrandDiscover:
            return @"Discover";
        case STPCardBrandJCB:
            return @"JCB";
        case STPCardBrandMasterCard:
            return @"MasterCard";
        case STPCardBrandVisa:
            return @"Visa";
        default:
            return @"Unknown";
    }
}
 */

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"card_cell" forIndexPath:indexPath];
    
    // Configure the cell...
    CCardInfo *card=[_appDelegate.appConfig.userInfo.ccards objectAtIndex:indexPath.row];
    //cell.textLabel.text=[NSString stringWithFormat:@"%@ %@/%@ %@",card.ccNumber,card.ccExpMonth,card.ccExpYear,card.ccCVV];
   // cell.detailTextLabel.text=card.name;
    
    //cell.numberLabel.text=[NSString stringWithFormat:@"xxxx-xxxx-xxxx-%@", (card.number.length>4)?[card.number substringFromIndex:card.number.length-4]:@""];//card.number;
   // cell.providerLabel.text=card.ccProvider;
   // cell.nameLabel.text=card.name;
    //cell.expLabel.text=[NSString stringWithFormat:@"%lu/%lu",(unsigned long)card.expMonth,(unsigned long)card.expYear];
    //cell.cvvLabel.text=[NSString stringWithFormat:@"%@",card.cvc];
    //cell.cardImage.image=[UIImage imageNamed:[NSString stringWithFormat:@"%@",card.ccType]];
    
    cell.textLabel.text=[NSString stringWithFormat:@"****-****-****-%@", card.last4];
    cell.detailTextLabel.text=[NSString stringWithFormat:@"%@",[AppDelegate cardtype:card.brand]];
    
    if(card.isDefault)
        cell.accessoryType=UITableViewCellAccessoryCheckmark;
    else
        cell.accessoryType=UITableViewCellAccessoryNone;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //selectedIndexPath=indexPath;
    //selectedAction=ACTION_EDIT;
    selectedCard=[_appDelegate.appConfig.userInfo.ccards objectAtIndex:indexPath.row];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    [self performSegueWithIdentifier:@"toCCardViewController" sender:self];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 84.0;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    /*
     NSMutableArray *orders=[self.history valueForKey:day];
     if(orders==nil){
     orders=[NSMutableArray new];
     [orders addObject:order];
     [self.history setValue:orders forKey:day];
     }
     else{
     [orders addObject:order];
     }
     */
    //NSMutableArray *orders=[_appDelegate.historyModel.history valueForKey:historyDates[indexPath.section]] ;
    
    //OrderHistory *delete_item=[orders objectAtIndex:indexPath.row];
    
    
    
    
    if(editingStyle==UITableViewCellEditingStyleDelete){
        
        [_appDelegate.appConfig.userInfo.ccards removeObjectAtIndex:indexPath.section];
      [AppConfigModel saveSettings];
        [self.tableView reloadData];
    }
}
-(void)setEditing:(BOOL)editing animated:(BOOL)animated{
    [super setEditing:editing animated:animated];
    [self.tableView setEditing:editing animated:animated];
    /*if (editing)
     {
     //self.editButtonItem.title = NSLocalizedString(@"Cancel", @"Cancel");
     }
     else
     {
     self.editButtonItem.title = NSLocalizedString(@"Block/UnBlock", @"Block/UnBlock");
     }
     */
}
-(void)addCCard{
    selectedCard=nil;

    //NSPredicate *predicate=[NSPredicate predicateWithFormat:@"ccNumber.length<%d OR ccNumber.length>%d OR ccNumber==%@",MIN_CC_NUMBER_LEN,MAX_CC_NUMBER_LEN, @"4242424242424242"];
    //NSPredicate *predicate=[NSPredicate predicateWithFormat:@"number.length==0"];
    
    //NSArray *results;
    if([_appDelegate.appConfig.userInfo.ccards count]>=MAX_CARDS){
        
        //check if there's a card we can reuse
        
            
        /*results=[_appDelegate.appConfig.userInfo.ccards filteredArrayUsingPredicate:predicate];
            
        if([results count]>0){
            selectedCard=[results firstObject];
        }
        else{
*/
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"Only %d credit cards allowed. Please remove invalid or expired card",MAX_CARDS] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            return;
        //}//
    }
    else{
        
        /*if([_appDelegate.appConfig.userInfo.ccards count]>0){
            results=[_appDelegate.appConfig.userInfo.ccards filteredArrayUsingPredicate:predicate];
            
            if([results count]>0){
                selectedCard=[results firstObject];
            }
            
        }
        
        if(selectedCard==nil){
            CCardInfo *newCard=[CCardInfo new];
            
            newCard.name=_appDelegate.appConfig.userInfo.fullName;
                //newCard.ccEmail=_appDelegate.appConfig.userInfo.email;
            
            newCard.cvc=@"";
            
            newCard.number=@"";
            newCard.isDefault=YES;
            //if([_appDelegate.appConfig.userInfo.ccards count]==0)
            
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy"];
            NSInteger currentYear = [[dateFormatter stringFromDate:[NSDate date]] integerValue];
            
            newCard.expMonth=1;
            
            newCard.expYear=currentYear+1;

            [_appDelegate.appConfig.userInfo.ccards addObject:newCard];
                [self.tableView reloadData];
                selectedCard=newCard;
            [AppConfigModel saveSettings];
        }
         */
    
        
    }
    
    [self performSegueWithIdentifier:@"toAddCCardViewController" sender:self];
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"toCCardViewController"]){
        
        CCardViewController *vc=[segue destinationViewController];
        vc.selectedCard=selectedCard;
       // vc.selectedAction=selectedAction;
        
        
    }
}

-(void)backButtonTapped{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

@end
