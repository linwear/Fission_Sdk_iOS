//
//  FBTestUIViewController.m
//  FissionBluetooth
//
//  Created by 裂变智能 on 2023/5/5.
//

#import "FBTestUIViewController.h"
#import "FBTestUITodayDataCell.h"
#import "FBTestUISportsRecordCell.h"
#import "FBTestUIItemCell.h"

#import "FBTestUIBaseListViewController.h"

static NSString *FBTestUITodayDataCellID = @"FBTestUITodayDataCell";
static NSString *FBTestUIItemCellID = @"FBTestUIItemCell";
static NSString *FBTestUISportsRecordCellID = @"FBTestUISportsRecordCell";

@interface FBTestUIViewController () <UICollectionViewDelegate, UICollectionViewDataSource, ZLCollectionViewBaseFlowLayoutDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSArray <NSArray <FBTestUIItemModel *> *> *items;

@property (nonatomic, strong) FBLocalHistoricalModel *historicalModel;

@property (nonatomic, strong) UISwitch *rightBarSwitch;

@end

@implementation FBTestUIViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    WeakSelf(self);
    // 今日实时数据
    [FBBgCommand.sharedInstance fbGetCurrentDayActivityDataWithBlock:^(FB_RET_CMD status, float progress, FBCurrentDataModel * _Nullable responseObject, NSError * _Nullable error) {
        
        if (status == FB_DATATRANSMISSIONDONE) {
            
            [weakSelf reloadFBTestUITodayDataCellWithStep:responseObject.currentStep calories:responseObject.currentCalories distance:responseObject.currentDistance];
        }
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = LWLocalizbleString(@"Data Visualization UI");
    self.view.backgroundColor = LineColor;
    
    ZLCollectionViewVerticalLayout *layout = ZLCollectionViewVerticalLayout.new;
    layout.minimumLineSpacing = 10;
    layout.minimumInteritemSpacing = 10;
    layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    layout.delegate = self;
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, NavigationContentTop, SCREEN_WIDTH, SCREEN_HEIGHT-NavigationContentTop) collectionViewLayout:layout];
    collectionView.backgroundColor = UIColorClear;
    collectionView.delegate = self;
    collectionView.dataSource = self;
    [self.view addSubview:collectionView];
    [collectionView registerNib:[UINib nibWithNibName:FBTestUITodayDataCellID bundle:nil] forCellWithReuseIdentifier:FBTestUITodayDataCellID];
    [collectionView registerNib:[UINib nibWithNibName:FBTestUISportsRecordCellID bundle:nil] forCellWithReuseIdentifier:FBTestUISportsRecordCellID];
    [collectionView registerNib:[UINib nibWithNibName:FBTestUIItemCellID bundle:nil] forCellWithReuseIdentifier:FBTestUIItemCellID];
    self.collectionView = collectionView;
    
    [self loadItemData];
    
    WeakSelf(self);
    [self addHeaderView:collectionView refresh:^{
        // 请求历史数据（保存至数据库）
        [weakSelf requestHistoricalData];
    }];
    
    // 请求本地历史数据（查询数据库）
    self.historicalModel = FBLocalHistoricalModel.new;
    [self QueryLocalHistoricalDataAndStep:0 calories:0 distance:0];
    
    /// 实时数据流
    UISwitch *rightBarSwitch = [[UISwitch alloc] qmui_initWithSize:CGSizeMake(50, 30)];
    rightBarSwitch.on = Tools.isStreamOpen;
    [rightBarSwitch addTarget:self action:@selector(rightBarSwitchChanged) forControlEvents:UIControlEventValueChanged];
    self.rightBarSwitch = rightBarSwitch;
    UIBarButtonItem *rightBar = [[UIBarButtonItem alloc] initWithCustomView:rightBarSwitch];
    [self.navigationItem setRightBarButtonItem:rightBar animated:YES];
    
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(realTimeDataStream:) name:FISSION_SDK_REALTIMEDATASTREAM object:nil];
}

