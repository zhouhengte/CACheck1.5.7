//
//  PasswordViewController.m
//  CACheck
//
//  Created by 刘子琨 on 16/1/28.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import "PasswordViewController.h"
#import "NSString+MD5.h"

@interface PasswordViewController ()

@property (strong,nonatomic)UITextField *oldPasswordTextField;
@property (strong,nonatomic)UITextField *freshPasswordTextField;
@property (strong,nonatomic)UITextField *repeatPasswordTextField;

@property (strong,nonatomic)UITextField *phoneNumTextField;
@property (strong,nonatomic)UITextField *verificationTextField;
@property (strong,nonatomic)UIButton *verificationButton;
@property (strong,nonatomic)NSString *thirdType;
@property (strong,nonatomic)UIButton *confirmButton;

@end

@implementation PasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    self.thirdType = [[NSUserDefaults standardUserDefaults]objectForKey:@"thirdtype"];
    [self setNavigationBar];
    
    if (self.thirdType) {
        [self setThirdLoginInterface];
    }else{
        [self setInterface];
    }
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"修改密码页面"];//("PageOne"为页面名称，可自定义)
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"修改密码页面"];
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
    label.text = @"修改密码";
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
    [leftButton addTarget:self action:@selector(backToPersonalInformationViewController) forControlEvents:UIControlEventTouchUpInside];
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
    
    if (!self.thirdType) {
        UIButton *rightButton = [[UIButton alloc]init];
        [rightButton setTitle:@"提交" forState:UIControlStateNormal];
        [rightButton addTarget:self action:@selector(rightItemAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:rightButton];
        [rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-15);
            make.top.mas_equalTo(20);
            make.size.mas_equalTo(CGSizeMake(50, 44));
        }];
        //手动添加highlight效果
        rightButton.tag = 102;
        [rightButton addTarget:self action:@selector(tapBack:) forControlEvents:UIControlEventTouchDown];
        [rightButton addTarget:self action:@selector(tapUp:) forControlEvents:UIControlEventTouchUpOutside];
    }

    
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

-(void)setInterface
{
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(81);
        make.left.mas_equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, 44));
    }];
    
    UILabel *label = [[UILabel alloc]init];
    [view addSubview:label];
    label.text = @"旧密码";
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.top.mas_equalTo(10);
        make.size.mas_equalTo(CGSizeMake(70, 24));
    }];
    
    self.oldPasswordTextField = [[UITextField alloc]init];
    self.oldPasswordTextField.placeholder = @"请输入旧密码";
    self.oldPasswordTextField.secureTextEntry = YES;
    [view addSubview:self.oldPasswordTextField];
    [self.oldPasswordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(label.mas_right).mas_equalTo(10);
        make.top.mas_equalTo(10);
        make.right.mas_equalTo(-20);
        make.bottom.mas_equalTo(-10);
    }];
    
    
    UIView *freshView = [[UIView alloc]init];
    freshView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:freshView];
    [freshView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(view.mas_bottom).mas_equalTo(1);
        make.left.mas_equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, 44));
    }];
    
    UILabel *freshLabel = [[UILabel alloc]init];
    [freshView addSubview:freshLabel];
    freshLabel.text = @"新密码";
    [freshLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.top.mas_equalTo(10);
        make.size.mas_equalTo(CGSizeMake(70, 24));
    }];
    
    self.freshPasswordTextField = [[UITextField alloc]init];
    self.freshPasswordTextField.placeholder = @"请输入6位以上密码";
    self.freshPasswordTextField.secureTextEntry = YES;
    [freshView addSubview:self.freshPasswordTextField];
    [self.freshPasswordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(label.mas_right).mas_equalTo(10);
        make.top.mas_equalTo(10);
        make.right.mas_equalTo(-20);
        make.bottom.mas_equalTo(-10);
    }];
    
    UIView *repeatView = [[UIView alloc]init];
    repeatView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:repeatView];
    [repeatView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(freshView.mas_bottom).mas_equalTo(1);
        make.left.mas_equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, 44));
    }];
    
    UILabel *repeatLabel = [[UILabel alloc]init];
    [repeatView addSubview:repeatLabel];
    repeatLabel.text = @"重复密码";
    [repeatLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.top.mas_equalTo(10);
        make.size.mas_equalTo(CGSizeMake(70, 24));
    }];
    
    self.repeatPasswordTextField = [[UITextField alloc]init];
    self.repeatPasswordTextField.placeholder = @"请再次输入";
    self.repeatPasswordTextField.secureTextEntry = YES;
    [repeatView addSubview:self.repeatPasswordTextField];
    [self.repeatPasswordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(label.mas_right).mas_equalTo(10);
        make.top.mas_equalTo(10);
        make.right.mas_equalTo(-20);
        make.bottom.mas_equalTo(-10);
    }];

}

