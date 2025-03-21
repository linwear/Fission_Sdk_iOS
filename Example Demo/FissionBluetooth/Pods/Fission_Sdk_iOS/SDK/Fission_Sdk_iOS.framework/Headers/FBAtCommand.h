//
//  FBAtCommand.h
//  FissionBluetooth
//
//  Created by 裂变智能 on 2021/1/28.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 FB At命令集｜FB At command set
*/
@interface FBAtCommand : NSObject

/** 初始化单个实例对象｜Initializes a single instance object */
+ (FBAtCommand *)sharedInstance;


#pragma mark - 获取设备电量信息｜Get device power information
/**
 获取设备电量信息｜Get device power information
*/
- (void)fbReqBatteryStatusDataWithBlock:(FBReqBatteryStatusBlock _Nonnull)fbBlock;


#pragma mark - 获取设备版本信息｜Get device version information
/**
 获取设备版本信息｜Get device version information
*/
- (void)fbReqDeviceVersionDataWithBlock:(FBReqDeviceVersionBlock _Nonnull)fbBlock;


#pragma mark - 获取协议版本信息｜Get agreement version information
/**
 获取协议版本信息｜Get agreement version information
*/
- (void)fbReqProtocolVersionDataWithBlock:(FBReqProtocolVersionBlock _Nonnull)fbBlock;


#pragma mark - 获取设备MTU值｜Get the device MTU value
/**
 获取设备MTU值｜Get the device MTU value
 */
- (void)fbGetConnectionMTUWithBlock:(FBGet_AT_ResultCallBackBlock _Nonnull)fbBlock;


#pragma mark - 回复设备MTU值｜Reply device MTU value
/**
 回复设备MTU值｜Reply device MTU value
 */
- (void)fbReqConnectionMTUData:(NSInteger)MTU withBlock:(FBResultCallBackBlock _Nonnull)fbBlock;


#pragma mark - 设置当前系统类型｜Set the current system type
/**
 设置当前系统类型｜Set the current system type
*/
- (void)fbUpSystemIdentificationWithBlock:(FBResultCallBackBlock _Nonnull)fbBlock;


#pragma mark - 获取UTC时间｜Get UTC time
/**
 获取UTC时间｜Get UTC time
*/
- (void)fbReqUTCTimeDataWithBlock:(FBGet_AT_ResultCallBackBlock _Nonnull)fbBlock;


#pragma mark - 获取时区｜Get time zone
/**
 获取时区｜Get time zone
*/
- (void)fbReqTimezoneDataWithBlock:(FBGet_AT_ResultCallBackBlock _Nonnull)fbBlock;


#pragma mark - 同步UTC时间｜Synchronize UTC Time
/**
 同步UTC时间｜Synchronize UTC Time
*/
- (void)fbSynchronizeUTCTimeWithBlock:(FBResultCallBackBlock _Nonnull)fbBlock API_DEPRECATED("It is recommended to use fbAutomaticallySynchronizeSystemTimeWithBlock: instead", macos(2.0, 2.0), ios(2.0, 2.0), tvos(2.0, 2.0), watchos(2.0, 2.0));


#pragma mark - 设置时区｜Set Time Zone
/**
 设置时区｜Set Time Zone
 @param timeZoneMinute          时区偏移时间（单位分钟）｜Time zone offset time (unit: minute)
*/
- (void)fbUpTimezoneMinuteData:(NSInteger)timeZoneMinute withBlock:(FBResultCallBackBlock _Nonnull)fbBlock API_DEPRECATED("It is recommended to use fbAutomaticallySynchronizeSystemTimeWithBlock: instead", macos(2.0, 2.0), ios(2.0, 2.0), tvos(2.0, 2.0), watchos(2.0, 2.0));


