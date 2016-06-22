//
//  WelcomeViewController.m
//  BaseProject
//
//  Created by 刘子琨 on 16/1/11.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import "WelcomeViewController.h"
#import "MainViewController.h"

#define kScreenScale (self.view.bounds.size.height/667.0)
#define kScreenWidthScale (self.view.bounds.size.width/375.0)

@interface WelcomeViewController ()<UIScrollViewDelegate>

@property(strong,nonatomic)UIPageControl *pageControl;

@property(strong,nonatomic)UIImageView *foodImageView;
@property(strong,nonatomic)UIImageView *momAndBabyImageView;
@property(strong,nonatomic)UIImageView *wineImageView;
@property(strong,nonatomic)UIImageView *cosmeticImageView;
@property(strong,nonatomic)UIImageView *homeApplianceImageView;
@property(strong,nonatomic)UIImageView *digitalImageView;
@property(strong,nonatomic)UIImageView *healthImageView;
@property(strong,nonatomic)UIImageView *homeFurnishingsImageView;
@property(strong,nonatomic)UIImageView *everydayUseImageView;


@end

@implementation WelcomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpScrollView];
    [self setUpPageControl];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"欢迎页面"];//("PageOne"为页面名称，可自定义)
}


//-(void)viewDidAppear:(BOOL)animated
//{
//    NSUserDefaults * settings1 = [NSUserDefaults standardUserDefaults];
//    NSString *key1 = [NSString stringWithFormat:@"is_first"];
//    NSString *value = [settings1 objectForKey:key1];
//    if ([value isEqualToString:@"false"]) {
//        [self enterApp];
//        //MainViewController *mainVC = [self.storyboard instantiateViewControllerWithIdentifier:@"mainViewController"];
//        //[self presentViewController:mainVC animated:YES completion:nil];
//    }
//    if (!value) {
//        NSUserDefaults * setting = [NSUserDefaults standardUserDefaults];
//        NSString * key = [NSString stringWithFormat:@"is_first"];
//        [setting setObject:[NSString stringWithFormat:@"false"] forKey:key];
//        [setting synchronize];
//        
//        //配置滚动视图
//        [self setUpScrollView];
//        //[self setUpPageControl];
//    }
//
//}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"欢迎页面"];
}

//设置滚动视图页面控制器
-(void)setUpPageControl
{
    //1.创建pageControl的实例
    UIPageControl * pageControl = [[UIPageControl alloc]init];
    self.pageControl = pageControl;
    
    //2.设置pageControl的位置和大小
    //pageControl.frame = CGRectMake(0, self.view.bounds.size.height-50, self.view.bounds.size.width, 30);
    
    //3.添加pageControl到控制器的view中
    [self.view addSubview:pageControl];
    [pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(49, 5));
        make.bottom.mas_equalTo(-12);
    }];
    
    //4.配置pageControl
    pageControl.numberOfPages = 6;
    
    //5.配置提示符的颜色
    pageControl.pageIndicatorTintColor = UIColorFromRGB(0xcccccc);
    
    //6.配置选中的提示符的颜色
    pageControl.currentPageIndicatorTintColor = UIColorFromRGB(0x1fb0ff);
    
    //7.关闭圆点与用户的交互功能
    pageControl.userInteractionEnabled = NO;
    
    pageControl.currentPage = 0;
    
    
}

