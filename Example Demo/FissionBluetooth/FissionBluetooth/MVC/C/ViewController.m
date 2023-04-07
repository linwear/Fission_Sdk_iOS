//
//  ViewController.m
//  FissionBluetooth
//
//  Created by 裂变智能 on 2021/1/5.
//

#import "ViewController.h"
#import "LeftViewController.h"
#import <AudioToolbox/AudioToolbox.h>
#import "ListViewController.h"
#import "UserInforViewController.h"
#import "SedentaryViewController.h"
#import "HeartRateViewController.h"
#import "WaterClockViewController.h"
#import "NotDisturbViewController.h"
#import "HrCheckViewController.h"
#import "BrightScreenViewController.h"
#import "SportTargetViewController.h"
#import "WeatherViewController.h"
#import "ChipFlashSpatialVC.h"
#import "MessagePushSwitchVC.h"
#import "ClockInforListVC.h"
#import "BinFileViewController.h"
#import "FBClockDialCategoryViewController.h"
#import "FemaleCircadianCycleVC.h"
#import "HeartRateReminderVC.h"
#import "MotionPushViewController.h"
#import "LWPersonViewController.h"
#import "FBCameraViewController.h"

#import "LWStartCountdownView.h"
#import "FBSportsConnectViewController.h"

#import "FBBatteryView.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

@property (nonatomic, strong) QMUIButton *titleView;
@property (nonatomic, strong) FBBatteryView *batteryView;

@property(nonatomic,strong) UITextView *receTextView;
@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,strong) NSMutableArray *funDatas;

@property(nonatomic,strong) UILabel *versionLab;

@property (nonatomic, strong) UILabel *receLab;
@property (nonatomic, strong) BRDatePickerView *datePickerView;
@property (nonatomic, strong) UIButton *staTBut;
@property (nonatomic, strong) UIButton *endTBut;

@property (nonatomic, assign) NSInteger staTime;
@property (nonatomic, assign) NSInteger endTime;

@property (nonatomic, assign) BOOL switchMode;

@end

