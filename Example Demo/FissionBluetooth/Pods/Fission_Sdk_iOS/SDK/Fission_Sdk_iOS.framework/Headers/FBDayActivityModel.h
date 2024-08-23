//
//  FBDayActivityModel.h
//  FissionBluetooth
//
//  Created by 裂变智能 on 2021/2/18.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 每日活动统计报告｜Daily activity statistics report
*/
@interface FBDayActivityModel : NSObject

/**
 时间戳GMT秒｜Time stamp GMT seconds
*/
@property (nonatomic, assign) NSInteger GMTtimeInterval;

/**
 GMT转年月日时分秒｜GMT to YYYY-MM-dd HH:mm:ss
*/
@property (nonatomic, copy) NSString *dateTimeStr;

/**
 结构体版本｜Structure version
*/
@property (nonatomic, assign) NSInteger structVersion;

/**
 当天的累计步数｜Cumulative steps of the day
*/
@property (nonatomic, assign) NSInteger totalSteps;

/**
 当天消耗的卡路里（千卡）｜Calories consumed that day (kcal)
*/
@property (nonatomic, assign) NSInteger totalCalories;

/**
 当天的累计行程（米）｜Cumulative itinerary of the day (m)
*/
@property (nonatomic, assign) NSInteger totalDistance;

/**
 当天的平均心率（次/分钟）｜Average heart rate of the day (times / min)
*/
@property (nonatomic, assign) NSInteger avgHeartRate;

/**
 当天最高心率（次/分钟）｜Maximum heart rate of the day (times / min)
*/
@property (nonatomic, assign) NSInteger maxHeartRate;

/**
 当天最低心率（次/分钟）｜Lowest heart rate of the day (times / min)
*/
@property (nonatomic, assign) NSInteger minHeartRate;

/**
 当天平均血氧（%）｜Average blood oxygen of the day (%)
*/
@property (nonatomic, assign) NSInteger avgOxy;

/**
 当天累计运动时间（分钟）｜Accumulated exercise time of the day (minutes)
*/
@property (nonatomic, assign) NSInteger totalSportTime;

/**
 当天激烈运动时间（分钟）｜Intense exercise time of the day (minutes)
*/
@property (nonatomic, assign) NSInteger voilentSportTime;

/**
 当天深度睡眠时间（分钟）｜Deep sleep time of the day (minutes)
*/
@property (nonatomic, assign) NSInteger deepSleeTime;

/**
 当天浅睡眠时间（分钟）｜Light sleep time of the day (minutes)
*/
@property (nonatomic, assign) NSInteger lightSleepTime;

/**
 当天睡眠眼动时间（分钟）｜Sleep eye movement time of the day (minutes)
*/
@property (nonatomic, assign) NSInteger eyeMoveTime;

/**
 当天最高血压（mmHg）｜Highest blood pressure of the day (mmHg)
*/
@property (nonatomic, assign) NSInteger maxBlood;

/**
 当天最低血压（mmHg）｜Lowest blood pressure of the day (mmHg)
*/
@property (nonatomic, assign) NSInteger minBlood;

/**
 当天最高精神压力值｜Maximum stress value of the day
*/
@property (nonatomic, assign) NSInteger maximumStress;

/**
 当天最高精神压力等级｜Maximum stress level of the day
*/
@property (nonatomic, assign) FB_CURRENTSTRESSRANGE StressRange;

@end

NS_ASSUME_NONNULL_END
