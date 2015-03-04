//
//  PXViewController.m
//  Pixelate
//
//  Created by hongzhihua on 14-8-19.
//  Copyright (c) 2014年 hongzhihua. All rights reserved.
//

#import "PXViewController.h"

@interface PXViewController ()
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView; // hong: test
- (IBAction)selectPic:(id)sender;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *imagePickBtn;
//@property (nonatomic) UIActionSheet *imagePickAsht;

@end

@implementation PXViewController

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
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)selectPic:(id)sender {
    
    UIActionSheet * actionSheet = nil;
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                                  delegate:self
                                                         cancelButtonTitle:@"Cancel"
                                                    destructiveButtonTitle:nil
                                                         otherButtonTitles:@"Photo", nil];
    }
    else {
        actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                  delegate:self
                                         cancelButtonTitle:@"Cancel"
                                    destructiveButtonTitle:nil
                                         otherButtonTitles:@"Photo", @"Shoot", nil];
    }
    //if (self.imagePickAsht == nil) {
        //self.imagePickAsht = [[UIActionSheet alloc] initWithTitle:nil
    /*
        UIActionSheet * actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                                 delegate:self
                                                        cancelButtonTitle:@"Cancel"
                                                   destructiveButtonTitle:nil
                                                        otherButtonTitles:@"Photo", @"Shoot", nil];
     */
    //}

    //[self.imagePickAsht showFromBarButtonItem:self.imagePickBtn animated:YES];
    
    
    
    [actionSheet showFromBarButtonItem:self.imagePickBtn animated:YES];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        NSLog(@"choose photo...");
        
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.modalPresentationStyle = UIModalPresentationCurrentContext; //?
        imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imagePickerController.delegate = self;
        
        [self presentViewController:imagePickerController animated:YES completion:nil];
    }
    else if (buttonIndex == 1) {
        NSLog(@"shoot shott...");
    }
}



//
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
    self.imageView.image = image;
    [self dismissViewControllerAnimated:YES completion:NULL];
    
    // hong: scroll view test
    UIImageView * tmpiview = [[UIImageView alloc] initWithImage:image];
    [self.scrollView addSubview:tmpiview];
    self.scrollView.contentSize = image.size;
}

@end
