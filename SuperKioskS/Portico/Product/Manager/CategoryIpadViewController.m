//
//  InventoryViewController.m
//
//
//  Created by Romulo Quidilig.
//  Copyright (c) 2015 Sharecle Inc. All rights reserved.
//


#import "CategoryIpadViewController.h"
#import "Product.h"
#import "ProductCategory.h"
#import "NSData+Conversion.h"
#import "CategoryProductsViewController.h"
#import "AddCategoryViewController.h"
#import "EditCategoryViewController.h"
#import "CategoryCell.h"
#import "defs.h"

#define BUTTON_WIDTH 48
#define PADDING 4
#define BUTTON_HEIGHT 33
#define MSG_NOCATEGORY @"You haven't created any categories. Tap + to create your fist category."
#define MSG_SELECTCATEGORY @"Select a category to modify."
#define BTN_CREATE_CATEGORY @"Create your first category"
#define X_POS 85//PADDING+BUTTON_WIDTH+PADDING

@interface CategoryIpadViewController (){
    NSString *documentPath;
    NSString *imagesPath;
    NSMutableArray *categories;
    NSMutableArray *sortedArray;
    //UIImage *newPictureImage;
    BOOL imageChanged;
    BOOL isUpdate;
    NSFileManager *fileManager;
    ProductCategory *selectedCategory;
    //NSDictionary *inventory;
    //NSArray *categorySectionTitles;
    
    InventoryModel* _inventoryModel;
    NSIndexPath *selectedIndexPath;
    //NSIndexPath *newIndexPath;
   // NSNumber *selectedRow;
    
    UIBarButtonItem *addButton;
    float toolbarHeight;
   // BOOL didAddCategory;
}
@property (weak, nonatomic) IBOutlet UITextField *name;

//@property (weak, nonatomic) IBOutlet UITextField *categoryID;

@property (weak, nonatomic) IBOutlet UIImageView *pictureFile;

@property (weak, nonatomic) IBOutlet UIButton *btnSave;
@property (strong, nonatomic) IBOutlet UILabel *messageLabel;

@end

