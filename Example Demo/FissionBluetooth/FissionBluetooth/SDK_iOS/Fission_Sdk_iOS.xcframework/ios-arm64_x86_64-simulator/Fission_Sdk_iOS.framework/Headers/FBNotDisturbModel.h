//
//  FBNotDisturbModel.h
//  FissionBluetooth
//
//  Created by 裂变智能 on 2021/2/18.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
/*
 勿扰提醒信息｜Do not disturb reminder message
*/
@interface FBNotDisturbModel : NSObject

/**
 勿扰提醒起始时间，一天的绝对分钟（大于等于0分钟，小于1440分钟，起始时间小于结束时间）（默认360，即06:00）｜Do not disturb reminder start time, absolute minutes of a day (greater than or equal to 0 minutes, less than 1440 minutes, start time less than end time)
*/
@property (nonatomic, assign) NSInteger startTime;

/**
 勿扰提醒结束时间，一天的绝对分钟（大于等于0分钟，小于1440分钟，结束时间大于起始时间）（默认1260，即21:00）｜Do not disturb reminder end time, absolute minutes of a day (greater than or equal to 0 minutes, less than 1440 minutes, end time greater than start time)
*/
@property (nonatomic, assign) NSInteger endTime;

/**
 勿扰提醒开关，NO:关闭  YES:打开（默认NO）｜Reminder switch, NO: off, YES: on (Default: NO)
*/
@property (nonatomic, assign) BOOL alterSwitch;

@end

NS_ASSUME_NONNULL_END
