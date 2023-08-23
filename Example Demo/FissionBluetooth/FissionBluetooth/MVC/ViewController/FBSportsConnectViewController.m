//
//  FBSportsConnectViewController.m
//  FissionBluetooth
//
//  Created by 裂变智能 on 2023/3/7.
//

#import "FBSportsConnectViewController.h"
#import "LWSportsConnectModel.h"
#import "LWMotionDataView.h"
#import "dispatch_source_timer.h"
#import "XYButton.h"

@interface FBSportsConnectViewController ()

@property (nonatomic, strong) FBGPSMotionActionModel *model;

@property (nonatomic, strong) LWMotionDataView *motionDataView;

@property (nonatomic, strong) LWSportsConnectModel *tempModel;

@property (nonatomic, strong) XYButton *leftBtn;
@property (nonatomic, strong) XYButton *rightBtn;
@property (nonatomic, strong) XYButton *pauseBtn;

@end

@implementation FBSportsConnectViewController

- (instancetype)initWithModel:(FBGPSMotionActionModel *)model {
    if (self = [super init]) {
        self.model = model;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = LWLocalizbleString(@"Outdoor Running");
    WeakSelf(self);
    
    // 可视数据
    LWMotionDataView *motionDataView = [[LWMotionDataView alloc] initWithFrame:CGRectMake(0, NavigationContentTop, SCREEN_WIDTH, 300)];
    [self.view addSubview:motionDataView];
    self.motionDataView = motionDataView;
    
    //左边按钮
    _leftBtn = [[XYButton alloc] initWithFrame:CGRectMake(0, 0, 85, 85) backgroundColor:UIColorGreen borderColor:UIColorBlack title:LWLocalizbleString(@"Continue") titleColor:UIColorBlack font:[NSObject BahnschriftFont:18] tapBlock:^(UIButton *btn) {
        //点击事件
        [weakSelf continueBtnClick:YES];
        
    }];
    _leftBtn.left = SCREEN_WIDTH / 6;
    _leftBtn.bottom = SCREEN_HEIGHT - 60;
    [self.view addSubview:_leftBtn];
    
    
    //右边按钮
    _rightBtn = [[XYButton alloc] initWithFrame:CGRectMake(0, 0, 85, 85) backgroundColor:UIColorRed borderColor:UIColorBlack title:LWLocalizbleString(@"End") titleColor:UIColorWhite font:[NSObject BahnschriftFont:18] tapBlock:^(UIButton *btn) {
        //点击事件
        [weakSelf endBtnClick:YES];
    }];
    _rightBtn.right = SCREEN_WIDTH - SCREEN_WIDTH / 6;
    _rightBtn.bottom = SCREEN_HEIGHT - 60;
    [self.view addSubview:_rightBtn];
    
    
    //暂停按钮
    _pauseBtn = [[XYButton alloc] initWithFrame:CGRectMake(0, 0, 85, 85) backgroundColor:UIColorYellow borderColor:UIColorBlack title:LWLocalizbleString(@"Pause") titleColor:UIColorBlack font:[NSObject BahnschriftFont:18] tapBlock:^(UIButton *btn) {
        //点击事件
        [weakSelf pauseBtnClick:YES];
    }];
    _pauseBtn.centerX = self.view.centerX;
    _pauseBtn.bottom = SCREEN_HEIGHT - 60;
    _pauseBtn.alpha = 0 ;
    _pauseBtn.transform = CGAffineTransformMakeScale(0.3,0.3);
    [self.view addSubview:_pauseBtn];
    
    
    // 初始化按钮状态
    weakSelf.leftBtn.centerX = weakSelf.rightBtn.centerX = weakSelf.view.centerX;
    weakSelf.leftBtn.alpha = weakSelf.rightBtn.alpha = 0;
    weakSelf.pauseBtn.alpha = 1;
    weakSelf.pauseBtn.transform = CGAffineTransformIdentity;
    
    
    // 监听手表端状态变更
    [FBAtCommand.sharedInstance fbGPS_MotionWatchStatusChangeCallbackWithBlock:^(FBGPSMotionActionModel * _Nullable responseObject) {
        FBLog(@"【裂变】收到手表GPS互联实时运动状态变更%@", responseObject.mj_keyValues);
        GCD_MAIN_QUEUE(^{
            [weakSelf WatchMotionStateUpdateWithModel:responseObject];
        });
    }];
    
    
    self.tempModel = LWSportsConnectModel.new;
    self.tempModel.begin = NSDate.date.timeIntervalSince1970;
    self.tempModel.MotionState = self.model.MotionState;
    
    
    // 计时器
    [[dispatch_source_timer sharedInstance] initializeTiming:self.tempModel.realTime andStartBlock:^(NSInteger timeIndex) {
        GCD_MAIN_QUEUE(^{
            // 更新计时数
            weakSelf.tempModel.realTime = timeIndex;
                        
            // 每5秒处理一下结果
            if (timeIndex % 5 == 0) {
                
                weakSelf.tempModel.calorie += 1;
                int y = (arc4random() % 301) + 500;
                weakSelf.tempModel.avgPace = y;
                weakSelf.tempModel.distance += 10;
                
                [weakSelf MotionDataExchange]; // 与手表数据交流
            }

            // 更新数据模型
            [weakSelf.motionDataView reloadWithMotionModel:weakSelf.tempModel];
        });
    }];
    
    GCD_AFTER(1.0f, ^{

        [[dispatch_source_timer sharedInstance] StartTiming]; // 开始计时
    });
}

#pragma mark - 运动数据交流
- (void)MotionDataExchange {
    
    WeakSelf(self);
    
    FBMotionInterconnectionModel *gpsModel = FBMotionInterconnectionModel.new;
    /** 当前时间(UTC)｜Current time (UTC) */
    gpsModel.currentTimeUTC = NSDate.date.timeIntervalSince1970;

    /** 运动ID，用运动的开始时间作为每笔运动的唯一识别码｜Motion ID, using the start time of the motion as the unique identification code of each motion */
    gpsModel.motionID = self.tempModel.begin;

    /** 运动开始时间戳(UTC)｜Motion start timestamp (UTC) */
    gpsModel.startMotionUTC = self.tempModel.begin;

    /** 运动结束时间(UTC)，进行中的运动填0 ｜Motion end time (UTC), fill in 0 for ongoing exercise */
    gpsModel.endMotionUTC = 0;

    /** 当前运动总时间，单位秒｜Total current movement time, in seconds */
    gpsModel.totalTime = self.tempModel.realTime;

    /** 当前运动总卡路里（千卡）｜Total calories of current exercise (kcal) */
    gpsModel.totalCalories = self.tempModel.calorie;

    /** 当前本次运动轨迹运动距离（单位米，通过gps定位计算）｜Motion distance of current trajectory (unit: m, calculated by GPS positioning) */
    gpsModel.motionDistance = self.tempModel.distance;

    /** 运动模式｜Motion mode  */
    gpsModel.MotionMode = self.model.MotionMode;

    /** 本次运动最大步频（单位：步/分钟） ｜Maximum step frequency of this movement (unit: step / minute) */
//    gpsModel.maxStepFrequency

    /** 本次运动平均步频 =步数/时间（单位：步/分钟）｜Average step frequency of this exercise = steps / time (unit: steps / minute) */
    CGFloat avgStepFrequency = self.tempModel.steps / (self.tempModel.realTime/60.0);
    gpsModel.avgStepFrequency = floor(avgStepFrequency);

    /** 重复运动的周期数（来回次数，圈数）（单位：圈）｜Number of cycles of repeated motion (number of turns, turns) (unit: turns) */
//    gpsModel.cyclesNumber;

    /** 本次运动最大速度（单位：米/秒）｜Maximum speed of this movement (unit: M / s) */
//    gpsModel.maxSpeed;

    /** 本次运动平均速度 = 距离/用时（单位：米/秒）｜Average speed of this movement = distance / time (unit: M / s) */
//    gpsModel.avgSpeed;

    /** 本次有轨迹运动配速（单位：秒/公里）｜This time there is track movement pace (unit: S / km) */
    gpsModel.trackPace = self.tempModel.avgPace;
    
    [FBBgCommand.sharedInstance fbGPSMotionInterconnectionWithModel:gpsModel withBlock:^(FB_RET_CMD status, float progress, FBMotionInterconnectionModel * _Nonnull responseObject, NSError * _Nonnull error) {
        
        GCD_MAIN_QUEUE(^{
            if (error) {
                
                FBLog(@"GPS运动数据发送失败:%@", error.localizedDescription);
                
            } else if (status==FB_DATATRANSMISSIONDONE){
                
                weakSelf.tempModel.steps = responseObject.totalSteps;
                weakSelf.tempModel.heartRate = responseObject.currentHeartRate;
            }
        });
    }];
}


- (void)WatchMotionStateUpdateWithModel:(FBGPSMotionActionModel *)model {
    
    FB_GPS_MOTION_STATE responseState = model.MotionState;
    
    if (responseState == FB_SettingStartMotion) { // 开始运动
        FBLog(@"收到裂变GPS运动开始...");
    }
    if (responseState==FB_SettingKeepMotion) { // 继续运动
        FBLog(@"收到裂变GPS运动继续...");
        [self continueBtnClick:NO];
    }
    else if (responseState==FB_SettingPauseMotion) { // 暂停运动
        FBLog(@"收到裂变GPS运动暂停...");
        [self pauseBtnClick:NO];
    }
    else if (responseState==FB_SettingStopMotion) { // 结束运动
        FBLog(@"收到裂变GPS运动结束...");
        [[dispatch_source_timer sharedInstance] PauseTiming]; // 停止计时
        [self endBtnClick:NO];
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

#pragma mark ————— 继续按钮点击 —————
-(void)continueBtnClick:(BOOL)isAPPClick {
    WeakSelf(self);
    [UIView animateWithDuration:0.2 delay:0 usingSpringWithDamping:0.9 initialSpringVelocity:10 options:0 animations:^{
        weakSelf.leftBtn.centerX = weakSelf.rightBtn.centerX = weakSelf.view.centerX;
        weakSelf.leftBtn.alpha = weakSelf.rightBtn.alpha = 0;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3 animations:^{
            
            weakSelf.pauseBtn.alpha = 1;
            weakSelf.pauseBtn.transform = CGAffineTransformIdentity;
        }];
    }];
    
    [[dispatch_source_timer sharedInstance] StartTiming]; // 开始计时
        
    self.tempModel.MotionState = FB_SettingKeepMotion;
    [self.motionDataView reloadWithMotionModel:self.tempModel];
    
    if (isAPPClick) {
        [self SynchronizationMotionWithModel];
    }
}

#pragma mark ————— 暂停按钮点击 —————
-(void)pauseBtnClick:(BOOL)isAPPClick {
    WeakSelf(self);
    [UIView animateWithDuration:0.3 animations:^{
        weakSelf.pauseBtn.alpha = 0;
    } completion:^(BOOL finished) {
        weakSelf.pauseBtn.transform = CGAffineTransformMakeScale(0.3,0.3);
        [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.4 initialSpringVelocity:20 options:0 animations:^{
            weakSelf.leftBtn.alpha = weakSelf.rightBtn.alpha = 1;
            weakSelf.leftBtn.left = SCREEN_WIDTH / 6;
            weakSelf.rightBtn.right = SCREEN_WIDTH - SCREEN_WIDTH / 6;
        } completion:nil];
    }];
    
    [[dispatch_source_timer sharedInstance] PauseTiming]; // 暂停计时
    
    self.tempModel.MotionState = FB_SettingPauseMotion;
    [self.motionDataView reloadWithMotionModel:self.tempModel];
    
    if (isAPPClick) {
        [self SynchronizationMotionWithModel];
    }
}

#pragma mark ————— 结束按钮点击 —————
-(void)endBtnClick:(BOOL)isAPPClick {
    
    self.tempModel.MotionState = FB_SettingStopMotion;
    
    if (isAPPClick) {
        [self SynchronizationMotionWithModel];
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - 运动指令同步
- (void)SynchronizationMotionWithModel {
    
    FBGPSMotionActionModel *actionModel = FBGPSMotionActionModel.new;
    actionModel.MotionMode = self.model.MotionMode;
    actionModel.MotionState = self.tempModel.MotionState;
    actionModel.totalTime = self.tempModel.realTime;

    WeakSelf(self);
    [FBAtCommand.sharedInstance fbSynchronizationGPS_MotionWithModel:actionModel withBlock:^(NSError * _Nullable error) {
        if (error) {
            // error..
        } else {
            // success...
            if (actionModel.MotionState == FB_SettingStopMotion) {
                GCD_MAIN_QUEUE(^{
                    [weakSelf dismissViewControllerAnimated:YES completion:nil];
                });
            }
        }
    }];
}

@end
