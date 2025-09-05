//
//  FBBloodPressureModel.h
//  FissionBluetooth
//
//  Created by LINWEAR on 2025-08-11.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 血压私人模式信息｜Blood pressure private mode information
 */
@interface FBBloodPressureModel : NSObject

/** 模式开关 NO:关闭 YES:打开｜Mode switch NO: Off YES: On */
@property (nonatomic, assign) BOOL enable;

/** 收缩压（高压，mmHg）｜Systolic blood pressure (high pressure, mmHg) */
@property (nonatomic, assign) NSInteger pb_max;

/** 舒张压（低压，mmHg）｜Diastolic blood pressure (low pressure, mmHg) */
@property (nonatomic, assign) NSInteger pb_min;

@end

NS_ASSUME_NONNULL_END
