//
//  PlayerViewRotate.m
//  SevenColorMovies
//
//  Created by yesdgq on 16/8/16.
//  Copyright © 2016年 yesdgq. All rights reserved.
//

#import "PlayerViewRotate.h"

@implementation PlayerViewRotate

+ (void)forceOrientation:(UIInterfaceOrientation)orientation {
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        SEL selector = NSSelectorFromString(@"setOrientation:");
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget:[UIDevice currentDevice]];
        int val = orientation;
        [invocation setArgument:&val atIndex:2];
        [invocation invoke];
    }
}


+ (BOOL)isOrientationLandscape {
    if (UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation)) {
        return YES;
    }else {
        return NO;
    }
}

@end
