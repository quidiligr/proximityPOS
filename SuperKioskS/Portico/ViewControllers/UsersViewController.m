//
//  StaffPeersTableViewController.m
//  Order Here
//
//  Created by Katherine Sheehy on 7/3/15.
//  Copyright (c) 2015 Sharecle. All rights reserved.
//

#import "UsersViewController.h"
#import "AppDelegate.h"
#import "PeerDisplayCell.h"
#import "UsersSectionCell.h"
#import "UserGroup.h"

#import "User.h"
#import "defs.h"
@interface UsersViewController (){
    AppDelegate *_appDelegate;
    //NSDictionary *staffs;
    //NSDictionary *customers;
    //NSMutableArray *peerGroupNames;
    NSMutableArray *groupNames;
    //UIBarButtonItem *sendButtonItem;
    UIBarButtonItem *blockButtonItem;
    NSIndexPath *selectedIndexPath;
    //NSArray *_groups;
    //NSArray *_users;
}

@end

@implementation UsersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor clearColor];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    _appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    //_groups=_appDelegate.groups;
    //_users=_appDelegate.users;
    /*if(_appDelegate.isIpad){
        self.navigationItem.hidesBackButton=YES;
        
    }
    */
    //sendButtonItem =[[UIBarButtonItem alloc] initWithTitle:@"New message" style:UIBarButtonItemStyleBordered target:self action:@selector(sendButtonItemTapped)];
    
    blockButtonItem =[[UIBarButtonItem alloc] initWithTitle:@"Block" style:UIBarButtonItemStyleBordered target:self action:@selector(blockButtonItemTapped)];
    
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didReceiveUpdatePeers:)
                                                 name:NOTIFY_UPDATE_PEERS
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didReceiveAppConfigUpdate:)
                                                 name:NOTIFY_APPCONFIG_UPDATE
                                               object:nil];
    
    
