//
//  FBAGPSLocationModel.h
//  FissionBluetooth
//
//  Created by 裂变智能 on 2023-08-24.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/*
 AGPS位置信息｜AGPS location information
*/
@interface FBAGPSLocationModel : NSObject

/** 当前时间(UTC)｜Current time (UTC) */
@property (nonatomic, assign) NSInteger currentTimeUTC;

/** 经度｜Longitude */
@property (nonatomic, assign) CGFloat longitude;

/** 纬度｜Latitude */
@property (nonatomic, assign) CGFloat latitude;

@end

NS_ASSUME_NONNULL_END
