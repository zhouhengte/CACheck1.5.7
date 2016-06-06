//
//  NSObject+Parse.h
//  BaseProject
//
//  Created by mis on 15/12/17.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 1.解析类，解析的对象就两种：NSDicationary,NSArray
 2.每个解析类 都会有一个parse方法，传入字典/数组，返回当前对象
 3.重写，解决key不存在，value不存在而崩溃的问题(防御性编程)
 4.考虑 key 和 系统关键词冲突问题
 5.考虑 解析类中存在数组的问题
 */

@interface NSObject (Parse)

+(id)parse:(id)responseObj;

/** 子类重写下方方法
 返回某个Key所对应的property
 //key:description property：desc
 */
+(NSString *)replacePropertyForKey:(NSString *)key;

/** 
 数组类型的key:应该由规定类来解析
 */
+(NSDictionary *)objectClassInArray;

@end
