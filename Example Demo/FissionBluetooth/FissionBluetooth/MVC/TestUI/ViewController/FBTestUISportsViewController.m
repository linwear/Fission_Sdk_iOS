//
//  FBTestUISportsViewController.m
//  FissionBluetooth
//
//  Created by 裂变智能 on 2023-05-30.
//

#import "FBTestUISportsViewController.h"
#import "FBTestUISportsSectionHeader.h"
#import "FBTestUISportsHeaderView.h"
#import "FBTestUISportsDetailsCell.h"
#import "FBTestUISportsHrRangeCell.h"
#import "FBTestUISportsChartCell.h"
#import "FBTestUIOverviewCell.h"

@interface FBTestUISportsViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray <FBTestUISportsSectionModel *> *dataArray;

@end

static NSString *FBTestUISportsSectionHeaderID = @"FBTestUISportsSectionHeader";
static NSString *FBTestUISportsDetailsCellID = @"FBTestUISportsDetailsCell";
static NSString *FBTestUISportsHrRangeCellID = @"FBTestUISportsHrRangeCell";
static NSString *FBTestUISportsChartCellID = @"FBTestUISportsChartCell";
static NSString *FBTestUIOverviewCellID = @"FBTestUIOverviewCell";

@implementation FBTestUISportsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = [FBLoadDataObject sportName:self.sportsModel.MotionMode];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, NavigationContentTop, SCREEN_WIDTH, SCREEN_HEIGHT-NavigationContentTop) style:UITableViewStylePlain];
    tableView.backgroundColor = UIColorClear;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    BOOL isCalorie = [FBLoadDataObject isCalorie:self.sportsModel];
    
    // tableHeaderView
    FBTestUISportsHeaderView *tableHeaderView = [NSBundle.mainBundle loadNibNamed:@"FBTestUISportsHeaderView" owner:self options:nil].firstObject;
    tableHeaderView.frame = (CGRect){CGPointZero, CGSizeMake(SCREEN_WIDTH, 120)};
    
    tableHeaderView.titleLab.text = isCalorie ? [NSString stringWithFormat:@"%ld kcal", self.sportsModel.calorie] : [Tools distanceConvert:self.sportsModel.distance space:YES];
    tableHeaderView.dateLab.text = [NSString stringWithFormat:@"%@-%@", [NSDate timeStamp:self.sportsModel.begin dateFormat:FBDateFormatYMDHm], [NSDate timeStamp:self.sportsModel.end dateFormat:FBDateFormatHm]];
    
    [Tools setUILabel:tableHeaderView.titleLab setDataArr:@[@"kcal", @"km", @"mi"] setColorArr:@[UIColorBlack, UIColorBlack, UIColorBlack] setFontArr:@[FONT(15), FONT(15), FONT(15)]];
    
    self.tableView.tableHeaderView = tableHeaderView;
    
    [tableView registerNib:[UINib nibWithNibName:FBTestUISportsSectionHeaderID bundle:nil] forHeaderFooterViewReuseIdentifier:FBTestUISportsSectionHeaderID];
    [tableView registerNib:[UINib nibWithNibName:FBTestUISportsDetailsCellID bundle:nil] forCellReuseIdentifier:FBTestUISportsDetailsCellID];
    [tableView registerNib:[UINib nibWithNibName:FBTestUISportsHrRangeCellID bundle:nil] forCellReuseIdentifier:FBTestUISportsHrRangeCellID];
    [tableView registerNib:[UINib nibWithNibName:FBTestUISportsChartCellID bundle:nil] forCellReuseIdentifier:FBTestUISportsChartCellID];
    [tableView registerNib:[UINib nibWithNibName:FBTestUIOverviewCellID bundle:nil] forCellReuseIdentifier:FBTestUIOverviewCellID];
    
    
    [self loadData:isCalorie];
}

