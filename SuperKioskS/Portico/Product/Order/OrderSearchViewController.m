//
//  InventoryViewController.m
//
//
//  Created by Romulo Quidilig.
//  Copyright (c) 2015 Sharecle Inc. All rights reserved.
//


#import "OrderSearchViewController.h"
#import "HistoryModel.h"
#import "OrderHistory.h"
#import "SpeechBubbleView.h"
#import "AppDelegate.h"
#import "OrderHistSettingsViewController.h"
#import "OrderSummaryViewController.h"

#import "CheckoutCart.h"
#import "PaymentManager.h"
#import "InventoryModel.h"
#import "PrintManager.h"
//#import "OrderHistoryViewCell.h"
#import "OrderHistoryCollectionViewCell.h"
#import "OrderHistoryHeaderViewCell.h"
#import "defs.h"
#import "defs_order_product.h"
/*#import "InventoryListViewController.h"

#define MENU_INV_MANAGE  @"Manage"
#define MENU_INV_VIEW  @"View Products"
#define MENU_INV_RENAME @"Rename"
#define MENU_INV_PUBLISH @"Set Active"
*/


@interface OrderSearchViewController (){
   
    //NSString *imagesPath;
    //NSMutableArray *categories;
    //UIImage *newPictureImage;
   // BOOL imageChanged;
   // BOOL isUpdate;
    //NSFileManager *fileManager;
    //Product *selectedProduct;
    //NSDictionary *inventory;
    //NSArray *categorySectionTitles;
    
    NSMutableArray *historyDates;
    NSString *selectedName;
    
    UIActionSheet *asSetStatus;
    
    UIActionSheet *asSetView;
    
    //UIBarButtonItem *btnView;
   // UIBarButtonItem *btnSummary;
   // UIBarButtonItem *btnDays;
    //NSDictionary *settings;
    //HistoryModel *currentHistory;
    AppDelegate *_appDelegate;
    //nsmutabl
    NSIndexPath *selectedIndexPath;
    OrderHistory *selectedOrder;
    
    NSMutableArray *items;
    
    NSString *_search;
    
    NSString *_searchProduct;
    NSString *_searchOrderNum;
    NSString *_searchDate;
    NSString *_searchOrderBy;
    NSString *_searchStatus;
    
    
     NSArray *searchTypes;
    NSArray *statusTypes;
    
    UIBarButtonItem *_cancelButonItem;
    UIBarButtonItem *_searchButonItem;
    
    
    
}
/*@property (weak, nonatomic) IBOutlet UITextField *name;
@property (weak, nonatomic) IBOutlet UITextField *price;
@property (weak, nonatomic) IBOutlet UITextField *productCategory;
@property (weak, nonatomic) IBOutlet UIImageView *pictureFile;
@property (weak, nonatomic) IBOutlet UITextField *productID;

@property (weak, nonatomic) IBOutlet UIButton *btnSave;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerCategory;
*/
//@property (weak, nonatomic) IBOutlet UITableView *tableView;


@end

@implementation OrderSearchViewController
- (id) initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        
        /*currentHistory=[HistoryModel sharedInstance];
        
        historyDates=[[currentHistory.history allKeys] mutableCopy];
        */
    }
    return self;
}

-(void)doSearch{
    [self.view endEditing:YES];
    [self reloadData];
}

