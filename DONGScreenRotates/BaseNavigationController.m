//
//  SCBaseNavigationController.m
//  SevenColorMovies
//
//  Created by yesdgq on 16/7/18.
//  Copyright © 2016年 yesdgq. All rights reserved.
//  手势返回基类

#import "BaseNavigationController.h"

#import <objc/runtime.h>


@interface BaseNavigationController () <UIGestureRecognizerDelegate>



@end

@implementation BaseNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    //    self.navigationBar.hidden = YES;
    
    // built-in pop recognizer
    UIGestureRecognizer *recognizer = self.interactivePopGestureRecognizer;
    recognizer.enabled = NO;
    UIView *gestureView = recognizer.view;
    
    // pop recognizer
    UIPanGestureRecognizer *popRecognizer = [[UIPanGestureRecognizer alloc] init];
    popRecognizer.delegate = self;
    popRecognizer.maximumNumberOfTouches = 1;
    [gestureView addGestureRecognizer:popRecognizer];
    self.popRecognizer = popRecognizer;
    
    // taget-action reflect
    NSMutableArray *actionTargets = [recognizer valueForKey:@"_targets"];
    id actionTarget = [actionTargets firstObject];
    id target = [actionTarget valueForKey:@"_target"];
    SEL action = NSSelectorFromString(@"handleNavigationTransition:");
    [popRecognizer addTarget:target action:action];
}

- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)gestureRecognizer
{
    return self.viewControllers.count > 1 && ![[self valueForKey:@"_isTransitioning"] boolValue] && [gestureRecognizer translationInView:gestureRecognizer.view].x > 0;
}

// 是否支持屏幕旋转
- (BOOL)shouldAutorotate
{
    return [self.viewControllers.lastObject shouldAutorotate];
}

// 支持设备旋转方向
- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return [self.viewControllers.lastObject supportedInterfaceOrientations];
}

@end
