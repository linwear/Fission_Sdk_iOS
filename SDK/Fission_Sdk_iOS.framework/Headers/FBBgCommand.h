//
//  FBBgCommand.h
//  FissionBluetooth
//
//  Created by 裂变智能 on 2021/2/1.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 FB Bg命令集｜FB Bg command set
*/
@interface FBBgCommand : NSObject

/**
 初始化单个实例对象｜Initializes a single instance object
*/
+ (FBBgCommand *)sharedInstance;


#pragma mark - 获取设备硬件信息｜Get device hardware information
/**
 获取设备硬件信息｜Get device hardware information
 
 @note 该接口请求成功时，内部会自动更新 FBFirmwareVersionObject 本地缓存，更多信息请查看 FBAllConfigObject.firmwareConfig｜When the interface request is successful, the FBFirmwareVersionObject local cache will be automatically updated internally. For more information, see FBAllConfigObject.firmwareConfig
*/
- (void)fbGetHardwareInformationDataWithBlock:(FBGetHardwareInformationBlock _Nonnull)fbBlock;


#pragma mark - 获取当日实时测量数据｜Obtain the real-time measurement data of the day
/**
 获取当日实时测量数据｜Obtain the real-time measurement data of the day
*/
- (void)fbGetCurrentDayActivityDataWithBlock:(FBGetCurrentDayActivityDataBlock _Nonnull)fbBlock;


#pragma mark - 获取当前睡眠实时统计报告｜Get the current sleep real-time statistical report
/**
 获取当前睡眠实时统计报告｜Get the current sleep real-time statistical report
 
 @note 正在进行中的睡眠数据，待睡眠状态结束后，生成正式睡眠数据报告，请查看 fbGetSleepStateRecordingDataStartTime:forEndTime:withBlock:｜For the sleep data in progress, a formal sleep data report will be generated after the sleep state ends. Please check fbGetSleepStateRecordingDataStartTime:forEndTime:withBlock:
*/
- (void)fbGetCurrentSleepStatisticsReportDataWithBlock:(FBGetSleepStatisticsReportBlock _Nonnull)fbBlock;


#pragma mark - 获取当前睡眠实时状态记录｜Get the current sleep real-time status record
/**
 获取当前睡眠实时状态记录｜Get the current sleep real-time status record
 
 @note 正在进行中的睡眠数据，待睡眠状态结束后，生成正式睡眠数据报告，请查看 fbGetSleepStatisticsReportDataStartTime:forEndTime:withBlock:｜For the sleep data in progress, a formal sleep data report will be generated after the sleep state ends. Please check fbGetSleepStatisticsReportDataStartTime:forEndTime:withBlock:
*/
- (void)fbGetCurrentSleepStateRecordingDataWithBlock:(FBGetSleepStateRecordingBlock _Nonnull)fbBlock;


#pragma mark - 获取每日活动统计报告｜Get daily activity statistics report
/**
 获取每日活动统计报告｜Get daily activity statistics report
 @param startTime           开始时间，秒（时间戳）｜Start time, seconds (timestamp)
 @param endTime                结束时间，秒（时间戳）｜End time, seconds (timestamp)
*/
- (void)fbGetDailyActivityDataStartTime:(NSInteger)startTime forEndTime:(NSInteger)endTime withBlock:(FBGetDailyActivityDataBlock _Nonnull)fbBlock;


#pragma mark - 获取整点活动统计报告｜Get the statistical report of the whole point activity
/**
 获取整点活动统计报告｜Get the statistical report of the whole point activity
 @param startTime           开始时间，秒（时间戳）｜Start time, seconds (timestamp)
 @param endTime                结束时间，秒（时间戳）｜End time, seconds (timestamp)
*/
- (void)fbGetHourlyActivityDataStartTime:(NSInteger)startTime forEndTime:(NSInteger)endTime withBlock:(FBGetHourlyActivityDataBlock _Nonnull)fbBlock;


#pragma mark - 获取睡眠统计报告｜Get sleep statistics report
/**
 获取睡眠统计报告｜Get sleep statistics report
 @param startTime           开始时间，秒（时间戳）｜Start time, seconds (timestamp)
 @param endTime                结束时间，秒（时间戳）｜End time, seconds (timestamp)
*/
- (void)fbGetSleepStatisticsReportDataStartTime:(NSInteger)startTime forEndTime:(NSInteger)endTime withBlock:(FBGetSleepStatisticsReportBlock _Nonnull)fbBlock;


#pragma mark - 获取睡眠状态记录｜Get sleep status record
/**
 获取睡眠状态记录｜Get sleep status record
 @param startTime           开始时间，秒（时间戳）｜Start time, seconds (timestamp)
 @param endTime                结束时间，秒（时间戳）｜End time, seconds (timestamp)
*/
- (void)fbGetSleepStateRecordingDataStartTime:(NSInteger)startTime forEndTime:(NSInteger)endTime withBlock:(FBGetSleepStateRecordingBlock _Nonnull)fbBlock;


