//
//  InventoryViewController.m
//  MCDemo
//
//  Created by Romulo Quidilig on 4/3/15.
//  Copyright (c) 2015 Sharecle Inc. All rights reserved.
//

#import "CategoryProductsViewController.h"
#import "Product.h"
#import "ProductCategory.h"
#import "NSData+Conversion.h"
#import "InventoryCell.h"
#import "AddProductViewController.h"
#import "EditCategoryViewController.h"
#import "AppDelegate.h"
#import "PrintManager.h"
#import "Util.h"
//#import "ZXingObjC.h"
#import "defs.h"
//#import "CategoryViewController.h"
//#import "ProductManagerViewController.h"

@interface CategoryProductsViewController (){
    NSString *documentPath;
    NSString *imagesPath;
    NSArray *categoryProducts;
    NSArray *sortedArray;
    //UIImage *newPictureImage;
   // BOOL imageChanged;
   // BOOL isUpdate;
    //NSFileManager *fileManager;
    Product *_selectedProduct;
    //NSIndexPath *selectedIndexPath;
    //InventoryModel* _inventoryModel;
    //NSDictionary *inventory;
    //NSArray *categorySectionTitles;
    UIBarButtonItem *addProductButton;
    UIBarButtonItem *deleteProductButton;
    
    //UIBarButtonItem *editCategoryButton;
    //UIBarButtonItem *addCategoryButton;
    //UIBarButtonItem *addCategoryButton;
    BOOL isUpdateProduct;
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
@property (strong, nonatomic) IBOutlet UILabel *NoItemLabel;

@end

@implementation CategoryProductsViewController
/*- (id) initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        _inventoryModel = [[InventoryModel alloc] init];
        [_inventoryModel loadInventory];
        inventory=[_inventoryModel toInventoryDictionary];
        categorySectionTitles=[inventory allKeys];
    }
    return self;
}
 */
- (void)viewDidLoad {
    [super viewDidLoad];
     _appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    // Do any additional setup after loading the view.
    
    //load categories
    //[_inventoryModel.products fil]
    
    //create path
     //fileManager=[NSFileManager defaultManager];
    //_inventoryModel = [[InventoryModel alloc] init];
    //_inventoryModel=[InventoryModel sharedInstance];
   
//    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
//        /*
//        UISplitViewController *svc= (UISplitViewController *)[self.navigationController parentViewController];
//        
//        UINavigationController *nav=(UINavigationController *)[svc.viewControllers objectAtIndex:1];
//        
//        EditProductViewController *detail=(EditProductViewController *)nav.topViewController;
//        
//        self.delegateProduct=detail;
//        svc.delegate=detail;
//         */
//        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_SHOW_START_PRODUCT object:nil];
//    }

    
    /*if(![_inventoryModel.name isEqualToString:self.inventoryName]){
        [_inventoryModel.products removeAllObjects];
        [_inventoryModel.categories removeAllObjects];
        _inventoryModel.name=self.inventoryName;
        [_inventoryModel loadInventory];
    }
    */
    
    
    
   
    
    documentPath= [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    
    imagesPath=[AppDelegate getImagesPath]; //[self getImagesPath];
    
    addProductButton=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addProduct)];
    
 
    
    deleteProductButton=self.editButtonItem;
   
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadCategoryProducts) name:NOTIFY_UPDATE_PRODUCT object:nil];
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateInventory:) name:NOTIFY_UPDATE_INVENTORY object:nil];
    
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(productAdded:) name:NOTIFY_PRODUCT_ADDED object:nil];
}
/*
-(void)updateInventory:(NSNotification *)notification{
    dispatch_async(dispatch_get_main_queue(),^{
        
    [self reloadCategoryProducts];
    
        Product *prod_update= [notification.userInfo valueForKey:KEY_SELECTED_PRODUCT];
        if(prod_update){
            if(![prod_update isEqual:_selectedProduct]){
                _selectedProduct=prod_update;
                
            }
            NSUInteger row=[sortedArray indexOfObject:_selectedProduct];
            selectedIndexPath=[NSIndexPath indexPathForRow:row inSection:0];
            [self.tableView selectRowAtIndexPath:selectedIndexPath animated:YES scrollPosition:UITableViewScrollPositionBottom];
        }
        
            //self.selectedProduct=[self.selectedInventory.products lastObject];//[sortedArray lastObject];
           // if(_selectedProduct!=nil){
        
        
        //}
    });

}
 */

