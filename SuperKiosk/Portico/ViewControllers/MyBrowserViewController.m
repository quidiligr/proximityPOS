//
//  BrowserViewController.m
//  MCDemo
//
//  Created by Romulo Quidilig on 3/19/15.
//  Copyright (c) 2015 Sharecle Inc. All rights reserved.
//

#import "MyBrowserViewController.h"
#import "AppDelegate.h"
#import "PeerInfo.h"
#import "HistoryModel.h"
#import "defs.h"

@interface MyBrowserViewController ()
{
    MCNearbyServiceBrowser *browser;
    //void(^handler)(NSData *,NSError *);//

}

@property (nonatomic, strong) AppDelegate *appDelegate;
//@property(nonatomic,strong) NSMutableArray *arrFoundDevices;



@end

@implementation MyBrowserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //_appDelegate.mcManager.peerDevices=[NSMutableArray new];
    _appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    /*handler=^(NSData *connectionData, NSError *error){
         NSLog(@"handler called");
        if(error!=nil){
            
            NSLog([error localizedDescription]);
        }
       
    };
     */
    // [[_appDelegate mcManager] setupPeerAndSessionWithDisplayName:[UIDevice currentDevice].name];
   // [[_appDelegate mcManager] setupPeerAndSessionWithDisplayName:_appDelegate.userInfo.displayName];
    //[[_appDelegate mcManager] advertiseSelf:_swVisible.isOn];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(peerDidChangeStateWithNotification:)
                                                 name:NOTIFY_MCDIDCHANGESTATE
                                               object:nil];
   /* [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didReceivePeerPhotoNotification:)
                                                 name:NOTIFY_RECEIVED_PEER_PHOTO
                                               object:nil];
*/
    
    _appDelegate.mcManager.browser.delegate=self;
    [_appDelegate.mcManager.browser startBrowsingForPeers];


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_appDelegate.mcManager.peerDevices count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BrowserCellIdentifier"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"BrowserCellIdentifier"];
    }
   
    
    PeerInfo *peerInfo= [_appDelegate.mcManager.peerDevices objectAtIndex:indexPath.row];
    /*if([_appDelegate.mcManager.peerDevices containsObject:peerInfo])
        cell.textLabel.text =[NSString stringWithFormat:@"%@ Connected",peerInfo.peerID.displayName];
    else*/
        cell.textLabel.text =peerInfo.peerID.displayName;
    if(peerInfo.sessionState==MCSessionStateConnected)
        cell.detailTextLabel.text=@"Connected";//peerInfo.deviceToken;
    else if(peerInfo.sessionState==MCSessionStateConnecting)
        cell.detailTextLabel.text=@"Connecting...";
    else
        cell.detailTextLabel.text=nil;
    
    
    /*this ok for http connection
     dispatch_async(dispatch_get_main_queue(), ^{
        NSURL *url=[[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@myphoto.png",peerInfo.homeUrl]];
        NSData *imageData=[[NSData alloc] initWithContentsOfURL:url];
        if (imageData!=nil) {
           // UIImage *image=[[UIImage alloc] initWithData:imageData];
            cell.imageView.image=[[UIImage alloc] initWithData:imageData];
            cell.imageView.layer.cornerRadius=cell.imageView.frame.size.width / 2;
            cell.imageView.clipsToBounds = YES;

        }
        
        
    });
     */
    /*BT connection. NOTE: In this case this wont work bec theyre not connected yet
    
    //TODO: implement compression
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *peer_photo=[NSString stringWithFormat:@"myphoto-%@.png",peerInfo.deviceID];
        NSString *serverPath=[NSString stringWithFormat:@"/%@",peer_photo];
        
         //NSLog(@"serverpath=%@",peerInfo.homeUrl);
        NSLog(@"serverpath=%@",serverPath);
        
        NSDictionary *dict = @{KEY_SEND_MESSAGE: serverPath,
                               KEY_SEND_MESSAGE_TYPE : MSG_TYPE_REQUEST_FILE_DOWNLOAD
                               };
        
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_HAS_DATA_TO_SEND
                                                            object:nil
                                                          userInfo:dict];
        
        
        
    });
    */
    NSString *peer_photo=[NSString stringWithFormat:@"myphoto-%@.png",peerInfo.deviceID];
    
    NSString *filePath=[[AppDelegate getImagesPath] stringByAppendingPathComponent:peer_photo];
    
    //check if cached
    if([[NSFileManager defaultManager] fileExistsAtPath:filePath]){
        cell.imageView.image=[[UIImage alloc] initWithContentsOfFile:filePath];
    }
    else{
        dispatch_async(dispatch_get_main_queue(), ^{
            /*this is for http connectivity
             NSURL *url=[[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@myphoto.png",peerInfo.homeUrl]];
             NSData *imageData=[[NSData alloc] initWithContentsOfURL:url];
             if (imageData!=nil) {
             // UIImage *image=[[UIImage alloc] initWithData:imageData];
             cell.imageView.image=[[UIImage alloc] initWithData:imageData];
             cell.imageView.layer.cornerRadius=cell.imageView.frame.size.width / 2;
             cell.imageView.clipsToBounds = YES;
             }
             */
            
            //MC connectivity
            
            NSString *serverPath=[NSString stringWithFormat:@"/%@",peer_photo];
            
            //NSLog(@"serverpath=%@",peerInfo.homeUrl);
            //NSLog(@"serverpath=%@",serverPath);
            
            NSDictionary *dict = @{KEY_SEND_MESSAGE: serverPath,
                                   KEY_SEND_MESSAGE_TYPE : MSG_TYPE_REQUEST_FILE_DOWNLOAD
                                   };
            
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_HAS_DATA_TO_SEND
                                                                object:nil
                                                              userInfo:dict];
            
            
        });
    }

    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    _selectedPeer = [_appDelegate.mcManager.peerDevices objectAtIndex:indexPath.row];
    
    if(_selectedPeer==nil)
        return;
    
    if(_selectedPeer.sessionState!=MCSessionStateNotConnected)
        return;
    
    _selectedPeer.sessionState=MCSessionStateConnecting;
    //NSString *photUrl=@"";
    NSArray *objects=[[NSArray alloc] initWithObjects:_appDelegate.userInfo.deviceID,_appDelegate.userInfo.homeUrl, nil];
    
    NSArray *keys=[[NSArray alloc] initWithObjects:@"deviceID",@"homeurl", nil];
    NSDictionary *context=[[NSDictionary alloc] initWithObjects:objects forKeys:keys];
    
   // [context ]
    [_appDelegate.mcManager.browser invitePeer:_selectedPeer.peerID toSession:_appDelegate.mcManager.session withContext:[NSKeyedArchiver archivedDataWithRootObject:context] timeout:60.0 ];
    _appDelegate.mcManager.serverPeerInfo=_selectedPeer;
   /* UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:@"Connecting to..." message:peerInfo.peerID.displayName delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil, nil];
    [alertView show];
    */
    [_tableView reloadData];

}

