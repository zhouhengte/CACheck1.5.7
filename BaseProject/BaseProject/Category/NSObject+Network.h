//
//  NSObject+Network.h
//  BaseProject
//
//  Created by mis on 15/12/16.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import <Foundation/Foundation.h>
#define kCompletionHandle completionHandle:(void(^)(id model,NSError *error))completionHandle;
/*
 请求类型：Get Post
 Get：传递小型数据
 Post：传递大型数据
 具体使用哪个请求:有服务器人员规定
 */
@interface NSObject (Network)

+(id)GET:(NSString *)path parameters:(NSDictionary *)params kCompletionHandle
+(id)POST:(NSString *)path parameters:(NSDictionary *)params kCompletionHandle


@end