-(void)reloadData{
    
    if(items==nil)
        items=[NSMutableArray new];
    
    if([items count]>0)
        [items removeAllObjects];
    
    NSArray *result=[_appDelegate.historyModel search:_searchTextField.text withSearchType:_searchTypeTextField.text withStatus:_searchByStatusTextField.text withStartDate:_searchStartDateTextField.text withEndDate:_searchEndDateTextField.text isLive:(_appDelegate.appConfig.visibility==VISIBILITY_LIVE)?YES:NO];
    
    if([result count]>0)
        [items addObjectsFromArray:result];
    
    [_appDelegate updateBadgeOrders];
    [_collectionView reloadData];
    
    
}
-(void)doneSearch{
    [self dismissViewControllerAnimated:YES completion:nil];
}
//-(void)reloadDates{
//    [historyDates removeAllObjects];
//    NSString *documentPath= [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
//    NSError *error;
//    NSArray *dirContents= [[NSFileManager defaultManager] contentsOfDirectoryAtPath:documentPath error:&error];
//    if(error==nil){
//        if([dirContents count]>0){
//            NSPredicate *predicate=[NSPredicate predicateWithFormat:@"self ENDSWITH '.history.plist'"];
//            NSArray *onlyplist=[dirContents filteredArrayUsingPredicate:predicate];
//            if([onlyplist count]>0){
//                for (NSString *name in onlyplist) {
//                    
//                    [historyNames addObject:[name stringByReplacingOccurrencesOfString:@".history.plist" withString:@""]];
//                }
//            }
//            /*else{
//             [inventoryNames addObject:@"Untitled"];
//             }
//             */
//        }
//        /*else{
//         [inventoryNames addObject:@"Untitled"];
//         }*/
//        
//    }
//}
//
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor clearColor];
     //[[self navigationController] setNavigationBarHidden:NO animated:YES];
     _appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
   
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
        /*
         NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
         [dateFormatter setDateFormat:@"yyyy-MM-dd"];
         
         NSString *today=[dateFormatter stringFromDate:[NSDate date]];

         */
        [_appDelegate.historyModel loadHistory];
    //}

    
    
    
    
    asSetView=[[UIActionSheet alloc] initWithTitle:@"View" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:MENU_ORDER_VIEW_PAID,MENU_ORDER_VIEW_UNPAID,MENU_ORDER_VIEW_READY, MENU_ORDER_VIEW_CLOSED,MENU_ORDER_VIEW_CANC,MENU_ORDER_VIEW_ALL,nil];
    
    searchTypes=@[SEARCH_TYPE_ORDER_NUM,SEARCH_TYPE_ORDER_BY,SEARCH_TYPE_ORDER_STATUS,SEARCH_TYPE_ORDER_DATE,SEARCH_TYPE_ORDER_PROD];
    
    //statusTypes=@[ORDER,SEARCH_TYPE_ORDER_BY,SEARCH_TYPE_ORDER_STATUS,SEARCH_TYPE_ORDER_DATE,SEARCH_TYPE_ORDER_PROD];
    
    [self configurePickerView];
    
    
    _cancelButonItem=[[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneSearch)];
    
    _searchButonItem=[[UIBarButtonItem alloc] initWithTitle:@"Search" style:UIBarButtonItemStyleDone target:self action:@selector(doSearch)];
    
    self.navigationItem.leftBarButtonItem=_cancelButonItem;
    self.navigationItem.rightBarButtonItem=_searchButonItem;
   /* [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didUpdateHistoryWithNotification:)
                                                 name:NOTIFY_UPDATE_HISTORY
                                               object:nil];
    */
    
}


-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    //[self reloadData];
    // [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/*
-(void)badgeUpdateForOrders{
        if(_appDelegate.badgeOrderNumber==0)
     [ordersButtonItem setTitle:@"Orders(0)"];
     else
     [ordersButtonItem setTitle:[NSString stringWithFormat:@"Orders(%lu)",(unsigned long)_appDelegate.badgeOrderNumber]];
 
}
*/
//-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
//- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
#pragma -mark Collection View

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    NSInteger count= [items count];//[historyDates count];
    return count;//[categorySectionTitles count];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    
    NSArray *arr =[self getItemsForSection:section];
    return [arr count];
}
-(NSArray *) getItemsForSection:(NSUInteger)section{
    //NSArray *results=[_appDelegate.historyModel.history valueForKey:day];
    //if(results==nil || [results count]==0)
    //    return results;
    
    return [items objectAtIndex:section];
    
    
    /*NSMutableArray *finalResults=[NSMutableArray new];
    
    
    NSMutableArray *filterOrderStatus=[NSMutableArray new];
    
    [filterOrderStatus addObject:@(ORDER_STATUS_RECEIVED)];
    [filterOrderStatus addObject:@(ORDER_STATUS_READY)];
    
    if (_appDelegate.appConfig.showClosed) {
        [filterOrderStatus addObject:@(ORDER_STATUS_CLOSED)];//return 0.0;
    }
    
    if (_appDelegate.appConfig.showCancelled) {
        [filterOrderStatus addObject:@(ORDER_STATUS_CANC)];//return 0.0;
    }
    
    if (_appDelegate.appConfig.showRefunds) {
        [filterOrderStatus addObject:@(ORDER_STATUS_REFUND)];//return 0.0;
    }
    if (_appDelegate.appConfig.showFailed) {
        [filterOrderStatus addObject:@(ORDER_STATUS_FAILED)];//return 0.0;
    }
    
    
    NSString *p=@"orderIsLive==%@ && orderStatus IN %@";
    if(_appDelegate.appConfig.showPaid && _appDelegate.appConfig.showUnpaid)
        p=[p stringByAppendingString:@" && (orderIsPaid==YES || orderIsPaid==NO)"];
    else if(_appDelegate.appConfig.showPaid)// && !_appDelegate.appConfig.showUnpaid)
        p=[p stringByAppendingString:@" && orderIsPaid==YES"];
    else if(_appDelegate.appConfig.showUnpaid)// && !_appDelegate.appConfig.showPaid)
        p=[p stringByAppendingString:@" && orderIsPaid==NO"];
    
    
    //not working:  NSPredicate *predicate=[NSPredicate predicateWithFormat:@"(orderIsLive==%@ && orderStatus IN %@) || && orderIsPaid IN %@",@(_appDelegate.appConfig.isLive),filterOrderStatus,filterPaidStatus];
    
    NSPredicate *predicate=[NSPredicate predicateWithFormat:p,@(_appDelegate.appConfig.isLive),filterOrderStatus];
    
    
    [finalResults addObjectsFromArray:[arr filteredArrayUsingPredicate:predicate]];//[_appDelegate.historyModel.history valueForKey:_selectedDay]];
    
    return finalResults;
     */
}
/*
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
        return 1;
        
}
*/
//- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
//{
//    UICollectionReusableView *reusableview = nil;
//    
//    if (kind == UICollectionElementKindSectionHeader) {
//        OrderHistoryHeaderViewCell *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView" forIndexPath:indexPath];
//        /*
//        NSString *title = [[NSString alloc]initWithFormat:@"Recipe Group #%i", indexPath.section + 1];
//        headerView.title.text = title;
//        UIImage *headerImage = [UIImage imageNamed:@"header_banner.png"];
//        headerView.backgroundImage.image = headerImage;
//        */
//        OrderHistory *item=[items objectAtIndex:indexPath.section];
//        NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
//        [formatter setDateStyle:NSDateFormatterShortStyle];
//        [formatter setTimeStyle:NSDateFormatterShortStyle];
//        [formatter setDoesRelativeDateFormatting:YES];
//        //NSString* dateString = [formatter stringFromDate:message.createdon];
//        //return [
//        //return [formatter stringFromDate:item.orderDateTime];
//        headerView.nameLabel.text=[formatter stringFromDate:item.orderDateTime];
//        reusableview = headerView;
//    }
//    
//    if (kind == UICollectionElementKindSectionFooter) {
//        UICollectionReusableView *footerview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"FooterView" forIndexPath:indexPath];
//        
//        reusableview = footerview;
//    }
//    
//    return reusableview;
//}

