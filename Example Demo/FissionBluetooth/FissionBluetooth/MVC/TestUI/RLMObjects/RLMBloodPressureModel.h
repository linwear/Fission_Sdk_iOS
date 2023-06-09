//
//  RLMBloodPressureModel.h
//  FissionBluetooth
//
//  Created by 裂变智能 on 2023/5/11.
//

#import "RLMBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface RLMBloodPressureModel : RLMBaseModel

/// 时间戳
@property NSInteger begin;

/// 收缩压（高压，mmHg）
@property NSInteger systolic;

/// 舒张压（低压，mmHg）
@property NSInteger diastolic;



/// 必须先设置上面👆begin，调用此方法快速设置 deviceName、deviceMAC、primaryKey_ID
- (void)QuickSetup;

@end

NS_ASSUME_NONNULL_END
