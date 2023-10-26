//
//  FBLoadDataObject.h
//  FissionBluetooth
//
//  Created by 裂变智能 on 2023/5/8.
//

#import <Foundation/Foundation.h>
#import "FBLocalHistoricalModel.h"
#import "FBTestUIOverviewModel.h"

NS_ASSUME_NONNULL_BEGIN

@class FBTestUIBaseListModel;
@class FBTestUIBaseListSection;
@class FBStepItem;
@class FBHrItem;
@class FBSpo2Item;
@class FBBpItem;
@class FBStressItem;
@class FBSportsPositioningRecordResults;

#define x_Hour @[@"00:00-01:00", @"01:00-02:00", @"02:00-03:00", @"03:00-04:00", @"04:00-05:00", @"05:00-06:00", @"06:00-07:00", @"07:00-08:00", @"08:00-09:00", @"09:00-10:00", @"10:00-11:00", @"11:00-12:00", @"12:00-13:00", @"13:00-14:00", @"14:00-15:00", @"15:00-16:00", @"16:00-17:00", @"17:00-18:00", @"18:00-19:00", @"19:00-20:00", @"20:00-21:00", @"21:00-22:00", @"22:00-23:00", @"23:00-24:00"]

@interface FBLoadDataObject : NSObject

/* 请求历史数据（保存至数据库）｜Request Historical Data (Save to database)
 * currentStep、currentCalories、currentDistance 今日实时数据（步数、卡路里、距离）
 * errorString    失败信息，为nil表示全部类型请求成功
 */
+ (void)requestHistoricalDataWithBlock:(void(^)(NSInteger currentStep, NSInteger currentCalories, NSInteger currentDistance, NSString * _Nullable errorString))block;

/// 查询所有数据的日期，日历事件着色用｜Query all data dates, use calendar event coloring
+ (NSArray <NSString *>  * _Nullable)QueryAllRecordWithDataType:(FBTestUIDataType)dataType dateFormat:(FBDateFormat)dateFormat deviceName:(NSString *)deviceName deviceMAC:(NSString *)deviceMAC;

/// 查询某一数据类型、某一天的数据｜Query data of a certain data type and day
+ (FBTestUIBaseListModel *)QueryAllDataWithDate:(NSDate *)queryDate dataType:(FBTestUIDataType)dataType deviceName:(NSString *)deviceName deviceMAC:(NSString *)deviceMAC;

/// 该运动是卡路里运动吗
+ (BOOL)isCalorie:(RLMSportsModel *)sportsModel;

/// 运动名称
+ (NSString *)sportName:(FB_MOTIONMODE)MotionMode;

/// 查询本地历史数据（查询数据库）｜Query local historical data (Query Database)
+ (void)QueryLocalHistoricalDataWithBlock:(void(^)(FBLocalHistoricalModel *historicalModel))block;

/// 获取设备绑定记录｜Obtain device binding records
+ (NSArray <FBDropDownMenuModel *> *)ObtainDeviceBindingRecordsWithCurrentDeviceName:(NSString *)deviceName withDeviceMAC:(NSString *)deviceMAC;

@end


@interface FBTestUIBaseListModel : NSObject

@property (nonatomic, assign) FBTestUIDataType dataType;

@property (nonatomic, strong) AAChartModel *aaChartModel; // 图表数据

@property (nonatomic, strong) AAOptions *aaOptions; // 图表气泡

@property (nonatomic, strong) NSArray <RLMSportsModel *> *sportsArray; // 运动数据

@property (nonatomic, strong) NSArray <FBTestUIBaseListSection *> *section; // 组

@end


@interface FBTestUIBaseListSection : NSObject
@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) NSArray <FBTestUIOverviewModel *> *overviewArray;
@end


@interface FBStepItem : NSObject
@property (nonatomic, assign) NSInteger begin;
@property (nonatomic, assign) NSInteger step;
@end


@interface FBHrItem : NSObject
@property (nonatomic, assign) NSInteger begin;
@property (nonatomic, assign) NSInteger hr;
@end


@interface FBSpo2Item : NSObject
@property (nonatomic, assign) NSInteger begin;
@property (nonatomic, assign) NSInteger spo2;
@end


@interface FBBpItem : NSObject
@property (nonatomic, assign) NSInteger begin;
@property (nonatomic, assign) NSInteger bp_s;
@property (nonatomic, assign) NSInteger bp_d;
@end


@interface FBStressItem : NSObject
@property (nonatomic, assign) NSInteger begin;
@property (nonatomic, assign) NSInteger stress;
@property (nonatomic, assign) FB_CURRENTSTRESSRANGE StressRange;
@end


@interface FBSleepItem : NSObject
@property (nonatomic, assign) NSInteger begin;
@property (nonatomic, assign) NSInteger end;
@property (nonatomic, assign) NSInteger duration;
@property (nonatomic, assign) RLMSLEEPSTATE SleepState;
@end


@interface FBRestingHrItem : NSObject
@property (nonatomic, assign) NSInteger begin;
@property (nonatomic, assign) NSInteger restingHR;
@end


@interface FBSportsPositioningRecordResults : NSObject
/// 是否支持GPS
@property (nonatomic, assign) BOOL supportGPS;
/// 运动定位记录是否请求成功
@property (nonatomic, assign) BOOL isSuccessful;
/// 运动定位记录
@property (nonatomic, retain) NSArray <FBTypeRecordModel *> *sportsPositioningArray;
@end

NS_ASSUME_NONNULL_END
