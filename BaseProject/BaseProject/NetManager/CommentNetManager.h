//
//  CommentNetManager.h
//  BaseProject
//
//  Created by 刘子琨 on 16/5/4.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import "BaseNetManager.h"

@interface CommentNetManager : BaseNetManager

+(id)getCcodeCommentWithTypeID:(NSString *)typeid CurrentPage:(NSString *)currentpage PageSize:(NSString *)pagesize completionHandle:(void(^)(id responseObject,NSError *error))completionHandle;

+(id)getBarCodeCommentWithBarCode:(NSString *)barcode CurrentPage:(NSString *)currentpage PageSize:(NSString *)pagesize completionHandle:(void(^)(id responseObject,NSError *error))completionHandle;
@end
