//
//  ScanRecordTableViewController.m
//  BaseProject
//
//  Created by 刘子琨 on 16/1/12.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import "ScanRecordViewController.h"
#import "RecordTableViewCell.h"
#import "RecordDetailViewController.h"
#import "MobClick.h"
#import "UIAlertView+Blocks.h"

@interface ScanRecordViewController () <UITableViewDataSource,UITableViewDelegate>

//数据
@property (nonatomic , strong)NSMutableArray *dataArray;
//日期
@property (nonatomic , strong)NSMutableArray *timeArray;
@property (nonatomic , strong)NSMutableArray *keyArray;
@property (nonatomic , copy)NSString *keyStr;

@property (nonatomic , strong)UIButton *btn;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic , strong) UIButton *rightButton;
@property (nonatomic , strong) UIButton *cancelButton;
@property (nonatomic , strong) UIView *deleteView;
@property (nonatomic , strong) NSMutableArray *deleteArray;
@property (nonatomic , strong) NSMutableArray *deleteIndexPathArray;
@property (nonatomic , assign) BOOL allSelected;

@end



@implementation ScanRecordViewController

-(NSMutableArray *)dataArray
{
    if (!_dataArray) {
        self.dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

-(NSMutableArray *)keyArray
{
    if (!_keyArray) {
        self.keyArray = [NSMutableArray array];
    }
    return _keyArray;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = UIColorFromRGB(0xf0f0f0);
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.separatorColor = UIColorFromRGB(0xe8e8e5);
//    self.view.backgroundColor = UIColorFromRGB(0xf0f0f0);
    self.tableView.allowsMultipleSelectionDuringEditing = YES;
    // tableViewCell 分割线
    //self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.deleteArray = [NSMutableArray array];
    self.deleteIndexPathArray = [NSMutableArray array];
    self.allSelected = NO;
    
    //重新设置导航栏，隐藏原生导航栏，手动绘制新的导航栏，使右滑手势跳转时能让导航栏跟着变化
    [self setNavigationBar];
    
    
    
    
    
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *filePath = [path objectAtIndex:0];
    NSString *plistPath = [filePath stringByAppendingPathComponent:@"test.plist"];
    NSArray * arrayFromfile = [NSArray arrayWithContentsOfFile:plistPath];
    self.dataArray = [NSMutableArray arrayWithArray: arrayFromfile];
    
    
    
    
    
    NSString *datePlistPath = [filePath stringByAppendingPathComponent:@"date.plist"];
    
    NSArray * dateArrayFromfile = [NSArray arrayWithContentsOfFile:datePlistPath];
    self.timeArray = [NSMutableArray arrayWithArray:dateArrayFromfile];
    
    //只有客户端在本地找不到历史记录时，才会从通过这个接口查询数据。
    if (self.dataArray.count == 0) {
        [self getHistoryList];
#warning 还存在问题，应该在通过historylist仍然找不到记录时才调用该方法
        [self addPic];
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
    label.text = @"扫描记录";
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
    
    self.rightButton = [[UIButton alloc]init];
    [_rightButton setTitle:@"编辑" forState:UIControlStateNormal];
    [_rightButton addTarget:self action:@selector(rightItemAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_rightButton];
    [_rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.top.mas_equalTo(20);
        make.size.mas_equalTo(CGSizeMake(50, 44));
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
    if (button.tag == 102) {
        button.backgroundColor = UIColorFromRGB(0x1787c7);
    }else{
        button.alpha = 0.5;
    }
}
-(void)tapUp:(UIButton *)button
{
    if (button.tag == 102) {
        button.backgroundColor = [UIColor colorWithRed:52/255.0 green:181/255.0 blue:254/255.0 alpha:1.0];
    }else{
        button.alpha = 1;
    }
}

-(void)rightItemAction:(UIButton *)sender
{
    // 先修改表视图的状态
    [self.tableView setEditing:!self.tableView.isEditing animated:YES];
    // 判断表视图的状态,决定导航按钮上显示的文字
    if (self.tableView.isEditing) {
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


-(void)allSelectedClick:(UIButton *)sender
{
    _allSelected = !_allSelected;
    if (_allSelected) {
        [sender setImage:[UIImage imageNamed:@"已勾选"] forState:UIControlStateNormal];
        for (int row=0; row<self.dataArray.count; row++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
            [_tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
            [_deleteArray addObject:[self.dataArray objectAtIndex:indexPath.row]];
            [_deleteArray addObject:[self.timeArray objectAtIndex:indexPath.row]];
            [_deleteIndexPathArray addObject:indexPath];
        }
    }else{
        [sender setImage:[UIImage imageNamed:@"未勾选"] forState:UIControlStateNormal];
        for (int row=0; row<self.dataArray.count; row++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
            [_tableView deselectRowAtIndexPath:indexPath animated:NO];
            [_deleteArray addObject:[self.dataArray objectAtIndex:indexPath.row]];
        }
        [_deleteArray removeAllObjects];
        [_deleteIndexPathArray removeAllObjects];
    }

}

-(void)deleteClick:(UIButton *)sender
{
    [[[UIAlertView alloc]initWithTitle:nil message:@"删除扫描记录后，商品的相关消息也将删除，确定要删除吗？" cancelButtonItem:[RIButtonItem itemWithLabel:@"取消" action:^{
        [self cancelClick];
    }] otherButtonItems:[RIButtonItem itemWithLabel:@"确定" action:^{
        [_rightButton setTitle:@"编辑" forState:UIControlStateNormal];
        

        [self.dataArray removeObjectsInArray:_deleteArray];
        [self.timeArray removeObjectsInArray:_deleteArray];
        [self.tableView deleteRowsAtIndexPaths:_deleteIndexPathArray withRowAnimation:UITableViewRowAnimationLeft];
        [_deleteIndexPathArray removeAllObjects];
        [self.tableView setEditing:NO animated:YES];
        
        
        NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        
        NSString *filePath = [path objectAtIndex:0];
        NSString *plistPath = [filePath stringByAppendingPathComponent:@"test.plist"];
        NSArray * arrayFromfile = [NSArray arrayWithContentsOfFile:plistPath];
        self.dataArray = [NSMutableArray arrayWithArray: arrayFromfile];
        [self.dataArray removeObjectsInArray:_deleteArray];
        [self.dataArray writeToFile:plistPath atomically:YES];
        
        NSString *datePlistPath = [filePath stringByAppendingPathComponent:@"date.plist"];
        
        NSArray * dateArrayFromfile = [NSArray arrayWithContentsOfFile:datePlistPath];
        self.timeArray = [NSMutableArray arrayWithArray:dateArrayFromfile];
        [self.timeArray removeObjectsInArray:_deleteArray];
        [self.timeArray writeToFile:datePlistPath atomically:YES];

        
        [_deleteArray removeObjectsInArray:_timeArray];
        //NSLog(@"deleteArray:%@",_deleteArray);
        
        //将消息相关内容也删除，取消推送
        //把testPlist文件加入
        NSString *duedatePlistPath = [filePath stringByAppendingPathComponent:@"duedate.plist"];
        NSMutableArray *messageArray = [NSMutableArray arrayWithCapacity:1];
        
        NSArray *duedateArrayFromfile = [NSArray arrayWithContentsOfFile:duedatePlistPath];
        //            [array setArray:arrayFromfile];
        [messageArray addObjectsFromArray:duedateArrayFromfile];
        
        NSMutableArray *deleteMessageArray = [NSMutableArray array];
        for (NSObject *inner in _deleteArray) {
            if ([inner isKindOfClass:[NSDictionary class]]) {
                NSString *code = [[(NSDictionary *)inner allKeys]firstObject];
                //拿到 存有 所有 推送的数组
                NSArray * notiArray = [[UIApplication sharedApplication] scheduledLocalNotifications];
                //遍历这个数组 根据 key 拿到我们想要的 UILocalNotification
                for (UILocalNotification * loc in notiArray) {
                    if ([[loc.userInfo objectForKey:@"barcode"] isEqualToString:code]) {
                        //如果该产品已存在推送，取消该推送
                        [[UIApplication sharedApplication] cancelLocalNotification:loc];
                    }
                }
                for (NSDictionary *innerDic in messageArray) {
                    if ([[innerDic objectForKey:@"barcode"] isEqualToString:code]){
                        [deleteMessageArray addObject:innerDic];
                    }
                }
            }
        }
        [messageArray removeObjectsInArray:deleteMessageArray];
        [messageArray writeToFile:duedatePlistPath atomically:YES];
        
        [_deleteArray removeAllObjects];
        
    }], nil]show];
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



-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"扫描记录"];
//    self.navigationItem.title = @"扫描记录";
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

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"扫描记录"];
}


//没有扫描记录时执行，删除tableview，添加按钮
-(void)addPic
{
    [self.tableView removeFromSuperview];
    UIImageView *imageView = [[UIImageView alloc] init];
    //    UIImageView *imageView = [[UIImageView alloc] init];
    
    //    imageView.backgroundColor= [UIColor redColor];
    
    imageView.image = [UIImage imageNamed:@"扫描记录空"];
    [self.view addSubview:imageView];
    
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        //        make.centerY.equalTo(self.view);
        //        make.top.equalTo(imageViewBig1).with.offset(37/568.0*kScreenHeight);
        make.top.equalTo(self.view).with.offset(0.38*kScreenHeight);
        make.size.mas_equalTo(CGSizeMake(70, 60));
    }];
    
    UILabel *label = [[UILabel alloc]init];
    [self.view addSubview:label];
    label.text = @"还未扫描过商品";
    label.textColor = UIColorFromRGB(0xc3c3c3);
    label.font = [UIFont systemFontOfSize:17];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(imageView.mas_bottom).mas_equalTo(18);
    }];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    //btn.backgroundColor = [UIColor orangeColor];
    [btn setTitle:@"去扫码" forState:UIControlStateNormal];
    
    [self.view addSubview:btn];
    
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        
        make.size.mas_equalTo(CGSizeMake(125, 46));
        make.top.equalTo(imageView.mas_bottom).offset(55);
    }];
    btn.backgroundColor = [UIColor colorWithRed:52/255.0 green:181/255.0 blue:254/255.0 alpha:1.0];
    
    [btn.layer setCornerRadius:6.0];
    [btn addTarget:self action:@selector(goToScanViewController:) forControlEvents:UIControlEventTouchUpInside];
    btn.tag = 102;
    [btn addTarget:self action:@selector(tapBack:) forControlEvents:UIControlEventTouchDown];
    [btn addTarget:self action:@selector(tapUp:) forControlEvents:UIControlEventTouchUpOutside];
//    NSLog(@"%@",self.view.subviews);
}

