//
//  RLMSleepModel.h
//  FissionBluetooth
//
//  Created by 裂变智能 on 2023/5/11.
//

#import "RLMBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef enum {
    RLM_Awake       = 0, // 清醒
    RLM_Shallow     = 1, // 浅睡
    RLM_Deep        = 2, // 深睡
    RLM_REM         = 3, // 快速眼动
    RLM_Nap         = 4, // 零星小睡
    RLM_Nap_Awake   = 5  // 零星小睡（清醒状态）
}RLMSLEEPSTATE;

@interface RLMSleepModel : RLMBaseModel

/// 时间戳，睡眠状态开始
@property NSInteger begin;

/// 时间戳，睡眠状态结束
@property NSInteger end;

/// 睡眠状态时长（分钟）
@property NSInteger duration;

/// 睡眠状态
@property RLMSLEEPSTATE SleepState;



/// 必须先设置上面👆begin，调用此方法快速设置 deviceName、deviceMAC、primaryKey_ID
- (void)QuickSetup;

@end

NS_ASSUME_NONNULL_END
