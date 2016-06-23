//
//  NewsDetailViewController.m
//  BaseProject
//
//  Created by 刘子琨 on 16/5/11.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import "NewsDetailViewController.h"
#import <UMSocial.h>
#import "OCGumbo.h"
#import "OCGumbo+Query.h"
#import <UIImage+AFNetworking.h>
#import "UIButton+EnlargeEdge.h"

#define kScreenWidthScale (self.view.bounds.size.width/320.0)

@interface NewsDetailViewController ()<UIWebViewDelegate,UMSocialUIDelegate>
@property(nonatomic,strong)UIWebView *webView;
@property (nonatomic , strong)UIActivityIndicatorView *activityIndicator;
@property (nonatomic,strong)NSString *imageUrlString;
@property (nonatomic,strong)NSString *newsTitle;
@property (nonatomic,strong)NSString *firstContent;
@property (nonatomic,strong)NSString *shareUrl;
@property (nonatomic,strong)UIImage *image;
@property (nonatomic,strong)UIView *grayBackground;
@property (nonatomic,strong)UIView *shareView;
@property (nonatomic,strong)UIButton *rightButton;

@end

@implementation NewsDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //去除上方留白
    self.automaticallyAdjustsScrollViewInsets=NO;
    self.webView = [[UIWebView alloc]init];
    [self.view addSubview:self.webView];
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.mas_equalTo(0);
        make.top.mas_equalTo(64);
    }];
    self.webView.delegate = self;
    [self.webView loadRequest:self.request];
    self.webView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    //重新设置导航栏，隐藏原生导航栏，手动绘制新的导航栏，使右滑手势跳转时能让导航栏跟着变化
    [self setNavigationBar];
    
    [self setupShareView];
    
    [self getTitleAndImage];
    
    
    
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
    
    self.rightButton = [[UIButton alloc]init];
    [_rightButton setEnlargeEdge:20];
    [_rightButton setImage:[UIImage imageNamed:@"分享"] forState:UIControlStateNormal];
    [_rightButton setImage:[UIImage imageNamed:@"分享按下"] forState:UIControlStateHighlighted];
    [_rightButton.imageView setContentMode:UIViewContentModeScaleAspectFit];
    [_rightButton addTarget:self action:@selector(share:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_rightButton];
    [_rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-10);
        make.top.mas_equalTo(35);
        make.size.mas_equalTo(CGSizeMake(17, 17));
    }];
    
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