#pragma mark - 自动同步系统时间（同步UTC时间 + 设置时区）｜Automatically synchronize system time (Synchronize UTC Time + Set Time Zone)
/**
 自动同步系统时间（同步UTC时间 + 设置时区）｜Automatically synchronize system time (Synchronize UTC Time + Set Time Zone)
 
 @note 该方法内部实现实际是同时调用以上⬆️两条协议方法，调用此方法，无需再单独调用【同步UTC时间】【设置时区】协议方法｜The internal implementation of this method is actually to call the above two protocol methods at the same time. To call this method, there is no need to call the [Synchronize UTC Time] [Set Time Zone] protocol method separately
 */
- (void)fbAutomaticallySynchronizeSystemTimeWithBlock:(FBResultCallBackBlock _Nonnull)fbBlock;


#pragma mark - 设置时间显示模式｜Set time display mode
/**
 设置时间显示模式｜Set time display mode
 @param hoursMode           时间显示模式｜time display mode
*/
- (void)fbUpTimeModeData:(FB_TIMEDISPLAYMODE)hoursMode withBlock:(FBResultCallBackBlock _Nonnull)fbBlock;


#pragma mark - 设置语言｜Set language
/**
 设置语言｜Set language
 @param language            语种｜language
*/
- (void)fbUpLanguageData:(FB_LANGUAGES)language withBlock:(FBResultCallBackBlock _Nonnull)fbBlock;


#pragma mark - 设置距离单位（公英制）｜Set distance units (metric British system)
/**
 设置距离单位（公英制）｜Set distance units (metric British system)
 @param units           距离单位｜Distance units
*/
- (void)fbUpDistanceUnitData:(FB_DISTANCEUNIT)units withBlock:(FBResultCallBackBlock _Nonnull)fbBlock;


#pragma mark - 设置震动提醒开关｜Set vibration alert switch
/**
 设置震动提醒开关｜Set vibration alert switch
 @param switchMode          NO:关 YES:开 ｜NO: off    YES: on
*/
- (void)fbUpShakeAlterSwitchData:(BOOL)switchMode withBlock:(FBResultCallBackBlock _Nonnull)fbBlock;


#pragma mark - 设置抬腕亮屏开关｜Set the wrist lifting light screen switch
/**
 设置抬腕亮屏开关｜Set the wrist lifting light screen switch
 @param switchMode          NO:关 YES:开 ｜NO: off    YES: on
*/
- (void)fbUpWristSwitchData:(BOOL)switchMode withBlock:(FBResultCallBackBlock _Nonnull)fbBlock;


#pragma mark - 进入/退出拍照模式｜Enter / exit take a photo mode
/**
 进入/退出拍照模式｜Enter / exit take a photo mode
 @param switchMode          NO:退出 YES:进入 ｜NO: Exit   YES: Enter
*/
- (void)fbUpTakePhotoStatusData:(BOOL)switchMode withBlock:(FBResultCallBackBlock _Nonnull)fbBlock;


#pragma mark - 开启和关闭数据流指令｜Open and close the data flow instruction
/**
 开启和关闭数据流指令｜Open and close the data flow instruction
 @param second          数据返回时间间隔（单位秒） 0表示关闭 ｜Data return time interval (in seconds) 0 means off
 @see   fbStreamDataHandlerWithBlock:
*/
- (void)fbUpDataStreamData:(NSInteger)second withBlock:(FBResultCallBackBlock _Nonnull)fbBlock;


#pragma mark - 开启数据流指令后，接收流数据方法｜Method of receiving stream data after starting stream instruction
/**
 开启数据流指令后，接收流数据方法｜Method of receiving stream data after starting stream instruction
*/
- (void)fbStreamDataHandlerWithBlock:(FBStreamDataHandlerBlock _Nonnull)fbBlock;


#pragma mark - 心率模式开关｜Heart rate mode switch
/**
 心率模式开关｜Heart rate mode switch
 @param switchMode          NO:关 YES:开 ｜NO: off    YES: on
*/
- (void)fbUpHeartRateData:(BOOL)switchMode withBlock:(FBResultCallBackBlock _Nonnull)fbBlock;


