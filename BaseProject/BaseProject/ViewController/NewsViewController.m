//
//  NewsViewController.m
//  BaseProject
//
//  Created by 刘子琨 on 16/1/14.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import "NewsViewController.h"
#import "NewsDetailViewController.h"
#import <UMSocial.h>
//#import "MobClick.h"

@interface NewsViewController ()<UIWebViewDelegate,UMSocialUIDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (nonatomic , copy)NSString *url;
@property (nonatomic , strong)UIActivityIndicatorView *activityIndicator;
@property (strong , nonatomic) UIButton *btn;
//@property (nonatomic , strong)DJRefresh *refresh;

@end

@implementation NewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //去除上方留白
    self.automaticallyAdjustsScrollViewInsets=NO;
    self.webView.delegate = self;
    self.webView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    //重新设置导航栏，隐藏原生导航栏，手动绘制新的导航栏，使右滑手势跳转时能让导航栏跟着变化
    [self setNavigationBar];
    
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        //网络发生变化时 会触发这里的代码
        switch (status) {
            case AFNetworkReachabilityStatusReachableViaWiFi:
                DDLogVerbose(@"当前是wifi环境");
                break;
            case AFNetworkReachabilityStatusNotReachable:{
                DDLogVerbose(@"当前无网络");
                MBProgressHUD *Hud = [[MBProgressHUD alloc] initWithView:self.view];
                [self.view addSubview:Hud];
                Hud.labelText = @"当前无网络信号";
                Hud.labelFont = [UIFont systemFontOfSize:14];
                Hud.mode = MBProgressHUDModeText;
                [Hud show:YES];
                [Hud hide:YES afterDelay:1.5];
                break;
            }
            case AFNetworkReachabilityStatusUnknown:
                DDLogVerbose(@"当前网络未知");
            case AFNetworkReachabilityStatusReachableViaWWAN:
                DDLogVerbose(@"当前是蜂窝网络");
                break;
            default:
                break;
        }
    }];
    //开启网络状态监测
    [[AFNetworkReachabilityManager sharedManager]startMonitoring];
    
    
    
    //顶部刷新
    __weak UIWebView *wb = _webView;
    [self.webView.scrollView addHeaderRefresh:^{
        [wb reload];
        dispatch_async(dispatch_get_main_queue(), ^{
            [wb.scrollView endHeaderRefresh];
        });
        
    }];
    

    
//    _refresh=[[DJRefresh alloc] initWithScrollView:self.webView.scrollView];
//    _refresh.topEnabled=YES;
//    [_refresh didRefreshCompletionBlock:^(DJRefresh *refresh, DJRefreshDirection direction, NSDictionary *info) {
//        
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [_webView reload];
//            [_refresh finishRefreshingDirection:direction animation:YES];
//        });
//        
//        
//    }];
    
    
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
    
    NSString *url = [NSString stringWithFormat:@"%@/%@",kUrl,kWelcomeUrl];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *catoken = [userDefaults stringForKey:@"CA-Token"];
    
    //[manager.requestSerializer setValue:catoken forHTTPHeaderField:@"CA-Token"];
    

    
    [manager POST:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        self.url = responseObject[@"news_tips_link"];
        NSString  *str = [NSString stringWithFormat:@"%@/%@",kUrl,self.url];
        NSURL *url = [NSURL URLWithString:str];
        NSURLRequest *request =[NSURLRequest requestWithURL:url];
//        NSMutableURLRequest *mutableRequest = [request mutableCopy];
//        [mutableRequest setValue:@"唯一标示" forHTTPHeaderField:@"uuid"];
//        request = [mutableRequest copy];
        //        [self.view addSubview: self.webView];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.webView loadRequest:request];
        });
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
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
    label.text = @"新闻知识";
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
    [button addTarget:self action:@selector(backToMainViewController:) forControlEvents:UIControlEventTouchUpInside];
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

-(void)tapBack:(UIButton *)button
{
    button.alpha = 0.5;
}
-(void)tapUp:(UIButton *)button
{
    button.alpha = 1;
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"新闻知识"];
    
    
    //[self setNavigationBar];
    
    //self.navigationItem.title = @"新闻知识";
    
    //[self.navigationController setNavigationBarHidden:YES];
//    [self.navigationController.navigationBar setBarStyle:UIBarStyleDefault];
//    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:52/255.0 green:181/255.0 blue:254/255.0 alpha:1.0];
//    
//    self.btn = [UIButton buttonWithType:UIButtonTypeCustom];
//    self.btn.frame = CGRectMake(0, 0, 80, 44);
//    self.btn.userInteractionEnabled = YES;
//    [self.btn setTitle:@"返回" forState:UIControlStateNormal];
//    UIImage *image = [UIImage imageNamed:@"返回箭头"];
//    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 13, 11, 19)];
//    
//    imageView.image = image;
//    [self.btn addSubview:imageView];
//    
//    UIBarButtonItem *back=[[UIBarButtonItem alloc]initWithCustomView:self.btn];
//    self.navigationItem.leftBarButtonItem = back;
//    
//    
//    imageView.userInteractionEnabled = YES;
//    self.btn.userInteractionEnabled = YES;
//    //[self.navigationController.navigationBar addSubview:self.btn];
//    
//    
//    [self.btn addTarget: self action: @selector(backToMainViewController:) forControlEvents: UIControlEventTouchUpInside];
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"新闻知识"];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)backToMainViewController:(UIButton *)sender {
    //webView无法后退才跳转到主页面
    if ([self.webView canGoBack]) {
        sender.alpha = 1.0;
        [self.webView goBack];
        
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}



#pragma mark --- UIWebViewDelegate
//开始加载网页
- (void)webViewDidStartLoad:(UIWebView *)webView {
    //设置状态条(status bar)的activityIndicatorView开始动画
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight-64)];
    [view setTag:108];
    [view setBackgroundColor:[UIColor colorWithRed:241/255.0 green:241/255.0 blue:241/255.0 alpha:1]];
    
    [self.view addSubview:view];
    
    self.activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 32.0f, 32.0f)];

    
    [_activityIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
    
    [view addSubview:_activityIndicator];
    [_activityIndicator setCenter:CGPointMake(kScreenWidth/2.0, (kScreenHeight-64)/2.0)];
    
    [_activityIndicator startAnimating];
    
}

//成功加载完毕
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [self performSelector:@selector(loadEnd) withObject:nil afterDelay:1];

}

-(void)loadEnd
{
    //设置indicatorView动画停止
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    [self.activityIndicator stopAnimating];
    UIView *view = (UIView*)[self.view viewWithTag:108];
    [view removeFromSuperview];
}

//加载失败
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    //停止动画
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    [self.activityIndicator stopAnimating];
    UIView *view = (UIView*)[self.view viewWithTag:108];
    [view removeFromSuperview];
    MBProgressHUD *Hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:Hud];
    Hud.labelText = @"网络连接失败";
    Hud.labelFont = [UIFont systemFontOfSize:14];
    Hud.mode = MBProgressHUDModeText;
    [Hud show:YES];
    [Hud hide:YES afterDelay:1.5];

    NSLog(@"加载失败:%@", error.userInfo);
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSLog(@"%@",request.URL.absoluteString);
    if ([request.URL.absoluteString isEqualToString:[NSString stringWithFormat:@"%@/%@",kUrl,self.url]])
    {
        return YES;
    }
    NewsDetailViewController *newsDetailVC = [[NewsDetailViewController alloc]init];
    newsDetailVC.request = request;
    [self.navigationController pushViewController:newsDetailVC animated:YES];
    return NO;
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
