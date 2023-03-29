//
//  Fission_Sdk_iOS.h
//  Fission_Sdk_iOS
//
//  Created by 裂变智能 on 2021/3/17.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

//  框架名称｜Framework Name: Fission_Sdk_iOS.framework
//  框架功能｜Framework Function: iOS framework for Fission smart watch, which is responsible for the communication with the watch.
//                              Fission 智能手表的 iOS 框架，负责与智能手表设备通信等功能的封装。
//  修改记录｜Modification Record:
//     pcjbird    2023-03-29  Version:3.1.1 Build:202303291000
//                            1.优化内部压缩算法
//                            2.修复"获取设备硬件信息"结构体版本错误问题
//                            2.新增"获取设备绑定状态"协议（FBAtCommand）fbGetBindingStatusRequestWithBlock:
//                            3.新增"获取当前运动状态"协议（FBAtCommand）fbGetCurrentExerciseStateStatusWithBlock:
//
//     pcjbird    2023-03-24  Version:3.1.0 Build:202303241000
//                            1.FB_OTANOTIFICATION 新增OTA通知类型:
//                              FB_OTANotification_Multi_Dial_Built_in(200)
//                              FB_OTANotification_Multi_Sport_Built_in(201)
//                            2.FBCustomDataTools「多个运动类型Bin文件压缩合并成一个Bin文件」压缩算法API调整（2048或4096）
//                            3.新增"获取设备运动类型列表"协议（FBBgCommand）fbGetListOfDeviceMotionTypesWithBlock:
//                            4.原厂OTA SDK更新: RTKOTASDK.framework
//
//     pcjbird    2023-03-01  Version:3.0.9 Build:202303011000
//                            1.FBFirmwareVersionObject 新增配置:
//                              是否支持一次性推送多种运动模式
//                              支持一次性推送多种运动模式的个数，0不支持
//                            2.新增一次性推送多种运动模式协议
//                            3.FB_OTANOTIFICATION 新增OTA通知类型:
//                              FB_OTANotification_Multi_Sport(9)
//                            4.FBCustomDataTools 新增「多个运动类型Bin文件压缩合并成一个Bin文件」，配合「一次性推送多种运动模式」使用
//                            5.FBBluetoothOTA 新增进度模型 FBProgressModel，兼容一个bin文件包含多个包时的升级进度问题
//                            6.修正部分地区使用冬/夏令时，时区无法设置导致时间错误问题
//                            7.绑定设备请求可传入Mac地址，但是强烈建议传nil，SDK内部会为你管理绑定密钥
//                            8.GPS运动控制增加错误码 FB_GPS_MOTION_STATE_NONE 本地无此运动信息
//                            9.优化搜索设备，使用数据模型 FBPeripheralModel
//                            10.FB_MOTIONMODE 新增运动类型:
//                              法国式拳击(139)
//
//     pcjbird    2023-02-11  Version:3.0.8 Build:202302111000
//                            1.绑定请求超时时长由30s延长至60s
//                            2.新增获取设备log数据协议
//
//     pcjbird    2023-02-09  Version:3.0.7 Build:202302091800
//                            1.优化设备搜索性能
//                            2.优化数据发送间隔
//                            3.新增"确认手机被找到"协议（FBAtCommand）fbUpPhoneConfirmedFoundDataWithBlock:
//
//     pcjbird    2023-02-02  Version:3.0.6 Build:202302021500
//                            1.修正set心率异常提醒参数合法性判断
//
//     pcjbird    2023-01-30  Version:3.0.5 Build:202301301600
//                            1.修正获取血压记录协议
//                            2.新增获取运动高频心率记录(1秒1次)
//                            3.新增获取精神压力协议
//                            4.兼容获取手动测量记录协议
//                            5.FBFirmwareVersionObject 新增配置:
//                              是否支持音频和通话开关设置和获取
//                              是否支持心率血氧精神压力开关设置
//                              是否支持血压功能
//                              是否支持精神压力功能
//                            6.协议方法调用合并:
//                              同步系统时间 调用（FBAtCommand）fbAutomaticallySynchronizeSystemTimeWithBlock: 即可
//                              同时获取运动统计报告+运动详情纪录 调用 (FBBgCommand) fbGetSportsStatisticsDetailsReportsWithStartTime: 即可
//                            7.FB_RECORDTYPE 新增类型:
//                              FB_HFHeartRecord
//                            8.FB_MULTIPLERECORDREPORTS 新增类型:
//                              FB_Sports_Statistics_Details_Report
//
//     pcjbird    2023-01-05  Version:3.0.4 Build:202301051800
//                            1.新增get、set通话音频开关协议
//                            2.新增get、set多媒体音频开关协议
//                            3.EM_FUNC_SWITCH 新增类型:
//                              FS_CALLAUDIO_WARN(31)
//                              FS_MULTIMEDIAAUDIO_WARN(32)
//
//     pcjbird    2022-12-30  Version:3.0.3 Build:202212301600
//                            1.新增 定时心率检测开关设置协议、定时血氧检测开关设置协议、定时精神压力检测开关设置协议
//                            2.EM_FUNC_SWITCH 新增类型:
//                              FS_TIMING_HR_WARN(28)
//                              FS_TIMING_SPO2_WARN(29)
//                              FS_TIMING_STRESS_WARN(30)
//                            3.FBMessageModel 新增消息推送类型:
//                              missCall
//                              discord
//                              whitetb
//                              email
//                              fastrack_reflex_world
//                              inshort
//                              amazon
//                              flipkart
//                              smartworld
//                            4.FB_MOTIONMODE 新增运动类型:
//                              最大摄氧量测试(126)
//                              放风筝(127)
//                              台球(128)
//                              有氧运动巡洋舰(129)
//                              拔河比赛(130)
//                              免费的陪练(131)
//                              漂流(132)
//                              旋转(133)
//                              BMX(134)
//                              ATV(135)
//                              哑铃(136)
//                              沙滩足球(137)
//                              皮划艇(138)
//
//     pcjbird    2022-12-14  Version:3.0.2 Build:202212141900
//                            1.优化OTA通知问题
//                            2.GPS运动控制增加 确认/取消 指令
//
//     pcjbird    2022-11-19  Version:3.0.1 Build:202211191600
//                            1.广播信息解析:适配号兼容
//                            2.新增印地语、孟加拉语、乌尔都语、波斯语
//                            3.新增获取精神压力记录协议、血压协议暂时不使用
//
//     pcjbird    2022-07-15  Version:3.0.0 Build:202207151200
//                            1.优化已知问题
//                            2.block结果回调异常问题
//
//     pcjbird    2022-04-14  Version:2.0.0 Build:202204140900
//                            1.优化已知问题
//                            2.部分AT指令数据返回类型由NSDictionary字典转换为使用对象模型，后续会有更多api支持
//                            3.增加自定义表盘压缩算法协议
//
//     pcjbird    2020-12-31  Version:1.0.0 Build:202012311800
//                            1.首个发布版本
//

