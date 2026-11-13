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
 记录格式定义｜Record format definition
 
 RecordType == FB_SportsRecord -->>
 0:实时体力、运动状态值有效｜0: real-time physical strength and exercise status values ​​are valid
 1:公里、英里用时值有效｜1: kilometer and mile time values ​​are valid
 2:游泳相关值有效｜2: Swimming related values ​​are valid
 
 RecordType == FB_MotionGpsRecord -->>
 0:经纬度是单精度｜0: longitude and latitude are single precision
 1:经纬度是双精度｜1: longitude and latitude are double precision
 */
@property (nonatomic, assign) NSInteger recordDefinition;


// - - - - - 当 记录格式定义recordDefinition == 0 时，以下值有效｜When recordDefinition == 0, the following values are valid - - - - -

/** 实时体力，0~100｜Real time physical strength, 0-100 */
@property (nonatomic, assign) NSInteger stamina;

/** 运动状态。NO 正常，YES 暂停｜Motion state. NO normal, YES pause */
@property (nonatomic, assign) BOOL isSuspend;


// - - - - - 当 记录格式定义recordDefinition == 1 时，以下值有效｜When recordDefinition == 1, the following values are valid - - - - -

/** 一公里用时（一公里配速，单位秒）｜One kilometer time (one kilometer pace, unit second)*/
@property (nonatomic, assign) NSInteger KilometerPace;

/** 一英里用时（一英里配速，单位秒）｜Mile time (mile pace, in seconds) */
@property (nonatomic, assign) NSInteger MilePace;


// - - - - - 当 记录格式定义recordDefinition == 2 时，以下值有效｜When recordDefinition == 2, the following values are valid - - - - -

/** 主泳姿 (开放水域:50米、泳池:趟) */
@property (nonatomic, assign) FB_SWIMMINGSTROKES mainStroke_m;

/** 主泳姿 (开放水域:50码) */
@property (nonatomic, assign) FB_SWIMMINGSTROKES mainStroke_yd;

/** 时长 (开放水域:50米、泳池:趟) */
@property (nonatomic, assign) NSInteger strokeDuration_m;

/** 时长 (开放水域:50码) */
@property (nonatomic, assign) NSInteger strokeDuration_yd;

/** 划水次数 (开放水域:50米、泳池:趟) */
@property (nonatomic, assign) NSInteger strokeCount_m;

/** 划水次数 (开放水域:50码) */
@property (nonatomic, assign) NSInteger strokeCount_yd;



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



#pragma mark - 当 FB_RECORDTYPE为FB_AirPressureRecord 时（气压记录），以下值有效｜When FB_RECORDTYPE is FB_AirPressureRecord (air pressure record), the following values are valid
/** 气压值（帕）｜Air pressure value (Pa) */
@property (nonatomic, assign) NSInteger airPressure;

/** 海拔（米）｜Altitude (m) */
@property (nonatomic, assign) NSInteger altitude;



#pragma mark - 当 FB_RECORDTYPE为FB_BloodComponentRecord 时（血液成分记录），以下值有效｜When FB_RECORDTYPE is FB_BloodComponentRecord (blood component record), the following values are valid
/** 尿酸（μmol/L）｜Uric acid (μmol/L) */
@property (nonatomic, assign) NSInteger uricAcid;

/** 总胆固醇（μmol/L）｜Total cholesterol (μmol/L) */
@property (nonatomic, assign) double totalCholesterol;

/** 甘油三酯（μmol/L）｜Triglycerides (μmol/L) */
@property (nonatomic, assign) double triglycerides;

/** 高密度脂蛋白（μmol/L）｜High-density lipoprotein (μmol/L) */
@property (nonatomic, assign) double HDL;

/** 低密度脂蛋白（μmol/L）｜Low-density lipoprotein (μmol/L) */
@property (nonatomic, assign) double LDL;



#pragma mark - 当 FB_RECORDTYPE为FB_BloodGlucoseRecording 时（血糖记录），以下值有效｜When FB_RECORDTYPE is FB_BloodGlucoseRecording (blood glucose recording), the following values are valid
/** 血糖（mmol/L）｜Blood glucose (mmol/L) */
@property (nonatomic, assign) double bloodGlucose;


@end

NS_ASSUME_NONNULL_END
