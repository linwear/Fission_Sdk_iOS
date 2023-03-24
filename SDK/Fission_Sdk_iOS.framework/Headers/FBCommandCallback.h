//
//  FBCommandCallback.h
//  FissionBluetooth
//
//  Created by 裂变智能 on 2021/1/29.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

NS_ASSUME_NONNULL_BEGIN

#pragma mark - 🌟🌟🌟🌟🌟🌟🌟🌟🌟🌟🌟🌟🌟🌟🌟 蓝牙管理相关定义｜Bluetooth management related definitions🌟🌟🌟🌟🌟🌟🌟🌟🌟🌟🌟🌟🌟🌟🌟
/**
 *@brief 蓝牙状态改变的回调｜Callback of Bluetooth status change
 *@param central            中心蓝牙设备｜Central Bluetooth device
 *@param state                 蓝牙状态｜Bluetooth status
 */
typedef void (^FBOnCentralManagerDidUpdateStateBlock)(CBCentralManager *central, CBManagerState state);

/**
 *@brief 扫描到蓝牙设备的回调｜Callback of scanning to Bluetooth device
 *@param peripheralModel            外围设备信息｜外围设备信息
 */
typedef void (^FBDiscoverPeripheralsBlock)(FBPeripheralModel *peripheralModel);

/**
 *@brief 设备连接成功/失败的回调｜Callback of device connection success / failure
 *@param central                    中心蓝牙设备｜Central Bluetooth device
 *@param peripheral             蓝牙设备对象｜Bluetooth device object
 *@param error                        错误信息｜Error message｜Error message
 */
typedef void (^FBOnConnectedAtChannelBlock)(CBCentralManager *central, CBPeripheral *peripheral, NSError * _Nullable error);

/**
 *@brief 设备断开连接的回调｜Callback of device disconnection
 *@param central                    中心蓝牙设备｜Central Bluetooth device
 *@param peripheral             蓝牙设备对象｜Bluetooth device object
 *@param error                        错误信息｜Error message｜Error message
 */
typedef void (^FBOnDisconnectAtChannelBlock)(CBCentralManager *central, CBPeripheral *peripheral, NSError * _Nullable error);

/**
 *@brief 蓝牙系统错误的回调｜Callback of Bluetooth system error
 *@param object1            设备对象1｜Device object 1
 *@param object2            设备对象2｜Device object 2
 *@param error                错误信息｜Error message｜Error message
 */
typedef void (^FBBluetoothSystemErrorBlock)(id object1, id object2, NSError * _Nullable error);

/**
 *@brief FBAtCommand、FBBgCommand 设置（Set）调用结果回调｜FBAtCommand, FBBgCommand set call result callback
 *@param error          错误信息｜Error message，为 nil 时 代表成功｜Error message. Nil means success
 */
typedef void (^FBResultCallBackBlock)(NSError * _Nullable error);

/**
 *@brief FBAtCommand 获取（Get）调用结果回调｜FBAtCommand get (get) call result callback
 *@param error              错误信息｜Error message
 */
typedef void (^FBGet_AT_ResultCallBackBlock)(NSInteger responseObject, NSError * _Nullable error);


#pragma mark - 🌟🌟🌟🌟🌟🌟🌟🌟🌟🌟🌟🌟🌟🌟🌟 AT协议指令定义｜At protocol instruction definition 🌟🌟🌟🌟🌟🌟🌟🌟🌟🌟🌟🌟🌟🌟🌟
/**
 *@brief 获取设备电量信息 调用结果回调｜Get the device power information call result callback
 *@param responseObject             设备电量信息｜Equipment power information
 *@param error                                 错误信息｜Error message｜Error message
 */
typedef void (^FBReqBatteryStatusBlock)(FBBatteryInfoModel * _Nullable responseObject, NSError * _Nullable error);

/**
 *@brief 获取设备版本信息 调用结果回调｜Get device version information call result callback
 *@param responseObject             设备版本信息｜Device version information
 *@param error                                 错误信息｜Error message
 */
typedef void (^FBReqDeviceVersionBlock)(FBDeviceVersionModel * _Nullable responseObject, NSError * _Nullable error);

/**
 *@brief 获取协议版本信息 调用结果回调｜Get the protocol version information and call the result callback
 *@param responseObject             协议版本信息｜Protocol version information
 *@param error                                 错误信息｜Error message
 */
