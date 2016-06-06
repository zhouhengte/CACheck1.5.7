//
//  LoginViewController.m
//  BaseProject
//
//  Created by 刘子琨 on 16/1/18.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import "LoginViewController.h"
#import "NSString+MD5.h"
#import "MainViewController.h"
#import <UMSocial.h>
#import "ThirdTelVerificationViewController.h"

#define kScreenScale (self.view.bounds.size.height/568.0)
#define kScreenWidthScale (self.view.bounds.size.width/320.0)
#define kQQappid @"1104866715"

@interface LoginViewController () <MBProgressHUDDelegate>


@property (strong,nonatomic) MBProgressHUD *hud;

@property (nonatomic , copy)NSString *passwordMd5;

@property (strong,nonatomic)UIView *loginView;
@property (strong,nonatomic)UITextField *userNameTextField;
@property (strong,nonatomic)UITextField *passwordTextField;
@property (strong,nonatomic)UIButton *loginButton;

@end

@implementation LoginViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavigationBar];
    
    [self setLoginView];
    
}

-(void)setLoginView
{
    self.loginView = [[UIView alloc]init];
    self.loginView.userInteractionEnabled = YES;
    UITapGestureRecognizer *loginViewTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapLoginView:)];
    [self.loginView addGestureRecognizer:loginViewTap];
    [self.view addSubview:_loginView];
    //将该view放置在自定义navigationbar后面,防止navigationbar被遮住
    [self.view sendSubviewToBack:self.loginView];
    [_loginView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.mas_equalTo(0);
        make.height.mas_equalTo(self.view.mas_height).mas_equalTo(-64);
    }];
    UIButton *qqLoginButton = [[UIButton alloc]init];
    [_loginView addSubview:qqLoginButton];
    [qqLoginButton setImage:[UIImage imageNamed:@"qqLogin"] forState:UIControlStateNormal];
    [qqLoginButton addTarget:self action:@selector(qqLoginClick:) forControlEvents:UIControlEventTouchUpInside];
    [qqLoginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo((kScreenWidth-142)/3);
        make.top.mas_equalTo(53*kScreenScale);
        make.size.mas_equalTo(CGSizeMake(71, 71));
    }];
    UILabel *qqLoginLabel = [[UILabel alloc]init];
    qqLoginLabel.text = @"QQ账号登录";
    qqLoginLabel.font = [UIFont systemFontOfSize:13];
    [self.loginView addSubview:qqLoginLabel];
    [qqLoginLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(qqLoginButton);
        make.top.mas_equalTo(qqLoginButton.mas_bottom).mas_equalTo(10);
    }];
    UIButton *weiboLoginButton = [[UIButton alloc]init];
    [_loginView addSubview:weiboLoginButton];
    [weiboLoginButton setImage:[UIImage imageNamed:@"新浪Login"] forState:UIControlStateNormal];
    [weiboLoginButton addTarget:self action:@selector(sinaLoginClick:) forControlEvents:UIControlEventTouchUpInside];
    [weiboLoginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-(kScreenWidth-142)/3);
        make.top.mas_equalTo(53*kScreenScale);
        make.size.mas_equalTo(CGSizeMake(71, 71));
    }];
    UILabel *weiboLoginLabel = [[UILabel alloc]init];
    weiboLoginLabel.text = @"新浪微博登录";
    weiboLoginLabel.font = [UIFont systemFontOfSize:13];
    [self.loginView addSubview:weiboLoginLabel];
    [weiboLoginLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(weiboLoginButton);
        make.top.mas_equalTo(weiboLoginButton.mas_bottom).mas_equalTo(10);
    }];
    
    UIView *lineView = [[UIView alloc]init];
    [_loginView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(206*kScreenScale);
        make.height.mas_equalTo(14);
    }];
    UILabel *huoLabel = [[UILabel alloc]init];
    huoLabel.text = @"或";
    huoLabel.font = [UIFont systemFontOfSize:14];
    huoLabel.textColor = UIColorFromRGB(0xB4B4B4);
    [lineView addSubview:huoLabel];
    [huoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(0);
    }];
    UIView *leftLineView = [[UIView alloc]init];
    leftLineView.backgroundColor = UIColorFromRGB(0xD3D3D3);
    [lineView addSubview:leftLineView];
    [leftLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.left.mas_equalTo(23);
        make.right.mas_equalTo(huoLabel.mas_left).mas_equalTo(-25);
        make.height.mas_equalTo(1);
    }];
    UIView *rightLineView = [[UIView alloc]init];
    rightLineView.backgroundColor = UIColorFromRGB(0xd3d3d3);
    [lineView addSubview:rightLineView];
    [rightLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.right.mas_equalTo(-23);
        make.left.mas_equalTo(huoLabel.mas_right).mas_equalTo(25);
        make.height.mas_equalTo(1);
    }];
    
    UIImageView *userNameImageView = [[UIImageView alloc]init];
    [userNameImageView setImage:[UIImage imageNamed:@"账号"]];
    [self.loginView addSubview:userNameImageView];
    [userNameImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(23);
        make.top.mas_equalTo(lineView.mas_bottom).mas_equalTo(40*kScreenScale);
        make.size.mas_equalTo(CGSizeMake(18, 19));
    }];
    self.userNameTextField = [[UITextField alloc]init];
    _userNameTextField.keyboardType = UIKeyboardTypeASCIICapable;
    [self.userNameTextField addTarget:self  action:@selector(valueChanged:)  forControlEvents:UIControlEventAllEditingEvents];
    _userNameTextField.font = [UIFont systemFontOfSize:14];
    _userNameTextField.placeholder = @"请输入账号或手机号";
    [_loginView addSubview:_userNameTextField];
    [_userNameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(userNameImageView.mas_right).mas_equalTo(14);
        make.right.mas_equalTo(-23);
        make.centerY.mas_equalTo(userNameImageView);
        make.height.mas_equalTo(18);
    }];
    UIView *userNameLineView = [[UIView alloc]init];
    userNameLineView.backgroundColor = UIColorFromRGB(0xbebebe);
    [self.loginView addSubview:userNameLineView];
    [userNameLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(userNameImageView.mas_bottom).mas_equalTo(5);
        make.left.mas_equalTo(23);
        make.right.mas_equalTo(-23);
        make.height.mas_equalTo(1);
    }];
    
    UIImageView *passwordImageView = [[UIImageView alloc]init];
    [passwordImageView setImage:[UIImage imageNamed:@"密码"]];
    [self.loginView addSubview:passwordImageView];
    [passwordImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(23);
        make.top.mas_equalTo(userNameLineView.mas_bottom).mas_equalTo(22);
        make.size.mas_equalTo(CGSizeMake(18, 19));
    }];
    self.passwordTextField = [[UITextField alloc]init];
    _passwordTextField.keyboardType = UIKeyboardTypeASCIICapable;
    _passwordTextField.secureTextEntry = YES;
    _passwordTextField.font = [UIFont systemFontOfSize:14];
    _passwordTextField.placeholder = @"请输入密码";
    [_loginView addSubview:_passwordTextField];
    [_passwordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(passwordImageView.mas_right).mas_equalTo(14);
        make.right.mas_equalTo(-23);
        make.centerY.mas_equalTo(passwordImageView);
        make.height.mas_equalTo(18);
    }];
    UIView *passwordLineView = [[UIView alloc]init];
    passwordLineView.backgroundColor = UIColorFromRGB(0xbebebe);
    [_loginView addSubview:passwordLineView];
    [passwordLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(passwordImageView.mas_bottom).mas_equalTo(5);
        make.left.mas_equalTo(23);
        make.right.mas_equalTo(-23);
        make.height.mas_equalTo(1);
    }];
    
    self.loginButton = [[UIButton alloc]init];
    _loginButton.backgroundColor = UIColorFromRGB(0xbebebe);
    [self.loginButton setTitleColor:UIColorFromRGB(0x7e7e7e) forState:UIControlStateNormal];
    [self.loginButton.layer setCornerRadius:8.0]; //设置矩圆角半径
    [_loginButton setTitle:@"登录" forState:UIControlStateNormal];
    [_loginButton addTarget:self action:@selector(loginClick:) forControlEvents:UIControlEventTouchUpInside];
    [_loginView addSubview:_loginButton];
    [_loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(23);
        make.right.mas_equalTo(-23);
        make.top.mas_equalTo(passwordLineView.mas_bottom).mas_equalTo(25*kScreenScale);
        make.height.mas_equalTo(39);
    }];
    
