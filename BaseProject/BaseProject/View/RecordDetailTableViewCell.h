//
//  RecordDetailTableViewCell.h
//  CACheck
//
//  Created by 刘子琨 on 15/9/22.
//  Copyright (c) 2015年 刘子琨. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecordDetailTableViewCell : UITableViewCell

@property (nonatomic , strong)UILabel *titleLabel;
@property (nonatomic , strong)UILabel *contentLabel;
@property (nonatomic , strong)UIImageView *ImageView;

-(void)setContentLabelText:(NSString*)text;

-(void)setTitleLabelText:(NSString *)text;
-(void)calculateheight;

@end
