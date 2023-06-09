//
//  LWWaveProgress.h
//  LinWear
//
//  Created by 裂变智能 on 2021/6/22.
//  Copyright © 2021 lw. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LWWaveProgress : UIView

/** 初始化 */
+ (LWWaveProgress *)sharedInstance;

/** 展示视图
 @param frame                视图在窗口中相对位置
 @param title                显示的进度文字
 @param progress         进度，范围 0～1
 @param waveColor       水纹颜色
 */
- (void)showWithFrame:(CGRect)frame withTitle:(NSString *)title withProgress:(CGFloat)progress withWaveColor:(UIColor *)waveColor;

/** 销毁视图 */
- (void)dismiss;

@end

NS_ASSUME_NONNULL_END
