//
//  FBLocationManager.h
//  FissionBluetooth
//
//  Created by 裂变智能 on 2023-08-29.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FBLocationManager : NSObject

/// 开始定位
+ (void)startLocation:(void(^)(CLLocation *location))success failure:(void(^)(CLAuthorizationStatus status, NSError *error))failure;

/// 结束定位
+ (void)stopLocation;

/// 最近一个定位信息
+ (CLLocation * _Nullable)location;

@end

NS_ASSUME_NONNULL_END