//设置滚动视图
-(void)setUpScrollView
{
    //1.创建一个滚动视图
    UIScrollView *sv = [[UIScrollView alloc]init];
    
    //设置滚动视图的代理为当前控制器，负责响应滚动视图发出的各种消息
    sv.delegate = self;
    
    //2.设置滚动视图的可见区域与控制器的view一样大
    sv.frame = self.view.bounds;
    sv.userInteractionEnabled = YES;
    
    //3.向滚动视图中添加多个图片子视图
    for (int i =0; i<5; i++) {
        //格式化图片的名称
        NSString *imageName = [NSString stringWithFormat:@"引导%d.png",i+1];
        if (kScreenHeight <= 481) {
            imageName = [NSString stringWithFormat:@"4s引导%d.png",i+1];
        }
        //创建一个图片视图对象
        UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:imageName]];
        //设置图片视图的位置及大小
        //声明了一个结构体的变量，其中x和y和w和h初始化为0
        CGRect iFrame = CGRectZero;
        iFrame.origin = CGPointMake(sv.bounds.size.width*i, 0);
        iFrame.size = sv.bounds.size;
        imageView.frame = iFrame;
        //将图片视图添加到滚动视图中
        [sv addSubview:imageView];
        if (i == 4) {
            //向此时的最后一屏图片视图中添加按钮
            [self addEnterButton:imageView];
        }
    }
    
    //设置喜好选择图
    UIView *userFavorView = [[UIView alloc]init];
    userFavorView.userInteractionEnabled = YES;
    userFavorView.frame = CGRectMake(5*sv.bounds.size.width, 0, sv.bounds.size.width, sv.bounds.size.height);
    [sv addSubview:userFavorView];
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.text = @"选择你感兴趣的进口商品";
    titleLabel.font = [UIFont systemFontOfSize:25];
    [userFavorView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(78.5*kScreenScale);
    }];
    self.foodImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"食品"]];
    _foodImageView.tag = 1;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(favorTap:)];
    [_foodImageView addGestureRecognizer:tap];
    _foodImageView.userInteractionEnabled = YES;
    [userFavorView addSubview:_foodImageView];
    [_foodImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.centerY.mas_equalTo(titleLabel.mas_bottom).mas_equalTo((60+31)*kScreenScale);
        make.size.mas_equalTo(CGSizeMake(0, 0));
    }];
    UILabel *foodLabel = [[UILabel alloc]init];
    foodLabel.text = @"食品";
    foodLabel.textColor = UIColorFromRGB(0xa0a0a0);
    foodLabel.font = [UIFont systemFontOfSize:11];
    [userFavorView addSubview:foodLabel];
    [foodLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_foodImageView.mas_centerY).mas_equalTo(42*kScreenWidthScale);
        make.centerX.mas_equalTo(_foodImageView);
    }];
    
    self.momAndBabyImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"母婴"]];
    _momAndBabyImageView.tag = 0;
    [userFavorView addSubview:_momAndBabyImageView];
    [_momAndBabyImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_foodImageView);
        make.centerX.mas_equalTo(_foodImageView).mas_equalTo(-110.5*kScreenWidthScale);
        make.size.mas_equalTo(CGSizeMake(0, 0));
    }];
    UILabel *momAndBabyLabel = [[UILabel alloc]init];
    momAndBabyLabel.text = @"母婴";
    momAndBabyLabel.textColor = UIColorFromRGB(0xa0a0a0);
    momAndBabyLabel.font = [UIFont systemFontOfSize:11];
    [userFavorView addSubview:momAndBabyLabel];
    [momAndBabyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_momAndBabyImageView.mas_centerY).mas_equalTo(42*kScreenWidthScale);
        make.centerX.mas_equalTo(_momAndBabyImageView);
    }];
    
    self.wineImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"酒类"]];
    _wineImageView.tag = 2;
    [userFavorView addSubview:_wineImageView];
    [_wineImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_foodImageView);
        make.centerX.mas_equalTo(_foodImageView).mas_equalTo(110.5*kScreenWidthScale);
        make.size.mas_equalTo(CGSizeMake(0, 0));
    }];
    UILabel *wineLabel = [[UILabel alloc]init];
    wineLabel.text = @"酒类";
    wineLabel.textColor = UIColorFromRGB(0xa0a0a0);
    wineLabel.font = [UIFont systemFontOfSize:11];
    [userFavorView addSubview:wineLabel];
    [wineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_wineImageView.mas_centerY).mas_equalTo(42*kScreenWidthScale);
        make.centerX.mas_equalTo(_wineImageView);
    }];
    
    self.cosmeticImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"彩妆护肤"]];
    _cosmeticImageView.tag = 3;
    [userFavorView addSubview:_cosmeticImageView];
    [_cosmeticImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(_momAndBabyImageView);
        make.centerY.mas_equalTo(_momAndBabyImageView).mas_equalTo(110.5*kScreenWidthScale);
        make.size.mas_equalTo(CGSizeMake(0, 0));
    }];
    UILabel *cosmeticLabel = [[UILabel alloc]init];
    cosmeticLabel.text = @"酒类";
    cosmeticLabel.textColor = UIColorFromRGB(0xa0a0a0);
    cosmeticLabel.font = [UIFont systemFontOfSize:11];
    [userFavorView addSubview:cosmeticLabel];
    [cosmeticLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_cosmeticImageView.mas_centerY).mas_equalTo(42*kScreenWidthScale);
        make.centerX.mas_equalTo(_cosmeticImageView);
    }];
    
    self.homeApplianceImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"家电"]];
    _homeApplianceImageView.tag = 4;
    [userFavorView addSubview:_homeApplianceImageView];
    [_homeApplianceImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.centerY.mas_equalTo(_cosmeticImageView);
        make.size.mas_equalTo(CGSizeMake(0, 0));
    }];
    UILabel *homeApplianceLabel = [[UILabel alloc]init];
    homeApplianceLabel.text = @"彩妆护肤";
    homeApplianceLabel.textColor = UIColorFromRGB(0xa0a0a0);
    homeApplianceLabel.font = [UIFont systemFontOfSize:11];
    [userFavorView addSubview:homeApplianceLabel];
    [homeApplianceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_homeApplianceImageView.mas_centerY).mas_equalTo(42*kScreenWidthScale);
        make.centerX.mas_equalTo(_homeApplianceImageView);
    }];
    
    self.digitalImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"数码"]];
    _digitalImageView.tag = 5;
    [userFavorView addSubview:_digitalImageView];
    [_digitalImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(_wineImageView);
        make.centerY.mas_equalTo(_cosmeticImageView);
        make.size.mas_equalTo(CGSizeMake(0, 0));
    }];
    UILabel *digitalLabel = [[UILabel alloc]init];
    digitalLabel.text = @"家电";
    digitalLabel.textColor = UIColorFromRGB(0xa0a0a0);
    digitalLabel.font = [UIFont systemFontOfSize:11];
    [userFavorView addSubview:digitalLabel];
    [digitalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_digitalImageView.mas_centerY).mas_equalTo(42*kScreenWidthScale);
        make.centerX.mas_equalTo(_digitalImageView);
    }];
    
    self.healthImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"保健"]];
    _healthImageView.tag = 6;
    [userFavorView addSubview:_healthImageView];
    [_healthImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(_cosmeticImageView);
        make.centerY.mas_equalTo(_cosmeticImageView).mas_equalTo(110.5*kScreenWidthScale);
        make.size.mas_equalTo(CGSizeMake(0, 0));
    }];
    UILabel *healthLabel = [[UILabel alloc]init];
    healthLabel.text = @"保健";
    healthLabel.textColor = UIColorFromRGB(0xa0a0a0);
    healthLabel.font = [UIFont systemFontOfSize:11];
    [userFavorView addSubview:healthLabel];
    [healthLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_healthImageView.mas_centerY).mas_equalTo(42*kScreenWidthScale);
        make.centerX.mas_equalTo(_healthImageView);
    }];
    
    self.homeFurnishingsImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"家居"]];
    _homeFurnishingsImageView.tag = 7;
    [userFavorView addSubview:_homeFurnishingsImageView];
    [_homeFurnishingsImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.centerY.mas_equalTo(_healthImageView);
        make.size.mas_equalTo(CGSizeMake(0, 0));
    }];
    UILabel *homeFurnishingsLabel = [[UILabel alloc]init];
    homeFurnishingsLabel.text = @"家居";
    homeFurnishingsLabel.textColor = UIColorFromRGB(0xa0a0a0);
    homeFurnishingsLabel.font = [UIFont systemFontOfSize:11];
    [userFavorView addSubview:homeFurnishingsLabel];
    [homeFurnishingsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_homeFurnishingsImageView.mas_centerY).mas_equalTo(42*kScreenWidthScale);
        make.centerX.mas_equalTo(_homeFurnishingsImageView);
    }];
    
    self.everydayUseImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"日用品"]];
    _everydayUseImageView.tag = 8;
    [userFavorView addSubview:_everydayUseImageView];
    [_everydayUseImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(_digitalImageView);
        make.centerY.mas_equalTo(_healthImageView);
        make.size.mas_equalTo(CGSizeMake(0, 0));
    }];
    UILabel *everydaysUseLabel = [[UILabel alloc]init];
    everydaysUseLabel.text = @"日用品";
    everydaysUseLabel.textColor = UIColorFromRGB(0xa0a0a0);
    everydaysUseLabel.font = [UIFont systemFontOfSize:11];
    [userFavorView addSubview:everydaysUseLabel];
    [everydaysUseLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_everydayUseImageView.mas_centerY).mas_equalTo(42*kScreenWidthScale);
        make.centerX.mas_equalTo(_everydayUseImageView);
    }];
    
    UIButton *confirmButton = [[UIButton alloc]init];
    [confirmButton setTitle:@"确 定" forState:UIControlStateNormal];
    confirmButton.titleLabel.textColor = [UIColor whiteColor];
    confirmButton.titleLabel.font = [UIFont systemFontOfSize:15];
    confirmButton.backgroundColor = [UIColor colorWithRed:52/255.0 green:181/255.0 blue:254/255.0 alpha:1.0];
    confirmButton.layer.cornerRadius = 4;
    confirmButton.layer.masksToBounds = YES;
    [confirmButton addTarget:self action:@selector(confirmClick:) forControlEvents:UIControlEventTouchUpInside];
    [userFavorView addSubview:confirmButton];
    [confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(45);
        make.right.mas_equalTo(-45);
        make.bottom.mas_equalTo(-64*kScreenScale);
        make.height.mas_equalTo(44*kScreenScale);
    }];
    
    
    //4.设置滚动视图的内容大小
    sv.contentSize = CGSizeMake(6*sv.bounds.size.width, sv.bounds.size.height);
    //配置滚动视图到达边缘时不弹跳
    sv.bounces = NO;
    //配置滚动视图整页滚动
    sv.pagingEnabled = YES;
    //配置滚动视图不显示水平滚动条提示
    sv.showsHorizontalScrollIndicator = NO;
    
    //5.将滚动视图添加到控制器的view中
    [self.view addSubview:sv];
}