typedef void (^FBReqProtocolVersionBlock)(NSString * _Nullable responseObject, NSError * _Nullable error);

/**
 *@brief 监听设备->手机实时数据流 结果回调｜Monitoring device - > callback of mobile real-time data flow result
 *@param responseObject             实时数据流信息｜Real time data flow information
 *@param error                                 错误信息｜Error message
 */
typedef void (^FBStreamDataHandlerBlock)(FBStreamDataModel * _Nullable responseObject, NSError * _Nullable error);

/**
 *@brief 监听设备->手机即时拍照 结果回调｜Monitoring device - > callback of mobile phone instant photographing results
 */
typedef void (^FBUpTakePhotoClickBlock)(void);

/**
 *@brief 监听设备->查找手机 结果回调｜Monitor device - > find mobile phone result callback
 */
typedef void (^FBUpFindPhoneBlock)(void);

/**
 *@brief 监听设备->放弃查找手机 结果回调｜Monitor device - > abandon the callback of finding mobile phone results
 */
typedef void (^FBAbandonFindingPhoneBlock)(void);

/**
 *@brief 监听设备->手机配对成功iOS 结果回调｜Monitoring device - > successful phone pairing IOS result callback
 */
typedef void (^FBUpPairingCompleteBlock)(void);

/**
 *@brief 监听定位开关 结果回调｜Listen for the callback of positioning switch results
 */
typedef void (^FBUpPositioningSwitchBlock)(void);

/**
 *@brief 监听设备->手机功能开关状态变更 结果回调｜Monitoring device - > callback of function switch status change result of mobile phone
 */
typedef void (^FBReceiveFunctionSwitchSynchronizationBlock)(FBWatchFunctionChangeNoticeModel * _Nullable responseObject);

/**
 *@brief 监听GPS运动手表状态变更->手机 结果回调｜Monitor the status change of GPS Sports Watch - > callback of mobile phone results
 *@param responseObject             GPS运动状态信息｜GPS motion status information
 */
typedef void (^FBGPSMotionWatchStatusChangeBlock)(FBGPSMotionActionModel * _Nullable responseObject);


#pragma mark - 🌟🌟🌟🌟🌟🌟🌟🌟🌟🌟🌟🌟🌟🌟🌟 BG大数据协议指令｜BG big data protocol instruction 🌟🌟🌟🌟🌟🌟🌟🌟🌟🌟🌟🌟🌟🌟🌟
/**
 *@brief 获取设备硬件信息 调用结果回调｜Get device hardware information call result callback
 *@param status                               状态码｜Status code
 *@param progress                          当前进度0～1｜Current progress 0 ~ 1
 *@param responseObject             设备硬件信息｜Device hardware information
 *@param error                                 错误信息｜Error message
 */
typedef void (^FBGetHardwareInformationBlock)(FB_RET_CMD status, float progress, FBDeviceInfoModel * _Nullable responseObject, NSError * _Nullable error);

/**
 *@brief 获取当日实时测量数据 调用结果回调｜Get the real-time measurement data of the current day and call back the result
 *@param status                               状态码｜Status code
 *@param progress                          当前进度0～1｜Current progress 0 ~ 1
 *@param responseObject             当日实时测量数据｜Real time measurement data of the day
 *@param error                                 错误信息｜Error message
 */
typedef void (^FBGetCurrentDayActivityDataBlock)(FB_RET_CMD status, float progress, FBCurrentDataModel * _Nullable responseObject, NSError * _Nullable error);

/**
 *@brief 获取每日活动统计报告 调用结果回调｜Get daily activity statistics report call result callback
 *@param status                               状态码｜Status code
 *@param progress                          当前进度0～1｜Current progress 0 ~ 1
 *@param responseObject             每日活动统计报告｜Daily activity statistics report
 *@param error                                 错误信息｜Error message
 */
typedef void (^FBGetDailyActivityDataBlock)(FB_RET_CMD status, float progress, NSArray <FBDayActivityModel *> * _Nullable responseObject, NSError * _Nullable error);

/**
 *@brief 获取整点活动统计报告 调用结果回调｜Get the call result callback of the whole point activity statistics report
 *@param status                               状态码｜Status code
 *@param progress                          当前进度0～1｜Current progress 0 ~ 1
 *@param responseObject             整点活动统计报告｜Statistical report of on-time activities
 *@param error                                 错误信息｜Error message
 */
