//
//  IODViewController.m
//  iOSDiner
//
//  Created by Romulo Quidilig on 3/19/15.
//  Copyright (c) 2015 Sharecle Inc. All rights reserved.
//

#import "KidsOrderViewController.h"

#import "OrderItem.h"     // <---- #1
#import "Order.h"     // <---- #1


@implementation KidsOrderViewController



@synthesize ibRemoveItemButton;
@synthesize ibAddItemButton;
@synthesize ibPreviousItemButton;
@synthesize ibNextItemButton;
@synthesize ibTotalOrderButton;
@synthesize ibSubmitButton;
@synthesize ibChalkboardLabel;
@synthesize ibCurrentItemImageView;
@synthesize ibCurrentItemLabel;
@synthesize inventory;     // <---- #2
@synthesize order;     // <---- #2

dispatch_queue_t queue; 

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

-(void)dealloc {
 //   dispatch_release(queue);
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    _appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    currentItemIndex = 0;     // <---- #3
    [self setOrder:[Order new]];     // <---- #4
    
    queue = dispatch_queue_create("com.sharecle.tido",nil); // <======
}

- (void)viewDidUnload
{
    [self setIbRemoveItemButton:nil];
    [self setIbAddItemButton:nil];
    [self setIbPreviousItemButton:nil];
    [self setIbNextItemButton:nil];
    [self setIbTotalOrderButton:nil];
    [self setIbChalkboardLabel:nil];
    [self setIbCurrentItemImageView:nil];
    [self setIbCurrentItemLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self updateInventoryButtons]; // <---- Add

    [ibChalkboardLabel setText:@"Loading Inventory..."];
    
    dispatch_async(queue, ^{
        [self setInventory:[[Order retrieveInventoryItems:[NSString stringWithFormat:@"%@inventory",_appDelegate.mcManager.serverPeerInfo.homeUrl]] mutableCopy]];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self updateOrderBoard]; // <---- Add
            [self updateInventoryButtons]; // <---- Add
            [self updateCurrentInventoryItem]; // <---- Add

            [ibChalkboardLabel setText:@"Inventory Loaded\n\nHow can I help you?"];
        });
    });}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

