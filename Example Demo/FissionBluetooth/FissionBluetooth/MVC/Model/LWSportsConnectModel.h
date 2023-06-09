//
//  LWSportsConnectModel.h
//  FissionBluetooth
//
//  Created by 裂变智能 on 2023/3/7.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LWSportsConnectModel : NSObject

/** 运动状态 */
@property (nonatomic, assign) FB_GPS_MOTION_STATE MotionState;

/** 运动ID（开始运动时的时间戳） */
@property (nonatomic, assign) NSInteger begin;

/** 时间计数 */
@property (nonatomic, assign) NSInteger realTime;

/** 步数 */
@property (nonatomic, assign) NSInteger steps;

/** 距离m */
@property (nonatomic, assign) NSInteger distance;

/** 卡路里kcal */
@property (nonatomic, assign) NSInteger calorie;

/** 当前心率 */
@property (nonatomic, assign) NSInteger heartRate;

/** 平均配速s /km */
@property (nonatomic, assign) NSInteger avgPace;

@end

NS_ASSUME_NONNULL_END
