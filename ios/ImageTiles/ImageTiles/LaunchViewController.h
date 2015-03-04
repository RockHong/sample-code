//
//  LaunchViewController.h
//  ImageTiles
//
//  Created by 洪 智华 on 12-5-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SelectImageViewController;
@class SettingsViewController;

@interface LaunchViewController : UIViewController

@property (retain, nonatomic)  SelectImageViewController *sivc;
@property (retain, nonatomic) SettingsViewController *svc;

- (IBAction)playGame:(id)sender;
- (IBAction)goSetting:(id)sender;
- (IBAction)viewRecords:(id)sender;

@end
