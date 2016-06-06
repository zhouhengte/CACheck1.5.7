//
//  CommentViewController.m
//  BaseProject
//
//  Created by 刘子琨 on 16/4/25.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import "CommentViewController.h"
#import "LoginViewController.h"
#import "UIButton+EnlargeEdge.h"
#import "CommentCell.h"
#import <MJRefresh.h>
#import "CommentNetManager.h"
#import "LoginViewController.h"

@interface CommentViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITextView *textView;
@property (nonatomic,strong)UIView *editView;
@property (nonatomic,strong)UIView *grayTranslucentView;
@property (nonatomic,strong)UILabel *label;
@property (nonatomic,strong)UIButton *firstStar;
@property (nonatomic,strong)UIButton *secondStar;
@property (nonatomic,strong)UIButton *thirdStar;
@property (nonatomic,strong)UIButton *forthStar;
@property (nonatomic,strong)UIButton *fifthStar;
@property (nonatomic,assign)BOOL isScored;
@property (nonatomic,assign)NSInteger clickStar;
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *dataArray;
@property (nonatomic,strong)NSNumber *totalScore;
@property (nonatomic,strong)NSString *commentStr;
@property (nonatomic,strong)UIView *emptyView;
@property (nonatomic,strong)UILabel *placeholdLabel;

@property (nonatomic,strong)UIImageView *foregroundImageView;
@property (nonatomic,strong)UILabel *totalScoreLabel;

@property(nonatomic,assign)NSInteger pageCount;
@property(nonatomic,assign)NSInteger pageCountTotal;

@end

@implementation CommentViewController

-(NSMutableArray *)commentArray
{
    if (!_commentArray) {
        _commentArray = [NSMutableArray array];
    }
    return _commentArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.commentArray = [self.commentDic[@"Data"] mutableCopy];
    self.pageCountTotal = [self.commentDic[@"totalpage"] integerValue];
    self.pageCount = [self.commentDic[@"currentpage"] integerValue];
    
    self.totalScore = 0;
    
    self.view.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
    //重新设置导航栏，隐藏原生导航栏，手动绘制新的导航栏，使右滑手势跳转时能让导航栏跟着变化
    [self setNavigationBar];
    
    [self setCommentTableView];
    
    if (self.commentArray.count == 0) {
        [self setEmptyView];
    }
    
    
    [self setBottom];
    
    [self setEditView];
    
    self.isScored = NO;
    
}

// 有键盘弹起,此方法就会被自动执行
-(void)openKeyboard:(NSNotification *)noti
{
    // 获取键盘的 frame 数据
    CGRect  keyboardFrame = [noti.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    // 获取键盘动画的种类
    int options = [noti.userInfo[UIKeyboardAnimationCurveUserInfoKey] intValue];
    
    // 获取键盘动画的时长
    NSTimeInterval duration = [noti.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    CGFloat height = self.textView.contentSize.height > 83.0 ? 83.0 : self.textView.contentSize.height;
    
    // 在动画内调用 layoutIfNeeded 方法
    [UIView animateWithDuration:duration delay:0 options:options animations:^{
        [self.editView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.height.mas_equalTo(height + 61);
            make.bottom.mas_equalTo(-keyboardFrame.size.height);
        }];
        [self.editView layoutIfNeeded];
        
    } completion:nil];
    
}

-(void)closeKeyboard:(NSNotification *)noti
{
    self.grayTranslucentView.hidden = YES;
    // 获取键盘动画的种类
    int options = [noti.userInfo[UIKeyboardAnimationCurveUserInfoKey] intValue];
    
    // 获取键盘动画的时长
    NSTimeInterval duration = [noti.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    // 在动画内调用 layoutIfNeeded 方法
    [UIView animateWithDuration:duration delay:0 options:options animations:^{
        [self.editView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.height.mas_equalTo(94);
            make.bottom.mas_equalTo(94);
        }];
        [self.view layoutIfNeeded];
    } completion:nil];
    
}

//根据输入框内容改变行数
-(void)textChanged:(NSNotification *)noti
{
    //NSLog(@"%f",self.textView.contentSize.height);
    self.placeholdLabel.hidden = self.textView.hasText;
    CGFloat height = self.textView.contentSize.height > 83.0 ? 83.0 : self.textView.contentSize.height;
    //CGFloat height = self.textView.contentSize.height > 83.0 ? 83.0 : ceilf([_textView sizeThatFits:_textView.frame.size].height);
    
    [UIView animateWithDuration:0.1 animations:^{
        [self.editView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(height+61);
        }];
    }];
    //self.textView.scrollEnabled = YES;
    [self.textView scrollRangeToVisible:NSMakeRange(self.textView.text.length - 2, 1)];
    
}


//// 点击空白处,收起键盘
//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    [self.view endEditing:YES];
//}

-(void)setEmptyView
{
    self.tableView.hidden = YES;
    self.emptyView = [[UIView alloc]init];
    _emptyView.frame = CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64);
    _emptyView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_emptyView];
    UIImageView *imageView = [[UIImageView alloc] init];
    //    UIImageView *imageView = [[UIImageView alloc] init];
    
    //    imageView.backgroundColor= [UIColor redColor];
    
    imageView.image = [UIImage imageNamed:@"消息空"];
    [_emptyView addSubview:imageView];
    
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        //        make.centerY.equalTo(self.view);
        //        make.top.equalTo(imageViewBig1).with.offset(37/568.0*kScreenHeight);
        make.top.equalTo(self.view).with.offset(0.4*kScreenHeight);
        make.size.mas_equalTo(CGSizeMake(65, 60));
    }];
    
    UILabel *label = [[UILabel alloc]init];
    [_emptyView addSubview:label];
    label.textColor = UIColorFromRGB(0xc3c3c3);
    label.text = @"暂无评价";
    label.font = [UIFont systemFontOfSize:17];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(imageView.mas_bottom).mas_equalTo(10);
    }];

}