#pragma mark - 低速连接/高速连接
/**
 低速连接/高速连接｜Low speed connection / high speed connection
 @param switchMode          NO:低速 YES:高速 ｜NO: low speed      YES: high speed
 
 @note 切换高低速时，返回值为1表示当前为高速连接，为0则为低速连接｜ (when switching between high and low speeds, a return value of 1 indicates that the current connection is high speed, and a return value of 0 indicates that the connection is low speed.)
*/
- (void)fbUpHighAndLowSpeedConnectionWithSwitchMode:(BOOL)switchMode withBlock:(FBGet_AT_ResultCallBackBlock _Nonnull)fbBlock;


#pragma mark - 监听设备->手机即时拍照回调｜Monitoring device - > instant camera callback of mobile phone
/**
 监听设备->手机即时拍照回调｜Monitoring device - > instant camera callback of mobile phone
 
 @note 当在设备上点击拍照，会通过此回调通知｜When a photo is clicked on the device, it will be notified through this callback
*/
- (void)fbUpTakePhotoClickDataWithBlock:(FBUpTakePhotoClickBlock _Nonnull)fbBlock;


#pragma mark - 手机查找设备｜Mobile find device
/**
 手机查找设备｜Mobile find device
*/
- (void)fbUpFindDeviceDataWithBlock:(FBResultCallBackBlock _Nonnull)fbBlock;


#pragma mark - 设备确认被找到｜The device is confirmed to be found
/**
 设备确认被找到｜The device is confirmed to be found
 
 @note 当手机查找到设备，在设备上点击确认时，会通过此回调通知｜When the mobile phone finds the device and clicks confirmation on the device, it will be notified through this callback
*/
- (void)fbUpDeviceConfirmedFoundDataWithBlock:(FBDeviceConfirmationFoundBlock _Nonnull)fbBlock;


#pragma mark - 手机确认被找到｜The mobile phone is confirmed to be found
/**
 手机确认被找到｜The mobile phone is confirmed to be found
 
 @note 当设备成功查找到手机时，APP调用该方法可停止设备查找手机｜When the device successfully finds the mobile phone, the APP calls this method to stop the device from searching for the mobile phone
*/
- (void)fbUpPhoneConfirmedFoundDataWithBlock:(FBResultCallBackBlock _Nonnull)fbBlock;


#pragma mark - 监听设备->查找手机回调｜Monitor device - > find mobile callback
/**
 监听设备->查找手机回调｜Monitor device - > find mobile callback
 
 @note 当在设备上点击查找手机，会通过此回调通知｜When you click to find a mobile phone on the device, you will be notified through this callback
*/
- (void)fbUpFindPhoneDataWithBlock:(FBUpFindPhoneBlock _Nonnull)fbBlock;


#pragma mark - 监听设备->放弃查找手机回调｜Monitor device - > give up looking for mobile phone callback
/**
 监听设备->放弃查找手机回调｜Monitor device - > give up looking for mobile phone callback
 
 @note 当在设备上取消/放弃查找手机，会通过此回调通知｜When the phone is canceled/abandoned on the device, it will be notified through this callback
*/
- (void)fbAbandonFindingPhoneWithBlock:(FBAbandonFindingPhoneBlock _Nonnull)fbBlock;


#pragma mark - 监听设备->手机配对成功iOS回调｜Monitoring device - > successful phone pairing IOS callback
/**
 监听设备->手机配对成功iOS回调｜Monitoring device - > successful phone pairing IOS callback
 
 @note 当在设备与手机系统成功配对，会通过此回调通知｜When the device is successfully paired with the mobile phone system, it will be notified through this callback
*/
- (void)fbUpPairingCompleteDataWithBlock:(FBUpPairingCompleteBlock _Nonnull)fbBlock;


#pragma mark - 重启设备｜Reboot device
/**
 重启设备｜Reboot device
*/
- (void)fbUpRebootDeviceDataWithBlock:(FBResultCallBackBlock _Nonnull)fbBlock;


#pragma mark - 恢复出厂设置｜Restore factory settings
/**
 恢复出厂设置｜Restore factory settings
 @param shutdown          恢复出厂设置后是否关机，NO开机，YES关机｜Whether to shut down after restoring factory settings, NO to turn on, YES to shut down
*/
- (void)fbUpResetDeviceDataWithShutdown:(BOOL)shutdown withBlock:(FBResultCallBackBlock _Nonnull)fbBlock;


