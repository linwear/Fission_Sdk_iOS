//
//  LWMotionPushDataCell.h
//  LinWear
//
//  Created by 裂变智能 on 2023/2/27.
//  Copyright © 2023 lw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LWMotionPushClassifyModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LWMotionPushDataCell : UITableViewCell

- (void)reload:(LWMotionPushClassifyModel*)model isFirst:(BOOL)isFirstIndex isLast:(BOOL)isLastIndex block:(LWMotionPushSelectBlock)block;

@end

NS_ASSUME_NONNULL_END