-(void)setupShareView
{
    self.grayBackground = [[UIView alloc]init];
//    _grayBackground.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-290);
    _grayBackground.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    [self.view addSubview:_grayBackground];
    [_grayBackground mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.mas_equalTo(0);
    }];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(grayBackgroundTap:)];
    [_grayBackground addGestureRecognizer:tap];
    _grayBackground.hidden = YES;
    
    self.shareView = [[UIView alloc]init];
    _shareView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.5];
    [self.view addSubview:_shareView];
    [_shareView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(self.view.frame.size.width, 290));
        make.bottom.mas_equalTo(290);
    }];
    

    
    //设置毛玻璃效果，ios8之后控件，如需兼容ios7，则需加判断
    if ([[UIDevice currentDevice].systemVersion doubleValue] >= 8.0) {
        UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        UIVisualEffectView *effectview = [[UIVisualEffectView alloc] initWithEffect:blur];
        effectview.frame = CGRectMake(0, 0, self.view.frame.size.width, 290);
        [_shareView addSubview:effectview];
    }else{
        UIView *whiteView = [[UIView alloc]init];
        whiteView.backgroundColor = [UIColor whiteColor];
        whiteView.frame = CGRectMake(0, 0, self.view.frame.size.width, 290);
        [_shareView addSubview:whiteView];
    }
    

    
    UILabel *label = [[UILabel alloc]init];
    [self.shareView addSubview:label];
    label.font = [UIFont systemFontOfSize:14];
    label.text = @"分享到";
    label.textColor = UIColorFromRGB(0x5A5A5A);
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(19);
    }];
    
    UIButton *cancelButton = [[UIButton alloc]init];
    [cancelButton setTitle:@"取 消" forState:UIControlStateNormal];
    [cancelButton setTitleColor:UIColorFromRGB(0x191919) forState:UIControlStateNormal];
    [self.shareView addSubview:cancelButton];
    [cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.mas_equalTo(0);
        make.height.mas_equalTo(49);
    }];
    [cancelButton addTarget:self action:@selector(grayBackgroundTap:) forControlEvents:UIControlEventTouchUpInside];
    UIView *lineView = [[UIView alloc]init];
    lineView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    [self.shareView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-49);
        make.height.mas_equalTo(0.5);
    }];
    
    UIButton *friend = [[UIButton alloc]init];
    [friend setImage:[UIImage imageNamed:@"朋友圈"] forState:UIControlStateNormal];
    [self.shareView addSubview:friend];
    [friend mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(50, 50));
        make.top.mas_equalTo(48);
    }];
    [friend addTarget:self action:@selector(shareToFriend:) forControlEvents:UIControlEventTouchUpInside];
    UILabel *friendLabel = [[UILabel alloc]init];
    friendLabel.font = [UIFont systemFontOfSize:12];
    friendLabel.text = @"微信朋友圈";
    friendLabel.textColor = UIColorFromRGB(0x5A5A5A);
    [self.shareView addSubview:friendLabel];
    [friendLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(friend.mas_bottom).mas_equalTo(9);
    }];

    UIButton *qzone = [[UIButton alloc]init];
    [qzone setImage:[UIImage imageNamed:@"空间"] forState:UIControlStateNormal];
    [self.shareView addSubview:qzone];
    [qzone mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(50, 50));
        make.top.mas_equalTo(142);
    }];
    [qzone addTarget:self action:@selector(shareToQzone:) forControlEvents:UIControlEventTouchUpInside];
    UILabel *qzoneLabel = [[UILabel alloc]init];
    qzoneLabel.font = [UIFont systemFontOfSize:12];
    qzoneLabel.text = @"QQ空间";
    qzoneLabel.textColor = UIColorFromRGB(0x5A5A5A);
    [self.shareView addSubview:qzoneLabel];
    [qzoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(qzone.mas_bottom).mas_equalTo(9);
    }];

    UIButton *weixin = [[UIButton alloc]init];
    [weixin setImage:[UIImage imageNamed:@"微信"] forState:UIControlStateNormal];
    [self.shareView addSubview:weixin];
    [weixin mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(friend);
        make.size.mas_equalTo(CGSizeMake(50, 50));
        make.right.mas_equalTo(friend.mas_left).mas_equalTo(-63*kScreenWidthScale);
    }];
    [weixin addTarget:self action:@selector(shareToWechat:) forControlEvents:UIControlEventTouchUpInside];
    UILabel *weixinLabel = [[UILabel alloc]init];
    //weixinLabel.font = [UIFont fontWithName:@"PingFangSC-Thin" size:12];
    weixinLabel.font = [UIFont systemFontOfSize:12];
    weixinLabel.text = @"微信好友";
    weixinLabel.textColor = UIColorFromRGB(0x5A5A5A);
    [self.shareView addSubview:weixinLabel];
    [weixinLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(weixin);
        make.top.mas_equalTo(weixin.mas_bottom).mas_equalTo(9);
    }];
    
    UIButton *weibo = [[UIButton alloc]init];
    [weibo setImage:[UIImage imageNamed:@"新浪"] forState:UIControlStateNormal];
    [self.shareView addSubview:weibo];
    [weibo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(friend);
        make.size.mas_equalTo(CGSizeMake(50, 50));
        make.left.mas_equalTo(friend.mas_right).mas_equalTo(63*kScreenWidthScale);
    }];
    [weibo addTarget:self action:@selector(shareToWeibo:) forControlEvents:UIControlEventTouchUpInside];
    UILabel *weiboLabel = [[UILabel alloc]init];
    weiboLabel.font = [UIFont systemFontOfSize:12];
    weiboLabel.text = @"新浪微博";
    weiboLabel.textColor = UIColorFromRGB(0x5a5a5a);
    [self.shareView addSubview:weiboLabel];
    [weiboLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(weibo);
        make.top.mas_equalTo(weibo.mas_bottom).mas_equalTo(9);
    }];
    
    UIButton *qq = [[UIButton alloc]init];
    [qq setImage:[UIImage imageNamed:@"QQ"] forState:UIControlStateNormal];
    [self.shareView addSubview:qq];
    [qq mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(weixin);
        make.centerY.mas_equalTo(qzone);
        make.size.mas_equalTo(CGSizeMake(50, 50));
    }];
    [qq addTarget:self action:@selector(shareToQQ:) forControlEvents:UIControlEventTouchUpInside];
    UILabel *qqLabel = [[UILabel alloc]init];
    qqLabel.font = [UIFont systemFontOfSize:12];
    qqLabel.text = @"QQ好友";
    qqLabel.textColor = UIColorFromRGB(0x5a5a5a);
    [self.shareView addSubview:qqLabel];
    [qqLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(qq);
        make.top.mas_equalTo(qq.mas_bottom).mas_equalTo(9);
    }];
    
    UIButton *lianjie = [[UIButton alloc]init];
    [lianjie setImage:[UIImage imageNamed:@"复制"] forState:UIControlStateNormal];
    [self.shareView addSubview:lianjie];
    [lianjie mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(weibo);
        make.centerY.mas_equalTo(qzone);
        make.size.mas_equalTo(CGSizeMake(50, 50));
    }];
    [lianjie addTarget:self action:@selector(copyUrl:) forControlEvents:UIControlEventTouchUpInside];
    UILabel *lianjieLabel = [[UILabel alloc]init];
    lianjieLabel.font = [UIFont systemFontOfSize:12];
    lianjieLabel.text = @"复制链接";
    lianjieLabel.textColor = UIColorFromRGB(0x5a5a5a);
    [self.shareView addSubview:lianjieLabel];
    [lianjieLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(lianjie);
        make.top.mas_equalTo(lianjie.mas_bottom).mas_equalTo(9);
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


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"新闻知识详情"];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"新闻知识详情"];
}

