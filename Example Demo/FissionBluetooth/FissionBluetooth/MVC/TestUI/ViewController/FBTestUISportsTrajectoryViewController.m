//
//  FBTestUISportsTrajectoryViewController.m
//  FissionBluetooth
//
//  Created by 裂变智能 on 2023-10-21.
//

#import "FBTestUISportsTrajectoryViewController.h"
#import "FBMapView.h"
#import "FBRecordScreen.h"

@interface FBTestUISportsTrajectoryViewController () <RPPreviewViewControllerDelegate>

@property (nonatomic, strong) FBMapView *mapView;

@property (nonatomic, assign) BOOL hiddenBar;

@property (nonatomic, strong) QMUIGridView *gridView; // 概览

@property (nonatomic, strong) UIView *countingView;
@property (nonatomic, strong) UICountingLabel *distanceLabel;
@property (nonatomic, strong) UICountingLabel *durationLabel;

@end

#define Overview_Height 70.0

@implementation FBTestUISportsTrajectoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 初始化地图
    FBMapView *mapView = [[FBMapView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    mapView.optimization = YES; // 默认开启轨迹优化
    [self.view addSubview:mapView];
    self.mapView = mapView;
    
    self.navigationItem.leftItemsSupplementBackButton = YES; // 保留返回按钮
    
    // 视屏录制分享按钮
    UIBarButtonItem *videoShareBar = [[UIBarButtonItem alloc] initWithImage:UIImageMake(@"ic_sports_videoShare") style:UIBarButtonItemStylePlain target:self action:@selector(startRecordingScreen)];
    
    // 左边按钮
    [self.navigationItem setLeftBarButtonItem:videoShareBar animated:YES];
    
    // 轨迹优化按钮
    UISwitch *optimizeSwitch = [[UISwitch alloc] qmui_initWithSize:CGSizeMake(50, 30)];
    optimizeSwitch.on = self.mapView.optimization;
    [optimizeSwitch addTarget:self action:@selector(dataLoading:) forControlEvents:UIControlEventValueChanged];
    UIBarButtonItem *optimizeBar = [[UIBarButtonItem alloc] initWithCustomView:optimizeSwitch];
    
    // 轨迹回放按钮
    UIBarButtonItem *playBar = [[UIBarButtonItem alloc] initWithImage:UIImageMake(@"ic_sports_play") style:UIBarButtonItemStylePlain target:self action:@selector(playing)];
    
    // 右边按钮
    [self.navigationItem setRightBarButtonItems:@[optimizeBar, playBar] animated:YES];
    
    
    // 概览
    QMUIGridView *gridView = [[QMUIGridView alloc] init];
    gridView.columnCount = 3;
    gridView.rowHeight = Overview_Height;
    gridView.separatorWidth = 1;
    gridView.separatorColor = UIColorBlack;
    gridView.separatorDashed = NO;
    gridView.layer.borderWidth = gridView.separatorWidth;
    gridView.layer.borderColor = gridView.separatorColor.CGColor;
    [self.mapView addSubview:gridView];
    [gridView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.bottom.mas_equalTo(-30);
        make.height.mas_equalTo(Overview_Height);
    }];
    self.gridView = gridView;
    // 将要布局的 item 以 addSubview: 的方式添加进去即可自动布局
    QMUILabel *duration = [[QMUILabel alloc] qmui_initWithFont:FONT(12) textColor:UIColorMakeWithHex(@"#696969")];
    duration.backgroundColor = [UIColorWhite colorWithAlphaComponent:.6];
    duration.numberOfLines = 0;
    duration.lineBreakMode = NSLineBreakByWordWrapping;
    duration.textAlignment = NSTextAlignmentCenter;
    [gridView addSubview:duration];
    NSString *durationString = [Tools HMS:self.sportsModel.duration];
    duration.text = [NSString stringWithFormat:@"%@\n%@", LWLocalizbleString(@"运动用时"), durationString];
    [Tools setUILabel:duration setDataArr:@[durationString] setColorArr:@[UIColorBlack] setFontArr:@[UIFontBoldMake(15)]];
    
    QMUILabel *distance = QMUILabel.new;
    [distance qmui_setTheSameAppearanceAsLabel:duration];
    distance.numberOfLines = 0;
    [gridView addSubview:distance];
    NSString *distanceString = [Tools distanceConvert:self.sportsModel.distance space:NO];
    distance.text = [NSString stringWithFormat:@"%@\n%@", LWLocalizbleString(@"运动距离"), distanceString];
    [Tools setUILabel:distance setDataArr:@[distanceString] setColorArr:@[UIColorBlack] setFontArr:@[UIFontBoldMake(15)]];
    
    QMUILabel *calorie = QMUILabel.new;
    [calorie qmui_setTheSameAppearanceAsLabel:duration];
    calorie.numberOfLines = 0;
    [gridView addSubview:calorie];
    NSString *calorieString = [NSString stringWithFormat:@"%ldkcal", self.sportsModel.calorie];
    calorie.text = [NSString stringWithFormat:@"%@\n%@", LWLocalizbleString(@"消耗热量"), calorieString];
    [Tools setUILabel:calorie setDataArr:@[calorieString] setColorArr:@[UIColorBlack] setFontArr:@[UIFontBoldMake(15)]];
    
    // 运动距离
    UIView *countingView = UIView.new;
    countingView.backgroundColor = UIColorClear;
    [self.view addSubview:countingView];
    [countingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(NavigationContentTop);
        make.leading.mas_equalTo(30);
        make.trailing.mas_equalTo(-30);
        make.height.mas_equalTo(90);
    }];
    countingView.hidden = countingView;
    self.countingView = countingView;
    
    QMUILabel *titleLab = [[QMUILabel alloc] qmui_initWithFont:FONT(12) textColor:UIColor.blackColor];
    titleLab.text = LWLocalizbleString(@"运动距离");
    [countingView addSubview:titleLab];
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.mas_equalTo(0);
    }];
    
    UICountingLabel *distanceLabel = UICountingLabel.new;
    distanceLabel.font = FONT(34);
    distanceLabel.format = @"%.2f";
    distanceLabel.method = UILabelCountingMethodLinear;
    [countingView addSubview:distanceLabel];
    [distanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(titleLab.mas_bottom).offset(0);
        make.leading.mas_equalTo(titleLab.mas_leading);
    }];
    self.distanceLabel = distanceLabel;
    
    QMUILabel *unitLab = [[QMUILabel alloc] qmui_initWithFont:FONT(12) textColor:UIColor.blackColor];
    unitLab.text = Tools.distanceUnit;
    [countingView addSubview:unitLab];
    [unitLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(distanceLabel.mas_trailing).offset(0);
        make.bottom.mas_equalTo(distanceLabel.mas_bottom).offset(0);
    }];
    
    UICountingLabel *durationLabel = UICountingLabel.new;
    durationLabel.font = FONT(24);
    durationLabel.method = UILabelCountingMethodLinear;
    [countingView addSubview:durationLabel];
    [durationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(distanceLabel.mas_leading);
        make.top.mas_equalTo(distanceLabel.mas_bottom).offset(10);
    }];
    durationLabel.formatBlock = ^NSString *(CGFloat value) {
        return [Tools HMS:value];
    };
    self.durationLabel = durationLabel;
    
    // 反地理编码
    [self reverseGeocoding];
}