-(void)favorTap:(UIGestureRecognizer *)tap
{
    NSLog(@"%@",[tap view]);
}

-(void)confirmClick:(UIButton *)sender
{
    NSLog(@"确定");
}

//向图片视图中添加按钮
-(void)addEnterButton:(UIImageView *)iv
{
    //0.开启图片视图的用户交互功能，否则里面的子视图按钮时不能接受用户交互的
    iv.userInteractionEnabled = YES;
    
    //1.创建按钮实例
    UIButton *button = [[UIButton alloc]init];
    
    //2.设置按钮的frame
    //button.frame = CGRectMake((iv.bounds.size.width-150)/2, iv.bounds.size.height*0.75, 150, 40);
    //button.frame = CGRectMake(0, 0, iv.bounds.size.width, iv.bounds.size.height);
    
    //按钮的其他配置
    //[button setTitle:@"进入应用" forState:UIControlStateNormal];
    button.backgroundColor = [UIColor clearColor];
    [button setTitle:@"点击进入" forState:UIControlStateNormal];
    button.font = [UIFont systemFontOfSize:16];
    //button.layer.borderWidth = 2;
    //button.layer.borderColor = [UIColor whiteColor].CGColor;
    [button setTitleColor:UIColorFromRGB(0x21afff) forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"进入应用"] forState:UIControlStateNormal];
    
    //3.将按钮添加到图片视图中
    [iv addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(iv);
        make.bottom.mas_equalTo(-54);
        make.size.mas_equalTo(CGSizeMake(162, 35));
    }];
    
    //4.为按钮添加事件响应
    [button addTarget:self action:@selector(enterApp) forControlEvents:UIControlEventTouchUpInside];
    
}

