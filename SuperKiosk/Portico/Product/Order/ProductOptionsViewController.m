//
//  ProductOptionsViewController.m
//  superkiosk
//
//  Created by Katherine Sheehy on 8/23/16.
//  Copyright © 2016 Appcoda. All rights reserved.
//

#import "ProductOptionsViewController.h"
#import "Product.h"
#import "ProductOption.h"
#import "ProductOptionItem.h"
#import "ProductOptionItemCell.h"
#import "Util.h"
@interface ProductOptionsViewController (){
UIBarButtonItem *_doneButtonItem;
UIBarButtonItem *_clearButtonItem;
}
@end

@implementation ProductOptionsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    _clearButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"Clear" style:UIBarButtonItemStyleBordered target:self action:@selector(clearButtonTapped:)];
    
    _doneButtonItem=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(doneButtonTapped:)];
    self.navigationItem.rightBarButtonItems=@[_doneButtonItem, _clearButtonItem];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Incomplete implementation, return the number of sections
    NSInteger count=[_selectedProduct.options count];
    //if(count==0)
      //  count=1;
    
    return count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete implementation, return the number of rows
    ProductOption *po=[_selectedProduct.options objectAtIndex:section];
    NSInteger count=[po.selections count];
    //if(count==0)
      //count=1;
    return count;
    
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ProductOptionItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ProductOptionItemCell" forIndexPath:indexPath];
    ProductOption *po=[_selectedProduct.options objectAtIndex:indexPath.section];
    ProductOptionItem *poi=[po.selections objectAtIndex:indexPath.row];
    
    //cell.selectLabel.text=[NSString stringWithFormat:@"%@ %.2f", poi.title,(float)(_selectedProduct.price+poi.addlCost)/100];
    cell.selectLabel.text=[NSString stringWithFormat:@"%@ %@", poi.title,[Util priceIntToString:(_selectedProduct.price+poi.addlCost) currency:nil]];
    
    
    
    return cell;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    ProductOption *po=[_selectedProduct.options objectAtIndex:section];
    if(po.maxSelected>0)
        return [NSString stringWithFormat:@"%@ (Select %@)", po.name,@(po.maxSelected)];
    else
        return po.name;
        
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

-(void)doneButtonTapped:(id)sender{
    [self.delegate productOptionDone];
    [self dismissViewControllerAnimated:YES completion:nil];
}
  -(void)clearButtonTapped:(id)sender{
      for(ProductOption *po in _selectedProduct.options){
          for(ProductOptionItem *poi in po.selections){
              poi.selected=NO;
          }
      }
      [self.tableView reloadData];
  }

@end
