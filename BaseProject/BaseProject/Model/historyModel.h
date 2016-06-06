//
//  historyModel.h
//  CACheck
//
//  Created by 刘子琨 on 15/10/26.
//  Copyright (c) 2015年 刘子琨. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface historyModel : NSObject

@property (nonatomic , strong)NSString *value;
@property (nonatomic ,strong)NSString *key;

@property (nonatomic, copy)NSString * productName;
@property (nonatomic , copy)NSString *statusDesc;

@property (nonatomic , copy)NSString *color;

-(instancetype)initWithDict:(NSDictionary *)dic;

//传入字典， 定义model 的名字，是否合格
- (id)setConfigureWithDict:(NSDictionary *)dic;
@end
