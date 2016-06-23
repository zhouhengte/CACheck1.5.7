//
//  PreferenceViewController.m
//  BaseProject
//
//  Created by 刘子琨 on 16/1/15.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import "PreferenceViewController.h"
#import "LoginViewController.h"
#import "PersonalInformationViewController.h"
#import "FavoriteGoodsViewController.h"

#define kScreenWidthScale (self.view.bounds.size.width/375.0)

@interface PreferenceViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong ,nonatomic) UISwitch *notificationSwitch;
@property (nonatomic , strong) UIButton *btn;

@property (nonatomic , copy)NSString *stateStr;

@end

@implementation PreferenceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView.separatorColor = UIColorFromRGB(0xe8e8e5);

    
    //重新设置导航栏，隐藏原生导航栏，手动绘制新的导航栏，使右滑手势跳转时能让导航栏跟着变化
    [self setNavigationBar];
    
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
    label.text = @"设置";
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
    [MobClick beginLogPageView:@"设置页面"];//("PageOne"为页面名称，可自定义)
    
    [self.tableView reloadData];
    
//    self.navigationItem.title = @"设置";
//    
//    [self.navigationController setNavigationBarHidden:NO];
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
//    
//    //由于改写了leftBarButtonItem,所以需要重新定义右滑返回手势
//    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;

    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"设置页面"];
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        cell.textLabel.text = @"个人账号";
        cell.textLabel.textColor = [UIColor colorWithRed:50/255.0 green:50/255.0 blue:50/255.0 alpha:1];
        self.valueStr = [[NSUserDefaults standardUserDefaults] stringForKey:@"username"];
        
        if (self.valueStr == nil) {
            cell.detailTextLabel.text = @"未登录";
        }else{
            //
            cell.detailTextLabel.text = self.valueStr;
        }
        
        self.stateStr = cell.detailTextLabel.text;
        //cell.detailTextLabel.text = @"未登录";
        return cell;
    }
    if (indexPath.section == 1) {
        //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"favorCell"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.text = @"";
        cell.detailTextLabel.text = @"";
        UILabel *titleLabel = [[UILabel alloc]init];
        titleLabel.text = @"感兴趣的进口商品";
        titleLabel.textColor = [UIColor colorWithRed:50/255.0 green:50/255.0 blue:50/255.0 alpha:1];;
        titleLabel.font = [UIFont systemFontOfSize:15];
        [cell addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.top.mas_equalTo(13);
        }];
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSArray *favorArray = [userDefaults objectForKey:@"favorArray"];
        if (favorArray.count == 0) {
            UIImageView *moreImageView = [[UIImageView alloc]init];
            moreImageView.image = [UIImage imageNamed:@"设置－感兴趣的进口商品－更多"];
            [cell addSubview:moreImageView];
            [moreImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(15);
                make.top.mas_equalTo(titleLabel.mas_bottom).mas_equalTo(17);
                make.size.mas_equalTo(CGSizeMake(50, 50));
            }];
            UILabel *moreLabel = [[UILabel alloc]init];
            moreLabel.text = @"更多";
            moreLabel.textColor = UIColorFromRGB(0xa0a0a0);
            moreLabel.font = [UIFont systemFontOfSize:11];
            [cell addSubview:moreLabel];
            [moreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.mas_equalTo(moreImageView);
                make.top.mas_equalTo(moreImageView.mas_bottom).mas_equalTo(10);
            }];
        }
        for (int i = 0; i<(favorArray.count>3?3:favorArray.count); i++) {
            UIImageView *imageView = [[UIImageView alloc]init];
            imageView.image = [UIImage imageNamed:favorArray[i]];
            [cell addSubview:imageView];
            [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(15+i*(50+40*kScreenWidthScale));
                make.top.mas_equalTo(titleLabel.mas_bottom).mas_equalTo(17);
                make.size.mas_equalTo(CGSizeMake(50, 50));
            }];
            UILabel *label = [[UILabel alloc]init];
            label.text = favorArray[i];
            label.textColor = UIColorFromRGB(0xa0a0a0);
            label.font = [UIFont systemFontOfSize:11];
            [cell addSubview:label];
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.mas_equalTo(imageView);
                make.top.mas_equalTo(imageView.mas_bottom).mas_equalTo(10);
            }];
            if (i == 2 && favorArray.count > 3) {
                UIImageView *moreImageView = [[UIImageView alloc]init];
                moreImageView.image = [UIImage imageNamed:@"设置－感兴趣的进口商品－更多"];
                [cell addSubview:moreImageView];
                [moreImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(15+(i+1)*(50+40*kScreenWidthScale));
                    make.top.mas_equalTo(titleLabel.mas_bottom).mas_equalTo(17);
                    make.size.mas_equalTo(CGSizeMake(50, 50));
                }];
                UILabel *moreLabel = [[UILabel alloc]init];
                moreLabel.text = @"更多";
                moreLabel.textColor = UIColorFromRGB(0xa0a0a0);
                moreLabel.font = [UIFont systemFontOfSize:11];
                [cell addSubview:moreLabel];
                [moreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerX.mas_equalTo(moreImageView);
                    make.top.mas_equalTo(moreImageView.mas_bottom).mas_equalTo(10);
                }];
            }
        }
        return cell;
    }
    if (indexPath.section == 2) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell2"];
        cell.textLabel.text = @"消息通知";
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        cell.textLabel.textColor = [UIColor colorWithRed:50/255.0 green:50/255.0 blue:50/255.0 alpha:1];
        _notificationSwitch = [[UISwitch alloc]initWithFrame:CGRectZero];
        [_notificationSwitch addTarget:self action:@selector(clickNotificationSwitch) forControlEvents:UIControlEventValueChanged];
        cell.accessoryView = _notificationSwitch;
        _notificationSwitch.on = YES;
        return cell;
    }else{
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        cell.textLabel.text = @"关于我们";
        cell.textLabel.textColor = [UIColor colorWithRed:50/255.0 green:50/255.0 blue:50/255.0 alpha:1];
        cell.detailTextLabel.text = @"";
        return cell;
    }


}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 2) {
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, kScreenWidth-20, 10)];
        label.text = @"    如果关闭，收到新消息时将不再通知你";
        label.textColor = UIColorFromRGB(0x909090);
        label.font = [UIFont systemFontOfSize:13];
        return label;
    }
    return nil;
}

