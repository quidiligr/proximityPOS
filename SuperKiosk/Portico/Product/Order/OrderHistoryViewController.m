//
//  InventoryViewController.m
//
//
//  Created by Romulo Quidilig.
//  Copyright (c) 2015 Sharecle Inc. All rights reserved.
//


#import "OrderHistoryViewController.h"
#import "HistoryModel.h"
#import "OrderHistory.h"
#import "SpeechBubbleView.h"
#import "AppDelegate.h"
//#import "SWRevealViewController.h"
#import "HistoryViewController.h"
#import "CheckoutCart.h"
#import "BroadcastMessageAPI.h"

#import "OrderHistoryCollectionViewCell.h"
#import "OrderHistoryHeaderViewCell.h"

#import "defs.h"
/*#import "InventoryListViewController.h"
 
 #define MENU_INV_MANAGE  @"Manage"
 #define MENU_INV_VIEW  @"View Products"
 #define MENU_INV_RENAME @"Rename"
 #define MENU_INV_PUBLISH @"Set Active"
 */


@interface OrderHistoryViewController (){
    
    //NSString *imagesPath;
    //NSMutableArray *categories;
    //UIImage *newPictureImage;
    // BOOL imageChanged;
    // BOOL isUpdate;
    //NSFileManager *fileManager;
    //Product *selectedProduct;
    //NSDictionary *inventory;
    //NSArray *categorySectionTitles;
    //NSMutableArray *historyNames;
    //NSMutableArray *historyDates;
    NSString *selectedName;
    
    UIActionSheet *asMenu;
    
    //NSDictionary *settings;
    //HistoryModel *currentHistory;
    AppDelegate *_appDelegate;
    //nsmutabl
    NSIndexPath *selectedIndexPath;
    OrderHistory *selectedOrder;
    UIBarButtonItem *showOtherButton;
    UIBarButtonItem *synchButton;

    
    NSArray *days;
     //CCardInfo *selectedCard;
    
    StoreHistory *selectedStoreHistory;
    
    BOOL bannerIsVisible;
    
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
//@property (strong, nonatomic) STPCard* stripeCard;

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

//-(void)reloadData{
//    /*
//    if(!currentHistory.filename){
//        if(historyNames.count>0){
//            currentHistory.filename=[historyNames lastObject];
//            
//            
//            [currentHistory loadHistory];
//            
//            
//        }
//    }
//    
//    if(currentHistory.filename){
//        historyDates=[[currentHistory.history allKeys] mutableCopy];
//        
//    }
//     */
//    //NSPredicate *predicate=[NSPredicate predicateWithFormat:@"orderDay=%@",[_appDelegate.selectedStore.days objectAtIndex:section]];
//   //days=[_appDelegate.selectedStore.orders filteredArrayUsingPredicate:predicate];
//    //[self.tableView reloadData];
//    
//}
//-(void)reloadNames{
//    /*
//    if(!historyNames)
//        historyNames=[NSMutableArray new];
//    else
//        [historyNames removeAllObjects];
//    
//    NSString *documentPath= [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
//    NSError *error;
//    NSFileManager* fileManager=[NSFileManager defaultManager];
//    
//    
//    
//    NSArray *dirContents= [fileManager contentsOfDirectoryAtPath:documentPath error:&error];
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
//            
//        }
//       
//        
//    }
//    */
//}

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
    //self.tableView.backgroundColor=[UIColor clearColor];
    _appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    //if(_appDelegate.isIpad){
    ///    self.navigationItem.hidesBackButton=YES;
        
   // }
#ifdef ENABLE_IAD
    if ([self respondsToSelector:@selector(setCanDisplayBannerAds:)]) {
        
        self.canDisplayBannerAds=YES;
    }
#endif
    //if(_appDelegate.isServer){
    /*SWRevealViewController *revealViewController = self.revealViewController;
     if ( revealViewController )
     {
     [self.sidebarButton setTarget: self.revealViewController];
     [self.sidebarButton setAction: @selector( revealToggle: )];
     [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
     }
     */
    //currentHistory=[HistoryModel sharedInstance];
    
   // [self reloadNames];
    
    //currentHistory=_appDelegate.historyModel;
    
    /*SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
    {
        [self.sidebarButton setTarget: self.revealViewController];
        [self.sidebarButton setAction: @selector( revealToggle: )];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
    */
    showOtherButton=[[UIBarButtonItem alloc] initWithTitle:@"Other store" style:UIBarButtonItemStyleBordered target:self action:@selector(showOtherStore:)];
    synchButton=[[UIBarButtonItem alloc] initWithTitle:@"Synch" style:UIBarButtonItemStyleBordered target:self action:@selector(synchHistory:)];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didUpdateHistoryWithNotification:)
                                                 name:NOTIFY_UPDATE_HISTORY
                                               object:nil];
   
  /*  [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didReceiveNewOrderNotification:)
                                                 name:NOTIFY_NEW_ORDER
                                               object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didReceiveServerInfoNotification:)
                                                 name:NOTIFY_RECEIVED_SERVERINFO
                                               object:nil];
    

    */
    
    
}
/*
 -(void)addNewItem{
 NSString *documentPath= [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
 NSFileManager *fileManager=[NSFileManager defaultManager];
 NSString *filepath;
 NSString *filename;
 NSString *title;
 for (int i=1; i<INT32_MAX; i++) {
 title=[NSString stringWithFormat:@"Untitled %d",i];
 filename=[title stringByAppendingString:@".history.plist"];
 filepath=[documentPath stringByAppendingPathComponent:filename];
 if (![fileManager fileExistsAtPath:filepath]) {
 [fileManager createFileAtPath:filepath contents:nil attributes:nil];
 [historyNames addObject:title];
 [self.tableView reloadData];
 break;
 }
 }
 
 }
 
 -(BOOL)renameItem:(NSString *)fromName toName:(NSString *)toName{
 NSString *documentPath= [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
 NSFileManager *fileManager=[NSFileManager defaultManager];
 //NSString *filepath;
 
 
 //for (int i=1; i<INT32_MAX; i++) {
 
 NSString *fromFileName=[fromName stringByAppendingString:@".inventory.plist"];
 NSString *fromPath=[documentPath stringByAppendingPathComponent:fromFileName];
 
 NSString *toFileName=[toName stringByAppendingString:@".inventory.plist"];
 NSString *toPath=[documentPath stringByAppendingPathComponent:toFileName];
 
 BOOL success=YES;
 if ([fileManager fileExistsAtPath:fromPath]) {
 NSError *error;
 
 success=[fileManager moveItemAtPath:fromPath toPath:toPath error:&error];
 //return success;
 
 }
 else{
 
 }
 //}
 return success;
 
 }
 */
