//
//  FBFirmwareVersionObject.h
//  FissionBluetooth
//
//  Created by 裂变智能 on 2022/2/11.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FBFirmwareVersionObject : NSObject <NSCoding, NSSecureCoding>

/**
 最后一次更新时间，非0表示以下数据值有效 | Last update time, non-zero indicates that the following data values are valid
*/
@property (nonatomic, assign) NSInteger updateUTC;

/**
 结构体版本 | Structure version
*/
@property (nonatomic, assign) NSInteger structVersion;

/**
 硬件标志 | Hardware logo
*/
@property (nonatomic, copy) NSString *hardwareIdentifier;

/**
 mac 地址 | MAC address
*/
@property (nonatomic, copy) NSString *mac;

/**
 硬件版本 | Hardware version
*/
@property (nonatomic, copy) NSString *hardWareVersion;

/**
 固件版本 | Firmware version
*/
@property (nonatomic, copy) NSString *firmwareVersion;

/**
 UI版本 | UI version
*/
@property (nonatomic, copy) NSString *UI_Version;

/**
 协议版本 | Protocol version
*/
@property (nonatomic, copy) NSString *protocolVeriosn;

/**
 设备名称 | Equipment name
*/
@property (nonatomic, copy) NSString *deviceName;

/**
 设备ID | Device ID
*/
@property (nonatomic, assign) NSInteger deviceID;

/**
 设备SN号 | Equipment Sn number
*/
@property (nonatomic, copy) NSString *deviceSN;

/**
 固件更新日期 | Firmware update date
*/
@property (nonatomic, copy) NSString *firmwareUpdateTime;

/**
 适配号 | Matching number
*/
@property (nonatomic, copy) NSString *fitNumber;

/**
 二维码信息 | QR code information
*/
@property (nonatomic, assign) NSInteger QR_code;

/**
 MAC二维码版本 | Mac QR code version
*/
@property (nonatomic, assign) NSInteger Mac_QR_code_version;

/**
 显示屏型号 | Display model
*/
@property (nonatomic, assign) NSInteger display_model;

/**
 TP型号 | TP model
*/
@property (nonatomic, assign) NSInteger TP_model;

/**
 手表表盘形状 | Watch dial shape
 
 @note  shape           手表表盘形状，0:长方形、1:圆形、2:正方形｜Watch dial shape, 0: rectangle, 1: circle, 2: Square
*/
@property (nonatomic, assign) NSInteger shape;

/**
 手表显示分辨率宽｜Wide display resolution of watch
 */
@property (nonatomic, assign) NSInteger watchDisplayWide;

/**
 手表显示分辨率高｜The watch has high display resolution
 */
@property (nonatomic, assign) NSInteger watchDisplayHigh;

/**
 表盘缩略图显示分辨率宽｜The display resolution of dial thumbnail is wide
 */
@property (nonatomic, assign) NSInteger dialThumbnailDisplayWide;

/**
 表盘缩略图显示分辨率高｜Dial thumbnail display with high resolution
 */
@property (nonatomic, assign) NSInteger dialThumbnailDisplayHigh;

/**
 音频库版本｜Audio library version
 */
@property (nonatomic, copy) NSString *audioTimeVersion;

/**
 🌟是否需要使用时区补偿时间｜Need to use time zone to compensate time🌟
 
 @note  NO：不使用时区（时区需设定为0），时区直接补偿到UTC中，所以记录时间戳实际采用RTC记录（RTC = UTC + 时区偏移秒）、YES：使用时区（时区需要正确设定），所有记录时间戳采用UTC记录｜NO: do not use the time zone (the time zone needs to be set to 0), and the time zone is directly compensated to UTC, so the recording timestamp actually adopts RTC recording (RTC = UTC + time zone offset second). YES: use the time zone (the time zone needs to be set correctly), and all recording timestamps adopt UTC recording
*/
@property (nonatomic, assign) BOOL useTimeZone;

/**
 🌟是否需要使用压缩算法（表盘）｜Need to use compression algorithm (DIAL)🌟
 
 @note  NO：使用普通算法、YES：使用压缩算法｜NO: use ordinary algorithm, YES: use compression algorithm
*/
@property (nonatomic, assign) BOOL useCompress;

/**
 🌟是否支持来电快捷回复｜Does it support quick reply to incoming calls🌟
 
 @note  NO：不支持、YES：支持｜NO: not support YES: support
*/
@property (nonatomic, assign) BOOL supportQuickReply;

/**
 🌟是否支持GPS互联｜Whether GPS interconnection is supported🌟
 
 @note  NO：不支持、YES：支持｜NO: not support YES: support
*/
@property (nonatomic, assign) BOOL supportGPS;

/**
 🌟是否支持未来14天天气预报（与旧版相比，旧版本只支持未来5天天气预报）｜Does it support the weather forecast for the next 14 days (compared with the old version, the old version only supports the weather forecast for the next 5 days)🌟
 
 @note  NO：不支持、YES：支持｜NO: not support YES: support
*/
@property (nonatomic, assign) BOOL support_14days_Weather;

