//
//  LWCustomDialPickerView.h
//  LinWear
//
//  Created by 裂变智能 on 2021/6/16.
//  Copyright © 2021 lw. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LWCustomDialPickerView : UIView

+ (LWCustomDialPickerView *)sharedInstance;

- (void)showMode:(LWCustomDialSelectMode)mode withTitle:(NSString *)title withArrayData:(NSArray *)arrayData withSelectObj:(NSInteger)obj withBlock:(void(^)(LWCustomDialSelectMode mode, NSInteger result))block;

@end

NS_ASSUME_NONNULL_END