- (void)loadData:(BOOL)isCalorie {
    
    // - - - - - - - - - - - - - - - - - - - - - - - - 运动明细 - - - - - - - - - - - - - - - - - - - - - - - -
    FBTestUISportsDetailsModel *model_1 = FBTestUISportsDetailsModel.new;
    model_1.img = @"ic_details_duration_s";
    model_1.title = LWLocalizbleString(@"Duration");
    model_1.details = [Tools HMS:self.sportsModel.duration];
    
    FBTestUISportsDetailsModel *model_2 = FBTestUISportsDetailsModel.new;
    model_2.img = @"ic_details_tempo_s";
    model_2.title = LWLocalizbleString(@"Total Steps");
    model_2.details = [NSString stringWithFormat:@"%ld", self.sportsModel.step];
    
    FBTestUISportsDetailsModel *model_3 = FBTestUISportsDetailsModel.new;
    model_3.img = @"ic_details_calories_s";
    model_3.title = LWLocalizbleString(@"Burn Calories");
    model_3.details = [NSString stringWithFormat:@"%ld kcal", self.sportsModel.calorie];
    
    FBTestUISportsDetailsModel *model_4 = FBTestUISportsDetailsModel.new;
    model_4.img = @"ic_details_spped_s";
    model_4.title = LWLocalizbleString(@"Average Pace");
    model_4.details = [Tools averageSpeed:[Tools averageSpeedWithDistance:self.sportsModel.distance duration:self.sportsModel.duration] unit:YES];
    
    FBTestUISportsDetailsModel *model_5 = FBTestUISportsDetailsModel.new;
    model_5.img = @"ic_details_frequency_s";
    model_5.title = LWLocalizbleString(@"Average Cadence");
    model_5.details = [NSString stringWithFormat:@"%ld %@", self.sportsModel.avgStride, LWLocalizbleString(@"Steps/Minute")];
    
    FBTestUISportsDetailsModel *model_6 = FBTestUISportsDetailsModel.new;
    model_6.img = @"ic_details_pulse_s";
    model_6.title = LWLocalizbleString(@"Average Heart Rate");
    model_6.details = [NSString stringWithFormat:@"%ld bpm", self.sportsModel.avgHeartRate];
    
    NSArray *sectionArray = nil;
    if (isCalorie) {
        sectionArray = @[model_1, model_3, model_6];
    } else {
        sectionArray = @[model_1, model_2, model_3, model_4, model_5, model_6];
    }
    
    FBTestUISportsSectionModel *sectionModel_1 = FBTestUISportsSectionModel.new;
    sectionModel_1.sectionTitle = nil;
    sectionModel_1.listType = FBSportsListType_SportsDetails;
    sectionModel_1.rowArray = sectionArray;
    
    
    // - - - - - - - - - - - - - - - - - - - - - - - - 心率区间 - - - - - - - - - - - - - - - - - - - - - - - -
    CGFloat totalMinute = ceilf(self.sportsModel.duration/60.0);
    
    FBTestUISportsHrRangeModel *hrModel_1 = FBTestUISportsHrRangeModel.new;
    hrModel_1.title = [NSString stringWithFormat:@"%@\n%ld min", LWLocalizbleString(@"Warm Up"), self.sportsModel.heartRate_level_1];
    hrModel_1.progress = self.sportsModel.heartRate_level_1/totalMinute;
    hrModel_1.color = GreenColor;
    
    FBTestUISportsHrRangeModel *hrModel_2 = FBTestUISportsHrRangeModel.new;
    hrModel_2.title = [NSString stringWithFormat:@"%@\n%ld min", LWLocalizbleString(@"Fat Burning"), self.sportsModel.heartRate_level_2];
    hrModel_2.progress = self.sportsModel.heartRate_level_2/totalMinute;
    hrModel_2.color = BlueColor;
    
    FBTestUISportsHrRangeModel *hrModel_3 = FBTestUISportsHrRangeModel.new;
    hrModel_3.title = [NSString stringWithFormat:@"%@\n%ld min", LWLocalizbleString(@"Aerobic Endurance"), self.sportsModel.heartRate_level_3];
    hrModel_3.progress = self.sportsModel.heartRate_level_3/totalMinute;
    hrModel_3.color = COLOR_HEX(0xCD661D, 1);
    
    FBTestUISportsHrRangeModel *hrModel_4 = FBTestUISportsHrRangeModel.new;
    hrModel_4.title = [NSString stringWithFormat:@"%@\n%ld min", LWLocalizbleString(@"Anaerobic Endurance"), self.sportsModel.heartRate_level_4];
    hrModel_4.progress = self.sportsModel.heartRate_level_4/totalMinute;
    hrModel_4.color = COLOR_HEX(0xCD2990, 1);
    
    FBTestUISportsHrRangeModel *hrModel_5 = FBTestUISportsHrRangeModel.new;
    hrModel_5.title = [NSString stringWithFormat:@"%@\n%ld min", LWLocalizbleString(@"Limit"), self.sportsModel.heartRate_level_5];
    hrModel_5.progress = self.sportsModel.heartRate_level_5/totalMinute;
    hrModel_5.color = COLOR_HEX(0xB22222, 1);
    
    FBTestUISportsSectionModel *sectionModel_2 = FBTestUISportsSectionModel.new;
    sectionModel_2.sectionTitle = LWLocalizbleString(@"Exercise Heart Rate Zone");
    sectionModel_2.listType = FBSportsListType_SportsHrRange;
    sectionModel_2.rowArray = @[hrModel_1, hrModel_2, hrModel_3, hrModel_4, hrModel_5];
    
    
    NSArray <FBTestUISportsChartOverviewModel *> *chartOverviewModelArray = [self returnChartOverviewModelArray];
    
    // - - - - - - - - - - - - - - - - - - - - - - - - 运动心率图表 - - - - - - - - - - - - - - - - - - - - - - - -
    FBTestUISportsSectionModel *sectionModel_3 = FBTestUISportsSectionModel.new;
    sectionModel_3.sectionTitle = LWLocalizbleString(@"Exercise Heart Rate");
    sectionModel_3.listType = FBSportsListType_SportsHeartRate;
    sectionModel_3.rowArray = @[chartOverviewModelArray[0].aaChartModel, chartOverviewModelArray[0].overviewArray];
    
    
    // - - - - - - - - - - - - - - - - - - - - - - - - 运动步频图表 - - - - - - - - - - - - - - - - - - - - - - - -
    FBTestUISportsSectionModel *sectionModel_4 = FBTestUISportsSectionModel.new;
    sectionModel_4.sectionTitle = LWLocalizbleString(@"Exercise Cadence");
    sectionModel_4.listType = FBSportsListType_SportsStepFrequency;
    sectionModel_4.rowArray = @[chartOverviewModelArray[1].aaChartModel, chartOverviewModelArray[1].overviewArray];
    
    
    // - - - - - - - - - - - - - - - - - - - - - - - - 运动卡路里图表 - - - - - - - - - - - - - - - - - - - - - - - -
    FBTestUISportsSectionModel *sectionModel_5 = FBTestUISportsSectionModel.new;
    sectionModel_5.sectionTitle = LWLocalizbleString(@"Exercise Calories");
    sectionModel_5.listType = FBSportsListType_SportsCalorie;
    sectionModel_5.rowArray = @[chartOverviewModelArray[2].aaChartModel, chartOverviewModelArray[2].overviewArray];
    
    
    // - - - - - - - - - - - - - - - - - - - - - - - - 运动距离图表 - - - - - - - - - - - - - - - - - - - - - - - -
    FBTestUISportsSectionModel *sectionModel_6 = FBTestUISportsSectionModel.new;
    sectionModel_6.sectionTitle = LWLocalizbleString(@"Movement Distance");
    sectionModel_6.listType = FBSportsListType_SportsDistance;
    sectionModel_6.rowArray = @[chartOverviewModelArray[3].aaChartModel, chartOverviewModelArray[3].overviewArray];
    
    
    // - - - - - - - - - - - - - - - - - - - - - - - - 运动配速图表 - - - - - - - - - - - - - - - - - - - - - - - -
    FBTestUISportsSectionModel *sectionModel_7 = FBTestUISportsSectionModel.new;
    sectionModel_7.sectionTitle = LWLocalizbleString(@"Sport Pace");
    sectionModel_7.listType = FBSportsListType_SportsPace;
    sectionModel_7.rowArray = @[chartOverviewModelArray[4].aaChartModel, chartOverviewModelArray[4].overviewArray];
    
    
    if (isCalorie) {
        self.dataArray = @[sectionModel_1, sectionModel_2, sectionModel_3, sectionModel_5];
    } else {
        self.dataArray = @[sectionModel_1, sectionModel_2, sectionModel_3, sectionModel_4, sectionModel_5, sectionModel_6, sectionModel_7];
    }
}

