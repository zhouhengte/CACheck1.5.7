//
//  ZHTPopTransitionAnimator.m
//  BaseProject
//
//  Created by 刘子琨 on 16/6/1.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import "ZHTPopTransitionAnimator.h"
#import <UIKit/UIKit.h>
#import "MainViewController.h"
#import "ScanViewController.h"

@interface ZHTPopTransitionAnimator ()<UIViewControllerAnimatedTransitioning>

@property (weak, nonatomic) id transitionContext;

@end

@implementation ZHTPopTransitionAnimator

-(NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 0.5;
}

-(void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    self.transitionContext = transitionContext;
    UIView *containerView = [transitionContext containerView];
    ScanViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    MainViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIButton *button = toVC.scanIconButton;
    
    [containerView addSubview:toVC.view];
    [containerView addSubview:fromVC.view];
    
    UIBezierPath *circleMaskPathFinal = [UIBezierPath bezierPathWithOvalInRect:button.frame];
    CGPoint extremePoint = CGPointMake(button.center.x - 0, button.center.y - CGRectGetHeight(toVC.view.bounds));
    float radius = sqrtf((extremePoint.x * extremePoint.x) + (extremePoint.y * extremePoint.y));
    UIBezierPath *circleMaskPathInitial = [UIBezierPath bezierPathWithOvalInRect:CGRectInset(button.frame, -radius, -radius)];
    
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.path = circleMaskPathFinal.CGPath;
    fromVC.view.layer.mask = maskLayer;
    
    CABasicAnimation *maskLayerAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
    maskLayerAnimation.fromValue = (__bridge id _Nullable)(circleMaskPathInitial.CGPath);
    maskLayerAnimation.toValue = (__bridge id _Nullable)(circleMaskPathFinal.CGPath);
    maskLayerAnimation.duration = [self transitionDuration:transitionContext];
    maskLayerAnimation.delegate = self;
    [maskLayer addAnimation:maskLayerAnimation forKey:@"path"];
}

-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    [self.transitionContext completeTransition:![self.transitionContext transitionWasCancelled]];
    [self.transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey].view.layer.mask = nil;
}


@end