typedef void (^FBGetHourlyActivityDataBlock)(FB_RET_CMD status, float progress, NSArray <FBHourReportModel *> * _Nullable responseObject, NSError * _Nullable error);

/**
 *@brief 获取睡眠统计报告 调用结果回调｜Get the call result callback of sleep statistics report
 *@param status                               状态码｜Status code
 *@param progress                          当前进度0～1｜Current progress 0 ~ 1
 *@param responseObject             睡眠统计报告｜Sleep statistics report
 *@param error                                 错误信息｜Error message
 */
typedef void (^FBGetSleepStatisticsReportBlock)(FB_RET_CMD status, float progress, NSArray <FBSleepCaculateReportModel *> * _Nullable responseObject, NSError * _Nullable error);

/**
 *@brief 获取睡眠状态记录 调用结果回调｜Get the call result callback of sleep status record
 *@param status                               状态码｜Status code
 *@param progress                          当前进度0～1｜Current progress 0 ~ 1
 *@param responseObject             睡眠状态记录｜Sleep status record
 *@param error                                 错误信息｜Error message
 */
typedef void (^FBGetSleepStateRecordingBlock)(FB_RET_CMD status, float progress, NSArray <FBSleepStatusRecordModel *> * _Nullable responseObject, NSError * _Nullable error);

/**
 *@brief 获取设备运动类型列表 调用结果回调｜Get the list of device motion types Call the result callback
 *@param status                               状态码｜Status code
 *@param progress                          当前进度0～1｜Current progress 0 ~ 1
 *@param responseObject             设备运动类型列表｜List of Equipment Motion Types
 *@param error                                 错误信息｜Error message
 */
typedef void (^FBGetMotionTypesListBlock)(FB_RET_CMD status, float progress, FBMotionTypesListModel * _Nullable responseObject, NSError * _Nullable error);

/**
 *@brief 获取运动记录列表 调用结果回调｜Get motion record list call result callback
 *@param status                               状态码｜Status code
 *@param progress                          当前进度0～1｜Current progress 0 ~ 1
 *@param responseObject             运动记录列表｜Sports record list
 *@param error                                 错误信息｜Error message
 */
typedef void (^FBGetMotionRecordListBlock)(FB_RET_CMD status, float progress, NSArray <FBSportRecordModel *> * _Nullable responseObject, NSError * _Nullable error);

/**
 *@brief 获取运动统计报告 调用结果回调｜Get motion record list call result callback
 *@param status                               状态码｜Status code
 *@param progress                          当前进度0～1｜Current progress 0 ~ 1
 *@param responseObject             运动统计报告｜Sports statistics report
 *@param error                                 错误信息｜Error message
 */
typedef void (^FBGetSportsDataReportBlock)(FB_RET_CMD status, float progress, NSArray <FBSportCaculateModel *> * _Nullable responseObject, NSError * _Nullable error);

/**
 *@brief 获取心率记录 调用结果回调｜Get the call result callback of motion statistics report
 *@param status                               状态码｜Status code
 *@param progress                          当前进度0～1｜Current progress 0 ~ 1
 *@param responseObject             心率记录｜Heart rate recording
 *@param error                                 错误信息｜Error message
 */
typedef void (^FBGetHeartRateRecordBlock)(FB_RET_CMD status, float progress, NSArray <FBTypeRecordModel *> * _Nullable responseObject, NSError * _Nullable error);

/**
 *@brief 获取计步记录 调用结果回调｜Get call result callback of step counting record
 *@param status                               状态码｜Status code
 *@param progress                          当前进度0～1｜Current progress 0 ~ 1
 *@param responseObject             计步记录｜Step counting record
 *@param error                                 错误信息｜Error message
 */
typedef void (^FBGetStepCountRecordBlock)(FB_RET_CMD status, float progress, NSArray <FBTypeRecordModel *> * _Nullable responseObject, NSError * _Nullable error);

/**
 *@brief 获取血氧记录 调用结果回调｜Get the call result callback of blood oxygen record
 *@param status                               状态码｜Status code
 *@param progress                          当前进度0～1｜Current progress 0 ~ 1
 *@param responseObject             血氧记录｜Blood oxygen record
 *@param error                                 错误信息｜Error message
 */
typedef void (^FBGetBloodOxygenRecordBlock)(FB_RET_CMD status, float progress, NSArray <FBTypeRecordModel *> * _Nullable responseObject, NSError * _Nullable error);

