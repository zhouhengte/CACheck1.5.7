//
//  RecordTableViewCell.m
//  BaseProject
//
//  Created by 刘子琨 on 16/1/14.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import "RecordTableViewCell.h"


#define kSpaceW 10
#define kSpaceH 8
#define kContentImageWidth 52
#define kContentImageHeight 52
#define kLabelHeight 18

@implementation RecordTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.contentImageView];
        [self.contentView addSubview:self.nameLabel];
        [self.contentView addSubview:self.stateLabel];
        [self.contentView addSubview:self.dateLabel];
    }
    return self;
}

-(UIImageView *)contentImageView
{
    if (!_contentImageView) {
        _contentImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kSpaceW/320.0*kScreenWidth, kSpaceH/568.0*kScreenHeight, kContentImageWidth/568.0*kScreenHeight, kContentImageHeight/568.0*kScreenHeight)];
        //        _contentImage.backgroundColor = [UIColor orangeColor];
    }
    [self zoomImageScale:_contentImageView.image];
    return _contentImageView;
}
-(UIImage *)zoomImageScale:(UIImage *)image
{
    CGSize size = image.size;
    UIGraphicsBeginImageContext(CGSizeMake(360, 360 * size.height / size.width));
    
    [image drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.width * size.height / size.width)];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
    
}
-(UILabel *)nameLabel
{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.contentImageView.frame) + kSpaceW/568.0*kScreenHeight, kSpaceH/568.0*kScreenHeight, [UIScreen mainScreen].bounds.size.width - CGRectGetMaxX(self.contentImageView.frame) - 2 * kSpaceW/320.0*kScreenWidth, kLabelHeight/568.0*kScreenHeight)];
        //        self.nameLabel.backgroundColor = [UIColor orangeColor];
        _nameLabel.font = [UIFont systemFontOfSize:13];
        _nameLabel.numberOfLines = 0;
        _nameLabel.textColor = UIColorFromRGB(0x353535);
        
        
    }
    return _nameLabel;
}

-(UILabel *)stateLabel
{
    if (!_stateLabel) {
        _stateLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.contentImageView.frame) + kSpaceW/320.0*kScreenWidth, CGRectGetMaxY(self.nameLabel.frame) + 0.3*kSpaceH/568.0*kScreenHeight, self.nameLabel.frame.size.width, kLabelHeight/568.0*kScreenHeight)];
        //        self.stateLabel.backgroundColor = [UIColor orangeColor];
        _stateLabel.font = [UIFont systemFontOfSize:11];
        _stateLabel.numberOfLines = 0;
        _stateLabel.textColor = UIColorFromRGB(0xff7b94);
        
    }
    return _stateLabel;
}

-(UILabel *)dateLabel
{
    if (!_dateLabel) {
        _dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.contentImageView.frame) + kSpaceW/320.0*kScreenWidth, CGRectGetMaxY(self.stateLabel.frame) + 0.3*kSpaceH/568*kScreenHeight, self.nameLabel.frame.size.width, kLabelHeight/568.0*kScreenHeight)];
        //        self.dateLabel.backgroundColor = [UIColor orangeColor];
        _dateLabel.font = [UIFont systemFontOfSize:10];
        _dateLabel.numberOfLines = 0;
        _dateLabel.textColor = UIColorFromRGB(0x8f8f8f);
    }
    return _dateLabel;
}
- (void)setModel:(historyModel *)model {
    _model = model;
    //    self.nameLabel.text = model.productName;
    
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