//    UIButton *button = [[UIButton alloc]init];
//    [button setTitle:@"取消授权" forState:UIControlStateNormal];
//    [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
//    [button addTarget:self action:@selector(cancelLogin:) forControlEvents:UIControlEventTouchUpInside];
//    [_loginView addSubview:button];
//    [button mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(_loginButton.mas_bottom).mas_equalTo(10);
//        make.centerX.mas_equalTo(_loginButton);
//        make.height.mas_equalTo(20);
//    }];
    
    UIView *registView = [[UIView alloc]init];
    [_loginView addSubview:registView];
    [registView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-20);
        make.centerX.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(130, 18));
    }];
    UILabel *bottomLabel = [[UILabel alloc]init];
    bottomLabel.text = @"没有账号？";
    bottomLabel.font = [UIFont systemFontOfSize:14];
    bottomLabel.textColor = UIColorFromRGB(0xB4B4B4);
    [registView addSubview:bottomLabel];
    [bottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.left.mas_equalTo(0);
    }];
    UILabel *registLabel = [[UILabel alloc]init];
    NSMutableAttributedString *registAttributedStr = [[NSMutableAttributedString alloc]initWithString:@"立即注册"];
    [registAttributedStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14.0] range:NSMakeRange(0, registAttributedStr.length)];
    [registAttributedStr addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0, registAttributedStr.length)];
    [registAttributedStr addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0x007aff) range:NSMakeRange(0, registAttributedStr.length)];
    registLabel.attributedText = registAttributedStr;
    registLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *registTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(registTap:)];
    [registLabel addGestureRecognizer:registTap];
    [registView addSubview:registLabel];
    [registLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(bottomLabel.mas_right);
        make.centerY.mas_equalTo(0);
    }];

}

