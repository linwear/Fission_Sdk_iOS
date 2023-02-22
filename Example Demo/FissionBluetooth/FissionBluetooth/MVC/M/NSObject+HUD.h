//
//  NSObject+HUD.h
//  FissionBluetooth
//
//  Created by 裂变智能 on 2021/3/5.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (HUD)
+ (void)showHUDText:(NSString *)text;

// 苹方中黑字体
+ (UIFont *)themePingFangSCMediumFont:(CGFloat)fontSize;

+ (void)setView:(UIView*)view
        cornerRadius:(CGFloat)radius
        borderWidth:(CGFloat)bWidth
        borderColor:(UIColor *)bColor;

// 获取屏幕当前显示的 ViewController
+ (UIViewController *)getCurrentVC:(UIView *)view;

@end

NS_ASSUME_NONNULL_END
