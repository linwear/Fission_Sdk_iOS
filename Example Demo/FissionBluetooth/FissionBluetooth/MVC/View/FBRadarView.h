//
//  FBRadarView.h
//  FissionBluetooth
//
//  Created by 裂变智能 on 2023/1/6.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FBRadarView : UIView

@property (nonatomic, assign, readonly) BOOL isAnimation;

/// 是否开始动画
- (void)animation:(BOOL)isAnimation;

@end

NS_ASSUME_NONNULL_END
