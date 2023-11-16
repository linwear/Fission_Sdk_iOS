//
//  FBAutomaticOTAViewController.m
//  FissionBluetooth
//
//  Created by 裂变智能 on 2023-11-01.
//

#import "FBAutomaticOTAViewController.h"
#import "FBAutomaticOTACell.h"
#import "FBAutomaticOTAOverview.h"
#import "dispatch_source_timer.h"

#import "FBOTAFilePickerViewController.h"
#import "FBOTAFailureReportViewController.h"

@interface FBAutomaticOTAViewController () <QMUITextViewDelegate, UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;
@property (weak, nonatomic) IBOutlet QMUITextView *textView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *hightConstraint;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
@property (weak, nonatomic) IBOutlet UILabel *progressLabel;
@property (weak, nonatomic) IBOutlet UIButton *otaButton;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) FBAutomaticOTAOverview *automaticOTAOverview;

@property (nonatomic, assign) BOOL isPush;

/// 数据源，更新记录
@property (nonatomic, strong) NSMutableArray <FBAutomaticOTAModel *> *dataSource;

/// 失败统计
@property (nonatomic, strong) NSMutableArray <FBAutomaticOTAFailureModel *> *failureSource;

/// 选择的文件
@property (nonatomic, strong) NSArray <FBOTAFilePickerModel *> *selectFileArray;
/// 当前OTA文件索引
@property (nonatomic, assign) NSInteger currentOtaIndex;
/// 更新间隔，秒
@property (nonatomic, assign) int interval;
 
@end

static NSString *FBAutomaticOTACellID = @"FBAutomaticOTACell";
static NSString *FBAutomaticOTAHeaderViewID = @"FBAutomaticOTAHeaderView";

@implementation FBAutomaticOTAViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [Tools idleTimerDisabled:YES];
    
    self.isPush = NO;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [Tools idleTimerDisabled:NO];
    
    if (!self.isPush) {
        [dispatch_source_timer.sharedInstance PauseTiming];
        self.otaButton.selected = NO;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    BOOL isFirmware = self.OTAType==FB_OTANotification_Firmware;
    
    self.topConstraint.constant = NavigationContentTop + 10;

    self.interval = isFirmware ? 90 : 5; // 部分设备重启时间长，固件设置90秒的周期，表盘5秒的周期
    
    if (self.OTAType == FB_OTANotification_Motion || self.OTAType == FB_OTANotification_Multi_Sport) {
        BOOL supportMultipleSports = FBAllConfigObject.firmwareConfig.supportMultipleSports;
        // 错误：单包推送-设备支持多包，多包推送-设备不支持多包
        if ((self.OTAType == FB_OTANotification_Motion && supportMultipleSports) ||
            (self.OTAType == FB_OTANotification_Multi_Sport && !supportMultipleSports)) {
            WeakSelf(self);
            [UIAlertObject presentAlertTitle:LWLocalizbleString(@"Tip") message:LWLocalizbleString(@"This function does not support") cancel:nil sure:LWLocalizbleString(@"OK") block:^(AlertClickType clickType) {
                     
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }];
        }
    }
    
    self.textView.placeholder = LWLocalizbleString(@"Please Select Bin File");
    self.textView.placeholderColor = UIColor.whiteColor;
    self.textView.delegate = self;
    self.textView.font = FONT(17);
    self.textView.textColor = UIColor.whiteColor;
    self.textView.maximumHeight = SCREEN_HEIGHT*0.35;
    
    self.dataSource = NSMutableArray.array;
    self.failureSource = NSMutableArray.array;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.estimatedRowHeight = UITableViewAutomaticDimension;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedSectionHeaderHeight = UITableViewAutomaticDimension;
    self.tableView.sectionHeaderHeight = UITableViewAutomaticDimension;
    [self.tableView registerNib:[UINib nibWithNibName:FBAutomaticOTACellID bundle:nil] forCellReuseIdentifier:FBAutomaticOTACellID];
    [self.tableView registerClass:[FBAutomaticOTAHeaderView class] forHeaderFooterViewReuseIdentifier:FBAutomaticOTAHeaderViewID];
    
    [self.otaButton setBackgroundImage:[UIImage qmui_imageWithColor:BlueColor] forState:UIControlStateNormal];
    [self.otaButton setBackgroundImage:[UIImage qmui_imageWithColor:COLOR_HEX(0xDC143C, 1)] forState:UIControlStateSelected];
    [self.otaButton setTitle:[NSString stringWithFormat:@"OTA【%d s】", self.interval] forState:UIControlStateNormal];
    [self.otaButton setTitle:[NSString stringWithFormat:@"STOP【%d s】", self.interval] forState:UIControlStateSelected];
    
    WeakSelf(self);
    FBAutomaticOTAOverview *automaticOTAOverview = [[FBAutomaticOTAOverview alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0) overviewBlock:^{
        
        weakSelf.isPush = YES;
        
        FBOTAFailureReportViewController *vc = FBOTAFailureReportViewController.new;
        vc.failureSource = weakSelf.failureSource.copy;
        [weakSelf.navigationController wxs_pushViewController:vc makeTransition:^(WXSTransitionProperty *transition) {
            transition.animationType =  WXSTransitionAnimationTypePointSpreadPresent;
            transition.animationTime = 0.7;
            transition.autoShowAndHideNavBar = NO;
            transition.startView = weakSelf.automaticOTAOverview;
        }];
    }];
    self.tableView.tableFooterView = automaticOTAOverview;
    self.automaticOTAOverview = automaticOTAOverview;
    
    [dispatch_source_timer.sharedInstance initializeTiming:0 andStartBlock:^(NSInteger timeIndex) {
        
        weakSelf.progressLabel.text = [NSString stringWithFormat:@"【%ld s】", (weakSelf.interval - timeIndex)];
        
        if (timeIndex >= weakSelf.interval) {
            [dispatch_source_timer.sharedInstance PauseTiming];
            
            if (weakSelf.otaButton.selected) {
                [weakSelf StartOtaWithData:weakSelf.ObtainOtaFile];
            }
        }
    }];
}

