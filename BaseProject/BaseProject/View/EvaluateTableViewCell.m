//
//  EvaluateTableViewCell.m
//  CACheck
//
//  Created by 刘子琨 on 15/12/2.
//  Copyright © 2015年 刘子琨. All rights reserved.
//

#import "EvaluateTableViewCell.h"


#define kSpaceW 10
#define kSpaceH 8
#define kContentImageWidth 52
#define kContentImageHeight 52
#define kLabelHeight 18

@implementation EvaluateTableViewCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addSubviews];
    }
    return self;
}


-(void)addSubviews
{
    for (int i = 0; i < 5; i++) {
        self.starImage = [[UIImageView alloc] initWithFrame:CGRectMake(10 + (12+3)*i, 0, 12, 12)];
        UIImage *image = [UIImage imageNamed:@"星星"];
        self.starImage.image = image;
        [self.contentView addSubview:self.starImage];
    }
    
    
    self.comment = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.starImage.frame) + 9, kScreenWidth - 20, 15)];
    self.comment.font = [UIFont systemFontOfSize:13];
    self.comment.textColor = UIColorFromRGB(0x1c1c1c);
//    self.comment.backgroundColor = [UIColor orangeColor];
    [self addSubview:self.comment];
    
    
    self.phoneNumber = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.comment.frame) + 10, 200, 15)];
    self.phoneNumber.font = [UIFont systemFontOfSize:10];
    self.phoneNumber.textColor = UIColorFromRGB(0x8f8f8f);
//    self.phoneNumber.backgroundColor = [UIColor yellowColor];
    [self addSubview: self.phoneNumber];
    
    
    self.date = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth - CGRectGetMaxX(self.phoneNumber.frame), self.phoneNumber.frame.origin.y, 200, 15)];
    self.date.textColor = UIColorFromRGB(0x8f8f8f);
    self.date.font = [UIFont systemFontOfSize:10];
//    self.date.backgroundColor = [UIColor orangeColor];
    self.date.textAlignment = NSTextAlignmentRight;
    [self addSubview:self.date];
    
    
    self.button = [UIButton buttonWithType:UIButtonTypeCustom];
    self.button.frame = CGRectMake(120, CGRectGetMaxY(self.date.frame)+ 10, 95/320.0*kScreenWidth, 22.5/568.0*kScreenHeight);
//    self.button.backgroundColor = [UIColor grayColor];
    self.button.titleLabel.font = [UIFont systemFontOfSize:12];
    [self.button setTitleColor:UIColorFromRGB(0x34b5fe) forState:UIControlStateNormal];
    
    [self.button.layer setMasksToBounds:YES];
    [self.button.layer setCornerRadius:6.0]; //设置矩圆角半径
    [self.button.layer setBorderWidth:1.0];
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 52/255.0, 181/255.0, 254/255.0, 1 });
    
    
    [self.button.layer setBorderColor:colorref];//边框颜色

    [self addSubview:self.button];
    
}









- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