-(void)goToScanViewController:(UIButton *)sender
{
    sender.backgroundColor = [UIColor colorWithRed:52/255.0 green:181/255.0 blue:254/255.0 alpha:1.0];
    [self.navigationController pushViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"scanViewController"] animated:YES];
}


-(void)getHistoryList
{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
    //    NSString *url = @"http://appserver.ciqca.com/getscanlogapi.action";
    NSString *url = [NSString stringWithFormat:@"%@/%@",kUrl,kHistoryListUrl];
    //NSLog(@"%@",url);
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *catoken = [userDefaults objectForKey:@"CA-Token"];
    //NSLog(@"%@",catoken);
    [manager.requestSerializer setValue:catoken forHTTPHeaderField:@"CA-Token"];
    NSString *stringInt = [NSString stringWithFormat:@"%d",0];
    [manager.requestSerializer setValue:stringInt forHTTPHeaderField:@"Client-Flag"];
    
    NSString *name = [userDefaults objectForKey:@"username"];
    //NSLog(@"%@",name);
    
    if (name == nil) {
        return;
    }else{
        NSDictionary *dic = @{@"username":name,@"pagesize":@10,@"currentpage":@1,/*@"roleid":@1,@"usermobilephone":name*/};
        NSString *json = [self dictionaryToJson:dic];
        //NSLog(@"%@",json);
        NSDictionary *jsonParm = @{@"json":json};
        //NSLog(@"%@",jsonParm);

        
        [manager POST:url parameters:jsonParm progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            //获取数据后好像还没处理
            NSArray *array = responseObject[@"Data"];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"%@",error);
        }];
        
    }
}

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