-(void)reloadNavigationItems{
    if([_appDelegate.historyModel.history count]==0){
        if (_appDelegate.selectedStore.peerInfo!=nil && _appDelegate.selectedStore.peerInfo.sessionState==MCSessionStateConnected){
            self.navigationItem.rightBarButtonItems=@[synchButton];
        }
        else{
            self.navigationItem.rightBarButtonItems=nil;
        }
        return;

    }
    
    // if(self.navigationItem.rightBarButtonItem==nil)
    //   self.navigationItem.rightBarButtonItem=showOtherButton;
    if (_appDelegate.selectedStore.peerInfo!=nil && _appDelegate.selectedStore.peerInfo.sessionState==MCSessionStateConnected){
        if([_appDelegate.selectedStore.orders count]>0){
            if([_appDelegate.historyModel.history count]>1)
                self.navigationItem.rightBarButtonItems=@[showOtherButton,synchButton, self.editButtonItem];
            else
                self.navigationItem.rightBarButtonItems=@[synchButton,self.editButtonItem];
        }
        else{
            //self.navigationItem.rightBarButtonItems=@[showOtherButton];
            if([_appDelegate.historyModel.history count]>1)
                self.navigationItem.rightBarButtonItems=@[showOtherButton,synchButton];
            else
                self.navigationItem.rightBarButtonItems=@[synchButton];
        }
    }
    else{
        if([_appDelegate.selectedStore.orders count]>0){
            if([_appDelegate.historyModel.history count]>1)
                self.navigationItem.rightBarButtonItems=@[showOtherButton,self.editButtonItem];
            else
                self.navigationItem.rightBarButtonItems=@[self.editButtonItem];
        }
        else{
            //self.navigationItem.rightBarButtonItems=@[showOtherButton];
            if([_appDelegate.historyModel.history count]>1)
                self.navigationItem.rightBarButtonItems=@[showOtherButton];
            else
                self.navigationItem.rightBarButtonItems=nil;
        }
    }
}
-(void)reloadData{
    /*if(_appDelegate.selectedStore==nil){
        if(_appDelegate.selectedStore.peerInfo!=nil){
            //NSPredicate *predicate=[NSPredicate predicateWithFormat:@"storeId=%@ && orderIsLive==%@",_appDelegate.selectedStore.peerInfo.deviceID,@(_appDelegate.appConfig.isLive)];
            //NSPredicate *predicate=[NSPredicate predicateWithFormat:@"storeId=%@",_appDelegate.selectedStore.peerInfo.deviceID];
            //NSArray *result=[_appDelegate.historyModel.history filteredArrayUsingPredicate:predicate];
            //if([result count]>0){
                _appDelegate.selectedStore=[_appDelegate.historyModel storeWithStoreID:_appDelegate.selectedStore.peerInfo.deviceID]; //[result firstObject];
                
           // }
            
        }
        if(_appDelegate.selectedStore==nil){
            if([_appDelegate.historyModel.history count]>0)
                [self performSegueWithIdentifier:@"toHistoryViewController" sender:self];
        }
        else{
            //ensure days is synch
            //_appDelegate.selectedStore.days=[_appDelegate.selectedStore.orders valueForKey:@"orderDay"];
            days=[_appDelegate.selectedStore days:NO];
            
        }
        
    }
    else{
        */
        //ensure days is synch
        //if ([_appDelegate.selectedStore.days count]==0 && [_appDelegate.selectedStore.orders count]>0) {
        //_appDelegate.selectedStore.days =[_appDelegate.selectedStore.orders valueForKey:@"orderDay"];
        //[_appDelegate.selectedStore.days addObjectsFromArray:result];
        //[_appDelegate.historyModel saveHistory];
        //}
        days=[_appDelegate.selectedStore days:NO];
    //}
    
    [self.collectionView reloadData];
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    //[self reloadNavigationItems];
    
    [self reloadData];
    /*if([_appDelegate.historyModel.history count]==0){
        self.navigationItem.rightBarButtonItems=nil;
        return;
    }
    */
    //self.title=_appDelegate.selectedStore.storeName;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    NSUInteger count=[days count];
    /*if(count==0){
        UITabBarItem *tbi=(UITabBarItem *)[self.tabBarController.tabBar.items objectAtIndex:TAB_INDEX_ORDERS];
        if(tbi.badgeValue!=nil)
            tbi.badgeValue=nil;

    }
        [self reloadNavigationItems];
    */
    return count;//[days count];
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    //if(_appDelegate.selectedStore!=nil){
        //doesnt work: NSPredicate *predicate=[NSPredicate predicateWithFormat:@"orderDay=%@ AND orderIsLive=%@",[[_appDelegate.selectedStore days:NO] objectAtIndex:section],@(_appDelegate.appConfig.isLive)];
        NSPredicate *predicate=[NSPredicate predicateWithFormat:@"orderDay=%@",[days objectAtIndex:section]];
    NSArray *day_orders=[_appDelegate.selectedStore.orders filteredArrayUsingPredicate:predicate];
        
       // predicate=[NSPredicate predicateWithFormat:@"orderIsLive=%@",@(_appDelegate.appConfig.isLive)];
        if(_appDelegate.appConfig.isLive)
            predicate=[NSPredicate predicateWithFormat:@"orderIsLive==YES"];
        else
            predicate=[NSPredicate predicateWithFormat:@"orderIsLive==NO"];
        NSArray *orders=[day_orders filteredArrayUsingPredicate:predicate];
        
        //if([orders count]==0){
        //    return 1;
        //}
        //else{
            return [orders count];
        //}
   /* }
    else{
        return 0;
    }
     */
    //return 1;
}



