//
//  LWCustomDialColorCollectionCell.m
//  LinWear
//
//  Created by 裂变智能 on 2021/6/16.
//  Copyright © 2021 lw. All rights reserved.
//

#import "LWCustomDialColorCollectionCell.h"

@implementation LWCustomDialColorCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.bgView.backgroundColor = [UIColor whiteColor];
    [NSObject setView:self.bgView cornerRadius:12 borderWidth:2 borderColor:COLOR_HEX(0xFFFFFF, 1)];
    
    self.colorView.backgroundColor = [UIColor whiteColor];
    [NSObject setView:self.colorView cornerRadius:8 borderWidth:0 borderColor:nil];
}

- (void)cellColor:(UIColor *)color withSelectColor:(UIColor *)selectColor{
    
    self.colorView.backgroundColor = color;
    
    [NSObject setView:self.bgView cornerRadius:12 borderWidth:2 borderColor:[color isEqual:selectColor]?COLOR_HEX(0x333333, 1):COLOR_HEX(0xFFFFFF, 1)];
}

@end