#pragma mark - 软关机｜Soft-off
/**
 软关机｜Soft-off
*/
- (void)fbUpSoftDownDataWithBlock:(FBResultCallBackBlock _Nonnull)fbBlock;


#pragma mark - 启动OTA升级｜Start OTA upgrade
/**
 启动OTA升级｜Start OTA upgrade
*/
- (void)fbUpOpenOTADataWithBlock:(FBResultCallBackBlock _Nonnull)fbBlock;


#pragma mark - 安全确认｜Safety confirmation
/**
 安全确认｜Safety confirmation
*/
- (void)fbUpSafetyConfirmDataWithBlock:(FBResultCallBackBlock _Nonnull)fbBlock;


#pragma mark - 退出自检模式/启动自检模式｜Exit self test mode / start self test mode
/**
 退出自检模式/启动自检模式｜Exit self test mode / start self test mode
 @param switchMode          NO:退出 YES:启动 ｜NO: Exit YES: Start
*/
- (void)fbUpSelfTestData:(BOOL)switchMode withBlock:(FBResultCallBackBlock _Nonnull)fbBlock;


#pragma mark - 清除用户信息｜Clear user information
/**
 清除用户信息｜Clear user information
*/
- (void)fbUpClearUserInfoDataWithBlock:(FBResultCallBackBlock _Nonnull)fbBlock;


#pragma mark - 清除运动数据｜Clear motion data
/**
 清除运动数据｜Clear motion data
*/
- (void)fbUpClearSportDataWithBlock:(FBResultCallBackBlock _Nonnull)fbBlock;


#pragma mark - 设置设备主动断开连接｜Setting device active disconnect
/**
 设置设备主动断开连接｜Setting device active disconnect
*/
- (void)fbUpDisConnectDataWithBlock:(FBResultCallBackBlock _Nonnull)fbBlock;


#pragma mark - 界面跳转测试｜Interface jump test
/**
 界面跳转测试｜Interface jump test
 @param interfaceCode           指定界面代号｜Specify interface code
*/
- (void)fbUpInterfaceJumpTestCode:(NSInteger)interfaceCode withBlock:(FBResultCallBackBlock _Nonnull)fbBlock;


#pragma mark - 女性生理状态设定｜Female's physiological state setting
/**
 女性生理状态设定｜Female's physiological state setting
 @param stateCode           女性生理状态｜Female's physiological state
*/
- (void)fbUpFemalePhysiologicalStateData:(FB_FEMALEPHYSIOLOGICALSTATE)stateCode withBlock:(FBResultCallBackBlock _Nonnull)fbBlock;


#pragma mark - 获取未使用的 记事提醒/闹钟信息 ID｜Get unused reminder / alarm clock ID
/**
 获取未使用的 记事提醒/闹钟信息 ID｜Get unused reminder / alarm clock ID
*/
- (void)fbGetUnusedClockIDWithBlock:(FBGet_AT_ResultCallBackBlock _Nonnull)fbBlock;


#pragma mark - 开启/关闭短跑模式，开启后采集速度由一分钟一笔运动详情，改为一秒一次｜Turn on / off the sprint mode, and the collection speed will be changed from one minute to one second after the start
/**
 开启/关闭短跑模式，开启后采集速度由一分钟一笔运动详情，改为一秒一次｜Turn on / off the sprint mode, and the collection speed will be changed from one minute to one second after the start
 @param mode            关闭/开启｜Off / on
*/
- (void)fbUpSprintMode:(FB_SPRINTMODE)mode withBlock:(FBResultCallBackBlock _Nonnull)fbBlock;


