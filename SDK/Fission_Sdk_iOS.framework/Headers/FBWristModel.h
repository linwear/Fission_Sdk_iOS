//
//  FBWristModel.h
//  FissionBluetooth
//
//  Created by 裂变智能 on 2021/2/18.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 抬腕亮屏信息｜Wrist lifting light screen information
*/
@interface FBWristModel : NSObject

/**
 抬腕有效起始时间，当天的绝对分钟（大于等于0分钟，小于1440分钟，起始时间小于结束时间）（默认360，即06:00）｜Effective starting time of wrist lifting, absolute minutes of the day (greater than or equal to 0 minutes, less than 1440 minutes, start time less than end time)  (the default is 360, i.e. 06:00)
*/
@property (nonatomic, assign) NSInteger startTime;

/**
 抬腕有效结束时间，当天的绝对分钟（大于等于0分钟，小于1440分钟，结束时间大于起始时间）（默认1320，即22:00）｜Effective end time of wrist lifting, absolute minutes of the day (greater than or equal to 0 minutes, less than 1440 minutes, end time greater than start time)  (the default is 1320, i.e. 22:00)
*/
@property (nonatomic, assign) NSInteger endTime;

/**
 抬腕亮屏开关，NO:关闭  YES:打开（默认YES）｜Wrist lifting light screen switch, NO: off, 1: YES (Default: YES)
*/
@property (nonatomic, assign) BOOL alterSwitch;

@end

NS_ASSUME_NONNULL_END
