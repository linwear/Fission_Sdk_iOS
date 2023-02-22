//
//  FBWeatherDetailsModel.h
//  FissionBluetooth
//
//  Created by 裂变智能 on 2021/4/15.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
/*
 推送今日天气详情消息参数｜Push today's weather details message parameters
*/
@interface FBWeatherDetailsModel : NSObject

/**
 天气｜Weather
*/
@property (nonatomic, assign) FB_WEATHER Weather;

/**
 空气质量等级｜Air quality level
*/
@property (nonatomic, assign) FB_AIRLEVEL AirCategory;

/**
 空气温度｜air temperature
*/
@property (nonatomic, assign) NSInteger airTemp;

/**
 体感温度（C）｜Somatosensory temperature (c)
*/
@property (nonatomic, assign) NSInteger somatTemp;

/**
 最低温度，可以为负数｜The lowest temperature can be negative
*/
@property (nonatomic, assign) NSInteger tempMin;

/**
 最高温度，可以为负数｜The highest temperature can be negative
*/
@property (nonatomic, assign) NSInteger tempMax;

/**
 日出时间，小时｜Sunrise time, hours
*/
@property (nonatomic, assign) NSInteger sunriseHours;

/**
 日出时间，分钟｜Sunrise time, minutes
*/
@property (nonatomic, assign) NSInteger sunriseMinutes;

/**
 日落时间，小时｜Sunset time, hours
*/
@property (nonatomic, assign) NSInteger sunsetHours;

/**
 日落时间，分钟｜Sunset time, minutes
*/
@property (nonatomic, assign) NSInteger sunsetMinutes;

/**
 湿度（%）｜Humidity (%)
*/
@property (nonatomic, assign) NSInteger humidity;

/**
 风向｜Wind direction
*/
@property (nonatomic, assign) EM_WINDDIRECTION WindDirection;

/**
 风速度（米/秒）｜Wind speed (M / s)
*/
@property (nonatomic, assign) NSInteger windSpeed;

/**
 最近2小时降水概率（%）｜Precipitation probability in the last 2 hours (%)
*/
@property (nonatomic, assign) NSInteger probability;

/**
 降水量（毫米）｜Precipitation (mm)
*/
@property (nonatomic, assign) NSInteger precipitation;

/**
 气压（百帕）｜Air pressure (HPA)
*/
@property (nonatomic, assign) NSInteger airPressure;

/**
 能见度（米）｜Visibility (m)
*/
@property (nonatomic, assign) NSInteger visibility;

/**
 紫外线指数｜UV index
*/
@property (nonatomic, assign) NSInteger UV_index;

@end

NS_ASSUME_NONNULL_END
