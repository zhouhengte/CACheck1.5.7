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
#import "UIAlertView+Blocks.h"

@interface MessageViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic , copy)NSString *url;
@property (nonatomic , strong)UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic , strong) NSMutableArray *messageArray;
@property (nonatomic , strong) NSMutableArray *deleteArray;
@property (nonatomic , strong) NSMutableArray *deleteIndexPathArray;
@property (nonatomic , strong) UIButton *rightButton;
@property (nonatomic , strong) UIButton *cancelButton;
@property (nonatomic , strong) UIView *deleteView;
@property (nonatomic , assign) BOOL allSelected;

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
    self.tableView.allowsMultipleSelectionDuringEditing = YES;

    //[self.tableView registerClass:[MessageTableViewCell class] forCellReuseIdentifier:@"messagecell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"MessageTableViewCell" bundle:nil] forCellReuseIdentifier:@"messagecell"];
    
    self.deleteArray = [NSMutableArray array];
    self.deleteIndexPathArray = [NSMutableArray array];
    self.allSelected = NO;
    
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
    
    //根据发送时间排序
    NSArray *sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"firedate" ascending:NO]];
    [self.messageArray sortUsingDescriptors:sortDescriptors];
    //NSLog(@"messageArray:%@",_messageArray);
    
    NSMutableArray *mutableArray = [NSMutableArray arrayWithArray:self.messageArray];
    NSDate *now = [NSDate date];
    
    //如果还没到该消息发送的时间，则隐藏该消息
    for (NSDictionary *innerDic in mutableArray) {
        NSDate *firedate = innerDic[@"firedate"];
        if ([firedate isEqualToDate:[firedate laterDate:now]]) {
            [self.messageArray removeObject:innerDic];
        }
    }
    
    
    //如果商品重复，隐藏一条，现在不需要隐藏
