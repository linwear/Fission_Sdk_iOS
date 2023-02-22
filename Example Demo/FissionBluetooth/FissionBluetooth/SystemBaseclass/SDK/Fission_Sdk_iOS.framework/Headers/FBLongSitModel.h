//
//  FBLongSitModel.h
//  FissionBluetooth
//
//  Created by 裂变智能 on 2021/2/18.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
/*
 久坐提醒信息｜Sedentary reminder
*/
@interface FBLongSitModel : NSObject

/**
 久坐提醒开关 NO:关闭 YES:打开（默认YES）｜Sedentary reminder switch NO: off YES: on (Default: YES)
*/
@property (nonatomic, assign) BOOL enable;

/**
 检测起始时间，一天的绝对分钟（大于等于0分钟，小于1440分钟，起始时间小于结束时间）（默认480，即08:00）｜Detection start time, absolute minutes of a day (greater than or equal to 0 minutes, less than 1440 minutes, start time less than end time) (the default is 480, i.e. 08:00)
*/
@property (nonatomic, assign) NSInteger startTime;

/**
 检测结束时间，一天的绝对分钟（大于等于0分钟，小于1440分钟，结束时间大于起始时间）（默认1080，即18:00）｜Detection end time, absolute minutes of a day (greater than or equal to 0 minutes, less than 1440 minutes, end time greater than start time) (the default is 1080, i.e. 18:00)
*/
@property (nonatomic, assign) NSInteger endTime;

/**
 久坐持续时间检测时间（分钟），在这个时间内步数不达标，进行久坐提醒（默认45）｜The detection time of sedentary duration（minutes）. If the steps are not up to standard within this time, the sedentary reminder will be given (Default: 45)
*/
@property (nonatomic, assign) NSInteger continueTime;

/**
 目标步数，在持续时间内低于这个值，进行久坐提醒（默认100）｜If the target step number is lower than this value in the duration, the sedentary reminder will be given (Default: 100)
*/
@property (nonatomic, assign) NSInteger targetSteps;

@end

NS_ASSUME_NONNULL_END
