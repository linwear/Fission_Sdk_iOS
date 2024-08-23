//
//  FBRecordScreen.h
//  FissionBluetooth
//
//  Created by 裂变智能 on 2024-01-25.
//

#import <Foundation/Foundation.h>
#import <ReplayKit/ReplayKit.h>
#import <Photos/Photos.h>
#import <AVKit/AVKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^FBRecordScreenOpenBlock)(void);

typedef void(^FBRecordScreenFailedBlock)(NSError * _Nullable error);

typedef void(^FBRecordScreenCompleteBlock)(RPPreviewViewController * _Nullable previewViewController, NSURL * _Nullable videoUrl);

@interface FBRecordScreen : NSObject

/// 实例化
+ (FBRecordScreen *)sharedInstance;

/**
 此类包含2种截屏方式，改宏决定使用哪种，YES使用iOS11+的方法
 NO : 使用iOS10+方式，只能得到RPPreviewViewController，无法获得视频URL（私有的），只能弹出此控制器，用户自行选择存储视频or分享视频，操作不太友好且有时操作无法响应
 YES: 使用iOS11+方式，可以自定义sampleBuffer写入指定视频URL、存储视频or分享视频，最终获得视频URL，可根据业务自行定制
 
 2种方式的比较:
 iOS10+ 最终视频为系统内部处理，优点:视频质量高、低CPU；缺点:有局限性，无法获得原视频URL
 iOS11+ 需要自己写入视频，优点:可以定制视频质量、指定URL、存储等；缺点:写入视频过程中有点耗CPU
 */
@property (nonatomic, assign) BOOL UsingiOS11_Methods;

/**
 开启录屏
 @param failedBlock     录屏失败的回调，返回错误Error
 @param openBlock       成功打开录屏功能，收到这个回调开始则do something...
 @param completeBlock   录屏完成的回调，请注意宏UsingiOS11_Methods，iOS10+的方式则返回RPPreviewViewController，iOS11+的方式则返回NSURL，注意分别处理
 */
- (void)startRecordingScreenWithFailedBlock:(nullable FBRecordScreenFailedBlock)failedBlock
                              withOpenBlock:(nullable FBRecordScreenOpenBlock)openBlock
                          withCompleteBlock:(nullable FBRecordScreenCompleteBlock)completeBlock;;

/** 
 停止录屏
 */
- (void)stopRecordingScreen;

@end

NS_ASSUME_NONNULL_END
