//
//  FBTestUIBaseListViewController.m
//  FissionBluetooth
//
//  Created by 裂变智能 on 2023/5/12.
//

#import "FBTestUIBaseListViewController.h"
#import "FBTestUISportsSectionHeader.h"
#import "FBTestUIBaseChartCell.h"
#import "FBTestUIOverviewCell.h"
#import "FBTestUIBaseSportsCell.h"
#import "FBTestUIBaseListCell.h"

#import "FBTestUISportsViewController.h"

@interface FBTestUIBaseListViewController () <UITableViewDataSource, UITableViewDelegate, FSCalendarDataSource, FSCalendarDelegate, FSCalendarDelegateAppearance, UIGestureRecognizerDelegate>

@property (nonatomic, assign) FBTestUIDataType dataType;

@property (nonatomic, strong) NSDate *queryDate;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *calendarTopConstraint;
@property (weak, nonatomic) IBOutlet FSCalendar *calendar;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *calendarHighConstraint;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) UIPanGestureRecognizer *scopeGesture;

@property (nonatomic, strong) NSArray <NSString *> *eventsForDate;

@property (nonatomic, strong) FBTestUIBaseListModel *baseListModel;

@end

static NSString *FBTestUISportsSectionHeaderID = @"FBTestUISportsSectionHeader";
static NSString *FBTestUIBaseChartCellID = @"FBTestUIBaseChartCell";
static NSString *FBTestUIOverviewCellID = @"FBTestUIOverviewCell";
static NSString *FBTestUIBaseSportsCellID = @"FBTestUIBaseSportsCell";
static NSString *FBTestUIBaseListCellID = @"FBTestUIBaseListCell";

@implementation FBTestUIBaseListViewController

- (instancetype)initWithDataType:(FBTestUIDataType)dataType queryDate:(NSDate *)queryDate title:(NSString *)title {
    if (self = [super init]) {
        self.navigationItem.title = title;
        self.dataType = dataType;
        self.queryDate = queryDate;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = LineColor;
    
    FBFirmwareVersionObject *object = FBAllConfigObject.firmwareConfig;
    
    // 日历事件
    self.eventsForDate = [FBLoadDataObject QueryAllRecordWithDataType:self.dataType dateFormat:FBDateFormatYMD deviceName:object.deviceName deviceMAC:object.mac];
    
    // 查询数据
    [self loadBaseListModel:self.queryDate deviceName:object.deviceName deviceMAC:object.mac];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithImage:UIImageMake(@"ic_linear_calendar") style:UIBarButtonItemStylePlain target:self action:@selector(showCalendar)];
    [self.navigationItem setRightBarButtonItem:rightItem animated:YES];
    
    self.calendarTopConstraint.constant = NavigationContentTop;
    
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self.calendar action:@selector(handleScopeGesture:)];
    panGesture.delegate = self;
    panGesture.minimumNumberOfTouches = 1;
    panGesture.maximumNumberOfTouches = 2;
    [self.view addGestureRecognizer:panGesture];
    self.scopeGesture = panGesture;
    
    self.calendar.delegate = self;
    self.calendar.dataSource = self;
    self.calendar.backgroundColor = UIColorWhite;
    self.calendar.appearance.headerTitleColor = BlueColor;
    self.calendar.appearance.weekdayTextColor = BlueColor;
//    self.calendar.appearance.todayColor = GreenColor;
    self.calendar.appearance.selectionColor = BlueColor;
    self.calendar.appearance.borderSelectionColor = UIColorBlack;
    self.calendar.placeholderType = FSCalendarPlaceholderTypeFillHeadTail;
    self.calendar.scope = FSCalendarScopeWeek;
    [self.calendar selectDate:self.queryDate scrollToDate:YES];

    [self.tableView.panGestureRecognizer requireGestureRecognizerToFail:panGesture];
    self.tableView.backgroundColor = UIColorClear;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.tableView registerNib:[UINib nibWithNibName:FBTestUISportsSectionHeaderID bundle:nil] forHeaderFooterViewReuseIdentifier:FBTestUISportsSectionHeaderID];
    [self.tableView registerNib:[UINib nibWithNibName:FBTestUIBaseChartCellID bundle:nil] forCellReuseIdentifier:FBTestUIBaseChartCellID];
    [self.tableView registerNib:[UINib nibWithNibName:FBTestUIOverviewCellID bundle:nil] forCellReuseIdentifier:FBTestUIOverviewCellID];
    [self.tableView registerClass:NSClassFromString(FBTestUIBaseSportsCellID) forCellReuseIdentifier:FBTestUIBaseSportsCellID];
    [self.tableView registerNib:[UINib nibWithNibName:FBTestUIBaseListCellID bundle:nil] forCellReuseIdentifier:FBTestUIBaseListCellID];
}