#pragma mark - 反地理编码
/**  反地理编码 */
- (void)reverseGeocoding {
    
    // 利用第一个定位数据进行反地理编码，确定位置在哪个国家，因为手表返回的是坐标系WGS-84，如果当前在中国，则需要转换成 火星坐标系GCJ-02
    RLMSportsLocationModel *firstObject = self.sportsModel.locations.firstObject;
    CLLocation *firstLocation = [[CLLocation alloc] initWithLatitude:firstObject.latitude longitude:firstObject.longitude];
    
    [NSObject showLoading:LWLocalizbleString(@"Loading...")];
    WeakSelf(self);
    [CLGeocoder.new reverseGeocodeLocation:firstLocation completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        
        [NSObject dismiss];
        
        if (error) {
            FBLog(@"反地理编码失败 %@", error.localizedDescription);
            [NSObject showHUDText:error.localizedDescription];
        } else {
            CLPlacemark *placemark = placemarks.firstObject;
            NSString *country = nil;
            if (@available(ios 11.0,*)) {
                country = placemark.ISOcountryCode;
            } else {
                country = placemark.addressDictionary[@"CountryCode"];
            }
            
            // 是否在中国地区境内
            BOOL chinaRegion = [country isEqualToString:@"CN"];
            weakSelf.mapView.chinaRegion = chinaRegion; // 设置地图参数，关系到经纬度换算
            
            // 加载地图覆盖物
            [weakSelf dataLoading:nil];
        }
    }];
}


