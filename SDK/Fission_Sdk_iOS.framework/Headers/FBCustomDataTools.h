//
//  FBCustomDataTools.h
//  FissionBluetooth
//
//  Created by 裂变智能 on 2021/7/6.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/*
 自定义bin文件数据工具｜Custom bin file data tools
*/
@interface FBCustomDataTools : NSObject

/**
 初始化单个实例对象 |  Initializes a single instance object
 */
+ (FBCustomDataTools *)sharedInstance;


#pragma mark - 生成自定义表盘bin文件数据 | Generate custom dial bin file data
/**
 生成自定义表盘bin文件数据 | Generate custom dial bin file data
 @param dialModel                                 自定义表盘参数模型｜Custom dial parameter model
*/
- (NSData *)fbGenerateCustomDialBinFileDataWithDialModel:(FBCustomDialModel *)dialModel;

#pragma mark - 生成自定义运动类型bin文件数据（⚠️暂未开发） | Generate custom motion category bin file data（⚠️Not developed yet)
/**
 生成自定义运动类型bin文件数据（⚠️暂未开发） | Generate custom motion category bin file data (⚠️Not developed yet)
 @param motionModel                             自定义运动类型参数模型｜Custom motion parameters model
*/
- (NSData *)fbGenerateCustomMotionBinFileDataWithMotionModel:(FBCustomMotionModel *)motionModel API_DEPRECATED("⚠️暂未开发｜⚠️Not developed yet", macos(2.0, 2.0), ios(2.0, 2.0), tvos(2.0, 2.0), watchos(2.0, 2.0));


@end

NS_ASSUME_NONNULL_END
