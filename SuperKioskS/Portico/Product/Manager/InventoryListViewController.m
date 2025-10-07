//
//  InventoryViewController.m
//
//
//  Created by Romulo Quidilig.
//  Copyright (c) 2015 Sharecle Inc. All rights reserved.
//


#import "InventoryListViewController.h"
//#import "InventoryListViewController.h"
//#import "InventorySettingsViewController.h"
//#import "CategoryIpadViewController.h"
#import "StartInventoryViewController.h"
#import "CategoryListViewController.h"
#import "Product.h"
//#import "UIImage+NSCoder.h"

#import "defs.h"

#define MENU_INV_MANAGE  @"Manage Items"

#define MENU_INV_SETTINGS @"Settings"
#define MENU_INV_BACKUP @"Export"
#define MENU_INV_RESTORE @"Import"


#define INVENTORY_NEWNAME 1
#define INVENTORY_RENAME 2
#define INVENTORY_BACKUP 3
#define INVENTORY_RESTORE 4




@interface InventoryListViewController (){
   
    //NSString *imagesPath;
    //NSMutableArray *categories;
    //UIImage *newPictureImage;
   // BOOL imageChanged;
   // BOOL isUpdate;
    //NSFileManager *fileManager;
    //Product *selectedProduct;
    //NSDictionary *inventory;
    //NSArray *categorySectionTitles;
    
    NSMutableArray *inventoryItems;
    NSString *selectedName;
    
    UIActionSheet *asMenu;
    
    NSDictionary *settings;
    InventoryModel *inventoryModel;
    UIBarButtonItem *addButton;
    
    //UIBarButtonItem *restoreButton;
    //UIBarButtonItem *backupButton;
    
    NSString *selected_restore_filename;
    
    //UIAlertView * showBackupAlert;
    
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

@implementation InventoryListViewController
/*- (id) initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        inventoryModel=[InventoryModel sharedInstance];
        
        //inventoryItems=[NSMutableArray new];
       
        
       // settings=[InventoryModel sharedSettings];
       // [InventoryModel loadSettings];

    }
    return self;
}
*/

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.backgroundColor=[UIColor clearColor];
    
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    UIEdgeInsets inset = UIEdgeInsetsMake(5, 0, 0, 0);
    self.tableView.contentInset = inset;
   _appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    inventoryModel=[InventoryModel sharedInstance];
    
   /* if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
   
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(loadCategories:) name:@"NOTIFY_START_CATEGORY"
                                                   object:nil];
    }
    */
    selected_restore_filename=nil;
    addButton=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNewItem)];
    
   // restoreButton=[[UIBarButtonItem alloc] initWithTitle:@"Import" style:UIBarButtonItemStyleBordered target:self action:@selector(selectFile)];
    
    
    
    
    //self.navigationItem.rightBarButtonItems=@[backupButton, restoreButton,addButton];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reloadTable) name:NOTIFY_UPDATE_INVENTORY
                                               object:nil];

   
    
    
    
}

-(void)loadCategories:(NSNotification *) notification{
    [self performSegueWithIdentifier:@"toCategoryListViewController" sender:self];
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
   /*
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        if([inventoryModel.inventories count]>0){
            if(_selectedInventory==nil){
                _selectedInventory=[InventoryModel activeInventory];
                if(!_selectedInventory){
                    _selectedInventory=[inventoryModel.inventories firstObject];
                }
                else{
                    
                }
            }
            
            //if(_selectedInventory!=nil){
                self.navigationItem.rightBarButtonItems=@[backupButton, restoreButton,addButton,self.editButtonItem];
            //}
            //else{
                //self.navigationItem.rightBarButtonItems=@[ restoreButton,addButton,self.editButtonItem];
            //}
            
            NSUInteger row=[inventoryModel.inventories indexOfObject:_selectedInventory];
            NSIndexPath *selectedIndexPath=[NSIndexPath indexPathForRow:row inSection:0];
            
            [self.tableView selectRowAtIndexPath:selectedIndexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
    
            
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_SHOW_INVENTORY_SETTINGS object:nil userInfo:@{KEY_SELECTED_INVENTORY:_selectedInventory}];
        }
        else{
            _selectedInventory=nil;
            self.navigationItem.rightBarButtonItems=@[ restoreButton,addButton,self.editButtonItem];
        }
        
       
    }
    */
     [self.tableView reloadData];
}

