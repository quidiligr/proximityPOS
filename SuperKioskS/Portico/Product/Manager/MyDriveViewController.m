//
//  MyFileViewController.m
//  Sharecle
//
//  Created by Romulo Quidilig on 8/11/14.
//  Copyright (c) 2014 Sharecle Inc. All rights reserved.
//

#import "MyDriveViewController.h"
//#import "DataModel.h"
#import "UserInfo.h"
#import "MyFile.h"
#import "MyFolder.h"
//#import "FileStore.h"
#import "NSData+MD5.h"
#import "AFNetworking.h"
#import "MBProgressHUD.h"
#import "defs.h"

@interface MyDriveViewController (){
    AFHTTPClient *_client;
    
    //DataModel *_dataModel;
    MyFile *_file;
    NSInteger _currentPage;
    NSUInteger _totalPages;
    NSArray *_unplayedMessages;
    NSUInteger _count;
    //NSUInteger _pageOffset;
    NSMutableDictionary *_properties;
    NSNumber *_folderid;
    NSString *_foldername;
    
    NSNumber *_parentfolderid;
    NSString *_parentfoldername;
    
    UIBarButtonItem *_upfolderButtonItem;
    
    UIImage *attachPhoto;
    UIActionSheet *_photoActionSheet;
    
    
    
    
    NSMutableArray *_deleteFiles;
    UIBarButtonItem *_addButtonItem;
    UIBarButtonItem *_refreshButtonItem;
    UIBarButtonItem *_synchButtonItem;
    MyFile *selectedFile;
    
    UIAlertView * alertAddfolder;
    UIAlertView * alertRenameFile;
    
    NSMutableArray *myFiles;
    NSInteger myFilesCount;
    // BOOL _needPhotoUpload;
}
@property (weak, nonatomic) IBOutlet UIBarButtonItem *btnUpFolder;
@property (nonatomic, strong) AppDelegate *appDelegate;


@end

@implementation MyDriveViewController

- (id) initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        // _pageOffset=MAX_ROWS/ROWS_PER_PAGE;  //50/25=2
        //_dataModel=[DataModel getInstance];
        
        _properties=[NSMutableDictionary new];
        _client = [AFHTTPClient clientWithBaseURL:[NSURL URLWithString:ServerApiURL]];
        
        _folderid=nil;
        
        if(myFiles==nil)
            myFiles=[NSMutableArray array];
        
        if(myFiles.count>0)
            [myFiles removeAllObjects];
        //[_dataModel.selectedBroadcast.messages removeAllObjects];
        _currentPage=0;
        //else{
        
        //  _currentPage=1;
        // [self fetchFilesFromServer:SCROLL_UP];
        // }
        
    }
    
    return self;
}


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
     _appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.parentViewController.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"common_bg"]];
    self.tableView.backgroundColor = [UIColor clearColor];
    UIEdgeInsets inset = UIEdgeInsetsMake(5, 0, 0, 0);
    self.tableView.contentInset = inset;
    
    // [_properties setValue:[NSNumber numberWithInteger:self.tag] forKey:@"tag"];
    // [_properties setValue:self.contenTypeFilter forKey:@"contenTypeFilter"];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    _deleteFiles=[NSMutableArray array];
    
    _addButtonItem=[[UIBarButtonItem alloc ] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(actionAddPhoto:)];
    //_composeButtonItem=[[UIBarButtonItem alloc ] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(composeAction:)];
    [self.editButtonItem setImage:[UIImage imageNamed:@"UIButtonBarTrashLandscape"]];
    //_composeButtonItem.title=@"Compose";
    
    // _refreshButtonItem=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ic_action_overflow@2x"] style:UIBarButtonItemStyleBordered target:self action:@selector(actionMenu:)];
    _refreshButtonItem=[[UIBarButtonItem alloc ] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(actionRefresh:)];
    // _synchButtonItem=[[UIBarButtonItem alloc ] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(actionSynch:)];
    
    self.navigationItem.rightBarButtonItems=@[_refreshButtonItem,_addButtonItem,self.editButtonItem];
    
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    //if(_dataModel.needsUpdateViewMyDrive){
        [self refresh];
    //}
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (_currentPage == 0) {
        return 1;
    }
    
    if (_currentPage < _totalPages) {
        if (_currentPage>2 && myFiles.count<MAX_ROWS) {
            return myFiles.count + 2;
        }
        else
            return myFiles.count + 1;
    }
    
    
    return myFiles.count;
    
}
/*- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section{
 return self.contactInfo.username;
 }
 */

- (UITableViewCell*)itemCellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    static NSString* CellIdentifier = @"cell_file";
    
    UITableViewCell* cell = (UITableViewCell*)[self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    
    MyFile* file = (myFiles)[indexPath.row];
    if (file.type==MyFileTypeFile) {
        cell.textLabel.text=file.filename;
        cell.detailTextLabel.text=[NSString stringWithFormat:@"%@", file.filesize];
        cell.accessoryType=UITableViewCellAccessoryNone;
    }
    else
    {
        cell.textLabel.text=file.foldername;
        cell.detailTextLabel.text=[NSString stringWithFormat:@"%@", file.totalfiles];
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    }
    
    
    
    if(file.type==0){
        cell.imageView.image=[UIImage imageNamed:@"UIButtonBarOrganizeLandscape"];
    }
    else{
        cell.imageView.image=[UIImage imageNamed:@"empty_picture.png"];
        // [cell setMessage:message_data];
        if ([file.contenttype isEqualToString:@"image/png"] || [file.contenttype isEqualToString:@"image/jpg"] || [file.contenttype isEqualToString:@"image/jpeg"]) {
            //if (file.fileimage.length>0) {
            dispatch_queue_t imageQueue = dispatch_queue_create("Image File",NULL);
            dispatch_async(imageQueue, ^{
                
                //NSURL *url = [NSURL URLWithString:urlString];
                // NSLog(@"message_data=%@",message_data.sender_imagefileuid);
               // NSData *imageData = [_dataModel fileStoreGetSetData:file.fileuid contentType:file.contenttype contentLength:file.filesize isStream:NO];//[NSData dataWithContentsOfURL:url];
                
                NSData *imageData=nil;
                
                NSString *filePath=[[AppDelegate getImagesPath] stringByAppendingPathComponent:file.filename];
                
                if([[NSFileManager defaultManager] fileExistsAtPath:filePath]){
                    //cell.productImage.image=[[UIImage alloc] initWithContentsOfFile:filePath];
                    imageData=[NSData dataWithContentsOfFile:filePath];

                
                // UIImage *image = [UIImage imageWithData:imageData];
                
                //NSUInteger imageIndex = [images indexOfObject:urlString];
                //UIImageView *imageVIew =cell.photo; //(UIImageView *)[self.view viewWithTag:imageIndex];
                
                //if (!imageVIew) return;
                if(!cell.imageView)
                    return;
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    // Update the UI
                    //[imageVIew setImage:image];
                    if(imageData)
                        [cell.imageView setImage:[UIImage imageWithData:imageData]];
                });
                
            });
            //}
        }
        else{
            if (file.fileuid.length>0 && file.fileimage.length>0) {
                /*dispatch_queue_t imageQueue = dispatch_queue_create("Image File",NULL);
                dispatch_async(imageQueue, ^{
                    
                    NSData *imageData=nil;
                    //NSData *imageData = [_dataModel fileStoreGetSetData:file.fileimage contentType:file.contenttype contentLength:file.filesize isStream:NO];//[NSData dataWithContentsOfURL:url];
                    NSString *filePath=[[AppDelegate getImagesPath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@"] product.pictureFile];
                    //check if cached
                    if([[NSFileManager defaultManager] fileExistsAtPath:filePath]){
                        //cell.productImage.image=[[UIImage alloc] initWithContentsOfFile:filePath];
                        imageData=[NSData dataWithContentsOfFile:filePath];
                                       if(!cell.imageView)
                        return;
                    }
                    dispatch_async(dispatch_get_main_queue(), ^{
                        // Update the UI
                        //[imageVIew setImage:image];
                        if(imageData)
                            [cell.imageView setImage:[UIImage imageWithData:imageData]];
                    });
                    
                });
                 */
            }
        }
    }
    
    /*if(file.fileuid.length>0 && file.filecontentlength>0)
     [cell setBroadcastMessageWithMedia:message myPhoto:_myPhoto otherPhoto:_otherPhoto mediaImage:_mediaIcon];
     else
     [cell setBroadcastMessage:message myPhoto:_myPhoto otherPhoto:_otherPhoto];
     */
    
    UIImage *background = [self cellBackgroundForRowAtIndexPath:indexPath];
    UIImageView *cellBackgroundView = [[UIImageView alloc] initWithImage:background];
    cellBackgroundView.image = background;
    cell.backgroundView = cellBackgroundView;
    
    return cell;
}

