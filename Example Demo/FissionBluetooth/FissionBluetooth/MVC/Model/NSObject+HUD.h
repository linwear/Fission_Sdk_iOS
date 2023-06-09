//
//  NSObject+HUD.h
//  FissionBluetooth
//
//  Created by 裂变智能 on 2021/3/5.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (HUD)

/// 文字提示框---透明允许交互
+ (void)showHUDText:(NSString *)text;

/// 加载等待框---渐变不允许交互
+ (void)showLoading:(NSString *)text;

/// 进度等待框---渐变不允许交互
+ (void)showProgress:(float)progress status:(NSString*)status;

/// 隐藏
+ (void)dismiss;

/// 字体
+ (UIFont *)themePingFangSCMediumFont:(CGFloat)fontSize;

/// 圆角边框
+ (void)setView:(UIView*)view
        cornerRadius:(CGFloat)radius
        borderWidth:(CGFloat)bWidth
        borderColor:(UIColor *)bColor;

/// 获取屏幕当前显示的 ViewController
+ (UIViewController *)getCurrentVC:(UIView *)view;

@end

NS_ASSUME_NONNULL_END