#pragma mark - 监听设备定位开关状态回调，为开启状态时则获取一次定位并上报｜The status callback of the location switch of the monitoring device. When it is in the on state, it will obtain a location and report it
/**
 监听设备定位开关状态回调，为开启状态时则获取一次定位并上报｜The status callback of the location switch of the monitoring device. When it is in the on state, it will obtain a location and report it
 @see   fbPushMobileLocationInformationWithLongitude:withLatitude:withBlock:
*/
- (void)fbUpPositioningSwitchWithBlock:(FBUpPositioningSwitchBlock _Nonnull)fbBlock;


#pragma mark - OTA类型通知｜OTA type notification
/**
 OTA类型通知｜OTA type notification
 @param type         OTA类型｜OTA type
*/
- (void)fbUpOTANotificationWithType:(FB_OTANOTIFICATION)type withBlock:(FBResultCallBackBlock _Nonnull)fbBlock;


#pragma mark - 生产测试模式｜Production test mode
/**
 生产测试模式｜Production test mode
 @param isOpen         YES:进入生产测试模式，NO:退出生产测试模式｜Yes: enter production test mode, No: exit production test mode
*/
- (void)fbUpProductionTestModeIsOpen:(BOOL)isOpen withBlock:(FBResultCallBackBlock _Nonnull)fbBlock;


#pragma mark - 监听设备端功能开关状态同步到手机端回调｜Monitor the status of the function switch on the device side and synchronize it to the callback on the mobile phone side
/**
 监听设备端功能开关状态同步到手机端回调｜Monitor the status of the function switch on the device side and synchronize it to the callback on the mobile phone side
*/
- (void)fbReceiveFunctionSwitchSynchronizationWithBlock:(FBReceiveFunctionSwitchSynchronizationBlock _Nonnull)fbBlock;


#pragma mark - 设置温度单位｜Set temperature units
/**
 设置温度单位｜Set temperature units
 @param unit            温度单位｜Temperature unit
*/
- (void)fbUpTemperatureUnitWithUnit:(FB_TEMPERATUREUNIT)unit withBlock:(FBResultCallBackBlock _Nonnull)fbBlock;


#pragma mark - 获取亮屏时长｜Get the duration of bright screen
/**
 获取亮屏时长｜Get the duration of bright screen
*/
- (void)fbGetTheDurationOfBrightScreenWithBlock:(FBGet_AT_ResultCallBackBlock _Nonnull)fbBlock;


#pragma mark - 设置亮屏时长｜Set the duration of bright screen
/**
 设置亮屏时长｜Set the duration of bright screen
 @param duration            亮屏时间，单位秒｜Screen on time, in seconds
*/
- (void)fbSetTheDurationOfBrightScreenWithDuration:(int)duration withBlock:(FBResultCallBackBlock _Nonnull)fbBlock;


#pragma mark - 切换至指定表盘｜Toggles the specified dial
/**
 切换至指定表盘｜Toggles the specified dial
 @param index           index：第index个内置表盘；10+index：第10+index个动态表盘；20+index：第20+index个自定义表盘｜Index: the first built-in dial; 10 + index: the 10th + index dynamic dial; 20 + index: the 20th + index custom dial
 
 @note  如果超出系统的最大支持的表盘数，则返回系统能支持的最大表盘数｜If the maximum number of dials supported by the system is exceeded, the maximum number of dials supported by the system is returned
 */
- (void)fbTogglesTheSpecifiedDialWithIndex:(int)index withBlock:(FBResultCallBackBlock _Nonnull)fbBlock;


#pragma mark - 震动反馈开关｜Vibration feedback switch
/**
 震动反馈开关｜Vibration feedback switch
 @param mode            YES:开，NO:关｜Yes: on, No: off
*/
- (void)fbVibrationFeedbackSwitchWithMode:(BOOL)mode withBlock:(FBResultCallBackBlock _Nonnull)fbBlock;


#pragma mark - 获取设备当前绑定状态｜Get the current binding status of the device
/**
 获取设备当前绑定状态｜Get the current binding status of the device
 
 @note responseObject 🔑设备绑定状态，为0: 未绑定，不为0: 已绑定｜🔑Device binding status, 0: unbound, not 0: bound
*/
- (void)fbGetBindingStatusRequestWithBlock:(FBGet_AT_ResultCallBackBlock _Nonnull)fbBlock;


