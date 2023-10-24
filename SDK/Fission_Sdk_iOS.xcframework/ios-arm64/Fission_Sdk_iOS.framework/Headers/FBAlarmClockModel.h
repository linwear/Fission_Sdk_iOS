//
//  FBAlarmClockModel.h
//  FissionBluetooth
//
//  Created by 裂变智能 on 2021/2/18.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 记事提醒/闹钟信息｜Reminder / alarm clock
*/
@interface FBAlarmClockModel : NSObject


#pragma mark 以下值，通用，必传｜The following values, general, must be passed
/**
 序号ID（0，1，2，3 ...）｜Sequence ID (0, 1, 2, 3...)
*/
@property (nonatomic, assign) NSInteger clockID;

/**
 闹铃类别: 备忘提醒（年月日小时分钟有效），定时闹钟（仅小时分钟有效）｜Alarm category: reminder（valid for hours and minutes）, Time alarm clock（only hours and minutes）
*/
@property (nonatomic, assign) FB_ALARMCATEGORY clockCategory;

/**
 使能开关 NO:关 YES:开（默认YES）｜Enable switch NO: off YES: on (default YES)
*/
@property (nonatomic, assign) BOOL clockEnableSwitch;

/**
 稍后提醒开关 NO:关 YES:开（默认NO）｜Remind switch later NO: OFF YES: ON (default NO)
*/
@property (nonatomic, assign) BOOL remindLater;

/**
 描述、备注（长度小于等于23个字节，超出最大长度，自动截取）｜Description, remarks (length is less than or equal to 23 bytes, if the maximum length is exceeded, it will be automatically intercepted)
*/
@property (nonatomic, copy) NSString *clockDescribe;


#pragma mark 当 FB_ALARMCATEGORY==FB_Reminders 时，为备忘提醒，以下值，必传｜When FB_ ALARMCATEGORY==FB_Reminders, for reminders, the following values must be passed
/**
 年月日小时分钟，格式：YYYY-MM-dd HH:mm（当闹铃类别为FB_Reminders:备忘提醒，必传；为FB_AlarmClock:定时闹钟可不传）｜Month, year, day, hour and minute, format: YYYY-MM-dd HH:mm (When the alarm type is FB_Reminders: reminder, it must be sent; when it is FB_AlarmClock: fixed time alarm, it can not be sent)
*/
@property (nonatomic, copy) NSString *clockYMDHm;


#pragma mark 当 FB_ALARMCATEGORY==FB_AlarmClock 时，为定时闹钟，以下值，必传｜When FB_ ALARMCATEGORY==FB_AlarmClock, for alarm clock, the following values must be passed
/**
 重复性，YES:周期有效，NO:一次有效｜Repeatability, YES: cycle effective, NO: once effective
*/
@property (nonatomic, assign) BOOL isRepeat;

/**
 星期选中标记（星期日、星期一、星期二、星期三、星期四、星期五、星期六；必须设置固定七个数据的数组，传0「未选中」或1「选中」）｜Week check mark (Sunday, Monday, Tuesday, Wednesday, Thursday, Friday, Saturday; fixed array of seven data must be set, transfer 0 (unselected) or 1 (selected))
*/
@property (nonatomic, strong) NSArray <NSNumber *> *clockRepeatArray;

/**
 小时分钟，格式：HH:mm（当闹铃类别为FB_AlarmClock:定时闹钟，必传；为FB_Reminders:备忘提醒可不传）｜Hours and minutes, format: HH: mm (When the alarm type is FB_AlarmClock: timed alarm, it must be sent; when it is FB_Reminders: reminder, it can not be sent)
*/
@property (nonatomic, copy) NSString *clockHm;

@end

NS_ASSUME_NONNULL_END
