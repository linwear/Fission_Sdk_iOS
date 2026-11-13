//
//  FBSystemSpaceModel.h
//  FissionBluetooth
//
//  Created by 裂变智能 on 2024-05-22.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 系统空间使用信息｜System space usage information
 T = A + B + C + D
*/
@interface FBSystemSpaceModel : NSObject

/**
 T: 系统总flash空间（单位Byte）｜Total system space (unit Byte)
*/
@property (nonatomic, assign) NSInteger totalSystemSpace;

/**
 A: 系统占用空间（UI资源、日常记录、系统参数、运动报告与记录等，单位Byte）｜System space occupied (UI resources, daily records, system parameters, exercise reports and records, etc., in Byte)
*/
@property (nonatomic, assign) NSInteger usedSystemSpace;

/**
 B: 表盘应用总空间（单位Byte）｜Total space of watch face application (unit Byte)
*/
@property (nonatomic, assign) NSInteger totalDialSpace;

/**
 表盘应用已使用空间（单位Byte）｜Space used by watch face application (unit: Byte)
*/
@property (nonatomic, assign) NSInteger usedDialSpace;

/**
 C: JS应用总空间（单位Byte）｜Total space of JS application (unit Byte)
*/
@property (nonatomic, assign) NSInteger totalJsAppSpace;

/**
 JS应用已使用空间（单位Byte）｜JS application used space (unit Byte)
*/
@property (nonatomic, assign) NSInteger usedJsAppSpace;

/**
 D: 多媒体总空间（单位Byte）｜Total multimedia space (unit Byte)
*/
@property (nonatomic, assign) NSInteger totalMultimediaSpace;

/**
 多媒体已使用空间（单位Byte）｜Multimedia Used Space (unit Byte)
*/
@property (nonatomic, assign) NSInteger usedMultimediaSpace;

@end

NS_ASSUME_NONNULL_END
