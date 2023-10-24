//
//  FBLocationConverter.h
//  FissionBluetooth
//
//  Created by 裂变智能 on 2023-10-21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FBLocationConverter : NSObject

/**
 *    @brief     世界标准地理坐标(WGS-84) 转换成 中国国测局地理坐标（GCJ-02）<火星坐标>
 *
 *    @param     coordinate     世界标准地理坐标(WGS-84)
 *
 *    @return    中国国测局地理坐标（GCJ-02）<火星坐标>
 */
+ (CLLocationCoordinate2D)wgs_84ToGcj_02:(CLLocationCoordinate2D)coordinate;

@end

NS_ASSUME_NONNULL_END
