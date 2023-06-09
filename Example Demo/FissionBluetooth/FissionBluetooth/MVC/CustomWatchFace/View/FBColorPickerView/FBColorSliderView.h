//
//  FBColorSliderView.h
//  FissionBluetooth
//
//  Created by 裂变智能 on 2023/5/23.
//

#import <QMUIKit/QMUIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^FBColorSliderViewBlock)(UIColor *color, CGFloat x);

@interface FBColorSliderView : UIControl

- (instancetype)initWithFrame:(CGRect)frame block:(FBColorSliderViewBlock)block;

@end

NS_ASSUME_NONNULL_END