/*
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    //return historyDates[section];
    OrderHistory *item=[items objectAtIndex:section];
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterShortStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDoesRelativeDateFormatting:YES];
    //NSString* dateString = [formatter stringFromDate:message.createdon];
    //return [
    return [formatter stringFromDate:item.orderDateTime];
}
*/

//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
//{
//    UICollectionReusableView *reusableview = nil;
//    
//    if (kind == UICollectionElementKindSectionHeader) {
//        //return [self headerView:indexPath];
//        
//        OrderHistoryHeaderViewCell *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"OrderHistoryHeaderViewCell" forIndexPath:indexPath];
//        NSString *title = [days objectAtIndex:indexPath.section];//[[NSString alloc]initWithFormat:@"Recipe Group #%i", indexPath.section + 1];
//        headerView.title.text = title;
//        //UIImage *headerImage = [UIImage imageNamed:@"header_banner.png"];
//        //headerView.backgroundImage.image = headerImage;
//        //headerView.backgroundColor=[UIColor whiteColor];
//        reusableview = headerView;
//        
//        
//    }
//    /*
//     if (kind == UICollectionElementKindSectionFooter) {
//     UICollectionReusableView *footerview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"FooterView" forIndexPath:indexPath];
//     
//     reusableview = footerview;
//     }
//     */
//    return reusableview;
//}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"OrderHistoryCollectionViewCell";
    
    OrderHistoryCollectionViewCell *cell = (OrderHistoryCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    //OrderHistory *item=[items objectAtIndex:indexPath.row];
    NSArray *arr=[self getItemsForSection:indexPath.section]; //[self getItemsForDay:[historyDates objectAtIndex:indexPath.section]];
    
    OrderHistory *item=[arr objectAtIndex:indexPath.row]; //[[items objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];

    cell.nameLabel.text=item.orderBy;
    //cell.numberLabel.text=[NSString stringWithFormat:@"Order# %@ %@",item.orderNumber,(item.orderIsLive)?@"":@"(TEST)"];
   // cell.numberLabel.text=[NSString stringWithFormat:@"#%@",item.orderNumber];
    cell.numberLabel.text=[NSString stringWithFormat:@"%@#%@",(item.orderIsLive)?@"":@"TST",item.orderNumber];
    cell.itemsLabel.numberOfLines=0;
    cell.itemsLabel.lineBreakMode=NSLineBreakByWordWrapping;
    
    cell.itemsLabel.text=[item toStringLabelItems];//[item toStringLabel];
     [cell.itemsLabel sizeToFit];
    
    [cell.imageView setImage:[UIImage imageNamed:@"person.png"]];
    
    NSString *peer_photo=[NSString stringWithFormat:@"%@%@.png",PREFIX_MYPHOTO, item.orderDeviceID];
    
    
    NSString *filePath=[[AppDelegate getImagesPath] stringByAppendingPathComponent:peer_photo];
    if([[NSFileManager defaultManager] fileExistsAtPath:filePath]){
        dispatch_queue_t imageQueue = dispatch_queue_create("Image Queue",NULL);
        dispatch_async(imageQueue, ^{
            
            
            NSData *imageData=imageData =[NSData dataWithContentsOfFile:filePath];
            
            
            if(!imageData) return;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if(cell.imageView){
                    [cell.imageView setImage:[UIImage imageWithData:imageData]];
                    //cell.senderPhoto.layer.cornerRadius=cell.senderPhoto.frame.size.width / 2;
                    //cell.senderPhoto.clipsToBounds = YES;
                }
            });
        });
    }