-(void)setThirdLoginInterface
{
    UILabel *phoneNumLabel = [[UILabel alloc]init];
    phoneNumLabel.text = @"手机号";
    [self.view addSubview:phoneNumLabel];
    [phoneNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(23);
        make.top.mas_equalTo(91);
    }];
    self.phoneNumTextField = [[UITextField alloc]init];
    _phoneNumTextField.placeholder = @"请输入手机号";
    [_phoneNumTextField setValue:UIColorFromRGB(0xa0a0a0) forKeyPath:@"_placeholderLabel.textColor"];
    _phoneNumTextField.font = [UIFont systemFontOfSize:14];
    [self.phoneNumTextField addTarget:self  action:@selector(valueChanged:)  forControlEvents:UIControlEventAllEditingEvents];
    [self.view addSubview:_phoneNumTextField];
    [_phoneNumTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(110);
        make.right.mas_equalTo(-23);
        make.height.mas_equalTo(25);
        make.centerY.mas_equalTo(phoneNumLabel);
    }];
    UIView *firstLineView = [[UIView alloc]init];
    firstLineView.backgroundColor = UIColorFromRGB(0xbebebe);
    [self.view addSubview:firstLineView];
    [firstLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(phoneNumLabel.mas_bottom).mas_equalTo(20);
        make.left.mas_equalTo(23);
        make.right.mas_equalTo(-23);
        make.height.mas_equalTo(0.5);
    }];
    
    UILabel *verificationLabel = [[UILabel alloc]init];
    verificationLabel.text = @"验证码";
    [self.view addSubview:verificationLabel];
    [verificationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(23);
        make.top.mas_equalTo(firstLineView).mas_equalTo(20);
    }];
    self.verificationButton = [[UIButton alloc]init];
    [_verificationButton setTitle:@"点击获取" forState:UIControlStateNormal];
    [_verificationButton addTarget:self action:@selector(sendVerification:) forControlEvents:UIControlEventTouchUpInside];
    _verificationButton.titleLabel.font = [UIFont systemFontOfSize:14];
    self.verificationButton.userInteractionEnabled = NO;
    [self.verificationButton setTitleColor:UIColorFromRGB(0x7e7e7e) forState:UIControlStateNormal];
    self.verificationButton.layer.borderColor = UIColorFromRGB(0x7e7e7e).CGColor;
    [_verificationButton.layer setMasksToBounds:YES];
    [_verificationButton.layer setCornerRadius:6.0]; //设置矩圆角半径
    [_verificationButton.layer setBorderWidth:1.0];   //边框宽度

    [self.view addSubview:_verificationButton];
    [_verificationButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-23);
        make.centerY.mas_equalTo(verificationLabel);
        make.size.mas_equalTo(CGSizeMake(90, 28));
    }];
    self.verificationTextField = [[UITextField alloc]init];
    _verificationTextField.placeholder = @"请输入验证码";
    [_verificationTextField setValue:UIColorFromRGB(0xa0a0a0) forKeyPath:@"_placeholderLabel.textColor"];
    _verificationTextField.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:_verificationTextField];
    [_verificationTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(110);
        make.right.mas_equalTo(_verificationButton.mas_left).mas_equalTo(-10);
        make.height.mas_equalTo(25);
        make.centerY.mas_equalTo(verificationLabel);
    }];
    UIView *secondLineView = [[UIView alloc]init];
    secondLineView.backgroundColor = UIColorFromRGB(0xbebebe);
    [self.view addSubview:secondLineView];
    [secondLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(verificationLabel.mas_bottom).mas_equalTo(20);
        make.left.mas_equalTo(23);
        make.right.mas_equalTo(-23);
        make.height.mas_equalTo(0.5);
    }];
    
    UILabel *freshPasswordLabel = [[UILabel alloc]init];
    freshPasswordLabel.text = @"新密码";
    [self.view addSubview:freshPasswordLabel];
    [freshPasswordLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(secondLineView).mas_equalTo(20);
        make.left.mas_equalTo(23);
    }];
    self.freshPasswordTextField = [[UITextField alloc]init];
    _freshPasswordTextField.placeholder = @"请输入新密码";
    [_freshPasswordTextField setValue:UIColorFromRGB(0xa0a0a0) forKeyPath:@"_placeholderLabel.textColor"];
    _freshPasswordTextField.secureTextEntry = YES;
    _freshPasswordTextField.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:_freshPasswordTextField];
    [_freshPasswordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(freshPasswordLabel);
        make.left.mas_equalTo(110);
        make.height.mas_equalTo(25);
        make.right.mas_equalTo(-23);
    }];
    UIView *thirdLineView = [[UIView alloc]init];
    thirdLineView.backgroundColor = UIColorFromRGB(0xbebebe);
    [self.view addSubview:thirdLineView];
    [thirdLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(23);
        make.right.mas_equalTo(-23);
        make.top.mas_equalTo(freshPasswordLabel.mas_bottom).mas_equalTo(20);
        make.height.mas_equalTo(0.5);
    }];
    
    UILabel *repeatPasswordLabel = [[UILabel alloc]init];
    repeatPasswordLabel.text = @"确认密码";
    [self.view addSubview:repeatPasswordLabel];
    [repeatPasswordLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(23);
        make.top.mas_equalTo(thirdLineView).mas_equalTo(20);
    }];
    self.repeatPasswordTextField = [[UITextField alloc]init];
    _repeatPasswordTextField.placeholder = @"请再次输入新密码";
    [_repeatPasswordTextField setValue:UIColorFromRGB(0xa0a0a0) forKeyPath:@"_placeholderLabel.textColor"];
    _repeatPasswordTextField.secureTextEntry = YES;
    _repeatPasswordTextField.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:_repeatPasswordTextField];
    [_repeatPasswordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(repeatPasswordLabel);
        make.left.mas_equalTo(110);
        make.height.mas_equalTo(25);
        make.right.mas_equalTo(-23);
    }];
    UIView *forthLineView = [[UIView alloc]init];
    forthLineView.backgroundColor = UIColorFromRGB(0xbebebe);
    [self.view addSubview:forthLineView];
    [forthLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(repeatPasswordLabel.mas_bottom).mas_equalTo(20);
        make.left.mas_equalTo(23);
        make.right.mas_equalTo(-23);
        make.height.mas_equalTo(0.5);
    }];
    
    self.confirmButton = [[UIButton alloc]init];
    [_confirmButton addTarget:self action:@selector(confirmClick:) forControlEvents:UIControlEventTouchUpInside];
    _confirmButton.userInteractionEnabled = NO;
    [_confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _confirmButton.backgroundColor = UIColorFromRGB(0xdcdcdc);
    [_confirmButton setTitle:@"确定" forState:UIControlStateNormal];
    [_confirmButton.layer setCornerRadius:5.0]; //设置矩圆角半径
    _confirmButton.titleLabel.font = [UIFont systemFontOfSize:17];
    [self.view addSubview:_confirmButton];
    [_confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(23);
        make.right.mas_equalTo(-23);
        make.height.mas_equalTo(40);
        make.top.mas_equalTo(forthLineView).mas_equalTo(30);
    }];
}

