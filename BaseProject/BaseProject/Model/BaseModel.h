//
//  BaseModel.h
//  BaseProject
//
//  Created by tarena on 15/12/16.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseModel : NSObject
@property (nonatomic , strong)NSString *text;
@property (nonatomic , strong)NSString *value;
@property (nonatomic , strong)NSString *type;
@property (nonatomic , strong)NSString *picUrl;
@property (nonatomic , strong)NSString *key;
@property (nonatomic , strong)NSString *color;

-(instancetype)initWithDict:(NSDictionary *)dic;
@end
