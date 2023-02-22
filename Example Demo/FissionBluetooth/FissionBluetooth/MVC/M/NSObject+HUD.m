//
//  NSObject+HUD.m
//  FissionBluetooth
//
//  Created by 裂变智能 on 2021/3/5.
//

#import "NSObject+HUD.h"
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonHMAC.h>

@implementation NSObject (HUD)
+ (void)showHUDText:(NSString *)text{
    [SVProgressHUD showImage:[UIImage imageNamed:@"?"] status:text];
}
// 苹方中黑字体
+ (UIFont *)themePingFangSCMediumFont:(CGFloat)fontSize {
    UIFont *font = [UIFont fontWithName:@"PingFangSC-Medium" size:fontSize];
    return font;
}
+ (void)setView:(UIView*)view cornerRadius:(CGFloat)radius
            borderWidth:(CGFloat)bWidth
            borderColor:(UIColor *)bColor {

    view.layer.cornerRadius = radius;
    view.layer.borderWidth = bWidth;
    view.layer.borderColor = bColor.CGColor;
}

// 获取屏幕当前显示的 ViewController
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
