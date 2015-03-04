//
//  GameViewController.h
//  ImageTiles
//
//  Created by 洪 智华 on 12-5-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Tile;
@class LaunchViewController;

@interface GameViewController : UIViewController

@property (retain, nonatomic) UIImage *gameImage;
// LaunchViewController presents SettingViewController; SetttingViewController presents GameViewController
// If user finishes game, we want to go back to LauchViewController.
// If we just let GameViewController dismiss itself, it will go back to SettingViewController.
// So, we keep a 'lvc' pointer here.
// It seems not a good design. Maybe we need a better design on view controllers relationship.
@property (assign, nonatomic) LaunchViewController *lvc;

@end
