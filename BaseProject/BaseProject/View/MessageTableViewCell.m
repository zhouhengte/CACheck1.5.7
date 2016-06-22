//
//  MessageTableViewCell.m
//  BaseProject
//
//  Created by 刘子琨 on 16/4/5.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import "MessageTableViewCell.h"

@interface MessageTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *leftImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *bottomLabel;


@end

@implementation MessageTableViewCell

-(void)setMessageDic:(NSDictionary *)messageDic
{
    _messageDic = messageDic;
    
    self.bottomLabel.textColor = UIColorFromRGB(0x24b5fe);
    
//    NSDate *duedate = messageDic[@"duedate"];
//    NSDate *now = [NSDate date];
//    NSTimeInterval timeInterval = [duedate timeIntervalSinceDate:now];
//    int remainingDays = 0;
//    if (timeInterval <= 0) {
//        remainingDays = 0;
//        self.titleLabel.text = [NSString stringWithFormat:@"您的商品\"%@\"已过期,请查看", messageDic[@"productname"]];
//    }else{
//        remainingDays = ((int)timeInterval)/(3600*24)+1;
//        //self.titleLabel.text = [NSString stringWithFormat:@"请注意您扫描过的\"%@\"保质期还剩%d天", messageDic[@"productname"],remainingDays];
//        self.titleLabel.text = [NSString stringWithFormat:@"您的商品\"%@\"即将过期，请查看", messageDic[@"productname"]];
//    }
    
    if ([messageDic[@"type"] integerValue] == 1) {
        self.titleLabel.text = [NSString stringWithFormat:@"您的商品\"%@\"即将过期，请查看", messageDic[@"productname"]];
    }else if ([messageDic[@"type"] integerValue] == 2) {
        self.titleLabel.text = [NSString stringWithFormat:@"您的商品\"%@\"已过期,请查看", messageDic[@"productname"]];
    }else if ([messageDic[@"type"] integerValue] == 3) {
        self.titleLabel.text = [NSString stringWithFormat:@"您的商品\"%@\"已使用7天了，去评价一下吧～", messageDic[@"productname"]];
    }else{
        NSDate *duedate = messageDic[@"duedate"];
        NSDate *now = [NSDate date];
        NSTimeInterval timeInterval = [duedate timeIntervalSinceDate:now];
        int remainingDays = 0;
        if (timeInterval <= 0) {
            remainingDays = 0;
            self.titleLabel.text = [NSString stringWithFormat:@"您的商品\"%@\"已过期,请查看", messageDic[@"productname"]];
        }else{
            remainingDays = ((int)timeInterval)/(3600*24)+1;
            //self.titleLabel.text = [NSString stringWithFormat:@"请注意您扫描过的\"%@\"保质期还剩%d天", messageDic[@"productname"],remainingDays];
            self.titleLabel.text = [NSString stringWithFormat:@"您的商品\"%@\"即将过期，请查看", messageDic[@"productname"]];
        }
    }
    self.titleLabel.textColor = UIColorFromRGB(0x353535);
    
    NSString *imageUrl = messageDic[@"imageUrl"];
    NSURL *url = [NSURL URLWithString:imageUrl];
    [self.leftImageView setImageWithURL:url placeholderImage:[UIImage imageNamed:@"icon1024"]];
    self.leftImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.leftImageView.clipsToBounds = YES;
    
    NSDate *date = messageDic[@"firedate"];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.timeZone = [NSTimeZone localTimeZone];
    [dateFormatter setDateFormat:@"MM-dd HH:mm"];
    NSString *receiveTimeStr = [dateFormatter stringFromDate:date];
    self.timeLabel.text = receiveTimeStr;
    self.timeLabel.textColor = UIColorFromRGB(0x8f8f8f);
    
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
