//
//  FBCustomDialListModel.h
//  FissionBluetooth
//
//  Created by 裂变智能 on 2023-06-07.
//

#import <Foundation/Foundation.h>

@class FBCustomDialItems;
@class FBCustomDialSoures;

typedef enum {
    FBCustomDialListType_Background,    // 背景
    FBCustomDialListType_DialType,      // 刻度、指针等...
    FBCustomDialListType_Module,        // 组件
    FBCustomDialListType_Colour,        // 颜色
}FBCustomDialListType; // list 类型

typedef enum {
    FBCustomDialListItemsEvent_None,
    FBCustomDialListItemsEvent_UpdateHeight,       // 更新高度
    FBCustomDialListItemsEvent_BackgroundImage,    // 背景图
    FBCustomDialListItemsEvent_DialTypeText,       // 表盘类型（文字，数字表盘or指针表盘）
    FBCustomDialListItemsEvent_NumberImage,        // 数字时间图
    FBCustomDialListItemsEvent_PointerImage,       // 指针图
    FBCustomDialListItemsEvent_ScaleImage,         // 刻度图
    FBCustomDialListItemsEvent_StateTypeText,      // 状态类型（文字，电量or蓝牙）
    FBCustomDialListItemsEvent_StateTypeImage,     // 状态类型图（电量or蓝牙）
    FBCustomDialListItemsEvent_ModuleTypeText,     // 组件类型（文字，心率、血氧等...）
    FBCustomDialListItemsEvent_ModuleTypeImage,    // 组件类型图（文字，心率、血氧等...）
}FBCustomDialListItemsEvent; // 事件 类型


NS_ASSUME_NONNULL_BEGIN

@interface FBCustomDialListModel : NSObject

/// 类型
@property (nonatomic, assign) FBCustomDialListType listType;

@property (nonatomic, strong) NSArray <FBCustomDialItems *> *list;

@end



@interface FBCustomDialItems : NSObject

@property (nonatomic, copy, nullable) NSString *title;

@property (nonatomic, assign) FBCustomDialListItemsEvent itemEvent;

@property (nonatomic, strong) NSArray <FBCustomDialSoures *> *items;

@end



@interface FBCustomDialSoures : NSObject

@property (nonatomic, assign) FBCustomDialListItemsEvent itemEvent;

@property (nonatomic, strong) NSArray *soures;

@end

NS_ASSUME_NONNULL_END
