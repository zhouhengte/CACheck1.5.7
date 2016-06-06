//
//  PictureViewController.h
//  CACheck
//
//  Created by 刘子琨 on 15/10/26.
//  Copyright (c) 2015年 刘子琨. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BigImageView.h"
#import "RecordDetailViewController.h"

@interface PictureViewController : UIViewController

@property (nonatomic , strong)RecordDetailViewController *tableViewHeader;

@property(nonatomic , copy)NSString *url;
@property(nonatomic , strong)NSMutableArray *urlArray;

@property (nonatomic ,assign)NSInteger index;
@property (nonatomic , strong)BigImageView *bigImageView;
@property (nonatomic , strong)NSString *suger;

@end