- (UITableViewCell *)loadingCell {
    //UITableViewCell *cell = [[[UITableViewCell alloc]
    //  initWithStyle:UITableViewCellStyleDefault
    //  reuseIdentifier:nil] autorelease];
    UITableViewCell *cell = [[UITableViewCell alloc]
                             initWithStyle:UITableViewCellStyleDefault
                             reuseIdentifier:nil] ;
    
    UIActivityIndicatorView *activityIndicator =
    [[UIActivityIndicatorView alloc]
     initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityIndicator.center = cell.center;
    [cell addSubview:activityIndicator];
    //[activityIndicator release];
    
    [activityIndicator startAnimating];
    
    cell.tag = kLoadingCellTag;
    
    return cell;
}

- (UITableViewCell *)loadingCellUp {
    //UITableViewCell *cell = [[[UITableViewCell alloc]
    //  initWithStyle:UITableViewCellStyleDefault
    //  reuseIdentifier:nil] autorelease];
    UITableViewCell *cell = [[UITableViewCell alloc]
                             initWithStyle:UITableViewCellStyleDefault
                             reuseIdentifier:nil] ;
    
    UIActivityIndicatorView *activityIndicator =
    [[UIActivityIndicatorView alloc]
     initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityIndicator.center = cell.center;
    [cell addSubview:activityIndicator];
    //[activityIndicator release];
    
    [activityIndicator startAnimating];
    
    cell.tag = kLoadingCellPageUpTag;
    
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row < myFiles.count) {
        if(indexPath.row==0 && _currentPage>[self pageOffset] && myFiles.count<MAX_ROWS)
            return [self loadingCellUp];
        else
            return [self itemCellForRowAtIndexPath:indexPath];
    }
    else {
        return [self loadingCell];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (cell.tag==kLoadingCellPageUpTag) {
        _currentPage=_currentPage-[self pageOffset];
        [self fetchFilesFromServer:SCROLL_UP];
    }
    else if (cell.tag == kLoadingCellTag) {
        /*
         NSIndexPath *firstRow=[NSIndexPath indexPathForRow:0 inSection:0];
         [self.tableView scrollToRowAtIndexPath:firstRow atScrollPosition:UITableViewScrollPositionTop animated:YES];
         */
        //[_messages removeAllObjects];
        //_messages=nil;
        // [self.tableView reloadData];
        if(myFiles.count<=MAX_ROWS)
            _currentPage++;
        else
            _currentPage=_currentPage+2;
        
        [self fetchFilesFromServer:SCROLL_DOWN];
        
        
    }
}
/*
 -(void)fetchMessages:(NSUInteger)scroll{
 
 // NSUInteger count=[_dataModel broadcastMessageCount];
 //if db is less then it means it was stipped so we fill it up;
 if(scroll==SCROLL_UP)
 
 [self fetchMessagesFromServer:SCROLL_UP];
 
 else{
 [self fetchMessagesFromServer:SCROLL_DOWN];
 }
 }
 */

-(void)fetchFilesFromServer:(NSUInteger)scroll{
    
    //    if (_dataModel.userInfo.devicetoken==nil)
    //	{
    //		_dataModel.userInfo.devicetoken=[[[NSUUID UUID] UUIDString] lowercaseString];
    //        [_dataModel.context save:nil];
    //	}
    NSDictionary *params;
    if(_folderid!=nil && [_folderid longValue]>0)
        params = @{@"cmd":@"135",
                   //@"user_id":[_dataModel userId],
                   @"usertoken": _appDelegate.appConfig.user_userToken,// _dataModel.userInfo.userToken,
                   @"folderid":_folderid,
                   @"contenttypefilter":(self.contenTypeFilter==nil)?@"":self.contenTypeFilter,
                   @"pageindex":[NSNumber numberWithLong:_currentPage],//_dataModel.userInfo.password
                   @"pagesize":[NSNumber numberWithLong:ROWS_PER_PAGE]
                   };
    else
        params = @{@"cmd":@"135",
                   //@"user_id":[_dataModel userId],
                   @"usertoken": _appDelegate.appConfig.user_userToken,//_dataModel.userInfo.userToken,
                   //@"folderid":_dataModel.selectedFolder.folderid,
                   @"pageindex":[NSNumber numberWithLong:_currentPage],//_dataModel.userInfo.password
                   @"pagesize":[NSNumber numberWithLong:ROWS_PER_PAGE]
                   };
    
    [_client postPath:@"/api/index"
                     parameters:params
                        success:^(AFHTTPRequestOperation *operation, id responseObject) {
                            
                            if ([self isViewLoaded]) {
                                //[MBProgressHUD hideHUDForView:self.view animated:YES];
                                if([operation.response statusCode] != 200) {
                                    [AppDelegate ShowErrorAlert:NSLocalizedString(@"There was an error communicating with the server", nil)];
                                }
                                else {
                                    
                                    //NSLog(operation.responseString);
                                    
                                    NSError* error;
                                    NSDictionary* json=[NSJSONSerialization JSONObjectWithData:operation.responseData options:kNilOptions error:&error];
                                    //NSDictionary* VLDirectory=[json objectForKey:@"VLDirectory"];
                                    NSNumber* success=[json objectForKey:@"success"];
                                    if([success intValue]==1){
                                        
                                        NSNumber *count=DICT_GET(json, @"count"); //[json objectForKey:@"count"];
                                        
                                        if(count==nil)
                                            return;
                                        
                                        // if(count!=nil){
                                        _count=[count longValue];
                                        //_dataModel.selectedFolder.totalfiles =count;
                                        myFilesCount =_count;
                                        
                                        //[_dataModel.context save:nil];
                                        if(_count<=ROWS_PER_PAGE)
                                            _totalPages=1;
                                        else{
                                            
                                            if ((_count % ROWS_PER_PAGE)==0)
                                                _totalPages=_count/ROWS_PER_PAGE;
                                            else
                                                _totalPages=(_count/ROWS_PER_PAGE)+1;
                                        }
                                        
                                        //  }
                                        
                                        _folderid=DICT_GET(json, @"folderid");
                                        _foldername=DICT_GET(json, @"foldername");
                                        
                                        _parentfolderid=DICT_GET(json,@"parent_folderid");
                                        _parentfoldername=DICT_GET(json,@"parent_foldername");
                                        
                                        if (_folderid==nil && _parentfolderid==nil) {
                                            //_upfolderButtonItem=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"UINavigationBarBackIndicatorDefault"] style:UIBarButtonItemStyleBordered target:self action:@selector(actionMenu)];
                                            self.title=@"Sharecle Drive";
                                            self.navigationItem.leftBarButtonItem = nil;
                                        }
                                        else{
                                            self.title=_foldername;
                                            _upfolderButtonItem=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"UINavigationBarBackIndicatorDefault"] style:UIBarButtonItemStyleBordered target:self action:@selector(upFolder)];
                                            self.navigationItem.leftBarButtonItem = _upfolderButtonItem;
                                            
                                            //_upfolderButtonItem.title=(_parentfolderid==nil)?@"Sharecle Drive":_parentfoldername;
                                        }
                                        
                                        
                                        NSArray *jsonArray=[json objectForKey:@"files"];
                                        
                                        if(jsonArray!=nil){
                                            
                                            [self saveOrUpdateMyFilesFromWeb:jsonArray];
                                            
                                            if(myFiles.count>MAX_ROWS){
                                                if(scroll==SCROLL_UP){
                                                    //for (NSUInteger i=_messages.count-MAX_ROWS ; i<_messages.count; i++) {
                                                    NSUInteger j=myFiles.count-MAX_ROWS;
                                                    for (NSUInteger i=0 ; i<j; i++) {
                                                        
                                                        [myFiles removeObjectAtIndex:MAX_ROWS];
                                                    }
                                                }
                                                else{
                                                    for (NSUInteger i=0 ; i<ROWS_PER_PAGE; i++) {
                                                        
                                                        [myFiles removeObjectAtIndex:0];
                                                    }
                                                }
                                            }
                                            
                                            //_messages=[_dataModel broadcastMessagesGetAll];
                                            //_currentDate= ((BroadcastMessage *)[_messages lastObject]).createdon;
                                            
                                            
                                            [self.tableView reloadData];
                                        }
                                        else{
                                            [self.tableView reloadData];
                                        }
                                        
                                        
                                    }
                                }
                            }
                        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                            if ([self isViewLoaded]) {
                                //[MBProgressHUD hideHUDForView:self.view animated:YES];
                                [AppDelegate ShowErrorAlert:[error localizedDescription]];
                            }
                        }];
}

