//
//  FBCurrentDataModel.h
//  FissionBluetooth
//
//  Created by 裂变智能 on 2021/2/18.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 当日实时测量数据｜Real time measurement data of the day
*/
@interface FBCurrentDataModel : NSObject

/**
 本次数据产生时间点，时间戳GMT秒｜Time point of data generation, time stamp GMT seconds
*/
@property (nonatomic, assign) NSInteger GMTtimeInterval;

/**
 GMT转年月日时分秒｜GMT to YYYY-MM-dd HH:mm:ss
*/
@property (nonatomic, copy) NSString *dateTimeStr;

/**
 当前累计步数｜Current cumulative steps
*/
@property (nonatomic, assign) NSInteger currentStep;

/**
 当前累计消耗卡路里（千卡）｜Current cumulative calories consumed (kcal)
*/
@property (nonatomic, assign) NSInteger currentCalories;

/**
 当前累计行程（米）｜Current cumulative travel (m)
*/
@property (nonatomic, assign) NSInteger currentDistance;

/**
 当前心率（次/分钟）｜Current heart rate (times / min)
*/
@property (nonatomic, assign) NSInteger currentHeartRate;

/**
 当前心率等级｜Current heart rate level
*/
@property (nonatomic, assign) FB_CURRENTHEARTRANGE HeartRateRange;

/**
 当前血氧（%）｜Current blood oxygen (%)
*/
@property (nonatomic, assign) NSInteger currentOxy;

/**
 当前血氧等级｜Current blood oxygen level
*/
@property (nonatomic, assign) FB_CURRENTOXYRANGE OxyRange;

/**
 当前电池电量（%）｜Current battery level (%)
*/
@property (nonatomic, assign) NSInteger batteryLevel;

/**
 当前收缩血压（高压，mmHg）｜Current systolic blood pressure (high pressure, mmHg)
*/
@property (nonatomic, assign) NSInteger currentShrinkBlood;

/**
 当前舒张血压（低压，mmHg）｜Current diastolic blood pressure (low pressure, mmHg)
*/
@property (nonatomic, assign) NSInteger currentDiastoleBlood;

/**
 当前累计运动时间（分钟）｜Current cumulative movement time (minutes)
*/
@property (nonatomic, assign) NSInteger currentSportTimes;

/**
 当前累计激烈运动时间（分钟）｜Current accumulated intense exercise time (minutes)
*/
@property (nonatomic, assign) NSInteger currentSportFierceTimes;

/**
 当前发生久坐累计时间（分钟）｜Current accumulated sitting time (minutes)
*/
@property (nonatomic, assign) NSInteger sittingTime;

/**
 当前久坐期间平均步数，步数/小时｜Average steps during current sedentary period, steps / hour
*/
@property (nonatomic, assign) NSInteger sittingStep;

/**
 当前的经度 (WGS-84)｜Current longitude (WGS-84)
*/
@property (nonatomic) float currentLongitude;

/**
 当前的纬度 (WGS-84)｜Current latitude (WGS-84)
*/
@property (nonatomic) float currentLatitude;

/**
 当天每小时步数曲线，一小时一笔，固定24笔｜Steps per hour curve of the day, one transaction per hour, 24 fixed transactions
 
 @note  第一笔为 0时～1时的步数，第二笔为1时～2时，以此类推...｜The first stroke is the number of steps from 0 hour to 1 hour, the second stroke is from 1 hour to 2 hours, and so on
*/
@property (nonatomic, strong) NSArray <NSNumber *> *currentStepCurve;

/**
 当前精神压力值｜Current stress value
*/
@property (nonatomic, assign) NSInteger currentStress;

/**
 当前精神压力等级｜Current stress level
*/
@property (nonatomic, assign) FB_CURRENTSTRESSRANGE StressRange;


@end

NS_ASSUME_NONNULL_END