#pragma mark -UICollectionView

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableview = nil;
    
    if (kind == UICollectionElementKindSectionHeader) {
        //return [self headerView:indexPath];
        
         OrderHistoryHeaderViewCell *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"OrderHistoryHeaderViewCell" forIndexPath:indexPath];
        NSString *title = [days objectAtIndex:indexPath.section];//[[NSString alloc]initWithFormat:@"Recipe Group #%i", indexPath.section + 1];
         headerView.title.text = title;
         //UIImage *headerImage = [UIImage imageNamed:@"header_banner.png"];
         //headerView.backgroundImage.image = headerImage;
         //headerView.backgroundColor=[UIColor whiteColor];
         reusableview = headerView;
        
        
    }
    /*
    if (kind == UICollectionElementKindSectionFooter) {
        UICollectionReusableView *footerview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"FooterView" forIndexPath:indexPath];
        
        reusableview = footerview;
    }
    */
    return reusableview;
}



- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{

    
    OrderHistoryCollectionViewCell *cell;
    
    OrderHistory *item=[self cellOrderWithIndexPath:indexPath];
    //works: NSPredicate *predicate=[NSPredicate predicateWithFormat:@"orderDay=%@",[days objectAtIndex:indexPath.section]];
    /*
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"orderDay=%@",[days objectAtIndex:indexPath.section]];
    
    //NSArray *orders=[_appDelegate.selectedStore.orders filteredArrayUsingPredicate:predicate];
    NSArray *day_orders=[_appDelegate.selectedStore.orders filteredArrayUsingPredicate:predicate];
    if(_appDelegate.appConfig.isLive)
        predicate=[NSPredicate predicateWithFormat:@"orderIsLive==YES"];
    else
        predicate=[NSPredicate predicateWithFormat:@"orderIsLive==NO"];
    NSArray *orders=[day_orders filteredArrayUsingPredicate:predicate];
    
    NSSortDescriptor *desc=[[NSSortDescriptor alloc] initWithKey:@"orderDateTime" ascending:NO];
    
    NSArray *sorted_orders=[orders sortedArrayUsingDescriptors:[NSArray arrayWithObject:desc]];

    
    OrderHistory *item=[sorted_orders objectAtIndex:indexPath.row];
    //
*/
    //if(item!=nil){
        static NSString *identifier = @"OrderHistoryCollectionViewCell";
        
        cell = (OrderHistoryCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
        
        //cell = [tableView dequeueReusableCellWithIdentifier:@"orderhistory_cell" forIndexPath:indexPath];
        //if(cell==nil){
        //    cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"orderhistory_cell"];
        //}
        //for screen shot submition only:
        item.orderBy=_appDelegate.appConfig.userInfo.displayName;
        
        cell.itemsLabel.numberOfLines=0;
        cell.itemsLabel.lineBreakMode=NSLineBreakByWordWrapping;
        //cell.textLabel.text=item.orderDetailText;
        cell.itemsLabel.text=[item toStringLabel];
        
       
        [cell.itemsLabel sizeToFit];
       
        /*TODO:
        if(item.orderSynched)
            cell.accessoryType=UITableViewCellAccessoryCheckmark;
        else
            cell.accessoryType=UITableViewCellAccessoryNone;
        */
        
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
        
        /*
        UIImage *background = [self cellBackgroundForRowAtIndexPath:indexPath];
        
        UIImageView *cellBackgroundView = [[UIImageView alloc] initWithImage:background];
        cellBackgroundView.image = background;
        cell.backgroundView = cellBackgroundView;
        */
    /*
    }
    else{
        cell = [tableView dequeueReusableCellWithIdentifier:@"empty_cell" forIndexPath:indexPath];
        if(cell==nil){
            cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"empty_cell"];
        }
        cell.textLabel.text=@"Orders: 0";
    }
    */
    return cell;
    
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    /*OrderHistory *item=[items objectAtIndex:indexPath.row];
    
    NSString *lblItems=[item toStringLabelItems];
    
    CGSize bubbleSize = [SpeechBubbleView sizeForText:lblItems];//[SpeechBubbleView sizeForText:item.toStringLabel];
    
    
    //return bubbleSize.height + HEIGHT_OFFSET+25; u may use this for no image
    //bubbleSize.height=bubbleSize.height + HEIGHT_OFFSET+70;
    bubbleSize.height=bubbleSize.height + HEIGHT_OFFSET+200;
    return bubbleSize;
     */
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"orderDay=%@",[days objectAtIndex:indexPath.section]];
    NSArray *orders=[_appDelegate.selectedStore.orders filteredArrayUsingPredicate:predicate];
    OrderHistory *item=[orders objectAtIndex:indexPath.row];
    
    CGSize bubbleSize = [SpeechBubbleView sizeForText:[item toStringLabel]];
    bubbleSize.height=bubbleSize.height + HEIGHT_OFFSET+25;
    return bubbleSize;
    /*NSString *lblItems=[item toStringLabel];
    CGSize cellSize=[lblItems sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:24.0]}];
    
    // bubbleSize.height=bubbleSize.height + HEIGHT_OFFSET+200;
    if(cellSize.height>37.0){ //37 is current height of the label in storyboard
        //cellSize.height=160.0+(cellSize.height-37.0);
        cellSize.height=220.0+(cellSize.height-37.0);
        
    }
    
    return cellSize;
     */
}

