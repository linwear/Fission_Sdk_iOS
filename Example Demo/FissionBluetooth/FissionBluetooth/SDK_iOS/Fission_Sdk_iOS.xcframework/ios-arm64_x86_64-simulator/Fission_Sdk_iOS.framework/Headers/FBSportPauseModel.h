//
//  FBSportPauseModel.h
//  FissionBluetooth
//
//  Created by 裂变智能 on 2021/2/19.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
/*
 中断UTC记录｜Interrupt UTC record
*/
@interface FBSportPauseModel : NSObject

/**
 运动暂停时间，单位秒｜Sport pause time,Unit second
*/
@property (nonatomic, assign) NSInteger sportPauseTime;

/**
 运动重新开始时间，单位秒｜Sport restart time,Unit second
*/
@property (nonatomic, assign) NSInteger sportAgainTime;

@end

NS_ASSUME_NONNULL_END
