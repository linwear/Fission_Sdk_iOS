//
//  FBResumeDownloadFileModel.h
//  FissionBluetooth
//
//  Created by LINWEAR on 2025-03-26.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 文件信息｜File information
*/
@interface FBResumeDownloadFileModel : NSObject

/**
 文件格式类型
 */
@property (nonatomic, assign) FB_FILETYPE fileType;

/**
 文件完整数据长度
 */
@property (nonatomic, assign) NSInteger fileLength;

/**
 文件数据内容 crc 校验值
 */
@property (nonatomic, assign) NSInteger fileCrc;

/**
 文件数据
 */
@property (nonatomic, strong) NSData *fileData;

@end

NS_ASSUME_NONNULL_END