-(void)hideToolbar{
    
    /*
    if([sortedArray count]>0){
        _messageLabel.text=@"Select an item to edit";
    }
    else{
        _messageLabel.text=@"Tap + to create your first item.";
    }
    [self.messageLabel setHidden:NO];
    self.toolBarr.alpha=0;
    [self.toolBarr setHidden:YES];
     */
}

-(void)viewDidAppear:(BOOL)animated{
    if(_selectedCategory){
        self.title=self.selectedCategory.name;
    }
    [self hideToolbar];
    
    [self reloadCategoryProducts];
    
    if(_triggerAddItem){
        _triggerAddItem=NO;
        [self addProduct];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)reloadCategoryProducts{
    
     sortedArray=[_appDelegate.inventoryModel.inventory allProductsWithCategoryID:_selectedCategory.categoryID sorted:YES];//[_selectedCategory.products filteredArrayUsingPredicate:predicate] ;
    //sortedArray=[categoryProducts sortedArrayUsingDescriptors:descriptors];
     [self.tableView reloadData];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSUInteger count= [sortedArray count];
    /*
    if (count>0) {
        
        if(_selectedProduct==nil){
           self.messageLabel.text=MSG_SELECTPRODUCT;
           [self.messageLabel setHidden:NO];
           [self.toolBarr setHidden:YES];
           
        }
        else{
            [self.messageLabel setHidden:YES];
            [self.toolBarr setHidden:NO];
            [_editProductButton setEnabled:YES];
        //}
        
            if(count==1){
               
                [_upButton setEnabled:NO];
                [_downButton setEnabled:NO];
                //[_editProductButton setEnabled:YES];
                
            }
            else{ //count>1
                //first row
                if([_selectedProduct isEqual:[sortedArray firstObject]]){ //first row
                    [self.upButton setEnabled:NO];
                    [self.downButton setEnabled:YES ];
                }
                //last row
                else if([_selectedProduct isEqual:[sortedArray lastObject]]){//first row
                    [_upButton setEnabled:YES];
                    [_downButton setEnabled:NO];
                   
                }
                //middle
                else{
                    [self.upButton setEnabled:YES];
                    [self.downButton setEnabled:YES ];
                }
            }
        }
        
        self.navigationItem.rightBarButtonItems=@[addProductButton,self.editButtonItem];
        
    }
    else{
        
        self.navigationItem.rightBarButtonItems=@[addProductButton];
        
        self.messageLabel.text=[NSString stringWithFormat:MSG_NOPRODUCT,_selectedCategory.name] ;
        
        [self.messageLabel setHidden:NO];
        
        [_toolBarr setHidden:YES];
        if([self isEditing])
            [self setEditing:NO];
       
        
    }
    */
    if (count==0) {
        count=1;
    }
    return count;
}
/*
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
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
    cell.textLabel.text=[NSString stringWithFormat:@"You haven't created any item for %@. Tap + to create your first item.",_selectedCategory.name] ;
    return cell;
}

- (UITableViewCell *)itemCell:(NSIndexPath *)indexPath{
    
    
    InventoryCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"inventory_cell" forIndexPath:indexPath];
    if(cell==nil){
        cell=[[InventoryCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"inventory_cell"];
    }
    
    Product *product=[sortedArray objectAtIndex:indexPath.row];
    
    if(_selectedProduct!=nil && [product isEqual:_selectedProduct])
        [cell setHighlighted:YES];
    else
        [cell setHighlighted:NO];
    
    cell.titleLabel.text=product.name;
    
    if(_appDelegate.inventoryModel.inventory.isEcommerce){
        if(product.discount==0)
            cell.subTitleLabel.text=[NSString stringWithFormat:@"Price: %@",[Util priceToString:(double)product.price/100 currency:_appDelegate.inventoryModel.inventory.currencySymbol]];
        else{
            //cell.subTitleLabel.text=[NSString stringWithFormat:@"Price:%@  Discount:%@%% Actual:%.02f",[product actualPriceToString],[product discountToString],(double)product.price/100];
            if(product.discountType==DISCOUNT_PCT){
                cell.subTitleLabel.text=[NSString stringWithFormat:@"Price:%@  Discount:%@%% Actual:%@",[Util priceToString:(double)product.price/100 currency:_appDelegate.inventoryModel.inventory.currencySymbol],[Util discountToString:product.discount],[Util priceToString:(double)product.actualPrice/100 currency:_appDelegate.inventoryModel.inventory.currencySymbol]];
            }
            else{
                cell.subTitleLabel.text=[NSString stringWithFormat:@"Price:%@  Discount:%@ Actual:%@",[Util priceToString:(double)product.price/100 currency:_appDelegate.inventoryModel.inventory.currencySymbol],[Util discountToString:product.discount],[Util priceToString:(double)product.actualPrice/100 currency:_appDelegate.inventoryModel.inventory.currencySymbol]];
            }
        }
    }
    else{
        cell.subTitleLabel.text=product.detail;
    }
        [cell.upButton addTarget:self action:@selector(moveUpTapped:) forControlEvents:UIControlEventTouchUpInside];

        [cell.downButton addTarget:self action:@selector(moveDownTapped:) forControlEvents:UIControlEventTouchUpInside];

        [cell.productImageView setImage:[UIImage imageNamed:@"empty_picture"]];
        // NSString *newPictureFile=[imageData MD5];
        if(product.pictureFile.length>0){
            NSString *filePath=[imagesPath stringByAppendingPathComponent:product.pictureFile];
            
            if([[NSFileManager defaultManager] fileExistsAtPath:filePath])
                cell.productImageView.image=[[UIImage alloc] initWithContentsOfFile:filePath];
            //else
            //    [cell.imageView setImage:[UIImage imageNamed:@"empty_picture"]];
        }
    
    
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

-(IBAction)moveUpTapped:(id)sender{
   // CGPoint buttonPosition=[sender convertPoint:CGPointZero toView:self.tableView];
    
  // NSIndexPath *indexPath= [self.tableView indexPathForRowAtPoint:buttonPosition];
      NSIndexPath *indexPath= [self.tableView indexPathForSelectedRow];
    if (indexPath.row==0)
        return;
    
    NSIndexPath *selectedIndexPath=[NSIndexPath indexPathForRow:indexPath.row-1 inSection:0];
    
    Product *p1=[sortedArray objectAtIndex:indexPath.row];
    Product *p2=[sortedArray objectAtIndex:indexPath.row-1];
    p1.sortNumber=indexPath.row-1;
    p2.sortNumber=indexPath.row;
    [_appDelegate.inventoryModel saveInventory];
    [self reloadCategoryProducts];
    
    [self.tableView selectRowAtIndexPath:selectedIndexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
}

-(IBAction)moveDownTapped:(id)sender{
    
    NSIndexPath *indexPath= [self.tableView indexPathForSelectedRow];
     
    
    if (indexPath.row>=[sortedArray count]-1)
        return;
    
    NSIndexPath *selectedIndexPath=[NSIndexPath indexPathForRow:indexPath.row+1 inSection:0];
    
    Product *p1=[sortedArray objectAtIndex:indexPath.row];
    Product *p2=[sortedArray objectAtIndex:indexPath.row+1];
    p1.sortNumber=indexPath.row+1;
    p2.sortNumber=indexPath.row;
    [_appDelegate.inventoryModel saveInventory];
[self reloadCategoryProducts];
    
    [self.tableView selectRowAtIndexPath:selectedIndexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
    
}

-(void)editProduct{
    EditProductViewController* editProductController = (EditProductViewController*) [ApplicationDelegate.storyBoard instantiateViewControllerWithIdentifier:@"EditProductViewController"];
    editProductController.selectedProduct=_selectedProduct;
    //editProductController.selectedInventory=_selectedInventory;
    editProductController.selectedCategory=_selectedCategory;
    editProductController.delegate=self;
    UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:editProductController];
    
    
    
    [self presentViewController:nav animated:YES completion:nil];
}
- (IBAction)editProductButtonTapped:(id)sender {
    [self editProduct];
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
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
        [self didSelectRowAtIndexPath:indexPath];
    
}
-(void)didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    _selectedProduct=[sortedArray objectAtIndex:indexPath.row]; //[_inventoryModel.products objectAtIndex:indexPath.row];
    /*
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
        if (indexPath.row==0)//if (_selectedProduct.sortNumber==0)
        {//top
            [self.upButton setEnabled:NO];
            [self.downButton setEnabled:YES ];
            
        }
        else if (indexPath.row==[sortedArray count]-1)//else if (_selectedProduct.sortNumber==[sortedArray count]-1)
        { //bottom
            [self.upButton setEnabled:YES];
            [self.downButton setEnabled:NO ];
            
        }
        else{// middle
            
            [self.upButton setEnabled:YES];
            [self.downButton setEnabled:YES ];
            
        }
     
        
    }
    [_editProductButton setEnabled:YES];
     */
    if([sortedArray count]==0){
        
    }
    {
        [self editProduct];
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
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if(editingStyle==UITableViewCellEditingStyleDelete){
        Product *delete_item=[sortedArray objectAtIndex:indexPath.row];
        
        if(_selectedProduct!=nil && _selectedProduct.productID==delete_item.productID){
            _selectedProduct=nil;
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_SHOW_EDIT_PRODUCT object:nil];
        }
        
        [_appDelegate.inventoryModel.inventory.products removeObject:delete_item];
        [_appDelegate.inventoryModel saveInventory];
        //[self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [self reloadCategoryProducts];
        
        
    }
}
/*
-(void)reloadInventoryTable{
    inventory=[_inventoryModel toInventoryDictionary];
    
    categorySectionTitles=[inventory allKeys];
    [self.tableView reloadData];
}
 */
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"toAddProductViewController"]) {
        AddProductViewController *destController=[segue destinationViewController];
        //vc.inventoryModel=_inventoryModel;
        destController.selectedProduct=_selectedProduct;
         destController.selectedCategory=self.selectedCategory;
       // destController.selectedInventory=self.selectedInventory;
        //destController.delegate=self;
    }
    else if ([segue.identifier isEqualToString:@"toEditProductViewController"]) {
        EditProductViewController *vc=[segue destinationViewController];
        //vc.inventoryModel=_inventoryModel;
        //vc.delegate=self;
    vc.selectedCategory=self.selectedCategory;
    vc.selectedProduct=_selectedProduct;
       // vc.selectedInventory=self.selectedInventory;    //vc.isUpdateProduct=isUpdateProduct;
    }
    
}

