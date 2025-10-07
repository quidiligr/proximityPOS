//
//  InventoryViewController.m
//
//
//  Created by Romulo Quidilig.
//  Copyright (c) 2015 Sharecle Inc. All rights reserved.
//


#import "CategoryListViewController.h"
#import "Product.h"
#import "ProductCategory.h"
#import "NSData+Conversion.h"
#import "CategoryProductsViewController.h"

#import "CategoryCell.h"
#import "defs.h"

#define BUTTON_WIDTH 48
#define PADDING 4
#define BUTTON_HEIGHT 33

#define TAG_ALERT_SHOWADDITEMS 50
#define BTN_CREATE_CATEGORY @"Create your first category"
#define X_POS 85//PADDING+BUTTON_WIDTH+PADDING

@interface CategoryListViewController (){
    NSString *documentPath;
    NSString *imagesPath;
    NSMutableArray *categories;
    NSMutableArray *sortedArray;
    //UIImage *newPictureImage;
    //BOOL imageChanged;
    BOOL isUpdate;
    NSFileManager *fileManager;
    
    //NSDictionary *inventory;
    //NSArray *categorySectionTitles;
    
    //InventoryModel* _inventoryModel;
    //NSIndexPath *selectedIndexPath;
    //NSIndexPath *newIndexPath;
   // NSNumber *selectedRow;
    AppDelegate *_appDelegate;
    UIActionSheet *asMenu;
    UIBarButtonItem *addButton;
    float toolbarHeight;
   // BOOL didAddCategory;
    BOOL triggerAddItem;
}
//@property (weak, nonatomic) IBOutlet UITextField *name;

//@property (weak, nonatomic) IBOutlet UITextField *categoryID;

//@property (weak, nonatomic) IBOutlet UIImageView *pictureFile;

@property (weak, nonatomic) IBOutlet UIButton *btnSave;
//@property (strong, nonatomic) IBOutlet UILabel *messageLabel;

@end

@implementation CategoryListViewController
/*- (id) initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        _inventoryModel = [[InventoryModel alloc] init];
        [_inventoryModel loadInventory];
       // inventory=[_inventoryModel toInventoryDictionary];
        //categorySectionTitles=[inventory allKeys];
    }
    return self;
}
 */
- (void)viewDidLoad {
    [super viewDidLoad];
      //self.view.backgroundColor=[UIColor clearColor];
    _appDelegate=ApplicationDelegate;
     addButton=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(showAddCategory)];
   
    //_inventoryModel=[InventoryModel sharedInstance];
    
    
    self.title=@"Categories";//_selectedInventory.name;//_inventoryModel.name;
    //self.messageLabel.text=@"Select a category to edit or tap + button to add new category.";
   
    [self.view bringSubviewToFront:self.addCategoryView];
    documentPath= [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    
    imagesPath=[self getImagesPath];
    
    fileManager=[NSFileManager defaultManager];

    //imageChanged=NO;
   
    /*[_pictureFile setImage:[UIImage imageNamed:@"empty_picture"]];
    
    
    UITapGestureRecognizer *imageTap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTapped)];
    imageTap.numberOfTapsRequired=1;
    [_pictureFile setUserInteractionEnabled:YES];
    [_pictureFile addGestureRecognizer:imageTap];
    
    [self configurePickerView];
    */
    
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(categoryAdded:) name:NOTIFY_CATEGORY_ADDED object:nil];
    
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(categorySaved:) name:NOTIFY_CATEGORY_SAVED object:nil];
    
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifyShowProducts:) name:NOTIFY_SHOW_PRODUCTS object:nil];
    
    
    [self reloadCategories];
}

-(void)notifyShowProducts:(NSNotification *)notification{
    
    EditCategoryViewController *viewController=[notification.userInfo objectForKey:@"controller"];
    
    [viewController dismissViewControllerAnimated:YES completion:^{
        
         [self performSegueWithIdentifier:@"toCategoryProductsViewController" sender:self];
        
        
    }];
   
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
   
   //[self reloadCategories];
}


