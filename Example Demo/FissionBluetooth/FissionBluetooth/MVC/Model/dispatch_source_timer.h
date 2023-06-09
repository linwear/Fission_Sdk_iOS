//
//  dispatch_source_timer.h
//  LinWear
//
//  Created by 裂变智能 on 2022/1/18.
//  Copyright © 2022 lw. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

// 定时器封装类🥱
@interface dispatch_source_timer : NSObject

/// 实例化
+ (dispatch_source_timer *)sharedInstance;

/// 初始化计时事件
- (void)initializeTiming:(NSInteger)timing andStartBlock:(void (^)(NSInteger timeIndex))block;

/// 开始计时
- (void)StartTiming;

/// 暂停计时
- (void)PauseTiming;

@end

NS_ASSUME_NONNULL_END
