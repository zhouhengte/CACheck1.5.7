//
//  ZHTNavigationDelegate.m
//  BaseProject
//
//  Created by 刘子琨 on 16/4/29.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import "ZHTNavigationDelegate.h"
#import "ZHTTransitionAnimator.h"
#import "ZHTPopTransitionAnimator.h"
#import <UIKit/UIKit.h>

@interface ZHTNavigationDelegate ()<UINavigationControllerDelegate>

@end

@implementation ZHTNavigationDelegate

-(id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC
{
    if ([fromVC isKindOfClass:[[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"mainViewController"] class]]) {
        if ([toVC isKindOfClass:[[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"scanViewController"] class]]) {
            return (id)[[ZHTTransitionAnimator alloc]init];
        }
    }
    if ([fromVC isKindOfClass:[[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"scanViewController"] class]]) {
        if ([toVC isKindOfClass:[[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"mainViewController"] class]]) {
            return (id)[[ZHTPopTransitionAnimator alloc]init];
        }
    }
    return nil;
}

//-(void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
//    if (navigationController.viewControllers) {
//        <#statements#>
//    }
//}

@end
