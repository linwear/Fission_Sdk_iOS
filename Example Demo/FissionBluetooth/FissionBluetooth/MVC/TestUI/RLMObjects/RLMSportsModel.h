//
//  RLMSportsModel.h
//  FissionBluetooth
//
//  Created by 裂变智能 on 2023/5/11.
//

#import "RLMBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface RLMSportsItemModel : RLMObject
/// 时间戳
@property NSInteger begin;
/// 步数
@property NSInteger step;
/// 距离 (单位：米)
@property NSInteger distance;
/// 卡路里 (单位: 千卡)
@property NSInteger calorie;
/// 配速(s/km)
@property NSInteger pace;
/// 运动心率(次/min)
@property NSInteger heartRate;
@end


RLM_COLLECTION_TYPE(RLMSportsItemModel)


@interface RLMSportsModel : RLMBaseModel

/// 时间戳，运动开始时间
@property NSInteger begin;

/// 时间戳，运动结束时间
@property NSInteger end;

/// 运动时长（秒）
@property NSInteger duration;

/// 运动总步数
@property NSInteger step;

/// 运动总卡路里（千卡）
@property NSInteger calorie;

/// 运动总距离（单位米，通过计步估算）
@property NSInteger distance;

/// 运动模式
@property FB_MOTIONMODE MotionMode;

/// 本次运动最大心率（次/分钟）
@property NSInteger maxHeartRate;

/// 本次运动最小心率（次/分钟）
@property NSInteger minHeartRate;

/// 本次运动平均心率，运动结束时计算，心率和/ 记录次数（次/分钟）
@property NSInteger avgHeartRate;

/// 本次运动最大步频（步/分钟）
@property NSInteger maxStride;

/// 本次运动平均步频 = 步频和/记录次数（步/分钟）
@property NSInteger avgStride;

/// 运动详细
@property RLMArray <RLMSportsItemModel> *items;


// * * * * * * * * * * * * * * * * * * * * * * * * * * * * 运动心率区间 * * * * * * * * * * * * * * * * * * * * * * * * * * * *
/// 热身运动时间，单位分钟
@property NSInteger heartRate_level_1;

/// 燃脂运动时间，单位分钟
@property NSInteger heartRate_level_2;

/// 有氧耐力运动时间，单位分钟
@property NSInteger heartRate_level_3;

/// 高强有氧运动时间，单位分钟
@property NSInteger heartRate_level_4;

/// 无氧运动时间，单位分钟
@property NSInteger heartRate_level_5;



/// 必须先设置上面👆begin，调用此方法快速设置 deviceName、deviceMAC、primaryKey_ID
- (void)QuickSetup;

@end

NS_ASSUME_NONNULL_END
