//
//  BigImageView.m
//  CACheck
//
//  Created by 刘子琨 on 15/10/27.
//  Copyright (c) 2015年 刘子琨. All rights reserved.
//

#import "BigImageView.h"

@implementation BigImageView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.delegate = self;
    }
    return self;
}


-(instancetype)initWithFrame:(CGRect)frame andImagesArray:(NSMutableArray *)images{
    self = [self initWithFrame:frame];
    for (int i = 0; i < [images count]; i++) {
        zoomScrollView *zoomCrollView = [[zoomScrollView alloc] initWithFrame:CGRectMake(i * self.frame.size.width, 0, self.frame.size.width, self.frame.size.height)];
        [images objectAtIndex:i];
        [self addSubview:zoomCrollView];
    }
    self.contentSize = CGSizeMake([images count] * self.frame.size.width, self.frame.size.height);
    self.pagingEnabled = YES;
    return self;
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger index = scrollView.contentOffset.x / scrollView.frame.size.width;
    zoomScrollView *currentZoomScrollView = (zoomScrollView *)[self.subviews objectAtIndex:index];
    if (currentZoomScrollView != self.zoomScroll) {
        self.zoomScroll.zoomScale = 1;
        self.zoomScroll = currentZoomScrollView;
    }
}


-(void)chooseImageAtIndex:(NSInteger)index
{
    index = index - 101;
    //    self.contentOffset = (CGPointMake(index * self.frame.size.width, 0) animated: YES);
    [self setContentOffset:CGPointMake(index * self.frame.size.width, 0) animated:YES];
    //指向缩放图片的地址，保存索引
//    self.zoomScroll= ((zoomScrollView *)[[self subviews] objectAtIndex:index]);
}


@end
