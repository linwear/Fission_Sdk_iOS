//
//  FBPeripheralModel.h
//  FissionBluetooth
//
//  Created by 裂变智能 on 2023/3/1.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

NS_ASSUME_NONNULL_BEGIN
/*
 外围设备信息模型｜Peripheral Information Model
*/
@interface FBPeripheralModel : NSObject

/**
 设备是否已配对｜Whether the device is paired
 */
@property (nonatomic, assign) BOOL isPair;

/**
 设备名称｜Device name
 */
@property (nonatomic, copy) NSString *device_Name;

/**
 设备Mac地址｜Device device Mac address
 */
@property (nonatomic, copy) NSString *mac_Address;

/**
 设备适配号｜Device Adapter Number
 */
@property (nonatomic, copy) NSString *adapt_Number;

/**
 设备版本号｜Device version number
 */
@property (nonatomic, copy) NSString *version_Number;

/**
 设备对象｜Device object
 */
@property (nonatomic, retain) CBPeripheral *peripheral;

/**
 设备广播信息｜Device broadcast information
 */
@property (nonatomic, retain) NSDictionary *advertisementData;

/**
 设备广播信号｜Device broadcast signal
 */
@property (nonatomic, retain) NSNumber *RSSI;

@end

NS_ASSUME_NONNULL_END
