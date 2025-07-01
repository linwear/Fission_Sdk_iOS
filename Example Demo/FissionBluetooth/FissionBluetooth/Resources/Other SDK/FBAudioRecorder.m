//
//  FBAudioRecorder.m
//  LinWear
//
//  Created by 裂变智能 on 2024-12-18.
//  Copyright © 2024 lw. All rights reserved.
//

#import "FBAudioRecorder.h"

#define FBAudioPath [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, true).firstObject stringByAppendingPathComponent:@"FBAudioRecorder"]

@interface FBAudioRecorder () <AVAudioRecorderDelegate>
@property (nonatomic, strong) AVAudioRecorder *audioRecorder;
@property (nonatomic, copy) FBRecordingCallback recordingCallback;
@end

@implementation FBAudioRecorder

- (instancetype)initWithCallback:(FBRecordingCallback)callback {
    self = [super init];
    if (self) {
        _recordingCallback = callback;
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        BOOL isDir = NO;
        //fileExistsAtPath 判断一个文件或目录是否有效，isDirectory判断是否一个目录
        BOOL existed = [fileManager fileExistsAtPath:FBAudioPath isDirectory:&isDir];
        if (!(isDir && existed)) {
            // 在Document目录下创建一个archiver目录
            [fileManager createDirectoryAtPath:FBAudioPath withIntermediateDirectories:YES attributes:nil error:nil];
        }
    }
    return self;
}

// 检查麦克风权限
- (void)checkMicrophonePermissionWithCompletion:(void (^)(BOOL granted))completion allowFirst:(BOOL)allowFirst {
    AVAuthorizationStatus microphoneStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
    switch (microphoneStatus) {
        case AVAuthorizationStatusDenied:
        case AVAuthorizationStatusRestricted:
            [self goMicroPhoneSet];
            if (completion) completion(NO);
            break;
        case AVAuthorizationStatusNotDetermined:
            [self requestMicrophonePermissionWithCompletion:completion allowFirst:allowFirst];
            break;
        case AVAuthorizationStatusAuthorized:
            if (completion) completion(YES);
            break;
        default:
            if (completion) completion(NO);
            break;
    }
}

// 请求麦克风权限
- (void)requestMicrophonePermissionWithCompletion:(void (^)(BOOL granted))completion allowFirst:(BOOL)allowFirst {
    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeAudio completionHandler:^(BOOL granted) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (granted) {
                // allowFirst是否允许首次授权请求成功后返回YES，用于某些场景需要通过授权后即开始录音
                if (completion) completion(allowFirst);
            } else {
                [self goMicroPhoneSet];
                if (completion) completion(NO);
            }
        });
    }];
}

/// 开始录音(allowFirst是否允许首次授权请求成功后返回YES，用于某些场景需要通过授权后即开始录音)
- (void)startRecording:(void (^)(BOOL, BOOL))completion allowFirst:(BOOL)allowFirst {
    WeakSelf(self);
    [self checkMicrophonePermissionWithCompletion:^(BOOL granted)
     {
        GCD_MAIN_QUEUE(^{
            if (granted) {
                [weakSelf startRecordings:completion];
            }
            else { // 没有权限
                if (completion) completion(granted, granted);
            }
        });
    } allowFirst:allowFirst];
}