//self.tableView.backgroundColor=[UIColor clearColor];
    
    
    
}
-(void)didReceiveAppConfigUpdate:(NSNotification *)notification{
    
    [self reloadData];
}
-(void)didReceiveUpdatePeers:(NSNotification *)notification{
    [self.tableView reloadData];
}
   
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    //[self.tableView reloadData];
    [self reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return [_appDelegate.groups count];
}
/*
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return [peerGroupNames objectAtIndex:section];
}
*/
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
   
        UsersSectionCell *cell=[tableView dequeueReusableCellWithIdentifier:@"UsersSectionCell"];
    UserGroup *g=[_appDelegate.groups objectAtIndex:section];
    cell.nameLabel.text =[NSString stringWithFormat:@"%@ (%lu)",g.name,(unsigned long)[g.users count]];//[peerGroupNames objectAtIndex:section];//[categorySectionTitles objectAtIndex:section];
        if(!g.expanded){
            //cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
            [cell.expandImage setImage:[UIImage imageNamed:@"expand_arrow"]];
            
            
        }
        else{
            [cell.expandImage setImage:[UIImage imageNamed:@"collapse_arrow"]] ;
            
        }
        /*[cell.expandButton addTarget:self action:@selector(expandAction:) forControlEvents:UIControlEventTouchUpInside];
         cell.expandButton.tag=section;
         */
        UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(expandGesture:)];
        
        [cell addGestureRecognizer:tap];
        cell.tag=section;
        /*
         [[cell.expandButton layer] setCornerRadius:8.0f];
         
         [[cell.expandButton layer] setBorderWidth:1.0f];
         
         [[cell.expandButton layer] setBorderColor:cell.expandButton.titleLabel.textColor.CGColor];
         */
        //cell.backgroundColor=[UIColor whiteColor];
    
    UIImage *background = [self cellSectionBackground];
    
    UIImageView *cellBackgroundView = [[UIImageView alloc] initWithImage:background];
    cellBackgroundView.image = background;
    cell.backgroundView = cellBackgroundView;
    
        return cell;
        
    //}
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    UserGroup *g=[_appDelegate.groups objectAtIndex:section];
    if(g.expanded){
        return [g.users count];
    }
    else{
    //return [peers count];
        return 0;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"users_cell" forIndexPath:indexPath];
    /*
    NSPredicate *p=[NSPredicate predicateWithFormat:@"PeerGroup==%@",[peerGroupNames objectAtIndex:indexPath.section]];
    NSArray *peers=[_appDelegate.mcManager.myPeerInfo.peers filteredArrayUsingPredicate:p];
    
    
    NSDictionary *peer=[peers objectAtIndex:indexPath.row];
   */
    UserGroup *group=[_appDelegate.groups objectAtIndex:indexPath.section];
    User *user=[group.users objectAtIndex:indexPath.row];
    
    [cell.imageView setImage:[UIImage imageNamed:@"empty"]];
    dispatch_queue_t imageQueue = dispatch_queue_create("Image Queue",NULL);
    dispatch_async(imageQueue, ^{
        
        
        NSString *filePath;
        
        /*
        NSString *photo=[NSString stringWithFormat:@"%@%@.png",PREFIX_MYPHOTO, [peer objectForKey:DeviceIdKey]];
        if([[peer valueForKey:DeviceIdKey] isEqualToString:_appDelegate.appConfig.device_id])
            
            filePath=[[AppDelegate getDocumentsPath] stringByAppendingPathComponent:photo];
        else{
            if(_appDelegate.mcManager.myPeerInfo==nil)
                return;
            
            filePath=[[AppDelegate getImagesPath] stringByAppendingPathComponent:peer_photo];
        }
*/
        NSString *photo=[NSString stringWithFormat:@"%@%@.png",PREFIX_MYPHOTO, user.deviceID];
        if([user.deviceID isEqualToString:_appDelegate.appConfig.device_id])
            
            filePath=[[AppDelegate getDocumentsPath] stringByAppendingPathComponent:photo];
        else{
            if(_appDelegate.mcManager.myPeerInfo==nil)
                return;
            
            filePath=[[AppDelegate getImagesPath] stringByAppendingPathComponent:photo];
        }
        
                /*
         NSString *filePath=[[AppDelegate getImagesPath] stringByAppendingPathComponent:peer_photo];
         */
        
        //check if cached
        NSData *imageData=nil;
        if([[NSFileManager defaultManager] fileExistsAtPath:filePath]){
            
           
            imageData =[NSData dataWithContentsOfFile:filePath];
        }
      
        if(!imageData) return;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if(cell.imageView){
                [cell.imageView setImage:[UIImage imageWithData:imageData]];
                cell.imageView.layer.cornerRadius=cell.imageView.frame.size.width / 2;
                cell.imageView.clipsToBounds = YES;
            }
        });
    });
   
    NSString *userName=(user.groupID==0)?@"Anonymous":user.userName;
    
     if([user.deviceID isEqualToString:_appDelegate.appConfig.device_id])
         cell.textLabel.text = @"You";
    else
        //cell.textLabel.text =[NSString stringWithFormat:@"%@ -%@",user.name, (user.groupID==0)?@"Anonymous":user.userName] ;//[peer objectForKey:@"Title"];
        cell.textLabel.text =[NSString stringWithFormat:@"%@",user.name] ;
    
    //if([_appDelegate.appConfig.blockedDevices containsObject:[peer valueForKey:DeviceIdKey]]){
    if([_appDelegate.appConfig.blockedDevices containsObject:user.deviceID]){
        cell.detailTextLabel.text=[NSString stringWithFormat:@"%@ BLOCKED",userName];
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:cell.detailTextLabel.text];
        [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, cell.detailTextLabel.text.length)];
        cell.detailTextLabel.attributedText = attributedString;
        
    }
    else
        cell.detailTextLabel.text=userName;

    cell.imageView.layer.cornerRadius=cell.imageView.frame.size.width / 2;
    cell.imageView.clipsToBounds = YES;
   // [cell.contentView.layer setBorderColor:[UIColor clearColor].CGColor];
    // [cell.contentView.layer setBorderWidth:2.0];
    
    UIImage *background = [self cellBackgroundForRowAtIndexPath:indexPath];
    
    UIImageView *cellBackgroundView = [[UIImageView alloc] initWithImage:background];
    cellBackgroundView.image = background;
    cell.backgroundView = cellBackgroundView;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    /*
    NSPredicate *p=[NSPredicate predicateWithFormat:@"PeerGroup==%@",[peerGroupNames objectAtIndex:indexPath.section]];
    
    NSArray *peers=[_appDelegate.mcManager.myPeerInfo.peers filteredArrayUsingPredicate:p];
    
    
    NSDictionary *peer=[peers objectAtIndex:indexPath.row];
    */
    UserGroup *selectedGroup=[_appDelegate.groups objectAtIndex:indexPath.section];
    _selectedUser=[selectedGroup.users objectAtIndex:indexPath.row];
    /*
    //if([[peer valueForKey:DeviceIdKey] isEqualToString:_appDelegate.appConfig.device_id] || [[peer valueForKey:DeviceIdKey] isEqualToString:_appDelegate.mcManager.myPeerInfo.deviceID]){
    if([_selectedUser.deviceID isEqualToString:_appDelegate.appConfig.device_id] || [_selectedUser.deviceID isEqualToString:_appDelegate.mcManager.myPeerInfo.deviceID]){
        //self.navigationItem.rightBarButtonItems=@[sendButtonItem];
    }
    else{
        //if([_appDelegate.appConfig.blockedDevices containsObject:[peer valueForKey:DeviceIdKey]]){
        if([_appDelegate.appConfig.blockedDevices containsObject:_selectedUser.deviceID]){
            [blockButtonItem setTitle:@"Unblock"];
            self.navigationItem.rightBarButtonItems=@[blockButtonItem];
        }
        else{
            [blockButtonItem setTitle:@"Block"];
            //self.navigationItem.rightBarButtonItems=@[sendButtonItem,blockButtonItem];
            self.navigationItem.rightBarButtonItems=@[blockButtonItem];
        }
    }
   
    selectedIndexPath=indexPath;
    */
    [self performSegueWithIdentifier:@"toUserDetailViewController" sender:self];
    
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    /*NSPredicate *p=[NSPredicate predicateWithFormat:@"PeerGroup==%@",[peerGroupNames objectAtIndex:indexPath.section]];
    NSArray *peers=[_appDelegate.mcManager.myPeerInfo.peers filteredArrayUsingPredicate:p];
    
    
    NSDictionary *peer=[peers objectAtIndex:indexPath.row];
    */
    UserGroup *group=[_appDelegate.groups objectAtIndex:indexPath.section];
    User *user=[group.users objectAtIndex:indexPath.row];
    
    //if([[peer valueForKey:DeviceIdKey] isEqualToString:_appDelegate.appConfig.device_id]){
    if([user.deviceID isEqualToString:_appDelegate.appConfig.device_id]){
        return NO;
    }
    //if([[peer valueForKey:DeviceIdKey] isEqualToString:_appDelegate.mcManager.myPeerInfo.deviceID]){
    if([user.deviceID isEqualToString:_appDelegate.mcManager.myPeerInfo.deviceID]){
        return NO;
    }
    /*if (indexPath.section==0) {
        return YES;
    }
    else{
        return NO;
    }
     */
    return YES;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 60.0;
}

