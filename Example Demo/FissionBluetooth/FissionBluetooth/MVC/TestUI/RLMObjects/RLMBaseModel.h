//
//  RLMBaseModel.h
//  FissionBluetooth
//
//  Created by 裂变智能 on 2023/5/11.
//

#import "RLMObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface RLMBaseModel : RLMObject

/// 设备名称
@property NSString *deviceName;

/// 设备MAC地址
@property NSString *deviceMAC;

/// 主键：时间戳 + 名称 + MAC地址
@property NSString *primaryKey_ID;

@end

NS_ASSUME_NONNULL_END