-(void)setNavigationBar
{
    [self.navigationController setNavigationBarHidden:YES];
    
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = [UIColor colorWithRed:52/255.0 green:181/255.0 blue:254/255.0 alpha:1.0];
    [self.view addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(self.view);
        make.right.mas_equalTo(self.view);
        make.height.mas_equalTo(21);
    }];
    
    UILabel *label = [[UILabel alloc]init];
    label.backgroundColor = [UIColor colorWithRed:52/255.0 green:181/255.0 blue:254/255.0 alpha:1.0];
    label.text = @"评价";
    label.font = [UIFont systemFontOfSize:18];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(20);
        make.left.mas_equalTo(self.view);
        make.right.mas_equalTo(self.view);
        make.height.mas_equalTo(44);
    }];
    
    
    UIButton *button = [[UIButton alloc]init];
    [button setTitle:@"返回" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(backToRecordDetailViewController:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(5);
        make.top.mas_equalTo(20);
        make.size.mas_equalTo(CGSizeMake(80, 44));
    }];
    //手动添加highlight效果
    button.tag = 101;
    [button addTarget:self action:@selector(tapBack:) forControlEvents:UIControlEventTouchDown];
    [button addTarget:self action:@selector(tapUp:) forControlEvents:UIControlEventTouchUpOutside];
    
    UIImage *image = [UIImage imageNamed:@"返回箭头"];
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = image;
    [button addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(5);
        make.top.mas_equalTo(13);
        make.size.mas_equalTo(CGSizeMake(11, 19));
    }];
    
    //由于改写了leftBarButtonItem,所以需要重新定义右滑返回手势
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    
}

-(void)setBottom
{
    UIView *view = [[UIView alloc]init];
    view.layer.borderWidth = 0.5;
    view.layer.borderColor = [UIColor colorWithRed:199/255.0 green:199/255.0 blue:199/255.0 alpha:1].CGColor;
    [self.view addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.mas_equalTo(0);
        make.height.mas_equalTo(60);
    }];
    
    UIView *centerView = [[UIView alloc]init];
    centerView.layer.borderWidth = 0.5;
    centerView.layer.cornerRadius = 4;
    centerView.layer.borderColor = UIColorFromRGB(0xcccccc).CGColor;
    centerView.backgroundColor = [UIColor whiteColor];
    [view addSubview:centerView];
    [centerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(12.5, 12.5, 12.5, 12.5));
    }];
    centerView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(click:)];
    [centerView addGestureRecognizer:tap];
    
    UIImageView *imageView =[[UIImageView alloc]init];
    [imageView setImage:[UIImage imageNamed:@"评论"]];
    [centerView addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.left.mas_equalTo(9);
        make.size.mas_equalTo(CGSizeMake(13, 13));
    }];
    
    self.label = [[UILabel alloc]init];
    if (self.commentDic.count != 0) {
        _label.text = @"你的评价对其他人帮助很大哦～";
    }else{
        _label.text = @"快来抢第一条评价吧！";
    }
    _label.font = [UIFont systemFontOfSize:13];
    _label.textColor = [UIColor colorWithRed:180/255.0 green:180/255.0 blue:180/255.0 alpha:1];
    [centerView addSubview:_label];
    [_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(31);
        make.top.right.bottom.mas_equalTo(0);
    }];
}

-(void)tapBack:(UIButton *)button
{
    button.alpha = 0.5;
}
-(void)tapUp:(UIButton *)button
{
    button.alpha = 1;
}

-(void)click:(UIView *)sender
{
    //NSLog(@"点击了评价");
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"login"] isEqualToString: @"登录成功"]) {
        NSLog(@"已登陆");
        self.grayTranslucentView.hidden = NO;
        [self.textView becomeFirstResponder];
        
        
    }else{
//        UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//        LoginViewController *loginVC = [mainStoryBoard instantiateViewControllerWithIdentifier:@"loginViewController"];
//        loginVC.from = @"comment";
//        [self.navigationController pushViewController:loginVC animated:YES];
        [self performSegueWithIdentifier:@"loginSegue" sender:nil];
    }
}

