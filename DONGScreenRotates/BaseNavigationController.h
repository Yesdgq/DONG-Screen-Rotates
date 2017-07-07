//
//  SCBaseNavigationController.h
//  SevenColorMovies
//
//  Created by yesdgq on 16/7/18.
//  Copyright © 2016年 yesdgq. All rights reserved.
//  手势返回基类

#import <UIKit/UIKit.h>

@interface BaseNavigationController : UINavigationController

@property (nonatomic, strong) UIPanGestureRecognizer *popRecognizer;

@end
