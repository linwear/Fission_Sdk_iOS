//
//  FBHrReminderModel.h
//  FissionBluetooth
//
//  Created by 裂变智能 on 2021/8/5.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 心率异常提醒信息｜Abnormal heart rate reminder information
*/
@interface FBHrReminderModel : NSObject

/**
 心率异常提醒开关 NO:关闭 YES:打开｜Abnormal heart rate reminder switch No: off yes: on
*/
@property (nonatomic, assign) BOOL enable;

/**
 心率提醒上限，心率超高提醒｜Heart rate reminder upper limit, heart rate ultra-high reminder
*/
@property (nonatomic, assign) NSInteger highReminder;

/**
 心率提醒下限，心率过低提醒｜Low heart rate reminder
*/
@property (nonatomic, assign) NSInteger lowReminder;

/**
 心率值连续超标次数（达到超标的次数时才会提醒）｜The number of times the heart rate value exceeds the standard continuously (it will be reminded only when the number exceeds the standard)
*/
@property (nonatomic, assign) NSInteger exceedanceTimes;

/**
 检测起始时间，一天的绝对分钟（大于等于0分钟，小于1440分钟，起始时间小于结束时间）｜Detection start time, absolute minutes of a day (greater than or equal to 0 minutes, less than 1440 minutes, start time less than end time)
*/
@property (nonatomic, assign) NSInteger startTime;

/**
 检测结束时间，一天的绝对分钟（大于等于0分钟，小于1440分钟，结束时间大于起始时间）｜Detection end time, absolute minutes of a day (greater than or equal to 0 minutes, less than 1440 minutes, end time greater than start time)
*/
@property (nonatomic, assign) NSInteger endTime;

@end

NS_ASSUME_NONNULL_END