@implementation CategoryIpadViewController
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
     addButton=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(showAddCategory)];
   
    _inventoryModel=[InventoryModel sharedInstance];
    [self reloadCategories];
    
    self.title=_selectedInventory.name;//_inventoryModel.name;
    self.messageLabel.text=@"Select a category to edit or tap + button to add new category.";
    toolbarHeight=44.0;
    //[self hideToolBar:YES];//[self.toolBar setHidden:YES];
    self.toolBar.alpha = 0;
   // self.navigationItem.rightBarButtonItem=rightButton;
    [self.view bringSubviewToFront:self.addCategoryView];
    documentPath= [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    
    imagesPath=[self getImagesPath];
    
    fileManager=[NSFileManager defaultManager];

    imageChanged=NO;
    //NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
   // NSString *filePath=[documentPath stringByAppendingPathComponent:@"empty_picture.png"];
    [_pictureFile setImage:[UIImage imageNamed:@"empty_picture"]];
    
    //_myPhoto.image=[UIImage imageNamed:@"myphoto.png"];
    //if(_pictureFile.image==nil)
    //    _pictureFile.image=[UIImage imageNamed:@"person"];
    
    //rounded image
    //_pictureFile.layer.cornerRadius=_pictureFile.frame.size.width / 2;
    //_pictureFile.clipsToBounds = YES;
   // newPictureImage=nil;
    UITapGestureRecognizer *imageTap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTapped)];
    imageTap.numberOfTapsRequired=1;
    [_pictureFile setUserInteractionEnabled:YES];
    [_pictureFile addGestureRecognizer:imageTap];
    
    [self configurePickerView];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(categoryAdded:) name:NOTIFY_CATEGORY_ADDED object:nil];
    
}
-(void)categoryAdded:(NSNotification *)notification{
    [self reloadCategories];
    selectedCategory=[sortedArray lastObject];
    if(selectedCategory!=nil){
        /*if([selectedCategory.products count]==0){
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Categories" message:[NSString stringWithFormat:@"Add item(s) to %@?",selectedCategory.name] delegate:self cancelButtonTitle:@"Later" otherButtonTitles:@"Yes", nil];
            alert.tag=2;
            [alert show];
        }*/
        selectedIndexPath=[NSIndexPath indexPathForRow:[sortedArray count]-1 inSection:0];
       // this crash [self.tableView selectRowAtIndexPath:selectedIndexPath animated:YES scrollPosition:UITableViewScrollPositionBottom];
       // didAddCategory=YES;
      //  UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Empty menu" message:@"Add item(s) to your Menu now?" delegate:self cancelButtonTitle:@"Later" otherButtonTitles:@"Yes", nil];
    }
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    
    [self.tableView reloadData];
    
    if ([_selectedInventory.categories count]==0) {
        self.messageLabel.text=MSG_NOCATEGORY;
        [self.messageLabel setHidden:NO];
        self.toolBar.alpha = 0; //[self hideToolBar:YES];//[self.toolBar setHidden:YES];
        [self.tableView setHidden:YES];
        /*UIAlertView *alert=[[UIAlertView alloc] initWithTitle:nil message:MSG_NOCATEGORY delegate:self cancelButtonTitle:@"Later" otherButtonTitles:BTN_CREATE_CATEGORY, nil];
        
        [alert show];
        */
    }
    else{
        [self.tableView setHidden:NO];
        self.messageLabel.text=MSG_SELECTCATEGORY;
        [self.messageLabel setHidden:NO];

        if(selectedCategory!=nil && selectedIndexPath!=nil){
            
            //[self hideToolBar:NO];
            self.toolBar.alpha = 1;
            [self.tableView selectRowAtIndexPath:selectedIndexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
        }
        else
            //[self hideToolBar:YES];
            
            self.toolBar.alpha = 0;
        //[self reloadCategories];
        
            //this will clean sortnumbers
        
        
        
        
    }
}


-(void)showAddCategory{
   
    
   // self.navigationItem.rightBarButtonItems=nil;
    
   // [self.addCategoryView setHidden:NO];
    
    
    [self performSegueWithIdentifier:@"toAddCategoryViewController" sender:self];
    
    /*if(last.sortNumber!=[sortedArray count]-1){
        //re-number
        for (NSUInteger i=0; i<[sortedArray count]; i++) {
            ((ProductCategory *)sortedArray[i]).sortNumber=i;
        }
        //[_inventoryModel saveInventory];
        sortedArray=[[_inventoryModel.categories sortedArrayUsingDescriptors:descriptors] mutableCopy];
        
    }
     */
}

-(void)showEditCategory{
    
    
    // self.navigationItem.rightBarButtonItems=nil;
    
    // [self.addCategoryView setHidden:NO];
    
    
    [self performSegueWithIdentifier:@"toEditCategoryViewController" sender:self];
    
    /*if(last.sortNumber!=[sortedArray count]-1){
     //re-number
     for (NSUInteger i=0; i<[sortedArray count]; i++) {
     ((ProductCategory *)sortedArray[i]).sortNumber=i;
     }
     //[_inventoryModel saveInventory];
     sortedArray=[[_inventoryModel.categories sortedArrayUsingDescriptors:descriptors] mutableCopy];
     
     }
     */
}

#pragma mark - UIPicker configuration
- (void)configurePickerView {
    
    /*self.categoryTextField.text=_selectedCategory.name;
    //self.categoryTextField.textColor = [UIColor blackColor];
    
    self.pickerCategory = [[UIPickerView alloc] init];
    self.pickerCategory.dataSource=self;
    self.pickerCategory.delegate=self;
    self.pickerCategory.showsSelectionIndicator = YES;
    [self.pickerCategory selectRow:[_inventoryModel.categories indexOfObject:_selectedCategory] inComponent:0 animated:YES];
     */
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
    
    [pickerToolbar setItems:[NSArray arrayWithObjects:flexibleSpaceLeft, doneButton, nil]];
    
    
    
    
    self.name.inputAccessoryView = pickerToolbar;
   
    
}

- (void)pickerDoneButtonPressed {
    [self.view endEditing:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

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
/*
- (IBAction)actionSave:(id)sender {
    
    [self.view endEditing:YES];
    
   if(_name.text==nil || _name.text.length==0)
       return;
    [_name.text stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" "]];
    
    if(_name.text.length==0)
        return;
    
    if(!isUpdate){
        
        
        NSString *imageName=@"";
        
        
        //if(imageChanged){
            //NSData *data=UIImagePNGRepresentation(_pictureFile.image);
            //item.pictureFile=[data MD5];
            //create path
            NSData *imageData=[[NSData alloc] initWithData:UIImagePNGRepresentation(_pictureFile.image)];
            if(imageData){
                //NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                
                NSString *newPictureFile=[NSString stringWithFormat:@"%@.png",[imageData MD5]];
                
               
                if(imagesPath!=nil){
                    NSString *filePath=[imagesPath stringByAppendingPathComponent:newPictureFile];
                    
                    
                    //save image
                    if(![fileManager fileExistsAtPath:filePath])
                        [imageData writeToFile:filePath atomically:YES];
                    
                   // newCategory.pictureFile=newPictureFile;
                }
            }
            
       // }
        
        //get categroy id
        //[_inventoryModel addCategory:_name.text imageName:imageName];
        [self endSave];
        
        selectedCategory= [_inventoryModel.categories lastObject];
        [self performSegueWithIdentifier:@"toCategoryProducts" sender:self];
        return;
       //[_inventoryModel addInventory:newProduct];
        
    }
    else{
        
        selectedCategory.name=_name.text;
        
      
            NSData *imageData=[[NSData alloc] initWithData:UIImagePNGRepresentation(_pictureFile.image)];
            if(imageData){
                //NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                
                NSString *newPictureFile=[NSString stringWithFormat:@"%@.png",[imageData MD5]];
                
                
                if(imagesPath!=nil){
                    NSString *filePath=[documentPath stringByAppendingPathComponent:newPictureFile];
                    
                    //save image
                    if(![fileManager fileExistsAtPath:filePath])
                        [imageData writeToFile:filePath atomically:YES];
                    
                    selectedCategory.pictureFile=newPictureFile;
                }
            }
            
        //}
        [_inventoryModel saveInventory];

    }
        _name.text=nil;
    //_price.text=nil;
    [self endSave];
}
*/
-(void)endSave{
    _name.text=nil;
    //_price.text=nil;
    isUpdate=NO;
    
    [_pictureFile setImage:[UIImage imageNamed:@"empty_picture"]];
    
    [_btnSave setTitle:@"Add" forState:UIControlStateNormal];
    [self.tableView reloadData];
    [self.delegate categoryIpadViewControllerdidUpdate:self];
    [self.addCategoryView setHidden:YES];
    
    NSInteger count=[_selectedInventory.categories count];
    if (count>0) {
        
        self.navigationItem.rightBarButtonItems=@[addButton,self.editButtonItem ];
    }
    else{
        self.navigationItem.rightBarButtonItems=@[addButton];
    }
    
    [self.addCategoryView setHidden:YES];
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
    // Return the number of rows in the section.
  //  NSString *sectionTitle = [categorySectionTitles objectAtIndex:section];
   // NSArray *sectionProducts = [inventory objectForKey:sectionTitle];
    NSInteger count=[sortedArray count];
    if (count>0) {
        self.messageLabel.text=MSG_SELECTCATEGORY;
        [self.messageLabel setHidden:NO];
        self.toolBar.alpha = 1;
        self.navigationItem.rightBarButtonItems=@[addButton,self.editButtonItem];
        [self.tableView setHidden:NO];
        
        }
    else{
        self.messageLabel.text=MSG_NOCATEGORY;
        [self.messageLabel setHidden:NO];
        self.navigationItem.rightBarButtonItems=@[addButton];
        self.toolBar.alpha = 0;
        [self.tableView setHidden:YES];
    }
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
    CategoryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"category_cell" forIndexPath:indexPath];
    if(cell==nil){
        cell=[[CategoryCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"category_cell"];
    }
    
    ProductCategory *prodcat=[sortedArray objectAtIndex:indexPath.row];
    cell.titleLabel.text=prodcat.name;
    cell.subTitleLabel.text=prodcat.detail;
    
    /*
    if([sortedArray count]==1){
        [cell.downButton setHidden:YES];
        [cell.upButton setHidden:YES];
    }
    else{
        if (prodcat.sortNumber==0) {//top
            [cell.upButton setHidden:YES];
             [cell.downButton setHidden:NO];
            [cell.downButton addTarget:self action:@selector(moveDownTapped:) forControlEvents:UIControlEventTouchUpInside];
        }
        else if (prodcat.sortNumber==[sortedArray count]-1){ //bottom
            [cell.downButton setHidden:YES];
            [cell.upButton setHidden:NO];
            [cell.upButton addTarget:self action:@selector(moveUpTapped:) forControlEvents:UIControlEventTouchUpInside];
        }
        else{// middle
            [cell.downButton setHidden:NO];
            [cell.upButton setHidden:NO];
            [cell.upButton addTarget:self action:@selector(moveUpTapped:) forControlEvents:UIControlEventTouchUpInside];
             [cell.downButton addTarget:self action:@selector(moveDownTapped:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    */
    
    ///cell.detailTextLabel.text=[NSString stringWithFormat:@"%f",prodcat.price];
    [cell.categoryImageView setImage:[UIImage imageNamed:@"empty_picture"]];
    // NSString *newPictureFile=[imageData MD5];
    if(prodcat.pictureFile.length>0){
        NSString *filePath=[imagesPath stringByAppendingPathComponent:prodcat.pictureFile];
        
        if([fileManager fileExistsAtPath:filePath])
            cell.categoryImageView.image=[[UIImage alloc] initWithContentsOfFile:filePath];
        //else
        //    [cell.imageView setImage:[UIImage imageNamed:@"empty_picture"]];
    }
   /* if(selectedRow!=nil){
        if(indexPath.row==[selectedRow integerValue])
            
            //cell.highlighted=YES;
    }
    //else
       // cell.highlighted=NO;
    }
    */
    return cell;
    
    
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
     selectedIndexPath=[NSIndexPath indexPathForRow:indexPath.row-1 inSection:0];
   // selectedRow=[NSNumber numberWithUnsignedInteger:indexPath.row-1];
    ProductCategory *p1=[sortedArray objectAtIndex:indexPath.row];
    ProductCategory *p2=[sortedArray objectAtIndex:indexPath.row-1];
    p1.sortNumber=indexPath.row-1;
    p2.sortNumber=indexPath.row;
    [_inventoryModel saveInventory];
    [self reloadCategories];
   //[self.tableView selectRowAtIndexPath:newIndexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
    [self.tableView selectRowAtIndexPath:selectedIndexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
}

-(IBAction)moveDownTapped:(id)sender{
   // CGPoint buttonPosition=[sender convertPoint:CGPointZero toView:self.tableView];
    
   // NSIndexPath *indexPath= [self.tableView indexPathForRowAtPoint:buttonPosition];
    NSIndexPath *indexPath= [self.tableView indexPathForSelectedRow];

    if (indexPath.row==[sortedArray count]-1)
        return;
    selectedIndexPath=[NSIndexPath indexPathForRow:indexPath.row+1 inSection:0];
    
   // selectedRow=[NSNumber numberWithUnsignedInteger:indexPath.row+1];
    
    ProductCategory *p1=[sortedArray objectAtIndex:indexPath.row];
    ProductCategory *p2=[sortedArray objectAtIndex:indexPath.row+1];
    p1.sortNumber=indexPath.row+1;
    p2.sortNumber=indexPath.row;
    [_inventoryModel saveInventory];
     [self reloadCategories];
   [self.tableView selectRowAtIndexPath:selectedIndexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
    
}
- (IBAction)showProducts:(id)sender {
    NSIndexPath *indexPath=[self.tableView indexPathForSelectedRow];
    if(indexPath==nil)
        return;
    
    selectedCategory= [sortedArray objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"toCategoryProductsViewController" sender:self];
}
- (IBAction)editCategory:(id)sender {
    NSIndexPath *indexPath=[self.tableView indexPathForSelectedRow];
    if(indexPath==nil)
        return;
    
    selectedCategory= [sortedArray objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"toEditCategoryViewController" sender:self];
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
*/
-(void)showEditCategory:(NSIndexPath *)indexPath{
    selectedCategory= [_selectedInventory.categories objectAtIndex:indexPath.row];
    
    //if(editCategory==nil)
     //   return;
    
    _name.text=selectedCategory.name;
    
    
    [_pictureFile setImage:[UIImage imageNamed:@"empty_picture"]];
    
    
    if(selectedCategory.pictureFile.length>0){
        NSString *filePath=[imagesPath stringByAppendingPathComponent:selectedCategory.pictureFile];
        
        if([fileManager fileExistsAtPath:filePath])
            _pictureFile.image=[[UIImage alloc] initWithContentsOfFile:filePath];
        
    }
    isUpdate=YES;
    [_btnSave setTitle:@"Update" forState:UIControlStateNormal];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
   /* selectedCategory= [sortedArray objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"toCategoryProducts" sender:self];
    */
  
    selectedCategory=[sortedArray objectAtIndex:indexPath.row];
    NSMutableArray *toolBarButtons=[self.toolbarItems mutableCopy];
    
    //[self hideToolBar:NO];//[self.toolBar setHidden:NO];
    self.messageLabel.text=MSG_SELECTCATEGORY;
    [self.messageLabel setHidden:YES];
    self.toolBar.alpha=0;
    [UIView animateWithDuration:1.0 animations:^{
        self.toolBar.alpha = 1;
    } completion:^(BOOL finished) {
        
    }];

    
    if([sortedArray count]==1){
        //[cell.downButton setHidden:YES];
        //[cell.upButton setHidden:YES];
        [toolBarButtons removeObject:self.upButton ];
        [toolBarButtons removeObject:self.downButton ];
        
    }
    else{
       if (selectedCategory.sortNumber==0) {//top
            [toolBarButtons removeObject:self.upButton ];
            
            if(![toolBarButtons containsObject:self.downButton])
                [toolBarButtons addObject:self.downButton ];
            
       }
       else if (selectedCategory.sortNumber==[sortedArray count]-1){ //bottom
           [toolBarButtons removeObject:self.downButton ];
           if(![toolBarButtons containsObject:self.upButton])
               [toolBarButtons addObject:self.upButton ];
           
        }
        else{// middle
            
            if(![toolBarButtons containsObject:self.upButton])
             [toolBarButtons addObject:self.upButton ];
            
            if(![toolBarButtons containsObject:self.downButton])
             [toolBarButtons addObject:self.downButton ];

        }
        
    }
    [self setToolbarItems:toolBarButtons animated:YES];
    
    if(selectedIndexPath!=nil && (selectedIndexPath.row==indexPath.row)){
        [self showProducts:self];
    }
    else{
        selectedIndexPath=indexPath;
    }
    
}

-(void)setEditing:(BOOL)editing animated:(BOOL)animated{
    [super setEditing:editing animated:animated];
    [self.tableView setEditing:editing animated:animated];
    if(editing){
        
    }
    else{
        
    }
}

-(void)imageTapped{
    UIImagePickerController *picker=[[UIImagePickerController alloc] init];
    picker.delegate=self;
    picker.allowsEditing=YES;
    picker.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:picker animated:YES
                     completion:NULL];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    UIImage *chosenImage=info[UIImagePickerControllerEditedImage];
    [_pictureFile setImage:chosenImage];
    imageChanged=YES;
    [picker dismissViewControllerAnimated:YES completion:nil];
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if(editingStyle==UITableViewCellEditingStyleDelete){
        //reset products with this category
        ProductCategory *c=[sortedArray objectAtIndex:indexPath.row];
        NSPredicate *predicate=[NSPredicate predicateWithFormat:@"categoryID=%d",c.categoryID];
        
        NSArray *arr_products=[self.selectedInventory.products filteredArrayUsingPredicate:predicate];
        if([arr_products count]>0){
            selectedIndexPath=indexPath;
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"Items in this category will be deleted!"] delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Continue", nil];
            
            [alert show];
            
        }
        else{
            
            [_selectedInventory.categories removeObjectAtIndex:indexPath.row];
            [_inventoryModel saveInventory];
            
            //[_tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [self reloadCategories];
        }
        
        
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"toCategoryProductsViewController"]){
    CategoryProductsViewController *vc=[segue destinationViewController];
    vc.selectedCategory=selectedCategory;
        vc.selectedInventory=self.selectedInventory;
    }
    
    else if([segue.identifier isEqualToString:@"toAddCategoryViewController"]){
        AddCategoryViewController *vc=[segue destinationViewController];
        vc.selectedInventory=self.selectedInventory;
        
    }
    else if([segue.identifier isEqualToString:@"toEditCategoryViewController"]){
        EditCategoryViewController *vc=[segue destinationViewController];
         vc.selectedCategory=selectedCategory;
        vc.selectedInventory=self.selectedInventory;
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    /*if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"Yes"]) {
       
        if (alertView.tag==1)
            [self performSegueWithIdentifier:@"toAddCategoryViewController" sender:self];
        else if(alertView.tag==2)
            [self performSegueWithIdentifier:@"toCategoryProductsViewController" sender:self];
    }
     */
    if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:BTN_CREATE_CATEGORY]) {
        
        //if (alertView.tag==1)
            [self performSegueWithIdentifier:@"toAddCategoryViewController" sender:self];
        //else if(alertView.tag==2)
          //  [self performSegueWithIdentifier:@"toCategoryProductsViewController" sender:self];
    }
}
- (IBAction)doneButtonTapped:(id)sender {
    NSInteger count=[_selectedInventory.categories count];
    if (count>0) {
        
        self.navigationItem.rightBarButtonItems=@[addButton,self.editButtonItem];
    }
    else{
        self.navigationItem.rightBarButtonItems=@[addButton];;
    }
    [self.addCategoryView setHidden:YES];
}


-(void)reloadCategories{
   // NSPredicate *predicate=[NSPredicate predicateWithFormat:@"categoryID=%d",self.currentCategory.categoryID];
    
    NSSortDescriptor *valueDescriptors=[[NSSortDescriptor alloc] initWithKey:@"sortNumber" ascending:YES];
    NSArray *descriptors=[NSArray arrayWithObject:valueDescriptors];
    
    //categoryProducts=[_inventoryModel.products filteredArrayUsingPredicate:predicate] ;
    sortedArray=[[_selectedInventory.categories sortedArrayUsingDescriptors:descriptors] mutableCopy];
   // [self.tableView reloadData];
    //assign sort number
    /*if([sortedArray count]>0)
    {
        
        ProductCategory *last=[sortedArray lastObject];
        if(last.sortNumber!=[sortedArray count]-1){
            //re-number
            for (NSUInteger i=0; i<[sortedArray count]; i++) {
                ((ProductCategory *)sortedArray[i]).sortNumber=i;
            }
            //[_inventoryModel saveInventory];
            sortedArray=[[_inventoryModel.categories sortedArrayUsingDescriptors:descriptors] mutableCopy];
            
        }
        
        
    }
    */
  
    //self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
}

@end