#pragma mark - 获取设备运动类型列表｜Get a list of device motion types
/**
 获取设备运动类型列表｜Get a list of device motion types
*/
- (void)fbGetListOfDeviceMotionTypesWithBlock:(FBGetMotionTypesListBlock _Nonnull)fbBlock;


#pragma mark - 获取运动记录列表｜Get a list of sports records
/**
 获取运动记录列表｜Get a list of sports records
 @param startTime           开始时间，秒（时间戳）｜Start time, seconds (timestamp)
 @param endTime                结束时间，秒（时间戳）｜End time, seconds (timestamp)
*/
- (void)fbGetMotionRecordListDataStartTime:(NSInteger)startTime forEndTime:(NSInteger)endTime withBlock:(FBGetMotionRecordListBlock _Nonnull)fbBlock;


#pragma mark - 获取运动统计报告｜Get sports statistics report
/**
 获取运动统计报告｜Get sports statistics report
 @param startTime           开始时间，秒（时间戳）｜Start time, seconds (timestamp)
 @param endTime                结束时间，秒（时间戳）｜End time, seconds (timestamp)
*/
- (void)fbGetSportsDataReportDataStartTime:(NSInteger)startTime forEndTime:(NSInteger)endTime withBlock:(FBGetSportsDataReportBlock _Nonnull)fbBlock;


#pragma mark - 获取心率记录｜Get heart rate records
/**
 获取心率记录｜Get heart rate records
 @param startTime           开始时间，秒（时间戳）｜Start time, seconds (timestamp)
 @param endTime                结束时间，秒（时间戳）｜End time, seconds (timestamp)
*/
- (void)fbGetHeartRateRecordDataStartTime:(NSInteger)startTime forEndTime:(NSInteger)endTime withBlock:(FBGetHeartRateRecordBlock _Nonnull)fbBlock;


#pragma mark - 获取计步记录｜Get step record
/**
 获取计步记录｜Get step record
 @param startTime           开始时间，秒（时间戳）｜Start time, seconds (timestamp)
 @param endTime                结束时间，秒（时间戳）｜End time, seconds (timestamp)
*/
- (void)fbGetStepCountRecordDataStartTime:(NSInteger)startTime forEndTime:(NSInteger)endTime withBlock:(FBGetStepCountRecordBlock _Nonnull)fbBlock;


#pragma mark - 获取血氧记录｜Blood oxygen records were obtained
/**
 获取血氧记录｜Blood oxygen records were obtained
 @param startTime           开始时间，秒（时间戳）｜Start time, seconds (timestamp)
 @param endTime                结束时间，秒（时间戳）｜End time, seconds (timestamp)
*/
- (void)fbGetBloodOxygenRecordDataStartTime:(NSInteger)startTime forEndTime:(NSInteger)endTime withBlock:(FBGetBloodOxygenRecordBlock _Nonnull)fbBlock;


#pragma mark - 获取血压记录｜Get blood pressure records
/**
 获取血压记录｜Get blood pressure records
 @param startTime           开始时间，秒（时间戳）｜Start time, seconds (timestamp)
 @param endTime                结束时间，秒（时间戳）｜End time, seconds (timestamp)
*/
- (void)fbGetBloodPressureRecordsDataStartTime:(NSInteger)startTime forEndTime:(NSInteger)endTime withBlock:(FBGetBloodPressureRecordsBlock _Nonnull)fbBlock;


#pragma mark - 获取运动详情记录｜Get sports details
/**
 获取运动详情记录｜Get sports details
 @param startTime           开始时间，秒（时间戳）｜Start time, seconds (timestamp)
 @param endTime                结束时间，秒（时间戳）｜End time, seconds (timestamp)
*/
- (void)fbGetExerciseDetailsDataStartTime:(NSInteger)startTime forEndTime:(NSInteger)endTime withBlock:(FBGetExerciseDetailsBlock _Nonnull)fbBlock;


#pragma mark - 获取 运动统计报告+运动详情纪录｜Get sports statistics report + sports details record
/**
 获取 运动统计报告+运动详情纪录｜Get sports statistics report + sports details record
 @param startTime           开始时间，秒（时间戳）｜Start time, seconds (timestamp)
 @param endTime                结束时间，秒（时间戳）｜End time, seconds (timestamp)
 
 @note 该方法内部实现实际是同时调用以上⬆️两条协议方法，调用此方法，可以得到匹配完整的运动详细报告｜The internal implementation of this method is actually calling the above two protocol methods at the same time. Calling this method can get a detailed sports report that matches and completes
*/
- (void)fbGetSportsStatisticsDetailsReportsWithStartTime:(NSInteger)startTime forEndTime:(NSInteger)endTime withBlock:(FBGetSportsStatisticsDetailsRecordBlock _Nonnull)fbBlock;


