//
//  FBRecordScreen.m
//  FissionBluetooth
//
//  Created by 裂变智能 on 2024-01-25.
//

#import "FBRecordScreen.h"

@interface FBRecordScreen ()

/// 录屏打开block
@property (nonatomic, copy) FBRecordScreenOpenBlock openBlock;
/// 录屏失败block
@property (nonatomic, copy) FBRecordScreenFailedBlock failedBlock;
/// 录屏完成block
@property (nonatomic, copy) FBRecordScreenCompleteBlock completeBlock;

/// 视频写入相关 - AVAssetWriter
@property (nonatomic, strong) AVAssetWriter *assetWriter;
/// 视频写入相关 - AVAssetWriterInputPixelBufferAdaptor
@property (nonatomic, strong) AVAssetWriterInputPixelBufferAdaptor *assetWriterInputAdaptor;

@end

@implementation FBRecordScreen

+ (FBRecordScreen *)sharedInstance {
    static FBRecordScreen *manage = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manage = [[FBRecordScreen alloc] init];
    });
    return manage;
}

- (instancetype)init {
    if (self = [super init]) {
        // 监听是否进入后台
        [NSNotificationCenter.defaultCenter addObserver:self
                                               selector:@selector(recordingShutdown) name:UIApplicationWillResignActiveNotification
                                                 object:nil];        
    }
    return self;
}

- (void)setUsingiOS11_Methods:(BOOL)UsingiOS11_Methods {
    _UsingiOS11_Methods = UsingiOS11_Methods;
}

// 检查设备是否支持录屏、相册权限是否可用
+ (void)authorization:(void(^)(NSError * _Nullable error))handler {
    
    if (RPScreenRecorder.sharedRecorder.isAvailable) {
        // 当前设备支持录屏，检查相册权限
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus phStatus) {
            if (phStatus == PHAuthorizationStatusRestricted || phStatus == PHAuthorizationStatusDenied) {
                // 拒绝
                NSError *error = [NSError errorWithDomain:RPRecordingErrorDomain code:500 userInfo:@{NSLocalizedDescriptionKey : LWLocalizbleString(@"Please allow %@ to access the album in \"Settings-Privacy-Album\" of the iPhone")}];
                if (handler) handler(error);
            } else if (phStatus == PHAuthorizationStatusNotDetermined) {
                // 未选择，等待选择...
            } else {
                // 允许
                if (handler) handler(nil);
            }
        }];
    }
    else {
        // 当前设备不支持录屏
        NSError *error = [NSError errorWithDomain:RPRecordingErrorDomain code:500 userInfo:@{NSLocalizedDescriptionKey : LWLocalizbleString(@"The current device does not support screen recording")}];
        if (handler) handler(error);
    }
}