-(void)showAddCategory{
   
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:NO];
    //if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        
        //self.navigationItem.rightBarButtonItems=nil;//@[addButton,self.editButtonItem ];
        /*if([sortedArray count]>0)
            self.navigationItem.rightBarButtonItems=nil;//@[addButton,self.editButtonItem ];
        else
            self.navigationItem.rightBarButtonItems=@[self.editButtonItem];
        
        UISplitViewController *svc= (UISplitViewController *)[self.navigationController parentViewController];
        
       
        
        AddCategoryViewController *rightController=[self.storyboard instantiateViewControllerWithIdentifier:@"AddCategoryViewController"];
        rightController.selectedInventory=_selectedInventory;
        
        UINavigationController *navRight=[[UINavigationController alloc] initWithRootViewController:rightController];
        
        NSMutableArray *viewControllers=[svc.viewControllers mutableCopy];
        
        [viewControllers setObject:navRight atIndexedSubscript:1];
     
        svc.viewControllers=viewControllers;
         */
        //[[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_ADD_CATEGORY object:nil];
        
        
        
   //// }
   //// else {
    
    
    //[self performSegueWithIdentifier:@"toAddCategoryViewController" sender:self];
   // }
    
    AddCategoryViewController *vc=[self.storyboard instantiateViewControllerWithIdentifier:@"AddCategoryViewController"];
    //vc.selectedInventory=_selectedInventory;
    vc.delegate=self;
    UINavigationController *navRight=[[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:navRight animated:YES completion:nil];
   
}