-(void)setEditing:(BOOL)editing animated:(BOOL)animated{
    [super setEditing:editing animated:animated];
    [self.tableView setEditing:editing animated:animated];
    if (editing)
    {
        //self.editButtonItem.title = NSLocalizedString(@"Cancel", @"Cancel");
    }
    else
    {
        self.editButtonItem.title = NSLocalizedString(@"Block/UnBlock", @"Block/UnBlock");
    }
}

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    /*
    NSPredicate *p=[NSPredicate predicateWithFormat:@"PeerGroup==%@",[peerGroupNames objectAtIndex:indexPath.section]];
    NSArray *peers=[_appDelegate.mcManager.myPeerInfo.peers filteredArrayUsingPredicate:p];
    
    
    NSDictionary *peer=[peers objectAtIndex:indexPath.row];
     */
    UserGroup *group=[_appDelegate.groups objectAtIndex:indexPath.section];
    User *user=[group.users objectAtIndex:indexPath.row];
    //if([_appDelegate.appConfig.blockedDevices containsObject:[peer valueForKey:DeviceIdKey]])
    if([_appDelegate.appConfig.blockedDevices containsObject:user.deviceID])
        return @"UNBLOCKED";
    else
        return @"BLOCK";
    
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    /*
     NSMutableArray *orders=[self.history valueForKey:day];
     if(orders==nil){
     orders=[NSMutableArray new];
     [orders addObject:order];
     [self.history setValue:orders forKey:day];
     }
     else{
     [orders addObject:order];
     }
     */
    //NSMutableArray *orders=[_appDelegate.historyModel.history valueForKey:historyDates[indexPath.section]] ;
    
    //OrderHistory *delete_item=[orders objectAtIndex:indexPath.row];
    
    
    
    
    if(editingStyle==UITableViewCellEditingStyleDelete){
        /*
        NSPredicate *p=[NSPredicate predicateWithFormat:@"PeerGroup==%@",[peerGroupNames objectAtIndex:indexPath.section]];
        NSArray *peers=[_appDelegate.mcManager.myPeerInfo.peers filteredArrayUsingPredicate:p];
        
        
        NSDictionary *peer=[peers objectAtIndex:indexPath.row];
         */
        UserGroup *group=[_appDelegate.groups objectAtIndex:indexPath.section];
        User *user=[group.users objectAtIndex:indexPath.row];
        //if([_appDelegate.appConfig.blockedDevices containsObject:[peer valueForKey:DeviceIdKey]])
        if([_appDelegate.appConfig.blockedDevices containsObject:user.deviceID])
            [_appDelegate.appConfig.blockedDevices removeObject:user.deviceID];
        else
            //[_appDelegate.appConfig.blockedDevices addObject:[peer valueForKey:DeviceIdKey]];
            [_appDelegate.appConfig.blockedDevices addObject:user.deviceID];
        
        //[self.tableView reloadData];
        [self reloadData];
    }
}

