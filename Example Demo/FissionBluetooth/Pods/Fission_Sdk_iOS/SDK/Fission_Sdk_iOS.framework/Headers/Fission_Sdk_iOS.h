//
//  Fission_Sdk_iOS.h
//  Fission_Sdk_iOS
//
//  Created by 裂变智能 on 2021/3/17.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/*
  框架名称｜Framework Name: Fission_Sdk_iOS.framework
  框架功能｜Framework Function: iOS framework for Fission smart watch, which is responsible for the communication with the watch.
                              Fission 智能手表的 iOS 框架，负责与智能手表设备通信等功能的封装。
  GitHub @link https://github.com/linwear/Fission_Sdk_iOS.git
  修改记录｜Modification Record:
     project    2024-08-22  Version:3.2.2 Build:20240822001
                            1.⚠️Fission_Sdk_iOS.framework最低系统版本要求由 iOS10.0+ 提高至 iOS12.1+
                            2.⚠️不再支持x86_64(模拟器)。新增Framework库依赖:
                              SCompressLib.framework
                              MagicTool.framework
                              Starscream.framework
                              ffmpegKit-kit @linkhttps://github.com/arthenica/ffmpeg-kit (参考pod 'ffmpeg-kit-ios-full', '~> 6.0' 最低系统版本要求12.1)
                            3.新增运动类型: 141-151
                            4.FBFirmwareVersionObject 新增标志位:
                              是否支持PATCH版本字段
                              是否支持日程功能
                              是否支持紧急联系人（SOS）
                              是否支持今日天气显示城市名称
                              是否支持JS应用
                              支持常用联系人设置的个数
                              支持紧急联系人设置的个数
                              是否支持今日天气显示城市名称
                              是否支持JS应用
                              是否支持多媒体空间
                              是否支持视频表盘
                            5.新增"获取未使用的 日程信息 ID"协议（FBAtCommand）fbGetUnusedScheduleIDWithBlock:
                            6.新增"获取日程信息"协议（FBBgCommand）fbGetScheduleInforWithBlock:
                            7.新增"设置日程信息"协议（FBBgCommand）fbSetSchedulenforWithScheduleModel:withRemoved:withBlock:
                            8.新增"获取紧急联系人信息"协议（FBBgCommand）fbGetEmergencyContactListWithBlock:
                            9.新增"设置紧急联系人信息"协议（FBBgCommand）fbSetEmergencyContactListWithModel:withBlock:
                            10.优化运动记录数据排序问题
                            11.优化海思芯片OTA方案
                            12.新增"OTA文件增加文件信息"（FBCustomDataTools）createFileName:withFileData:withOTAType:方法，当前此方法仅用于海思芯片方案
                            13.自定义表盘兼容海思芯片方案，支持自定义视频表盘（FBCustomDataTools）fbGenerateCustomDialBinFileDataWithDialModel:
                            14.支持百度相关: 语音识别、文字翻译、文心一言、文字生成语音、百度导航（文字导航）。详见 FBBaiduCloudKit 类
                            15.支持系统麦克风的调用封装。详见 FBAudioRecorder 类。注意需要在 Info.plist 中添加 NSMicrophoneUsageDescription 权限
                            16.新增"获取系统空间使用信息"协议（FBBgCommand）fbGetSystemSpaceUsageInforWithBlock:
                            17.新增"获取表盘列表文件信息"协议（FBBgCommand）fbGetDialListFileInforWithBlock:
                            18.新增"获取JS应用列表文件信息"协议（FBBgCommand）fbGetJsAppListFileInforWithBlock:
                            19.新增"删除表盘列表文件信息"协议（FBBgCommand）fbDeleteDialListFileInfor:withBlock:
                            20.新增"删除JS应用列表文件信息"协议（FBBgCommand）fbDeleteJsAppListFileInfor:withBlock:
                            21.支持【支付宝】【乘车码】功能，SDK内部处理，外部无需任何调用
                            22.新增支持瑞昱8773芯片
                            23.优化自定义表盘图片抗锯齿
                            24.优化已知问题
 
     project    2024-01-22  Version:3.2.1 Build:20240122001
                            1.新增生成AGPS星历bin文件数据（FBCustomDataTools）fbGenerateAGPSEphemerisBinFileDataWithModel:
                            2.适配兼容新协议版本的数据格式解析
                            3.FBFirmwareVersionObject 新增标志位:
                              芯片厂商类型 (瑞昱、海思)
                            4.不同芯片类型使用不同的OTA方法 (SDK内部已做区分，FBBluetoothOTA传入对应的otaType即可)
                            5.qz压缩算法增加crc校验和，以及其他优化
                            6.优化已知问题
 
     project    2023-12-15  Version:3.2.0 Build:20231215001
                            1.定位记录详情增加 公/英里 里程点
                            2.修改翻译
                            3.优化已知问题
 
     project    2023-11-28  Version:3.1.9 Build:20231128001
                            1.优化绑定密钥缓存逻辑
 
     project    2023-11-16  Version:3.1.8 Build:20231116001
                            1.FBMacro.h调整枚举声明方式
                            2.广播信息优化
                            3.OTA进度回调优化
                            4.时间格式转换优化
                            5.断开连接同时是否清除连接历史记录 @see disconnectPeripheralAndClearHistory:
                            6.其他已知问题的优化
 
     project    2023-10-10  Version:3.1.7 Build:20231010001
                            1.FBFirmwareVersionObject 新增标志位:
                              是否支持静息心率
                              是否支持AGPS定位
                            2.修复"获取运动定位记录"协议已知错误问题（FBBgCommand）fbGetMotionLocationRecordDataStartTime: forEndTime: withBlock:

     project    2023-08-24  Version:3.1.6 Build:20230824001
                            1.EM_FUNC_SWITCH 新增类型:
                              FS_AGPS_LOCATION_REQUEST(35)
                              FS_AGPS_DATA_REQUEST(36)
                            2.FB_OTANOTIFICATION 新增OTA通知类型:
                              FB_OTANotification_AGPS_Package(30)
                            3.新增"推送AGPS位置基础信息(经纬度UTC)"协议（FBBgCommand）fbPushAGPSLocationInformation: withBlock:
                            4.新增"同步AGPS定位数据"协议（FBBgCommand）fbSynchronizeAGPSPositioningData: withBlock:
                            5.FB_MOTIONMODE 新增运动类型:
                              沙滩排球(140)
                            6.FB_LANGUAGES 新增语言类型:
                              FB_SDK_ms(29)
                              FB_SDK_sk(30)
                              FB_SDK_my(31)
                              FB_SDK_da(32)
                            7.SDK同时支持 真机、模拟器 编译运行（注意：模拟器无法使用蓝牙）

     project    2023-07-18  Version:3.1.5 Build:20230718001
                            1.新增"多项目自定义表盘"功能（FBCustomDataTools）fbGenerateMultiProjectCustomDialBinFileDataWithDialsModel:
                            2.修复"设置/获取 个人用户信息"协议已知错误问题
                            3.新增"读取片外 flash 空间数据"协议，用于获取设备意外重启信息，供固件分析问题（FBBgCommand）fbReadOffChipFlashWithAddress: withLength: withBlock:
                            4.FBFirmwareVersionObject 新增:
                              适配号，长整形（部分手表支持）
                              Hardfault信息空间地址
                              Hardfault信息空间尺寸
                              系统参数空间地址
                              系统参数空间尺寸
                              是否支持带适配号验证的OTA通知指令
                              是否支持hardfault信息和系統参数读取
                              是否支持表盘CRC校验
                            5.EM_FUNC_SWITCH 新增类型:
                              FS_TIMING_BP_WARN(33)
                              FS_DEVICE_EXCEPTION_WARN(34)
                            6.新增表盘数据校验（UTC或CRC）
                            7.原厂OTA SDK更新至v1.4.9版本（RTKOTASDK.framework、RTKLEFoundation.framework）修改多包OTA文件顺序
                            8.FBTypeRecordModel 记录生成周期 参数名由原先 createTimes 改为 recordingCycle，避免歧义，并且单位统一为秒；新增参数 记录格式定义（recordDefinition）
                            9.FBRecordDetailsModel 运动详情记录新增参数 一公里用时（一公里配速，单位秒）KilometerPace，一英里用时（一英里配速，单位秒）MilePace，仅部分设备支持，具体根据参数 记录格式定义（recordDefinition）而定
                            10.自定义表盘抗锯齿切图更新
                            11.优化记录/报告排序及其他已知问题

     project    2023-05-18  Version:3.1.4 Build:202305181600
                            1.优化已知问题
                            2.新增"自定义表盘支持抗锯齿"处理
                            3.FBFirmwareVersionObject 新增配置:
                              是否支持系统功能开关的设定和获取大数据指令（0252H / 0352H）
                              是否支持零星小睡
                              是否支持自定义表盘抗锯齿
                            4.新增尼泊尔语
                            5.新增乌克兰语
                            6.报告/记录 按时间戳由小到大排序
                            7.广播信息中设配号兼容

     project    2023-04-12  Version:3.1.3 Build:202304121900
                            1.新增"设备确认被找到"协议（FBAtCommand）fbUpDeviceConfirmedFoundDataWithBlock:
                            2.新增"获取系统功能开关信息"协议（FBBgCommand）fbGetSystemFunctionSwitchInformationWithBlock:
                            3.新增"设置系统功能开关信息"协议（FBBgCommand）fbSetSystemFunctionSwitchInformation: withBlock:
                            4.FBFirmwareVersionObject 新增配置:
                              是否支持日常心率检测开关控制
                              是否支持日常血氧检测开关控制
                              是否支持日常血压检测开关控制
                              是否支持日常精神压力检测开关控制
                            5.新增二进制数据埋点log完整解析
                            6.OTA新增错误状态 FB_OTANotification_ERROR_Busy_Sport: 设备处于运动中，请结束运动后重试...
                            7.修正"界面跳转测试"协议错误（FBAtCommand）fbUpInterfaceJumpTestCode:

     project    2023-04-03  Version:3.1.2 Build:202304031700
                            1.新增图片资源，自定义表盘，不同分辨率使用不同大小的切图

     project    2023-03-29  Version:3.1.1 Build:202303291000
                            1.优化内部压缩算法
                            2.修复"获取设备硬件信息"结构体版本错误问题
                            2.新增"获取设备绑定状态"协议（FBAtCommand）fbGetBindingStatusRequestWithBlock:
                            3.新增"获取当前运动状态"协议（FBAtCommand）fbGetCurrentExerciseStateStatusWithBlock:

     project    2023-03-24  Version:3.1.0 Build:202303241000
                            1.FB_OTANOTIFICATION 新增OTA通知类型:
                              FB_OTANotification_Multi_Dial_Built_in(200)
                              FB_OTANotification_Multi_Sport_Built_in(201)
                            2.FBCustomDataTools「多个运动类型Bin文件压缩合并成一个Bin文件」压缩算法API调整（2048或4096）
                            3.新增"获取设备运动类型列表"协议（FBBgCommand）fbGetListOfDeviceMotionTypesWithBlock:
                            4.原厂OTA SDK更新: RTKOTASDK.framework

     project    2023-03-01  Version:3.0.9 Build:202303011000
                            1.FBFirmwareVersionObject 新增配置:
                              是否支持一次性推送多种运动模式
                              支持一次性推送多种运动模式的个数，0不支持
                            2.新增一次性推送多种运动模式协议
                            3.FB_OTANOTIFICATION 新增OTA通知类型:
                              FB_OTANotification_Multi_Sport(9)
                            4.FBCustomDataTools 新增「多个运动类型Bin文件压缩合并成一个Bin文件」，配合「一次性推送多种运动模式」使用
                            5.FBBluetoothOTA 新增进度模型 FBProgressModel，兼容一个bin文件包含多个包时的升级进度问题
                            6.修正部分地区使用冬/夏令时，时区无法设置导致时间错误问题
                            7.绑定设备请求可传入Mac地址，但是强烈建议传nil，SDK内部会为你管理绑定密钥
                            8.GPS运动控制增加错误码 FB_GPS_MOTION_STATE_NONE 本地无此运动信息
                            9.优化搜索设备，使用数据模型 FBPeripheralModel
                            10.FB_MOTIONMODE 新增运动类型:
                              法国式拳击(139)

     project    2023-02-11  Version:3.0.8 Build:202302111000
                            1.绑定请求超时时长由30s延长至60s
                            2.新增获取设备log数据协议

     project    2023-02-09  Version:3.0.7 Build:202302091800
                            1.优化设备搜索性能
                            2.优化数据发送间隔
                            3.新增"确认手机被找到"协议（FBAtCommand）fbUpPhoneConfirmedFoundDataWithBlock:

     project    2023-02-02  Version:3.0.6 Build:202302021500
                            1.修正set心率异常提醒参数合法性判断

     project    2023-01-30  Version:3.0.5 Build:202301301600
                            1.修正获取血压记录协议
                            2.新增获取运动高频心率记录(1秒1次)
                            3.新增获取精神压力协议
                            4.兼容获取手动测量记录协议
                            5.FBFirmwareVersionObject 新增配置:
                              是否支持音频和通话开关设置和获取
                              是否支持心率血氧精神压力开关设置
                              是否支持血压功能
                              是否支持精神压力功能
                            6.协议方法调用合并:
                              同步系统时间 调用（FBAtCommand）fbAutomaticallySynchronizeSystemTimeWithBlock: 即可
                              同时获取运动统计报告+运动详情纪录 调用 (FBBgCommand) fbGetSportsStatisticsDetailsReportsWithStartTime: 即可
                            7.FB_RECORDTYPE 新增类型:
                              FB_HFHeartRecord
                            8.FB_MULTIPLERECORDREPORTS 新增类型:
                              FB_Sports_Statistics_Details_Report

     project    2023-01-05  Version:3.0.4 Build:202301051800
                            1.新增get、set通话音频开关协议
                            2.新增get、set多媒体音频开关协议
                            3.EM_FUNC_SWITCH 新增类型:
                              FS_CALLAUDIO_WARN(31)
                              FS_MULTIMEDIAAUDIO_WARN(32)

     project    2022-12-30  Version:3.0.3 Build:202212301600
                            1.新增 定时心率检测开关设置协议、定时血氧检测开关设置协议、定时血压检测开关设置协议、定时精神压力检测开关设置协议
                            2.EM_FUNC_SWITCH 新增类型:
                              FS_TIMING_HR_WARN(28)
                              FS_TIMING_SPO2_WARN(29)
                              FS_TIMING_STRESS_WARN(30)
                            3.FBMessageModel 新增消息推送类型:
                              missCall
                              discord
                              whitetb
                              email
                              fastrack_reflex_world
                              inshort
                              amazon
                              flipkart
                              smartworld
                            4.FB_MOTIONMODE 新增运动类型:
                              最大摄氧量测试(126)
                              放风筝(127)
                              台球(128)
                              有氧运动巡洋舰(129)
                              拔河比赛(130)
                              免费的陪练(131)
                              漂流(132)
                              旋转(133)
                              BMX(134)
                              ATV(135)
                              哑铃(136)
                              沙滩足球(137)
                              皮划艇(138)

     project    2022-12-14  Version:3.0.2 Build:202212141900
                            1.优化OTA通知问题
                            2.GPS运动控制增加 确认/取消 指令

     project    2022-11-19  Version:3.0.1 Build:202211191600
                            1.广播信息解析:适配号兼容
                            2.新增印地语、孟加拉语、乌尔都语、波斯语
                            3.新增获取精神压力记录协议、血压协议暂时不使用

     project    2022-07-15  Version:3.0.0 Build:202207151200
                            1.优化已知问题
                            2.block结果回调异常问题

     project    2022-04-14  Version:2.0.0 Build:202204140900
                            1.优化已知问题
                            2.部分AT指令数据返回类型由NSDictionary字典转换为使用对象模型，后续会有更多api支持
                            3.增加自定义表盘压缩算法协议

     project    2020-12-31  Version:1.0.0 Build:202012311800
                            1.首个发布版本
 */

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
#import <Fission_Sdk_iOS/FBFemalePhysiologyModel.h>
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
#import <Fission_Sdk_iOS/FBCustomDialModel.h>
#import <Fission_Sdk_iOS/FBMultipleCustomDialsModel.h>
#import <Fission_Sdk_iOS/FBCustomDialVideoModel.h>
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
#import <Fission_Sdk_iOS/FBSystemFunctionSwitchModel.h>
#import <Fission_Sdk_iOS/FBAGPSLocationModel.h>
#import <Fission_Sdk_iOS/FBAGPSEphemerisModel.h>
#import <Fission_Sdk_iOS/FBScheduleModel.h>
#import <Fission_Sdk_iOS/FBSystemSpaceModel.h>
#import <Fission_Sdk_iOS/FBListFileInforModel.h>
#import <Fission_Sdk_iOS/FBBaiduNaviModel.h>

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
/** 百度相关功能工具类｜Baidu related functional tools */
#import <Fission_Sdk_iOS/FBBaiduCloudKit.h>