- (IBAction)otaClick:(id)sender {
    WeakSelf(self);
    
    if (self.otaButton.selected) {
        [UIAlertObject presentAlertTitle:LWLocalizbleString(@"Tip") message:LWLocalizbleString(@"Confirm that the current OTA will stop immediately after completion?") cancel:LWLocalizbleString(@"Cancel") sure:LWLocalizbleString(@"OK") block:^(AlertClickType clickType) {
                 
            if (clickType == AlertClickType_Sure)
            {
                weakSelf.otaButton.selected = NO;
                [dispatch_source_timer.sharedInstance PauseTiming];
            }
        }];
        return;
    }
    
    if (!self.selectFileArray.count) {
        [NSObject showHUDText:LWLocalizbleString(@"Please Select Bin File")];
        FBLog(@"bin文件为空...请检查...");
        return;
    }
    
    self.otaButton.selected = YES;
    
    [self StartOtaWithData:self.ObtainOtaFile];
}

- (NSData *)ObtainOtaFile {
    
    if (!self.selectFileArray.count) return nil;
    
    NSData *otaData = nil;
    
    // 为运动推送，且支持一次推送多个，得打包合并成一个
    if (self.OTAType == FB_OTANotification_Multi_Sport)
    {
        NSMutableArray <NSData *> *array = NSMutableArray.array;
        for (FBOTAFilePickerModel *model in self.selectFileArray) {
            [array addObject:model.data];
        }
        otaData = [FBCustomDataTools.sharedInstance fbGenerateCustomMultipleMotionBinFileDataWithItems:array isBuilt_in:FB_OTANotification_Multi_Sport];
    }
    else // 顺序执行
    {
        if (self.currentOtaIndex >= self.selectFileArray.count) self.currentOtaIndex = 0;
        
        if (self.currentOtaIndex < self.selectFileArray.count) {
            otaData = self.selectFileArray[self.currentOtaIndex].data;
        }
        
        self.currentOtaIndex += 1;
    }
    
    return otaData;
}

