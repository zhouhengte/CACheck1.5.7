//
//  HZPhotoBrowser.h
//  photobrowser
//
//  Created by aier on 15-2-3.
//  Copyright (c) 2015年 aier. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecordDetailViewController.h"


@class HZButton, HZPhotoBrowser;

@protocol HZPhotoBrowserDelegate <NSObject>

@required

- (UIImage *)photoBrowser:(HZPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index;

@optional

- (NSURL *)photoBrowser:(HZPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index;
-(void)photoBrowser:(HZPhotoBrowser *)browser returnSetCurrentImageViewIndex:(NSInteger)index;
@end


@interface HZPhotoBrowser : UIView <UIScrollViewDelegate>

@property (nonatomic,weak) RecordDetailViewController *supViewController;
@property (nonatomic, weak) UIView *sourceImagesContainerView;
@property (nonatomic, assign) int currentImageIndex;
@property (nonatomic, assign) NSInteger imageCount;

@property (nonatomic, weak) id<HZPhotoBrowserDelegate> delegate;

- (void)show;

@end
