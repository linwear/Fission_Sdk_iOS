//
//  FBSportCaculateModel.h
//  FissionBluetooth
//
//  Created by 裂变智能 on 2021/2/18.
//

#import <Foundation/Foundation.h>
#import "FBSportPauseModel.h"

NS_ASSUME_NONNULL_BEGIN

/**
 运动统计报告｜Sports statistics report
*/
@interface FBSportCaculateModel : NSObject

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
 运动开始时间戳，作为每笔运动的唯一识别id， GMT秒｜The movement start time stamp is used as the unique identification ID of each movement, GMT seconds.
 */
@property (nonatomic, assign) NSInteger startSportTime;

/**
 运动开始时间，GMT转年月日时分秒｜Start time of exercise, GMT to YYYY-MM-dd HH:mm:ss
 */
@property (nonatomic, copy) NSString *startDateTimerStr;

/**
 运动结束时间戳，GMT秒｜Movement end timestamp, GMT seconds
 */
@property (nonatomic, assign) NSInteger endSportTime;

/**
 运动结束时间，GMT转年月日时分秒｜End time of exercise, GMT to YYYY-MM-dd HH:mm:ss
 */
@property (nonatomic, copy) NSString *endDateTimerStr;

/**
 运动总时间（秒）｜Total exercise time (seconds)
 */
@property (nonatomic, assign) NSInteger totalSportTime;

/**
 运动总步数｜Total movement steps
 */
@property (nonatomic, assign) NSInteger totalSteps;

/**
 运动总卡路里（千卡）｜Total exercise calories (kcal)
 */
@property (nonatomic, assign) NSInteger totalCalories;

/**
 运动总距离（单位米，通过计步估算）｜Total distance of movement (in meters, estimated by steps)
 */
@property (nonatomic, assign) NSInteger totalDistance;

/**
 本次运动轨迹运动距离（单位米，通过gps定位 计算）｜The movement distance of this movement track (unit: m, calculated by GPS positioning)
 */
@property (nonatomic, assign) NSInteger gpsDistance;

/**
 运动模式｜Motion mode
 */
@property (nonatomic, assign) FB_MOTIONMODE MotionMode;

/**
 本次运动最大心率（次/分钟）｜Maximum heart rate of this exercise (times / min)
 */
@property (nonatomic, assign) NSInteger maxHeartRate;

/**
 本次运动最小心率（次/分钟）｜Minimum heart rate of this exercise (times / min)
 */
@property (nonatomic, assign) NSInteger minHeartRate;

/**
 本次运动平均心率，运动结束时计算，心率和/ 记录次数（次/分钟）｜Average heart rate of the exercise, calculated at the end of the exercise, heart rate and / or record times (times / minute)
 */
@property (nonatomic, assign) NSInteger avgHeartRate;

/**
 本次运动最大步频（步/分钟）｜Maximum stride frequency (step / min)
 */
@property (nonatomic, assign) NSInteger maxStride;

/**
 本次运动平均步频 = 步频和/记录次数（步/分钟）｜Average stride frequency = stride frequency and / or recording times (step / minute)
 */
@property (nonatomic, assign) NSInteger avgStride;

/**
 运动次数，中途休息次数｜Number of exercises, number of breaks
 */
@property (nonatomic, assign) NSInteger breakTimes;

/**
 中断UTC记录，同时用于统计运动总时间｜The UTC record is interrupted and used to count the total movement time at the same time
 */
@property (nonatomic, strong) NSArray <FBSportPauseModel *> *sportPauseArray;

/**
 本次运动最大速度(单位:米/秒)｜Maximum speed of this movement (unit: M / s)
 */
@property (nonatomic, assign) NSInteger maxSpeed;

/**
 本次运动平均速度 = 距离/用时（米/秒）｜Average speed of this movement = distance / time (M / s)
 */
@property (nonatomic, assign) NSInteger avgSpeed;

/**
 本次无轨迹运动平均配速（秒/公里）｜Average speed of this trackless movement (s / km)
 */
@property (nonatomic, assign) NSInteger noTrackAvgSpeed;

/**
 本次有轨迹运动配速（秒/公里）｜This time, there is track movement speed (s / km)
 */
@property (nonatomic, assign) NSInteger trackAvgSpeed;

/**
 重复运动的周期数(来回次数，圈数，游泳趟数)(单位: 圈)｜The number of repetitive exercise cycles (number of rounds, laps, swimming laps) (unit: laps)
 */
@property (nonatomic, assign) NSInteger sportRepeatCount;

/**
 摆臂次数，划水次数(单位:次)｜Arm swing times, stroke times (unit: Times)
 */
@property (nonatomic, assign) NSInteger armSwingTimes;

/**
 热身运动时间，单位分钟｜Warm-up time in minutes
 */
@property (nonatomic, assign) NSInteger heartRate_level_1;

/**
 燃脂运动时间，单位分钟｜Fat burning exercise time in minutes
 */
@property (nonatomic, assign) NSInteger heartRate_level_2;

/**
 有氧运动时间，单位分钟｜Aerobic exercise time in minutes
 */
@property (nonatomic, assign) NSInteger heartRate_level_3;

/**
 无氧运动时间，单位分钟｜Anaerobic exercise time in minutes
 */
@property (nonatomic, assign) NSInteger heartRate_level_4;

/**
 极限运动时间，单位分钟｜Extreme exercise time in minutes
 */
@property (nonatomic, assign) NSInteger heartRate_level_5;

/**
 游泳泳姿（仅游泳运动有效）｜Swimming strokes (valid only for swimming)
 */
@property (nonatomic, assign) FB_SWIMMINGSTROKES swimmingStrokes;

/**
 游泳效率 = 时间（秒）+ 次数（仅游泳运动有效）｜Swimming efficiency = time (seconds) + number of times (valid only for swimming)
 */
@property (nonatomic, assign) NSInteger swimmingEfficiency;

/**
 泳池长度（厘米，仅游泳运动有效）｜Pool length (cm, valid only for swimming)
 */
@property (nonatomic, assign) NSInteger poolLength;

/**
 平均划水频率，单位：次/分钟｜Average stroke rate, unit: strokes/minute
 */
@property (nonatomic, assign) NSInteger avgStrokeRate;

@end

NS_ASSUME_NONNULL_END
