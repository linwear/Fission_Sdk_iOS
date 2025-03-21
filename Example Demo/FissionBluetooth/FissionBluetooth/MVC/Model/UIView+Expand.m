//
//  UIView+Expand.m
//  FissionBluetooth
//
//  Created by LINWEAR on 2025-01-21.
//

#import "UIView+Expand.h"

@implementation UIView (Expand)

- (void)cornerRadius:(CGFloat)r {
    [self setRoundedCornersWithCorners:LWCornerAll cornerRadius:r];
}

/**
 设置指定圆角

 @param corners 要圆角化的角，可以使用 UIRectCorner 枚举来指定，例如 UIRectCornerBottomLeft | UIRectCornerBottomRight
 @param cornerRadius 圆角的半径大小
 */
- (void)setRoundedCornersWithCorners:(LWCorner)corners
                        cornerRadius:(CGFloat)cornerRadius {
    
    CACornerMask maskedCorners;
    if (corners == LWCornerTop) {
        maskedCorners = kCALayerMinXMinYCorner | kCALayerMaxXMinYCorner;
    }
    else if (corners == LWCornerBottom) {
        maskedCorners = kCALayerMinXMaxYCorner | kCALayerMaxXMaxYCorner;
    }
    else if (corners == LWCornerLeft) {
        maskedCorners = kCALayerMinXMinYCorner | kCALayerMinXMaxYCorner;
    }
    else if (corners == LWCornerRight) {
        maskedCorners = kCALayerMaxXMinYCorner | kCALayerMaxXMaxYCorner;
    }
    else if (corners == LWCornerIgnoreLeftBottom) {
        maskedCorners = kCALayerMinXMinYCorner | kCALayerMaxXMinYCorner | kCALayerMaxXMaxYCorner;
    }
    else if (corners == LWCornerIgnoreRightBottom) {
        maskedCorners = kCALayerMinXMinYCorner | kCALayerMaxXMinYCorner | kCALayerMinXMaxYCorner;
    }
    else { // all
        maskedCorners = kCALayerMinXMinYCorner | kCALayerMaxXMinYCorner | kCALayerMinXMaxYCorner | kCALayerMaxXMaxYCorner;
    }
    // iOS11+有效
    self.layer.cornerRadius = cornerRadius;
    self.layer.maskedCorners = maskedCorners;
}

@end
