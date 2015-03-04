//
//  LaunchViewController.m
//  ImageTiles
//
//  Created by 洪 智华 on 12-5-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "LaunchViewController.h"
#import "SelectImageViewController.h"
#import "SettingsViewController.h"

@interface LaunchViewController ()

@end

@implementation LaunchViewController

@synthesize sivc = _sivc, svc = _svc;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc
{
    [_svc release];
    [_sivc release];
    [super dealloc];
}

- (IBAction)playGame:(id)sender {
    SelectImageViewController *sivc = [[SelectImageViewController alloc] initWithNibName:@"SelectImageViewController" bundle:nil];
    self.sivc = sivc;
    self.sivc.lvc = self;
    [sivc release];
#if 0
    self.sivc.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
#elif 0
    self.sivc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
#elif 1
    self.sivc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
#elif 0
    self.sivc.modalTransitionStyle = UIModalTransitionStylePartialCurl;
#endif
    [self presentViewController:self.sivc animated:YES completion:nil];
}

- (IBAction)goSetting:(id)sender {
    SettingsViewController *svc = [[SettingsViewController alloc] initWithNibName:@"SettingsViewController" bundle:nil];
    self.svc = svc; // release old, retain the newly alloc one.
    [svc release];
    self.svc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:self.svc animated:YES completion:nil];
}

- (IBAction)viewRecords:(id)sender {
}

@end
