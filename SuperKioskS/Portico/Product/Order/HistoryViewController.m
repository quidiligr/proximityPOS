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
    
    NSMutableArray *historyNames;
    NSString *selectedName;
    
    UIActionSheet *asMenu;
    
    NSDictionary *settings;
    HistoryModel *currentHistory;
    AppDelegate *_appDelegate;
    
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
        historyNames=[NSMutableArray new];
        //[self reloadNames];
        _appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
        //settings=[HistoryModel sharedSettings];
        //[HistoryModel loadSettings];

    }
    return self;
}

-(void)reloadNames{
    [historyNames removeAllObjects];
    
    //NSString *documentPath= [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    //NSError *error;
    NSFileManager* fileManager=[NSFileManager defaultManager];
    

        NSString* fileName=[NSString stringWithFormat:@"%@.server-history.plist",_appDelegate.historyModel.filename];
        if ([fileManager fileExistsAtPath:[[AppDelegate getDocumentsPath] stringByAppendingPathComponent:fileName]]) {
            [historyNames addObject:_appDelegate.historyModel.filename];
        }
        
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor clearColor];
    // Do any additional setup after loading the view.
    
    //settings=[InventoryModel sharedSettings];
    
    
    
   /* UIBarButtonItem *rightButton=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNewItem)];
    self.navigationItem.rightBarButtonItem=rightButton;
    */
    //asMenu=[[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:MENU_INV_MANAGE,MENU_INV_VIEW,MENU_INV_RENAME, MENU_INV_PUBLISH,nil];
}

-(void)viewDidAppear:(BOOL)animated{
    if(_appDelegate.isIpad){
        [[self navigationController] setNavigationBarHidden:NO animated:YES];
    }
    [self reloadNames];
    if([historyNames count]>0)
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
    return [historyNames count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //UITableViewCell *cell=[self.tableView dequeueReusableCellWithIdentifier:<#(NSString *)#>]
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"history_cell" forIndexPath:indexPath];
    if(cell==nil){
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"history_cell"];
    }
    
    
    cell.textLabel.text=[historyNames objectAtIndex:indexPath.row];
    
    /*if([[inventoryNames objectAtIndex:indexPath.row] isEqualToString:[settings valueForKey:KEY_SETTINGS_INV_PUBLISHEDNAME]])
        cell.detailTextLabel.text=@"ACTIVE";
    else
        cell.detailTextLabel.text=@"INACTIVE";
     */
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    selectedName=[historyNames objectAtIndex:indexPath.row];
    [asMenu showInView:self.view];
    [self performSegueWithIdentifier:@"toOrderHistoryViewController" sender:self];
    
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if(editingStyle==UITableViewCellEditingStyleDelete){
        
        NSString *documentPath= [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
        
        NSString *title=[historyNames objectAtIndex:indexPath.row];
        
        NSString *filename=[title stringByAppendingString:@".history.plist"];
        
        NSString *filepath=[documentPath stringByAppendingPathComponent:filename];
        
        NSError *error;
        
        BOOL success=[[NSFileManager defaultManager] removeItemAtPath:filepath   error:&error];
        
        if (success) {
            
             [historyNames removeObjectAtIndex:indexPath.row];
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
           
        }
    }

}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
      currentHistory=[HistoryModel sharedInstance];
    
    if(![selectedName isEqualToString:currentHistory.filename]){
        currentHistory.filename=selectedName;
        
        
            
            [currentHistory loadHistory];
    }
    
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
