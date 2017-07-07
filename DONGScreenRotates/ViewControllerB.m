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


#define FULLScreenFrame [UIScreen mainScreen].bounds
#define PlayerWindowFrame CGRectMake(0, 20, 375, 200)

@interface ViewControllerB ()

@property (nonatomic, strong) CMMotionManager *motionManager;

@property (weak, nonatomic) IBOutlet UIView *playerView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation ViewControllerB

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _playerView.frame = PlayerWindowFrame;
    _imageView.frame = _playerView.bounds;
    
    // 注册statusBar方向监听通知
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(statusBarOrientationChange:)name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
    
    // 注册Device方向监听通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientChange:)name:UIDeviceOrientationDidChangeNotification object:nil];
    
    // 使用加速器
    [self cofigMotionManager];
    
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
    [self getDeviceOrientation];
    
//    if ([PlayerViewRotate isOrientationLandscape]) {
//        [PlayerViewRotate forceOrientation:UIInterfaceOrientationPortrait];
//    } else {
//        [PlayerViewRotate forceOrientation:UIInterfaceOrientationLandscapeRight];
//    }
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

#pragma mark - 设备方向变化的监听

// 这种方式里面的方向还包括朝上或者朝下，很容易看出这个完全是根据设备自身的物理方向得来的，当我们关注的只是物理朝向时，我们通常需要注册该通知来解决问题（另外还有一个加速计的api，可以实现类似的功能，该api较底层，在上面两个方法能够解决问题的情况下建议不要用，使用不当性能损耗非常大）。
// 即使所在VC不支持旋转，当设备发生旋转时，仍然能监听到该方法，但是却不会监听到statusBar旋转的方法
- (void)orientChange:(NSNotification *)noti
{
    UIDeviceOrientation  orient = [UIDevice currentDevice].orientation;
    /*
     UIDeviceOrientationUnknown,
     UIDeviceOrientationPortrait,            // Device oriented vertically, home button on the bottom
     UIDeviceOrientationPortraitUpsideDown,  // Device oriented vertically, home button on the top
     UIDeviceOrientationLandscapeLeft,       // Device oriented horizontally, home button on the right
     UIDeviceOrientationLandscapeRight,      // Device oriented horizontally, home button on the left
     UIDeviceOrientationFaceUp,              // Device oriented flat, face up
     UIDeviceOrientationFaceDown             // Device oriented flat, face down   */
    
    // 以设备头即听筒的指向为标识
    switch (orient)
    {
        case UIDeviceOrientationPortrait:
            NSLog(@"Home键-->下");
            if ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeRight) {
                [self viewTransformRotate:-M_PI_2 frame:PlayerWindowFrame statusBarOrientation:UIInterfaceOrientationPortrait];
            }
            if ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeLeft) {
                [self viewTransformRotate:M_PI_2 frame:PlayerWindowFrame statusBarOrientation:UIInterfaceOrientationPortrait];
            }
            break;
        case UIDeviceOrientationLandscapeLeft:
        {
            NSLog(@"Home键-->右");
            if ([UIApplication sharedApplication].statusBarOrientation == UIDeviceOrientationPortrait) {
                [self getDeviceOrientation];
            }
            if ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeLeft) {
                [self viewTransformRotate:M_PI statusBarOrientation:UIInterfaceOrientationLandscapeRight];
            }
        }
            break;
        case UIDeviceOrientationPortraitUpsideDown:
            NSLog(@"Home键-->上");
            
            break;
        case UIDeviceOrientationLandscapeRight:
        {
            NSLog(@"Home键-->左");
            if ([UIApplication sharedApplication].statusBarOrientation == UIDeviceOrientationPortrait) {
                [self getDeviceOrientation];
            }
            if ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeRight) {
                [self viewTransformRotate:M_PI statusBarOrientation:UIInterfaceOrientationLandscapeLeft];
            }
        }
            
            break;
            
        default:
            break;
    }
}

#pragma mark - StatusBar变化的监听