#pragma mark - 获取运动定位记录｜Get motion location record
/**
 获取运动定位记录｜Get motion location record
 @param startTime           开始时间，秒（时间戳）｜Start time, seconds (timestamp)
 @param endTime                结束时间，秒（时间戳）｜End time, seconds (timestamp)
*/
- (void)fbGetMotionLocationRecordDataStartTime:(NSInteger)startTime forEndTime:(NSInteger)endTime withBlock:(FBGetMotionLocationRecordBlock _Nonnull)fbBlock;


#pragma mark - 获取运动高频心率记录(1秒1次)｜Obtain exercise high-frequency heart rate records (1 time per second)
/**
 获取运动高频心率记录(1秒1次)｜Obtain exercise high-frequency heart rate records (1 time per second)
 @param startTime           开始时间，秒（时间戳）｜Start time, seconds (timestamp)
 @param endTime                结束时间，秒（时间戳）｜End time, seconds (timestamp)
*/
- (void)fbExerciseHighFrequencyHeartRateRecordsDataStartTime:(NSInteger)startTime forEndTime:(NSInteger)endTime withBlock:(FBGetExerciseHFHRRecordsBlock _Nonnull)fbBlock;


#pragma mark - 获取精神压力记录｜Get stress records
/**
 获取精神压力记录｜Get stress records
 @param startTime           开始时间，秒（时间戳）｜Start time, seconds (timestamp)
 @param endTime                结束时间，秒（时间戳）｜End time, seconds (timestamp)
*/
- (void)fbGetStressRecordsDataStartTime:(NSInteger)startTime forEndTime:(NSInteger)endTime withBlock:(FBGetStressRecordsBlock _Nonnull)fbBlock;


#pragma mark - 获取手动测量数据记录｜Obtain manual measurement data records
/**
 获取手动测量数据记录｜Obtain manual measurement data records
 @param startTime           开始时间，秒（时间戳）｜Start time, seconds (timestamp)
 @param endTime                结束时间，秒（时间戳）｜End time, seconds (timestamp)
*/
- (void)fbGetManualMeasurementDataStartTime:(NSInteger)startTime forEndTime:(NSInteger)endTime withBlock:(FBGetManualMeasureDataBlock _Nonnull)fbBlock;


#pragma mark - 获取指定记录和报告｜Get specific records and reports
/**
 获取指定记录和报告｜Get specific records and reports
 @param recordTypes             请求历史记录类型｜Request History Type
*/
- (void)fbGetSpecialRecordsAndReportsDataWithType:(NSArray <FBReqHistoryModel *> * _Nonnull)recordTypes withBlock:(FBGetSpecialRecordsAndReportsBlock _Nonnull)fbBlock;


#pragma mark - 获取个人用户信息｜Get personal user information
/**
 获取个人用户信息｜Get personal user information
*/
- (void)fbGetPersonalUserInforWithBlock:(FBGetPersonalUserInforBlock _Nonnull)fbBlock;


#pragma mark - 设置个人用户信息｜Setting personal user information
/**
 设置个人用户信息｜Setting personal user information
 @param userModel           个人用户信息｜Personal user information
*/
- (void)fbSetPersonalUserInforWithUserModel:(FBUserInforModel * _Nonnull)userModel withBlock:(FBResultCallBackBlock _Nonnull)fbBlock;


#pragma mark - 获取记事提醒/闹钟信息｜Get the reminders / alarm clock
/**
 获取记事提醒/闹钟信息｜Get the reminders / alarm clock
*/
- (void)fbGetClockInforWithBlock:(FBGetClockInforBlock _Nonnull)fbBlock;


#pragma mark - 设置记事提醒/闹钟信息｜Set reminders / alarm clock
/**
 设置记事提醒/闹钟信息｜Set  reminders / alarm clock
 @param clockModel              记事提醒/闹钟信息｜Reminders / alarm clock
 @param isRemoved                是否移除，YES:移除该记事提醒/闹铃信息，NO:添加或修改该记事提醒/闹铃信息｜Yes: remove the reminder / alarm information, No: add or modify the reminder / alarm information
*/
- (void)fbSetClockInforWithClockModel:(FBAlarmClockModel * _Nonnull)clockModel withRemoved:(BOOL)isRemoved withBlock:(FBResultCallBackBlock _Nonnull)fbBlock;