-(void)tapLoginView:(UITapGestureRecognizer *)tap
{
    [self.userNameTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
}

-(void)registTap:(UITapGestureRecognizer *)tap
{
    [self performSegueWithIdentifier:@"registViewControllerSegue" sender:nil];
}

-(void)valueChanged:(UITextField *)sender
{
    if ([sender.text isEqualToString:@""]) {
        self.loginButton.userInteractionEnabled = NO;
        [self.loginButton setTitleColor:UIColorFromRGB(0x7e7e7e) forState:UIControlStateNormal];
        self.loginButton.backgroundColor = UIColorFromRGB(0xbebebe);
    }else{
        self.loginButton.userInteractionEnabled = YES;
        [self.loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.loginButton.backgroundColor = [UIColor colorWithRed:52/255.0 green:181/255.0 blue:254/255.0 alpha:1.0];
    }
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
    label.text = @"登录";
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
    [button addTarget:self action:@selector(backToPreferenceViewController) forControlEvents:UIControlEventTouchUpInside];
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

- (void)sinaLoginClick:(UIButton *)sender {
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina];
    
    snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
        
        //          获取微博用户名、uid、token等
        
        if (response.responseCode == UMSResponseCodeSuccess) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                // Set some text to show the initial status.
                    _hud.labelText = @"正在登录";
            });
            
            UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:UMShareToSina];
            
            //NSLog(@"username is %@, uid is %@, token is %@ url is %@ ,expirationDate is %@,appid is %@",snsAccount.userName,snsAccount.usid,snsAccount.accessToken,snsAccount.iconURL,snsAccount.expirationDate,snsAccount.appId);
            
            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
            [manager.requestSerializer setValue:@"0" forHTTPHeaderField:@"Client-Flag"];
            manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
            NSString *url = [NSString stringWithFormat:@"%@/%@",kUrl,kThirdLoginUrl];
            NSDictionary *dic = @{@"token":snsAccount.accessToken,@"openid":snsAccount.usid,@"thirdparty":@"1"};
            NSString *paramStr = [self dictionaryToJson:dic];
            NSDictionary *paramDic = @{@"json":paramStr};
            NSLog(@"paramDic:%@",paramDic);
            [manager POST:url parameters:paramDic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                NSLog(@"responseObject:%@",responseObject);
                if ([responseObject[@"Result"]integerValue] == 2) {
                    if ([responseObject[@"FailInfo"] isEqualToString:@"数据不存在"]) {
                        NSLog(@"账号没注册");
                        [_hud hide:YES];
                        [_hud removeFromSuperview];
                        ThirdTelVerificationViewController *thirdTelVerificationVC = [[ThirdTelVerificationViewController alloc]init];
                        thirdTelVerificationVC.thirdParty = @"1";
                        thirdTelVerificationVC.thirdToken = snsAccount.accessToken;
                        thirdTelVerificationVC.openID = snsAccount.usid;
                        [self.navigationController pushViewController:thirdTelVerificationVC animated:YES];
                    }else if ([responseObject[@"Result"]integerValue] == 1){
                        //其他错误情况
                        dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
                            _hud.mode = MBProgressHUDModeText;
                            _hud.labelText = @"登录失败";
                            sleep(1.5);
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [_hud hide:YES];
                                [_hud removeFromSuperview];
                            });
                        });
                    }
                }if ([responseObject[@"Result"]integerValue] == 0) {
                    //登陆成功
                    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                    [userDefaults setObject:@"1" forKey:@"thirdtype"];
                    [self saveNSUserDefaultsWithResponseObject:responseObject andTask:task];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        //                        MBProgressHUD *Hud = [[MBProgressHUD alloc] initWithView:self.view];
                        //                        [self.view addSubview:Hud];
                        _hud.labelText = @"登录成功";
                        _hud.labelFont = [UIFont systemFontOfSize:14];
                        _hud.mode = MBProgressHUDModeText;
                        [_hud showAnimated:YES whileExecutingBlock:^{
                            sleep(1.5);
                        } completionBlock:^{
                            [_hud removeFromSuperview];
                            [self dismissViewControllerAnimated:YES completion:nil];
                        }];
                    });
                    
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                NSLog(@"error:%@",error);
                dispatch_async(dispatch_get_main_queue(), ^{
                    _hud.labelText = @"连接超时";
                    _hud.labelFont = [UIFont systemFontOfSize:14];
                    _hud.mode = MBProgressHUDModeText;
                    [_hud showAnimated:YES whileExecutingBlock:^{
                        sleep(1.5);
                    } completionBlock:^{
                        [_hud removeFromSuperview];
                        [self dismissViewControllerAnimated:YES completion:nil];
                    }];
                });
            }];
            
        }});
}

