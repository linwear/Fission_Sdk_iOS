//
//  FemaleCell.m
//  FissionBluetooth
//
//  Created by 裂变智能 on 2021/6/1.
//

#import "FemaleCell.h"

@implementation FemaleCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self.swi addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
}

- (void)setModel:(FBFemalePhysiologyModel *)model{
    _model = model;
    
    [self.but1 setTitle:[self but1Title:model.HealthModel] forState:UIControlStateNormal];
    
    [self.but2 setTitle:[NSString stringWithFormat:@"%ld",model.daysInAdvance] forState:UIControlStateNormal];
    
    [self.but3 setTitle:[NSString stringWithFormat:@"%ld",model.daysMenstruation] forState:UIControlStateNormal];
    
    [self.but4 setTitle:[NSString stringWithFormat:@"%ld",model.cycleLength] forState:UIControlStateNormal];
    
    [self.but5 setTitle:[NSString stringWithFormat:@"%04ld-%02ld-%02ld",model.lastYear,model.lastMonth,model.lastDay] forState:UIControlStateNormal];
    
    [self.but6 setTitle:model.isPreProduction?@"Days to due date":@"Days Pregnant" forState:UIControlStateNormal];
    
    [self.but7 setTitle:[NSString stringWithFormat:@"%02ld:%02ld",model.reminderHours,model.reminderMinutes] forState:UIControlStateNormal];
    
    self.swi.on = model.reminderSwitch;
}

- (NSString *)but1Title:(NSInteger)type{
    switch (type) {
        case 1:
            return @"Menstrual Period";
            break;
        case 2:
            return @"Pregnancy Period";
            break;
        case 3:
            return @"Pregnancy";
            break;
            
        default:
            return @"Closure";
            break;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)butC1:(id)sender {
    if (self.femaleCellBlock) {
        self.femaleCellBlock(1);
    }
}
- (IBAction)butC2:(id)sender {
    if (self.femaleCellBlock) {
        self.femaleCellBlock(2);
    }
}
- (IBAction)butC3:(id)sender {
    if (self.femaleCellBlock) {
        self.femaleCellBlock(3);
    }
}
- (IBAction)butC4:(id)sender {
    if (self.femaleCellBlock) {
        self.femaleCellBlock(4);
    }
}
- (IBAction)butC5:(id)sender {
    if (self.femaleCellBlock) {
        self.femaleCellBlock(5);
    }
}
- (IBAction)butC6:(id)sender {
    if (self.femaleCellBlock) {
        self.femaleCellBlock(6);
    }
}
- (IBAction)butC7:(id)sender {
    if (self.femaleCellBlock) {
        self.femaleCellBlock(7);
    }
}

- (void)switchAction:(UISwitch*)swi{
    if (self.femaleCellBlock) {
        self.femaleCellBlock(swi.on?100:200);
    }
}

@end
