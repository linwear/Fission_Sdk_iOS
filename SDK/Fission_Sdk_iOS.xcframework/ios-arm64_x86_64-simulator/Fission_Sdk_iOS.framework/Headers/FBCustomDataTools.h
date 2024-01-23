//
//  FBCustomDataTools.h
//  FissionBluetooth
//
//  Created by 裂变智能 on 2021/7/6.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 自定义bin文件数据工具｜Custom bin file data tools
*/
@interface FBCustomDataTools : NSObject

/**
 初始化单个实例对象 |  Initializes a single instance object
 */
+ (FBCustomDataTools *)sharedInstance;


/**
 生成自定义表盘bin文件数据 | Generate custom dial bin file data
 @param dialModel                                 自定义表盘参数模型｜Custom dial parameter model
*/
- (NSData *)fbGenerateCustomDialBinFileDataWithDialModel:(FBCustomDialModel * _Nonnull)dialModel;


/**
 生成自定义运动类型bin文件数据（⚠️暂未开发） | Generate custom motion category bin file data (⚠️Not developed yet)
 @param motionModel                             自定义运动类型参数模型｜Custom motion parameters model
*/
- (NSData *)fbGenerateCustomMotionBinFileDataWithMotionModel:(FBCustomMotionModel * _Nonnull)motionModel API_DEPRECATED("⚠️暂未开发｜⚠️Not developed yet", macos(2.0, 2.0), ios(2.0, 2.0), tvos(2.0, 2.0), watchos(2.0, 2.0));


/**
 生成自定义运动类型bin文件数据（多个运动类型Bin文件压缩合并成一个Bin文件） | Generate custom motion type bin file data (Bin files of multiple motion types are compressed and merged into one Bin file)
 @param items                             自定义运动类型bin文件数组｜Custom motion type bin file array
 @param isBuilt_in                  是否为厂线推送内置运动，FB_OTANotification_Multi_Sport:推送自定义多运动，FB_OTANotification_Multi_Sport_Built_in:厂线推送内置多运动｜Whether to push built-in sports for the factory line, FB_OTANotification_Multi_Sport: Push custom multi-sport, FB_OTANotification_Multi_Sport_Built_in: Push built-in multi-sport for the factory line
 
 @note
 ①. 具体支持的 items 最大个数不能超过 FBAllConfigObject.firmwareConfig.supportMultipleSportsCount 设备支持个数｜The maximum number of specific supported items cannot exceed the number supported by FBAllConfigObject.firmwareConfig.supportMultipleSportsCount
 ②. 根据 FBAllConfigObject.firmwareConfig.supportMultipleSports 来标识需要使用压缩合并，再去启动OTA｜According to FBAllConfigObject.firmwareConfig.supportMultipleSports to identify the need to use compression and merge, and then start OTA
*/
- (NSData *)fbGenerateCustomMultipleMotionBinFileDataWithItems:(NSArray <NSData *> * _Nonnull)items isBuilt_in:(FB_OTANOTIFICATION)isBuilt_in;


/**
 生成AGPS星历bin文件数据（多个星历Bin文件合并成一个Bin文件） | Generate AGPS ephemeris bin file data (merge multiple ephemeris Bin files into one Bin file)
 @param ephemerisModel                             AGPS星历bin文件参数模型｜AGPS ephemeris bin file parameter model
*/
- (NSData *)fbGenerateAGPSEphemerisBinFileDataWithModel:(FBAGPSEphemerisModel* _Nonnull)ephemerisModel;


@end

NS_ASSUME_NONNULL_END
