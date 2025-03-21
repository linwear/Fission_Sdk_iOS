//
//  UIView+Expand.h
//  FissionBluetooth
//
//  Created by LINWEAR on 2025-01-21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_OPTIONS(NSUInteger, LWCorner) {
    LWCornerTop                 = 1,    // 顶部
    LWCornerBottom              = 2,    // 底部
    LWCornerLeft                = 3,    // 左边
    LWCornerRight               = 4,    // 右边
    LWCornerIgnoreLeftBottom    = 5,    // 除了左下角
    LWCornerIgnoreRightBottom   = 6,    // 除了右下角
    LWCornerAll                 = 0xFF, // 全部
};

@interface UIView (Expand)

- (void)cornerRadius:(CGFloat)r;

/// 设置指定圆角
/// - Parameters:
///   - corners: 要圆角化的角，可以使用 UIRectCorner 枚举来指定，例如 UIRectCornerBottomLeft | UIRectCornerBottomRight
///   - cornerRadius: 圆角的半径大小
- (void)setRoundedCornersWithCorners:(LWCorner)corners
                        cornerRadius:(CGFloat)cornerRadius;

@end

NS_ASSUME_NONNULL_END