#pragma mark - 启动OTA
- (void)StartOtaWithData:(NSData *)binFile {
    WeakSelf(self);
    
    self.progressView.progress = 0;
    self.progressLabel.text = @"0%";
    
    NSString *title = [NSString stringWithFormat:@"Round %ld", self.dataSource.count+1];
    NSString *string = [NSString stringWithFormat:@"START: size%.2fkb %@", (CGFloat)binFile.length/1024.00, [NSDate timeStamp:NSDate.date.timeIntervalSince1970 dateFormat:FBDateFormatYMDHms]];
    
    FBAutomaticOTAModel *model = FBAutomaticOTAModel.new;
    model.title = title;
    [model.rowArray addObject:string]; // 开始
    [self.dataSource addObject:model];
    
    FBLog(@"%@ %@", title, string);
    
    [self refresh]; // 刷新列表
    
    FBBluetoothOTA.sharedInstance.isCheckPower = NO;
    FBBluetoothOTA.sharedInstance.sendTimerOut = self.OTAType==FB_OTANotification_Firmware ? 90 : 30;
    
    [NSObject showLoading:LWLocalizbleString(@"Loading...")];
   
    [FBBluetoothOTA.sharedInstance fbStartCheckingOTAWithBinFileData:binFile withOTAType:self.OTAType withBlock:^(FB_RET_CMD status, FBProgressModel * _Nullable progress, FBOTADoneModel * _Nullable responseObject, NSError * _Nullable error) {
        
        [NSObject dismiss];
        
        if (error || status == FB_DATATRANSMISSIONDONE) // 失败 or 完成
        {
            weakSelf.automaticOTAOverview.ALL.text = @(weakSelf.automaticOTAOverview.ALL.text.integerValue + 1).stringValue; // 总次数+1
            
            FBAutomaticOTAModel *lastModel = weakSelf.dataSource.lastObject;
            NSString *string = nil;
            if (error) {
                [weakSelf FailureStatisticsWithError:error]; // 失败统计
                
                string = [NSString stringWithFormat:@"FAILURE: PROGRESS%.f%% ERROR%@ %@", weakSelf.progressView.progress*100.0, error.localizedDescription, [NSDate timeStamp:NSDate.date.timeIntervalSince1970 dateFormat:FBDateFormatYMDHms]];
                
                weakSelf.automaticOTAOverview.NG.text = @(weakSelf.automaticOTAOverview.NG.text.integerValue + 1).stringValue; // NG次数+1
            } else {
                string = [NSString stringWithFormat:@"SUCCESS: VELOCITY%.2fkb/s TIME%lds %@", responseObject.velocity, responseObject.totalInterval, [NSDate timeStamp:NSDate.date.timeIntervalSince1970 dateFormat:FBDateFormatYMDHms]];
                
                weakSelf.automaticOTAOverview.OK.text = @(weakSelf.automaticOTAOverview.OK.text.integerValue + 1).stringValue; // OK次数+1
                
                weakSelf.progressView.progress = 1;
                weakSelf.progressLabel.text = @"100%";
            }
            FBLog(@"%@", string);
            [lastModel.rowArray addObject:string];
            
            [weakSelf refresh]; // 刷新列表
            
            if (weakSelf.otaButton.selected) {
                [dispatch_source_timer.sharedInstance CountReset];
                [dispatch_source_timer.sharedInstance StartTiming];
            }
        }
        else if (status == FB_INDATATRANSMISSION) // 进行中...
        {
            weakSelf.progressView.progress = (CGFloat)progress.totalPackageProgress/100.0;
            weakSelf.progressLabel.text = [NSString stringWithFormat:@"%ld%%", progress.totalPackageProgress];
        }
    }];
}

