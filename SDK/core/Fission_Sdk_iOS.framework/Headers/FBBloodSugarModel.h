//
//  FBBloodSugarModel.h
//  FissionBluetooth
//
//  Created by LINWEAR on 2025-08-11.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 血糖私人模式信息｜Blood sugar private mode information
 */
@interface FBBloodSugarModel : NSObject

/** 模式开关 NO:关闭 YES:打开｜Mode switch NO: Off YES: On */
@property (nonatomic, assign) BOOL enable;


/** 早餐前（绝对分钟）｜Before breakfast (Absolute minutes) */
@property (nonatomic, assign) NSInteger bb_minutes;

/** 早餐前血糖（mmol/L）｜Before breakfast blood sugar (mmol/L) */
@property (nonatomic, assign) double bb_bloodSugar;

/** 早餐后（绝对分钟））｜After breakfast (Absolute minutes) */
@property (nonatomic, assign) NSInteger ab_minutes;

/** 早餐后血糖（mmol/L）｜After breakfast blood sugar (mmol/L) */
@property (nonatomic, assign) double ab_bloodSugar;


/** 午餐前（绝对分钟）｜Before lunch (Absolute minutes) */
@property (nonatomic, assign) NSInteger bl_minutes;

/** 午餐前血糖（mmol/L）｜Before lunch blood sugar (mmol/L) */
@property (nonatomic, assign) double bl_bloodSugar;

/** 午餐后（绝对分钟）｜After lunch (Absolute minutes) */
@property (nonatomic, assign) NSInteger al_minutes;

/** 午餐后血糖（mmol/L）｜After lunch blood sugar (mmol/L) */
@property (nonatomic, assign) double al_bloodSugar;


/** 晚餐前（绝对分钟）｜Before dinner (Absolute minutes) */
@property (nonatomic, assign) NSInteger bd_minutes;

/** 晚餐前血糖（mmol/L）｜Before dinner blood sugar (mmol/L) */
@property (nonatomic, assign) double bd_bloodSugar;

/** 晚餐后UTC（绝对分钟）｜After dinner (Absolute minutes) */
@property (nonatomic, assign) NSInteger ad_minutes;

/** 晚餐后血糖（mmol/L）｜After dinner blood sugar (mmol/L) */
@property (nonatomic, assign) double ad_bloodSugar;

@end

NS_ASSUME_NONNULL_END