-(void)addProductViewControllerdidAdd:(AddProductViewController *)viewController{
   /*
    [self reloadCategoryProducts];
    [self.tableView reloadData];
    [viewController.navigationController popViewControllerAnimated:YES];
    */
}

-(void)editProductViewControllerdidUpdate:(EditProductViewController *)viewController{
   /*
    [self reloadCategoryProducts];
    [self.tableView reloadData];
    [viewController.navigationController popViewControllerAnimated:YES];
    */
}
/*
-(void)categoryViewControllerdidUpdate:(CategoryViewController *)viewController{
    [self reloadCategoryProducts];
}


-(void)addCategory{
    [self performSegueWithIdentifier:@"toCategoryView" sender:self];
}
*/
-(void)addProduct{
    
    
    _selectedProduct=[self createNewProduct];
    
    if(_selectedProduct!=nil){
        [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:NO];

            AddProductViewController* addProductController = (AddProductViewController*) [ApplicationDelegate.storyBoard instantiateViewControllerWithIdentifier:@"AddProductViewController"];
        addProductController.delegate=self;
        addProductController.selectedProduct=_selectedProduct;
   //     addProductController.selectedInventory=_selectedInventory;
        addProductController.selectedCategory=_selectedCategory;
        
        
            UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:addProductController];
            
            
            
            [self presentViewController:nav animated:YES completion:nil];

        /*}
        else{
            [self performSegueWithIdentifier:@"toAddProductViewController" sender:self];
        }
         */
    }
    else{
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Error" message:@"Attempt to add new product failed." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }
}





