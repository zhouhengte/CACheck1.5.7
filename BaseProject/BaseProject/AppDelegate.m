//
//  AppDelegate.m
//  BaseProject
//
//  Created by tarena on 15/12/15.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import "AppDelegate.h"
#import "AppDelegate+Category.h"
#import "MobClick.h"
#import <UMSocial.h>
#import <UMSocialWechatHandler.h>
#import <UMSocialQQHandler.h>
#import <UMSocialSinaSSOHandler.h>
#import "WelcomeViewController.h"
#import "RecordDetailViewController.h"
#import "ScanRecordViewController.h"
#import "MessageViewController.h"
#import "MainViewController.h"
#import <CoreLocation/CoreLocation.h>

@interface AppDelegate ()
@property (nonatomic, strong) CLLocationManager *manager;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //设置电池栏颜色，需先在target info中设置View controller-based status bar appearance为NO
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleLightContent];
    
    //友盟日活统计key
    [MobClick startWithAppkey:@"564e8ee567e58e64f2003bef" reportPolicy:BATCH channelId:@"Web"];
    //    [MobClick startWithAppkey:@"5660f82e67e58efaa5002135" reportPolicy:BATCH channelId:@"Web"];
    //友盟社会化分享
    [UMSocialData setAppKey:@"564e8ee567e58e64f2003bef"];
    [UMSocialWechatHandler setWXAppId:@"wx1b75fcd340d4f79e" appSecret:@"9bf2df908c85a552b7986f0c96944551" url:@"http://www.umeng.com/social"];
    [UMSocialQQHandler setQQWithAppId:@"1104866715" appKey:@"xecOSHVV5mwkLmex" url:@"http://www.umeng.com/social"];
    [UMSocialSinaSSOHandler openNewSinaSSOWithAppKey:@"967224804" secret:@"6e4eb274f1ee1d3494017707e4c5babb" RedirectURL:@"http://sns.whalecloud.com/sina2/callback"];
    
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [MobClick setAppVersion:version];
#warning 如果是开发状态，切记要写下方代码，否则应用崩溃就不会出现任何提示,会被传到友盟官网
#ifdef DEBUG
    [MobClick setLogEnabled:YES];
#endif
    
    
    //初始化方法
    [self initializeWithApplication:application];
    
    //初始化manager对象
    self.manager = [[CLLocationManager alloc] init];
    //设置代理
    //self.manager.delegate = self;
    //征求用户的同意(假定同意)
    //iOS8+才开始征求用户的同意
    if ([[UIDevice currentDevice].systemVersion doubleValue] > 8.0) {
        //征求用户是否愿意前台和后台都定位
        //        [self.manager requestAlwaysAuthorization];
        //征求用户是否愿意只在前台定位(Info.plist添加key)
        [self.manager requestWhenInUseAuthorization];
    } else {
        //直接定位(不需要征求用户同意)
        //[self.manager startUpdatingLocation];
    }

    
    //设置第一次启动进入欢迎页面
    NSUserDefaults * settings1 = [NSUserDefaults standardUserDefaults];
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *key1 = [NSString stringWithFormat:@"is_first_%@",[infoDictionary objectForKey:@"CFBundleShortVersionString"]];
    NSString *value = [settings1 objectForKey:key1];
    if ([value isEqualToString:@"false"]) {
        self.window = [[UIWindow alloc]initWithFrame:[[UIScreen mainScreen]bounds]];
        UINavigationController *naviVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"contentViewController"];
        self.window.rootViewController = naviVC;
        [self.window makeKeyAndVisible];
        //[self enterApp];
        //MainViewController *mainVC = [self.storyboard instantiateViewControllerWithIdentifier:@"mainViewController"];
        //[self presentViewController:mainVC animated:YES completion:nil];
    }
    if (!value) {
        NSUserDefaults * setting = [NSUserDefaults standardUserDefaults];
        NSString * key = [NSString stringWithFormat:@"is_first_%@",[infoDictionary objectForKey:@"CFBundleShortVersionString"]];
        [setting setObject:[NSString stringWithFormat:@"false"] forKey:key];
        [setting synchronize];
        self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen]bounds]];
        WelcomeViewController *welVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"welcomeViewController"];
        self.window.rootViewController = welVC;
        [self.window makeKeyAndVisible];
    }

    
    // ios8后，需要添加这个注册，才能得到授权(还未注册远程推送，以后实现)
    if ([application respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        UIUserNotificationType type =  UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound;
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:type
                                                                                 categories:nil];
        [application registerUserNotificationSettings:settings];

    } else {

        [application registerForRemoteNotificationTypes:UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeSound|UIRemoteNotificationTypeBadge];
    }
    
    
    
//    if (launchOptions != nil) {
//        NSDictionary *userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
//        if (userInfo != nil) {
//            NSString *notMess = [userInfo objectForKey:@"barcode"];
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"该产品已过期"
//                                                            message:notMess
//                                                           delegate:nil
//                                                  cancelButtonTitle:@"OK"
//                                                  otherButtonTitles:nil];
//            [alert show];
//    
//            // 更新显示的徽章个数
//            NSInteger badge = [UIApplication sharedApplication].applicationIconBadgeNumber;
//            badge--;
//            badge = badge >= 0 ? badge : 0;
//            [UIApplication sharedApplication].applicationIconBadgeNumber = badge;
//
//        }
//        //NSLog(@"local notification:%@",userInfo);
//    }
    
    //判断是否从本地推送点击进入app
    UILocalNotification *localNotification = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
    NSLog(@"localNotification = %@",localNotification);
    if (localNotification) {
        NSLog(@"noti:%@",localNotification);
        // 这里真实需要处理交互的地方
        // 获取通知所带的数据
//        NSString *notMess = [localNotification.userInfo objectForKey:@"barcode"];
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"该产品已过期"
//                                                        message:notMess
//                                                       delegate:nil
//                                              cancelButtonTitle:@"OK"
//                                              otherButtonTitles:nil];
//        [alert show];
        
        
        self.window = [[UIWindow alloc]initWithFrame:[[UIScreen mainScreen]bounds]];
        //手动拼接navigationcontrollers
        UINavigationController *naviVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"contentViewController"];
        self.window.rootViewController = naviVC;
        RecordDetailViewController *recordDetailVC = [[RecordDetailViewController alloc] init];
        recordDetailVC.judgeStr = [localNotification.userInfo objectForKey:@"barcode"];
        recordDetailVC.sugueStr = @"list";
        recordDetailVC.onlyStr = @"消息";
        //ScanRecordViewController *scanRecordVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"scanRecordViewController"];
        MessageViewController *messageVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"messageViewController"];
        MainViewController *mainVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"mainViewController"];
        NSArray *controllerArray = @[mainVC,messageVC,recordDetailVC];
        [naviVC setViewControllers:controllerArray];
        [self.window makeKeyAndVisible];
        
        
        
        // 更新显示的徽章个数
        NSInteger badge = [UIApplication sharedApplication].applicationIconBadgeNumber;
        badge--;
        badge = badge >= 0 ? badge : 0;
        [UIApplication sharedApplication].applicationIconBadgeNumber = badge;
        
        // 在不需要再推送时，可以取消推送
        //[application cancelLocalNotification:localNotification];

    }
    
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    BOOL result = [UMSocialSnsService handleOpenURL:url];
    if (result == FALSE) {
        //调用其他SDK，例如支付宝SDK等
    }
    return result;
}



@end