- (NSArray <FBTestUISportsChartOverviewModel *> *)returnChartOverviewModelArray {
    
    NSMutableArray *heartRateArray = NSMutableArray.array;
    NSMutableArray *stepFrequencyArray = NSMutableArray.array;
    NSMutableArray *calorieArray = NSMutableArray.array;
    NSMutableArray *distanceArray = NSMutableArray.array;
    NSMutableArray *paceArray = NSMutableArray.array;
    
    for (RLMSportsItemModel *item in self.sportsModel.items) {
        [heartRateArray     addObject:item.heartRate==0 ? NSNull.null : @(item.heartRate)];
        [stepFrequencyArray addObject:item.step==0 ?      NSNull.null : @(item.step)];
        [calorieArray       addObject:item.calorie==0 ?   NSNull.null : @(item.calorie)];
        [distanceArray      addObject:item.distance==0 ?  NSNull.null : @([Tools distance_metre_Convert:item.distance])];
        [paceArray          addObject:item.pace==0 ?      NSNull.null : @([Tools paceSwitch:item.pace])];
    }
    
    NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(id  _Nullable evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
        return [evaluatedObject isKindOfClass:NSNumber.class];
    }];
    
    NSArray *hArray = [heartRateArray filteredArrayUsingPredicate:predicate];
    NSArray *sArray = [stepFrequencyArray filteredArrayUsingPredicate:predicate];
    NSArray *cArray = [calorieArray filteredArrayUsingPredicate:predicate];
    NSArray *dArray = [distanceArray filteredArrayUsingPredicate:predicate];
    NSArray *pArray = [paceArray filteredArrayUsingPredicate:predicate];
    
    NSInteger heartRateMax = [[hArray valueForKeyPath:@"@max.floatValue"] integerValue];