/*-(void)initMessagesWithChannelFromServer{
 
 if (_dataModel.userInfo.devicetoken==nil)
	{
 _dataModel.userInfo.devicetoken=[[[NSUUID UUID] UUIDString] lowercaseString];
 [_dataModel.context save:nil];
	}
 
 
 NSDictionary *params = @{@"cmd":@"118.1",
 //@"user_id":[_dataModel userId],
 @"usertoken": _dataModel.userInfo.userToken,
 @"channelid":_dataModel.selectedBroadcast.channelid,
 @"pageindex":@1,//_dataModel.userInfo.password
 @"pagesize":@ROWS_PER_PAGE
 };
 
 [_dataModel.client postPath:@"/api/index"
 parameters:params
 success:^(AFHTTPRequestOperation *operation, id responseObject) {
 
 if ([self isViewLoaded]) {
 //[MBProgressHUD hideHUDForView:self.view animated:YES];
 if([operation.response statusCode] != 200) {
 ShowErrorAlert(NSLocalizedString(@"There was an error communicating with the server", nil));
 }
 else {
 
 //NSLog(operation.responseString);
 
 NSError* error;
 NSDictionary* json=[NSJSONSerialization JSONObjectWithData:operation.responseData options:kNilOptions error:&error];
 //NSDictionary* VLDirectory=[json objectForKey:@"VLDirectory"];
 NSNumber* success=[json objectForKey:@"success"];
 if([success intValue]==1){
 
 NSNumber *count=DICT_GET(json, @"count"); //[json objectForKey:@"count"];
 if(count!=nil){
 _dataModel.selectedBroadcast.totalmessages=count;
 _count=[count longValue];
 //[_dataModel.context save:nil];
 if(_count<=ROWS_PER_PAGE)
 _totalPages=1;
 else{
 
 if ((_count % ROWS_PER_PAGE)==0)
 _totalPages=_count/ROWS_PER_PAGE;
 else
 _totalPages=(_count/ROWS_PER_PAGE)+1;
 }
 
 
 
 }
 
 NSArray *jsonArray=[json objectForKey:@"messages"];
 
 if(jsonArray!=nil){
 
 [self saveOrUpdateMyBroadcastMessagesFromWeb:jsonArray];
 
 
 
 //[self.tableView reloadData];
 }
 
 
 
 
 }
 }
 }
 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
 if ([self isViewLoaded]) {
 //[MBProgressHUD hideHUDForView:self.view animated:YES];
 ShowErrorAlert([error localizedDescription]);
 }
 }];
 }
 */