/**
 *@brief 获取血压记录 调用结果回调｜Get the callback of blood pressure record call result
 *@param status                               状态码｜Status code
 *@param progress                          当前进度0～1｜Current progress 0 ~ 1
 *@param responseObject             血压记录｜Blood pressure record
 *@param error                                 错误信息｜Error message
 */
typedef void (^FBGetBloodPressureRecordsBlock)(FB_RET_CMD status, float progress, NSArray <FBTypeRecordModel *> * _Nullable responseObject, NSError * _Nullable error);

/**
 *@brief 获取精神压力记录 调用结果回调｜Get mental pressure record call result callback
 *@param status                               状态码｜Status code
 *@param progress                          当前进度0～1｜Current progress 0 ~ 1
 *@param responseObject             精神压力记录｜Stress Record
 *@param error                                 错误信息｜Error message
 */
typedef void (^FBGetStressRecordsBlock)(FB_RET_CMD status, float progress, NSArray <FBTypeRecordModel *> * _Nullable responseObject, NSError * _Nullable error);

/**
 *@brief 获取运动详情记录 调用结果回调｜Get motion detail record call result callback
 *@param status                               状态码｜Status code
 *@param progress                          当前进度0～1｜Current progress 0 ~ 1
 *@param responseObject             运动详情记录｜Sports detail record
 *@param error                                 错误信息｜Error message
 */
typedef void (^FBGetExerciseDetailsBlock)(FB_RET_CMD status, float progress, NSArray <FBTypeRecordModel *> * _Nullable responseObject, NSError * _Nullable error);

/**
 *@brief 获取 运动统计报告+运动详情纪录 调用结果回调｜Get Sports Statistics Report + Sports Details Record Call Result Callback
 *@param status                               状态码｜Status code
 *@param progress                          当前进度0～1｜Current progress 0 ~ 1
 *@param responseObject             运动统计报告+运动详情纪录｜Sports Statistics Report + Sports Details Record
 *@param error                                 错误信息｜Error message
 */
typedef void (^FBGetSportsStatisticsDetailsRecordBlock)(FB_RET_CMD status, float progress, NSArray <FBSportsStatisticsDetailsRecordModel *> * _Nullable responseObject, NSError * _Nullable error);

/**
 *@brief 获取运动定位记录 调用结果回调｜Get the call result callback of motion positioning record
 *@param status                               状态码｜Status code
 *@param progress                          当前进度0～1｜Current progress 0 ~ 1
 *@param responseObject             运动定位记录｜Motion positioning record
 *@param error                                 错误信息｜Error message
 */
typedef void (^FBGetMotionLocationRecordBlock)(FB_RET_CMD status, float progress, NSArray <FBTypeRecordModel *> * _Nullable responseObject, NSError * _Nullable error);

/**
 *@brief 获取运动高频心率记录(1秒1次) 调用结果回调｜Get exercise high-frequency heart rate records (once per second) Call the result callback
 *@param status                               状态码｜Status code
 *@param progress                          当前进度0～1｜Current progress 0 ~ 1
 *@param responseObject             运动高频心率记录｜Sports high-frequency heart rate recording
 *@param error                                 错误信息｜Error message
 */
typedef void (^FBGetExerciseHFHRRecordsBlock)(FB_RET_CMD status, float progress, NSArray <FBTypeRecordModel *> * _Nullable responseObject, NSError * _Nullable error);

/**
 *@brief 获取手动测量数据记录 调用结果回调｜Get manual measurement data record call result callback
 *@param status                               状态码｜Status code
 *@param progress                          当前进度0～1｜Current progress 0 ~ 1
 *@param responseObject             手动测量数据记录｜Manual measurement data record
 *@param error                                 错误信息｜Error message
 */
typedef void (^FBGetManualMeasureDataBlock)(FB_RET_CMD status, float progress, NSArray <FBManualMeasureDataModel *> * _Nullable responseObject, NSError * _Nullable error);

/**
 *@brief 获取指定记录报告数据 调用结果回调｜Get the specified record report data call result callback
 *@param status                               状态码｜Status code
 *@param recordType                      当前返回的记录报告类型｜Currently returned record report type
 *@param progress                          当前进度0～1｜Current progress 0 ~ 1
 *@param responseObject             当前返回记录报告数据｜Current return record report data
 *@param error                                 错误信息｜Error message
 */
