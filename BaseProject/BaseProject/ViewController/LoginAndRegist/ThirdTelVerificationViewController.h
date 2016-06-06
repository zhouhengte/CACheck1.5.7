//
//  ThirdTelVerificationViewController.h
//  BaseProject
//
//  Created by 刘子琨 on 16/6/2.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import "ViewController.h"

@interface ThirdTelVerificationViewController : ViewController

@property (nonatomic,strong)NSString *thirdParty;//区分来自哪个第三方，0:qq,1:微博
@property (nonatomic,strong)NSString *openID;
@property (nonatomic,strong)NSString *thirdToken;


@end
