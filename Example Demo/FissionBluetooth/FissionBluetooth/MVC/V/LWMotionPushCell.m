//
//  LWMotionPushCell.m
//  LinWear
//
//  Created by 裂变智能 on 2021/11/1.
//  Copyright © 2021 lw. All rights reserved.
//

#import "LWMotionPushCell.h"

@implementation LWMotionPushCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.cellTitle.textColor = UIColorBlack;
    self.cellTitle.font = FONT(12);
}

@end
