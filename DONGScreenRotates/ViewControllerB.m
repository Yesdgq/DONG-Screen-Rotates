//
//  ViewControllerB.m
//  DONGScreenRotates
//
//  Created by yesdgq on 2017/7/5.
//  Copyright © 2017年 yesdgq. All rights reserved.
//

#import "ViewControllerB.h"
#import "AppDelegate.h"
#import "PlayerViewRotate.h"
#import "ViewControllerC.h"
#import "ViewControllerD.h"
#import <CoreMotion/CoreMotion.h>

//#define FULLScreenFrame [UIScreen mainScreen].bounds
#define FULLScreenFrame CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width)
#define PlayerWindowFrame CGRectMake(0, 20, 375, 200)

@interface ViewControllerB ()

@property (nonatomic, strong) CMMotionManager *motionManager;

@property (weak, nonatomic) IBOutlet UIView *playerView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation ViewControllerB

{
    NSString *viewOriention;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _playerView.frame = PlayerWindowFrame;
    _imageView.frame = _playerView.bounds;
    
    // 注册statusBar方向监听通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(statusBarOrientationChange:)name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
    
    // 注册Device方向监听通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientChange:)name:UIDeviceOrientationDidChangeNotification object:nil];
    
    // 使用加速器
    [self cofigMotionManager];
    
    // 状态栏起始位置
    viewOriention = @"状态栏在上";
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:YES];
    [self.navigationController.navigationBar setHidden:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (IBAction)pushVCC:(id)sender
{
    if ([PlayerViewRotate isOrientationLandscape]) {
        [PlayerViewRotate forceOrientation:UIInterfaceOrientationPortrait];
    }
    
    ViewControllerC *vcC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ViewControllerC"];
    [self.navigationController pushViewController:vcC animated:YES];
}

- (IBAction)presentVCC:(id)sender
{
    if ([PlayerViewRotate isOrientationLandscape]) {
        [PlayerViewRotate forceOrientation:UIInterfaceOrientationPortrait];
    }
    
    ViewControllerC *vcC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ViewControllerC"];
    [self presentViewController:vcC animated:YES completion:nil];
    
}

- (IBAction)popSelf:(id)sender
{
    [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationPortrait animated:NO];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)fullScreen:(id)sender
{
    [self AutomaticallyRotateByDeviceOrientation];
}

#pragma mark - 旋转设置

// 是否支持屏幕旋转
- (BOOL)shouldAutorotate
{
    return NO;
}

// 支持设备旋转方向
- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}

#pragma mark - 设备方向变化的监听

// 即使所在VC不支持旋转，当设备发生旋转时，仍然能监听到该方法，但是却不会监听到statusBar旋转的方法
- (void)orientChange:(NSNotification *)noti
{
    UIDeviceOrientation  orient = [UIDevice currentDevice].orientation;

    // 以设备头即听筒的指向为标识
    switch (orient)
    {
        case UIDeviceOrientationPortrait:
        {
            [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationPortrait animated:NO];
        }
            break;
        case UIDeviceOrientationLandscapeLeft:
        {
            [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeRight animated:NO];
            
        }
            break;
        case UIDeviceOrientationPortraitUpsideDown:
            
            break;
        case UIDeviceOrientationLandscapeRight:
        {
            [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeLeft animated:NO];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - StatusBar变化的监听

- (void)statusBarOrientationChange:(NSNotification *)notification
{
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    // 以Home键为标识
    if (orientation == UIInterfaceOrientationLandscapeRight) { // home键靠右
        NSLog(@"状态栏-->左");
        [self changeViewTransformWhenStatusBarOrientationChanged:orientation];
    }
    if (orientation ==UIInterfaceOrientationLandscapeLeft) { // home键靠左
        NSLog(@"状态栏-->右");
        [self changeViewTransformWhenStatusBarOrientationChanged:orientation];
    }
    if (orientation == UIInterfaceOrientationPortrait) { // home键靠下
        NSLog(@"状态栏-->上");
        [self changeViewTransformWhenStatusBarOrientationChanged:orientation];
    }
    if (orientation == UIInterfaceOrientationPortraitUpsideDown) { // home键靠上
        NSLog(@"状态栏-->下");
        [self changeViewTransformWhenStatusBarOrientationChanged:orientation];
    }
}


#pragma mark - 加速器

- (void)cofigMotionManager
{
    // pull方式 仅在点击旋转按钮的时候才需要判断力的朝向，所以选择了 pull 方式，节省资源
    // 初始化全局管理对象
    CMMotionManager *manager = [[CMMotionManager alloc] init];
    self.motionManager = manager;
    // 判断加速度计可不可用，判断加速度计是否开启
    if ([manager isAccelerometerAvailable]) {
        // 告诉manager，更新频率是100Hz 其实Pull时设置频率并没有用 因为只会读取一次
        self.motionManager.gyroUpdateInterval = 0.1;
        self.motionManager.accelerometerUpdateInterval = 0.1;
        // 开始更新，后台线程开始运行。这是Pull方式。
        [manager startAccelerometerUpdates];
    }
    // 获取并处理加速度计数据
    CMAccelerometerData *newestAccel = self.motionManager.accelerometerData;
    NSLog(@"X = %.04f",newestAccel.acceleration.x);
    NSLog(@"Y = %.04f",newestAccel.acceleration.y);
    NSLog(@"Z = %.04f",newestAccel.acceleration.z);
    
}

// 根据设备朝向通过transform旋转
- (void)AutomaticallyRotateByDeviceOrientation
{
    CMAcceleration acceleration = self.motionManager.accelerometerData.acceleration;
    CGFloat xACC = acceleration.x; // x受力方向。
    
    //    NSLog(@"X = %.04f",acceleration.x);
    //    NSLog(@"Y = %.04f",acceleration.y);
    //    NSLog(@"Z = %.04f",acceleration.z);
    
    if ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait) { // Home键在下
        
        if (xACC <= 0) {

            [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeRight animated:NO];
            viewOriention = @"状态栏在左";
            
        } else if (xACC > 0) {

             [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeLeft animated:NO];
            viewOriention = @"状态栏在右";
        }
        
    } else if ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeRight) { // 此时Home键在右-->旋转为小窗口

        [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationPortrait animated:NO];
        viewOriention = @"状态栏在上";
        
    } else if ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeLeft) { // 此时Home键在左-->旋转为小窗口
       
        [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationPortrait animated:NO];
        viewOriention = @"状态栏在上";
        
    }
}

