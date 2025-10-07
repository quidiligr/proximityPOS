//
//  InventoryViewController.m
//
//
//  Created by Romulo Quidilig.
//  Copyright (c) 2015 Sharecle Inc. All rights reserved.
//


#import "OrderDaysViewController.h"
#import "HistoryModel.h"
#import "OrderHistory.h"
//#import "SpeechBubbleView.h"
#import "AppDelegate.h"
//#import "OrderHistSettingsViewController.h"
#import "OrderHistoryViewController.h"
//#import "CheckoutCart.h"
#import "InventoryModel.h"
#import "defs.h"
#import "defs_order_product.h"
/*#import "InventoryListViewController.h"

#define MENU_INV_MANAGE  @"Manage"
#define MENU_INV_VIEW  @"View Products"
#define MENU_INV_RENAME @"Rename"
#define MENU_INV_PUBLISH @"Set Active"
*/


@interface OrderDaysViewController (){
   
   
    
    NSMutableArray *historyDates;
    NSString *selectedName;
    
    UIActionSheet *asSetStatus;
    
    UIActionSheet *asSetView;
    
    
    AppDelegate *_appDelegate;
    
    NSIndexPath *selectedIndexPath;
    OrderHistory *selectedOrder;
    
   // NSString *selectedDay;
    
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation OrderDaysViewController
- (id) initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        
        /*currentHistory=[HistoryModel sharedInstance];
        
        historyDates=[[currentHistory.history allKeys] mutableCopy];
        */
    }
    return self;
}

-(void)reloadData{
    //if(_appDelegate.isServer){
        //currentHistory=_appDelegate.historyModel;
    NSSortDescriptor *valueDescriptors=[[NSSortDescriptor alloc] initWithKey:@"self" ascending:YES];
    NSArray *descriptors=[NSArray arrayWithObject:valueDescriptors];
    
    
    NSArray *sortedArray=[[_appDelegate.historyModel.history allKeys] sortedArrayUsingDescriptors:descriptors];
    
       // historyDates=[[_appDelegate.historyModel.history allKeys] mutableCopy];
    if(historyDates==nil)
        historyDates=[NSMutableArray new];
    
    [historyDates removeAllObjects];
    
     [historyDates addObjectsFromArray:sortedArray];
    
    

    
   
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor clearColor];
     _appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
   

        
        [_appDelegate.historyModel loadHistory];
    
   
    asSetView=[[UIActionSheet alloc] initWithTitle:@"View" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:MENU_ORDER_VIEW_PAID,MENU_ORDER_VIEW_UNPAID,MENU_ORDER_VIEW_READY, MENU_ORDER_VIEW_CLOSED,MENU_ORDER_VIEW_CANC,MENU_ORDER_VIEW_ALL,nil];
    
  
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didUpdateHistoryWithNotification:)
                                                 name:NOTIFY_UPDATE_HISTORY
                                               object:nil];
    
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self reloadData];
     [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    //return [historyDates count];
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
     return [historyDates count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"orderdays_cell" forIndexPath:indexPath];
    if(cell==nil){
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"orderdays_cell"];
    }
   
    cell.textLabel.text=historyDates[indexPath.row];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    /*
        selectedDay=historyDates[indexPath.row];
    [self performSegueWithIdentifier:@"toOrderHistoryViewController" sender:self];
    */
   _appDelegate.selectedOrdersDay=historyDates[indexPath.row];
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)setEditing:(BOOL)editing animated:(BOOL)animated{
    [super setEditing:editing animated:animated];
    [self.tableView setEditing:editing animated:animated];
    if(editing){
        
    }
    else{
        
    }
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
   
    NSMutableArray *orders=[_appDelegate.historyModel.history valueForKey:historyDates[indexPath.section]] ;
    
    OrderHistory *delete_item=[orders objectAtIndex:indexPath.row];
    
    if(editingStyle==UITableViewCellEditingStyleDelete){
        if(delete_item!=nil){
        [orders removeObject:delete_item];
        
        
        [_appDelegate.historyModel saveHistory];
             [_appDelegate updateBadgeOrders];
        [self reloadData];
       // [self.tableView reloadData];
        //    if(_appDelegate.badgeOrderNumber>0)
          //      _appDelegate.badgeOrderNumber--;
            
           
            
        //[self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
        
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    /*
    OrderHistoryViewController *destController=segue.destinationViewController;
    destController.selectedDay=selectedDay;
     */
}




-(void)didUpdateHistoryWithNotification:(NSNotification *)notification{
    
   
    [self reloadData];
    [self.tableView reloadData];
}



@end