-(void)showEditCategory{
    
    
    // self.navigationItem.rightBarButtonItems=nil;
    
    // [self.addCategoryView setHidden:NO];
    
    
    //[self performSegueWithIdentifier:@"toEditCategoryViewController" sender:self];
    
    /*if(last.sortNumber!=[sortedArray count]-1){
     //re-number
     for (NSUInteger i=0; i<[sortedArray count]; i++) {
     ((ProductCategory *)sortedArray[i]).sortNumber=i;
     }
     //[_inventoryModel saveInventory];
     sortedArray=[[_inventoryModel.categories sortedArrayUsingDescriptors:descriptors] mutableCopy];
     
     }
     */
    EditCategoryViewController *vc=[self.storyboard instantiateViewControllerWithIdentifier:@"EditCategoryViewController"];
    //vc.selectedInventory=_selectedInventory;
    vc.selectedCategory=_selectedCategory;
    vc.delegate=self;
    UINavigationController *navRight=[[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:navRight animated:YES completion:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSString*)getImagesPath
{
    //NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    //NSString* documentsDirectory = paths[0];
    NSError *error;
    BOOL isDirectory=YES;
     NSString *directory=[documentPath stringByAppendingPathComponent:@"images"];
    if(![fileManager fileExistsAtPath:directory isDirectory:&isDirectory])
        [fileManager createDirectoryAtPath:directory withIntermediateDirectories:YES attributes:nil error:&error];
    if (error!=nil) {
        return nil;
    }
    return directory;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

//-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    
//    return 36.0;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   
    NSInteger count=[sortedArray count];
    /*if (count>0) {
       
        if(_selectedCategory==nil){
            self.messageLabel.text=MSG_SELECTCATEGORY;
            [self.messageLabel setHidden:NO];
            [self.toolBarr setHidden:YES];
        }
        else{
            [self.messageLabel setHidden:YES];
            [self.toolBarr setHidden:NO];
            [_editCategoryButton setEnabled:YES];
            
            if(count==1){
                [self.upButton setEnabled:NO];
                [self.downButton setEnabled:NO ];
                //[_editProductButton setEnabled:YES];
            }
            else{ //count>1
                
                //first row
                if([_selectedCategory isEqual:[sortedArray firstObject]]){
                    [self.upButton setEnabled:NO];
                    [self.downButton setEnabled:YES ];
                }
                //last row
                else if([_selectedCategory isEqual:[sortedArray lastObject]]){
                    [self.upButton setEnabled:YES];
                    [self.downButton setEnabled:NO ];
                }
                //middle
                else{
                    [self.upButton setEnabled:YES];
                    [self.downButton setEnabled:YES ];
                }
            }
        }
        
        self.navigationItem.rightBarButtonItems=@[addButton,self.editButtonItem];

        
    }
    else{
        self.navigationItem.rightBarButtonItems=@[addButton];
        //self.messageLabel.text=[NSString stringWithFormat:MSG_NOCATEGORY,_selectedInventory.name] ;
        self.messageLabel.text=MSG_NOCATEGORY;
        [self.messageLabel setHidden:NO];
       
         [self.toolBarr setHidden:YES];
        if([self isEditing])
            [self setEditing:NO];
    }
    */
    
    if (count==0)
        count= 1;
    
    return count;//[sortedArray count];
}

/*- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [categorySectionTitles objectAtIndex:section];
}
*/
/*
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_inventoryModel.products count];
}
*/
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if([sortedArray count]==0)
        return [self emptyCell:indexPath];
    else{
        return [self itemCell:indexPath];
    }
    
}


- (UITableViewCell *)emptyCell:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"empty_cell" forIndexPath:indexPath];
    if(cell==nil){
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"empty_cell"];
    }
    /*
     self.messageLabel.text=[NSString stringWithFormat:@"You haven't created any item for %@. Tap + to create your first item.",_selectedCategory.name] ;
     [self.messageLabel setHidden:NO];
     
     [self.toolBarr setHidden:YES];
     */
    cell.textLabel.text=@"You haven't created any category yet. Tap + to create your first category.";
    return cell;
}
- (UITableViewCell *)itemCell:(NSIndexPath *)indexPath{

    CategoryCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"category_cell" forIndexPath:indexPath];
    if(cell==nil){
        cell=[[CategoryCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"category_cell"];
    }
    
    ProductCategory *prodcat=[sortedArray objectAtIndex:indexPath.row];
    if(_selectedCategory!=nil && [prodcat isEqual:_selectedCategory])
        [cell setHighlighted:YES];
    else
        [cell setHighlighted:NO];
    cell.titleLabel.text=prodcat.name;
    cell.subTitleLabel.text=prodcat.detail;
    
   
    if(prodcat.pictureFile.length>0){
        NSString *filePath=[imagesPath stringByAppendingPathComponent:prodcat.pictureFile];
        
        if([fileManager fileExistsAtPath:filePath])
            cell.categoryImageView.image=[[UIImage alloc] initWithContentsOfFile:filePath];
        else
            [cell.categoryImageView setImage:nil];
    }
    else{
        [cell.categoryImageView setImage:nil];

    }
   /* if(selectedRow!=nil){
        if(indexPath.row==[selectedRow integerValue])
            
            //cell.highlighted=YES;
    }
    //else
       // cell.highlighted=NO;
    }
    */
    UIImage *background = [self cellBackgroundForRowAtIndexPath:indexPath];
    
    
    UIImageView *cellBackgroundView = [[UIImageView alloc] initWithImage:background];
    cellBackgroundView.image = background;
    cell.backgroundView = cellBackgroundView;
    return cell;
    
    
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
    
    [self didSelectRowAtIndexPath:indexPath];
    
}

