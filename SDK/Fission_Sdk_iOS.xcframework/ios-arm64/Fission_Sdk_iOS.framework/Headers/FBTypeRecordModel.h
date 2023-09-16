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
 类型记录/报告（公共类，recordArray内容具体参考枚举值 FB_RECORDTYPE）｜Type record/report (public class, the content of recordArray refers to the enumeration value FB_RECORDTYPE)
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
 记录生成周期（单位秒；之前部分记录周期以分钟为单位，从v3.1.5版本开始统一以秒为单位）｜Record generation cycle (in seconds; the previous part of the record cycle was in minutes, and it is unified in seconds since v3.1.5)
*/
@property (nonatomic, assign) NSInteger recordingCycle;

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
 记录格式定义｜Record Format Definition
*/
@property (nonatomic, assign) NSInteger recordDefinition;

/**
 类型记录数组｜Type record array
*/
@property (nonatomic, strong) NSArray <FBRecordDetailsModel *> *recordArray;

@end

NS_ASSUME_NONNULL_END
