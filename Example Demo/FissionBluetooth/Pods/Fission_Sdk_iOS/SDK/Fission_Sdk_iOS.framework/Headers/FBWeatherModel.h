//
//  FBWeatherModel.h
//  FissionBluetooth
//
//  Created by 裂变智能 on 2021/2/18.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 推送天气消息参数｜Push weather message parameters
*/
@interface FBWeatherModel : NSObject

/**
 序号ID，0:昨天、1:今天、2:明天、3:后天......｜Serial number ID, 0: yesterday, 1: today, 2: tomorrow, 3: the day after tomorrow ......
 
 @note  根据 FBAllConfigObject.firmwareConfig.support_14days_Weather 来标识是否支持未来14天天气预报（YES：序号ID支持0-15，NO：序号ID支持0-6）｜According to FBAllConfigObject.firmwareConfig.support_14days_Weather to identify whether the weather forecast for the next 14 days is supported (YES: serial number ID supports 0-15, NO: serial number ID supports 0-6)
*/
@property (nonatomic, assign) NSInteger days;

/**
 天气｜Weather
*/
@property (nonatomic, assign) FB_WEATHER Weather;

/**
 最低温度，可以为负数｜The lowest temperature can be negative
*/
@property (nonatomic, assign) NSInteger tempMin;

/**
 最高温度，可以为负数｜The highest temperature can be negative
*/
@property (nonatomic, assign) NSInteger tempMax;

/**
 空气质量等级｜Air quality level
*/
@property (nonatomic, assign) FB_AIRLEVEL AirCategory;

/**
 PM2.5等级｜PM2.5
*/
@property (nonatomic, assign) FB_PM25 PM2p5;

@end

NS_ASSUME_NONNULL_END