/*-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    [_appDelegate.mcManager.browser inv]
}
*/


-(void)peerDidChangeStateWithNotification:(NSNotification *)notification{
    /* MCPeerID *peerID = [[notification userInfo] objectForKey:@"peerID"];
     // peerID.hash
     //NSString *peerDisplayName = peerID.displayName;
     
     MCSessionState state = [[[notification userInfo] objectForKey:@"state"] intValue];
     
     if (state != MCSessionStateConnecting) {
     if (state == MCSessionStateConnected) {
     //[_arrConnectedDevices addObject:peerDisplayName];
     
     PeerInfo *peerInfo=[[PeerInfo alloc] init];
     peerInfo.peerID=peerID;
     [_appDelegate.mcManager.arrConnectedDevices addObject:peerInfo];
     }
     else if (state == MCSessionStateNotConnected){
     if ([_appDelegate.mcManager.arrConnectedDevices count] > 0) {
     //int indexOfPeer = [_arrConnectedDevices indexOfObject:peerDisplayName];
     NSInteger indexOfPeer = [_appDelegate.mcManager.arrConnectedDevices indexOfObject:peerID];
     [_appDelegate.mcManager.arrConnectedDevices removeObjectAtIndex:indexOfPeer];
     }
     }
     [_tblConnectedDevices reloadData];
     
     BOOL peersExist = ([[_appDelegate.mcManager.session connectedPeers] count] == 0);
     [_btnDisconnect setEnabled:!peersExist];
     [_txtName setEnabled:peersExist];
     }
     */
    //[_tblConnectedDevices reloadData];
    //[self reloadConnectedDevices];
    
    
    [_tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
    
  
        MCSessionState state = [[[notification userInfo] objectForKey:@"state"] intValue];
        
       
       if (state == MCSessionStateConnected) {
        
           
           //stop browse
           [self.delegate browserViewControllerDidFinishConnected:self];
        
           
        }

}

-(void)browser:(MCNearbyServiceBrowser *)browser foundPeer:(MCPeerID *)peerID withDiscoveryInfo:(NSDictionary *)info{
    
    
    
    PeerInfo *newPeer=[[PeerInfo alloc] initWithPeerID:peerID];
    //existingPeer.peerID=peerID;
    newPeer.deviceID=[info valueForKey:@"deviceID"];
    newPeer.homeUrl=[info valueForKey:@"homeurl"];
    /*NSData *photo=[info valueForKey:@"photo"];
    [self copyImageFileToDocDirIfNeeded:newPeer.deviceToken peerPhoto:photo];
  */
    //NSData *connectionData;
    //NSError *error;
    

 
    
    if([_appDelegate.mcManager.peerDevices containsObject:newPeer]){
        NSInteger indexOfPeer = [_appDelegate.mcManager.peerDevices indexOfObject:newPeer];
        PeerInfo *existing=[_appDelegate.mcManager.peerDevices objectAtIndex:indexOfPeer];
        existing.peerID=peerID;

    }
    else{

        [_appDelegate.mcManager.peerDevices addObject:newPeer];
    }
    
    /*[_appDelegate.mcManager.session nearbyConnectionDataForPeer:peerID withCompletionHandler:^(NSData *connectionData,
                                                                                                NSError *error){
        NSDictionary *peer_connectionData=( NSDictionary *)[NSKeyedUnarchiver unarchiveObjectWithData:connectionData];
        //NSString *home_url=[peer_connectionData valueForKey:@"home_url"];
        newPeer.homeUrl=[peer_connectionData valueForKey:@"home_url"];
         
    }];
   */

    
    
    [_tableView reloadData];

    
}

-(void)browser:(MCNearbyServiceBrowser *)browser didNotStartBrowsingForPeers:(NSError *)error{
    NSString *message=[error localizedDescription];
    UIAlertView *toast=[[UIAlertView alloc] initWithTitle:nil message:message delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
    [toast show];
    int duration=2;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, duration * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [toast dismissWithClickedButtonIndex:0 animated:YES];
    });
}

