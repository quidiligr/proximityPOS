//
//  UserDetailViewController.m
//  superkiosks
//
//  Created by Katherine Sheehy on 8/14/16.
//  Copyright © 2016 Sharecle. All rights reserved.
//

#import "UserDetailViewController.h"
#import "AppDelegate.h"
#import "UserGroup.h"
#import "OrderHistory.h"
#import "defs.h"

#define MSG_BLOCK_DEVICE @"Block device"
#define MSG_UNBLOCK_DEVICE @"Unblock device"

@interface UserDetailViewController (){
    AppDelegate* _appDelegate;
    NSArray *_myOrders;
}









@end

@implementation UserDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    _appDelegate=ApplicationDelegate;
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    if([_selectedUser isEqual:_appDelegate.admin]){
        [_blockUnblockButton setHidden:YES];
        [_sendMessageButton setHidden:YES];
    }
    
    if([_appDelegate.appConfig.blockedDevices containsObject:_selectedUser.deviceID]){
        //[_appDelegate.appConfig.blockedDevices removeObject:_selectedUser.deviceID];
        [_blockUnblockButton setTitle:MSG_UNBLOCK_DEVICE forState:UIControlStateNormal];
    }
    else{
        //[_appDelegate.appConfig.blockedDevices addObject:_selectedUser.deviceID];
        [_blockUnblockButton setTitle:MSG_BLOCK_DEVICE forState:UIControlStateNormal];
    }
    
    [self reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Incomplete implementation, return the number of sections
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete implementation, return the number of rows
    if(section==0)
        return 1;
    else if(section==1)
        return [_appDelegate.groups count];
    else if(section==2){
        return [_myOrders count];
    }
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch(indexPath.section){
        case 0:
        {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UserDetailCell" forIndexPath:indexPath];
            cell.textLabel.text=[NSString stringWithFormat:@"%@(%@)",_selectedUser.name, _selectedUser.userName];
            //cell.detailTextLabel.text=_selectedUser.
            return cell;
        }
            break;
        case 1:
        {
            
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UserGroupCell" forIndexPath:indexPath];
            
            UserGroup *g =[_appDelegate.groups objectAtIndex:indexPath.row];
            cell.textLabel.text=[NSString stringWithFormat:@"%@",g.name];
            if(_selectedUser.groupID==g.groupID)
                cell.accessoryType=UITableViewCellAccessoryCheckmark;
            else
                cell.accessoryType=UITableViewCellAccessoryNone;
            return cell;
        }
            break;
        case 2:
        {
            
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderDetailCell" forIndexPath:indexPath];
            OrderHistory *oh=[_myOrders objectAtIndex:indexPath.row];
            cell.textLabel.text=[NSString stringWithFormat:@"Order: %@",oh.orderID];
            cell.detailTextLabel.text=[NSString stringWithFormat:@"%@",oh.orderDateTime];
            return cell;
        }
            break;
    }
    
    
    // Configure the cell...
    
    return nil;
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
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section==1){
        UserGroup *g=[_appDelegate.groups objectAtIndex:indexPath.row];
        
        if(g.groupID==GROUPID_GUESTS){
            [AppDelegate toast:@"Not allowed" duration:2.0];
            return;
        }
        
        if(_selectedUser.userID==GROUPID_GUESTS){
            [AppDelegate toast:@"Not allowed" duration:2.0];
            return;
        }
        
        if(_selectedUser.userID==_appDelegate.admin.userID){
            [AppDelegate toast:@"Not allowed" duration:2.0];
            return;
        }
        _selectedUser.groupID=g.groupID;
        [AppConfigModel saveSettings];
        [self reloadData];
    
    }
    //else if(indexPath.section==2){
        
    //}
}

-(void)blockButtonItemTapped{
    
    //UserGroup *group=[_appDelegate.groups objectAtIndex:selectedIndexPath.section];
    //User *user=[group.users objectAtIndex:selectedIndexPath.row];
    
    if([_appDelegate.appConfig.blockedDevices containsObject:_selectedUser.deviceID]){
        [_appDelegate.appConfig.blockedDevices removeObject:_selectedUser.deviceID];
        [AppDelegate toast:@"Device UNBLOCKED done!" duration:2.0];
    }
    else{
        [_appDelegate.appConfig.blockedDevices addObject:_selectedUser.deviceID];
         [AppDelegate toast:@"Device BLOCKED done!" duration:2.0];
    }
    
    [AppConfigModel saveSettings];
    
    //[self reloadData];
    
}


-(void)sendButtonItemTapped{
    
    //UserGroup *group=[_appDelegate.groups objectAtIndex:selectedIndexPath.section];
   // User *user=[group.users objectAtIndex:selectedIndexPath.row];
    
    
    //[[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_SHOW_SENDMESSAGE object:nil userInfo:@{DeviceIdKey:_selectedUser.deviceID}];//peer];
    //[self.tabBarController setSelectedIndex:TAB_INDEX_CHAT];
    //[self.navigationController popToRootViewControllerAnimated:YES];
    /*
    [self dismissViewControllerAnimated:YES completion:^{
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_SHOW_SENDMESSAGE object:nil userInfo:@{DeviceIdKey:_selectedUser.deviceID}];
    }];
    */
    [self.delegate userDetailViewControllerSendTapped:self withUser:_selectedUser];
}
- (IBAction)sendMessageButtonTapped:(id)sender {
    [self sendButtonItemTapped];
}

- (IBAction)blockUnblockButtontapped:(id)sender {
    [self blockButtonItemTapped];
}


-(void)reloadData{
    
    if(_selectedUser.userID==0){
        
        _myOrders= [_appDelegate.historyModel searchWithDeviceID:_selectedUser.deviceID isLive:_appDelegate.appConfig.isLive];
    }
    else{
        _myOrders=[_appDelegate.historyModel searchWithUserID:_selectedUser.userID isLive:_appDelegate.appConfig.isLive];
    }
    
}



@end
