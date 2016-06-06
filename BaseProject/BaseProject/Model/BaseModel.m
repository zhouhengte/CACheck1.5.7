//
//  BaseModel.m
//  BaseProject
//
//  Created by tarena on 15/12/16.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import "BaseModel.h"

@implementation BaseModel
-(instancetype)initWithDict:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        self.text = dic[@"text"];
        self.value = dic[@"value"];
        self.type = dic[@"type"];
        self.picUrl = dic[@"url"];
        self.key = dic[@"key"];
        self.color = dic[@"color"];
    }
    return self;
}
//- (NSString *)description {
//    return [NSString stringWithFormat:@"%@  %@  url =%@ %@ %@ ", _text, _value, _picUrl, _key, _type];
//}
@end