#pragma mark - 获取消息推送开关信息｜Get message push switch information
/**
 获取消息推送开关信息｜Get message push switch information
*/
- (void)fbGetMessagePushSwitchWithBlock:(FBGetMessagePushSwitchBlock _Nonnull)fbBlock;


#pragma mark - 设置消息推送开关信息｜Set message push switch information
/**
 设置消息推送开关信息｜Set message push switch information
 @param messageModel            消息推送开关信息｜Message push switch information
*/
- (void)fbSetMessagePushSwitchWithData:(FBMessageModel *)messageModel withBlock:(FBResultCallBackBlock _Nonnull)fbBlock;


#pragma mark - 获取久坐提醒信息｜Set message push switch information
/**
 获取久坐提醒信息｜Set message push switch information
*/
- (void)fbGetLongSitInforWithBlock:(FBGetLongSitInforBlock _Nonnull)fbBlock;


#pragma mark - 设置久坐提醒信息｜Set sedentary reminder information
/**
 设置久坐提醒信息｜Set sedentary reminder information
 @param longSitModel            久坐提醒信息｜Sedentary reminder
*/
- (void)fbSetLongSitInforWithModel:(FBLongSitModel * _Nonnull)longSitModel withBlock:(FBResultCallBackBlock _Nonnull)fbBlock;


#pragma mark - 获取心率等级判定信息｜Get heart rate level judgment information
/**
 获取心率等级判定信息｜Get heart rate level judgment information
*/
- (void)fbGetHeartRateInforWithBlock:(FBGetHeartRateInforBlock _Nonnull)fbBlock;


#pragma mark - 设置心率等级判定信息｜Set heart rate level judgment information
/**
 设置心率等级判定信息｜Set heart rate level judgment information
 @param heartAlgoModel          心率等级判定信息｜Heart rate level determination information
*/
- (void)fbSetHeartRateInforWithModel:(FBHeartRateRatingModel * _Nonnull)heartAlgoModel withBlock:(FBResultCallBackBlock _Nonnull)fbBlock;


#pragma mark - 获取喝水提醒信息｜Get water reminder information
/**
 获取喝水提醒信息｜Get water reminder information
*/
- (void)fbGetDrinkWaterWithBlock:(FBGetDrinkWaterBlock _Nonnull)fbBlock;


#pragma mark - 设置喝水提醒信息｜Set water drinking reminder information
/**
 设置喝水提醒信息｜Set water drinking reminder information
 @param drinkWaterModel             喝水提醒信息｜Water drinking reminder information
*/
- (void)fbSetDrinkWaterWithModel:(FBWaterClockModel * _Nonnull)drinkWaterModel withBlock:(FBResultCallBackBlock _Nonnull)fbBlock;


#pragma mark - 获取勿扰提醒信息｜Get do not disturb reminder information
/**
 获取勿扰提醒信息｜Get do not disturb reminder information
*/
- (void)fbGetNotDisturbWithBlock:(FBGetNotDisturbBlock _Nonnull)fbBlock;


#pragma mark - 设置勿扰提醒信息｜Set do not disturb reminder information
/**
 设置勿扰提醒信息｜Set do not disturb reminder information
 @param notDisturbModel             勿扰提醒信息｜Do not disturb reminder message
*/
- (void)fbSetNotDisturbWithModel:(FBNotDisturbModel * _Nonnull)notDisturbModel withBlock:(FBResultCallBackBlock _Nonnull)fbBlock;


#pragma mark - 获取心率检测信息｜Get heart rate detection information
/**
 获取心率检测信息｜Get heart rate detection information
*/
- (void)fbGetHeartTestPeriodsWithBlock:(FBGetHeartTestPeriodsBlock _Nonnull)fbBlock;


#pragma mark - 设置心率检测信息｜Set heart rate detection information
/**
 设置心率检测信息｜Set heart rate detection information
 @param hrCheckModel            心率检测信息｜Heart rate detection information
*/
- (void)fbSetHeartTestPeriodsWithModel:(FBHrCheckModel * _Nonnull)hrCheckModel withBlock:(FBResultCallBackBlock _Nonnull)fbBlock;


#pragma mark - 获取抬腕亮屏信息｜Get the bright screen information of wrist lifting
/**
 获取抬腕亮屏信息｜Get the bright screen information of wrist lifting
*/
- (void)fbGetWristTimeWithBlock:(FBGetWristTimeBlock _Nonnull)fbBlock;


#pragma mark - 设置抬腕亮屏信息｜Set the bright screen information of wrist lifting
/**
 设置抬腕亮屏信息｜Set the bright screen information of wrist lifting
 @param wristModel          抬腕亮屏信息｜Wrist lifting light screen information
*/
- (void)fbSetWristTimeWithModel:(FBWristModel * _Nonnull)wristModel withBlock:(FBResultCallBackBlock _Nonnull)fbBlock;


