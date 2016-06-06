//
//  CommentNetManager.m
//  BaseProject
//
//  Created by 刘子琨 on 16/5/4.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import "CommentNetManager.h"

@implementation CommentNetManager

+(id)getCcodeCommentWithTypeID:(NSString *)typeid CurrentPage:(NSString *)currentpage PageSize:(NSString *)pagesize completionHandle:(void (^)(id, NSError *))completionHandle
{
    NSString *getccodeCommentUrl = [NSString stringWithFormat:@"%@/%@",kUrl,kGetCCodeCommentUrl];
    NSMutableDictionary *getDic = [[NSMutableDictionary alloc]init];
    [getDic setValue:typeid forKey:@"typeid"];
    [getDic setValue:currentpage forKey:@"currentpage"];
    [getDic setValue:pagesize forKey:@"pagesize"];
    NSString *para = [self dictionaryToJson:getDic];
    NSDictionary *paraDic = @{@"json":para};
    
    return [self POST:getccodeCommentUrl parameters:paraDic completionHandle:^(id responseObject, NSError *error) {
        completionHandle(responseObject,error);
    }];
}

+(id)getBarCodeCommentWithBarCode:(NSString *)barcode CurrentPage:(NSString *)currentpage PageSize:(NSString *)pagesize completionHandle:(void (^)(id, NSError *))completionHandle
{
    NSString *getBarCodeCommentUrl = [NSString stringWithFormat:@"%@/%@",kUrl,kGetBarCodeCommentUrl];
    NSMutableDictionary *getDic = [[NSMutableDictionary alloc]init];
    [getDic setValue:barcode forKey:@"barcode"];
    [getDic setValue:currentpage forKey:@"currentpage"];
    [getDic setValue:pagesize forKey:@"pagesize"];
    NSString *para = [self dictionaryToJson:getDic];
    NSDictionary *paraDic = @{@"json":para};
    
    return [self POST:getBarCodeCommentUrl parameters:paraDic completionHandle:^(id responseObject, NSError *error) {
        completionHandle(responseObject,error);
    }];
}

#pragma mark - 字典转json串
+ (NSString*)dictionaryToJson:(NSDictionary *)dic
{
    
    NSError *parseError = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
}

@end
