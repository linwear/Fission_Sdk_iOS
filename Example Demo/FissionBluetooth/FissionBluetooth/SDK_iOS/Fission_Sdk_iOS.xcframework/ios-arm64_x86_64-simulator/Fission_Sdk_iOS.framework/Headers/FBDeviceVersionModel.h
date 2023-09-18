//
//  FBDeviceVersionModel.h
//  FissionBluetooth
//
//  Created by 裂变智能 on 2022/7/12.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
/*
 设备版本信息｜Device version information
 */
@interface FBDeviceVersionModel : NSObject

/**
 硬件版本号｜Hardware version number
*/
@property (nonatomic, copy) NSString *hardwareVersion;

/**
 软件版本号｜Software version number
*/
@property (nonatomic, copy) NSString *softwareVersion;

@end

NS_ASSUME_NONNULL_END
