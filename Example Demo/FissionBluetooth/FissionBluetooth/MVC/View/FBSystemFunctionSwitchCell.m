//
//  FBSystemFunctionSwitchCell.m
//  FissionBluetooth
//
//  Created by 裂变智能 on 2023-07-07.
//

#import "FBSystemFunctionSwitchCell.h"

typedef void(^FBSystemFunctionSwitchCellBlock)(BOOL enable);

@interface FBSystemFunctionSwitchCell ()

@property (nonatomic, copy) FBSystemFunctionSwitchCellBlock block;

@end

@implementation FBSystemFunctionSwitchCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)callBack:(void (^)(BOOL))block {
    self.block = block;
}

- (IBAction)swicthClick:(UISwitch *)sender {
    if (self.block) {
        self.block(sender.on);
    }
}

@end
