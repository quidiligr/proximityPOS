//
//  AddProductOptionItemViewController.m
//  superkiosks
//
//  Created by Katherine Sheehy on 8/22/16.
//  Copyright © 2016 Sharecle. All rights reserved.
//

#import "EditProductOptionViewController.h"
#import "ProductOptionItemCell.h"
#import "Util.h"
#import "AppDelegate.h"

@interface EditProductOptionViewController (){
    AppDelegate *_appDelegate;
    UIBarButtonItem *_addButtonItem;
    //UIBarButtonItem *_deleteButtonItem;
}
@end

@implementation EditProductOptionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _appDelegate=ApplicationDelegate;
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    _addButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"Add new selection" style:UIBarButtonItemStylePlain target:self action:@selector(addButtonTapped:)];
    //self.navigationItem.rightBarButtonItem=_addButtonItem;
    _maxSelectedTextField.keyboardType=UIKeyboardTypeNumberPad;
    _minSelectedTextField.keyboardType=UIKeyboardTypeNumberPad;
    //self.navigationItem.rightBarButtonItems=@[_addButtonItem,self.editButtonItem];
    [self reloadData];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
}

-(void)viewDidDisappear:(BOOL)animated{
    if(_selectedProduct.selectedOption.isNew)
        return;
    [self saveOption];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
/*
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Incomplete implementation, return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete implementation, return the number of rows
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
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
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return @"Selections:";
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger count=[_selectedProduct.selectedOption.selections count];
    if(count>0)
        self.navigationItem.rightBarButtonItems=@[_addButtonItem,self.editButtonItem];
    else{
        count=1;
        self.navigationItem.rightBarButtonItems=@[_addButtonItem];
    }
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if([_selectedProduct.selectedOption.selections count]>0){
    ProductOptionItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ProductOptionItemCell" forIndexPath:indexPath];
    ProductOptionItem *poi=[_selectedProduct.selectedOption.selections objectAtIndex:indexPath.row];
    cell.titleLabel.text=poi.title;
        cell.shortDescLabel.text=poi.shortDesc;
        /*
         float actualPrice=(float)(_selectedProduct.actualPrice+ poi.addlCost)/100;
    cell.priceLabel.text=[NSString stringWithFormat:@"%@",@(actualPrice)];
         */
        cell.priceLabel.text=[Util priceIntToString:poi.addlCost currency:nil];
        
        return cell;
    }
    else{
       UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NoItemCell" forIndexPath:indexPath];
        
        cell.textLabel.text=@"Tap add to create a selection for this option.";
        return cell;
    }
    
}
/*
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    _selectedProduct.selectedOption.selectedOptionItem=[_selectedProduct.selectedOption.selections objectAtIndex:indexPath.row];
    [self showAddOptionItem];
}
*/
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if(editingStyle==UITableViewCellEditingStyleDelete){
        
        //BroadcastMessageAPI* delete_item = (_appDelegate.messages)[indexPath.section];
        [_selectedProduct.selectedOption.selections removeObjectAtIndex:indexPath.section];
        [_appDelegate.inventoryModel saveInventory];
        [self.tableView reloadData];
        
    }
}

-(void)addButtonTapped:(id)sender{
    [self showAddOptionItem];
}

-//(void)saveButtonTapped:(id)sender{
(void)saveOption{
    
   
    _selectedProduct.selectedOption.name=[_nameTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" "]];
    
    if(_selectedProduct.selectedOption.name.length==0){
        [AppDelegate toast:@"Option name is required." duration:2.0];
        return;
    }
    
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    
    NSNumber *digitNumber = [numberFormatter numberFromString:_maxSelectedTextField.text];
        
    if (digitNumber != nil) {
        _selectedProduct.selectedOption.maxSelected=[digitNumber intValue];
    }
    
    digitNumber = [numberFormatter numberFromString:_minSelectedTextField.text];
    
    if (digitNumber != nil) {
        _selectedProduct.selectedOption.minSelected=[digitNumber intValue];
    }
    
    [_selectedProduct.selectedOption autoCorrectMinMax];
    
    
    
    @try{
    //_selectedProduct.selectedOption.maxSelected=[_maxSelectedTextField.text integerValue];
        _selectedProduct.selectedOption.sortNum=[_sortNumTextField.text integerValue];
    }
    @catch(NSException *e){
        [AppDelegate toast:@"Invalid number." duration:2.0];
        return;
    }
    
    
    if(_selectedProduct.selectedOption.isNew){
        _selectedProduct.selectedOption.isNew=NO;
        
        if(_selectedProduct.options==nil)
            _selectedProduct.options=[NSMutableArray new];
        [_selectedProduct.options addObject:_selectedProduct.selectedOption];
        
    }
    [_appDelegate.inventoryModel saveInventory];
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)showAddOptionItem{
    _selectedProduct.selectedOption.selectedOptionItem=[ProductOptionItem new];
    _selectedProduct.selectedOption.selectedOptionItem.title=@"Untitled selection";
    _selectedProduct.selectedOption.selectedOptionItem.UID=[[NSUUID UUID] UUIDString];
    //_selectedProduct.selectedOption.selectedOptionItem.UIDParent=_selectedProduct.selectedOption.UID;
    _selectedProduct.selectedOption.selectedOptionItem.addlCost=0;
    _selectedProduct.selectedOption.selectedOptionItem.isNew=YES;
    [self showEditOptionItem];
}
-(void)showEditOptionItem{
    
    
    
    
    EditProductOptionItemViewController *vc=[_appDelegate.storyBoard instantiateViewControllerWithIdentifier:@"EditProductOptionItemViewController"];
    //vc.delegate=self;
    vc.selectedProduct=_selectedProduct;
    vc.delegate=self;
    
    
    
    UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:vc];
    
    if(_appDelegate.isIpad){
        //if(_popOver==nil){
        
        
        _popOver=[[UIPopoverController alloc] initWithContentViewController:nav];
        //_chatPopover.popoverContentSize=CGSizeMake(self.view.frame.size.width/2, self.view.frame.size.height);
        _popOver.popoverContentSize=CGSizeMake(320.0, self.view.frame.size.height);
        [_popOver presentPopoverFromBarButtonItem:_addButtonItem permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        //[_popOver presentPopoverFromRect:CGRectMake(_barcodeButton.frame.origin.x, _barcodeButton.frame.origin.y, _barcodeButton.frame.size.width, _barcodeButton.frame.size.height) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        // [_popOver presentPopoverFromRect:self.view.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        /*}
         else{
         [_popOver dismissPopoverAnimated:YES];
         _popOver=nil;
         }
         */
    }
    else{
        [self presentViewController:nav animated:YES completion:nil];
    }
    
}

-(void)productOptionItemUpdated{
    [self reloadData];
}

-(void)reloadData{
    _nameTextField.text=_selectedProduct.selectedOption.name;
    _maxSelectedTextField.text=[NSString stringWithFormat:@"%@",@(_selectedProduct.selectedOption.maxSelected)];
    _minSelectedTextField.text=[NSString stringWithFormat:@"%@",@(_selectedProduct.selectedOption.minSelected)];
    _sortNumTextField.text=[NSString stringWithFormat:@"%@",@(_selectedProduct.selectedOption.sortNum)];
    [self.tableView reloadData];
}
@end
