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

- (void)reloadSportsChartModel:(AAChartModel *)aaChartModel listType:(FBSportsListType)listType {
    
    if (listType == FBSportsListType_SportsRealTimePace) {
        AALabels *aaYAxisLabels = AALabels.new
        .formatterSet(@AAJSFunc(function () {
            const yValue = this.value;
            if (yValue == 0) {
                return "0";
            } else if (yValue == 600) {
                return "10‘00“";
            } else if (yValue == 1200) {
                return "20‘00“";
            } else if (yValue == 1800) {
                return "30‘00“";
            } else if (yValue == 2400) {
                return "40‘00“";
            } else if (yValue == 3000) {
                return "50‘00“";
            } else if (yValue == 3600) {
                return "60‘00“";
            } else if (yValue == 4200) {
                return "70‘00“";
            } else if (yValue == 4800) {
                return "80‘00“";
            } else if (yValue == 5400) {
                return "90‘00“";
            } else if (yValue == 5999) {
                return "99‘59“";
            }
        }));

        AAOptions *aaOptions = aaChartModel.aa_toAAOptions;
        aaOptions.yAxis
        .tickPositionsSet(@[@0,@600,@1200, @1800,@2400,
                            @3000,@3600,@4200,@4800,@5400,
                            @5999])
        .labelsSet(aaYAxisLabels);

        [self.aaChartView aa_drawChartWithOptions:aaOptions]; 
    } else {
        [self.aaChartView aa_drawChartWithChartModel:aaChartModel];
    }
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
