//
//  AppSettingsTableViewController.m
//  superkiosk
//
//  Created by Katherine Sheehy on 3/13/16.
//  Copyright © 2016 Sharecle. All rights reserved.
//

#import "AppSettingsViewController.h"

//#import "AppConfigModel.h"
#import "AppDelegate.h"
#import "CCardsViewController.h"
#import "MyInfoSettingsViewController.h"
#import "defs.h"
@interface AppSettingsViewController (){
    AppDelegate *_appDelegate;
    UIBarButtonItem *_doneButton;
}
@property (strong, nonatomic) IBOutlet UITableViewCell *messagingSingleMessageCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *playSoundCell;
@property (strong, nonatomic) IBOutlet UILabel *totalSize;

@end

@implementation AppSettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    _doneButton=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneButtonTapped:)];
    self.navigationItem.leftBarButtonItem = _doneButton;
    
    if(_appDelegate.appConfig.userInfo.messageLimitPerUser==0){
        
      
        _messagingSingleMessageCell.accessoryType=UITableViewCellAccessoryNone;
    }
    else{
      
        _messagingSingleMessageCell.accessoryType=UITableViewCellAccessoryCheckmark;
    }
    
    if(_appDelegate.appConfig.userInfo.isPlaySound){
        
        
        _playSoundCell.accessoryType=UITableViewCellAccessoryNone;
    }
    else{
        
        _playSoundCell.accessoryType=UITableViewCellAccessoryCheckmark;
    }
    
    _totalSize.text=[AppDelegate sizeOfTmpFolder];

}
/*
-(void)viewDidDisappear:(BOOL)animated{
     // [AppConfigModel saveSettings];
}
*/
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
/*
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return 0;
}
*/
/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell =[tableView cellForRowAtIndexPath:indexPath]; //[tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

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

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //[self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section==0) {
        //[self performSegueWithIdentifier:@"toMyInfoSettingsViewController" sender:self];
        /*if(_appDelegate.isIpad){
         [self performSegueWithIdentifier: sender:self];
         }
         else{
         */
        MyInfoSettingsViewController* destViewController = (MyInfoSettingsViewController*) [ApplicationDelegate.storyBoard instantiateViewControllerWithIdentifier:@"MyInfoSettingsViewController"];
        //browser.delegate = self;
        
        UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:destViewController];
        
        [self presentViewController:nav animated:YES completion:nil];
        //}
        
    }
    
    else if (indexPath.section==1){ //credit cards
        //[self bgphotoTapped];
        //[self performSegueWithIdentifier:@"toCCardsViewController" sender:self];
        CCardsViewController* destViewController = (CCardsViewController*) [ApplicationDelegate.storyBoard instantiateViewControllerWithIdentifier:@"CCardsViewController"];
        //browser.delegate = self;
        
        UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:destViewController];
        
        [self presentViewController:nav animated:YES completion:nil];
    }
    else if (indexPath.section==2){
        //UITableViewCell *cell=[self.tableView cellForRowAtIndexPath:indexPath];
        if(_messagingSingleMessageCell.accessoryType==UITableViewCellAccessoryCheckmark){
            _appDelegate.appConfig.userInfo.messageLimitPerUser=0;
            _messagingSingleMessageCell.accessoryType=UITableViewCellAccessoryNone;
        }
        else{
            _appDelegate.appConfig.userInfo.messageLimitPerUser=1;
            _messagingSingleMessageCell.accessoryType=UITableViewCellAccessoryCheckmark;
        }
    }
    else if (indexPath.section==3){
       // UITableViewCell *cell=[self.tableView cellForRowAtIndexPath:indexPath];
        if(_playSoundCell.accessoryType==UITableViewCellAccessoryCheckmark){
            _appDelegate.appConfig.userInfo.isPlaySound=NO;
            _playSoundCell.accessoryType=UITableViewCellAccessoryNone;
        }
        else{
            _appDelegate.appConfig.userInfo.isPlaySound=YES;
            _playSoundCell.accessoryType=UITableViewCellAccessoryCheckmark;
        }
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)doneButtonTapped:(id)sender {
    
    [AppConfigModel saveSettings];

    
    //[self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
    
}


- (IBAction)clearCacheButtonTapped:(id)sender {
    [AppDelegate clearTmp];
    _totalSize.text=@"Total szie: ";
}

@end
