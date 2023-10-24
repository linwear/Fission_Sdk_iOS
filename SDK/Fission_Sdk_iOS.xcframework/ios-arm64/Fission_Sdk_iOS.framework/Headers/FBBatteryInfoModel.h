//
//  FBBatteryInfoModel.h
//  FissionBluetooth
//
//  Created by 裂变智能 on 2022/5/27.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 手表设备电量信息｜Watch device battery info
 */
@interface FBBatteryInfoModel : NSObject

/**
 电池电量状态｜Battery state
*/
@property (nonatomic, assign) FB_BATTERYLEVEL batteryState;

/**
 电池电量 | Battery level
*/
@property (nonatomic, assign) NSInteger batteryLevel;

@end

NS_ASSUME_NONNULL_END
