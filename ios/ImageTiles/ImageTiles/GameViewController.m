//
//  GameViewController.m
//  ImageTiles
//
//  Created by 洪 智华 on 12-5-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "GameViewController.h"
#import "Tile.h"
#import "LaunchViewController.h"
#import <QuartzCore/QuartzCore.h>  //using core animation

@interface GameViewController ()
{
    Tile *_tryTile;
    CGPoint _targetCenter;
    CGPoint _preCenter;
    BOOL _tried;
    NSInteger ROW;
    NSInteger COLUMN;
}

@property (retain, nonatomic) NSMutableArray *tileArray;
@property (retain, nonatomic) UIImageView *imageLeft;
@property (retain ,nonatomic) UIImageView *imageRight;
@property (retain, nonatomic) UIButton *okBtn;

-(void)dragTile:(UIPanGestureRecognizer *)sender;
-(void)dragTileSimple:(UIPanGestureRecognizer *)sender;
-(void)addTilesAndDisorder;
-(void)tryExchange;
-(void)cancelTry;
-(void)check;
-(void)sucessWithAnimation;
-(void)quitGame:(id)sender;
@end

@implementation GameViewController

@synthesize tileArray = _tileArray, gameImage = _gameImage, imageLeft = _imageLeft, imageRight = _imageRight, okBtn = _okBtn;
@synthesize lvc = _lvc;

-(void)quitGame:(id)sender
{
    [_lvc dismissViewControllerAnimated:NO completion:nil];
}

-(void)check
{
    BOOL ok = YES;
    CGFloat rowHeight = self.view.frame.size.height/ROW;
    CGFloat colWidth = self.view.frame.size.width/COLUMN;
    for (Tile *t in self.tileArray) {
        int row = t.index/COLUMN;
        int col = t.index - row*COLUMN;
        if (!CGRectContainsPoint(CGRectMake(col*colWidth, row*rowHeight, colWidth, rowHeight), t.center)){
            ok = NO;
            break;
        }
    }
    
    if (ok) {
        for (Tile *t in self.tileArray) {
            t.hidden = YES;
        }
        self.imageLeft.hidden = NO;
        self.imageRight.hidden = NO;
        [self sucessWithAnimation];
    }
}

-(void)sucessWithAnimation
{    
    self.okBtn.transform = CGAffineTransformMakeScale(0.3, 0.3);
    
    CATransform3D matrix = CATransform3DIdentity;
    matrix.m34 = -1.0f/500; // Magic! make 3D perspective effect!
    self.imageLeft.layer.transform = matrix;
    self.imageRight.layer.transform = matrix;
    
    [UIView beginAnimations:@"success animation" context:nil];
    [UIView setAnimationDuration:2];
    self.imageLeft.layer.transform = CATransform3DRotate(matrix, M_PI_2, 0, 1, 0);
    self.imageRight.layer.transform = CATransform3DRotate(matrix, -M_PI_2, 0, 1, 0);
    
    self.okBtn.alpha = 1.0;
    self.okBtn.transform = CGAffineTransformMakeScale(1, 1);
    [UIView commitAnimations];
}

-(void)addTilesAndDisorder
{
    CGFloat rowHight = self.view.frame.size.height/ROW;
    CGFloat columnWidth = self.view.frame.size.width/COLUMN;
    
    for(NSInteger i = 0; i < ROW; i++)
    {
        for(NSInteger j = 0; j < COLUMN; j++)
        {
            CGImageRef imageRef = CGImageCreateWithImageInRect([self.gameImage CGImage], CGRectMake(j*columnWidth, i*rowHight, columnWidth, rowHight));
            Tile *t = [[Tile alloc] initWithFrame:CGRectMake(j*columnWidth, i*rowHight, columnWidth, rowHight) image:[UIImage imageWithCGImage:imageRef] index:i*COLUMN+j];
            CGImageRelease(imageRef);
            [self.view addSubview:t];
            [self.tileArray addObject:t]; 
            [t release];
        }
    }
    
    NSInteger loopCount = arc4random()%15;
    if (loopCount < 5) loopCount = 5;
    [UIView beginAnimations:@"disorder" context:nil];
    [UIView setAnimationDuration:1.0];
    for (NSInteger i = 0; i < loopCount; i++)
    {
        NSInteger one = arc4random()%(ROW*COLUMN);
        NSInteger another = arc4random()%(ROW*COLUMN);
        if (one == another) 
        {
            loopCount++;
            continue;
        }
        Tile *oneT = [self.tileArray objectAtIndex:one];
        Tile *anotherT = [self.tileArray objectAtIndex:another];
        CGPoint tmp = anotherT.center;
        anotherT.center = oneT.center;
        oneT.center = tmp;
    }
    [UIView commitAnimations]; //todo , to see if animation happens
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _tileArray = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    ROW = [ud integerForKey:@"row"];
    COLUMN = [ud integerForKey:@"column"];
    
    _tryTile = nil;
    _tried = NO;
    
    CGFloat width = self.view.frame.size.width;
    CGFloat height = self.view.frame.size.height;
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.okBtn = btn;
    [self.okBtn addTarget:self action:@selector(quitGame:) forControlEvents:UIControlEventTouchUpInside];
    self.okBtn.alpha = 0; //property 'alpah' can animate
    self.okBtn.titleLabel.font = [UIFont systemFontOfSize: 12];
    [self.okBtn setTitle:@"Succeed!" forState:UIControlStateNormal];
    self.okBtn.frame = CGRectMake(width/2 - 25, height/2 - 15, 60, 30);
    [self.view addSubview:self.okBtn];
    
    // add left subview
    CGImageRef imageRef = CGImageCreateWithImageInRect([self.gameImage CGImage], CGRectMake(0, 0, width/2.0, height));
    UIImageView *left = [[UIImageView alloc] initWithFrame: CGRectMake(0, 0, width/2.0, height)];
    left.image = [UIImage imageWithCGImage:imageRef];
    self.imageLeft = left;
    CGImageRelease(imageRef);
    [left release];
    [self.view addSubview:self.imageLeft];
    self.imageLeft.hidden = YES;
    
    // add right subview
    imageRef = CGImageCreateWithImageInRect([self.gameImage CGImage], CGRectMake(width/2.0, 0, width/2.0, height));
    UIImageView *right = [[UIImageView alloc] initWithFrame: CGRectMake(width/2.0, 0, width/2.0, height)];
    right.image = [UIImage imageWithCGImage:imageRef];
    self.imageRight = right;
    CGImageRelease(imageRef);
    [right release];
    [self.view addSubview:self.imageRight];
    self.imageRight.hidden = YES;
    
    self.imageLeft.layer.anchorPoint = CGPointMake(0, 0.5);
    self.imageLeft.center = CGPointMake(0.0, height/2.0);
    self.imageRight.layer.anchorPoint = CGPointMake(1.0, 0.5); //set anchor point
    self.imageRight.center = CGPointMake(width, height/2.0); //why mofigy center? see Doc to find out the relationship between anchor point and position
    
    // add tiles
    [self addTilesAndDisorder];
    
    // add gesture
#if 0
    UIPanGestureRecognizer *dragGR = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(dragTile:)];
