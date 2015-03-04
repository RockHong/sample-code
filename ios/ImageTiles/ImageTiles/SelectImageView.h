//
//  SelectImageView.h
//  ImageTiles
//
//  Created by 洪 智华 on 12-5-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

//should not inherit UIImageView, or it will not call 'drawRect:'
@interface SelectImageView : UIView

@property (retain, nonatomic) UIImage *image;

- (UIImage*)resultImage;
@end
