//
//  AddProductOptionItemViewController.m
//  superkiosks
//
//  Created by Katherine Sheehy on 8/22/16.
//  Copyright © 2016 Sharecle. All rights reserved.
//

#import "EditProductOptionItemViewController.h"
#import "AppDelegate.h"

@interface EditProductOptionItemViewController (){
    AppDelegate *_appDelegate;
    UIBarButtonItem *saveButtonItem;
}
@end

@implementation EditProductOptionItemViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _appDelegate=ApplicationDelegate;
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    saveButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(saveButtonTapped:)];
    self.navigationItem.rightBarButtonItem=saveButtonItem;
    _addedCostTextField.keyboardType=UIKeyboardTypeNumberPad;
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    _nameTextField.text=_selectedProduct.selectedOption.selectedOptionItem.title;
    float addedCost=(float)_selectedProduct.selectedOption.selectedOptionItem.addlCost/100;
    _addedCostTextField.text=[NSString stringWithFormat:@"%@", @(addedCost)];
    _sortNumTextField.text=[NSString stringWithFormat:@"%@", @(_selectedProduct.selectedOption.selectedOptionItem.sortNum)];
    
    
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

-(void)saveButtonTapped:(id *)sender{
    
    self.editing=NO;
    
    NSString *name=[_nameTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" "]];
    
    if(name.length==0){
        [AppDelegate toast:@"Selection name is required." duration:2.0];
        return;
    }
    
    float addedCost=0.0;
    NSInteger sortNum=0;
    @try{
        addedCost=[_addedCostTextField.text floatValue];
        sortNum=[_sortNumTextField.text integerValue];
    }
    @catch(NSException *e){
        [AppDelegate toast:@"Invalid number." duration:2.0];
        return;
    }
    
    
    _selectedProduct.selectedOption.selectedOptionItem.title=name;
    _selectedProduct.selectedOption.selectedOptionItem.addlCost=addedCost*100;
    _selectedProduct.selectedOption.selectedOptionItem.sortNum=sortNum;
    
    if(_selectedProduct.selectedOption.selections==nil)
        _selectedProduct.selectedOption.selections=[NSMutableArray new];
    
    if(_selectedProduct.selectedOption.selectedOptionItem.isNew){
        
        
        _selectedProduct.selectedOption.selectedOptionItem.isNew=NO;
        [_selectedProduct.selectedOption.selections addObject:_selectedProduct.selectedOption.selectedOptionItem];
    }
    
    
     if(_selectedProduct.selectedOption.isNew){
     _selectedProduct.selectedOption.isNew=NO;
     
     if(_selectedProduct.options==nil)
     _selectedProduct.options=[NSMutableArray new];
     [_selectedProduct.options addObject:_selectedProduct.selectedOption];
         
         
     
     }
    
    [_appDelegate.inventoryModel saveInventory];
    if(_appDelegate.isIpad){
    
        
        
        [self.delegate productOptionItemUpdated];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else{
        [self.delegate productOptionItemUpdated];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

@end