-(void)addNewItem{
   
    NSString *title;
    NSArray *names=[inventoryModel.inventories valueForKey:NAME_KEY];
    
    for (int i=1; i<INT32_MAX; i++) {
        title=[NSString stringWithFormat:@"Inventory %d",i];
        if(![names containsObject:title])
            break;
        
     
    }
    
    UIAlertView * alert =[[UIAlertView alloc ] initWithTitle:@"Create Inventory" message:@"Enter title" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles: nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert addButtonWithTitle:@"OK"];
    alert.tag=INVENTORY_NEWNAME;
    UITextField *txtName=[alert textFieldAtIndex:0];
    txtName.text=title;
    [alert show];
    
}

-(void)renameItem:(NSString *)inventoryId toName:(NSString *)toName{
    /*NSString *documentPath= [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSFileManager *fileManager=[NSFileManager defaultManager];
    
        NSString *fromFileName=[fromName stringByAppendingString:@".inventory.plist"];
        NSString *fromPath=[documentPath stringByAppendingPathComponent:fromFileName];
    
    NSString *toFileName=[toName stringByAppendingString:@".inventory.plist"];
    NSString *toPath=[documentPath stringByAppendingPathComponent:toFileName];
    
    BOOL success=YES;
        if ([fileManager fileExistsAtPath:fromPath]) {
            NSError *error;
            
            success=[fileManager moveItemAtPath:fromPath toPath:toPath error:&error];
                    }
        else{
           
        }
    
    
    return success;
    */
    //NSDictionary *inventory_dict=[inventoryModel.inventories valueForKey:inventoryId];
    //[inventory_dict setValue:toName forKey:NAME_KEY];
    if(toName.length>0)
        self.selectedInventory.name=toName;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger count=[inventoryModel.inventories count];//[inventoryItems count];
    //CGRect frame=_messageView.frame;
    if(count>0){
       // self.navigationItem.leftBarButtonItem=self.editButtonItem;
        /*if(_selectedInventory!=nil){
            self.navigationItem.rightBarButtonItems=@[backupButton, restoreButton,addButton,self.editButtonItem];
        }
        else{*/
            self.navigationItem.rightBarButtonItems=@[ //restoreButton,
                                                      addButton,self.editButtonItem];
        //}
        //frame.size.height=0;
        //_messageView.frame=frame;
        //return 1;
    }
    else{
        //self.navigationItem.leftBarButtonItem=nil;
        if([self isEditing])
            [self setEditing:NO];
        self.navigationItem.rightBarButtonItems=@[//restoreButton,
                                                  addButton];
        //frame.size.height=145.0;
        //_messageView.frame=frame;
        return 1;
    }
    return count;//[inventoryItems count];
}

- (UITableViewCell *)itemCell:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"file_cell" forIndexPath:indexPath];
    if(cell==nil){
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"file_cell"];
    }
    InventoryItem *item=[inventoryModel.inventories objectAtIndex:indexPath.row];
    
    cell.textLabel.text=item.name;
    
    if(item.isActive)
        cell.detailTextLabel.text=@"ACTIVE";
    else
        cell.detailTextLabel.text=@"INACTIVE";
    
    UIImage *background = [self cellBackgroundForRowAtIndexPath:indexPath];
    
    
    UIImageView *cellBackgroundView = [[UIImageView alloc] initWithImage:background];
    cellBackgroundView.image = background;
    cell.backgroundView = cellBackgroundView;
    return cell;
    
    
}

- (UITableViewCell *)emptyCell:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"empty_cell" forIndexPath:indexPath];
    if(cell==nil){
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"empty_cell"];
    }
    return cell;
}

    
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([inventoryModel.inventories count]==0)
        return [self emptyCell:indexPath];
    else{
        return [self itemCell:indexPath];
    }
    
}