#pragma mark - 获取运动目标信息｜Get moving target information
/**
 获取运动目标信息｜Get moving target information
*/
- (void)fbGetSportsTagargetWithBlock:(FBGetSportsTagargetBlock _Nonnull)fbBlock;


#pragma mark - 设置运动目标信息｜Set moving target information
/**
 设置运动目标信息｜Set moving target information
 @param sportTargetModel            运动目标信息｜Moving target information
*/
- (void)fbSetSportsTagargetWithModel:(FBSportTargetModel * _Nonnull)sportTargetModel withBlock:(FBResultCallBackBlock _Nonnull)fbBlock;


#pragma mark - 设置今日天气详情｜Set today's weather details
/**
 设置今日天气详情｜Set today's weather details
 @param model           今日天气详情｜Weather details today
*/
- (void)fbPushTodayWeatherDetailsWithModel:(FBWeatherDetailsModel * _Nonnull)model withBlock:(FBResultCallBackBlock _Nonnull)fbBlock;


#pragma mark - 设置未来天气预报信息｜Set future weather forecast information
/**
 设置未来天气预报信息｜Set future weather forecast information
 @param weatherArray                                未来天气预报信息｜Future weather forecast information
*/
- (void)fbPushWeatherMessageWithModel:(NSArray <FBWeatherModel *> *)weatherArray withBlock:(FBResultCallBackBlock _Nonnull)fbBlock;


#pragma mark - App推送手机定位信息｜App push mobile location information
/**
 App推送手机定位信息｜App push mobile location information
 @param longitude           经度｜Longitude
 @param latitude             纬度｜Latitude
*/
- (void)fbPushMobileLocationInformationWithLongitude:(float)longitude withLatitude:(float)latitude withBlock:(FBResultCallBackBlock _Nonnull)fbBlock API_DEPRECATED("This API is deprecated", macos(2.0, 2.0), ios(2.0, 2.0), tvos(2.0, 2.0), watchos(2.0, 2.0));


#pragma mark - 获取女性生理周期信息｜Obtain female physiological cycle information
/**
 获取女性生理周期信息｜Obtain female physiological cycle information
*/
- (void)fbGetFemaleCircadianCycleWithBlock:(FBGetFemaleCircadianCycleBlock _Nonnull)fbBlock;


#pragma mark - 设置女性生理周期信息｜Set female physiological cycle information
/**
 设置女性生理周期信息｜Set female physiological cycle information
 @param physiologyModel             女性生理周期信息｜Female physiological cycle information
*/
- (void)fbSetFemaleCircadianCycleWithModel:(FBFemalePhysiologyModel * _Nonnull)physiologyModel withBlock:(FBResultCallBackBlock _Nonnull)fbBlock;


#pragma mark - 获取心率异常提醒信息｜Get abnormal heart rate reminder information
/**
 获取心率异常提醒信息｜Get abnormal heart rate reminder information
*/
- (void)fbGetAbnormalHeartRateReminderWithBlock:(FBGetAbnormalHeartRateReminderBlock _Nonnull)fbBlock;


#pragma mark - 设置心率异常提醒信息｜Set abnormal heart rate reminder information
/**
 设置心率异常提醒信息｜Set abnormal heart rate reminder information
 @param hrReminderModel             心率异常提醒信息｜Abnormal heart rate reminder information
*/
- (void)fbSetAbnormalHeartRateReminderWithModel:(FBHrReminderModel * _Nonnull)hrReminderModel withBlock:(FBResultCallBackBlock _Nonnull)fbBlock;


#pragma mark - 同步自定义表盘，表盘数据可用 FBCustomDataTools 工具生成｜Synchronize the custom dial, and the dial data can be generated by FBCustomDataTools
/**
 同步自定义表盘，表盘数据可用 FBCustomDataTools 工具生成｜Synchronize the custom dial, and the dial data can be generated by FBCustomDataTools
 @param fileData            自定义表盘bin文件｜Custom dial bin file
 
 @note 内部使用，建议使用FBBluetoothOTA类方法，传入对应OTA类型 FB_OTANotification_CustomClockDial 即可｜For internal use, it is recommended to use the FBBluetoothOTA class method and pass in the corresponding OTA type FB_OTANotification_CustomClockDial
 
 @see fbStartCheckingOTAWithBinFileData:withOTAType:withBlock:
*/
- (void)fbSynchronizeTheCustomDialData:(NSData * _Nonnull)fileData withBlock:(FBSetOtaUpgradeManagerBlock _Nonnull)fbBlock API_DEPRECATED("For internal use, it is recommended to use (FBBluetoothOTA) fbStartCheckingOTAWithBinFileData: withOTAType: withBlock: instead", macos(2.0, 2.0), ios(2.0, 2.0), tvos(2.0, 2.0), watchos(2.0, 2.0));


