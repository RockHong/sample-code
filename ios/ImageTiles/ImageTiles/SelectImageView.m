//
//  SelectImageView.m
//  ImageTiles
//
//  Created by 洪 智华 on 12-5-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SelectImageView.h"

@interface SelectImageView () {
    NSInteger _rowCount;
    NSInteger _columnCount;
    CGFloat _scale;
    CGFloat _offsetX;
    CGFloat _offsetY;
}
-(void)imagePinched:(UIPinchGestureRecognizer *)gr;
-(void)imageDragged:(UIPanGestureRecognizer *)gr;
-(CGRect)imageRectInOriginalImage;
@end

@implementation SelectImageView

@synthesize image = _image;

- (void)imagePinched:(UIPinchGestureRecognizer *)gr
{
    NSLog(@"imagePinched: scale %f", _scale);
    _scale = gr.scale;
    [self setNeedsDisplay];
}

- (void)imageDragged:(UIPanGestureRecognizer *)gr
{
    static CGFloat tmpx;
    static CGFloat tmpy;
    if (gr.state == UIGestureRecognizerStateBegan) {
        tmpx = _offsetX;
        tmpy = _offsetY;
    }
    else {
        CGPoint translate = [gr translationInView:self];
        CGFloat factor = 0.9;
        _offsetX = tmpx + factor*translate.x;
        _offsetY = tmpy + factor*translate.y;  
        [self setNeedsDisplay];
    }
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    NSLog(@"initwithcoder");
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        _scale = 1.0;
        
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        _rowCount = [ud integerForKey:@"row"];
        _columnCount = [ud integerForKey:@"column"];
        
        UIPinchGestureRecognizer *pinchGR = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(imagePinched:)];
        [self addGestureRecognizer:pinchGR];
        [pinchGR release];
        UIPanGestureRecognizer *dragGR = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(imageDragged:)];
        dragGR.maximumNumberOfTouches = 1;
        [self addGestureRecognizer:dragGR];
        [dragGR release];
    }
    return self;
}

-(UIImage *)resultImage
{
    UIGraphicsBeginImageContextWithOptions(self.frame.size, YES, 0.0);
    UIBezierPath *backgroundRect = [UIBezierPath bezierPathWithRect:self.frame];
    [self.backgroundColor setFill];
    [backgroundRect fill];
    [self.image drawInRect:[self imageRectInOriginalImage]];
    UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resultImage;
}

-(CGRect)imageRectInOriginalImage
{
    CGFloat imageRatio = self.image.size.width/self.image.size.height;
    CGFloat viewRatio = self.frame.size.width/self.frame.size.height;
    CGRect drawingRect;
    if (imageRatio > viewRatio) {
        drawingRect = CGRectMake(0, 0.5*self.frame.size.height -0.5*self.frame.size.width/imageRatio, self.frame.size.width, self.frame.size.width/imageRatio);
    }
    else {
        drawingRect = CGRectMake(0.5*self.frame.size.width - 0.5*self.frame.size.height*imageRatio, 0, self.frame.size.height*imageRatio, self.frame.size.height);
    }
    drawingRect = CGRectApplyAffineTransform(drawingRect, CGAffineTransformMakeScale(_scale, _scale));
    drawingRect = CGRectApplyAffineTransform(drawingRect, CGAffineTransformMakeTranslation(self.frame.size.width*0.5*(1-_scale), self.frame.size.height*0.5*(1-_scale)));
    drawingRect = CGRectApplyAffineTransform(drawingRect, CGAffineTransformMakeTranslation(_offsetX, _offsetY));
    return drawingRect;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    CGContextRef ref = UIGraphicsGetCurrentContext();
    
    // draw image
    [self.image drawInRect:[self imageRectInOriginalImage]];
    // draw image ends
    
    UIBezierPath *hline = [UIBezierPath bezierPath];
    [hline moveToPoint:CGPointMake(0, 0)];
    [hline addLineToPoint:CGPointMake(self.frame.size.width, 0)];
    
    UIBezierPath *vline = [UIBezierPath bezierPath];
    [vline moveToPoint:CGPointMake(0, 0)];
    [vline addLineToPoint:CGPointMake(0, self.frame.size.height)];
    
    [[UIColor lightGrayColor] setStroke];
    CGFloat pattern[2] = {2,2};
    [hline setLineDash: pattern count:2 phase:0];
    [vline setLineDash: pattern count:2 phase:0];
    
    CGFloat vlinestep = self.frame.size.width/_columnCount;
    CGFloat hlinestep = self.frame.size.height/_rowCount;
    
    CGContextSaveGState(ref);
    
    for (NSInteger i = 1; i < _rowCount; i++) {
        CGContextTranslateCTM(ref, 0, hlinestep);
        [hline stroke];
    }
    
    CGContextRestoreGState(ref);
    for (NSInteger i = 1; i < _columnCount; i++) {
        CGContextTranslateCTM(ref, vlinestep, 0);
        [vline stroke];
    }    
}

-(void)dealloc
{
    [_image release];
    [super dealloc];
}

@end
