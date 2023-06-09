//
//  FBColorPickerView.h
//  FissionBluetooth
//
//  Created by 裂变智能 on 2023/5/24.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^FBColorPickerViewBlock)(UIColor *color);

@interface FBColorPickerView : UIView

- (instancetype)initWithFrame:(CGRect)frame block:(FBColorPickerViewBlock)block;

@end

NS_ASSUME_NONNULL_END