#pragma mark - 同步在线表盘，仅当 FBAllConfigObject.firmwareConfig.supportPrivatePushDial 为YES时使用｜Synchronous online dial, only when FBAllConfigObject.firmwareConfig.supportPrivatePushDial Use when yes
/**
 同步在线表盘，仅当 FBAllConfigObject.firmwareConfig.supportPrivatePushDial 为YES时使用｜Synchronous online dial, only when FBAllConfigObject.firmwareConfig.supportPrivatePushDial Use when yes
 @param fileData            在线表盘bin文件｜Online dial bin file
 
 @note 内部使用，建议使用FBBluetoothOTA类方法，传入对应OTA类型 FB_OTANotification_ClockDial 即可｜For internal use, it is recommended to use the FBBluetoothOTA class method and pass in the corresponding OTA type FB_OTANotification_ClockDial
 
 @see fbStartCheckingOTAWithBinFileData:withOTAType:withBlock:
*/
- (void)fbSynchronousOnlineDialData:(NSData * _Nonnull)fileData withBlock:(FBSetOtaUpgradeManagerBlock _Nonnull)fbBlock API_DEPRECATED("For internal use, it is recommended to use (FBBluetoothOTA) fbStartCheckingOTAWithBinFileData: withOTAType: withBlock: instead", macos(2.0, 2.0), ios(2.0, 2.0), tvos(2.0, 2.0), watchos(2.0, 2.0));


#pragma mark - 推送自定义运动类型，运动类型数据可用 FBCustomDataTools 工具生成｜Push custom motion category, and the motion category data can be generated by FBCustomDataTools
/**
 推送自定义运动类型，运动类型数据可用 FBCustomDataTools 工具生成｜Push custom motion category, and the motion category data can be generated by FBCustomDataTools
 @param fileData            自定义运动bin文件｜Custom motion bin file
 
 @note 内部使用，建议使用FBBluetoothOTA类方法，传入对应OTA类型 FB_OTANotification_Motion 即可｜For internal use, it is recommended to use the FBBluetoothOTA class method and pass in the corresponding OTA type FB_OTANotification_Motion
 
 @see fbStartCheckingOTAWithBinFileData:withOTAType:withBlock:
*/
- (void)fbPushCustomMotionCategoryData:(NSData * _Nonnull)fileData withBlock:(FBSetOtaUpgradeManagerBlock _Nonnull)fbBlock API_DEPRECATED("For internal use, it is recommended to use (FBBluetoothOTA) fbStartCheckingOTAWithBinFileData: withOTAType: withBlock: instead", macos(2.0, 2.0), ios(2.0, 2.0), tvos(2.0, 2.0), watchos(2.0, 2.0));


#pragma mark - 一次性推送多个自定义运动类型，运动类型数据可用 FBCustomDataTools 工具合并生成｜Push multiple custom motion types at one time, and the motion type data can be merged and generated by FBCustomDataTools
/**
 一次性推送多个自定义运动类型，运动类型数据可用 FBCustomDataTools 工具合并生成｜Push multiple custom motion types at one time, and the motion type data can be merged and generated by FBCustomDataTools
 @param fileData            自定义运动bin文件｜Custom motion bin file
 @param OTAType              OTA类型，支持 FB_OTANotification_Multi_Sport 或 FB_OTANotification_Multi_Sport_Built_in｜OTA type, support FB_OTANotification_Multi_Sport or FB_OTANotification_Multi_Sport_Built_in
 
 @note 内部使用，建议使用FBBluetoothOTA类方法，传入对应OTA类型 FB_OTANotification_Multi_Sport 即可｜For internal use, it is recommended to use the FBBluetoothOTA class method and pass in the corresponding OTA type FB_OTANotification_Multi_Sport
 
 @see fbStartCheckingOTAWithBinFileData:withOTAType:withBlock:
*/
- (void)fbPushCustomMultipleMotionCategoryData:(NSData * _Nonnull)fileData withOTAType:(FB_OTANOTIFICATION)OTAType withBlock:(FBSetOtaUpgradeManagerBlock _Nonnull)fbBlock API_DEPRECATED("For internal use, it is recommended to use (FBBluetoothOTA) fbStartCheckingOTAWithBinFileData: withOTAType: withBlock: instead", macos(2.0, 2.0), ios(2.0, 2.0), tvos(2.0, 2.0), watchos(2.0, 2.0));


#pragma mark - GPS运动互联数据交互｜GPS motion interconnection data interaction
/**
 GPS运动互联数据交互｜GPS motion interconnection data interaction
 @param model           GPS运动互联交流信息｜GPS sports interconnection exchange information
*/
- (void)fbGPSMotionInterconnectionWithModel:(FBMotionInterconnectionModel * _Nonnull)model withBlock:(FBMotionInterconnectionBlock _Nonnull)fbBlock;