- (void)loadItemData {
    
    FBFirmwareVersionObject *object = FBAllConfigObject.firmwareConfig;
    
    FBTestUIItemModel *item_1 = FBTestUIItemModel.new;
    item_1.dataType = FBTestUIDataType_TodayData;
    item_1.title = LWLocalizbleString(@"Today's Data");
    
    FBTestUIItemModel *item_2 = FBTestUIItemModel.new;
    item_2.dataType = FBTestUIDataType_Sports;
    item_2.title = LWLocalizbleString(@"Sports Record");
    item_2.gif = @"icons8-running-gif";
    item_2.icon = @"icons8-running";
    
    NSArray <FBTestUIItemModel *> *section_1 = @[item_1, item_2];
    
    NSMutableArray <FBTestUIItemModel *> *section_2 = NSMutableArray.array;
    
    FBTestUIItemModel *item_3 = FBTestUIItemModel.new;
    item_3.dataType = FBTestUIDataType_Sleep;
    item_3.title = LWLocalizbleString(@"Sleep");
    item_3.icon = @"icons8-night";
    item_3.gradientAColor = COLOR_HEX(0xFFFFFF, 0);
    item_3.gradientBColor = Color_LightS;
    [section_2 addObject:item_3];
    
    FBTestUIItemModel *item_4 = FBTestUIItemModel.new;
    item_4.dataType = FBTestUIDataType_HeartRate;
    item_4.title = LWLocalizbleString(@"Heart Rate");
    item_4.icon = @"icons8-pulse";
    item_4.gradientAColor = COLOR_HEX(0xFFFFFF, 0);
    item_4.gradientBColor = Color_Hr;
    
    [section_2 addObject:item_4];
    
    FBTestUIItemModel *item_5 = FBTestUIItemModel.new;
    item_5.dataType = FBTestUIDataType_BloodOxygen;
    item_5.title = LWLocalizbleString(@"Blood Oxygen");
    item_5.icon = @"icons8-blood-sample";
    item_5.gradientAColor = COLOR_HEX(0xFFFFFF, 0);
    item_5.gradientBColor = Color_Spo2;
    [section_2 addObject:item_5];
    
    if (object.supportBloodPressure || StringIsEmpty(object.mac)) { // 支持 或 未绑定
        FBTestUIItemModel *item_6 = FBTestUIItemModel.new;
        item_6.dataType = FBTestUIDataType_BloodPressure;
        item_6.title = LWLocalizbleString(@"Blood Pressure");
        item_6.icon = @"icons8-syringe";
        item_6.gradientAColor = COLOR_HEX(0xFFFFFF, 0);
        item_6.gradientBColor = Color_Bp_s;
        [section_2 addObject:item_6];
    }
    
    if (object.supportMentalStress || StringIsEmpty(object.mac)) { // 支持 或 未绑定
        FBTestUIItemModel *item_7 = FBTestUIItemModel.new;
        item_7.dataType = FBTestUIDataType_Stress;
        item_7.title = LWLocalizbleString(@"Mental Stress");
        item_7.icon = @"icons8-critical-thinking";
        item_7.gradientAColor = COLOR_HEX(0xFFFFFF, 0);
        item_7.gradientBColor = Color_Stre;
        [section_2 addObject:item_7];
    }
    
    self.items = @[section_1, section_2];
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

#pragma mark - ZLCollectionViewBaseFlowLayoutDelegate, UICollectionViewDataSource
//指定 列布局
- (ZLLayoutType)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewFlowLayout *)collectionViewLayout typeOfLayout:(NSInteger)section {
    
    return ColumnLayout;
}

// 指定哪些是多列
- (NSInteger)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewFlowLayout*)collectionViewLayout columnCountOfSection:(NSInteger)section {
    
    if (section == 0) {
        return 1;
    }
    return 2;
}

// 指定哪些事单列
- (BOOL)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewFlowLayout *)collectionViewLayout singleColumnCountOfIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        return YES;
    }
    return NO;
}

#pragma mark - UICollectionViewDataSource, UICollectionViewDataSource
// 多少组
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return self.items.count;
}

