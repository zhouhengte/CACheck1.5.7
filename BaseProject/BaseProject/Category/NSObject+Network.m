//
//  NSObject+Network.m
//  BaseProject
//
//  Created by mis on 15/12/16.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import "NSObject+Network.h"


@implementation NSObject (Network)



+(AFHTTPSessionManager *)sharedAFManager
{
    static AFHTTPSessionManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [AFHTTPSessionManager manager];
        //设置AF对哪些数据类型进行解析
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json",@"text/json",@"text/javascript",@"text/plain",@"application/x-javascript", nil];
        //定义请求超时时间长度
        manager.requestSerializer.timeoutInterval = 30;
        //还可以设置请求的 头部 httpHeaderField
        [manager.requestSerializer setValue:@"0" forHTTPHeaderField:@"Client-Flag"];
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSString *catoken = [userDefaults valueForKey:@"CA-Token"];
        [manager.requestSerializer setValue:catoken forHTTPHeaderField:@"CA-Token"];
        //可以设置value为nil，来删除某个key
        //[manager.requestSerializer setValue:@"" forKey:@""];
    });
    return manager;
}

+(id)GET:(NSString *)path parameters:(NSDictionary *)params completionHandle:(void (^)(id, NSError *))completionHandle{
    return [[self sharedAFManager]GET:path parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        completionHandle(responseObject,nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        completionHandle(nil,error);
    }];
//    return [[self sharedAFManager]GET:path parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        completionHandle(responseObject,nil);
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        completionHandle(nil,error);
//    }];
}

+(id)POST:(NSString *)path parameters:(NSDictionary *)params completionHandle:(void (^)(id, NSError *))completionHandle{
    return [[self sharedAFManager]POST:path parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        completionHandle(responseObject,nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        completionHandle(nil,error);
    }];
    
//    return [[self sharedAFManager]POST:path parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        completionHandle(responseObject,nil);
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        completionHandle(nil,error);
//    }];
}


@end
