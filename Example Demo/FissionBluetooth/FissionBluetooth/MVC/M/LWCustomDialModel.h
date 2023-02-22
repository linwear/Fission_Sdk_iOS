//
//  LWCustomDialModel.h
//  LinWear
//
//  Created by 裂变智能 on 2021/6/16.
//  Copyright © 2021 lw. All rights reserved.
//

#import <Foundation/Foundation.h>


NS_ASSUME_NONNULL_BEGIN

@interface LWCustomDialModel : NSObject

/** 选择的字体颜色 */
@property (nonatomic, strong) UIColor *selectColor;

/** 选择的字体样式 */
@property (nonatomic, assign) LWCustomDialStyle selectStyle;

/** 选择的背景图片 */
@property (nonatomic, strong) UIImage *selectImage;

/** 选择的时间位置 */
@property (nonatomic, assign) LWCustomTimeLocationStyle selectPosition;

/** 选择的时间上方内容 */
@property (nonatomic, assign) LWCustomTimeTopStyle selectTimeTopStyle;

/** 选择的时间下方内容 */
@property (nonatomic, assign) LWCustomTimeBottomStyle selectTimeBottomStyle;

/** 预览图 */
@property (nonatomic, strong) UIImage *resolvePreviewImage;

@end

NS_ASSUME_NONNULL_END