-(void)setEditView
{
    self.clickStar = 0;
    
    self.grayTranslucentView = [[UIView alloc]init];
    _grayTranslucentView.frame = self.view.frame;
    _grayTranslucentView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    UITapGestureRecognizer *blockTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(blockClick:)];
    [_grayTranslucentView addGestureRecognizer:blockTap];
    [self.view addSubview:_grayTranslucentView];
    _grayTranslucentView.hidden = YES;
    
    self.editView = [[UIView alloc]init];
    self.editView.backgroundColor = [UIColor colorWithRed:246/255.0 green:246/255.0 blue:249/255.0 alpha:1];
    [self.view addSubview:self.editView];
    [self.editView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(94);
        make.bottom.mas_equalTo(94);
    }];
    
    UILabel *label = [[UILabel alloc]init];
    label.text = @"轻点星形来评分";
    label.font = [UIFont systemFontOfSize:12];
    label.textColor = [UIColor colorWithRed:160/255.0 green:160/255.0 blue:160/255.0 alpha:1];
    [self.editView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12);
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(51);
    }];
    
    UIButton *firstStar = [[UIButton alloc]init];
    self.firstStar = firstStar;
    [firstStar setEnlargeEdge:20];
    [firstStar setImage:[UIImage imageNamed:@"点击的评分1"] forState:UIControlStateNormal];
    [firstStar addTarget:self action:@selector(clickStar:) forControlEvents:UIControlEventTouchUpInside];
    firstStar.tag = 1;
    [self.editView addSubview:firstStar];
    [firstStar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(label);
        make.left.mas_equalTo(label.mas_right).mas_equalTo(12);
        make.size.mas_equalTo(CGSizeMake(18, 18));
    }];
    UIButton *secondStar = [[UIButton alloc]init];
    self.secondStar = secondStar;
    [secondStar setEnlargeEdge:20];
    [secondStar setImage:[UIImage imageNamed:@"点击的评分1"] forState:UIControlStateNormal];
    [secondStar addTarget:self action:@selector(clickStar:) forControlEvents:UIControlEventTouchUpInside];
    secondStar.tag = 2;
    [self.editView addSubview:secondStar];
    [secondStar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(label);
        make.left.mas_equalTo(firstStar.mas_right).mas_equalTo(25);
        make.size.mas_equalTo(CGSizeMake(18, 18));
    }];
    UIButton *thirdStar = [[UIButton alloc]init];
    self.thirdStar = thirdStar;
    [thirdStar setEnlargeEdge:20];
    [thirdStar setImage:[UIImage imageNamed:@"点击的评分1"] forState:UIControlStateNormal];
    [thirdStar addTarget:self action:@selector(clickStar:) forControlEvents:UIControlEventTouchUpInside];
    thirdStar.tag = 3;
    [self.editView addSubview:thirdStar];
    [thirdStar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(label);
        make.left.mas_equalTo(secondStar.mas_right).mas_equalTo(25);
        make.size.mas_equalTo(CGSizeMake(18, 18));
    }];
    UIButton *forthStar = [[UIButton alloc]init];
    self.forthStar = forthStar;
    [forthStar setEnlargeEdge:20];
    [forthStar setImage:[UIImage imageNamed:@"点击的评分1"] forState:UIControlStateNormal];
    [forthStar addTarget:self action:@selector(clickStar:) forControlEvents:UIControlEventTouchUpInside];
    forthStar.tag = 4;
    [self.editView addSubview:forthStar];
    [forthStar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(label);
        make.left.mas_equalTo(thirdStar.mas_right).mas_equalTo(25);
        make.size.mas_equalTo(CGSizeMake(18, 18));
    }];
    UIButton *fifthStar = [[UIButton alloc]init];
    self.fifthStar = fifthStar;
    [fifthStar setEnlargeEdge:20];
    [fifthStar setImage:[UIImage imageNamed:@"点击的评分1"] forState:UIControlStateNormal];
    [fifthStar addTarget:self action:@selector(clickStar:) forControlEvents:UIControlEventTouchUpInside];
    fifthStar.tag = 5;
    [self.editView addSubview:fifthStar];
    [fifthStar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(label);
        make.left.mas_equalTo(forthStar.mas_right).mas_equalTo(25);
        make.size.mas_equalTo(CGSizeMake(18, 18));
    }];
    
    UIView *view = [[UIView alloc]init];
    //self.textView.contentInset = UIEdgeInsetsMake(0, 9, 0, 9);
    //self.textView.contentOffset = CGPointMake(9, 0);
    view.backgroundColor = [UIColor whiteColor];
    view.layer.borderColor = UIColorFromRGB(0xcccccc).CGColor;
    view.layer.borderWidth = 0.5;
    view.layer.cornerRadius = 4;
    view.layer.masksToBounds = YES;
    [self.editView addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12);
        make.bottom.mas_equalTo(-8);
        make.right.mas_equalTo(-46);
        make.top.mas_equalTo(51);
    }];
    
    self.placeholdLabel = [[UILabel alloc]init];
    [view addSubview:_placeholdLabel];
    [_placeholdLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.bottom.right.top.mas_equalTo(0);
    }];
    if (self.commentDic.count != 0) {
        _placeholdLabel.text = @"你的评价对其他人帮助很大哦～";
    }else{
        _placeholdLabel.text = @"快来抢第一条评价吧！";
    }
    _placeholdLabel.font = [UIFont systemFontOfSize:13];
    _placeholdLabel.textColor = [UIColor colorWithRed:180/255.0 green:180/255.0 blue:180/255.0 alpha:1];

    self.textView = [[UITextView alloc]init];
    self.textView.backgroundColor = [UIColor clearColor];
    [view addSubview:_textView];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(6);
        make.bottom.right.top.mas_equalTo(0);
    }];
    _textView.font = [UIFont systemFontOfSize:14];
    
    
    UIButton *button = [[UIButton alloc]init];
    [self.editView addSubview:button];
    [button setTitle:@"发送" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithRed:52/255.0 green:181/255.0 blue:254/255.0 alpha:1] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        //make.centerY.mas_equalTo(_textView);
        make.top.mas_equalTo(50);
        make.right.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(46, 35));
    }];
    [button addTarget:self action:@selector(sendClick:) forControlEvents:UIControlEventTouchUpInside];

}

-(void)blockClick:(UIView *)sender
{
    [self.view endEditing:YES];
}

