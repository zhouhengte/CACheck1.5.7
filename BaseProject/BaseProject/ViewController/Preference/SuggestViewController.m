//
//  SuggestViewController.m
//  BaseProject
//
//  Created by 刘子琨 on 16/1/18.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import "SuggestViewController.h"

#define kMaxLength 1024

@interface SuggestViewController ()<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (strong,nonatomic) UILabel *placeholderLabel;

@end

@implementation SuggestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    //self.navigationItem.title = @"意见反馈";
    self.textView.delegate = self;
    
    [self setNavigationBar];
    
    
    self.placeholderLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 200, 30)];
    self.placeholderLabel.textColor = [UIColor colorWithRed:199/255.0 green:199/255.0 blue:199/255.0 alpha:1.0];
    self.placeholderLabel.text = @"请输入对我们应用的宝贵意见";
    self.placeholderLabel.font = [UIFont systemFontOfSize:15];
    [self.textView addSubview:self.placeholderLabel];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"意见反馈"];//("PageOne"为页面名称，可自定义)
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"意见反馈"];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.textView becomeFirstResponder];
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
    label.text = @"意见反馈";
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
    [leftButton addTarget:self action:@selector(backToPreferenceViewController) forControlEvents:UIControlEventTouchUpInside];
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



-(void)rightItemAction:(UIButton *)sender
{
    sender.alpha = 1;
    if ([self.textView.text isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入内容" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }   else{
        if (self.textView.text.length > kMaxLength) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"长度不要超过1024个字符" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }else{
            
            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
            manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            NSString *catoken = [userDefaults stringForKey:@"CA-Token"];
            [manager.requestSerializer setValue:catoken forHTTPHeaderField:@"CA-Token"];
            
            
            
            NSDate *now = [NSDate date];
            NSString *date = [self changeDateToDateString:now];
            
            NSDictionary *dic = @{@"res":self.textView.text,@"restime":date};
            
            //将字典转化成json串、
            NSString *dicStr = [self dictionaryToJson:dic];
            NSDictionary *paramDic = @{@"json":dicStr};
            
            NSString *url = [NSString stringWithFormat:@"%@/%@",kUrl,kMessageFeedbackUrl];
            
            [manager POST:url parameters:paramDic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                NSString * result = responseObject[@"Result"];
                if ([result integerValue] == 0) {
                    
                    //            self.alert = [[UIAlertView alloc] initWithTitle:nil message:@"提交成功" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
                    //定时器
                    [userDefaults setObject:@"提交成功" forKey:@"suggest"];
                    
                    //            [NSTimer scheduledTimerWithTimeInterval:1.0f
                    //                                             target:self
                    //                                           selector:@selector(dismissAlertView:)
                    //                                           userInfo:nil
                    //                                            repeats:NO];
                    //            [self.alert show];
                    [self.navigationController popViewControllerAnimated:YES];
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                 NSLog(@"%@",error);
            }];
        }
    }
}

//日期格式转换
- (NSString *) changeDateToDateString :(NSDate *) date {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    NSLocale *locale = [NSLocale currentLocale];
    NSString *dateFormat = [NSDateFormatter dateFormatFromTemplate:@"YYYY-MM-dd HH mm ss" options:0 locale:locale];
    [dateFormatter setDateFormat:dateFormat];
    [dateFormatter setLocale:locale];
    NSString *dateString = [dateFormatter stringFromDate:date];
    return dateString;
}


- (NSString*)dictionaryToJson:(NSDictionary *)dic

{
    
    NSError *parseError = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
}



//textView占位符
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text

{
    
    if (![text isEqualToString:@""])
    {
        _placeholderLabel.hidden = YES;
    }
    if ([text isEqualToString:@""] && range.location == 0 && range.length == 1)
    {
        _placeholderLabel.hidden = NO;
    }
    return YES;
    
}

-(void)backToPreferenceViewController
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