// 一组多少个
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    if (section < self.items.count) {
        return [self.items[section] count];
    }
    return 0;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            
            FBTestUITodayDataCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:FBTestUITodayDataCellID forIndexPath:indexPath];
            
            WeakSelf(self);
            [cell reloadCellModel:self.historicalModel click:^(FBTestUIDataType dataType) {
                
                FBTestUIItemModel *itemModel = FBTestUIItemModel.new;
                itemModel.dataType = dataType;
                if (dataType == FBTestUIDataType_Step) {
                    itemModel.title = LWLocalizbleString(@"Step");
                }
                
                [weakSelf seeMoreTestUIItemModel:itemModel];
            }];
            
            return cell;
        }
        else {
            
            FBTestUISportsRecordCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:FBTestUISportsRecordCellID forIndexPath:indexPath];
            
            [cell reloadCellModel:self.historicalModel.sportsModel];
            
            return cell;
        }
    }
    else {
        
        FBTestUIItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:FBTestUIItemCellID forIndexPath:indexPath];
        cell.contentView.backgroundColor = UIColorWhite;
        
        [cell reloadItem:self.items[indexPath.section][indexPath.row] historicalModel:self.historicalModel];
        
        return cell;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        return CGSizeMake(0, indexPath.row==0 ? 200 : 100); // 宽度随便写，内部会根据layout配置自适应
    }
    else {
        
        CGFloat width = (SCREEN_WIDTH-30)/2;
        return CGSizeMake(0, width*1.08); // 宽度随便写，内部会根据layout配置自适应
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section==0 && indexPath.row==0) return;
    
    NSArray <FBTestUIItemModel *> *section = self.items[indexPath.section];
    FBTestUIItemModel *itemModel = section[indexPath.row];
    
    [self seeMoreTestUIItemModel:itemModel];
}


#pragma mark - 请求历史数据（保存至数据库）｜Request Historical Data (Save to database)
- (void)requestHistoricalData {
    
    WeakSelf(self);
    [FBLoadDataObject requestHistoricalDataWithBlock:^(NSInteger currentStep, NSInteger currentCalories, NSInteger currentDistance, NSString * _Nullable errorString) {
        
        GCD_MAIN_QUEUE(^{
            [weakSelf.collectionView.mj_header endRefreshing];
            
            if (!StringIsEmpty(errorString)) {
                [NSObject showHUDText:errorString];
            }
            
            // 查询本地历史数据（查询数据库）｜Query local historical data (Query Database)
            [weakSelf QueryLocalHistoricalDataAndStep:currentStep calories:currentCalories distance:currentDistance];
        });
    }];
}

#pragma mark - 查询本地历史数据（查询数据库）｜Query local historical data (Query Database)
- (void)QueryLocalHistoricalDataAndStep:(NSInteger)currentStep calories:(NSInteger)currentCalories distance:(NSInteger)currentDistance {
    WeakSelf(self);
    
    [FBLoadDataObject QueryLocalHistoricalDataWithBlock:^(FBLocalHistoricalModel * _Nonnull historicalModel) {
        
        // 如果开启了实时数据流，这里需要处理一下，避免数据回退
        if (weakSelf.historicalModel.currentStep <= currentStep) {
            historicalModel.currentStep = currentStep;
            historicalModel.currentCalories = currentCalories;
            historicalModel.currentDistance = currentDistance;
        } else { // 最新实时数据流数据
            historicalModel.currentStep = weakSelf.historicalModel.currentStep;
            historicalModel.currentCalories = weakSelf.historicalModel.currentCalories;
            historicalModel.currentDistance = weakSelf.historicalModel.currentDistance;
        }
        
        weakSelf.historicalModel = historicalModel;
        
        // 刷新列表
        [weakSelf.collectionView reloadData];
    }];
}