- (UIImage *)cellBackgroundForRowAtIndexPath:(NSIndexPath *)indexPath{
    /*NSInteger rowCount = [self tableView:[self tableView] numberOfRowsInSection:indexPath.section];
    NSInteger rowIndex = indexPath.row;
    UIImage *background = nil;
    
    if (rowIndex == 0) {
        background = [UIImage imageNamed:@"cell_top.png"];
    } else if (rowIndex == rowCount - 1) {
        background = [UIImage imageNamed:@"cell_bottom.png"];
    } else {
        background = [UIImage imageNamed:@"cell_middle.png"];
    }
    */
    UIImage *background = nil;

    return background;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    [self didSelectRowAtIndexPath:indexPath];
    
}


#pragma mark -Table

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return [days objectAtIndex:section];
}

- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"orderDay=%@",[days objectAtIndex:indexPath.section]];
    NSArray *orders=[_appDelegate.selectedStore.orders filteredArrayUsingPredicate:predicate];
    OrderHistory *item=[orders objectAtIndex:indexPath.row];
    
        CGSize bubbleSize = [SpeechBubbleView sizeForText:[item toStringLabel]];
    
    
    return bubbleSize.height + HEIGHT_OFFSET+25;
    
    
    
}

-(void)didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    selectedIndexPath=indexPath;
    
    /*
     NSPredicate *predicate=[NSPredicate predicateWithFormat:@"orderDay=%@",[days objectAtIndex:indexPath.section]];
     NSArray *orders=[_appDelegate.selectedStore.orders filteredArrayUsingPredicate:predicate];
     selectedOrder=[orders objectAtIndex:indexPath.row];
     */
    selectedOrder=[self cellOrderWithIndexPath:indexPath];
    
    
    
    
    
    int status=[selectedOrder.orderStatus intValue];
    
    //if(status!=ORDER_STATUS_CANC && status!=ORDER_STATUS_CLOSED){
    //if(status!=ORDER_STATUS_CANC && status!=ORDER_STATUS_CLOSED && status!=ORDER_STATUS_READY){
    //if(selectedOrder.orderIsPaid){
    //if(status<=_appDelegate.selectedStore.peerInfo.refundLevel){
    if(status<=_appDelegate.selectedStore.inventory.refundLevel){
        
        asMenu=[[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles: MENU_REORDER_TOCART,MENU_REORDER_HANDSFREE,MENU_ORDER_SET_CANC,nil];
    }
    else{
        
        asMenu=[[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles: MENU_REORDER_TOCART,MENU_REORDER_HANDSFREE,nil];
        
        
    }
    //}
    /*else{
     asMenu=[[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles: MENU_ORDER_REORDER,MENU_ORDER_HANDSFREE,nil];
     }
     */
    
    [asMenu showInView:self.view];
    

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   
   
    [self didSelectRowAtIndexPath:indexPath];
    

}

//-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)*editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
//    /*if(editingStyle==UITableViewCellEditingStyleDelete){
//
//        NSString *documentPath= [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
//
//        NSString *title=[historyNames objectAtIndex:indexPath.row];
//
//        NSString *filename=[title stringByAppendingString:@".history.plist"];
//
//        NSString *filepath=[documentPath stringByAppendingPathComponent:filename];
//
//        NSError *error;
//
//        BOOL success=[[NSFileManager defaultManager] removeItemAtPath:filepath   error:&error];
//
//        if (success) {
//
//             [historyNames removeObjectAtIndex:indexPath.row];
//            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
//
//        }
//    }
//*/
//}
//

-(void)setEditing:(BOOL)editing animated:(BOOL)animated{
    [super setEditing:editing animated:animated];
    [self.tableView setEditing:editing animated:animated];
    if(editing){
        
    }
    else{
        
    }
}
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
   // NSMutableArray *orders=[_appDelegate.historyModel.history valueForKey:historyDates[indexPath.section]] ;
    
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"orderDay=%@",[days objectAtIndex:indexPath.section]];
    NSArray *orders=[_appDelegate.selectedStore.orders filteredArrayUsingPredicate:predicate];
    
    // NSArray *orders=[_appDelegate.historyModel valueForKey:_appDelegate.selectedStore.days[indexPath.section]];
    
    OrderHistory *delete_item=[orders objectAtIndex:indexPath.row];
    
    
    
    
    if(editingStyle==UITableViewCellEditingStyleDelete){
        if(delete_item!=nil){
            [_appDelegate.selectedStore.orders removeObject:delete_item];
            /*if([orders count]==1){
                _appDelegate.selectedStore.days=[_appDelegate.selectedStore.orders valueForKey:@"orderDay"];
            }
            */
            [_appDelegate.historyModel saveHistory];
            [self reloadData];
            // [self.tableView reloadData];
           // if(_appDelegate.badgeOrderNumber>0)
           //     _appDelegate.badgeOrderNumber--;
            
            //UITabBarItem *tbi=(UITabBarItem *)[self.tabBarController.tabBar.items objectAtIndex:TAB_INDEX_ORDERS];
            //if(_appDelegate.badgeOrderNumber==0)
            //    tbi.badgeValue=nil;
            //else
            //    tbi.badgeValue =[NSString stringWithFormat:@"%lu",(unsigned long)_appDelegate.badgeOrderNumber];
            
           // [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
           // [self.tableView reloadData];
        }
        
    }
}

