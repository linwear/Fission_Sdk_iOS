//
//  FBHUD.h
//  FissionBluetooth
//
//  Created by 裂变智能 on 2023-08-01.
//

#import <Foundation/Foundation.h>

@class FBLoadingHUD;
@class FBResultHUD;

NS_ASSUME_NONNULL_BEGIN

@interface FBHUD : NSObject

/// 显示加载
+ (void)showLoading:(UIView *)view;

/// 显示成功
+ (void)showSuccess:(UIView *)view;

/// 显示失败
+ (void)showFailure:(UIView *)view;

@end


// 加载中...
@interface FBLoadingHUD : UIView

+ (FBLoadingHUD*)showIn:(UIView *)view;

+ (FBLoadingHUD*)hideIn:(UIView *)view;

@end


// 成功or失败...
@interface FBResultHUD : UIView <CAAnimationDelegate>

+ (FBResultHUD*)showIn:(UIView *)view success:(BOOL)success;

+ (FBResultHUD*)hideIn:(UIView *)view;

@end

NS_ASSUME_NONNULL_END