- (UIImage *)cellBackgroundForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger rowCount =[self.tableView numberOfRowsInSection:0];  //[self tableView:[self tableView] numberOfRowsInSection:0];
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

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    /*if(![self.navigationItem.rightBarButtonItems containsObject:backupButton]){ self.navigationItem.rightBarButtonItems=@[backupButton, restoreButton,addButton];
    }
     */
     NSInteger count=[inventoryModel.inventories count];
    if(count==0){
        [self addNewItem];
        return;
    }
    
    InventoryItem *item=[inventoryModel.inventories objectAtIndex:indexPath.row];
    
    
    
    selectedName=item.name;
    
   // if([item isEqual:_appDelegate.currentInventory]){
    //    _selectedInventory=_appDelegate.currentInventory;
        
   // }
   // else{
    _selectedInventory=item;
   // }
   /* if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
       
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_SHOW_INVENTORY_SETTINGS object:nil userInfo:@{KEY_SELECTED_INVENTORY:_selectedInventory}];
    }
    else{*/
         asMenu=[[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:MENU_INV_MANAGE,MENU_INV_SETTINGS,MENU_INV_BACKUP,MENU_INV_RESTORE, nil];
       // asMenu=[[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:MENU_INV_SETTINGS,MENU_INV_BACKUP, nil];
        
    [asMenu showInView:self.view];
    
   // [self performSegueWithIdentifier:@"toInventorySettingsViewController" sender:self];
    //}
}