/**
 🌟是否支持更多种运动推送｜Does it support more sports push🌟
 
 @note  NO：不支持、YES：支持｜NO: not support YES: support
*/
@property (nonatomic, assign) BOOL supportMoreSports;

/**
 🌟是否支持更多天气类型（与旧版相比，增加「中雨、暴雨」）｜Whether more weather types are supported (compared with the old version, add "moderate rain, rainstorm")🌟
 
 @note  NO：不支持、YES：支持｜NO: not support YES: support
*/
@property (nonatomic, assign) BOOL supportMoreWeather;

/**
 🌟是否支持同步常用联系人｜Support to synchronize favorite contacts🌟
 
 @note  NO：不支持、YES：支持｜NO: not support YES: support
*/
@property (nonatomic, assign) BOOL supportFavContacts;

/**
 🌟是否支持运动心率预警｜Whether it supports exercise heart rate warning🌟
 
 @note  NO：不支持、YES：支持｜NO: not support YES: support
*/
@property (nonatomic, assign) BOOL supportHrWarning;

/**
 🌟是否支持运动目标设置｜Whether the setting of moving targets is supported🌟
 
 @note  NO：不支持、YES：支持｜NO: not support YES: support
*/
@property (nonatomic, assign) BOOL supportSportTarget;

/**
 🌟是否支持勿扰设置｜Whether the do not disturb setting is supported🌟
 
 @note  NO：不支持、YES：支持｜NO: not support YES: support
*/
@property (nonatomic, assign) BOOL supportNotDisturb;

/**
 🌟是否支持密钥绑定｜Whether key binding is supported🌟
 
 @note  NO：不支持、YES：支持｜NO: not support YES: support
*/
@property (nonatomic, assign) BOOL supportBinding;

/**
 🌟是否支持使用私有协议推送在线表盘｜Whether it supports using private protocol to push online dial🌟
 
 @note  NO：不支持、YES：支持｜NO: not support YES: support
*/
@property (nonatomic, assign) BOOL supportPrivatePushDial;

/**
 🌟是否支持抬腕亮屏信息设置｜Whether it supports the setting of wrist lifting and bright screen information🌟
 
 @note  NO：不支持、YES：支持｜NO: not support YES: support
*/
@property (nonatomic, assign) BOOL supportWristScreen;

/**
 🌟是否支持通话｜Whether calls are supported🌟
 
 @note  NO：不支持、YES：支持｜NO: not support YES: support
*/
@property (nonatomic, assign) BOOL supportCalls;

/**
 🌟是否支持APP设置 记事提醒/闹钟｜Does the app support setting reminders / alarm clocks🌟
 
 @note  NO：不支持、YES：支持｜NO: not support YES: support
*/
@property (nonatomic, assign) BOOL supportSetAlarmClock;

/**
 🌟是否支持 记事提醒/闹钟 显示备注｜Whether it supports memo reminder / alarm clock display remarks🌟
 
 @note  NO：不支持、YES：支持｜NO: not support YES: support
*/
@property (nonatomic, assign) BOOL supportDisplayRemarks;

/**
 🌟是否支持更多（10个）记事提醒/闹钟（与旧版相比，旧版本只支持（5个）记事提醒/闹钟）｜Whether it supports more (10) reminders / alarms (compared with the old version, the old version only supports (5) reminders / alarms)🌟
 
 @note  NO：不支持、YES：支持｜NO: not support YES: support
*/
@property (nonatomic, assign) BOOL supportMoreAlarmClock;

/**
 🌟是否支持OTA进度反馈（固件/表盘/运动下载等）｜Whether OTA progress feedback is supported (firmware / dial / sports download, etc.)🌟
 
 @note  NO：不支持、YES：支持｜NO: not support YES: support
*/
@property (nonatomic, assign) BOOL support_ota_progress;

/**
 🌟是否支持音频和通话开关设置和获取｜Whether to support audio and call switch setting and acquisition🌟
 
 @note  NO：不支持、YES：支持｜NO: not support YES: support
*/
@property (nonatomic, assign) BOOL support_audio_call_switch;

/**
 🌟是否支持心率血氧精神压力开关设置｜Whether to support heart rate blood oxygen mental pressure switch setting🌟
 
 @note  NO：不支持、YES：支持｜NO: not support YES: support
*/
@property (nonatomic, assign) BOOL support_hr_spo2_stress_switch;

/**
 🌟是否支持血压功能｜Whether to support blood pressure function🌟
 
 @note  NO：不支持、YES：支持｜NO: not support YES: support
*/
@property (nonatomic, assign) BOOL supportBloodPressure;

/**
 🌟是否支持精神压力功能｜Whether to support mental stress function🌟
 
 @note  NO：不支持、YES：支持｜NO: not support YES: support
*/
@property (nonatomic, assign) BOOL supportMentalStress;

@end

NS_ASSUME_NONNULL_END
