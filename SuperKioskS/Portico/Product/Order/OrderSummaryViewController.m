//
//  InventoryViewController.m
//
//
//  Created by Romulo Quidilig.
//  Copyright (c) 2015 Sharecle Inc. All rights reserved.
//


#import "OrderSummaryViewController.h"
#import "HistoryModel.h"
#import "OrderHistory.h"
#import "OrderItem.h"
#import "OrderSummaryCell.h"
#import "SummaryItemCell.h"
#import "SummarySectionCell.h"
//#import "SpeechBubbleView.h"
#import "AppDelegate.h"
//#import "OrderHistSettingsViewController.h"
//#import "OrderHistoryViewController.h"
//#import "CheckoutCart.h"
#import "InventoryModel.h"
#import "defs.h"
#import "defs_order_product.h"
#import "Util.h"
/*#import "InventoryListViewController.h"

#define MENU_INV_MANAGE  @"Manage"
#define MENU_INV_VIEW  @"View Products"
#define MENU_INV_RENAME @"Rename"
#define MENU_INV_PUBLISH @"Set Active"
*/


@interface OrderSummaryViewController (){
   
    //NSString *imagesPath;
    //NSMutableArray *categories;
    //UIImage *newPictureImage;
   // BOOL imageChanged;
   // BOOL isUpdate;
    //NSFileManager *fileManager;
    //Product *selectedProduct;
    //NSDictionary *inventory;
    //NSArray *categorySectionTitles;
    
    //NSMutableArray *historyDates;
    //NSString *selectedName;
    
    //UIActionSheet *asSetStatus;
    
   // UIActionSheet *asSetView;
    
    //UIBarButtonItem *btnView;
    
    //NSDictionary *settings;
    //HistoryModel *currentHistory;
    AppDelegate *_appDelegate;
    //nsmutabl
   // NSIndexPath *selectedIndexPath;
   // OrderHistory *selectedOrder;
    
    NSMutableArray *items;
    //NSString *selectedDay;
    
    
    NSUInteger total_paid;
    NSUInteger total_paid_count;
    NSInteger total_unpaid;
    NSInteger total_unpaid_count;
    NSInteger total_cancel_count;
    NSInteger total_ccard;
    NSInteger total_ccard_count;
    NSInteger total_cash;
    NSInteger total_cash_count;
    
    NSMutableArray *products_sold;
    
    /*BOOL productOn;
    BOOL countOn;
    BOOL totalOn;
    */
    NSString *sortColumn;
    BOOL ascending_name;
    BOOL ascending_count;
    BOOL ascending_total;
}
/*@property (weak, nonatomic) IBOutlet UITextField *name;
@property (weak, nonatomic) IBOutlet UITextField *price;
@property (weak, nonatomic) IBOutlet UITextField *productCategory;
@property (weak, nonatomic) IBOutlet UIImageView *pictureFile;
@property (weak, nonatomic) IBOutlet UITextField *productID;

@property (weak, nonatomic) IBOutlet UIButton *btnSave;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerCategory;
*/
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation OrderSummaryViewController
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
    
    [_appDelegate.historyModel loadHistory];
    if(items==nil)
        items=[NSMutableArray new];
    if([items count]>0)
        [items removeAllObjects];
    
    if(products_sold==nil)
        products_sold=[NSMutableArray new];
    else
        [products_sold removeAllObjects];
    
    if(_selectedDay==nil)
        _selectedDay=[Util today];
    
    [items addObjectsFromArray:[_appDelegate.historyModel.history valueForKey:_selectedDay]];
    
    if([items count]>0){
        
         total_paid=0;
         total_paid_count=0;
         total_unpaid=0;
         total_unpaid_count=0;
         total_cancel_count=0;
         total_ccard=0;
         total_ccard_count=0;
         total_cash=0;
         total_cash_count=0;
        
        if(products_sold==nil)
            products_sold=[NSMutableArray new];
        else
            [products_sold removeAllObjects];
        
        for(OrderHistory *oh in items){
        
            if(oh.orderIsPaid){
                total_paid=total_paid+[oh.total integerValue];
                total_paid_count++;
                if([oh.chargePayType isEqualToString:ORDER_PAY_TYPE_CCARD]){
                    total_ccard=total_ccard+[oh.total integerValue];
                    total_ccard_count++;
                }
                else{
                    total_cash=total_cash+[oh.total integerValue];
                    total_cash_count++;
                }
               
                
                //if(oh.orderItems!=nil && [oh.orderItems count]>0){
                    for (OrderItem *oi in oh.orderItems) {
                        
                        
                        NSPredicate *predicate=[NSPredicate predicateWithFormat:@"productID==%@",@(oi.productID)];
                        NSArray *result=[products_sold filteredArrayUsingPredicate:predicate];
                        if([result count]>0){
                        
                            NSDictionary *dict=[result firstObject];
                            NSInteger index=[products_sold indexOfObject:dict];
                            NSInteger item_count=[[dict valueForKey:KEY_COUNT] integerValue]+oi.quantity;
                            NSInteger item_total=[[dict valueForKey:KEY_TOTAL] integerValue]+(oi.price*oi.quantity);
                            
                            //[dict setValue:@(item_count) forKey:KEY_COUNT];
                            //[dict setValue:@(item_total) forKey:KEY_TOTAL];
                            dict=@{KEY_COUNT:@(item_count), KEY_TOTAL:@(item_total),KEY_NAME:oi.name,KEY_PRODUCTID:@(oi.productID)};
                            
                            products_sold[index]=dict;
                            
                            
                        }
                        else{
                            
                            [products_sold addObject:@{KEY_COUNT:@(oi.quantity), KEY_TOTAL:@(oi.price*oi.quantity),KEY_NAME:oi.name,KEY_PRODUCTID:@(oi.productID)}];
                           
                        }
                        
                        
                    }
            

                //}
            }
            else{
                total_unpaid=total_unpaid+[oh.total integerValue];
                total_unpaid_count++;
            }
    }
        [self sort];
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor clearColor];
     _appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    sortColumn=KEY_NAME;
    ascending_name=YES;
   
