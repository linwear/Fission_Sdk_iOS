//
//  NSObject+HUD.m
//  FissionBluetooth
//
//  Created by 裂变智能 on 2021/3/5.
//

#import "NSObject+HUD.h"

@implementation NSObject (HUD)

/// 文字提示框---透明允许交互
+ (void)showHUDText:(NSString *)text{
    [SVProgressHUD showImage:[UIImage imageNamed:@"?"] status:text];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeNone];
}

/// 加载等待框---渐变不允许交互
+ (void)showLoading:(NSString *)text {
    [SVProgressHUD showWithStatus:text];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
}

/// 进度等待框---渐变不允许交互
+ (void)showProgress:(float)progress status:(NSString*)status {
    [SVProgressHUD showProgress:progress status:status];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
}

/// 隐藏
+ (void)dismiss {
    [SVProgressHUD dismiss];
}

/// 字体
+ (UIFont *)BahnschriftFont:(CGFloat)fontSize {
    UIFont *font = [UIFont fontWithName:@"Bahnschrift" size:fontSize];
    return font;
}

/// 圆角边框
+ (void)setView:(UIView*)view cornerRadius:(CGFloat)radius
            borderWidth:(CGFloat)bWidth
            borderColor:(UIColor *)bColor {

    view.layer.cornerRadius = radius;
    view.layer.borderWidth = bWidth;
    view.layer.borderColor = bColor.CGColor;
}

/// 获取屏幕当前显示的 ViewController
+ (UIViewController *)getCurrentVC:(UIView *)view {
    UIResponder *next = view.nextResponder;
    
    do {
        
        if ([next isKindOfClass:[UIViewController class]]) {
            
            return (UIViewController *)next;
        }
        
        next = next.nextResponder;
        
    } while (next != nil);
    
    return nil;
}


@end
