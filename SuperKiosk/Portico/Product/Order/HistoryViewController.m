//
//  InventoryViewController.m
//
//
//  Created by Romulo Quidilig.
//  Copyright (c) 2015 Sharecle Inc. All rights reserved.
//


#import "HistoryViewController.h"
#import "HistoryModel.h"
#import "AppDelegate.h"
//#import "SWRevealViewController.h"
#import "defs.h"
/*#import "InventoryListViewController.h"

#define MENU_INV_MANAGE  @"Manage"
#define MENU_INV_VIEW  @"View Products"
#define MENU_INV_RENAME @"Rename"
#define MENU_INV_PUBLISH @"Set Active"
*/


@interface HistoryViewController (){
   
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
    //NSString *selectedName;
    
    UIActionSheet *asMenu;
    
    NSDictionary *settings;
    HistoryModel *currentHistory;
    AppDelegate *_appDelegate;
  
    NSMutableArray *_stores;
    
}
/*@property (weak, nonatomic) IBOutlet UITextField *name;
@property (weak, nonatomic) IBOutlet UITextField *price;
@property (weak, nonatomic) IBOutlet UITextField *productCategory;
@property (weak, nonatomic) IBOutlet UIImageView *pictureFile;
@property (weak, nonatomic) IBOutlet UITextField *productID;

@property (weak, nonatomic) IBOutlet UIButton *btnSave;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerCategory;
*/
@end

@implementation HistoryViewController
- (id) initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        //historyNames=[NSMutableArray new];
        //[self reloadNames];
        //_appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
        //settings=[HistoryModel sharedSettings];
        //[HistoryModel loadSettings];

    }
    return self;
}
/*
-(void)reloadNames{
    [historyNames removeAllObjects];
    
    NSString *documentPath= [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSError *error;
    NSFileManager* fileManager=[NSFileManager defaultManager];
    

    
    NSArray *dirContents= [fileManager contentsOfDirectoryAtPath:documentPath error:&error];
    if(error==nil){
        if([dirContents count]>0){
            NSPredicate *predicate=[NSPredicate predicateWithFormat:@"self ENDSWITH '.history.plist'"];
            NSArray *onlyplist=[dirContents filteredArrayUsingPredicate:predicate];
            if([onlyplist count]>0){
                for (NSString *name in onlyplist) {
                    
                    [historyNames addObject:[name stringByReplacingOccurrencesOfString:@".history.plist" withString:@""]];
                }
            }
 
        }
 
    }

}
*/
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor clearColor];
   // self.tableView.backgroundColor=[UIColor clearColor];
    _appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    currentHistory=[HistoryModel sharedInstance];
   
    
    _stores=[[currentHistory.history allValues] mutableCopy];
}

-(void)viewDidAppear:(BOOL)animated{
    //[self reloadNames];
    
    if([_stores count]>0)
        self.navigationItem.rightBarButtonItem=self.editButtonItem;
    [self.tableView reloadData];
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_stores count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //UITableViewCell *cell=[self.tableView dequeueReusableCellWithIdentifier:<#(NSString *)#>]
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"history_cell" forIndexPath:indexPath];
    if(cell==nil){
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"history_cell"];
    }
    
    StoreHistory *store=[_stores objectAtIndex:indexPath.row];
    //NSString *storeName=store.storeName;
    cell.textLabel.text=store.storeName;//[_historyNames objectAtIndex:indexPath.row];
    if([_appDelegate.selectedStore.storeName isEqualToString:store.storeName])
        cell.accessoryType=UITableViewCellAccessoryCheckmark;
    /*if([[inventoryNames objectAtIndex:indexPath.row] isEqualToString:[settings valueForKey:KEY_SETTINGS_INV_PUBLISHEDNAME]])
        cell.detailTextLabel.text=@"ACTIVE";
    else
        cell.detailTextLabel.text=@"INACTIVE";
     */
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    /*selectedName=[_historyNames objectAtIndex:indexPath.row];
    //[asMenu showInView:self.view];
    //[self performSegueWithIdentifier:@"toOrderHistoryViewController" sender:self];
   // currentHistory=[HistoryModel sharedInstance];
    
    if(![selectedName isEqualToString:currentHistory.filename]){
        currentHistory.filename=selectedName;
        
        // [currentHistory.orders removeAllObjects];
        //[currentHistory.dates removeAllObjects];
        
        [currentHistory loadHistory];
    }
     */
    _appDelegate.selectedStore=[_stores objectAtIndex:indexPath.row];//[currentHistory.history objectAtIndex:indexPath.row];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if(editingStyle==UITableViewCellEditingStyleDelete){
        
        //NSString *documentPath= [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
        [_stores removeObjectAtIndex:indexPath.row];
        [_appDelegate.historyModel saveHistory];
        /*NSString *title=store.storeName;
        
        NSString *filename=[title stringByAppendingString:@".history.plist"];
        
        NSString *filepath=[documentPath stringByAppendingPathComponent:filename];
        
        NSError *error;
        
        BOOL success=[[NSFileManager defaultManager] removeItemAtPath:filepath   error:&error];
        
        if (success) {
            
             [_historyNames removeObjectAtIndex:indexPath.row];
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
           
        }
         */
        
    }

}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
  /*
    currentHistory=[HistoryModel sharedInstance];
    
    if(![selectedName isEqualToString:currentHistory.filename]){
        currentHistory.filename=selectedName;
        
        
            
            [currentHistory loadHistory];
    }
    */
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
   /*
    if(buttonIndex==[actionSheet cancelButtonIndex])
        return;
    
    NSString *btnTitle=[actionSheet buttonTitleAtIndex:buttonIndex];
    
    if ([btnTitle isEqualToString:MENU_INV_MANAGE]) {
        
            [self performSegueWithIdentifier:@"toCategoryViewController" sender:self];
        
        
    }
    else if ([btnTitle isEqualToString:MENU_INV_VIEW]) {
        
        [self performSegueWithIdentifier:@"toInventoryListViewController" sender:self];
        
        
    }
    else if ([btnTitle isEqualToString:MENU_INV_RENAME]) {
        
        UIAlertView * alert =[[UIAlertView alloc ] initWithTitle:@"Rename Inventory" message:@"Enter new name" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles: nil];
        alert.alertViewStyle = UIAlertViewStylePlainTextInput;
        [alert addButtonWithTitle:@"Save"];
        [alert show];
        
        
    }
    else if ([btnTitle isEqualToString:MENU_INV_PUBLISH]) {
        
        
        [InventoryModel publish:selectedName];
        
        
        [self.tableView reloadData];
    }
    */
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



@end