-(void)valueChanged:(UITextField *)sender
{
    //NSLog(@"text:%@",sender.text);
    
    if (![self isMobileNumber:sender.text]) {
        _confirmButton.userInteractionEnabled = NO;
        //[_confirmButton setTitleColor:UIColorFromRGB(0x7e7e7e) forState:UIControlStateNormal];
        _confirmButton.backgroundColor = UIColorFromRGB(0xdcdcdc);
        
        self.verificationButton.userInteractionEnabled = NO;
        [self.verificationButton setTitleColor:UIColorFromRGB(0x7e7e7e) forState:UIControlStateNormal];
        self.verificationButton.layer.borderColor = UIColorFromRGB(0x7e7e7e).CGColor;
    }else{
        _confirmButton.userInteractionEnabled = YES;
        //[_confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _confirmButton.backgroundColor = [UIColor colorWithRed:52/255.0 green:181/255.0 blue:254/255.0 alpha:1.0];
        
        self.verificationButton.userInteractionEnabled = YES;
        [self.verificationButton setTitleColor:[UIColor colorWithRed:52/255.0 green:181/255.0 blue:254/255.0 alpha:1.0] forState:UIControlStateNormal];
        self.verificationButton.layer.borderColor = [UIColor colorWithRed:52/255.0 green:181/255.0 blue:254/255.0 alpha:1.0].CGColor;
    }
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

-(void)backToPersonalInformationViewController
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)sendVerification:(UIButton *)sender
{
    sender.userInteractionEnabled = NO;
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
    
    if (![self isMobileNumber:self.phoneNumTextField.text]) {
        NSLog(@"手机号有误");
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"手机号有误" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        sender.userInteractionEnabled = YES;
    }else{
        NSDictionary *dic = @{@"phone":self.phoneNumTextField.text,@"openid":@"1"};
        NSString *strParam = [self dictionaryToJson:dic];
        NSDictionary *paramDic = @{@"json":strParam};
        
        NSString *url = [NSString stringWithFormat:@"%@/%@",kUrl,kPushCodeUrl];
        
        
        //  AFN POST 请求
        [manager POST:url parameters:paramDic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            //打印返回值
            NSLog(@"%@",responseObject);
            NSString *str = responseObject[@"FailInfo"];
            if ([str isEqualToString:@"记录已存在"]) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:str delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
                sender.userInteractionEnabled = YES;
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

-(void)confirmClick:(UIButton *)sender
{
    if (![self isMobileNumber:self.phoneNumTextField.text]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"手机号有误" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    if ([_verificationTextField.text isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入验证码" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    if ([self.freshPasswordTextField.text length]<6||[self.freshPasswordTextField.text length]>20) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入6位以上密码" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }else{
        if (![self.freshPasswordTextField.text  isEqualToString: self.repeatPasswordTextField.text] ) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"两次密码输入不一致" delegate:nil cancelButtonTitle:@"确定"otherButtonTitles:nil, nil];
            [alert show];
        }else{
            //判断正确走这个方法
            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            NSString *token = [userDefaults objectForKey:@"CA-Token"];
            NSString *userName = [userDefaults objectForKey:@"username"];
            NSString *thirdParty = [userDefaults objectForKey:@"thirdtype"];
            [manager.requestSerializer setValue:@"0" forHTTPHeaderField:@"Client-Flag"];
            [manager.requestSerializer setValue:token forHTTPHeaderField:@"CA-Token"];
            manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
            NSString *url = [NSString stringWithFormat:@"%@/%@",kUrl,kUpdateThirdPasswordUrl];
            NSDictionary *dic = @{@"username":userName,@"thirdparty":thirdParty,@"checkcode":_verificationTextField.text,@"userpassword":[_freshPasswordTextField.text MD5]};
            NSString *paramStr = [self dictionaryToJson:dic];
            NSDictionary *paramDic = @{@"json":paramStr};
            NSLog(@"paramDic:%@",paramDic);
            [manager POST:url parameters:paramDic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                NSLog(@"responseObject:%@",responseObject);
                if ([responseObject[@"Result"]integerValue] == 0){
                    [userDefaults setObject:@"修改成功" forKey:@"password"];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        MBProgressHUD *Hud = [[MBProgressHUD alloc] initWithView:self.view];
                        [self.view addSubview:Hud];
                        Hud.labelText = @"修改成功";
                        Hud.labelFont = [UIFont systemFontOfSize:14];
                        Hud.mode = MBProgressHUDModeText;
                        //            hud.yOffset = 250;
                        [Hud showAnimated:YES whileExecutingBlock:^{
                            sleep(1.5);
                        } completionBlock:^{
                            [Hud removeFromSuperview];
                            [self.navigationController popViewControllerAnimated:YES];;
                        }];
                    });
                    
                }
                if ([responseObject[@"Result"] integerValue] != 0) {
                    //self.string = responseObject[@"FailInfo"];
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:responseObject[@"FailInfo"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [alert  show];
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                NSLog(@"error:%@",error);
            }];

        }
    }
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

-(void)rightItemAction:(UIButton *)sender
{
    sender.alpha = 1;
    if ([self.freshPasswordTextField.text length]<6||[self.freshPasswordTextField.text length]>20) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入6位以上密码" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }else{
        if (![self.freshPasswordTextField.text  isEqualToString: self.repeatPasswordTextField.text] ) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"两次密码输入不一致" delegate:nil cancelButtonTitle:@"确定"otherButtonTitles:nil, nil];
            [alert show];
        }else{
            //判断正确走这个方法
            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
            
            manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
            
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            NSString *catoken = [userDefaults stringForKey:@"CA-Token"];
            
            [manager.requestSerializer setValue:catoken forHTTPHeaderField:@"CA-Token"];
            
            
            NSString *url = [NSString stringWithFormat:@"%@/%@",kUrl,kInfoUrl];
            //            NSString *url = @"http://appserver.ciqca.com/modifyappuserapi.action";
            NSString *username = [userDefaults stringForKey:@"username"];
            
            NSString *oldpassword = [self.oldPasswordTextField.text MD5];
            NSString *newpassword = [self.freshPasswordTextField.text MD5];
            
            
            NSDictionary * dic = @{@"username":username,@"olduserpassword":oldpassword,@"userpassword":newpassword,@"roleid":[NSNumber numberWithInt:1],@"status":[NSNumber numberWithInt:1]};
            
            NSString *dicStr = [self dictionaryToJson:dic];
            NSDictionary *paramDic = @{@"json":dicStr};
            
            [manager POST:url parameters:paramDic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                NSString *str = responseObject[@"FailInfo"];
                //                NSInteger *result = responseObject[@"Result"]integerValue;
                if ([responseObject[@"Result"]integerValue] == 0) {
                    [userDefaults setObject:@"修改成功" forKey:@"password"];
                    [self.navigationController popViewControllerAnimated:YES];
                    //                    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
                }else{
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:str delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [alert show];
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                NSLog(@"%@",error);
            }];
        }
    }

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

//字典转化成json串
- (NSString*)dictionaryToJson:(NSDictionary *)dic

{
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
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
