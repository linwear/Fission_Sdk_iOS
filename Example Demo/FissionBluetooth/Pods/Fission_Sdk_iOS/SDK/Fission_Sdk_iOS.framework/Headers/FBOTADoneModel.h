//
//  FBOTADoneModel.h
//  FissionBluetooth
//
//  Created by 裂变智能 on 2021/3/15.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 OTA完成信息｜OTA completion information
*/
@interface FBOTADoneModel : NSObject

/**
 ota类型｜OTA type
*/
@property (nonatomic, assign) FB_OTANOTIFICATION type;

/**
 bin二进制文件｜Bin binary
*/
@property (nonatomic, retain) NSData *binFile;

/**
 ota升级总时长（单位秒）｜Total OTA upgrade time (in seconds)
*/
@property (nonatomic, assign) NSInteger totalInterval;

/**
 平均速率（单位KB/s）｜Average velocity (in KB / s)
*/
@property (nonatomic) float velocity;


@end

NS_ASSUME_NONNULL_END