-(void)didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    /*
     _selectedCategory=[sortedArray objectAtIndex:indexPath.row];
    
    
    [self.messageLabel setHidden:YES];
    
    self.toolBarr.alpha=0;
    [self.toolBarr setHidden:NO];
    
    [UIView animateWithDuration:1.0 animations:^{
     self.toolBarr.alpha = 1;
     } completion:^(BOOL finished) {
     
     }];
    
    if([sortedArray count]==1){
        
        [self.upButton setEnabled:NO];
        [self.downButton setEnabled:NO ];
        
    }
    else{
        if (indexPath.row==0)//_selectedCategory.sortNumber==0)
        {//top
            
            [self.upButton setEnabled:NO];
            [self.downButton setEnabled:YES ];
        }
        else if (indexPath.row==[sortedArray count]-1)//_selectedCategory.sortNumber==[sortedArray count]-1)
        { //bottom
            
            [self.upButton setEnabled:YES];
            [self.downButton setEnabled:NO ];
            
            
        }
        else{// middle
            
            [self.upButton setEnabled:YES];
            [self.downButton setEnabled:YES ];
            
        }
        
    }
    
    
    [_editCategoryButton setEnabled:YES];
    */
    //if([sortedArray count]==0){
        
    //}
    //{
        _selectedCategory=[sortedArray objectAtIndex:indexPath.row];
        /*
        if(selectedIndexPath!=nil && (selectedIndexPath.row==indexPath.row)){
            [self showProducts:self];
        }
        else{
            selectedIndexPath=indexPath;
        }
         */
        [self showEditCategory];
    //}
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
    if(editingStyle==UITableViewCellEditingStyleDelete){
        //reset products with this category
        ProductCategory *c=[sortedArray objectAtIndex:indexPath.row];
        NSPredicate *predicate=[NSPredicate predicateWithFormat:@"categoryID=%d",c.categoryID];
        
        NSArray *arr_products=[_appDelegate.inventoryModel.inventory.products filteredArrayUsingPredicate:predicate];
        if([arr_products count]>0){
            //selectedIndexPath=indexPath;
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"Items in this category will be deleted!"] delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Continue", nil];
            
            [alert show];
            
        }
        else{
            
            [_appDelegate.inventoryModel.inventory.categories removeObjectAtIndex:indexPath.row];
            [_appDelegate.inventoryModel saveInventory];
            
            //[_tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [self reloadCategories];
        }
        
        
    }
}

/*
 -(void)moveUpTapped:(id)sender{
 CGPoint buttonPosition=[sender convertPoint:CGPointZero toView:self.tableView];
 
 NSIndexPath *indexPath= [self.tableView indexPathForRowAtPoint:buttonPosition];
 if (indexPath.row==0)
 return;
 Product *p1=[sortedArray objectAtIndex:indexPath.row];
 Product *p2=[sortedArray objectAtIndex:indexPath.row-1];
 p1.sortNumber=indexPath.row-1;
 p2.sortNumber=indexPath.row;
 [_inventoryModel saveInventory];
 [self reloadCategoryProducts];
 
 
 }
 
 -(void)moveDownTapped:(id)sender{
 CGPoint buttonPosition=[sender convertPoint:CGPointZero toView:self.tableView];
 
 NSIndexPath *indexPath= [self.tableView indexPathForRowAtPoint:buttonPosition];
 if (indexPath.row>=[sortedArray count])
 return;
 Product *p1=[sortedArray objectAtIndex:indexPath.row];
 Product *p2=[sortedArray objectAtIndex:indexPath.row+1];
 p1.sortNumber=indexPath.row+1;
 p2.sortNumber=indexPath.row;
 [_inventoryModel saveInventory];
 [self reloadCategoryProducts];
 
 
 }

 */