- (UIImage *)cellBackgroundForRowAtIndexPath:(NSIndexPath *)indexPath{
    UserGroup *g=[_appDelegate.groups objectAtIndex:indexPath.section];
    
    //NSInteger rowCount = [self tableView:[self tableView] numberOfRowsInSection:indexPath.section];
    NSInteger rowCount = [g.users count];//[g.peers count];
    
   // NSInteger rowCoun
    NSInteger rowIndex = indexPath.row;
    UIImage *background = nil;
    
    /*if (rowIndex == 0) {
        background = [UIImage imageNamed:@"cell_top.png"];
     */
    if(rowCount>1){
        if (rowIndex == rowCount - 1) {
        background = [UIImage imageNamed:@"cell_bottom.png"];
        } else {
            background = [UIImage imageNamed:@"cell_middle.png"];
        }
    }
    else{
        background = [UIImage imageNamed:@"cell_bottom.png"];    
    }
    
    return background;
}
- (UIImage *)cellSectionBackground{
    //NSInteger rowCount = [self tableView:[self tableView] numberOfRowsInSection:indexPath.section];
    //NSInteger rowIndex = indexPath.row;
    UIImage *background = nil;
    
    //if (rowIndex == 0) {
        background = [UIImage imageNamed:@"cell_top.png"];
    /*} else if (rowIndex == rowCount - 1) {
        background = [UIImage imageNamed:@"cell_bottom.png"];
    } else {
        background = [UIImage imageNamed:@"cell_middle.png"];
    }
    */
    return background;
}

