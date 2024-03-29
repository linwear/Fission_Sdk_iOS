//
//  LWCustomDialViewController.m
//  LinWear
//
//  Created by lw on 2021/5/20.
//  Copyright © 2021 lw. All rights reserved.
//

#import "LWCustomDialViewController.h"
#import "LWCustomDialHeaderView.h"
#import "LWCustomDialTableView.h"
#import "LWWaveProgress.h"

@interface LWCustomDialViewController ()

@property (nonatomic, strong) LWCustomDialTableView *tableView;

@property (nonatomic, strong) LWCustomDialHeaderView *headerView;

@property (nonatomic, assign) CGRect butRect;

@end

const CGFloat CustomDiaHeaderViewHeight = 312.0;
const CGFloat CustomDiaHeaderViewStyleBHeight = 262.0;
const CGFloat CustomDiaButtonMargin = 24.0;

@implementation LWCustomDialViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [Tools idleTimerDisabled:YES];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [Tools idleTimerDisabled:NO];
}

- (LWCustomDialTableView *)tableView {
    if (!_tableView) {
        _tableView = [[LWCustomDialTableView alloc] initWithFrame:CGRectMake(0, NavigationContentTop+CustomDiaHeaderViewHeight, SCREEN_WIDTH, SCREEN_HEIGHT-NavigationContentTop-48-k_SafeAreaBottomMargin-CustomDiaButtonMargin-CustomDiaButtonMargin-CustomDiaHeaderViewHeight) style:UITableViewStylePlain];
    }
    return _tableView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = LWLocalizbleString(@"Custom Dial");
        
    self.headerView = [[LWCustomDialHeaderView alloc] initWithFrame:CGRectMake(0, NavigationContentTop, SCREEN_WIDTH, CustomDiaHeaderViewHeight)];
    [self.view addSubview:self.headerView];
    
    [self.view addSubview:self.tableView];
    
    // 设置表盘按钮
    UIButton *setPlateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    setPlateBtn.backgroundColor = BlueColor;
    setPlateBtn.layer.cornerRadius = 24;
    setPlateBtn.titleLabel.font = [NSObject BahnschriftFont:18];
    [setPlateBtn setTitle:LWLocalizbleString(@"Synchronize") forState:UIControlStateNormal];
    [setPlateBtn addTarget:self action:@selector(createCustomDial) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:setPlateBtn];
    [setPlateBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(32);
        make.right.mas_equalTo(-32);
        make.height.mas_equalTo(48);
        make.bottom.mas_equalTo(-k_SafeAreaBottomMargin-CustomDiaButtonMargin);
    }];
    
    self.butRect = CGRectMake(32, SCREEN_HEIGHT-48-k_SafeAreaBottomMargin-CustomDiaButtonMargin, SCREEN_WIDTH-64, 48);
    
    
    // 选择器的选择回调
    WeakSelf(self);
    self.tableView.customDialSelectModeBlock = ^(LWCustomDialSelectMode mode, id  _Nonnull result) {
        if (mode==LWCustomDialSelectFontColor) { // 选择的字体颜色
            UIColor *color = result;
            weakSelf.dialmodel.selectColor = color;
            [weakSelf.headerView selectedCustomDialModel:weakSelf.dialmodel handler:^(UIImage * _Nullable preImage) {
                weakSelf.dialmodel.resolvePreviewImage = preImage;
            }];
            
        } else if (mode==LWCustomDialSelectFontStyle) { // 选择的字体样式
            LWCustomDialStyle style = [result integerValue];
            weakSelf.dialmodel.selectStyle = style;
            [weakSelf.headerView selectedCustomDialModel:weakSelf.dialmodel handler:^(UIImage * _Nullable preImage) {
                weakSelf.dialmodel.resolvePreviewImage = preImage;
            }];
            
        } else if  (mode==LWCustomDialSelectBgImage) { // 选择的背景图片
            UIImage *image = result;
            weakSelf.dialmodel.selectImage = image;
            [weakSelf.headerView selectedCustomDialModel:weakSelf.dialmodel handler:^(UIImage * _Nullable preImage) {
                weakSelf.dialmodel.resolvePreviewImage = preImage;
            }];
            
        } else if  (mode==LWCustomDialSelectPosition) { // 选择的时间位置
            LWCustomTimeLocationStyle position = [result integerValue];
            weakSelf.dialmodel.selectPosition = position;
            [weakSelf.headerView selectedCustomDialModel:weakSelf.dialmodel handler:^(UIImage * _Nullable preImage) {
                weakSelf.dialmodel.resolvePreviewImage = preImage;
            }];
            
        } else if  (mode==LWCustomDialSelectTimeTopStyle) { // 选择的时间上方内容
            LWCustomTimeTopStyle top = [result integerValue];
            weakSelf.dialmodel.selectTimeTopStyle = top;
            [weakSelf.headerView selectedCustomDialModel:weakSelf.dialmodel handler:^(UIImage * _Nullable preImage) {
                weakSelf.dialmodel.resolvePreviewImage = preImage;
            }];
            
        } else if  (mode==LWCustomDialSelectTimeBottomStyle) { // 选择的时间下方内容
            LWCustomTimeBottomStyle bot = [result integerValue];
            weakSelf.dialmodel.selectTimeBottomStyle = bot;
            [weakSelf.headerView selectedCustomDialModel:weakSelf.dialmodel handler:^(UIImage * _Nullable preImage) {
                weakSelf.dialmodel.resolvePreviewImage = preImage;
            }];
            
        } else if (mode==LWCustomDialSelectRestoreDefault) { // 恢复默认设置
            NSString *message = LWLocalizbleString(@"Please confirm whether to restore the default settings?");
            
            [UIAlertObject presentAlertTitle:LWLocalizbleString(@"Tip") message:message cancel:LWLocalizbleString(@"Cancel") sure:LWLocalizbleString(@"OK") block:^(AlertClickType clickType) {
                
                if (clickType == AlertClickType_Sure) {
                    [weakSelf InitializeCustomDialModel];
                }
            }];
        }
        [weakSelf.tableView reloadData];
    };
    
    // 初始化自定义表盘数据
    [self InitializeCustomDialModel];
}