-(void)share:(UIButton *)sender
{
    self.grayBackground.hidden = NO;

    [UIView animateWithDuration:0.25 animations:^{
        [self.shareView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(0);
        }];
        [self.grayBackground mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(-290);
        }];
        _grayBackground.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
        [self.grayBackground setNeedsLayout];
        [self.grayBackground layoutIfNeeded];
        [self.shareView setNeedsLayout];
        [self.shareView layoutIfNeeded];
    }];
    
    
    //NSLog(@"%@",self.webView.request.URL.absoluteString);
    //如果需要分享回调，请将delegate对象设置self，并实现下面的回调方法
//    [UMSocialSnsService presentSnsIconSheetView:self
//                                         appKey:@"507fcab25270157b37000010"
//                                      shareText:@"TEST"
//                                     shareImage:[UIImage imageNamed:@"icon1024"]
//                                shareToSnsNames:@[UMShareToWechatSession,UMShareToWechatTimeline,UMShareToQQ,UMShareToQzone]
//                                       delegate:self];
    

    
}
//分享到朋友圈
-(void)shareToFriend:(UIButton *)sender
{
    [UMSocialData defaultData].extConfig.wechatTimelineData.title = self.newsTitle;
    [UMSocialData defaultData].extConfig.wechatTimelineData.url = self.shareUrl;
    //NSLog(@"%@",self.image);
    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatTimeline] content:self.firstContent image:self.image location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
        //去除分享view
        [self grayBackgroundTap:nil];
        if (response.responseCode == UMSResponseCodeSuccess) {
            NSLog(@"分享成功！");
        }
    }];
    
}
-(void)shareToQzone:(UIButton *)sender
{
    [UMSocialData defaultData].extConfig.qzoneData.title = self.newsTitle;
    [UMSocialData defaultData].extConfig.qzoneData.url = self.shareUrl;
    [[UMSocialDataService defaultDataService] postSNSWithTypes:@[UMShareToQzone] content:self.firstContent image:self.image location:nil urlResource:nil presentedController:nil completion:^(UMSocialResponseEntity *response) {
        [self grayBackgroundTap:nil];
        if (response.responseCode == UMSResponseCodeSuccess) {
            NSLog(@"分享成功！");
        }
    }];
}
//分享到微信好友
-(void)shareToWechat:(UIButton *)sender
{
    [UMSocialData defaultData].extConfig.wechatSessionData.url = self.shareUrl;
    [UMSocialData defaultData].extConfig.wechatSessionData.title = self.newsTitle;
    //NSLog(@"%@",self.image);
    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatSession] content:self.firstContent image:self.image location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
        [self grayBackgroundTap:nil];
        if (response.responseCode == UMSResponseCodeSuccess) {
            NSLog(@"分享成功！");
        }
    }];
}

-(void)shareToWeibo:(UIButton *)sender
{
    NSString *content = [NSString stringWithFormat:@"【%@】%@ %@",self.newsTitle,self.firstContent,self.shareUrl];
    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToSina] content:content image:self.image location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *shareResponse){
        [self grayBackgroundTap:nil];
        if (shareResponse.responseCode == UMSResponseCodeSuccess) {
            NSLog(@"分享成功！");
        }
    }];
}
-(void)shareToQQ:(UIButton *)sender
{
    [UMSocialData defaultData].extConfig.qqData.title = self.newsTitle;
    [UMSocialData defaultData].extConfig.qqData.url = self.shareUrl;
    NSLog(@"%@",self.image);
    [[UMSocialDataService defaultDataService] postSNSWithTypes:@[UMShareToQQ] content:self.firstContent image:self.image location:nil urlResource:nil presentedController:nil completion:^(UMSocialResponseEntity *response) {
        [self grayBackgroundTap:nil];
        if (response.responseCode == UMSResponseCodeSuccess) {
            NSLog(@"分享成功！");
        }
    }];
}
-(void)copyUrl:(UIButton *)sender
{
    //复制到剪切板
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    [pasteboard setString:self.shareUrl];
    NSLog(@"%@",self.shareUrl);
    [self grayBackgroundTap:nil];
    MBProgressHUD *Hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:Hud];
    Hud.labelText = @"已复制链接到剪切板";
    Hud.labelFont = [UIFont systemFontOfSize:14];
    Hud.mode = MBProgressHUDModeText;
    [Hud show:YES];
    [Hud hide:YES afterDelay:1.5];
    
}

