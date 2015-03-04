//
//  SettingsViewController.h
//  ImageTiles
//
//  Created by 洪 智华 on 12-5-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsViewController : UIViewController
@property (retain, nonatomic) IBOutlet UILabel *rowlabel;
@property (retain, nonatomic) IBOutlet UILabel *columnLabel;
@property (retain, nonatomic) IBOutlet UIStepper *rowStepper;
@property (retain, nonatomic) IBOutlet UIStepper *columnStepper;
@property (retain, nonatomic) IBOutlet UISwitch *soundSwitch;

- (IBAction)valueChanged:(id)sender;
- (IBAction)ok:(id)sender;
- (IBAction)cancel:(id)sender;
@end
