//
//  FBAGPSLocationModel.h
//  FissionBluetooth
//
//  Created by 裂变智能 on 2023-08-24.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 AGPS位置信息｜AGPS location information
*/
@interface FBAGPSLocationModel : NSObject

/** 当前时间(UTC)｜Current time (UTC) */
@property (nonatomic, assign) NSInteger currentTimeUTC;

/** 经度 (WGS-84)｜Longitude (WGS-84) */
@property (nonatomic, assign) CGFloat longitude;

/** 纬度 (WGS-84)｜Latitude (WGS-84) */
@property (nonatomic, assign) CGFloat latitude;

/// @note 系统 CLLocationManager 定位得到的 CLLocation 坐标系就是WGS-84。关于经纬度要在地图上显示的问题：经纬度属于中国境内的，则需要先转换为火星坐标系GCJ-02；中国境外的则继续使用坐标系WGS-84。｜The CLLocation coordinate system obtained by positioning the system CLLocationManager is WGS-84. Regarding the issue of displaying longitude and latitude on the map: if the longitude and latitude are within China, they need to be converted to the Mars coordinate system GCJ-02 first; if the longitude and latitude are outside China, they will continue to use the coordinate system WGS-84.

@end

NS_ASSUME_NONNULL_END
