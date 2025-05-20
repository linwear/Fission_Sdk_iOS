//
//  FBGameStreamDataModel.h
//  FissionBluetooth
//
//  Created by LINWEAR on 2025-04-18.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class FBGameDataModel;

/**
 流数据-游戏｜Streaming Data - Game
 */
@interface FBGameStreamDataModel : NSObject

/**
 流帧计数，自动递增，0-255，溢出后清零｜Stream frame count, auto increment, 0-255, clear after overflow
 */
@property (nonatomic, assign) NSInteger streamCount;

/**
 游戏厂家｜Game Manufacturer
 */
@property (nonatomic, assign) FB_GAMEMANUFACTURER gameManufacturer;

/**
 传感器类型｜Sensor Type
 */
@property (nonatomic, assign) FB_SENSORTYPE sensorType;

/**
 算法版本号，例如20表示 2.0 版本｜Algorithm version number, for example 20 means version 2.0
 */
@property (nonatomic, assign) NSInteger version;

/**
 传感器游戏数据
 */
@property (nonatomic, strong) FBGameDataModel *gameData;

@end


@interface FBGameDataModel : NSObject
/// X轴实时转向
@property (nonatomic, assign) int x;
/// Y轴实时俯仰
@property (nonatomic, assign) int y;
/// 实时速度
@property (nonatomic, assign) int speed;
/// X轴瞬间转向
@property (nonatomic, assign) int xThrow;
/// Y轴瞬间俯仰
@property (nonatomic, assign) int yThrow;
/// 投掷计数
@property (nonatomic, assign) int countThrow;
/// X轴加速度
@property (nonatomic, assign) int xGravity;
/// Y轴加速度
@property (nonatomic, assign) int yGravity;
/// Z轴加速度
@property (nonatomic, assign) int zGravity;
@end

NS_ASSUME_NONNULL_END
