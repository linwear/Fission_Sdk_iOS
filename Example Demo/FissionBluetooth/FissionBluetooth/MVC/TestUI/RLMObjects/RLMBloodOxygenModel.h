//
//  RLMBloodOxygenModel.h
//  FissionBluetooth
//
//  Created by 裂变智能 on 2023/5/11.
//

#import "RLMBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface RLMBloodOxygenModel : RLMBaseModel

/// 时间戳
@property NSInteger begin;

/// 血氧值
@property NSInteger bloodOxygen;



/// 必须先设置上面👆begin，调用此方法快速设置 deviceName、deviceMAC、primaryKey_ID
- (void)QuickSetup;

@end

NS_ASSUME_NONNULL_END
