//
//  AppDelegate+Category.m
//  BaseProject
//
//  Created by mis on 15/12/16.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import "AppDelegate+Category.h"
//电池条上网络活动提示
#import <AFNetworkActivityIndicatorManager.h>
#import "RecordDetailViewController.h"
#import "UIAlertView+Blocks.h"


@implementation AppDelegate (Category)

-(void)initializeWithApplication:(UIApplication *)application
{
    //注册DDLog
    [DDLog addLogger:[DDASLLogger sharedInstance]];
    [DDLog addLogger:[DDTTYLogger sharedInstance]];
    [[DDTTYLogger sharedInstance]setColorsEnabled:YES];
    //当使用AF发送网络请求时，只要有网络操作，那么在状态栏（电池条）wifi符号旁边显示 菊花提示(网络是否下载监测功能)
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    //能够监测当前网络是wifi，蜂窝网络，没有网
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        //网络发生变化时 会触发这里的代码
        switch (status) {
            case AFNetworkReachabilityStatusReachableViaWiFi:
                DDLogVerbose(@"当前是wifi环境");
                break;
            case AFNetworkReachabilityStatusNotReachable:
                DDLogVerbose(@"当前无网络");
                break;
            case AFNetworkReachabilityStatusUnknown:
                DDLogVerbose(@"当前网络未知");
            case AFNetworkReachabilityStatusReachableViaWWAN:
                DDLogVerbose(@"当前是蜂窝网络");
                break;
            default:
                break;
        }
    }];
    //开启网络状态监测
    [[AFNetworkReachabilityManager sharedManager]startMonitoring];
    //网络活动发生变化时，会发送下方key的通知，可用在通知中心中添加检测
//    [[NSNotificationCenter defaultCenter]addObserver:nil selector:nil name:AFNetworkingReachabilityDidChangeNotification object:nil];
    


    
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    //取消徽章
    //[[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

//接收到本地通知，下方协议方法会程序未被关闭时，在推送消息被点击(桌面从屏幕上方弹出消息), (锁屏)右滑打开 或 当前程序就在前台  时触发
-(void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    NSLog(@"noti:%@",notification);
//    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//    [userDefaults setObject:@"no" forKey:@"messageisclick"];
    // 这里真实需要处理交互的地方
    // 获取通知所带的数据
    NSString *productName = [notification.userInfo objectForKey:@"productname"];
    NSDate *duedate = [notification.userInfo objectForKey:@"duedate"];
    NSDate *now = [NSDate date];
    NSString *notiMess = @"";
    if ([now isEqualToDate:[duedate laterDate:now]]) {
        notiMess = [NSString stringWithFormat:@"您扫描过的\"%@\"已过期",productName];
    }else{
        notiMess = [NSString stringWithFormat:@"您扫描过的\"%@\"即将过期",productName];
    }
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"过期提醒"
//                                                    message:notiMess
//                                                   delegate:self
//                                          cancelButtonTitle:@"取消"
//                                          otherButtonTitles:@"查看", nil];
//
//    [alert show];
    
    [[[UIAlertView alloc] initWithTitle:@"过期提醒"
                                message:notiMess
                       cancelButtonItem:[RIButtonItem itemWithLabel:@"取消" action:^{
        // Handle "Cancel"
    }]
                       otherButtonItems:[RIButtonItem itemWithLabel:@"查看" action:^{
        UINavigationController *navigetion = (UINavigationController *)self.window.rootViewController;
        RecordDetailViewController *recordDetailVC = [[RecordDetailViewController alloc] init];
        recordDetailVC.judgeStr = [notification.userInfo objectForKey:@"barcode"];
        recordDetailVC.sugueStr = @"list";
        recordDetailVC.onlyStr = @"消息";
        [navigetion pushViewController:recordDetailVC animated:YES];

    }], nil] show];


     //更新显示的徽章个数
//    NSInteger badge = [UIApplication sharedApplication].applicationIconBadgeNumber;
//    badge--;
//    badge = badge >= 0 ? badge : 0;
//    [UIApplication sharedApplication].applicationIconBadgeNumber = 1;
    
    // 在不需要再推送时，可以取消推送
    //[application cancelLocalNotification:notification];

}






@end