@implementation ViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self reloadTitle];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    WeakSelf(self);
    // Do any additional setup after loading the view.
    //    NSData *h = [NSString dataForHexString:@"56312e3037"];
    //    NSString *firmwareVersion = [[NSString alloc] initWithData:h encoding:NSUTF8StringEncoding];
        
    //    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, true);
    //    NSString *fileName = [NSString stringWithFormat:@"%@/firmwares/%@", paths[0], @"2.bin"];
    //    NSData *binFile = [NSData dataWithContentsOfFile:fileName];
    //    [FBCustomDataTools.sharedInstance d:binFile];
    
    [self cw_registerShowIntractiveWithEdgeGesture:YES transitionDirectionAutoBlock:^(CWDrawerTransitionDirection direction) {
        if (CWDrawerTransitionFromLeft == direction) {
            [weakSelf scaleYAnimationFromLeft];
        }
    }];
    
    // result
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(result:) name:FISSION_SDK_CONNECTBINGSTATE object:nil];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString * docsdir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    NSString *dataFilePath = [docsdir stringByAppendingPathComponent:@"firmwares"]; // 在Document目录下创建 "firmwares" 文件夹
    BOOL isDir = NO;
    //fileExistsAtPath 判断一个文件或目录是否有效，isDirectory判断是否一个目录
    BOOL existed = [fileManager fileExistsAtPath:dataFilePath isDirectory:&isDir];
    if (!(isDir && existed)) {
        // 在Document目录下创建一个archiver目录
        [fileManager createDirectoryAtPath:dataFilePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    NSString *dataFilePath1 = [docsdir stringByAppendingPathComponent:@"motionPush"]; // 在Document目录下创建 "motionPush" 文件夹
    BOOL isDir1 = NO;
    //fileExistsAtPath 判断一个文件或目录是否有效，isDirectory判断是否一个目录
    BOOL existed1 = [fileManager fileExistsAtPath:dataFilePath1 isDirectory:&isDir1];
    if (!(isDir1 && existed1)) {
        // 在Document目录下创建一个archiver目录
        [fileManager createDirectoryAtPath:dataFilePath1 withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    NSString *dataFilePath2 = [docsdir stringByAppendingPathComponent:@"customDial"]; // 在Document目录下创建 "customDial" 文件夹
    BOOL isDir2 = NO;
    //fileExistsAtPath 判断一个文件或目录是否有效，isDirectory判断是否一个目录
    BOOL existed2 = [fileManager fileExistsAtPath:dataFilePath2 isDirectory:&isDir2];
    if (!(isDir2 && existed2)) {
        // 在Document目录下创建一个archiver目录
        [fileManager createDirectoryAtPath:dataFilePath2 withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    [self initUI];
    
    [self initDatas];
}

#pragma mark - 左边抽屉｜left drawer
- (void)scaleYAnimationFromLeft {
    
    LeftViewController *vc = LeftViewController.new;

    CWLateralSlideConfiguration *conf = [CWLateralSlideConfiguration configurationWithDistance:0 maskAlpha:0.4 scaleY:0.8 direction:CWDrawerTransitionFromLeft backImage:UIImageMake(@"nightSky")];

    [self cw_showDrawerViewController:vc animationType:CWDrawerAnimationTypeDefault configuration:conf];
}

- (void)fbPushMobileLocationInformation{
    WeakSelf(self);
    
    [FBBgCommand.sharedInstance fbPushMobileLocationInformationWithLongitude:114.031040 withLatitude:22.324386 withBlock:^(NSError * _Nullable error) {
        if (error) {
            [NSObject showHUDText:error.domain];
        } else {
            weakSelf.receTextView.text = @"lon 114.031040--lat 22.324386";
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

#pragma mark - 初始化UI｜Initialize the UI
-(void)initUI{
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithImage:IMAGE_NAME(@"personal_myservice_icons") style:UIBarButtonItemStylePlain target:self action:@selector(scaleYAnimationFromLeft)];
    [self.navigationItem setLeftBarButtonItem:leftItem animated:YES];
    
    UIBarButtonItem *rigtItem = [[UIBarButtonItem alloc] initWithCustomView:self.batteryView];
    [self.navigationItem setRightBarButtonItem:rigtItem animated:YES];
    
    CGFloat leftSpace = 5;
    
    self.receLab = [[UILabel alloc] initWithFrame:CGRectMake(leftSpace, NavigationContentTop, SCREEN_WIDTH-leftSpace*2, 50)];
    self.receLab.text = LWLocalizbleString(@"Receive Data");
    self.receLab.font = FONT(14);
    self.receLab.textAlignment = NSTextAlignmentLeft;
    self.receLab.textColor = UIColorBlue;
    self.receLab.numberOfLines = 0;
    [self.view addSubview:self.receLab];
    
    self.receTextView = [[UITextView alloc] initWithFrame:CGRectMake(leftSpace, CGRectGetMaxY(self.receLab.frame), CGRectGetWidth(self.receLab.frame), 150)];
    self.receTextView.textColor = UIColorBlue;
    self.receTextView.font = FONT(14);
    self.receTextView.editable = NO;
    self.receTextView.layer.borderWidth = 1;
    self.receTextView.layer.borderColor = UIColorBlack.CGColor;
    self.receTextView.sd_cornerRadius = @(8);
    [self.view addSubview:self.receTextView];
    
    self.staTBut = [UIButton buttonWithType:UIButtonTypeCustom];
    self.staTBut.frame = CGRectMake(0, CGRectGetMaxY(self.receTextView.frame), SCREEN_WIDTH/2, 40);
    self.staTBut.backgroundColor = UIColorRed;
    [self.staTBut setTitle:[self getTheCurrentTimeFormat:NO] forState:UIControlStateNormal];
    [self.staTBut setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:self.staTBut];
    [self.staTBut addTarget:self action:@selector(staTimeClick:) forControlEvents:UIControlEventTouchUpInside];
    
    self.endTBut = [UIButton buttonWithType:UIButtonTypeCustom];
    self.endTBut.frame = CGRectMake(CGRectGetMaxX(self.staTBut.frame), CGRectGetMaxY(self.receTextView.frame), SCREEN_WIDTH/2, 40);
    self.endTBut.backgroundColor = BlueColor;
    [self.endTBut setTitle:[self getTheCurrentTimeFormat:YES] forState:UIControlStateNormal];
    [self.endTBut setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:self.endTBut];
    [self.endTBut addTarget:self action:@selector(endTimeClick:) forControlEvents:UIControlEventTouchUpInside];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.staTBut.frame), SCREEN_WIDTH,SCREEN_HEIGHT-CGRectGetMaxY(self.staTBut.frame)) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 52;
    self.tableView.tableFooterView = UIView.new;
    [self.tableView registerClass:UITableViewCell.class forCellReuseIdentifier:@"ViewControllerCell"];
    [self.view addSubview:self.tableView];
    
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    footView.backgroundColor = UIColorClear;
    self.tableView.tableFooterView = footView;
    
    self.versionLab = [[UILabel alloc] initWithFrame:CGRectMake(0,SCREEN_HEIGHT-40, SCREEN_WIDTH,40)];
    self.versionLab.font = FONT(14);
    self.versionLab.textColor = [UIColor blueColor];
    self.versionLab.numberOfLines = 0;
    self.versionLab.textAlignment = NSTextAlignmentCenter;
    [self.view bringSubviewToFront:self.versionLab];
    [self.view addSubview:self.versionLab];
    
    // 1.创建日期选择器
    self.datePickerView = [[BRDatePickerView alloc]init];
    self.datePickerView.pickerMode = BRDatePickerModeYMDHMS;
}

- (NSString *)getTheCurrentTimeFormat:(BOOL)end {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    dateFormatter.timeZone = [NSTimeZone systemTimeZone];
    dateFormatter.locale = [NSLocale currentLocale];
    dateFormatter.calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    NSDate *datenow;
    if (end) {
        datenow = NSDate.date;
    } else {
        NSInteger time = [NSDate.date timeIntervalSince1970] - 86400;
        datenow = [NSDate dateWithTimeIntervalSince1970:time];
    }
    self.staTime = NSDate.date.timeIntervalSince1970 - 86400;
    self.endTime = NSDate.date.timeIntervalSince1970;
    NSString *time_other = [dateFormatter stringFromDate:datenow];
    return time_other;
}

#pragma mark - 选择起始查询时间｜Select the starting query time
- (void)staTimeClick:(UIButton*)but{
    WeakSelf(self);
    self.datePickerView.title = LWLocalizbleString(@"Start query time");
    self.datePickerView.selectValue = self.staTBut.titleLabel.text;
    self.datePickerView.resultBlock = ^(NSDate *selectDate, NSString *selectValue) {
        
        [weakSelf.staTBut setTitle:selectValue forState:UIControlStateNormal];
        weakSelf.staTime = [selectDate timeIntervalSince1970];
    };
    [self.datePickerView show];
}

#pragma mark - 选择结束查询时间｜Select end query time
- (void)endTimeClick:(UIButton*)but{
    WeakSelf(self);
    self.datePickerView.title = LWLocalizbleString(@"End query time");
    self.datePickerView.selectValue = self.endTBut.titleLabel.text;
    self.datePickerView.resultBlock = ^(NSDate *selectDate, NSString *selectValue) {
        
        [weakSelf.endTBut setTitle:selectValue forState:UIControlStateNormal];
        weakSelf.endTime = [selectDate timeIntervalSince1970];
    };
    [self.datePickerView show];
}

#pragma mark - 列表数据源｜list data source
- (void)initDatas{
    
    NSDictionary *dict1  = @{@"command":@"FBAtCommand",
                             @"status":@(0),
                             @"funcArr":@[
                                 LWLocalizbleString(@"Get device power information"),
                                 LWLocalizbleString(@"Get device version information"),
                                 LWLocalizbleString(@"Get protocol version information"),
                                 LWLocalizbleString(@"Get UTC time"),
                                 LWLocalizbleString(@"Get the time zone"),
                                 LWLocalizbleString(@"Synchronize UTC time"),
                                 LWLocalizbleString(@"Set the time zone"),
                                 LWLocalizbleString(@"Synchronize system time"),
                                 LWLocalizbleString(@"Set the time display mode"),
                                 LWLocalizbleString(@"Language setting"),
                                 LWLocalizbleString(@"Set distance unit"),
                                 LWLocalizbleString(@"Set the vibration reminder switch"),
                                 LWLocalizbleString(@"Set the switch to turn on the screen by raising your wrist"),
                                 LWLocalizbleString(@"Enter/exit camera mode"),
                                 LWLocalizbleString(@"Phone find device"),
                                 LWLocalizbleString(@"Reboot the device"),
                                 LWLocalizbleString(@"Reset"),
                                 LWLocalizbleString(@"Soft shutdown"),
                                 LWLocalizbleString(@"Security confirmation"),
                                 LWLocalizbleString(@"Start/Exit Self-Test Mode"),
                                 LWLocalizbleString(@"Clear user information"),
                                 LWLocalizbleString(@"Clear activity data"),
                                 LWLocalizbleString(@"Set the device to actively disconnect"),
                                 LWLocalizbleString(@"Interface jump test"),
                                 LWLocalizbleString(@"Women's Physiological Status Setting"),
                                 LWLocalizbleString(@"Get unused note reminder/alarm ID"),
                                 LWLocalizbleString(@"Enable/exit sprint mode"),
                                 LWLocalizbleString(@"Enter/Exit production mode"),
                                 LWLocalizbleString(@"Set temperature unit"),
                                 LWLocalizbleString(@"Get the duration of the bright screen"),
                                 LWLocalizbleString(@"Set the duration of the bright screen"),
                                 LWLocalizbleString(@"Switch to the specified watch face"),
                                 LWLocalizbleString(@"Set vibration feedback"),
                                 LWLocalizbleString(@"Request to bind the device"),
                                 LWLocalizbleString(@"Request to unbind the device"),
                                 LWLocalizbleString(@"Get resting heart rate for the day"),
                                 LWLocalizbleString(@"Get the specified prompt function"),
                                 LWLocalizbleString(@"Set the specified reminder function"),
                                 LWLocalizbleString(@"The app side synchronizes the GPS motion status to the device side"),
                                 LWLocalizbleString(@"Turn on/off the heart rate monitoring switch"),
                                 LWLocalizbleString(@"Timing heart rate detection switch setting"),
                                 LWLocalizbleString(@"Timed blood oxygen detection switch setting"),
                                 LWLocalizbleString(@"Timed mental stress detection switch setting"),
                                 LWLocalizbleString(@"Get call audio switch status"),
                                 LWLocalizbleString(@"Turn on/off call audio switch"),
                                 LWLocalizbleString(@"Get Multimedia Audio Switch status"),
                                 LWLocalizbleString(@"Turn on/off Multimedia Audio Switch"),
                             ]
    };
    
    NSDictionary *dict2  = @{@"command":@"Stream",
                             @"status":@(0),
                             @"funcArr":@[
                                 LWLocalizbleString(@"Enable(2s)/disable data monitoring flow"),
                             ]
    };
    
    NSDictionary *dict3 =  @{@"command":@"FBBgCommand",
                             @"status":@(0),
                             @"funcArr":@[
                                 LWLocalizbleString(@"Get device hardware information"),
                                 LWLocalizbleString(@"Obtain real-time measurement data of the day"),
                                 LWLocalizbleString(@"Get real-time statistics report of current sleep"),
                                 LWLocalizbleString(@"Get the current real-time sleep state record"),
                                 LWLocalizbleString(@"Get daily activity statistics report"),
                                 LWLocalizbleString(@"Obtain the hourly activity statistics report"),
                                 LWLocalizbleString(@"Get sleep statistics report"),
                                 LWLocalizbleString(@"Get sleep status record"),
                                 LWLocalizbleString(@"Get a list of device motion types"),
                                 LWLocalizbleString(@"Get list of exercise records"),
                                 LWLocalizbleString(@"Get Sports Statistics Report"),
                                 LWLocalizbleString(@"Get heart rate records"),
                                 LWLocalizbleString(@"Get pedometer records"),
                                 LWLocalizbleString(@"Get Blood Oxygen Records"),
                                 LWLocalizbleString(@"Get blood pressure records"),
                                 LWLocalizbleString(@"Obtain exercise high-frequency heart rate records (1 time per second)"),
                                 LWLocalizbleString(@"Get Stress Records"),
                                 LWLocalizbleString(@"Get exercise details record"),
                                 LWLocalizbleString(@"Get sports statistics report + sports details record"),
                                 LWLocalizbleString(@"Obtain motion location records"),
                                 LWLocalizbleString(@"Acquire manual measurement data records"),
                                 LWLocalizbleString(@"Get specified records and reports"),
                                 LWLocalizbleString(@"User Info"),
                                 LWLocalizbleString(@"Reminder/Alarm"),
                                 LWLocalizbleString(@"Message Switch"),
                                 LWLocalizbleString(@"Heart Rate Level"),
                                 LWLocalizbleString(@"Sedentary Reminder"),
                                 LWLocalizbleString(@"Drink Water Reminder"),
                                 LWLocalizbleString(@"DND Reminder"),
                                 LWLocalizbleString(@"Heart Rate Monitor"),
                                 LWLocalizbleString(@"Raise Wrist"),
                                 LWLocalizbleString(@"Sport Goal"),
                                 LWLocalizbleString(@"Set Weather"),
                                 LWLocalizbleString(@"Push Location Info"),
                                 LWLocalizbleString(@"Physical Health"),
                                 LWLocalizbleString(@"Abnormal HR reminder"),
                                 LWLocalizbleString(@"Frequent Contacts"),
                                 LWLocalizbleString(@"Request Device Logs"),
                             ]
    };
    
    NSDictionary *dict4  = @{@"command":@"OTA",
                             @"status":@(0),
                             @"funcArr":@[
                                 LWLocalizbleString(@"Firmware OTA"),
                                 LWLocalizbleString(@"Dial Face OTA"),
                                 LWLocalizbleString(@"Sports Type OTA"),
                             ]
    };
    
    self.funDatas = NSMutableArray.array;
    [self.funDatas addObject:dict1];
    [self.funDatas addObject:dict2];
    [self.funDatas addObject:dict3];
    [self.funDatas addObject:dict4];
}

#pragma mark - UITableViewDelegate, UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.funDatas.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSDictionary *dict = self.funDatas[section];
    NSNumber *status  = dict[@"status"];
    NSArray *funcArr = dict[@"funcArr"];
    
    if (status.intValue == 1) {
        return funcArr.count;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 60)];
    view.backgroundColor = UIColorWhite;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0,SCREEN_WIDTH-20, 60)];
    label.font = [NSObject themePingFangSCMediumFont:17];
    label.textColor = UIColorRed;
    [view addSubview:label];
    
    UIButton *clickBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-100,10,80, 40)];
    [clickBtn setTitle:LWLocalizbleString(@"Expand") forState:UIControlStateNormal];
    [clickBtn setTitle:LWLocalizbleString(@"Away") forState:UIControlStateSelected];
    [clickBtn setTitleColor:UIColorBlack forState:UIControlStateNormal];
    [clickBtn setTitleColor:UIColorBlack forState:UIControlStateSelected];
    [clickBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    clickBtn.layer.borderWidth = 0.5;
    clickBtn.titleLabel.font = [NSObject themePingFangSCMediumFont:14];
    clickBtn.layer.borderColor = [UIColor blackColor].CGColor;
    clickBtn.layer.cornerRadius = 10;
    clickBtn.tag = 100 + section;
    [view addSubview:clickBtn];
    
    UIView *topLine = [[UIView alloc] initWithFrame:CGRectMake(0,60-0.5, SCREEN_WIDTH, 0.5)];
    topLine.backgroundColor = [UIColor blackColor];
    [view addSubview:topLine];
    
    UIView *downLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0.5, SCREEN_WIDTH, 0.5)];
    downLine.backgroundColor = [UIColor blackColor];
    [view addSubview:downLine];
    
    NSDictionary *dict = self.funDatas[section];
    clickBtn.selected = [dict[@"status"] boolValue];
    label.text = dict[@"command"];
    
    return view;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 60.f;
}

