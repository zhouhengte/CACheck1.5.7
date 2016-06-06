//
//  PetnameViewController.m
//  CACheck
//
//  Created by 刘子琨 on 16/1/28.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import "PetnameViewController.h"

@interface PetnameViewController ()

@property (strong,nonatomic) UITextField *petnameTextField;

@property (nonatomic , strong)NSDictionary *paramDic;

@end

@implementation PetnameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    [self setNavigationBar];

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
    label.text = @"昵称";
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.top.mas_equalTo(10);
        make.size.mas_equalTo(CGSizeMake(50, 24));
    }];
    
    self.petnameTextField = [[UITextField alloc]init];
    self.petnameTextField.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"petname"];
    self.petnameTextField.placeholder = @"请输入昵称";
    [view addSubview:self.petnameTextField];
    [self.petnameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(label.mas_right).mas_equalTo(10);
        make.top.mas_equalTo(10);
        make.right.mas_equalTo(-20);
        make.bottom.mas_equalTo(-10);
    }];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"昵称页面"];//("PageOne"为页面名称，可自定义)
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"昵称页面"];
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
    label.text = @"昵称";
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


-(void)backToPersonalInformationViewController
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)rightItemAction:(UIButton *)sender
{
    sender.alpha = 1;
    if ([self.petnameTextField.text length] > 14) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"昵称不能超过14位" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    if ([self.petnameTextField.text isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请输入昵称" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *roleid = [userDefaults objectForKey:@"roleid"];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
    
    
    NSString *catoken = [userDefaults stringForKey:@"CA-Token"];
    
    [manager.requestSerializer setValue:catoken forHTTPHeaderField:@"CA-Token"];
    
    NSString *url = [NSString stringWithFormat:@"%@/%@",kUrl,kInfoUrl];
    NSString *username = [userDefaults objectForKey:@"username"];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setValue:username forKey:@"username"];
    [dic setValue:[NSNumber numberWithInt:1] forKey:@"status"];
    [dic setValue:self.petnameTextField.text forKey:@"petname"];
    NSLog(@"%@",roleid);
    if ([userDefaults objectForKey:@"roleid"]) {
        [dic setValue:roleid forKey:@"roleid"];
    }
    //        NSDictionary *dic = @{@"username":username,@"roleid":roleid,@"status":[NSNumber numberWithInt:1],@"petname":self.nickName.text};
    NSString *dicStr = [self dictionaryToJson:dic];
    self.paramDic = @{@"json":dicStr};
    
    [manager POST:url parameters:self.paramDic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [userDefaults setValue:responseObject[@"username"]forKey:@"username"];
        if ([responseObject objectForKey:@"petname"]) {
            [userDefaults setValue:responseObject[@"petname"] forKey:@"petname"];
        }
        if ([responseObject objectForKey:@"gender"]) {
            [userDefaults setValue:responseObject[@"gender"] forKey:@"gender"];
        }
        //返回到指定控制器
        [self.navigationController popViewControllerAnimated:YES];
        //        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:0] animated:YES];

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
    
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