#pragma mark - 开启录屏
- (void)startRecordingScreenWithFailedBlock:(FBRecordScreenFailedBlock)failedBlock withOpenBlock:(FBRecordScreenOpenBlock)openBlock withCompleteBlock:(FBRecordScreenCompleteBlock)completeBlock {
    WeakSelf(self);
    
    if (RPScreenRecorder.sharedRecorder.isRecording) return; // 录制状态 拦截
    
    [FBRecordScreen authorization:^(NSError * _Nullable error) {
        if (error) {
            FBLog(@"未授权 %@", error);
            if (failedBlock) failedBlock(error);
        } else {
            weakSelf.openBlock = openBlock;
            weakSelf.failedBlock = failedBlock;
            weakSelf.completeBlock = completeBlock;
            
            [weakSelf startRecordingScreen];
        }
    }];
}
- (void)startRecordingScreen {
    WeakSelf(self);
    
    if (self.UsingiOS11_Methods) {
        if (@available(ios 11.0,*)) {
            
            [self setAssetWriterInfo]; // 初始化视频写入相关
            
            [RPScreenRecorder.sharedRecorder startCaptureWithHandler:^(CMSampleBufferRef  _Nonnull sampleBuffer, RPSampleBufferType bufferType, NSError * _Nullable error) {
                
                if (CMSampleBufferDataIsReady(sampleBuffer) && bufferType == RPSampleBufferTypeVideo) {
                    
                    CVPixelBufferRef pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
                    // 获取样本缓冲区的呈现时间戳
                    CMTime presentationTimeStamp = CMSampleBufferGetPresentationTimeStamp(sampleBuffer);
                    
                    if (weakSelf.assetWriter.status == AVAssetWriterStatusUnknown) {
                        [weakSelf.assetWriter startWriting];
                        [weakSelf.assetWriter startSessionAtSourceTime:presentationTimeStamp];
                    }
                    if (weakSelf.assetWriterInputAdaptor.assetWriterInput.readyForMoreMediaData) {
                        BOOL appendSuccessful = [weakSelf.assetWriterInputAdaptor appendPixelBuffer:pixelBuffer withPresentationTime:presentationTimeStamp];
                        if (!appendSuccessful) {
                            FBLog(@"sampleBuffer追加写入失败...");
                        }
                    }
                }
            } completionHandler:^(NSError * _Nullable error) {
                FBLog(@"开启录屏 %@", error);
                
                GCD_MAIN_QUEUE(^{
                    if (error) {
                        // 打开录屏失败
                        if (weakSelf.failedBlock) weakSelf.failedBlock(error);
                    }
                    else {
                        // 打开录屏成功
                        if (weakSelf.openBlock) weakSelf.openBlock();
                    }
                });
            }];
        }
    }
    else {
        [RPScreenRecorder.sharedRecorder startRecordingWithHandler:^(NSError * _Nullable error) {
            FBLog(@"开启录屏 %@", error);
            
            GCD_MAIN_QUEUE(^{
                if (error) {
                    // 打开录屏失败
                    if (weakSelf.failedBlock) weakSelf.failedBlock(error);
                }
                else {
                    // 打开录屏成功
                    if (weakSelf.openBlock) weakSelf.openBlock();
                }
            });
        }];
    }
}

#pragma mark - 停止录屏
- (void)stopRecordingScreen {
    
    if (!RPScreenRecorder.sharedRecorder.isRecording) return; // 非录制状态 拦截
    
    WeakSelf(self);
    if (self.UsingiOS11_Methods) {
        if (@available(ios 11.0,*)) {
            [RPScreenRecorder.sharedRecorder stopCaptureWithHandler:^(NSError * _Nullable error) {
                FBLog(@"停止录屏 %@", error);
                
                if (error) {
                    // 录屏失败
                    if (weakSelf.failedBlock) weakSelf.failedBlock(error);
                }
                else {
                    // 结束写入
                    [weakSelf.assetWriterInputAdaptor.assetWriterInput markAsFinished];
                    [weakSelf.assetWriter finishWritingWithCompletionHandler:^{
                        
                        NSURL *videoUrl = weakSelf.assetWriter.outputURL;
                        
                        [weakSelf saveVideo:videoUrl completionHandler:^(NSError * _Nullable error) {
                            GCD_MAIN_QUEUE(^{
                                if (error) {
                                    FBLog(@"视频保存失败❌%@", error);
                                    if (weakSelf.failedBlock) weakSelf.failedBlock(error);
                                } else {
                                    FBLog(@"视频已成功保存至相册✅");
                                    if (weakSelf.completeBlock) weakSelf.completeBlock(nil, videoUrl);
                                }
                            });
                        }];
                    }];
                }
            }];
        }
    }
    else {
        [RPScreenRecorder.sharedRecorder stopRecordingWithHandler:^(RPPreviewViewController * _Nullable previewViewController, NSError * _Nullable error) {
            FBLog(@"停止录屏 %@", error);
            
            GCD_MAIN_QUEUE(^{
                if (error) {
                    // 录屏失败
                    if (weakSelf.failedBlock) weakSelf.failedBlock(error);
                }
                else {
                    // 录屏完成
                    if (previewViewController) { // 成功
                        if (weakSelf.completeBlock) weakSelf.completeBlock(previewViewController, nil);
                    }
                    else { // 失败
                        NSError *error = [NSError errorWithDomain:RPRecordingErrorDomain code:500 userInfo:@{NSLocalizedDescriptionKey : LWLocalizbleString(@"Screen recording failed, unknown error")}];
                        if (weakSelf.failedBlock) weakSelf.failedBlock(error);
                    }
                }
            });
        }];
    }
}

