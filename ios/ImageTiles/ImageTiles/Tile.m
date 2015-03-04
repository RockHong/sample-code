//
//  Tile.m
//  ImageTiles
//
//  Created by 洪 智华 on 12-5-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "Tile.h"

@implementation Tile

@synthesize index = _index, image = _image;

- (id)initWithFrame:(CGRect)frame image:(UIImage *)image index:(NSInteger)index
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _image = image;
        [_image retain]; //todo : right?
        _index = index;
    }
    return self;
}

-(void)dealloc
{
    [_image release];
    [super dealloc];
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    [[UIColor redColor] setStroke];
    [[UIColor blueColor] setFill];
    [self.image drawAtPoint:CGPointMake(0.0, 0.0)];
#if 0
    NSString *testString = [[NSString alloc] initWithFormat:@"%ld", self.index];
    [testString drawAtPoint:CGPointMake(9,9) withFont:[UIFont systemFontOfSize:26.0]];
#endif
}


@end
