//
//  LWMotionPushCollectionView.h
//  LinWear
//
//  Created by 裂变智能 on 2023/2/25.
//  Copyright © 2023 lw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LWMotionPushClassifyModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LWMotionPushCollectionView : UIView

- (instancetype)initWithIcon:(UIImage *)icon add:(BOOL)isAdd block:(LWMotionPushSelectBlock)block;

@property (nonatomic, strong) NSMutableArray <LWMotionPushModel *> *sportList;

@end

NS_ASSUME_NONNULL_END
