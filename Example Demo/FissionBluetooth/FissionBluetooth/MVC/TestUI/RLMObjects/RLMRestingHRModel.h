//
//  RLMRestingHRModel.h
//  FissionBluetooth
//
//  Created by 裂变智能 on 2023-10-21.
//

#import "RLMBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface RLMRestingHRModel : RLMBaseModel

/// 时间戳
@property (nonatomic) NSInteger begin;

/// 静息心率值
@property (nonatomic) NSInteger restingHR;



/// 必须先设置上面👆begin，调用此方法快速设置 deviceName、deviceMAC、primaryKey_ID
- (void)QuickSetup;

@end

NS_ASSUME_NONNULL_END