#pragma mark - 结束录制
- (void)recordingShutdown {
    
    if (RPScreenRecorder.sharedRecorder.isRecording) { // 处于录制状态
        
        NSError *error = [NSError errorWithDomain:RPRecordingErrorDomain code:500 userInfo:@{NSLocalizedDescriptionKey : LWLocalizbleString(@"Screen recording has been terminated, please keep running in the foreground")}];
        
        if (self.UsingiOS11_Methods) {
            if (@available(ios 11.0,*)) {
                [RPScreenRecorder.sharedRecorder stopCaptureWithHandler:nil]; // 停止录制
            }
        }
        else {
            [RPScreenRecorder.sharedRecorder stopRecordingWithHandler:nil]; // 停止录制
        }
        
        WeakSelf(self);
        GCD_MAIN_QUEUE(^{
        // 录屏失败
            if (weakSelf.failedBlock) weakSelf.failedBlock(error);
        });
    }
}

- (void)setAssetWriterInfo {
    if (@available(ios 11.0,*)) {
        // 计算屏幕分辨率
        CGFloat scale = UIScreen.mainScreen.scale;
        
        // 视频将要保存的路径
        NSString *temp = NSTemporaryDirectory();
        NSString *filePath = [temp stringByAppendingPathComponent:[NSString stringWithFormat:@"sports_video_%ld.MP4", (NSInteger)NSDate.date.timeIntervalSince1970]];
        
        NSError *error = nil;
        AVAssetWriter *assetWriter = [[AVAssetWriter alloc] initWithURL:[NSURL fileURLWithPath:filePath] fileType:AVFileTypeMPEG4 error:&error];
        
        // 设置视频参数
        NSDictionary *videoSettings = @{
            AVVideoCodecKey : AVVideoCodecTypeH264,
            AVVideoWidthKey : @(SCREEN_WIDTH * scale),
            AVVideoHeightKey : @(SCREEN_HEIGHT * scale),
            AVVideoCompressionPropertiesKey : @{
                //AVVideoAverageBitRateKey : @(SCREEN_WIDTH * SCREEN_HEIGHT * scale), // 比特率
                AVVideoProfileLevelKey : AVVideoProfileLevelH264HighAutoLevel
            }
        };
        
        // 创建视频输入
        AVAssetWriterInput *videoWriterInput = [AVAssetWriterInput assetWriterInputWithMediaType:AVMediaTypeVideo outputSettings:videoSettings];
        videoWriterInput.expectsMediaDataInRealTime = YES; // 如果是实时处理或录制则设置为YES
        
        AVAssetWriterInputPixelBufferAdaptor *assetWriterInputAdaptor = [AVAssetWriterInputPixelBufferAdaptor assetWriterInputPixelBufferAdaptorWithAssetWriterInput:videoWriterInput sourcePixelBufferAttributes:nil];
        
        [assetWriter addInput:videoWriterInput];
        
        self.assetWriter = assetWriter;
        self.assetWriterInputAdaptor = assetWriterInputAdaptor;
    }
}

- (void)saveVideo:(NSURL *)videoURL completionHandler:(void(^)(NSError *__nullable error))completionHandler {
    
    // 保存视频到相册
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        // 创建一个新的请求来添加视频
        PHAssetChangeRequest *createAssetRequest = [PHAssetChangeRequest creationRequestForAssetFromVideoAtFileURL:videoURL];

        // 可选：设置视频的创建日期和位置信息
        createAssetRequest.creationDate = NSDate.date;
        // createAssetRequest.location = ...;

        // 如果需要将视频保存到特定相册
        // PHAssetCollection *album = ...; // 获取或创建相册
        // PHAssetCollectionChangeRequest *albumChangeRequest = [PHAssetCollectionChangeRequest changeRequestForAssetCollection:album];
        // [albumChangeRequest addAssets:@[[createAssetRequest placeholderForCreatedAsset]]];

    } completionHandler:^(BOOL success, NSError * _Nullable error) {
        if (error) {
            if (completionHandler) completionHandler(error);
        } else {
            if (completionHandler) completionHandler(nil);
        }
    }];
}

@end
