//
//  FBWaterClockModel.h
//  FissionBluetooth
//
//  Created by 裂变智能 on 2021/2/18.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
/*
 喝水提醒信息｜Water drinking reminder information
*/
@interface FBWaterClockModel : NSObject

/**
 提醒起始时间，一天的绝对分钟（大于等于0分钟，小于1440分钟，起始时间小于结束时间）（默认480，即08:00）｜Reminder start time, absolute minutes of a day (greater than or equal to 0 minutes, less than 1440 minutes, start time less than end time) (the default is 480, i.e. 08:00)
*/
@property (nonatomic, assign) NSInteger startTime;

/**
 提醒结束时间，一天的绝对分钟（大于等于0分钟，小于1440分钟，结束时间大于起始时间）（默认1080，即18:00）｜Reminder end time, absolute minutes of a day (greater than or equal to 0 minutes, less than 1440 minutes, end time greater than start time) (the default is 1080, i.e. 18:00)
*/
@property (nonatomic, assign) NSInteger endTime;

/**
 提醒周期，如果为 0 只提醒一次（默认60）｜Reminder cycle, if it is 0, only remind once  (Default: 60)
*/
@property (nonatomic, assign) NSInteger repeatCount;

/**
 提醒开关，NO:关闭  YES:打开（默认YES）｜Reminder switch, NO: off, YES: on (Default: YES)
*/
@property (nonatomic, assign) BOOL alterSwitch;

@end

NS_ASSUME_NONNULL_END
