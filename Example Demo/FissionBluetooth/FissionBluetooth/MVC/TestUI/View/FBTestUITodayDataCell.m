//
//  FBTestUITodayDataCell.m
//  FissionBluetooth
//
//  Created by 裂变智能 on 2023/5/8.
//

#import "FBTestUITodayDataCell.h"

typedef void(^FBTestUITodayDataClickBlock)(FBTestUIDataType dataType);

@interface FBTestUITodayDataCell ()

@property (weak, nonatomic) IBOutlet QMUIButton *step;

@property (weak, nonatomic) IBOutlet QMUIButton *calorie;

@property (weak, nonatomic) IBOutlet QMUIButton *distance;

@property (weak, nonatomic) IBOutlet AAChartView *aaChartView;

@property (nonatomic, strong) NSArray *y_Array;

@property (nonatomic, copy) FBTestUITodayDataClickBlock block;

@end

@implementation FBTestUITodayDataCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.contentView.backgroundColor = UIColorWhite;
    
    [_step setImage:UIImageMake(@"icon8-steps") forState:UIControlStateNormal];
    [_step setTitleColor:UIColorBlack forState:UIControlStateNormal];
    _step.titleLabel.font = [NSObject BahnschriftFont:17];
    _step.imagePosition = QMUIButtonImagePositionTop;
    _step.spacingBetweenImageAndTitle = 5;
    _step.backgroundColor = UIColorTestRed;


    [_calorie setImage:UIImageMake(@"icon8-calories") forState:UIControlStateNormal];
    [_calorie setTitleColor:UIColorBlack forState:UIControlStateNormal];
    _calorie.titleLabel.font = [NSObject BahnschriftFont:17];
    _calorie.imagePosition = QMUIButtonImagePositionTop;
    _calorie.spacingBetweenImageAndTitle = 5;
    _calorie.backgroundColor = UIColorTestGreen;


    [_distance setImage:UIImageMake(@"icon8-distance") forState:UIControlStateNormal];
    [_distance setTitleColor:UIColorBlack forState:UIControlStateNormal];
    _distance.titleLabel.font = [NSObject BahnschriftFont:17];
    _distance.imagePosition = QMUIButtonImagePositionTop;
    _distance.spacingBetweenImageAndTitle = 5;
    _distance.backgroundColor = UIColorTestBlue;
    
    self.y_Array = @[
        @0, @0, @0, @0, @0,
        @0, @0, @0, @0, @0,
        @0, @0, @0, @0, @0,
        @0, @0, @0, @0, @0,
        @0, @0, @0, @0
    ];
}


- (IBAction)stepClick:(id)sender {
    FBLog(@"点击了步数...");
    if (self.block) {
        self.block (FBTestUIDataType_Step);
    }
}


- (IBAction)calorieClick:(id)sender {
    FBLog(@"点击了卡路里...");
    if (self.block) {
        self.block (FBTestUIDataType_Calorie);
    }
}


- (IBAction)distanceClick:(id)sender {
    FBLog(@"点击了距离...");
    if (self.block) {
        self.block (FBTestUIDataType_Distance);
    }
}

- (void)step:(NSInteger)step calories:(NSInteger)calories distance:(NSInteger)distance {
    
    [self.step setTitle:[NSString stringWithFormat:@"%ld", step] forState:UIControlStateNormal];
    
    [self.calorie setTitle:[NSString stringWithFormat:@"%ld kcal", calories] forState:UIControlStateNormal];
    
    [self.distance setTitle:[Tools distanceConvert:distance space:YES] forState:UIControlStateNormal];
}

