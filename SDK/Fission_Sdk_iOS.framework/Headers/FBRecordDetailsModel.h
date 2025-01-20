//
//  FBRecordDetailsModel.h
//  FissionBluetooth
//
//  Created by 裂变智能 on 2021/2/20.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 类型记录数组详情（公共类，具体参考枚举值 FB_RECORDTYPE）｜Type record array details (public class, refer to enumeration value FB_RECORDTYPE for details)
*/
@interface FBRecordDetailsModel : NSObject


#pragma mark - 以下值，通用，有值｜The following values, general, have values

/** 记录形成时间戳GMT秒｜Record the formation time stamp GMT seconds */
@property (nonatomic, assign) NSInteger GMTtimeInterval;

/** GMT转年月日时分秒｜GMT to YYYY-MM-dd HH:mm:ss */
@property (nonatomic, copy) NSString *dateTimeStr;

/** 记录类型｜Record type */
@property (nonatomic, assign) FB_RECORDTYPE RecordType;


#pragma mark - 当 FB_RECORDTYPE为FB_HeartRecord、FB_HFHeartRecord 时（心率记录、运动高频心率记录(1秒1次)），以下值有效｜When FB_RECORDTYPE is FB_HeartRecord, FB_HFHeartRecord (heart rate recording, sports high-frequency heart rate recording (once per second)), the following values are valid

/** 心率值｜Heart rate value */
@property (nonatomic, assign) NSInteger hr;



#pragma mark - 当 FB_RECORDTYPE为FB_StepRecord 时（计步记录），以下值有效｜When FB_RECORDTYPE is FB_StepRecord (step recording), the following values are valid

/** 计步数累加值｜Accumulated value of step count */
@property (nonatomic, assign) NSInteger step;



#pragma mark - 当 FB_RECORDTYPE为FB_BloodOxyRecord 时（血氧记录），以下值有效｜When FB_RECORDTYPE is FB_BloodOxyRecord (blood oxygen record), the following values are valid
/** 血氧值（%）｜Blood oxygen value (%) */
@property (nonatomic, assign) NSInteger Sp02;



#pragma mark - 当 FB_RECORDTYPE为FB_BloodPreRecord 时（血压记录），以下值有效｜When FB_RECORDTYPE is FB_BloodPreRecord (blood pressure recording), the following values are valid
/** 收缩压（高压，mmHg）｜Systolic blood pressure (high pressure, mmHg) */
@property (nonatomic, assign) NSInteger pb_max;

/** 舒张压（低压，mmHg）｜Diastolic blood pressure (low pressure, mmHg) */
@property (nonatomic, assign) NSInteger pb_min;



#pragma mark - 当 FB_RECORDTYPE为FB_StressRecord 时（精神压力记录），以下值有效｜When FB_RECORDTYPE is FB_StressRecord (mental stress record), the following values are valid
/** 精神压力值｜Mental stress value */
@property (nonatomic, assign) NSInteger stress;

/** 精神压力等级｜Mental stress level */
@property (nonatomic, assign) FB_CURRENTSTRESSRANGE StressRange;



#pragma mark - 当 FB_RECORDTYPE为FB_SportsRecord 时（运动详情记录），以下值有效｜When FB_RECORDTYPE is FB_SportsRecord (sports details record), the following values are valid
/** 实时配速（秒/千米）｜Real time pace (SEC / km) */
@property (nonatomic, assign) NSInteger pace;

/** 一分钟内消耗的卡路里值（千卡）｜Calories consumed in one minute (kcal) */
@property (nonatomic, assign) NSInteger calories;

/** 一分钟内的步数（实时步频，步/分钟）｜Steps in one minute (real time step frequency, step / minute) */
@property (nonatomic, assign) NSInteger stepFrequency;

/** 运动中的实时距离（米）｜Real time distance in motion (m) */
@property (nonatomic, assign) NSInteger distance;

/** 实时心率（次/分钟）｜Real time heart rate (times / min) */
@property (nonatomic, assign) NSInteger heartRate;

/**
 记录格式定义
 
 RecordType == FB_SportsRecord -->>
 0:实时体力、运动状态值有效，1:公里、英里用时值有效｜Record format definition, 0: real-time physical strength and exercise status values ​​are valid, 1: kilometer and mile time values ​​are valid
 
 RecordType == FB_MotionGpsRecord -->>
 0:经纬度是单精度，1:经纬度是双精度｜0: longitude and latitude are single precision, 1: longitude and latitude are double precision
*/
@property (nonatomic, assign) NSInteger recordDefinition;


// - - - - - 当 记录格式定义recordDefinition == 0 时，以下值有效｜When recordDefinition == 0, the following values are valid - - - - -

/** 实时体力，0~100｜Real time physical strength, 0-100 */
@property (nonatomic, assign) NSInteger stamina;

/** 运动状态。NO 正常，YES 暂停｜Motion state. NO normal, YES pause */
@property (nonatomic, assign) BOOL isSuspend;


// - - - - - - - - - - 当 记录格式定义recordDefinition == 1 时，以下值有效｜When recordDefinition == 1, the following values are valid - - - - - - - - - -

/** 一公里用时（一公里配速，单位秒）｜One kilometer time (one kilometer pace, unit second)*/
@property (nonatomic, assign) NSInteger KilometerPace;

/** 一英里用时（一英里配速，单位秒）｜Mile time (mile pace, in seconds) */
@property (nonatomic, assign) NSInteger MilePace;



#pragma mark - 当 FB_RECORDTYPE为FB_MotionGpsRecord 时（运动定位记录），以下值有效｜When FB_RECORDTYPE is FB_MotionGpsRecord (motion positioning record), the following values are valid
/** 经度 (WGS-84)｜Longitude (WGS-84) */
@property (nonatomic) double longitude;

/** 纬度 (WGS-84)｜Latitude (WGS-84) */
@property (nonatomic) double latitude;

/** GPS 速度（米/秒）｜GPS speed (M / s) */
@property (nonatomic, assign) NSInteger speed;

/** 状态。NO 正常，YES 暂停｜Status. NO normal, YES pause */
@property (nonatomic, assign) BOOL gpsPause;

/** 该经纬度是否为公里里程点。YES 里程点，NO 非里程点｜Whether the latitude and longitude is a kilometer mileage point. YES mileage points, NO non-mileage points */
@property (nonatomic, assign) BOOL gpsKilometerPoints;

/** 该经纬度是否为英里里程点。YES 里程点，NO 非里程点｜Whether this latitude and longitude is a mileage point. YES mileage points, NO non-mileage points */
@property (nonatomic, assign) BOOL gpsMilePoints;

/** GPS 实时心率（次/分钟）｜GPS Real time heart rate (times / min) */
@property (nonatomic, assign) NSInteger gpsHeartRate;


@end

NS_ASSUME_NONNULL_END