-(void)setEditing:(BOOL)editing animated:(BOOL)animated{
    [super setEditing:editing animated:animated];
    if(editing){
        //self.navigationItem.rightBarButtonItems=nil;//@[backupButton, restoreButton,addButton];
        self.navigationItem.rightBarButtonItems=@[self.editButtonItem];
    }
    else{
        if([inventoryModel.inventories count]>0){
            if([self.tableView indexPathForSelectedRow]){
                self.navigationItem.rightBarButtonItems=@[//backupButton, restoreButton,
                                                          addButton,self.editButtonItem];
            }
            else{
                self.navigationItem.rightBarButtonItems=@[ //restoreButton,addButton,
                                                          self.editButtonItem];
            }
            
        }
        else{
            self.navigationItem.rightBarButtonItems=@[ //restoreButton,
                                                      addButton];
        }
    }
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
   // InventoryItem *item=[inventoryModel.inventories objectAtIndex:indexPath.row];
    if(editingStyle==UITableViewCellEditingStyleDelete){
        
        //NSString *documentPath= [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
        
        //NSString *title=item.name;
        
        //NSString *filename=[title stringByAppendingString:@".inventory.plist"];
        
        //NSString *filepath=[documentPath stringByAppendingPathComponent:filename];
        
       // NSError *error;
        
        //BOOL success=[[NSFileManager defaultManager] removeItemAtPath:filepath   error:&error];
        
        //if (success) {
            InventoryItem *item=[inventoryModel.inventories objectAtIndex:indexPath.row];
        if(_selectedInventory!=nil && _selectedInventory==item){
            _selectedInventory=nil;
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_SHOW_INVENTORY_SETTINGS object:nil];
        }
        
        
            [inventoryModel.inventories removeObjectAtIndex:indexPath.row];
        
        
            //[self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        
        if(item.isActive){
            
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_UPDATE_INVENTORY object:nil userInfo:@{NAME_KEY:item.name}];
        }
        [inventoryModel saveInventory];
        
        [self.tableView reloadData];
        //}
    }

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if([inventoryModel.inventories count]==0){
        return 162.0;
    }
    else{
        return 70.0;
    }
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
   
    //currentInventory=[InventoryModel sharedInstance];
    //NSDictionary *inventory_dict=[inventoryModel.inventories valueForKey:selectedName];
    if ([segue.identifier isEqualToString:@"toCategoryListViewController"]) {
        ///if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            
            /*
            UINavigationController *nav=segue.destinationViewController;
            CategoryIpadViewController *dest=(CategoryIpadViewController *)[nav topViewController];
            dest.selectedInventory=self.selectedInventory;
             */
        //}
        //else{
            CategoryListViewController *dest=segue.destinationViewController;
            dest.selectedInventory=self.selectedInventory;
        //}
    }
    else if ([segue.identifier isEqualToString:@"toInventorySettingsViewController"]) {
        InventorySettingsViewController *dest=segue.destinationViewController;
        dest.selectedInventory=self.selectedInventory;
    }
    /*else if ([segue.identifier isEqualToString:@"toInventoryListViewController"]) {
        //InventoryListViewController *dest=segue.destinationViewController;
        //dest.selectedInventory=self.selectedInventory;
    }
      */
    /*if(![selectedName isEqualToString:currentInventory.name]){
        currentInventory.name=selectedName;
        
            [currentInventory.products removeAllObjects];
            [currentInventory.categories removeAllObjects];
            
            [currentInventory loadInventory];
        
        if([currentInventory.name isEqualToString:[settings valueForKey:KEY_SETTINGS_INV_PUBLISHEDNAME]]){
            currentInventory.isActive=YES;
        }
        else{
            currentInventory.isActive=NO;
        }
    }
     */
    
    
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if(buttonIndex==[actionSheet cancelButtonIndex])
        return;
    
    NSString *btnTitle=[actionSheet buttonTitleAtIndex:buttonIndex];
    
    if ([btnTitle isEqualToString:MENU_INV_MANAGE]) {
        
        
         /*if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            UISplitViewController *svc=[self.storyboard instantiateViewControllerWithIdentifier:@"svcCategoryProducts"];
            UINavigationController *nav=[svc.viewControllers objectAtIndex:0];

            CategoryIpadViewController *leftController=(CategoryIpadViewController *)[nav topViewController];
            leftController.selectedInventory=self.selectedInventory;
            
            self.view.window.rootViewController=svc;
         }
         else{
          */
             [self performSegueWithIdentifier:@"toCategoryListViewController" sender:self];
         //}
        
    }
    /*else if ([btnTitle isEqualToString:MENU_INV_VIEW]) {
        
        [self performSegueWithIdentifier:@"toInventoryListViewController" sender:self];
        
        
    }
    */
    else if ([btnTitle isEqualToString:MENU_INV_SETTINGS]) {
        
                [self performSegueWithIdentifier:@"toInventorySettingsViewController" sender:self];
        
    }
    else if ([btnTitle isEqualToString:MENU_INV_BACKUP]) {
        
        [self showBackupDialog];
        
    }
    else if ([btnTitle isEqualToString:MENU_INV_RESTORE]) {
        [self selectFileToImport];
        
        
    }
    //selectFile
     /*
    else if ([btnTitle isEqualToString:MENU_INV_ACTIVATE]) {
        self.selectedInventory.isActive=YES;
        [inventoryModel saveInventory];
          [self.tableView reloadData];
    }
    else if ([btnTitle isEqualToString:MENU_INV_DEACTIVATE]) {
        
        self.selectedInventory.isActive=NO;
        [inventoryModel saveInventory];
          [self.tableView reloadData];
    }
     
    else if ([btnTitle isEqualToString:MENU_INV_RENAME]) {
        
        UIAlertView * alert =[[UIAlertView alloc ] initWithTitle:@"Rename Inventory" message:@"Enter new name" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles: nil];
         alert.alertViewStyle = UIAlertViewStylePlainTextInput;
         [alert addButtonWithTitle:@"Save"];
         alert.tag=INVENTORY_RENAME;
         [alert show];
        
        
    }*/
    /*else if ([btnTitle isEqualToString:MENU_INV_PUBLISH]) {
        
        
        [InventoryModel publish:selectedName];
        
        [self.tableView reloadData];
    }
    else if ([btnTitle isEqualToString:MENU_INV_ALLOW_CARDPAYMENT]) {
        
        
        currentInventory.allowedPayment=@CASH_ONLY;
        
        [self.tableView reloadData];
    }*/
}
/*
-(void)showBackupDialog{
    UIAlertView * alert =[[UIAlertView alloc ] initWithTitle:@"Backup menu" message:@"Enter backup name" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles: @"OK", nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    //[alert addButtonWithTitle:@"Backup"];
    alert.tag=INVENTORY_BACKUP;
    UITextField *txtName=[alert textFieldAtIndex:0];
    txtName.text=[NSString stringWithFormat:@"%@%@", _selectedInventory.name,@".bak"];
    [alert show];

}
*/

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    NSString *btnTitle=[alertView buttonTitleAtIndex:buttonIndex];
    
    if (alertView.tag==INVENTORY_NEWNAME) {
        if([btnTitle isEqualToString:@"OK"]){
            UITextField *txtName=[alertView textFieldAtIndex:0];
            if(txtName.text.length>0){
                
                
                self.selectedInventory=[inventoryModel addInventory:txtName.text];
                if(self.selectedInventory!=nil){
                  
                    
                    if(_selectedInventory.isActive){
                        _appDelegate.currentInventory=_selectedInventory;
                    }
                    
                    
                    
                    [self.tableView reloadData];
                    
                    NSIndexPath *selectedIndexPath=[NSIndexPath indexPathForRow:[inventoryModel.inventories count]-1 inSection:0];
                    
                    [self.tableView selectRowAtIndexPath:selectedIndexPath animated:YES scrollPosition:UITableViewScrollPositionBottom];

                    /*[[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_SHOW_INVENTORY_SETTINGS object:nil userInfo:@{KEY_SELECTED_INVENTORY:_selectedInventory}];
                     */
                    [self performSegueWithIdentifier:@"toInventorySettingsViewController" sender:self];
                    
                }
                else{
                    UIAlertView *errAlert= [[UIAlertView alloc] initWithTitle:@"Error" message:@"There was an error processing your request. Please try again later." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [errAlert show];
                }
                
                
                
                
            }
        }
        
    }
    
    else if (alertView.tag==INVENTORY_RENAME) {
    
    
    if([btnTitle isEqualToString:@"Save"]){
        UITextField *txtName=[alertView textFieldAtIndex:0];
        
        /*if([self renameItem:selectedName toName:txtName.text]){
            [self reloadInventoryNames];
        
            [self.tableView reloadData];
        }
        else{
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Error" message:@"Rename error." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil]
            ;
            [alert show];
        }*/
        if(txtName.text.length>0){
        
        self.selectedInventory.name=txtName.text;
        [inventoryModel saveInventory];
          [self.tableView reloadData];
        
        }
        
    }
    }
    
    
    else if (alertView.tag==INVENTORY_RESTORE) {
        
        
        if([btnTitle isEqualToString:@"OK"]){
            if(!selected_restore_filename)
                return;
            UITextField *txtName=[alertView textFieldAtIndex:0];
            
            /*if([self renameItem:selectedName toName:txtName.text]){
             [self reloadInventoryNames];
             
             [self.tableView reloadData];
             }
             else{
             UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Error" message:@"Rename error." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil]
             ;
             [alert show];
             }*/
            //if(txtName.text.length>0){
                [self restoreWithName:txtName.text];
                
            //}
            
        }
    }
    
    else if (alertView.tag==INVENTORY_BACKUP) {
        
        
        if([btnTitle isEqualToString:@"OK"]){
            UITextField *txtName=[alertView textFieldAtIndex:0];
            
            
            if(txtName.text.length>0){
                NSString *fname=[[AppDelegate getDocumentsPath] stringByAppendingPathComponent:txtName.text];
                if([[NSFileManager defaultManager] fileExistsAtPath:fname]){
                    [AppDelegate ShowErrorAlert:@"File already exists."]
                    ;                }
                else{
                    [self backup:txtName.text];
                    
                }
                
            }
            
        }
    }
    
}

