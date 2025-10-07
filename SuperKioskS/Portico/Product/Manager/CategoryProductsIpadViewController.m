//
//  InventoryViewController.m
//  MCDemo
//
//  Created by Romulo Quidilig on 4/3/15.
//  Copyright (c) 2015 Sharecle Inc. All rights reserved.
//

#import "CategoryProductsIpadViewController.h"
#import "Product.h"
#import "ProductCategory.h"
#import "NSData+Conversion.h"
#import "InventoryCell.h"
//#import "AddProductViewController.h"
//#import "EditCategoryViewController.h"
#import "EditProductIpadViewController.h"
#import "AddProductIpadViewController.h"
#import "defs.h"
//#import "CategoryViewController.h"
//#import "ProductManagerViewController.h"

@interface CategoryProductsIpadViewController (){
    NSString *documentPath;
    NSString *imagesPath;
    NSArray *categoryProducts;
    NSArray *sortedArray;
    //UIImage *newPictureImage;
   // BOOL imageChanged;
   // BOOL isUpdate;
    //NSFileManager *fileManager;
    Product *_selectedProduct;
    NSIndexPath *selectedIndexPath;
    InventoryModel* _inventoryModel;
    //NSDictionary *inventory;
    //NSArray *categorySectionTitles;
    UIBarButtonItem *addProductButton;
    UIBarButtonItem *deleteProductButton;
    UIBarButtonItem *backButton;
    //UIBarButtonItem *editCategoryButton;
    //UIBarButtonItem *addCategoryButton;
    //UIBarButtonItem *addCategoryButton;
    BOOL isUpdateProduct;
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

@implementation CategoryProductsIpadViewController
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
    
    /*
    UISplitViewController *svc= (UISplitViewController *)self.view.window.rootViewController;//(UISplitViewController *)[self.navigationController parentViewController];
    
    
    EditProductIpadViewController *rightViewController= (EditProductIpadViewController *)[svc.viewControllers objectAtIndex:1];
    self.delegateProduct=rightViewController;
    svc.delegate=rightViewController;
*/
    
    _inventoryModel=[InventoryModel sharedInstance];
   
    
    self.title=self.selectedCategory.name;
    self.messageLabel.text=@"Select a product to edit or tap + button to add new product.";
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
    