- (void)backToMainViewController:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //    static NSString *cellID = @"cellID";
    //NSString *cellID = [NSString stringWithFormat:@"Cell%ld%ld", (long)[indexPath section], (long)[indexPath row]];
    RecordTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (nil == cell) {
        cell = [[RecordTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    //设置cell
    [self configureCellIndexPath:indexPath andcell:cell];
    [cell setSelectionStyle:UITableViewCellSelectionStyleBlue];
    
//    cell.selectedBackgroundView.backgroundColor = [UIColor redColor];
//    UIView *aView = [[UIView alloc] initWithFrame:cell.contentView.frame];
//    aView.backgroundColor = UIColorFromRGB(0xf7f7f7);
//    cell.selectedBackgroundView = aView;
    return cell;
}

-(void)configureCellIndexPath:(NSIndexPath *)indexPath andcell:(RecordTableViewCell *)cell
{
    
    NSDictionary *dic = self.dataArray[indexPath.row];
    
    NSString *keyStr = [[dic allKeys] firstObject];
    [self.keyArray insertObject:keyStr atIndex:self.keyArray.count];
    self.keyStr = keyStr;
    
    NSDictionary *bigDic = [dic valueForKey:keyStr];
    NSArray *miniArr = bigDic[@"BaseInfo"];
    
    //isInclude   保存 是否存在LabelProof  这个key，  假设不包含
    //最后根据 其值判断 显示的图片
    BOOL isInclude = NO;
    NSString * imageUrl = nil;
    
    for (NSDictionary *miniDic in miniArr) {
        historyModel *model = [[historyModel alloc]initWithDict:miniDic];
        
        if ([model.key isEqualToString:@"ProductName"]) {
            cell.nameLabel.text = model.value;
            
        }if ([model.key isEqualToString:@"StatusDesc"]) {
            
            NSString *color = model.color;
            NSString * aStr = [NSString stringWithFormat:@"0x%@", color];
            
            //                NSString *str = @"0xff055008";// @"0x34b5fe";
            //先以16为参数告诉strtoul字符串参数表示16进制数字，然后使用0x%X转为数字类型
            unsigned long red = strtoul([aStr UTF8String],0,16);
            //strtoul如果传入的字符开头是“0x”,那么第三个参数是0，也是会转为十六进制的,这样写也可以：
            
            //                unsigned long red = strtoul([@"0x6587" UTF8String],0,0);
            //NSLog(@"转换完的数字为：%lx",red);
            //            cell.userInteractionEnabled = NO;
            cell.stateLabel.textColor = UIColorFromRGB(red);//             }
            cell.stateLabel.text = model.value;
            
        }
        
        
        NSString * keyStr = [miniDic objectForKey:@"key"];
        if ([keyStr isEqualToString:@"LabelProof"]) {
            isInclude = YES;
            imageUrl = model.value;
            //            continue;
        }
        
        cell.dateLabel.text = self.timeArray[indexPath.row];
    }if (cell.stateLabel.text == nil) {//循环外判断如果statelabel为空的话，datelabel取代其位置
        //如果状态栏为空则改变frame
        
        
        //        cell.dateLabel.frame = cell.stateLabel.frame;
        cell.nameLabel.frame = CGRectMake(cell.nameLabel.frame.origin.x, 15/568.0*kScreenHeight, cell.nameLabel.frame.size.width, cell.nameLabel.frame.size.height);
        cell.dateLabel.frame = CGRectMake(cell.nameLabel.frame.origin.x,38/568.0*kScreenHeight, cell.nameLabel.frame.size.width, cell.nameLabel.frame.size.height);
        
    }
    
    if (isInclude) {
        [cell.contentImageView setImageWithURL:[NSURL URLWithString:imageUrl]];
        cell.contentImageView.contentMode = UIViewContentModeScaleAspectFill;
        [cell.contentImageView setContentScaleFactor:[[UIScreen mainScreen] scale]];
        
        
        
        cell.contentImageView.clipsToBounds  = YES;
        
    }else {
        cell.contentImageView.image = [UIImage imageNamed:@"icon1024"];
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
    
    //        return UITableViewCellEditingStyleDelete;
    //
    //        return UITableViewCellEditingStyleInsert;
    
    return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 69/568.0*kScreenHeight;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (![tableView isEditing]) {
        //当手指离开某行时，就让某行的选中状态消失
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        self.keyStr = self.keyArray[indexPath.row];
        UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        RecordDetailViewController *recordDetailVC = [mainStoryBoard instantiateViewControllerWithIdentifier:@"recordDetailViewController"];
        //[self.navigationController pushViewController:loginVC animated:YES];
        //RecordDetailViewController *recordDetailVC = [[RecordDetailViewController alloc] init];
        recordDetailVC.judgeStr = self.keyStr;
        recordDetailVC.sugueStr = @"list";
        recordDetailVC.onlyStr = @"记录列表";
        [self.navigationController pushViewController:recordDetailVC animated:YES];
    }else{
        [_deleteArray addObject:[self.dataArray objectAtIndex:indexPath.row]];
        [_deleteArray addObject:[self.timeArray objectAtIndex:indexPath.row]];
        [_deleteIndexPathArray addObject:indexPath];

    }
    
    

    
//    RecordDetailViewController *recordDetailVC = (RecordDetailViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"recordDetailViewController"];
//    recordDetailVC.judgeStr = self.keyStr;
//    recordDetailVC.sugueStr = @"list";
//    recordDetailVC.onlyStr = @"记录列表";
//    
//    //[self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:recordDetailVC] animated:YES];
//    [self.sideMenuViewController setContentViewController:recordDetailVC animated:YES];
//    ScanRecordTableViewController *scanRecordVC = [[ScanRecordTableViewController alloc]init];
//    [self.sideMenuViewController setLeftMenuViewController:scanRecordVC];
    //[self.sideMenuViewController hideMenuViewController];

    
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.tableView isEditing]) {
        [_deleteArray removeObject:[self.dataArray objectAtIndex:indexPath.row]];
        [_deleteArray removeObject:[self.timeArray objectAtIndex:indexPath.row]];
        [_deleteIndexPathArray removeObject:indexPath];
    }
}


//-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
//    RecordDetailViewController* recordDetailVC = (RecordDetailViewController *)segue.destinationViewController;
//    recordDetailVC.judgeStr = self.keyStr;
//    recordDetailVC.sugueStr = @"list";
//    recordDetailVC.onlyStr = @"记录列表";
//}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
