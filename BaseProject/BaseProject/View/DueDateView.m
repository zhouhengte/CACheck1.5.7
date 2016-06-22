//
//  DueDataView.m
//  BaseProject
//
//  Created by 刘子琨 on 16/3/31.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import "DueDateView.h"

@interface DueDateView ()
@property (nonatomic,strong) UIDatePicker *datePicker;
//@property (nonatomic,strong) UILabel *duedateLabel;
@property (nonatomic,strong) UILabel *firstLabel;
@property (nonatomic,strong) UILabel *secondLabel;
@property (nonatomic,strong) UILabel *thirdLabel;
@property (nonatomic,strong) UILabel *label;
@end

@implementation DueDateView

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

-(void)setDate:(NSDate *)date
{
    _date = date;
    NSDate *now = [NSDate date];
    NSTimeInterval timeInterval = [date timeIntervalSinceDate:now];
    if (timeInterval <= 0) {
        //过期
        //        _duedateLabel.text = @"已过期";
        //        _duedateLabel.textColor = [UIColor redColor];
        //        _duedateLabel.font = [UIFont systemFontOfSize:20];
        _label.text = @"商品已过期，注意及时处理";
        _firstLabel.text = @"0";
        _secondLabel.text = @"0";
        _thirdLabel.text = @"0";
    }else{
        //        _duedateLabel.textColor = UIColorFromRGB(0x34b5fe);
        self.label.text = @"此商品离过期还有";
        int totaldays = ((int)timeInterval)/(3600*24)+1;
        if (totaldays <= 10) {
            self.label.textColor = [UIColor redColor];
        }else{
            self.label.textColor = [UIColor blackColor];
        }
        if (totaldays >= 999) {
            _firstLabel.text = @"9";
            _secondLabel.text = @"9";
            _thirdLabel.text = @"9";
        }else{
            int hun = totaldays/100;
            int ten = totaldays%100/10;
            int ge = totaldays%100%10;
            _firstLabel.text = [NSString stringWithFormat:@"%d",hun];
            _secondLabel.text = [NSString stringWithFormat:@"%d",ten];
            _thirdLabel.text = [NSString stringWithFormat:@"%d",ge];
        }
        
        //        if (totaldays >= 365) {
        //            int years = totaldays/365;
        //            int days = totaldays%365;
        //            NSString *str = [NSString stringWithFormat:@"%d年 %d天",years,days];
        //            NSMutableAttributedString *dateStr = [[NSMutableAttributedString alloc]initWithString:str];
        //            NSRange yearRange = [str rangeOfString:@"年"];
        //            NSRange dayRange = [str rangeOfString:@"天"];
        //            [dateStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16.0] range:yearRange];
        //            [dateStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16.0] range:dayRange];
        //            _duedateLabel.attributedText = dateStr;
        ////        }else if (totaldays >= 30){
        ////            int mouths = totaldays/30;
        ////            int days = totaldays%30;
        ////            NSString *str = [NSString stringWithFormat:@"%d个月 %d天",mouths,days];
        ////            NSMutableAttributedString *dateStr = [[NSMutableAttributedString alloc]initWithString:str];
        ////            NSRange mouthRange = [str rangeOfString:@"个月"];
        ////            NSRange dayRange = [str rangeOfString:@"天"];
        ////            [dateStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16.0] range:mouthRange];
        ////            [dateStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16.0] range:dayRange];
        ////            _duedateLabel.attributedText = dateStr;
        //        }else{
        //            NSString *str = [NSString stringWithFormat:@"%d天",totaldays];
        //            NSMutableAttributedString *dateStr = [[NSMutableAttributedString alloc]initWithString:str];
        //            NSRange dayRange = [str rangeOfString:@"天"];
        //            [dateStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16.0] range:dayRange];
        //            _duedateLabel.attributedText = dateStr;
        //            if (totaldays <= 10) {
        //                _duedateLabel.textColor = [UIColor redColor];
        //            }
        //        }
    }
    
}

