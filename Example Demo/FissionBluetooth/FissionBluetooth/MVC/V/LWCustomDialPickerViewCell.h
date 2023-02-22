//
//  LWCustomDialPickerViewCell.h
//  LinWear
//
//  Created by 裂变智能 on 2021/6/16.
//  Copyright © 2021 lw. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LWCustomDialPickerViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *rigImage;
@property (weak, nonatomic) IBOutlet UIView *lineView;

@end

NS_ASSUME_NONNULL_END
