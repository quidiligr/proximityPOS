//
//  MenuController.m
//  superkiosks
//
//  Created by Katherine Sheehy on 10/9/15.
//  Copyright (c) 2015 Appcoda. All rights reserved.
//

#import "MenuCollectionController.h"
#import "MenuCollectionViewCell.h"
#import "ProductCategory.h"
#import "defs.h"

@interface MenuCollectionController (){
     NSString *imagesPath;
}

@end

@implementation MenuCollectionController
{
   // NSMutableArray *categorySectionTitles;
    
    InventoryModel *_inventoryModel;
    InventoryItem *_selectedInventory;
    //Product *selectedProduct;
    NSArray *_sortedCategories;
    NSSortDescriptor *valueDescriptors;
    NSArray *descriptors;
}

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
     imagesPath=[AppDelegate getImagesPath];
    _selectedInventory=[InventoryModel activeInventory];
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self reloadMenu];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
//#warning Incomplete method implementation -- Return the number of sections
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
//#warning Incomplete method implementation -- Return the number of items in the section
    return [_sortedCategories count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MenuCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    //MenuCollectionViewCell *cell = [collectionView
     //                               dequeueReusableCellWithReuseIdentifier:@"menu_cell2"
      //                              forIndexPath:indexPath];
    
    //UIImage *image;
    long row = [indexPath row];
    ProductCategory *pc=_sortedCategories[row];
    if (pc.pictureFile) {
        NSString *fileName=[imagesPath stringByAppendingPathComponent:pc.pictureFile];
        if([[NSFileManager defaultManager] fileExistsAtPath:fileName]){
            cell.imageView.image=[UIImage imageWithContentsOfFile:fileName];
        }
    }
    cell.nameLabel.text=pc.name;
    
    return cell;
}

#pragma mark <UICollectionViewDelegate>

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
}

-(void)reloadMenu{
    
    
    /*if(_inventoryModel==nil){
     _appDelegate.inventory=nil;
     return;
     }
     */
    
    
    //_appDelegate.inventory=[_selectedInventory toMenuDictionary];
    
    
    
    //[categorySectionTitles removeAllObjects];
    _sortedCategories=[_selectedInventory.categories sortedArrayUsingDescriptors:descriptors];
    [self.collectionView reloadData];
    /*
    if(_sortedCategories==nil)
        _sortedCategories = [NSMutableArray new];
    
    //
    [_sortedCategories removeAllObjects];
    
    NSArray *allSortedCategories=[_selectedInventory.categories sortedArrayUsingDescriptors:descriptors];
    for (ProductCategory *pc in allSortedCategories) {
        pc.sortedProducts=[_selectedInventory allProductsWithCategoryID:pc.categoryID sorted:YES];
        if(pc.sortedProducts!=nil && [pc.sortedProducts count]>0){
            [_sortedCategories addObject:pc];
        }
    }
    
    categorySectionTitles=[_sortedCategories valueForKey:NAME_KEY];//[_appDelegate.inventory allKeys] ;
    
    
    if(categorySectionTitles==nil)
        categorySectionTitles=[NSMutableArray new];

    
    if(categorySectionTitles.count==0){
        [_menuTableView setHidden:YES];
        
    }
    else{
        [_menuTableView reloadData];
        [_menuTableView setHidden:NO];
    }
     */
}
@end
