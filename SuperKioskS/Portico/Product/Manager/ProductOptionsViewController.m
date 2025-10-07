//
//  ProductOptionsTableViewController.m
//  superkiosks
//
//  Created by Katherine Sheehy on 8/22/16.
//  Copyright © 2016 Sharecle. All rights reserved.
//

#import "ProductOptionsViewController.h"
#import "ProductOptionSectionCell.h"
#import "EditProductOptionViewController.h"

#define ALERT_TAG_ADD_SELECTION 101

@interface ProductOptionsViewController (){
    NSMutableArray *options;
    ProductOption *selectedOption;
    UIActionSheet *ua;
    AppDelegate *_appDelegate;
    UIBarButtonItem *_addButtonItem;
}

@end

@implementation ProductOptionsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    _appDelegate=ApplicationDelegate;
    
    _addButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"Add new option" style:UIBarButtonItemStylePlain target:self action:@selector(showAddOption)];
   // self.navigationItem.rightBarButtonItem=_addButtonItem;
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
/*
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Incomplete implementation, return the number of sections
    
    return [_selectedProduct.options count];
}
*/
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete implementation, return the number of rows
    //return 0;
    //ProductOption *po=[_selectedProduct.options objectAtIndex:section];
    //return [po.selections count];
    NSInteger count=[_selectedProduct.options count];
    if(count>0)
        self.navigationItem.rightBarButtonItems=@[_addButtonItem,self.editButtonItem];
    else{
        self.navigationItem.rightBarButtonItems=@[_addButtonItem];
        count=1;
    }
    return count;
}

/*
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    //if(section==1){
        //static NSString* headerCellIdentifier=@"InvConfigSwitchSectionCell";
        ProductOptionSectionCell *cell=[tableView dequeueReusableCellWithIdentifier:@"ProductOptionSectionCell"];
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapSectionGesture:)];
    
    [cell addGestureRecognizer:tap];
    cell.tag=section;
    
    return cell;
}
*/

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell=nil;
    if([_selectedProduct.options count]>0){
    cell = [tableView dequeueReusableCellWithIdentifier:@"ProductOptionItemCell" forIndexPath:indexPath];
        ProductOption *po=[_selectedProduct.options objectAtIndex:indexPath.row];
        //ProductOptionItem *poi=[po.selections objectAtIndex:indexPath.row];
        cell.textLabel.text=po.name;
        cell.detailTextLabel.text=[NSString stringWithFormat:@"Selections: %@",@([po.selections count])];

    }
    else{
    cell = [tableView dequeueReusableCellWithIdentifier:@"NoItemCell" forIndexPath:indexPath];
        cell.textLabel.text=@"Tap add to create an option for this product.";
    }
    
    
        return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    _selectedProduct.selectedOption=[_selectedProduct.options objectAtIndex:indexPath.row];
    _selectedProduct.selectedOption.isNew=NO;
    [self showEditOption];
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if(editingStyle==UITableViewCellEditingStyleDelete){
        
        //BroadcastMessageAPI* delete_item = (_appDelegate.messages)[indexPath.section];
        [_selectedProduct.options removeObjectAtIndex:indexPath.section];
        [_appDelegate.inventoryModel saveInventory];
        [self.tableView reloadData];
        
    }
}
/*
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    ProductOption *po=[_selectedProduct.options objectAtIndex:section];
    return po.name;
}
*/

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
-(void)tapSectionGesture:(UITapGestureRecognizer *)sender{
    //UIButton *button=(UIButton *)sender;
    
    NSUInteger section=sender.view.tag;//button.tag;
    
    selectedOption=[_selectedProduct.options objectAtIndex:section];
    ua=[[UIActionSheet alloc]
        initWithTitle: nil
        delegate:self
        cancelButtonTitle:@"Cancel"
        destructiveButtonTitle: nil
        otherButtonTitles:AS_ADD_OPTIONITEM,AS_REMOVE_OPTION, nil];
    
}

-(void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{
    NSString *title=[actionSheet buttonTitleAtIndex:buttonIndex];
    if([title isEqualToString:AS_ADD_OPTIONITEM]){
        /*UIAlertView * alert =[[UIAlertView alloc ] initWithTitle:selectedOption.name message:@"Add new selection" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
        alert.alertViewStyle = UIAlertViewStylePlainTextInput;
        //[alert addButtonWithTitle:@"OK"];
        alert.tag=ALERT_TAG_ADD_SELECTION;
        UITextField *txtName=[alert textFieldAtIndex:0];
        
        txtName.text=[NSString stringWithFormat:@"%.2f",(double)totalTip/100];
        [txtName setKeyboardType:UIKeyboardTypeDecimalPad];
        
        [alert show];
         */

    }
    else if([title isEqualToString:AS_REMOVE_OPTION]){
        
    }
    
}
-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    
}

-(void)showEditOption{
    /*
    EditProductOptionViewController *vc=[_appDelegate.storyBoard instantiateViewControllerWithIdentifier:@"EditProductOptionViewController"];
    
    vc.selectedProduct=_selectedProduct;
*/
    [self performSegueWithIdentifier:@"toEditProductOptionViewController" sender:self];
}

-(void)showAddOption{
    ProductOption *po=[ProductOption new];
    po.UID=[[NSUUID UUID] UUIDString];
    po.parentUID=nil;
    
    po.name=@"Untitled option";
    po.maxSelected=1;
    po.selections=[NSMutableArray new];
    po.isNew=YES;
    /*
    if(_selectedProduct.options==nil)
        _selectedProduct.options=[NSMutableArray new];
    [_selectedProduct.options addObject:po];
    */
    _selectedProduct.selectedOption=po;
    [self showEditOption];
//    EditProductOptionViewController *vc=[_appDelegate.storyBoard instantiateViewControllerWithIdentifier:@"EditProductOptionViewController"];
//    //vc.delegate=self;
//    
//    //vc.isAdd=YES;
//    vc.selectedProduct=_selectedProduct;
//    
//    
//    
//    //po.optionUID=[[NSUUID UUID] UUIDString];
//    //po.optionUIDParent=[[NSUUID UUID] UUIDString];
//    
//    
//    UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:vc];
//    
//    if(_appDelegate.isIpad){
//        //if(_popOver==nil){
//        
//        
//        _popOver=[[UIPopoverController alloc] initWithContentViewController:nav];
//        //_chatPopover.popoverContentSize=CGSizeMake(self.view.frame.size.width/2, self.view.frame.size.height);
//        _popOver.popoverContentSize=CGSizeMake(320.0, self.view.frame.size.height);
//        [_popOver presentPopoverFromBarButtonItem:_addButtonItem permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
//        //[_popOver presentPopoverFromRect:CGRectMake(_barcodeButton.frame.origin.x, _barcodeButton.frame.origin.y, _barcodeButton.frame.size.width, _barcodeButton.frame.size.height) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
//        [_popOver presentPopoverFromRect:self.view.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
//        /*}
//         else{
//         [_popOver dismissPopoverAnimated:YES];
//         _popOver=nil;
//         }
//         */
//    }
//    else{
//        [self presentViewController:nav animated:YES completion:nil];
//    }

}

/*
-(void)addProductOptionItemViewControllerAdded:(AddProductOptionItemViewController *)controller{
    [controller
    
}
*/

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"toEditProductOptionViewController"]){
        EditProductOptionViewController *vc=segue.destinationViewController;
    
    vc.selectedProduct=_selectedProduct;
    }
    
    
}

-(void)reloadData{
    //if(options==nil)
      //  options=[NSMutableArray new];
    
}

@end