-(OrderHistory *)cellOrderWithIndexPath:(NSIndexPath *)indexPath{
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"orderDay=%@",[days objectAtIndex:indexPath.section]];
    
    //NSArray *orders=[_appDelegate.selectedStore.orders filteredArrayUsingPredicate:predicate];
    NSArray *day_orders=[_appDelegate.selectedStore.orders filteredArrayUsingPredicate:predicate];
    if(_appDelegate.appConfig.isLive)
        predicate=[NSPredicate predicateWithFormat:@"orderIsLive==YES"];
    else
        predicate=[NSPredicate predicateWithFormat:@"orderIsLive==NO"];
    NSArray *orders=[day_orders filteredArrayUsingPredicate:predicate];
    if([orders count]>0){
        NSSortDescriptor *desc=[[NSSortDescriptor alloc] initWithKey:@"orderDateTime" ascending:NO];
        
        NSArray *sorted_orders=[orders sortedArrayUsingDescriptors:[NSArray arrayWithObject:desc]];
        
        //OrderHistory *item=[sorted_orders objectAtIndex:indexPath.row];
        
        
        return [sorted_orders objectAtIndex:indexPath.row];
    }
    else{
        return nil;
    }
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    /*  //if([segue.identifier isEqualToString:@"toInventoryListViewController"]){
     //InventoryListViewController *vc=[segue destinationViewController];
     currentHistory=[HistoryModel sharedInstance];
     
     if(![selectedName isEqualToString:currentHistory.name]){
     currentHistory.name=selectedName;
     
     [currentHistory.products removeAllObjects];
     [currentHistory.dates removeAllObjects];
     
     [currentHistory loadHistory];
     }
     //vc.inventoryName=selectedName;
     //}
     */
    if ([segue.identifier isEqualToString:@"toHistoryViewController"]) {
        //HistoryViewController *destViewContoller=segue.destinationViewController;
        //destViewContoller.historyNames=historyNames;
    }
}


-(BOOL)cancelOrder:(StoreHistory *)store{
    
    //currentHistory=[HistoryModel sharedInstance];
    /*NSPredicate *predicate=[NSPredicate predicateWithFormat:@"orderDay=%@",[[_appDelegate.selectedStore days:NO] objectAtIndex:selectedIndexPath.section]];
    NSArray *orders=[_appDelegate.selectedStore.orders filteredArrayUsingPredicate:predicate];
    
    
    OrderHistory *item=[orders objectAtIndex:selectedIndexPath.row];
    */
    
    
            NSDictionary *order_dict=[selectedOrder toJSONCancelOrderDictionary];
            
    NSMutableDictionary *request_dict=[[NSMutableDictionary alloc] init];
    
    [request_dict setValue:KEY_ACTION_CANCEL_ORDER forKey:KEY_ACTION];
    [request_dict setValue:@{KEY_ORDER:order_dict} forKey:KEY_ACTION_PARAM];
    [request_dict setValue:KEY_ACTION_TYPE_REQUEST forKey:KEY_ACTION_TYPE];
    
    NSError *error;
    
    NSData *jsonData=[NSJSONSerialization dataWithJSONObject:request_dict options:NSJSONWritingPrettyPrinted error:&error];
    
    if(error==nil){
        NSString *request=[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        //NSLog(@"reply=%@",reply);
        //[self sendMyMessage:reply withMessageType:MSG_TYPE_RESPONSE andLocalCopy:NO];
        
        BroadcastMessageAPI *message=[[BroadcastMessageAPI alloc] init];
        message.text=request;
        message.isBroadcast=NO;
        message.toPeerInfo=_appDelegate.selectedStore.peerInfo;
        message.message_type=MSG_TYPE_REQUEST;
        message.localCopy=NO;
        
        NSDictionary *dict = @{KEY_SEND_MESSAGE: message
                               };
        
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_HAS_DATA_TO_SEND
                                                            object:nil
                                                          userInfo:dict];
        //NSTimer *timer;
        //processTimer=[NSTimer scheduledTimerWithTimeInterval:30.0 target:self selector:@selector(chargeTimedOut:) userInfo:nil repeats:NO];
        //[processWait show];
        
    }
    else{
        //return;
        /*UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Error 100" message:@"There was an error processing your request. Please see attendant for help." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
         */
        BroadcastMessageAPI *m=[[BroadcastMessageAPI alloc] init];
        m.sender=_appDelegate.selectedStore.peerInfo.peerID.displayName;
        m.peerInfo=_appDelegate.selectedStore.peerInfo;
        m.fromDeviceID=_appDelegate.selectedStore.peerInfo.deviceID;
        
        
        
        m.text=@"There was an error processing your request. Please see an attendant for detail.";
        
       // [_appDelegate addNewMessage:m];
        [store addNewMessage:m];
        
        
    }
    
     self.tabBarController.selectedIndex=TAB_INDEX_CHAT;
    
    return YES;
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if(buttonIndex==[actionSheet cancelButtonIndex])
        return;
    
    NSString *btnTitle=[actionSheet buttonTitleAtIndex:buttonIndex];
    
    /*if ([btnTitle isEqualToString:MENU_ORDER_SET_PAID]) {
        
        [self setOrderStatus:ORDER_STATUS_PAID];
        
    }
    else if ([btnTitle isEqualToString:MENU_ORDER_SET_UNPAID]) {
        
        [self setOrderStatus:ORDER_STATUS_RECEIVED];
        
        
    }
    else if ([btnTitle isEqualToString:MENU_ORDER_SET_READY]) {
        
       [self setOrderStatus:ORDER_STATUS_READY];
        
    }
    else if ([btnTitle isEqualToString:MENU_ORDER_SET_CLOSED]) {
        
        
        [self setOrderStatus:ORDER_STATUS_CLOSED];
    }
    
    else if ([btnTitle isEqualToString:MENU_ORDER_SET_CANC]) {
        
        
        [self setOrderStatus:ORDER_STATUS_CANC];
    }
     */
    
    if ([btnTitle isEqualToString:MENU_REORDER_TOCART]) {
        /*if(![_appDelegate isConnectedToStore:selectedOrder.orderStoreID]){
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Connection Error" message:@"Make sure you are connected to right store." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
        else{
         */
            [self addHistoryItemsToCart];
        //}
        
    }
    else if ([btnTitle isEqualToString:MENU_REORDER_HANDSFREE]) {
        /*
        if(![_appDelegate isConnectedToStore:selectedOrder.orderStoreID]){
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Connection Error" message:@"Make sure you are connected to the right store." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
        else{
        */
            [self handsFreeWithOrder:selectedOrder];
        //}
    }

    else if ([btnTitle isEqualToString:MENU_ORDER_SET_CANC]) {
        
        if([selectedOrder.orderStatus isEqualToNumber:@ORDER_STATUS_START]){
            [_appDelegate.selectedStore.orders removeObject:selectedOrder];
            /*if([orders count]==1){
             _appDelegate.selectedStore.days=[_appDelegate.selectedStore.orders valueForKey:@"orderDay"];
             }
             */
            [_appDelegate.historyModel saveHistory];
            [self reloadData];
            selectedOrder=nil;
        }
        else{
            /*if(![_appDelegate isConnectedToStore:selectedOrder.orderStoreID]){
                UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Connection Error" message:@"Make sure you are connected to the right store." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];            }
            else{
             */
            StoreHistory *store=[_appDelegate.historyModel storeWithStoreID:selectedOrder.orderStoreID];
            [self cancelOrder:store];
            //}
        }
    }
    
}