-(void)blockButtonItemTapped{
    
    UserGroup *group=[_appDelegate.groups objectAtIndex:selectedIndexPath.section];
    User *user=[group.users objectAtIndex:selectedIndexPath.row];
    
if([_appDelegate.appConfig.blockedDevices containsObject:user.deviceID])
[_appDelegate.appConfig.blockedDevices removeObject:user.deviceID];
else
[_appDelegate.appConfig.blockedDevices addObject:user.deviceID];


[self reloadData];
    
}


-(void)sendMessage:(User *)to{
    
    //UserGroup *group=[_appDelegate.groups objectAtIndex:selectedIndexPath.section];
    //User *user=[group.users objectAtIndex:selectedIndexPath.row];
 
    
   // [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_SHOW_SENDMESSAGE object:nil userInfo:@{DeviceIdKey:to.deviceID}];//peer];
     //[self.tabBarController setSelectedIndex:TAB_INDEX_CHAT];
    //[self.navigationController popToRootViewControllerAnimated:YES];
    
    [self dismissViewControllerAnimated:YES completion:^{
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_SHOW_SENDMESSAGE object:nil userInfo:@{DeviceIdKey:to.deviceID}];
    }];
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



-(void)reloadData{
    [_appDelegate reloadUserGroups];
    
    
    
    
    
        BOOL def_expanded=YES;
        
        if(_appDelegate.users.count>50)
            def_expanded=NO;
        
    
        [self.tableView reloadData];
    
}

-(void)expandGesture:(UITapGestureRecognizer *)sender{
    //UIButton *button=(UIButton *)sender;
    
    NSUInteger section=sender.view.tag;//button.tag;
    UserGroup *g=[_appDelegate.groups objectAtIndex:section];//[_sortedCategories objectAtIndex:section];
    
    if(g.expanded){
        g.expanded=NO;
    }
    else{
        g.expanded=YES;
    }
    [self.tableView reloadData];
}

-(void)imageForUser:(UIImageView *)imageView deviceID:(NSString *) deviceID{
    [imageView setImage:[UIImage imageNamed:@"person.png"]];
    
    NSString *peer_photo=[NSString stringWithFormat:@"%@%@.png",PREFIX_MYPHOTO, deviceID];
    
    
    NSString *filePath=[[AppDelegate getImagesPath] stringByAppendingPathComponent:peer_photo];
    if([[NSFileManager defaultManager] fileExistsAtPath:filePath]){
        dispatch_queue_t imageQueue = dispatch_queue_create("Image Queue",NULL);
        dispatch_async(imageQueue, ^{
            
            
            NSData *imageData=imageData =[NSData dataWithContentsOfFile:filePath];
            
            
            if(!imageData) return;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if(imageView){
                    [imageView setImage:[UIImage imageWithData:imageData]];
                    //cell.senderPhoto.layer.cornerRadius=cell.senderPhoto.frame.size.width / 2;
                    //cell.senderPhoto.clipsToBounds = YES;
                }
            });
        });
    }
    imageView.layer.cornerRadius=imageView.frame.size.width / 2;
    imageView.clipsToBounds = YES;
    
}


- (IBAction)backAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)searchAction:(id)sender {
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if([segue.identifier isEqualToString:@"toSearchUsersViewController"]){
        SearchUsersViewController *vc=segue.destinationViewController;
        vc.delegate=self;
    }
    
    else if([segue.identifier isEqualToString:@"toUserDetailViewController"]){
        UserDetailViewController *vc=segue.destinationViewController;
        //vc.delegate=self;
        vc.selectedUser=_selectedUser;
    }
    

    
}

-(void)searchUsersViewControllerDidSelect:(SearchUsersViewController *)controller withUser:(User *)user{
    [self performSegueWithIdentifier:@"toUserDetailViewController" sender:self];
}

-(void)userDetailViewControllerSendTapped:(UserDetailViewController *)controller withUser:(User *)user{
    [self sendMessage:user];
}
@end