- (void)refresh {
    
    FBAutomaticOTAModel *lastModel = self.dataSource.lastObject;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:lastModel.rowArray.count-1 inSection:self.dataSource.count-1];
    
    [self.tableView reloadData];
    
    NSIndexPath *lastIndexPath = [self.tableView indexPathsForVisibleRows].lastObject;

    if (lastIndexPath.section == self.dataSource.count-1) { // 当在最底部时，滚动至最新
        GCD_AFTER(0.3, ^{
            [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
        });
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark - QMUITextViewDelegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    WeakSelf(self);
    
    self.isPush = YES;
    
    FBOTAFilePickerViewController *vc = [[FBOTAFilePickerViewController alloc] initWithArray:self.selectFileArray block:^(NSArray<FBOTAFilePickerModel *> * _Nonnull array) {
        
        if (weakSelf.OTAType == FB_OTANotification_Multi_Sport) { // 多包运动推送
            int supportCount = (int)FBAllConfigObject.firmwareConfig.supportMultipleSportsCount;
            if (array.count > supportCount) { // 所选的个数超过设备支持个数
                
                GCD_AFTER(1.0, (^{
                    [UIAlertObject presentAlertTitle:LWLocalizbleString(@"Tip") message:[NSString stringWithFormat:LWLocalizbleString(@"The maximum supported number is %d, please select again!"), supportCount] cancel:nil sure:LWLocalizbleString(@"OK") block:^(AlertClickType clickType) { }];
                }));
                
                return;
            }
        }
        
        weakSelf.selectFileArray = array;
        
        NSMutableString *string = NSMutableString.string;
        for (int k = 0; k < array.count; k++) {
            FBOTAFilePickerModel *model = array[k];
            [string appendString:[NSString stringWithFormat:@"🧧%d: size%.2fkb - %@%@", k+1, (CGFloat)model.data.length/1024.00, model.name, k==array.count-1 ? @"" : @"\n"]];
        }
        weakSelf.textView.text = string.copy;
    }];
    [self.navigationController wxs_pushViewController:vc makeTransition:^(WXSTransitionProperty *transition) {
        transition.animationType =  WXSTransitionAnimationTypeSysCubeFromTop;
        transition.animationTime = 0.3;
        transition.autoShowAndHideNavBar = NO;
    }];

    return NO;
}

- (void)textView:(QMUITextView *)textView newHeightAfterTextChanged:(CGFloat)height {
    self.hightConstraint.constant = height<50 ? 50 : height;
}


#pragma mark - UITableViewDelegate, UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section < self.dataSource.count) {
        FBAutomaticOTAModel *model = self.dataSource[section];
        return model.rowArray.count;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    FBAutomaticOTAHeaderView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:FBAutomaticOTAHeaderViewID];
    if (section < self.dataSource.count) {
        FBAutomaticOTAModel *model = self.dataSource[section];
        view.titleLab.text = model.title;
    }
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FBAutomaticOTACell *cell = [tableView dequeueReusableCellWithIdentifier:FBAutomaticOTACellID];
    if (indexPath.section < self.dataSource.count) {
        FBAutomaticOTAModel *model = self.dataSource[indexPath.section];
        if (indexPath.row < model.rowArray.count) {
            NSString *title = model.rowArray[indexPath.row];
            [cell text:title];
        }
    }
    return cell;
}

#pragma mark - 失败统计
- (void)FailureStatisticsWithError:(NSError *)error {
    
    NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(FBAutomaticOTAFailureModel * _Nullable evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
        return (evaluatedObject.errorCode == error.code);
    }];

    NSMutableArray <FBAutomaticOTAFailureModel *> *soures = (NSMutableArray *)[self.failureSource filteredArrayUsingPredicate:predicate]; // 相同error code
    
    FBAutomaticOTAFailureModel *model = nil;
    if (soures.count) {
        model = soures.firstObject;
        model.errorCount += 1;
    } else {
        model = FBAutomaticOTAFailureModel.new;
        model.errorCode = error.code;
        model.errorString = error.localizedDescription;
        model.errorCount = 1;
        [self.failureSource addObject:model];
    }
}

@end
