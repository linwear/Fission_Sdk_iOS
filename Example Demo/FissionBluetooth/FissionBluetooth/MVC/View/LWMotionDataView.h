//
//  LWMotionDataView.h
//  LinWear
//
//  Created by 裂变智能 on 2022/1/16.
//  Copyright © 2022 lw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LWSportsConnectModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LWMotionDataView : UIView

// 更新
- (void)reloadWithMotionModel:(LWSportsConnectModel *)model;

@end

NS_ASSUME_NONNULL_END
