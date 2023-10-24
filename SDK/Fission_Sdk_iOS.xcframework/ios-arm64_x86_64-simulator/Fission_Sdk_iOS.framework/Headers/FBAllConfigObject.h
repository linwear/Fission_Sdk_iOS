//
//  FBAllConfigObject.h
//  FissionBluetooth
//
//  Created by 裂变智能 on 2022/2/11.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 所有配置信息｜All configuration information
*/
@interface FBAllConfigObject : NSObject

/**
 固件配置｜Firmware configuration
 
 @note  首次绑定成功后，需要主动获取设备硬件信息（方法名：fbGetHardwareInformationDataWithBlock:）成功后有值｜After the first binding is successful, you need to actively obtain the device hardware information (method name: fbGetHardwareInformationDataWithBlock:). There is a value after the success
 */
+ (FBFirmwareVersionObject *)firmwareConfig;

@end

NS_ASSUME_NONNULL_END