-(void)saveOrUpdateMyFilesFromWeb:(NSArray *)files{
    if (myFiles==nil) {
        myFiles=[NSMutableArray array];
    }
    for(id fileDictionary in files){
        MyFile *file = [[MyFile alloc] initWithDictionary:fileDictionary];
        
        if (![myFiles containsObject:file]) {
            
            [myFiles addObject:file];
            
            //file store
            //check for files
            
            //autoplay
            /*NSFetchRequest *fetchFS=[[NSFetchRequest alloc] initWithEntityName:@"FileStore"];
             NSPredicate *predicateFS;
             NSArray *resultFS;
             if (message.fileuid.length>0) {
             
             predicateFS=[NSPredicate predicateWithFormat:@"fileuid==%@",message.fileuid];
             
             [fetchFS setPredicate:predicateFS];
             
             resultFS=[_dataModel.context executeFetchRequest:fetchFS error:nil];
             
             if(resultFS!=nil || [resultFS count]==0){
             FileStore *fs=[_dataModel fileStoreInit:message.fileuid];
             if(fs!=nil){
             
             fs.contenttype=message.filecontenttype;
             fs.size=message.filecontentlength;
             
             
             }
             [_dataModel.context save:nil];
             }
             }
             //attachment
             if (message.imagefileuid.length>0) {
             predicateFS=[NSPredicate predicateWithFormat:@"fileuid==%@",message.imagefileuid];
             
             [fetchFS setPredicate:predicateFS];
             
             resultFS=[_dataModel.context executeFetchRequest:fetchFS error:nil];
             
             if(resultFS!=nil || [resultFS count]==0){
             FileStore *fs=[_dataModel fileStoreInit:message.fileuid]; //[NSEntityDescription insertNewObjectForEntityForName:@"FileStore" inManagedObjectContext:self.context];
             if(fs!=nil){
             //fs.fileuid=message.imagefileuid;
             fs.contenttype=message.imagefilecontenttype;
             fs.size=message.imagefilecontentlength;
             fs.filename=[NSString stringWithFormat:@"%@%@",message.imagefileuid,[_dataModel fileStoreGetFile:fs.contenttype]];
             //fs.filename=message.imagefilename;
             }
             [_dataModel.context save:nil];
             }
             }
             */
            
        }
        
    }
    
    NSSortDescriptor *sortDescriptor;
    sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"filename"
                                                 ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    //NSArray *sortedArray;
    myFiles = [[myFiles sortedArrayUsingDescriptors:sortDescriptors] mutableCopy];
    
}

- (void) upFolder{
    
    /*if ([_dataModel.myBroadcastChannels count]>0)
     self.navigationItem.rightBarButtonItems=@[addButton,self.editButtonItem];
     else
     self.navigationItem.rightBarButtonItems=@[addButton];
     */
    _folderid=_parentfolderid;
    [myFiles removeAllObjects];
    _currentPage=1;
    [self fetchFilesFromServer:SCROLL_UP];
}


/*
 - (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
 {
 NSString *sectionName;
 switch (section)
 {
 case 0:
 sectionName = [NSString stringWithFormat:@"#%@  %@",_dataModel.selectedBroadcast.channelid, (_dataModel.selectedBroadcast.title.length==0)?_dataModel.selectedBroadcast.channelid:_dataModel.selectedBroadcast.title];//NSLocalizedString(@"mySectionName", @"mySectionName");
 break;
 }
 return sectionName;
 }
 */
/*- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
 
 [super setEditing:editing animated:animated];
 
 [self.tableView setEditing:editing animated:YES];
 
 if (editing) {
 
 //  addButton.enabled = NO;
 
 
 } else {
 
 // addButton.enabled = YES;
 //self.editButtonItem.title=@"DropOut";
 
 //reloading will perform cleanup like messages marked for deletion
 //[_dataModel loadBroadcastMessages];
 
 
 }
 
 }
 */
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(myFiles==nil || [myFiles count]==0){
        //rom: we shouldnt reach this, if we do something had happen with memory
        [self refresh];
        return;
    }
    selectedFile =[myFiles objectAtIndex:indexPath.row];
    if(selectedFile==nil)
        return;
    if(selectedFile.type==MyFileTypeFolder){
        if(![_folderid isEqualToNumber:selectedFile.folderid]){
            [myFiles removeAllObjects];
            //_parentfolderid=_folderid;
        }
        _folderid=selectedFile.folderid;
        _currentPage=1;
        [self fetchFilesFromServer:SCROLL_UP];
        return;
    }
    
    else if ([selectedFile.contenttype isEqualToString:@"image/png"] || [selectedFile.contenttype isEqualToString:@"image/jpg" ]
             || [selectedFile.contenttype isEqualToString:@"image/jpeg"]
             ) {
        _photoActionSheet = [[UIActionSheet alloc]
                             initWithTitle: nil
                             delegate:self
                             cancelButtonTitle:@"Cancel"
                             destructiveButtonTitle: nil
                             //otherButtonTitles:([nextMessage.isplayed isEqualToNumber:@1])?MENU_ITEM_REPLAY:MENU_ITEM_PLAY,MENU_ITEM_REPLYTOUSER, MENU_ITEM_ABOUTUSER,MENU_ITEM_BLOCKUSER, NULL];
                             //otherButtonTitles:@"Copy",@"Delete",NULL];
                             otherButtonTitles:@"Copy to device",@"Rename",NULL];
        [_photoActionSheet showInView:[self.view window] ];
        
    }
    //    else{
    //        _photoActionSheet = [[UIActionSheet alloc]
    //                             initWithTitle: nil
    //                             delegate:self
    //                             cancelButtonTitle:@"Cancel"
    //                             destructiveButtonTitle: nil
    //                             //otherButtonTitles:([nextMessage.isplayed isEqualToNumber:@1])?MENU_ITEM_REPLAY:MENU_ITEM_PLAY,MENU_ITEM_REPLYTOUSER, MENU_ITEM_ABOUTUSER,MENU_ITEM_BLOCKUSER, NULL];
    //                             otherButtonTitles:@"Delete",NULL];
    //
    //    }
    
    //[_properties setValue:selectedFile forKey:MyFileControllerSelectedFile];
    // [self.delegate myDriveController:self didFinishPickingFileWithInfo:_properties];
}


- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // SimpleEditableListAppDelegate *controller = (SimpleEditableListAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    //if (indexPath.row == [_dataModel.allBroadcastChannels count]-1){//[self.tableView.delegate countOfList]-1) {
    
    
    //return UITableViewCellEditingStyleInsert;
    
    //} else {
    
    return UITableViewCellEditingStyleDelete;
    
    // }
    
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    
    [super setEditing:editing animated:animated];
    
    [self.tableView setEditing:editing animated:YES];
    
    if (editing) {
        
        //  addButton.enabled = NO;
        self.editButtonItem.image=nil;
        
    } else {
        
        // addButton.enabled = YES;
        //self.editButtonItem.title=@"DropOut";
        
        //reloading will perform cleanup like messages marked for deletion
        //[_dataModel loadBroadcastMessages];
        self.editButtonItem.image=[UIImage imageNamed:@"UIButtonBarTrashLandscape"];
        self.editButtonItem.title=nil;
        
    }
    
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // If row is deleted, remove it from the list.
    //MyFile *file=[_dataModel.myFiles objectAtIndex:indexPath.row]
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //[_deleteFiles addObject:<#(id)#>]
        // [self postDeleteSelectedFile:file];
        MyFile *deleteFile =[myFiles objectAtIndex:indexPath.row];
        
        if(deleteFile==nil)
            return;
        if(deleteFile.type==MyFileTypeFolder){
            /*
             if(![_folderid isEqualToNumber:selectedFile.folderid]){
             [_dataModel.myFiles removeAllObjects];
             
             }
             
             _folderid=selectedFile.folderid;
             _currentPage=1;
             [self fetchFilesFromServer:SCROLL_UP];
             return;
             */
            /* UIAlertView * alert =[[UIAlertView alloc ] initWithTitle: @"Delete Folder"
             message:[NSString stringWithFormat:@"Delete folder %@ and it's contents?",selectedFile.foldername]
             delegate:self
             cancelButtonTitle:@"Cancel"
             otherButtonTitles: nil];
             [alert addButtonWithTitle:@"Delete"];
             [alert show];
             */
            [self postDeleteSelectedFolder:deleteFile];
            
        }
        else
            [self postDeleteSelectedFile:deleteFile];
    }
    
}

