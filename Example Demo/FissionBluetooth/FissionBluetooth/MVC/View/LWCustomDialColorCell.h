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

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIView *lineView;

@property (nonatomic, copy) DidSelectColorBlock didSelectColorBlock;

@end

NS_ASSUME_NONNULL_END