#pragma mark - 初始化自定义表盘数据🌈
- (void)InitializeCustomDialModel{
    // 🌈🌈🌈🌈🌈🌈🌈🌈🌈🌈🌈🌈🌈🌈🌈🌈🌈🌈初始化自定义表盘数据🌈🌈🌈🌈🌈🌈🌈🌈🌈🌈🌈🌈🌈🌈🌈🌈🌈🌈
    self.dialmodel = [LWCustomDialModel new];
    self.dialmodel.selectImage = IMAGE_NAME(@"rgbA");
    self.dialmodel.selectColor = [UIColor whiteColor];
    self.dialmodel.selectStyle = LWCustomDialStyleF;
    self.dialmodel.selectPosition = LWCustomTimeLocationStyleTop;
    self.dialmodel.selectTimeTopStyle = LWCustomTimeTopStyleNone;
    self.dialmodel.selectTimeBottomStyle = LWCustomTimeBottomStyleNone;
    
    NSArray *array = @[
        @{LWLocalizbleString(@"Text Color Replacement") : @[]},
        @{LWLocalizbleString(@"Background Picture") : @[]},
        @{LWLocalizbleString(@"Time Position") : @[@{LWLocalizbleString(@"Top"):@(LWCustomTimeLocationStyleTop)},
                                                   @{LWLocalizbleString(@"Bottom"):@(LWCustomTimeLocationStyleBottom)},
                                                   @{LWLocalizbleString(@"Left"):@(LWCustomTimeLocationStyleLeft)},
                                                   @{LWLocalizbleString(@"Right"):@(LWCustomTimeLocationStyleRight)},
                                                   @{LWLocalizbleString(@"Mid"):@(LWCustomTimeLocationStyleCentre)}]},
        @{LWLocalizbleString(@"Restore Default Settings") : @[]},
    ];
    WeakSelf(self);
    [self.headerView selectedCustomDialModel:self.dialmodel handler:^(UIImage * _Nullable preImage) {
        weakSelf.dialmodel.resolvePreviewImage = preImage;
    }];
    self.tableView.titles = array;
    self.tableView.selectModel = self.dialmodel;
}

