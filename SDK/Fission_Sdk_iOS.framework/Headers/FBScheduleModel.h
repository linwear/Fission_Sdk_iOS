//
//  FBScheduleModel.h
//  FissionBluetooth
//
//  Created by 裂变智能 on 2024-03-02.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 日程信息｜Schedule information
*/
@interface FBScheduleModel : NSObject


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
 标题描述（长度小于等于12个字节，超出最大长度，自动截取）｜Title description (length is less than or equal to 12 bytes, exceeds the maximum length, automatically intercepted)
*/
@property (nonatomic, copy) NSString *titleDescribe;

/**
 地点描述（长度小于等于32个字节，超出最大长度，自动截取）｜Location description (length less than or equal to 32 bytes, exceeding the maximum length, automatically intercepted)
*/
@property (nonatomic, copy) NSString *locationDescribe;

/**
 内容描述（长度小于等于64个字节，超出最大长度，自动截取）｜Content description (length is less than or equal to 64 bytes, exceeds the maximum length, automatically intercepted)
*/
@property (nonatomic, copy) NSString *contentDescribe;


// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 


#pragma mark 当 FB_ALARMCATEGORY==FB_Reminders 时，为备忘提醒，以下值，必传｜When FB_ ALARMCATEGORY==FB_Reminders, for reminders, the following values must be passed
/**
 备忘提醒年月日小时分钟，时间戳（当闹铃类别为FB_Reminders:备忘提醒，必传；为FB_AlarmClock:定时闹钟可不传）｜Reminder year, month, day, hour, minute, timestamp (when the alarm category is FB_Reminders: reminder reminder, it must be sent; if it is FB_AlarmClock: scheduled alarm clock, it does not need to be sent)
*/
@property (nonatomic, assign) NSInteger remindersTime;

/**
 备忘提醒起始时间戳（当闹铃类别为FB_Reminders:备忘提醒，必传；为FB_AlarmClock:定时闹钟可不传）｜Memo reminder starting timestamp (when the alarm category is FB_Reminders: Memo reminder, it must be transmitted; when it is FB_AlarmClock: scheduled alarm clock, it does not need to be transmitted)
*/
@property (nonatomic, assign) NSInteger startTime;

/**
 备忘提醒结束时间戳（当闹铃类别为FB_Reminders:备忘提醒，必传；为FB_AlarmClock:定时闹钟可不传）｜Memo reminder end timestamp (when the alarm category is FB_Reminders: Memo reminder, it must be transmitted; when it is FB_AlarmClock: scheduled alarm clock, it does not need to be transmitted)
*/
@property (nonatomic, assign) NSInteger endTime;


// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


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
 闹钟提醒时间，一天的绝对分钟（大于等于0分钟，小于1440分钟，起始时间小于结束时间）（默认480，即08:00）（当闹铃类别为FB_AlarmClock:定时闹钟，必传；为FB_Reminders:备忘提醒可不传）｜Alarm reminder time, absolute minutes of the day (greater than or equal to 0 minutes, less than 1440 minutes, the start time is less than the end time) (default 480, which is 08:00) (when the alarm category is FB_AlarmClock: scheduled alarm clock, must be transmitted; for FB_Reminders :Memo reminder does not need to be sent)
*/
@property (nonatomic, assign) NSInteger clockTime;

@end

NS_ASSUME_NONNULL_END