#pragma mark - 绑定设备请求｜Bind device request
/**
 绑定设备请求｜Bind device request
 @param macAddress            手表Mac地址，可不传，为nil时SDK内部处理，建议传nil｜The Mac address of the watch can not be passed. If it is nil, it will be processed internally by the SDK. It is recommended to pass nil
 
 @note responseObject 🔑设备绑定结果: 0拒绝绑定，1同意绑定，2已被绑定，3确认超时，4递交秘钥错误，5递交秘钥正确，6无需绑定｜🔑 Device binding result: 0 refuses to bind, 1 agrees to bind, 2 has been bound, 3 confirmation timeout, 4 submits the secret key incorrectly, 5 submits the secret key correctly, 6 does not need to bind
*/
- (void)fbBindDeviceRequest:(NSString * _Nullable)macAddress withBlock:(FBGet_AT_ResultCallBackBlock _Nonnull)fbBlock;


#pragma mark - 解绑设备请求｜Unbind device request
/**
 解绑设备请求｜Unbind device request
 @param macAddress            手表Mac地址，可不传，为nil时SDK内部处理，建议传nil｜The Mac address of the watch can not be passed. If it is nil, it will be processed internally by the SDK. It is recommended to pass nil
*/
- (void)fbUnbindDeviceRequest:(NSString * _Nullable)macAddress withBlock:(FBResultCallBackBlock _Nonnull)fbBlock;


#pragma mark - 获取当天静息心率｜Get the resting heart rate of the day
/**
 获取当天静息心率｜Get the resting heart rate of the day
 */
- (void)fbGetRestingHeartRateOfTheDayWithBlock:(FBGet_AT_ResultCallBackBlock _Nonnull)fbBlock;


#pragma mark - 获取指定提示功能｜Get the specified prompt function
/**
 获取指定提示功能｜Get the specified prompt function
 @param mode            指定的提示功能｜Specified prompt function
 
 @note  返回值 Threshold     提示阀值，当指定值大于0则进行提示；当h=0，为关闭此类提示｜The return value threshold prompts the threshold value. When the specified value is greater than 0, it prompts; When h = 0, this prompt is turned off
 */
- (void)fbGetPromptFunctionWithMode:(FB_PROMPTFUNCTION)mode withBlock:(FBGet_AT_ResultCallBackBlock _Nonnull)fbBlock;


#pragma mark - 设置指定提示功能｜Set the specified prompt function
/**
 设置指定提示功能｜Set the specified prompt function
 @param mode                      指定的提示功能｜Specified prompt function
 @param threshold           提示阀值，当指定值大于0则进行提示；当h=0，为关闭此类提示｜Prompt the threshold value, and prompt when the specified value is greater than 0; When h = 0, this prompt is turned off
 */
- (void)fbSetPromptFunctionWithMode:(FB_PROMPTFUNCTION)mode withThreshold:(NSInteger)threshold withBlock:(FBResultCallBackBlock _Nonnull)fbBlock;


#pragma mark - 获取当前运动状态｜Get the current exercise state
/**
 获取当前运动状态｜Get the current exercise state
 
 @note  运动状态，0:运动停止，1:运动进行中，2:运动暂停中，3:GPS运动进行中，4:GPS运动暂停中｜Motion status, 0: motion stopped, 1: motion in progress, 2: motion paused, 3: GPS motion in progress, 4: GPS motion paused
 */
- (void)fbGetCurrentExerciseStateStatusWithBlock:(FBGet_AT_ResultCallBackBlock _Nonnull)fbBlock;


#pragma mark - APP端GPS运动指令同步｜App GPS motion command synchronization
/**
 APP端GPS运动指令同步｜App GPS motion command synchronization
 @param model           GPS运动状态信息｜GPS motion status information
 */
- (void)fbSynchronizationGPS_MotionWithModel:(FBGPSMotionActionModel *)model withBlock:(FBResultCallBackBlock _Nonnull)fbBlock;


