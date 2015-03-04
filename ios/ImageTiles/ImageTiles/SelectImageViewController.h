//
//  SelectImageViewController.h
//  ImageTiles
//
//  Created by 洪 智华 on 12-5-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SelectImageView;
@class GameViewController;
@class LaunchViewController;

@interface SelectImageViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate, 
                                                        UIActionSheetDelegate>
@property (retain, nonatomic) IBOutlet UIButton *okButton;
@property (retain, nonatomic) IBOutlet SelectImageView *theImageView;
@property (retain, nonatomic) GameViewController *gvc;
@property (assign, nonatomic) LaunchViewController *lvc;

- (IBAction)startGame:(id)sender;
- (IBAction)backToMainMenu:(id)sender;
@end