//    NSInteger heartRateMin = [[hArray valueForKeyPath:@"@min.floatValue"] integerValue];
    
    NSInteger stepFrequencyMax = [[sArray valueForKeyPath:@"@max.floatValue"] integerValue];
    NSInteger stepFrequencyMin = [[sArray valueForKeyPath:@"@min.floatValue"] integerValue];

    NSInteger calorieMax = [[cArray valueForKeyPath:@"@max.floatValue"] integerValue];
//    NSInteger calorieMin = [[cArray valueForKeyPath:@"@min.floatValue"] integerValue];

    NSInteger distanceMax = [[dArray valueForKeyPath:@"@max.floatValue"] integerValue];
//    NSInteger distanceMin = [[dArray valueForKeyPath:@"@min.floatValue"] integerValue];

    NSInteger paceMax = [[pArray valueForKeyPath:@"@max.floatValue"] integerValue];
    NSInteger paceMin = [[pArray valueForKeyPath:@"@min.floatValue"] integerValue];
    
    // 心率图表
    AAChartModel *heartRateAAChartModel = [self returnChartModel:heartRateArray name:LWLocalizbleString(@"Heart Rate") subtitle:@"bpm" color:Color_Hr max_y:@(heartRateMax *2)];
    
    // 步频图表
    AAChartModel *stepAAChartModel = [self returnChartModel:stepFrequencyArray name:LWLocalizbleString(@"Cadence") subtitle:LWLocalizbleString(@"Steps/Minute") color:BlueColor max_y:@(stepFrequencyMax *2)];
    
    // 卡路里图表
    AAChartModel *calorieAAChartModel = [self returnChartModel:calorieArray name:LWLocalizbleString(@"Calorie") subtitle:@"kcal" color:COLOR_HEX(0xFF8C00, 1) max_y:@(calorieMax *2)];
    
    // 距离图表
    AAChartModel *distanceAAChartModel = [self returnChartModel:distanceArray name:LWLocalizbleString(@"Distance") subtitle:Tools.distanceUnit_metre color:GreenColor max_y:@(distanceMax *2)];
    
    // 配速图表
    AAChartModel *paceAAChartModel = [self returnChartModel:paceArray name:LWLocalizbleString(@"Pace") subtitle:[NSString stringWithFormat:@"s/%@", Tools.distanceUnit] color:COLOR_HEX(0x4682B4, 1) max_y:@(paceMax *2)];
    
    // 心率-概览
    FBTestUISportsChartOverviewModel *chartOverviewModel_1 = FBTestUISportsChartOverviewModel.new;
    chartOverviewModel_1.aaChartModel = heartRateAAChartModel;
    chartOverviewModel_1.overviewArray = @[
        [[FBTestUIOverviewModel alloc] initWithTitle:LWLocalizbleString(@"Average Heart Rate") value:[Tools stringValue:self.sportsModel.avgHeartRate]],
        [[FBTestUIOverviewModel alloc] initWithTitle:LWLocalizbleString(@"Maximum Heart Rate") value:[Tools stringValue:self.sportsModel.maxHeartRate]],
        [[FBTestUIOverviewModel alloc] initWithTitle:LWLocalizbleString(@"Minimum Heart Rate") value:[Tools stringValue:self.sportsModel.minHeartRate]]
    ];
    
    // 步频-概览
    FBTestUISportsChartOverviewModel *chartOverviewModel_2 = FBTestUISportsChartOverviewModel.new;
    chartOverviewModel_2.aaChartModel = stepAAChartModel;
    chartOverviewModel_2.overviewArray = @[
        [[FBTestUIOverviewModel alloc] initWithTitle:LWLocalizbleString(@"Average Cadence") value:[Tools stringValue:self.sportsModel.avgStride]],
        [[FBTestUIOverviewModel alloc] initWithTitle:LWLocalizbleString(@"Maximum Cadence") value:[Tools stringValue:self.sportsModel.maxStride]],
        [[FBTestUIOverviewModel alloc] initWithTitle:LWLocalizbleString(@"Minimum Cadence") value:[Tools stringValue:stepFrequencyMin]]
    ];
    
    // 卡路里-概览
    FBTestUISportsChartOverviewModel *chartOverviewModel_3 = FBTestUISportsChartOverviewModel.new;
    chartOverviewModel_3.aaChartModel = calorieAAChartModel;
    chartOverviewModel_3.overviewArray = @[
        [[FBTestUIOverviewModel alloc] initWithTitle:LWLocalizbleString(@"Average Calories") value:[NSString stringWithFormat:@"%.2f", (CGFloat)self.sportsModel.calorie/(CGFloat)self.sportsModel.items.count]],
        [[FBTestUIOverviewModel alloc] initWithTitle:LWLocalizbleString(@"Highest Calories") value:@(calorieMax).stringValue],
        [[FBTestUIOverviewModel alloc] initWithTitle:LWLocalizbleString(@"Total Calories") value:@(self.sportsModel.calorie).stringValue]
    ];
    
    // 距离-概览
    FBTestUISportsChartOverviewModel *chartOverviewModel_4 = FBTestUISportsChartOverviewModel.new;
    chartOverviewModel_4.aaChartModel = distanceAAChartModel;
    chartOverviewModel_4.overviewArray = @[
        [[FBTestUIOverviewModel alloc] initWithTitle:LWLocalizbleString(@"Average Distance") value:[NSString stringWithFormat:@"%.2f", [Tools distance_metre_Convert:(CGFloat)self.sportsModel.distance/(CGFloat)self.sportsModel.items.count]]],
        [[FBTestUIOverviewModel alloc] initWithTitle:LWLocalizbleString(@"Maximum Distance") value:[NSString stringWithFormat:@"%.2f", [Tools distance_metre_Convert:distanceMax]]],
        [[FBTestUIOverviewModel alloc] initWithTitle:LWLocalizbleString(@"Total Distance") value:[NSString stringWithFormat:@"%.2f", [Tools distance_metre_Convert:self.sportsModel.distance]]]
    ];
    
    // 配速-概览
    FBTestUISportsChartOverviewModel *chartOverviewModel_5 = FBTestUISportsChartOverviewModel.new;
    chartOverviewModel_5.aaChartModel = paceAAChartModel;
    chartOverviewModel_5.overviewArray = @[
        [[FBTestUIOverviewModel alloc] initWithTitle:LWLocalizbleString(@"Average Pace") value:[Tools averageSpeed:[Tools averageSpeedWithDistance:self.sportsModel.distance duration:self.sportsModel.duration] unit:NO]],
        [[FBTestUIOverviewModel alloc] initWithTitle:LWLocalizbleString(@"Best Pace") value:[Tools averageSpeed:[Tools paceSwitch:paceMin] unit:NO]],
        [[FBTestUIOverviewModel alloc] initWithTitle:LWLocalizbleString(@"Minimum Pace") value:[Tools averageSpeed:[Tools paceSwitch:paceMax] unit:NO]]
    ];
    
    return @[chartOverviewModel_1, chartOverviewModel_2, chartOverviewModel_3, chartOverviewModel_4, chartOverviewModel_5];
}

