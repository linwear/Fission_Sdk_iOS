//
//  FBHeartRateRatingModel.h
//  FissionBluetooth
//
//  Created by 裂变智能 on 2021/2/18.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
/*
 心率等级判定信息｜Heart rate level determination information
*/
@interface FBHeartRateRatingModel : NSObject

/**
 超过这个百分比，认定为 mix_hr｜If the percentage exceeds this, it will be regarded as mix_hr
*/
@property (nonatomic, assign) NSInteger min_hr;

/**
 超过这个百分比，认定为 moderate｜If the percentage exceeds this, it will be regarded as moderate
*/
@property (nonatomic, assign) NSInteger moderate;

/**
 超过这个百分比，认定为 vigorous｜If the percentage exceeds this, it will be regarded as vigorous
*/
@property (nonatomic, assign) NSInteger vigorous;

/**
 超过这个百分比，认定为 max_hr｜If it exceeds this percentage, it is regarded as max_hr
*/
@property (nonatomic, assign) NSInteger max_hr;

/**
 最高心率值｜Maximum heart rate
*/
@property (nonatomic, assign) NSInteger heigt_hr;

/**
 只有心率值在这个时间宽度都在某个级别以 上，才确定新等级｜Only when the heart rate value is above a certain level in this time width can the new level be determined
*/
@property (nonatomic, assign) NSInteger other_hr;

@end

NS_ASSUME_NONNULL_END