-(Product *)createNewProduct{
    Product *newProduct=[Product new];
    
    
    newProduct.categoryID=self.selectedCategory.categoryID;
    
    
    newProduct.name=@"";
    
    newProduct.detail=@"";
    newProduct.pictureFile=@"";
    newProduct.allowOutOfStock=NO;
    newProduct.price=0;
    newProduct.actualPrice=0;
    newProduct.sortNumber=0;
    newProduct.discount=0;//self.selectedInventory.discount;
   
    Product *lastProduct=[_appDelegate.inventoryModel.inventory.products lastObject];
    
    if(lastProduct!=nil)
        newProduct.productID=lastProduct.productID+1;
    else
        newProduct.productID=1;
    
    if([sortedArray count]==0)
        newProduct.sortNumber=0;
    else {
        Product *lastProductInCategory=[sortedArray lastObject];
        if (lastProductInCategory.sortNumber!=[sortedArray count]-1) {
            //re-number
            for (NSUInteger i=0; i<[sortedArray count]; i++) {
                ((Product *)sortedArray[i]).sortNumber=i;
            }
            [_appDelegate.inventoryModel saveInventory];
            
            
        }
        
        newProduct.sortNumber=[sortedArray count];
    }
    
    return newProduct;
    
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"Yes"]) {
        /*ProductCategory *c=[_selectedInventory.categories objectAtIndex:selectedIndexPath.row];
         NSPredicate *predicate=[NSPredicate predicateWithFormat:@"categoryID=%d",c.categoryID];
         
         NSArray *arr_products=[c.products filteredArrayUsingPredicate:predicate];
         for(Product *p in arr_products){
         [c.products removeObject:p];
         }
         
         [_selectedInventory.categories removeObjectAtIndex:selectedIndexPath.row];
         [_inventoryModel saveInventory];
         
         //[_tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:selectedIndex] withRowAnimation:UITableViewRowAnimationFade];
         [self reloadCategories];
         */
        //if (alertView.tag==1)
            [self performSegueWithIdentifier:@"toAddProductViewController" sender:self];
        //else if(alertView.tag==2)
         //   [self performSegueWithIdentifier:@"toCategoryProductsViewController" sender:self];
    }
}

