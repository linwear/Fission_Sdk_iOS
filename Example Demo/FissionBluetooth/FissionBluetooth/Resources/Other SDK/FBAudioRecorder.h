//
//  FBAudioRecorder.h
//  LinWear
//
//  Created by 裂变智能 on 2024-12-18.
//  Copyright © 2024 lw. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^FBRecordingCallback)(NSData *_Nullable audioData, NSError *_Nullable error);

NS_ASSUME_NONNULL_BEGIN

@interface FBAudioRecorder : NSObject

/// 初始化录音器
- (instancetype)initWithCallback:(FBRecordingCallback)callback;

/// 开始录音(allowFirst是否允许首次授权请求成功后返回YES，用于某些场景需要通过授权后即开始录音)
- (void)startRecording:(void (^)(BOOL autorisieren, BOOL success))completion allowFirst:(BOOL)allowFirst;

/// 完成录音
- (void)finishRecording;

/// 取消录音
- (void)cancelRecording;

@end

NS_ASSUME_NONNULL_END