- (void)btnClick:(UIButton *)sender{
    NSInteger tag = sender.tag -100;
    sender.selected = !sender.selected;
    
    NSDictionary *dict = self.funDatas[tag];
    NSMutableDictionary *mutDict = [[NSMutableDictionary alloc] initWithDictionary:dict];
    [mutDict setObject:[NSNumber numberWithBool:sender.selected] forKey:@"status"];
    [self.funDatas replaceObjectAtIndex:tag withObject:mutDict.copy];
    
    [self.tableView reloadData];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ViewControllerCell"];
    UIView *view = UIView.new;
    view.backgroundColor = UIColorTestGreen;
    cell.selectedBackgroundView = view;
    cell.backgroundColor = row%2==0 ? COLOR_HEX(0xF0F0F0, 1) : UIColorWhite;
    
    NSDictionary *dict = self.funDatas[section];
    NSArray *funArr = dict[@"funcArr"];
    NSString *text = funArr[row];
    
    cell.textLabel.text = text;
    cell.textLabel.font = FONT(14);
    cell.textLabel.textAlignment = NSTextAlignmentLeft;
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.textColor = UIColorBlack;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    WeakSelf(self);
    
    self.receLab.text = [NSString stringWithFormat:@"%@ %ld-%ld---MTU:%ld", LWLocalizbleString(@"Receive Data"), indexPath.section, indexPath.row, FBBluetoothManager.sharedInstance.FB_MTU];
    
    NSInteger staTime = self.staTime;
    NSInteger endTime = self.endTime;
    
    NSDictionary *dict = self.funDatas[indexPath.section];
    NSString *commandStr  = dict[@"command"];
    NSArray *funcArr = dict[@"funcArr"];
    NSString *rowStr = funcArr[indexPath.row];
    self.receTextView.text = [NSString stringWithFormat:@"%@\n%@\nRequest...", commandStr, rowStr];
    
    
    NSInteger section = indexPath.section;
    
#pragma mark - FBAtCommand
    if (section == 0) {
        
        if ([rowStr isEqualToString:LWLocalizbleString(@"Get device power information")]) {
            [FBAtCommand.sharedInstance fbReqBatteryStatusDataWithBlock:^(FBBatteryInfoModel * _Nonnull responseObject, NSError * _Nonnull error) {
                if (error) {
                    [NSObject showHUDText:[NSString stringWithFormat:@"%@", error]];
                } else {
                    weakSelf.receTextView.text = [NSString stringWithFormat:@"%@", responseObject.mj_keyValues];
                }
            }];
        }
        
        if ([rowStr isEqualToString:LWLocalizbleString(@"Get device version information")]) {
            [FBAtCommand.sharedInstance fbReqDeviceVersionDataWithBlock:^(FBDeviceVersionModel * _Nullable responseObject, NSError * _Nullable error) {
                if (error) {
                    [NSObject showHUDText:[NSString stringWithFormat:@"%@", error]];
                } else {
                    weakSelf.receTextView.text = [NSString stringWithFormat:@"%@", responseObject.mj_keyValues];
                }
            }];
        }
        
        if ([rowStr isEqualToString:LWLocalizbleString(@"Get protocol version information")]) {
            [FBAtCommand.sharedInstance fbReqProtocolVersionDataWithBlock:^(NSString * _Nullable responseObject, NSError * _Nullable error) {
                if (error) {
                    [NSObject showHUDText:[NSString stringWithFormat:@"%@", error]];
                } else {
                    weakSelf.receTextView.text = [NSString stringWithFormat:@"%@", responseObject];
                }
            }];
        }
        
        if ([rowStr isEqualToString:LWLocalizbleString(@"Get UTC time")]) {
            [FBAtCommand.sharedInstance fbReqUTCTimeDataWithBlock:^(NSInteger responseObject, NSError * _Nullable error) {
                if (error) {
                    [NSObject showHUDText:[NSString stringWithFormat:@"%@", error]];
                } else {
                    weakSelf.receTextView.text = [NSString stringWithFormat:@"%ld", responseObject];
                }
            }];
        }
        
        if ([rowStr isEqualToString:LWLocalizbleString(@"Get the time zone")]) {
            [FBAtCommand.sharedInstance fbReqTimezoneDataWithBlock:^(NSInteger responseObject, NSError * _Nullable error) {
                if (error) {
                    [NSObject showHUDText:[NSString stringWithFormat:@"%@", error]];
                } else {
                    weakSelf.receTextView.text = [NSString stringWithFormat:@"%ld", responseObject];
                }
            }];
        }
        
        if ([rowStr isEqualToString:LWLocalizbleString(@"Synchronize UTC time")]) {
            [FBAtCommand.sharedInstance fbSynchronizeUTCTimeWithBlock:^(NSError * _Nullable error) {
                if (error) {
                    [NSObject showHUDText:[NSString stringWithFormat:@"%@", error]];
                } else {
                    weakSelf.receTextView.text = LWLocalizbleString(@"Success");
                }
            }];
        }
        
        if ([rowStr isEqualToString:LWLocalizbleString(@"Set the time zone")]) {
            NSTimeZone *systemZone = [NSTimeZone systemTimeZone];
            NSInteger minute = systemZone.secondsFromGMT/60;
            [FBAtCommand.sharedInstance fbUpTimezoneMinuteData:minute withBlock:^(NSError * _Nullable error) {
                if (error) {
                    [NSObject showHUDText:[NSString stringWithFormat:@"%@", error]];
                } else {
                    weakSelf.receTextView.text = LWLocalizbleString(@"Success");
                }
            }];
        }
        
        if ([rowStr isEqualToString:LWLocalizbleString(@"Synchronize system time")]) {
            [FBAtCommand.sharedInstance fbAutomaticallySynchronizeSystemTimeWithBlock:^(NSError * _Nullable error) {
                if (error) {
                    [NSObject showHUDText:[NSString stringWithFormat:@"%@", error]];
                } else {
                    weakSelf.receTextView.text = LWLocalizbleString(@"Success");
                }
            }];
        }
        
        if ([rowStr isEqualToString:LWLocalizbleString(@"Set the time display mode")]) {
            _switchMode = !_switchMode;
            FB_TIMEDISPLAYMODE mode = _switchMode ? FB_TimeDisplayMode24Hours : FB_TimeDisplayMode12Hours;
            
            [FBAtCommand.sharedInstance fbUpTimeModeData:mode withBlock:^(NSError * _Nullable error) {
                if (error) {
                    [NSObject showHUDText:[NSString stringWithFormat:@"%@", error]];
                } else {
                    weakSelf.receTextView.text = LWLocalizbleString(@"Success");
                }
            }];
        }
        
        if ([rowStr isEqualToString:LWLocalizbleString(@"Language setting")]) {
            [FBAtCommand.sharedInstance fbUpLanguageData:FB_SDK_en withBlock:^(NSError * _Nullable error) {
                if (error) {
                    [NSObject showHUDText:[NSString stringWithFormat:@"%@", error]];
                } else {
                    weakSelf.receTextView.text = LWLocalizbleString(@"Success");
                }
            }];
        }
        
        if ([rowStr isEqualToString:LWLocalizbleString(@"Set distance unit")]) {
            _switchMode = !_switchMode;
            FB_DISTANCEUNIT mode = _switchMode ? FB_EnglishUnits : FB_MetricUnit;
            
            [FBAtCommand.sharedInstance fbUpDistanceUnitData:mode withBlock:^(NSError * _Nullable error) {
                if (error) {
                    [NSObject showHUDText:[NSString stringWithFormat:@"%@", error]];
                } else {
                    weakSelf.receTextView.text = LWLocalizbleString(@"Success");
                }
            }];
        }
        
        if ([rowStr isEqualToString:LWLocalizbleString(@"Set the vibration reminder switch")]) {
            _switchMode = !_switchMode;
            
            [FBAtCommand.sharedInstance fbUpShakeAlterSwitchData:_switchMode withBlock:^(NSError * _Nullable error) {
                if (error) {
                    [NSObject showHUDText:[NSString stringWithFormat:@"%@", error]];
                } else {
                    weakSelf.receTextView.text = LWLocalizbleString(@"Success");
                }
            }];
        }
        
        if ([rowStr isEqualToString:LWLocalizbleString(@"Set the switch to turn on the screen by raising your wrist")]) {
            _switchMode = !_switchMode;
            
            [FBAtCommand.sharedInstance fbUpWristSwitchData:_switchMode withBlock:^(NSError * _Nullable error) {
                if (error) {
                    [NSObject showHUDText:[NSString stringWithFormat:@"%@", error]];
                } else {
                    weakSelf.receTextView.text = LWLocalizbleString(@"Success");
                }
            }];
        }
        
        if ([rowStr isEqualToString:LWLocalizbleString(@"Enter/exit camera mode")]) {
            
            if (NSObject.accessCamera) {
                FBCameraViewController *vc = FBCameraViewController.new;
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
        
        if ([rowStr isEqualToString:LWLocalizbleString(@"Phone find device")]) {
            [FBAtCommand.sharedInstance fbUpFindDeviceDataWithBlock:^(NSError * _Nullable error) {
                if (error) {
                    [NSObject showHUDText:[NSString stringWithFormat:@"%@", error]];
                } else {
                    weakSelf.receTextView.text = LWLocalizbleString(@"Success");
                }
            }];
        }
        
        if ([rowStr isEqualToString:LWLocalizbleString(@"Reboot the device")]) {
            [FBAtCommand.sharedInstance fbUpRebootDeviceDataWithBlock:^(NSError * _Nullable error) {
                if (error) {
                    [NSObject showHUDText:[NSString stringWithFormat:@"%@", error]];
                } else {
                    weakSelf.receTextView.text = LWLocalizbleString(@"Success");
                }
            }];
        }
        
        if ([rowStr isEqualToString:LWLocalizbleString(@"Reset")]) {
            [FBAtCommand.sharedInstance fbUpResetDeviceDataWithBlock:^(NSError * _Nullable error) {
                if (error) {
                    [NSObject showHUDText:[NSString stringWithFormat:@"%@", error]];
                } else {
                    weakSelf.receTextView.text = LWLocalizbleString(@"Success");
                }
            }];
        }
        
        if ([rowStr isEqualToString:LWLocalizbleString(@"Soft shutdown")]) {
            [FBAtCommand.sharedInstance fbUpSoftDownDataWithBlock:^(NSError * _Nullable error) {
                if (error) {
                    [NSObject showHUDText:[NSString stringWithFormat:@"%@", error]];
                } else {
                    weakSelf.receTextView.text = LWLocalizbleString(@"Success");
                }
            }];
        }
        
        if ([rowStr isEqualToString:LWLocalizbleString(@"Security confirmation")]) {
            [FBAtCommand.sharedInstance fbUpSafetyConfirmDataWithBlock:^(NSError * _Nullable error) {
                if (error) {
                    [NSObject showHUDText:[NSString stringWithFormat:@"%@", error]];
                } else {
                    weakSelf.receTextView.text = LWLocalizbleString(@"Success");
                }
            }];
        }
        
        if ([rowStr isEqualToString:LWLocalizbleString(@"Start/Exit Self-Test Mode")]) {
            _switchMode = !_switchMode;
            
            [FBAtCommand.sharedInstance fbUpSelfTestData:_switchMode withBlock:^(NSError * _Nullable error) {
                if (error) {
                    [NSObject showHUDText:[NSString stringWithFormat:@"%@", error]];
                } else {
                    weakSelf.receTextView.text = LWLocalizbleString(@"Success");
                }
            }];
        }
        
        if ([rowStr isEqualToString:LWLocalizbleString(@"Clear user information")]) {
            [FBAtCommand.sharedInstance fbUpClearUserInfoDataWithBlock:^(NSError * _Nullable error) {
                if (error) {
                    [NSObject showHUDText:[NSString stringWithFormat:@"%@", error]];
                } else {
                    weakSelf.receTextView.text = LWLocalizbleString(@"Success");
                }
            }];
        }
        
        if ([rowStr isEqualToString:LWLocalizbleString(@"Clear activity data")]) {
            [FBAtCommand.sharedInstance fbUpClearSportDataWithBlock:^(NSError * _Nullable error) {
                if (error) {
                    [NSObject showHUDText:[NSString stringWithFormat:@"%@", error]];
                } else {
                    weakSelf.receTextView.text = LWLocalizbleString(@"Success");
                }
            }];
        }
        
        if ([rowStr isEqualToString:LWLocalizbleString(@"Set the device to actively disconnect")]) {
            [FBAtCommand.sharedInstance fbUpDisConnectDataWithBlock:^(NSError * _Nullable error) {
                if (error) {
                    [NSObject showHUDText:[NSString stringWithFormat:@"%@", error]];
                } else {
                    weakSelf.receTextView.text = LWLocalizbleString(@"Success");
                }
            }];
        }
        
        if ([rowStr isEqualToString:LWLocalizbleString(@"Interface jump test")]) {
            // The correct interface is required
            [FBAtCommand.sharedInstance fbUpInterfaceJumpTestData:@"hello" withBlock:^(NSError * _Nullable error) {
                if (error) {
                    [NSObject showHUDText:[NSString stringWithFormat:@"%@", error]];
                } else {
                    weakSelf.receTextView.text = LWLocalizbleString(@"Success");
                }
            }];
        }
        
        if ([rowStr isEqualToString:LWLocalizbleString(@"Women's Physiological Status Setting")]) {
            _switchMode = !_switchMode;
            FB_FEMALEPHYSIOLOGICALSTATE Phy = _switchMode ? FB_FPS_Pregnancy : FB_FPS_Menstruation;
            
            [FBAtCommand.sharedInstance fbUpFemalePhysiologicalStateData:Phy withBlock:^(NSError * _Nullable error) {
                if (error) {
                    [NSObject showHUDText:[NSString stringWithFormat:@"%@", error]];
                } else {
                    weakSelf.receTextView.text = LWLocalizbleString(@"Success");
                }
            }];
        }
        
        if ([rowStr isEqualToString:LWLocalizbleString(@"Get unused note reminder/alarm ID")]) {
            [FBAtCommand.sharedInstance fbGetUnusedClockIDWithBlock:^(NSInteger responseObject, NSError * _Nullable error) {
                if (error) {
                    [NSObject showHUDText:[NSString stringWithFormat:@"%@", error]];
                } else {
                    weakSelf.receTextView.text = [NSString stringWithFormat:@"%ld", responseObject];
                }
            }];
        }
        
        if ([rowStr isEqualToString:LWLocalizbleString(@"Enable/exit sprint mode")]) {
            _switchMode = !_switchMode;
            FB_SPRINTMODE sprint = _switchMode ? FB_SPRINTMODE_ON : FB_SPRINTMODE_OFF;
            
            [FBAtCommand.sharedInstance fbUpSprintMode:sprint withBlock:^(NSError * _Nullable error) {
                if (error) {
                    [NSObject showHUDText:[NSString stringWithFormat:@"%@", error]];
                } else {
                    weakSelf.receTextView.text = LWLocalizbleString(@"Success");
                }
            }];
        }
        
        if ([rowStr isEqualToString:LWLocalizbleString(@"Enter/Exit production mode")]) {
            _switchMode = !_switchMode;
            
            [FBAtCommand.sharedInstance fbUpProductionTestModeIsOpen:_switchMode withBlock:^(NSError * _Nullable error) {
                if (error) {
                    [NSObject showHUDText:[NSString stringWithFormat:@"%@", error]];
                } else {
                    weakSelf.receTextView.text = LWLocalizbleString(@"Success");
                }
            }];
        }
        
        if ([rowStr isEqualToString:LWLocalizbleString(@"Set temperature unit")]) {
            _switchMode = !_switchMode;
            FB_TEMPERATUREUNIT units = _switchMode ? FB_Centigrade : FB_FahrenheitDegree;
            
            [FBAtCommand.sharedInstance fbUpTemperatureUnitWithUnit:units withBlock:^(NSError * _Nullable error) {
                if (error) {
                    [NSObject showHUDText:[NSString stringWithFormat:@"%@", error]];
                } else {
                    weakSelf.receTextView.text = LWLocalizbleString(@"Success");
                }
            }];
        }
        
        if ([rowStr isEqualToString:LWLocalizbleString(@"Get the duration of the bright screen")]) {
            [FBAtCommand.sharedInstance fbGetTheDurationOfBrightScreenWithBlock:^(NSInteger responseObject, NSError * _Nullable error) {
                if (error) {
                    [NSObject showHUDText:[NSString stringWithFormat:@"%@", error]];
                } else {
                    weakSelf.receTextView.text = [NSString stringWithFormat:@"%ld", responseObject];
                }
            }];
        }
        
        if ([rowStr isEqualToString:LWLocalizbleString(@"Set the duration of the bright screen")]) {
            [FBAtCommand.sharedInstance fbSetTheDurationOfBrightScreenWithDuration:20 withBlock:^(NSError * _Nullable error) {
                if (error) {
                    [NSObject showHUDText:[NSString stringWithFormat:@"%@", error]];
                } else {
                    weakSelf.receTextView.text = LWLocalizbleString(@"Success");
                }
            }];
        }
        
        if ([rowStr isEqualToString:LWLocalizbleString(@"Switch to the specified watch face")]) {
            [FBAtCommand.sharedInstance fbTogglesTheSpecifiedDialWithIndex:2 withBlock:^(NSError * _Nullable error) {
                if (error) {
                    [NSObject showHUDText:[NSString stringWithFormat:@"%@", error]];
                } else {
                    weakSelf.receTextView.text = LWLocalizbleString(@"Success");
                }
            }];
        }
        
        if ([rowStr isEqualToString:LWLocalizbleString(@"Set vibration feedback")]) {
            _switchMode = !_switchMode;
            
            [FBAtCommand.sharedInstance fbVibrationFeedbackSwitchWithMode:_switchMode withBlock:^(NSError * _Nullable error) {
                if (error) {
                    [NSObject showHUDText:[NSString stringWithFormat:@"%@", error]];
                } else {
                    weakSelf.receTextView.text = LWLocalizbleString(@"Success");
                }
            }];
        }
        
        if ([rowStr isEqualToString:LWLocalizbleString(@"Request to bind the device")]) {
            [FBAtCommand.sharedInstance fbBindDeviceRequest:nil withBlock:^(NSInteger responseObject, NSError * _Nullable error) {
                if (error) {
                    [NSObject showHUDText:[NSString stringWithFormat:@"%@", error]];
                } else {
                    weakSelf.receTextView.text = [NSString stringWithFormat:@"%ld", responseObject];
                }
            }];
        }
        
        if ([rowStr isEqualToString:LWLocalizbleString(@"Request to unbind the device")]) {
            [FBAtCommand.sharedInstance fbUnbindDeviceRequestWithBlock:^(NSError * _Nullable error) {
                if (error) {
                    [NSObject showHUDText:[NSString stringWithFormat:@"%@", error]];
                } else {
                    weakSelf.receTextView.text = LWLocalizbleString(@"Success");
                }
                [FBBluetoothManager.sharedInstance disconnectPeripheral];
            }];
        }
        
        if ([rowStr isEqualToString:LWLocalizbleString(@"Get resting heart rate for the day")]) {
            [FBAtCommand.sharedInstance fbGetRestingHeartRateOfTheDayWithBlock:^(NSInteger responseObject, NSError * _Nullable error) {
                if (error) {
                    [NSObject showHUDText:[NSString stringWithFormat:@"%@", error]];
                } else {
                    weakSelf.receTextView.text = [NSString stringWithFormat:@"%ld", responseObject];
                }
            }];
        }
        
        if ([rowStr isEqualToString:LWLocalizbleString(@"Get the specified prompt function")]) {
            [FBAtCommand.sharedInstance fbGetPromptFunctionWithMode:FB_ExerciseHeartRate withBlock:^(NSInteger responseObject, NSError * _Nullable error) {
                if (error) {
                    [NSObject showHUDText:[NSString stringWithFormat:@"%@", error]];
                } else {
                    weakSelf.receTextView.text = [NSString stringWithFormat:@"%ld", responseObject];
                }
            }];
        }
        
        if ([rowStr isEqualToString:LWLocalizbleString(@"Set the specified reminder function")]) {
            [FBAtCommand.sharedInstance fbSetPromptFunctionWithMode:FB_ExerciseHeartRate withThreshold:70 withBlock:^(NSError * _Nullable error) {
                if (error) {
                    [NSObject showHUDText:[NSString stringWithFormat:@"%@", error]];
                } else {
                    weakSelf.receTextView.text = LWLocalizbleString(@"Success");
                }
            }];
        }
        
        if ([rowStr isEqualToString:LWLocalizbleString(@"The app side synchronizes the GPS motion status to the device side")]) {
            // This is the movement state of the watch controlled by the app
            FBGPSMotionActionModel *model = FBGPSMotionActionModel.new;
            model.MotionMode = FBOutdoor_running;
            model.MotionState = FB_SettingStartMotion;
            model.totalTime = 0;
            
            [FBAtCommand.sharedInstance fbSynchronizationGPS_MotionWithModel:model withBlock:^(NSError * _Nullable error) {
                if (error) {
                    [NSObject showHUDText:[NSString stringWithFormat:@"%@", error]];
                } else {
                    weakSelf.receTextView.text = LWLocalizbleString(@"Success");
                    
                    GCD_MAIN_QUEUE(^{
                        
                        [LWStartCountdownView.initialization showWithBlock:^{
                            
                            GCD_MAIN_QUEUE(^{
                            
                                FBSportsConnectViewController *vc = [[FBSportsConnectViewController alloc] initWithModel:model];
                                FBBaseNavigationController *naviBar = [[FBBaseNavigationController alloc] initWithRootViewController:vc];
                                if(@available(iOS 13.0,*)){
                                    naviBar.modalPresentationStyle = UIModalPresentationFullScreen;
                                }
                                [weakSelf.navigationController presentViewController:naviBar animated:YES completion:nil];
                            });
                        }];
                    });
                }
            }];
            
            // The movement state of the watch changes, please use the monitoring method -(void)fbGPS_MotionWatchStatusChangeCallbackWithBlock:
        }
        
        if ([rowStr isEqualToString:LWLocalizbleString(@"Turn on/off the heart rate monitoring switch")]) {
            _switchMode = !_switchMode;
            
            [FBAtCommand.sharedInstance fbUpHeartRateData:_switchMode withBlock:^(NSError * _Nullable error) {
                if (error) {
                    [NSObject showHUDText:[NSString stringWithFormat:@"%@", error]];
                } else {
                    weakSelf.receTextView.text = LWLocalizbleString(@"Success");
                }
            }];
        }
        
        if ([rowStr isEqualToString:LWLocalizbleString(@"Timing heart rate detection switch setting")]) {
            _switchMode = !_switchMode;
            
            [FBAtCommand.sharedInstance fbTimingHeartRateDetectionSwitchData:_switchMode withBlock:^(NSError * _Nullable error) {
                if (error) {
                    [NSObject showHUDText:[NSString stringWithFormat:@"%@", error]];
                } else {
                    weakSelf.receTextView.text = LWLocalizbleString(@"Success");
                }
            }];
        }
        
        if ([rowStr isEqualToString:LWLocalizbleString(@"Timed blood oxygen detection switch setting")]) {
            _switchMode = !_switchMode;
            
            [FBAtCommand.sharedInstance fbTimingBloodOxygenDetectionSwitchData:_switchMode withBlock:^(NSError * _Nullable error) {
                if (error) {
                    [NSObject showHUDText:[NSString stringWithFormat:@"%@", error]];
                } else {
                    weakSelf.receTextView.text = LWLocalizbleString(@"Success");
                }
            }];
        }
        
        if ([rowStr isEqualToString:LWLocalizbleString(@"Timed mental stress detection switch setting")]) {
            _switchMode = !_switchMode;
            
            [FBAtCommand.sharedInstance fbTimingStressDetectionSwitchData:_switchMode withBlock:^(NSError * _Nullable error) {
                if (error) {
                    [NSObject showHUDText:[NSString stringWithFormat:@"%@", error]];
                } else {
                    weakSelf.receTextView.text = LWLocalizbleString(@"Success");
                }
            }];
        }
        
        if ([rowStr isEqualToString:LWLocalizbleString(@"Get call audio switch status")]) {
            
            [FBAtCommand.sharedInstance fbGetCallAudioSwitchWithBlock:^(NSInteger responseObject, NSError * _Nullable error) {
                if (error) {
                    [NSObject showHUDText:[NSString stringWithFormat:@"%@", error]];
                } else {
                    weakSelf.receTextView.text = [NSString stringWithFormat:@"%@ - %ld", LWLocalizbleString(@"Success"), responseObject];
                }
            }];
        }
        
        if ([rowStr isEqualToString:LWLocalizbleString(@"Turn on/off call audio switch")]) {
            _switchMode = !_switchMode;
            
            [FBAtCommand.sharedInstance fbSetCallAudioSwitchData:_switchMode withBlock:^(NSError * _Nullable error) {
                if (error) {
                    [NSObject showHUDText:[NSString stringWithFormat:@"%@", error]];
                } else {
                    weakSelf.receTextView.text = LWLocalizbleString(@"Success");
                }
            }];
        }
        
        if ([rowStr isEqualToString:LWLocalizbleString(@"Get Multimedia Audio Switch status")]) {
            
            [FBAtCommand.sharedInstance fbGetMultimediaAudioSwitchWithBlock:^(NSInteger responseObject, NSError * _Nullable error) {
                if (error) {
                    [NSObject showHUDText:[NSString stringWithFormat:@"%@", error]];
                } else {
                    weakSelf.receTextView.text = [NSString stringWithFormat:@"%@ - %ld", LWLocalizbleString(@"Success"), responseObject];
                }
            }];
        }
        
        if ([rowStr isEqualToString:LWLocalizbleString(@"Turn on/off Multimedia Audio Switch")]) {
            _switchMode = !_switchMode;
            
            [FBAtCommand.sharedInstance fbSetMultimediaAudioSwitchData:_switchMode withBlock:^(NSError * _Nullable error) {
                if (error) {
                    [NSObject showHUDText:[NSString stringWithFormat:@"%@", error]];
                } else {
                    weakSelf.receTextView.text = LWLocalizbleString(@"Success");
                }
            }];
        }
    }
    
#pragma mark - Stream
    if (section == 1) {
        
        if ([rowStr isEqualToString:LWLocalizbleString(@"Enable(2s)/disable data monitoring flow")]) {
            _switchMode = !_switchMode;
            
            [FBAtCommand.sharedInstance fbUpDataStreamData:_staTime ? 2 : 0 withBlock:^(NSError * _Nullable error) {
                if (error) {
                    [NSObject showHUDText:[NSString stringWithFormat:@"%@", error]];
                } else {
                    weakSelf.receTextView.text = LWLocalizbleString(@"Success");
                }
            }];
            
            // After it is enabled, please use the monitoring method -(void)fbStreamDataHandlerWithBlock: to receive streaming data
        }
    }
    
#pragma mark - FBBgCommand
    if (section == 2) {
        
        if ([rowStr isEqualToString:LWLocalizbleString(@"Get device hardware information")]) {
            [FBBgCommand.sharedInstance fbGetHardwareInformationDataWithBlock:^(FB_RET_CMD status, float progress, FBDeviceInfoModel * _Nonnull responseObject, NSError * _Nonnull error) {
                if (error) {
                    [NSObject showHUDText:[NSString stringWithFormat:@"%@", error]];
                }
                else if (status==FB_INDATATRANSMISSION) {
                    weakSelf.receTextView.text = [NSString stringWithFormat:@"Receiving Progress: %.f%%", progress*100];
                }
                else if (status==FB_DATATRANSMISSIONDONE) {
                    weakSelf.receTextView.text = [NSString stringWithFormat:@"%@", responseObject.mj_keyValues];
                }
            }];
        }
        
        if ([rowStr isEqualToString:LWLocalizbleString(@"Obtain real-time measurement data of the day")]) {
            [FBBgCommand.sharedInstance fbGetCurrentDayActivityDataWithBlock:^(FB_RET_CMD status, float progress, FBCurrentDataModel * _Nonnull responseObject, NSError * _Nonnull error) {
                if (error) {
                    [NSObject showHUDText:[NSString stringWithFormat:@"%@", error]];
                }
                else if (status==FB_INDATATRANSMISSION) {
                    weakSelf.receTextView.text = [NSString stringWithFormat:@"Receiving Progress: %.f%%", progress*100];
                }
                else if (status==FB_DATATRANSMISSIONDONE) {
                    weakSelf.receTextView.text = [NSString stringWithFormat:@"%@", responseObject.mj_keyValues];
                }
            }];
        }
        
        if ([rowStr isEqualToString:LWLocalizbleString(@"Get real-time statistics report of current sleep")]) {
            [FBBgCommand.sharedInstance fbGetCurrentSleepStatisticsReportDataWithBlock:^(FB_RET_CMD status, float progress, NSArray<FBSleepCaculateReportModel *> * _Nullable responseObject, NSError * _Nullable error) {
                if (error) {
                    [NSObject showHUDText:[NSString stringWithFormat:@"%@", error]];
                }
                else if (status==FB_INDATATRANSMISSION) {
                    weakSelf.receTextView.text = [NSString stringWithFormat:@"Receiving Progress: %.f%%", progress*100];
                }
                else if (status==FB_DATATRANSMISSIONDONE) {
                    FBSleepCaculateReportModel *model = responseObject.firstObject;
                    weakSelf.receTextView.text = [NSString stringWithFormat:@"%@", model.mj_keyValues];
                }
            }];
        }
        
        if ([rowStr isEqualToString:LWLocalizbleString(@"Get the current real-time sleep state record")]) {
            [FBBgCommand.sharedInstance fbGetCurrentSleepStateRecordingDataWithBlock:^(FB_RET_CMD status, float progress, NSArray<FBSleepStatusRecordModel *> * _Nullable responseObject, NSError * _Nullable error) {
                if (error) {
                    [NSObject showHUDText:[NSString stringWithFormat:@"%@", error]];
                }
                else if (status==FB_INDATATRANSMISSION) {
                    weakSelf.receTextView.text = [NSString stringWithFormat:@"Receiving Progress: %.f%%", progress*100];
                }
                else if (status==FB_DATATRANSMISSIONDONE) {
                    FBSleepStatusRecordModel *model = responseObject.firstObject;
                    weakSelf.receTextView.text = [NSString stringWithFormat:@"%@", model.mj_keyValues];
                }
            }];
        }
        
        if ([rowStr isEqualToString:LWLocalizbleString(@"Get daily activity statistics report")]) {
            [FBBgCommand.sharedInstance fbGetDailyActivityDataStartTime:staTime forEndTime:endTime withBlock:^(FB_RET_CMD status, float progress, NSArray<FBDayActivityModel *> * _Nonnull responseObject, NSError * _Nonnull error) {
                if (error) {
                    [NSObject showHUDText:[NSString stringWithFormat:@"%@", error]];
                }
                else if (status==FB_INDATATRANSMISSION) {
                    weakSelf.receTextView.text = [NSString stringWithFormat:@"Receiving Progress: %.f%%", progress*100];
                }
                else if (status==FB_DATATRANSMISSIONDONE) {
                    
                    NSMutableString *mutStr = [NSMutableString string];
                    for (FBDayActivityModel *model in responseObject) {
                        [mutStr appendFormat:@"%@", model.mj_keyValues];
                    }
                    weakSelf.receTextView.text = mutStr.length ? mutStr : LWLocalizbleString(@"No Data");
                }
            }];
        }
        
        if ([rowStr isEqualToString:LWLocalizbleString(@"Obtain the hourly activity statistics report")]) {
            [FBBgCommand.sharedInstance fbGetHourlyActivityDataStartTime:staTime forEndTime:endTime withBlock:^(FB_RET_CMD status, float progress, NSArray<FBHourReportModel *> * _Nonnull responseObject, NSError * _Nonnull error) {
                if (error) {
                    [NSObject showHUDText:[NSString stringWithFormat:@"%@", error]];
                }
                else if (status==FB_INDATATRANSMISSION) {
                    weakSelf.receTextView.text = [NSString stringWithFormat:@"Receiving Progress: %.f%%", progress*100];
                }
                else if (status==FB_DATATRANSMISSIONDONE) {
                    
                    NSMutableString *mutStr = [NSMutableString string];
                    for (FBHourReportModel *model in responseObject) {
                        [mutStr appendFormat:@"%@", model.mj_keyValues];
                    }
                    weakSelf.receTextView.text = mutStr.length ? mutStr : LWLocalizbleString(@"No Data");
                }
            }];
        }
        
        if ([rowStr isEqualToString:LWLocalizbleString(@"Get sleep statistics report")]) {
            [FBBgCommand.sharedInstance fbGetSleepStatisticsReportDataStartTime:staTime forEndTime:endTime withBlock:^(FB_RET_CMD status, float progress, NSArray<FBSleepCaculateReportModel *> * _Nonnull responseObject, NSError * _Nonnull error) {
                if (error) {
                    [NSObject showHUDText:[NSString stringWithFormat:@"%@", error]];
                }
                else if (status==FB_INDATATRANSMISSION) {
                    weakSelf.receTextView.text = [NSString stringWithFormat:@"Receiving Progress: %.f%%", progress*100];
                }
                else if (status==FB_DATATRANSMISSIONDONE) {
                    
                    NSMutableString *mutStr = [NSMutableString string];
                    for (FBSleepCaculateReportModel *model in responseObject) {
                        [mutStr appendFormat:@"%@", model.mj_keyValues];
                    }
                    weakSelf.receTextView.text = mutStr.length ? mutStr : LWLocalizbleString(@"No Data");
                }
            }];
        }
        
        if ([rowStr isEqualToString:LWLocalizbleString(@"Get sleep status record")]) {
            [FBBgCommand.sharedInstance fbGetSleepStateRecordingDataStartTime:staTime forEndTime:endTime withBlock:^(FB_RET_CMD status, float progress, NSArray<FBSleepStatusRecordModel *> * _Nonnull responseObject, NSError * _Nonnull error) {
                if (error) {
                    [NSObject showHUDText:[NSString stringWithFormat:@"%@", error]];
                }
                else if (status==FB_INDATATRANSMISSION) {
                    weakSelf.receTextView.text = [NSString stringWithFormat:@"Receiving Progress: %.f%%", progress*100];
                }
                else if (status==FB_DATATRANSMISSIONDONE) {
                    
                    NSMutableString *mutStr = [NSMutableString string];
                    for (FBSleepStatusRecordModel *model in responseObject) {
                        NSString *string = [NSString stringWithFormat:@"%@\n",model.mj_keyValues];
                        [mutStr appendFormat:@"%@", string];
                    }
                    weakSelf.receTextView.text = mutStr.length ? mutStr : LWLocalizbleString(@"No Data");
                }
            }];
        }
        
        if ([rowStr isEqualToString:LWLocalizbleString(@"Get a list of device motion types")]) {
            [FBBgCommand.sharedInstance fbGetListOfDeviceMotionTypesWithBlock:^(FB_RET_CMD status, float progress, FBMotionTypesListModel * _Nullable responseObject, NSError * _Nullable error) {
                if (error) {
                    [NSObject showHUDText:[NSString stringWithFormat:@"%@", error]];
                }
                else if (status==FB_INDATATRANSMISSION) {
                    weakSelf.receTextView.text = [NSString stringWithFormat:@"Receiving Progress: %.f%%", progress*100];
                }
                else if (status==FB_DATATRANSMISSIONDONE) {
                    
                    weakSelf.receTextView.text = [NSString stringWithFormat:@"%@", responseObject.mj_keyValues];
                }
            }];
        }
        
        if ([rowStr isEqualToString:LWLocalizbleString(@"Get list of exercise records")]) {
            [FBBgCommand.sharedInstance fbGetMotionRecordListDataStartTime:staTime forEndTime:endTime withBlock:^(FB_RET_CMD status, float progress, NSArray<FBSportRecordModel *> * _Nonnull responseObject, NSError * _Nonnull error) {
                if (error) {
                    [NSObject showHUDText:[NSString stringWithFormat:@"%@", error]];
                }
                else if (status==FB_INDATATRANSMISSION) {
                    weakSelf.receTextView.text = [NSString stringWithFormat:@"Receiving Progress: %.f%%", progress*100];
                }
                else if (status==FB_DATATRANSMISSIONDONE) {
                    
                    NSMutableString *mutStr = [NSMutableString string];
                    for (FBSportRecordModel *model in responseObject) {
                        [mutStr appendFormat:@"%@", model.mj_keyValues];
                    }
                    weakSelf.receTextView.text = mutStr.length ? mutStr : LWLocalizbleString(@"No Data");
                }
            }];
        }
        
        if ([rowStr isEqualToString:LWLocalizbleString(@"Get Sports Statistics Report")]) {
            [FBBgCommand.sharedInstance fbGetSportsDataReportDataStartTime:staTime forEndTime:endTime withBlock:^(FB_RET_CMD status, float progress, NSArray<FBSportCaculateModel *> * _Nonnull responseObject, NSError * _Nonnull error) {
                if (error) {
                    [NSObject showHUDText:[NSString stringWithFormat:@"%@", error]];
                }
                else if (status==FB_INDATATRANSMISSION) {
                    weakSelf.receTextView.text = [NSString stringWithFormat:@"Receiving Progress: %.f%%", progress*100];
                }
                else if (status==FB_DATATRANSMISSIONDONE) {
                    
                    NSMutableString *mutStr = [NSMutableString string];
                    for (FBSportCaculateModel *model in responseObject) {
                        [mutStr appendFormat:@"%@", model.mj_keyValues];
                    }
                    weakSelf.receTextView.text = mutStr.length ? mutStr : LWLocalizbleString(@"No Data");
                }
            }];
        }
        
        if ([rowStr isEqualToString:LWLocalizbleString(@"Get heart rate records")]) {
            [FBBgCommand.sharedInstance fbGetHeartRateRecordDataStartTime:staTime forEndTime:endTime withBlock:^(FB_RET_CMD status, float progress, NSArray<FBTypeRecordModel *> * _Nonnull responseObject, NSError * _Nonnull error) {
                if (error) {
                    [NSObject showHUDText:[NSString stringWithFormat:@"%@", error]];
                }
                else if (status==FB_INDATATRANSMISSION) {
                    weakSelf.receTextView.text = [NSString stringWithFormat:@"Receiving Progress: %.f%%", progress*100];
                }
                else if (status==FB_DATATRANSMISSIONDONE) {
                    
                    NSMutableString *mutStr = [NSMutableString string];
                    for (FBTypeRecordModel *model in responseObject) {
                        
                        [mutStr appendFormat:@"%@\n", model.mj_keyValues];
                        
                        for (FBRecordDetailsModel *reArr in model.recordArray) {
                            [mutStr appendFormat:@"%@", [NSString stringWithFormat:@"%@=====%ld\n", reArr.dateTimeStr, reArr.hr]];
                        }
                        
                    }
                    weakSelf.receTextView.text = mutStr.length ? mutStr : LWLocalizbleString(@"No Data");
                }
            }];
        }
        
        if ([rowStr isEqualToString:LWLocalizbleString(@"Get pedometer records")]) {
            [FBBgCommand.sharedInstance fbGetStepCountRecordDataStartTime:staTime forEndTime:endTime withBlock:^(FB_RET_CMD status, float progress, NSArray<FBTypeRecordModel *> * _Nonnull responseObject, NSError * _Nonnull error) {
                if (error) {
                    [NSObject showHUDText:[NSString stringWithFormat:@"%@", error]];
                }
                else if (status==FB_INDATATRANSMISSION) {
                    weakSelf.receTextView.text = [NSString stringWithFormat:@"Receiving Progress: %.f%%", progress*100];
                }
                else if (status==FB_DATATRANSMISSIONDONE) {
                    
                    NSMutableString *mutStr = [NSMutableString string];
                    for (FBTypeRecordModel *model in responseObject) {
                        
                        [mutStr appendFormat:@"%@\n", model.mj_keyValues];
                        
                        for (FBRecordDetailsModel *reArr in model.recordArray) {
                            [mutStr appendFormat:@"%@", [NSString stringWithFormat:@"%@=====%ld\n", reArr.dateTimeStr, reArr.step]];
                        }
                        
                    }
                    weakSelf.receTextView.text = mutStr.length ? mutStr : LWLocalizbleString(@"No Data");
                }
            }];
        }
        
        if ([rowStr isEqualToString:LWLocalizbleString(@"Get Blood Oxygen Records")]) {
            [FBBgCommand.sharedInstance fbGetBloodOxygenRecordDataStartTime:staTime forEndTime:endTime withBlock:^(FB_RET_CMD status, float progress, NSArray<FBTypeRecordModel *> * _Nonnull responseObject, NSError * _Nonnull error) {
                if (error) {
                    [NSObject showHUDText:[NSString stringWithFormat:@"%@", error]];
                }
                else if (status==FB_INDATATRANSMISSION) {
                    weakSelf.receTextView.text = [NSString stringWithFormat:@"Receiving Progress: %.f%%", progress*100];
                }
                else if (status==FB_DATATRANSMISSIONDONE) {
                    
                    NSMutableString *mutStr = [NSMutableString string];
                    for (FBTypeRecordModel *model in responseObject) {
                        
                        [mutStr appendFormat:@"%@\n", model.mj_keyValues];
                        
                        for (FBRecordDetailsModel *reArr in model.recordArray) {
                            [mutStr appendFormat:@"%@", [NSString stringWithFormat:@"%@=====%ld\n", reArr.dateTimeStr, reArr.Sp02]];
                        }
                        
                    }
                    weakSelf.receTextView.text = mutStr.length ? mutStr : LWLocalizbleString(@"No Data");
                }
            }];
        }
        
        if ([rowStr isEqualToString:LWLocalizbleString(@"Get blood pressure records")]) {
            [FBBgCommand.sharedInstance fbGetBloodPressureRecordsDataStartTime:staTime forEndTime:endTime withBlock:^(FB_RET_CMD status, float progress, NSArray<FBTypeRecordModel *> * _Nonnull responseObject, NSError * _Nonnull error) {
                if (error) {
                    [NSObject showHUDText:[NSString stringWithFormat:@"%@", error]];
                }
                else if (status==FB_INDATATRANSMISSION) {
                    weakSelf.receTextView.text = [NSString stringWithFormat:@"Receiving Progress: %.f%%", progress*100];
                }
                else if (status==FB_DATATRANSMISSIONDONE) {
                    
                    NSMutableString *mutStr = [NSMutableString string];
                    for (FBTypeRecordModel *model in responseObject) {
                        
                        [mutStr appendFormat:@"%@\n", model.mj_keyValues];
                        
                        for (FBRecordDetailsModel *reArr in model.recordArray) {
                            [mutStr appendFormat:@"%@", [NSString stringWithFormat:@"%@=====man%ld-min%ld\n", reArr.dateTimeStr, reArr.pb_max, reArr.pb_min]];
                        }
                        
                    }
                    weakSelf.receTextView.text = mutStr.length ? mutStr : LWLocalizbleString(@"No Data");
                }
            }];
        }
        
        if ([rowStr isEqualToString:LWLocalizbleString(@"Obtain exercise high-frequency heart rate records (1 time per second)")]) {
            [FBBgCommand.sharedInstance fbExerciseHighFrequencyHeartRateRecordsDataStartTime:staTime forEndTime:endTime withBlock:^(FB_RET_CMD status, float progress, NSArray<FBTypeRecordModel *> * _Nullable responseObject, NSError * _Nullable error) {
                if (error) {
                    [NSObject showHUDText:[NSString stringWithFormat:@"%@", error]];
                }
                else if (status==FB_INDATATRANSMISSION) {
                    weakSelf.receTextView.text = [NSString stringWithFormat:@"Receiving Progress: %.f%%", progress*100];
                }
                else if (status==FB_DATATRANSMISSIONDONE) {
                    
                    NSMutableString *mutStr = [NSMutableString string];
                    for (FBTypeRecordModel *model in responseObject) {
                        
                        [mutStr appendFormat:@"%@\n", model.mj_keyValues];
                        
                        for (FBRecordDetailsModel *reArr in model.recordArray) {
                            [mutStr appendFormat:@"%@", [NSString stringWithFormat:@"%@=====%ld\n", reArr.dateTimeStr, reArr.hr]];
                        }
                        
                    }
                    weakSelf.receTextView.text = mutStr.length ? mutStr : LWLocalizbleString(@"No Data");
                }
            }];
        }
        
        if ([rowStr isEqualToString:LWLocalizbleString(@"Get Stress Records")]) {
            [FBBgCommand.sharedInstance fbGetStressRecordsDataStartTime:staTime forEndTime:endTime withBlock:^(FB_RET_CMD status, float progress, NSArray<FBTypeRecordModel *> * _Nonnull responseObject, NSError * _Nonnull error) {
                if (error) {
                    [NSObject showHUDText:[NSString stringWithFormat:@"%@", error]];
                }
                else if (status==FB_INDATATRANSMISSION) {
                    weakSelf.receTextView.text = [NSString stringWithFormat:@"Receiving Progress: %.f%%", progress*100];
                }
                else if (status==FB_DATATRANSMISSIONDONE) {
                    
                    NSMutableString *mutStr = [NSMutableString string];
                    for (FBTypeRecordModel *model in responseObject) {
                        
                        [mutStr appendFormat:@"%@\n", model.mj_keyValues];
                        
                        for (FBRecordDetailsModel *reArr in model.recordArray) {
                            [mutStr appendFormat:@"%@", [NSString stringWithFormat:@"%@=====Value%ld-Range%u\n", reArr.dateTimeStr, reArr.stress, reArr.StressRange]];
                        }
                        
                    }
                    weakSelf.receTextView.text = mutStr.length ? mutStr : LWLocalizbleString(@"No Data");
                }
            }];
        }
        
        if ([rowStr isEqualToString:LWLocalizbleString(@"Get exercise details record")]) {
            [FBBgCommand.sharedInstance fbGetExerciseDetailsDataStartTime:staTime forEndTime:endTime withBlock:^(FB_RET_CMD status, float progress, NSArray<FBTypeRecordModel *> * _Nonnull responseObject, NSError * _Nonnull error) {
                if (error) {
                    [NSObject showHUDText:[NSString stringWithFormat:@"%@", error]];
                }
                else if (status==FB_INDATATRANSMISSION) {
                    weakSelf.receTextView.text = [NSString stringWithFormat:@"Receiving Progress: %.f%%", progress*100];
                }
                else if (status==FB_DATATRANSMISSIONDONE) {
                    
                    NSMutableString *mutStr = [NSMutableString string];
                    for (FBTypeRecordModel *model in responseObject) {
                        
                        [mutStr appendFormat:@"%@\n", model.mj_keyValues];
                        
                        for (FBRecordDetailsModel *reArr in model.recordArray) {
                            [mutStr appendFormat:@"%@", [NSString stringWithFormat:@"%@=====\n pace%ld\n calories%ld\n stepFrequency%ld\n distance%ld\n heartRate%ld\n stamina%ld\n isSuspend%ld\n", reArr.dateTimeStr, reArr.pace, reArr.calories, reArr.stepFrequency, reArr.distance, reArr.heartRate, reArr.stamina, (long)reArr.isSuspend]];
                        }
                        
                    }
                    weakSelf.receTextView.text = mutStr.length ? mutStr : LWLocalizbleString(@"No Data");
                }
            }];
        }
        
        if ([rowStr isEqualToString:LWLocalizbleString(@"Get sports statistics report + sports details record")]) {
            [FBBgCommand.sharedInstance fbGetSportsStatisticsDetailsReportsWithStartTime:staTime forEndTime:endTime withBlock:^(FB_RET_CMD status, float progress, NSArray<FBSportsStatisticsDetailsRecordModel *> * _Nullable responseObject, NSError * _Nullable error) {
                
                if (error) {
                    [NSObject showHUDText:[NSString stringWithFormat:@"%@", error]];
                }
                else if (status==FB_INDATATRANSMISSION) {
                    weakSelf.receTextView.text = [NSString stringWithFormat:@"Receiving Progress: %.f%%", progress*100];
                }
                else if (status==FB_DATATRANSMISSIONDONE) {
                    
                    NSMutableString *mutStr = [NSMutableString string];
                    for (FBSportsStatisticsDetailsRecordModel *model in responseObject) {
                        
                        [mutStr appendFormat:@"%@\n", model.sportsStatisticsRecord.mj_keyValues];
                        
                        for (FBRecordDetailsModel *item in model.sportsDetailsRecord) {
                            [mutStr appendFormat:@"%@", [NSString stringWithFormat:@"-----\npace %ld\ncalories %ld\nstepFrequency %ld\ndistance %ld\nheartRate %ld\nstamina %ld\nisSuspend %d\n-----\n", item.pace, item.calories, item.stepFrequency, item.distance, item.heartRate, item.stamina, (int)item.isSuspend]];
                        }
                        
                    }
                    weakSelf.receTextView.text = mutStr.length ? mutStr : LWLocalizbleString(@"No Data");
                }
            }];
        }
        
        if ([rowStr isEqualToString:LWLocalizbleString(@"Obtain motion location records")]) {
            [FBBgCommand.sharedInstance fbGetMotionLocationRecordDataStartTime:staTime forEndTime:endTime withBlock:^(FB_RET_CMD status, float progress, NSArray<FBTypeRecordModel *> * _Nonnull responseObject, NSError * _Nonnull error) {
                if (error) {
                    [NSObject showHUDText:[NSString stringWithFormat:@"%@", error]];
                }
                else if (status==FB_INDATATRANSMISSION) {
                    weakSelf.receTextView.text = [NSString stringWithFormat:@"Receiving Progress: %.f%%", progress*100];
                }
                else if (status==FB_DATATRANSMISSIONDONE) {
                    
                    NSMutableString *mutStr = [NSMutableString string];
                    for (FBTypeRecordModel *model in responseObject) {
                        
                        [mutStr appendFormat:@"%@\n", model.mj_keyValues];
                        
                        for (FBRecordDetailsModel *reArr in model.recordArray) {
                            [mutStr appendFormat:@"%@", [NSString stringWithFormat:@"%@=====\n lat%.6f\n log%.6f\n speed%ld\n gpsIsSuspend%ld\n", reArr.dateTimeStr, reArr.latitude, reArr.longitude, reArr.speed, (long)reArr.gpsIsSuspend]];
                        }
                        
                    }
                    weakSelf.receTextView.text = mutStr.length ? mutStr : LWLocalizbleString(@"No Data");
                }
            }];
        }
        
        if ([rowStr isEqualToString:LWLocalizbleString(@"Acquire manual measurement data records")]) {
            [FBBgCommand.sharedInstance fbGetManualMeasurementDataStartTime:staTime forEndTime:endTime withBlock:^(FB_RET_CMD status, float progress, NSArray<FBManualMeasureDataModel *> * _Nonnull responseObject, NSError * _Nonnull error) {
                if (error) {
                    [NSObject showHUDText:[NSString stringWithFormat:@"%@", error]];
                }
                else if (status==FB_INDATATRANSMISSION) {
                    weakSelf.receTextView.text = [NSString stringWithFormat:@"Receiving Progress: %.f%%", progress*100];
                }
                else if (status==FB_DATATRANSMISSIONDONE) {
                    
                    NSMutableString *mutStr = [NSMutableString string];
                    for (FBManualMeasureDataModel *model in responseObject) {
                        [mutStr appendFormat:@"%@\n", model.mj_keyValues];
                    }
                    weakSelf.receTextView.text = mutStr.length ? mutStr : LWLocalizbleString(@"No Data");
                }
            }];
        }
        
        if ([rowStr isEqualToString:LWLocalizbleString(@"Get specified records and reports")]) {
            
            //For example, acquiring heart rate, blood oxygen, and exercise records
            FB_MULTIPLERECORDREPORTS mode = FB_HeartRateRecording | FB_BloodOxygenRecording | FB_SportsRecordList;
            
            NSMutableString *mutStr = [NSMutableString string];
            [FBBgCommand.sharedInstance fbGetSpecialRecordsAndReportsDataWithType:mode startTime:staTime forEndTime:endTime withBlock:^(FB_RET_CMD status, FB_MULTIPLERECORDREPORTS recordType, float progress, id  _Nonnull responseObject, NSError * _Nonnull error) {
                if (mode==recordType) {
                    if (error) {
                        [mutStr appendFormat:@"ERROR：%@\n\n",error.domain];
                        weakSelf.receTextView.text = mutStr;
                    }
                } else if (recordType==FB_HeartRateRecording) {
                    if (error) {
                        [mutStr appendFormat:@"FB_HeartRateRecording ERROR：%@\n\n",error.domain];
                    } else if (status==FB_DATATRANSMISSIONDONE) {
                        
                        [mutStr appendFormat:@"FB_HeartRateRecording：%@\n\n",responseObject];
                    }
                } else if (recordType==FB_BloodOxygenRecording) {
                    if (error) {
                        [mutStr appendFormat:@"FB_BloodOxygenRecording ERROR：%@\n\n",error.domain];
                    } else if (status==FB_DATATRANSMISSIONDONE) {
                        
                        [mutStr appendFormat:@"FB_BloodOxygenRecording：%@\n\n",responseObject];
                    }
                } else if (recordType==FB_SportsRecordList) {
                    if (error)
                    {
                        [mutStr appendFormat:@"FB_SportsRecordList ERROR：%@\n\n",error.domain];
                        weakSelf.receTextView.text = mutStr;
                    }
                    else if (status==FB_DATATRANSMISSIONDONE)
                    {
                        
                        [mutStr appendFormat:@"FB_SportsRecordList：%@\n\n",responseObject];
                        weakSelf.receTextView.text = mutStr;
                    }
                }
            }];
        }
                
        if ([rowStr isEqualToString:LWLocalizbleString(@"User Info")]) {
            UserInforViewController *vc = [UserInforViewController new];
            vc.title = rowStr;
            [self.navigationController pushViewController:vc animated:YES];
        }
        
        if ([rowStr isEqualToString:LWLocalizbleString(@"Reminder/Alarm")]) {
            ClockInforListVC *vc = [ClockInforListVC new];
            vc.title = rowStr;
            [self.navigationController pushViewController:vc animated:YES];
        }
        
        if ([rowStr isEqualToString:LWLocalizbleString(@"Message Switch")]) {
            MessagePushSwitchVC *vc = [MessagePushSwitchVC new];
            vc.title = rowStr;
            [self.navigationController pushViewController:vc animated:YES];
        }
        
        if ([rowStr isEqualToString:LWLocalizbleString(@"Heart Rate Level")]) {
            HeartRateViewController *vc = [HeartRateViewController new];
            vc.title = rowStr;
            [self.navigationController pushViewController:vc animated:YES];
        }
        
        if ([rowStr isEqualToString:LWLocalizbleString(@"Sedentary Reminder")]) {
            SedentaryViewController *vc = [SedentaryViewController new];
            vc.title = rowStr;
            [self.navigationController pushViewController:vc animated:YES];
            
        }
        
        if ([rowStr isEqualToString:LWLocalizbleString(@"Drink Water Reminder")]) {
            WaterClockViewController *vc = [WaterClockViewController new];
            vc.title = rowStr;
            [self.navigationController pushViewController:vc animated:YES];
        }
        
        if ([rowStr isEqualToString:LWLocalizbleString(@"DND Reminder")]) {
            NotDisturbViewController *vc = [NotDisturbViewController new];
            vc.title = rowStr;
            [self.navigationController pushViewController:vc animated:YES];
        }
        
        if ([rowStr isEqualToString:LWLocalizbleString(@"Heart Rate Monitor")]) {
            HrCheckViewController *vc = [HrCheckViewController new];
            vc.title = rowStr;
            [self.navigationController pushViewController:vc animated:YES];
        }
        
        if ([rowStr isEqualToString:LWLocalizbleString(@"Raise Wrist")]) {
            BrightScreenViewController *vc = [BrightScreenViewController new];
            vc.title = rowStr;
            [self.navigationController pushViewController:vc animated:YES];
        }
        
        if ([rowStr isEqualToString:LWLocalizbleString(@"Sport Goal")]) {
            SportTargetViewController *vc = [SportTargetViewController new];
            vc.title = rowStr;
            [self.navigationController pushViewController:vc animated:YES];
        }
        
        if ([rowStr isEqualToString:LWLocalizbleString(@"Set Weather")]) {
            WeatherViewController *vc= [WeatherViewController new];
            vc.title = rowStr;
            [self.navigationController pushViewController:vc animated:YES];
        }
        
        if ([rowStr isEqualToString:LWLocalizbleString(@"Push Location Info")]) {
            [FBBgCommand.sharedInstance fbPushMobileLocationInformationWithLongitude:114.035544 withLatitude:22.648616 withBlock:^(NSError * _Nullable error) {
                if (error) {
                    [NSObject showHUDText:[NSString stringWithFormat:@"%@", error]];
                } else {
                    weakSelf.receTextView.text = LWLocalizbleString(@"Success");
                }
            }];
        }
        
        if ([rowStr isEqualToString:LWLocalizbleString(@"Physical Health")]) {
            FemaleCircadianCycleVC *vc = [FemaleCircadianCycleVC new];
            vc.title = rowStr;
            [self.navigationController pushViewController:vc animated:YES];
        }
        
        if ([rowStr isEqualToString:LWLocalizbleString(@"Abnormal HR reminder")]) {
            HeartRateReminderVC *vc = [HeartRateReminderVC new];
            vc.title = rowStr;
            [self.navigationController pushViewController:vc animated:YES];
        }
        
        if ([rowStr isEqualToString:LWLocalizbleString(@"Frequent Contacts")]) {
            LWPersonViewController *vc = [LWPersonViewController new];
            vc.title = rowStr;
            [self.navigationController pushViewController:vc animated:YES];
        }
        
        if ([rowStr isEqualToString:LWLocalizbleString(@"Request Device Logs")]) {
            [FBBgCommand.sharedInstance fbRequestDeviceLogsWithBlock:^(FB_RET_CMD status, float progress, NSString * _Nullable responseObject, NSError * _Nullable error) {
                if (error) {
                    [NSObject showHUDText:[NSString stringWithFormat:@"%@", error]];
                }
                else if (status==FB_INDATATRANSMISSION) {
                    weakSelf.receTextView.text = [NSString stringWithFormat:@"Receiving Progress: %.f%%", progress*100];
                }
                else if (status==FB_DATATRANSMISSIONDONE) {
                    
                    weakSelf.receTextView.text = responseObject;
                }
            }];
        }
    }
    
#pragma mark - OTA
    if (section == 3) {
        
        if ([rowStr isEqualToString:LWLocalizbleString(@"Firmware OTA")]) {
            BinFileViewController *vc = [BinFileViewController new];
            vc.title = rowStr;
            [self.navigationController pushViewController:vc animated:YES];
        }
        
        if ([rowStr isEqualToString:LWLocalizbleString(@"Dial Face OTA")]){
            FBClockDialCategoryViewController *vc = [FBClockDialCategoryViewController new];
            vc.title = rowStr;
            [self.navigationController pushViewController:vc animated:YES];
        }
        
        if ([rowStr isEqualToString:LWLocalizbleString(@"Sports Type OTA")]) {
            MotionPushViewController *vc = [MotionPushViewController new];
            vc.title = rowStr;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

#pragma mark - titleView
- (QMUIButton *)titleView {
    if (!_titleView) {
        _titleView = [QMUIButton buttonWithType:UIButtonTypeCustom];
        _titleView.titleLabel.font = [NSObject themePingFangSCMediumFont:18];
        _titleView.frame = CGRectMake(0, 0, SCREEN_WIDTH-120, 44);
        [_titleView setTitleColor:self.navigationController.navigationBar.tintColor forState:UIControlStateNormal];
        [_titleView setImage:IMAGE_NAME(@"ic_device_disconnect") forState:UIControlStateNormal];
        [_titleView setImage:IMAGE_NAME(@"ic_device_connect") forState:UIControlStateSelected];
        _titleView.spacingBetweenImageAndTitle = 5;
    }
    return _titleView;
}

#pragma mark - batteryView
- (FBBatteryView *)batteryView {
    if (!_batteryView) {
        _batteryView = [[FBBatteryView alloc] initWithFrame:CGRectMake(0, 0, 60, 44)];
    }
    return _batteryView;
}


#pragma mark - NSNotification
- (void)result:(NSNotification *)obj {
    
    if ([obj.object isKindOfClass:NSNumber.class]) {
        
        [self reloadTitle];
        
        CONNECTBINGSTATE state = (CONNECTBINGSTATE)[obj.object integerValue];
        
        WeakSelf(self);
        if (state == CONNECTBINGSTATE_COMPLETE) {
            [FBAtCommand.sharedInstance fbReqBatteryStatusDataWithBlock:^(FBBatteryInfoModel * _Nullable responseObject, NSError * _Nullable error) { // Refresh battery
                
                [weakSelf.batteryView reloadBattery:responseObject.batteryLevel state:responseObject.batteryState];
            }];
        }
    }
    
    else if ([obj.object isKindOfClass:FBWatchFunctionChangeNoticeModel.class]) {
        
        FBWatchFunctionChangeNoticeModel *model = (FBWatchFunctionChangeNoticeModel *)obj.object;
        EM_FUNC_SWITCH functionMode = model.functionMode;
        NSInteger functionChangeValue = model.functionChangeValue;
        
        self.receTextView.text = [NSString stringWithFormat:@"%@", model.mj_keyValues];
        
        if (functionMode == FS_STATEOFCHARGE_WARN) { // Refresh battery
            [self.batteryView reloadBattery:self.batteryView.battery state:(FB_BATTERYLEVEL)functionChangeValue];
        }
        
        else if (model.functionMode == FS_PERCENTAGE_BATTERY) { // Refresh battery
            [self.batteryView reloadBattery:functionChangeValue state:self.batteryView.level];
        }
        
        else if (model.functionMode == FS_TAKEPHOTOS_WARN) { // Camera mode
            
            UIViewController *vc = QMUIHelper.visibleViewController;
            
            if (functionChangeValue == 0) {
                if ([vc isKindOfClass:FBCameraViewController.class]) {
                    [vc.navigationController popViewControllerAnimated:YES];
                }
            } else if (functionChangeValue == 1) {
                if (![vc isKindOfClass:FBCameraViewController.class]) {
                    if (NSObject.accessCamera) {
                        FBCameraViewController *camera = FBCameraViewController.new;
                        [vc.navigationController pushViewController:camera animated:YES];
                    }
                }
            }
        }
        
        else {
            // More...
        }
    }
    
    else if ([obj.object isKindOfClass:FBStreamDataModel.class]) {
        
        FBStreamDataModel *model = (FBStreamDataModel *)obj.object;
        self.receTextView.text = [NSString stringWithFormat:@"%@", model.mj_keyValues];
    }
}

#pragma mark - 连接状态｜Connection Status
- (void)reloadTitle {
    
    if (StringIsEmpty(FBAllConfigObject.firmwareConfig.deviceName)) {
        self.titleView.selected = NO;
        [self.titleView setTitle:LWLocalizbleString(@"No Connection") forState:UIControlStateNormal];
        [self.batteryView reloadBattery:-1 state:BATT_NORMAL]; // -1 隐藏电量🔋
        
        self.versionLab.text = @"";
    }
    else {
        
        FBFirmwareVersionObject *object = FBAllConfigObject.firmwareConfig;
        
        if (FBBluetoothManager.sharedInstance.IsTheDeviceReady) {
            self.titleView.selected = YES;
            [self.titleView setTitle:object.deviceName forState:UIControlStateSelected];
        } else {
            self.titleView.selected = NO;
            [self.titleView setTitle:object.deviceName forState:UIControlStateNormal];
            [self.batteryView reloadBattery:-1 state:BATT_NORMAL]; // -1 隐藏电量🔋
        }
        
        self.versionLab.text = [NSString stringWithFormat:@"%@:%@ %@:%@\n%@ %@",
                                LWLocalizbleString(@"Firmware Version"), object.firmwareVersion,
                                LWLocalizbleString(@"Project Number"), object.fitNumber,
                                LWLocalizbleString(@"Mac Address"), object.mac];
    }
    
    self.navigationItem.titleView = self.titleView;
}

@end
