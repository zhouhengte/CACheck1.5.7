//
//  WelcomeViewController.m
//  BaseProject
//
//  Created by 刘子琨 on 16/1/11.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import "WelcomeViewController.h"
#import "MainViewController.h"

@interface WelcomeViewController ()<UIScrollViewDelegate>

@property(strong,nonatomic)UIPageControl *pageControl;

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
    pageControl.numberOfPages = 5;
    
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
    
    //4.设置滚动视图的内容大小
    sv.contentSize = CGSizeMake(5*sv.bounds.size.width, sv.bounds.size.height);
    //配置滚动视图到达边缘时不弹跳
    sv.bounces = NO;
    //配置滚动视图整页滚动
    sv.pagingEnabled = YES;
    //配置滚动视图不显示水平滚动条提示
    sv.showsHorizontalScrollIndicator = NO;
    
    //5.将滚动视图添加到控制器的view中
    [self.view addSubview:sv];
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
    //NSLog(@"%@",NSStringFromCGPoint(scrollView.contentOffset));
    int index = round(scrollView.contentOffset.x/self.view.bounds.size.width);//round函数，四舍五入
    
    self.pageControl.currentPage = index;
    
}


@end

