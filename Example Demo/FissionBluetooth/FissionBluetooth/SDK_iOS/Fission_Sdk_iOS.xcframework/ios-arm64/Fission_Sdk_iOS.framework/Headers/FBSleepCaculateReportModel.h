//
//  FBSleepCaculateReportModel.h
//  FissionBluetooth
//
//  Created by 裂变智能 on 2021/2/18.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
/*
 睡眠统计报告｜Sleep statistics report
*/
@interface FBSleepCaculateReportModel : NSObject

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
 本次开始睡觉时间，GMT秒｜Time to go to bed this time, GMT seconds
*/
@property (nonatomic, assign) NSInteger startSleepTime;

/**
 本次开始睡觉时间，GMT转年月日时分秒｜Time to go to bed this time, GMT to YYYY-MM-dd HH:mm:ss
*/
@property (nonatomic, copy) NSString *startDateTimerStr;

/**
 本次结束睡觉时间，GMT秒｜The end of the sleep time, GMT seconds
*/
@property (nonatomic, assign) NSInteger endSleepTime;

/**
 本次结束睡觉时间，GMT转年月日时分秒｜The end of the sleep time, GMT to YYYY-MM-dd HH:mm:ss
*/
@property (nonatomic, copy) NSString *endDateTimerStr;

/**
 本次睡眠持续总时间（分钟）｜Total sleep duration (minutes)
*/
@property (nonatomic, assign) NSInteger continueSleepTime;

/**
 本次睡眠清醒累计时间（分钟）｜Cumulative time of waking up in this sleep (minutes)
*/
@property (nonatomic, assign) NSInteger awakeTime;

/**
 本次睡眠浅睡累计时间（分钟）｜Cumulative time of light sleep (minutes)
*/
@property (nonatomic, assign) NSInteger lightSleepTime;

/**
 本次睡眠深睡累计时间（分钟）｜Cumulative time of deep sleep (minutes)
*/
@property (nonatomic, assign) NSInteger deepSleepTime;

/**
 本次睡眠眼动累计时间（分钟）｜Cumulative time of eye movement in this sleep (minutes)
*/
@property (nonatomic, assign) NSInteger eyeMoveTime;

/**
 本次睡眠时最大血氧（%）｜Maximum blood oxygen during this sleep (%)
*/
@property (nonatomic, assign) NSInteger maxOxy;

/**
 本次睡眠时最小血氧（%）｜Minimum blood oxygen during this sleep (%)
*/
@property (nonatomic, assign) NSInteger minOxy;

/**
 本次睡眠时最大心率（次/分钟）｜Maximum heart rate during this sleep (times / min)
*/
@property (nonatomic, assign) NSInteger maxHeartRate;

/**
 本次睡眠时最小心率（次/分钟）｜Minimum heart rate during this sleep (times / min)
*/
@property (nonatomic, assign) NSInteger minHeartRate;

/**
 本次睡眠零星小睡累计时间（分钟）｜Cumulative time of this sporadic nap (minutes)
*/
@property (nonatomic, assign) NSInteger sporadicNapTime;

@end

NS_ASSUME_NONNULL_END