#pragma mark - 获取联系人信息｜Get contact information
/**
 获取联系人信息｜Get contact information
 @param type                联系人类型｜Contact type
*/
- (void)fbGetContactListWithType:(FB_CONTACTTYPE)type withBlock:(FBGetContactListBlock _Nonnull)fbBlock;


#pragma mark - 设置联系人信息｜Set up contact information
/**
 设置联系人信息｜Set up contact information
 @param type                联系人类型｜Contact type
 @param modelList           联系人信息｜Frequently used contact information
*/
- (void)fbSetContactListWithType:(FB_CONTACTTYPE)type withList:(NSArray <FBContactModel *> *)modelList withBlock:(FBResultCallBackBlock _Nonnull)fbBlock;


#pragma mark - 读取片外 flash 空间数据｜Read off-chip flash space data
/**
 读取片外 flash 空间数据｜Read off-chip flash space data
 @param hardfault           YES:读取Hardfault参数信息，NO:读取系统参数信息｜YES: read Hardfault parameter information, NO: read system parameter information
 
 @note 该方法用于获取设备意外重启信息，供固件分析问题｜This method is used to obtain the unexpected restart information of the device for the firmware to analyze the problem
*/
- (void)fbReadOffChipFlashWithHardfault:(BOOL)hardfault withBlock:(FBRequestDeviceLogsPathBlock _Nonnull)fbBlock;


#pragma mark - 请求获取设备日志（埋点数据，读取 OTA 缓存数据，总共 60K）｜Request device logs (Buried point data, read OTA cache data, a total of 60K)
/**
 请求获取设备日志（埋点数据，读取 OTA 缓存数据，总共 60K）｜Request device logs (Buried point data, read OTA cache data, a total of 60K)
*/
- (void)fbRequestDeviceLogsWithBlock:(FBRequestDeviceLogsPathBlock _Nonnull)fbBlock;


#pragma mark - 读取指定路径下的某个文件数据｜Read data from a file in the specified path
/**
 读取指定路径下的某个文件数据｜Read data from a file in the specified path
 @param paths                指定的文件路径数组｜TArray of specified file paths
*/
- (void)fbReadDataFileWithPaths:(NSArray <NSString *> * _Nonnull)paths withBlock:(FBRequestDeviceLogsPathArrayBlock _Nonnull)fbBlock;


#pragma mark - 获取系统功能开关信息｜Get system function switch information
/**
 获取系统功能开关信息｜Get system function switch information
*/
- (void)fbGetSystemFunctionSwitchInformationWithBlock:(FBRequestSystemFunctionSwitchInfoBlock _Nonnull)fbBlock;


#pragma mark - 设置系统功能开关信息｜Set system function switch information
/**
 设置系统功能开关信息｜Set system function switch information
 @param switchModel           系统功能开关信息｜System function switch information
*/
- (void)fbSetSystemFunctionSwitchInformation:(FBSystemFunctionSwitchModel * _Nonnull)switchModel withBlock:(FBResultCallBackBlock _Nonnull)fbBlock;


#pragma mark - 推送AGPS位置基础信息(经纬度UTC)｜Push basic information of AGPS location (latitude and longitude UTC)
/**
 推送AGPS位置基础信息(经纬度UTC)｜Push basic information of AGPS location (latitude and longitude UTC)
 @param locationModel           AGPS位置信息｜ AGPS location information
*/
- (void)fbPushAGPSLocationInformation:(FBAGPSLocationModel * _Nonnull)locationModel withBlock:(FBResultCallBackBlock _Nonnull)fbBlock;


#pragma mark - 同步AGPS星历数据，星历数据可用 FBCustomDataTools 工具合并生成｜Synchronize AGPS ephemeris data, ephemeris data can be merged and generated using the FBCustomDataTools tool
/**
 同步AGPS星历数据，星历数据可用 FBCustomDataTools 工具合并生成｜Synchronize AGPS ephemeris data, ephemeris data can be merged and generated using the FBCustomDataTools tool
 @param fileData            AGPS星历数据bin文件｜AGPS ephemeris data bin file
 
 @note 内部使用，建议使用FBBluetoothOTA类方法，传入对应OTA类型 FB_OTANotification_AGPS_Ephemeris 即可｜For internal use, it is recommended to use the FBBluetoothOTA class method and pass in the corresponding OTA type FB_OTANotification_AGPS_Ephemeris
 
 @see fbStartCheckingOTAWithBinFileData:withOTAType:withBlock:
*/
- (void)fbSynchronizeAGPSEphemerisData:(NSData * _Nonnull)fileData withBlock:(FBSetOtaUpgradeManagerBlock _Nonnull)fbBlock API_DEPRECATED("For internal use, it is recommended to use (FBBluetoothOTA) fbStartCheckingOTAWithBinFileData: withOTAType: withBlock: instead", macos(2.0, 2.0), ios(2.0, 2.0), tvos(2.0, 2.0), watchos(2.0, 2.0));


