//
//  FBFemalePhysiologyModel.h
//  FissionBluetooth
//
//  Created by 裂变智能 on 2021/6/1.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 女性生理周期信息｜Female physiological cycle information
*/
@interface FBFemalePhysiologyModel : NSObject

/**
 健康模式设置｜Health mode setting
*/
@property (nonatomic, assign) FB_FEMALEPHYSIOLOGICALHEALTHMODEL HealthModel;

/**
 经期开始提醒提前天数，范围1-3天 ｜The number of days in advance of menstruation start reminder, ranging from 1 to 3 days
*/
@property (nonatomic, assign) NSInteger daysInAdvance;

/**
 经期的天数，范围3-15天｜The number of days of menstruation, ranging from 3 to 15 days
*/
@property (nonatomic, assign) NSInteger daysMenstruation;

/**
 周期长度，范围17-60天｜Cycle length, ranging from 17 to 60 days
*/
@property (nonatomic, assign) NSInteger cycleLength;

/**
 最近一次月经，年（最近两年）｜Last menstruation, year (last two years)
*/
@property (nonatomic, assign) NSInteger lastYear;

/**
 最近一次月经，月｜Last menstruation, month
*/
@property (nonatomic, assign) NSInteger lastMonth;

/**
 最近一次月经，日｜The last menstruation, day
*/
@property (nonatomic, assign) NSInteger lastDay;

/**
 孕期提醒方式：NO提示已怀孕天数，YES提示距离预产期天数｜Pregnancy reminder: no indicates the number of days pregnant, yes indicates the number of days away from the expected delivery date
*/
@property (nonatomic, assign) BOOL isPreProduction;

/**
 提醒时间，小时｜Reminder time, hours
*/
@property (nonatomic, assign) NSInteger reminderHours;

/**
 提醒时间，分钟｜Reminder time, minutes
*/
@property (nonatomic, assign) NSInteger reminderMinutes;

/**
 设备提醒开关，NO关，YES开｜Device reminder switch, no off, yes on
*/
@property (nonatomic, assign) BOOL reminderSwitch;

@end

NS_ASSUME_NONNULL_END
