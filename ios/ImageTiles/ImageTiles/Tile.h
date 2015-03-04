//
//  Tile.h
//  ImageTiles
//
//  Created by 洪 智华 on 12-5-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Tile : UIView

@property (nonatomic) NSInteger index;
@property (retain, nonatomic) UIImage * image;

- (id)initWithFrame:(CGRect)frame image:(UIImage *)image index:(NSInteger)index;

@end