-(void)clickStar:(UIButton *)sender
{
    if (self.clickStar == sender.tag) {
        [self.firstStar setImage:[UIImage imageNamed:@"点击的评分1"] forState:UIControlStateNormal];
        [self.secondStar setImage:[UIImage imageNamed:@"点击的评分1"] forState:UIControlStateNormal];
        [self.thirdStar setImage:[UIImage imageNamed:@"点击的评分1"] forState:UIControlStateNormal];
        [self.forthStar setImage:[UIImage imageNamed:@"点击的评分1"] forState:UIControlStateNormal];
        [self.fifthStar setImage:[UIImage imageNamed:@"点击的评分1"] forState:UIControlStateNormal];
        self.clickStar = 0;
    }else{
        self.clickStar = sender.tag;
        switch (sender.tag) {
            case 1:
                [self.firstStar setImage:[UIImage imageNamed:@"点击的评分2"] forState:UIControlStateNormal];
                [self.secondStar setImage:[UIImage imageNamed:@"点击的评分1"] forState:UIControlStateNormal];
                [self.thirdStar setImage:[UIImage imageNamed:@"点击的评分1"] forState:UIControlStateNormal];
                [self.forthStar setImage:[UIImage imageNamed:@"点击的评分1"] forState:UIControlStateNormal];
                [self.fifthStar setImage:[UIImage imageNamed:@"点击的评分1"] forState:UIControlStateNormal];
                break;
            case 2:
                [self.firstStar setImage:[UIImage imageNamed:@"点击的评分2"] forState:UIControlStateNormal];
                [self.secondStar setImage:[UIImage imageNamed:@"点击的评分2"] forState:UIControlStateNormal];
                [self.thirdStar setImage:[UIImage imageNamed:@"点击的评分1"] forState:UIControlStateNormal];
                [self.forthStar setImage:[UIImage imageNamed:@"点击的评分1"] forState:UIControlStateNormal];
                [self.fifthStar setImage:[UIImage imageNamed:@"点击的评分1"] forState:UIControlStateNormal];
                break;
            case 3:
                [self.firstStar setImage:[UIImage imageNamed:@"点击的评分2"] forState:UIControlStateNormal];
                [self.secondStar setImage:[UIImage imageNamed:@"点击的评分2"] forState:UIControlStateNormal];
                [self.thirdStar setImage:[UIImage imageNamed:@"点击的评分2"] forState:UIControlStateNormal];
                [self.forthStar setImage:[UIImage imageNamed:@"点击的评分1"] forState:UIControlStateNormal];
                [self.fifthStar setImage:[UIImage imageNamed:@"点击的评分1"] forState:UIControlStateNormal];
                break;
            case 4:
                [self.firstStar setImage:[UIImage imageNamed:@"点击的评分2"] forState:UIControlStateNormal];
                [self.secondStar setImage:[UIImage imageNamed:@"点击的评分2"] forState:UIControlStateNormal];
                [self.thirdStar setImage:[UIImage imageNamed:@"点击的评分2"] forState:UIControlStateNormal];
                [self.forthStar setImage:[UIImage imageNamed:@"点击的评分2"] forState:UIControlStateNormal];
                [self.fifthStar setImage:[UIImage imageNamed:@"点击的评分1"] forState:UIControlStateNormal];
                break;
            default:
                [self.firstStar setImage:[UIImage imageNamed:@"点击的评分2"] forState:UIControlStateNormal];
                [self.secondStar setImage:[UIImage imageNamed:@"点击的评分2"] forState:UIControlStateNormal];
                [self.thirdStar setImage:[UIImage imageNamed:@"点击的评分2"] forState:UIControlStateNormal];
                [self.forthStar setImage:[UIImage imageNamed:@"点击的评分2"] forState:UIControlStateNormal];
                [self.fifthStar setImage:[UIImage imageNamed:@"点击的评分2"] forState:UIControlStateNormal];
                break;
        }
    }
    self.isScored = YES;
}

