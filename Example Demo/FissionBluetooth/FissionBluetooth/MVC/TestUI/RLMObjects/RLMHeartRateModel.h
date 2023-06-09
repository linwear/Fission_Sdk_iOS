//
//  RLMHeartRateModel.h
//  FissionBluetooth
//
//  Created by 裂变智能 on 2023/5/11.
//

#import "RLMBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface RLMHeartRateModel : RLMBaseModel

/// 时间戳
@property NSInteger begin;

/// 心率值
@property NSInteger heartRate;



/// 必须先设置上面👆begin，调用此方法快速设置 deviceName、deviceMAC、primaryKey_ID
- (void)QuickSetup;

@end

NS_ASSUME_NONNULL_END
