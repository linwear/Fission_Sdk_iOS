//
//  FBCustomDialVideoModel.h
//  FissionBluetooth
//
//  Created by 裂变智能 on 2024-08-12.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 自定义视频表盘参数｜Customize video dial parameters
 
 @note 下面返回的路径文件在每次新的周期中都会被清除，如果需要长期保存，请单独保存。｜The path files returned below will be cleared in each new cycle. If you need to save them for a long time, please save them separately.
*/
@interface FBCustomDialVideoModel : NSObject

/** 最终的视频文件路径｜Final video file path */
@property (nonatomic, copy) NSString *finalVideoPath;

/** 最终的GIF文件路径｜Final GIF file path */
@property (nonatomic, copy) NSString *finalGifPath;

/** 视频封面图片路径｜Video cover image path */
@property (nonatomic, copy) NSString *coverImagePath;

@end

NS_ASSUME_NONNULL_END