- (void)qqLoginClick:(UIButton *)sender {
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToQQ];
    
    snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
        
        //          获取微博用户名、uid、token等
        NSLog(@"%u",response.responseCode);
        if (response.responseCode == UMSResponseCodeSuccess) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                // Set some text to show the initial status.
                _hud.labelText = @"正在登录";
            });
            
            UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:UMShareToQQ];
            
            //NSLog(@"username is %@, uid is %@, token is %@ url is %@ ,expirationDate is %@,appid is %@",snsAccount.userName,snsAccount.usid,snsAccount.accessToken,snsAccount.iconURL,snsAccount.expirationDate,snsAccount.appId);
            
            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
            [manager.requestSerializer setValue:@"0" forHTTPHeaderField:@"Client-Flag"];
            manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
            NSString *url = [NSString stringWithFormat:@"%@/%@",kUrl,kThirdLoginUrl];
            NSDictionary *dic = @{@"token":snsAccount.accessToken,@"openid":snsAccount.usid,@"thirdparty":@"0",@"appid":kQQappid};
            NSString *paramStr = [self dictionaryToJson:dic];
            NSDictionary *paramDic = @{@"json":paramStr};
            NSLog(@"paramDic:%@",paramDic);
            [manager POST:url parameters:paramDic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                NSLog(@"responseObject:%@",responseObject);
                if ([responseObject[@"Result"]integerValue] == 2) {
                    if ([responseObject[@"FailInfo"] isEqualToString:@"数据不存在"]) {
                        NSLog(@"账号没注册");
                        [_hud hide:YES];
                        [_hud removeFromSuperview];
                        ThirdTelVerificationViewController *thirdTelVerificationVC = [[ThirdTelVerificationViewController alloc]init];
                        thirdTelVerificationVC.thirdParty = @"0";
                        thirdTelVerificationVC.thirdToken = snsAccount.accessToken;
                        thirdTelVerificationVC.openID = snsAccount.usid;
                        [self.navigationController pushViewController:thirdTelVerificationVC animated:YES];
                    }else if ([responseObject[@"Result"]integerValue] == 1){
                        //其他错误情况
                        dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
                            _hud.mode = MBProgressHUDModeText;
                            _hud.labelText = @"登录失败";
                            sleep(1.5);
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [_hud hide:YES];
                                [_hud removeFromSuperview];
                            });
                        });
                    }
                }if ([responseObject[@"Result"]integerValue] == 0) {
                    //登陆成功
                    //将数据存储到NSUserDefautls中，
                    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                    [userDefaults setObject:@"0" forKey:@"thirdtype"];
                    [self saveNSUserDefaultsWithResponseObject:responseObject andTask:task];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
//                        MBProgressHUD *Hud = [[MBProgressHUD alloc] initWithView:self.view];
//                        [self.view addSubview:Hud];
                        _hud.labelText = @"登录成功";
                        _hud.labelFont = [UIFont systemFontOfSize:14];
                        _hud.mode = MBProgressHUDModeText;
                        [_hud showAnimated:YES whileExecutingBlock:^{
                            sleep(1.5);
                        } completionBlock:^{
                            [_hud removeFromSuperview];
                            [self dismissViewControllerAnimated:YES completion:nil];
                        }];
                    });
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                NSLog(@"error:%@",error);
                dispatch_async(dispatch_get_main_queue(), ^{
                    _hud.labelText = @"连接超时";
                    _hud.labelFont = [UIFont systemFontOfSize:14];
                    _hud.mode = MBProgressHUDModeText;
                    [_hud showAnimated:YES whileExecutingBlock:^{
                        sleep(1.5);
                    } completionBlock:^{
                        [_hud removeFromSuperview];
                        [self dismissViewControllerAnimated:YES completion:nil];
                    }];
                });
            }];
            
        }});
}
//取消授权
- (void)cancelLogin:(id)sender {
    [[UMSocialDataService defaultDataService] requestUnOauthWithType:UMShareToSina  completion:^(UMSocialResponseEntity *response){
        NSLog(@"sina response is %@",response);
    }];
    [[UMSocialDataService defaultDataService] requestUnOauthWithType:UMShareToQQ completion:^(UMSocialResponseEntity *response) {
        NSLog(@"qq response is %@",response);
    }];
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"登录页面"];//("PageOne"为页面名称，可自定义)
    
    
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
//    [self.btn addTarget: self action: @selector(backToPreferenceViewController) forControlEvents: UIControlEventTouchUpInside];
//    
//    //由于改写了leftBarButtonItem,所以需要重新定义右滑返回手势
//    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //增加键盘的弹起通知监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(openKeyboard:) name:UIKeyboardWillShowNotification object:nil];
    //增加键盘的收起通知监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closeKeyboard:) name:UIKeyboardWillHideNotification object:nil];