#pragma mark - 查看更多｜see more
- (void)seeMoreTestUIItemModel:(FBTestUIItemModel *)itemModel {
    
    if (itemModel.dataType == FBTestUIDataType_Calorie) return; // 卡路里 return
    
    if (itemModel.dataType == FBTestUIDataType_Distance) { // 选择公英制单位
        
        BRStringPickerView *pickerView = [[BRStringPickerView alloc] initWithPickerMode:BRStringPickerComponentSingle];
        pickerView.title = LWLocalizbleString(@"Distance Unit Setting");
        pickerView.dataSourceArr = @[LWLocalizbleString(@"Metric"), LWLocalizbleString(@"Imperial")];
        pickerView.selectIndex = Tools.isMetric ? 0 : 1;
        [pickerView show];
        WeakSelf(self);
        pickerView.resultModelBlock = ^(BRResultModel * _Nullable resultModel) {
            
            FB_DISTANCEUNIT unit = resultModel.index==0 ? FB_MetricUnit : FB_EnglishUnits;
            // 设置距离单位（公英制）｜Set distance units (metric British system)
            [FBAtCommand.sharedInstance fbUpDistanceUnitData:unit withBlock:^(NSError * _Nullable error) {
                if (error) {
                    [NSObject showHUDText:error.localizedDescription];
                } else {
                    [Tools saveIsMetric:(unit == FB_MetricUnit)];
                    // 刷新 第一组 FBTestUITodayDataCell FBTestUISportsRecordCell
                    [weakSelf reloadSections_1];
                }
            }];
        };
    }
    else {
        NSInteger queryBegin = 0;
        
        if (itemModel.dataType == FBTestUIDataType_Step) {
            queryBegin = NSDate.date.timeIntervalSince1970;
        }
        else if (itemModel.dataType == FBTestUIDataType_HeartRate) {
            queryBegin = self.historicalModel.hrBegin;
        }
        else if (itemModel.dataType == FBTestUIDataType_BloodOxygen) {
            queryBegin = self.historicalModel.spo2Begin;
        }
        else if (itemModel.dataType == FBTestUIDataType_BloodPressure) {
            queryBegin = self.historicalModel.bpBegin;
        }
        else if (itemModel.dataType == FBTestUIDataType_Stress) {
            queryBegin = self.historicalModel.stressBegin;
        }
        else if (itemModel.dataType == FBTestUIDataType_Sleep) {
            queryBegin = self.historicalModel.sleepBegin;
        }
        else if (itemModel.dataType == FBTestUIDataType_Sports) {
            queryBegin = self.historicalModel.sportsBegin;
        }
        
        if (queryBegin <= 0) { // 为0 默认今天
            queryBegin = NSDate.date.timeIntervalSince1970;
        } else {
            NSDate *date = [NSDate dateWithTimeIntervalSince1970:queryBegin];
            queryBegin = date.Time_01-1 == queryBegin ? queryBegin-1 : queryBegin; // 00:00整点的数据为昨天的
        }
        
        NSDate *queryDate = [NSDate dateWithTimeIntervalSince1970:queryBegin];
        // 其他
        FBTestUIBaseListViewController *vc = [[FBTestUIBaseListViewController alloc] initWithDataType:itemModel.dataType queryDate:queryDate title:itemModel.title];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - 刷新 第一组 FBTestUITodayDataCell FBTestUISportsRecordCell
- (void)reloadSections_1 {
    WeakSelf(self);
    [UIView performWithoutAnimation:^{
        [weakSelf.collectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];
    }];
}

#pragma mark - 实时数据流相关
- (void)rightBarSwitchChanged {
    
    // Before opening, please register the listening method -(void)fbStreamDataHandlerWithBlock: to receive stream data
    
    WeakSelf(self);
    [FBAtCommand.sharedInstance fbUpDataStreamData:self.rightBarSwitch.on ? 2 : 0 withBlock:^(NSError * _Nullable error) {
        if (error) {
            [NSObject showHUDText:error.localizedDescription];
            weakSelf.rightBarSwitch.on = !weakSelf.rightBarSwitch.on;
        } else {
            [Tools saveIsStreamOpen:weakSelf.rightBarSwitch.on];
        }
    }];
}

/// 实时数据流
- (void)realTimeDataStream:(NSNotification *)streamObj {
    
    if ([streamObj.object isKindOfClass:FBStreamDataModel.class]) {
        FBStreamDataModel *model = (FBStreamDataModel *)streamObj.object;
        
        [self reloadFBTestUITodayDataCellWithStep:model.currentStepCount calories:model.currentCalories distance:model.currentDistance];
    }
}

/// 刷新 FBTestUITodayDataCell 步数、卡路里、距离
- (void)reloadFBTestUITodayDataCellWithStep:(NSInteger)currentStep calories:(NSInteger)currentCalories distance:(NSInteger)currentDistance {
    
    self.historicalModel.currentStep = currentStep;
    self.historicalModel.currentCalories = currentCalories;
    self.historicalModel.currentDistance = currentDistance;
    
    FBTestUITodayDataCell *todayDataCell = (FBTestUITodayDataCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
    [todayDataCell step:currentStep calories:currentCalories distance:currentDistance];
}

#pragma mark - dealloc
- (void)dealloc {
    [NSNotificationCenter.defaultCenter removeObserver:self];
}

@end
