//
//  LWCustomDialTableView.h
//  LinWear
//
//  Created by 裂变智能 on 2021/6/16.
//  Copyright © 2021 lw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LWCustomDialModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^CustomDialSelectModeBlock)(LWCustomDialSelectMode mode, id result);

@interface LWCustomDialTableView : UITableView

@property (nonatomic, retain) NSArray *titles; // 列表数据源

@property (nonatomic, strong) LWCustomDialModel *selectModel; // 选择的数据

@property (nonatomic, copy) CustomDialSelectModeBlock customDialSelectModeBlock;

@end

NS_ASSUME_NONNULL_END
