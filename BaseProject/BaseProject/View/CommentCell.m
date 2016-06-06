//
//  CommentCell.m
//  BaseProject
//
//  Created by 刘子琨 on 16/4/27.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import "CommentCell.h"

@interface CommentCell ()

@property (weak, nonatomic) IBOutlet UIImageView *starImageView;
@property (weak, nonatomic) IBOutlet UILabel *commentLabel;
@property (weak, nonatomic) IBOutlet UILabel *useridLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@end

@implementation CommentCell

-(void)setCommentDic:(NSDictionary *)commentDic{
    self.commentLabel.text = [commentDic objectForKey:@"ccomment"];
    self.useridLabel.text = [[commentDic objectForKey:@"username"] stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
    self.dateLabel.text = [[commentDic objectForKey:@"createtime"] substringToIndex:10];
    
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    float score = [[commentDic objectForKey:@"levelscore"] floatValue];
    UIBezierPath *toPath = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, 84*score/5, 13)];
    maskLayer.path = toPath.CGPath;
    self.starImageView.layer.mask = maskLayer;

}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