#pragma mark - 加载地图覆盖物
/**  加载地图覆盖物 */
- (void)dataLoading:(UISwitch *)swi {
    
    if (swi) {
        self.mapView.optimization = swi.on; // 设置地图参数，关系到轨迹平滑优化
    }
    
    [self.mapView addMapTrack:self.sportsModel.locations edgePadding:UIEdgeInsetsMake(40+NavigationContentTop, 30, 30+Overview_Height+30, 30)];
}

#pragma mark - 播放轨迹回放
- (void)playing {
    WeakSelf(self);
    // 隐藏导航栏
    [self navigationBarHidden:YES];
    
    // 开始播放
    [self startPlayingWithCompleteBlock:^{
        
        [weakSelf navigationBarHidden:NO]; // 播放完成
    }];
}

- (void)startPlayingWithCompleteBlock:(void(^)(void))completeBlock {
    WeakSelf(self);
    [self.mapView startPlayingWithDistance:self.sportsModel.distance progress:^(FBCountingModel * _Nonnull countingModel, BOOL first) {
        
        [weakSelf.distanceLabel countFrom:countingModel.startValue to:countingModel.endValue withDuration:countingModel.interval];
        
        if (first) {
            [weakSelf.durationLabel countFrom:0 to:weakSelf.sportsModel.duration withDuration:countingModel.totalInterval];
        }
        
    } complete:^{
        if (completeBlock) {
            completeBlock();
        }
    }];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    // 停止以释放...
    [self.mapView stopPlaying];
    
    // 停止录制以释放...
    [FBRecordScreen.sharedInstance stopRecordingScreen];
}

#pragma mark - 视频录制分享
- (void)startRecordingScreen {
    WeakSelf(self);
    QMUIAlertController *alertController = [QMUIAlertController alertControllerWithTitle:LWLocalizbleString(@"录屏方式") message:nil preferredStyle:QMUIAlertControllerStyleActionSheet];
    [alertController addAction:[QMUIAlertAction actionWithTitle:@"iOS10" style:QMUIAlertActionStyleDefault handler:^(__kindof QMUIAlertController * _Nonnull aAlertController, QMUIAlertAction * _Nonnull action) {
        //iOS10
        FBRecordScreen.sharedInstance.UsingiOS11_Methods = NO;
        [weakSelf startRecording];
    }]];
    [alertController addAction:[QMUIAlertAction actionWithTitle:@"iOS11.0+" style:QMUIAlertActionStyleDefault handler:^(__kindof QMUIAlertController * _Nonnull aAlertController, QMUIAlertAction * _Nonnull action) {
        // iOS11+
        FBRecordScreen.sharedInstance.UsingiOS11_Methods = YES;
        [weakSelf startRecording];
    }]];
    [alertController addAction:[QMUIAlertAction actionWithTitle:LWLocalizbleString(@"Cancel") style:QMUIAlertActionStyleCancel handler:nil]];
    [alertController showWithAnimated:YES];
}

