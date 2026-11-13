//
//  FBStreamDataModel.h
//  FissionBluetooth
//
//  Created by 裂变智能 on 2021/2/22.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 流数据-健康｜Streaming Data - Health
*/
@interface FBStreamDataModel : NSObject

/**
 流帧计数，自动递增，0-255，溢出后清零｜Stream frame count, auto increment, 0-255, clear after overflow
*/
@property (nonatomic, assign) NSInteger streamCount;

/**
 当前心率（次/分钟）｜Current heart rate (times / minute)
*/
@property (nonatomic, assign) NSInteger currentHeartRate;

/**
 当前心率等级｜Current heart rate level
*/
@property (nonatomic, assign) FB_CURRENTHEARTRANGE HeartRateRange;

/**
 当前累计步数｜Current cumulative steps
*/
@property (nonatomic, assign) NSInteger currentStepCount;

/**
 当前累计距离（米）｜Current cumulative distance (m)
*/
@property (nonatomic, assign) NSInteger currentDistance;

/**
 当前累计消耗卡路里（千卡）｜Current cumulative calories consumed (kcal)
*/
@property (nonatomic, assign) NSInteger currentCalories;

@end

NS_ASSUME_NONNULL_END