#pragma mark 如果已登录，则dismiss
    if([[[NSUserDefaults standardUserDefaults] objectForKey:@"login"] isEqualToString:@"登录成功"]){
        [self dismissViewControllerAnimated:YES completion:nil];
    }
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
 
    [UIView animateKeyframesWithDuration:duration delay:0 options:options animations:^{
        [self.loginView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(-keyboardFrame.size.height+50);
        }];
        [self.loginView setNeedsLayout];
        [self.loginView layoutIfNeeded];
    } completion:^(BOOL finished) {
        
    }];
}

-(void)closeKeyboard:(NSNotification *)noti
{
    // 获取键盘动画的种类
    int options = [noti.userInfo[UIKeyboardAnimationCurveUserInfoKey] intValue];
    
    // 获取键盘动画的时长
    NSTimeInterval duration = [noti.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    [UIView animateKeyframesWithDuration:duration delay:0 options:options animations:^{
        [self.loginView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(0);
        }];
        [self.loginView setNeedsLayout];
        [self.loginView layoutIfNeeded];
    } completion:^(BOOL finished) {
        
    }];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"登录页面"];
    
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    //取消注册过的通知
    //只按照通知的名字,取消掉具体的某个通知,而不是全部一次性取消掉所有注册过的通知
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}




- (void)loginClick:(id)sender {
    NSLog(@"您点击了登录按钮");
//    if ([self.phoneNumTextField.text isEqualToString:@""]) {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入账号" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//        [alert show];
//        return;
//    }
    if ([self.passwordTextField.text isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入密码" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    //  配置hud
    self.hud = [[MBProgressHUD alloc] init];
    self.hud.delegate = self;
    _hud.dimBackground = YES;
    _hud.labelText = @"正在登录";
    [self.view addSubview:_hud];
    [_hud show:YES];
    //[_hud hide:YES afterDelay:3];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
    //url
    //    NSString *url = @"http://appserver.ciqca.com/loginapi.action";
    NSString *url = [NSString stringWithFormat:@"%@/%@",kUrl,kLoginUrl];
    //md5
    self.passwordMd5 = [self.passwordTextField.text MD5];
    
    NSDictionary *dic = @{@"username":self.userNameTextField.text,@"userpassword":self.passwordMd5};
    NSString *strParam = [self dictionaryToJson:dic];
    NSDictionary *paramDic = @{@"json":strParam};
    
    [manager POST:url parameters:paramDic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setValue:responseObject[@"petname"] forKey:@"petname"];
        [userDefaults setValue:responseObject[@"gender"] forKey:@"gender"];
        [userDefaults setValue:responseObject[@"username"] forKey:@"username"];
        [userDefaults setValue:responseObject[@"roleid"] forKey:@"roleid"];
        [userDefaults setValue:responseObject[@"userid"] forKey:@"userid"];
        
        //打印header中的信息
        //NSLog(@"%@",task.response.allHeaderFields);
        //NSString *FailInfo = responseObject[@"FailInfo"];
        
        if ([responseObject[@"Result"]integerValue] == 0) {
            NSLog(@"登录成功");
            
            //将数据存储到NSUserDefautls中，
            [self saveNSUserDefaultsWithResponseObject:responseObject andTask:task];
            //登录成功返回到主页并提示登录成功
            
            
            
            //            self.alert = [[UIAlertView alloc] initWithTitle:nil message:@"登录成功" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
            

            
//            if ([self.from isEqualToString:@"recordDetail"] || [self.from isEqualToString:@"comment"] ) {
//                //[self.navigationController popViewControllerAnimated:YES];
//                [self dismissViewControllerAnimated:YES completion:nil];
//            }else{
//            
//                MainViewController *mainVC =[self.storyboard instantiateViewControllerWithIdentifier:@"mainViewController"];
//                mainVC.from = @"登录成功";
//                [self.navigationController pushViewController:mainVC animated:YES];
//                //将mainVC设为导航栏唯一页面，使其无法右滑返回
//                //[self.navigationController setViewControllers:@[mainVC]];
//            }
            dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
                // Do something useful in the background and update the HUD periodically.
                //MBProgressHUD *hud = [MBProgressHUD HUDForView:self.navigationController.view];
                // Indeterminate mode
                UIImage *image = [UIImage imageNamed:@"对勾"];
                UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
                imageView.image = image;
                //hud.customView = imageView;
                _hud.mode = MBProgressHUDModeText;
                _hud.labelText = @"登录成功";
                sleep(1.5);
                dispatch_async(dispatch_get_main_queue(), ^{
                    [_hud hide:YES];
                    [_hud removeFromSuperview];
                    [self dismissViewControllerAnimated:YES completion:nil];
                });
            });
            
            

            
            
        }else {
            [self.hud hide:YES];
            UIAlertView *alert2 = [[UIAlertView alloc] initWithTitle:@"提示" message:@"用户名或密码错误" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert2 show];
        }

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"登录失败－－－－－%@",error);
        //  隐藏hud
        [self.hud hide:YES];
    }];
    
    
