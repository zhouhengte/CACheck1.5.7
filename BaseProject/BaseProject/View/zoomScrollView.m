//
//  zoomScrollView.m
//  CACheck
//
//  Created by 刘子琨 on 15/10/27.
//  Copyright (c) 2015年 刘子琨. All rights reserved.
//

#import "zoomScrollView.h"

@implementation zoomScrollView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.maximumZoomScale = 2;
        self.minimumZoomScale = 0.3;
        self.delegate = self;
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame andImage:(UIImage *)image
{
    self = [self initWithFrame:frame];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
    imageView.tag = 111;
    [self addSubview:imageView];
    
    return self;
}

@end