//! Project version number for Fission_Sdk_iOS.
FOUNDATION_EXPORT double Fission_Sdk_iOSVersionNumber;

//! Project version string for Fission_Sdk_iOS.
FOUNDATION_EXPORT const unsigned char Fission_Sdk_iOSVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <Fission_Sdk_iOS/PublicHeader.h>

/** 枚举相关｜Enumerate related */
#import <Fission_Sdk_iOS/FBMacro.h>
/** 数据模型相关类｜Data model related classes */
#import <Fission_Sdk_iOS/FBPeripheralModel.h>
#import <Fission_Sdk_iOS/FBBatteryInfoModel.h>
#import <Fission_Sdk_iOS/FBDeviceVersionModel.h>
#import <Fission_Sdk_iOS/FBWatchFunctionChangeNoticeModel.h>
#import <Fission_Sdk_iOS/FBDeviceInfoModel.h>
#import <Fission_Sdk_iOS/FBCurrentDataModel.h>
#import <Fission_Sdk_iOS/FBDayActivityModel.h>
#import <Fission_Sdk_iOS/FBHourReportModel.h>
#import <Fission_Sdk_iOS/FBSleepCaculateReportModel.h>
#import <Fission_Sdk_iOS/FBSleepStatusRecordModel.h>
#import <Fission_Sdk_iOS/FBSportRecordModel.h>
#import <Fission_Sdk_iOS/FBSportCaculateModel.h>
#import <Fission_Sdk_iOS/FBTypeRecordModel.h>
#import <Fission_Sdk_iOS/FBUserInforModel.h>
#import <Fission_Sdk_iOS/FBAlarmClockModel.h>
#import <Fission_Sdk_iOS/FBLongSitModel.h>
#import <Fission_Sdk_iOS/FBHeartRateRatingModel.h>
#import <Fission_Sdk_iOS/FBWaterClockModel.h>
#import <Fission_Sdk_iOS/FBNotDisturbModel.h>
#import <Fission_Sdk_iOS/FBHrCheckModel.h>
#import <Fission_Sdk_iOS/FBWristModel.h>
#import <Fission_Sdk_iOS/FBSportTargetModel.h>
#import <Fission_Sdk_iOS/FBMessageModel.h>
#import <Fission_Sdk_iOS/FBWeatherModel.h>
#import <Fission_Sdk_iOS/FBSleepStateModel.h>
#import <Fission_Sdk_iOS/FBSportPauseModel.h>
#import <Fission_Sdk_iOS/FBRecordDetailsModel.h>
#import <Fission_Sdk_iOS/FBSportsStatisticsDetailsRecordModel.h>
#import <Fission_Sdk_iOS/FBStreamDataModel.h>
#import <Fission_Sdk_iOS/FBOTADoneModel.h>
#import <Fission_Sdk_iOS/FBWeatherDetailsModel.h>
#import <Fission_Sdk_iOS/FBFemalePhysiologyModel.h>
#import <Fission_Sdk_iOS/FBCustomDialModel.h>
#import <Fission_Sdk_iOS/FBHrReminderModel.h>
#import <Fission_Sdk_iOS/FBManualMeasureDataModel.h>
#import <Fission_Sdk_iOS/FBCustomMotionModel.h>
#import <Fission_Sdk_iOS/FBGPSMotionActionModel.h>
#import <Fission_Sdk_iOS/FBMotionInterconnectionModel.h>
#import <Fission_Sdk_iOS/FBFirmwareVersionObject.h>
#import <Fission_Sdk_iOS/FBAllConfigObject.h>
#import <Fission_Sdk_iOS/FBFavContactModel.h>
#import <Fission_Sdk_iOS/FBProgressModel.h>
#import <Fission_Sdk_iOS/FBMotionTypesListModel.h>

/** 蓝牙管理器｜Bluetooth manager */
#import <Fission_Sdk_iOS/FBCommandCallback.h>
#import <Fission_Sdk_iOS/FBBluetoothManager.h>
/** AT指令集｜At instruction set */
#import <Fission_Sdk_iOS/FBAtCommand.h>
/** BG指令集｜Bg instruction set */
#import <Fission_Sdk_iOS/FBBgCommand.h>
/** OTA管理器｜OTA Manager */
#import <Fission_Sdk_iOS/FBBluetoothOTA.h>
/** 生成自定义bin数据工具类｜Generate custom bin data tool class */
#import <Fission_Sdk_iOS/FBCustomDataTools.h>

