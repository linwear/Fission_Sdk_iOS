//
//  LWCustomDialHeaderView.h
//  LinWear
//
//  Created by lw on 2021/5/21.
//  Copyright © 2021 lw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LWCustomDialModel.h"

typedef void (^ResultBlock)(UIImage* _Nullable preImage);

NS_ASSUME_NONNULL_BEGIN

@interface LWCustomDialHeaderView : UIView

@property (nonatomic, copy) ResultBlock resultBlock;

/** 拓步手表的自定义表盘
@param model 选择表盘的数据模型
 */
- (void)selectedCustomDialModel:(LWCustomDialModel *)model handler:(ResultBlock)resultBlock;

@end

NS_ASSUME_NONNULL_END