#pragma mark - 分包压缩发送文件到设备｜Subpackage and compress files to send to device
/**
 分包压缩发送文件到设备｜Subpackage and compress files to send to device
 @param fileData            将要分包压缩的文件｜Files to be subpackaged and compressed
 @param otaType              OTA类型｜OTA type
 
 @note 内部使用，建议使用FBBluetoothOTA类方法，传入将要分包压缩的文件数据类型对应OTA类型即可｜For internal use, it is recommended to use the FBBluetoothOTA class method and pass in the file data type to be subpackaged and compressed corresponding to the OTA type
 
 @see fbStartCheckingOTAWithBinFileData:withOTAType:withBlock:
*/
- (void)fbSynchronousSubpackageCompressData:(NSData * _Nonnull)fileData withOtaType:(FB_OTANOTIFICATION)otaType withBlock:(FBSetOtaUpgradeManagerBlock _Nonnull)fbBlock API_DEPRECATED("For internal use, it is recommended to use (FBBluetoothOTA) fbStartCheckingOTAWithBinFileData: withOTAType: withBlock: instead", macos(2.0, 2.0), ios(2.0, 2.0), tvos(2.0, 2.0), watchos(2.0, 2.0));


#pragma mark - 获取日程信息｜Get schedule information
/**
 获取日程信息｜Get schedule information
*/
- (void)fbGetScheduleInforWithBlock:(FBGetScheduleInforBlock _Nonnull)fbBlock;


#pragma mark - 设置日程信息｜Set schedule information
/**
 设置日程信息｜Set schedule information
 @param scheduleModel               日程信息｜Schedule information
 @param isRemoved                   是否移除，YES:移除日程信息，NO:添加或修改该日程信息｜YES: remove schedule information, NO: add or modify the schedule information
*/
- (void)fbSetSchedulenforWithScheduleModel:(FBScheduleModel * _Nonnull)scheduleModel withRemoved:(BOOL)isRemoved withBlock:(FBResultCallBackBlock _Nonnull)fbBlock;


#pragma mark - 获取系统空间使用信息｜Get system space usage information
/**
 获取系统空间使用信息｜Get system space usage information
*/
- (void)fbGetSystemSpaceUsageInfoWithBlock:(FBGetSystemSpaceInfoBlock _Nonnull)fbBlock;


#pragma mark - 获取列表文件信息｜Get list file information
/**
 获取列表文件信息｜Get list file information
 @param type                        列表文件类型｜List file types
*/
- (void)fbGetListFileInfoWithType:(FB_LISTFILEINFORTYPE)type withBlock:(FBGetListFileInfoBlock _Nonnull)fbBlock;


#pragma mark - 删除列表文件信息｜Delete list file information
/**
 删除列表文件信息｜Delete list file information
 @param type                        列表文件类型｜List file types
 @param modelList                   列表文件信息｜List file information
*/
- (void)fbDeleteListFileInfoWithType:(FB_LISTFILEINFORTYPE)type withList:(NSArray <FBListFileInfoModel *> * _Nonnull)modelList withBlock:(FBResultCallBackBlock _Nonnull)fbBlock;


#pragma mark - 获取当前使用的铃声信息｜Get the currently used ringtone information
/**
 获取当前使用的铃声信息｜Get the currently used ringtone information
*/
- (void)fbGetCurrentRingtoneInfoWithBlock:(FBGetRingtoneInfoBlock _Nonnull)fbBlock;


#pragma mark - 设置当前使用的铃声信息｜Set the currently used ringtone information
/**
 设置当前使用的铃声信息｜Set the currently used ringtone information
 @param modelList                   铃声信息｜Ringtone information
*/
- (void)fbSetCurrentRingtoneInfoWithList:(NSArray <FBRingtoneInfoModel *> * _Nonnull)modelList withBlock:(FBResultCallBackBlock _Nonnull)fbBlock;


#pragma mark - 设置设备授权码｜Set device authorization code
/**
 设置设备授权码｜Set device authorization code
 @param modelList                   设备授权码｜Device authorization code
*/
- (void)fbSetDeviceAuthCodeWithList:(NSArray <FBDeviceAuthCodeModel *> * _Nonnull)modelList withBlock:(FBResultCallBackBlock _Nonnull)fbBlock;

@end

NS_ASSUME_NONNULL_END