- (void)startRecording {
    WeakSelf(self);
    
    // 隐藏导航栏
    [self navigationBarHidden:YES];
    
    // 开启录屏
    [FBRecordScreen.sharedInstance startRecordingScreenWithFailedBlock:^(NSError * _Nullable error) { // 录屏失败
        
        [weakSelf navigationBarHidden:NO];
        
        [weakSelf.mapView stopPlaying];
        
        [weakSelf showAlert:error.localizedDescription];
        
    } withOpenBlock:^{ // 录屏打开
        
        // 启动成功，开始播放轨迹
        [weakSelf startPlayingWithCompleteBlock:^{
            // 播放轨迹完成，停止录制
            [FBRecordScreen.sharedInstance stopRecordingScreen];
        }];
        
    } withCompleteBlock:^(RPPreviewViewController * _Nullable previewViewController, NSURL * _Nullable videoUrl) { // 录屏完成
                
        [weakSelf navigationBarHidden:NO];
        
        [weakSelf presentPreview:previewViewController videoUrl:videoUrl];
    }];
}


- (void)showAlert:(NSString *)message {
    // 失败弹窗
    GCD_MAIN_QUEUE(^{
        [UIAlertObject presentAlertTitle:LWLocalizbleString(@"Fail") message:message cancel:nil sure:LWLocalizbleString(@"OK") block:^(AlertClickType clickType) {
            // something...
        }];
    });
}

- (void)presentPreview:(RPPreviewViewController *)previewViewController videoUrl:(NSURL *)videoUrl {
    
    if (previewViewController) { // 弹出系统界面
        previewViewController.modalPresentationStyle = UIModalPresentationFullScreen;
        previewViewController.previewControllerDelegate = self;
        [self presentViewController:previewViewController animated:YES completion:nil];
    }
    else if (videoUrl) { // 播放视频URL
        AVPlayerItem *playerItem = [AVPlayerItem playerItemWithURL:videoUrl];
        AVPlayer *player = [AVPlayer playerWithPlayerItem:playerItem];
        
        AVPlayerViewController *playerViewController = [[AVPlayerViewController alloc] init];
        playerViewController.player = player;
        [self presentViewController:playerViewController animated:YES completion:nil];
        
        [NSObject showHUDText:LWLocalizbleString(@"Video successfully saved to album")];
    }
}

- (void)previewControllerDidFinish:(RPPreviewViewController *)previewController {
    //用户操作完成后，返回之前的界面
    [previewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)previewController:(RPPreviewViewController *)previewController didFinishWithActivityTypes:(NSSet<NSString *> *)activityTypes {
    if ([activityTypes containsObject:@"com.apple.UIKit.activity.SaveToCameraRoll"]) {
        [NSObject showHUDText:LWLocalizbleString(@"Video successfully saved to album")];
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

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self navigationBarAlpha:0.0];
    self.navigationController.navigationBar.tintColor = UIColorBlack;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self navigationBarAlpha:1.0];
    self.navigationController.navigationBar.tintColor = UIColorWhite;
}

- (void)navigationBarHidden:(BOOL)hidden {
    self.hiddenBar = hidden;
    // 刷新状态栏
    [self setNeedsStatusBarAppearanceUpdate];
    // 刷新导航栏
    [self.navigationController setNavigationBarHidden:hidden animated:NO];
    
    self.gridView.hidden = hidden;
    
    self.countingView.hidden = !hidden;
    self.distanceLabel.text = @"0.00";
    self.durationLabel.text = @"00:00:00";
}

/// 是否隐藏状态栏
- (BOOL)prefersStatusBarHidden {
    return self.hiddenBar;
}

/// 状态栏颜色-黑
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

@end