-(void)backup:(NSString *)filename{
    
    //InventoryItem * inventoryIte=_selectedInventory;
    //InventoryModel *_inventoryModel =[InventoryModel sharedInstance];
    //NSDictionary *menu_dict=nil;
    
    // InventoryItem *inventoryItem=[InventoryModel activeInventory];
    
    // if(_selectedInventory==nil)
    //     return;
    
    
    //NSDictionary *menu_dict=[_selectedInventory toMenuDictionary:deviceID storeName:storeName];
    NSDictionary *menu_dict=[_selectedInventory toDictionaryExport];
    
    if(menu_dict==nil)
        return;
    
    // Get a full path to a plist within the Backup folder for the app
    //NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
    // NSUserDomainMask,
    //YES);
    //NSString *bakPath = [NSString stringWithFormat:@"%@/%@",
    //[paths objectAtIndex:0],name];
    NSString *backupPath=[[AppDelegate getBackupPath] stringByAppendingPathComponent:filename];
    NSString *imagesPath=[AppDelegate getImagesPath];
    //NSMutableArray *images_array=[NSMutableArray new];
    NSMutableDictionary *images_dict=[NSMutableDictionary new];
    for (Product *p in _selectedInventory.products) {
        if(p.pictureFile){
            NSString *filePath=[imagesPath stringByAppendingPathComponent:p.pictureFile];
            if([[NSFileManager defaultManager] fileExistsAtPath:filePath])
            {
                NSData *data=[NSData dataWithContentsOfFile:filePath];
                //UIImage *image=[[UIImage alloc] initWithContentsOfFile:filePath];
                if(data!=nil){
                    [images_dict setObject:data forKey:[NSString stringWithFormat:@"%@",p.pictureFile]];
                }
                //[images_dict setObject:[NSData dataWithContentsOfFile:filePath] forKey:[NSString stringWithFormat:@"%@",p.pictureFile]];
                
                //[images_array addObject:image];
            }
        }
    }
    
    
    NSDictionary *dictionary=@{@"inventory_item":menu_dict,@"images":images_dict};
    @try{
        [   NSKeyedArchiver archiveRootObject:dictionary toFile:backupPath];
        
    }
    @catch(NSException *error){
        [AppDelegate ShowErrorAlert:[NSString stringWithFormat:@"There was error saving backup. %@",error]];
    }
}