    backButton=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(actionGoBack:)];
    
    self.navigationItem.leftBarButtonItem=backButton;
    
    deleteProductButton=self.editButtonItem;
   
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadCategoryProducts) name:NOTIFY_UPDATE_PRODUCT object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(productAdded:) name:NOTIFY_PRODUCT_ADDED object:nil];
}
-(void)productAdded:(NSNotification *)notification{
    [self reloadCategoryProducts];
    
    self.selectedProduct=[self.selectedInventory.products lastObject];//[sortedArray lastObject];
    if(_selectedProduct!=nil){
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
    [self reloadCategoryProducts];
    
    if([categoryProducts count]>0)
        self.navigationItem.rightBarButtonItems=@[addProductButton,deleteProductButton];
    else
        self.navigationItem.rightBarButtonItems=@[addProductButton];

    [self.tableView reloadData];
    if([sortedArray count]==0){
         //[self.toolBar setHidden:YES];
        _toolBar.alpha=0;
        [self.tableView setHidden:YES];
        /*UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Categories" message:[NSString stringWithFormat:@"Add items to %@?",self.selectedCategory.name] delegate:self cancelButtonTitle:@"Later" otherButtonTitles:@"Yes", nil];
      
        [alert show];
         */
    }
    else{
        if(_selectedProduct!=nil && selectedIndexPath!=nil){
            //[_toolBar setHidden:NO];
            _toolBar.alpha=1;
            if(selectedIndexPath!=nil)
                [self.tableView selectRowAtIndexPath:selectedIndexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
        }
        else
            //[_toolBar setHidden:YES];
            _toolBar.alpha=0;
        
    }
    
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
/*
- (NSString*)getImagesPath
{
    //NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    //NSString* documentsDirectory = paths[0];
    NSError *error;
    BOOL isDirectory=YES;
    NSString *directory=[documentPath stringByAppendingPathComponent:@"images"];
    if([[NSFileManager defaultManager] fileExistsAtPath:directory]==NO){
        [[NSFileManager defaultManager] createDirectoryAtPath:directory withIntermediateDirectories:NO attributes:nil error:&error];
    }
    if(![[NSFileManager defaultManager] fileExistsAtPath:directory isDirectory:&isDirectory])
        [[NSFileManager defaultManager] createDirectoryAtPath:directory withIntermediateDirectories:YES attributes:nil error:&error];
    if (error!=nil) {
        return nil;
    }
    return directory;
}
 */

/*
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [categorySectionTitles count];
}
*/
-(void)reloadCategoryProducts{
    //NSPredicate *predicate=[NSPredicate predicateWithFormat:@"categoryID=%d",_selectedCategory.categoryID];
    
    //NSSortDescriptor *valueDescriptors=[[NSSortDescriptor alloc] initWithKey:@"sortNumber" ascending:YES];
    //NSArray *descriptors=[NSArray arrayWithObject:valueDescriptors];
    
    sortedArray=[self.selectedInventory allProductsWithCategoryID:_selectedCategory.categoryID sorted:YES];//[_selectedCategory.products filteredArrayUsingPredicate:predicate] ;
    //sortedArray=[categoryProducts sortedArrayUsingDescriptors:descriptors];
     //[self.tableView reloadData];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSUInteger count= [sortedArray count];
    if (count>0) {
        
        self.navigationItem.rightBarButtonItems=@[addProductButton,self.editButtonItem];
        self.toolBar.alpha = 1;
        [self.tableView setHidden:NO];
        
    }
    else{
        self.navigationItem.rightBarButtonItems=@[addProductButton];
        self.toolBar.alpha = 0;
        [self.tableView setHidden:YES];
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
    InventoryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"inventory_cell" forIndexPath:indexPath];
    if(cell==nil){
        cell=[[InventoryCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"inventory_cell"];
    }
    
    Product *product=[sortedArray objectAtIndex:indexPath.row];
    cell.titleLabel.text=product.name;
    
    if(_selectedInventory.isEcommerce){
        if(product.discount==0)
            cell.subTitleLabel.text=[NSString stringWithFormat:@"Price: %@",[Product priceToString:(double)product.price/100]];
        else{
            //cell.subTitleLabel.text=[NSString stringWithFormat:@"Price:%@  Discount:%@%% Actual:%.02f",[product actualPriceToString],[product discountToString],(double)product.price/100];
            if(product.discountType==DISCOUNT_PCT){
                cell.subTitleLabel.text=[NSString stringWithFormat:@"Price:%@  Discount:%@%% Actual:%@",[Product priceToString:(double)product.price/100],[Product discountToString:product.discount],[Product priceToString:(double)product.actualPrice/100]];
            }
            else{
                cell.subTitleLabel.text=[NSString stringWithFormat:@"Price:%@  Discount:%@ Actual:%@",[Product priceToString:(double)product.price/100],[Product discountToString:product.discount],[Product priceToString:(double)product.actualPrice/100]];
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
    
    
    return cell;
    
    
}

-(IBAction)moveUpTapped:(id)sender{
   // CGPoint buttonPosition=[sender convertPoint:CGPointZero toView:self.tableView];
    
  // NSIndexPath *indexPath= [self.tableView indexPathForRowAtPoint:buttonPosition];
      NSIndexPath *indexPath= [self.tableView indexPathForSelectedRow];
    if (indexPath.row==0)
        return;
    selectedIndexPath=[NSIndexPath indexPathForRow:indexPath.row-1 inSection:0];
    Product *p1=[sortedArray objectAtIndex:indexPath.row];
    Product *p2=[sortedArray objectAtIndex:indexPath.row-1];
    p1.sortNumber=indexPath.row-1;
    p2.sortNumber=indexPath.row;
    [_inventoryModel saveInventory];
    [self reloadCategoryProducts];
    [self.tableView reloadData];
    [self.tableView selectRowAtIndexPath:selectedIndexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
}

-(IBAction)moveDownTapped:(id)sender{
    //CGPoint buttonPosition=[sender convertPoint:CGPointZero toView:self.tableView];
    
    NSIndexPath *indexPath= [self.tableView indexPathForSelectedRow];
     
    
    if (indexPath.row>=[sortedArray count]-1)
        return;
    selectedIndexPath=[NSIndexPath indexPathForRow:indexPath.row+1 inSection:0];
    Product *p1=[sortedArray objectAtIndex:indexPath.row];
    Product *p2=[sortedArray objectAtIndex:indexPath.row+1];
    p1.sortNumber=indexPath.row+1;
    p2.sortNumber=indexPath.row;
    [_inventoryModel saveInventory];
[self reloadCategoryProducts];
    [self.tableView reloadData];
    [self.tableView selectRowAtIndexPath:selectedIndexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
    
}

- (IBAction)editProductButtonTapped:(id)sender {
    
    
     UISplitViewController *svc= (UISplitViewController *)self.view.window.rootViewController;
     
     
   
    NSMutableArray *viewControllers=[[svc viewControllers] mutableCopy];
   
    
    EditProductIpadViewController *detailViewController=[self.storyboard instantiateViewControllerWithIdentifier:@"EditProductIpadViewController"];
    
    UINavigationController *nav=[[UINavigationController alloc] initWithRootViewController:detailViewController];
    [viewControllers setObject:nav atIndexedSubscript:1];
    svc.viewControllers=viewControllers;
    
    
   
    detailViewController.selectedCategory=self.selectedCategory;
    detailViewController.selectedProduct=_selectedProduct;
    detailViewController.selectedInventory=self.selectedInventory;
    
    self.delegateProduct=detailViewController;
    svc.delegate=detailViewController ;
   
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
    
    _selectedProduct=[sortedArray objectAtIndex:indexPath.row]; //[_inventoryModel.products objectAtIndex:indexPath.row];
    /*
    if(_selectedProduct==nil)
        return;
    
    isUpdateProduct=YES;
    [self performSegueWithIdentifier:@"toEditProductViewController" sender:self];
    */
    
    //selectedCategory=[sortedArray objectAtIndex:indexPath.row];
    NSMutableArray *toolBarButtons=[self.toolbarItems mutableCopy];
    
    //[self.toolBar setHidden:NO];
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
        if (_selectedProduct.sortNumber==0) {//top
            [toolBarButtons removeObject:self.upButton ];
            
            if(![toolBarButtons containsObject:self.downButton])
                [toolBarButtons addObject:self.downButton ];
            
        }
        else if (_selectedProduct.sortNumber==[sortedArray count]-1){ //bottom
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
        //[self performSegueWithIdentifier:@"toEditProductViewController" sender:self];
        [self editProductButtonTapped:self];
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
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if(editingStyle==UITableViewCellEditingStyleDelete){
        Product *delete_item=[sortedArray objectAtIndex:indexPath.row];
        [self.selectedInventory.products removeObject:delete_item];
        [_inventoryModel saveInventory];
        [self reloadCategoryProducts];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
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
    /*
    if ([segue.identifier isEqualToString:@"toAddProductViewController"]) {
        AddProductViewController *destController=[segue destinationViewController];
        //vc.inventoryModel=_inventoryModel;
        destController.selectedProduct=_selectedProduct;
         destController.selectedCategory=self.selectedCategory;
        destController.selectedInventory=self.selectedInventory;
        //destController.delegate=self;
    }
    else if ([segue.identifier isEqualToString:@"toEditProductViewController"]) {
        EditProductViewController *vc=[segue destinationViewController];
        //vc.inventoryModel=_inventoryModel;
        //vc.delegate=self;
    vc.selectedCategory=self.selectedCategory;
    vc.selectedProduct=_selectedProduct;
        vc.selectedInventory=self.selectedInventory;    //vc.isUpdateProduct=isUpdateProduct;
    }
    */
}

-(void)addProductViewControllerdidAdd:(AddProductViewController *)viewController{
   
    [self reloadCategoryProducts];
    [self.tableView reloadData];
    [viewController.navigationController popViewControllerAnimated:YES];
}

-(void)editProductViewControllerdidUpdate:(EditProductViewController *)viewController{
   
    [self reloadCategoryProducts];
    [self.tableView reloadData];
    [viewController.navigationController popViewControllerAnimated:YES];
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
        //[self performSegueWithIdentifier:@"toAddProductViewController" sender:self];
        UISplitViewController *svc= (UISplitViewController *)self.view.window.rootViewController;
        
        
        
       
        
        
        AddProductIpadViewController *detailViewController=[self.storyboard instantiateViewControllerWithIdentifier:@"AddProductIpadViewController"];
        
        UINavigationController *nav=[[UINavigationController alloc] initWithRootViewController:detailViewController];
        
        
        
        
        
        detailViewController.selectedCategory=self.selectedCategory;
        detailViewController.selectedProduct=_selectedProduct;
        detailViewController.selectedInventory=self.selectedInventory;
        self.delegateProduct=detailViewController;
        
        NSMutableArray *viewControllers=[[svc viewControllers] mutableCopy];
        [viewControllers setObject:nav atIndexedSubscript:1];
        svc.viewControllers=viewControllers;
        
        svc.delegate=detailViewController ;

        
    }
    else{
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Error" message:@"Attempt to add new product failed." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }
}





-(Product *)createNewProduct{
    Product *newProduct=[Product new];
    //if(_productCategory.text.length==0)
    /*
     vc.selectedCategory=self.currentCategory;
     vc.selectedProduct=_selectedProduct;
     vc.isUpdateProduct=isUpdateProduct;
     */
    
    newProduct.categoryID=self.selectedCategory.categoryID;
    //newProduct.categoryName=self.self.selectedCategory.name;
    
    newProduct.name=@"Untitled";
    
    newProduct.detail=@"";
    newProduct.pictureFile=@"";
    newProduct.stock_unlimited=YES;
    newProduct.price=0;
    newProduct.actualPrice=0;
    newProduct.sortNumber=0;
    newProduct.discount=0;//self.selectedInventory.discount;
   
    Product *lastProduct=[self.selectedInventory.products lastObject];
    
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
            [_inventoryModel saveInventory];
            
            
        }
        
        newProduct.sortNumber=[sortedArray count];
    }
    
    /*nf=[[NSNumberFormatter alloc] init];
    if([nf numberFromString:_priceTextField.text])
        newProduct.price=[_priceTextField.text floatValue];
    else
     
        newProduct.price=0.0f;
    
    
    
    //if(!_unlimittedToggle.isOn){
   if(![nf numberFromString:_remainingTextField.text]){
        newProduct.stock_unlimitted=YES;
        _remainingTextField.text=@"";
    }
    else{
        int remaining=[_productIDTextField.text intValue];
        if(remaining<0)
            remaining=0;
        else
            newProduct.instock=remaining;
        newProduct.stock_unlimitted=NO;
        
    }
    
    // }
    //else{
    
    //}
    
    newProduct.pictureFile=@"";
    if(newProduct.pictureFile.length>0){
        NSData *imageData=[[NSData alloc] initWithData:UIImagePNGRepresentation(_pictureFile.image)];
        if(imageData){
            //NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            
            NSString *newPictureFile=[NSString stringWithFormat:@"%@.png",[imageData MD5]];
            
            
            if(imagesPath!=nil){
                NSString *filePath=[imagesPath stringByAppendingPathComponent:newPictureFile];
                
                
                //save image
                if(![[NSFileManager defaultManager] fileExistsAtPath:filePath])
                    [imageData writeToFile:filePath atomically:YES];
                
                newProduct.pictureFile=newPictureFile;
            }
        }
        
    }
    */
    // }
    
    /*
    @try {
        [_inventoryModel addInventory:newProduct];
    }
    @catch (NSException *exception) {
        newProduct=nil;
    }
    @finally {
        return newProduct;
    }
    */
    return newProduct;
    
    /*_nameTextField.text=nil;
    _priceTextField.text=nil;
    _descriptionTextField.text=nil;
    [_pictureFile setImage:[UIImage imageNamed:@"empty_picture"]];
    
    //[_btnSave setTitle:@"Add" forState:UIControlStateNormal];
    
    [self.delegate productManagerViewControllerdidAdd:self];
    */
    
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
- (IBAction)actionGoBack:(id)sender {
    //if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        /*UISplitViewController *svc=[self.storyboard instantiateViewControllerWithIdentifier:@"svcCategoryProducts"];
        UINavigationController *nav=[svc.viewControllers objectAtIndex:0];
        
        
        
        CategoryProductsViewController *leftController=(CategoryProductsViewController *)[nav topViewController];
        leftController.selectedInventory=self.selectedInventory;
        leftController.selectedCategory=selectedCategory;
        */
        //self.view.window.rootViewController=svc;
    //}
     [ApplicationDelegate showTabBarController];
}

@end
