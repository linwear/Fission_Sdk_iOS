//
//  FBSnoreRecordModel.h
//  FissionBluetooth
//
//  Created by LINWEAR on 2025-06-24.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 鼾宝记录信息｜Snore Record Information
*/
@interface FBSnoreRecordModel : NSObject

/**
 震动时间（秒时间戳）｜Vibration time (seconds timestamp)
*/
@property (nonatomic, assign) NSInteger GMTtimeInterval;

/**
 震动原因｜Causes of vibration
*/
@property (nonatomic, assign) NSInteger causes;

/**
 血氧值（%）｜Blood oxygen value (%)
 */
@property (nonatomic, assign) NSInteger SpO2;

@end

NS_ASSUME_NONNULL_END
