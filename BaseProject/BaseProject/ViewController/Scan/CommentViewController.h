//
//  CommentViewController.h
//  BaseProject
//
//  Created by 刘子琨 on 16/4/25.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentViewController : UIViewController
@property (nonatomic,strong)NSString *productCode;
@property (nonatomic,strong)NSMutableDictionary *commentDic;
@property (nonatomic,strong)NSMutableArray *commentArray;
@property (nonatomic,strong)NSDictionary *productDic;
@property (nonatomic,assign)BOOL isBarcode;
@end
