//
//  FBMultipleCustomDialsModel.h
//  FissionBluetooth
//
//  Created by 裂变智能 on 2023-06-14.
//

#import <Foundation/Foundation.h>

@class FBCustomDialItem;

NS_ASSUME_NONNULL_BEGIN

/**
 多项目自定义表盘参数｜Multi-item custom dial parameters
*/
@interface FBMultipleCustomDialsModel : NSObject

/** 基础资源bin文件｜Basic resource bin file */
@property (nonatomic, retain) NSData *packet_bin;

/** 基础资源json文件｜Basic resource json file */
@property (nonatomic, retain) NSDictionary *info_png;

/** 表盘背景图片｜Background picture of dial */
@property (nonatomic, retain) UIImage *dialBackgroundImage;

/** 表盘预览图片（长按手表切换表盘时显示的预览图）｜Dial preview image (the preview image displayed when long press watch to switch dial) */
@property (nonatomic, retain) UIImage *dialPreviewImage;

/** 自定义表盘的项目｜Customized dial items */
@property (nonatomic, retain) NSArray <FBCustomDialItem *> *items;

@end


/**
 项目参数｜Project Parameters
*/
@interface FBCustomDialItem : NSObject

/** 类型｜Type */
@property (nonatomic, assign) FB_CUSTOMDIALITEMS type;

/** 字体颜色，默认白色（RGB 255, 255, 255）｜Font color, default white (RGB 255, 255, 255) */
@property (nonatomic, retain) UIColor *fontColor;

/** 索引｜Index */
@property (nonatomic, assign) NSInteger index;

/** 中心点坐标｜Center Point */
@property (nonatomic, assign) CGPoint center;

@end

NS_ASSUME_NONNULL_END