/*-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    CGRect frame=tableView.frame;
    
    
    UIButton *editButton=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    editButton.frame=CGRectMake(frame.size.width-(X_POS), PADDING, BUTTON_WIDTH, BUTTON_HEIGHT);
    [editButton setImage:[UIImage imageNamed:@"UIButtonBarCompose"] forState:UIControlStateNormal];
    [editButton addTarget:self action:@selector(showEditCategory) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *moveUpButton=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    moveUpButton.frame=CGRectMake(frame.size.width-(editButton.frame.size.width+X_POS), PADDING, BUTTON_WIDTH, BUTTON_HEIGHT);
    [moveUpButton setImage:[UIImage imageNamed:@"UIButtonBarArrowUp"] forState:UIControlStateNormal];
    [moveUpButton addTarget:self action:@selector(moveUpTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *moveDownButton=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    moveDownButton.frame=CGRectMake(frame.size.width-(editButton.frame.size.width+moveUpButton.frame.size.width+X_POS), PADDING, BUTTON_WIDTH, BUTTON_HEIGHT);
    [moveDownButton setImage:[UIImage imageNamed:@"UIButtonBarArrowDown"] forState:UIControlStateNormal];
    [moveDownButton addTarget:self action:@selector(moveDownTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    */
    /*btnReferesh=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    btnReferesh.frame=CGRectMake(frame.size.width-(btnHidePlayer.frame.size.width+PADDING+BUTTON_WIDTH+PADDING), PADDING, BUTTON_WIDTH, BUTTON_HEIGHT);
    [btnReferesh setImage:[UIImage imageNamed:@"UIButtonBarRefreshLandscape"] forState:UIControlStateNormal];
    [btnReferesh addTarget:self action:@selector(reloadData) forControlEvents:UIControlEventTouchUpInside];
    
    
    btnCompose=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    btnCompose.frame=CGRectMake(frame.size.width-(btnReferesh.frame.size.width+btnHidePlayer.frame.size.width+PADDING+BUTTON_WIDTH+PADDING), PADDING, BUTTON_WIDTH, BUTTON_HEIGHT);
    
    [btnCompose setImage:[UIImage imageNamed:@"UIButtonBarCompose"] forState:UIControlStateNormal];
    [btnCompose addTarget:self action:@selector(composeAction:) forControlEvents:UIControlEventTouchUpInside];
    */
    
   // UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
    
    
    
    /* UILabel *lblTitle=[[UILabel alloc] initWithFrame:CGRectMake(0, 5, 200, 32)];
     lblTitle.text=[NSString stringWithFormat:@"#%@  %@",_dataModel.selectedBroadcast.channelid, (_dataModel.selectedBroadcast.title.length==0)?_dataModel.selectedBroadcast.channelid:_dataModel.selectedBroadcast.title];
     
     [headerView addSubview:lblTitle];
     */
