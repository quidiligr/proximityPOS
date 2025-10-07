//
//  StaffPeersTableViewController.m
//  Order Here
//
//  Created by Katherine Sheehy on 7/3/15.
//  Copyright (c) 2015 Appcoda. All rights reserved.
//

#import "CustomerPeersViewController.h"
#import "AppDelegate.h"
#import "PeerDisplayCell.h"
#import "defs.h"
@interface CustomerPeersViewController (){
    AppDelegate *_appDelegate;
    //NSDictionary *staff;
    NSMutableArray *peers;
}

@end

@implementation CustomerPeersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    _appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    peers=[NSMutableArray new];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didReceiveUpdatePeers:)
                                                 name:NOTIFY_UPDATE_PEERS
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didReceiveAppConfigUpdate:)
                                                 name:NOTIFY_APPCONFIG_UPDATE
                                               object:nil];
    
    
self.tableView.backgroundColor=[UIColor clearColor];
    
    
    
}
-(void)didReceiveAppConfigUpdate:(NSNotification *)notification{
    [self loadData];
}
-(void)didReceiveUpdatePeers:(NSNotification *)notification{
    [self loadData];
}
   
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    //[self.tableView reloadData];
    [self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return [peers count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PeerDisplayCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PeerDisplayCell" forIndexPath:indexPath];
    
    NSDictionary *peer=[peers objectAtIndex:indexPath.row];
   
    
    dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_async(concurrentQueue, ^{
        UIImage *image = nil;
        
        NSString *filePath;
        
        NSString *peer_photo=[NSString stringWithFormat:@"%@%@.png",PREFIX_MYPHOTO, [peer objectForKey:@"DeviceId"]];
        
        if([[peer valueForKey:@"DeviceId"] isEqualToString:_appDelegate.appConfig.userInfo.deviceID])
            
            filePath=[[AppDelegate getDocumentsPath] stringByAppendingPathComponent:peer_photo];
        else
            filePath=[[AppDelegate getImagesPath] stringByAppendingPathComponent:peer_photo];
        
        
        
        //check if cached
        if([[NSFileManager defaultManager] fileExistsAtPath:filePath]){
            
            image=[[UIImage alloc] initWithContentsOfFile:filePath];
        }
        else{
            
            image=[UIImage imageNamed:@"person.png"];
        }
        //image = [UIImage imageNamed:[currentArticle objectForKey:@"ImageName"]];
        //image = [UIImage imageNamed:@"person.png"];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [cell.peerImage setImage:image];
        });
    });
    
     if([[peer valueForKey:@"DeviceId"] isEqualToString:_appDelegate.appConfig.userInfo.deviceID])
         cell.peerLabel.text = @"You";
    else
        cell.peerLabel.text = [peer objectForKey:@"Title"];

    cell.peerImage.layer.cornerRadius=cell.peerImage.frame.size.width / 2;
    cell.peerImage.clipsToBounds = YES;
   // [cell.contentView.layer setBorderColor:[UIColor clearColor].CGColor];
    // [cell.contentView.layer setBorderWidth:2.0];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *peer=[peers objectAtIndex:indexPath.row];
    
      [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_SHOW_SENDMESSAGE object:nil userInfo:peer];
    
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

-(void)loadData{
    if(_appDelegate==nil)
        _appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    //PeerListViewController_iPhone *destViewController=(PeerListViewController_iPhone *)segue.destinationViewController;
    [peers removeAllObjects];
    //NSMutableArray *staffs=[NSMutableArray new];
    if(_appDelegate.mcManager.serverPeerInfo && _appDelegate.mcManager.serverPeerInfo.peers){
        //[self.containerStaffsList setHidden:NO];
        
        NSString *file1Path;
        NSDictionary *peer;
        
        for (NSDictionary *peer_dict in _appDelegate.mcManager.serverPeerInfo.peers){
            if([[peer_dict valueForKey:@"PeerGroup"] isEqualToString:PEER_GROUP_CUSTOMERS]){
                file1Path=[[AppDelegate getImagesPath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@%@.png",PREFIX_MYPHOTO,[peer_dict valueForKey:@"DeviceId"]]];
                if([[NSFileManager defaultManager] fileExistsAtPath:file1Path]){
                    peer=@{
                            @"Title":[peer_dict valueForKey:@"Title"],
                            @"DeviceId":[peer_dict valueForKey:@"DeviceId"],
                            @"ImageName":[NSString stringWithFormat:@"%@%@.png",PREFIX_MYPHOTO,[peer_dict valueForKey:@"DeviceId"]]
                            };
                    
                }
                else{
                    peer=@{
                            @"Title":[peer_dict valueForKey:@"Title"],
                            @"DeviceId":[peer_dict valueForKey:@"DeviceId"],
                            @"ImageName":@"person.png"
                            };
                }
                [peers addObject:peer];
            }
            
        }
        
    }
    else{
        //staff=@{@"Title":@"",@"ImageName":@"person.png"};
        //[self.containerStaffsList setHidden:YES];
    }
    [self.tableView reloadData];
    //destViewController.articleDictionary=@{@"Staffs":staffs};
    //[[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_UPDATE_PEERS object:self];
}
@end
