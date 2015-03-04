//
//  PXComposeView.m
//  Pixelate
//
//  Created by hongzhihua on 14-9-9.
//  Copyright (c) 2014年 hongzhihua. All rights reserved.
//

#import "PXComposeView.h"

@implementation PXComposeView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    UIBezierPath *aPath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(10, 10, 160, 160)];
    UIBezierPath *pathb = [UIBezierPath bezierPathWithRect:CGRectMake(10, 10, 160, 160)];
    
    // Set the render colors.
    [[UIColor greenColor] setStroke];
    [[UIColor redColor] setFill];
    
    // Adjust the drawing options as needed.
    aPath.lineWidth = 5;
    
    //CGContextRef aRef = UIGraphicsGetCurrentContext();
    
    // If you have content to draw after the shape,
    // save the current state before changing the transform.
    //CGContextSaveGState(aRef);
    
    // Adjust the view's origin temporarily. The oval is
    // now drawn relative to the new origin point.
    //CGContextTranslateCTM(aRef, 50, 50);
    
    // Fill the path before stroking it so that the fill
    // color does not obscure the stroked line.
    [aPath fill];
    [aPath stroke];
    
    [pathb stroke];
    
    // Restore the graphics state before drawing any other content.
    //CGContextRestoreGState(aRef);
}


@end
