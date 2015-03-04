//
//  SelectImageViewController.m
//  ImageTiles
//
//  Created by 洪 智华 on 12-5-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SelectImageViewController.h"
#import "GameViewController.h"
#import "SelectImageView.h"

@interface SelectImageViewController ()
-(void)selectGamePic:(UIGestureRecognizer *)sender;
@end

@implementation SelectImageViewController
@synthesize okButton;
@synthesize theImageView;
@synthesize gvc = _gvc;
@synthesize lvc = _lvc;

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == actionSheet.cancelButtonIndex) {
        [actionSheet release];
        return;
    }
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    if (buttonIndex == 0){
        picker.sourceType = UIImagePickerControllerSourceTypeCamera; //todo crash
    }
    else if (buttonIndex == 1) {
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    [self presentViewController:picker animated:YES completion:nil];
    
    [actionSheet release];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    //self.theImageView.userInteractionEnabled = NO;
    self.okButton.enabled = YES;
    self.theImageView.image = [info valueForKey:UIImagePickerControllerOriginalImage]; 
    [self.theImageView setNeedsDisplay];
    [picker dismissViewControllerAnimated:YES completion:nil];
    [picker release]; //todo: ok?
}

-(void)selectGamePic:(UIGestureRecognizer *)sender
{
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"cancel" destructiveButtonTitle:nil otherButtonTitles:@"shoot", @"saved image", nil];
    [sheet showInView:self.view];
}

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
    
    UITapGestureRecognizer *doubletapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectGamePic:)];
    doubletapGR.numberOfTapsRequired = 2;
    [self.theImageView addGestureRecognizer:doubletapGR];
    [doubletapGR release];
}

- (void)viewDidUnload
{
    [self setOkButton:nil];
    [self setTheImageView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    [okButton release];
    [theImageView release];
    [_gvc release];
    [super dealloc];
}

- (IBAction)startGame:(id)sender {
    GameViewController *gvc = [[GameViewController alloc] initWithNibName:@"GameViewController" bundle:nil];
    self.gvc = gvc;
    self.gvc.lvc = _lvc;
    self.gvc.gameImage = [self.theImageView resultImage];
    [gvc release];
    [self presentViewController:gvc animated:NO completion:nil];
}

- (IBAction)backToMainMenu:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