- (void)reloadCellModel:(FBLocalHistoricalModel *)model click:(nonnull void (^)(FBTestUIDataType))block {
    
    self.block = block;
    
    if (model.stepsArray.count) {
        self.y_Array = model.stepsArray;
    }
    
    [self step:model.currentStep calories:model.currentCalories distance:model.currentDistance];
    
    NSInteger track = floor([[self.y_Array valueForKeyPath:@"@max.floatValue"] floatValue] * 0.1);
    NSMutableArray *trackArray = NSMutableArray.array;
    NSMutableArray *fillArray = NSMutableArray.array;
    for (NSNumber *step in self.y_Array) {
        [trackArray addObject: step.integerValue>0 ? [NSNull null] : track>0 ? @(track) : @(1)];
        [fillArray addObject: step.integerValue>0 ? (step.integerValue<track ? @(track) : step) : [NSNull null]];
    }
    
    
    AAChartModel *aaChartModel = AAChartModel.new
        .chartTypeSet(AAChartTypeColumn)
        .animationTypeSet(AAChartAnimationBounce)
        .stackingSet(AAChartStackingTypeNormal)
        .xAxisVisibleSet(NO)
        .yAxisVisibleSet(NO)
        .legendEnabledSet(NO)
        .tooltipSharedSet(YES)
        .colorsThemeSet(@[@"#D3D3D3", HEX_STR_COLOR(BlueColor)])
        .categoriesSet(x_Hour)
        .seriesSet(@[
            AASeriesElement.new
                .borderRadiusTopLeftSet((id)@"50%")
                .borderRadiusTopRightSet((id)@"50%")
                .dataSet(trackArray),
            AASeriesElement.new
                .borderRadiusTopLeftSet((id)@"50%")
                .borderRadiusTopRightSet((id)@"50%")
                .dataSet(fillArray)
        ]);
    
    if (![trackArray containsObject:[NSNull null]]) {
        aaChartModel.yAxisMaxSet(@10);
    }

    [self.aaChartView aa_drawChartWithChartModel:aaChartModel];

    [self bubbleWithChartModel:aaChartModel];
}

- (void)bubbleWithChartModel:(AAChartModel *)aaChartModel {
    NSArray *arr = @[LWLocalizbleString(@"Step")];
    
    NSString *x_JS = [x_Hour aa_toJSArray];
    NSString *y_JS = [self.y_Array aa_toJSArray];
    NSString *unit_JS = [arr aa_toJSArray];
    
    NSString *jsFormatterStr = [NSString stringWithFormat:@AAJSFunc(
                                                                    function () {
                                                                        const x_JS_Array = %@;
                                                                        const y_JS_Array = %@;
                                                                        const unit = %@;
                                                                        //‼️以 this.point.index 这种方式获取选中的点的索引必须设置 tooltip 的 shared 为 false
                                                                        //‼️共享时是 this.points (由多个 point 组成的 points 数组)
                                                                        //‼️非共享时是 this.point 单个 point 对象
                                                                        const selectedSeries = this.points[0];
                                                                        const pointIndex = selectedSeries.point.index;
                                                                        const time = x_JS_Array[pointIndex] + "&nbsp";
                                                                        const step = unit + "&nbsp" + y_JS_Array[pointIndex];
                                                                        
                                                                        const wholeContentStr =  time + step;
                                                                        
                                                                        return wholeContentStr;
                                                                    }), x_JS, y_JS, unit_JS];
    
    AAOptions *aaOptions = aaChartModel.aa_toAAOptions;
    aaOptions.chart.marginTop = @0;
    aaOptions.chart.marginBottom = @5;
    AATooltip *tooltip = aaOptions.tooltip;
    tooltip
        .sharedSet(true)
        .useHTMLSet(true)
        .formatterSet(jsFormatterStr)
        .backgroundColorSet(AAColor.whiteColor)
        .borderColorSet(HEX_STR_COLOR(BlueColor))//边缘颜色
        .styleSet(AAStyleColor(HEX_STR_COLOR(BlueColor)))//文字颜色
    ;
        
    aaOptions.chart
        .eventsSet(AAChartEvents.new
            .loadSet(@AAJSFunc(function () {
                const chart = this;
                Highcharts.addEvent(
                    chart.tooltip,
                    'refresh',
                    function () {
                        //设置 tooltip 自动隐藏的时间
                        chart.tooltip.hide(5000);
                });
            })));
    
    [self.aaChartView aa_drawChartWithOptions:aaOptions];
}

@end
