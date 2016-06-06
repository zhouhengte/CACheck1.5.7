//
//  RegistViewController.m
//  BaseProject
//
//  Created by 刘子琨 on 16/1/18.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import "RegistViewController.h"
#import "NSString+MD5.h"
#import "MainViewController.h"

@interface RegistViewController ()
@property (strong, nonatomic)  UIButton *registButton;
//发送验证码
@property (strong, nonatomic)  UIButton *verificationButton;
@property (strong, nonatomic)  UITextField *phoneNumTextField;
@property (strong, nonatomic)  UITextField *verificationTextField;
@property (strong, nonatomic)  UITextField *passwordTextField;

@end

@implementation RegistViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    

    

    
    [self setNavigationBar];
    
    [self setInterface];
    
}

-(void)valueChanged:(UITextField *)sender
{
    //NSLog(@"text:%@",sender.text);
    
    if (![self isMobileNumber:sender.text]) {
        self.registButton.userInteractionEnabled = NO;
        [self.registButton setTitleColor:UIColorFromRGB(0x7e7e7e) forState:UIControlStateNormal];
        self.registButton.backgroundColor = UIColorFromRGB(0xbebebe);
        
        self.verificationButton.userInteractionEnabled = NO;
        [self.verificationButton setTitleColor:UIColorFromRGB(0x7e7e7e) forState:UIControlStateNormal];
        self.verificationButton.layer.borderColor = UIColorFromRGB(0x7e7e7e).CGColor;
    }else{
        self.registButton.userInteractionEnabled = YES;
        [self.registButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.registButton.backgroundColor = [UIColor colorWithRed:52/255.0 green:181/255.0 blue:254/255.0 alpha:1.0];
        
        self.verificationButton.userInteractionEnabled = YES;
        [self.verificationButton setTitleColor:[UIColor colorWithRed:52/255.0 green:181/255.0 blue:254/255.0 alpha:1.0] forState:UIControlStateNormal];
        self.verificationButton.layer.borderColor = [UIColor colorWithRed:52/255.0 green:181/255.0 blue:254/255.0 alpha:1.0].CGColor;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"注册页面"];//("PageOne"为页面名称，可自定义)
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"注册页面"];
}

//点击空白处，隐藏键盘
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.phoneNumTextField resignFirstResponder];
    [self.verificationTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
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
    label.text = @"用户注册";
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
    [button addTarget:self action:@selector(backToLoginViewController) forControlEvents:UIControlEventTouchUpInside];
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

-(void)setInterface
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
    _phoneNumTextField.font = [UIFont systemFontOfSize:14];
    [self.phoneNumTextField addTarget:self  action:@selector(valueChanged:)  forControlEvents:UIControlEventAllEditingEvents];
    [self.view addSubview:_phoneNumTextField];
    [_phoneNumTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(95);
        make.right.mas_equalTo(-23);
        make.height.mas_equalTo(25);
        make.centerY.mas_equalTo(phoneNumLabel);
    }];
    UIView *firstLineView = [[UIView alloc]init];
    firstLineView.backgroundColor = UIColorFromRGB(0xd3d3d3);
    [self.view addSubview:firstLineView];
    [firstLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(phoneNumLabel.mas_bottom).mas_equalTo(20);
        make.left.mas_equalTo(23);
        make.right.mas_equalTo(-23);
        make.height.mas_equalTo(1);
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
    
    UILabel *passwordLabel = [[UILabel alloc]init];
    passwordLabel.text = @"密  码";
    [self.view addSubview:passwordLabel];
    [passwordLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(secondLineView).mas_equalTo(20);
        make.left.mas_equalTo(23);
    }];
    self.passwordTextField = [[UITextField alloc]init];
    _passwordTextField.placeholder = @"请输入6位以上密码";
    _passwordTextField.secureTextEntry = YES;
    _passwordTextField.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:_passwordTextField];
    [_passwordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(passwordLabel);
        make.left.mas_equalTo(95);
        make.height.mas_equalTo(25);
        make.right.mas_equalTo(-23);
    }];
    UIView *thirdLineView = [[UIView alloc]init];
    thirdLineView.backgroundColor = UIColorFromRGB(0xd3d3d3);
    [self.view addSubview:thirdLineView];
    [thirdLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(23);
        make.right.mas_equalTo(-23);
        make.top.mas_equalTo(passwordLabel.mas_bottom).mas_equalTo(20);
        make.height.mas_equalTo(1);
    }];
    
    self.registButton = [[UIButton alloc]init];
    [_registButton addTarget:self action:@selector(registClick:) forControlEvents:UIControlEventTouchUpInside];
    self.registButton.userInteractionEnabled = NO;
    [self.registButton setTitleColor:UIColorFromRGB(0x7e7e7e) forState:UIControlStateNormal];
    self.registButton.backgroundColor = UIColorFromRGB(0xbebebe);
    [_registButton setTitle:@"确定" forState:UIControlStateNormal];
    [_registButton.layer setCornerRadius:6.0]; //设置矩圆角半径
    [self.view addSubview:_registButton];
    [_registButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(23);
        make.right.mas_equalTo(-23);
        make.height.mas_equalTo(40);
        make.top.mas_equalTo(thirdLineView).mas_equalTo(30);
    }];

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
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:str delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
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


