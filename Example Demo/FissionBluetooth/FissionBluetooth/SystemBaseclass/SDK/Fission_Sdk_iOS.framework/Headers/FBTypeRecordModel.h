//
//  FBTypeRecordModel.h
//  FissionBluetooth
//
//  Created by 裂变智能 on 2021/2/20.
//

#import <Foundation/Foundation.h>
#import "FBRecordDetailsModel.h"

NS_ASSUME_NONNULL_BEGIN
/*
 类型记录/报告｜Type record / Report
*/
@interface FBTypeRecordModel : NSObject

/**
 第一条记录(结构体)的形成时间戳GMT秒｜Time stamp GMT seconds
*/
@property (nonatomic, assign) NSInteger GMTtimeInterval;

/**
 GMT转年月日时分秒｜GMT to YYYY-MM-dd HH:mm:ss
*/
@property (nonatomic, copy) NSString *dateTimeStr;

/**
 本次运动的开始时间戳GMT秒（仅FB_RECORDTYPE类型为：FB_SportsRecord、FB_MotionGpsRecord、FB_HFHeartRecord 时 有值）｜The start time stamp of this exercise in GMT seconds (Only available when the FB_RECORDTYPE type is: FB_SportsRecord, FB_MotionGpsRecord, FB_HFHeartRecord)
*/
@property (nonatomic, assign) NSInteger sportTimeStamp;

/**
 记录生成周期（仅FB_RECORDTYPE类型为：FB_SportsRecord、FB_MotionGpsRecord、FB_HFHeartRecord 时，单位为秒；其他时，单位为分钟）｜Record generation cycle (only when the FB_RECORDTYPE type is: FB_SportsRecord, FB_MotionGpsRecord, FB_HFHeartRecord, the unit is seconds; for others, the unit is minutes)
*/
@property (nonatomic, assign) NSInteger createTimes;

/**
 有效记录条数｜Number of effective records
*/
@property (nonatomic, assign) NSInteger EffectiveRecord;

/**
 单条记录长度｜Length of single record
*/
@property (nonatomic, assign) NSInteger recordLength;

/**
 记录类型｜Record type 
*/
@property (nonatomic, assign) FB_RECORDTYPE RecordType;

/**
 类型记录数组｜Type record array
*/
@property (nonatomic, strong) NSArray <FBRecordDetailsModel *> *recordArray;

@end

NS_ASSUME_NONNULL_END