/*
 -(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
 
 NSString *btnTitle=[alertView buttonTitleAtIndex:buttonIndex];
 
 
 
 if (alertView.tag==INVENTORY_BACKUP) {
 
 
 if([btnTitle isEqualToString:@"OK"]){
 UITextField *txtName=[alertView textFieldAtIndex:0];
 
 
if(txtName.text.length>0){
    NSString *fname=[[AppDelegate getDocumentsPath] stringByAppendingPathComponent:txtName.text];
    if([[NSFileManager defaultManager] fileExistsAtPath:fname]){
        [AppDelegate ShowErrorAlert:@"File already exists."]
        ;                }
    else{
        [self backup:txtName.text];
        
    }
    
}

}
}


}


 

-(void)reloadInventories{
 
    [inventoryNames removeAllObjects];
    [inventoryNames addObjectsFromArray:[inventoryModel.inventories valueForKey:NAME_KEY]];
 
}
*/
-(void)reloadTable{
    [self.tableView reloadData];
}



-(void)selectFileToImport{
  FilePickerController *filePicker=[ApplicationDelegate.storyBoard instantiateViewControllerWithIdentifier:@"FilePickerController"];
    filePicker.delegate=self;
    filePicker.folder=@"backup";
    UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:filePicker];
    [self presentViewController:nav animated:YES completion:nil];
}

-(void)downloadSampleMenu{
    /*FilePickerController *filePicker=[ApplicationDelegate.storyBoard instantiateViewControllerWithIdentifier:@"FilePickerController"];
    filePicker.delegate=self;
    filePicker.folder=@"backup";
    UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:filePicker];
    [self presentViewController:nav animated:YES completion:nil];
     */
}