/*
    NSFileManager* fileManager=[NSFileManager defaultManager];
    
    
NSString* fileName=[NSString stringWithFormat:@"%@.server-history.plist",_appDelegate.historyModel.filename];
    if ([fileManager fileExistsAtPath:[[AppDelegate getDocumentsPath] stringByAppendingPathComponent:fileName]]) {
        [historyNames addObject:_appDelegate.historyModel.filename];
    }

    currentHistory=[HistoryModel sharedInstance];
    
    if(![selectedName isEqualToString:currentHistory.filename]){
        currentHistory.filename=selectedName;
        
  */
        
    
    //}

    
    //asSetStatus=[[UIActionSheet alloc] initWithTitle:@"Set Order Status" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:MENU_ORDER_SET_PAID,MENU_ORDER_SET_UNPAID,MENU_ORDER_SET_READY, MENU_ORDER_SET_CLOSED,MENU_ORDER_SET_CANC,nil];
   
   // asSetView=[[UIActionSheet alloc] initWithTitle:@"View" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:MENU_ORDER_VIEW_PAID,MENU_ORDER_VIEW_UNPAID,MENU_ORDER_VIEW_READY, MENU_ORDER_VIEW_CLOSED,MENU_ORDER_VIEW_CANC,MENU_ORDER_VIEW_ALL,nil];
    
  //  btnView=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(showViewMenu)];
    
   // self.navigationItem.rightBarButtonItem=btnView;
    
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
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section==0)
        return 3;//[historyDates count];
    else if(section==1)
        return [products_sold count];
    else return 0;
        
}
/*
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return historyDates[section];
}
 */
