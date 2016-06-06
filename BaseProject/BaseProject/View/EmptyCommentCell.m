//
//  EmptyCommentCell.m
//  BaseProject
//
//  Created by 刘子琨 on 16/4/25.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import "EmptyCommentCell.h"

@interface EmptyCommentCell ()


@end

@implementation EmptyCommentCell

- (void)awakeFromNib {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.commentButton.layer setMasksToBounds:YES];
    [self.commentButton.layer setCornerRadius:6.0]; //设置矩圆角半径
    [self.commentButton.layer setBorderWidth:1.0];   //边框宽度
    [self.commentButton.layer setBorderColor:[UIColor colorWithRed:52/255.0 green:181/255.0 blue:254/255.0 alpha:1].CGColor];
    [self.commentButton setTitleColor:[UIColor colorWithRed:52/155.0 green:181/255.0 blue:254/255.0 alpha:1] forState:UIControlStateNormal];
    self.userInteractionEnabled = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
