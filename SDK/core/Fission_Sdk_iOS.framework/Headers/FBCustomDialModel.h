//
//  FBCustomDialModel.h
//  FissionBluetooth
//
//  Created by 裂变智能 on 2021/7/6.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class FBCustomDialResult;

/**
 自定义表盘参数｜Custom dial parameters
*/
@interface FBCustomDialModel : NSObject

/** 表盘背景图片｜Background picture of dial */
@property (nonatomic, retain) UIImage *dialBackgroundImage;

/** 表盘背景视频 (仅部分手表支持 @link +fbHandleVideoDialWithPath)｜Watch face background video (supported only by some watches @link +fbHandleVideoDialWithPath) */
@property (nonatomic, copy) NSString *dialVideoPath;

/** 表盘预览图片（长按手表切换表盘时显示的预览图）｜Dial preview image (the preview image displayed when long press watch to switch dial) */
@property (nonatomic, retain) UIImage *dialPreviewImage;

/** 表盘时间内容显示位置｜Time content display position of dial */
@property (nonatomic, assign) FB_CUSTOMDIALTIMEPOSITION dialDisplayPosition;

/** 表盘字体颜色｜Dial font color */
@property (nonatomic, retain) UIColor *dialFontColor;

@end


/**
 自定义表盘｜Custom Dial
 */
@interface FBCustomDialResult : NSObject

/** 原始大小（字节）｜Original size (bytes) */
@property (nonatomic, assign) NSUInteger originalSize;

/** 表盘bin文件 */
@property (nonatomic, strong) NSData *dialData;

@end

NS_ASSUME_NONNULL_END