#pragma mark - 监听GPS运动手表状态变更->手机 结果回调｜Monitor the status change of GPS Sports Watch - > callback of mobile phone results
/**
 监听GPS运动手表状态变更->手机 结果回调｜Monitor the status change of GPS Sports Watch - > callback of mobile phone results
 */
- (void)fbGPS_MotionWatchStatusChangeCallbackWithBlock:(FBGPSMotionWatchStatusChangeBlock _Nonnull)fbBlock;


#pragma mark - 定时心率检测开关设置｜Timing heart rate detection switch setting
/**
 定时心率检测开关设置｜Timing heart rate detection switch setting
 @param switchMode          NO:关 YES:开 ｜NO: off    YES: on
 */
- (void)fbTimingHeartRateDetectionSwitchData:(BOOL)switchMode withBlock:(FBResultCallBackBlock _Nonnull)fbBlock;


#pragma mark - 定时血氧检测开关设置｜Timed blood oxygen detection switch setting
/**
 定时血氧检测开关设置｜Timed blood oxygen detection switch setting
 @param switchMode          NO:关 YES:开 ｜NO: off    YES: on
 */
- (void)fbTimingBloodOxygenDetectionSwitchData:(BOOL)switchMode withBlock:(FBResultCallBackBlock _Nonnull)fbBlock;


#pragma mark - 定时血压检测开关设置｜Timed blood pressure detection switch setting
/**
 定时血压检测开关设置｜Timed blood pressure detection switch setting
 @param switchMode          NO:关 YES:开 ｜NO: off    YES: on
 */
- (void)fbTimingBloodPressureDetectionSwitchData:(BOOL)switchMode withBlock:(FBResultCallBackBlock _Nonnull)fbBlock;


#pragma mark - 定时精神压力检测开关设置｜Timed mental stress detection switch setting
/**
 定时精神压力检测开关设置｜Timed mental stress detection switch setting
 @param switchMode          NO:关 YES:开 ｜NO: off    YES: on
 */
- (void)fbTimingStressDetectionSwitchData:(BOOL)switchMode withBlock:(FBResultCallBackBlock _Nonnull)fbBlock;


#pragma mark - 获取通话音频开关｜Get call audio switch
/**
 获取通话音频开关｜Get call audio switch
 
 @note responseObject          0:关 1:开 ｜0: off    1: on
 */
- (void)fbGetCallAudioSwitchWithBlock:(FBGet_AT_ResultCallBackBlock _Nonnull)fbBlock;


#pragma mark - 设置通话音频开关｜Set call audio switch
/**
 设置通话音频开关｜Set call audio switch
 @param switchMode          NO:关 YES:开 ｜NO: off    YES: on
 */
- (void)fbSetCallAudioSwitchData:(BOOL)switchMode withBlock:(FBResultCallBackBlock _Nonnull)fbBlock;


#pragma mark - 获取多媒体音频开关｜Get Multimedia Audio Switch
/**
 获取多媒体音频开关｜Get Multimedia Audio Switch
 
 @note responseObject          0:关 1:开 ｜0: off    1: on
 */
- (void)fbGetMultimediaAudioSwitchWithBlock:(FBGet_AT_ResultCallBackBlock _Nonnull)fbBlock;


#pragma mark - 设置多媒体音频开关｜Set Multimedia Audio Switch
/**
 设置多媒体音频开关｜Set Multimedia Audio Switch
 @param switchMode          NO:关 YES:开 ｜NO: off    YES: on
 */
- (void)fbSetMultimediaAudioSwitchData:(BOOL)switchMode withBlock:(FBResultCallBackBlock _Nonnull)fbBlock;


#pragma mark - 获取未使用的 日程信息 ID｜Get unused schedule information ID
/**
 获取未使用的 日程信息 ID｜Get unused schedule information ID
*/
- (void)fbGetUnusedScheduleIDWithBlock:(FBGet_AT_ResultCallBackBlock _Nonnull)fbBlock;