//    [manager POST:url parameters:paramDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSLog(@"%@",responseObject);
//        
//        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//        [userDefaults setValue:responseObject[@"petname"] forKey:@"petname"];
//        [userDefaults setValue:responseObject[@"gender"] forKey:@"gender"];
//        [userDefaults setValue:responseObject[@"username"] forKey:@"username"];
//        [userDefaults setValue:responseObject[@"roleid"] forKey:@"roleid"];
//        [userDefaults setValue:responseObject[@"userid"] forKey:@"userid"];
//        
//        //打印header中的信息
//        NSLog(@"%@",operation.response.allHeaderFields);
//        NSString *FailInfo = responseObject[@"FailInfo"];
//        
//        if ([responseObject[@"Result"]integerValue] == 0) {
//            NSLog(@"登录成功");
//            
//            //将数据存储到NSUserDefautls中，
//            [self saveNSUserDefaultsWithResponseObject:responseObject andOperation:operation];
//            //登录成功返回到主页并提示登录成功
//            
//            
//            
//            //            self.alert = [[UIAlertView alloc] initWithTitle:nil message:@"登录成功" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
//            
//            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//            [userDefaults setObject:@"登录成功" forKey:@"login"];
//            
//            ViewController *VC =[[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"storyBoardID"];
//            [self.navigationController pushViewController:VC animated:YES];
//            
//            
//            
//            MBProgressHUD *Hud = [[MBProgressHUD alloc] initWithView:self.view];
//            [self.view addSubview:Hud];
//            Hud.labelText = @"登录成功";
//            Hud.labelFont = [UIFont systemFontOfSize:14];
//            Hud.mode = MBProgressHUDModeText;
//            
//            //            hud.yOffset = 250;
//            
//            
//            [Hud showAnimated:YES whileExecutingBlock:^{
//                sleep(3);
//                
//            } completionBlock:^{
//                [Hud removeFromSuperview];
//                
//                
//            }];
//            
//            
//        }else {
//            [hud hide:YES];
//            UIAlertView *alert2 = [[UIAlertView alloc] initWithTitle:@"提示" message:@"用户名或密码错误" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//            [alert2 show];
//        }
//        
//        [hud hide:YES];
//        [hud removeFromSuperview];
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"登录失败－－－－－%@",error);
//        //  隐藏hud
//        [hud hide:YES];
//        [hud removeFromSuperview];
//        
//    }];

    
}

