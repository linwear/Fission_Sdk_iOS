//
//  FBHourReportModel.h
//  FissionBluetooth
//
//  Created by 裂变智能 on 2021/2/18.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
/*
 整点活动统计报告｜Statistical report of on-time activities
*/
@interface FBHourReportModel : NSObject

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
 到此刻为止的累计计步数｜Cumulative steps up to now
*/
@property (nonatomic, assign) NSInteger hourStep;

/**
 到此刻为止的累计行走距离（米）｜Accumulated walking distance up to now (m)
*/
@property (nonatomic, assign) NSInteger hourdDistance;

/**
 到此刻为止的累计消耗卡路里（千卡）｜Cumulative calories burned so far (kcal)
*/
@property (nonatomic, assign) NSInteger hourCalories;

@end

NS_ASSUME_NONNULL_END