- (UITableViewCell *)cellSummaryTotals:(NSIndexPath *)indexPath
{
   
    OrderSummaryCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"ordersummary_cell" forIndexPath:indexPath];
    if(cell==nil){
        cell=[[OrderSummaryCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ordersummary_cell"];
    }
    
    if(indexPath.row==0){
        cell.nameLabel.text=@"Total Charge";
        cell.valueLabel.text=[NSString stringWithFormat:@"%.02f",(float)total_ccard/100];
    }
    else if(indexPath.row==1){
        cell.nameLabel.text=@"Total Cash";
        cell.valueLabel.text=[NSString stringWithFormat:@"%.02f",(float)total_cash/100];
    }
    else if(indexPath.row==2){
        cell.nameLabel.text=@"Total Sale";
        cell.valueLabel.text=[NSString stringWithFormat:@"%.02f",(float)total_paid/100];
    }

    
    
    return cell;
}

- (UITableViewCell *)cellSummaryItems:(NSIndexPath *)indexPath
{
    
    SummaryItemCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"summaryitem_cell" forIndexPath:indexPath];
    if(cell==nil){
        cell=[[SummaryItemCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"summaryitem_cell"];
    }
    
    
        NSDictionary *dict_item=[products_sold objectAtIndex:indexPath.row];
        cell.productLabel.text=[dict_item valueForKey:KEY_NAME];
        cell.countLabel.text=[NSString stringWithFormat:@"%@",[dict_item valueForKey:KEY_COUNT]];
    
    cell.totalLabel.text=[NSString stringWithFormat:@"%.02f",(float)[[dict_item valueForKey:KEY_TOTAL] integerValue]/100];
    
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section==0)
        return [self cellSummaryTotals:indexPath];

    
    else if(indexPath.section==1)
        return [self cellSummaryItems:indexPath];
    else
        return nil;
        
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if(section==1){
    static NSString* headerCellIdentifier=@"summarysection_cell";
    SummarySectionCell *cell=[tableView dequeueReusableCellWithIdentifier:headerCellIdentifier];
    /*ProductCategory *pc=[_sortedCategories objectAtIndex:section];
    
    cell.nameLabel.text =pc.name;
    
    NSString *filePath=[[AppDelegate getImagesPath] stringByAppendingPathComponent:pc.pictureFile];
    //check if cached
    if([[NSFileManager defaultManager] fileExistsAtPath:filePath])
        cell.sectionImageView.image=[[UIImage alloc] initWithContentsOfFile:filePath];
    
    if(!pc.expanded){
        //cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        [cell.expandButton setImage:[UIImage imageNamed:@"expand_arrow"] forState:UIControlStateNormal];
        
        
    }
    else{
        [cell.expandButton setImage:[UIImage imageNamed:@"collapse_arrow"] forState:UIControlStateNormal];
        
    }
     */
    [cell.productButton addTarget:self action:@selector(productAction:) forControlEvents:UIControlEventTouchUpInside];
    [cell.countButton addTarget:self action:@selector(countAction:) forControlEvents:UIControlEventTouchUpInside];
    [cell.totalButton addTarget:self action:@selector(totalAction:) forControlEvents:UIControlEventTouchUpInside];
    //cell.productButton.tag=section;
    //cell.backgroundColor=[UIColor whiteColor];
    return cell;
    }
    return nil;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section==1)
        return 60.0;
    else
        return 10.0;
}
/*
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
   
    
    
    
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
        [self reloadData];
       // [self.tableView reloadData];
            if(_appDelegate.badgeOrderNumber>0)
                _appDelegate.badgeOrderNumber--;
            
            UITabBarItem *tbi=(UITabBarItem *)[self.tabBarController.tabBar.items objectAtIndex:TAB_INDEX_ORDERS];
            if(_appDelegate.badgeOrderNumber==0)
                tbi.badgeValue=nil;
            else
                tbi.badgeValue =[NSString stringWithFormat:@"%lu",(unsigned long)_appDelegate.badgeOrderNumber];
            
        //[self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
        
    }
}
*/

-(void)didUpdateHistoryWithNotification:(NSNotification *)notification{
    
   
    [self reloadData];
    [self.tableView reloadData];
}

-(void)productAction:(id)sender{
    

    sortColumn=KEY_NAME;
    [self sort];
    [self.tableView reloadData];
    
}
-(void)countAction:(id)sender{
    
    sortColumn=KEY_COUNT;
    [self sort];
    [self.tableView reloadData];
}
-(void)totalAction:(id)sender{
    
    sortColumn=KEY_TOTAL;
    [self sort];
    [self.tableView reloadData];
}

-(void)sort{
    NSSortDescriptor *valueDescriptors=nil;
    if([sortColumn isEqualToString:KEY_NAME]){
        if(ascending_name)
            ascending_name=NO;
        else
            ascending_name=YES;
        
        
            valueDescriptors=[[NSSortDescriptor alloc] initWithKey:KEY_NAME ascending:ascending_name];
    }
    else if([sortColumn isEqualToString:KEY_COUNT]){
        if(ascending_count)
            ascending_count=NO;
        else
            ascending_count=YES;
        valueDescriptors=[[NSSortDescriptor alloc] initWithKey:KEY_COUNT ascending:ascending_count];
    }
    else if([sortColumn isEqualToString:KEY_TOTAL]){
        if(ascending_total)
            ascending_total=NO;
        else
            ascending_total=YES;
        valueDescriptors=[[NSSortDescriptor alloc] initWithKey:KEY_TOTAL ascending:ascending_total];
    }
   
        NSArray *descriptors=[NSArray arrayWithObject:valueDescriptors];
        products_sold= [[products_sold sortedArrayUsingDescriptors:descriptors] mutableCopy] ;

    
    
}

@end