//点击进入应用按钮，执行该方法
-(void)enterApp
{
    [self performSegueWithIdentifier:@"GoToMainViewControllerSegue" sender:nil];
}


#pragma mark ScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    int index = round(scrollView.contentOffset.x/self.view.bounds.size.width);//round函数，四舍五入
    
    self.pageControl.currentPage = index;
    
    if (scrollView.contentOffset.x == self.view.bounds.size.width*5) {
        [UIView animateKeyframesWithDuration:2 delay:0 options:UIViewKeyframeAnimationOptionCalculationModeLinear animations:^{
            [UIView addKeyframeWithRelativeStartTime:0 relativeDuration:0 animations:^{
                [_momAndBabyImageView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.size.mas_equalTo(CGSizeMake(0, 0));
                }];
                [_momAndBabyImageView setNeedsLayout];
                [_momAndBabyImageView layoutIfNeeded];
                [_foodImageView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.size.mas_equalTo(CGSizeMake(0, 0));
                }];
                [_foodImageView setNeedsLayout];
                [_foodImageView layoutIfNeeded];
                [_wineImageView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.size.mas_equalTo(CGSizeMake(0, 0));
                }];
                [_wineImageView setNeedsLayout];
                [_wineImageView layoutIfNeeded];
                [_cosmeticImageView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.size.mas_equalTo(CGSizeMake(0, 0));
                }];
                [_cosmeticImageView setNeedsLayout];
                [_cosmeticImageView layoutIfNeeded];
                [_homeApplianceImageView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.size.mas_equalTo(CGSizeMake(0, 0));
                }];
                [_homeApplianceImageView setNeedsLayout];
                [_homeApplianceImageView layoutIfNeeded];
                [_digitalImageView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.size.mas_equalTo(CGSizeMake(0, 0));
                }];
                [_digitalImageView setNeedsLayout];
                [_digitalImageView layoutIfNeeded];
                [_healthImageView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.size.mas_equalTo(CGSizeMake(0, 0));
                }];
                [_healthImageView setNeedsLayout];
                [_healthImageView layoutIfNeeded];
                [_homeFurnishingsImageView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.size.mas_equalTo(CGSizeMake(0, 0));
                }];
                [_homeFurnishingsImageView setNeedsLayout];
                [_homeFurnishingsImageView layoutIfNeeded];
                [_everydayUseImageView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.size.mas_equalTo(CGSizeMake(0, 0));
                }];
                [_everydayUseImageView setNeedsLayout];
                [_everydayUseImageView layoutIfNeeded];
            }];
            [UIView addKeyframeWithRelativeStartTime:0 relativeDuration:0.0714 animations:^{
                [_momAndBabyImageView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.size.mas_equalTo(CGSizeMake(20, 20));
                }];
                [_momAndBabyImageView setNeedsLayout];
                [_momAndBabyImageView layoutIfNeeded];
            }];
            
            [UIView addKeyframeWithRelativeStartTime:0.0714 relativeDuration:0.0714 animations:^{
                [_momAndBabyImageView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.size.mas_equalTo(CGSizeMake(41, 41));
                }];
                [_momAndBabyImageView setNeedsLayout];
                [_momAndBabyImageView layoutIfNeeded];
                [_foodImageView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.size.mas_equalTo(CGSizeMake(20, 20));
                }];
                [_foodImageView setNeedsLayout];
                [_foodImageView layoutIfNeeded];
            }];
            [UIView addKeyframeWithRelativeStartTime:0.1428 relativeDuration:0.0714 animations:^{
                [_momAndBabyImageView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.size.mas_equalTo(CGSizeMake(62, 62));
                }];
                [_momAndBabyImageView setNeedsLayout];
                [_momAndBabyImageView layoutIfNeeded];
                [_foodImageView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.size.mas_equalTo(CGSizeMake(41, 41));
                }];
                [_foodImageView setNeedsLayout];
                [_foodImageView layoutIfNeeded];
                [_wineImageView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.size.mas_equalTo(CGSizeMake(20, 20));
                }];
                [_wineImageView setNeedsLayout];
                [_wineImageView layoutIfNeeded];

            }];
            [UIView addKeyframeWithRelativeStartTime:0.2142 relativeDuration:0.0714 animations:^{
                [_momAndBabyImageView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.size.mas_equalTo(CGSizeMake(70, 70));
                }];
                [_momAndBabyImageView setNeedsLayout];
                [_momAndBabyImageView layoutIfNeeded];
                [_foodImageView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.size.mas_equalTo(CGSizeMake(62, 62));
                }];
                [_foodImageView setNeedsLayout];
                [_foodImageView layoutIfNeeded];
                [_wineImageView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.size.mas_equalTo(CGSizeMake(41, 41));
                }];
                [_wineImageView setNeedsLayout];
                [_wineImageView layoutIfNeeded];
                [_cosmeticImageView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.size.mas_equalTo(CGSizeMake(20, 20));
                }];
                [_cosmeticImageView setNeedsLayout];
                [_cosmeticImageView layoutIfNeeded];

            }];
            [UIView addKeyframeWithRelativeStartTime:0.2856 relativeDuration:0.0714 animations:^{
                [_momAndBabyImageView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.size.mas_equalTo(CGSizeMake(62, 62));
                }];
                [_momAndBabyImageView setNeedsLayout];
                [_momAndBabyImageView layoutIfNeeded];
                [_foodImageView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.size.mas_equalTo(CGSizeMake(70, 70));
                }];
                [_foodImageView setNeedsLayout];
                [_foodImageView layoutIfNeeded];
                [_wineImageView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.size.mas_equalTo(CGSizeMake(62, 62));
                }];
                [_wineImageView setNeedsLayout];
                [_wineImageView layoutIfNeeded];
                [_cosmeticImageView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.size.mas_equalTo(CGSizeMake(41, 41));
                }];
                [_cosmeticImageView setNeedsLayout];
                [_cosmeticImageView layoutIfNeeded];
                [_homeApplianceImageView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.size.mas_equalTo(CGSizeMake(20, 20));
                }];
                [_homeApplianceImageView setNeedsLayout];
                [_homeApplianceImageView layoutIfNeeded];

            }];
            [UIView addKeyframeWithRelativeStartTime:0.357 relativeDuration:0.0714 animations:^{
                [_foodImageView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.size.mas_equalTo(CGSizeMake(62, 62));
                }];
                [_foodImageView setNeedsLayout];
                [_foodImageView layoutIfNeeded];
                [_wineImageView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.size.mas_equalTo(CGSizeMake(70, 70));
                }];
                [_wineImageView setNeedsLayout];
                [_wineImageView layoutIfNeeded];
                [_cosmeticImageView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.size.mas_equalTo(CGSizeMake(62, 62));
                }];
                [_cosmeticImageView setNeedsLayout];
                [_cosmeticImageView layoutIfNeeded];
                [_homeApplianceImageView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.size.mas_equalTo(CGSizeMake(41, 41));
                }];
                [_homeApplianceImageView setNeedsLayout];
                [_homeApplianceImageView layoutIfNeeded];
                [_digitalImageView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.size.mas_equalTo(CGSizeMake(20, 20));
                }];
                [_digitalImageView setNeedsLayout];
                [_digitalImageView layoutIfNeeded];
            }];
            [UIView addKeyframeWithRelativeStartTime:0.4284 relativeDuration:0.0714 animations:^{
                [_wineImageView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.size.mas_equalTo(CGSizeMake(62, 62));
                }];
                [_wineImageView setNeedsLayout];
                [_wineImageView layoutIfNeeded];
                [_cosmeticImageView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.size.mas_equalTo(CGSizeMake(70, 70));
                }];
                [_cosmeticImageView setNeedsLayout];
                [_cosmeticImageView layoutIfNeeded];
                [_homeApplianceImageView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.size.mas_equalTo(CGSizeMake(62, 62));
                }];
                [_homeApplianceImageView setNeedsLayout];
                [_homeApplianceImageView layoutIfNeeded];
                [_digitalImageView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.size.mas_equalTo(CGSizeMake(41, 41));
                }];
                [_digitalImageView setNeedsLayout];
                [_digitalImageView layoutIfNeeded];
                [_healthImageView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.size.mas_equalTo(CGSizeMake(20, 20));
                }];
                [_healthImageView setNeedsLayout];
                [_healthImageView layoutIfNeeded];
            }];
            [UIView addKeyframeWithRelativeStartTime:0.4998 relativeDuration:0.0714 animations:^{
                [_cosmeticImageView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.size.mas_equalTo(CGSizeMake(62, 62));
                }];
                [_cosmeticImageView setNeedsLayout];
                [_cosmeticImageView layoutIfNeeded];
                [_homeApplianceImageView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.size.mas_equalTo(CGSizeMake(70, 70));
                }];
                [_homeApplianceImageView setNeedsLayout];
                [_homeApplianceImageView layoutIfNeeded];
                [_digitalImageView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.size.mas_equalTo(CGSizeMake(62, 62));
                }];
                [_digitalImageView setNeedsLayout];
                [_digitalImageView layoutIfNeeded];
                [_healthImageView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.size.mas_equalTo(CGSizeMake(41, 41));
                }];
                [_healthImageView setNeedsLayout];
                [_healthImageView layoutIfNeeded];
                [_homeFurnishingsImageView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.size.mas_equalTo(CGSizeMake(20, 20));
                }];
                [_homeFurnishingsImageView setNeedsLayout];
                [_homeFurnishingsImageView layoutIfNeeded];
            }];
            [UIView addKeyframeWithRelativeStartTime:0.5712 relativeDuration:0.0714 animations:^{
                [_homeApplianceImageView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.size.mas_equalTo(CGSizeMake(62, 62));
                }];
                [_homeApplianceImageView setNeedsLayout];
                [_homeApplianceImageView layoutIfNeeded];
                [_digitalImageView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.size.mas_equalTo(CGSizeMake(70, 70));
                }];
                [_digitalImageView setNeedsLayout];
                [_digitalImageView layoutIfNeeded];
                [_healthImageView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.size.mas_equalTo(CGSizeMake(62, 62));
                }];
                [_healthImageView setNeedsLayout];
                [_healthImageView layoutIfNeeded];
                [_homeFurnishingsImageView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.size.mas_equalTo(CGSizeMake(41, 41));
                }];
                [_homeFurnishingsImageView setNeedsLayout];
                [_homeFurnishingsImageView layoutIfNeeded];
                [_everydayUseImageView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.size.mas_equalTo(CGSizeMake(20, 20));
                }];
                [_everydayUseImageView setNeedsLayout];
                [_everydayUseImageView layoutIfNeeded];
            }];
            [UIView addKeyframeWithRelativeStartTime:0.6426 relativeDuration:0.0714 animations:^{
                [_digitalImageView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.size.mas_equalTo(CGSizeMake(62, 62));
                }];
                [_digitalImageView setNeedsLayout];
                [_digitalImageView layoutIfNeeded];
                [_healthImageView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.size.mas_equalTo(CGSizeMake(70, 70));
                }];
                [_healthImageView setNeedsLayout];
                [_healthImageView layoutIfNeeded];
                [_homeFurnishingsImageView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.size.mas_equalTo(CGSizeMake(62, 62));
                }];
                [_homeFurnishingsImageView setNeedsLayout];
                [_homeFurnishingsImageView layoutIfNeeded];
                [_everydayUseImageView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.size.mas_equalTo(CGSizeMake(41, 41));
                }];
                [_everydayUseImageView setNeedsLayout];
                [_everydayUseImageView layoutIfNeeded];
            }];
            [UIView addKeyframeWithRelativeStartTime:0.714 relativeDuration:0.0714 animations:^{
                [_healthImageView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.size.mas_equalTo(CGSizeMake(62, 62));
                }];
                [_healthImageView setNeedsLayout];
                [_healthImageView layoutIfNeeded];
                [_homeFurnishingsImageView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.size.mas_equalTo(CGSizeMake(70, 70));
                }];
                [_homeFurnishingsImageView setNeedsLayout];
                [_homeFurnishingsImageView layoutIfNeeded];
                [_everydayUseImageView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.size.mas_equalTo(CGSizeMake(62, 62));
                }];
                [_everydayUseImageView setNeedsLayout];
                [_everydayUseImageView layoutIfNeeded];
            }];
            [UIView addKeyframeWithRelativeStartTime:0.7854 relativeDuration:0.0714 animations:^{
                [_homeFurnishingsImageView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.size.mas_equalTo(CGSizeMake(62, 62));
                }];
                [_homeFurnishingsImageView setNeedsLayout];
                [_homeFurnishingsImageView layoutIfNeeded];
                [_everydayUseImageView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.size.mas_equalTo(CGSizeMake(70, 70));
                }];
                [_everydayUseImageView setNeedsLayout];
                [_everydayUseImageView layoutIfNeeded];
            }];
            [UIView addKeyframeWithRelativeStartTime:0.8568 relativeDuration:0.0714 animations:^{
                [_everydayUseImageView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.size.mas_equalTo(CGSizeMake(62, 62));
                }];
                [_everydayUseImageView setNeedsLayout];
                [_everydayUseImageView layoutIfNeeded];
            }];
            [UIView addKeyframeWithRelativeStartTime:0.9282 relativeDuration:0.0714 animations:^{
                
            }];


        } completion:^(BOOL finished) {
            
        }];

    }
    
}


@end