/*    [headerView addSubview:editButton];
    [headerView addSubview:moveUpButton];
    [headerView addSubview:moveDownButton];
    
    
    return headerView;
}
*/
-(IBAction)moveUpTapped:(id)sender{
   // CGPoint buttonPosition=[sender convertPoint:CGPointZero toView:self.tableView];
    
    //NSIndexPath *indexPath= [self.tableView indexPathForRowAtPoint:buttonPosition];
      NSIndexPath *indexPath= [self.tableView indexPathForSelectedRow];
    if (indexPath.row==0)
        return;
    
     NSIndexPath *selectedIndexPath=[NSIndexPath indexPathForRow:indexPath.row-1 inSection:0];
   
    ProductCategory *p1=[sortedArray objectAtIndex:indexPath.row];
    ProductCategory *p2=[sortedArray objectAtIndex:indexPath.row-1];
    p1.sortNumber=indexPath.row-1;
    p2.sortNumber=indexPath.row;
    [_appDelegate.inventoryModel saveInventory];
    [self reloadCategories];
  
    [self.tableView selectRowAtIndexPath:selectedIndexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
}

-(IBAction)moveDownTapped:(id)sender{
   
    NSIndexPath *indexPath= [self.tableView indexPathForSelectedRow];

    if (indexPath.row==[sortedArray count]-1)
        return;
   
    NSIndexPath *selectedIndexPath=[NSIndexPath indexPathForRow:indexPath.row+1 inSection:0];
    
   // selectedRow=[NSNumber numberWithUnsignedInteger:indexPath.row+1];
    
    ProductCategory *p1=[sortedArray objectAtIndex:indexPath.row];
    ProductCategory *p2=[sortedArray objectAtIndex:indexPath.row+1];
    p1.sortNumber=indexPath.row+1;
    p2.sortNumber=indexPath.row;
    [_appDelegate.inventoryModel saveInventory];
     [self reloadCategories];
   
    [self.tableView selectRowAtIndexPath:selectedIndexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
    
}

-(void)showProducts{
    
        [self performSegueWithIdentifier:@"toCategoryProductsViewController" sender:self];
    
}

- (IBAction)showProductsAction:(id)sender {
  /*  NSIndexPath *indexPath=[self.tableView indexPathForSelectedRow];
    if(indexPath==nil)
        return;
     _selectedCategory= [sortedArray objectAtIndex:indexPath.row];
    */
   //// if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        /*UISplitViewController *svc=[self.storyboard instantiateViewControllerWithIdentifier:@"svcCategoryProducts"];
        UINavigationController *nav=[svc.viewControllers objectAtIndex:0];
        
        
        
        CategoryProductsViewController *leftController=(CategoryProductsViewController *)[nav topViewController];
        leftController.selectedInventory=self.selectedInventory;
        leftController.selectedCategory=_selectedCategory;
        
        self.view.window.rootViewController=svc;
         */
   // }
    //else{
       
        [self performSegueWithIdentifier:@"toCategoryProductsViewController" sender:self];
       // }
    
    
}
- (IBAction)editCategory:(id)sender {
    //NSIndexPath *indexPath=[self.tableView indexPathForSelectedRow];
    //if(indexPath==nil)
      //  return;
    
    //_selectedCategory= [sortedArray objectAtIndex:indexPath.row];
    /*[self performSegueWithIdentifier:@"toEditCategoryViewController" sender:self];
     */
    if(_selectedCategory!=nil)
        [self showEditCategory];
}

/*
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell=[_tableView dequeueReusableCellWithIdentifier:@"product_cell" forIndexPath:indexPath];
    
    if(cell==nil){
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"product_cell"];
    }
    Product *product=[_inventoryModel.products objectAtIndex:indexPath.row];
    
    cell.textLabel.text=product.name;
    cell.detailTextLabel.text=[NSString stringWithFormat:@"%f",product.price];
     [cell.imageView setImage:[UIImage imageNamed:@"empty_picture"]];
   // NSString *newPictureFile=[imageData MD5];
    if(product.pictureFile.length>0){
        NSString *filePath=[imagesPath stringByAppendingPathComponent:product.pictureFile];
        
        if([fileManager fileExistsAtPath:filePath])
            cell.imageView.image=[[UIImage alloc] initWithContentsOfFile:filePath];
        //else
        //    [cell.imageView setImage:[UIImage imageNamed:@"empty_picture"]];
    }
    
    return cell;
}



-(void)showEditCategory:(NSIndexPath *)indexPath{
    _selectedCategory= [_selectedInventory.categories objectAtIndex:indexPath.row];
    
    //if(editCategory==nil)
     //   return;
    
    _name.text=_selectedCategory.name;
    
    
    [_pictureFile setImage:[UIImage imageNamed:@"empty_picture"]];
    
    
    if(_selectedCategory.pictureFile.length>0){
        NSString *filePath=[imagesPath stringByAppendingPathComponent:_selectedCategory.pictureFile];
        
        if([fileManager fileExistsAtPath:filePath])
            _pictureFile.image=[[UIImage alloc] initWithContentsOfFile:filePath];
        
    }
    isUpdate=YES;
    [_btnSave setTitle:@"Update" forState:UIControlStateNormal];
}


-(void)imageTapped{
    UIImagePickerController *picker=[[UIImagePickerController alloc] init];
    picker.modalPresentationStyle=UIModalPresentationCurrentContext;

    picker.delegate=self;
    picker.allowsEditing=YES;
    picker.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:picker animated:YES
                     completion:NULL];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    UIImage *chosenImage=info[UIImagePickerControllerEditedImage];
    [_pictureFile setImage:chosenImage];
    //imageChanged=YES;
    [picker dismissViewControllerAnimated:YES completion:nil];
}
*/

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"toCategoryProductsViewController"]){
    CategoryProductsViewController *vc=[segue destinationViewController];
    vc.selectedCategory=_selectedCategory;
        //vc.selectedInventory=self.selectedInventory;
        if(triggerAddItem){
            //reset
            triggerAddItem=NO;
            vc.triggerAddItem=YES;
        }
        else{
            vc.triggerAddItem=NO;
        }
    }
    
    
    /*
    else if([segue.identifier isEqualToString:@"toAddCategoryViewController"]){
        AddCategoryViewController *vc=[segue destinationViewController];
        vc.selectedInventory=self.selectedInventory;
        
    }
    else if([segue.identifier isEqualToString:@"toEditCategoryViewController"]){
        EditCategoryViewController *vc=[segue destinationViewController];
         vc.selectedCategory=_selectedCategory;
        vc.selectedInventory=self.selectedInventory;
    }
     */
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    /*if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"Yes"]) {
       
        if (alertView.tag==1)
            [self performSegueWithIdentifier:@"toAddCategoryViewController" sender:self];
        else if(alertView.tag==2)
            [self performSegueWithIdentifier:@"toCategoryProductsViewController" sender:self];
    }
     */
    NSString *titleBtn=[alertView buttonTitleAtIndex:buttonIndex];
    
    if(alertView.tag==TAG_ALERT_SHOWADDITEMS){
        if([titleBtn isEqualToString:@"Yes"]){
            triggerAddItem=YES;
            [self showProducts];
        }
    }
    else{
        if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:BTN_CREATE_CATEGORY]) {
            
            //if (alertView.tag==1)
                [self performSegueWithIdentifier:@"toAddCategoryViewController" sender:self];
            //else if(alertView.tag==2)
              //  [self performSegueWithIdentifier:@"toCategoryProductsViewController" sender:self];
        }
    }
}
- (IBAction)doneButtonTapped:(id)sender {
    NSInteger count=[_appDelegate.inventoryModel.inventory.categories count];
    if (count>0) {
        
        self.navigationItem.rightBarButtonItems=@[addButton,self.editButtonItem];
    }
    else{
        self.navigationItem.rightBarButtonItems=@[addButton];
    }
    [self.addCategoryView setHidden:YES];
}