-(NSUInteger)supportedInterfaceOrientations{
    if([[UIDevice currentDevice] userInterfaceIdiom]==UIUserInterfaceIdiomPad){
        //ipad allow all orientaions
        return UIInterfaceOrientationMaskAll;
    }
    else{
        //iphone allow only landscape
        return UIInterfaceOrientationMaskLandscape;
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (IBAction)ibaRemoveItem:(id)sender {
    OrderItem* currentItem = [[self inventory] objectAtIndex:currentItemIndex];
    
    [order removeItemFromOrder:currentItem];
    [self updateOrderBoard];
    [self updateCurrentInventoryItem];
    [self updateInventoryButtons];
    
    UILabel* removeItemDisplay = [[UILabel alloc] initWithFrame:[ibCurrentItemImageView frame]];
    [removeItemDisplay setCenter:[ibChalkboardLabel center]];
    [removeItemDisplay setText:@"-1"];
    [removeItemDisplay setTextAlignment:UITextAlignmentCenter];
    [removeItemDisplay setTextColor:[UIColor redColor]];
    [removeItemDisplay setBackgroundColor:[UIColor clearColor]];
    [removeItemDisplay setFont:[UIFont boldSystemFontOfSize:32.0]];
    [[self view] addSubview:removeItemDisplay];
    
    [UIView animateWithDuration:1.0
                     animations:^{
                         [removeItemDisplay setCenter:[ibCurrentItemImageView center]];
                         [removeItemDisplay setAlpha:0.0];
                     } completion:^(BOOL finished) {
                         [removeItemDisplay removeFromSuperview];
                     }];

}

- (IBAction)ibaAddItem:(id)sender {
    OrderItem* currentItem = [[self inventory] objectAtIndex:currentItemIndex];
    
    [order addItemToOrder:currentItem];
    [self updateOrderBoard];
    [self updateCurrentInventoryItem];
    [self updateInventoryButtons];
    
    UILabel* addItemDisplay = [[UILabel alloc] initWithFrame:[ibCurrentItemImageView frame]];
    [addItemDisplay setText:@"+1"];
    [addItemDisplay setTextColor:[UIColor whiteColor]];
    [addItemDisplay setBackgroundColor:[UIColor clearColor]];
    [addItemDisplay setTextAlignment:UITextAlignmentCenter];
    [addItemDisplay setFont:[UIFont boldSystemFontOfSize:32.0]];
    [[self view] addSubview:addItemDisplay];
    
    [UIView animateWithDuration:1.0
                     animations:^{
                         [addItemDisplay setCenter:[ibChalkboardLabel center]];
                         [addItemDisplay setAlpha:0.0];
                     } completion:^(BOOL finished) {
                         [addItemDisplay removeFromSuperview];
                     }];
}

- (IBAction)ibaLoadPreviousItem:(id)sender {
    currentItemIndex--;
    [self updateCurrentInventoryItem];
    [self updateInventoryButtons];
}

- (IBAction)ibaLoadNextItem:(id)sender {
    currentItemIndex++;
    [self updateCurrentInventoryItem];
    [self updateInventoryButtons];
}

- (IBAction)ibaCalculateTotal:(id)sender {
    float total = [order totalOrder];
    
    UIAlertView* totalAlert = [[UIAlertView alloc] initWithTitle:@"Total" 
                                                         message:[NSString stringWithFormat:@"$%0.2f",total] 
                                                        delegate:nil
                                               cancelButtonTitle:@"Close" 
                                               otherButtonTitles:nil];
    [totalAlert show];
}

#pragma mark - Helper Methods

- (void)updateCurrentInventoryItem {
    if (currentItemIndex >= 0 && currentItemIndex < [[self inventory] count]) {
        OrderItem* currentItem = [[self inventory] objectAtIndex:currentItemIndex];
        [ibCurrentItemLabel setText:[currentItem name]];
        
       // [ibCurrentItemImageView setImage:[UIImage imageNamed:[currentItem pictureFile]]];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString *url=[NSString stringWithFormat:@"%@images/%@",_appDelegate.mcManager.serverPeerInfo.homeUrl,[currentItem pictureFile]];
            NSURL *pictureUrl=[NSURL URLWithString:url];
            NSData *data=[[NSData alloc] initWithContentsOfURL:pictureUrl];
        [ibCurrentItemImageView setImage:[UIImage imageWithData:data]];
        });
        
        /*dispatch_async(dispatch_get_main_queue(), ^{
            NSString *url=[NSString stringWithFormat:@"%@/%@",_appDelegate.mcManager.serverPeerInfo.homeUrl,[currentItem pictureFile]];
            NSURL *pictureUrl=[NSURL URLWithString:url];
            NSData *data=[[NSData alloc] initWithContentsOfURL:pictureUrl];
            [ibCurrentItemImageView setImage:[UIImage imageWithData:data]];
        });
         */
        
    }
}

- (void)updateInventoryButtons {
    if (![self inventory] || [[self inventory] count] == 0) {
        [ibAddItemButton setEnabled:NO];
        [ibRemoveItemButton setEnabled:NO];
        [ibNextItemButton setEnabled:NO];
        [ibPreviousItemButton setEnabled:NO];
        [ibTotalOrderButton setEnabled:NO];
    }
    else {
        if (currentItemIndex <= 0) {
            [ibPreviousItemButton setEnabled:NO];
        }
        else {
            [ibPreviousItemButton setEnabled:YES];
        }
        
        if (currentItemIndex >= [[self inventory] count]-1) {
            [ibNextItemButton setEnabled:NO];
        }
        else {
            [ibNextItemButton setEnabled:YES];
        }
        
        OrderItem* currentItem = [[self inventory] objectAtIndex:currentItemIndex];
        if (currentItem) {
            [ibAddItemButton setEnabled:YES];
        }
        else {
            [ibAddItemButton setEnabled:NO];
        }
        
        if (![[self order] findKeyForOrderItem:currentItem]) {
            [ibRemoveItemButton setEnabled:NO];
        }
        else {
            [ibRemoveItemButton setEnabled:YES];
        }
        
        if ([[order orderItems] count] == 0) {
            [ibTotalOrderButton setEnabled:NO];
        }
        else {
            [ibTotalOrderButton setEnabled:YES];
        }
    }
}

- (void)updateOrderBoard {
    if ([[order orderItems] count] == 0) {
        [ibChalkboardLabel setText:@"No Items. Please order something!"];
    }
    else {
        [ibChalkboardLabel setText:[order orderDescription]];
    }
}

- (IBAction)actionSubmitOrder:(id)sender {
    [self.delegate orderViewControllerDidFinish:self];
}
- (IBAction)cancelOrder:(id)sender {
    //[self dismissViewControllerAnimated:YES completion:nil];
    [self.delegate orderViewControllerWasCancelled:self];
}

@end
