//
//  RLMManualMeasureModel.h
//  FissionBluetooth
//
//  Created by 裂变智能 on 2023/5/11.
//

#import "RLMBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface RLMManualMeasureModel : RLMBaseModel

/// 时间戳
@property (nonatomic) NSInteger begin;

/// 心率值
@property (nonatomic) NSInteger hr;

/// 血氧值
@property (nonatomic) NSInteger Sp02;

/// 收缩压（高压，mmHg）
@property (nonatomic) NSInteger systolic;

/// 舒张压（低压，mmHg）
@property (nonatomic) NSInteger diastolic;

/// 精神压力值
@property (nonatomic) NSInteger stress;

/// 精神压力等级
@property (nonatomic) FB_CURRENTSTRESSRANGE StressRange;



/// 必须先设置上面👆begin，调用此方法快速设置 deviceName、deviceMAC、primaryKey_ID
- (void)QuickSetup;

@end

NS_ASSUME_NONNULL_END
