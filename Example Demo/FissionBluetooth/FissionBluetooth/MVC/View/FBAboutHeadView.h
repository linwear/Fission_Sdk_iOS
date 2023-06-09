//
//  FBAboutHeadView.h
//  FissionBluetooth
//
//  Created by 裂变智能 on 2023/1/9.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FBAboutHeadView : UIView

- (instancetype)initWithFrame:(CGRect)frame withImage:(UIImage *)image;

- (void)scrollViewDidScroll_y:(CGFloat)offset_y;

@end

NS_ASSUME_NONNULL_END