//    cell.imageView.layer.cornerRadius=cell.imageView.frame.size.width / 2;
//    cell.imageView.clipsToBounds = YES;
    [[cell layer] setBorderWidth:5.0f];
    [[cell layer] setCornerRadius:8.0f];
    
    
    if([item.orderStatus isEqualToNumber:@ORDER_STATUS_READY])
        [[cell layer] setBorderColor:[UIColor greenColor].CGColor];
    else if([item.orderStatus isEqualToNumber:@ORDER_STATUS_START])
        [[cell layer] setBorderColor:[UIColor blueColor].CGColor];
    else if([item.orderStatus isEqualToNumber:@ORDER_STATUS_RECEIVED]){
        if(item.orderIsPaid)
            [[cell layer] setBorderColor:[UIColor yellowColor].CGColor];
        else
            [[cell layer] setBorderColor:[UIColor orangeColor].CGColor];
    }
    else if([item.orderStatus isEqualToNumber:@ORDER_STATUS_FAILED])
        [[cell layer] setBorderColor:[UIColor redColor].CGColor];
    else
        [[cell layer] setBorderColor:[UIColor grayColor].CGColor];
    return cell;
}

/*
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UILabel *myLabel = [[UILabel alloc] init];
    myLabel.frame = CGRectMake(20, 8, 320, 20);
    myLabel.font = [UIFont boldSystemFontOfSize:18];
    myLabel.text = [self tableView:tableView titleForHeaderInSection:section];
    
    UIView *headerView = [[UIView alloc] init];
    [headerView addSubview:myLabel];
    
    return headerView;
}
*/

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableview = nil;
    
    if (kind == UICollectionElementKindSectionHeader) {
        //return [self headerView:indexPath];
        
        OrderHistoryHeaderViewCell *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"OrderHistoryHeaderViewCell" forIndexPath:indexPath];
        NSString *title = [[NSString alloc]initWithFormat:@"%@",[historyDates objectAtIndex: indexPath.section]];
        
        headerView.nameLabel.text = title;
        //UIImage *headerImage = [UIImage imageNamed:@"header_banner.png"];
        //headerView.backgroundImage.image = headerImage;
        //headerView.backgroundColor=[UIColor whiteColor];
        reusableview = headerView;
        
    }
    
    if (kind == UICollectionElementKindSectionFooter) {
        UICollectionReusableView *footerview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"FooterView" forIndexPath:indexPath];
        
        reusableview = footerview;
    }
    
    return reusableview;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    //OrderHistory *item=[items objectAtIndex:indexPath.row];
    NSArray *arr=[self getItemsForSection:indexPath.section]; //getItemsForDay:[historyDates objectAtIndex:indexPath.section]];
    
    OrderHistory *item=[arr objectAtIndex:indexPath.row]; //(OrderHistory *)[[items objectAtIndex:indexPath.section]
    
    NSString *lblItems=[item toStringLabelItems];
    
    CGSize bubbleSize = [SpeechBubbleView sizeForText:lblItems];//[SpeechBubbleView sizeForText:item.toStringLabel];
    
    
    //return bubbleSize.height + HEIGHT_OFFSET+25; u may use this for no image
    //bubbleSize.height=bubbleSize.height + HEIGHT_OFFSET+70;
    bubbleSize.height=bubbleSize.height + HEIGHT_OFFSET+200;
    return bubbleSize;
}
/*- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    
    
    OrderHistory *item=[items objectAtIndex:indexPath.section];
    
    
    CGSize bubbleSize = [SpeechBubbleView sizeForText:[item toStringLabelItems]];//[SpeechBubbleView sizeForText:item.toStringLabel];
    
    
    //return bubbleSize.height + HEIGHT_OFFSET+25; u may use this for no image
    return bubbleSize.height + HEIGHT_OFFSET+70;
    
}
*/
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
   
    //selectedIndexPath=indexPath;
    
   
    
    //selectedOrder=[items objectAtIndex:selectedIndexPath.row];//[orders objectAtIndex:selectedIndexPath.row];
    NSArray *arr=[self getItemsForSection:indexPath.section]; //getItemsForDay:[historyDates objectAtIndex:indexPath.section]];
    
    selectedOrder=[arr objectAtIndex:indexPath.row]; //(OrderHistory *)[[items objectAtIndex:indexPath.section]
    
    
    int status=[selectedOrder.orderStatus intValue];
    if(status!=ORDER_STATUS_CANC && status!=ORDER_STATUS_CLOSED ){
        if(selectedOrder.orderIsPaid){
            
            asSetStatus=[[UIActionSheet alloc] initWithTitle:@"Set Order Status" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:MENU_ORDER_SET_READY, MENU_ORDER_SET_CLOSED,MENU_ORDER_SET_CANC,MENU_ORDER_SET_REFUND,MENU_ORDER_PRINT,nil];
        }
        else{
            asSetStatus=[[UIActionSheet alloc] initWithTitle:@"Set Order Status" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:MENU_ORDER_SET_PAYNOW,MENU_ORDER_SET_CANC,MENU_ORDER_PRINT,nil];
        }
    }
    else{
        
        if(selectedOrder.orderIsPaid){
            
            asSetStatus=[[UIActionSheet alloc] initWithTitle:@"Set Order Status" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles: MENU_ORDER_SET_REFUND,MENU_ORDER_PRINT,nil];
        }
    }
    
    
    //}
    [asSetStatus showInView:self.view];
    //[self.collectionView deselectRowAtIndexPath:indexPath animated:NO];
}