-(void)sendClick:(UIButton *)sender
{
    [MobClick event:@"SendComment"];
    //NSLog(@"%@",self.productDic);
    //NSLog(@"%@",self.productCode);
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *userName = [userDefaults objectForKey:@"username"];
    NSString *userId = [userDefaults objectForKey:@"userid"];
    NSString *token = [userDefaults objectForKey:@"CA-Token"];
    //NSLog(@"%@",userName);
    //NSLog(@"%@",userId);
    //NSLog(@"%@",token);
    

    
    NSString *productname = [NSString new];
    NSArray *baseInfoArray = [self.productDic objectForKey:@"BaseInfo"];
    for (NSDictionary *dic in baseInfoArray) {
        if ([[dic objectForKey:@"text"] isEqualToString:@"商品名称"]) {
            productname = [dic objectForKey:@"value"];
        }
    }
    
    NSMutableDictionary *addDic = [[NSMutableDictionary alloc]init];
    


    [addDic setValue:productname forKey:@"productname"];
    [addDic setValue:userName forKey:@"username"];
    [addDic setValue:userId forKey:@"userid"];
    [addDic setValue:[NSNumber numberWithInteger:self.clickStar] forKey:@"levelscore"];
    if ([self.textView.text isEqualToString:@""]) {
        MBProgressHUD *Hud = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:Hud];
        Hud.labelText = @"请输入评价内容";
        Hud.labelFont = [UIFont systemFontOfSize:14];
        Hud.mode = MBProgressHUDModeText;
        //            hud.yOffset = 250;
        [Hud showAnimated:YES whileExecutingBlock:^{
            sleep(1.5);
            
        } completionBlock:^{
            [Hud removeFromSuperview];
        }];
        return;
    }
    if (self.textView.text.length > 500) {
        MBProgressHUD *Hud = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:Hud];
        Hud.labelText = @"评价内容不能超过500字";
        Hud.labelFont = [UIFont systemFontOfSize:14];
        Hud.mode = MBProgressHUDModeText;
        //            hud.yOffset = 250;
        [Hud showAnimated:YES whileExecutingBlock:^{
            sleep(1.5);
            
        } completionBlock:^{
            [Hud removeFromSuperview];
        }];
        return;

    }
    [addDic setValue:self.textView.text forKey:@"ccomment"];
    //NSLog(@"comment length:%lu",(unsigned long)self.textView.text.length);
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.requestSerializer setValue:@"0" forHTTPHeaderField:@"Client-Flag"];
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"CA-Token"];
    //    NSString *token = [manager.requestSerializer valueForHTTPHeaderField:@"CA-Token"];
    //    NSLog(@"catoken:%@",token);
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain",@"application/json", nil];

    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    // Set some text to show the initial status.
    hud.labelText = @"加载中";
    hud.yOffset = -20;
    
    if (self.isBarcode == NO) {
        NSString *addccodeCommentUrl = [NSString stringWithFormat:@"%@/%@",kUrl,kAddCCodeCommentUrl];
        NSString *typeid = [self.productDic objectForKey:@"typeid"];
        
        [addDic setValue:typeid forKey:@"typeid"];
        [addDic setValue:self.productCode forKey:@"ccode"];
        NSString *para = [self dictionaryToJson:addDic];
        
        NSDictionary *paraDic = @{@"json":para};
        //NSLog(@"参数:%@",paraDic);
        [manager POST:addccodeCommentUrl parameters:paraDic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            //NSLog(@"发送评论:%@",responseObject);
            if ([responseObject[@"Result"] integerValue] == 0)
            {//发送成功
                
                [self getComment];
                
                [self.view endEditing:YES];
                self.textView.text = @"";
                [self.firstStar setImage:[UIImage imageNamed:@"点击的评分1"] forState:UIControlStateNormal];
                [self.secondStar setImage:[UIImage imageNamed:@"点击的评分1"] forState:UIControlStateNormal];
                [self.thirdStar setImage:[UIImage imageNamed:@"点击的评分1"] forState:UIControlStateNormal];
                [self.forthStar setImage:[UIImage imageNamed:@"点击的评分1"] forState:UIControlStateNormal];
                [self.fifthStar setImage:[UIImage imageNamed:@"点击的评分1"] forState:UIControlStateNormal];
                self.clickStar = 0;
                

//                MBProgressHUD *Hud = [[MBProgressHUD alloc] initWithView:self.view];
//                [self.view addSubview:Hud];
//                Hud.labelText = @"发送成功";
//                Hud.labelFont = [UIFont systemFontOfSize:14];
//                Hud.mode = MBProgressHUDModeCustomView;
//                UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
//                imageView.image = [UIImage imageNamed:@"对勾"];
//                Hud.customView = imageView;
//                //            hud.yOffset = 250;
//                [Hud showAnimated:YES whileExecutingBlock:^{
//                    sleep(1.5);
//                    
//                } completionBlock:^{
//                    [Hud removeFromSuperview];
//                }];
                
                
                dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
                    // Do something useful in the background and update the HUD periodically.
                    //MBProgressHUD *hud = [MBProgressHUD HUDForView:self.navigationController.view];
                    // Indeterminate mode
                    UIImage *image = [UIImage imageNamed:@"对勾"];
                    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
                    imageView.image = image;
                    //hud.customView = imageView;
                    hud.mode = MBProgressHUDModeText;
                    hud.labelText = @"发送成功";
                    sleep(1.5);
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [hud hide:YES];
                        [hud removeFromSuperview];
                    });
                });
            }else if ([responseObject[@"Result"] integerValue] == 1){
                dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
                    // Do something useful in the background and update the HUD periodically.
                    //MBProgressHUD *hud = [MBProgressHUD HUDForView:self.navigationController.view];
                    // Indeterminate mode
                    hud.mode = MBProgressHUDModeText;
                    hud.labelText = @"发送失败";
                    sleep(1.5);
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [hud hide:YES];
                        [hud removeFromSuperview];
                    });
                });
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            //NSLog(@"发送评论失败%@",error);
            dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
                // Do something useful in the background and update the HUD periodically.
                //MBProgressHUD *hud = [MBProgressHUD HUDForView:self.navigationController.view];
                // Indeterminate mode
                hud.mode = MBProgressHUDModeText;
                hud.labelText = @"发送失败";
                sleep(1.5);
                dispatch_async(dispatch_get_main_queue(), ^{
                    [hud hide:YES];
                    [hud removeFromSuperview];
                });
            });

        }];

    }else{
        NSString *addBarCodeCommentUrl = [NSString stringWithFormat:@"%@/%@",kUrl,kAddBarCodeCommentUrl];
        [addDic setValue:self.productCode forKey:@"barcode"];
        NSString *para = [self dictionaryToJson:addDic];
        NSDictionary *paraDic = @{@"json":para};
        [manager POST:addBarCodeCommentUrl parameters:paraDic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            [self getBarcodeComment];
            
            [self.view endEditing:YES];
            self.textView.text = @"";
            [self.firstStar setImage:[UIImage imageNamed:@"点击的评分1"] forState:UIControlStateNormal];
            [self.secondStar setImage:[UIImage imageNamed:@"点击的评分1"] forState:UIControlStateNormal];
            [self.thirdStar setImage:[UIImage imageNamed:@"点击的评分1"] forState:UIControlStateNormal];
            [self.forthStar setImage:[UIImage imageNamed:@"点击的评分1"] forState:UIControlStateNormal];
            [self.fifthStar setImage:[UIImage imageNamed:@"点击的评分1"] forState:UIControlStateNormal];
            self.clickStar = 0;
            
            
            dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
                // Do something useful in the background and update the HUD periodically.
                //MBProgressHUD *hud = [MBProgressHUD HUDForView:self.navigationController.view];
                hud.mode = MBProgressHUDModeText;
                hud.labelText = @"发送成功";
                sleep(1.5);
                dispatch_async(dispatch_get_main_queue(), ^{
                    [hud hide:YES];
                    [hud removeFromSuperview];
                });
            });

        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            //NSLog(@"发送评论失败%@",error);
            dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
                // Do something useful in the background and update the HUD periodically.
                //MBProgressHUD *hud = [MBProgressHUD HUDForView:self.navigationController.view];
                //hud.customView = imageView;
                hud.mode = MBProgressHUDModeText;
                hud.labelText = @"发送失败";
                sleep(1.5);
                dispatch_async(dispatch_get_main_queue(), ^{
                    [hud hide:YES];
                    [hud removeFromSuperview];
                });
            });

        }];
    }
    
    
    
}


