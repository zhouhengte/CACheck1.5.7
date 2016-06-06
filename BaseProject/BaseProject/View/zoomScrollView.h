//
//  zoomScrollView.h
//  CACheck
//
//  Created by 刘子琨 on 15/10/27.
//  Copyright (c) 2015年 刘子琨. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface zoomScrollView : UIScrollView<UIScrollViewDelegate>

-(instancetype)initWithFrame:(CGRect)frame andImage:(UIImage *)image;

@end