-(instancetype)initWithFrame:(CGRect)frame andJudgeStr:(NSString *)judgeStr
{
    self = [super initWithFrame:CGRectMake(0, 0, kScreenWidth, frame.size.height)];
    
    //    UIImageView *backgroundImageView = [[UIImageView alloc]initWithFrame:self.frame];
    //    backgroundImageView.image = [UIImage imageNamed:@""];
    self.backgroundColor = [UIColor whiteColor];
    
    UILabel *label = [[UILabel alloc]init];
    label.frame = CGRectMake(0, 30, 200, 16);
    label.center = CGPointMake(self.center.x, label.center.y);
    label.font = [UIFont systemFontOfSize:20];
    label.text = @"请设置过期日期";
    label.textAlignment = NSTextAlignmentCenter;
    [self addSubview:label];
    
    self.datePicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, 70, 300, 200)];
    _datePicker.datePickerMode = UIDatePickerModeDate;
    _datePicker.minimumDate = [NSDate dateWithTimeIntervalSinceNow:86400];
    _datePicker.center = CGPointMake(self.center.x, _datePicker.center.y);
    [self addSubview:_datePicker];
    
    //拿到 存有 所有 推送的数组
    NSArray * notiArray = [[UIApplication sharedApplication] scheduledLocalNotifications];
    //遍历这个数组 根据 key 拿到我们想要的 UILocalNotification
    for (UILocalNotification * loc in notiArray) {
        if ([[loc.userInfo objectForKey:@"barcode"] isEqualToString:judgeStr]) {
            //如果该产品已存在推送，显示推送日期
            if ([loc.userInfo objectForKey:@"duedate"]) {
                _datePicker.date = [loc.userInfo objectForKey:@"duedate"];
            }
        }
    }
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = UIColorFromRGB(0x34b5fe);
    [button setTitle:@"确定" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(confirmClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self);
        make.bottom.mas_equalTo(self);
        make.height.mas_equalTo(48);
    }];
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelButton setImage:[UIImage imageNamed:@"叉2"] forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:cancelButton];
    [cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.right.mas_equalTo(-12);
        make.size.mas_equalTo(CGSizeMake(38, 34));
    }];
    
    
    
    
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame andDate:(NSDate *)date
{
    self = [super initWithFrame:CGRectMake(0, 0, kScreenWidth, frame.size.height)];
    
    UIImageView *backgroundImageView = [[UIImageView alloc]init];
    backgroundImageView.image = [UIImage imageNamed:@"背景"];
    [self addSubview:backgroundImageView];
    [backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(self);
        make.bottom.mas_equalTo(48);
    }];
    
    
    //新的显示
    UIImageView *duedateImageView = [[UIImageView alloc]init];
    [self addSubview:duedateImageView];
    [duedateImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self);
        make.size.mas_equalTo(CGSizeMake(178, 67));
    }];
    [duedateImageView setImage:[UIImage imageNamed:@"到期日期2"]];
    
    self.firstLabel = [[UILabel alloc]init];
    [duedateImageView addSubview:_firstLabel];
    [_firstLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.mas_equalTo(0);
        make.width.mas_equalTo(44);
    }];
    _firstLabel.textAlignment = NSTextAlignmentCenter;
    _firstLabel.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:40];
    _firstLabel.textColor = UIColorFromRGB(0x34b5fe);
    
    self.secondLabel = [[UILabel alloc]init];
    [duedateImageView addSubview:_secondLabel];
    [_secondLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(45);
        make.top.bottom.mas_equalTo(0);
        make.width.mas_equalTo(44);
    }];
    _secondLabel.textAlignment = NSTextAlignmentCenter;
    _secondLabel.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:40];
    _secondLabel.textColor = UIColorFromRGB(0x34b5fe);
    
    self.thirdLabel = [[UILabel alloc]init];
    [duedateImageView addSubview:_thirdLabel];
    [_thirdLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-45);
        make.top.bottom.mas_equalTo(0);
        make.width.mas_equalTo(44);
    }];
    _thirdLabel.textAlignment = NSTextAlignmentCenter;
    _thirdLabel.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:40];
    _thirdLabel.textColor = UIColorFromRGB(0x34b5fe);
    
    UILabel *dayLabel = [[UILabel alloc]init];
    [duedateImageView addSubview:dayLabel];
    [dayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(-1);
        make.right.mas_equalTo(0);
        make.width.mas_equalTo(44);
    }];
    dayLabel.textAlignment = NSTextAlignmentCenter;
    dayLabel.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:31];
    dayLabel.textColor = UIColorFromRGB(0x34b5fe);
    dayLabel.text = @"天";
    
    UIView *whiteLine = [[UIView alloc]init];
    [duedateImageView addSubview:whiteLine];
    [whiteLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.center.mas_equalTo(0);
        make.height.mas_equalTo(1);
    }];
    whiteLine.backgroundColor = [UIColor whiteColor];
    
    //不知道为什么用下面这种方法无法居中，而且不好用，放弃
    //    NSMutableParagraphStyle *
    //    style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    //    style.lineSpacing = 0;//增加行高
    //    style.headIndent = 0;//头部缩进，相当于左padding
    //    style.tailIndent = 0;//相当于右padding
    //    style.lineHeightMultiple = 1;//行间距是多少倍
    //    style.alignment = NSTextAlignmentCenter;//对齐方式
    //    style.firstLineHeadIndent = 10;//首行头缩进
    //    style.paragraphSpacing = 0;//段落后面的间距
    //    style.paragraphSpacingBefore = 0;//段落之前的间距
    //
    //    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:@"057"];
    //    [attrString addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, 3)];
    //    [attrString addAttribute:NSKernAttributeName value:@22 range:NSMakeRange(0, 3)];//字符间距
    //    firstLabel.attributedText = attrString;
    
    
    
    
    //    UIImageView *imageView = [[UIImageView alloc]init];
    //    [self addSubview:imageView];
    //    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.center.mas_equalTo(self);
    //        //make.centerX.mas_equalTo(self);
    //        make.size.mas_equalTo(CGSizeMake(206, 62));
    //    }];
    
    self.label = [[UILabel alloc]init];
    [self addSubview:_label];
    self.label.textAlignment = NSTextAlignmentCenter;
    self.label.text = @"此商品离过期还有";
    self.label.font = [UIFont systemFontOfSize:18];
    self.label.textColor = [UIColor blackColor];
    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(duedateImageView.mas_top).mas_equalTo(-20);
        make.centerX.mas_equalTo(self);
    }];
    
    //    imageView.contentMode = UIViewContentModeCenter;
    //    imageView.image = [UIImage imageNamed:@"闹钟"];
    
    //    self.duedateLabel = [[UILabel alloc]init];
    //    _duedateLabel.textAlignment = NSTextAlignmentCenter;
    //    _duedateLabel.font = [UIFont systemFontOfSize:27];
    NSDate *now = [NSDate date];
    NSTimeInterval timeInterval = [date timeIntervalSinceDate:now];
    if (timeInterval <= 0) {
        //过期
        //        _duedateLabel.text = @"已过期";
        //        _duedateLabel.textColor = [UIColor redColor];
        self.label.text = @"商品已过期，注意及时处理";
        self.label.textColor = [UIColor redColor];
        _firstLabel.text = @"0";
        _secondLabel.text = @"0";
        _thirdLabel.text = @"0";
        //_duedateLabel.font = [UIFont systemFontOfSize:20];
    }else{
        //_duedateLabel.textColor = UIColorFromRGB(0x34b5fe);
        int totaldays = ((int)timeInterval)/(3600*24)+1;
        if (totaldays <= 10) {
            self.label.textColor = [UIColor redColor];
        }
        if (totaldays >= 999) {
            _firstLabel.text = @"9";
            _secondLabel.text = @"9";
            _thirdLabel.text = @"9";
        }else{
            int hun = totaldays/100;
            int ten = totaldays%100/10;
            int ge = totaldays%100%10;
            _firstLabel.text = [NSString stringWithFormat:@"%d",hun];
            _secondLabel.text = [NSString stringWithFormat:@"%d",ten];
            _thirdLabel.text = [NSString stringWithFormat:@"%d",ge];
        }
        //        if (totaldays >= 365) {
        //            int years = totaldays/365;
        //            int days = totaldays%365;
        //            NSString *str = [NSString stringWithFormat:@"%d年 %d天",years,days];
        //            NSMutableAttributedString *dateStr = [[NSMutableAttributedString alloc]initWithString:str];
        //            NSRange yearRange = [str rangeOfString:@"年"];
        //            NSRange dayRange = [str rangeOfString:@"天"];
        //            [dateStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16.0] range:yearRange];
        //            [dateStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16.0] range:dayRange];
        //            _duedateLabel.attributedText = dateStr;
        ////        }else if (totaldays >= 30){
        ////            int mouths = totaldays/30;
        ////            int days = totaldays%30;
        ////            NSString *str = [NSString stringWithFormat:@"%d个月 %d天",mouths,days];
        ////            NSMutableAttributedString *dateStr = [[NSMutableAttributedString alloc]initWithString:str];
        ////            NSRange mouthRange = [str rangeOfString:@"个月"];
        ////            NSRange dayRange = [str rangeOfString:@"天"];
        ////            [dateStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16.0] range:mouthRange];
        ////            [dateStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16.0] range:dayRange];
        ////            _duedateLabel.attributedText = dateStr;
        //        }else{
        //
        //            NSString *str = [NSString stringWithFormat:@"%d天",totaldays];
        //            NSMutableAttributedString *dateStr = [[NSMutableAttributedString alloc]initWithString:str];
        //            NSRange dayRange = [str rangeOfString:@"天"];
        //            [dateStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16.0] range:dayRange];
        //            _duedateLabel.attributedText = dateStr;
        //            if (totaldays <= 10) {
        //                _duedateLabel.textColor = [UIColor redColor];
        //            }
        //        }
        
    }
    //    [self addSubview:_duedateLabel];
    //    [_duedateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    //        //make.top.mas_equalTo(157);
    //        make.center.mas_equalTo(self);
    //        make.size.mas_equalTo(CGSizeMake(180, 40));
    //    }];
    
    UIButton *updateButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [updateButton setTitle:@"修改过期日期" forState:UIControlStateNormal];
    [updateButton setTitleColor:UIColorFromRGB(0x34b5fe) forState:UIControlStateNormal];
    [updateButton addTarget:self action:@selector(updateClick) forControlEvents:UIControlEventTouchUpInside];
    updateButton.layer.borderWidth = 1;
    updateButton.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
    [self addSubview:updateButton];
    [updateButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.mas_equalTo(self);
        make.right.mas_equalTo(-kScreenWidth/2);
        make.height.mas_equalTo(48);
    }];
    
    UIButton *commentButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [commentButton setTitle:@"评价商品" forState:UIControlStateNormal];
    [commentButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    commentButton.backgroundColor = UIColorFromRGB(0x34b5fe);
    [commentButton addTarget:self action:@selector(commentClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:commentButton];
    [commentButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.mas_equalTo(self);
        make.left.mas_equalTo(updateButton.mas_right);
        make.height.mas_equalTo(48);
    }];
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelButton setImage:[UIImage imageNamed:@"叉2"] forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(closeClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:cancelButton];
    [cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(24);
        make.right.mas_equalTo(-12);
        make.size.mas_equalTo(CGSizeMake(38, 34));
    }];
    
    return self;
}


-(void)confirmClick
{
    //NSLog(@"确认到期日期:%@",self.datePicker.date);
    self.confirmBlock(self.datePicker.date);
}

-(void)cancelClick
{
    self.cancelBlock();
}

-(void)closeClick
{
    self.closeBlock();
}

-(void)updateClick
{
    self.updateBlock();
}
-(void)commentClick
{
    self.commentBlock();
}
@end