- (UIImage *)cellBackgroundForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger rowCount = [self tableView:[self tableView] numberOfRowsInSection:0];
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
/*
 - (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
 {
 //NSLog(@"Button Index =%ld",buttonIndex);
 //if (buttonIndex == 0)
 //{
 //   NSLog(@"You have clicked Cancel");
 //}
 if(buttonIndex == 1)
 {
 [self postDeleteSelectedFile:selectedFile];
 }
 }
 */
-(void) postDeleteSelectedFile:(MyFile *)file{
    
    MBProgressHUD* hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = NSLocalizedString(@"Deleting...", nil);
    
    NSDictionary *params = @{@"cmd":@"135.1",
                             @"usertoken":_appDelegate.appConfig.user_userToken,//_dataModel.userInfo.userToken,
                             @"fileid":file.fileid
                             };
    
    [_client postPath:@"/api/index"
           parameters:params
              success:^(AFHTTPRequestOperation *operation, id responseObject) {
                  if ([self isViewLoaded])
                      [MBProgressHUD hideHUDForView:self.view animated:YES];
                  
                  if([operation.response statusCode] != 200) {
                      //ShowErrorAlert(NSLocalizedString(@"There was an error communicating with the server", nil));
                      NSLog(NSLocalizedString(@"There was an error communicating with the server", nil));
                      
                  }
                  else {
                      if(operation.responseString==nil)
                          return;
                      
                      
                      NSError* error;
                      NSDictionary* json=[NSJSONSerialization JSONObjectWithData:operation.responseData options:kNilOptions error:&error];
                      
                      NSNumber* success=[json objectForKey:@"success"];
                      if([success intValue]==1){
                          
                          // NSString* json_messageuid=[json objectForKey:@"messageuid"];
                          
                          // [self deleteSelectedFileFromWeb:json_messageuid];
                          [myFiles removeAllObjects];
                          _currentPage=0;
                          [self.tableView reloadData];
                          
                          
                      }
                      else{
                          //NSLog(@"Delete broadcast message failed. %@",[json objectForKey:@"error"]);
                          [AppDelegate ShowErrorAlert:@"Delete failed."];
                      }
                  }
                  //}
                  
              } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                  if ([self isViewLoaded])
                      [MBProgressHUD hideHUDForView:self.view animated:YES];
                  //[MBProgressHUD hideHUDForView:self.view animated:YES];
                  
                  
                  [AppDelegate ShowErrorAlert:[error localizedDescription]];
                  //NSLog([NSString stringWithFormat:@"%@", error]);
                  
              }
     
     ];
    
}

-(void) postDeleteSelectedFolder:(MyFile *)file{
    
    MBProgressHUD* hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = NSLocalizedString(@"Deleting...", nil);
    
    NSDictionary *params = @{@"cmd":@"135.2",
                             @"usertoken":_appDelegate.appConfig.user_userToken,// _dataModel.userInfo.userToken,
                             @"folderid":file.folderid
                             };
    
    [_client postPath:@"/api/index"
           parameters:params
              success:^(AFHTTPRequestOperation *operation, id responseObject) {
                  if ([self isViewLoaded])
                      [MBProgressHUD hideHUDForView:self.view animated:YES];
                  
                  if([operation.response statusCode] != 200) {
                      //ShowErrorAlert(NSLocalizedString(@"There was an error communicating with the server", nil));
                      NSLog(NSLocalizedString(@"There was an error communicating with the server", nil));
                      
                  }
                  else {
                      if(operation.responseString==nil)
                          return;
                      
                      
                      NSError* error;
                      NSDictionary* json=[NSJSONSerialization JSONObjectWithData:operation.responseData options:kNilOptions error:&error];
                      
                      NSNumber* success=[json objectForKey:@"success"];
                      if([success intValue]==1){
                          
                          // NSString* json_messageuid=[json objectForKey:@"messageuid"];
                          
                          // [self deleteSelectedFileFromWeb:json_messageuid];
                          [myFiles removeAllObjects];
                          _currentPage=0;
                          [self.tableView reloadData];
                          
                          
                      }
                      else{
                          //NSLog(@"Delete broadcast message failed. %@",[json objectForKey:@"error"]);
                          [AppDelegate ShowErrorAlert:@"Delete failed."];
                      }
                  }
                  //}
                  
              } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                  if ([self isViewLoaded])
                      [MBProgressHUD hideHUDForView:self.view animated:YES];
                  //[MBProgressHUD hideHUDForView:self.view animated:YES];
                  
                  
                  [AppDelegate ShowErrorAlert:[error localizedDescription]];
                  //NSLog([NSString stringWithFormat:@"%@", error]);
                  
              }
     
     ];
    
}