#pragma mark - 重置MAC地址 (仅供内部测试使用，请勿用于其他用途)｜Reset MAC address (for internal testing only, please do not use for other purposes)
/**
 重置MAC地址 (仅供内部测试使用，请勿用于其他用途)｜Reset MAC address (for internal testing only, please do not use for other purposes)
 */
- (void)fbResetMACaddressWithBlock:(FBResultCallBackBlock _Nonnull)fbBlock API_DEPRECATED("For internal testing only, please do not use for other purposes", macos(2.0, 2.0), ios(2.0, 2.0), tvos(2.0, 2.0), watchos(2.0, 2.0));


#pragma mark - 向设备反馈日志读取进度 (仅供内部使用)｜Feedback log reading progress to the device (Internal use only)
/**
 向设备反馈日志读取进度 (仅供内部使用)｜Feedback log reading progress to the device (Internal use only)
 @param totalCount      将要读取日志的总个数｜The total number of logs to be read
 @param currentIndex    当前读取日志的索引，起始1｜The index of the current log to be read, starting from 1
 */
- (void)fbReadingWithTotalCount:(int)totalCount withCurrentIndex:(int)currentIndex withBlock:(FBResultCallBackBlock _Nonnull)fbBlock API_DEPRECATED("Internal use only", macos(2.0, 2.0), ios(2.0, 2.0), tvos(2.0, 2.0), watchos(2.0, 2.0));


#pragma mark - 设置音量增益补偿｜Setting the volume gain
/**
 设置音量增益补偿｜Setting the volume gain
 @param volumeGain          音量增益补偿，0不补偿｜Volume gain compensation, 0 means no compensation
 */
- (void)fbSetVolumeGainData:(NSInteger)volumeGain withBlock:(FBResultCallBackBlock _Nonnull)fbBlock;


#pragma mark - GPS运动参数设定 (兼容运动定位记录数据双精度)｜GPS sports parameter settings (compatible with sports positioning record data double precision)
/**
 GPS运动参数设定 (兼容运动定位记录数据双精度)｜GPS sports parameter settings (compatible with sports positioning record data double precision)
 */
- (void)fbSettingsGPSSportsParameterWithBlock:(FBResultCallBackBlock _Nonnull)fbBlock;


#pragma mark - 设置离线语音唤醒开关状态｜Set the offline voice wake-up switch status
/**
 设置离线语音唤醒开关状态｜Set the offline voice wake-up switch status
 @param status          开关状态，NO关，YES开｜Switch status, NO off, YES on
 */
- (void)fbSetOfflineVoiceData:(BOOL)status withBlock:(FBResultCallBackBlock _Nonnull)fbBlock;


#pragma mark - 设置手电筒开关状态｜Set the flashlight on/off state
/**
 设置手电筒开关状态｜Set the flashlight on/off state
 @param status          开关状态，NO关，YES开｜Switch status, NO off, YES on
 */
- (void)fbSetFlashlightData:(BOOL)status withBlock:(FBResultCallBackBlock _Nonnull)fbBlock;


#pragma mark - 获取内置表盘开关掩码｜Get the built-in dial switch mask
/**
 获取内置表盘开关掩码｜Get the built-in dial switch mask
 
 @note responseObject          开关掩码，枚举值FB_DIALSWITCHMASKTYPE｜Switch mask, enumeration value FB_DIALSWITCHMASKTYPE
 */
- (void)fbGetDialSwitchMaskWithBlock:(FBGet_AT_ResultCallBackBlock _Nonnull)fbBlock;


#pragma mark - 设置内置表盘开关掩码｜Set the built-in dial switch mask
/**
 设置内置表盘开关掩码｜Set the built-in dial switch mask
 @param switchMask          开关掩码，枚举值FB_DIALSWITCHMASKTYPE｜Switch mask, enumeration value FB_DIALSWITCHMASKTYPE
 */
- (void)fbSetDialSwitchMask:(FB_DIALSWITCHMASKTYPE)switchMask withBlock:(FBResultCallBackBlock _Nonnull)fbBlock;

@end

NS_ASSUME_NONNULL_END
