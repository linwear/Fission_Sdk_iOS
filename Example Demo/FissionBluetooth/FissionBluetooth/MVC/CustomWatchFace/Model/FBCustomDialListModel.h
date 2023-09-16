//
//  FBCustomDialListModel.h
//  FissionBluetooth
//
//  Created by 裂变智能 on 2023-06-07.
//

#import <Foundation/Foundation.h>

@class FBCustomDialItems;
@class FBCustomDialSoures;
@class FBCustomDialSouresSelect;

typedef enum {
    FBCustomDialListType_Background,    // 背景
    FBCustomDialListType_DialType,      // 刻度、指针等...
    FBCustomDialListType_Module,        // 组件
    FBCustomDialListType_Colour,        // 颜色
}FBCustomDialListType; // list 类型

typedef enum {
    FBCustomDialListSouresType_Image,      // 图片
    FBCustomDialListSouresType_Text,       // 文本
    FBCustomDialListSouresType_Color,      // 颜色
}FBCustomDialListSouresType; // Soures 类型

typedef enum {
    FBCustomDialListItemsEvent_None,
    FBCustomDialListItemsEvent_BackgroundImage,         // 背景图
    FBCustomDialListItemsEvent_DialTypeText,            // 表盘类型（文字：数字、指针、刻度）
    FBCustomDialListItemsEvent_NumberImage,             // 数字图
    FBCustomDialListItemsEvent_PointerImage,            // 指针图
    FBCustomDialListItemsEvent_ScaleImage,              // 刻度图
    FBCustomDialListItemsEvent_StateTypeText,           // 状态类型（文字：电量、蓝牙）
    FBCustomDialListItemsEvent_StateBatteryImage,       // 电量图
    FBCustomDialListItemsEvent_StateBluetoothImage_BLE, // BLE蓝牙图
    FBCustomDialListItemsEvent_StateBluetoothImage_BT,  // BT蓝牙图
    FBCustomDialListItemsEvent_ModuleTypeText,          // 组件类型（文字：步数、卡路里、距离、心率、血氧 等...）
    FBCustomDialListItemsEvent_ModuleStepImage,         // 步数图
    FBCustomDialListItemsEvent_ModuleCalorieImage,      // 卡路里图
    FBCustomDialListItemsEvent_ModuleDistanceImage,     // 距离图
    FBCustomDialListItemsEvent_ModuleHeartRateImage,    // 心率图
    FBCustomDialListItemsEvent_ModuleBloodOxygenImage,  // 血氧图
    FBCustomDialListItemsEvent_ModuleBloodPressureImage,// 血压图
    FBCustomDialListItemsEvent_ModuleStressImage,       // 精神压力图
    FBCustomDialListItemsEvent_Color,                   // 颜色
}FBCustomDialListItemsEvent; // 事件 类型

typedef enum {
    FBCustomDialDynamicSelection_None,
    FBCustomDialDynamicSelection_AddSuccess, // + 成功
    FBCustomDialDynamicSelection_AddFailure, // + 失败
    FBCustomDialDynamicSelection_CutSuccess, // - 成功
    FBCustomDialDynamicSelection_CutFailure, // - 失败
    
    FBCustomDialDynamicSelection_Reset,      // 初始化、重置
}FBCustomDialDynamicSelection; // 动态选择 类型

NS_ASSUME_NONNULL_BEGIN

@interface FBCustomDialListModel : NSObject

/// 类型
@property (nonatomic, assign) FBCustomDialListType listType;

@property (nonatomic, strong) NSArray <FBCustomDialItems *> *list; // 多少组

@end



@interface FBCustomDialItems : NSObject

@property (nonatomic, copy, nullable) NSString *title; // 组名

@property (nonatomic, assign) FBCustomDialListSouresType souresType; // 该组 数据源类型

@property (nonatomic, strong) NSArray <NSArray <FBCustomDialSoures *> *> *items; // 可选 嵌套 <组1、组2、组3...>

@end



@interface FBCustomDialSoures : NSObject

@property (nonatomic, assign) BOOL allowRepeatSelection; // 是否支持复选（点击选中 and 点击取消）

@property (nonatomic, assign) FBCustomDialListItemsEvent itemEvent; // 类型

@property (nonatomic, strong, nullable) UIImage *image;

@property (nonatomic, copy, nullable) NSString *title;
@property (nonatomic, assign) BOOL isTitleSelect; // 当子集有被选择时，标题处显示圆点

@property (nonatomic, strong, nullable) UIColor *color;

@property (nonatomic, assign) BOOL isSelect; // 当前是否被选中

@property (nonatomic, assign) NSInteger index; // 对应索引

@end

NS_ASSUME_NONNULL_END
