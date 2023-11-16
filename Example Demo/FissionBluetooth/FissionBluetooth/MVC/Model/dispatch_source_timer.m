//
//  dispatch_source_timer.m
//  LinWear
//
//  Created by 裂变智能 on 2022/1/18.
//  Copyright © 2022 lw. All rights reserved.
//

#import "dispatch_source_timer.h"

typedef void(^dispatch_source_timer_Block)(NSInteger timeIndex);

@interface dispatch_source_timer ()

@property (nonatomic, strong) dispatch_source_t timer; // 计时器

@property (nonatomic, assign) NSInteger timeIndex; // 计时时间

@property (nonatomic, assign) BOOL isTiming; // 是计时中吗

@property (nonatomic, copy) dispatch_source_timer_Block timer_Block;

@end

@implementation dispatch_source_timer

#pragma mark - 实例化
+ (dispatch_source_timer *)sharedInstance {
    static dispatch_source_timer *manage = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manage = [[dispatch_source_timer alloc] init];
    });
    return manage;
}
- (void)createTimer {
    WeakSelf(self);
    
    if (_timer) {
        [self StartTiming];
        dispatch_source_cancel(_timer);
    }
    
    self.isTiming = NO;
    
    self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0));
    uint64_t interval = (uint64_t)(1.0 * NSEC_PER_SEC);
    dispatch_source_set_timer(self.timer, DISPATCH_TIME_NOW, interval, 0);
    dispatch_source_set_event_handler(self.timer, ^{
        
        GCD_MAIN_QUEUE(^{
            weakSelf.timeIndex++;
            if (weakSelf.timer_Block) {
                weakSelf.timer_Block(weakSelf.timeIndex);
            }
        });
    });
}

#pragma mark - 初始化计时事件
- (void)initializeTiming:(NSInteger)timing andStartBlock:(void (^)(NSInteger))block {
    WeakSelf(self);
    
    [self createTimer];
    
    GCD_MAIN_QUEUE(^{
        weakSelf.timeIndex = timing;
        weakSelf.timer_Block = block;
    });
}

#pragma mark - 开始计时
- (void)StartTiming {
    if (!self.isTiming) {
        dispatch_resume(self.timer);
        self.isTiming = YES;
    }
}

#pragma mark - 暂停计时
- (void)PauseTiming {
    if (self.isTiming) {
        dispatch_suspend(self.timer);
        self.isTiming = NO;
    }
}

#pragma mark - 计数重置
- (void)CountReset {
    self.timeIndex = 0;
}

@end