//-(NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
//{
//    if (section == 1) {
//        return @"如果关闭，收到新消息时将不再通知你";
//    }
//    return nil;
//}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //当手指离开某行时，就让某行的选中状态消失
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        if ([self.stateStr isEqualToString:@"未登录"]) {
            //[self.navigationController pushViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"loginViewController"] animated:YES];
            [self performSegueWithIdentifier:@"loginSegue" sender:nil];
        }else{
            PersonalInformationViewController *personalInfoVC = (PersonalInformationViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"personalInformationViewController"];
            [self.navigationController pushViewController:personalInfoVC animated:YES];
        }
    }
    if (indexPath.section == 1) {
        FavoriteGoodsViewController *favorVC = [[FavoriteGoodsViewController alloc]init];
        [self.navigationController pushViewController:favorVC animated:YES];
    }
    if (indexPath.section == 3) {
        [self.navigationController pushViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"aboutUsViewController"] animated:YES];
    }
}


-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 2) {
        return 30;
    }
    return 3;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        return 140;
    }else{
        return 44;
    }
}

//-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
//    if (section == 1) {
//        UILabel *label = [[UILabel alloc]init];
//        label.font = [UIFont systemFontOfSize:17];
//        label.text = @"ddsdfsadfsadf";
//        return label;
//    }
//    return nil;
//}

-(void)clickNotificationSwitch
{
    if (self.notificationSwitch.on){
        NSLog(@"如果打开， 则接受消息推送");
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setBool:YES forKey:@"switchStatus"];
    }else{
        NSLog(@"关闭则不接受");
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setBool:NO forKey:@"switchStatus"];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)backToMainViewController:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
    
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