- (void)addHistoryItemsToCart {
    //NOTE: for now check if connected, later when not connected we get menu from the internet
    
    //CheckoutCart* checkoutCart = [CheckoutCart sharedInstance];
    //[checkoutCart clearCart];
    //checkoutCart.order=selectedOrder;
    /*
     NSArray *pcs=_appDelegate.selectedStore.inventory.categories;
     
     
     
     for(ProductCategory *pc in pcs){
     pc.products=[_appDelegate.selectedStore.inventory allProductsWithCategoryID:pc.categoryID sorted:YES];
     [_menu addObject:pc];
     }

     */
    if(_appDelegate.selectedStore.peerInfo==nil ||
       _appDelegate.selectedStore.peerInfo.sessionState!=MCSessionStateConnected){
        //_appDelegate.selectedStore.storeName
        [AppDelegate toast:@"Please connect to continue." duration:2.0];
        return;
    }
    
    if(_appDelegate.selectedStore.inventory==nil){
        [AppDelegate toast:@"Menu is empty. Please try again later. 926" duration:2.0];
        return;
    }
    if([_appDelegate.selectedStore.inventory.products count]==0){
        [AppDelegate toast:@"Menu is empty. Please try again later. 929" duration:2.0];
        return;
    }
    
    for(OrderItem *item in selectedOrder.orderItems){
        //search for latest product 
        NSPredicate *p=[NSPredicate predicateWithFormat:@"productID==%@",@(item.productID)];
        
        NSArray *arr = [_appDelegate.selectedStore.inventory.products filteredArrayUsingPredicate:p];
        if([arr count]>0){
            Product *prod=[arr firstObject];
            OrderItem *orderItem=[[OrderItem alloc] initWithProduct:prod isLive:_appDelegate.appConfig.isLive withStoreID:_appDelegate.selectedStore.peerInfo.deviceID];
            
            //orderItem.storeID=selectedOrder.orderStoreID;
            /*NSString *deviceID=[_appDelegate.selectedStore.inventory_dict valueForKey:deviceIDKey];
            
            
            orderItem.storeID=(deviceID==nil)?@"":deviceID;
            */
            
            //[checkoutCart addItem:orderItem isLive:selectedOrder.orderIsLive];
            [_appDelegate addToCart:orderItem product:prod];
        }
        
        
        
    }
    UITabBarItem *tbi=(UITabBarItem *)[self.tabBarController.tabBar.items objectAtIndex:TAB_INDEX_CART];
    if([_appDelegate.selectedStore.cart.itemsArray count]==0)
        tbi.badgeValue=nil;
    else
        tbi.badgeValue=[NSString stringWithFormat:@"%lu",(unsigned long)[_appDelegate.selectedStore.cart.itemsArray count]];
    
    
    
    [self.tabBarController setSelectedIndex:TAB_INDEX_CART];
    
    
}

