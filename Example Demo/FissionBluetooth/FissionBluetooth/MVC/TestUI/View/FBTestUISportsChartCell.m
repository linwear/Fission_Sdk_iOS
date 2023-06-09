//
//  FBTestUISportsChartCell.m
//  FissionBluetooth
//
//  Created by 裂变智能 on 2023-06-05.
//

#import "FBTestUISportsChartCell.h"

@interface FBTestUISportsChartCell ()

@property (weak, nonatomic) IBOutlet AAChartView *aaChartView;

@end

@implementation FBTestUISportsChartCell

- (void)reloadSportsChartModel:(AAChartModel *)aaChartModel {
    
    [self.aaChartView aa_drawChartWithChartModel:aaChartModel];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