-(void)setCommentTableView
{
    self.tableView = [[UITableView alloc]init];
    self.tableView.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(64);
        make.bottom.mas_equalTo(-60);
    }];
    
    UIView *headerview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 54)];
    headerview.backgroundColor = [UIColor colorWithRed:246/255.0 green:246/255.0 blue:249/255.0 alpha:1];
    UILabel *label = [[UILabel alloc]init];
    label.font = [UIFont systemFontOfSize:14];
    label.text = @"总评分";
    label.textAlignment = NSTextAlignmentLeft;
    [headerview addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        //make.height.mas_equalTo(14);
        make.left.mas_equalTo(12);
    }];
    
    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"五星空"]];
    [headerview addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(label.mas_right).mas_equalTo(12);
        make.size.mas_equalTo(CGSizeMake(84, 12));
        make.centerY.mas_equalTo(0);
    }];
    
    self.totalScore = [NSNumber numberWithFloat:([self.commentDic[@"totalscore1"] floatValue]/[self.commentDic[@"totalcnt"] floatValue])];
    
    //NSLog(@"commentDic:%@",self.commentDic);
    
    self.foregroundImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"五星全"]];
    [headerview addSubview:_foregroundImageView];
    [_foregroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(label.mas_right).mas_equalTo(12);
        make.size.mas_equalTo(CGSizeMake(84, 12));
        make.centerY.mas_equalTo(0);
    }];
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    //UIBezierPath *fromPath = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, 1, 12)];
    UIBezierPath *toPath = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, 84*[self.totalScore floatValue]/5, 12)];
    maskLayer.path = toPath.CGPath;
    //maskLayer.speed = 1;
    //CABasicAnimation *basicAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
    //basicAnimation.fromValue = fromPath;
    //basicAnimation.toValue = toPath;
    //basicAnimation.duration = 5;
    //[maskLayer addAnimation:basicAnimation forKey:@"pathAnimation"];
    _foregroundImageView.layer.mask = maskLayer;
    

    
    
    self.totalScoreLabel = [[UILabel alloc]init];
    _totalScoreLabel.text = [NSString stringWithFormat:@"%.1f分",round([self.totalScore floatValue]*10)/10];
    _totalScoreLabel.font = [UIFont systemFontOfSize:14];
    [headerview addSubview:_totalScoreLabel];
    [_totalScoreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(imageView.mas_right).mas_equalTo(12);
        make.centerY.mas_equalTo(0);
    }];
    
    self.tableView.tableHeaderView = headerview;
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"CommentCell" bundle:nil] forCellReuseIdentifier:@"commentCell"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    

    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refresh)];
    [header setTitle:@"下拉刷新评价" forState:MJRefreshStateIdle];
    [header setTitle:@"释放刷新评价" forState:MJRefreshStatePulling];
    [header setTitle:@"加载数据中" forState:MJRefreshStateRefreshing];
    self.tableView.mj_header = header;