//注册
- (IBAction)registClick:(id)sender {
    NSLog(@"您点击了注册btn");

    if (self.passwordTextField.text.length < 6) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入6位以上密码" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    //    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
    NSString *url = [NSString stringWithFormat:@"%@/%@",kUrl,kRegistUrl];
    
    
    //密码进行md5 加密
    NSString *passwordMd5 = [self.passwordTextField.text MD5];
    
    NSDictionary *dic = @{@"username":self.phoneNumTextField.text,@"userpassword":passwordMd5 ,@"checkcode":self.verificationTextField.text,@"status":[NSNumber numberWithInt:1],@"roleid":[NSNumber numberWithInt:1]};
    NSString *jsonStr = [self dictionaryToJson:dic];
    //    NSLog(@"%@",jsonStr);
    NSDictionary *paramDic = @{@"json":jsonStr};
    
    
    [manager POST:url parameters:paramDic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"请求成功");
        NSLog(@"%@",responseObject);
        NSString *str = responseObject[@"FailInfo"];
        if ([responseObject[@"Result"] integerValue] == 0) {
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"注册成功" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//            [alert show];
//            NSLog(@"注册成功!");
            //存储用户信息
            [self saveNSUserDefaultsWithResponseObject:responseObject andTask:task];
            NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
            [userDefault setObject:responseObject[@"username"] forKey:@"username"];
            [userDefault setObject:responseObject[@"roleid"] forKey:@"roleid"];
            MainViewController *mainVC =[self.storyboard instantiateViewControllerWithIdentifier:@"mainViewController"];
            mainVC.from = @"注册";
            [self.navigationController pushViewController:mainVC animated:YES];
            
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults setObject:@"注册成功" forKey:@"regist"];
            
            
            
        }else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:str delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求失败--------%@",error);
    }];
    
    
//    [manager POST:url parameters:paramDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSLog(@"请求成功");
//        NSLog(@"%@",responseObject);
//        NSString *str = responseObject[@"FailInfo"];
//        if ([responseObject[@"Result"] integerValue]==0) {
//            //            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"注册成功" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//            //            [alert show];
//            //            NSLog(@"注册成功!");
//            [self saveNSUserDefaultsWithResponseObject:responseObject andOperation:operation];
//            NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
//            [userDefault setObject:responseObject[@"username"] forKey:@"username"];
//            [userDefault setObject:responseObject[@"roleid"] forKey:@"roleid"];
//            ViewController *VC =[[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"storyBoardID"];
//            [self.navigationController pushViewController:VC animated:YES];
//            //
//            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//            [userDefaults setObject:@"注册成功" forKey:@"regist"];
//            
//            
//            
//        }else{
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:str delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//            [alert show];
//        }
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"请求失败--------%@",error);
//    }];

}


#pragma mark - 保存数据到NSUserDefaults
-(void)saveNSUserDefaultsWithResponseObject:(id)responseObject andTask:(NSURLSessionTask *)task
{
    NSString *username = responseObject[@"username"];
    NSString *userid = responseObject[@"userid"];
    //NSString *caToken = operation.response.allHeaderFields[@"CA-Token"];
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;
    NSString *caToken = httpResponse.allHeaderFields[@"CA-Token"];
    NSLog(@"caToken = %@",caToken);
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    
    [userDefaults setObject:username forKey:@"username"];
    [userDefaults setObject:userid forKey:@"userid"];
    [userDefaults setObject:self.passwordTextField.text forKey:@"password"];
    [userDefaults setObject:caToken forKey:@"CA-Token"];
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


-(void)backToLoginViewController
{
    [self.navigationController popViewControllerAnimated:YES];
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
