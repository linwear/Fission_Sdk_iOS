//
//  FBMotionTypesListModel.h
//  FissionBluetooth
//
//  Created by 裂变智能 on 2023/3/22.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
/*
 设备运动类型列表｜List of Equipment Motion Types
*/
@interface FBMotionTypesListModel : NSObject

/**
 运动类型总个数｜Total number of sports types
 */
@property (nonatomic, assign) NSInteger totalCount;

/**
 本地运动类型个数｜Number of local motion types
 */
@property (nonatomic, assign) NSInteger localCount;

/**
 运动推送类型个数｜Number of motion push types
 */
@property (nonatomic, assign) NSInteger pushCount;

/**
 运动类型列表｜Sports Type List
 
 @note  其中  NSNumber.integerValue 为运动模式枚举类型 FB_MOTIONMODE｜Where NSNumber.integerValue is the motion mode enumeration type FB_MOTIONMODE
 */
@property (nonatomic, strong) NSArray <NSNumber *> *SportsList;

@end

NS_ASSUME_NONNULL_END