-(void)browser:(MCNearbyServiceBrowser *)browser lostPeer:(MCPeerID *)peerID{
   /* NSInteger indexOfPeer=-1;
   
    for( NSInteger i=0;i<[_appDelegate.mcManager.peerDevices count];i++){
        PeerInfo *item =_appDelegate.mcManager.peerDevices[i];
        if([item.peerID.displayName isEqualToString:peerID.displayName]){
            indexOfPeer = i;
            break;
        }
    }
   
    //[_appDelegate.mcManager.arrConnectedDevices indexOfObject:item];
    if(indexOfPeer!=-1){
        [_appDelegate.mcManager.peerDevices removeObjectAtIndex:indexOfPeer];
        [_tableView reloadData];
    }
*/
    PeerInfo *lostPeer=[[PeerInfo alloc] initWithPeerID:peerID];
    //existingPeer.peerID=peerID;
    //lostPeer.deviceToken=[info valueForKey:@"devicetoken"];
    //lostPeer.homeUrl=[info valueForKey:@"homeurl"];
    /*NSData *photo=[info valueForKey:@"photo"];
     [self copyImageFileToDocDirIfNeeded:newPeer.deviceToken peerPhoto:photo];
     */
    //NSData *connectionData;
    //NSError *error;
    
    
    
    
    if([_appDelegate.mcManager.peerDevices containsObject:lostPeer]){
        NSInteger indexOfPeer = [_appDelegate.mcManager.peerDevices indexOfObject:lostPeer];
        //PeerInfo *existing=[_appDelegate.mcManager.peerDevices objectAtIndex:indexOfPeer];
        //existing.peerID=peerID;
        [_appDelegate.mcManager.peerDevices removeObjectAtIndex:indexOfPeer];
        [_tableView reloadData];

        
    }
    
}




- (IBAction)actionDone:(id)sender {
    [self.delegate browserViewControllerDidFinish:self];
}


- (IBAction)actionCancel:(id)sender {
     [self.delegate browserViewControllerWasCancelled:self];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(void)didReceivePeerPhotoNotification:(NSNotification *)notification{
    [self.tableView reloadData];
}

@end
