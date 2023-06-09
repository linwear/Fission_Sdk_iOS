//
//  FBTestUIBaseChartCell.m
//  FissionBluetooth
//
//  Created by 裂变智能 on 2023/5/13.
//

#import "FBTestUIBaseChartCell.h"

@interface FBTestUIBaseChartCell ()

@property (weak, nonatomic) IBOutlet AAChartView *aaChartView;

@end

@implementation FBTestUIBaseChartCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.contentView.backgroundColor = UIColorWhite;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)refreshModel:(FBTestUIBaseListModel *)baseListModel {
    
    [self.aaChartView aa_drawChartWithChartModel:baseListModel.aaChartModel];
    
    [self.aaChartView aa_drawChartWithOptions:baseListModel.aaOptions];
}

@end
