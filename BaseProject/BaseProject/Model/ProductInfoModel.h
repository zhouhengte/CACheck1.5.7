//
//  ProductInfoModel.h
//  BaseProject
//
//  Created by 刘子琨 on 16/1/13.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProductInfoModel : NSObject

@property (nonatomic , strong)NSString *text;
@property (nonatomic , strong)NSString *value;
@property (nonatomic , strong)NSString *url;
@property (nonatomic , strong)NSString *key;

-(instancetype)initWithDict:(NSDictionary *)dic;

@end
