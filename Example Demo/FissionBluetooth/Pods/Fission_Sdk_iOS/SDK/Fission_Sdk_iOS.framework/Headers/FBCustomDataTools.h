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
 初始化单个实例对象｜Initializes a single instance object
 */
+ (FBCustomDataTools *)sharedInstance;


/**
 生成自定义表盘bin文件数据｜Generate custom dial bin file data
 @param dialModel                                 自定义表盘参数模型｜Custom dial parameter model
*/
- (NSData *)fbGenerateCustomDialBinFileDataWithDialModel:(FBCustomDialModel * _Nonnull)dialModel;


/**
 视频转码、创建GIF图、获取视频首帧图片｜Video transcoding, creating GIF images, and obtaining the first frame of a video
 @param videoPath                                 将要处理的视频路径｜The video path to be processed
 @param contentMode                               显示模式｜Content mode
 @param scaleRect                                 裁剪矩形范围，仅FB_VIDEOCONTENTMODE_SCALETORECT模式有效；其他模式置CGRectZero即可｜Crop rectangle range. Only valid in FB_VIDEOCONTENTMODE_SCALETORECT mode. For other modes, set CGRectZero.
 @param timeRange                                 裁剪时间范围，location:起始秒，length:时长；不裁剪全置0即可｜Crop time range, location: starting second, length: duration; if not cropped, all values ​​can be set to 0
 @param clearAudio                                视频是否去除音频（如果视频用于制作表盘，那么应该设置为YES）｜Whether to remove audio from the video (if the video is used to make a watch face, it should be set to YES)
*/
+ (void)fbHandleVideoDialWithPath:(NSString * _Nonnull)videoPath
                      contentMode:(FB_VIDEOCONTENTMODE)contentMode
                        scaleRect:(CGRect)scaleRect
                        timeRange:(NSRange)timeRange
                       clearAudio:(BOOL)clearAudio
                         callback:(void(^)(FBCustomDialVideoModel * _Nullable videoModel, NSError * _Nullable error))callback;


/**
 TXT电子书UTF8编码｜TXT E-book UTF8 encoding
 @param eBookFilePath                             将要处理的电子书TXT文件路径｜The path of the e-book TXT file to be processed
*/
+ (void)fbHandleEBookUTF8EncodingWithFilePath:(NSString * _Nonnull)eBookFilePath
                                 callback:(void(^)(NSData * _Nullable eBookData, NSError * _Nullable error))callback;


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


/**
 OTA文件增加文件信息，当前此方法仅用于海思芯片方案｜Add file information to the OTA file. Currently, this method is only used in HiSilicon chip solutions.
 @param fileName                                文件完整名称（包含.文件后缀）｜Full file name (including .file suffix)
 @param fileData                                原始文件数据｜Raw file data
 @param OTAType                                 OTA类型｜OTA type
 
 @note ⚠️"fileName"必须严格遵守以下文件命名规则👇:｜⚠️"fileName" must strictly comply with the following file naming rules👇:
 
 1.FB_OTANotification_Firmware
    update.fwpkg（固定命名｜Fixed naming）
 
 2.FB_OTANotification_ClockDial
    Dial_online_L******_xxxxxxxxxx_AAAA.bin（其中******为文件大小，xxxxxxxxxx为时间戳，AAAA为唯一ID｜Where ****** is the file size, xxxxxxxxxx is the timestamp, and AAAA is the unique ID）
 
 3.FB_OTANotification_CustomClockDial           
    Dial_photo_L******_xxxxxxxxxx.bin（其中******为文件大小，xxxxxxxxxx为时间戳｜Where ****** is the file size, xxxxxxxxxx is the timestamp）
 
 4.FB_OTANotification_AGPS_Ephemeris            
    无需重新命名，即用原始文件的名称｜No need to rename, just use the name of the original file
 
 5.FB_OTANotification_JS_App
    JS_AAAA_BBBB_L******_xxxxxxxxxx.bin（其中AAAA为应用唯一ID，BBBB为版本号，******为文件大小，xxxxxxxxxx为时间戳｜AAAA is the unique ID of the application, BBBB is the version number, ****** is the file size, and xxxxxxxxxx is the timestamp.）
 
 6.FB_OTANotification_eBooks
    EBooks_L******_xxxxxxxxxx_AAAA_BBBB.txt（其中******为文件大小，xxxxxxxxxx为时间戳，AAAA为唯一ID，BBBB为显示名称｜Where ****** is the file size, xxxxxxxxxx is the timestamp, AAAA is the unique ID, and BBBB is the display name）
 
 7.FB_OTANotification_Video
    Video_L******_xxxxxxxxxx_AAAA_BBBB.mp4（其中******为文件大小，xxxxxxxxxx为时间戳，AAAA为唯一ID，BBBB为显示名称｜Where ****** is the file size, xxxxxxxxxx is the timestamp, AAAA is the unique ID, and BBBB is the display name）
 
 8.FB_OTANotification_Music
    Music_L******_xxxxxxxxxx_AAAA_BBBB.mp3（其中******为文件大小，xxxxxxxxxx为时间戳，AAAA为唯一ID，BBBB为显示名称｜Where ****** is the file size, xxxxxxxxxx is the timestamp, AAAA is the unique ID, and BBBB is the display name）
 
 9.FB_OTANotification_Ring_Message
    MessSound_L******_xxxxxxxxxx_AAAA_BBBB.mp3（其中******为文件大小，xxxxxxxxxx为时间戳，AAAA为唯一ID，BBBB为显示名称｜Where ****** is the file size, xxxxxxxxxx is the timestamp, AAAA is the unique ID, and BBBB is the display name）
 
 10.FB_OTANotification_Ring_Call
    CallSound_L******_xxxxxxxxxx_AAAA_BBBB.mp3（其中******为文件大小，xxxxxxxxxx为时间戳，AAAA为唯一ID，BBBB为显示名称｜Where ****** is the file size, xxxxxxxxxx is the timestamp, AAAA is the unique ID, and BBBB is the display name）
 
 11.FB_OTANotification_Ring_Alarm
    ClockSound_L******_xxxxxxxxxx_AAAA_BBBB.mp3（其中******为文件大小，xxxxxxxxxx为时间戳，AAAA为唯一ID，BBBB为显示名称｜Where ****** is the file size, xxxxxxxxxx is the timestamp, AAAA is the unique ID, and BBBB is the display name）
 
 
 更多...待拓展｜More...to be expanded
 */
+ (NSData *)createFileName:(NSString * _Nonnull)fileName withFileData:(NSData * _Nonnull)fileData withOTAType:(FB_OTANOTIFICATION)OTAType;


@end

NS_ASSUME_NONNULL_END
