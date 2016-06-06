//
//  ThirdTelVerificationViewController.m
//  BaseProject
//
//  Created by 刘子琨 on 16/6/2.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import "ThirdTelVerificationViewController.h"

#define kQQappid @"1104866715"

@interface ThirdTelVerificationViewController ()

@property (nonatomic,strong) UITextField *phoneNumTextField;
@property (nonatomic,strong) UITextField *verificationTextField;
@property (nonatomic,strong) UIButton *verificationButton;
@property (nonatomic,strong) UIButton *confirmButton;

@end

@implementation ThirdTelVerificationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    [self setNavigationBar];
    
    
    UILabel *phoneNumLabel = [[UILabel alloc]init];
    phoneNumLabel.text = @"手机号";
    phoneNumLabel.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:phoneNumLabel];
    [phoneNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(23);
        make.top.mas_equalTo(91);
    }];
    self.phoneNumTextField = [[UITextField alloc]init];
    _phoneNumTextField.placeholder = @"请输入手机号";
    _phoneNumTextField.font = [UIFont systemFontOfSize:14];
    [self.phoneNumTextField addTarget:self  action:@selector(valueChanged:)  forControlEvents:UIControlEventAllEditingEvents];
    [self.view addSubview:_phoneNumTextField];
    [_phoneNumTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(phoneNumLabel);
        make.left.mas_equalTo(95);
        make.right.mas_equalTo(-23);
        make.height.mas_equalTo(28);
    }];
    UIView *firstLineView = [[UIView alloc]init];
    firstLineView.backgroundColor = UIColorFromRGB(0xbebebe);
    [self.view addSubview:firstLineView];
    [firstLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(23);
        make.right.mas_equalTo(-23);
        make.top.mas_equalTo(phoneNumLabel.mas_bottom).mas_equalTo(20);
        make.height.mas_equalTo(1);
    }];
    UILabel *verificationLabel = [[UILabel alloc]init];
    verificationLabel.text = @"验证码";
    verificationLabel.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:verificationLabel];
    [verificationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(23);
        make.top.mas_equalTo(firstLineView).mas_equalTo(20);
    }];
    self.verificationButton = [[UIButton alloc]init];
    [_verificationButton setTitle:@"点击获取" forState:UIControlStateNormal];
    [_verificationButton addTarget:self action:@selector(sendVerification:) forControlEvents:UIControlEventTouchUpInside];
    _verificationButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [_verificationButton setTitleColor:[UIColor colorWithRed:52/255.0 green:181/255.0 blue:254/255.0 alpha:1] forState:UIControlStateNormal];
    [_verificationButton.layer setMasksToBounds:YES];
    [_verificationButton.layer setCornerRadius:6.0]; //设置矩圆角半径
    [_verificationButton.layer setBorderWidth:1.0];   //边框宽度
    [_verificationButton.layer setBorderColor:[UIColor colorWithRed:52/255.0 green:181/255.0 blue:254/255.0 alpha:1].CGColor];
    [self.view addSubview:_verificationButton];
    [_verificationButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-23);
        make.centerY.mas_equalTo(verificationLabel);
        make.size.mas_equalTo(CGSizeMake(90, 28));
    }];
    self.verificationTextField = [[UITextField alloc]init];
    _verificationTextField.placeholder = @"请输入验证码";
    _verificationTextField.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:_verificationTextField];
    [_verificationTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(95);
        make.right.mas_equalTo(_verificationButton.mas_left).mas_equalTo(-10);
        make.height.mas_equalTo(25);
        make.centerY.mas_equalTo(verificationLabel);
    }];
    UIView *secondLineView = [[UIView alloc]init];
    secondLineView.backgroundColor = UIColorFromRGB(0xd3d3d3);
    [self.view addSubview:secondLineView];
    [secondLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(verificationLabel.mas_bottom).mas_equalTo(20);
        make.left.mas_equalTo(23);
        make.right.mas_equalTo(-23);
        make.height.mas_equalTo(1);
    }];
    self.confirmButton = [[UIButton alloc]init];
    [_confirmButton addTarget:self action:@selector(confirmClick:) forControlEvents:UIControlEventTouchUpInside];
    _confirmButton.backgroundColor = [UIColor colorWithRed:52/255.0 green:181/255.0 blue:254/255.0 alpha:1];
    [_confirmButton setTitle:@"确定" forState:UIControlStateNormal];
    [_confirmButton.layer setCornerRadius:6.0]; //设置矩圆角半径
    [self.view addSubview:_confirmButton];
    [_confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(23);
        make.right.mas_equalTo(-23);
        make.height.mas_equalTo(40);
        make.top.mas_equalTo(secondLineView).mas_equalTo(30);
    }];
}