//    NSMutableArray *listArray = [NSMutableArray array];
//    for (NSDictionary *innerDic in _messageArray) {
//        if (![listArray containsObject:[innerDic objectForKey:@"barcode"]]) {
//            [listArray addObject:[innerDic objectForKey:@"barcode"]];
//        }else{
//            [_messageArray removeObject:innerDic];
//        }
//    }
    
    
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
    
    self.rightButton = [[UIButton alloc]init];
    [_rightButton setTitle:@"编辑" forState:UIControlStateNormal];
    [_rightButton addTarget:self action:@selector(rightItemAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_rightButton];
    [_rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.top.mas_equalTo(20);
        make.size.mas_equalTo(CGSizeMake(50, 44));
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

-(void)rightItemAction:(UIButton *)sender
{
    // 先修改表视图的状态
    [self.tableView setEditing:!self.tableView.isEditing animated:YES];
    // 判断表视图的状态,决定导航按钮上显示的文字
    if (self.tableView.isEditing) {
        
//        for (int row=0; row<self.messageArray.count; row++) {
//            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
//            MessageTableViewCell * cell = [self.tableView cellForRowAtIndexPath:indexPath];
//            UIImageView *imageView = cell.subviews[2].subviews[0];
//            imageView.image = [UIImage imageNamed:@"未勾选"];
//        }
        
        
        
        [sender setTitle:@"取消" forState:UIControlStateNormal];
        
        self.deleteView = [[UIView alloc]init];
        [self.view addSubview:_deleteView];
        [_deleteView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_equalTo(0);
            make.height.mas_equalTo(49);
        }];
        
        UIButton *allSelectedButton = [[UIButton alloc]init];
        allSelectedButton.backgroundColor = [UIColor whiteColor];
        [allSelectedButton setTitle:@"全选" forState:UIControlStateNormal];
        allSelectedButton.titleLabel.font = [UIFont systemFontOfSize:14];
        allSelectedButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, kScreenWidth/2-85);
        [allSelectedButton setImage:[UIImage imageNamed:@"未勾选"] forState:UIControlStateNormal];
        [allSelectedButton setImageEdgeInsets:UIEdgeInsetsMake(13, 13, 13, kScreenWidth/2-23-13)];
        [allSelectedButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [allSelectedButton addTarget:self action:@selector(allSelectedClick:) forControlEvents:UIControlEventTouchUpInside];
        [_deleteView addSubview:allSelectedButton];
        [allSelectedButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.top.mas_equalTo(0);
            make.width.mas_equalTo(kScreenWidth/2);
        }];
        
        UIButton *deleteButton = [[UIButton alloc]init];
        deleteButton.backgroundColor = [UIColor redColor];
        [deleteButton setTitle:@"删除" forState:UIControlStateNormal];
        deleteButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [deleteButton setImage:[UIImage imageNamed:@"删除icon"] forState:UIControlStateNormal];
        [deleteButton setImageEdgeInsets:UIEdgeInsetsMake(17.25, (kScreenWidth/2-12.5)/2-15, 17.25, (kScreenWidth/2-12.5)/2+15)];
        [deleteButton addTarget:self action:@selector(deleteClick:) forControlEvents:UIControlEventTouchUpInside];
        [_deleteView addSubview:deleteButton];
        [deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.bottom.top.mas_equalTo(0);
            make.width.mas_equalTo(kScreenWidth/2);
        }];
        
//        self.cancelButton = [[UIButton alloc]init];
//        _cancelButton.backgroundColor = [UIColor colorWithRed:52/255.0 green:181/255.0 blue:254/255.0 alpha:1.0];
//        [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
//        [_cancelButton addTarget:self action:@selector(cancelClick:) forControlEvents:UIControlEventTouchUpInside];
//        [self.view addSubview:_cancelButton];
//        [_cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.mas_equalTo(5);
//            make.top.mas_equalTo(20);
//            make.size.mas_equalTo(CGSizeMake(80, 44));
//        }];
        //[self.tableView reloadData];
    }else{
        [sender setTitle:@"编辑" forState:UIControlStateNormal];
        [_deleteIndexPathArray removeAllObjects];
        [_deleteArray removeAllObjects];
        [_deleteView removeFromSuperview];
        _deleteView = nil;
//        [[[UIAlertView alloc]initWithTitle:nil message:@"确认删除" cancelButtonItem:[RIButtonItem itemWithLabel:@"取消" action:^{
//            [self cancelClick:_cancelButton];
//        }] otherButtonItems:[RIButtonItem itemWithLabel:@"确定" action:^{
//            [sender setTitle:@"编辑" forState:UIControlStateNormal];
//            [self.messageArray removeObjectsInArray:_deleteArray];
//            [self.tableView deleteRowsAtIndexPaths:_deleteIndexPathArray withRowAnimation:UITableViewRowAnimationLeft];
//            [_deleteIndexPathArray removeAllObjects];
//            [_cancelButton removeFromSuperview];
//            
//            //找到documents文件所在的路径
//            NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//            //获取第一个文件夹的路径
//            NSString *filePath = [path objectAtIndex:0];
//            //把testPlist文件加入
//            NSString *plistPath = [filePath stringByAppendingPathComponent:@"duedate.plist"];
//            NSMutableArray *array = [NSMutableArray arrayWithCapacity:1];
//            
//            NSArray * arrayFromfile = [NSArray arrayWithContentsOfFile:plistPath];
//            //            [array setArray:arrayFromfile];
//            [array addObjectsFromArray:arrayFromfile];
//            [array removeObjectsInArray:_deleteArray];
//            //将纪录存入本地
//            [array writeToFile:plistPath atomically:YES];
//
//        }], nil]show];
        
        
    }
    //[self.tableView reloadData];
}

-(void)tapBack:(UIButton *)button
{
    button.alpha = 0.5;
}
-(void)tapUp:(UIButton *)button
{
    button.alpha = 1;
}

-(void)deleteClick:(UIButton *)sender
{
    [[[UIAlertView alloc]initWithTitle:nil message:@"确认删除" cancelButtonItem:[RIButtonItem itemWithLabel:@"取消" action:^{
        [self cancelClick];
    }] otherButtonItems:[RIButtonItem itemWithLabel:@"确定" action:^{
        [_rightButton setTitle:@"编辑" forState:UIControlStateNormal];
        [self.messageArray removeObjectsInArray:_deleteArray];
        [self.tableView deleteRowsAtIndexPaths:_deleteIndexPathArray withRowAnimation:UITableViewRowAnimationLeft];
        [_deleteIndexPathArray removeAllObjects];
        [self.tableView setEditing:NO animated:YES];

        //找到documents文件所在的路径
        NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        //获取第一个文件夹的路径
        NSString *filePath = [path objectAtIndex:0];
        //把testPlist文件加入
        NSString *plistPath = [filePath stringByAppendingPathComponent:@"duedate.plist"];
        NSMutableArray *array = [NSMutableArray arrayWithCapacity:1];

        NSArray * arrayFromfile = [NSArray arrayWithContentsOfFile:plistPath];
        //            [array setArray:arrayFromfile];
        [array addObjectsFromArray:arrayFromfile];
        [array removeObjectsInArray:_deleteArray];
        //将纪录存入本地
        [array writeToFile:plistPath atomically:YES];
        
        [_deleteArray removeAllObjects];
        [self cancelClick];

    }], nil]show];
}