//    //下拉刷新
//    __weak typeof(self) weakSelf = self;
//    [self.tableView addHeaderRefresh:^{
//        dispatch_async(dispatch_get_global_queue(0, 0), ^{
//            if (self.isBarcode == NO) {
//                NSString *typeid = [weakSelf.productDic objectForKey:@"typeid"];
//                [CommentNetManager getCcodeCommentWithTypeID:typeid CurrentPage:@"0" PageSize:@"10" completionHandle:^(id responseObject, NSError *error) {
//                    if (!error) {
//                        NSLog(@"%@",responseObject);
//                        if (responseObject[@"Result"] == 0) {
//                            weakSelf.commentDic = [responseObject mutableCopy];
//                            weakSelf.commentArray = [weakSelf.commentDic[@"Data"] mutableCopy];
//                            [weakSelf.tableView reloadData];
//                        }
//                    }else{
//                        NSLog(@"获取评论失败:%@",error);
//                    }
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        
//                        [weakSelf.tableView endHeaderRefresh];
//                    });
//                }];
//
//            }else{
//                [CommentNetManager getBarCodeCommentWithBarCode:weakSelf.productCode CurrentPage:@"0" PageSize:@"10" completionHandle:^(id responseObject, NSError *error) {
//                    if (!error) {
//                        NSLog(@"%@",responseObject);
//                        if (responseObject[@"Result"] == 0) {
//                            weakSelf.commentDic = responseObject;
//                            weakSelf.commentArray = weakSelf.commentDic[@"Data"];
//                            [weakSelf.tableView reloadData];
//                        }
//                    }else{
//                        NSLog(@"获取评论失败:%@",error);
//                    }
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        [weakSelf.tableView endHeaderRefresh];
//                    });
//                }];
//            }
//            
//
//        });
//    }];

    //底部刷新
    //MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadOnceData)];
    MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    // 设置了底部inset
    //self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 30, 0);
    // 忽略掉底部inset
    //self.tableView.mj_footer.ignoredScrollViewContentInsetBottom = 30;
    footer.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
    //隐藏文字
    //footer.stateLabel.hidden = YES;
    
    // 设置文字
    [footer setTitle:@"上拉加载更多评价" forState:MJRefreshStateIdle];
    [footer setTitle:@"正在加载数据" forState:MJRefreshStateRefreshing];
    [footer setTitle:@"已显示全部评价" forState:MJRefreshStateNoMoreData];
    
    // 设置字体
    footer.stateLabel.font = [UIFont systemFontOfSize:12];
    
    // 设置颜色
    footer.stateLabel.textColor = [UIColor colorWithRed:160/255.0 green:160/255.0 blue:160/255.0 alpha:1];
    
    // 设置footer
    self.tableView.mj_footer = footer;


    
}

-(void)getComment
{
    //获取评论
    NSString *getccodeCommentUrl = [NSString stringWithFormat:@"%@/%@",kUrl,kGetCCodeCommentUrl];
    NSMutableDictionary *getDic = [[NSMutableDictionary alloc]init];
    //[getDic setValue:@1 forKey:@"typeid"];
    //[getDic setValue:@"12345678901222" forKey:@"barcode"];
    NSString *typeid = [self.productDic objectForKey:@"typeid"];
    [getDic setValue:typeid forKey:@"typeid"];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.requestSerializer setValue:@"0" forHTTPHeaderField:@"Client-Flag"];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [userDefaults objectForKey:@"CA-Token"];
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"CA-Token"];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain",@"application/json", nil];
    
    NSString *para = [self dictionaryToJson:getDic];
    
    NSDictionary *paraDic = @{@"json":para};
    //NSLog(@"参数:%@",paraDic);
    [manager POST:getccodeCommentUrl parameters:paraDic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //NSLog(@"评论:%@",responseObject);
        if ([responseObject[@"Result"] integerValue] == 0) {
            self.commentArray = [responseObject[@"Data"] mutableCopy];
            self.totalScore = [NSNumber numberWithFloat:([responseObject[@"totalscore1"] floatValue]/[responseObject[@"totalcnt"] floatValue])];
            
            CAShapeLayer *maskLayer = [CAShapeLayer layer];
            //UIBezierPath *fromPath = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, 1, 12)];
            UIBezierPath *toPath = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, 84*[self.totalScore floatValue]/5, 12)];
            maskLayer.path = toPath.CGPath;
            _foregroundImageView.layer.mask = maskLayer;
            _totalScoreLabel.text = [NSString stringWithFormat:@"%.1f分",round([self.totalScore floatValue]*10)/10];
            
            self.tableView.hidden = NO;
            self.label.text = @"你的评价对其他人很有帮助哦～";
            self.placeholdLabel.text = @"你的评价对其他人很有帮助哦～";
            [self.tableView reloadData];
            [self.emptyView removeFromSuperview];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //NSLog(@"获取评论失败%@",error);
    }];
    
}

-(void)getBarcodeComment
{
    [CommentNetManager getBarCodeCommentWithBarCode:self.productCode CurrentPage:@"0" PageSize:@"10" completionHandle:^(id responseObject, NSError *error) {
        if (!error) {
            if ([responseObject[@"Result"] integerValue] == 0) {
                self.commentArray = responseObject[@"Data"];
                self.totalScore = [NSNumber numberWithFloat:([responseObject[@"totalscore1"] floatValue]/[responseObject[@"totalcnt"] floatValue])];
                
                CAShapeLayer *maskLayer = [CAShapeLayer layer];
                //UIBezierPath *fromPath = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, 1, 12)];
                UIBezierPath *toPath = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, 84*[self.totalScore floatValue]/5, 12)];
                maskLayer.path = toPath.CGPath;
                _foregroundImageView.layer.mask = maskLayer;
                _totalScoreLabel.text = [NSString stringWithFormat:@"%.1f分",round([self.totalScore floatValue]*10)/10];
                
                self.tableView.hidden = NO;
                self.label.text = @"你的评价对其他人很有帮助哦～";
                self.placeholdLabel.text = @"你的评价对其他人很有帮助哦～";
                [self.tableView reloadData];
                [self.emptyView removeFromSuperview];
            }else{
                //NSLog(@"获取评论失败%@",error);
            }
        }
    }];
}



