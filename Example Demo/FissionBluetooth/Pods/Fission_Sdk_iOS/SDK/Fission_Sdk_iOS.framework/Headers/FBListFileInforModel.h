//
//  FBListFileInforModel.h
//  FissionBluetooth
//
//  Created by 裂变智能 on 2024-05-22.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 列表文件信息｜List file information
*/
@interface FBListFileInforModel : NSObject

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


#pragma mark 当为 JS应用 文件列表时，以下值，有效｜When applying file lists for JS, the following values are valid
/**
 JS应用唯一ID｜JS application unique ID
*/
@property (nonatomic, copy, nullable) NSString *jsAppBundleId;

/**
 JS应用版本号（例如V0.01）｜JS application version number（For example, V0.01）
*/
@property (nonatomic, copy, nullable) NSString *jsAppVersion;


// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


#pragma mark 当为 音频、视频、电子书 文件列表时，以下值，有效｜When it is a list of audio, video, or e-book files, the following values ​​are valid
/**
 名称｜Name
*/
@property (nonatomic, copy, nullable) NSString *name;


@end

NS_ASSUME_NONNULL_END