/*

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //selectedName=[historyDates objectAtIndex:indexPath.row];
    selectedIndexPath=indexPath;
    
   // NSArray *orders=[_appDelegate.historyModel.history valueForKey:historyDates[selectedIndexPath.section]];
    
    selectedOrder=[items objectAtIndex:selectedIndexPath.section];//[orders objectAtIndex:selectedIndexPath.row];
    
    
    int status=[selectedOrder.orderStatus intValue];
        if(status!=ORDER_STATUS_CANC && status!=ORDER_STATUS_CLOSED ){
            if(selectedOrder.orderIsPaid){
                
                asSetStatus=[[UIActionSheet alloc] initWithTitle:@"Set Order Status" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:MENU_ORDER_SET_READY, MENU_ORDER_SET_CLOSED,MENU_ORDER_SET_CANC,MENU_ORDER_SET_REFUND,MENU_ORDER_PRINT,nil];
            }
            else{
                asSetStatus=[[UIActionSheet alloc] initWithTitle:@"Set Order Status" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:MENU_ORDER_SET_PAYNOW,MENU_ORDER_SET_CANC,MENU_ORDER_PRINT,nil];
            }
        }
        else{
            
            if(selectedOrder.orderIsPaid){
                
                asSetStatus=[[UIActionSheet alloc] initWithTitle:@"Set Order Status" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles: MENU_ORDER_SET_REFUND,MENU_ORDER_PRINT,nil];
            }
        }
    
        
    //}
    [asSetStatus showInView:self.view];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
}

- (UIImage *)cellBackgroundForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger rowCount = [self tableView:[self tableView] numberOfRowsInSection:indexPath.section];
    NSInteger rowIndex = indexPath.row;
    UIImage *background = nil;
    
    if (rowIndex == 0) {
        background = [UIImage imageNamed:@"cell_top.png"];
    } else if (rowIndex == rowCount - 1) {
        background = [UIImage imageNamed:@"cell_bottom.png"];
    } else {
        background = [UIImage imageNamed:@"cell_middle.png"];
    }
    
    return background;
}
*/
-(void)setEditing:(BOOL)editing animated:(BOOL)animated{
    /* editing doesnt work in collection view
    [super setEditing:editing animated:animated];
    [self.collectionView setEditing:editing animated:animated];
    if(editing){
        
    }
    else{
        
    }
     */
}