//
//- (IBAction)printBarcodeAction:(id)sender {
//    NSError *error = nil;
//    ZXMultiFormatWriter *writer = [ZXMultiFormatWriter writer];
//    /*ZXBitMatrix* result = [writer encode:[NSString stringWithFormat:@"%@",@(_selectedProduct.productID)]//@"A string to encode"
//                                  format:kBarcodeFormatQRCode
//                                   width:500
//                                  height:500
//                                   error:&error];
//     */
//    ZXBitMatrix* result = [writer encode:[NSString stringWithFormat:@"%@",@(_selectedProduct.productID)]//@"A string to encode"
//                                  format:kBarcodeFormatEan13
//                                   width:72 //1"
//                                  height:27 //.375
//                                   error:&error];
//    
//    if (result) {
//        CGImageRef imageRef = [[ZXImage imageWithMatrix:result] cgimage];
//        UIImage *image=[UIImage imageWithCGImage:imageRef];
//        PrintManager *pm= [PrintManager sharedInstance];
//        [pm printBarcode:image fromView:self.view];
//        // This CGImageRef image can be placed in a UIImage, NSImage, or written to a file.
//    } else {
//        NSString *errorMessage = [error localizedDescription];
//        [AppDelegate toast:errorMessage duration:1.0];
//    }
//}
-(void)addProductViewControllerDidAdd:(AddProductViewController *)viewController withProduct:(Product *)product{
    
    _selectedProduct=product;

    
    [viewController dismissViewControllerAnimated:YES completion:^{
        
                [self reloadCategoryProducts];
        
        NSIndexPath *newIndexPath=[NSIndexPath indexPathForRow:[sortedArray count]-1 inSection:0];
        
        [self.tableView selectRowAtIndexPath:newIndexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
        
         [self didSelectRowAtIndexPath:newIndexPath];
    }];
}
-(void)editProductViewControllerDidUpdate:(EditProductViewController *)viewController{
    /*[viewController dismissViewControllerAnimated:YES completion:^{
        [self reloadCategoryProducts];
        
        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:[sortedArray indexOfObject:_selectedProduct] inSection:0];
        
        [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
        
        [self didSelectRowAtIndexPath:indexPath];
        
    }];
    */
}
@end