-(void) postAddNewFolder:(NSString *)newfoldername{
    
    MBProgressHUD* hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = NSLocalizedString(@"Add folder...", nil);
    NSDictionary *params;
    if(_folderid!=nil && [_folderid longValue]>0)
        params = @{@"cmd":@"135.3",
                   @"usertoken":_appDelegate.appConfig.user_userToken,//_dataModel.userInfo.userToken,
                   @"parentfolderid":_folderid,
                   @"newfoldername":newfoldername
                   };
    else
        params = @{@"cmd":@"135.3",
                   @"usertoken":_appDelegate.appConfig.user_userToken,//_dataModel.userInfo.userToken,
                   // @"parentfolderid":_folderid,
                   @"newfoldername":newfoldername
                   };
    
    [_client postPath:@"/api/index"
           parameters:params
              success:^(AFHTTPRequestOperation *operation, id responseObject) {
                  if ([self isViewLoaded])
                      [MBProgressHUD hideHUDForView:self.view animated:YES];
                  
                  if([operation.response statusCode] != 200) {
                      //ShowErrorAlert(NSLocalizedString(@"There was an error communicating with the server", nil));
                      NSLog(NSLocalizedString(@"There was an error communicating with the server", nil));
                      
                  }
                  else {
                      if(operation.responseString==nil)
                          return;
                      
                      
                      NSError* error;
                      NSDictionary* json=[NSJSONSerialization JSONObjectWithData:operation.responseData options:kNilOptions error:&error];
                      
                      NSNumber* success=[json objectForKey:@"success"];
                      if([success intValue]==1){
                          /*
                           [_dataModel.myFiles removeAllObjects];
                           _currentPage=0;
                           [self.tableView reloadData];
                           */
                          NSDictionary *folder=[json objectForKey:@"folder"];
                          if (folder==(id)[NSNull null]) {
                              [self refresh];
                              return;
                          }
                          
                          MyFile *newfolder=[[MyFile alloc] initWithDictionary:folder];
                          if(newfolder.type==MyFileTypeFolder){
                              if(![_folderid isEqualToNumber:newfolder.folderid]){
                                  [myFiles removeAllObjects];
                                  //_parentfolderid=_folderid;
                              }
                              _folderid=newfolder.folderid;
                              _currentPage=1;
                              [self fetchFilesFromServer:SCROLL_UP];
                              
                              [self refresh];
                              return;
                          }
                          
                          
                      }
                      else{
                          //NSLog(@"Delete broadcast message failed. %@",[json objectForKey:@"error"]);
                          [AppDelegate ShowErrorAlert:@"Add folder failed."];
                      }
                  }
                  //}
                  
              } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                  if ([self isViewLoaded])
                      [MBProgressHUD hideHUDForView:self.view animated:YES];
                  //[MBProgressHUD hideHUDForView:self.view animated:YES];
                  
                  
                  [AppDelegate ShowErrorAlert:[error localizedDescription]];
                  //NSLog([NSString stringWithFormat:@"%@", error]);
                  
              }
     
     ];
    
}


/*
 -(void)deleteSelectedFileFromWeb:(NSString*) fileuid{
 
 if( fileuid==(id)[NSNull null] || fileuid==nil || fileuid.length==0)
 return ;
 NSPredicate *predicateContactMessage=[NSPredicate predicateWithFormat:@"fileuid = %@",fileuid];
 
 NSArray  *results = [_dataModel.myFiles filteredArrayUsingPredicate:predicateContactMessage]; //[_context
 if(results!=nil && [results count]>0 ){
 for(MyFile *item in results){
 
 [_dataModel.myFiles removeObject:item];
 }
 }
 [self.tableView reloadData];
 
 }
 */
/*
 - (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
 {
 
 // UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
	//UITableViewCell *cell= [self.tableView cellForRowAtIndexPath:indexPath];
 // if (cell.tag==kLoadingCellTag || cell.tag==kLoadingCellPageUpTag)
 //    return 44;
 
 if (indexPath.row < _dataModel.myFiles.count) {
 MyFile* file = (_dataModel.myFiles)[indexPath.row];
 if([file.status isEqualToNumber:@-1])
 return 0;
 CGSize bubbleSize = [SpeechBubbleView sizeForText:message.text];
 file.bubbleSizeheight=[NSNumber numberWithFloat:bubbleSize.height];
 file.bubbleSizewidth=[NSNumber numberWithFloat:bubbleSize.width];
 
 
 return [message.bubbleSizeheight floatValue] + 16;
 }
 else
 return 44;
 
 
 }
 */


/*
 - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
 {
 UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
 
 // Configure the cell...
 
 return cell;
 }
 */

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
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
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
//- (IBAction)actionAddRemoveImage:(id)sender {
//    // if (_dataModel.broadcastChannels.count > 0){
//    //if(_btnAddRemoveImage.tag==0){ //add
//
//        _photoActionSheet = [[UIActionSheet alloc]
//                             initWithTitle: nil
//                             delegate:self
//                             cancelButtonTitle:@"Cancel"
//                             destructiveButtonTitle: nil
//                             otherButtonTitles:@"Take Photo",@"Select Photo",@"Select Photo from Sharecle Drive", NULL];
//        //    }
//        //    else{
//        //        _photoActionSheet = [[UIActionSheet alloc]
//        //                            initWithTitle: nil
//        //                            delegate:self
//        //                            cancelButtonTitle:@"Cancel"
//        //                            destructiveButtonTitle: nil
//        //                            otherButtonTitles:@"TuneIn", NULL];
//        //    }
//        [_photoActionSheet showInView:[self.view window] ];
//   /* }
//    else{ //remove
//        self.attachPhoto.image=nil;
//        _hasImage=NO;
//        //_btnRemoveImage.hidden=YES;
//        //_btnAddImage.hidden=NO;
//        _btnAddRemoveImage.tag=0;
//        [_btnAddRemoveImage setImage:[UIImage imageNamed:@"ic_action_new_picture.png"] forState:UIControlStateNormal];
//    }
//    */
//}

- (IBAction)actionAddPhoto:(id)sender {
    //[self dismissViewControllerAnimated:YES completion:nil];
    if (_folderid==nil && _parentfolderid==nil) {
        
        [self addNewFolderAction];
        
    }
    else{
        _photoActionSheet = [[UIActionSheet alloc]
                             initWithTitle: nil
                             delegate:self
                             cancelButtonTitle:@"Cancel"
                             destructiveButtonTitle: nil
                             otherButtonTitles:@"Take Photo",@"Select Photo",@"New Folder", NULL];
        //    }
        //    else{
        //        _photoActionSheet = [[UIActionSheet alloc]
        //                            initWithTitle: nil
        //                            delegate:self
        //                            cancelButtonTitle:@"Cancel"
        //                            destructiveButtonTitle: nil
        //                            otherButtonTitles:@"TuneIn", NULL];
        //    }
        // [_photoActionSheet showInView:[self.view window] ];
    }
    [_photoActionSheet showInView:self.parentViewController.view ];
    
}

- (IBAction)actionSynch:(id)sender {
    /*
     _photoActionSheet = [[UIActionSheet alloc]
     initWithTitle: nil
     delegate:self
     cancelButtonTitle:@"Cancel"
     destructiveButtonTitle: nil
     otherButtonTitles:@"Take Photo",@"Select Photo",@"Add New Folder", NULL];
     
     [_photoActionSheet showInView:[self.view window] ];
     */
    // NSData *imageData=[_dataModel fileStoreGetSetData:message.imagefileuid contentType:message.imagefilecontenttype contentLength:message.imagefilecontentlength isStream:NO];
    
    
}

-(void)refresh{
    _currentPage=0;
    [myFiles removeAllObjects];
    [self.tableView reloadData];
}

