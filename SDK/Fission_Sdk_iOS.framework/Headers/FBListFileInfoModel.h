//
//  FBListFileInfoModel.h
//  FissionBluetooth
//
//  Created by 裂变智能 on 2024-05-22.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 列表文件信息｜List file information
*/
@interface FBListFileInfoModel : NSObject

/**
 文件完整名称，参考（FBCustomDataTools）-createFileName:的命名规则｜The complete name of the file, refer to the naming rules of (FBCustomDataTools)-createFileName:
*/
@property (nonatomic, copy) NSString *fileName;

/**
 文件大小（单位Byte）｜File size (unit Byte)
*/
@property (nonatomic, assign) NSInteger fileSize;

/**
 创建文件名称的时间戳｜Timestamp when file name was created
*/
@property (nonatomic, assign) NSInteger createTimestamp;


// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


#pragma mark - 当为 在线表盘、JS应用、音乐、视频、电子书、消息提示音、来电铃声、闹钟铃声 文件列表时，以下值，有效｜When it is an online watch face, JS application, music, video, e-book, message reminder tone, incoming call ringtone, alarm ringtone file list, the following values ​​are valid
/**
 唯一ID｜Unique ID
*/
@property (nonatomic, copy, nullable) NSString *uid;


// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


#pragma mark - 当为 JS应用 文件列表时，以下值，有效｜When applying file lists for JS, the following values are valid
/**
 JS应用版本号（例如V0.01）｜JS application version number（For example, V0.01）
*/
@property (nonatomic, copy, nullable) NSString *jsAppVersion;


// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


#pragma mark - 当为 音乐、视频、电子书、消息提示音、来电铃声、闹钟铃声 文件列表时，以下值，有效｜When it is a list of music, video, e-book, message alert tone, incoming call ringtone, alarm ringtone, the following values ​​are valid
/**
 名称｜Name
*/
@property (nonatomic, copy, nullable) NSString *name;

@end

NS_ASSUME_NONNULL_END