- (AAChartModel *)returnChartModel:(NSArray *)array name:(NSString *)name subtitle:(NSString *)subtitle color:(UIColor *)color max_y:(NSNumber *)max_y {
    
    AAChartModel *aaChartModel = AAChartModel.new
        .chartTypeSet(AAChartTypeAreaspline)
        .animationTypeSet(AAChartAnimationBounce)
        .stackingSet(AAChartStackingTypeNormal)
        .markerRadiusSet(@4)
        .yAxisMaxSet(max_y)
        .legendEnabledSet(NO)
        .dataLabelsEnabledSet(YES)
        .yAxisGridLineStyleSet([AALineStyle styleWithColor:AAColor.lightGrayColor dashStyle:AAChartLineDashStyleTypeLongDashDot])
        .subtitleSet(subtitle)
        .subtitleAlignSet(AAChartAlignTypeLeft)
        .colorsThemeSet(@[HEX_STR_COLOR(color)])
        .seriesSet(@[
            AASeriesElement.new
                .nameSet(name)
                .dataSet(array)
        ]);
    
    return aaChartModel;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataArray[section].rowArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    FBTestUISportsSectionModel *sectionModel = self.dataArray[indexPath.section];
    if (sectionModel.listType == FBSportsListType_SportsDetails ||
        sectionModel.listType == FBSportsListType_SportsHrRange) {
        return 60;
    } else {
        if (indexPath.row == 0) {
            return 300; // 图表
        } else {
            return 120; // 概览
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.section < self.dataArray.count) {
        
        FBTestUISportsSectionModel *sectionModel = self.dataArray[indexPath.section];
        
        if (sectionModel.listType == FBSportsListType_SportsDetails) {
            FBTestUISportsDetailsCell *cell = [tableView dequeueReusableCellWithIdentifier:FBTestUISportsDetailsCellID];
            FBTestUISportsDetailsModel *model = (FBTestUISportsDetailsModel *)sectionModel.rowArray[indexPath.row];
            cell.detailsModel = model;
            return cell;
        }
        else if (sectionModel.listType == FBSportsListType_SportsHrRange) {
            FBTestUISportsHrRangeCell *cell = [tableView dequeueReusableCellWithIdentifier:FBTestUISportsHrRangeCellID];
            FBTestUISportsHrRangeModel *model = (FBTestUISportsHrRangeModel *)sectionModel.rowArray[indexPath.row];
            cell.hrRangeModel = model;
            return cell;
        }
        else {
            
            if (indexPath.row == 0) { // 图表
                FBTestUISportsChartCell *chartCell = [tableView dequeueReusableCellWithIdentifier:FBTestUISportsChartCellID];
                AAChartModel *aaChartModel = (AAChartModel *)sectionModel.rowArray.firstObject;
                [chartCell reloadSportsChartModel:aaChartModel];
                return chartCell;
            }
            else { // 概览
                FBTestUIOverviewCell *overviewCell = [tableView dequeueReusableCellWithIdentifier:FBTestUIOverviewCellID];
                NSArray <FBTestUIOverviewModel *> *overviewArray = (NSArray <FBTestUIOverviewModel *> *)sectionModel.rowArray.lastObject;
                [overviewCell reloadOverviewModel:overviewArray];
                return overviewCell;
            }
        }
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    FBTestUISportsSectionModel *sectionModel = self.dataArray[section];
    return StringIsEmpty(sectionModel.sectionTitle) ? 0.0 : 40.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    FBTestUISportsSectionModel *sectionModel = self.dataArray[section];
    if (StringIsEmpty(sectionModel.sectionTitle)) return nil;
    
    FBTestUISportsSectionHeader *sectionHeader = [tableView dequeueReusableHeaderFooterViewWithIdentifier:FBTestUISportsSectionHeaderID];
    sectionHeader.title.text = sectionModel.sectionTitle;
    return sectionHeader;
}

@end


@implementation FBTestUISportsSectionModel
@end


@implementation FBTestUISportsChartOverviewModel
@end