-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
   
    //NSMutableArray *orders=[_appDelegate.historyModel.history valueForKey:historyDates[indexPath.section]] ;
    
    OrderHistory *delete_item=[items objectAtIndex:indexPath.section];//[orders objectAtIndex:indexPath.row];
    
    if(editingStyle==UITableViewCellEditingStyleDelete){
        if(delete_item!=nil){
        [items removeObject:delete_item];
        
        
        [_appDelegate.historyModel saveHistory];
        [self reloadData];
       // [self.tableView reloadData];
            //if(_appDelegate.badgeOrderNumber>0)
             //   _appDelegate.badgeOrderNumber--;
            
           // [_appDelegate updateBadgeOrders];
            
        //[self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
        
    }
}
//add histoy to cart
- (void)addHistoryItemsToCart {
    CheckoutCart* checkoutCart = [CheckoutCart sharedInstance];
    [checkoutCart clearCart];
    checkoutCart.order=selectedOrder;
  
    for(OrderItem *orderItem in selectedOrder.orderItems){
                
        [checkoutCart addItem:orderItem];
       
        

        
    }
    UITabBarItem *tbi=(UITabBarItem *)[self.tabBarController.tabBar.items objectAtIndex:TAB_INDEX_CART];
    if([checkoutCart.itemsInCart count]==0)
        tbi.badgeValue=nil;
    else
        tbi.badgeValue=[NSString stringWithFormat:@"%lu",(unsigned long)[checkoutCart.itemsInCart count]];
    
    
    
    [self.tabBarController setSelectedIndex:TAB_INDEX_CART];

   
   }





-(BOOL)setOrderStatus:(NSUInteger)newStatus{
    
    NSUInteger oldStatus=[selectedOrder.orderStatus integerValue];
    
    if(oldStatus!=newStatus){
    
      
        
    selectedOrder.orderStatus=[NSNumber numberWithUnsignedInteger:newStatus];
    
        if(newStatus==ORDER_STATUS_CANC){
          
            [PaymentManager returnOrder:selectedOrder];
            
            
            //if(_appDelegate.badgeOrderNumber>0){
            //    _appDelegate.badgeOrderNumber--;
                //[_appDelegate displayBadgeOrders];
            //}
            
        }
       else if(newStatus==ORDER_STATUS_CLOSED){
        
        //first check is it needs capturing
           if(selectedOrder.orderIsCaptured){
               
               //if(_appDelegate.badgeOrderNumber>0){
               //    _appDelegate.badgeOrderNumber--;
                   // [_appDelegate displayBadgeOrders];
               //}
           }
           else{
               NSString *error=[PaymentManager performPostCapture:selectedOrder];
               if(error==nil){
                   //[self reloadData];
                //_appDelegate.badgeOrderNumber--;
               }
               else{
                   selectedOrder.orderStatus=@(oldStatus) ;
                   
                   UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Error" message:error delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                   [alert show];
                   
                   
               }
           }
           
        
        
        
       }
        
       else if(newStatus==ORDER_STATUS_READY){
           
           
           
           
       }
       else if(newStatus==ORDER_STATUS_RECEIVED){
           if(selectedOrder.orderIsPaid){
           //check out
           [self addHistoryItemsToCart];
           //we will skip saving because we have to process payment first
           return YES;
           }
       }
   
       else if(newStatus==ORDER_STATUS_REFUND){
           //[self addHistoryItemsToCart];
           NSString *error=[PaymentManager performPostRefund:selectedOrder];
           if(error==nil){
               [self reloadData];
           }
           else{
               
                   UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Error" message:error delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                   [alert show];
                   
                   
             

           }
           //return YES;
       }
        
        
    [_appDelegate.historyModel saveHistory];
    
    
    
    
    historyDates=[[_appDelegate.historyModel.history allKeys] mutableCopy];
    
    //[self.tableView reloadData];
        [self reloadData];
        
    //[_appDelegate updateBadgeOrders];
        
    }
    
    //sync
    if(selectedOrder.orderDeviceID!=nil){
                    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_DEVICE object:nil userInfo:@{@"order":selectedOrder}];
    
    }
    return YES;
}


