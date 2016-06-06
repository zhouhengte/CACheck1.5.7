//
//  PersonalInformationViewController.m
//  CACheck
//
//  Created by 刘子琨 on 16/1/28.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import "PersonalInformationViewController.h"
#import "PetnameViewController.h"
#import "GenderViewController.h"
#import "PasswordViewController.h"
#import "MainViewController.h"
#import <UMSocial.h>

@interface PersonalInformationViewController () <UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong,nonatomic) NSString *thirdType;
@property (assign,nonatomic) BOOL isThirdLogin;

@end

@implementation PersonalInformationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    //重新设置导航栏，隐藏原生导航栏，手动绘制新的导航栏，使右滑手势跳转时能让导航栏跟着变化
    [self setNavigationBar];
    
    self.thirdType = [[NSUserDefaults standardUserDefaults] objectForKey:@"thirdtype"];
    if (self.thirdType){
        self.isThirdLogin = YES;
    }else{
        self.isThirdLogin = NO;
    }
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"个人账号页面"];//("PageOne"为页面名称，可自定义)
    [self.tableView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"个人账号页面"];
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
    label.text = @"个人账号";
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


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        if (self.isThirdLogin) {
            return 4;
        }
        return 3;
    }
    if (section == 1) {
        return 1;
    }else{
        return 1;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        cell.textLabel.text = @"账号";
        cell.detailTextLabel.text = [[NSUserDefaults standardUserDefaults] stringForKey:@"username"];
        return cell;
    }
    if (indexPath.section == 2) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell3"];
        cell.textLabel.text = @"退出登录";
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        return cell;
    }
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell2"];
    if (indexPath.section == 1) {
        cell.textLabel.text = @"修改密码";
        cell.detailTextLabel.text = @"";
        return cell;
    }
    if (indexPath.row == 1) {
        cell.textLabel.text = @"昵称";
        if ([[NSUserDefaults standardUserDefaults] stringForKey:@"petname"] == nil || [[[NSUserDefaults standardUserDefaults] stringForKey:@"petname"] isEqualToString:@""]) {
            cell.detailTextLabel.text = @"未设置";
        }else
        {
            cell.detailTextLabel.text = [[NSUserDefaults standardUserDefaults] stringForKey:@"petname"];
        }
    }
    if (indexPath.row == 2) {
        cell.textLabel.text = @"性别";
        cell.detailTextLabel.text = @"未设置";
        if ([[[NSUserDefaults standardUserDefaults] stringForKey:@"gender"] intValue] == 0) {
            cell.detailTextLabel.text = @"男";
        }
        if ([[[NSUserDefaults standardUserDefaults] stringForKey:@"gender"] intValue] == 1) {
            cell.detailTextLabel.text = @"女";
        }
    }
    if (indexPath.row == 3) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        cell.textLabel.text = @"其他平台绑定";
        if ([self.thirdType isEqualToString:@"0"]) {
            cell.detailTextLabel.text = @"QQ账号";
        }else if([self.thirdType isEqualToString:@"1"]){
            cell.detailTextLabel.text = @"新浪微博账号";
        }
        
        return cell;

    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //当手指离开某行时，就让某行的选中状态消失
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0 && indexPath.row == 1) {
        PetnameViewController *petnameVC = [[PetnameViewController alloc]init];
        [self.navigationController pushViewController:petnameVC animated:YES];
    }
    if (indexPath.section == 0 && indexPath.row == 2) {
        GenderViewController *genderVC = [[GenderViewController alloc]init];
        [self.navigationController pushViewController:genderVC animated:YES];
    }
    if (indexPath.section == 1) {
        PasswordViewController *passwordVC = [[PasswordViewController alloc]init];
        [self.navigationController pushViewController:passwordVC animated:YES];
    }
    if (indexPath.section == 2) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确定要退出登录吗?" delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
        
        [alert show];
    }

}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 15;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 3;
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        ;
    }else{
        NSUserDefaults *userDefatluts = [NSUserDefaults standardUserDefaults];
//        NSDictionary *dictionary = [userDefatluts dictionaryRepresentation];
//        for(NSString* key in [dictionary allKeys]){
//            [userDefatluts removeObjectForKey:key];
//            [userDefatluts synchronize];
//        }
        
        [userDefatluts removeObjectForKey:@"username"];
        [userDefatluts removeObjectForKey:@"userid"];
        [userDefatluts removeObjectForKey:@"petname"];
        [userDefatluts removeObjectForKey:@"CA-Token"];
        [userDefatluts removeObjectForKey:@"roleid"];
        [userDefatluts removeObjectForKey:@"password"];
        [userDefatluts removeObjectForKey:@"gender"];
        [userDefatluts synchronize];
        
        
        [[NSUserDefaults standardUserDefaults] setObject:@"退出登录" forKey:@"logout"];
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"login"];
        //取消第三方授权
        [[UMSocialDataService defaultDataService] requestUnOauthWithType:UMShareToSina  completion:^(UMSocialResponseEntity *response){
            NSLog(@"sina response is %@",response);
        }];
        [[UMSocialDataService defaultDataService] requestUnOauthWithType:UMShareToQQ completion:^(UMSocialResponseEntity *response) {
            NSLog(@"qq response is %@",response);
        }];
        
        MainViewController *mainVC =[self.storyboard instantiateViewControllerWithIdentifier:@"mainViewController"];
        mainVC.from = @"退出登录";
        [self.navigationController pushViewController:mainVC animated:YES];
//        //将mainVC设为导航栏唯一页面，使其无法右滑返回
//        [self.navigationController setViewControllers:@[mainVC]];
        
        
        
    }
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
