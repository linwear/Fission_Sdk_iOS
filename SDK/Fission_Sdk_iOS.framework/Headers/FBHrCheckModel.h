//
//  FBHrCheckModel.h
//  FissionBluetooth
//
//  Created by 裂变智能 on 2021/2/18.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
/*
 心率检测信息，为全天候检测，建议只可修改提醒周期｜The heart rate detection information is all-weather detection, and it is recommended that only the reminder cycle can be modified
*/
@interface FBHrCheckModel : NSObject

/**
 心率检测起始时间，一天的绝对分钟（大于等于0分钟，小于1440分钟，起始时间小于结束时间）｜Start time of heart rate detection, absolute minutes of a day (greater than or equal to 0 minutes, less than 1440 minutes, start time less than end time)
*/
@property (nonatomic, assign) NSInteger startTime;

/**
 心率检测结束时间，一天的绝对分钟（大于等于0分钟，小于1440分钟，结束时间大于起始时间）｜End time of heart rate detection, absolute minutes of a day (greater than or equal to 0 minutes, less than 1440 minutes, end time greater than start time)
*/
@property (nonatomic, assign) NSInteger endTime;

/**
 心率检测周期，分钟，如果为 0 只检测一次，为10的整倍数｜Heart rate detection cycle, minutes, if it is 0, only detect once, it is an integral multiple of 10
*/
@property (nonatomic, assign) NSInteger repeatCount;

/**
 自动检测开关，NO:关闭  YES:打开｜Automatic detection switch, NO: off, YES: on
*/
@property (nonatomic, assign) BOOL alterSwitch;

@end

NS_ASSUME_NONNULL_END