-(void)valueChanged:(UITextField *)sender
{
    //NSLog(@"text:%@",sender.text);
    
    if (![self isMobileNumber:sender.text]) {
        _confirmButton.userInteractionEnabled = NO;
        [_confirmButton setTitleColor:UIColorFromRGB(0x7e7e7e) forState:UIControlStateNormal];
        _confirmButton.backgroundColor = UIColorFromRGB(0xbebebe);
        
        self.verificationButton.userInteractionEnabled = NO;
        [self.verificationButton setTitleColor:UIColorFromRGB(0x7e7e7e) forState:UIControlStateNormal];
        self.verificationButton.layer.borderColor = UIColorFromRGB(0x7e7e7e).CGColor;
    }else{
        _confirmButton.userInteractionEnabled = YES;
        [_confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _confirmButton.backgroundColor = [UIColor colorWithRed:52/255.0 green:181/255.0 blue:254/255.0 alpha:1.0];
        
        self.verificationButton.userInteractionEnabled = YES;
        [self.verificationButton setTitleColor:[UIColor colorWithRed:52/255.0 green:181/255.0 blue:254/255.0 alpha:1.0] forState:UIControlStateNormal];
        self.verificationButton.layer.borderColor = [UIColor colorWithRed:52/255.0 green:181/255.0 blue:254/255.0 alpha:1.0].CGColor;
    }
}

-(void)confirmClick:(UIButton *)sender
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.requestSerializer setValue:@"0" forHTTPHeaderField:@"Client-Flag"];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
    NSString *url = [NSString stringWithFormat:@"%@/%@",kUrl,kThirdRegistUrl];
    NSDictionary *dic = [NSDictionary dictionary];
    if ([_thirdParty integerValue] == 0) {
        dic = @{@"token":_thirdToken,@"checkcode":_verificationTextField.text,@"openid":_openID,@"thirdparty":_thirdParty,@"appid":kQQappid,@"usermobilephone":_phoneNumTextField.text};
    }else if ([_thirdParty integerValue] == 1)
    {
        dic = @{@"token":_thirdToken,@"checkcode":_verificationTextField.text,@"openid":_openID,@"thirdparty":_thirdParty,@"usermobilephone":_phoneNumTextField.text};
    }
    
    NSString *paramStr = [self dictionaryToJson:dic];
    NSDictionary *paramDic = @{@"json":paramStr};
    NSLog(@"paramDic:%@",paramDic);
    [manager POST:url parameters:paramDic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"responseObject:%@",responseObject);
        if ([responseObject[@"Result"]integerValue] == 0) {//登录成功
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults setValue:responseObject[@"petname"] forKey:@"petname"];
            [userDefaults setValue:responseObject[@"gender"] forKey:@"gender"];
            [userDefaults setValue:responseObject[@"username"] forKey:@"username"];
            [userDefaults setValue:responseObject[@"roleid"] forKey:@"roleid"];
            [userDefaults setValue:responseObject[@"userid"] forKey:@"userid"];
            //将数据存储到NSUserDefautls中，
            [self saveNSUserDefaultsWithResponseObject:responseObject andTask:task];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                MBProgressHUD *Hud = [[MBProgressHUD alloc] initWithView:self.view];
                [self.view addSubview:Hud];
                Hud.labelText = @"登录成功";
                Hud.labelFont = [UIFont systemFontOfSize:14];
                Hud.mode = MBProgressHUDModeText;
                //            hud.yOffset = 250;
                [Hud showAnimated:YES whileExecutingBlock:^{
                    sleep(1.5);
                } completionBlock:^{
                    [Hud removeFromSuperview];
                    [self.navigationController popViewControllerAnimated:YES];
                }];
            });
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error:%@",error);
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
    label.text = @"手机验证";
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
    
    
    UIButton *leftButton = [[UIButton alloc]init];
    [leftButton setTitle:@"返回" forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(backToLoginViewController) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:leftButton];
    [leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(5);
        make.top.mas_equalTo(20);
        make.size.mas_equalTo(CGSizeMake(80, 44));
    }];
    //手动添加highlight效果
    leftButton.tag = 101;
    [leftButton addTarget:self action:@selector(tapBack:) forControlEvents:UIControlEventTouchDown];
    [leftButton addTarget:self action:@selector(tapUp:) forControlEvents:UIControlEventTouchUpOutside];
    
    UIImage *image = [UIImage imageNamed:@"返回箭头"];
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = image;
    [leftButton addSubview:imageView];
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

