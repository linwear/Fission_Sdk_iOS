//
//  FBOfflineVoiceInfoModel.h
//  FissionBluetooth
//
//  Created by LINWEAR on 2025-02-22.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 离线语音信息｜Offline voice information
*/
@interface FBOfflineVoiceInfoModel : NSObject

/**
 开关状态｜Switch Status
*/
@property (nonatomic, assign) BOOL switchStatus;

/**
 授权状态｜Authorization Status
*/
@property (nonatomic, assign) BOOL authStatus;

/**
 语种｜Language
*/
@property (nonatomic, copy) NSString *language;

/**
 版本号｜Version Number
*/
@property (nonatomic, copy) NSString *version;

/**
 唤醒词｜Wake word
*/
@property (nonatomic, copy) NSString *wakeWord;

@end

NS_ASSUME_NONNULL_END