- (IBAction)actionRefresh:(id)sender {
    
    //[self fetchFilesFromServer: SCROLL_UP];
    [self refresh];
    
}
-(void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{
    //-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    /*if(buttonIndex == 0){
     [self takePhotoActionn];
     }
     else if(buttonIndex == 1){
     
     [self selectPhotoAction];
     }
     else if(buttonIndex == 2){
     
     [self addNewFolderAction];
     }
     
     else if(buttonIndex == 3){
     // cancel the operation
     [actionSheet dismissWithClickedButtonIndex:3 animated:YES];
     }
     */
    
    NSString *title= [actionSheet buttonTitleAtIndex:buttonIndex];
    
    
    //otherButtonTitles:([_message.isplayed isEqualToNumber:@1])?@"Re-play":@"Play",@"View Attached Photo",@"Reply to this user", @"About this user",@"Block this user", NULL];
    
    if([title isEqualToString:@"Copy to device"]){
       /* NSData *data= [_dataModel fileStoreGetSetData:selectedFile.fileuid contentType:selectedFile.contenttype contentLength:selectedFile.filesize isStream:false];
        if(data)
            UIImageWriteToSavedPhotosAlbum([UIImage imageWithData:data],
                                           self,
                                           @selector(actionSaveDone),
                                           nil);
        
        */
    }
    else if([title isEqualToString:@"Rename"]){
        [self renameFileAction];
    }
    else if([title isEqualToString:@"New Folder"]){
        [self addNewFolderAction];
    }
    else if([title isEqualToString:@"Take Photo"]){
        [self takePhotoActionn];
    }
    else if([title isEqualToString:@"Select Photo"]){
        [self selectPhotoAction];
    }
    else
        [actionSheet dismissWithClickedButtonIndex:actionSheet.cancelButtonIndex animated:YES];
    
}

-(void)takePhotoActionn{
    if(![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera ]){
        UIAlertView *myAlertView=[[UIAlertView alloc] initWithTitle:@"Error" message:@"Device has no camera" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [myAlertView show];
    }
    else
    {
        UIImagePickerController *picker=[[UIImagePickerController alloc] init];
        picker.modalPresentationStyle=UIModalPresentationCurrentContext;
        picker.delegate=self;
        picker.allowsEditing=YES;
        picker.sourceType=UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:picker animated:YES
                         completion:NULL];
    }
}

-(void)selectPhotoAction{
    UIImagePickerController *picker=[[UIImagePickerController alloc] init];
    picker.modalPresentationStyle=UIModalPresentationCurrentContext;
    picker.delegate=self;
    picker.allowsEditing=YES;
    picker.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:picker animated:YES
                     completion:NULL];
}

-(void)addNewFolderAction{
    alertAddfolder =[[UIAlertView alloc ] initWithTitle:@"New folder" message:@"Enter folder name" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles: nil];
    alertAddfolder.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alertAddfolder addButtonWithTitle:@"Add"];
    [alertAddfolder show];
}

-(void)renameFileAction{
    alertRenameFile =[[UIAlertView alloc ] initWithTitle:[NSString stringWithFormat:@"Rename %@",selectedFile.filename] message:@"Enter new filename" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles: nil];
    alertRenameFile.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alertRenameFile addButtonWithTitle:@"Rename"];
    [alertRenameFile show];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    //NSLog(@"Button Index =%ld",buttonIndex);
    if(alertView==alertAddfolder){
        if (buttonIndex == 1) {  //Add
            UITextField *foldername = [alertView textFieldAtIndex:0];
            //NSLog(@"username: %@", textfield.text);
            if (foldername.text.length>0) {
                [self postAddNewFolder:foldername.text];
            }
        }
    }
    else if(alertView==alertRenameFile){
        if (buttonIndex == 1) {  //Rename
            UITextField *filename = [alertView textFieldAtIndex:0];
            //NSLog(@"username: %@", textfield.text);
            if (filename.text.length>0) {
                [self postRenameFile:filename.text];
            }
        }
    }
}

- (void)saveFileImage:(NSData *)imageFileData
{
    if(!imageFileData)
        return;
    //[_messageTextView resignFirstResponder];
    
    /*
     ComposeData *message = [[ComposeData alloc] init];
     if([self.messageType isEqualToNumber:@2])
     message.messagetype=@2;
     else
     message.messagetype=@1;
     
     message.createdon = [NSDate date];
     
     
     message.text = self.messageTextView.text;
     message.messageuid = [[[NSUUID UUID] UUIDString] lowercaseString];
     
     //use for type 2
     message.channelid=self.channelid;
     
     
     //use for type 1
     message.recipientid =self.recipientid; //_contactInfo.userid;
     message.recipient = self.recipient; //_contactInfo.username;
     
     
     message.fileuid =nil;    message.filelen=nil;
     message.filecontenttype=nil;
     
     message.imagefileuid=nil;
     message.imagefilelen=nil;
     message.imagefilecontenttype=nil;
     
     message.senderid =_dataModel.userInfo.userid;
     message.sender = _dataModel.userInfo.username;
     
     message.userid = _dataModel.userInfo.userid;
     
     */
    /// NSData *filedata=nil;
    //NSData *imageFileData=nil;
    NSString *fileuid;
    //NSString *filecontenttype=@"image/png";
    
    NSNumber *filelen;
    @try
    {
        //   [recorder stop];
        
        // [audioSession setActive:NO error:nil];
        //_needVoiceUpload=NO;
        // _needPhotoUpload=NO;
        
        //save image locally
        
        
        //imageFileData= UIImagePNGRepresentation(_attachPhoto.image);//(uploadedImgView.image);
        if (imageFileData && imageFileData.length>0)
        {
            fileuid=[[ imageFileData MD5] uppercaseString];
            //filecontenttype=@"image/png";
            
            filelen=[NSNumber numberWithUnsignedInteger:imageFileData.length];
            
            
            /* FileStore *fs=[_dataModel fileStoreInit:fileuid];
             if(fs!=nil){
             
             
             fs.contenttype=@"image/png";
             fs.data=imageFileData;
             fs.mediatype=@"image";
             //  fs.filename=message.imagefilename;
             [_dataModel.context save:nil];
             
             }
             */
            
        }
        
    }
    @catch (NSException *e) {
        NSLog(@"Exception: %@", e);
        return;
    }
    
    /*if(imageFileData.length==0){
     //_lblMessage.text=NSLocalizedString(@"No data to send.",nil);
     ShowErrorAlert(@"Nothing to upload.");
     return;
     }
     */
    // _messageTextView.text=@"";
    
    /*
     if([_dataModel addMessageQueue:message]==NO){
     return;
     }
     */
    
    //message.status=@0;
    //message.isplayed=@0;
    
    //if(_needPhotoUpload)
    
    [self postUploadBeforeSend:fileuid fileData:imageFileData];
    //else
    //  [self postSend:message];
    
    /* [_dataModel postSendMessageRequest:message];
     [self.delegate didSaveMessageSuccess];
     //[self.navigationController popViewControllerAnimated:YES];
     [self dismissViewControllerAnimated:YES completion:nil];
     */
    
}