-(void)reloadCategories{
  
    
    NSSortDescriptor *valueDescriptors=[[NSSortDescriptor alloc] initWithKey:@"sortNumber" ascending:YES];
    NSArray *descriptors=[NSArray arrayWithObject:valueDescriptors];
    
   
    sortedArray=[[_appDelegate.inventoryModel.inventory.categories sortedArrayUsingDescriptors:descriptors] mutableCopy];
    
    
    
    [self.tableView reloadData];
    
}


-(void)addCategoryViewControllerDidAddCategory:(AddCategoryViewController *)viewController withNewCategory:(ProductCategory *)newCategory{
    _selectedCategory=newCategory;
    [viewController dismissViewControllerAnimated:YES completion:^{
        
        [self reloadCategories];
        NSIndexPath *newIndexPath=[NSIndexPath indexPathForRow:[sortedArray count]-1 inSection:0];//[self.tableView sele]
        //if(selectedIndexPath!=nil){
            [self.tableView selectRowAtIndexPath:newIndexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
        [self didSelectRowAtIndexPath:newIndexPath];
        //UIAlertView *showAddItemsAlert=[[UIAlertView alloc] initWithTitle:@"Notification" message:[NSString stringWithFormat:@"Add items to %@ category?",_selectedCategory.name]  delegate:self cancelButtonTitle:@"Later" otherButtonTitles:@"Yes", nil];
        UIAlertView *showAddItemsAlert=[[UIAlertView alloc] initWithTitle:@"Notification" message:[NSString stringWithFormat:@"Add items to %@ category?",_selectedCategory.name]  delegate:self cancelButtonTitle:@"Later" otherButtonTitles:@"Yes", nil];
        showAddItemsAlert.tag=TAG_ALERT_SHOWADDITEMS;
        [showAddItemsAlert show];
        
        }];
}

-(void)editCategoryViewControllerDidUpdateCategory:(EditCategoryViewController *)viewController{
    
    [viewController dismissViewControllerAnimated:YES completion:^{
        
        [self reloadCategories];
        
       
    }];
}
@end