-(void)grayBackgroundTap:(UITapGestureRecognizer *)tap
{
    
    [UIView animateWithDuration:0.25 animations:^{
        [self.shareView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(290);
        }];
        [self.grayBackground mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(0);
        }];
        _grayBackground.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
        [_grayBackground layoutIfNeeded];
        [self.shareView setNeedsLayout];
        [self.shareView layoutIfNeeded];
    } completion:^(BOOL finished) {
        self.grayBackground.hidden = YES;
    }];
}

//-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
//{
//    //根据`responseCode`得到发送结果,如果分享成功
//    if(response.responseCode == UMSResponseCodeSuccess)
//    {
//        //得到分享到的平台名
//        NSLog(@"share to sns name is %@",[[response.data allKeys] objectAtIndex:0]);
//    }
//}

-(void)getTitleAndImage
{
    self.shareUrl = [self.request.URL.absoluteString stringByAppendingString:@"&share=1"];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    //manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain",@"application/json",@"text/html", nil];
    
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *catoken = [userDefaults stringForKey:@"CA-Token"];
    
    [manager.requestSerializer setValue:catoken forHTTPHeaderField:@"CA-Token"];
    //manager.requestSerializer.stringEncoding = NSUTF8StringEncoding;
    
    NSLog(@"%@",self.request.URL.absoluteString);
    
    [manager POST:self.request.URL.absoluteString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *htmlString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"%@",htmlString);
        
        OCGumboDocument *document = [[OCGumboDocument alloc] initWithHTMLString:htmlString];
        
        OCGumboElement *element = document.Query(@"body").find(@".context").find(@"img").first();
        //如果该页面存在图片
        if (element) {
            if ([[element.attr(@"src") substringToIndex:[kUrl length]] isEqualToString:kUrl]) {
                self.imageUrlString = element.attr(@"src");
            }else if([[element.attr(@"src") substringToIndex:[kUrl length]+1] isEqualToString:@"http://appserver.cieway.com"]){
                self.imageUrlString = element.attr(@"src");
            }else{
                self.imageUrlString = [NSString stringWithFormat:@"%@%@",kUrl,element.attr(@"src")];
            }
            NSLog(@"src = %@", self.imageUrlString);
            self.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.imageUrlString]]];
            NSLog(@"image = %@",self.image);

        }
        //如果无法获取该图片
        if (!self.image) {
            self.image = [UIImage imageNamed:@"icon1024"];
        }
        
        OCGumboElement *title = document.Query(@"title");
        if (title) {
            self.newsTitle = title.text();
        }else{
            self.newsTitle = @"云检科技新闻资讯";
        }
        
        
        //获取内容，暂时先这样吧，虽然有点low
        OCGumboElement *content = document.Query(@"body").find(@".context").find(@"span").first();
        if (content) {
            self.firstContent = content.text();
        }
        if (self.firstContent.length <= 30) {
            content = document.Query(@"body").find(@".context").find(@"span").get(1);
            if (content) {
                self.firstContent = content.text();
            }
            
        }
        if(self.firstContent.length <= 30){
            content = document.Query(@"body").find(@".context").find(@"span").get(2);
            if (content) {
                self.firstContent = content.text();
            }
            
        }
        if(self.firstContent.length <= 30){
            content = document.Query(@"body").find(@".context").find(@"span").get(3);
            if (content) {
                self.firstContent = content.text();
            }
            
        }
        if (self.firstContent.length >= 50) {
            self.firstContent = [self.firstContent substringToIndex:50];
        }
        if (self.firstContent.length <= 10) {
            self.firstContent = self.newsTitle;
        }else{
            self.firstContent = [self.firstContent stringByAppendingString:@"..."];
        }
        NSLog(@"firstcontent = %@",self.firstContent);
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];

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
    _rightButton.userInteractionEnabled = NO;
    _rightButton.alpha = 0.5;
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

    [self performSelector:@selector(loadEnd) withObject:nil afterDelay:0];
    
}

-(void)loadEnd
{
    _rightButton.userInteractionEnabled = YES;
    _rightButton.alpha = 1;
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
