//
//  LWCustomDialColorCollectionCell.h
//  LinWear
//
//  Created by 裂变智能 on 2021/6/16.
//  Copyright © 2021 lw. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LWCustomDialColorCollectionCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIView *colorView;

- (void)cellColor:(UIColor *)color withSelectColor:(UIColor *)selectColor;

@end

NS_ASSUME_NONNULL_END