typedef void (^FBGetSpecialRecordsAndReportsBlock)(FB_RET_CMD status, FB_MULTIPLERECORDREPORTS recordType, float progress, id _Nullable responseObject, NSError * _Nullable error);

/**
 *@brief 获取个人用户信息 调用结果回调｜Get personal user information call result callback
 *@param status                               状态码｜Status code
 *@param progress                          当前进度0～1｜Current progress 0 ~ 1
 *@param responseObject             个人用户信息｜Personal user information
 *@param error                                 错误信息｜Error message
 */
typedef void (^FBGetPersonalUserInforBlock)(FB_RET_CMD status, float progress, FBUserInforModel * _Nullable responseObject, NSError * _Nullable error);

/**
 *@brief 获取记事提醒/闹钟信息 调用结果回调｜Get reminder / alarm information call result callback
 *@param status                               状态码｜Status code
 *@param progress                          当前进度0～1｜Current progress 0 ~ 1
 *@param responseObject             记事提醒/闹钟信息｜Reminder / alarm clock
 *@param error                                 错误信息｜Error message
 */
typedef void (^FBGetClockInforBlock)(FB_RET_CMD status, float progress, NSArray <FBAlarmClockModel *> * _Nullable responseObject, NSError * _Nullable error);

/**
 *@brief 获取消息推送开关信息 调用结果回调｜Get message push switch information call result callback
 *@param status                               状态码｜Status code
 *@param progress                          当前进度0～1｜Current progress 0 ~ 1
 *@param responseObject             消息推送开关信息｜Message push switch information
 *@param error                                 错误信息｜Error message
 */
typedef void (^FBGetMessagePushSwitchBlock)(FB_RET_CMD status, float progress, FBMessageModel * _Nullable responseObject, NSError * _Nullable error);

/**
 *@brief 获取久坐提醒信息 调用结果回调｜Get sedentary reminder information call result callback
 *@param status                               状态码｜Status code
 *@param progress                          当前进度0～1｜Current progress 0 ~ 1
 *@param responseObject             久坐提醒信息｜Sedentary reminder
 *@param error                                 错误信息｜Error message
 */
typedef void (^FBGetLongSitInforBlock)(FB_RET_CMD status, float progress, FBLongSitModel * _Nullable responseObject, NSError * _Nullable error);

/**
 *@brief 获取心率等级判定信息 调用结果回调｜Get the heart rate level determination information and call the result callback
 *@param status                               状态码｜Status code
 *@param progress                          当前进度0～1｜Current progress 0 ~ 1
 *@param responseObject             心率等级判定信息｜Heart rate level determination information
 *@param error                                 错误信息｜Error message
 */
typedef void (^FBGetHeartRateInforBlock)(FB_RET_CMD status, float progress, FBHeartRateRatingModel * _Nullable responseObject, NSError * _Nullable error);

/**
 *@brief 获取喝水提醒信息 调用结果回调｜Get the water drinking reminder information and call the result callback
 *@param status                               状态码｜Status code
 *@param progress                          当前进度0～1｜Current progress 0 ~ 1
 *@param responseObject             喝水提醒信息｜Water drinking reminder information
 *@param error                                 错误信息｜Error message
 */
typedef void (^FBGetDrinkWaterBlock)(FB_RET_CMD status, float progress, FBWaterClockModel * _Nullable responseObject, NSError * _Nullable error);

/**
 *@brief 获取勿扰提醒信息 调用结果回调｜Get do not disturb reminder information call back result
 *@param status                               状态码｜Status code
 *@param progress                          当前进度0～1｜Current progress 0 ~ 1
 *@param responseObject             勿扰提醒信息｜Do not disturb reminder message
 *@param error                                 错误信息｜Error message
 */
typedef void (^FBGetNotDisturbBlock)(FB_RET_CMD status, float progress, FBNotDisturbModel * _Nullable responseObject, NSError * _Nullable error);

/**
 *@brief 获取心率检测信息 调用结果回调｜Get heart rate detection information call result callback
 *@param status                               状态码｜Status code
 *@param progress                          当前进度0～1｜Current progress 0 ~ 1
 *@param responseObject             心率检测信息｜Heart rate detection information
 *@param error                                 错误信息｜Error message
 */
typedef void (^FBGetHeartTestPeriodsBlock)(FB_RET_CMD status, float progress, FBHrCheckModel * _Nullable responseObject, NSError * _Nullable error);