#else
    UIPanGestureRecognizer *dragGR = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(dragTileSimple:)];
#endif
    [self.view addGestureRecognizer:dragGR];
    [dragGR release];
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

-(void)dealloc
{
    [_tileArray release];
    [_gameImage release];
    [_imageRight release];
    [_imageLeft release];
    [_okBtn release];
    [super dealloc];
}

#pragma mark - a way to respond user touch events
// user drag a tile. if he/she move the tile, then hold the tile on another tile for a little seconds, it will exchange them.
// Then, if touch end, the exchange done. Or, if he/she keep move, the previous exchange cancels.
// todo: a little bug still
-(void)dragTile:(UIPanGestureRecognizer *)send
{
    static Tile *dragged = nil;
    if (send.state == UIGestureRecognizerStateBegan) {
        dragged = nil;
        CGPoint point = [send locationInView:self.view];
        for (Tile *t in self.tileArray) {
            if (CGRectContainsPoint(t.frame, point)) {
                dragged = t;
                [self.view bringSubviewToFront:dragged];
                _targetCenter = t.center;
                break;
            }
        }
    }
    else if (send.state == UIGestureRecognizerStateChanged)
    {
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(tryExchange) object:nil];
        dragged.center = [send locationInView:self.view];
        for (Tile *t in self.tileArray) {
            if (t == dragged || t == _tryTile)
                continue;
            if (CGRectContainsPoint(t.frame, dragged.center))
            {
                [self cancelTry];
                _tryTile = t;
                break;
            }
        }
        [self performSelector:@selector(tryExchange) withObject:nil afterDelay:0.5];
    }
    else if (send.state == UIGestureRecognizerStateEnded)
    {
        [UIView beginAnimations:@"exchange" context:nil];
        [UIView setAnimationDuration:0.2];
        dragged.center = _preCenter;
        [UIView commitAnimations];
        dragged = nil;
        _tryTile = nil;
        
        [self check];
    }
}

-(void)tryExchange
{
    _preCenter = _tryTile.center;
    _tried = YES;
    
    [UIView beginAnimations:@"try" context:nil];
    [UIView setAnimationDuration:0.5];
    _tryTile.center = _targetCenter;
    [UIView commitAnimations];
}

-(void)cancelTry
{
    if (_tried) {
        [UIView beginAnimations:@"canceltry" context:nil];
        [UIView setAnimationDuration:0.5];
        _tryTile.center = _preCenter;
        [UIView commitAnimations];
        _tried = NO;
    }
}

#pragma mark - another way to respond user touch events
// a simpler way. user move the tile. if he/she finish move, exchange the two tiles.
-(void)dragTileSimple:(UIPanGestureRecognizer *)sender
{
    static Tile *dragged = nil;
    static CGPoint center;
    if (sender.state == UIGestureRecognizerStateBegan) {
        dragged = nil;
        CGPoint point = [sender locationInView:self.view];
        for (Tile *t in self.tileArray) {
            if (CGRectContainsPoint(t.frame, point)) {
                dragged = t;
                center = dragged.center;
                [self.view bringSubviewToFront:dragged];
                break;
            }
        }
    }
    else if (sender.state == UIGestureRecognizerStateChanged)
    {
        dragged.center = [sender locationInView:self.view];
    }
    else if (sender.state == UIGestureRecognizerStateEnded)
    {
        Tile *other;
        for (Tile *t in self.tileArray) {
            if (t == dragged) {
                continue;
            }
            if (CGRectContainsPoint(t.frame, dragged.center)) {
                other = t;
                break;
            }
        }
        [UIView beginAnimations:@"exchange simple" context:nil];
        [UIView setAnimationDuration:0.1];
        dragged.center = other.center;
        other.center = center;
        [UIView commitAnimations];
        dragged = nil;
        
        [self check];
    }
}

@end
