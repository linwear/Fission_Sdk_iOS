//
//  ClockInforViewController.h
//  FissionBluetooth
//
//  Created by 裂变智能 on 2021/1/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ClockInforViewController : LWBaseViewController

/// 日程
@property (nonatomic, assign) BOOL isSchedule;

@property (nonatomic, retain) FBAlarmClockModel *alarmClockModel; // 闹钟

@property (nonatomic, retain) FBScheduleModel *scheduleModel; // 日程

@end

NS_ASSUME_NONNULL_END
