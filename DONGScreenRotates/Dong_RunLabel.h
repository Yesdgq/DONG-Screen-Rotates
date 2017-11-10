//
//  Dong_RunLabel.h
//  SevenColorMovies
//
//  Created by yesdgq on 16/12/7.
//  Copyright © 2016年 yesdgq. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Dong_RunLabel : UIView
/** 文字内容 */
@property (nonatomic, copy) NSString *titleName;
/** 文字大小 */
@property (nonatomic, strong) UIFont *titleFont;
/** 文字颜色 */
@property (nonatomic, strong) UIColor *titleColor;
/** 文字对齐方式 */
@property (nonatomic, assign) NSTextAlignment textAlignment;
/** 背景颜色 */
@property (nonatomic, strong) UIColor *backGroundColor;

- (instancetype)initWithTitle:(NSString *)titleName;

@end
