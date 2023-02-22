//
//  PushSwitchCell.m
//  FissionBluetooth
//
//  Created by 裂变智能 on 2021/1/21.
//

#import "PushSwitchCell.h"

@implementation PushSwitchCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.cellSwi.on = NO;
    [self.cellSwi addTarget:self action:@selector(pressSwitch:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)pressSwitch:(UISwitch*)swit{
    self.cellSwi.on = swit.on;
    if (self.pushSwitchStaBlock) {
        self.pushSwitchStaBlock(swit.on);
    }
}
@end