-(void)restoreWithName:(NSString *)name{
    
        //UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Import Menu" message:[NSString stringWithFormat:@"Export %@",_selectedInventory.name] delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
        //[self performSegueWithIdentifier:@"toSelectImportInventory" sender:self];
        
    
//}
//-(void)unpackInventoryItem{//:(NSString *)name{ //:(NSString *)keyName
    
    
    //NSString *filePath = [_documentsDirectory stringByAppendingPathComponent:filename];
    
    
    NSData *fileData = [NSData dataWithContentsOfFile:selected_restore_filename];
    if([fileData length] > 0)
    {
        NSDictionary *menuDict = [NSDictionary dictionaryWithDictionary:[NSKeyedUnarchiver unarchiveObjectWithData:fileData]];
        
        InventoryItem *source=[InventoryItem fromDictionaryExport:[menuDict valueForKey:@"inventory_item"]];
        if(name!=nil || name.length>0)
            source.name=name;
        if([inventoryModel exists:source.name]){
            
            //UIAlertView *alert=[[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"%@ exists. Overwrite?"] delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"YES", nil]
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"The name %@ already exists. Please enter new name.",source.name] delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK",nil];
            alert.alertViewStyle = UIAlertViewStylePlainTextInput;
            //[alert addButtonWithTitle:@"Backup"];
            alert.tag=INVENTORY_RESTORE;
            UITextField *txtName=[alert textFieldAtIndex:0];
            txtName.text=[NSString stringWithFormat:@"%@", source.name];
            
            [alert show];
            return;
        }

        NSDictionary *images=[menuDict valueForKey:@"images"];
        NSArray *keys=[images allKeys];
        if([keys count]>0){
            //NSFileManager fileManager=[NSFileManager defaultManager];
            NSString *imagesPath=[AppDelegate getImagesPath];
            for (NSString *imageFileName in keys) {
                
                //if(![fileManager fileExistsAtPath:imagePath]){
                NSData *imageData=[images valueForKey:imageFileName];
                
                if(imageData){
                    //NSString *filePath=[imagesPath stringByAppendingPathComponent:imagePath];
                    
                    //save image
                    NSString *imagePath=[imagesPath stringByAppendingPathComponent:imageFileName];
                    //if(![[NSFileManager defaultManager] fileExistsAtPath:filePath])
                    [imageData writeToFile:imagePath atomically:YES];
                }
                
                //}
            }
        }
        
        
        [inventoryModel.inventories addObject:source];
        [inventoryModel saveInventory];
        [self.tableView reloadData];
        
    }
    
    
}

