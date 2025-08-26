//
//  FBManualMeasureDataModel.h
//  FissionBluetooth
//
//  Created by 裂变智能 on 2021/10/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 手动测量数据记录｜Manual measurement data record
*/
@interface FBManualMeasureDataModel : NSObject

/**
 时间戳GMT秒｜Time stamp GMT seconds
*/
@property (nonatomic, assign) NSInteger GMTtimeInterval;

/**
 GMT转年月日时分秒｜GMT to YYYY-MM-dd HH:mm:ss
*/
@property (nonatomic, copy) NSString *dateTimeStr;

/**
 心率值｜Heart rate value
*/
@property (nonatomic, assign) NSInteger hr;

/**
 血氧值（%）｜Blood oxygen value (%)
*/
@property (nonatomic, assign) NSInteger Sp02;

/**
 收缩压（高压，mmHg）｜Systolic blood pressure (high pressure, mmHg)
 */
@property (nonatomic, assign) NSInteger pb_max;

/**
 舒张压（低压，mmHg）｜Diastolic blood pressure (low pressure, mmHg)
 */
@property (nonatomic, assign) NSInteger pb_min;

/**
 精神压力值｜Mental stress value
 */
@property (nonatomic, assign) NSInteger stress;

/**
 精神压力等级｜Mental stress level
 */
@property (nonatomic, assign) FB_CURRENTSTRESSRANGE StressRange;

/**
 血糖值（mmol/L）
 */
@property (nonatomic, assign) double bg;

/**
 尿酸（μmol/L）｜Uric acid (μmol/L)
 */
@property (nonatomic, assign) NSInteger uricAcid;

/**
 总胆固醇（μmol/L）｜Total cholesterol (μmol/L)
 */
@property (nonatomic, assign) double totalCholesterol;

/**
 甘油三酯（μmol/L）｜Triglycerides (μmol/L)
 */
@property (nonatomic, assign) double triglycerides;

/**
 高密度脂蛋白（μmol/L）｜High-density lipoprotein (μmol/L)
 */
@property (nonatomic, assign) double HDL;

/**
 低密度脂蛋白（μmol/L）｜Low-density lipoprotein (μmol/L)
 */
@property (nonatomic, assign) double LDL;


@end

NS_ASSUME_NONNULL_END