#pragma mark HAND-FREE ORDERING
- (void)handsFreeWithOrder:(OrderHistory *)order {
    
    
    if (![_appDelegate.selectedStore.deviceID isEqualToString:order.orderStoreID]) {
        /*NSPredicate *predicate=[NSPredicate predicateWithFormat:@"storeId=%@",order.orderStoreID];
        NSArray *stores=[_appDelegate.historyModel.history filteredArrayUsingPredicate:predicate];
        if([stores count]>0){
            selectedStoreHistory=[stores firstObject];
        }
        else{
         
            [AppDelegate toast:@"Selection is not valid. Please choose another one." duration:5];
            return;
        }
         */
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"" message:[NSString stringWithFormat:@"Selected order is not valid for store %@",_appDelegate.selectedStore.storeName] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;

    }
    else{
        selectedStoreHistory=_appDelegate.selectedStore;
    }
    
    NSArray *pending_orders=[_appDelegate.historyModel searchPendingOrdersWithStore:selectedStoreHistory isLive:_appDelegate.appConfig.isLive];
    if([pending_orders count]>0){
        //[AppDelegate toast:[NSString stringWithFormat:@"You still have pending %@orders for %@. Please cancel order and try again.",(order.orderIsLive)?@"":@"TEST ",selectedStoreHistory.storeName] duration:5];
            //return;
        for (int i=0; i<[pending_orders count]; i++) {
            //[selectedStoreHistory.orders removeObject:pending_orders[i]];
            ((OrderHistory *) pending_orders[i]).orderStatus=@ORDER_STATUS_FAILED;
        }
        [_appDelegate.historyModel saveHistory];
    }
    
    OrderHistory *newOrder=[self createOrderFromExisting:order];//[[OrderHistory alloc] init];
    /*UITabBarItem *tbi=(UITabBarItem *)[self.tabBarController.tabBar.items objectAtIndex:TAB_INDEX_INVENTORY];
    
    if(tbi.badgeValue==nil)
        tbi.badgeValue=@"1";
    else
        tbi.badgeValue=[NSString stringWithFormat:@"%d",[tbi.badgeValue integerValue]+1];
     */
    /*CheckoutCart* checkoutCart = [CheckoutCart sharedInstance];
    [checkoutCart clearCart];
    checkoutCart.order=selectedOrder;
    checkoutCart.cusrrentStoreID=order.orderStoreID;
    
    for(OrderItem *orderItem in order.orderItems){
        
        orderItem.storeID=order.orderStoreID;
        [checkoutCart addItem:orderItem];
        
        
        
        
    }
     */
    
   // [OrderHistory completeChargeWithOrder:newOrder];
    //clean then submit new order
    NSArray *failed_orders=[_appDelegate.historyModel searchFailedOrdersWithStore:selectedStoreHistory isLive:_appDelegate.appConfig.isLive];
    if([failed_orders count]>0){
        //[AppDelegate toast:[NSString stringWithFormat:@"You still have pending %@orders for %@. Please cancel order and try again.",(order.orderIsLive)?@"":@"TEST ",selectedStoreHistory.storeName] duration:5];
        //return;
        for (int i=0; i<[failed_orders count]; i++) {
            [selectedStoreHistory.orders removeObject:failed_orders[i]];
            
        }
        [_appDelegate.historyModel saveHistory];
    }
    
    
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_NEW_ORDER object:nil userInfo:@{@"order":newOrder}];
    /*
    UITabBarItem *tbi=(UITabBarItem *)[self.tabBarController.tabBar.items objectAtIndex:TAB_INDEX_CART];
    if([checkoutCart.itemsInCart count]==0)
        tbi.badgeValue=nil;
    else
        tbi.badgeValue=[NSString stringWithFormat:@"%lu",(unsigned long)[checkoutCart.itemsInCart count]];
    
    
    
    [self.tabBarController setSelectedIndex:TAB_INDEX_CART];
    */
    
}
//for hands-free charging, copied from RWStripeViewController
-(OrderHistory *)createOrderFromExisting:(OrderHistory *)existingOrder{
    
    //2
    
    
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSString *today=[dateFormatter stringFromDate:[NSDate date]];
    
    
    
    OrderHistory *order=[[OrderHistory alloc] init];
    
    
    order.orderBy=order.orderBy;//selectedCard.name;//self.nameTextField.text;
    order.orderTableNumber=@"";//self.tableNumberTextField.text;
    order.orderID=[[[NSUUID UUID] UUIDString] lowercaseString];
    order.orderNumber=@0;
    order.chargePayType=ORDER_PAY_TYPE_CCARD;
    // order.orderDetailText=textLabel;
    //get order items
    order.orderItems=[NSArray arrayWithArray:existingOrder.orderItems];// //[checkoutCart itemsInCart];
    
    
    // CheckoutCart* checkoutCart = [CheckoutCart sharedInstance];
    NSInteger confirmed_totalCents;
    NSInteger totalCents;
    
    totalCents=[self totalWithOrderItems:order.orderItems]; //[checkoutCart total];
    //totalCents = totalCents+[checkoutCart total_tax:totalCents tax:[[_appDelegate.selectedStore.inventory_dict valueForKey:taxKey] floatValue]];
    totalCents = totalCents+[self total_tax:totalCents tax:_appDelegate.selectedStore.inventory.salesTax];
    //totalCents = totalCents+[checkoutCart total_tax:totalCents tax:_appDelegate.selectedStore.inventory.salesTax];
    
    confirmed_totalCents=totalCents;
    
    // [checkoutCart clearCart];
    
    
    // NSString* textLabel=[checkoutCart textLabel:[_appDelegate.selectedStore.inventory_dict valueForKey:deviceNameKey] storeID:[_appDelegate.selectedStore.inventory_dict valueForKey:deviceIDKey]];
    
    
    //NSString *stripeAmount = [NSString stringWithFormat:@"%ld", (long)confirmed_totalCents];
    //NSString *stripeCurrency = (_appDelegate.selectedStore.peerInfo.currency.length==0)?@"usd":_appDelegate.selectedStore.peerInfo.currency;
    //NSString *stripeToken = token;
    //NSString *stripeDescription = textLabel;//@"Purchase from Portico iOS app!";
    
    
    
    if(order.orderPayments==nil)
        order.orderPayments=[NSMutableArray new];
    
    
    order.orderDateTime=[NSDate date];
    order.orderDate=[dateFormatter dateFromString:today];
    order.orderDay=today;
    order.orderStatus=@ORDER_STATUS_START;
    
    order.orderStoreID=existingOrder.orderStoreID;// _appDelegate.selectedStore.peerInfo.deviceID;
    order.orderStoreName=existingOrder.orderStoreName;//_appDelegate.selectedStore.peerInfo.peerID.displayName;
    order.orderIsLive=existingOrder.orderIsLive;//_appDelegate.appConfig.isLive;
    order.orderDeviceID= _appDelegate.appConfig.userInfo.deviceID;
    order.orderDeviceToken=_appDelegate.appConfig.userInfo.deviceToken;
    
    //double tax=[[_appDelegate.selectedStore.inventory_dict valueForKey:@"tax"] floatValue];
    order.orderTax=existingOrder.orderTax;//tax;
    order.orderAmountDue=totalCents;
    order.chargeAmount=confirmed_totalCents; //stripeAmount;
    order.chargeCurrency=existingOrder.chargeCurrency;
    //order.chargeToken=stripeToken;
    order.chargeDescription=existingOrder.chargeDescription;
    
    
    [_appDelegate.historyModel addOrUpdateOrderHistory:order];
    
    
    
    //HistoryModel *historyModel=[HistoryModel sharedInstance];
    
    return order;
    
    
    
}