//hub的内存管理
-(void)hudWasHidden:(MBProgressHUD *)hud
{
    [hud removeFromSuperview];
    hud.delegate = nil;
    hud = nil;
}

-(void)backToPreferenceViewController
{
    //[self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 保存数据到NSUserDefaults
-(void)saveNSUserDefaultsWithResponseObject:(id)responseObject andTask:(NSURLSessionTask *)task
{
    
    NSString *username = responseObject[@"username"];
    NSString *userid = responseObject[@"userid"];
    NSString *petname = responseObject[@"petname"];
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;
    NSString *caToken = httpResponse.allHeaderFields[@"CA-Token"];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    [userDefaults setValue:responseObject[@"gender"] forKey:@"gender"];
    [userDefaults setValue:responseObject[@"roleid"] forKey:@"roleid"];
    
    [userDefaults setObject:username forKey:@"username"];
    [userDefaults setObject:userid forKey:@"userid"];
    [userDefaults setObject:petname forKey:@"petname"];
    [userDefaults setObject:self.passwordTextField.text forKey:@"password"];
    [userDefaults setObject:caToken forKey:@"CA-Token"];
    NSLog(@"CA-Token = %@",caToken);

    [userDefaults setObject:@"登录成功" forKey:@"login"];
    //设置logout为空，不然主页面会弹出2个hud
    [userDefaults setObject:@"" forKey:@"logout"];
    
    [userDefaults synchronize];   //这行代码一定要加，虽然有时候不加这一行代码也能保存成功，但是如果程序运行占用比较大的内存的时候不加这行代码，可能会造成无法写入plist文件中
}


- (NSString*)dictionaryToJson:(NSDictionary *)dic
{
    
    NSError *parseError = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
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
