![Fission_Sdk_iOS-LOGO](https://github.com/linwear/Fission_Sdk_iOS/blob/main/Resources/000.png)

<p align="center">

<a href="https://github.com/linwear/Fission_Sdk_iOS.git">
    <img src="https://img.shields.io/badge/Release-3.2.6 -Green.svg">
</a>
<a href="https://github.com/linwear/Fission_Sdk_iOS.git">
    <img src="https://img.shields.io/badge/Support-iOS13.0+ -blue.svg">
</a>
<a href="https://github.com/linwear/Fission_Sdk_iOS.git">
    <img src="https://img.shields.io/badge/Support-CocoaPods -aquamarine.svg">
</a>
<a href="https://github.com/linwear/Fission_Sdk_iOS.git">
    <img src="https://img.shields.io/badge/Language-Objective_C -red.svg">
</a>
<a href="https://github.com/linwear/Fission_Sdk_iOS.git">
    <img src="https://img.shields.io/badge/Document-简体中文/English -teal.svg">
</a>
<a href="https://github.com/linwear/Fission_Sdk_iOS.git">
    <img src="https://img.shields.io/badge/Team-Fission/LinWear -purple.svg">
</a>
<a href="https://github.com/linwear/Fission_Sdk_iOS.git">
    <img src="https://img.shields.io/badge/License-MIT -gold.svg">
</a>

</p>

# 📁Fission_Sdk_iOS

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

## 🔖SDK For iOS &amp; LinWear &amp; Fission

#### 框架名称: Fission_Sdk_iOS.framework｜Framework Name: Fission_Sdk_iOS.framework

#### 框架功能: Fission 智能手表的 iOS 框架，负责与智能手表设备通信等功能的封装｜Framework Function: iOS framework for Fission smart watch, which is responsible for the communication with the watch.

#### [⚠️请仔细阅读《接入指南》，根据文档指引集成SDK；参考提供的示例demo（Example Demo），以帮助您更好地理解SDK API的使用！｜Please read the "Access Guide" carefully and integrate the SDK according to the document guidelines; refer to the provided example demo (Example Demo) to help you better understand the use of the SDK API!](#NOTE)

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

## 📃接入指南｜Access Guide

* **📝[中文文档(Chinese Document)](iOS版FissionSDK用户指南.pdf)**
* **📝[英文文档(English Document)](FissionSDK_UserGuide_for_iOS.pdf)**

### 兼容性｜Compatibility

1. iOS 13.0 及以上操作系统｜iOS 13.0 and above operating systems

2. 支持 arm64 指令集（不再支持模拟器）｜Support arm64 instruction set (simulators is no longer supported)

### 安装｜Installation

* **方式一(推荐): CocoaPods｜Method 1 (Recommend): CocoaPods**
1. 在 `Podfile` 中添加以下内容｜Add the following content in `Podfile`
```ruby
pod 'Fission_Sdk_iOS', git: 'https://github.com/linwear/Fission_Sdk_iOS.git'
```

2. 运行 `pod install` 或 `pod update`｜Run `pod install` or `pod update`

* **方式二: 手动导入｜Method 2: Manually**
1. 将 Fission_Sdk_iOS.framework、RTKOTASDK.framework、RTKLEFoundation.framework、SCompressLib.framework 文件 `Add File` 导入工程｜Import Fission_Sdk_iOS.framework、RTKOTASDK.framework、RTKLEFoundation.framework、SCompressLib.framework files `Add File` into the project

2. 集成依赖 FFmpeg｜Integrated dependency FFmpeg (reference https://github.com/arthenica/ffmpeg-kit.git)

3. 在 TARGETS - General 中修改 Fission_Sdk_iOS.framework、RTKOTASDK.framework、 RTKLEFoundation.framework、SCompressLib.framework 的嵌入方式为 `Embed&Sign`｜Modify the embedding mode of Fission_Sdk_iOS.framework、RTKOTASDK.framework、 RTKLEFoundation.framework、SCompressLib.framework in the TARGETS - General to `Embed&Sign`

4. 在 TARGETS - Build Settings - Other Linker Flags 中添加 `-ObjC`｜Add `-ObjC` in TARGETS - Build Settings - Other Linker Flags

| Add File  | Embed&Sign  |
| :----:  | :----:  |
| ![image1](https://github.com/linwear/Fission_Sdk_iOS/blob/main/Resources/007.png) | ![image1](https://github.com/linwear/Fission_Sdk_iOS/blob/main/Resources/008.png) |

### 设置蓝牙后台模式｜Set Bluetooth Background Modes
1. 在 project 的 `Background Modes` 中勾选开启 `Uses Bluetooth LE accessories`｜Check and enable `Uses Bluetooth LE accessories` in the `Background Modes` of the project

| Background Modes  |
| :----:  |
| ![image1](https://github.com/linwear/Fission_Sdk_iOS/blob/main/Resources/009.png) |

### 设置隐私权限｜Set privacy permissions
1. 在 `info plist` 文件中增加以下两个隐私权限｜Add the following two privacy permissions in the `info plist` file
```objective-c
Privacy - Bluetooth Peripheral Usage Description
```
```objective-c
Privacy - Bluetooth Always Usage Description
```

| Privacy  |
| :----:  |
| ![image1](https://github.com/linwear/Fission_Sdk_iOS/blob/main/Resources/010.png) |

### 使用｜Usage
1. 由于SDK使用Objective-C与Swift混合开发。如果你的项目没有自动生成桥接头文件（Bridging Header），请手动创建一个。这里不对Bridging Header做过多叙述。｜Because the SDK is developed using a mixture of Objective-C and Swift. If your project does not automatically generate a bridging header file (Bridging Header), please create one manually. There is not much description of Bridging Header here.

2. 将以下内容添加到您要使用的文件中｜Add the following to the file you want to use
```objective-c
#import <Fission_Sdk_iOS/Fission_Sdk_iOS.h>
```

#### 🎉🎉🎉恭喜!!!至此你已完成集成工作!!!｜Congratulations!!! At this point you have completed the integration!!!🌈🌈🌈

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

## 🚀示例演示工程 修改记录｜Example Demo Modification Record:

#### [⚠️演示项目中使用到数据库'Realm'，运行demo前，请先cd到项目，再执行pod install｜The database 'Realm' is used in the demo project. Before running the demo, please cd to the project first, and then execute pod install](#NOTE)

     project    2024-08-22
                1.支持自定义视频表盘（部分手表支持）

     project    2023-12-15
                1.运动记录增加地图运动轨迹

     project    2023-11-16
                1.优化已知问题
                
     project    2023-10-26
                1.【数据可视化UI】模块，支持切换数据源查看不同设备的历史健康数据

     project    2023-10-24
                1.【数据可视化UI】睡眠记录模块，新增睡眠静息心率
                2.【数据可视化UI】运动记录模块，新增GPS运动轨迹预览

     project    2023-06-09
                1.新增【数据可视化UI】模块，便于了解数据同步API的使用，直观查看设备历史数据
                
     project    2020-12-31
                1.首个发布版本

| Basic  | Query  | Drawer  |
| :----:  | :----:  | :----:  |
| ![image1](https://github.com/linwear/Fission_Sdk_iOS/blob/main/Resources/001.png) | ![image1](https://github.com/linwear/Fission_Sdk_iOS/blob/main/Resources/002.png) | ![image1](https://github.com/linwear/Fission_Sdk_iOS/blob/main/Resources/003.png) |

| Search  | Logger  | TestUI  |
| :----:  | :----:  | :----:  |
| ![image1](https://github.com/linwear/Fission_Sdk_iOS/blob/main/Resources/004.png) | ![image1](https://github.com/linwear/Fission_Sdk_iOS/blob/main/Resources/005.png) | ![image1](https://github.com/linwear/Fission_Sdk_iOS/blob/main/Resources/006.png) |

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

## 🚀SDK 修改记录｜SDK Modification Record:（Fission_Sdk_iOS.h）

| Public Header Files  |
| :----:  |
| ![image1](https://github.com/linwear/Fission_Sdk_iOS/blob/main/Resources/011.png) |

     project    2025-01-17  Version:3.2.6 Build:20250117001
                            1.⚠️Fission_Sdk_iOS.framework最低系统版本要求 iOS13.0及以上
                            2.FBFirmwareVersionObject 新增标志位:
                                是否支持音量增益补偿
                                是否支持JSI通道
                                NandFlashID
                                NorFlashID
                                是否支持离线语音
                            3.新增"设置音量增益补偿"协议（FBAtCommand）fbSetVolumeGainData:withBlock:
                            4.星历文件支持合成包同步
                            5.支持双精度经纬度
                            6.支持瑞昱8773 Chat/AI功能
                            7.修复视频转码失败问题
                            8.新增"GPS运动参数设定 (兼容运动定位记录数据双精度)"（FBAtCommand）fbSettingsGPSSportsParameterWithBlock:
                            9.新增兼容固件bug，该值真实反馈是否支持JSI通道（FBBaiduCloudKit.sharedInstance.allowUsingJSI）YES支持
                            10.新增是否使用新的JSI通道，该值真实反馈是否走JSI通道进行数传（FBBaiduCloudKit.sharedInstance.usingJSI）YES使用JSI通道
                            11.新增"设置设备授权码"协议（FBBgCommand）fbSetDeviceAuthCodeWithList:withBlock:
                            12.新增"获取离线语音唤醒开关状态以及授权状态"协议（FBAtCommand）fbGetOfflineVoiceAllStatusWithBlock:
                            13.新增"设置离线语音唤醒开关状态"协议（FBAtCommand）fbSetOfflineVoiceData:withBlock:
                            14.新增"设置手电筒开关状态"协议（FBAtCommand）fbSetFlashlightData:withBlock:
                            15.变更"恢复出厂设置"协议（FBAtCommand）fbUpResetDeviceDataWithShutdown::withBlock:
                            16.EM_FUNC_SWITCH 新增类型:
                                FS_OFFLINEVOICE_AUTH_NOTIFY(48)
                                FS_OFFLINEVOICE_WARN_NOTIFY(49)
                            17.修复已知自定义表盘问题
                            18.优化连接超时问题
                            19.优化数据解析

     project    2024-11-06  Version:3.2.5 Build:20241106001
                            1.新增"读取指定路径下的某个文件数据"协议（FBBgCommand）fbReadDataFileWithPaths:withBlock:
                            2.FBFirmwareVersionObject 新增标志位:
                                是否支持读取系统日志
                                是否支持星历文件合成包
                            3.修复已知的概率crash问题
                            4.其他已知问题优化

     project    2024-09-30  Version:3.2.4 Build:20240930001
                            1.新增推送消息提示铃声、来电铃声、闹钟铃声（仅部分手表支持: 支持铃声推送个数）
                            2.修改"获取列表文件信息"协议（FBBgCommand）fbGetListFileInfoWithType:withBlock:
                            3.修改"删除列表文件信息"协议（FBBgCommand）fbDeleteListFileInfoWithType:withList:withBlock:
                            4.新增"获取当前使用的铃声信息"协议（FBBgCommand）fbGetCurrentRingtoneInfoWithBlock:
                            5.新增"设置当前使用的铃声信息"协议（FBBgCommand）fbSetCurrentRingtoneInfoWithList:withBlock:
                            6."功能开关状态同步"协议支持的类型更新
                            7.其他已知问题优化
     
     project    2024-09-20  Version:3.2.3 Build:20240920001
                            1.新增推送电子书、视频、音频（仅部分手表支持: 支持多媒体空间）
                            2.新增"获取电子书列表文件信息"协议（FBBgCommand）fbGetEBookListFileInforWithBlock:
                            3.新增"获取视频列表文件信息"协议（FBBgCommand）fbGetVideoListFileInforWithBlock:
                            4.新增"获取音频列表文件信息"协议（FBBgCommand）fbGetAudioListFileInforWithBlock:
                            5.新增"删除电子书列表文件信息"协议（FBBgCommand）fbDeleteEBookListFileInfor:withBlock:
                            6.新增"删除视频列表文件信息"协议（FBBgCommand）fbDeleteVideoListFileInfor:withBlock:
                            7.新增"删除音频列表文件信息"协议（FBBgCommand）fbDeleteAudioListFileInfor:withBlock:
                            8.新增"正在同步数据，请稍后重试..."错误码FB_SYNCHRONIZING_DATA_TRY_AGAIN_LATER
                            9.修改"获取指定记录和报告"协议，支持使用不同请求时间、返回总进度（FBBgCommand）fbGetSpecialRecordsAndReportsDataWithType:withBlock:
                            10.优化数据解析性能问题

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

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