-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
   
    if(buttonIndex==[actionSheet cancelButtonIndex])
        return;
    
    NSString *btnTitle=[actionSheet buttonTitleAtIndex:buttonIndex];
    
    if([actionSheet isEqual:asSetStatus]){
        if ([btnTitle isEqualToString:MENU_ORDER_SET_PAYNOW]) {
            
            //[self setOrderStatus:ORDER_STATUS_PAID];
            selectedOrder.orderIsPaid=YES;
        }
        else if ([btnTitle isEqualToString:MENU_ORDER_SET_UNPAID]) {
            
            [self setOrderStatus:ORDER_STATUS_RECEIVED];
            
            
        }
        else if ([btnTitle isEqualToString:MENU_ORDER_SET_READY]) {
            
            /*UIAlertView * alert =[[UIAlertView alloc ] initWithTitle:@"Rename Inventory" message:@"Enter new name" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles: nil];
            alert.alertViewStyle = UIAlertViewStylePlainTextInput;
            [alert addButtonWithTitle:@"Save"];
            [alert show];
            */
            [self setOrderStatus:ORDER_STATUS_READY];
            
        }
        else if ([btnTitle isEqualToString:MENU_ORDER_SET_CLOSED]) {
            
            
            [self setOrderStatus:ORDER_STATUS_CLOSED];
        }
        
        else if ([btnTitle isEqualToString:MENU_ORDER_SET_CANC]) {
            
            
            [self setOrderStatus:ORDER_STATUS_CANC];
        }
        else if ([btnTitle isEqualToString:MENU_ORDER_SET_REFUND]) {
            
            
            [self setOrderStatus:ORDER_STATUS_REFUND];
        }
        else if ([btnTitle isEqualToString:MENU_ORDER_PRINT]) {
            
            
            //[self setOrderStatus:ORDER_STATUS_CAPTURED];
           /* NSData *pdfData=[PrintManager PDFData:[selectedOrder toStringLabel]];
                             
            if ([UIPrintInteractionController canPrintData:pdfData]) {
                UIPrintInfo *printInfo = [UIPrintInfo printInfo];
                //printInfo.jobName = self.imageURL.lastPathComponent;
                printInfo.outputType = UIPrintInfoOutputGeneral;
                
                UIPrintInteractionController *printController = [UIPrintInteractionController sharedPrintController];
                printController.printInfo = printInfo;
                
                printController.printingItem = pdfData;//self.imageURL;
                
                //[printController presentAnimated:true completionHandler: nil];
                if(_appDelegate.isIpad){
                    [printController presentFromRect:self.view.frame inView:self.view animated:YES completionHandler:nil];
                }
                
            }
            */
           [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_PRINT_ORDER object:nil userInfo:@{@"order":selectedOrder}];
        }
    
    }
    
    else{
        if ([btnTitle isEqualToString:MENU_ORDER_VIEW_PAID]) {
            
            //[self setOrderStatus:ORDER_STATUS_PAID];
            
        }
        else if ([btnTitle isEqualToString:MENU_ORDER_VIEW_UNPAID]) {
            
            //[self setOrderStatus:ORDER_STATUS_RECEIVED];
            
            
        }
        else if ([btnTitle isEqualToString:MENU_ORDER_VIEW_READY]) {
            
            /*UIAlertView * alert =[[UIAlertView alloc ] initWithTitle:@"Rename Inventory" message:@"Enter new name" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles: nil];
             alert.alertViewStyle = UIAlertViewStylePlainTextInput;
             [alert addButtonWithTitle:@"Save"];
             [alert show];
             */
            //[self setOrderStatus:ORDER_STATUS_READY];
            
        }
        else if ([btnTitle isEqualToString:MENU_ORDER_VIEW_CLOSED]) {
            
            
           // [self setOrderStatus:ORDER_STATUS_CLOSED];
        }
        
        else if ([btnTitle isEqualToString:MENU_ORDER_VIEW_CANC]) {
            
            
            //[self setOrderStatus:ORDER_STATUS_CANC];
        }
        
        else if ([btnTitle isEqualToString:MENU_ORDER_VIEW_ALL]) {
            
            
            //[self setOrderStatus:ORDER_STATUS_CANC];
        }
    }
}
/*
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSString *btnTitle=[alertView buttonTitleAtIndex:buttonIndex];
    if([btnTitle isEqualToString:@"Save"]){
        UITextField *txtName=[alertView textFieldAtIndex:0];
        if([self renameItem:selectedName toName:txtName.text]){
            [self reloadNames];
        
            [self.tableView reloadData];
        }
        else{
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Error" message:@"Rename error." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil]
            ;
            [alert show];
        }
    }
}
*/

-(void)didUpdateHistoryWithNotification:(NSNotification *)notification{
    
    /*currentHistory=[HistoryModel sharedInstance];
    
    historyDates=[[currentHistory.history allKeys] mutableCopy];
    
    [self.tableView reloadData];
    UITabBarItem *tbi=(UITabBarItem *)[self.tabBarController.tabBar.items objectAtIndex:3];
    if(_appDelegate.badgeOrderNumber==0)
        tbi.badgeValue=nil;
    else
        tbi.badgeValue =[NSString stringWithFormat:@"%lu",(unsigned long)_appDelegate.badgeOrderNumber];
     */
    [self reloadData];
    [self.collectionView reloadData];
}

/*-(void)didSendUnpaidOrderWithNotification:(NSNotification *)notification{
 
    currentHistory=[HistoryModel sharedInstance];
    
    historyDates=[[currentHistory.history allKeys] mutableCopy];
    
    [self.tableView reloadData];
}

-(void)didSendPaidOrderWithNotification:(NSNotification *)notification{
    
    currentHistory=[HistoryModel sharedInstance];
    
    historyDates=[[currentHistory.history allKeys] mutableCopy];
    
    [self.tableView reloadData];
}

-(void)didReceivePaidOrderWithNotification:(NSNotification *)notification{
    
    currentHistory=[HistoryModel sharedInstance];
    
    historyDates=[[currentHistory.history allKeys] mutableCopy];
    
    [self.tableView reloadData];
}
 */
