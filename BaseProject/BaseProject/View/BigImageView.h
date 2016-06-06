//
//  BigImageView.h
//  CACheck
//
//  Created by 刘子琨 on 15/10/27.
//  Copyright (c) 2015年 刘子琨. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "zoomScrollView.h"

@interface BigImageView : UIScrollView<UIScrollViewDelegate>

@property (nonatomic , strong)zoomScrollView *zoomScroll;

-(instancetype)initWithFrame:(CGRect)frame andImagesArray:(NSMutableArray *)images;

-(void)chooseImageAtIndex:(NSInteger)index;

@end