/*
-(void)exportMenu:(NSString *)deviceID storeName:(NSString *) storeName inventoryItem:(InventoryItem *)inventoryItem {
    //NSAlert *alert=[nsaler]
    //InventoryModel *_inventoryModel =[InventoryModel sharedInstance];
    NSDictionary *menu_dict=nil;
    
    // InventoryItem *inventoryItem=[InventoryModel activeInventory];
    
    if(inventoryItem!=nil)
        menu_dict=[inventoryItem toMenuDictionary:deviceID storeName:storeName];
    
    if(menu_dict==nil)
        return;
    
  
    NSError *error;
    
    NSData *jsonData=[NSJSONSerialization dataWithJSONObject:menu_dict options:NSJSONWritingPrettyPrinted error:&error];
    
    if(error!=nil)
        return;
    
    if(jsonData==nil)
        return;
    
    //}:(NSData *)filedata fileuid:(NSString *)fileuid filecontenttype:(NSString *) filecontenttype{
    AFHTTPClient *client = [AFHTTPClient clientWithBaseURL:[NSURL URLWithString:ServerApiURL]];
    MBProgressHUD* hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = NSLocalizedString(@"Processing...", nil);
    
    NSDictionary *params = @{@"cmd":@"120",
                             @"usertoken": ApplicationDelegate.appConfig.user_userToken//_dataModel.userInfo.userToken
                             //no need ,@"attachment": message.imagefileuid==nil?@"":message.imagefileuid
                             // ,@"fileuid": fileuid
                             
                             
                             };
    
    
    
    // NSMutableURLRequest *request = [client multipartFormRequestWithMethod:@"POST" path:@"/api/index" parameters:params constructingBodyWithBlock: ^(id <AFMultipartFormData>formData) {
    NSMutableURLRequest *request = [client multipartFormRequestWithMethod:@"POST" path:@"/superkiosks/api" parameters:params constructingBodyWithBlock: ^(id <AFMultipartFormData>formData) {
        //NSString *imagesPath=[AppDelegate getImagesPath];
        //if(imagesPath!=nil){
        // NSString *filePath=[imagesPath stringByAppendingPathComponent:newPictureFile];
        
        //save image
        // if(![[NSFileManager defaultManager] fileExistsAtPath:filePath])
        //    [imageData writeToFile:filePath atomically:YES];
        
        //_selectedProduct.pictureFile=newPictureFile;
        //}
        NSString *jsonDataMD5=[jsonData MD5];
        [formData  appendPartWithFileData: jsonData name:[NSString stringWithFormat:@"%@",jsonDataMD5] fileName:[NSString stringWithFormat:@"%@.menu",inventoryItem.name] mimeType:@"application/octet-stream"];
        
        NSString *filePath;
        int i=0;
        for (Product *p in inventoryItem.products) {
            filePath=[imagesPath stringByAppendingPathComponent:p.pictureFile];
            if([[NSFileManager defaultManager] fileExistsAtPath:filePath])
            {
                NSData *imageData=[NSData dataWithContentsOfFile:filePath];
                if(imageData){
                    [formData  appendPartWithFileData: imageData name:[NSString stringWithFormat:@"%d",i] fileName:p.pictureFile mimeType:@"image/png"];
                    i++;
                }
            }
        }
        
        
        
        
    }];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         
         if ([self isViewLoaded])
             [MBProgressHUD hideHUDForView:self.view animated:YES];
         
         if([operation.response statusCode] != 200){
             
             
             [AppDelegate ShowErrorAlert:@"There was an error communicating with the server"];
         }
         else {
             
             if(operation.responseString==nil)
                 return;
             
             
             NSError* error;
             NSDictionary* json=[NSJSONSerialization JSONObjectWithData:operation.responseData options:kNilOptions error:&error];
             
             
             
             NSNumber* success=[json objectForKey:@"success"];
             
             if([success intValue]==1){
                 
 
             }
             else{
                 //ShowErrorAlert(@"There was an error processing your request. Please try again later.");
                 NSString *error_msg=[json objectForKey:@"error"];
                 if (error_msg) {
                     [AppDelegate ShowErrorAlert:error_msg];//ShowErrorAlert(error_msg);
                 }
                 else{
                     [AppDelegate ShowErrorAlert:@"There was an error processing your request."];//ShowErrorAlert(ERROR_MSG_PROCESSING);
                 }
                 
                 
             }
         }
         
         
         
     }
     
                                     failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         
         if ([self isViewLoaded]) {
             [MBProgressHUD hideHUDForView:self.view animated:YES];
             
             [AppDelegate ShowErrorAlert:@"There was an error processing your request. Please try again later."];
         }
     }];
    
    [operation start];
}
*/

-(void)filePickerController:(FilePickerController *)picker didFinishPickingFileWithInfo:(NSDictionary *)info{
    selected_restore_filename=[info valueForKey:@"filename"];
    [picker dismissViewControllerAnimated:YES completion:nil];
    [self restoreWithName:nil];
}
/*
-(void)showItems:(id)sender{
    [self performSegueWithIdentifier:@"toCategoryViewController" sender:self];
}
*/

-(void)showBackupDialog{//:(id)sender{
    UIAlertView * alert =[[UIAlertView alloc ] initWithTitle:@"Backup menu" message:@"Enter backup name" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles: @"OK", nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    //[alert addButtonWithTitle:@"Backup"];
    alert.tag=INVENTORY_BACKUP;
    UITextField *txtName=[alert textFieldAtIndex:0];
    txtName.text=[NSString stringWithFormat:@"%@%@", _selectedInventory.name,@".bak"];
    [alert show];
    
}

@end
