//
//  InventoryViewController.m
//
//
//  Created by Romulo Quidilig.
//  Copyright (c) 2015 Sharecle Inc. All rights reserved.
//


#import "OrderHistoryViewController.h"
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
#import "TrashViewController.h"
#import "defs.h"
#import "defs_order_product.h"
#import "Util.h"
/*#import "InventoryListViewController.h"

#define MENU_INV_MANAGE  @"Manage"
#define MENU_INV_VIEW  @"View Products"
#define MENU_INV_RENAME @"Rename"
#define MENU_INV_PUBLISH @"Set Active"
*/


@interface OrderHistoryViewController (){
   
    NSTimer *timerOrder;
    
    NSMutableArray *historyDates;
    NSString *selectedName;
    
    UIActionSheet *asSetStatus;
    
    UIActionSheet *asSetView;
    
    UIActionSheet *asMainMenu;
    
    /*
    UIBarButtonItem *btnSettings;
    UIBarButtonItem *btnSummary;
    UIBarButtonItem *_searchButtonItem;
    */
     
    UIBarButtonItem *_mainMenuButtonItem;
    
    AppDelegate *_appDelegate;
   
    NSIndexPath *selectedIndexPath;
    OrderHistory *selectedOrder;
    
    //NSMutableArray *items;
    
    
    NSArray *searchTypes;
    
   
    
    NSMutableDictionary *_history_dict;
}


@end

@implementation OrderHistoryViewController
- (id) initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        
        /*currentHistory=[HistoryModel sharedInstance];
        
        historyDates=[[currentHistory.history allKeys] mutableCopy];
        */
    }
    return self;
}

-(NSArray *) getItemsForDay:(NSString *)day{
    NSArray *results=[_appDelegate.historyModel.history valueForKey:day];
    if(results==nil || [results count]==0)
        return results;
    
    NSMutableArray *finalResults=[NSMutableArray new];
    
    
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
    
    NSPredicate *predicate=[NSPredicate predicateWithFormat:p,@((_appDelegate.appConfig.visibility==VISIBILITY_LIVE)?YES:NO),filterOrderStatus];
    
    
    [finalResults addObjectsFromArray:[results filteredArrayUsingPredicate:predicate]];//[_appDelegate.historyModel.history valueForKey:_selectedDay]];

    return finalResults;
}

-(void)reloadData{
       //get headers
    if(_history_dict==nil)
        _history_dict=[NSMutableDictionary new];
    [_history_dict removeAllObjects];
    
    
    if(historyDates==nil)
        historyDates=[NSMutableArray new];
    [historyDates removeAllObjects];
    
    NSDictionary *result=[_appDelegate.historyModel synchFilteredHistory:(_appDelegate.appConfig.visibility==VISIBILITY_LIVE)?YES:NO showClosed:_appDelegate.appConfig.showClosed showCancelled:_appDelegate.appConfig.showCancelled showRefunds:_appDelegate.appConfig.showRefunds showFailed:_appDelegate.appConfig.showFailed showPaid:_appDelegate.appConfig.showPaid showUnpaid:_appDelegate.appConfig.showUnpaid];
    
   [_appDelegate updateBadgeOrders];
    
    if(result!=nil){
        
        _history_dict=[result valueForKey:@"results"] ;
        
    
    /*
    NSSortDescriptor *valueDescriptors=[[NSSortDescriptor alloc] initWithKey:@"self" ascending:NO];
    NSArray *descriptors=[NSArray arrayWithObject:valueDescriptors];
    
    
    NSArray *sortedArray=[[_appDelegate.historyModel.history allKeys] sortedArrayUsingDescriptors:descriptors];
    */
    // historyDates=[[_appDelegate.historyModel.history allKeys] mutableCopy];
    
    
    
    
    
    //[historyDates addObjectsFromArray:sortedArray];
    
    NSArray *sortedArray=[_history_dict allKeys];
    if(sortedArray!=nil && [sortedArray count]>0){
        [historyDates addObjectsFromArray:sortedArray];
    }
    
    }
    
    [self.collectionView reloadData];
    
   
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

    
    //asSetStatus=[[UIActionSheet alloc] initWithTitle:@"Set Order Status" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:MENU_ORDER_SET_PAID,MENU_ORDER_SET_UNPAID,MENU_ORDER_SET_READY, MENU_ORDER_SET_CLOSED,MENU_ORDER_SET_CANC,nil];
   
    
    
    asSetView=[[UIActionSheet alloc] initWithTitle:@"View" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:MENU_ORDER_VIEW_PAID,MENU_ORDER_VIEW_UNPAID,MENU_ORDER_VIEW_READY, MENU_ORDER_VIEW_CLOSED,MENU_ORDER_VIEW_CANC,MENU_ORDER_VIEW_ALL,nil];
    /*
    btnSettings=[[UIBarButtonItem alloc] initWithTitle:@"Settings" style:UIBarButtonItemStyleBordered target:self action:@selector(showSettings)];
    
    btnSummary=[[UIBarButtonItem alloc] initWithTitle:@"Summary" style:UIBarButtonItemStyleBordered target:self action:@selector(showSummary)];
    
    _searchButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"Search" style:UIBarButtonItemStyleBordered target:self action:@selector(searchAction:)];
   */
    asMainMenu=[[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:MAINMENU_ORDERHISTORY_SEARCH,MAINMENU_ORDERHISTORY_SETTINGS,MAINMENU_ORDERHISTORY_REPORTS,MAINMENU_ORDERHISTORY_EMPTYTRASH,nil];
    
    _mainMenuButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"Menu" style:UIBarButtonItemStyleBordered target:self action:@selector(showMainMenu:)];
    
    self.navigationItem.rightBarButtonItem=_mainMenuButtonItem;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didUpdateHistoryWithNotification:)
                                                 name:NOTIFY_UPDATE_HISTORY
                                               object:nil];
    
    
}


