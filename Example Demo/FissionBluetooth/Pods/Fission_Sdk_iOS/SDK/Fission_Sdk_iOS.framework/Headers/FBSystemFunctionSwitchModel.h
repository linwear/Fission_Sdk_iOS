//
//  FBSystemFunctionSwitchModel.h
//  FissionBluetooth
//
//  Created by 裂变智能 on 2023/4/11.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 系统功能开关信息｜System function switch information
*/
@interface FBSystemFunctionSwitchModel : NSObject

/**
 设置的类型｜type of setting
 
 @note 举个例子：FB_CUSTOMSETTINGSWITCHTYPE  switchType = FB_SWITCH_ALL时，表示以下全部开关会在设备端生效；FB_CUSTOMSETTINGSWITCHTYPE switchType = FB_SWITCH_HeartRate | FB_SWITCH_BloodOxygen时，表示只有【定时心率采集开关】、【定时血氧采集开关】会在设备端生效 ｜For example: when FB_CUSTOMSETTINGSWITCHTYPE switchType = FB_SWITCH_ALL, it means that all the following switches will take effect on the device side; when FB_CUSTOMSETTINGSWITCHTYPE switchType = FB_SWITCH_HeartRate | FB_SWITCH_BloodOxygen, it means that only [Scheduled Heart Rate Collection Switch] and [Scheduled Blood Oxygen Collection Switch] will take effect on the device side
*/
@property (nonatomic, assign) FB_CUSTOMSETTINGSWITCHTYPE switchType;

/**
 定时心率采集开关｜Timing heart rate acquisition switch
*/
@property (nonatomic, assign) BOOL heartRate;

/**
 定时血氧采集开关｜Timing blood oxygen collection switch
*/
@property (nonatomic, assign) BOOL bloodOxygen;

/**
 定时血压采集开关｜Timing blood pressure collection switch
*/
@property (nonatomic, assign) BOOL bloodPressure;

/**
 定时精神压力采集开关｜Timing mental pressure acquisition switch
*/
@property (nonatomic, assign) BOOL mentalPressure;

/**
 通话音频开关｜Call audio switch
*/
@property (nonatomic, assign) BOOL callAudio;

/**
 多媒体音频开关｜Multimedia Audio Switch
*/
@property (nonatomic, assign) BOOL multimediaAudio;

/**
 勿扰开关｜Do not disturb switch
*/
@property (nonatomic, assign) BOOL DND;

/**
 进入测试模式开关｜Enter test mode switch
*/
@property (nonatomic, assign) BOOL testMode;

/**
 抬腕亮屏开关｜Wrist up screen switch
*/
@property (nonatomic, assign) BOOL wristScreen;

@end

NS_ASSUME_NONNULL_END
