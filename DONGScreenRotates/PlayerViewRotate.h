//
//  PlayerViewRotate.h
//  SevenColorMovies
//
//  Created by yesdgq on 16/8/16.
//  Copyright © 2016年 yesdgq. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface PlayerViewRotate : NSObject

+ (void)forceOrientation: (UIInterfaceOrientation)orientation;

+ (BOOL)isOrientationLandscape;

@end
