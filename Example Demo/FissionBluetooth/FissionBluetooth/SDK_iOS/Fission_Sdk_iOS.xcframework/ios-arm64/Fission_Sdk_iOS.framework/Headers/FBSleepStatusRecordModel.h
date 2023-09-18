//
//  FBSleepStatusRecordModel.h
//  FissionBluetooth
//
//  Created by 裂变智能 on 2021/2/18.
//

#import <Foundation/Foundation.h>
#import "FBSleepStateModel.h"

NS_ASSUME_NONNULL_BEGIN
/*
 睡眠状态记录｜Sleep state recording
*/
@interface FBSleepStatusRecordModel : NSObject

/**
 时间戳GMT秒｜Time stamp GMT seconds
*/
@property (nonatomic, assign) NSInteger GMTtimeInterval;

/**
 GMT转年月日时分秒｜GMT to YYYY-MM-dd HH:mm:ss
*/
@property (nonatomic, copy) NSString *dateTimeStr;

/**
 结构体版本，0:不支持眼动，1:支持眼动｜Structure version, 0: eye movement is not supported, 1: eye movement is supported
*/
@property (nonatomic, assign) NSInteger structVersion;

/**
 是否有零星小睡，YES:有零星小睡，NO:无零星小睡 ｜Whether there are sporadic naps, yes: sporadic naps, No: no sporadic naps
*/
@property (nonatomic, assign) BOOL isNap;

/**
 零星小睡数据的偏移位置长度｜Offset position length of sporadic nap data
*/
@property (nonatomic, assign) NSInteger napDataOffset;

/**
 开始睡眠时间，GMT秒｜Sleep start time, GMT seconds
*/
@property (nonatomic, assign) NSInteger startSleepTime;

/**
 开始睡眠时间，GMT转年月日时分秒｜Sleep start time, GMT to YYYY-MM-dd HH:mm:ss
*/
@property (nonatomic, copy) NSString *startDateTimerStr;

/**
 睡眠结束时间，GMT秒｜Sleep end time, GMT seconds
*/
@property (nonatomic, assign) NSInteger endSleepTime;

/**
 睡眠结束时间，GMT转年月日时分秒｜Sleep end time, GMT to YYYY-MM-dd HH:mm:ss
*/
@property (nonatomic, copy) NSString *endDateTimerStr;

/**
 当天深度睡眠时间（分钟）｜Deep sleep time of the day (minutes)
*/
@property (nonatomic, assign) NSInteger deepSleepTime;

/**
 当天浅睡时间（分钟）｜Light sleep time of the day (minutes)
*/
@property (nonatomic, assign) NSInteger lightSleepTime;

/**
 当天眼动时间（分钟）｜Eye movement time of the day (minutes)
*/
@property (nonatomic, assign) NSInteger eyeMoveTime;

/**
睡眠状态数组有效长度｜Effective length of sleep state array
*/
@property (nonatomic, assign) NSInteger EffectiveLength;

/**
 夜间睡眠状态数组｜Night sleep status array
*/
@property (nonatomic, strong) NSArray <FBSleepStateModel *> *sleepStateArray;

/**
 零星小睡状态数组｜Sporadic nap status array
*/
@property (nonatomic, strong) NSArray <FBSleepStateModel *> *napStateArray;

@end

NS_ASSUME_NONNULL_END
