//
//  RecordTableViewCell.h
//  BaseProject
//
//  Created by 刘子琨 on 16/1/14.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "historyModel.h"

@interface RecordTableViewCell : UITableViewCell

@property (nonatomic , strong)UIImageView *contentImageView;
@property (nonatomic , strong)UILabel *nameLabel;
@property (nonatomic , strong)UILabel *stateLabel;
@property (nonatomic , strong)UILabel *dateLabel;

@property (nonatomic, strong)   historyModel *model;

@end
