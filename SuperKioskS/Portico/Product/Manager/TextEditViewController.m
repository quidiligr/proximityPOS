//
//  TextEditViewController.m
//  superkiosks
//
//  Created by Katherine Sheehy on 10/24/15.
//  Copyright (c) 2015 Sharecle. All rights reserved.
//

#import "TextEditViewController.h"

@interface TextEditViewController ()
@property (strong, nonatomic) IBOutlet UITextView *editTextView;
@end

@implementation TextEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelAction)];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveAction)];
    self.editTextView.text=self.inputText;
    [[self.editTextView layer] setBorderColor:[[[UIColor grayColor] colorWithAlphaComponent:0.5] CGColor]];
    [[self.editTextView layer] setBorderWidth:1.0];//setBorderWidth:2.3];
    [[self.editTextView layer] setCornerRadius:2];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)saveAction{
    self.inputText=self.editTextView.text;
    [self.delegate textEditViewControllerDidChange:self];
}
-(void)cancelAction{
    [self dismissViewControllerAnimated:YES completion:nil];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - UIPicker configuration
- (void)configurePickerView {
    
    
    //Create and configure toolabr that holds "Done button"
    UIToolbar *pickerToolbar = [[UIToolbar alloc] init];
    pickerToolbar.barStyle = UIBarStyleBlackTranslucent;
    [pickerToolbar sizeToFit];
    
    UIBarButtonItem *flexibleSpaceLeft = [[UIBarButtonItem alloc]
                                          initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                          target:nil
                                          action:nil];
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                   style:UIBarButtonItemStyleBordered
                                                                  target:self
                                                                  action:@selector(pickerDoneButtonPressed)];
    
    UIBarButtonItem *clearButton = [[UIBarButtonItem alloc] initWithTitle:@"Clear"
                                                                    style:UIBarButtonItemStyleBordered
                                                                   target:self
                                                                   action:@selector(pickerClearButtonPressed)];
    
    [pickerToolbar setItems:[NSArray arrayWithObjects:flexibleSpaceLeft,clearButton, doneButton, nil]];
    
    
    
    self.editTextView.inputAccessoryView = pickerToolbar;
    //self.editTextView.keyboardType=UIKeyboardTypeNumberPad;
    
}

- (void)pickerDoneButtonPressed {
    [self.view endEditing:YES];
}

- (void)pickerClearButtonPressed {
  if([self.editTextView isFirstResponder])
        self.editTextView.text=nil;
    
}

@end
