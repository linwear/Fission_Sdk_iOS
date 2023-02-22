//
//  LWCustomDialColorCell.h
//  LinWear
//
//  Created by 裂变智能 on 2021/6/16.
//  Copyright © 2021 lw. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^DidSelectColorBlock)(UIColor * _Nullable didSelectColor);

NS_ASSUME_NONNULL_BEGIN

@interface LWCustomDialColorCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIView *lineView;

@property (nonatomic, copy) DidSelectColorBlock didSelectColorBlock;

/** 选中的字体颜色 */
@property (nonatomic, retain) UIColor *selectColor;

@end

NS_ASSUME_NONNULL_END