//-(void)showSettingsMenu{
//    //[asSetView showFromBarButtonItem:self.navigationItem.rightBarButtonItem animated:YES];
//    OrderHistSettingsViewController *destViewController= (OrderHistSettingsViewController *) [ApplicationDelegate.storyBoard instantiateViewControllerWithIdentifier:@"OrderHistSettingsViewController"];
//    //destViewController.delegate=self;
//    //destViewController.isTunedIn=YES;
//    //destViewController.channel =_dataModel.selectedBroadcast;
//    [self presentViewController:destViewController animated:YES completion:nil ];
//}
//
//-(void)showSummary{
//    
//    [self performSegueWithIdentifier:@"toOrderSummaryViewController" sender:self];
//    
//}
//
//-(void)showDays{
//    
//    [self performSegueWithIdentifier:@"toOrderDaysViewController" sender:self];
//    
//}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"toOrderSummaryViewController"]){
        OrderSummaryViewController *vc=segue.destinationViewController;
        vc.selectedDay=_appDelegate.selectedOrdersDay;
    }
}


#pragma mark - UIPicker configuration
- (void)configurePickerView {
    
    _searchTypeTextField.text=SEARCH_TYPE_ORDER_NUM;
    _pickerSearchType = [[UIPickerView alloc] init];
    _pickerSearchType.dataSource=self;
    _pickerSearchType.delegate=self;
    _pickerSearchType.showsSelectionIndicator = YES;
    [_pickerSearchType selectRow:0 inComponent:0 animated:YES];
    
    _searchByStatusTextField.text=@"";
    _pickerSeachStatus = [[UIPickerView alloc] init];
    _pickerSeachStatus.dataSource=self;
    _pickerSeachStatus.delegate=self;
    _pickerSeachStatus.showsSelectionIndicator = YES;
    [_pickerSeachStatus selectRow:0 inComponent:0 animated:YES];
    
    
    //Create and configure toolabr that holds "Done button"
    UIToolbar *pickerToolbar = [[UIToolbar alloc] init];
    pickerToolbar.barStyle = UIBarStyleBlackTranslucent;
    [pickerToolbar sizeToFit];
    
    UIBarButtonItem *flexibleSpaceLeft = [[UIBarButtonItem alloc]
                                          initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                          target:nil
                                          action:nil];
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                   style:UIBarButtonItemStyleBordered
                                                                  target:self
                                                                  action:@selector(pickerDoneButtonPressed)];
    
    UIBarButtonItem *clearButton = [[UIBarButtonItem alloc] initWithTitle:@"Clear"
                                                                    style:UIBarButtonItemStyleBordered
                                                                   target:self
                                                                   action:@selector(pickerClearButtonPressed)];
    
    [pickerToolbar setItems:[NSArray arrayWithObjects:flexibleSpaceLeft,clearButton, doneButton, nil]];
    
    _searchTypeTextField.inputView = _pickerSearchType;
    _searchTypeTextField.inputAccessoryView = pickerToolbar;
    
    _searchByStatusTextField.inputView= _pickerSeachStatus;
    _searchByStatusTextField.inputAccessoryView = pickerToolbar;
    
    
}

- (void)pickerDoneButtonPressed {
    [self.view endEditing:YES];
}

- (void)pickerClearButtonPressed {
    if([_searchTextField isFirstResponder])
        _searchTextField.text=nil;
    
}

#pragma mark - UIPicker data source

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if([pickerView isEqual:_pickerSearchType])
        return [searchTypes count];
    
    else if([pickerView isEqual:_pickerSeachStatus])
        return [statusTypes count];
    
    return 0;
}

#pragma mark - UIPicker delegate

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    if([pickerView isEqual:_pickerSearchType])
        return [searchTypes objectAtIndex:row];
    
    else if([pickerView isEqual:_pickerSeachStatus])
        return [statusTypes objectAtIndex:row];
    
    return nil;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    [self.view endEditing:YES];
    
    if([pickerView isEqual:_pickerSearchType]){
        _searchTypeTextField.text=
        [NSString stringWithFormat:@"%@",[searchTypes objectAtIndex:row]];
        
        if(_searchTextField.text.length>0){
            [self reloadData];
        }
    }
    else if([pickerView isEqual:_pickerSeachStatus]){
        _searchByStatusTextField.text=[NSString stringWithFormat:@"%@",[searchTypes objectAtIndex:row]];
        
        //if(_searchStatusTextField.text.length>0){
            [self reloadData];
        //}
    }
    
    //   }
    
    
    //}
    
    
}




@end
