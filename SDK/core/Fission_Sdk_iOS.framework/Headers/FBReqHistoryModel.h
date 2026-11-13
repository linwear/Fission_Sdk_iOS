//
//  FBReqHistoryModel.h
//  FissionBluetooth
//
//  Created by 裂变智能 on 2024-09-11.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 请求历史记录配置｜Request History Configuration
*/
@interface FBReqHistoryModel : NSObject

/**
 请求的历史记录类型｜The requested history type
*/
@property (nonatomic, assign) FB_MULTIPLERECORDREPORTS recordType;

/**
 请求开始时间，秒（时间戳）｜Request start time, seconds (timestamp)
*/
@property (nonatomic, assign) NSInteger startTime;

/**
 请求结束时间，秒（时间戳）｜Request end time, seconds (timestamp)
*/
@property (nonatomic, assign) NSInteger endTime;

@end

NS_ASSUME_NONNULL_END
