//
//  ViewControllerD.m
//  DONGScreenRotates
//
//  Created by yesdgq on 2017/7/7.
//  Copyright © 2017年 yesdgq. All rights reserved.
//

#import "ViewControllerD.h"

@interface ViewControllerD ()

@end

@implementation ViewControllerD

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 是否支持屏幕旋转
- (BOOL)shouldAutorotate
{
    return NO;
}

// 支持设备旋转方向
- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

@end