//发送验证码
- (void)sendVerification:(id)sender {
    self.verificationButton.userInteractionEnabled = NO;
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
    
    if (![self isMobileNumber:self.phoneNumTextField.text]) {
        NSLog(@"手机号有误");
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"手机号有误" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        self.verificationButton.userInteractionEnabled = YES;
    }else{
        NSDictionary *dic = @{@"phone":self.phoneNumTextField.text};
        NSString *strParam = [self dictionaryToJson:dic];
        NSDictionary *paramDic = @{@"json":strParam};
        
        NSString *url = [NSString stringWithFormat:@"%@/%@",kUrl,kPushCodeUrl];
        
        
        //  AFN POST 请求
        [manager POST:url parameters:paramDic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            //打印返回值
            NSLog(@"%@",responseObject);
            NSString *str = responseObject[@"FailInfo"];
            if ([str isEqualToString:@"记录已存在"]) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"该手机号已注册，请直接使用手机号登录" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
                self.verificationButton.userInteractionEnabled = YES;
                return ;
            }else{
                [self countDown];//倒计时
            }
            if ([responseObject[@"Result"] integerValue] != 0) {
                //self.string = responseObject[@"FailInfo"];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:responseObject[@"FailInfo"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert  show];
                
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"验证失败 %@",error);
        }];
        
    }
    
}

#pragma mark - 保存数据到NSUserDefaults
-(void)saveNSUserDefaultsWithResponseObject:(id)responseObject andTask:(NSURLSessionTask *)task
{
    
    NSString *username = responseObject[@"username"];
    NSString *userid = responseObject[@"userid"];
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;
    NSString *caToken = httpResponse.allHeaderFields[@"CA-Token"];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    
    [userDefaults setObject:username forKey:@"username"];
    [userDefaults setObject:userid forKey:@"userid"];
    [userDefaults setObject:caToken forKey:@"CA-Token"];
    [userDefaults setObject:_thirdParty forKey:@"thirdtype"];
    NSLog(@"CA-Token = %@",caToken);
    
    [userDefaults setObject:@"登录成功" forKey:@"login"];
    //设置logout为空，不然主页面会弹出2个hud
    [userDefaults setObject:@"" forKey:@"logout"];
    
    [userDefaults synchronize];   //这行代码一定要加，虽然有时候不加这一行代码也能保存成功，但是如果程序运行占用比较大的内存的时候不加这行代码，可能会造成无法写入plist文件中
    
}

// 正则判断手机号码地址格式
- (BOOL)isMobileNumber:(NSString *)mobileNum {
    
    //    电信号段:133/153/180/181/189/177
    //    联通号段:130/131/132/155/156/185/186/145/176
    //    移动号段:134/135/136/137/138/139/150/151/152/157/158/159/182/183/184/187/188/147/178
    //    虚拟运营商:170
    
    NSString *MOBILE = @"^1(3[0-9]|4[57]|5[0-35-9]|8[0-9]|7[06-8])\\d{8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    
    return [regextestmobile evaluateWithObject:mobileNum];
}

//字典转json串
- (NSString*)dictionaryToJson:(NSDictionary *)dic

{
    
    NSError *parseError = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
}

//倒计时
-(void)countDown
{
    __block int timeout = 60; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout <= 0)
        { //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [self.verificationButton setTitle:@"点击获取" forState:UIControlStateNormal];
                [self.verificationButton.layer setBorderColor:[UIColor colorWithRed:52/255.0 green:181/255.0 blue:254/255.0 alpha:1].CGColor];
                [self.verificationButton setTitleColor:[UIColor colorWithRed:52/255.0 green:181/255.0 blue:254/255.0 alpha:1] forState:UIControlStateNormal];
                self.verificationButton.userInteractionEnabled = YES;
            });
            
        }else{
            NSString *strTime = [NSString stringWithFormat:@"%.2d", timeout];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [self.verificationButton setTitle:[NSString stringWithFormat:@"重新获取(%@)",strTime] forState:UIControlStateNormal];
                [self.verificationButton.layer setBorderColor:[UIColor grayColor].CGColor];
                [self.verificationButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
                self.verificationButton.userInteractionEnabled = NO;
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
}


-(void)backToLoginViewController
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"第三方手机验证页面"];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"第三方手机验证页面"];
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
