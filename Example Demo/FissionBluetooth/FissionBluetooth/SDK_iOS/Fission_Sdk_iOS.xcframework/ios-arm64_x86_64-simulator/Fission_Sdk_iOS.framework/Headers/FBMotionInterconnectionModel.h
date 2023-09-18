//
//  FBMotionInterconnectionModel.h
//  FissionBluetooth
//
//  Created by 裂变智能 on 2021/11/15.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
/*
 GPS运动互联数据交互信息｜Interactive information of GPS motion interconnection data
 */
@interface FBMotionInterconnectionModel : NSObject


#pragma mark - 以下数据由APP提供填充｜The following data is filled in by app
/** 当前时间(UTC)｜Current time (UTC) */
@property (nonatomic, assign) NSInteger currentTimeUTC;

/** 运动ID，用运动的开始时间作为每笔运动的唯一识别码｜Motion ID, using the start time of the motion as the unique identification code of each motion */
@property (nonatomic, assign) NSInteger motionID;

/** 运动开始时间戳(UTC)｜Motion start timestamp (UTC) */
@property (nonatomic, assign) NSInteger startMotionUTC;

/** 运动结束时间(UTC)，进行中的运动填0 ｜Motion end time (UTC), fill in 0 for ongoing exercise */
@property (nonatomic, assign) NSInteger endMotionUTC;

/** 当前运动总时间，单位秒｜Total current movement time, in seconds */
@property (nonatomic, assign) NSInteger totalTime;

/** 当前运动总卡路里（千卡）｜Total calories of current exercise (kcal) */
@property (nonatomic, assign) NSInteger totalCalories;

/** 当前本次运动轨迹运动距离（单位米，通过gps定位计算）｜Motion distance of current trajectory (unit: m, calculated by GPS positioning) */
@property (nonatomic, assign) NSInteger motionDistance;

/** 运动模式｜Motion mode  */
@property (nonatomic, assign) FB_MOTIONMODE MotionMode;

/** 本次运动最大步频（单位：步/分钟） ｜Maximum step frequency of this movement (unit: step / minute) */
@property (nonatomic, assign) NSInteger maxStepFrequency;

/** 本次运动平均步频 =步数/时间（单位：步/分钟）｜Average step frequency of this exercise = steps / time (unit: steps / minute) */
@property (nonatomic, assign) NSInteger avgStepFrequency;

/** 重复运动的周期数（来回次数，圈数）（单位：圈）｜Number of cycles of repeated motion (number of turns, turns) (unit: turns) */
@property (nonatomic, assign) NSInteger cyclesNumber;

/** 本次运动最大速度（单位：米/秒）｜Maximum speed of this movement (unit: M / s) */
@property (nonatomic, assign) CGFloat maxSpeed;

/** 本次运动平均速度 = 距离/用时（单位：米/秒）｜Average speed of this movement = distance / time (unit: M / s) */
@property (nonatomic, assign) CGFloat avgSpeed;

/** 本次有轨迹运动配速（单位：秒/公里）｜This time there is track movement pace (unit: S / km) */
@property (nonatomic, assign) NSInteger trackPace;


#pragma mark - 以下数据APP或手表由提供（双方都有权修改）｜The following data is provided by app or watch (both parties have the right to modify)
/** 中途休息次数｜Number of breaks */
@property (nonatomic, assign) NSInteger breaksNumber;

/** 运动状态，0停止，1进行中，2暂停（表明当前运动状态，非控制指令）｜Motion state, 0 stop, 1 in progress, 2 pause (indicating current motion state, non control command) */
@property (nonatomic, assign) NSInteger motionState;


#pragma mark - 以下数据由手表填充返回，APP无需设置｜The following data is filled and returned by the watch. App does not need to be set
/** 当前运动总步数｜Total current motion steps */
@property (nonatomic, assign) NSInteger totalSteps;

/** 本次运动当前实时心率（单位：次/分钟）｜Current real-time heart rate during this exercise (unit: times / minute) */
@property (nonatomic, assign) NSInteger currentHeartRate;

/** 本次运动最大心率（单位：次/分钟）｜Maximum heart rate of this exercise (unit: times / minute) */
@property (nonatomic, assign) NSInteger maxHeartRate;

/** 本次运动最小心率（单位：次/分钟）｜Minimum heart rate of this exercise (unit: times / minute) */
@property (nonatomic, assign) NSInteger minHeartRate;

/** 本次运动实时平均心率（单位：次/分钟）｜Real time average heart rate of this exercise (unit: times / minute) */
@property (nonatomic, assign) NSInteger avgHeartRate;

/** 当前心率处于的区间（热身，燃脂，有氧，高强有氧，无氧）｜The range of current heart rate (warm-up, fat burning, aerobic, high-strength aerobic, anaerobic) */
@property (nonatomic, assign) FB_MOTIONHEARTRATERANGE currentHrRange;

/** 到当前为止，热身运动时间，单位分钟，随时刷新｜Up to now, the warm-up exercise time, in minutes, is refreshed at any time */
@property (nonatomic, assign) NSInteger heartRate_level_1;

/** 到当前为止，燃脂运动时间，单位分钟，随时刷新｜Up to now, the fat burning movement time, in minutes, can be refreshed at any time */
@property (nonatomic, assign) NSInteger heartRate_level_2;

/** 到当前为止，有氧耐力运动时间，单位分钟，随时刷新｜So far, aerobic endurance exercise time, in minutes, can be refreshed at any time */
@property (nonatomic, assign) NSInteger heartRate_level_3;

/** 到当前为止，高强有氧运动时间，单位分钟，随时刷新｜So far, the time of high-strength aerobic exercise, in minutes, can be refreshed at any time */
@property (nonatomic, assign) NSInteger heartRate_level_4;

/** 到当前为止，无氧运动时间，单位分钟，随时刷新｜So far, the anaerobic exercise time, in minutes, can be refreshed at any time */
@property (nonatomic, assign) NSInteger heartRate_level_5;

@end

NS_ASSUME_NONNULL_END
