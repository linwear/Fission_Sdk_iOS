//
//  FBSnoreModel.h
//  FissionBluetooth
//
//  Created by LINWEAR on 2025-06-24.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 鼾宝信息｜Snore Information
*/
@interface FBSnoreModel : NSObject

/**
 震动等级｜Vibration level
*/
@property (nonatomic, assign) FB_DEVICEVIBRATELEVEL vibrationLevel;

/**
 白天开关状态，YES开 NO关｜Daytime switch status, YES on, NO off
*/
@property (nonatomic, assign) BOOL day;

/**
 白天开始时间（绝对分钟数）｜Daylight start time (in absolute minutes)
*/
@property (nonatomic, assign) NSInteger dayStart;

/**
 白天结束时间（绝对分钟数）｜Daylight end time (in absolute minutes)
*/
@property (nonatomic, assign) NSInteger dayEnd;

/**
 晚上开关状态，YES开 NO关｜Switch status at night, YES on, NO off
*/
@property (nonatomic, assign) BOOL night;

/**
 晚上开始时间（绝对分钟数）｜Evening start time (absolute minutes)
*/
@property (nonatomic, assign) NSInteger nightStart;

/**
 晚上结束时间（绝对分钟数）｜End time of the evening (in absolute minutes)
*/
@property (nonatomic, assign) NSInteger nightEnd;

@end

NS_ASSUME_NONNULL_END
