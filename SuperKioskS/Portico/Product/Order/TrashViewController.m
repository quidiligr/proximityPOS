//
//  TrashTableViewController.m
//  superkiosks
//
//  Created by Katherine Sheehy on 6/18/16.
//  Copyright © 2016 Sharecle. All rights reserved.
//

#import "TrashViewController.h"
#import "AppDelegate.h"
#import "OrderHistory.h"
@interface TrashViewController (){
    NSMutableArray *_trashArray;
    AppDelegate *_appDelegate;
    UIBarButtonItem *_emptyTrashButtoItem;
    BOOL cleanOnExit;
}
@property (strong, nonatomic) IBOutlet UIButton *restoreButton;
@property (strong, nonatomic) IBOutlet UISwitch *selectAllSwitch;

@end

@implementation TrashViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    //self.navigationItem.rightBarButtonItem = self.editButtonItem;
    _appDelegate=ApplicationDelegate;
    cleanOnExit=NO;
    self.title=@"Trash";
    _emptyTrashButtoItem=[[UIBarButtonItem alloc] initWithTitle:@"Empty" style:UIBarButtonItemStyleBordered target:self action:@selector(emptyTrash)];
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self loadData];
    
}

-(void)viewDidDisappear:(BOOL)animated{
    if(cleanOnExit){
        [_appDelegate.historyModel emtpyTrash:NO];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Incomplete implementation, return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete implementation, return the number of rows
    return [_trashArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"trash_cell" forIndexPath:indexPath];
    
    // Configure the cell...
    OrderHistory *oh=[_trashArray objectAtIndex:indexPath.row];
    
    cell.textLabel.text=[NSString stringWithFormat:@"#%@ %@",oh.orderNumber, oh.orderBy];
    cell.detailTextLabel.text=[NSString stringWithFormat:@"%@%@ %@",(oh.orderIsLive)?@"":@"(TEST) ", oh.orderDay,[OrderHistory statusToString:[oh.orderStatus integerValue]]];
    if(oh.selected){
        cell.accessoryType=UITableViewCellAccessoryCheckmark;
    }
    else{
        cell.accessoryType=UITableViewCellAccessoryNone;
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    OrderHistory *oh=[_trashArray objectAtIndex:indexPath.row];
    if(oh.deleteStatus==2){
        return 0;
    }
    else{
        return 50;
    }
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        //[_trashArray removeObjectAtIndex:]
        /*
        [_appDelegate.historyModel deleteFromTrash:[_trashArray objectAtIndex:indexPath.row]];
        [_trashArray removeObjectAtIndex:indexPath.row];

        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
         */
        OrderHistory *oh=[_trashArray objectAtIndex:indexPath.row];
        if(oh){
            oh.deleteStatus=2;
            cleanOnExit=YES;
            [self.tableView reloadData];
        }
        
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    OrderHistory *oh=[_trashArray objectAtIndex:indexPath.row];
    if(oh)
    {
        oh.selected=YES;
        [_restoreButton setHidden:NO];
        [self.tableView reloadData];
    }
}

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
-(void)loadData{
    if(_trashArray==nil)
        _trashArray=[NSMutableArray new];
    else
        [_trashArray removeAllObjects];
    
    [_trashArray addObjectsFromArray:[_appDelegate.historyModel trashArray]];
    
    if([_trashArray count]>0){
        if(self.navigationItem.rightBarButtonItems==nil)
            self.navigationItem.rightBarButtonItems = @[_emptyTrashButtoItem,self.editButtonItem];
    }
    else{
        self.navigationItem.rightBarButtonItems=nil;
        
    }
    if([_trashArray count]==0){
        [self done];
        return;
    }
    [self.tableView reloadData];
}

-(void)emptyTrash{
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Trask" message:@"Empty trash?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
    [alert show];
    
}

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    if(alertView.cancelButtonIndex==buttonIndex)
        return;
    
    [_appDelegate.historyModel emtpyTrash:YES];
    [self done];
    
}
- (IBAction)restoreButtonTapped:(id)sender {
     [_restoreButton setHidden:YES];
    if([_trashArray count]>0){
        NSPredicate *p=[NSPredicate predicateWithFormat:@"selected==1"];
        NSArray *selectedArray=[_trashArray filteredArrayUsingPredicate:p];
        
        for(OrderHistory *oh in selectedArray){
            oh.selected=NO;
            oh.deleteStatus=0;
        }
        [_appDelegate.historyModel saveHistory];
        [self loadData];
    }
   
    
}

-(void)done{
    if(_appDelegate.isIpad){
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}


- (IBAction)selectAllSwitchChanged:(id)sender {
    if([_selectAllSwitch isOn]){
        for(OrderHistory *oh in _trashArray){
            oh.selected=YES;
        }
        [_restoreButton setHidden:NO];
    }
    else{
        for(OrderHistory *oh in _trashArray){
            oh.selected=NO;
        }
        [_restoreButton setHidden:YES];
    }
    [self.tableView reloadData];

}

@end
