//
//  LWPersonCell.m
//  LinWear
//
//  Created by 裂变智能 on 2021/12/20.
//  Copyright © 2021 lw. All rights reserved.
//

#import "LWPersonCell.h"

@implementation LWPersonCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.name.font = [UIFont systemFontOfSize:16];
    self.name.textColor = UIColor.blackColor;
    
    self.tel.font = [UIFont systemFontOfSize:12];
    self.tel.textColor = UIColor.grayColor;
    
    self.choice.hidden = YES;
    
    self.line.backgroundColor = UIColor.grayColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
