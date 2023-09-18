//
//  FBSportTargetModel.h
//  FissionBluetooth
//
//  Created by 裂变智能 on 2021/2/18.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
/*
 运动目标信息｜Moving target information
*/
@interface FBSportTargetModel : NSObject

/**
 目标步数开关：NO:关  YES:开｜Target step switch：NO:off YES: on
*/
@property (nonatomic, assign) BOOL stepSwitch;

/**
 目标卡路里开关：NO:关  YES:开｜Target calorie switch：NO:off YES: on
*/
@property (nonatomic, assign) BOOL caculateSwitch;

/**
 目标距离开关：NO:关  YES:开｜Target distance switch：NO:off YES: on
*/
@property (nonatomic, assign) BOOL distanceSwitch;

/**
 运动目标参数开关：NO:关  YES:开｜Moving target parameter switch：NO:off YES: on
*/
@property (nonatomic, assign) BOOL sportSwicth;

/**
 目标之步数｜Step target
*/
@property (nonatomic, assign) NSInteger stepTarget;

/**
 目标之卡路里消耗（千卡）｜Target calorie consumption (kcal)
*/
@property (nonatomic, assign) NSInteger calorieTarget;

/**
 目标之里程数（米）｜Distance target (m)
*/
@property (nonatomic, assign) NSInteger distanceTarget;

/**
 目标之运动时间（分钟）｜Sport time target (minute)
*/
@property (nonatomic, assign) NSInteger sportTimeTarget;

@end

NS_ASSUME_NONNULL_END
