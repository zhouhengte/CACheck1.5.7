//
//  MessageViewController.m
//  BaseProject
//
//  Created by 刘子琨 on 16/1/15.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import "MessageViewController.h"
#import "MessageTableViewCell.h"
#import "RecordDetailViewController.h"

@interface MessageViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic , copy)NSString *url;
@property (nonatomic , strong)UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic , strong) NSMutableArray *messageArray;
@end

@implementation MessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //去除上方留白
    self.automaticallyAdjustsScrollViewInsets=NO;
    
    
    //重新设置导航栏，隐藏原生导航栏，手动绘制新的导航栏，使右滑手势跳转时能让导航栏跟着变化
    [self setNavigationBar];

    self.view.backgroundColor = UIColorFromRGB(0xf0f0f0);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];

    //[self.tableView registerClass:[MessageTableViewCell class] forCellReuseIdentifier:@"messagecell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"MessageTableViewCell" bundle:nil] forCellReuseIdentifier:@"messagecell"];
    
    //找到documents文件所在的路径
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    //获取第一个文件夹的路径
    NSString *filePath = [path objectAtIndex:0];
    //把testPlist文件加入
    NSString *plistPath = [filePath stringByAppendingPathComponent:@"duedate.plist"];
    self.messageArray = [NSMutableArray arrayWithCapacity:1];
    
    NSArray * arrayFromfile = [NSArray arrayWithContentsOfFile:plistPath];
    //            [array setArray:arrayFromfile];
    [self.messageArray addObjectsFromArray:arrayFromfile];
    NSMutableArray *mutableArray = [NSMutableArray arrayWithArray:self.messageArray];
    NSDate *now = [NSDate date];
    //如果还没到该消息发送的时间，则隐藏该消息
    for (NSDictionary *innerDic in mutableArray) {
        NSDate *firedate = innerDic[@"firedate"];
        if ([firedate isEqualToDate:[firedate laterDate:now]]) {
            [self.messageArray removeObject:innerDic];
        }
    }
    [self.tableView reloadData];
    
    if (self.messageArray.count == 0) {
        [self.tableView removeFromSuperview];
        UIImageView *imageView = [[UIImageView alloc] init];
        //    UIImageView *imageView = [[UIImageView alloc] init];
        
        //    imageView.backgroundColor= [UIColor redColor];
        
        imageView.image = [UIImage imageNamed:@"消息空"];
        [self.view addSubview:imageView];
        
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view);
            //        make.centerY.equalTo(self.view);
            //        make.top.equalTo(imageViewBig1).with.offset(37/568.0*kScreenHeight);
            make.top.equalTo(self.view).with.offset(0.4*kScreenHeight);
            make.size.mas_equalTo(CGSizeMake(65, 60));
        }];
        
        UILabel *label = [[UILabel alloc]init];
        [self.view addSubview:label];
        label.textColor = UIColorFromRGB(0xc3c3c3);
        label.text = @"暂无内容";
        label.font = [UIFont systemFontOfSize:17];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(0);
            make.top.mas_equalTo(imageView.mas_bottom).mas_equalTo(10);
        }];

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
    label.text = @"消息";
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

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.messageArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"messagecell"];
    cell.messageDic = self.messageArray[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    RecordDetailViewController *recordDetailVC = [[RecordDetailViewController alloc] init];
    recordDetailVC.judgeStr = self.messageArray[indexPath.row][@"barcode"];
    recordDetailVC.sugueStr = @"list";
    recordDetailVC.onlyStr = @"消息";
    [self.navigationController pushViewController:recordDetailVC animated:YES];
}



-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 142;
}

//-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return 12;
//}
//
//-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
//{
//    return 1;
//}




-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"消息页面"];//("PageOne"为页面名称，可自定义)
    
//    self.navigationItem.title = @"消息";
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
    [MobClick endLogPageView:@"消息页面"];
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
