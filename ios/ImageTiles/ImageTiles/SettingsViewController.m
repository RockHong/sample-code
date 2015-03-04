//
//  SettingsViewController.m
//  ImageTiles
//
//  Created by 洪 智华 on 12-5-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SettingsViewController.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController
@synthesize rowlabel;
@synthesize columnLabel;
@synthesize rowStepper;
@synthesize columnStepper;
@synthesize soundSwitch;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        NSLog(@"yyy");
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    NSDictionary *appDefaults = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:2], @"row", [NSNumber numberWithInteger:2], @"column",
                                 [NSNumber numberWithBool:NO], @"sound", nil];
    [[NSUserDefaults standardUserDefaults] registerDefaults:appDefaults];
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    self.rowStepper.value = [ud integerForKey:@"row"];
    self.columnStepper.value = [ud integerForKey:@"column"];
    self.rowlabel.text = [NSString stringWithFormat:@"Row: %ld", [ud integerForKey:@"row"]];
    self.columnLabel.text = [NSString stringWithFormat:@"Column: %ld", [ud integerForKey:@"column"]];
    self.soundSwitch.on = [ud boolForKey:@"sound"];
    
    NSLog(@"xxx");
}

- (void)viewDidUnload
{
    [self setRowlabel:nil];
    [self setColumnLabel:nil];
    [self setRowStepper:nil];
    [self setColumnStepper:nil];
    [self setSoundSwitch:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    NSLog(@"ddd");
    [rowlabel release];
    [columnLabel release];
    [rowStepper release];
    [columnStepper release];
    [soundSwitch release];
    [super dealloc];
}

- (IBAction)valueChanged:(id)sender
{
    NSInteger tag = [sender tag];
    if (tag == 0) {
        self.rowlabel.text = [NSString stringWithFormat:@"Row: %.0f", [(UIStepper*)sender value]];
    }
    else if (tag == 1) {
        self.columnLabel.text = [NSString stringWithFormat:@"Column: %.0f", [(UIStepper*)sender value]];
    }
    else if (tag == 2) {
        
    }
}

- (IBAction)ok:(id)sender {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:[NSNumber numberWithDouble: self.rowStepper.value] forKey:@"row"];
    [ud setDouble:self.columnStepper.value forKey:@"column"];
    [ud setBool:self.soundSwitch.on forKey:@"sound"];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)cancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