/**
 *@brief 获取抬腕亮屏信息 调用结果回调｜Get the information of wrist lifting and bright screen and call back the result
 *@param status                               状态码｜Status code
 *@param progress                          当前进度0～1｜Current progress 0 ~ 1
 *@param responseObject             抬腕亮屏信息｜Wrist lifting light screen information
 *@param error                                 错误信息｜Error message
 */
typedef void (^FBGetWristTimeBlock)(FB_RET_CMD status, float progress, FBWristModel * _Nullable responseObject, NSError * _Nullable error);

/**
 *@brief 获取运动目标信息 调用结果回调｜Get moving target information call result callback
 *@param status                               状态码｜Status code
 *@param progress                          当前进度0～1｜Current progress 0 ~ 1
 *@param responseObject             运动目标信息｜Moving target information
 *@param error                                 错误信息｜Error message
 */
typedef void (^FBGetSportsTagargetBlock)(FB_RET_CMD status, float progress, FBSportTargetModel * _Nullable responseObject, NSError * _Nullable error);

/**
 *@brief 获取女性生理周期信息 调用结果回调｜Get female physiological cycle information call result callback
 *@param status                               状态码｜Status code
 *@param progress                          当前进度0～1｜Current progress 0 ~ 1
 *@param responseObject             女性生理周期信息｜Female physiological cycle information
 *@param error                                 错误信息｜Error message
 */
typedef void (^FBGetFemaleCircadianCycleBlock)(FB_RET_CMD status, float progress, FBFemalePhysiologyModel * _Nullable responseObject, NSError * _Nullable error);

/**
 *@brief 获取心率异常提醒信息 调用结果回调｜Get the abnormal heart rate reminder information and call the result callback
 *@param status                               状态码｜Status code
 *@param progress                          当前进度0～1｜Current progress 0 ~ 1
 *@param responseObject             心率异常提醒信息｜Abnormal heart rate reminder information
 *@param error                                 错误信息｜Error message
 */
typedef void (^FBGetAbnormalHeartRateReminderBlock)(FB_RET_CMD status, float progress, FBHrReminderModel * _Nullable responseObject, NSError * _Nullable error);

/**
 *@brief OTA同步数据 调用结果回调｜OTA synchronous data call result callback
 *@param status                               状态码｜Status code
 *@param progress                          当前进度信息｜current progress information
 *@param responseObject             OTA完成信息｜OTA completion information
 *@param error                                 错误信息｜Error message
 */
typedef void (^FBSetOtaUpgradeManagerBlock)(FB_RET_CMD status, FBProgressModel * _Nullable progress, FBOTADoneModel * _Nullable responseObject, NSError * _Nullable error);

/**
 *@brief GPS运动互联数据交互 调用结果回调｜GPS motion interconnection data interaction call result callback
 *@param status                               状态码｜Status code
 *@param progress                          当前进度0～1｜Current progress 0 ~ 1
 *@param responseObject             GPS运动互联数据｜GPS motion interconnection data
 *@param error                                 错误信息｜Error message
 */
typedef void (^FBMotionInterconnectionBlock)(FB_RET_CMD status, float progress, FBMotionInterconnectionModel * _Nullable responseObject, NSError * _Nullable error);

/**
 *@brief 获取常用联系人信息 调用结果回调｜Get common contact information call result callback
 *@param status                               状态码｜Status code
 *@param progress                          当前进度0～1｜Current progress 0 ~ 1
 *@param responseObject             常用联系人信息｜Frequently used contact information
 *@param error                                 错误信息｜Error message
 */
typedef void (^FBGetFavoriteContactListBlock)(FB_RET_CMD status, float progress, NSArray <FBFavContactModel *> * _Nullable responseObject, NSError * _Nullable error);

/**
 *@brief 请求获取设备日志信息 调用结果回调｜Request to get device log information Call result callback
 *@param status                               状态码｜Status code
 *@param progress                          当前进度0～1｜Current progress 0 ~ 1
 *@param responseObject             设备日志信息｜Device log information
 *@param error                                 错误信息｜Error message
 */
typedef void (^FBRequestDeviceLogsBlock)(FB_RET_CMD status, float progress, NSString * _Nullable responseObject, NSError * _Nullable error);


/* block回调类｜Block callback class */
@interface FBCommandCallback : NSObject
@end

NS_ASSUME_NONNULL_END
