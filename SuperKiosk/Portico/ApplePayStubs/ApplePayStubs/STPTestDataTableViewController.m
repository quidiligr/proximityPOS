//
//  STPTestDataTableViewController.m
//  StripeExample
//
//  Created by Jack Flintermann on 10/1/14.
//  Copyright (c) 2014 Stripe. All rights reserved.
//



#import "STPTestDataTableViewController.h"
#import "CCardsViewController.h"
#import "CCardViewController.h"
#import "AppDelegate.h"

#import "STPTestCardStore.h"
#import "STPTestAddressStore.h"
#import "STPTestShippingMethodStore.h"



#define BTN_CANCEL @"Cancel"
#define BTN_SETDEFAULT @"Set Default"
#define BTN_EDIT @"Edit"
#define BTN_DELETE @"Delete"

@interface STPTestDataTableViewController(){
    NSIndexPath * selected_indexPath;
    AppDelegate *_appDelegate;
    
}
@property(nonatomic)id<STPTestDataStore>store;
@end

@interface STPTestDataTableViewCell : UITableViewCell
@end

@implementation STPTestDataTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    return [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
}
@end

@implementation STPTestDataTableViewController

- (instancetype)initWithStore:(id<STPTestDataStore>)store {
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        _store = store;
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _appDelegate=[[UIApplication sharedApplication] delegate];
    
   
    
    [self.tableView registerClass:[STPTestDataTableViewCell class] forCellReuseIdentifier:@"cell"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveUpdateCardsNotification:) name:@"DidReceiveUpdateCardsNotification" object:nil];
}

-(void)didReceiveUpdateCardsNotification:(NSNotification *)notifacation{
    _store=[STPTestCardStore new];

    [self.tableView reloadData];
}



/*
-(void)didReceiveUpdateCardsNotification{
    _store.allItems.firstObject = [STPTestCardStore defaultCard];//@[[self.class defaultCard], [self.class defaultFailingCard]];
    _store.selectedItem = self.allItems[0];
    [self.tableView reloadData];
}
 */
#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.store.allItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"
                                                            forIndexPath:indexPath];
    id item = self.store.allItems[indexPath.row];
    NSArray *descriptions = [self.store descriptionsForItem:item];
    cell.textLabel.text = descriptions[0];
    cell.detailTextLabel.text = descriptions[1];
    cell.accessoryType = ([item isEqual:self.store.selectedItem]) ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
/*    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    self.store.selectedItem = self.store.allItems[indexPath.row];
    [self.tableView reloadData];
    if (self.callback) {
        self.callback(self.store.selectedItem);
    }
 */
     if ([self.store isKindOfClass:[STPTestCardStore class]]) {
    
    selected_indexPath=indexPath;
    UIActionSheet *actionSheet=[[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:BTN_CANCEL destructiveButtonTitle:nil otherButtonTitles:BTN_SETDEFAULT,BTN_EDIT,BTN_DELETE, nil];
    [actionSheet showInView:self.view];
     }
     else{
         [tableView deselectRowAtIndexPath:indexPath animated:NO];
         self.store.selectedItem = self.store.allItems[indexPath.row];
         [self.tableView reloadData];
         if (self.callback) {
             self.callback(self.store.selectedItem);
         }
     }
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSString *btnTitle=[actionSheet buttonTitleAtIndex:buttonIndex];
    if ([btnTitle isEqualToString:BTN_SETDEFAULT]) {
        [self.tableView deselectRowAtIndexPath:selected_indexPath animated:NO];
        self.store.selectedItem = self.store.allItems[selected_indexPath.row];
        [self.tableView reloadData];
        if (self.callback) {
            self.callback(self.store.selectedItem);
        }
    }
    else if ([btnTitle isEqualToString:BTN_EDIT]){
        
        //vc.selectedCard = _;
        
        //id<STPTestDataStore> store = [self storeForSection:self.sectionTitles[indexPath.section]];
        //STPTestDataTableViewController *controller = [[STPTestDataTableViewController alloc] initWithStore:store];
        if ([self.store isKindOfClass:[STPTestCardStore class]]) {
            CCardViewController* vc = (CCardViewController*) [ApplicationDelegate.storyBoard instantiateViewControllerWithIdentifier:@"CCardViewController"];
            //id item = self.store.allItems[selected_indexPath.row];
            CCardInfo *selectedCard=[_appDelegate.appConfig.userInfo.ccards objectAtIndex:selected_indexPath.row];
            vc.selectedCard=selectedCard;
            [self presentViewController:vc animated:YES completion:nil];
        }

        
        
    }
    else if ([btnTitle isEqualToString:BTN_SETDEFAULT]){
        
    }
   /* else if ([btnTitle isEqualToString:BTN_SETDEFAULT]){
        
    }*/
}
@end