-(void)allSelectedClick:(UIButton *)sender
{
    _allSelected = !_allSelected;
    if (_allSelected) {
        [sender setImage:[UIImage imageNamed:@"已勾选"] forState:UIControlStateNormal];
        for (int row=0; row<self.messageArray.count; row++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
            [_tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
            MessageTableViewCell * cell = [self.tableView cellForRowAtIndexPath:indexPath];
            UIImageView *imageView = cell.subviews[3].subviews[0];
            imageView.image = [UIImage imageNamed:@"已勾选"];
            [_deleteArray addObject:[self.messageArray objectAtIndex:indexPath.row]];
            [_deleteIndexPathArray addObject:indexPath];
        }
    }else{
        [sender setImage:[UIImage imageNamed:@"未勾选"] forState:UIControlStateNormal];
        for (int row=0; row<self.messageArray.count; row++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
            [_tableView deselectRowAtIndexPath:indexPath animated:NO];
//            MessageTableViewCell * cell = [self.tableView cellForRowAtIndexPath:indexPath];
//            UIImageView *imageView = cell.subviews[2].subviews[0];
//            imageView.image = [UIImage imageNamed:@"未勾选"];

        }
        [_deleteArray removeAllObjects];
        [_deleteIndexPathArray removeAllObjects];
    }

}

-(void)cancelClick
{
    [self.tableView setEditing:NO animated:YES];
    [_rightButton setTitle:@"编辑" forState:UIControlStateNormal];
    [_deleteView removeFromSuperview];
    _deleteView = nil;
    [_deleteIndexPathArray removeAllObjects];
    [_deleteArray removeAllObjects];
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
//    if ([tableView isEditing]) {
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
//    cell.editingAccessoryType = UITableViewCellAccessoryCheckmark;
//    }else{
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    if (![self.tableView isEditing]) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        RecordDetailViewController *recordDetailVC = [mainStoryBoard instantiateViewControllerWithIdentifier:@"recordDetailViewController"];
        recordDetailVC.judgeStr = self.messageArray[indexPath.row][@"barcode"];
        recordDetailVC.sugueStr = @"list";
        recordDetailVC.onlyStr = @"消息";
        [self.navigationController pushViewController:recordDetailVC animated:YES];
    }else{
        //获取选取图
        MessageTableViewCell * cell = [self.tableView cellForRowAtIndexPath:indexPath];
        UIImageView *imageView = cell.subviews[3].subviews[0];
        imageView.image = [UIImage imageNamed:@"已勾选"];
        
        [_deleteArray addObject:[self.messageArray objectAtIndex:indexPath.row]];
        [_deleteIndexPathArray addObject:indexPath];
    }
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.tableView isEditing]) {
        [_deleteArray removeObject:[self.messageArray objectAtIndex:indexPath.row]];
        [_deleteIndexPathArray removeObject:indexPath];
//        MessageTableViewCell * cell = [self.tableView cellForRowAtIndexPath:indexPath];
//        UIImageView *imageView = cell.subviews[2].subviews[0];
//        imageView.image = [UIImage imageNamed:@"未勾选"];

    }
}

#pragma mark - 表格的编辑模式:两问一答
//问1:该行是否可编辑
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;

}

//问2:该行的编辑样式
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    MessageTableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
//    NSLog(@"subView:%@",cell.subviews);
//    NSLog(@"2subView:%@",cell.subviews[3].subviews);
//        return UITableViewCellEditingStyleDelete;
//
//        return UITableViewCellEditingStyleInsert;

        return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;

}

//答1:点击了按钮后如何响应
//不管点击的是绿色加,还是点两下后的红色delegate
//都会执行该方法
//参数:editingStyle就是点击的那个按钮的样式
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //  删除功能
        // 1.先删除数组中的数据
        //[self.allCitys removeObjectAtIndex:indexPath.row];
        
        // 2.刷新界面
        // 不用使用reloadData来刷新整个界面
        // 只需要将删除的数据对应的行,从表视图中删除即可
        //[tableView reloadData];
        //[tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
        
    }
//    else{
//        //  增加功能
//        // 1.向数组中添加数据
//        City *newCity = [[City alloc]init];
//        newCity.name = @"test";
//        newCity.population = 100;
//        [self.allCitys addObject:newCity];
//        
//        // 2.刷新界面
//        NSIndexPath *newIndexPath = [NSIndexPath  indexPathForRow:self.allCitys.count-1 inSection:0];
//        [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationTop];
//    }
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
