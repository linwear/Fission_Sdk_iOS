//
//  FBGPSMotionActionModel.h
//  FissionBluetooth
//
//  Created by 裂变智能 on 2022/5/27.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
/*
 GPS运动状态信息｜GPS motion status information
 */
@interface FBGPSMotionActionModel : NSObject

/**
 运动模式｜Movement mode
*/
@property (nonatomic, assign) FB_MOTIONMODE MotionMode;

/**
 GPS运动状态｜GPS Motion status
*/
@property (nonatomic, assign) FB_GPS_MOTION_STATE MotionState;

/**
 当前运动总时间，单位秒｜Total current movement time, in seconds
 */
@property (nonatomic, assign) NSInteger totalTime;

@end

NS_ASSUME_NONNULL_END
