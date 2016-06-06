//
//  historyModel.m
//  CACheck
//
//  Created by 刘子琨 on 15/10/26.
//  Copyright (c) 2015年 刘子琨. All rights reserved.
//

#import "historyModel.h"

@implementation historyModel
-(instancetype)initWithDict:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        self.value = dic[@"value"];
        self.key= dic[@"key"];
        self.color = dic[@"color"];
    }
    return self;
}

- (id)setConfigureWithDict:(NSDictionary *)dic {
//    self = [];
    
    
    if ([[dic objectForKey:@"key"] isEqualToString:@"ProductName"]) {
        self.productName = [dic objectForKey:@"value"];
    }
    if ([[dic objectForKey:@"key"] isEqualToString:@"StatusDesc"]) {
        self.statusDesc = [dic objectForKey:@"value"];
    }
    
    return self;
}


@end
