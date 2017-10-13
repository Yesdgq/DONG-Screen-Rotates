//
//  FullScreenVC.m
//  DONGScreenRotates
//
//  Created by yesdgq on 2017/10/13.
//  Copyright © 2017年 yesdgq. All rights reserved.
//

#import "FullScreenVC.h"
#import <CoreMotion/CoreMotion.h>


#define FULLScreenFrame CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width)
#define PlayerWindowFrame CGRectMake(0, 20, 375, 200)


@interface FullScreenVC ()

@property (nonatomic, strong) CMMotionManager *motionManager;

@property (weak, nonatomic) IBOutlet UIView *playerView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation FullScreenVC
{
    NSString *viewOriention;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // 使用加速器
    [self cofigMotionManager];
    
    
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:YES];
    
    // 注册statusBar方向监听通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(statusBarOrientationChange:) name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
    viewOriention = @"状态栏在上";
//    [self AutomaticallyRotateByDeviceOrientation];
    // 状态栏起始位置
    [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeRight animated:NO];
    [self changeViewTransformWhenStatusBarOrientationChanged:UIInterfaceOrientationLandscapeRight];

}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:YES];
    [self.navigationController.navigationBar setHidden:NO];
//    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)clickButton:(id)sender {
    [self AutomaticallyRotateByDeviceOrientation];
}

- (IBAction)dismiss:(id)sender {
    [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationPortrait animated:NO];
    [self dismissViewControllerAnimated:YES completion:nil];
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

@end
