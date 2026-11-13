//
//  FBSleepStateModel.h
//  FissionBluetooth
//
//  Created by 裂变智能 on 2021/2/19.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 睡眠状态详细｜Sleep status details
*/
@interface FBSleepStateModel : NSObject

/**
 睡眠状态起始时间戳GMT秒｜Sleep state start timestamp GMT seconds
*/
@property (nonatomic, assign) NSInteger startStatusGMT;

/**
 起始GMT转年月日时分秒｜From GMT to YYYY-MM-dd HH:mm:ss
*/
@property (nonatomic, copy) NSString *startDateTimeStr;

/**
 睡眠状态结束时间戳GMT秒｜Sleep state end timestamp GMT seconds
*/
@property (nonatomic, assign) NSInteger endStatusGMT;

/**
 结束GMT转年月日时分秒｜End GMT to YYYY-MM-dd HH:mm:ss
*/
@property (nonatomic, copy) NSString *endDateTimeStr;

/**
 睡眠状态｜Sleep state
*/
@property (nonatomic, assign) FB_SLEEPSTATE SleepStatus;

/**
 持续睡眠时间（分钟）｜Duration of sleep (minutes)
*/
@property (nonatomic, assign) NSInteger durationSleepTime;

@end

NS_ASSUME_NONNULL_END
