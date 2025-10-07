#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "SearchMenuViewController.h"
#import "BCScannerViewController.h"
#import "SelectOneViewController.h"
#import "OrderMenuViewController.h"
#import <iAd/iAd.h>
//#import "ProductSelectionDelegate.h"

//@protocol OrderViewControllerDelegate;
@class Order;
@class CheckoutCart;

@interface OrderMenuTableViewController : UITableViewController<UITableViewDelegate,UITableViewDataSource,ADBannerViewDelegate,BCScannerViewControllerDelegate,SearchMenuViewControllerDelegate,SelectOneViewControllerDelegate,UIActionSheetDelegate> {
    int currentItemIndex;
}

//@property (strong, nonatomic) NSDictionary* inventory;
@property (strong, nonatomic) Order* order;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *menuButtonItem;

//@property (nonatomic, assign) id<OrderIpadViewControllerDelegate> delegate;
//@property (nonatomic, assign) id<ProductSelectionDelegate> delegateProduct;

@property (strong, nonatomic) CheckoutCart* checkoutCart;

//@property (strong, nonatomic) IBOutlet UITableView *menuTableView;

//@property (strong, nonatomic) IBOutlet UITableView *orderTableView;

//@property (strong, nonatomic) NSIndexPath *selectedIndexPath;

//@property (nonatomic, strong) AppDelegate *appDelegate;

//@property (strong, nonatomic) IBOutlet UIImageView *wallImage;


@property (strong, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;

@property (strong, nonatomic) IBOutlet UITextField *txtMessage;

//@property (strong, nonatomic) IBOutlet ADBannerView *banner1;

@property (nonatomic) BOOL continueShopping;

@property (nonatomic, strong) UIPopoverController *popOver;
//- (void)updateCurrentInventoryItem;
//- (void)updateInventoryButtons;
//- (void)updateOrderBoard;
@property (strong, nonatomic) IBOutlet UISegmentedControl *selectViewSegmented;

@property(nonatomic,strong) OrderMenuViewController *refenceToParentViewController;
@property (strong, nonatomic) IBOutlet UILabel *lblStatus;

@end
/*
 @protocol OrderIpadViewControllerDelegate <NSObject>
 
 -(void)orderViewControllerDidFinish:(OrderIpadViewController *)orderViewController;
 
 -(void)orderViewControllerWasCancelled:(OrderIpadViewController *)orderViewController;
 
 
 
 @end
 
 */