- (void)changeViewTransformWhenStatusBarOrientationChanged:(UIInterfaceOrientation)orientation
{
    if (orientation == UIInterfaceOrientationPortrait) { // Home键在下
        
        if ([viewOriention isEqualToString:@"状态栏在左"]) {
            
            [self viewTransformRotate:-M_PI_2 frame:PlayerWindowFrame];
            viewOriention = @"状态栏在上";
        } else if ([viewOriention isEqualToString:@"状态栏在右"]) {
            
            [self viewTransformRotate:M_PI_2 frame:PlayerWindowFrame];
            viewOriention = @"状态栏在上";
        }
        
    } else if (orientation == UIInterfaceOrientationLandscapeRight) { // 此时Home键在右
        
        if ([viewOriention isEqualToString:@"状态栏在上"]) {
            
            [self viewTransformRotate:M_PI_2 frame:FULLScreenFrame];
            viewOriention = @"状态栏在左";
        } else if ([viewOriention isEqualToString:@"状态栏在右"]) {
            
            [self viewTransformRotate:M_PI frame:FULLScreenFrame];
            viewOriention = @"状态栏在左";
        }
        
        
    } else if (orientation == UIInterfaceOrientationLandscapeLeft) { // 此时Home键在左
        
        if ([viewOriention isEqualToString:@"状态栏在上"]) {
            
            [self viewTransformRotate:-M_PI_2 frame:FULLScreenFrame];
            viewOriention = @"状态栏在右";
            
        } else if ([viewOriention isEqualToString:@"状态栏在左"]) {
            
            [self viewTransformRotate:M_PI frame:FULLScreenFrame];
            viewOriention = @"状态栏在右";
        }
    }
    
    NSLog(@"bounds--%@", NSStringFromCGRect([UIScreen mainScreen].bounds));
}

#pragma mark - view旋转 transform

// 旋转且改变frame
- (void)viewTransformRotate:(CGFloat)pi
                      frame:(CGRect)frame
{
    [UIApplication sharedApplication].statusBarHidden = YES;
    [UIView animateWithDuration:[[UIApplication sharedApplication] statusBarOrientationAnimationDuration] animations:^{
        CGAffineTransform transform = CGAffineTransformRotate(self.playerView.transform, pi);
        self.playerView.transform = transform;
        self.playerView.frame = frame;
        _imageView.frame = _playerView.bounds;
        
    } completion:^(BOOL finished) {
        
        [UIApplication sharedApplication].statusBarHidden = NO;
        
    }];
}

// 只做旋转 不改变frame
- (void)viewTransformRotate:(CGFloat)pi
{
    [UIApplication sharedApplication].statusBarHidden = YES;
    [UIView animateWithDuration:[[UIApplication sharedApplication] statusBarOrientationAnimationDuration] animations:^{
        CGAffineTransform transform = CGAffineTransformRotate(self.playerView.transform, pi);
        self.playerView.transform = transform;
        _imageView.frame = _playerView.bounds;
        
    } completion:^(BOOL finished) {
        
        [UIApplication sharedApplication].statusBarHidden = NO;
        
    }];
}


@end
