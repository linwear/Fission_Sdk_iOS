//
//  FBTextImageView.h
//  FissionBluetooth
//
//  Created by 裂变智能 on 2023-07-12.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// 控制图片的位置
typedef NS_ENUM(NSUInteger, FBTextImagePosition) {
    FBTextImageFill,                    // 只显示imageView，铺满
    FBTextImagePositionTop,             // imageView在titleLable上面
    FBTextImagePositionLeft,            // imageView在titleLable左边
    FBTextImagePositionBottom,          // imageView在titleLable下面
    FBTextImagePositionRight,           // imageView在titleLable右边
};

@interface FBTextImageView : UIView

@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, strong) UILabel *titleLable;

@property (nonatomic, assign) FBTextImagePosition imagePosition;

@end

NS_ASSUME_NONNULL_END
