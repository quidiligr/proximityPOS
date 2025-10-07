//
//  StaffPeersTableViewController.m
//  Order Here
//
//  Created by Katherine Sheehy on 7/3/15.
//  Copyright (c) 2015 Sharecle. All rights reserved.
//

#import "SearchUsersViewController.h"
#import "AppDelegate.h"
#import "PeerDisplayCell.h"
#import "UsersSectionCell.h"
#import "UserGroup.h"

#import "defs.h"
@interface SearchUsersViewController (){
    AppDelegate *_appDelegate;
    //NSDictionary *staffs;
    //NSDictionary *customers;
    //NSMutableArray *peerGroupNames;
    //UIBarButtonItem *sendButtonItem;
    //UIBarButtonItem *blockButtonItem;
    NSIndexPath *selectedIndexPath;
    //NSArray *_groups;
    NSMutableArray *_searchResults;
    NSString *_searchText;
}

@end

@implementation SearchUsersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor clearColor];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    _appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    _searchTextField.delegate=self;
    /*if(_appDelegate.isIpad){
        self.navigationItem.hidesBackButton=YES;
        
    }
    */
    /*
    sendButtonItem =[[UIBarButtonItem alloc] initWithTitle:@"New message" style:UIBarButtonItemStyleBordered target:self action:@selector(sendButtonItemTapped)];
    
    blockButtonItem =[[UIBarButtonItem alloc] initWithTitle:@"Block" style:UIBarButtonItemStyleBordered target:self action:@selector(blockButtonItemTapped)];
    
    
    */
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
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;//[_appDelegate.groups count];
}
/*
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return [peerGroupNames objectAtIndex:section];
}
*/

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_searchResults count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"users_cell" forIndexPath:indexPath];
    
    User *user=[_searchResults objectAtIndex:indexPath.row];
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"groupID==%i",user.groupID];
    
    UserGroup *group=nil;
    NSArray *array=[_appDelegate.users filteredArrayUsingPredicate:predicate];
    if([array count]>0)
        group=[array firstObject];
   // else{
     //   group=[_appDelegate.groups firstObject]; //Anonymous
    //}
    
    
    [cell.imageView setImage:[UIImage imageNamed:@"empty"]];
    dispatch_queue_t imageQueue = dispatch_queue_create("Image Queue",NULL);
    dispatch_async(imageQueue, ^{
        
        
        NSString *filePath;
        
        //NSString *photo=[NSString stringWithFormat:@"%@%@.png",PREFIX_MYPHOTO, [peer objectForKey:@"DeviceId"]];
        NSString *photo=[NSString stringWithFormat:@"%@%@.png",PREFIX_MYPHOTO, user.deviceID];
        /*
        if([[peer valueForKey:@"DeviceId"] isEqualToString:_appDelegate.appConfig.device_id])
            
            filePath=[[AppDelegate getDocumentsPath] stringByAppendingPathComponent:photo];
        else{
            if(_appDelegate.mcManager.myPeerInfo==nil)
                return;
            
            filePath=[[AppDelegate getImagesPath] stringByAppendingPathComponent:photo];
        }
         */
        
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
   
    /*
     if([[peer valueForKey:@"DeviceId"] isEqualToString:_appDelegate.appConfig.device_id])
         cell.textLabel.text = @"You";
    else
        cell.textLabel.text = [peer objectForKey:@"Title"];
*/
    NSString *userName;
    if(group!=nil){
        userName=(user.groupID==GROUPID_GUESTS)?@"guest":user.userName;
        userName=[NSString stringWithFormat:@"%@ (%@)",userName,group.name];
    }
    else{
        userName=[NSString stringWithFormat:@"%@ (Group not set)",userName];
    }
    
    if([user.deviceID isEqualToString:_appDelegate.appConfig.device_id])
        cell.textLabel.text = @"You";
    else
        cell.textLabel.text = user.name;//[peer objectForKey:@"Title"];
    
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
    
    
    _selectedUser=[_searchResults objectAtIndex:indexPath.row];
    
    [self.delegate searchUsersViewControllerDidSelect:self withUser:_selectedUser];
    
}

- (UIImage *)cellBackgroundForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSInteger rowCount = [_searchResults count];//[g.peers count];
    
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


 -(void)reloadData{
 
     if(_searchResults==nil)
         _searchResults=[NSMutableArray new];
     
     if([_searchResults count]>0)
         [_searchResults removeAllObjects];
     
 _searchText=[_searchText stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" "]];
 
 _searchText=[_searchText stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"*"]];
 _searchText=[_searchText stringByAppendingString:@"*"];
 
 
     if(_searchText.length>0){
     
     
     NSPredicate* predicate = [NSPredicate predicateWithFormat:@"name LIKE[c] %@ || userName LIKE[c] %@",_searchText,_searchText];
     
     
     _searchResults= [[_appDelegate.users filteredArrayUsingPredicate:predicate] mutableCopy];
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

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    _searchText=[textField.text stringByReplacingCharactersInRange:range withString:string];
    
    NSLog(@"string=%@",string);
    NSLog(@"textField.text=%@",textField.text);
    NSLog(@"_searchText=%@",_searchText);
    
    //if(![string isEqualToString:@" "])
    [self reloadData];
    //[self.add]
    
    return YES;
}


@end
