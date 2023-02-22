//
//  LWCustomDialPickerViewCell.m
//  LinWear
//
//  Created by 裂变智能 on 2021/6/16.
//  Copyright © 2021 lw. All rights reserved.
//

#import "LWCustomDialPickerViewCell.h"

@implementation LWCustomDialPickerViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.titleLabel.textColor = [UIColor blackColor];
    self.titleLabel.font = [NSObject themePingFangSCMediumFont:16];
    
    self.lineView.backgroundColor = [UIColor lightGrayColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