-(void) postUploadBeforeSend:(NSString *)fileuid fileData:(NSData *) fileData{
    
    MBProgressHUD* hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = NSLocalizedString(@"Uploading...", nil);
    if(_folderid==nil)
        _folderid=@0;
    NSDictionary *params = @{@"cmd":@"120.2",
                             @"usertoken": _appDelegate.appConfig.user_userToken,//_dataModel.userInfo.userToken,
                             @"folderid": _folderid
                             };
    
    
    
    NSMutableURLRequest *request = [_client multipartFormRequestWithMethod:@"POST" path:@"/api/index" parameters:params constructingBodyWithBlock: ^(id <AFMultipartFormData>formData) {
        
        
        // if (fileuid.length>0)
        //if(fileData)
        // {
        
        // FileStore *fs=[_dataModel fileStoreGetFile:fileuid];
        // if(fs!=nil){
        
        
        //[formData  appendPartWithFileData: fs.data name:@"attachment" fileName:fs.filename mimeType:fs.contenttype];
        //[formData  appendPartWithFileData: fs.data name:fileuid fileName:fs.filename mimeType:fs.contenttype];
        [formData  appendPartWithFileData: fileData name:fileuid fileName:[NSString stringWithFormat:@"%@.png",fileuid] mimeType:@"image/png"];
        // }
        
        // }
        
        
    }];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         
         if ([self isViewLoaded])
             [MBProgressHUD hideHUDForView:self.view animated:YES];
         
         if([operation.response statusCode] != 200){
             
             
             [AppDelegate ShowErrorAlert:@"There was an error communicating with the server"];
         }
         else {
             
             if(operation.responseString==nil)
                 return;
             
             
             NSError* error;
             NSDictionary* json=[NSJSONSerialization JSONObjectWithData:operation.responseData options:kNilOptions error:&error];
             
             
             
             NSNumber* success=[json objectForKey:@"success"];
             
             if([success intValue]==1){
                 
                 
                 //[self postSend:message];
                 [myFiles removeAllObjects];
                 _currentPage=0;
                 [self.tableView reloadData];
             }
             else{
                 // ShowErrorAlert(@"There was an error processing your request. Please try again later.");
                 
                 NSString *error_msg=[json objectForKey:@"error"];
                 if (error_msg) {
                     [AppDelegate ShowErrorAlert:error_msg];
                 }
                 else{
                     [AppDelegate ShowErrorAlert:ERROR_MSG_PROCESSING];
                 }
                 
             }
         }
         
         
         
     }
     
                                     failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         
         if ([self isViewLoaded]) {
             [MBProgressHUD hideHUDForView:self.view animated:YES];
             
             [AppDelegate ShowErrorAlert:ERROR_MSG_PROCESSING];
         }
     }];
    
    [operation start];
}

-(void) postRenameFile:(NSString *)newFileName{
    
    MBProgressHUD* hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = NSLocalizedString(@"Uploading...", nil);
    if(_folderid==nil)
        _folderid=@0;
    NSDictionary *params = @{@"cmd":@"120.3",
                             @"usertoken": _appDelegate.appConfig.user_userToken,
                             @"folderid": _folderid,
                             @"fileid":selectedFile.fileid,
                             @"newfilename":newFileName
                             
                             };
    
    
    
    [_client postPath:@"/api/index"
           parameters:params
              success:^(AFHTTPRequestOperation *operation, id responseObject) {
                  if ([self isViewLoaded])
                      [MBProgressHUD hideHUDForView:self.view animated:YES];
                  
                  if([operation.response statusCode] != 200) {
                      //ShowErrorAlert(NSLocalizedString(@"There was an error communicating with the server", nil));
                      NSLog(NSLocalizedString(@"There was an error communicating with the server", nil));
                      
                  }
                  else {
                      if(operation.responseString==nil)
                          return;
                      
                      
                      NSError* error;
                      NSDictionary* json=[NSJSONSerialization JSONObjectWithData:operation.responseData options:kNilOptions error:&error];
                      
                      NSNumber* success=[json objectForKey:@"success"];
                      if([success intValue]==1){
                          [self refresh];
                          
                      }
                      else{
                          //NSLog(@"Delete broadcast message failed. %@",[json objectForKey:@"error"]);
                          [AppDelegate ShowErrorAlert:@"Rename failed."];
                      }
                  }
                  //}
                  
              } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                  if ([self isViewLoaded])
                      [MBProgressHUD hideHUDForView:self.view animated:YES];
                  //[MBProgressHUD hideHUDForView:self.view animated:YES];
                  
                  
                  [AppDelegate ShowErrorAlert:[error localizedDescription]];
                  //NSLog([NSString stringWithFormat:@"%@", error]);
                  
              }
     
     ];
}


#pragma mark - Delegates
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    UIImage *chosenImage=info[UIImagePickerControllerEditedImage];
    NSData *data=UIImagePNGRepresentation(chosenImage);
    //self.attachPhoto.hidden=NO;
    //self.attachPhoto.image=chosenImage;
    //_hasImage=YES;
    //self.saveItem.enabled = YES;
    //_needPhotoUpload=NO;
    //_btnRemoveImage.hidden=NO;
    //_btnAddRemoveImage.tag=1; //remove
    //[_btnAddRemoveImage setImage:[UIImage imageNamed:@"UITextFieldClearButton@2x.png"] forState:UIControlStateNormal];
    
    [picker dismissViewControllerAnimated:YES completion:^{
        [self saveFileImage:data];
    }];
    
}

- (IBAction)actionSave:(id)sender {
    /*NSData *data= [_dataModel fileStoreGetSetData:selectedFile.fileuid contentType:selectedFile.contenttype contentLength:selectedFile.filesize isStream:false];
    if(data)
    
        UIImageWriteToSavedPhotosAlbum([UIImage imageWithData:data],
                                       self, // send the message to 'self' when calling the callback
                                       @selector(thisImage:hasBeenSavedInPhotoAlbumWithError:usingContextInfo:), // the selector to tell the method to call on completion
                                       NULL); // you generally won't need a contextInfo here
     */
}


- (void)thisImage:(UIImage *)image hasBeenSavedInPhotoAlbumWithError:(NSError *)error usingContextInfo:(void*)ctxInfo {
    if (error) {
        // Do anything needed to handle the error or display it to the user
        UIAlertView * alert =[[UIAlertView alloc ] initWithTitle:@"Save Error"
                                                         message:[error localizedDescription]
                                                        delegate:self
                                               cancelButtonTitle:@"OK"
                                               otherButtonTitles: nil];
        //[alert addButtonWithTitle:@"GOO"];
        [alert show];
        
    } else {
        // .... do anything you want here to handle
        // .... when the image has been saved in the photo album
        UIAlertView * alert =[[UIAlertView alloc ] initWithTitle:@"Save Success"
                                                         message:@"Image has been saved in the photo album"
                                                        delegate:self
                                               cancelButtonTitle:@"OK"
                                               otherButtonTitles: nil];
        [alert show];
    }
}

-(int)pageOffset{
  return MAX_ROWS/ROWS_PER_PAGE;
  
}

@end