#pragma mark 上拉加载更多数据
- (void)loadMoreData
{
    
    if (self.isBarcode == NO) {
        NSString *typeid = [self.productDic objectForKey:@"typeid"];
        self.pageCount ++;
        if (_pageCount<self.pageCountTotal) {
            NSString *page = [NSString stringWithFormat:@"%ld",(long)self.pageCount];
            [CommentNetManager getCcodeCommentWithTypeID:typeid CurrentPage:page PageSize:@"10" completionHandle:^(id responseObject, NSError *error) {
                if (!error) {
                    //NSLog(@"%@",responseObject);
                    NSMutableArray *other = [responseObject[@"Data"] mutableCopy];
                    [self.commentArray addObjectsFromArray:other];
                    [self.tableView reloadData];
                }else{
                    //NSLog(@"获取评论失败:%@",error);
                }
                [self.tableView.mj_footer endRefreshing];
            }];
        }else{
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }

    }else
    {
        self.pageCount ++;
        if (_pageCount<self.pageCountTotal) {
            NSString *page = [NSString stringWithFormat:@"%ld",(long)self.pageCount];
            [CommentNetManager getBarCodeCommentWithBarCode:self.productCode CurrentPage:page PageSize:@"10" completionHandle:^(id responseObject, NSError *error) {
                if (!error) {
                    NSArray *other = responseObject[@"Data"];
                    [self.commentArray addObjectsFromArray:other];
                    [self.tableView reloadData];
                }else{
                    //NSLog(@"获取评论失败:%@",error);
                }
            }];
        }else{
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
    }
}

-(void)refresh
{
    if (self.isBarcode == NO) {
        NSString *typeid = [self.productDic objectForKey:@"typeid"];
        [CommentNetManager getCcodeCommentWithTypeID:typeid CurrentPage:@"0" PageSize:@"10" completionHandle:^(id responseObject, NSError *error) {
            if (!error) {
                //NSLog(@"%@",responseObject);
                self.commentArray = [responseObject[@"Data"] mutableCopy];
                self.totalScore = [NSNumber numberWithFloat:([responseObject[@"totalscore1"] floatValue]/[responseObject[@"totalcnt"] floatValue])];
                CAShapeLayer *maskLayer = [CAShapeLayer layer];
                //UIBezierPath *fromPath = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, 1, 12)];
                UIBezierPath *toPath = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, 84*[self.totalScore floatValue]/5, 12)];
                maskLayer.path = toPath.CGPath;
                _foregroundImageView.layer.mask = maskLayer;
                _totalScoreLabel.text = [NSString stringWithFormat:@"%.1f分",round([self.totalScore floatValue]*10)/10];
                
                [self.tableView reloadData];
                
                self.pageCount = 0;
                [self.tableView.mj_footer setRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
                [self.tableView.mj_footer resetNoMoreData];
            }else{
                //NSLog(@"获取评论失败:%@",error);
            }
            [self.tableView.mj_header endRefreshing];
        }];
    }else
    {
        [CommentNetManager getBarCodeCommentWithBarCode:self.productCode CurrentPage:@"0" PageSize:@"10" completionHandle:^(id responseObject, NSError *error) {
            if (!error) {
                self.commentArray = [responseObject[@"Data"] mutableCopy];
                self.totalScore = [NSNumber numberWithFloat:([responseObject[@"totalscore1"] floatValue]/[responseObject[@"totalcnt"] floatValue])];
                CAShapeLayer *maskLayer = [CAShapeLayer layer];
                //UIBezierPath *fromPath = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, 1, 12)];
                UIBezierPath *toPath = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, 84*[self.totalScore floatValue]/5, 12)];
                maskLayer.path = toPath.CGPath;
                _foregroundImageView.layer.mask = maskLayer;
                _totalScoreLabel.text = [NSString stringWithFormat:@"%.1f分",round([self.totalScore floatValue]*10)/10];
                [self.tableView reloadData];
                
                self.pageCount = 0;
                [self.tableView.mj_footer setRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
                [self.tableView.mj_footer resetNoMoreData];
            }else{
                //NSLog(@"获取评论失败:%@",error);
            }
            [self.tableView.mj_header endRefreshing];
        }];
    }

    


}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.commentArray.count;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CommentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"commentCell"];
    cell.commentDic = self.commentArray[indexPath.row];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}



-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width-24, 999)];
    NSString *value = [self.commentArray[indexPath.row] objectForKey:@"ccomment"];
    CGSize size = [value sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(self.view.frame.size.width - 24, 999) lineBreakMode:NSLineBreakByCharWrapping];
    //NSLog(@"%@",NSStringFromCGSize(size));
    //return 100-17+(size.height>66.8?66.8:size.height);
    return 100-17+size.height;
}

//-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//
//        return 54;
//
//}

- (NSString*)dictionaryToJson:(NSDictionary *)dic
{
    
    NSError *parseError = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
}


-(void)backToRecordDetailViewController:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"评价页面"];
}


-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //增加键盘的弹起通知监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(openKeyboard:) name:UIKeyboardWillShowNotification object:nil];
    //增加键盘的收起通知监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closeKeyboard:) name:UIKeyboardWillHideNotification object:nil];
    //增加输入框内容变化通知监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged:) name: UITextViewTextDidChangeNotification object:nil];
    
    if (self.commentDic.count == 0) {
        sleep(0.2);
        [self click:nil];
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"评价页面"];
}

//view看不见时,取消注册的键盘监听
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    //取消注册过的通知
    //只按照通知的名字,取消掉具体的某个通知,而不是全部一次性取消掉所有注册过的通知
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextViewTextDidChangeNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
