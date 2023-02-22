//
//  FBDeviceInfoModel.h
//  FissionBluetooth
//
//  Created by 裂变智能 on 2021/2/18.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
/*
 设备硬件信息｜Device hardware information
*/
@interface FBDeviceInfoModel : NSObject

/**
 结构体版本｜Structure version
*/
@property (nonatomic, assign) NSInteger structVersion;

/**
 硬件标志｜Hardware logo
*/
@property (nonatomic, copy) NSString *hardwareIdentifier;

/**
 mac 地址｜MAC address
*/
@property (nonatomic, copy) NSString *mac;

/**
 硬件版本｜Hardware version
*/
@property (nonatomic, copy) NSString *hardWareVersion;

/**
 固件版本｜Firmware version
*/
@property (nonatomic, copy) NSString *firmwareVersion;

/**
 UI版本｜UI version
*/
@property (nonatomic, copy) NSString *UI_Version;

/**
 协议版本｜Protocol version
*/
@property (nonatomic, copy) NSString *protocolVeriosn;

/**
 设备名称｜Equipment name
*/
@property (nonatomic, copy) NSString *deviceName;

/**
 设备ID｜Device ID
*/
@property (nonatomic, assign) NSInteger deviceID;

/**
 设备SN号｜Equipment Sn number
*/
@property (nonatomic, copy) NSString *deviceSN;

/**
 固件更新日期｜Firmware update date
*/
@property (nonatomic, copy) NSString *firmwareUpdateTime;

/**
 适配号｜Matching number
*/
@property (nonatomic, copy) NSString *fitNumber;

/**
 二维码信息｜QR code information
*/
@property (nonatomic, assign) NSInteger QR_code;

/**
 MAC二维码版本｜Mac QR code version
*/
@property (nonatomic, assign) NSInteger Mac_QR_code_version;

/**
 显示屏型号｜Display model
*/
@property (nonatomic, assign) NSInteger display_model;

/**
 TP型号｜TP model
*/
@property (nonatomic, assign) NSInteger TP_model;

/**
 手表表盘形状｜Watch dial shape
 
 @note  shape           手表表盘形状，0:长方形、1:圆形、2:正方形｜Watch dial shape, 0: rectangle, 1: circle, 2: Square
*/
@property (nonatomic, assign) NSInteger shape;

/**
 手表显示分辨率宽高｜Watch display resolution width and height
 */
@property (nonatomic, assign) CGSize watchDisplaySize;

/**
 表盘缩略图显示分辨率宽高｜Dial thumbnail display resolution width and height
 */
@property (nonatomic, assign) CGSize dialThumbnailDisplaySize;

/**
 音频库版本｜Audio library version
 */
@property (nonatomic, copy) NSString *audioTimeVersion;

@end

NS_ASSUME_NONNULL_END