- (NSInteger)totalWithOrderItems:(NSArray *)orderItems {
    
    NSInteger total = 0;
    for (OrderItem* item in orderItems) {
        //total += product.price;
        total += item.price*item.quantity;
    }
    return total;
}

- (NSInteger)total_tax:(NSInteger)totalCents tax:(double)tax{
    double d_totalCents = totalCents;
    d_totalCents=d_totalCents/100;
    //float total_tax=total*[[CheckoutCart sharedTaxInstance] floatValue];
    double total_tax=d_totalCents*(tax/100);
    
    return total_tax*100;
}

- (NSInteger)grand_totalWithOrderItems:(NSArray *)orderItems withTax:(double)tax{
    double d_total=[self totalWithOrderItems:orderItems];
    d_total=d_total/100 ;
    
    double t_total_tax=d_total*(tax/100);//[self total_tax:d_total tax:tax];
    
    //t_total_tax=t_total_tax/100;
    
    return (d_total+t_total_tax)*100;
}



-(void)didUpdateHistoryWithNotification:(NSNotification *)notification{
    [self reloadData];
    
    
}

- (IBAction)showOtherStore:(id)sender {
    [self performSegueWithIdentifier:@"toHistoryViewController" sender:self];
}

- (IBAction)synchHistory:(id)sender {
    //query menu
    
    for (OrderHistory *oh in _appDelegate.selectedStore.orders) {
        oh.orderSynched=NO;
    }
    
    NSMutableDictionary *request_dict=[[NSMutableDictionary alloc] init];
    
    
    
    [request_dict setValue:KEY_ACTION_SYNCH_REQUEST forKey:KEY_ACTION];
    
    [request_dict setValue:KEY_ACTION_TYPE_REQUEST forKey:KEY_ACTION_TYPE];
    
    
    
    NSError *error;
    
    NSData *jsonData=[NSJSONSerialization dataWithJSONObject:request_dict options:NSJSONWritingPrettyPrinted error:&error];
    
    
    NSString *text=[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    BroadcastMessageAPI *message=[[BroadcastMessageAPI alloc] init];
    message.text=text;
    message.isBroadcast=NO;
    message.toPeerInfo=_appDelegate.selectedStore.peerInfo;//_appDelegate.mcManager.serverPeerInfo;
    message.message_type=MSG_TYPE_REQUEST;
    message.localCopy=NO;
    
    NSDictionary *dict = @{KEY_SEND_MESSAGE: message
                           };
    
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_HAS_DATA_TO_SEND
                                                        object:nil
                                                      userInfo:dict];
    
}

#pragma mark Banner delegates

- (void)bannerViewDidLoadAd:(ADBannerView *)banner

{
    
    if (!bannerIsVisible)
        
    {
        
        [UIView beginAnimations:@"animateAdBannerOn" context:NULL];
        
        // Assumes the banner view is just off the bottom of the screen.
        
        banner.frame = CGRectOffset(banner.frame, 0, -banner.frame.size.height);
        
        [UIView commitAnimations];
        
        bannerIsVisible = YES;
        
    }
    
}


-(void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error{
    if (bannerIsVisible)
        
    {
        
        [UIView beginAnimations:@"animateAdBannerOff" context:NULL];
        
        // Assumes the banner view is placed at the bottom of the screen.
        
        banner.frame = CGRectOffset(banner.frame, 0, banner.frame.size.height);
        
        [UIView commitAnimations];
        
        bannerIsVisible = NO;
        
    }
}

@end
