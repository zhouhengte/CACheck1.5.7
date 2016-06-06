//
//  ProductInfoModel.m
//  BaseProject
//
//  Created by 刘子琨 on 16/1/13.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import "ProductInfoModel.h"

@implementation ProductInfoModel

-(instancetype)initWithDict:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        self.text = dic[@"text"];
        self.value = dic[@"value"];
        self.url = dic[@"url"];
        self.key = dic[@"key"];
    }
    return self;
}

@end