- (void)startRecordings:(void (^)(BOOL autorisieren, BOOL success))completion {
    
    [self cancelRecording];
    
    // 1. 创建一个音频会话实例
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    
    // 2. 设置音频会话的类别
    NSError *error;
    [audioSession setCategory:AVAudioSessionCategoryRecord error:&error];
    if (error) {
        NSLog(@"设置音频会话类别时出错: %@", error);
        if (self.recordingCallback) {
            self.recordingCallback(nil, error);
        }
        if (completion) completion(YES, NO);
        return;
    }
    
    // 3. 激活音频会话
    [audioSession setActive:YES error:&error];
    if (error) {
        NSLog(@"激活音频会话时出错: %@", error);
        if (self.recordingCallback) {
            self.recordingCallback(nil, error);
        }
        if (completion) completion(YES, NO);
        return;
    }
    
    // 4. 设置录音设置
    NSMutableDictionary *recordSettings = [NSMutableDictionary dictionary];
    
    // 设置采样率为16000Hz
    [recordSettings setValue:[NSNumber numberWithFloat:16000] forKey:AVSampleRateKey];
    
    // 设置通道数为1（单声道）
    [recordSettings setValue:[NSNumber numberWithInt:1] forKey:AVNumberOfChannelsKey];
    
    // 设置音频格式为线性PCM
    [recordSettings setValue:[NSNumber numberWithInt:kAudioFormatLinearPCM] forKey:AVFormatIDKey];
    
    // 设置线性PCM的比特深度
    [recordSettings setValue:[NSNumber numberWithInt:16] forKey:AVLinearPCMBitDepthKey];
    
    // 设置是否是小端字节序
    [recordSettings setValue:[NSNumber numberWithBool:NO] forKey:AVLinearPCMIsBigEndianKey];
    
    // 设置是否非对齐压缩
    [recordSettings setValue:[NSNumber numberWithBool:NO] forKey:AVLinearPCMIsNonInterleaved];
    
    // 5. 创建音频录制器
    NSString *fileName = [FBAudioPath stringByAppendingPathComponent:[NSString stringWithFormat:@"audio_%.0f", NSDate.date.timeIntervalSince1970*1000]];//fileName就是保存文件的文件名
    NSURL *audioFileURL = [NSURL URLWithString:fileName]/* 你保存录音文件的位置 */;
    NSError *recorderError = nil;
    AVAudioRecorder *audioRecorder = [[AVAudioRecorder alloc] initWithURL:audioFileURL settings:recordSettings error:&recorderError];
    
    if (recorderError) {
        NSLog(@"创建录音机时出错: %@", recorderError);
        if (self.recordingCallback) {
            self.recordingCallback(nil, recorderError);
        }
        if (completion) completion(YES, NO);
        return;
    }
    audioRecorder.delegate = self;
    
    // 6. 准备录音
    BOOL prepare = [audioRecorder prepareToRecord];
    
    // 7. 开始录音
    BOOL record = [audioRecorder record];
    
    self.audioRecorder = audioRecorder;
    
    if (completion) completion(YES, (prepare && record));
}

/// 完成录音
- (void)finishRecording {
    if (self.audioRecorder.isRecording) {
        [self.audioRecorder stop];
    }
    [self cancelRecording];
}

/// 取消录音
- (void)cancelRecording {
    [[AVAudioSession sharedInstance] setActive:NO error:nil];
    self.audioRecorder = nil;
}

/*!
 @method audioRecorderDidFinishRecording:successfully:
 @abstract This callback method is called when a recording has been finished or stopped.
 @discussion This method is NOT called if the recorder is stopped due to an interruption.
 */
- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag {
    NSData *data = nil;
    if (recorder.url) {
        data = [NSData dataWithContentsOfFile:recorder.url.path];
    }
    
    if (self.recordingCallback) {
        self.recordingCallback(data, nil);
    }
}

/*!
 @method audioRecorderEncodeErrorDidOccur:error:
 @abstract This callback method is called when an error occurs while encoding.
 @discussion If an error occurs while encoding it will be reported to the delegate.
 */
- (void)audioRecorderEncodeErrorDidOccur:(AVAudioRecorder *)recorder error:(NSError *)error {
    if (self.recordingCallback) {
        self.recordingCallback(nil, error);
    }
}


- (void)requestMicroPhoneAuth {
    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeAudio completionHandler:^(BOOL granted) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (granted) {
                // doSomething
            } else {
                [self goMicroPhoneSet];
            }
        });
    }];
}


- (void)goMicroPhoneSet {
    [UIAlertObject presentAlertTitle:LWLocalizbleString(@"Tip") message:[NSString stringWithFormat:LWLocalizbleString(@"Please allow %@ to access the microphone in \"Settings-Privacy-Microphone\" on your iPhone"), Tools.appName] cancel:LWLocalizbleString(@"Cancel") sure:LWLocalizbleString(@"Set") block:^(AlertClickType clickType) {
        
        if (clickType == AlertClickType_Sure) {
            //进入系统设置页面，APP本身的权限管理页面
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{} completionHandler:nil];
        }
    }];
}

@end

