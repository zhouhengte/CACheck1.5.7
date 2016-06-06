//
//  RecordDetailViewController.h
//  BaseProject
//
//  Created by 刘子琨 on 16/1/13.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import "ViewController.h"
#import <RESideMenu.h>

typedef void(^MyBlock)(NSString *);

@interface RecordDetailViewController : ViewController

@property (nonatomic , copy) MyBlock myBlcok;

//用来接收扫描页面二维码传来的c码
@property (nonatomic , copy)NSString *codeStr;

//用来接收扫描页面的条形码的code
@property (nonatomic , copy)NSString *barCode;

//用一个专一的字符串去接收list页面的传值
@property (nonatomic , copy)NSString *judgeStr;

//给控制器添加标识
@property (nonatomic , copy)NSString *sugueStr;


//给扫描记录添加标示
@property (nonatomic , copy)NSString *onlyStr;

//接收时间
@property (nonatomic , copy)NSString *date;

@property BOOL _someBool;
@property BOOL _anotherBool;

@property (nonatomic ,copy)NSString *countKey;

@end