- (void)showCalendar {

    if (self.calendar.scope == FSCalendarScopeMonth) {
        [self.calendar setScope:FSCalendarScopeWeek animated:YES];
    } else {
        [self.calendar setScope:FSCalendarScopeMonth animated:YES];
    }
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    BOOL shouldBegin = self.tableView.contentOffset.y <= -self.tableView.contentInset.top;
    if (shouldBegin) {
        CGPoint velocity = [self.scopeGesture velocityInView:self.view];
        switch (self.calendar.scope) {
            case FSCalendarScopeMonth:
                return velocity.y < 0;
            case FSCalendarScopeWeek:
                return velocity.y > 0;
        }
    }
    return shouldBegin;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - FSCalendarDataSource, FSCalendarDelegate
- (void)calendar:(FSCalendar *)calendar boundingRectWillChange:(CGRect)bounds animated:(BOOL)animated
{
    self.calendarHighConstraint.constant = CGRectGetHeight(bounds);
    [self.view layoutIfNeeded];
}

- (NSInteger)calendar:(FSCalendar *)calendar numberOfEventsForDate:(NSDate *)date
{
    if ([self.eventsForDate containsObject:[NSDate timeStamp:date.timeIntervalSince1970 dateFormat:FBDateFormatYMD]]) {
        return 1;
    }
    return 0;
}

- (NSArray <UIColor *> *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance eventDefaultColorsForDate:(NSDate *)date
{
    if ([self.eventsForDate containsObject:[NSDate timeStamp:date.timeIntervalSince1970 dateFormat:FBDateFormatYMD]]) {
        return @[BlueColor];
    }
    return nil;
}

- (NSArray <UIColor *> *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance eventSelectionColorsForDate:(NSDate *)date
{
    return @[BlueColor];
}

- (void)calendar:(FSCalendar *)calendar didSelectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition
{
    self.queryDate = date;
    
    if (monthPosition == FSCalendarMonthPositionNext || monthPosition == FSCalendarMonthPositionPrevious) {
        [calendar setCurrentPage:date animated:YES];
    }
    
    FBFirmwareVersionObject *object = FBAllConfigObject.firmwareConfig;
    
    // 查询数据
    [self loadBaseListModel:date deviceName:object.deviceName deviceMAC:object.mac];
    
    [self.tableView reloadData];
}

- (void)loadBaseListModel:(NSDate *)date deviceName:(NSString *)deviceName deviceMAC:(NSString *)deviceMAC {
    FBTestUIBaseListModel *baseListModel = [FBLoadDataObject QueryAllDataWithDate:date dataType:self.dataType deviceName:deviceName deviceMAC:deviceMAC];
    self.baseListModel = baseListModel;
}

#pragma mark - UITableViewDataSource, UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    if (self.dataType == FBTestUIDataType_Step || self.dataType == FBTestUIDataType_Sports) {
        return 1;
    } else {
        return self.baseListModel.section.count + 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (self.dataType == FBTestUIDataType_Sports) {
        return self.baseListModel.sportsArray.count;
    } else {
        if (section == 0) {
            return 1;
        } else if (section-1 < self.baseListModel.section.count) {
            FBTestUIBaseListSection *listSection = self.baseListModel.section[section-1];
            if ([listSection.title isEqualToString:LWLocalizbleString(@"Today's Overview")]) {
                if (self.dataType == FBTestUIDataType_Sleep) {
                    return listSection.overviewArray.count;
                } else {
                    return 1;
                }
            } else if ([listSection.title isEqualToString:LWLocalizbleString(@"Manual Measurement Data")]) {
                return listSection.overviewArray.count;
            }
        }
    }
        
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return section==0 ? 10.0 : 40.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    FBTestUISportsSectionHeader *sectionHeader = [tableView dequeueReusableHeaderFooterViewWithIdentifier:FBTestUISportsSectionHeaderID];
    
    if (section == 0) {
        sectionHeader.title.text = nil;
    } else if (section-1 < self.baseListModel.section.count) {
        FBTestUIBaseListSection *listSection = self.baseListModel.section[section-1];
        sectionHeader.title.text = listSection.title;
    }
    
    return sectionHeader;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.dataType == FBTestUIDataType_Sports) {
        return [self cellHeightForIndexPath:indexPath cellContentViewWidth:SCREEN_WIDTH tableView:tableView];
    }
    
    if (indexPath.section==0) {
        return 400;
    } else {
        if (indexPath.section-1 < self.baseListModel.section.count) {
            FBTestUIBaseListSection *listSection = self.baseListModel.section[indexPath.section-1];
            if ([listSection.title isEqualToString:LWLocalizbleString(@"Today's Overview")]) {
                if (self.dataType == FBTestUIDataType_Sleep) {
                    return 60;
                } else {
                    return 120;
                }
            } else if ([listSection.title isEqualToString:LWLocalizbleString(@"Manual Measurement Data")]) {
                return 60;
            }
        }
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    FBTestUIBaseChartCell *chartCell = [tableView dequeueReusableCellWithIdentifier:FBTestUIBaseChartCellID];
    FBTestUIBaseSportsCell *sportsCell = [tableView dequeueReusableCellWithIdentifier:FBTestUIBaseSportsCellID];
    FBTestUIOverviewCell *overviewCell = [tableView dequeueReusableCellWithIdentifier:FBTestUIOverviewCellID];
    FBTestUIBaseListCell *listCell = [tableView dequeueReusableCellWithIdentifier:FBTestUIBaseListCellID];
    listCell.titleLab.textColor = UIColorBlack;
    listCell.valueLab.textColor = UIColorBlack;
    
    if (self.dataType == FBTestUIDataType_Sports) {
            if (indexPath.row < self.baseListModel.sportsArray.count) {
            RLMSportsModel *sportsModel = self.baseListModel.sportsArray[indexPath.row];
            [sportsCell refreshModel:sportsModel hiddenLine:(indexPath.row == self.baseListModel.sportsArray.count-1)];
        }
        return sportsCell;
    }
    else {
        if (indexPath.section == 0) {
            [chartCell refreshModel:self.baseListModel];
            return chartCell;
        } else {
            
            if (indexPath.section-1 < self.baseListModel.section.count) {
                
                FBTestUIBaseListSection *listSection = self.baseListModel.section[indexPath.section-1];
                
                if (indexPath.row < listSection.overviewArray.count) {
                    
                    FBTestUIOverviewModel *overviewModel = listSection.overviewArray[indexPath.row];
                    
                    if ([listSection.title isEqualToString:LWLocalizbleString(@"Today's Overview")]) {
                        if (self.dataType == FBTestUIDataType_Sleep) {
                            listCell.titleLab.text = overviewModel.title;
                            listCell.valueLab.text = overviewModel.value;
                            if (indexPath.row == 0) {
                                listCell.titleLab.textColor = BlueColor;
                                listCell.valueLab.textColor = BlueColor;
                            }
                            return listCell;
                        } else {
                            [overviewCell reloadOverviewModel:listSection.overviewArray];
                            return overviewCell;
                        }
                    } else if ([listSection.title isEqualToString:LWLocalizbleString(@"Manual Measurement Data")]) {
                        listCell.titleLab.text = overviewModel.title;
                        listCell.valueLab.text = overviewModel.value;
                        return listCell;
                    }
                }
            }
        }
    }
    
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.dataType == FBTestUIDataType_Sports) {
        
        RLMSportsModel *sportsModel = self.baseListModel.sportsArray[indexPath.row];
        FBTestUISportsViewController *vc = FBTestUISportsViewController.new;
        vc.sportsModel = sportsModel;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

@end
