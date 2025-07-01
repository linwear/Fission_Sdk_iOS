//
//  AppDelegate+Ai.h
//  FissionBluetooth
//
//  Created by LINWEAR on 2025-05-16.
//

#import "AppDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface AppDelegate (Ai)

/// 注册手表相关AI回调｜Register watch-related AI callbacks
- (void)ai_registerCallbacks;

/// 初始化AI服务｜Initialize AI service
- (void)ai_initialize:(NSString * _Nonnull)mac;

@end

NS_ASSUME_NONNULL_END
