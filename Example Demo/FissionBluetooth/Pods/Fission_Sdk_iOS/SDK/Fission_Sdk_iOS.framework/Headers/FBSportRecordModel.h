//
//  FBSportRecordModel.h
//  FissionBluetooth
//
//  Created by 裂变智能 on 2021/2/18.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 运动记录列表｜Sports record list
*/
@interface FBSportRecordModel : NSObject

/**
 时间戳GMT秒｜Time stamp GMT seconds
*/
@property (nonatomic, assign) NSInteger GMTtimeInterval;

/**
 GMT转年月日时分秒｜GMT to YYYY-MM-dd HH:mm:ss
*/
@property (nonatomic, copy) NSString *dateTimeStr;

/**
 结构体版本｜Structure version
*/
@property (nonatomic, assign) NSInteger structVersion;

/**
 开始运动时间，GMT秒｜Start time of exercise, GMT seconds
*/
@property (nonatomic, assign) NSInteger startSportTime;

/**
 开始运动时间，GMT转年月日时分秒｜Start time of exercise, GMT to YYYY-MM-dd HH:mm:ss
*/
@property (nonatomic, copy) NSString *startDateTimerStr;

/**
 结束运动时间，GMT秒｜End exercise time, GMT seconds
*/
@property (nonatomic, assign) NSInteger endSportTime;

/**
 结束运动时间，GMT转年月日时分秒｜End exercise time, GMT to YYYY-MM-dd HH:mm:ss
*/
@property (nonatomic, copy) NSString *endDateTimerStr;

/**
 运动模式｜Motion mode
*/
@property (nonatomic, assign) FB_MOTIONMODE MotionMode;

@end

NS_ASSUME_NONNULL_END
