//
//  RecordDetailTableViewCell.m
//  CACheck
//
//  Created by 刘子琨 on 15/9/22.
//  Copyright (c) 2015年 刘子琨. All rights reserved.
//

#import "RecordDetailTableViewCell.h"

#define kSpaceX 12
#define kSpaceY 5
#define kTitleLabelW 120
#define kTitleLabelH 20
#define kContentLabelW 200
#define kContentLabelH 20

@implementation RecordDetailTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.contentLabel];
//        [self.contentView addSubview:self.ImageView];
    }
    return self;
}

-(UIImageView *)ImageView
{
    if (!_ImageView) {
        self.ImageView = [[UIImageView alloc] initWithFrame:CGRectMake(250, kSpaceY, 10, 12)];
    
        self.ImageView.backgroundColor = [UIColor redColor];
        
    }
    return _ImageView;
}

-(UILabel *)titleLabel
{
    if (!_titleLabel) {
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kSpaceX, kSpaceY, kTitleLabelW, kTitleLabelH)];
//        self.titleLabel.backgroundColor = [UIColor orangeColor];
        self.titleLabel.font = [UIFont systemFontOfSize:13];
        self.titleLabel.numberOfLines = 0;
        self.titleLabel.textColor = UIColorFromRGB(0x8f8f8f);
//        self.titleLabel.text = @"测试";
    }
    return _titleLabel;
}



-(UILabel *)contentLabel
{
    if (!_contentLabel) {
        self.contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.titleLabel.frame) + kSpaceY, self.titleLabel.frame.origin.y, [UIScreen mainScreen].bounds.size.width - CGRectGetMaxX(self.titleLabel.frame) - kSpaceX, kContentLabelH)];
//        self.contentLabel.backgroundColor = [UIColor orangeColor];
        self.contentLabel.font = [UIFont systemFontOfSize:13];
        self.contentLabel.numberOfLines = 0;

        self.contentLabel.textColor = UIColorFromRGB(0x8f8f8f);
       
//        self.contentLabel.text = @"测试";
    }
    return _contentLabel;
}
-(void)setTitleLabelText:(NSString *)text{

    
    //获得当前cell高度
    
    CGRect frame = [self frame];
    
    //文本赋值
    
    self.titleLabel.text = text;
    
    //设置label的最大行数
    
    self.titleLabel.numberOfLines = 0;
    
    CGSize size = CGSizeMake(kTitleLabelW, 1000);
    
    
    CGRect labelSize = [self.titleLabel.text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} context:nil];
    
    
    self.titleLabel.frame = CGRectMake(self.titleLabel.frame.origin.x, self.titleLabel.frame.origin.y,kTitleLabelW, labelSize.size.height);
    self.frame = frame;
    
}


-(void)setContentLabelText:(NSString*)text{
    
    //获得当前cell高度
    
    CGRect frame = [self frame];
    
    //文本赋值
    
    self.contentLabel.text = text;
    
    //设置label的最大行数
    
    self.contentLabel.numberOfLines = 0;
    
    CGSize size = CGSizeMake([UIScreen mainScreen].bounds.size.width - CGRectGetMaxX(self.titleLabel.frame) - kSpaceX, 1000);
    

    CGRect labelSize = [self.contentLabel.text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} context:nil];


    self.contentLabel.frame = CGRectMake(self.contentLabel.frame.origin.x, self.contentLabel.frame.origin.y, self.contentLabel.frame.size.width, labelSize.size.height);
 
    //计算出自适应的高度
    
//    frame.size.height = labelSize.size.height+10;
    
    self.frame = frame;  
    
}
-(void)calculateheight
{

    NSString *contentText = self.contentLabel.text;
    self.contentLabel.lineBreakMode = NSLineBreakByCharWrapping;
    self.contentLabel.numberOfLines = 0;
    self.contentLabel.preferredMaxLayoutWidth = CGRectGetWidth(self.contentLabel.frame);
//    self.contentLabel.text = str;
    CGSize maxSize = CGSizeMake(self.contentLabel.frame.size.width, 1000);
    
    CGRect textRect = [contentText boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]} context:nil];
    
    self.contentLabel.frame = CGRectMake(self.contentLabel.frame.origin.x, self.contentLabel.frame.origin.y, self.contentLabel.frame.size.width, textRect.size.height);
    self.titleLabel.frame = CGRectMake(self.titleLabel.frame.origin.x, self.titleLabel.frame.origin.y, self.titleLabel.frame.size.width, textRect.size.height);
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.contentLabel.frame.size.height + 10);
}



- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
