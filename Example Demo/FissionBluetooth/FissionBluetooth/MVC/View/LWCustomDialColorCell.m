//
//  LWCustomDialColorCell.m
//  LinWear
//
//  Created by 裂变智能 on 2021/6/16.
//  Copyright © 2021 lw. All rights reserved.
//

#import "LWCustomDialColorCell.h"
#import "FBColorPickerView.h"

@implementation LWCustomDialColorCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self.bgView updateLayout];
    
    WeakSelf(self);
    FBColorPickerView *colorPickerView = [[FBColorPickerView alloc] initWithFrame:CGRectMake(15, 0, SCREEN_WIDTH-30, self.bgView.height) block:^(UIColor * _Nonnull color) {
        
        if (weakSelf.didSelectColorBlock) {
            weakSelf.didSelectColorBlock(color);
        }
    }];
    [self.bgView addSubview:colorPickerView];
    
    self.titleLabel.textColor = [UIColor blackColor];
    self.titleLabel.font = [NSObject BahnschriftFont:16];
    
    self.lineView.backgroundColor = [UIColor lightGrayColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
