//
//  FBCustomDialSelectModel.h
//  FissionBluetooth
//
//  Created by 裂变智能 on 2023-06-01.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FBCustomDialSelectModel : NSObject

/// 选择的背景图
@property (nonatomic, strong) UIImage *selectBackgroundImage;

/// 表盘类型
@property (nonatomic, assign) FBCustomDialType selectDialType;

/// 选择的数字时间
@property (nonatomic, strong) UIImage *selectTimeImage;

/// 选择的指针
@property (nonatomic, strong) UIImage *selectPointerImage;

/// 选择的刻度
@property (nonatomic, strong) UIImage *selectScaleImage;

@end

NS_ASSUME_NONNULL_END