-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self reloadData];
    if(timerOrder==nil){
        timerOrder=[NSTimer scheduledTimerWithTimeInterval:60 target:self selector:@selector(reloadData) userInfo:nil repeats:YES];
    }
    // [self.tableView reloadData];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    if(timerOrder!=nil){
        [timerOrder invalidate];
        timerOrder=nil;
    }
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
    NSInteger count= [historyDates count];
    return count;//[categorySectionTitles count];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    /*
    NSInteger count=[items count];
    if(count>0){
        //self.navigationItem.rightBarButtonItems=@[btnView, btnSummary,self.editButtonItem];
        self.navigationItem.rightBarButtonItems=@[btnSettings, btnSummary,self.editButtonItem];
        
    }
    else{
        //self.navigationItem.rightBarButtonItems=nil;
        //self.navigationItem.rightBarButtonItems=@[btnSettings,btnDays, btnSummary];
        self.navigationItem.rightBarButtonItems=@[btnSettings,btnSummary];
    }
     */
    NSArray *arr =[_history_dict valueForKey:[historyDates objectAtIndex:section]]; //[self getItemsForDay:[historyDates objectAtIndex:section]];
    return [arr count];
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

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"OrderHistoryCollectionViewCell";
    
    OrderHistoryCollectionViewCell *cell = (OrderHistoryCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
   // NSArray *arr=[self getItemsForDay:[historyDates objectAtIndex:indexPath.section]];
    NSArray *arr =[_history_dict valueForKey:[historyDates objectAtIndex:indexPath.section]];
    OrderHistory *item=[arr objectAtIndex:indexPath.row]; //[[items objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    cell.agoLabel.text=[Util displayTime:item.orderDateTime];
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

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    //OrderHistory *item=(OrderHistory *)[items objectAtIndex:indexPath.row];
    NSArray *arr=[self getItemsForDay:[historyDates objectAtIndex:indexPath.section]];
    
    OrderHistory *item=[arr objectAtIndex:indexPath.row]; //(OrderHistory *)[[items objectAtIndex:indexPath.section] objectAtIndex:indexPath.section];

    
    NSString *lblItems=[item toStringLabelItems];
    
    //CGSize bubbleSize = [SpeechBubbleView sizeForText:lblItems];//CGSize bubbleSize = [SpeechBubbleView sizeForText:lblItems];//[SpeechBubbleView sizeForText:item.toStringLabel];
    CGSize cellSize=[lblItems sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:24.0]}];
   
   // bubbleSize.height=bubbleSize.height + HEIGHT_OFFSET+200;
    if(cellSize.height>37.0){ //37 is current height of the label in storyboard
        //cellSize.height=160.0+(cellSize.height-37.0);
        cellSize.height=220.0+(cellSize.height-37.0);
        
    }
    
    return cellSize;
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
   
    selectedIndexPath=indexPath;
    
   
    
    //selectedOrder=[items objectAtIndex:selectedIndexPath.row];//[orders objectAtIndex:selectedIndexPath.row];
    NSArray *arr =[_history_dict valueForKey:[historyDates objectAtIndex:indexPath.section]];
    
    selectedOrder=[arr objectAtIndex:indexPath.row];
    
    int status=[selectedOrder.orderStatus intValue];
    
    if(status!=ORDER_STATUS_CANC && status!=ORDER_STATUS_CLOSED){
        if(selectedOrder.orderIsPaid){
            
            asSetStatus=[[UIActionSheet alloc] initWithTitle:@"Set Order Status" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:MENU_ORDER_SET_READY, MENU_ORDER_SET_CLOSED,MENU_ORDER_SET_CANC,MENU_ORDER_SET_REFUND,(selectedOrder.deleteStatus!=0)?MENU_ORDER_SET_UNDELETE:MENU_ORDER_SET_DELETED,MENU_ORDER_PRINT,nil];
        }
        else{
            asSetStatus=[[UIActionSheet alloc] initWithTitle:@"Set Order Status" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:MENU_ORDER_SET_PAYNOW,MENU_ORDER_SET_CANC,(selectedOrder.deleteStatus!=0)?MENU_ORDER_SET_UNDELETE:MENU_ORDER_SET_DELETED,MENU_ORDER_PRINT,nil];
        }
    }
    else{
        
        if(selectedOrder.orderIsPaid){
            
            asSetStatus=[[UIActionSheet alloc] initWithTitle:@"Set Order Status" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles: MENU_ORDER_SET_REFUND,(selectedOrder.deleteStatus!=0)?MENU_ORDER_SET_UNDELETE:MENU_ORDER_SET_DELETED,MENU_ORDER_PRINT,nil];
        }
        else{
            
            asSetStatus=[[UIActionSheet alloc] initWithTitle:@"Set Order Status" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:MENU_ORDER_SET_PAYNOW,MENU_ORDER_SET_CANC,(selectedOrder.deleteStatus!=0)?MENU_ORDER_SET_UNDELETE:MENU_ORDER_SET_DELETED,MENU_ORDER_PRINT,nil];
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


/*
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
   
    //NSMutableArray *orders=[_appDelegate.historyModel.history valueForKey:historyDates[indexPath.section]] ;
    
    OrderHistory *delete_item=[items objectAtIndex:indexPath.section];//[orders objectAtIndex:indexPath.row];
    
    if(editingStyle==UITableViewCellEditingStyleDelete){
        if(delete_item!=nil){
        [items removeObject:delete_item];
        
        
        [_appDelegate.historyModel saveHistory];
        [self reloadData];
       // [self.tableView reloadData];
        //    if(_appDelegate.badgeOrderNumber>0)
        //        _appDelegate.badgeOrderNumber--;
            
       //     [_appDelegate displayBadgeOrders];
            
        //[self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
        
    }
}
*/

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



-(void)setDeleted:(BOOL)deleted{
    selectedOrder.deleteStatus=(deleted)?1:0;
    [_appDelegate.historyModel saveHistory];
    
    if(selectedOrder.orderDeviceID!=nil){
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_DEVICE object:nil userInfo:@{@"order":selectedOrder}];
        
    }
    [self reloadData];

}

-(BOOL)setOrderStatus:(NSUInteger)newStatus{
    
    NSUInteger oldStatus=[selectedOrder.orderStatus integerValue];
    
    if(oldStatus!=newStatus){
    
      
        
    selectedOrder.orderStatus=[NSNumber numberWithUnsignedInteger:newStatus];
    
        if(newStatus==ORDER_STATUS_CANC){
          
            [PaymentManager returnOrder:selectedOrder];
            
            /*
            if(_appDelegate.badgeOrderNumber>0){
                _appDelegate.badgeOrderNumber--;
                //[_appDelegate displayBadgeOrders];
            }
             */
            
        }
       else if(newStatus==ORDER_STATUS_CLOSED){
        
        //first check is it needs capturing
           if(selectedOrder.orderIsCaptured){
               /*
               if(_appDelegate.badgeOrderNumber>0){
                   _appDelegate.badgeOrderNumber--;
                   // [_appDelegate displayBadgeOrders];
               }
                */
           }
           else{
               NSString *error=[PaymentManager performPostCapture:selectedOrder];
               if(error==nil){
                   [self reloadData];
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
           if(error==nil)
               [self reloadData];
           else{
               
                   UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Error" message:error delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                   [alert show];
                   
                   
             

           }
           //return YES;
       }
        
        
    [_appDelegate.historyModel saveHistory];
    
    
    
    
    //historyDates=[[_appDelegate.historyModel.history allKeys] mutableCopy];
    
    //[self.tableView reloadData];
        [self reloadData];
        
    //[_appDelegate displayBadgeOrders];
        
    }
    
    //sync
    if(selectedOrder.orderDeviceID!=nil){
                    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_DEVICE object:nil userInfo:@{@"order":selectedOrder}];
    
    }
    return YES;
}

-(void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{
//-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
   
    if(buttonIndex==[actionSheet cancelButtonIndex])
        return;
    
    NSString *btnTitle=[actionSheet buttonTitleAtIndex:buttonIndex];
    
    if([actionSheet isEqual:asMainMenu]){
        if ([btnTitle isEqualToString:MAINMENU_ORDERHISTORY_SEARCH]) {
            [self searchAction:nil];
        }
        else if ([btnTitle isEqualToString:MAINMENU_ORDERHISTORY_SETTINGS]) {
            [self showSettings];
        }
        else if ([btnTitle isEqualToString:MAINMENU_ORDERHISTORY_REPORTS]) {
            [self showSummary];
        }
        else if ([btnTitle isEqualToString:MAINMENU_ORDERHISTORY_EMPTYTRASH]) {
            [self emptyTrash];
        }
    }
    
    else if([actionSheet isEqual:asSetStatus]){
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
        else if ([btnTitle isEqualToString:MENU_ORDER_SET_DELETED]) {
            
            
            //selectedOrder.orderIsDeleted=YES;
            [self setDeleted:YES];
        }
        else if ([btnTitle isEqualToString:MENU_ORDER_SET_UNDELETE]) {
            
            
            //selectedOrder.orderIsDeleted=NO;
            [self setDeleted:NO];
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
-(void)showSettings{
    /*
    OrderHistSettingsViewController *destViewController= (OrderHistSettingsViewController *) [ApplicationDelegate.storyBoard instantiateViewControllerWithIdentifier:@"OrderHistSettingsViewController"];
    
    [self presentViewController:destViewController animated:YES completion:nil ];
     */
    
        OrderHistSettingsViewController *vc=[_appDelegate.storyBoard instantiateViewControllerWithIdentifier:@"OrderHistSettingsViewController"];
        //vc.delegate=self;
        //vc.searchText=_searchTextField.text;
       // vc.selectedInventory=_selectedInventory;
        UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:vc];
        
        if(_appDelegate.isIpad){
            //if(_popOver==nil){
            
            
            _popOver=[[UIPopoverController alloc] initWithContentViewController:nav];
            //_chatPopover.popoverContentSize=CGSizeMake(self.view.frame.size.width/2, self.view.frame.size.height);
            _popOver.popoverContentSize=CGSizeMake(200.0, self.view.frame.size.height);
            [_popOver presentPopoverFromBarButtonItem:_mainMenuButtonItem permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
            //[_popOver presentPopoverFromRect:CGRectMake(_searchTextField.frame.origin.x, _searchTextField.frame.origin.y, _searchTextField.frame.size.width, _searchTextField.frame.size.height) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
            /*}
             else{
             [_popOver dismissPopoverAnimated:YES];
             _popOver=nil;
             }
             */
        }
        else{
            //[self performSegueWithIdentifier:@"toMenuSearchViewController" sender:self];
            [self presentViewController:nav animated:YES completion:nil];
        }
}

-(void)emptyTrash{
    //[_appDelegate.historyModel emtpyTrash];
    //[self performSegueWithIdentifier:@"toTrashViewController" sender:self];
    if([_appDelegate.historyModel trashCount]==0){
        [AppDelegate toast:@"Trash is empty" duration:2.0];
        return;
    }
    
    
    if(_appDelegate.isIpad){        //if(_popOver==nil){
        TrashViewController *vc=[_appDelegate.storyBoard instantiateViewControllerWithIdentifier:@"TrashViewController"];
        //vc.delegate=self;
        //vc.searchText=_searchTextField.text;
        // vc.selectedInventory=_selectedInventory;
        UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:vc];
        
        _popOver=[[UIPopoverController alloc] initWithContentViewController:nav];
        //_chatPopover.popoverContentSize=CGSizeMake(self.view.frame.size.width/2, self.view.frame.size.height);
        _popOver.popoverContentSize=CGSizeMake(200.0, self.view.frame.size.height);
        [_popOver presentPopoverFromBarButtonItem:_mainMenuButtonItem permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        //[_popOver presentPopoverFromRect:CGRectMake(_searchTextField.frame.origin.x, _searchTextField.frame.origin.y, _searchTextField.frame.size.width, _searchTextField.frame.size.height) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        /*}
         else{
         [_popOver dismissPopoverAnimated:YES];
         _popOver=nil;
         }
         */
    }
    else{
        [self performSegueWithIdentifier:@"toTrashViewController" sender:self];
        //[self presentViewController:nav animated:YES completion:nil];
    }
}

-(void)showSummary{
    
    [self performSegueWithIdentifier:@"toOrderSummaryViewController" sender:self];
    
}

-(void)showDays{
    
    [self performSegueWithIdentifier:@"toOrderDaysViewController" sender:self];
    
}
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
    [_pickerSearchType selectRow:[searchTypes indexOfObject:SEARCH_TYPE_ORDER_NUM] inComponent:0 animated:YES];
    
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
    //if([pickerView isEqual:_cardReaderPicker])
    return [searchTypes count];// [cardReadersArray count];
    
    //return 0;
}

#pragma mark - UIPicker delegate

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    //if([pickerView isEqual:_cardReaderPicker]){
    //if (component == 0) {
    return [searchTypes objectAtIndex:row]; //[cardReadersArray objectAtIndex:row]; //
    //}
    //}
    
    
    //return nil;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    [self.view endEditing:YES];
    //if([pickerView isEqual:_cardReaderPicker]){
    //    if (component == 0) {
    //cardReader = row;
    _searchTypeTextField.text=// _cardReaderTextField.text=
    [NSString stringWithFormat:@"%@",[searchTypes objectAtIndex:row]];
    //_searchTextField.text=nil;
    if(_searchTextField.text.length>0){
        [self reloadData];
    }
    
    //   }
    
    
    //}
    
    
}

- (IBAction)showMainMenu:(id)sender
{
    [asMainMenu showFromBarButtonItem:_mainMenuButtonItem animated:YES];
}

- (IBAction)searchAction:(id)sender{
    
    OrderSearchViewController *vc=[_appDelegate.storyBoard instantiateViewControllerWithIdentifier:@"OrderSearchViewController"];
    //vc.delegate=self;
    //vc.searchText=_searchTextField.text;
    //vc.selectedInventory=_selectedInventory;
    UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:vc];
    
    if(_appDelegate.isIpad){
        //if(_popOver==nil){
        
        
        _popOver=[[UIPopoverController alloc] initWithContentViewController:nav];
        //_chatPopover.popoverContentSize=CGSizeMake(self.view.frame.size.width/2, self.view.frame.size.height);
        _popOver.popoverContentSize=CGSizeMake(200.0, self.view.frame.size.height);
        [_popOver presentPopoverFromBarButtonItem:_mainMenuButtonItem permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        //[_popOver presentPopoverFromRect:CGRectMake(_searchTextField.frame.origin.x, _searchTextField.frame.origin.y, _searchTextField.frame.size.width, _searchTextField.frame.size.height) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        /*}
         else{
         [_popOver dismissPopoverAnimated:YES];
         _popOver=nil;
         }
         */
    }
    else{
        //[self performSegueWithIdentifier:@"toMenuSearchViewController" sender:self];
        [self presentViewController:nav animated:YES completion:nil];
    }
}





@end