#pragma mark - 生成自定义表盘
- (void)createCustomDial {
    WeakSelf(self);
    NSString *message = LWLocalizbleString(@"Please confirm whether the watch face is synchronized");
    
    [UIAlertObject presentAlertTitle:LWLocalizbleString(@"Tip") message:message cancel:LWLocalizbleString(@"Cancel") sure:LWLocalizbleString(@"OK") block:^(AlertClickType clickType) {
        
        if (clickType == AlertClickType_Sure) {
            [weakSelf Synchronize];
        }
    }];
}

- (void)Synchronize {
    
    NSInteger watchDisplayWide = FBAllConfigObject.firmwareConfig.watchDisplayWide;
    NSInteger watchDisplayHigh = FBAllConfigObject.firmwareConfig.watchDisplayHigh;
    CGSize dialSize = CGSizeMake(watchDisplayWide, watchDisplayHigh);
    
    NSInteger dialThumbnailDisplayWide = FBAllConfigObject.firmwareConfig.dialThumbnailDisplayWide;
    NSInteger dialThumbnailDisplayHigh = FBAllConfigObject.firmwareConfig.dialThumbnailDisplayHigh;
    CGSize thumbnailSize = CGSizeMake(dialThumbnailDisplayWide, dialThumbnailDisplayHigh);

    
    FBCustomDialModel *model = [FBCustomDialModel new];
    model.dialSize = dialSize;
    model.thumbnailSize = thumbnailSize;
    model.dialFontColor = self.dialmodel.selectColor;
    model.dialBackgroundImage = self.dialmodel.selectImage;
    model.dialPreviewImage = self.dialmodel.resolvePreviewImage;
    model.dialDisplayPosition = (FB_CUSTOMDIALTIMEPOSITION)self.dialmodel.selectPosition;
    

    NSData *binFile = [[FBCustomDataTools sharedInstance] fbGenerateCustomDialBinFileDataWithDialModel:model];

    
    [NSObject showLoading:LWLocalizbleString(@"Loading...")];
    
    FBBluetoothOTA.sharedInstance.isCheckPower = NO;
    
    FBBluetoothOTA.sharedInstance.sendTimerOut = 30;
            
    [FBBluetoothOTA.sharedInstance fbStartCheckingOTAWithBinFileData:binFile withOTAType:FB_OTANotification_CustomClockDial withBlock:^(FB_RET_CMD status, FBProgressModel * _Nullable progress, FBOTADoneModel * _Nullable responseObject, NSError * _Nullable error) {
        [SVProgressHUD dismiss];
        if (error) {
            [[LWWaveProgress sharedInstance] dismiss];
            [NSObject showHUDText:[NSString stringWithFormat:@"%@", error]];
        }
        else if (status==FB_INDATATRANSMISSION) {
            NSString *title = [NSString stringWithFormat:@"%@ %ld%%", LWLocalizbleString(@"Synchronize"), progress.totalPackageProgress];
            [[LWWaveProgress sharedInstance] showWithFrame:self.butRect withTitle:title withProgress:progress.totalPackageProgress/100.0 withWaveColor:BlueColor];
        }
        else if (status==FB_DATATRANSMISSIONDONE) {
            [[LWWaveProgress sharedInstance] dismiss];
            NSString *message = [NSString stringWithFormat:@"%@",responseObject.mj_keyValues];
            
            [UIAlertObject presentAlertTitle:LWLocalizbleString(@"Success") message:message cancel:nil sure:LWLocalizbleString(@"OK") block:^(AlertClickType clickType) {
                
            }];
            
    
            // 缓存起来，调试用
            NSString *FileName=[FBDocumentDirectory(FBCustomDialFile) stringByAppendingPathComponent:[NSString stringWithFormat:@"FBCustomDial_Ordinary_%ld.bin", (NSInteger)NSDate.date.timeIntervalSince1970]];
            [binFile writeToFile:FileName atomically:YES];//将NSData类型对象data写入文件，文件名为FileName
        }
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