// 这种方式监听的是StatusBar也就是状态栏的方向，所以这个是跟你的布局有关的，你的布局转了，才会接到这个通知，而不是设备旋转的通知。当我们关注的东西和布局相关而不是纯粹设备旋转，我们使用上面的代码作为实现方案比较适合。
- (void)statusBarOrientationChange:(NSNotification *)notification
{
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    // 以Home键为标识
    if (orientation == UIInterfaceOrientationLandscapeRight) { // home键靠右
        NSLog(@"状态栏-->左");
    }
    if (orientation ==UIInterfaceOrientationLandscapeLeft) { // home键靠左
        NSLog(@"状态栏-->右");
    }
    if (orientation == UIInterfaceOrientationPortrait) { // home键靠下
        NSLog(@"状态栏-->上");
    }
    if (orientation == UIInterfaceOrientationPortraitUpsideDown) { // home键靠上
        NSLog(@"状态栏-->下");
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
        // 告诉manager，更新频率是100Hz
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

// 通过加速器获取设备朝向
- (void)getDeviceOrientation
{
    CMAcceleration acceleration = self.motionManager.accelerometerData.acceleration;
    CGFloat xACC = acceleration.x; // x受力方向。
    
    NSLog(@"X = %.04f",acceleration.x);
    NSLog(@"Y = %.04f",acceleration.y);
    NSLog(@"Z = %.04f",acceleration.z);
    
    if ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait) { // Home键在下
        
        if (xACC <= 0) {
            NSLog(@"FULLScreenFrame--%@", NSStringFromCGRect(FULLScreenFrame));
            [self viewTransformRotate:M_PI_2 frame:FULLScreenFrame statusBarOrientation:UIInterfaceOrientationLandscapeRight];
        } else if (xACC > 0) {
            NSLog(@"FULLScreenFrame--%@", NSStringFromCGRect(FULLScreenFrame));
            [self viewTransformRotate:-M_PI_2 frame:FULLScreenFrame statusBarOrientation:UIInterfaceOrientationLandscapeLeft];
        }
        
    } else if ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeRight) { // 此时Home键在右-->旋转为小窗口
        [self viewTransformRotate:-M_PI_2 frame:PlayerWindowFrame statusBarOrientation:UIInterfaceOrientationPortrait];
        
    } else if ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeLeft) { // 此时Home键在左-->旋转为小窗口
        [self viewTransformRotate:M_PI_2 frame:PlayerWindowFrame statusBarOrientation:UIInterfaceOrientationPortrait];
    }
}

#pragma mark - view旋转 transform

// 旋转且改变frame
- (void)viewTransformRotate:(CGFloat)pi
                      frame:(CGRect)frame
       statusBarOrientation:(UIInterfaceOrientation)orientation
{
    [UIApplication sharedApplication].statusBarHidden = YES;
    [UIView animateWithDuration:[[UIApplication sharedApplication] statusBarOrientationAnimationDuration] animations:^{
        CGAffineTransform transform = CGAffineTransformRotate(self.playerView.transform, pi);
        self.playerView.transform = transform;
        self.playerView.frame = frame;
        _imageView.frame = _playerView.bounds;
        
    } completion:^(BOOL finished) {
        
        [UIApplication sharedApplication].statusBarHidden = NO;
        [[UIApplication sharedApplication] setStatusBarOrientation:orientation animated:NO];

    }];
}

// 只做旋转 不改变frame
- (void)viewTransformRotate:(CGFloat)pi
       statusBarOrientation:(UIInterfaceOrientation)orientation
{

    [UIApplication sharedApplication].statusBarHidden = YES;
    [UIView animateWithDuration:[[UIApplication sharedApplication] statusBarOrientationAnimationDuration] animations:^{
        CGAffineTransform transform = CGAffineTransformRotate(self.playerView.transform, pi);
        self.playerView.transform = transform;
        _imageView.frame = _playerView.bounds;
        
    } completion:^(BOOL finished) {
        
        [UIApplication sharedApplication].statusBarHidden = NO;
        [[UIApplication sharedApplication] setStatusBarOrientation:orientation animated:NO];

    }];
}

/*
 总结： 旋转视图的要点
 1. controller 作为 子controller 添加到 父viewController上。
 2. 旋转时，改变的是 controller.view  的transform。
 3. 设置 statusBarOrientation 时，需要注意 info.plist文件中，View controller-based status bar appearance
 默认plist文件中无该选项，需要添加。如果为yes，则view Controller 优先级高于 application，为no则以application 为准。
 4. 如果想要获取设备的矢量方向可以用加速器获取力的方向，来判断
 */

@end
