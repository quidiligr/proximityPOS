//
//  MapSearchViewController.m
//  superkiosk
//
//  Created by Katherine Sheehy on 9/9/16.
//  Copyright © 2016 Appcoda. All rights reserved.
//

#import "MapSearchViewController.h"
#import "Map2SearchCell.h"
#import "Util.h"

#define NOTIFY_SEARCH_RESULT @"SearchResultNotification"
#define StoreNameKey @"StoreName"
#define LatitudeKey @"Latitude"
#define LongitudeKey @"Longitude"
#define StoreAddressKey @"StoreAddress"

@interface MapSearchViewController (){
    AppDelegate *_appDelegate;
    NSMutableArray *_stores;

}


@end

@implementation MapSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    _searchTextField.delegate=self;
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(OnNotifySearchResult:) name:NOTIFY_SEARCH_RESULT object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Incomplete implementation, return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete implementation, return the number of rows
    return [_stores count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    Map2SearchCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MapSearchCell" forIndexPath:indexPath];
    NSDictionary *item=[_stores objectAtIndex:indexPath.row];
    cell.resultTitleLabel.text=[item valueForKey:StoreNameKey];
    cell.resultDetailLabel=[item valueForKey:StoreAddressKey];
    
    /*
    for(NSDictionary *item in _stores){
        
        CLLocationCoordinate2D itemCoordinate=CLLocationCoordinate2DMake([[item valueForKey:LatitudeKey] floatValue], [[item valueForKey:LongitudeKey] floatValue]);
        //StoreAnnotation *sa=[[StoreAnnotation alloc] initWithStoreInfo:s];//[[StoreAnnotation alloc] initWithTitle:store.storeName Location:storeCoordinates];
        //MKPointAnnotation *itemAnnotation=[[MKPointAnnotation alloc] init];
        StorePointAnnotation *itemAnnotation=[[StorePointAnnotation alloc] init];
        itemAnnotation.coordinate=itemCoordinate;
        itemAnnotation.title=[item valueForKey:StoreNameKey];
        itemAnnotation.subtitle=[item valueForKey:StoreAddressKey];
        itemAnnotation.deviceID=[item valueForKey:deviceIDKey];
        
        [_mapView addAnnotation:itemAnnotation];
        if(initialLocation==nil){
            initialLocation=[[CLLocation alloc] initWithLatitude:itemAnnotation.coordinate.latitude longitude:itemAnnotation.coordinate.longitude];
        }
    }
    */
    
    // Configure the cell...
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   
    
    NSDictionary *selectedItem=[_stores objectAtIndex:indexPath.row];
    //[self performSegueWithIdentifier:@"toProductViewController" sender:nil];
    [self.delegate mapSearchDidSelectItem:self item:selectedItem];
    
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    /*
     dispatch_async(dispatch_get_main_queue(), ^{
     
     if(timerBeginSearch==nil){
     timerBeginSearch=[NSTimer timerWithTimeInterval:2.0 target:self selector:@selector(reloadData) userInfo:nil repeats:NO];
     }
     else{
     // if([timerBeginSearch isValid])
     [timerBeginSearch invalidate];
     timerBeginSearch=nil;
     timerBeginSearch=[NSTimer timerWithTimeInterval:2.0 target:self selector:@selector(reloadData) userInfo:nil repeats:NO];
     }
     });
     */
    
    _searchText=[textField.text stringByReplacingCharactersInRange:range withString:string];
    
    //NSLog(@"string=%@",string);
    //NSLog(@"textField.text=%@",textField.text);
    //NSLog(@"_searchText=%@",_searchText);
    
    //if(![string isEqualToString:@" "])
    if(_searchText.length>=3)
    [self reloadFromWeb];
    //[self.add]
    
    return YES;
}

-(void)reloadFromWeb//:(CLLocationCoordinate2D)withMyCoordinate
{
    [Util postSearchStores:_searchText];
}

-(void)OnNotifySearchResult:(NSNotification *)notification{
    _stores=[notification.userInfo valueForKey:@"results"];
    
    [self reloadData];
    
}

-(void)reloadData//:(CLLocationCoordinate2D)withMyCoordinate
{
    [self.tableView reloadData];
    
}

@end
